const { check, validationResult } = require("express-validator");

const validateCreateUser = [
  check("firstName")
    .trim()
    .escape()
    .notEmpty()
    .withMessage("First name is required"),
  check("lastName")
    .trim()
    .escape()
    .notEmpty()
    .withMessage("Last name is required"),
  check("email")
    .isEmail()
    .normalizeEmail()
    .withMessage("Valid email is required"),
  check("password")
    .isLength({ min: 5 })
    .trim()
    .escape()
    .withMessage("Password must be at least 5 characters long"),
  check("profilePicture")
    .optional()
    .isURL()
    .trim()
    .escape()
    .withMessage("Valid URL is required for profile picture"),
];

const validateUpdateUser = [
  check("firstName").optional().trim().escape(),
  check("lastName").optional().trim().escape(),
  check("email")
    .optional()
    .isEmail()
    .normalizeEmail()
    .withMessage("Valid email is required"),
  check("password")
    .optional()
    .isLength({ min: 5 })
    .trim()
    .escape()
    .withMessage("Password must be at least 5 characters long"),
  check("profilePicture")
    .optional()
    .isURL()
    .trim()
    .escape()
    .withMessage("Valid URL is required for profile picture"),
];

const validateCreateReceipt = [
  check("restaurantName")
    .trim()
    .escape()
    .notEmpty()
    .withMessage("Restaurant name is required"),
  check("groupId")
    .trim()
    .escape()
    .notEmpty()
    .withMessage("Group ID is required"),
];

const validateCreateItem = [
  check("userId").trim().escape().notEmpty().withMessage("User ID is required"),
  check("receiptId")
    .trim()
    .escape()
    .notEmpty()
    .withMessage("Receipt ID is required"),
  check("name").trim().escape().notEmpty().withMessage("Item name is required"),
  check("price").isNumeric().withMessage("Price must be a number"),
  check("quantity").isInt().withMessage("Quantity must be an integer"),
];

const validateCreateGroup = [
  check("groupName")
    .trim()
    .escape()
    .notEmpty()
    .withMessage("Group name is required"),
  check("description").optional().trim().escape(),
  check("profilePicture")
    .optional()
    .isURL()
    .trim()
    .escape()
    .withMessage("Valid URL is required for profile picture"),
  check("createdBy")
    .trim()
    .escape()
    .notEmpty()
    .withMessage("Created by ID is required"),
  check("isActive")
    .optional()
    .isBoolean()
    .withMessage("IsActive must be a boolean"),
];

const validateAddMemberToGroup = [
  check("userId").trim().escape().notEmpty().withMessage("User ID is required"),
  check("groupId")
    .trim()
    .escape()
    .notEmpty()
    .withMessage("Group ID is required"),
];

const validate = (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }
  next();
};

module.exports = {
  validateCreateUser,
  validateUpdateUser,
  validateCreateReceipt,
  validateCreateItem,
  validateCreateGroup,
  validateAddMemberToGroup,
  validate,
};
