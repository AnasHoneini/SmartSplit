const express = require('express');
const auth = require('../middleware/auth');

const {
  createGroup,
  getGroupByName,
  updateGroupByName,
  deleteGroupByName,
  getMembersByGroupName,
  addMemberToGroup,
  getUserGroups,
  getReceiptsByGroupName,
} = require('../controllers/groupController');

const router = express.Router();

router.post('/group', auth, createGroup);
router.get('/group/:groupName', auth, getGroupByName);
router.put('/group/:groupName', auth, updateGroupByName);
router.delete('/group/:groupName', auth, deleteGroupByName);
router.get('/group/:groupName/members', auth, getMembersByGroupName);
router.post('/group/:groupName/addMember', auth, addMemberToGroup);
router.get('/group/user/:userEmail', auth, getUserGroups);
router.get('/group/:groupName/receipts', auth, getReceiptsByGroupName);

module.exports = router;
