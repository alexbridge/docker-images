USE APP;

-- helper table to generate rows via CROSS JOIN (no native ROW_GENERATE in MySQL 8.0)
CREATE TABLE seq (i INT);
INSERT INTO seq VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);

SET autocommit = 0;
START TRANSACTION;

-- 4,000 accounts (10% of 40,000) with lock=true
INSERT INTO BOOKING_LOCK (account_id, `lock`)
SELECT
    LPAD(row_num + 1, 14, '0') AS account_id,
    TRUE AS `lock`
FROM (
    SELECT
        (t1.i + t2.i * 10 + t3.i * 100 + t4.i * 1000 + t5.i * 10000) AS row_num
    FROM seq t1
    CROSS JOIN seq t2
    CROSS JOIN seq t3
    CROSS JOIN seq t4
    CROSS JOIN seq t5
    LIMIT 4000
) AS nums;

COMMIT;
SET autocommit = 1;
DROP TABLE seq;
