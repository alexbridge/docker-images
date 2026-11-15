USE APP;

-- helper table to generate rows via CROSS JOIN (no native ROW_GENERATE in MySQL 8.0)
CREATE TABLE seq (i INT);

INSERT INTO
    seq
VALUES
    (0),
    (1),
    (2),
    (3),
    (4),
    (5),
    (6),
    (7),
    (8),
    (9);

-- bulk load tuning: single transaction avoids per-statement fsync (disk flush) on commit
SET
    autocommit = 0;

START TRANSACTION;

-- 6x CROSS JOIN = exactly 1,000,000 rows, one per BOOKING.eid
-- partition is evenly distributed 1..32 via modular arithmetic on a scrambled row number
INSERT INTO BOOKING_PARTITION (account_id, `type`, `partition`)
SELECT
    LPAD(row_num + 1, 14, '0') AS account_id,
    ELT(FLOOR(1 + RAND()*2), 'KAFKA', 'QUEUE') AS `type`,
    MOD(row_num, 32) + 1 AS `partition`
FROM (
    SELECT
        (t1.i + t2.i * 10 + t3.i * 100 + t4.i * 1000 + t5.i * 10000 + t6.i * 100000) AS row_num
    FROM seq t1
    CROSS JOIN seq t2
    CROSS JOIN seq t3
    CROSS JOIN seq t4
    CROSS JOIN seq t5
    CROSS JOIN seq t6
    LIMIT 40000
) AS nums;

COMMIT;

SET
    autocommit = 1;

DROP TABLE seq;