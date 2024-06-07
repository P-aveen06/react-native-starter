import React from 'react';
import Home from './src/pages/home/Home';
import {
  QueryClient,
  QueryClientProvider,
} from '@tanstack/react-query'
import {NavigationContainer} from '@react-navigation/native';
import { MyStack } from './src/layout';

// Create a client
const queryClient = new QueryClient()

const App = () => {
  
  return (
    <QueryClientProvider client={queryClient}>
      <MyStack/>
    </QueryClientProvider>
  );
};



export default App;
