const { User } = require("../models");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const transporter = require("../config/nodemailer");
const secret = process.env.JWT_SECRET;

function generateOtp() {
  return Math.floor(100000 + Math.random() * 900000).toString();
}

const register = async (req, res) => {
  const { username, password } = req.body;
  const image = req.file
    ? `/uploads/users/${req.file.filename}`
    : "/uploads/default.png";

  // validasi username
  if (!username.includes("@gmail.com")) {
    return res.status(400).json({
      error: "username must include @gmail.com",
    });
  }

  try {
    const existingUser = await User.findOne({ where: { username: username } });
    if (existingUser) {
      return res.status(400).json({
        error: "username already exists",
      });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const otp = generateOtp().toString();
    const user = await User.create({
      username,
      password: hashedPassword,
      image,
      otp,
    });

    // send otp to email
    const mailOptions = {
      from: process.env.EMAIL_USER,
      to: user.username,
      subject: "OTP for Storage Management",
      text: `Your OTP is ${otp}, please do not share it with anyone.`,
    };

    transporter.sendMail(mailOptions, (error, info) => {
      if (error) {
        console.error("Error Sending Email: ", error);
        return res.status(500).json({ error: "Failed to send email" });
      } else {
        console.log(`Email sent: ${info.response}`);
        res.status(201).json({
          message: "OTP sent to email",
        });
      }
    });
  } catch (error) {
    console.error("Error Registering User: ", error);
    res.status(500).json({
      error: "failed to register user",
    });
  }
};

const completeRegistration = async (req, res) => {
  const { otp } = req.body;

  // Pastikan otp tersedia
  if (!otp) {
    return res.status(400).json({ error: "OTP is required" });
  }

  try {
    // Temukan pengguna dengan otp yang sesuai
    const user = await User.findOne({ where: { otp } });

    // Periksa apakah pengguna ditemukan dan OTP yang dimasukkan sesuai dengan yang disimpan dalam data pengguna
    if (user) {
      // Jika sesuai, tandai pengguna sebagai terverifikasi atau lakukan langkah tambahan sesuai kebutuhan aplikasi Anda
      await user.update({ otp: null, verified: true }); // Menghapus OTP dan menandai pengguna sebagai terverifikasi

      return res.status(200).json({
        message: "Registration completed successfully",
      });
    } else {
      // Jika OTP tidak sesuai, kirimkan pesan kesalahan
      return res.status(400).json({
        error: "Invalid OTP",
      });
    }
  } catch (error) {
    console.error("Error Completing Registration: ", error);
    res.status(500).json({
      error: "Failed to complete registration",
    });
  }
};

const login = async (req, res) => {
  const { username, password } = req.body;
  // validation username
  if (!username.includes("@gmail.com")) {
    return res.status(400).json({
      error: "username must include @gmail.com",
    });
  }
  try {
    const user = await User.findOne({ where: { username } });

    if (!user) {
      return res.status(400).json({ error: "Invalid username or password" });
    }

    const validPassword = await bcrypt.compare(password, user.password);

    if (!validPassword) {
      return res.status(400).json({ error: "Invalid username or password" });
    }

    const token = jwt.sign({ user: { id: user.id } }, secret, {
      expiresIn: "24h",
    });

    // Send token in response
    res.json({ token });
  } catch (error) {
    console.error("Error Logging In: ", error);
    res.status(500).json({ error: "Failed to login user" });
  }
};

const getProfile = async (req, res) => {
  const id = +req.params.id;
  try {
    const user = await User.findByPk(req.user.id, {
      attributes: { exclude: ["password"] },
    });
    if (!user) {
      return res.status(404).json({
        error: "user not found",
      });
    }
    res.json(user);
  } catch (error) {
    console.error("Error Getting Profile: ", error);
    res.status(500).json({
      error: "failed to get user",
    });
  }
};

const updateProfile = async (req, res) => {
  const { password } = req.body;
  const image = req.file
    ? `/uploads/users/${req.file.filename}`
    : `/uploads/default.png`;

  try {
    const user = await User.findByPk(req.user.id);

    if (!user) {
      return res.status(404).json({
        error: "user not found",
      });
    }

    if (password) {
      user.password = await bcrypt.hash(password, 10);
    }

    if (req.file) {
      user.image = image;
    }

    await user.save();

    res.json({
      message: "Profile updated successfully",
      user,
    });
  } catch {
    console.error("Error Updating User Profile: ", error);
    res.status(500).json({ error: "Failed to update user profile" });
  }
};

module.exports = {
  register,
  completeRegistration,
  login,
  getProfile,
  updateProfile,
};
