var Service = require('node-windows').Service;

 var svc = new Service({
 name:'ClientKillService',
 description: 'Serviço que controla o serviço do firebird',
 script: 'E://_ProjetosWEB//_sistemaKillServices//frontend//server.js'
 });

svc.on('install',function(){
        svc.start();
});

svc.on('start',()=>{
    console.log('Iniciou!!!!')
});

svc.install();

