const express = require('express');
const router = express.Router();
const mysql = require('mysql2');
require("dotenv").config();

const mysqlCon = mysql.createConnection({
    host: process.env.DATABASE_HOST,
    user: process.env.DATABASE_USER,
    password: process.env.DATABASE_PASSWORD,
    database: process.env.DATABASE_NAME,
    port: process.env.DATABASE_PORT,
    ssl: {
        rejectUnauthorized: false
      }
});

mysqlCon.connect((err)=>{
    if(!err){
        console.log("DATABASE CONNECTION SUCCEDED")
    }else{
        console.log("CONNECTION FAILED\n ERROR: "+JSON.stringify(err,undefined,2));
    }
})


module.exports = router;