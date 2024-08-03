const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  firstName: {
    type: String,
    required: [true, 'First Name is required!'],
  },
  lastName: {
    type: String,
    required: [true, 'Last Name is required!'],
  },
  email: {
    type: String,
    required: [true, 'Email is required!'],
    unique: true,
  },
  passwordHash: {
    type: String,
    required: [true, 'Password is required!'],
  },
  deletedAt: { type: Date },
  updatedAt: { type: Date, default: Date.now() },
  createdAt: { type: Date, default: Date.now() },
});

module.exports = mongoose.model('User', userSchema);
