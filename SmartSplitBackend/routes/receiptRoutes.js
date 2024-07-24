const express = require('express');
const {
  createReceipt,
  getReceiptByName,
  updateReceiptByName,
  deleteReceiptByName,
  getUserReceipts,
} = require('../controllers/receiptController');
const auth = require('../middleware/auth');

const router = express.Router();

router.post('/receipt', auth, createReceipt);
router.get('/receipt/:receiptName', auth, getReceiptByName);
router.put('/receipt/:receiptName', auth, updateReceiptByName);
router.delete('/receipt/:receiptName', auth, deleteReceiptByName);
router.get('/user/receipts', auth, getUserReceipts);

module.exports = router;
