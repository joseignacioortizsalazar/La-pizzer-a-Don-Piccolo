-- ============================================================
-- BASE DE DATOS: PIZZERÍA DON PICCOLO
-- EXAMEN: GESTIÓN DE VENTAS
-- ============================================================

-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS don_piccolo;

-- Seleccionar la base de datos
USE don_piccolo;


-- ============================================================
-- 1. TABLA: ventas
-- Registra la información general de cada venta.
-- ============================================================

CREATE TABLE ventas (
    id_venta INT AUTO_INCREMENT PRIMARY KEY,
    fecha_venta DATE DEFAULT (CURRENT_DATE),
    total_venta DECIMAL(10,2) NOT NULL,
    metodo_pago ENUM('Efectivo', 'Tarjeta', 'Transferencia') NOT NULL,
    sede VARCHAR(50) NOT NULL
);


-- ============================================================
-- 2. TABLA: detalle_venta
-- Registra los productos incluidos en cada venta.
-- Una venta puede tener varios productos.
-- ============================================================

CREATE TABLE detalle_venta (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_venta INT NOT NULL,
    producto VARCHAR(100) NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,

    -- Relación entre detalle_venta y ventas
    CONSTRAINT fk_detalle_venta
        FOREIGN KEY (id_venta)
        REFERENCES ventas(id_venta)
);


-- ============================================================
-- 3. TRIGGER: validar_total_venta
-- Verifica que el total de una venta sea mayor que cero.
-- Si el total es 0 o negativo, se genera un error.
-- ============================================================

DELIMITER $$

CREATE TRIGGER validar_total_venta
BEFORE INSERT ON ventas
FOR EACH ROW
BEGIN

    IF NEW.total_venta <= 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'El total de la venta debe ser mayor que cero';

    END IF;

END$$

DELIMITER ;


-- ============================================================
-- 4. INSERTAR DATOS DE PRUEBA
-- Estos datos permiten comprobar las consultas y el trigger.
-- ============================================================

INSERT INTO ventas
(fecha_venta, total_venta, metodo_pago, sede)
VALUES
(CURDATE(), 45000.00, 'Efectivo', 'San Gil'),
(CURDATE(), 78000.00, 'Tarjeta', 'San Gil'),
(CURDATE(), 52000.00, 'Transferencia', 'Socorro'),
(CURDATE(), 95000.00, 'Tarjeta', 'San Gil'),
('2026-09-24', 60000.00, 'Efectivo', 'Socorro'),
('2026-09-24', 85000.00, 'Tarjeta', 'San Gil');


-- ============================================================
-- 5. INSERTAR DETALLES DE LAS VENTAS
-- Cada registro representa un producto de una venta.
-- ============================================================

INSERT INTO detalle_venta
(id_venta, producto, cantidad, precio_unitario)
VALUES
(1, 'Pizza Hawaiana', 2, 22500.00),
(2, 'Pizza Pepperoni', 2, 39000.00),
(3, 'Pizza Vegetariana', 2, 26000.00),
(4, 'Pizza Especial', 1, 95000.00),
(5, 'Pizza Margarita', 2, 30000.00),
(6, 'Pizza Carnes', 1, 85000.00);


-- ============================================================
-- 6. CONSULTA DE VENTAS DEL DÍA
-- Muestra las ventas realizadas en la fecha actual.
-- Se ordenan de mayor a menor según el total.
-- ============================================================

SELECT
    id_venta,
    sede,
    metodo_pago,
    total_venta
FROM ventas
WHERE fecha_venta = CURDATE()
ORDER BY total_venta DESC;


-- ============================================================
-- 7. CONSULTA DE RESUMEN DIARIO
-- Muestra:
-- - Total recaudado por día
-- - Cantidad de pedidos
-- - Promedio de cada pedido
-- ============================================================

SELECT
    fecha_venta,
    SUM(total_venta) AS total_dia,
    COUNT(id_venta) AS pedidos_dia,
    AVG(total_venta) AS promedio_pedido
FROM ventas
GROUP BY fecha_venta
ORDER BY fecha_venta DESC;


-- ============================================================
-- 8. VISTA: vista_ventas_sedes
-- Resume las ventas realizadas en cada sede.
-- ============================================================

CREATE VIEW vista_ventas_sedes AS
SELECT
    sede,
    COUNT(id_venta) AS cantidad_pedidos,
    SUM(total_venta) AS total_recaudado
FROM ventas
GROUP BY sede;


-- ============================================================
-- 9. CONSULTAR LA VISTA DE VENTAS POR SEDE
-- ============================================================

SELECT *
FROM vista_ventas_sedes;


-- ============================================================
-- 10. CONSULTAS ADICIONALES PARA ANÁLISIS
-- Estas consultas ayudan a identificar los días más activos
-- y los montos generados.
-- ============================================================

-- Día con mayor cantidad de pedidos
SELECT
    fecha_venta,
    COUNT(id_venta) AS pedidos_dia
FROM ventas
GROUP BY fecha_venta
ORDER BY pedidos_dia DESC;


-- Día con mayor recaudación
SELECT
    fecha_venta,
    SUM(total_venta) AS total_dia
FROM ventas
GROUP BY fecha_venta
ORDER BY total_dia DESC;


-- Total general de ventas
SELECT
    SUM(total_venta) AS total_general
FROM ventas;


-- Promedio general de los pedidos
SELECT
    AVG(total_venta) AS promedio_general
FROM ventas;

select * from ventas
select * from ventas