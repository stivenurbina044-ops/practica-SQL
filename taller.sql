DROP TABLE IF EXISTS Venta;
DROP TABLE IF EXISTS Producto;

CREATE TABLE Producto (
    id        INT PRIMARY KEY,
    nombre    VARCHAR(100),
    precio    DECIMAL(10,2),
    categoria VARCHAR(50)
);

CREATE TABLE Venta (
    id           INT PRIMARY KEY,
    id_producto  INT,
    cantidad     INT,
    fecha        DATE,
    FOREIGN KEY (id_producto) REFERENCES Producto(id)
);

INSERT INTO Producto (id, nombre, precio, categoria) VALUES
 (1, 'Laptop Pro 15',      3200000.00, 'Tecnologia'),
 (2, 'Mouse Inalambrico',    45000.00, 'Tecnologia'),
 (3, 'Silla Ergonomica',    650000.00, 'Hogar'),
 (4, 'Escritorio Madera',   980000.00, 'Hogar'),
 (5, 'Camiseta Basica',      39000.00, 'Ropa'),
 (6, 'Refrigerador 300L',  2100000.00, 'Electrodomesticos'),
 (7, 'Lampara LED',          25000.00, 'Hogar');

INSERT INTO Venta (id, id_producto, cantidad, fecha) VALUES
 (1, 1,  3, '2026-01-05'),
 (2, 2, 60, '2026-01-06'),
 (3, 3, 10, '2026-01-07'),
 (4, 5, 80, '2026-01-08'),
 (5, 6,  2, '2026-01-09');


CREATE TABLE productos_caros AS
SELECT nombre, precio
FROM Producto
WHERE precio > 100000;


DESCRIBE productos_caros;
SELECT p.nombre, v.cantidad, v.fecha
FROM Producto p
JOIN Venta v ON p.id = v.id_producto;



SELECT
    p.nombre,
    UPPER(p.categoria)               AS categoria,
    ROUND(p.precio, 0)               AS precio_red,
    CONCAT(p.nombre, ' - ', p.categoria) AS detalle
FROM Producto p;


SELECT nombre, precio,
    IF(precio > 100000, 'Premium', 'Estandar') AS categoria_precio
FROM Producto;

SELECT p.nombre AS producto,
    UPPER(p.categoria) AS categoria,
    v.cantidad,
    IF(v.cantidad > 50, p.precio * 0.9, p.precio) AS precio_final
FROM Producto p
JOIN Venta v ON p.id = v.id_producto;
