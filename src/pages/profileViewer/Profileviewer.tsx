import React from 'react'
import { NativeModules, StyleSheet, Text, View } from 'react-native'

function ProfileScreen({navigation,route}:any) {
  const {OneviewAuth}=NativeModules
  console.log(OneviewAuth)
  return (
    <View style={styles.greetingContainer}>
        <Text style={styles.greeting}>Hello, {route.params.name}</Text>
    </View>
  )
}
const styles=StyleSheet.create({
    greetingContainer:{
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center'
  },
  greeting:{
    fontSize:20
  }
})

export default ProfileScreen