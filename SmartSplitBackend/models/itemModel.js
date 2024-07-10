const mongoose = require("mongoose");

const itemSchema = new mongoose.Schema({
  userEmail: {
    type: String,
    ref: "User",
    required: [true, "User Email is required!"],
  },
  receiptName: {
    type: String,
    ref: "Receipt",
    required: [true, "Receipt name is required!"],
  },
  name: {
    type: String,
    required: [true, "Name is required!"],
  },
  price: {
    type: Number,
    required: [true, "Price is required!"],
  },
  quantity: {
    type: Number,
    required: [true, "Quantity is required!"],
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

module.exports = mongoose.model("Item", itemSchema);
