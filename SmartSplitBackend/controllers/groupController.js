const Group = require("../models/groupModel");
const UserGroup = require("../models/userGroupModel");
const User = require("../models/userModel");
const {
  validateCreateGroup,
  validateAddMemberToGroup,
  validate,
} = require("../middleware/validator");

const createGroup = [
  validateCreateGroup,
  validate,
  async (req, res) => {
    const { groupName, description, profilePicture, createdBy, isActive } =
      req.body;

    try {
      const group = await Group.create({
        groupName,
        description,
        profilePicture,
        createdBy,
        isActive,
      });

      await UserGroup.create({ userId: createdBy, groupId: group._id });

      return res
        .status(201)
        .json({ message: "Group created successfully!", group });
    } catch (err) {
      return res.status(500).json({ message: err.message });
    }
  },
];

const getAllGroups = async (req, res) => {
  try {
    const groups = await Group.find().exec();
    return res.status(200).json(groups);
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

const getGroupByName = async (req, res) => {
  try {
    const group = await Group.findOne({
      groupName: req.params.groupName,
    }).exec();
    if (!group) {
      return res.status(404).json({ message: "Group not found" });
    }
    return res.status(200).json(group);
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

const updateGroupByName = async (req, res) => {
  try {
    const group = await Group.findOne({}).exec();
    if (!group) {
      return res.status(404).json({ message: "Group not found" });
    }

    if (req.body.groupName) group.groupName = req.body.groupName;
    if (req.body.description) group.description = req.body.description;
    if (req.body.profilePicture) group.profilePicture = req.body.profilePicture;
    if (req.body.isActive !== undefined) group.isActive = req.body.isActive;
    group.updatedAt = new Date();

    await group.save();
    return res.status(200).json({ message: "Group updated successfully!" });
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

const deleteGroupByName = async (req, res) => {
  try {
    const group = await Group.findOne({}).exec();
    if (!group) {
      return res.status(404).json({ message: "Group not found" });
    }

    group.deletedAt = new Date();
    await group.save();
    return res
      .status(200)
      .json({ message: "Group marked as deleted successfully!" });
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

const getMembersByGroupId = async (req, res) => {
  try {
    const group = await Group.findById(req.params.groupId).exec();
    if (!group) {
      return res.status(404).json({ message: "Group not found" });
    }

    const userGroups = await UserGroup.find({
      groupId: req.params.groupId,
    }).exec();
    const userIds = userGroups.map((ug) => ug.userId);
    const users = await User.find({ _id: { $in: userIds } }).exec();

    return res.status(200).json(users);
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

const addMemberToGroup = [
  validateAddMemberToGroup,
  validate,
  async (req, res) => {
    const { userId, groupId } = req.body;

    try {
      const group = await Group.findById(groupId).exec();
      if (!group) {
        return res.status(404).json({ message: "Group not found" });
      }

      const user = await User.findById(userId).exec();
      if (!user) {
        return res.status(404).json({ message: "User not found" });
      }

      const existingUserGroup = await UserGroup.findOne({
        userId,
        groupId,
      }).exec();
      if (existingUserGroup) {
        return res
          .status(400)
          .json({ message: "User is already a member of the group" });
      }

      const userGroup = await UserGroup.create({ userId, groupId });

      await group.save();

      return res
        .status(201)
        .json({ message: "Member added to group successfully!", userGroup });
    } catch (err) {
      return res.status(500).json({ message: err.message });
    }
  },
];

module.exports = {
  createGroup,
  getAllGroups,
  getGroupByName,
  updateGroupByName,
  deleteGroupByName,
  getMembersByGroupId,
  addMemberToGroup,
};
