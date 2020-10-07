const queryCC = require('../../fabricsdk/queryCC.js')
const mariaDB = require('./mariadb-connect.js');
require('date-utils');

module.exports = async function(req, res, next){
    //키 값 파싱
    let keyJson = {
        bankCode: req.body.bankCode,
        notiNumber: req.body.notiNumber,
        notiChangeNum: req.body.notiChangeNum,
        password: req.body.password,
    };

    var newDate = new Date();
    var time = newDate.toFormat('YYYY-MM-DD HH24:MI:SS');
    keyJson.time = time;
    keyJson.type = 'inquire';
    keyJson.isSuccess = false;
    try {
        //블록체인에서 쿼리 결과를 받아옴
        const queryResult = await queryCC.GetLC(keyJson);
        if(queryResult) {
            keyJson.isSuccess = true;
        }
        //홈페이지 서버에 응답
        res.render('getLC', {isSuccess: false, result: queryResult, });
    } catch (error) {
        //에러 출력
        console.log(error);
        //신용장 조회가 실패했을 시 DB에 기록
        res.render('getLC', {isSuccess: false, result: ['aa', 'bb'], });
    } finally {
        const dbResult = await mariaDB.addLog(keyJson);
    }
}