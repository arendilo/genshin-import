const mysql = require('mysql2');
require('dotenv').config();

const db = mysql.createConnection({
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'genshin_db'
});

db.connect(err => {
    if (err) {
        console.error('Failed to connect to database:', err);
    } else {
        console.log('Connected to MySQL Database');
    }
});

module.exports = db;