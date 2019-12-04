const axios = require('axios');
const sc = require('windows-service-controller');

const { exec } = require('child_process');

const api = axios.create({
    baseURL: 'http://3.90.37.26:7000/' ,
    timeout: 3000,
    headers: {'Content-Type': 'application/json'}
});

async function stopFirebird(){

    exec('net stop FirebirdGuardianDefaultInstance', (error, stdout, stderr) => {
        if (error) {
          console.error(`exec error: ${error}`);
          return;
        }
        console.log(`stdout: ${stdout}`);
        console.error(`stderr: ${stderr}`);
    })

}

async function startFirebird(){
    exec('net start FirebirdGuardianDefaultInstance', (error, stdout, stderr) => {
        if (error) {
          console.error(`exec error: ${error}`);
          return;
        }
        console.log(`stdout: ${stdout}`);
        console.error(`stderr: ${stderr}`);
    })
}

setInterval(async()=>{

    



   await api.get('/consulta/00657034000153').then((r)=>{
        const resposta = r.data ;
        if(resposta!=null){        
            if(resposta.ativo==true){
                startFirebird();
                console.log("Cliente com status ativo!!!")
            }else{
                stopFirebird();
                console.log("Firebird sendo parado!!!!!");
            }
        }

   }).catch(()=>{
       console.log("catch...");
   })   

},30000);