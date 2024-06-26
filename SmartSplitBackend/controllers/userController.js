const User = require("../models/userModel");
const bcrypt = require("bcrypt");
const {
  validateCreateUser,
  validateUpdateUser,
  validate,
} = require("../middleware/validator");

const createUser = [
  validateCreateUser,
  validate,
  async (req, res) => {
    const { firstName, lastName, email, password, profilePicture } = req.body;

    try {
      const duplicateUser = await User.findOne({ email }).exec();
      if (duplicateUser) {
        return res.status(400).json({ message: "User already exists!" });
      }

      const hashedPassword = await bcrypt.hash(password, 10);
      const user = await User.create({
        firstName,
        lastName,
        email,
        passwordHash: hashedPassword,
        profilePicture,
      });
      res.status(201).json({ message: "User created successfully!", user });
    } catch (err) {
      res.status(500).json({ message: err.message });
    }
  },
];

const getAllUsers = async (req, res) => {
  try {
    const users = await User.find().exec();
    res.status(200).json(users);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

const getUserByEmail = async (req, res) => {
  try {
    const user = await User.findOne({ email: req.params.email }).exec();
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    res.status(200).json(user);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

const updateUserByEmail = [
  validateUpdateUser,
  validate,
  async (req, res) => {
    try {
      const user = await User.findOne({ email: req.params.email }).exec();
      if (!user) {
        return res.status(404).json({ message: "User not found" });
      }

      if (req.body.firstName) {
        user.firstName = req.body.firstName;
      }
      if (req.body.lastName) {
        user.lastName = req.body.lastName;
      }
      if (req.body.email) {
        user.email = req.body.email;
      }
      if (req.body.password) {
        user.passwordHash = await bcrypt.hash(req.body.password, 10);
      }
      if (req.body.profilePicture) {
        user.profilePicture = req.body.profilePicture;
      }
      user.updatedAt = new Date();
      await user.save();
      res.status(200).json({ message: "User updated successfully!" });
    } catch (err) {
      res.status(500).json({ message: err.message });
    }
  },
];

const deleteUserByEmail = async (req, res) => {
  try {
    const user = await User.findOne({ email: req.params.email }).exec();
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    user.deletedAt = new Date();
    await user.save();
    res.status(200).json({ message: "User marked as deleted successfully!" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

module.exports = {
  createUser,
  getAllUsers,
  getUserByEmail,
  deleteUserByEmail,
  updateUserByEmail,
};
