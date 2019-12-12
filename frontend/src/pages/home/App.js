import React, {useState,useEffect} from 'react'
import axios from '../../services/api'
import {Container,Quadro,ItemQuadro,Aside,Content,Header} from './style'

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
      <Aside>
        <h5>Menu</h5>
      </Aside>
      <Content>
        <Header>Aqui ficará a pesquisa</Header>
        <Quadro>

            {
                data.map(cli => (
                  <ItemQuadro key={cli._id}>
                      <div>
                        <h4>Telefone: (082) 32218567</h4>
                        <h4>CNPJ: {cli.cnpj}</h4>
                      </div>
                      
                      <h2>{cli.razao}</h2> 

                      <p>Última comunicação: 11/12/2019</p>                
                    
                      <div className="rodapeItem">
                              <button>Editar</button>
                              <button onClick={()=>{alterarStatus(cli.cnpj,!cli.ativo)}} className={(cli.ativo) ? "aprovado" : "bloqueado"} >{(cli.ativo) ? "APROVADO" : "BLOQUEADO"}</button>
                            
                      </div>
                  </ItemQuadro> 
                ))
            }

      </Quadro>

      </Content>
  
      
 
    </Container>
  );
}

export default App;
