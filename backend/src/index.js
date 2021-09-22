const express = require("express");
const router = require("./routes");
//const mongoose = require('mongoose');
const cors = require("cors");

var app = express();
//mongoose.connect('mongodb://heliosilva.online:27017/servicekill', {useNewUrlParser: true,useUnifiedTopology: true });

app.use(cors());
app.use(express.json());
app.use(router);

app.listen(7000, () => {
  console.log(`Server started on port 7000!`);
});
