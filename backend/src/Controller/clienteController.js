const Cliente = require('../Model/Cliente');




module.exports = {



    async store(req,res){

        let {cnpj,razao,ativo} = req.body ;
        let cliente;

        if(cnpj!=null || razao!=null || ativo!=null){
            cliente = await Cliente.findOne({cnpj}) ;
            if(cliente==null){
                cliente = await Cliente.create(req.body);
            }  
        }        

        return res.json(cliente);

    },

    async getStatus(req,res){

        let {cnpj} = req.params;
        
        let result = await Cliente.findOne({
           cnpj 
        })

        if(result!=null){
            let {ativo} = result;
            return res.json({ativo});
        }else{
            return res.json({ativo:false})
        }

    },

    async setStatus(req,res){
        let {cnpj,ativo} = req.params;
        ativo = ativo=="true" ? true : false ;

        let result = await Cliente.updateOne({cnpj},{
           ativo
        })

        return res.json(result);


    }




}