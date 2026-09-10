-- ════════════════════════════════════════════════════════════════════
--  GESTIÓN DE DATOS CON SQL — SCRIPT DE APOYO PARA LA EXPOSICIÓN
--  Ingeniería de Sistemas · 5 expositores
--
--  Cómo usarlo:
--  1) Abre este archivo en MySQL Workbench (o el cliente que uses).
--  2) Ejecuta el bloque "PREPARACIÓN" una sola vez, antes de exponer,
--     para tener la base de datos y las tablas con datos de ejemplo.
--  3) Durante la exposición, cada expositor ejecuta SOLO los bloques
--     de su sección (están marcados con el número de diapositiva),
--     en el mismo orden en que aparecen en el PowerPoint.
--  4) Puedes volver a ejecutar "PREPARACIÓN" en cualquier momento
--     para reiniciar la base de datos desde cero (por ejemplo, si
--     alguien ejecuta el taller y quiere dejarlo limpio de nuevo).
-- ════════════════════════════════════════════════════════════════════


-- ┌──────────────────────────────────────────────────────────────────┐
-- │  PREPARACIÓN — Ejecutar una sola vez antes de empezar             │
-- └──────────────────────────────────────────────────────────────────┘
DROP DATABASE IF EXISTS gestion_datos_sql;
CREATE DATABASE gestion_datos_sql;
USE gestion_datos_sql;


-- ════════════════════════════════════════════════════════════════════
--  EXPOSITOR 1 · DIAPOSITIVAS 5-7 · CREACIÓN DE TABLAS CON SELECT
-- ════════════════════════════════════════════════════════════════════

-- --- Tabla base "empleados" (necesaria para los ejemplos) ---
CREATE TABLE empleados (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    salario DECIMAL(10,2),
    departamento VARCHAR(50),
    fecha_nacimiento DATE
);

INSERT INTO empleados (nombre, apellido, salario, departamento, fecha_nacimiento) VALUES
('Ana',     'Ruiz',    62000, 'Departamento X', '1994-03-12'),
('Carlos',  'Gómez',   48000, 'Departamento X', '1990-07-01'),
('Beatriz', 'Torres',  71000, 'Departamento X', '1988-11-23'),
('Diego',   'Salas',   39000, 'Departamento Y', '1996-01-15'),
('Elena',   'Vargas',  55000, 'Departamento Y', '1992-09-09'),
('Felipe',  'Rojas',   45000, NULL,             '1995-05-30');

-- DIAPOSITIVA 5 · Sintaxis general (no se ejecuta, solo se explica):
--   CREATE TABLE nueva_tabla AS
--   SELECT columna1, columna2, ...
--   FROM tabla_origen
--   WHERE condicion;

-- DIAPOSITIVA 6 · Ejemplo: empleados_departamento_x
CREATE TABLE empleados_departamento_x
AS
SELECT nombre, salario
FROM empleados
WHERE departamento = 'Departamento X'
AND salario > 50000;

SELECT * FROM empleados_departamento_x;
-- Debe mostrar solo a Ana y Beatriz (Carlos gana 48000, no pasa el filtro)

-- --- Tabla base "pais" (para el ejemplo tempPais) ---
CREATE TABLE pais (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(60),
    poblacion BIGINT
);

INSERT INTO pais (nombre, poblacion) VALUES
('Colombia',   52000000),
('Ecuador',    18000000),
('Uruguay',     3500000),
('Argentina',  46000000),
('Paraguay',    7100000),
('Brasil',    216000000);

-- DIAPOSITIVA 7 · Ejemplo: tempPais (con diagrama visual)
CREATE TABLE tempPais AS
SELECT nombre, poblacion
FROM pais
WHERE poblacion <= 100000000;

SELECT * FROM tempPais;
-- Debe excluir a Brasil (216 millones), que supera el límite


-- ════════════════════════════════════════════════════════════════════
--  EXPOSITOR 2 · DIAPOSITIVAS 9-10 · ESTRUCTURA DE UNA TABLA
-- ════════════════════════════════════════════════════════════════════

-- DIAPOSITIVA 9 · DESCRIBE y DESC
DESCRIBE tempPais;
DESC tempPais;

-- DIAPOSITIVA 10 · Otras formas de ver la estructura
SHOW COLUMNS FROM tempPais;
SHOW CREATE TABLE tempPais;
SHOW TABLE STATUS LIKE 'tempPais';

