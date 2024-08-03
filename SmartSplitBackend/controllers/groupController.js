const Group = require('../models/groupModel');
const UserGroup = require('../models/userGroupModel');
const GroupReceipt = require('../models/groupReceiptModel');
const Receipt = require('../models/receiptModel');
const User = require('../models/userModel');
const Item = require('../models/itemModel');

const {
  validateCreateGroup,
  validateAddMemberToGroup,
  validate,
} = require('../middleware/validator');

const createGroup = [
  validateCreateGroup,
  validate,
  async (req, res) => {
    const { groupName, description, createdBy, isActive } = req.body;

    try {
      const user = await User.findOne({ email: createdBy });
      if (!user) {
        return res.status(404).send({ message: 'User not found' });
      }
      const group = await Group.create({
        groupName,
        description,
        createdBy,
        isActive,
      });

      await UserGroup.create({ userEmail: createdBy, groupName: groupName });

      return res
        .status(201)
        .json({ message: 'Group created successfully!', group });
    } catch (err) {
      return res.status(500).json({ message: err.message });
    }
  },
];

const getGroupByName = async (req, res) => {
  try {
    const group = await Group.findOne({
      groupName: req.params.groupName,
    }).exec();
    if (!group) {
      return res.status(404).json({ message: 'Group not found' });
    }
    return res.status(200).json(group);
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

const updateGroupByName = async (req, res) => {
  try {
    const group = await Group.findOne({
      groupName: req.params.groupName,
    }).exec();
    if (!group) {
      return res.status(404).json({ message: 'Group not found' });
    }

    if (req.body.groupName) group.groupName = req.body.groupName;
    if (req.body.description) group.description = req.body.description;
    if (req.body.isActive !== undefined) group.isActive = req.body.isActive;
    group.updatedAt = new Date();

    await group.save();
    return res.status(200).json({ message: 'Group updated successfully!' });
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

const deleteGroupByName = async (req, res) => {
  try {
    const group = await Group.findOne({
      groupName: req.params.groupName,
    }).exec();
    if (!group) {
      return res.status(404).json({ message: 'Group not found' });
    }

    group.deletedAt = new Date();
    await group.save();
    return res
      .status(200)
      .json({ message: 'Group marked as deleted successfully!' });
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

const getMembersByGroupName = async (req, res) => {
  try {
    const group = await Group.findOne({
      groupName: req.params.groupName,
      deletedAt: { $exists: false },
    }).exec();
    if (!group) {
      return res.status(404).json({ message: 'Group not found' });
    }

    const userGroups = await UserGroup.find({
      groupName: req.params.groupName,
      deletedAt: { $exists: false },
    }).exec();
    const userEmails = userGroups.map((ug) => ug.userEmail);
    const users = await User.find({ email: { $in: userEmails } }).exec();

    return res.status(200).json(users);
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

const getUserGroups = async (req, res) => {
  try {
    const userGroups = await UserGroup.find({
      userEmail: req.params.userEmail,
    }).exec();
    const groupNames = userGroups.map((ug) => ug.groupName);
    const groups = await Group.find({ groupName: { $in: groupNames } }).exec();

    return res.status(200).json(groups);
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

const addMemberToGroup = [
  validateAddMemberToGroup,
  validate,
  async (req, res) => {
    const { userEmail, groupName } = req.body;

    try {
      const group = await Group.findOne({ groupName }).exec();
      if (!group) {
        return res.status(404).json({ message: 'Group not found' });
      }

      const user = await User.findOne({ email: userEmail }).exec();
      if (!user) {
        return res.status(404).json({ message: 'User not found' });
      }

      const existingUserGroup = await UserGroup.findOne({
        groupName,
        userEmail,
      }).exec();
      if (existingUserGroup) {
        return res
          .status(400)
          .json({ message: 'User is already a member of the group' });
      }

      const userGroup = new UserGroup({ groupName, userEmail });
      await userGroup.save();

      return res
        .status(201)
        .json({ message: 'Member added to group successfully!', userGroup });
    } catch (err) {
      return res.status(500).json({ message: err.message });
    }
  },
];

const getReceiptsByGroupName = async (req, res) => {
  try {
    const groupReceipts = await GroupReceipt.find({
      groupName: req.params.groupName,
    }).exec();
    const receiptNames = groupReceipts.map((gr) => gr.receiptName);
    const receipts = await Receipt.find({
      receiptName: { $in: receiptNames },
    }).exec();
    return res.status(200).json(receipts);
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

const deleteMemberFromGroup = async (req, res) => {
  const { groupName, userEmail } = req.body;

  try {
    const group = await Group.findOne({ groupName }).exec();
    if (!group) {
      return res.status(404).json({ message: 'Group not found' });
    }

    const userGroup = await UserGroup.findOne({ groupName, userEmail }).exec();
    if (!userGroup) {
      return res.status(404).json({ message: 'Member not found in the group' });
    }

    const userItems = await Item.find({
      groupName,
      userEmail,
      deletedAt: { $exists: false },
    }).exec();
    if (userItems.length > 0) {
      console.error(
        'User has items linked to their name and cannot be deleted.'
      );
      return res.status(400).json({
        message: 'User has items linked to their name and cannot be deleted.',
      });
    }

    userGroup.deletedAt = new Date();
    await userGroup.save();

    await Item.updateMany(
      { userEmail, groupName },
      { $set: { deletedAt: new Date() } }
    ).exec();

    return res
      .status(200)
      .json({ message: 'Member removed from group successfully!' });
  } catch (err) {
    console.error('Error deleting member:', err);
    return res
      .status(500)
      .json({ message: 'Failed to delete member', error: err.message });
  }
};

module.exports = {
  createGroup,
  getGroupByName,
  updateGroupByName,
  deleteGroupByName,
  getMembersByGroupName,
  addMemberToGroup,
  getUserGroups,
  getReceiptsByGroupName,
  deleteMemberFromGroup,
};
