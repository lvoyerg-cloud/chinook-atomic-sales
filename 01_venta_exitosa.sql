-- ============================================================================
-- SCRIPT 01: VENTA EXITOSA Y PRUEBA DE VISIBILIDAD ENTRE SESIONES
-- Autor: Louis Neil Voyer García
-- Propósito: Demostrar la creación atómica de una venta con cálculo dinámico
--            de total por agregación y aislamiento de lecturas en PostgreSQL.
-- ============================================================================

BEGIN;

-- 1. Insertar la cabecera de factura asignando un CustomerId existente (ej. CustomerId = 1)
INSERT INTO invoice (customer_id, invoice_date, billing_address, billing_city, billing_country, total)
VALUES (1, CURRENT_TIMESTAMP, 'Av. Las Americas 12-34, Zona 14', 'Ciudad de Guatemala', 'Guatemala', 0.00)
RETURNING invoice_id \gset

-- 2. Insertar detalles asociados utilizando la variable capturada por psql
INSERT INTO invoice_line (invoice_id, track_id, unit_price, quantity)
VALUES 
    (:v_invoice_id, 1, 0.99, 2),  -- Subtotal: 1.98
    (:v_invoice_id, 2, 0.99, 1),  -- Subtotal: 0.99
    (:v_invoice_id, 3, 1.99, 3);  -- Subtotal: 5.97

-- 3. Recalcular el total exacto de forma dinámica sumando sus líneas
UPDATE invoice
SET total = (
    SELECT SUM(unit_price * quantity)
    FROM invoice_line
    WHERE invoice_id = :v_invoice_id
)
WHERE invoice_id = :v_invoice_id;

-- 4. Comprobación interna dentro del bloque transaccional (Sesión A)
SELECT invoice_id, customer_id, total, invoice_date 
FROM invoice 
WHERE invoice_id = :v_invoice_id;

SELECT invoice_line_id, invoice_id, track_id, unit_price, quantity 
FROM invoice_line 
WHERE invoice_id = :v_invoice_id;

COMMIT;
