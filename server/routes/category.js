const categoryRoutes = require("express").Router();
const categoryController = require("../controllers/categoryController");
const authMiddleware = require("../middleware/auth");

categoryRoutes.get("/", authMiddleware, categoryController.getAllCategories);
categoryRoutes.get("/:id", authMiddleware, categoryController.getCategoryById);
categoryRoutes.post("/", authMiddleware, categoryController.createCategory);
categoryRoutes.put("/:id", authMiddleware, categoryController.updateCategory);
categoryRoutes.delete(
  "/:id",
  authMiddleware,
  categoryController.deleteCategory
);

module.exports = categoryRoutes;
