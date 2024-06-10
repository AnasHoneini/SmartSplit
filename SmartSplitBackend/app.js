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

app.use("/api/users", userRoutes);
app.use("/api/items", itemRoutes);
app.use("/api/groups", groupRoutes);
app.use("/api/receipts", receiptRoutes);

app.listen(5001, () => {
  console.log("Server is running on port 5001");
});
