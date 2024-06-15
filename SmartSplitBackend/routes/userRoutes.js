const express = require("express");

const router = express.Router();

const {
  createUser,
  getAllUsers,
  getUserByEmail,
  deleteUserByEmail,
  updateUserByEmail,
} = require("../controllers/userController");

router.post("/users", createUser);
router.get("/users", getAllUsers);
router.get("/users/:email", getUserByEmail);
router.put("/users/:email", updateUserByEmail);
router.delete("/users/:email", deleteUserByEmail);

module.exports = router;
