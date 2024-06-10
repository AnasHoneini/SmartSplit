const express = require("express");

const router = express.Router();

const {
  createUser,
  getAllUsers,
  getUserByEmail,
  deleteUserByEmail,
  updateUserByEmail,
} = require("../controllers/userController");

router.post("/createUser", createUser);
router.get("/getAllUsers", getAllUsers);
router.get("/getUserByEmail/:email", getUserByEmail);
router.put("/updateUserByEmail/:email", updateUserByEmail);
router.delete("/deleteUserByEmail/:email", deleteUserByEmail);

module.exports = router;
