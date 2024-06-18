const { Product, Category } = require("../models");
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
  const { name, qty, categoryId } = req.body;
  let imageUrl =
    "https://res.cloudinary.com/djgrhxns8/image/upload/v1718207307/uploads/v5s0fo7ptl0o2zwwrbqb.png"; // Default image
  if (req.file && req.file.path) {
    imageUrl = req.file.path; // URL from Cloudinary
  }
  try {
    const category = await Category.findByPk(req.body.categoryId);
    if (!category) {
      return res.status(404).json({
        error: "category not found",
      });
    }
    const product = await Product.create({
      name,
      qty,
      url: imageUrl,
      categoryId,
      createdBy: req.user.username,
      updatedBy: req.user.username,
    });
    res.status(201).json(product);
  } catch (error) {
    res.status(500).json({
      message: error.message,
    });
  }
};

const updateProduct = async (req, res) => {
  const { name, qty, categoryId } = req.body;
  const productId = req.params.id;

  try {
    const product = await Product.findByPk(productId);
    if (!product) {
      return res.status(404).json({
        error: "Product not found",
      });
    }

    const category = await Category.findByPk(parseInt(categoryId, 10));
    if (!category) {
      return res.status(404).json({
        error: "Category not found",
      });
    }

    let imageUrl = product.url; // Existing image URL
    if (req.file && req.file.path) {
      imageUrl = req.file.path; // New URL from Cloudinary
    }

    product.name = name || product.name;
    product.qty = qty || product.qty;
    product.url = imageUrl;
    product.categoryId = parseInt(categoryId, 10);
    product.updatedBy = req.user.username;

    await product.save();

    res.status(200).json(product);
  } catch (error) {
    console.error("Error updating product: ", error);
    res.status(500).json({
      error: "Failed to update product",
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
