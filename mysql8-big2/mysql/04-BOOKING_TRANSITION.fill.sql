USE APP;

CREATE TABLE seq (i INT);
INSERT INTO seq VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);

SET autocommit = 0;
START TRANSACTION;

-- Generate 5,000,000 rows: first day of each month from Jan 2024 to Dec 2026 (~138,889 per month)
INSERT INTO BOOKING_TRANSITION (`date`, `state`)
SELECT
    DATE_ADD('2024-01-01', INTERVAL FLOOR(row_num * 36 / 5000000) MONTH) AS `date`,
    ELT(FLOOR(1 + RAND()*3), 'PENDING','PROCESSED','PROCESSING') AS `state`
FROM (
    SELECT
        (t1.i + t2.i*10 + t3.i*100 + t4.i*1000 + t5.i*10000 + t6.i*100000 + t7.i*1000000) AS row_num
    FROM seq t1
    CROSS JOIN seq t2
    CROSS JOIN seq t3
    CROSS JOIN seq t4
    CROSS JOIN seq t5
    CROSS JOIN seq t6
    CROSS JOIN seq t7
    LIMIT 5000000
) AS nums;

COMMIT;
SET autocommit = 1;
DROP TABLE seq;

