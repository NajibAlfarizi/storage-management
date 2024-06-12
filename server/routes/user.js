const userRoutes = require("express").Router();
const userController = require("../controllers/authController");
const { uploadUserImage } = require("../middleware/multer");
const authMiddleware = require("../middleware/auth");

userRoutes.post(
  "/register",
  uploadUserImage.single("image"),
  userController.register
);
userRoutes.post("/complete-register", userController.completeRegistration);
userRoutes.post("/login", userController.login);
userRoutes.get("/profile", authMiddleware, userController.getProfile);
userRoutes.put(
  "/profile",
  authMiddleware,
  uploadUserImage.single("image"),
  userController.updateProfile
);

module.exports = userRoutes;
