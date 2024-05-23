const categoryRoutes = require("express").Router();
const categoryController = require("../controllers/categoryController");

categoryRoutes.get("/", categoryController.getAllCategories);
categoryRoutes.get("/:id", categoryController.getCategoryById);
categoryRoutes.post("/", categoryController.createCategory);
categoryRoutes.put("/:id", categoryController.updateCategory);
categoryRoutes.delete("/:id", categoryController.deleteCategory);

module.exports = categoryRoutes;
