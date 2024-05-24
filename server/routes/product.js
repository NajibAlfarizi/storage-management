const productRoutes = require("express").Router();
const productController = require("../controllers/productController");
const upload = require("../middleware/upload");
const authMiddleware = require("../middleware/auth");

productRoutes.get("/", authMiddleware, productController.getAllProducts);

productRoutes.get("/:id", authMiddleware, productController.getProductById);

productRoutes.post(
  "/",
  authMiddleware,
  upload.uploadProduct,
  productController.createProduct
);

productRoutes.put(
  "/:id",
  authMiddleware,
  upload.uploadProduct,
  productController.updateProduct
);

productRoutes.delete("/:id", authMiddleware, productController.deleteProduct);

module.exports = productRoutes;
