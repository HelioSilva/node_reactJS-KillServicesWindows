import React, {useState,useEffect} from 'react'
import axios from '../../services/api'
import {Container,Quadro,ItemQuadro} from './style'

function App() {

  const [data,setData] = useState([]);


  async function alterarStatus(cnpj,newStatus){
    const response = await axios.get('/status/'+cnpj+'/'+newStatus);
    loadClientes();
    return null ;
  }

  async function loadClientes(){
    console.log('Consultando api...');
    const response = await axios.get('/clientes') ; 
    setData(response.data);
    console.log(response.data);
  }


  useEffect(()=>{   

    loadClientes();

  },[data]);

  return (
    <Container>
  
      <Quadro>

            {
                data.map(cli => (
                <ItemQuadro key={cli._id}>
                    <div className="topoItem">
                            <strong>{cli.razao}</strong>
                    </div>
                    <div className="corpoItem">
                            <span>CNPJ: {cli.cnpj}</span>
                            <span>Tel: {cli.telefone}</span>
                    </div>
                    <div className="rodapeItem">
                            <button>Editar</button>
                            <button onClick={()=>{alterarStatus(cli.cnpj,!cli.ativo)}} className={(cli.ativo) ? "aprovado" : "bloqueado"} >{(cli.ativo) ? "APROVADO" : "BLOQUEADO"}</button>
                          
                    </div>
                </ItemQuadro> ))
            }

      </Quadro>
 
    </Container>
  );
}

export default App;
