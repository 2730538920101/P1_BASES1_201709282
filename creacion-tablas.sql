CREATE TABLE CATEGORIAS (
    id_categoria INT NOT NULL PRIMARY KEY ,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE PAISES(
    id_pais INT NOT NULL  PRIMARY KEY ,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE PRODUCTOS(
    id_producto INT NOT NULL PRIMARY KEY ,
    nombre VARCHAR(100) NOT NULL ,
    precio DOUBLE NOT NULL ,
    fk_id_categoria INT NOT NULL ,
    FOREIGN KEY (fk_id_categoria) REFERENCES CATEGORIAS(id_categoria)
);

CREATE TABLE VENDEDORES(
    id_vendedor INT NOT NULL PRIMARY KEY ,
    nombre VARCHAR(100) NOT NULL ,
    fk_id_pais INT NOT NULL ,
    FOREIGN KEY  (fk_id_pais) REFERENCES  PAISES(id_pais)
);

CREATE TABLE CLIENTES(
    id_cliente INT NOT NULL PRIMARY KEY ,
    nombre VARCHAR(100) NOT NULL ,
    apellido VARCHAR(100) NOT NULL ,
    direccion VARCHAR(500) NOT NULL ,
    telefono BIGINT NOT NULL ,
    tarjeta BIGINT NOT NULL ,
    edad INT NOT NULL ,
    salario DOUBLE NOT NULL ,
    genero VARCHAR(1) NOT NULL ,
    fk_id_pais INT NOT NULL ,
    FOREIGN KEY (fk_id_pais) REFERENCES PAISES(id_pais)
);

CREATE TABLE ORDENES(
    id_orden INT NOT NULL PRIMARY KEY ,
    linea_orden INT NOT NULL PRIMARY KEY ,
    fecha_orden DATE NOT NULL ,
    fk_id_cliente INT NOT NULL ,
    fk_id_vendedor INT NOT NULL ,
    fk_id_producto INT NOT NULL ,
    FOREIGN KEY (fk_id_cliente) REFERENCES CLIENTES(id_cliente),
    FOREIGN KEY (fk_id_vendedor) REFERENCES VENDEDORES(id_vendedor),
    FOREIGN KEY (fk_id_producto) REFERENCES  PRODUCTOS(id_producto)
);







