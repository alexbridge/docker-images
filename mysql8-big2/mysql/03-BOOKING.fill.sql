USE APP;

-- helper table to generate rows via CROSS JOIN (no native ROW_GENERATE in MySQL 8.0)
CREATE TABLE seq (i INT);

INSERT INTO seq VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);

SET autocommit = 0;
START TRANSACTION;

-- 6x CROSS JOIN generates exactly 1,000,000 rows
INSERT INTO BOOKING (eid, account_id, transition_eid)
SELECT
    row_num + 1 AS eid,
    LPAD(FLOOR(row_num / 25) + 1, 14, '0') AS account_id,
    MOD((row_num * 3141593) + 1234567, 5000000) + 1 AS transition_eid
FROM (
    SELECT
        (t1.i + t2.i * 10 + t3.i * 100 + t4.i * 1000 + t5.i * 10000 + t6.i * 100000) AS row_num
    FROM seq t1
    CROSS JOIN seq t2
    CROSS JOIN seq t3
    CROSS JOIN seq t4
    CROSS JOIN seq t5
    CROSS JOIN seq t6
) AS nums;

COMMIT;
SET autocommit = 1;
DROP TABLE seq;
