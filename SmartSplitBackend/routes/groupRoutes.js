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

router.post("/createGroup", createGroup);
router.get("/getAllGroups", getAllGroups);
router.get("/getGroupByName/:groupName", getGroupByName);
router.put("/updateGroupByName/:groupName", updateGroupByName);
router.delete("/deleteGroupByName/:groupName", deleteGroupByName);
router.get("/getMembersByGroupId/:groupId", getMembersByGroupId);
router.post("/addMemberToGroup", addMemberToGroup);

module.exports = router;
