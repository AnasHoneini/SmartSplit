const express = require("express");

const {
  createGroup,
  getAllGroups,
  getGroupByName,
  updateGroupByName,
  deleteGroupByName,
  getMembersByGroupName,
  addMemberToGroup,
  getUserGroups,
  getReceiptsByGroupName,
} = require("../controllers/groupController");

const router = express.Router();

router.post("/group", createGroup);
router.get("/group", getAllGroups);
router.get("/group/:groupName", getGroupByName);
router.put("/group/:groupName", updateGroupByName);
router.delete("/group/:groupName", deleteGroupByName);
router.get("/group/:groupName/members", getMembersByGroupName);
router.post("/group/:groupName/addMember", addMemberToGroup);
router.get("/group/user/:userEmail", getUserGroups);
router.get("/group/:groupName/receipts", getReceiptsByGroupName);

module.exports = router;
