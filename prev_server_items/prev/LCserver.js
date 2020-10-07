const express = require('express');
const app = express();

const queryCC = require('../javascript/queryCC.js');

const host = '172.25.233.240';
const port = '3000';

app.use(express.json());
app.use(function(req, res, next){
    res.header('Access-Control-Allow-Methods', 'POST, GET');
    res.header('Access-Control-Allow-Headers', 'content-type');
    res.header('Access-Control-Allow-Credentials', true);
    res.header('Access-Control-Allow-Origin', 'http://localhost:9553');
    next();
});

var server = app.listen(port, host, ()=>{
    console.log('********** Server started ************');
    console.log('******* http://'+host+':'+port+'/ ********');
})

app.get('/find', async function(req, res, next) {
    const password = req.query.password;
    const bankCode = req.query.bankCode;
    const notiNumber = req.query.notiNumber;
    const notiChangeNum = req.query.notiChangeNum;

    req.send({result:"aa"});
    
    /*try{
        const queryResult = await queryCC('GetLC', notiNumber, notiChangeNum, bankCode, password);
        console.log(queryResult);
        if(queryResult) res.json({result: queryResult, isSuccess: true});
        else res.json({isSuccess: false});
    } catch (error) {
        res.json({isSuccess: false});
        console.log('error here');
        console.log(error);
    }*/

});

app.post('/print', async function(req, res, next) {
    const bankCode = req.body.bankCode;
    const notiNumber = req.body.notiNumber;
    const notiChangeNum = req.body.notiChangeNum;

    if(!(bankCode && notiNumber && notiChangeNum))
        res.send('');

    try{
        const queryResult = await queryCC('PrintLC', notiNumber, notiChangeNum, bankCode);
        res.send(queryResult);
    } catch (error) {
        console.log(error);
    }
});

app.post('/buy', async function(req, res, next) {
    const password = req.body.password;
    const bankCode = req.body.bankCode;
    const notiNumber = req.body.notiNumber;
    const notiChangeNum = req.body.notiChangeNum;

    if(!(password && bankCode && notiNumber && notiChangeNum))
        res.send('');

    try{
        const queryResult = await queryCC('BuyLC', notiNumber, notiChangeNum, bankCode, password);
        res.send(queryResult);
    } catch (error) {
        console.log(error);
    }
});


app.post('/reject', async function(req, res, next) {
    //const bankCode = req.body.bankCode;
    //const notiNumber = req.body.notiNumber;
    //const notiChangeNum = req.body.notiChangeNum;

    //if(!(bankCode && notiNumber && notiChangeNum))
    //    res.send('');

    try{
        res.json({reject: true});
        //    const queryResult = await queryCC('RejectLC', notiNumber, notiChangeNum, bankCode);
    //    res.send(queryResult);
    } catch (error) {
        console.log(error);
    }
});

app.post('/enroll', async function(req, res, next) {
    const bankCode = req.body.bankCode;
    const notiNumber = req.body.notiNumber;
    const notiChangeNum = req.body.notiChangeNum;
    const lcNum = req.body.lcNum;
    const notiPlaceNum = req.body.notiPlaceNum;
    const enrollTime = req.body.enrollTime;
    const password = req.body.password;

    //const lc = req.body.lc;

    if(!(password && bankCode && notiNumber && notiChangeNum))
        res.send('');

    try{
        const queryResult = await queryCC.rejectLC('Enroll', notiNumber, notiChangeNum, bankCode, lcNum,
            notiPlaceNum, enrollTime, password, 'LC header', 'LC body', "LC Tail");
        res.send(queryResult);
    } catch (error) {
        console.log(error);
    }
});