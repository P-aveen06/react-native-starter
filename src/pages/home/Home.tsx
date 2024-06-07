import { useQuery } from '@tanstack/react-query';
import React, { useState } from 'react';
import { View, Text, StyleSheet, Image, TextInput, Button } from 'react-native';
import getPost from '../../service/getpost.service';


function HomeScreen({navigation}:any){
    const [inputValue,setInputValue]= useState<string>("")

    // Queries
    // const query = useQuery({ queryKey: ['post'], queryFn: getPost,enabled: enablePost})
  
    return(
        <View style={styles.container}>
        <Text style={styles.text}>Hello, welcome home kindly fill your profile details</Text>
        <Image style={styles.image} source={{ uri: 'https://reactnative.dev/img/tiny_logo.png' }}/>
        <Text style={styles.nameBox}>Name :</Text>
        <TextInput style={styles.inputBox} placeholder='May have your name' value={inputValue} onChangeText={value=>setInputValue(value)}/>
        {/* {query.data&&<Text style={styles.title}>{query.data.title}</Text>} */}
        <Button
            title="Go to profile"
            onPress={() =>navigation.navigate('Profile', {name: inputValue})}
    />
        </View>
    )
}

const styles = StyleSheet.create({
    container: {
      flex: 1,
      justifyContent: 'center',
      alignItems: 'center',
    },
    text: {
      fontSize: 20,
      width:250,
      textAlign:'center'
    },
    image:{
      width:32,
      height:32
    },
    inputBox:{
      width:180,
      height: 40,
      marginVertical:10,
      borderColor: 'gray',
      borderWidth: 1,
      paddingLeft: 8,
    },
    title:{
      margin:20,
      fontSize:16,
      textAlign:'center'
    },
    nameBox:{
        paddingVertical:5,
        width:180,
        textAlign:'left'
    }
  });

export default HomeScreen;
