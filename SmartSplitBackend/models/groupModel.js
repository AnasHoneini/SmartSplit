const mongoose = require("mongoose");

const groupSchema = new mongoose.Schema({
  groupName: {
    type: String,
    required: [true, "Group Name is required!"],
  },
  description: {
    type: String,
  },
  profilePicture: {
    type: String,
  },
  createdBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: [true, "User is required!"],
  },
  isActive: {
    type: Boolean,
    default: true,
    required: [true, "Active is required!"],
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

module.exports = mongoose.model("Group", groupSchema);
