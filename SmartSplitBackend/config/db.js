const mongoose = require("mongoose");

const mongourl =
  "mongodb+srv://anashoneini:admin@cluster0.zay5zx3.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";

const connectDB = async () => {
  try {
    await mongoose.connect(mongourl);
    console.log("Connected to the database!");
  } catch (err) {
    console.log("Cannot connect to the database!", err);
  }
};

module.exports = connectDB;
