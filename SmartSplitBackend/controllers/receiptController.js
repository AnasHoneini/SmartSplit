const Receipt = require('../models/receiptModel');
const GroupReceipt = require('../models/groupReceiptModel');
const Group = require('../models/groupModel');
const { validateCreateReceipt, validate } = require('../middleware/validator');

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

module.exports = {
  createReceipt,
  getReceiptByName,
  updateReceiptByName,
  deleteReceiptByName,
};
