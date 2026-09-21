-- Repro table for MySQL-ported mixed-case identifiers.
-- Loaded into each target DB via \i from 01-init.sql, after iam.sql.

SET search_path TO "IAM";

--
-- TestMixedCase
-- Table and column names keep their original camelCase, so every reference
-- must be double-quoted: unquoted `SELECT Id FROM TestMixedCase` is folded
-- to lowercase by Postgres and fails with "column id does not exist".
--
CREATE TABLE "TestMixedCase" (
  "Id"   serial PRIMARY KEY,
  "Name" varchar(255) NOT NULL
);

INSERT INTO "TestMixedCase" ("Id", "Name") VALUES
  (1, 'Alpha'),
  (2, 'Beta'),
  (3, 'Gamma'),
  (4, 'Delta'),
  (5, 'Epsilon');

SELECT setval(pg_get_serial_sequence('"IAM"."TestMixedCase"','Id'), (SELECT max("Id") FROM "TestMixedCase"));
