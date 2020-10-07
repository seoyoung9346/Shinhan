const {pool, enrollUser, login} = require('mariaDBConn.js');

enrollUser('abc', 'abc');
enrollUser('abab', 'abab');

const conn = await pool.getConnection();
const res = await conn.query('SELECT * from users');

console.log(res);
