const express = require("express");
const {
  createReceipt,
  getAllReceipts,
  getReceiptById,
  updateReceiptById,
  deleteReceiptById,
} = require("../controllers/receiptController");

const router = express.Router();

router.post("/receipt", createReceipt);
router.get("/receipt", getAllReceipts);
router.get("/receipt/:receiptId", getReceiptById);
router.put("/receipt/:receiptId", updateReceiptById);
router.delete("/receipt/:receiptId", deleteReceiptById);

module.exports = router;
