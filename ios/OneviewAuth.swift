import Foundation
import MSAL

@objc(OneviewAuth)
class OneviewAuth: NSObject {
    
    private let kClientID = "7ee6f103-1c81-46af-819e-50768a02fdd7"
    private let kAuthority = "https://login.microsoftonline.com/78c58f88-8385-43c2-b475-a57dcfbbc09f"
    private let kRedirectUri = "msauth.com.Azure-auth-ios://auth"
    private let kScopes: [String] = ["user.read"]
    
    private var applicationContext: MSALPublicClientApplication?
    private var webViewParameters: MSALWebviewParameters?
    private var currentAccount: MSALAccount?

    override init() {
        super.init()
        do {
            try self.initMSAL()
        } catch let error {
            print("Unable to create Application Context \(error)")
        }
    }
    
    private func initMSAL() throws {
        guard let authorityURL = URL(string: kAuthority) else {
            print("Unable to create authority URL")
            return
        }
        
        let authority = try MSALAADAuthority(url: authorityURL)
        
        let msalConfiguration = MSALPublicClientApplicationConfig(clientId: kClientID,
                                                                  redirectUri: kRedirectUri,
                                                                  authority: authority)
        self.applicationContext = try MSALPublicClientApplication(configuration: msalConfiguration)
    }
    
    @objc
    func getAccessToken(_ resolver: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock) {
        self.loadCurrentAccount { (account) in
            guard let currentAccount = account else {
                self.acquireTokenInteractively(resolver: resolver, rejecter: rejecter)
                return
            }
            self.acquireTokenSilently(currentAccount, resolver: resolver, rejecter: rejecter)
        }
    }
    
    private func acquireTokenInteractively(resolver: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock) {
        guard let applicationContext = self.applicationContext else {
            rejecter("MSAL_NOT_INITIALIZED", "MSAL not initialized", nil)
            return
        }
        
        let parameters = MSALInteractiveTokenParameters(scopes: kScopes, webviewParameters: MSALWebviewParameters(parentViewController: UIApplication.shared.keyWindow!.rootViewController!))
        parameters.promptType = .selectAccount

        applicationContext.acquireToken(with: parameters) { (result, error) in
            if let error = error {
                rejecter("ACQUIRE_TOKEN_ERROR", "Could not acquire token: \(error.localizedDescription)", error)
                return
            }
            guard let result = result else {
                rejecter("NO_RESULT", "Could not acquire token: No result returned", nil)
                return
            }
            resolver(result.accessToken)
        }
    }
    
    private func acquireTokenSilently(_ account: MSALAccount, resolver: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock) {
        guard let applicationContext = self.applicationContext else {
            rejecter("MSAL_NOT_INITIALIZED", "MSAL not initialized", nil)
            return
        }
        
        let parameters = MSALSilentTokenParameters(scopes: kScopes, account: account)
        
        applicationContext.acquireTokenSilent(with: parameters) { (result, error) in
            if let error = error {
                let nsError = error as NSError
                if nsError.domain == MSALErrorDomain,
                   nsError.code == MSALError.interactionRequired.rawValue {
                    DispatchQueue.main.async {
                        self.acquireTokenInteractively(resolver: resolver, rejecter: rejecter)
                    }
                    return
                }
                rejecter("ACQUIRE_TOKEN_SILENT_ERROR", "Could not acquire token silently: \(error.localizedDescription)", error)
                return
            }
            guard let result = result else {
                rejecter("NO_RESULT", "Could not acquire token: No result returned", nil)
                return
            }
            resolver(result.accessToken)
        }
    }
    
    private func loadCurrentAccount(completion: @escaping (MSALAccount?) -> Void) {
        guard let applicationContext = self.applicationContext else {
            completion(nil)
            return
        }
        
        let msalParameters = MSALParameters()
        msalParameters.completionBlockQueue = DispatchQueue.main

        applicationContext.getCurrentAccount(with: msalParameters) { (currentAccount, _, error) in
            if let error = error {
                print("Couldn't query current account with error: \(error)")
                completion(nil)
                return
            }
            self.currentAccount = currentAccount
            completion(currentAccount)
        }
    }
}
