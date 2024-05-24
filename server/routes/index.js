const routes = require("express").Router();
const categoryRoutes = require("./category");
const productRoutes = require("./product");
const userRoutes = require("./user");

routes.get("/", (req, res) => {
  res.json({ message: "Welcome to Fruit Store!" });
});

routes.use("/product", productRoutes);
routes.use("/category", categoryRoutes);
routes.use("/user", userRoutes);

module.exports = routes;
