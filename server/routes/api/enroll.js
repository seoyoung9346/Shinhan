const queryCC = require('../../fabricsdk/queryCC.js')
require('date-utils');

async function Enroll(){
    //키 파싱
    let keyJson = {
        bankCode: "BANK001",
        notiNumber: "NUM001",
        notiChangeNum: "CHANGE001",
        password: "password"
    };
    let lcMasterJson = {
        clientNum: "USER001",
        lcNum: "LC001",
        notiPlaceNum: "PLC001",
        prtCnt: 1,
        enrollTime: "2020-12-06 21:00:00",
        firstPrtTime: "2020-12-07 21:32:23",
        isBuyed: false,
        lcState: "",
        password: "password",
        buyBankCode: "BANK002",
    };
    let lcValueJson = {
        lcHeader: [
            "LC Header started",
            "This is test data #001",
            "LC Header ended",],
        lcBody: [
            "LC Body started",
            "This is test body #001",
            "LC Body ended",
        ],
        lcTail: [
            "LC Tail started",
            "This is test tail #001",
            "LC Tail ended",
        ],
    };

    var newDate = new Date();
    var time = newDate.toFormat('YYYY-MM-DD HH24:MI:SS');
    keyJson.time = time;
    keyJson.type = 'inquire';
    keyJson.isSuccess = false;
    try {
        //블록체인에서 쿼리 결과를 받아옴
        const queryResult = await queryCC.EnrollLC(keyJson, lcMasterJson, lcValueJson);
        if(queryResult) {
            keyJson.isSuccess = true;
        }
        //홈페이지 서버에 응답
        //res.render('getLC', {isSuccess: false, result: queryResult, });
    } catch (error) {
        //에러 출력
        //console.log(error);
        //신용장 조회가 실패했을 시 DB에 기록
        //res.render('getLC', {isSuccess: false, result: ['failed'], });
    } finally {
        //const dbResult = await mariaDB.addLog(keyJson);
    }
}

Enroll();