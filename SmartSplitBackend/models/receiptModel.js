const mongoose = require("mongoose");

const receiptSchema = new mongoose.Schema({
  restaurantName: {
    type: String,
    required: [true, "Restaurant name is required!"],
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
