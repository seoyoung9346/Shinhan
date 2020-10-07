const maria = require('mariadb');

//make connection pool.
const pool = maria.createPool({
    host: 'localhost',
    user: 'shorecrab',
    password: 'shorecrab',
    connectionLimit: 5,
    database:'db',
});

var enrollUser = async function (userid, userpw) {
    let conn, rows;
    try{
        conn = await pool.getConnection();
        rows = await conn.query('INSERT INTO users value (?,?)', [userid, userpw]);
        console.log("DB Access Success.")
    } catch (err){
        throw err;
    } finally {
        if(conn) conn.release();
        return rows;
    }
}

var login = async function (userid, userpw) {
    let conn, rows;
    try {
        conn = await pool.getConnection();
        rows = await conn.query('SELECT * from users where id=? and pw=?',[userid, userpw]);
    } catch (err) {
        throw err;
    } finally {
        if(conn) conn.release();
        return rows;
    }
}

module.exports = {pool, enrollUser, login};