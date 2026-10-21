-- ============================================================================
-- SCRIPT 03: RECUPERACIÓN PARCIAL MEDIANTE SAVEPOINT
-- Autor: Louis Neil Voyer García
-- Propósito: Demostrar el control fino de transacciones aislando un error con
--            SAVEPOINT sin perder el trabajo previo preparado.
-- ============================================================================

BEGIN;

INSERT INTO invoice (customer_id, invoice_date, billing_address, billing_city, billing_country, total)
VALUES (3, CURRENT_TIMESTAMP, 'Ruta 4 10-20, Zona 4', 'Huehuetenango', 'Guatemala', 0.00)
RETURNING invoice_id \gset

INSERT INTO invoice_line (invoice_id, track_id, unit_price, quantity)
VALUES 
    (:v_invoice_id, 5, 0.99, 1),
    (:v_invoice_id, 6, 0.99, 2);

SAVEPOINT sp_antes_operacion_riesgosa;

-- Operación con error intencional de FK (TrackId = 88888)
INSERT INTO invoice_line (invoice_id, track_id, unit_price, quantity)
VALUES (:v_invoice_id, 88888, 0.99, 1);

ROLLBACK TO SAVEPOINT sp_antes_operacion_riesgosa;

INSERT INTO invoice_line (invoice_id, track_id, unit_price, quantity)
VALUES (:v_invoice_id, 7, 1.99, 1);

UPDATE invoice
SET total = (
    SELECT SUM(unit_price * quantity)
    FROM invoice_line
    WHERE invoice_id = :v_invoice_id
)
WHERE invoice_id = :v_invoice_id;

COMMIT;

SELECT * FROM invoice WHERE invoice_id = :v_invoice_id;
SELECT * FROM invoice_line WHERE invoice_id = :v_invoice_id;
