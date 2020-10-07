module.exports = async function(req, res, next){
    try {
        var dbResult;
        //모든 정보 가져오기
        dbResult = mariaDB.getData();
        //홈페이지 서버에 응답
        res.send({isSuccess: 'true', result: dbResult});
    } catch (error) {
        console.log(error);
        res.send({isSuccess: 'false', result: ""});
    }
}