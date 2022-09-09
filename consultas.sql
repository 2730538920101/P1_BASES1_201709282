# CONSULTA 1 Mostrar el cliente que más ha comprado.
# Se debe de mostrar el id del cliente, nombre, apellido, país y monto total.

SELECT CLIENTES.id_cliente, CLIENTES.nombre, CLIENTES.apellido, (PAISES.nombre) AS pais ,
ROUND(SUM(DETALLE_ORDEN.cantidad * PRODUCTOS.precio),2) AS  monto FROM ORDENES
INNER JOIN CLIENTES ON ORDENES.fk_id_cliente = CLIENTES.id_cliente
INNER JOIN PAISES ON CLIENTES.fk_id_pais = PAISES.id_pais
INNER JOIN DETALLE_ORDEN ON ORDENES.id_orden = DETALLE_ORDEN.fk_id_orden
INNER JOIN PRODUCTOS ON DETALLE_ORDEN.fk_id_producto = PRODUCTOS.id_producto
GROUP BY fk_id_cliente ORDER BY MONTO DESC LIMIT 1;

# CONSULTA 2 Mostrar el producto más y menos comprado.
# Se debe mostrar el id del producto, nombre del producto, categoría, cantidad de unidades y monto vendido.

SELECT id_producto, nombre_producto, categoria, cantidad, monto FROM (
    (SELECT (PRODUCTOS.id_producto) AS id_producto, (PRODUCTOS.nombre) AS nombre_producto,
    (CATEGORIAS.nombre) AS categoria, SUM(cantidad) AS cantidad,
    ROUND(SUM((DETALLE_ORDEN.cantidad * PRODUCTOS.precio)),2) AS monto FROM DETALLE_ORDEN
    INNER JOIN PRODUCTOS ON DETALLE_ORDEN.fk_id_producto = PRODUCTOS.id_producto
    INNER JOIN CATEGORIAS ON PRODUCTOS.fk_id_categoria = CATEGORIAS.id_categoria
    GROUP BY  id_producto ORDER BY cantidad ASC, monto ASC LIMIT 1)

    UNION ALL

    (SELECT (PRODUCTOS.id_producto) AS id_producto, (PRODUCTOS.nombre) AS nombre_producto,
    (CATEGORIAS.nombre) AS categoria, SUM(cantidad) AS cantidad,
    ROUND(SUM((DETALLE_ORDEN.cantidad * PRODUCTOS.precio)),2) AS monto FROM DETALLE_ORDEN
    INNER JOIN PRODUCTOS ON DETALLE_ORDEN.fk_id_producto = PRODUCTOS.id_producto
    INNER JOIN CATEGORIAS ON PRODUCTOS.fk_id_categoria = CATEGORIAS.id_categoria
    GROUP BY  id_producto ORDER BY cantidad DESC, monto DESC LIMIT 1)
)AS consulta2;

# CONSULTA 3 Mostrar a la persona que más ha vendido.
# Se debe mostrar el id del vendedor, nombre del vendedor, monto total vendido.

SELECT VENDEDORES.id_vendedor, VENDEDORES.nombre,
ROUND(SUM((DETALLE_ORDEN.cantidad * PRODUCTOS.precio)),2) AS monto FROM DETALLE_ORDEN
INNER JOIN VENDEDORES ON DETALLE_ORDEN.fk_id_vendedor = VENDEDORES.id_vendedor
INNER JOIN PRODUCTOS ON DETALLE_ORDEN.fk_id_producto = PRODUCTOS.id_producto
GROUP BY  VENDEDORES.id_vendedor ORDER BY monto DESC LIMIT 1;

# CONSULTA 4 Mostrar el país que más y menos ha vendido.
# Debe mostrar el nombre del país y el monto. (Una sola consulta).

SELECT pais, monto FROM(
    (SELECT (PAISES.nombre) AS pais, ROUND(SUM((DETALLE_ORDEN.cantidad * PRODUCTOS.precio)),2) AS monto
     FROM DETALLE_ORDEN
     INNER JOIN PRODUCTOS ON DETALLE_ORDEN.fk_id_producto = PRODUCTOS.id_producto
     INNER JOIN VENDEDORES ON DETALLE_ORDEN.fk_id_vendedor = VENDEDORES.id_vendedor
     INNER JOIN PAISES ON VENDEDORES.fk_id_pais = PAISES.id_pais
     GROUP BY PAISES.id_pais ORDER BY monto ASC LIMIT 1)
    UNION ALL
    (SELECT (PAISES.nombre) AS pais, ROUND(SUM((DETALLE_ORDEN.cantidad * PRODUCTOS.precio)),2) AS monto
     FROM DETALLE_ORDEN
     INNER JOIN PRODUCTOS ON DETALLE_ORDEN.fk_id_producto = PRODUCTOS.id_producto
     INNER JOIN VENDEDORES ON DETALLE_ORDEN.fk_id_vendedor = VENDEDORES.id_vendedor
     INNER JOIN PAISES ON VENDEDORES.fk_id_pais = PAISES.id_pais
     GROUP BY PAISES.id_pais ORDER BY monto DESC LIMIT 1)
)AS consulta4;

# CONSULTA 5 Top 5 de países que más han comprado en orden ascendente.
# Se le solicita mostrar el id del país, nombre y monto total.

