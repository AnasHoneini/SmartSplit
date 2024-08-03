const Receipt = require('../models/receiptModel');
const GroupReceipt = require('../models/groupReceiptModel');
const UserGroup = require('../models/userGroupModel');
const Group = require('../models/groupModel');
const { validateCreateReceipt, validate } = require('../middleware/validator');
const Item = require('../models/itemModel');

const createReceipt = [
  validateCreateReceipt,
  validate,
  async (req, res) => {
    const { restaurantName, receiptName, groupName } = req.body;

    try {
      const groupExists = await Group.findOne({ groupName }).exec();
      if (!groupExists) {
        return res.status(404).json({ message: 'Group not found' });
      }

      const receipt = await Receipt.create({ restaurantName, receiptName });
      await GroupReceipt.create({ receiptName, groupName });

      return res
        .status(201)
        .json({ message: 'Receipt created successfully!', receipt });
    } catch (err) {
      return res.status(500).json({ message: err.message });
    }
  },
];

const getReceiptByName = async (req, res) => {
  try {
    const receipt = await Receipt.findOne({
      receiptName: req.params.receiptName,
    }).exec();
    if (!receipt) {
      return res.status(404).json({ message: 'Receipt not found' });
    }
    return res.status(200).json(receipt);
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

const updateReceiptByName = async (req, res) => {
  try {
    const receipt = await Receipt.findOne({
      receiptName: req.params.receiptName,
    }).exec();
    if (!receipt) {
      return res.status(404).json({ message: 'Receipt not found' });
    }

    if (req.body.restaurantName)
      receipt.restaurantName = req.body.restaurantName;

    receipt.updatedAt = new Date();

    await receipt.save();
    return res.status(200).json({ message: 'Receipt updated successfully!' });
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

const deleteReceiptByName = async (req, res) => {
  try {
    const receipt = await Receipt.findOne({
      receiptName: req.params.receiptName,
    }).exec();
    if (!receipt) {
      return res.status(404).json({ message: 'Receipt not found' });
    }

    receipt.deletedAt = new Date();
    await receipt.save();
    return res
      .status(200)
      .json({ message: 'Receipt marked as deleted successfully!' });
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

const getUserReceipts = async (req, res) => {
  try {
    const userEmail = req.user.email;
    const userGroups = await UserGroup.find({ userEmail }).exec();
    const groupNames = userGroups.map((ug) => ug.groupName);

    const groupReceipts = await GroupReceipt.find({
      groupName: { $in: groupNames },
    }).exec();
    const receiptNames = groupReceipts.map((gr) => gr.receiptName);

    const receipts = await Receipt.find({
      receiptName: { $in: receiptNames },
    }).exec();

    const receiptData = await Promise.all(
      receipts.map(async (receipt) => {
        const items = await Item.find({
          receiptName: receipt.receiptName,
          deletedAt: { $exists: false },
        }).exec();

        const totalPrice = items.reduce(
          (sum, item) => sum + item.price * item.quantity,
          0
        );

        return {
          receipt: {
            receiptName: receipt.receiptName,
            restaurantName: receipt.restaurantName,
            createdAt: receipt.createdAt,
            updatedAt: receipt.updatedAt,
            deletedAt: receipt.deletedAt,
          },
          totalPrice,
          items,
        };
      })
    );
    res.status(200).json(receiptData);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: err.message });
  }
};

module.exports = {
  createReceipt,
  getReceiptByName,
  updateReceiptByName,
  deleteReceiptByName,
  getUserReceipts,
};
