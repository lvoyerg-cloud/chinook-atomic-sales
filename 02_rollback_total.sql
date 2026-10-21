-- ============================================================================
-- SCRIPT 02: ERROR Y REVERSIÓN COMPLETA (ROLLBACK)
-- Autor: Louis Neil Voyer García
-- Propósito: Demostrar la propiedad de Atomicidad (Todo o Nada). Ante una
--            violación de clave foránea, la transacción entra en estado
--            'Aborted' y el ROLLBACK garantiza cero datos huérfanos.
-- ============================================================================

SELECT track_id FROM track WHERE track_id = 99999;

BEGIN;

INSERT INTO invoice (customer_id, invoice_date, billing_address, billing_city, billing_country, total)
VALUES (2, CURRENT_TIMESTAMP, 'Calle Mariscal 5-00, Zona 11', 'Quetzaltenango', 'Guatemala', 0.00)
RETURNING invoice_id \gset

INSERT INTO invoice_line (invoice_id, track_id, unit_price, quantity)
VALUES (:v_invoice_id, 4, 0.99, 1);

-- Provocar VIOLACIÓN DE FOREIGN KEY con TrackId inexistente (99999)
INSERT INTO invoice_line (invoice_id, track_id, unit_price, quantity)
VALUES (:v_invoice_id, 99999, 0.99, 1);

ROLLBACK;

SELECT * FROM invoice WHERE invoice_id = :v_invoice_id;
SELECT * FROM invoice_line WHERE invoice_id = :v_invoice_id;
