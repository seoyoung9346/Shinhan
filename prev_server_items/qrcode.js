const queryCC = require('../javascript/queryCC.js')
const qrcode = require('qrcode')

module.exports = async function(req, res, next){
    //키 값 파싱
    const bankCode = req.query.bankCode;
    const notiNumber = req.query.notiNumber;
    const notiChangeNum = req.query.notiChangeNum;
    
    console.log(notiChangeNum);

    qrcode.toDataURL('http://localohost:9553/bank.jsp?bankCode='+bankCode+
    '&notiNumber='+notiNumber+'&notiChangeNum='+notiChangeNum).then(url => {
        res.send({result:url});
    });
}