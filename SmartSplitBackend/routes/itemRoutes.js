const express = require("express");

const {
  createItem,
  getAllItems,
  getItemByName,
  updateItemByName,
  deleteItemByName,
} = require("../controllers/itemController");

const router = express.Router();

router.post("/items", createItem);
router.get("/items", getAllItems);
router.get("/items/:name", getItemByName);
router.put("/items/:name", updateItemByName);
router.delete("/items/:name", deleteItemByName);

module.exports = router;
