const { Category, Product } = require("../models");

const getAllCategories = async (req, res) => {
  try {
    const username = req.user.username;
    const categories = await Category.findAll({
      where: { createdBy: username },
      include: [
        {
          model: Product,
          as: "products",
          where: { createdBy: username },
          required: false,
        },
      ],
    });
    res.json(categories);
  } catch (error) {
    res.status(500).json({
      error: "Failed to get categories",
    });
  }
};

const getCategoryById = async (req, res) => {
  const id = +req.params.id;
  try {
    const username = req.user.username;
    const category = await Category.findOne({
      where: {
        id: id,
        createdBy: username,
      },
      include: [
        {
          model: Product,
          as: "products",
          where: { createdBy: username },
          required: false,
        },
      ],
    });
    if (!category) {
      return res.status(404).json({
        error: "Category not found or you do not have access to this category",
      });
    }
    res.json(category);
  } catch (error) {
    res.status(500).json({
      error: "Failed to get category",
    });
  }
};

const createCategory = async (req, res) => {
  const { name } = req.body;
  try {
    const category = await Category.create({
      name,
      createdBy: req.user.username,
    });
    res.status(201).json(category);
  } catch (error) {
    res.status(500).json({
      error: "Failed to create category",
    });
  }
};

const updateCategory = async (req, res) => {
  const id = +req.params.id;
  const { name } = req.body;
  try {
    const username = req.user.username;
    const category = await Category.findOne({
      where: {
        id: id,
        createdBy: username,
      },
    });
    if (!category) {
      return res.status(404).json({
        error: "Category not found or you do not have access to this category",
      });
    }
    await category.update({ name });
    res.json(category);
  } catch (error) {
    res.status(500).json({
      error: "Failed to update category",
    });
  }
};

const deleteCategory = async (req, res) => {
  const id = +req.params.id;
  try {
    const username = req.user.username;
    const category = await Category.findOne({
      where: {
        id: id,
        createdBy: username,
      },
    });
    if (!category) {
      return res.status(404).json({
        error: "Category not found or you do not have access to this category",
      });
    }
    await category.destroy();
    res.json({ message: "Category deleted" });
  } catch (error) {
    res.status(500).json({
      error: "Failed to delete category",
    });
  }
};

module.exports = {
  getAllCategories,
  getCategoryById,
  createCategory,
  updateCategory,
  deleteCategory,
};