SELECT * FROM(
SELECT (PAISES.id_pais) AS id_pais, (PAISES.nombre) AS pais,
ROUND(SUM((DETALLE_ORDEN.cantidad * PRODUCTOS.precio)),2) AS monto FROM DETALLE_ORDEN
INNER JOIN PRODUCTOS ON DETALLE_ORDEN.fk_id_producto = PRODUCTOS.id_producto
INNER JOIN ORDENES ON DETALLE_ORDEN.fk_id_orden = ORDENES.id_orden
INNER JOIN CLIENTES ON ORDENES.fk_id_cliente = CLIENTES.id_cliente
INNER JOIN PAISES ON CLIENTES.fk_id_pais = PAISES.id_pais
GROUP BY PAISES.id_pais ORDER BY monto DESC LIMIT 5
)AS compras_paises ORDER BY compras_paises.monto ASC;

# CONSULTA 6 Mostrar la categoría que más y menos se ha comprado.
# Debe de mostrar el nombre de la categoría y cantidad de unidades. (Una sola consulta).

SELECT categoria, cantidad FROM (
(SELECT (CATEGORIAS.nombre) AS categoria, SUM(DETALLE_ORDEN.cantidad) AS cantidad
FROM DETALLE_ORDEN
INNER JOIN PRODUCTOS ON DETALLE_ORDEN.fk_id_producto = PRODUCTOS.id_producto
INNER JOIN CATEGORIAS ON PRODUCTOS.fk_id_categoria = CATEGORIAS.id_categoria
GROUP BY CATEGORIAS.nombre ORDER BY cantidad ASC LIMIT 1 )
    UNION ALL
(SELECT (CATEGORIAS.nombre) AS categoria, SUM(DETALLE_ORDEN.cantidad) AS cantidad
FROM DETALLE_ORDEN
INNER JOIN PRODUCTOS ON DETALLE_ORDEN.fk_id_producto = PRODUCTOS.id_producto
INNER JOIN CATEGORIAS ON PRODUCTOS.fk_id_categoria = CATEGORIAS.id_categoria
GROUP BY CATEGORIAS.nombre ORDER BY cantidad DESC LIMIT 1 )
) AS consulta6;

# CONSULTA 7 Mostrar la categoría más comprada por cada país.
# Se debe de mostrar el nombre del país, nombre de la categoría y cantidad de unidades.
SELECT * FROM(
SELECT (PAISES.nombre) AS pais, (CATEGORIAS.nombre) AS categoria,
SUM(cantidad) AS cantidad FROM DETALLE_ORDEN
INNER JOIN PRODUCTOS ON DETALLE_ORDEN.fk_id_producto = PRODUCTOS.id_producto
INNER JOIN CATEGORIAS ON PRODUCTOS.fk_id_categoria = CATEGORIAS.id_categoria
INNER JOIN VENDEDORES ON DETALLE_ORDEN.fk_id_vendedor = VENDEDORES.id_vendedor
INNER JOIN PAISES ON VENDEDORES.fk_id_pais = PAISES.id_pais
GROUP BY PAISES.nombre, CATEGORIAS.nombre ORDER BY pais, cantidad DESC
) AS consulta7 GROUP BY pais;

# CONSULTA 8 Mostrar las ventas por mes de Inglaterra.
# Debe de mostrar el número del mes y el monto.

SELECT MONTH(ORDENES.fecha_orden) AS mes,
ROUND(SUM((DETALLE_ORDEN.cantidad * PRODUCTOS.precio)),2) AS monto FROM DETALLE_ORDEN
INNER JOIN ORDENES ON DETALLE_ORDEN.fk_id_orden = ORDENES.id_orden
INNER JOIN VENDEDORES ON DETALLE_ORDEN.fk_id_vendedor = VENDEDORES.id_vendedor
INNER JOIN PAISES ON VENDEDORES.fk_id_pais = PAISES.id_pais
INNER JOIN PRODUCTOS ON DETALLE_ORDEN.fk_id_producto = PRODUCTOS.id_producto
WHERE PAISES.nombre LIKE 'Inglaterra'
GROUP BY mes;

# CONSULTA 9 Mostrar el mes con más y menos ventas.
# Se debe de mostrar el número de mes y monto. (Una sola consulta).
SELECT mes, monto FROM(
(SELECT MONTH(ORDENES.fecha_orden) AS mes,
ROUND(SUM((DETALLE_ORDEN.cantidad * PRODUCTOS.precio)),2) AS monto FROM DETALLE_ORDEN
INNER JOIN ORDENES ON DETALLE_ORDEN.fk_id_orden = ORDENES.id_orden
INNER JOIN PRODUCTOS ON DETALLE_ORDEN.fk_id_producto = PRODUCTOS.id_producto
GROUP BY mes ORDER BY monto ASC LIMIT 1)
UNION ALL
(SELECT MONTH(ORDENES.fecha_orden) AS mes,
ROUND(SUM((DETALLE_ORDEN.cantidad * PRODUCTOS.precio)),2) AS monto FROM DETALLE_ORDEN
INNER JOIN ORDENES ON DETALLE_ORDEN.fk_id_orden = ORDENES.id_orden
INNER JOIN PRODUCTOS ON DETALLE_ORDEN.fk_id_producto = PRODUCTOS.id_producto
GROUP BY mes ORDER BY monto DESC LIMIT 1)
) AS consulta9;

# CONSULTA 10 Mostrar las ventas de cada producto de la categoría deportes.
# Se debe de mostrar el id del producto, nombre y monto.

SELECT (PRODUCTOS.id_producto) AS id_producto, (PRODUCTOS.nombre) AS nombre,
ROUND(SUM((DETALLE_ORDEN.cantidad * PRODUCTOS.precio)),2) AS monto FROM DETALLE_ORDEN
INNER JOIN PRODUCTOS ON DETALLE_ORDEN.fk_id_producto = PRODUCTOS.id_producto
INNER JOIN CATEGORIAS ON PRODUCTOS.fk_id_categoria = CATEGORIAS.id_categoria
WHERE CATEGORIAS.nombre LIKE 'Deportes'
GROUP BY id_producto



