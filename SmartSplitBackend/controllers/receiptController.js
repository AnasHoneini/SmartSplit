const Receipt = require("../models/receiptModel");
const GroupReceipt = require("../models/groupReceiptModel");

const createReceipt = async (req, res) => {
  const { restaurantName, groupId } = req.body;

  if (!restaurantName || !groupId) {
    return res.status(400).json({
      message: "Restaurant name and group ID are required!",
    });
  }

  try {
    const receipt = await Receipt.create({
      restaurantName,
    });

    await GroupReceipt.create({ receiptId: receipt._id, groupId: groupId });

    return res
      .status(201)
      .json({ message: "Receipt created successfully!", receipt });
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

const getAllReceipts = async (req, res) => {
  try {
    const receipts = await Receipt.find().exec();
    return res.status(200).json(receipts);
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

const getReceiptById = async (req, res) => {
  try {
    const receipt = await Receipt.findById(req.params.receiptId).exec();
    if (!receipt) {
      return res.status(404).json({ message: "Receipt not found" });
    }
    return res.status(200).json(receipt);
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

const updateReceiptById = async (req, res) => {
  try {
    const receipt = await Receipt.findById(req.params.receiptId).exec();
    if (!receipt) {
      return res.status(404).json({ message: "Receipt not found" });
    }

    if (req.body.restaurantName)
      receipt.restaurantName = req.body.restaurantName;

    receipt.updatedAt = new Date();

    await receipt.save();
    return res.status(200).json({ message: "Receipt updated successfully!" });
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

const deleteReceiptById = async (req, res) => {
  try {
    const receipt = await Receipt.findById(req.params.receiptId).exec();
    if (!receipt) {
      return res.status(404).json({ message: "Receipt not found" });
    }

    receipt.deletedAt = new Date();
    await receipt.save();
    return res
      .status(200)
      .json({ message: "Receipt marked as deleted successfully!" });
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

module.exports = {
  createReceipt,
  getAllReceipts,
  getReceiptById,
  updateReceiptById,
  deleteReceiptById,
};
