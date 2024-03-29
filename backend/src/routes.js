var express = require("express");
var router = express.Router();

//Controllers
const controlCliente = require("./Controller/clienteController");

//String de Rotas
const ckeckStatus = "/statusService";

function response(req, type, id, cod, msg) {
  return {
    links: {
      self: req,
    },
    data: {
      type: type,
      id,
      detalhes: {
        codigo: cod,
        mensagem: msg,
      },
    },
  };
}

//======================== x Rotas do Sistema x ============================//

router.get(ckeckStatus + "/:cnpj", (req, res) => {
  let { cnpj } = req.params;

  try {
    res.json(
      response(
        req.headers.host + req.originalUrl,
        "STATU",
        999,
        100,
        "Tudo certo!!!!"
      )
    );
  } catch (e) {
    res.json(
      response(req.headers.host + req.originalUrl, "STATUS", 0, 400, "Error!")
    );
  }
});

router.post("/insert", controlCliente.store);
router.post("/consulta/:cnpj", controlCliente.getStatus);
router.get("/status/:cnpj/:ativo", controlCliente.setStatus);
router.get("/clientes", controlCliente.index);

module.exports = router;
