-- Playground table for learning normalization, indexes, execution plans, etc.
USE MYSQL_8;

CREATE TABLE ORDERS_FLAT (
    order_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    customer_id INT UNSIGNED NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    status VARCHAR(20) NOT NULL,
    created_at DATETIME NOT NULL,
    PRIMARY KEY (order_id)
) ENGINE=InnoDB;

-- helper table to generate rows via CROSS JOIN (no native ROW_GENERATE in MySQL 8.0)
CREATE TABLE seq (i INT);
INSERT INTO seq VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);

-- bulk load tuning: single transaction avoids per-statement fsync (disk flush) on commit
SET autocommit = 0;
START TRANSACTION;

-- 8x CROSS JOIN of 10-row seq = up to 10^8 combinations, LIMIT caps actual insert count
INSERT INTO ORDERS_FLAT (customer_id, amount, status, created_at)
SELECT
    FLOOR(1 + RAND() * 100000) AS customer_id,
    ROUND(10 + (RAND() * 500), 2) AS amount,
    ELT(FLOOR(1 + RAND() * 3), 'pending', 'completed', 'refunded') AS status,
    DATE_SUB(NOW(), INTERVAL (t1.i + t2.i*10 + t3.i*100 + t4.i*1000
        + t5.i*10000 + t6.i*100000 + t7.i*1000000 + t8.i*10000000) * 8 SECOND) AS created_at
FROM seq t1
CROSS JOIN seq t2
CROSS JOIN seq t3
CROSS JOIN seq t4
CROSS JOIN seq t5
CROSS JOIN seq t6
CROSS JOIN seq t7
CROSS JOIN seq t8
LIMIT 20000000;

COMMIT;
SET autocommit = 1;

DROP TABLE seq;

-- secondary indexes built AFTER bulk load: sorted-set build on 20M rows
-- is much faster than 20M incremental B-tree (balanced tree) updates during insert
ALTER TABLE ORDERS_FLAT
    ADD INDEX idx_created_at (created_at),
    ADD INDEX idx_customer_status_created (customer_id, status, created_at);
