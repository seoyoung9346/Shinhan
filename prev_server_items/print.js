const queryCC = require('../javascript/queryCC.js')
const dateUtil = require('date-utils');

module.exports = async function(req, res, next){
    /*//키 값 파싱
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
        //출력 날짜 생성
        //var newDate = new Date();
        //var time = newDate.toFormat('YYYY-MM-DD HH24:MI:SS');
        //블록체인에서 출력 함수 호출
        var dateTime = newDate.toFormat('YYYY-MM-DD HH24:MI:SS');
        const queryResult = await queryCC.PrintLC(keyJson, dateTime);
        //DB에 이력 저장
        const dbResult = mariaDB.pushData(bankCode, notiNumber, notiChangeNum, time, 'print', 'Y');
        //홈페이지 서버에 응답
        res.send({isSuccess: 'true', result : queryResult});
    } catch (error) {
        //에러 출력
        console.log(error);
        //신용장 출력이 실패했을 시 DB에 기록
        const dbResult = mariaDB.pushData(bankCode, notiNumber, notiChangeNum, time, 'print', 'N');
        res.send({isSuccess: 'false', result : ""});
    }*/
    res.send({isSuccess: true, result : ""});
}