-- Create two databases, load identical IAM schema into each.
-- Runs against the default maintenance DB (POSTGRES_DB) on first init only.

CREATE DATABASE "MAIN";
CREATE DATABASE "SECOND";

\connect "MAIN"
\i /docker-entrypoint-initdb.d/include/iam.sql

\connect "SECOND"
\i /docker-entrypoint-initdb.d/include/iam.sql
