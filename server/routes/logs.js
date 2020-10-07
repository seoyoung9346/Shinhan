const express = require('express');
const router = express.Router();
const queryCC = require('../fabricsdk/queryCC.js');
const mariaDB = require('./api/mariadb-connect.js');

router.get('/', async function(req, res, next) {
    try {
        const dbResult = await mariaDB.queryAllLogs();
        //홈페이지 서버에 응답
        res.render('totalData', {result:dbResult});
    } catch (error) {
        //에러 출력
        console.log(error);
        res.render('totalData', {result:null});
    }
});

router.get('/buy', async function(req, res, next) {
    try {
        const dbResult = await mariaDB.queryTypeLogs('buy');
        //홈페이지 서버에 응답
        res.render('totalData', {result:dbResult});
    } catch (error) {
        //에러 출력
        console.log(error);
        res.render('totalData', {result:null});
    }
});

router.get('/inquire', async function(req, res, next) {
    try {
        const dbResult = await mariaDB.queryTypeLogs('inquire');
        //홈페이지 서버에 응답
        res.render('totalData', {result:dbResult});
    } catch (error) {
        //에러 출력
        console.log(error);
        res.render('totalData', {result:null});
    }
});

router.get('/print', async function(req, res, next) {
    try {
        const dbResult = await mariaDB.queryTypeLogs('print');
        //홈페이지 서버에 응답
        res.render('totalData', {result:dbResult});
    } catch (error) {
        //에러 출력
        console.log(error);
        res.render('totalData', {result:null});
    }
});

router.get('/reject', async function(req, res, next) {
    try {
        const dbResult = await mariaDB.queryTypeLogs('reject');
        //홈페이지 서버에 응답
        res.render('totalData', {result:dbResult});
    } catch (error) {
        //에러 출력
        console.log(error);
        res.render('totalData', {result:null});
    }
});

module.exports = router;