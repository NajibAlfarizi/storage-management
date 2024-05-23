const routes = require("express").Router();
const productRoutes = require("./product");

routes.get("/", (req, res) => {
  res.json({ message: "Welcome to Fruit Store!" });
});

routes.use("/product", productRoutes);

module.exports = routes;
