const express = require("express");
const bodyParser = require("body-parser");
const app = express();
const port = 3001;

require("dotenv").config();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

const routes = require("./routes");
app.use(routes);

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});
