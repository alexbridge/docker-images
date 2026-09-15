USE APP;

CREATE TABLE APPLICATION_CLIENT (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    application_id BIGINT UNSIGNED NOT NULL COMMENT 'Ref: APPLICATION.id',
    client_uuid VARCHAR(36) NOT NULL,
    status VARCHAR(20) NOT NULL,
    onboarding_flow VARCHAR(20) NOT NULL,
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
    APPLICATION_CLIENT (
        application_id,
        client_uuid,
        status,
        onboarding_flow,
        created_at
    )
SELECT
    a.id AS application_id,
    -- same client_uuid for 10 consecutive APPLICATION.id values, then a new one:
    -- integer division by 10 forms the group, MD5 spreads it over the UUID shape.
    -- deterministic (no UUID() per-row call) and reruns produce identical values
    LOWER(
        INSERT(
            INSERT(
                INSERT(
                    INSERT(MD5(FLOOR((a.id - 1) / 10)), 21, 0, '-'),
                    17,
                    0,
                    '-'
                ),
                13,
                0,
                '-'
            ),
            9,
            0,
            '-'
        )
    ) AS client_uuid,
    ELT(
        FLOOR(1 + RAND() * 4),
        'NEW',
        'IDENTIFIED',
        'VERIFIED',
        'REJECTED'
    ) AS status,
    ELT(
        FLOOR(1 + RAND() * 3),
        'VIDEOIDENT',
        'POSTIDENT',
        'EID'
    ) AS onboarding_flow,
    -- client record is created shortly after its application, never before
    DATE_ADD(
        a.created_at,
        INTERVAL FLOOR(RAND() * 600) SECOND
    ) AS created_at
FROM
    APPLICATION a;

COMMIT;

SET
    autocommit = 1;

-- secondary indexes built AFTER bulk load: sorted-set build on 20M rows
-- is much faster than 20M incremental B-tree (balanced tree) updates during insert
ALTER TABLE APPLICATION_CLIENT ADD INDEX idx_created_at (created_at),
ADD INDEX idx_client_uuid (client_uuid),
ADD INDEX idx_status_created (status, created_at);