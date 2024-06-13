// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "starter", // Change this to the actual name of your package
    platforms: [
            .iOS(.v12) // Specify the minimum iOS version you support
        ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "starter",
            targets: ["starter"]),
    ],
    dependencies: [
        .package(url: "https://github.com/AzureAD/microsoft-authentication-library-for-objc.git", branch:"main"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "starter",
            dependencies: [
                .product(name: "MSAL", package: "microsoft-authentication-library-for-objc")
            ]),
        .testTarget(
            name: "staeterTests",
            dependencies: ["starter"]),
    ]
)
