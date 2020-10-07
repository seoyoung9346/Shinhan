module.exports = async function(req, res, next){
    const kind = req.body.kind;
    try {
        var dbResult;
        //특정 정보 가져오기
        dbResult = mariaDB.getDataRequest(kind);
        //홈페이지 서버에 응답
        res.send({isSuccess: 'true', result: dbResult});
    } catch (error) {
        console.log(error);
        res.send({isSuccess: 'false', result: ""});
    }
}