const express = require('express');
const router = express.Router();

const query = require('./api/query');
const adminLogin = require('./api/adminLogin');
const logs = require('./logs');

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index');
});

router.get('/client', function(req, res, next) {
  res.render('client');
});

router.get('/admin', function(req, res, next) {
  res.render('admin_login');
});

router.post('/login', async function(req, res, next) {
  console.log('hey');
  await adminLogin(req, res, next);
});

router.get('/rejected', function(req, res, next) {
  res.json({isRejected: true});
});

router.post('/lcdata', async function(req, res, next) {
  await query(req, res, next);
});

module.exports = router;