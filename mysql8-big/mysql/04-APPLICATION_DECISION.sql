USE APP;

CREATE TABLE APPLICATION_DECISION (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    application_id BIGINT UNSIGNED NOT NULL COMMENT 'Ref: APPLICATION.id',
    decision VARCHAR(20) NOT NULL COMMENT 'Enum: ACCEPT, REJECT, WITHDRAW',
    created_at DATETIME NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY (application_id)
) ENGINE = InnoDB;

-- bulk load tuning: single transaction avoids per-statement fsync (disk flush) on commit
SET
    autocommit = 0;

START TRANSACTION;

-- rows are driven by APPLICATION itself, so application_id always hits an existing
-- APPLICATION.id -- no dependency on AUTO_INCREMENT starting at 1 or staying gapless
INSERT INTO
    APPLICATION_DECISION (application_id, decision, created_at)
SELECT
    a.id AS application_id,
    -- decision follows the application's own status, so the two never contradict.
    -- WITHDRAW is customer-initiated and can hit any stage, hence the id-based slice
    CASE
        WHEN MOD(a.id, 20) = 0 THEN 'WITHDRAW'
        WHEN a.status = 'REJECTED' THEN 'REJECT'
        ELSE 'ACCEPT'
    END AS decision,
    -- decision lands after its application, never before
    DATE_ADD(
        a.created_at,
        INTERVAL FLOOR(60 + RAND() * 86400) SECOND
    ) AS created_at
FROM
    APPLICATION a
    -- NEW and IN_REVIEW have not been decided yet: no row at all, rather than a
    -- fabricated one. MOD(..) = 0 matches the WITHDRAW arm above so those still land
WHERE
    a.status IN ('APPROVED', 'DISBURSED', 'REJECTED')
    OR MOD(a.id, 20) = 0;

COMMIT;

SET
    autocommit = 1;

-- secondary indexes built AFTER bulk load: sorted-set build on 20M rows
-- is much faster than 20M incremental B-tree (balanced tree) updates during insert
ALTER TABLE APPLICATION_DECISION ADD INDEX idx_created_at (created_at),
ADD INDEX idx_decision_created (decision, created_at);
