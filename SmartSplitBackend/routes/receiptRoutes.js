const express = require("express");
const {
  createReceipt,
  getAllReceipts,
  getReceiptByName,
  updateReceiptByName,
  deleteReceiptByName,
} = require("../controllers/receiptController");
const auth = require("../middleware/auth");

const router = express.Router();

router.post("/receipt", auth, createReceipt);
router.get("/receipt", auth, getAllReceipts);
router.get("/receipt/:receiptName", auth, getReceiptByName);
router.put("/receipt/:receiptName", auth, updateReceiptByName);
router.delete("/receipt/:receiptName", auth, deleteReceiptByName);

module.exports = router;
