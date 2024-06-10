const mongoose = require("mongoose");

const groupReceiptSchema = new mongoose.Schema({
  receiptId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Receipt",
    required: [true, "Receipt is required!"],
  },
  groupId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Group",
    required: [true, "Group is required!"],
  },
});

module.exports = mongoose.model("groupReceipt", groupReceiptSchema);
