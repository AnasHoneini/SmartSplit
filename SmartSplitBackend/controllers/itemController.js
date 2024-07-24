const Item = require('../models/itemModel');
const { validateCreateItem, validate } = require('../middleware/validator');

const createItem = [
  validateCreateItem,
  validate,
  async (req, res) => {
    const {
      userEmail,
      receiptName,
      name,
      price,
      quantity,
      shared,
      sharedWith,
    } = req.body;

    try {
      if (shared) {
        const sharedCount = sharedWith.length + 1;
        const sharedPrice = (price / sharedCount).toFixed(2);

        const items = [];
        const mainItem = await Item.create({
          userEmail,
          receiptName,
          name,
          price: sharedPrice,
          quantity,
        });
        items.push(mainItem);

        for (const email of sharedWith) {
          const sharedItem = await Item.create({
            userEmail: email,
            receiptName,
            name,
            price: sharedPrice,
            quantity,
          });
          items.push(sharedItem);
        }

        return res.status(201).json({
          message: 'Shared item created successfully!',
          items,
        });
      } else {
        const item = await Item.create({
          userEmail,
          receiptName,
          name,
          price,
          quantity,
        });

        return res
          .status(201)
          .json({ message: 'Item created successfully!', item });
      }
    } catch (err) {
      return res.status(500).json({ message: err.message });
    }
  },
];

const getItemByName = async (req, res) => {
  try {
    const item = await Item.findOne({ name: req.params.name }).exec();
    if (!item) {
      return res.status(404).json({ message: 'Item not found' });
    }
    return res.status(200).json(item);
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

const updateItemByName = async (req, res) => {
  try {
    const item = await Item.findOne({ name: req.params.name }).exec();
    if (!item) {
      return res.status(404).json({ message: 'Item not found' });
    }

    if (req.body.name) item.name = req.body.name;
    if (req.body.price) item.price = req.body.price;
    if (req.body.quantity) item.quantity = req.body.quantity;
    item.updatedAt = new Date();

    await item.save();
    return res.status(200).json({ message: 'Item updated successfully!' });
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

const deleteItemByName = async (req, res) => {
  try {
    const item = await Item.findOne({ name: req.params.name }).exec();
    if (!item) {
      return res.status(404).json({ message: 'Item not found' });
    }

    item.deletedAt = new Date();
    await item.save();
    return res
      .status(200)
      .json({ message: 'Item marked as deleted successfully!' });
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

const getItemsByReceiptName = async (req, res) => {
  try {
    const items = await Item.find({
      receiptName: req.params.receiptName,
    }).exec();
    return res.status(200).json(items);
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

module.exports = {
  createItem,
  getItemByName,
  updateItemByName,
  deleteItemByName,
  getItemsByReceiptName,
};
