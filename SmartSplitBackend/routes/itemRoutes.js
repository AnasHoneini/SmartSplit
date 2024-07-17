const express = require("express");

const {
  createItem,
  getAllItems,
  getItemByName,
  updateItemByName,
  deleteItemByName,
  getItemsByReceiptName,
} = require("../controllers/itemController");
const auth = require("../middleware/auth");

const router = express.Router();

router.post("/items", auth, createItem);
router.get("/items", auth, getAllItems);
router.get("/items/:name", auth, getItemByName);
router.put("/items/:name", auth, updateItemByName);
router.delete("/items/:name", auth, deleteItemByName);
router.get("/items/receipt/:receiptName", auth, getItemsByReceiptName);

module.exports = router;
