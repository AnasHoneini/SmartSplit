const express = require('express');
const auth = require('../middleware/auth');

const router = express.Router();

const {
  createUser,
  loginUser,
  getUserByEmail,
  deleteUserByEmail,
  updateUserByEmail,
  getAllUserEmails,
} = require('../controllers/userController');

router.post('/users', createUser);
router.post('/login', loginUser);
router.get('/:email', auth, getUserByEmail);
router.get('/emails/all', auth, getAllUserEmails);
router.put('/:email', auth, updateUserByEmail);
router.delete('/:email', auth, deleteUserByEmail);

module.exports = router;
