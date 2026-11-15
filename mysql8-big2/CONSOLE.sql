-- @connection: New Connection (dueguoiva) [APP]
ALTER TABLE BOOKING_TRANSITION
ADD INDEX `idx_select` (date, state, eid);

ALTER TABLE BOOKING_LOCK
ADD INDEX `idx_account_lock` (`account_id`, `lock`);

ALTER TABLE BOOKING_LOCK
DROP INDEX `uq_idx_account_id`;

ALTER TABLE BOOKING
ADD INDEX `idx_tx_account` (transition_eid, account_id);

ALTER TABLE BOOKING_PARTITION
ADD INDEX `idx_account` (account_id, `partition`, type);

ALTER TABLE BOOKING_TRANSITION
DROP INDEX `idx_select`;

/*
BP -> B -> BT -> BL
The optimizer checks the transition before checking the lock.
Step	Actual rows	Time
BP lookup	632	0.41 ms
B lookup + threshold	3,759	7.95 ms
BT primary-key lookup + filter	3,759	27.2 ms total
BL anti-join	25	27.4 ms total
Result	25	27.5 ms

Only 25 lock lookups are needed instead of 3,759.
*/
SELECT
    B.account_id,
    BT.date,
    BT.state
FROM
    BOOKING_PARTITION BP
    JOIN BOOKING B ON B.account_id = BP.account_id
    JOIN BOOKING_TRANSITION BT ON BT.eid = B.transition_eid
    LEFT JOIN BOOKING_LOCK BL ON BL.account_id = B.account_id
    AND BL.lock = FALSE
WHERE
    BP.partition = 1
    AND BP.type = 'KAFKA'
    -- AND B.transition_eid >= 363007
    AND BT.date = '2026-01-01'
    AND BT.state = 'PENDING'
    AND BL.eid IS NULL
LIMIT
    100;

explain SELECT
    B.account_id,
    BT.date,
    BT.state
FROM
    BOOKING_TRANSITION BT
    JOIN BOOKING B ON B.transition_eid = BT.eid
    JOIN BOOKING_PARTITION BP ON BP.account_id = B.account_id
    AND BP.type = 'KAFKA'
    AND BP.partition = 1
    LEFT JOIN BOOKING_LOCK BL ON BL.account_id = B.account_id
WHERE
    BT.date >= '2025-01-01'
    AND BT.date <= '2026-01-01'
    -- AND BT.state IN ('PENDING', 'PROCESSING')
    AND BL.account_id IS NULL
LIMIT
    100;

SELECT B.account_id
from BOOKING B
LEFT JOIN BOOKING_PARTITION BP ON BP.account_id = B.account_id
WHERE  BP.account_id IS NULL;