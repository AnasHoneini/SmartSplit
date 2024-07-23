const mongoose = require('mongoose');
require('dotenv').config();

const mongourl = process.env.MONGO_URL;

const connectDB = async () => {
  try {
    await mongoose.connect(mongourl);
    console.log('Connected to the database!');
  } catch (err) {
    console.log('Cannot connect to the database!', err);
  }
};

module.exports = connectDB;
