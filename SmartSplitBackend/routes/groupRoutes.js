const express = require("express");

const {
  createGroup,
  getAllGroups,
  getGroupByName,
  updateGroupByName,
  deleteGroupByName,
  getMembersByGroupId,
  addMemberToGroup,
} = require("../controllers/groupController");

const router = express.Router();

router.post("/group", createGroup);
router.get("/group", getAllGroups);
router.get("/group/:groupName", getGroupByName);
router.put("/group/:groupName", updateGroupByName);
router.delete("/group/:groupName", deleteGroupByName);
router.get("/group/:groupId", getMembersByGroupId);
router.post("/addGroup", addMemberToGroup);

module.exports = router;
