USE APP;

CREATE OR REPLACE TABLE APPLICATION_CLIENT (
    id BIGINT NOT NULL,
    application_id BIGINT NOT NULL, -- Ref: APPLICATION.id
    client_uuid VARCHAR NOT NULL,
    status VARCHAR NOT NULL,
    onboarding_flow VARCHAR NOT NULL,
    created_at TIMESTAMP NOT NULL,
    PRIMARY KEY (id)
);

-- rows are driven by APPLICATION itself, so application_id always hits an existing
-- APPLICATION.id
INSERT INTO
    APPLICATION_CLIENT (
        id,
        application_id,
        client_uuid,
        status,
        onboarding_flow,
        created_at
    )
SELECT
    a.id AS id,
    a.id AS application_id,
    -- same client_uuid for 10 consecutive APPLICATION.id values, then a new one:
    -- integer division by 10 forms the group, md5 spreads it over the UUID shape.
    -- deterministic (no uuid() per-row call) and reruns produce identical values
    regexp_replace(
        md5(CAST((a.id - 1) // 10 AS VARCHAR)),
        '^(.{8})(.{4})(.{4})(.{4})(.{12})$',
        '\1-\2-\3-\4-\5'
    ) AS client_uuid,
    [
        'NEW',
        'IDENTIFIED',
        'VERIFIED',
        'REJECTED'
    ][CAST(floor(1 + random() * 4) AS INTEGER)] AS status,
    ['VIDEOIDENT', 'POSTIDENT', 'EID'][CAST(floor(1 + random() * 3) AS INTEGER)] AS onboarding_flow,
    -- client record is created shortly after its application, never before
    a.created_at + INTERVAL (CAST(floor(random() * 600) AS BIGINT)) SECOND AS created_at
FROM
    APPLICATION a;

CREATE UNIQUE INDEX idx_client_application_id ON APPLICATION_CLIENT (application_id);

CREATE INDEX idx_client_uuid ON APPLICATION_CLIENT (client_uuid);
