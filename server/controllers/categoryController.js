const { Model } = require("sequelize");
const { Category, Product } = require("../models");

const getAllCategories = async (req, res) => {
  try {
    const categories = await Category.findAll({
      include: [
        {
          model: Product,
          as: "products",
        },
      ],
    });
    res.json(categories);
  } catch (error) {
    res.status(500).json({
      error: "failed to get categories",
    });
  }
};

const getCategoryById = async (req, res) => {
  const id = +req.params.id;
  try {
    const category = await Category.findByPk(id, {
      include: [
        {
          model: Product,
          as: "products",
        },
      ],
    });
    if (!category) {
      return res.status(404).json({
        error: "category not found",
      });
    }
    res.json(category);
  } catch (error) {
    res.status(500).json({
      error: "failed to get category",
    });
  }
};

const createCategory = async (req, res) => {
  const { name } = req.body;
  try {
    const category = await Category.create({
      name,
    });
    res.status(201).json(category);
  } catch (error) {
    res.status(500).json({
      error: "failed to create category",
    });
  }
};

const updateCategory = async (req, res) => {
  const id = +req.params.id;
  const { name } = req.body;
  try {
    const category = await Category.findByPk(id);
    if (!category) {
      return res.status(404).json({
        error: "category not found",
      });
    }
    await category.update({ name });
    res.json(category);
  } catch (error) {
    res.status(500).json({
      error: "failed to update category",
    });
  }
};

const deleteCategory = async (req, res) => {
  const id = +req.params.id;
  try {
    const category = await Category.findByPk(id);
    if (!category) {
      return res.status(404).json({
        error: "category not found",
      });
    }
    await category.destroy();
    res.json({ message: "category deleted" });
  } catch (error) {
    res.status(500).json({
      error: "failed to delete category",
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
