const mongoose = require("mongoose");

const userGroupSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: [true, "User is required!"],
  },
  groupId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Group",
    required: [true, "Group is required!"],
  },
});

module.exports = mongoose.model("UserGroup", userGroupSchema);
