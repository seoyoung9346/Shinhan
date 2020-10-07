const express = require('express');
const app = express();
const session = require('express-session');
const qrcode = require('qrcode');
const router = express.Router();
const MySQLStore = require('express-mysql-session')(session);
const qs = require('query-string');

const register = require('../javascript/registerMyUser.js');
const queryCC = require('../javascript/queryCar.js');
const checkUser = require('../javascript/checkUser.js');
const conn = require('./mariaDBConn.js');
const {encryptAES256, decryptAES256, QRkey} = require('./cryptoQR.js');

const host=process.env.HOST || '172.18.64.249';
const port=process.env.PORT || 3001;

const sessionStore = new MySQLStore({
    host: 'localhost',
    user: 'shorecrab',
    password: 'shorecrab',
    database: 'db',
});
//Use express middle-wares.
app.use(function(req, res, next){
    res.header('Access-Control-Allow-Methods', 'POST, GET');
    res.header('Access-Control-Allow-Headers', 'content-type');
    res.header('Access-Control-Allow-Credentials', true);
    res.header('Access-Control-Allow-Origin', 'http://172.18.64.249:3000');
    next();
});
app.use(express.json());
app.use(session({
    secret: '@#$%@#$%',
    resave: 'false',
    saveUninitialized: true,
    store: sessionStore,
}));
app.use('/', router);

//open server at host:port.
var server = app.listen(port, host, ()=>{
    console.log('**********Server Started**********');
    console.log('******** http://' + host + ':' + port + '********');
});

//enroll user with typed id and pw.
router.post('/users/signup', async function(req, res){
    let userid = req.body.userid;
    let userpw = req.body.userpw;
    let rows;

    if(!userid) {
        console.log('no id is given from user.')
        res.send({userid:null, message:'Please enter your ID'});
        return;
    }
    if(!userpw) {
        console.log('no pw is given from user.')
        res.send({userid:null, message:'Please enter your ID'});
        return;
    }
    //DO enroll.
    try{
        await register(userid);
        rows = await conn.enrollUser(userid, userpw);
        res.send({userid:userid, message:'Enroll Success.'});
    } catch (err) {
        res.send({userid:null, message:'There is an error.'})
        console.log(err);
    } 
    return;
});

router.post('/users/signin', async function(req, res) {
    let userid = req.body.userid;
    let userpw = req.body.userpw;
    let rows;
    try{ //get connection and try query.
        rows = await conn.login(userid, userpw);
        user = await checkUser(userid);

        //store session. If it is failed, dont store.
        if(rows.length > 0 && user){
            req.session.loggedIn = true;
            req.session.userid = userid;
            req.session.save();
            res.send({message:'Login Success.'});
        }
        else if(!user){
            res.send({message:'The user is not enrolled.'});
            return;
        }
        else {
            res.send({message:'ID or password is wrong.'});
            return;
        }
    } //if there is an error, throw the error.
    catch (err) {
        res.send({message:'Error Occurred.'});
        console.log(err);
    }
});

router.get('/users/check', function(req, res) {
    if(req.session.loggedIn) res.send({userid:req.session.userid, loggedIn:true})
    else res.send({loggedIn:false})
});

//query a car.
router.get('/users/cars', async function(req, res){
    let model, owner;
    let isEncrypt = req.query.isEncrypt;
    if(isEncrypt && isEncrypt.toString() == 'true') {
        let encrypted = req.query.qrcode;
        let decrypted = decryptAES256(QRkey, encrypted);
        decrypted = qs.parse(decrypted);
        model = decrypted.model
        owner = decrypted.owner
    }
    else {
        model = req.query.model
        owner = req.query.owner
    }

    if(req.session.loggedIn) {
        //get query from the fabric network.
        //queryCar returns result as buffer.
        console.log(req.session.userid + " queryed a car.");
        let ans = await queryCC(req.session.userid, model, owner);
        if(!ans) res.send({message:'There is not a car with given information'});
        else res.send({result: ans});
    } else { //if user is not logged in, send nothing.
        console.log("The user is not logged in.");
        res.send({message: 'You are not logged in'});
        return;
    }
    //if query is failed, return an empty body.
    return;
});

//make qrcode with given query.
router.post('/users/cars/qrcode', async function(req, res){
    let model = req.body.model;
    let owner = req.body.owner;
    let query = 'model='+model+'&owner='+owner;

    let encrypted = host+':3000'+'/cars?qrcode='+encryptAES256(QRkey, query);
    qrcode.toDataURL(encrypted).then(url => {
        res.send(url);
    })
    return;
});

router.post('/users/cars/print', async function(req, res){
    let carid = req.body.carid;
    
    
});