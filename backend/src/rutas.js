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

router.get('/consulta1',(req,res)=>{
    mysqlCon.query('SELECT CLIENTES.id_cliente, CLIENTES.nombre, CLIENTES.apellido, (PAISES.nombre) AS pais, ' +
        'ROUND(SUM(DETALLE_ORDEN.cantidad * PRODUCTOS.precio),2) AS  monto FROM ORDENES ' +
        'INNER JOIN CLIENTES ON ORDENES.fk_id_cliente = CLIENTES.id_cliente ' +
        'INNER JOIN PAISES ON CLIENTES.fk_id_pais = PAISES.id_pais ' +
        'INNER JOIN DETALLE_ORDEN ON ORDENES.id_orden = DETALLE_ORDEN.fk_id_orden ' +
        'INNER JOIN PRODUCTOS ON DETALLE_ORDEN.fk_id_producto = PRODUCTOS.id_producto ' +
        'GROUP BY fk_id_cliente ORDER BY MONTO DESC LIMIT 1 ',(err,rows,fields)=>{
        if(!err){
            console.log(rows);
            res.json({respuesta: rows});
        }else{
            console.log(err);
            return res.status(404).send("CAN'T GET REGISTERS");
        }
    });
});

router.get('/consulta2',(req,res)=>{
    mysqlCon.query('SELECT id_producto, nombre_producto, categoria, cantidad, monto FROM ( '+
        '(SELECT (PRODUCTOS.id_producto) AS id_producto, (PRODUCTOS.nombre) AS nombre_producto, '+
        '(CATEGORIAS.nombre) AS categoria, SUM(cantidad) AS cantidad, '+
        'ROUND(SUM((DETALLE_ORDEN.cantidad * PRODUCTOS.precio)),2) AS monto FROM DETALLE_ORDEN '+
        'INNER JOIN PRODUCTOS ON DETALLE_ORDEN.fk_id_producto = PRODUCTOS.id_producto '+
        'INNER JOIN CATEGORIAS ON PRODUCTOS.fk_id_categoria = CATEGORIAS.id_categoria '+
        'GROUP BY  id_producto ORDER BY cantidad ASC, monto ASC LIMIT 1) '+
    
        'UNION ALL '+
    
        '(SELECT (PRODUCTOS.id_producto) AS id_producto, (PRODUCTOS.nombre) AS nombre_producto,'+
        '(CATEGORIAS.nombre) AS categoria, SUM(cantidad) AS cantidad, '+
        'ROUND(SUM((DETALLE_ORDEN.cantidad * PRODUCTOS.precio)),2) AS monto FROM DETALLE_ORDEN '+
        'INNER JOIN PRODUCTOS ON DETALLE_ORDEN.fk_id_producto = PRODUCTOS.id_producto '+
        'INNER JOIN CATEGORIAS ON PRODUCTOS.fk_id_categoria = CATEGORIAS.id_categoria '+
        'GROUP BY  id_producto ORDER BY cantidad DESC , monto DESC LIMIT 1)'+
        ')AS consulta2',(err,rows,fields)=>{
        if(!err){
            console.log(rows);
            res.json({respuesta: rows});
        }else{
            console.log(err);
            return res.status(404).send("CAN'T GET REGISTERS");
        }
    });
});

router.get('/consulta3',(req,res)=>{
    mysqlCon.query('SELECT VENDEDORES.id_vendedor, VENDEDORES.nombre, '+
        'ROUND(SUM((DETALLE_ORDEN.cantidad * PRODUCTOS.precio)),2) AS monto FROM DETALLE_ORDEN '+
        'INNER JOIN VENDEDORES ON DETALLE_ORDEN.fk_id_vendedor = VENDEDORES.id_vendedor '+
        'INNER JOIN PRODUCTOS ON DETALLE_ORDEN.fk_id_producto = PRODUCTOS.id_producto '+
        'GROUP BY  VENDEDORES.id_vendedor ORDER BY monto DESC LIMIT 1',(err,rows,fields)=>{
        if(!err){
            console.log(rows);
            res.json({respuesta: rows});
        }else{
            console.log(err);
            return res.status(404).send("CAN'T GET REGISTERS");
        }
    });
});


