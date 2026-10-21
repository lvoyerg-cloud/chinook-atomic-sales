-- ============================================================================
-- SCRIPT 04: DIAGNÓSTICO DE SESIÓN Y ENTORNO
-- Autor: Louis Neil Voyer García
-- Propósito: Consultas de auditoría para verificar la versión del motor,
--            identificadores de procesos (PID), aislamiento y secuencias.
-- ============================================================================

SELECT version();
SELECT pg_backend_pid() AS id_sesion, current_user, current_database();
SHOW transaction_isolation;
SELECT last_value FROM invoice_invoice_id_seq;
