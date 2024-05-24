const productRoutes = require("express").Router();
const productController = require("../controllers/productController");
const upload = require("../middleware/upload");

productRoutes.get("/", productController.getAllProducts);

productRoutes.get("/:id", productController.getProductById);

productRoutes.post("/", upload.uploadProduct, productController.createProduct);

productRoutes.put(
  "/:id",
  upload.uploadProduct,
  productController.updateProduct
);

productRoutes.delete("/:id", productController.deleteProduct);

module.exports = productRoutes;