router.get('/consulta4',(req,res)=>{
    mysqlCon.query('SELECT pais, monto FROM( '+
        '(SELECT (PAISES.nombre) AS pais, ROUND(SUM((DETALLE_ORDEN.cantidad * PRODUCTOS.precio)),2) AS monto '+
        'FROM DETALLE_ORDEN '+
        'INNER JOIN PRODUCTOS ON DETALLE_ORDEN.fk_id_producto = PRODUCTOS.id_producto '+
        'INNER JOIN VENDEDORES ON DETALLE_ORDEN.fk_id_vendedor = VENDEDORES.id_vendedor '+
        'INNER JOIN PAISES ON VENDEDORES.fk_id_pais = PAISES.id_pais '+
        'GROUP BY PAISES.id_pais ORDER BY monto ASC LIMIT 1) '+
        'UNION ALL '+
        '(SELECT (PAISES.nombre) AS pais, ROUND(SUM((DETALLE_ORDEN.cantidad * PRODUCTOS.precio)),2) AS monto '+
        'FROM DETALLE_ORDEN '+
        'INNER JOIN PRODUCTOS ON DETALLE_ORDEN.fk_id_producto = PRODUCTOS.id_producto '+
        'INNER JOIN VENDEDORES ON DETALLE_ORDEN.fk_id_vendedor = VENDEDORES.id_vendedor '+
        'INNER JOIN PAISES ON VENDEDORES.fk_id_pais = PAISES.id_pais '+
        'GROUP BY PAISES.id_pais ORDER BY monto DESC LIMIT 1) '+
        ')AS consulta4;',(err,rows,fields)=>{
        if(!err){
            console.log(rows);
            res.json({respuesta: rows});
        }else{
            console.log(err);
            return res.status(404).send("CAN'T GET REGISTERS");
        }
    });
});

router.get('/consulta5',(req,res)=>{
    mysqlCon.query('SELECT * FROM( '+
        'SELECT (PAISES.id_pais) AS id_pais, (PAISES.nombre) AS pais, '+
        'ROUND(SUM((DETALLE_ORDEN.cantidad * PRODUCTOS.precio)),2) AS monto FROM DETALLE_ORDEN '+
        'INNER JOIN PRODUCTOS ON DETALLE_ORDEN.fk_id_producto = PRODUCTOS.id_producto '+
        'INNER JOIN ORDENES ON DETALLE_ORDEN.fk_id_orden = ORDENES.id_orden '+
        'INNER JOIN CLIENTES ON ORDENES.fk_id_cliente = CLIENTES.id_cliente '+
        'INNER JOIN PAISES ON CLIENTES.fk_id_pais = PAISES.id_pais '+
        'GROUP BY PAISES.id_pais ORDER BY monto DESC LIMIT 5 '+
        ')AS compras_paises ORDER BY compras_paises.monto ASC;',(err,rows,fields)=>{
        if(!err){
            console.log(rows);
            res.json({respuesta: rows});
        }else{
            console.log(err);
            return res.status(404).send("CAN'T GET REGISTERS");
        }
    });
});

router.get('/consulta6',(req,res)=>{
    mysqlCon.query('SELECT categoria, cantidad FROM ( '+
        '(SELECT (CATEGORIAS.nombre) AS categoria, SUM(DETALLE_ORDEN.cantidad) AS cantidad '+
        'FROM DETALLE_ORDEN '+
        'INNER JOIN PRODUCTOS ON DETALLE_ORDEN.fk_id_producto = PRODUCTOS.id_producto '+
        'INNER JOIN CATEGORIAS ON PRODUCTOS.fk_id_categoria = CATEGORIAS.id_categoria '+
        'GROUP BY CATEGORIAS.nombre ORDER BY cantidad ASC LIMIT 1 ) '+
            'UNION ALL '+
        '(SELECT (CATEGORIAS.nombre) AS categoria, SUM(DETALLE_ORDEN.cantidad) AS cantidad '+
        'FROM DETALLE_ORDEN '+
        'INNER JOIN PRODUCTOS ON DETALLE_ORDEN.fk_id_producto = PRODUCTOS.id_producto '+
        'INNER JOIN CATEGORIAS ON PRODUCTOS.fk_id_categoria = CATEGORIAS.id_categoria '+
        'GROUP BY CATEGORIAS.nombre ORDER BY cantidad DESC LIMIT 1 ) '+
        ') AS consulta6;',(err,rows,fields)=>{
        if(!err){
            console.log(rows);
            res.json({respuesta: rows});
        }else{
            console.log(err);
            return res.status(404).send("CAN'T GET REGISTERS");
        }
    });
});

