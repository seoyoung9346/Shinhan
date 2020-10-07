//서버 구동을 위한 Express 모듈
const express = require('express');
require('date-utils');
const app = express();
const router = express.Router();

//User created 모듈
//const hash = require('hash.js');
//const queryCC = require('../javascript/queryCC.js');
//const mariaDB = require('./mariaDBConnect.js');

//각각 기능 모듈
const query = require('./query.js');
const print = require('./print.js');
//const buy = require('./buy.js');
const reject = require('./reject.js');
//const getdata = require('./getdata.js');
//const getdatarequest = require('./getdatarequest.js');
const eaicall = require('./eaicall.js');
const qrcode = require('./qrcode.js');

//서버 설정
const host = '172.25.229.237';
const port = '3000';

// 서버에 바디파서 미들웨어 사용
app.use(express.json());
app.use(router);

router.use(function(req, res, next){
    res.header('Access-Control-Allow-Methods', 'POST, GET');
    res.header('Access-Control-Allow-Headers', 'content-type');
    res.header('Access-Control-Allow-Credentials', true);
    res.header('Access-Control-Allow-Origin', 'http://localhost:9553');
    next();
});

// 서버 구동
var server = app.listen(port,host,() => {
    console.log('************  Server Started  ************');
    console.log('********  http://' + host + '/'+port+'********')
});

//신용장 조회
router.get ('/query', async function(req, res, next) {
    query(req, res, next);
});

//신용장 조회
router.get ('/qrcode', async function(req, res, next) {
    qrcode(req, res, next);
});

//신용장 출력
router.get ('/print', async function(req, res, next) {
    print(req, res, next);
});

//신용장 매입 등록
router.post ('/buy', async function(req, res, next) {
    buy(req, res, next);
});

//신용장 수령 거절
router.get ('/reject', async function(req, res, next) {
    reject(req, res, next);
});

//마리아DB에서 모든 정보 가져오기
router.post ('/getData', async function(req, res, next) {
    getdata(req, res, next);
});

//마리아DB에서 특정 정보 가져오기
router.post ('/getDataRequest', async function(req, res, next) {
    getdatarequest(req, res, next);
});

//신용장 등록
router.post ('/eaiCall', async function(req, res, next) {
    eaicall(req, res, next);
});


