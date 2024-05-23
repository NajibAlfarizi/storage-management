const routes = require("express").Router();
const categoryRoutes = require("./category");
const productRoutes = require("./product");

routes.get("/", (req, res) => {
  res.json({ message: "Welcome to Fruit Store!" });
});

routes.use("/product", productRoutes);
routes.use("/category", categoryRoutes);

module.exports = routes;
