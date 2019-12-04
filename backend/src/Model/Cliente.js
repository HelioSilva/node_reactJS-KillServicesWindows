const mongoose = require('mongoose');


const clienteSchema = new mongoose.Schema({
  cnpj:  String,
  razao: String,
  ativo: Boolean,
},{timestamps:{
    createdAt : 'created_At',
    updatedAt :'updated_At'
}});

module.exports = mongoose.model('Cliente',clienteSchema);