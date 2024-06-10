const express = require("express");

const {
  createItem,
  getAllItems,
  getItemByName,
  updateItemByName,
  deleteItemByName,
} = require("../controllers/itemController");

const router = express.Router();

router.post("/createItem", createItem);
router.get("/getAllItems", getAllItems);
router.get("/getItemByName/:name", getItemByName);
router.put("/updateItemByName/:name", updateItemByName);
router.delete("/deleteItemByName/:name", deleteItemByName);

module.exports = router;
