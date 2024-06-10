const express = require("express");
const {
  createReceipt,
  getAllReceipts,
  getReceiptById,
  updateReceiptById,
  deleteReceiptById,
} = require("../controllers/receiptController");

const router = express.Router();

router.post("/createReceipt", createReceipt);
router.get("/getAllReceipts", getAllReceipts);
router.get("/getReceiptById/:receiptId", getReceiptById);
router.put("/updateReceiptById/:receiptId", updateReceiptById);
router.delete("/deleteReceiptById/:receiptId", deleteReceiptById);

module.exports = router;
