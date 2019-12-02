var express = require('express');
var router = express.Router();

const ckeckStatus = '/statusService';

function response(req,type,id,cod,msg){
    return( {
        links:{
            self: req
        },
        data:{
            type: type,
            id,
            detalhes:{
                codigo: cod,
                mensagem:msg
            }
        }
    })

}

//======================== x Rotas do Sistema x ============================//

router.get(ckeckStatus+'/:cnpj',(req,res)=>{
    let {cnpj} = req.params ;

    console.log(req);

    try {
        res.json( response( req.headers.host+req.originalUrl, 
                            'STATUS' ,
                            999,
                            100,
                            'Tudo certo!!!!') );
    } catch (e) {
        res.json( response(req.headers.host+req.originalUrl,'STATUS',0,400,'Error!'))        
    }
})

module.exports = router ;