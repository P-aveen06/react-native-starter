import axios from "axios";


export default async function getPost(){
    const result = await axios.get('https://jsonplaceholder.typicode.com/posts/1')
    return result.data;
}