-- Alternativa mencionada (no profundizar en clase):
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'gestion_datos_sql' AND TABLE_NAME = 'tempPais';

-- Cierre del bloque: volver a mostrar DESCRIBE tempPais para interpretar
DESCRIBE tempPais;


-- ════════════════════════════════════════════════════════════════════
--  EXPOSITOR 3 · DIAPOSITIVAS 12-14 · RELACIONES ENTRE TABLAS
-- ════════════════════════════════════════════════════════════════════

-- DIAPOSITIVA 12 (izquierda) · Relación 1:1 → Persona / Pasaporte
CREATE TABLE Persona (
    ID INT PRIMARY KEY,
    Nombre VARCHAR(100)
);

CREATE TABLE Pasaporte (
    ID INT PRIMARY KEY,
    ID_Persona INT UNIQUE,
    NumeroPasaporte VARCHAR(20),
    FOREIGN KEY (ID_Persona) REFERENCES Persona(ID)
);

INSERT INTO Persona VALUES (1, 'Laura Méndez'), (2, 'Jorge Peña');
INSERT INTO Pasaporte VALUES (1, 1, 'CO-1029384'), (2, 2, 'CO-2938471');

SELECT p.Nombre, pa.NumeroPasaporte
FROM Persona p
JOIN Pasaporte pa ON p.ID = pa.ID_Persona;

-- DIAPOSITIVA 12 (derecha) · Relación 1:N → Libro / Prestamo
CREATE TABLE Libro (
    ID INT PRIMARY KEY,
    Titulo VARCHAR(100),
    Autor VARCHAR(100)
);

CREATE TABLE Prestamo (
    ID INT PRIMARY KEY,
    ID_Libro INT,
    FechaPrestamo DATE,
    FechaDevolucion DATE,
    FOREIGN KEY (ID_Libro) REFERENCES Libro(ID)
);

INSERT INTO Libro VALUES
(1, 'Cien años de soledad', 'Gabriel García Márquez'),
(2, 'El Aleph', 'Jorge Luis Borges');

INSERT INTO Prestamo VALUES
(1, 1, '2026-01-10', '2026-01-24'),
(2, 1, '2026-02-02', '2026-02-16'),
(3, 2, '2026-01-15', '2026-01-29');

SELECT l.Titulo, COUNT(p.ID) AS veces_prestado
FROM Libro l
JOIN Prestamo p ON l.ID = p.ID_Libro
GROUP BY l.Titulo;
-- Muestra que "Cien años de soledad" se prestó 2 veces: 1 libro → N préstamos

-- DIAPOSITIVA 13 · Relación N:M → Estudiante / Curso / Inscripcion
CREATE TABLE Estudiante (
    ID INT PRIMARY KEY,
    Nombre VARCHAR(100)
);

CREATE TABLE Curso (
    ID INT PRIMARY KEY,
    Nombre VARCHAR(100),
    Descripcion TEXT
);

CREATE TABLE Inscripcion (
    ID_Estudiante INT,
    ID_Curso INT,
    FechaInscripcion DATE,
    PRIMARY KEY (ID_Estudiante, ID_Curso),
    FOREIGN KEY (ID_Estudiante) REFERENCES Estudiante(ID),
    FOREIGN KEY (ID_Curso) REFERENCES Curso(ID)
);

INSERT INTO Estudiante VALUES (1, 'Mariana Ospina'), (2, 'Tomás Reyes');
INSERT INTO Curso VALUES
(1, 'Bases de Datos', 'Fundamentos de SQL'),
(2, 'Redes',          'Fundamentos de redes');

INSERT INTO Inscripcion VALUES
(1, 1, '2026-02-01'),
(1, 2, '2026-02-01'),
(2, 1, '2026-02-03');

SELECT e.Nombre AS estudiante, c.Nombre AS curso
FROM Estudiante e
JOIN Inscripcion i ON e.ID = i.ID_Estudiante
JOIN Curso c ON c.ID = i.ID_Curso
ORDER BY e.Nombre;
-- Muestra cómo Inscripcion conecta cada estudiante con varios cursos

-- DIAPOSITIVA 14 · pais / ciudad (relación en MySQL Workbench)
CREATE TABLE ciudad (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(60),
    id_pais INT,
    FOREIGN KEY (id_pais) REFERENCES pais(id)
);

INSERT INTO ciudad (nombre, id_pais) VALUES
('Bucaramanga', 1),
('Bogotá',      1),
('Quito',       2),
('Montevideo',  3);

