
LOAD DATA INFILE '/var/lib/mysql-files/archivos_entrada/categoria.csv'
INTO TABLE CATEGORIAS
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

select * FROM CATEGORIAS;

LOAD DATA INFILE '/var/lib/mysql-files/archivos_entrada/pais.csv'
INTO TABLE PAISES
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA INFILE '/var/lib/mysql-files/archivos_entrada/productos.csv'
INTO TABLE PRODUCTOS
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA INFILE '/var/lib/mysql-files/archivos_entrada/cliente.csv'
INTO TABLE CLIENTES
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA INFILE '/var/lib/mysql-files/archivos_entrada/vendedor.csv'
INTO TABLE VENDEDORES
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


LOAD DATA INFILE '/var/lib/mysql-files/archivos_entrada/orden.csv'
INTO TABLE TEMPORAL_ORDENES
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


INSERT INTO ORDENES (id_orden, fecha_orden, fk_id_cliente)
SELECT id_orden, STR_TO_DATE(fecha_orden, '%m/%d/%Y') , id_cliente FROM TEMPORAL_ORDENES
GROUP BY id_orden, fecha_orden, id_cliente;

INSERT INTO DETALLE_ORDEN (linea_orden, fk_id_producto, cantidad, fk_id_vendedor, fk_id_orden)
SELECT  linea_orden, id_producto, cantidad, id_vendedor, id_orden FROM TEMPORAL_ORDENES;

SELECT * FROM DETALLE_ORDEN;


