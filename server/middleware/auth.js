// authMiddleware.js

const jwt = require("jsonwebtoken");
const secret = process.env.JWT_SECRET;
const { User } = require("../models");

const authMiddleware = async (req, res, next) => {
  // Ambil token dari header permintaan
  const token = req.header("Authorization");

  // Periksa apakah token tidak disertakan
  if (!token) {
    return res
      .status(401)
      .json({ error: "No token provided, authorization denied" });
  }

  try {
    // Periksa format token dan ambil token yang sesuai
    const tokenParts = token.split(" ");
    if (tokenParts.length !== 2 || tokenParts[0] !== "Bearer") {
      return res.status(401).json({ error: "Invalid token format" });
    }
    const userToken = tokenParts[1];

    // Verifikasi token
    const decoded = jwt.verify(userToken, secret);

    // Periksa apakah decoded memiliki properti 'user'
    if (!decoded.user || !decoded.user.id) {
      return res
        .status(401)
        .json({ error: "Invalid token, user ID not found" });
    }

    // Cari data pengguna berdasarkan ID yang diberikan oleh token
    const user = await User.findByPk(decoded.user.id);

    if (!user) {
      return res.status(401).json({ error: "User not found" });
    }

    // Tambahkan data pengguna ke dalam req.user
    req.user = user;

    next(); // Lanjutkan ke middleware atau handler berikutnya
  } catch (error) {
    console.error("Token Error: ", error.message);
    return res.status(401).json({ error: "Token is not valid" });
  }
};

module.exports = authMiddleware;
