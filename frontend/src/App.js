import React from 'react';
import axios from './services/api';

async function requisicao(){
  const resp = await axios.get('/consulta/00657034000153');
  console.log(resp);
  return resp
}

function  App() {

  requisicao();
  

  return (
    <div className="App">
      <header className="App-header">
        <p>
          Helio da Silva Filho
        </p>
        <a
          className="App-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn React
        </a>
      </header>
    </div>
  );
}

export default App;
