USE APP;

CREATE OR REPLACE TABLE APPLICATION_DECISION (
    id BIGINT NOT NULL,
    application_id BIGINT NOT NULL, -- Ref: APPLICATION.id
    decision VARCHAR NOT NULL, -- Enum: ACCEPT, REJECT, WITHDRAW
    created_at TIMESTAMP NOT NULL,
    PRIMARY KEY (id)
);

INSERT INTO
    APPLICATION_DECISION (id, application_id, decision, created_at)
SELECT
    a.id AS id,
    a.id AS application_id,
    -- decision follows the application's own status, so the two never contradict.
    -- WITHDRAW is customer-initiated and can hit any stage, hence the id-based slice
    CASE
        WHEN a.id % 20 = 0 THEN 'WITHDRAW'
        WHEN a.status = 'REJECTED' THEN 'REJECT'
        ELSE 'ACCEPT'
    END AS decision,
    -- decision lands after its application, never before
    a.created_at + INTERVAL (CAST(floor(60 + random() * 86400) AS BIGINT)) SECOND AS created_at
FROM
    APPLICATION a
    -- NEW and IN_REVIEW have not been decided yet: no row at all, rather than a
    -- fabricated one. % 20 = 0 matches the WITHDRAW arm above so those still land
WHERE
    a.status IN ('APPROVED', 'DISBURSED', 'REJECTED')
    OR a.id % 20 = 0;

CREATE UNIQUE INDEX idx_decision_application_id ON APPLICATION_DECISION (application_id);
