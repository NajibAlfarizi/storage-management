const userRoutes = require("express").Router();
const userController = require("../controllers/authController");
const upload = require("../middleware/upload");
const authMiddleware = require("../middleware/auth");

userRoutes.post("/register", upload.uploadUser, userController.register);
userRoutes.post("/complete-register", userController.completeRegistration);
userRoutes.post("/login", userController.login);
userRoutes.get("/profile", authMiddleware, userController.getProfile);
userRoutes.put(
  "/profile",
  authMiddleware,
  upload.uploadUser,
  userController.updateProfile
);

module.exports = userRoutes;