router.get('/consulta7',(req,res)=>{
    const a = 'SELECT * FROM( SELECT (PAISES.nombre) AS pais, (CATEGORIAS.nombre) AS categoria, SUM(cantidad) AS cantidad FROM DETALLE_ORDEN INNER JOIN PRODUCTOS ON DETALLE_ORDEN.fk_id_producto = PRODUCTOS.id_producto INNER JOIN CATEGORIAS ON PRODUCTOS.fk_id_categoria = CATEGORIAS.id_categoria INNER JOIN ORDENES ON DETALLE_ORDEN.fk_id_orden = ORDENES.id_orden INNER JOIN CLIENTES ON ORDENES.fk_id_cliente = CLIENTES.id_cliente INNER JOIN PAISES ON CLIENTES.fk_id_pais = PAISES.id_pais GROUP BY PAISES.nombre, CATEGORIAS.nombre ORDER BY pais, cantidad DESC ) AS consulta7 GROUP BY consulta7.pais ORDER BY consulta7.cantidad ASC;'
    mysqlCon.query(a,(err,rows,fields)=>{
        if(!err){
            console.log(rows);
            res.json({respuesta: rows});
        }else{
            console.log(err);
            return res.status(404).send("CAN'T GET REGISTERS");
        }
    });
});



router.get('/consulta8',(req,res)=>{
    mysqlCon.query('SELECT MONTH(ORDENES.fecha_orden) AS mes, '+
        'ROUND(SUM((DETALLE_ORDEN.cantidad * PRODUCTOS.precio)),2) AS monto FROM DETALLE_ORDEN '+
        'INNER JOIN ORDENES ON DETALLE_ORDEN.fk_id_orden = ORDENES.id_orden '+
        'INNER JOIN VENDEDORES ON DETALLE_ORDEN.fk_id_vendedor = VENDEDORES.id_vendedor '+
        'INNER JOIN PAISES ON VENDEDORES.fk_id_pais = PAISES.id_pais '+
        'INNER JOIN PRODUCTOS ON DETALLE_ORDEN.fk_id_producto = PRODUCTOS.id_producto '+
        'WHERE PAISES.nombre LIKE \'Inglaterra\' GROUP BY mes',(err,rows,fields)=>{
        if(!err){
            console.log(rows);
            res.json({respuesta: rows});
        }else{
            console.log(err);
            return res.status(404).send("CAN'T GET REGISTERS");
        }
    });
});

router.get('/consulta9',(req,res)=>{
    mysqlCon.query('SELECT mes, monto FROM( '+
        '(SELECT MONTH(ORDENES.fecha_orden) AS mes, '+
        'ROUND(SUM((DETALLE_ORDEN.cantidad * PRODUCTOS.precio)),2) AS monto FROM DETALLE_ORDEN '+
        'INNER JOIN ORDENES ON DETALLE_ORDEN.fk_id_orden = ORDENES.id_orden '+
        'INNER JOIN PRODUCTOS ON DETALLE_ORDEN.fk_id_producto = PRODUCTOS.id_producto '+
        'GROUP BY mes ORDER BY monto ASC LIMIT 1) '+
        'UNION ALL '+
        '(SELECT MONTH(ORDENES.fecha_orden) AS mes, '+
        'ROUND(SUM((DETALLE_ORDEN.cantidad * PRODUCTOS.precio)),2) AS monto FROM DETALLE_ORDEN '+
        'INNER JOIN ORDENES ON DETALLE_ORDEN.fk_id_orden = ORDENES.id_orden '+
        'INNER JOIN PRODUCTOS ON DETALLE_ORDEN.fk_id_producto = PRODUCTOS.id_producto '+
        'GROUP BY mes ORDER BY monto DESC LIMIT 1) '+
        ') AS consulta9;',(err,rows,fields)=>{
        if(!err){
            console.log(rows);
            res.json({respuesta: rows});
        }else{
            console.log(err);
            return res.status(404).send("CAN'T GET REGISTERS");
        }
    });
});

router.get('/consulta10',(req,res)=>{
    mysqlCon.query('SELECT (PRODUCTOS.id_producto) AS id_producto, (PRODUCTOS.nombre) AS nombre, '+
        'ROUND(SUM((DETALLE_ORDEN.cantidad * PRODUCTOS.precio)),2) AS monto FROM DETALLE_ORDEN '+
        'INNER JOIN PRODUCTOS ON DETALLE_ORDEN.fk_id_producto = PRODUCTOS.id_producto '+
        'INNER JOIN CATEGORIAS ON PRODUCTOS.fk_id_categoria = CATEGORIAS.id_categoria '+
        'WHERE CATEGORIAS.nombre LIKE \'Deportes\' GROUP BY id_producto;',(err,rows,fields)=>{
        if(!err){
            console.log(rows);
            res.json({respuesta: rows});
        }else{
            console.log(err);
            return res.status(404).send("CAN'T GET REGISTERS");
        }
    });
});

module.exports = router;