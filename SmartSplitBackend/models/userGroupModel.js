const mongoose = require('mongoose');

const userGroupSchema = new mongoose.Schema({
  userEmail: {
    type: String,
    ref: 'User',
    required: [true, 'User email is required!'],
  },
  groupName: {
    type: String,
    ref: 'Group',
    required: [true, 'Group is required!'],
  },
});

module.exports = mongoose.model('UserGroup', userGroupSchema);
