const queryCC = require('../javascript/queryCC.js')

module.exports = async function(req, res, next){
    if (true) { //인터페이스 ID를 확인해서 신용장 등록인지 판단해야함
        //신용장 등록일 때
        const clientNum = req.body.clientNum;
        const bankCode = req.body.bankCode;
        const notiNumber = req.body.notiNumber;
        const notiChangeNum = req.body.notiChangeNum;
        const lcNum = req.body.lcNum;
        const notiPlaceNum = req.body.notiPlaceNum;
        const enrollTime = req.body.enrollTime;
        const password = req.body.password;
        const buyBankCode = req.body.buyBankCode;

        const keyJson = {
            bankCode: bankCode,
            notiNumber: notiNumber,
            notiChangeNum: notiChangeNum,
        };
        const lcMasterJson = {
            clientNum: clientNum,
            lcNum: lcNum,
            notiPlaceNum: notiPlaceNum,
            enrollTime: enrollTime,
            buyBankCode: buyBankCode,
            password: password,
        };

        const a = {LCHeader:["aaababab"],
                   LCBody: ["abbbbbbbb"],
                   LCTail: ["ccccccc"],
        };
        let time;
        //블록체인 등록 함수 호출
        try {
            //신용장 등록 날짜 생성
            let newDate = new Date();
            time = newDate.toFormat('YYYY-MM-DD HH24:MI:SS');
            const queryResult = await queryCC.EnrollLC(keyJson, lcMasterJson, a);
            //DB에 이력 저장
            //const dbResult = mariaDB.pushData(bankCode, notiNumber, notiChangeNum, time, 'enroll', 'Y');
            res.send({respG: 000, respMsg: ""});
        } catch(error) {
            console.log(error);
            //신용장 등록이 실패했을 시 DB에 기록
            //const dbResult = mariaDB.pushData(bankCode, notiNumber, notiChangeNum, time, 'enroll', 'N');
            //실패 결과 응답
            res.send({respG: 000, respMsg: ""});
        }
    }
}