const mongoose = require('mongoose');

const groupReceiptSchema = new mongoose.Schema({
  receiptName: {
    type: String,
    ref: 'Receipt',
    required: [true, 'Receipt name is required!'],
  },
  groupName: {
    type: String,
    ref: 'Group',
    required: [true, 'Group name is required!'],
  },
});

module.exports = mongoose.model('GroupReceipt', groupReceiptSchema);
