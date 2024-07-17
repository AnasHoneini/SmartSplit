const express = require("express");
const auth = require("../middleware/auth");

const router = express.Router();

const {
  createUser,
  loginUser,
  getAllUsers,
  getUserByEmail,
  deleteUserByEmail,
  updateUserByEmail,
} = require("../controllers/userController");

router.post("/users", createUser);
router.post("/login", loginUser);
router.get("/", auth, getAllUsers);
router.get("/:email", auth, getUserByEmail);
router.put("/:email", auth, updateUserByEmail);
router.delete("/:email", auth, deleteUserByEmail);

module.exports = router;
