const queryCC = require('../../fabricsdk/queryCC.js')
const mariaDB = require('./mariadb-connect.js');

module.exports = async function(req, res, next){
    try {   
            const dbResult = await mariaDB.login(req.body.userid);
            if(dbResult[0].userpw === req.body.userpw && dbResult[0].role === 'admin') {
                res.redirect('/logs');
                return;
            }
            else {
                res.redirect('/admin');
            }
    } catch (error) {
        res.redirect('/admin');
    }
}