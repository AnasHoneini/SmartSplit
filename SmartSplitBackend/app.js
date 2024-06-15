const express = require("express");
const connectDB = require("./config/db");
const userRoutes = require("./routes/userRoutes");
const itemRoutes = require("./routes/itemRoutes");
const groupRoutes = require("./routes/groupRoutes");
const receiptRoutes = require("./routes/receiptRoutes");

const app = express();

connectDB();

app.use(express.json());

app.get("/", (req, res) => {
  res.send({ status: "Started" });
});

app.use("/api", userRoutes);
app.use("/api", itemRoutes);
app.use("/api", groupRoutes);
app.use("/api", receiptRoutes);

app.listen(5001, () => {
  console.log("Server is running on port 5001");
});
