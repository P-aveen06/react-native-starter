import React from 'react'
import { StyleSheet, Text, View } from 'react-native'

function ProfileScreen({navigation,route}:any) {
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