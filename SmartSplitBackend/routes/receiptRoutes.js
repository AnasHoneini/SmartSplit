const express = require("express");
const {
  createReceipt,
  getAllReceipts,
  getReceiptByName,
  updateReceiptByName,
  deleteReceiptByName,
} = require("../controllers/receiptController");

const router = express.Router();

router.post("/receipt", createReceipt);
router.get("/receipt", getAllReceipts);
router.get("/receipt/:receiptName", getReceiptByName);
router.put("/receipt/:receiptName", updateReceiptByName);
router.delete("/receipt/:receiptName", deleteReceiptByName);

module.exports = router;
