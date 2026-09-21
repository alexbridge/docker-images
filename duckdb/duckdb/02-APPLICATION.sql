USE APP;

CREATE OR REPLACE TABLE APPLICATION (
    id BIGINT NOT NULL,
    application_id VARCHAR NOT NULL,
    channel VARCHAR NOT NULL,
    purpose VARCHAR NOT NULL,
    status VARCHAR NOT NULL,
    created_at TIMESTAMP NOT NULL,
    PRIMARY KEY (id)
);

-- range() is a native row generator, so no seq helper table and no CROSS JOIN ladder
-- is needed to reach 10^7 rows the way MySQL 8.0 requires
INSERT INTO
    APPLICATION (
        id,
        application_id,
        channel,
        purpose,
        status,
        created_at
    )
SELECT
    r.i + 1 AS id,
    'APP-' || lpad(CAST(r.i AS VARCHAR), 10, '0') AS application_id,
    ['WEB', 'APP', 'PARTNER', 'BRANCH'][CAST(floor(1 + random() * 4) AS INTEGER)] AS channel,
    [
        'CAR',
        'HOME',
        'RENOVATION',
        'DEBT_CONSOLIDATION',
        'OTHER'
    ][CAST(floor(1 + random() * 5) AS INTEGER)] AS purpose,
    [
        'NEW',
        'IN_REVIEW',
        'APPROVED',
        'REJECTED',
        'DISBURSED'
    ][CAST(floor(1 + random() * 5) AS INTEGER)] AS status,
    now()::TIMESTAMP - INTERVAL (r.i * 8) SECOND AS created_at
FROM
    range(getvariable('seed_rows')) AS r (i);

-- DuckDB is columnar: min/max zonemaps per row group already prune range scans on
-- created_at, so only the equality-lookup column gets an explicit ART index
CREATE UNIQUE INDEX idx_application_id ON APPLICATION (application_id);
