// config/cloudinary.js
const cloudinary = require("cloudinary").v2;
const multer = require("multer");
const { CloudinaryStorage } = require("multer-storage-cloudinary");

cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET,
});

const productStorage = new CloudinaryStorage({
  cloudinary: cloudinary,
  params: {
    folder: "uploads/products", // Folder untuk produk
    allowed_formats: ["jpg", "jpeg", "png"],
  },
});

const userStorage = new CloudinaryStorage({
  cloudinary: cloudinary,
  params: {
    folder: "uploads/users", // Folder untuk pengguna
    allowed_formats: ["jpg", "jpeg", "png"],
  },
});

module.exports = {
  cloudinary,
  productStorage,
  userStorage,
};
