const { Product } = require("../models");
const getAllProducts = async (req, res) => {
  try {
    const product = await Product.findAll();
    res.json(product);
  } catch (error) {
    res.status(500).json({
      error: "failed to get products",
    });
  }
};

const getProductById = async (req, res) => {
  const id = +req.params.id;
  try {
    const product = await Product.findByPk(id);
    if (!product) {
      return res.status(404).json({
        error: "product not found",
      });
    }
    res.json(product);
  } catch (error) {
    res.status(500).json({
      error: "failed to get product",
    });
  }
};

const createProduct = async (req, res) => {
  const { name, qty, createdBy, updatedBy } = req.body;
  const url = req.file
    ? `/uploads/products/${req.file.filename}`
    : "/uploads/products/default.png";
  try {
    const product = await Product.create({
      name,
      qty,
      url,
      createdBy,
      updatedBy,
    });
    res.status(201).json(product);
  } catch (error) {
    res.status(500).json({
      error: "failed to create product",
    });
  }
};

const updateProduct = async (req, res) => {
  const id = +req.params.id;
  const { name, qty, updatedBy } = req.body;
  const url = req.file ? `/uploads/products/${req.file.filename}` : null;
  try {
    const product = await Product.findByPk(id);
    if (!product) {
      return res.status(404).json({
        error: "product not found",
      });
    }
    const updateData = { name, qty, updatedBy };
    if (url) {
      updateData.url = url;
    }
    await product.update(updateData);
    res.json(product);
  } catch (error) {
    res.status(500).json({
      error: "failed to update product",
    });
  }
};

const deleteProduct = async (req, res) => {
  const id = +req.params.id;
  try {
    const product = await Product.findByPk(id);
    if (!product) {
      return res.status(404).json({
        error: "product not found",
      });
    }
    await product.destroy();
    res.json(product);
  } catch (error) {
    res.status(500).json({
      error: "failed to delete product",
    });
  }
};

module.exports = {
  getAllProducts,
  getProductById,
  createProduct,
  updateProduct,
  deleteProduct,
};
