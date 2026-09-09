CREATE TABLE productos_prueba (
   id_producto INT,
   nombre VARCHAR(100),
   precio DECIMAL(10,2),
   stock INT,
   id_categoria INT,
   fecha_registro DATE
);

CREATE TABLE clientes (
   id_cliente INT,
   nombre VARCHAR(100),
   email VARCHAR(100),
   ciudad VARCHAR(100),
   fecha_registro DATETIME,
   acepta_promociones BOOLEAN
);

CREATE TABLe productos(
	id_producto INT PRIMARY KEY AUTO_INCREMENT,
	nombre VARCHAR(100) NOT NULL UNIQUE,
	precio DECIMAL(10,2) NOT NULL, 
	stock INT NOT NULL CHECK (stock >= 0),
	id_categoria INT,
	fecha_registro DATE DEFAULT (CURRENT_DATE),
	FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

CREATE TABLE empleados (
    id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    salario DECIMAL(10, 2) CHECK (salario >= 0),
    id_departamento INT,
    fecha_contratacion DATE,
    FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento)
);

CREATE TABLE departamentos(
	id_departamento INT PRIMARY KEY AUTO_INCREMENT,
	nombre VARCHAR(80) NOT NULL
);

DROP TABLE productos_prueba;

ALTER TABLE clientes
ADD COLUMN telefono VARCHAR(20);


ALTER TABLE empleados
	ADD COLUMN correo_corporativo VARCHAR(150);

DROP TABLE productos_prueba;

ALTER TABLE clientes
ADD COLUMN telefono VARCHAR(20);

INSERT INTO productos(
   nombre,
   precio,
   stock,
   id_categoria
)
VALUES(
   "Refrigerador Inverter 400L",
   1899.90,
   15,
   3
);

UPDATE productos
SET stock = stock - 1
WHERE id_producto = 245;

UPDATE productos
SET precio = 549.00
WHERE id_producto = 310;

DELETE FROM productos
WHERE id_producto = 118;

SELECT nombre, stock, precio

FROM productos
WHERE stock < 20
ORDER BY stock ABC;

SELECT nombre, fecha_registro
FROM clientes
WHERE ciudad = "Bogota"
ORDER BY fecha_registro DESC
LIMIT 5;



SELECT id_venta, fecha, total

FROM ventas
WHERE total > 500000
	AND fecha BETWEEN "2026-01-01" AND "2026-01-31"
ORDER BY fecha;


SELECT nombre, precio, categoria
FROM productos
WHERE categoria  IN ("Electrodomesticos", "Tecnologia")
	AND nombre LIKE "&Smart%";

SELECT 
	id_empleado
	COUNT(*) AS num_ventas,
	SUM(total) AS total_vendido
FROM ventas
GROUP BY id_empleado
ORDER BY total_vendido DESC;


