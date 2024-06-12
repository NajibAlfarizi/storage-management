const productRoutes = require("express").Router();
const productController = require("../controllers/productController");
const { uploadProductImage } = require("../middleware/multer");
const authMiddleware = require("../middleware/auth");

productRoutes.get("/", authMiddleware, productController.getAllProducts);

productRoutes.get("/:id", authMiddleware, productController.getProductById);

productRoutes.post(
  "/",
  authMiddleware,
  uploadProductImage.single("url"),
  productController.createProduct
);

productRoutes.put(
  "/:id",
  authMiddleware,
  uploadProductImage.single("url"),
  productController.updateProduct
);

productRoutes.delete("/:id", authMiddleware, productController.deleteProduct);

module.exports = productRoutes;