SELECT c.nombre AS ciudad, p.nombre AS pais
FROM ciudad c
JOIN pais p ON c.id_pais = p.id;
-- En MySQL Workbench: Database > Reverse Engineer para ver el diagrama EER


-- ════════════════════════════════════════════════════════════════════
--  EXPOSITOR 4 · DIAPOSITIVAS 16-19 · LLAVES FORÁNEAS, CAMPOS Y ALIAS
-- ════════════════════════════════════════════════════════════════════

-- DIAPOSITIVA 16-17 · Ya vimos FOREIGN KEY al crear la tabla (ciudad).
-- Ahora mostramos la Opción 2: agregarla con ALTER TABLE.
CREATE TABLE ciudad_sin_fk (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(60),
    id_pais INT
);

INSERT INTO ciudad_sin_fk (nombre, id_pais) VALUES ('Asunción', 5);

ALTER TABLE ciudad_sin_fk
ADD FOREIGN KEY (id_pais) REFERENCES pais(id);

-- Esto SÍ debería fallar (error de integridad referencial):
-- intenta insertar una ciudad con un país que no existe (id 999)
INSERT INTO ciudad_sin_fk (nombre, id_pais) VALUES ('Ciudad Fantasma', 999);

DROP TABLE ciudad_sin_fk; -- limpiamos la tabla de la demostración

-- DIAPOSITIVA 18 · Campos y alias
-- Necesitamos una tabla de ventas y una de departamentos para los ejemplos
CREATE TABLE ventas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    producto VARCHAR(60),
    precio DECIMAL(10,2),
    cantidad INT
);

INSERT INTO ventas (producto, precio, cantidad) VALUES
('Teclado', 80000, 3),
('Mouse',   35000, 5),
('Monitor', 620000, 2);

-- Operaciones con campos
SELECT producto, precio * cantidad AS total
FROM ventas;

-- Alias de columnas
SELECT nombre, fecha_nacimiento AS fecha_nac
FROM empleados;

-- Alias de tablas (necesitamos "departamentos" e id_departamento)
CREATE TABLE departamentos (
    id INT PRIMARY KEY,
    nombre_departamento VARCHAR(50)
);
INSERT INTO departamentos VALUES (1, 'Departamento X'), (2, 'Departamento Y');

ALTER TABLE empleados ADD COLUMN id_departamento INT;
UPDATE empleados SET id_departamento = 1 WHERE departamento = 'Departamento X';
UPDATE empleados SET id_departamento = 2 WHERE departamento = 'Departamento Y';

SELECT e.nombre, d.nombre_departamento
FROM empleados e
JOIN departamentos d
ON e.id_departamento = d.id;

-- DIAPOSITIVA 19 · Alias con JOIN y funciones de agregación
CREATE TABLE usuarios (
    id INT PRIMARY KEY,
    nombre VARCHAR(60)
);
CREATE TABLE pedidos (
    id INT PRIMARY KEY,
    usuario_id INT,
    fecha DATE
);

INSERT INTO usuarios VALUES (1, 'Camila Duarte'), (2, 'Andrés Lima');
INSERT INTO pedidos VALUES
(1, 1, '2026-03-01'),
(2, 1, '2026-03-15'),
(3, 2, '2026-03-05');

SELECT u.nombre, p.fecha
FROM usuarios AS u
JOIN pedidos AS p
ON u.id = p.usuario_id;

SELECT AVG(salario) AS salario_promedio
FROM empleados;


-- ════════════════════════════════════════════════════════════════════
--  EXPOSITOR 5 · DIAPOSITIVAS 21-23 · FUNCIONES Y COMANDOS EN CAMPOS
-- ════════════════════════════════════════════════════════════════════

-- DIAPOSITIVA 21 · Funciones de texto
SELECT CONCAT(nombre, ' ', apellido) AS nombre_completo
FROM empleados;

SELECT UPPER(nombre) AS nombre_mayusculas
FROM empleados;

SELECT LOWER(apellido) AS apellido_minusculas
FROM empleados;

SELECT nombre, LENGTH(nombre) AS longitud_nombre
FROM empleados;

SELECT apellido,
       SUBSTRING(apellido, 1, 3) AS subcadena_apellido
FROM empleados;

SELECT CONCAT('   ', nombre, '   ') AS nombre_con_espacios,
       TRIM(CONCAT('   ', nombre, '   ')) AS nombre_sin_espacios
FROM empleados;

