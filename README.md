# 🎵 PostgreSQL Atomic Sales Transactions - Chinook Database

[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-18-blue.svg)](https://www.postgresql.org/)

Este repositorio contiene la solución e implementación de operaciones transaccionales complejas sobre la base de datos **Chinook** utilizando **PostgreSQL 18** a través de la interfaz de línea de comandos (`psql` / CMD).

El proyecto demuestra el control estricto de transacciones, la gestión de errores con `ROLLBACK`, la recuperación parcial con `SAVEPOINT` y el comportamiento de visibilidad entre sesiones concurrentes en el nivel de aislamiento **Read Committed**.

---

## 🛠️ Requisitos del Entorno

* **Motor RDBMS:** PostgreSQL 18.x
* **Cliente Interactivo:** Command Line Interface (`psql`)
* **Esquema Base:** Variante oficial `Chinook_PostgreSql_SerialPKs.sql`
* **Tablas Involucradas:** `customer`, `invoice`, `invoice_line`, `track`

---

## 🚀 Guía de Ejecución de Escenarios

| Archivo | Descripción / Propósito |
| :--- | :--- |
| `01_venta_exitosa.sql` | Ejecuta una venta completa dentro de `BEGIN ... COMMIT`. Calcula totales reales mediante `SUM()`. Contiene los pasos para la prueba de aislamiento en Sesión B. |
| `02_rollback_total.sql` | Fuerza un error de Foreign Key (`track_id` inexistente) y demuestra la reversión total (`ROLLBACK`) dejando la base de datos limpia. |
| `03_savepoint.sql` | Demuestra la recuperación parcial ante un fallo intermedio mediante `SAVEPOINT` y `ROLLBACK TO SAVEPOINT`. |
| `04_validaciones.sql` | Consultas de apoyo para validar PIDs de sesión, nivel de aislamiento y estado de secuencias. |

---

## 🧠 Fundamentación Técnica y Propiedades ACID

* **Atomicidad (Atomicity):** Demostrada en los Escenarios 2 y 3. Si ocurre una falla en un punto de la transacción, todo el bloque se descarta vía `ROLLBACK`.
* **Consistencia (Consistency):** Garantizada por la restricción de clave foránea (`FK`) entre `invoice_line` y `track`.
* **Aislamiento (Isolation):** Validado mediante el nivel **Read Committed**. La Sesión B no puede visualizar los cambios de la Sesión A hasta que esta última ejecute `COMMIT;`.
* **Durabilidad (Durability):** Tras la ejecución de `COMMIT;`, PostgreSQL asegura la escritura de la transacción en el **WAL (Write-Ahead Log)**.
