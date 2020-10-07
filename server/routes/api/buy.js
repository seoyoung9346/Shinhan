const queryCC = require('../FabricSDK/queryCC.js');

module.exports = async function(req, res, next){
    const password = req.body.password;
    const bankCode = req.body.bankCode;
    const notiNumber = req.body.notiNumber;
    const notiChangeNum = req.body.notiChangeNum;
    var time;
    try {
        const keyJson = {
            bankCode: bankCode,
            notiNumber: notiNumber,
            notiChangeNum: notiChangeNum,
            password: password,
        };

        //매입 날짜 생성
        var newDate = new Date();
        time = newDate.toFormat('YYYY-MM-DD HH24:MI:SS');

        //블록체인에서 매입함수 호출
        const queryResult = await queryCC.BuyLC(keyJson);
        //DB에 이력 저장
        //const dbResult = mariaDB.pushData(bankCode, notiNumber, notiChangeNum, time, 'buy', 'Y');
        //홈페이지 서버에 응답
        res.send({isSuccess: 'true', result : queryResult});
    } catch (error) {
        console.log(error);
        //신용장 매입이 실패했을 시 DB에 기록
        //const dbResult = mariaDB.pushData(bankCode, notiNumber, notiChangeNum, time, 'buy', 'N');
        res.render('getLC', {isSuccess: false, result: ['aa', 'bb'], });
    }
}