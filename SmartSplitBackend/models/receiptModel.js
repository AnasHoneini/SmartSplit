const mongoose = require("mongoose");

const receiptSchema = new mongoose.Schema({
  restaurantName: {
    type: String,
    required: [true, "Restaurant name is required!"],
  },
  receiptName: {
    type: String,
    required: [true, "Receipt name is required!"],
    unique: true,
  },
  deletedAt: {
    type: Date,
  },
  updatedAt: {
    type: Date,
    default: Date.now,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model("Receipt", receiptSchema);
