const maria = require('mariadb');

//make connection pool.
const pool = maria.createPool({
    host: 'localhost',
    user: 'shorecrab',
    password: 'shorecrab',
    connectionLimit: 5,
    database:'fabricLC',
});

var register = async function (userid, userpw, role) {
    let conn, rows;
    try{
        conn = await pool.getConnection();
        rows = await conn.query('INSERT INTO users value (?,?,?)', [userid, userpw, role]);
        console.log("DB Access Success.")
    } catch (err){
        throw err;
    } finally {
        if(conn) conn.release();
        return rows;
    }
}

var login = async function (userid) {
    let conn, rows;
    try {
        conn = await pool.getConnection();
        rows = await conn.query('SELECT * from users where id=?', userid);
    } catch (err) {
        throw err;
    } finally {
        if(conn) conn.release();
        return rows;
    }
}

var addLog = async function (log) {
    let conn, rows;
    try {
        conn = await pool.getConnection();
        rows = await conn.query('INSERT INTO logs (bankCode, notiNumber, notiChangeNum, time, \
            type, isSuccess) VALUES(?,?,?,?,?,?)', 
            [log.bankCode, log.notiNumber, log.notiChangeNum, log.time, log.type, log.isSuccess]);
    } catch (err) {
        throw err;
    } finally {
        if(conn) conn.release();
        return rows;
    }
}

var queryLog = async function (key) {
    let conn, rows;
    try {
        conn = await pool.getConnection();
        rows = await conn.query('SELECT * from logs where bankCode=? and notiNumber=? and notiChangeNum=?',
        Object.values(key));
    } catch (err) {
        throw err;
    } finally {
        if(conn) conn.release();
        return rows;
    }
}

module.exports = {register, login, addLog, queryLog};