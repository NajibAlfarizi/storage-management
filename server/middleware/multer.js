// middleware/multer.js
const multer = require("multer");
const { productStorage, userStorage } = require("../config/cloudinary");

const uploadProductImage = multer({ storage: productStorage });
const uploadUserImage = multer({ storage: userStorage });

module.exports = {
  uploadProductImage,
  uploadUserImage,
};