-- DIAPOSITIVA 22 · Numéricas, de fecha y manejo de NULL
SELECT salario,
       ROUND(salario, 2) AS salario_redondeado
FROM empleados;

SELECT DATE_FORMAT(fecha_nacimiento, '%d-%m-%Y')
       AS fecha_formateada
FROM empleados;

SELECT NOW() AS fecha_hora_actual;

SELECT nombre,
       IFNULL(departamento, 'Sin asignar')
       AS departamento_asignado
FROM empleados;
-- Felipe tiene departamento NULL: debe mostrar "Sin asignar"

-- DIAPOSITIVA 23 · Comando IF en campos
CREATE TABLE productos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(60),
    precio DECIMAL(10,2)
);

INSERT INTO productos (nombre, precio) VALUES
('Silla ergonómica', 150000),
('Lámpara de escritorio', 45000),
('Escritorio ajustable', 480000);

SELECT nombre, precio,
       IF(precio > 100000, 'Premium', 'Estándar')
       AS categoria
FROM productos;

SELECT producto, cantidad,
       IF(cantidad > 3, precio * 0.9, precio)
       AS precio_con_descuento
FROM ventas;

ALTER TABLE empleados ADD COLUMN ventas INT;
ALTER TABLE empleados ADD COLUMN meta INT;
UPDATE empleados SET ventas = 120, meta = 100 WHERE nombre = 'Ana';
UPDATE empleados SET ventas = 80,  meta = 100 WHERE nombre = 'Carlos';
UPDATE empleados SET ventas = 95,  meta = 90  WHERE nombre = 'Beatriz';

SELECT nombre, ventas,
       IF(ventas > meta, 'Cumple', 'No Cumple') AS estado
FROM empleados
WHERE ventas IS NOT NULL;


-- ════════════════════════════════════════════════════════════════════
--  TALLER PRÁCTICO INTEGRADOR · DIAPOSITIVAS 24-26
--  Base de datos: una pequeña tienda (Producto / Venta)
-- ════════════════════════════════════════════════════════════════════

-- --- ENUNCIADO (mostrar solo esto mientras el grupo trabaja) ---
CREATE TABLE Producto (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    precio DECIMAL(10,2),
    categoria VARCHAR(50)
);

CREATE TABLE Venta (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_producto INT,
    cantidad INT,
    fecha DATE,
    FOREIGN KEY (id_producto) REFERENCES Producto(id)
);

INSERT INTO Producto (nombre, precio, categoria) VALUES
('Audífonos inalámbricos', 180000, 'Electrónica'),
('Mochila urbana',          95000, 'Accesorios'),
('Cámara deportiva',       650000, 'Electrónica'),
('Termo acero',             38000, 'Accesorios'),
('Parlante bluetooth',     210000, 'Electrónica');

INSERT INTO Venta (id_producto, cantidad, fecha) VALUES
(1, 2, '2026-03-01'),
(2, 5, '2026-03-02'),
(3, 1, '2026-03-03'),
(4, 8, '2026-03-04'),
(5, 3, '2026-03-05');

-- A partir de aquí, el grupo intenta resolver las 8 tareas del taller
-- (ver diapositiva 24) usando SOLO las tablas Producto y Venta de arriba.


-- --- SOLUCIONES (mostrar después de que el grupo lo intente) ---

-- 3. CREATE TABLE AS SELECT
CREATE TABLE productos_caros AS
SELECT nombre, precio
FROM Producto
WHERE precio > 100000;

-- 4. Revisar estructura
DESCRIBE productos_caros;

-- 5 y 6. Alias + funciones sobre campos
SELECT p.nombre,
       UPPER(p.categoria) AS categoria,
       ROUND(p.precio, 0) AS precio_red,
       CONCAT(p.nombre, ' - ', p.categoria) AS detalle
FROM Producto p;

-- 7. Clasificación con IF
SELECT nombre, precio,
       IF(precio > 100000, 'Premium', 'Estándar') AS categoria_precio
FROM Producto;

-- 8. Consulta final integradora (alias + JOIN + función + IF)
SELECT p.nombre AS producto,
       UPPER(p.categoria) AS categoria,
       v.cantidad,
       IF(v.cantidad > 3, p.precio * 0.9, p.precio) AS precio_final
FROM Producto p
JOIN Venta v
  ON p.id = v.id_producto;

-- ════════════════════════════════════════════════════════════════════
--  FIN DEL SCRIPT
-- ════════════════════════════════════════════════════════════════════