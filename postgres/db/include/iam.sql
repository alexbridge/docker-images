-- IAM schema + seed data, converted from MySQL dump to PostgreSQL.
-- Database-agnostic: loaded into each target DB via \i from 01-init.sql.

CREATE SCHEMA "IAM";
SET search_path TO "IAM";

--
-- TENANT
--
CREATE TABLE "TENANT" (
  id          serial PRIMARY KEY,
  created_at  timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  uid         varchar(21)  NOT NULL,
  name        varchar(255) NOT NULL,
  lang        varchar(10),
  CONSTRAINT "IDX_0ee4ebe26e70aca9c77fee8be3" UNIQUE (uid)
);
CREATE INDEX tenant_created_idx ON "TENANT" (created_at);

INSERT INTO "TENANT" VALUES (1,'2026-06-29 13:41:41','2026-06-29 13:41:41','tenant_uid_1','Main Office','en');

--
-- TENANT_GROUP
--
CREATE TABLE "TENANT_GROUP" (
  id          serial PRIMARY KEY,
  created_at  timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  uid         varchar(21)  NOT NULL,
  tenant_id   int NOT NULL,
  name        varchar(255) NOT NULL,
  code        varchar(30)  NOT NULL,
  CONSTRAINT "IDX_dae9c8c613f43a205c27372602" UNIQUE (uid)
);
CREATE INDEX tenant_group_created_idx ON "TENANT_GROUP" (created_at);
CREATE INDEX tenant_group_tenant_id_idx ON "TENANT_GROUP" (tenant_id);

INSERT INTO "TENANT_GROUP" VALUES (1,'2026-06-29 13:41:41','2026-06-29 13:41:41','1b13b74edb2e1bcb',1,'Director','SUPER_ADMIN'),(2,'2026-06-29 13:41:41','2026-06-29 13:41:41','5f481e510e0bd1f3',1,'Admin','ADMIN'),(3,'2026-06-29 13:41:41','2026-06-29 13:41:41','3e20181fff51365d',1,'Manager','MANAGER'),(4,'2026-06-29 13:41:41','2026-06-29 13:41:41','344c8de9762b2589',1,'Engineering Leads','ENG_LEAD'),(5,'2026-06-29 13:41:41','2026-06-29 13:41:41','954bc4aceb6e06ef',1,'HR Staff','HR_STAFF'),(6,'2026-06-29 13:41:41','2026-06-29 13:41:41','313a4abedf9f51b6',1,'Employee','EMPLOYEE');

--
-- TENANT_GROUP_USER
--
CREATE TABLE "TENANT_GROUP_USER" (
  id              serial PRIMARY KEY,
  tenant_group_id int NOT NULL,
  user_id         int NOT NULL,
  CONSTRAINT "IDX_5252a3243e6ac83d4404b761a0" UNIQUE (tenant_group_id, user_id)
);

INSERT INTO "TENANT_GROUP_USER" VALUES (1,1,1),(2,2,1),(4,2,2),(3,3,1),(5,3,2),(7,3,3),(10,3,5),(6,4,2),(11,4,6),(8,5,3),(15,5,10),(9,6,4),(12,6,7),(13,6,8),(14,6,9);

--
-- TENANT_TEAM
--
CREATE TABLE "TENANT_TEAM" (
  id          serial PRIMARY KEY,
  created_at  timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  uid         varchar(21)  NOT NULL,
  tenant_id   int NOT NULL,
  name        varchar(255) NOT NULL,
  CONSTRAINT "IDX_94226c6dc4312b09ef1d559040" UNIQUE (uid)
);
CREATE INDEX tenant_team_created_idx ON "TENANT_TEAM" (created_at);
CREATE INDEX tenant_team_tenant_id_idx ON "TENANT_TEAM" (tenant_id);

INSERT INTO "TENANT_TEAM" VALUES (1,'2026-06-29 13:41:41','2026-06-29 13:41:41','team_uid_1',1,'Team 1'),(2,'2026-06-29 13:41:41','2026-06-29 13:41:41','team_uid_2',1,'Team 2');

--
-- TENANT_USER
--
CREATE TABLE "TENANT_USER" (
  id              serial PRIMARY KEY,
  created_at      timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  uid             varchar(21)  NOT NULL,
  tenant_id       int NOT NULL,
  user_id         int,
  team_id         int,
  full_name       varchar(255) NOT NULL,
  employment_type varchar(50),
  employment_term varchar(50),
  job_title       varchar(255),
  birth_date      date,
  joined_at       timestamptz,
  lang            varchar(10),
  details         jsonb,
  CONSTRAINT "IDX_3c9fe8412d5b0b0f16277d6dba" UNIQUE (uid),
  CONSTRAINT "IDX_e6e414e6fdfb3461046bbaef7d" UNIQUE (tenant_id, user_id),
  CONSTRAINT "FK_5fdb826e71db5da24f554942838" FOREIGN KEY (team_id) REFERENCES "TENANT_TEAM" (id)
);
CREATE INDEX tenant_user_created_idx ON "TENANT_USER" (created_at);
CREATE INDEX tenant_user_tenant_id_idx ON "TENANT_USER" (tenant_id);
CREATE INDEX tenant_user_user_id_idx ON "TENANT_USER" (user_id);
CREATE INDEX tenant_user_team_id_idx ON "TENANT_USER" (team_id);

INSERT INTO "TENANT_USER" VALUES (1,'2026-06-29 13:41:41','2026-06-29 13:41:41','tenant-user-1',1,1,1,'Tenant Director','Employee','Permanent','Director','1980-01-01','2026-06-29 13:41:41','en',NULL),(2,'2026-06-29 13:41:41','2026-06-29 13:41:41','tenant-user-2',1,2,1,'John Doe','Employee','Permanent','Software Engineer','1990-05-15','2026-06-29 13:41:41','en',NULL),(3,'2026-06-29 13:41:41','2026-06-29 13:41:41','tenant-user-3',1,3,1,'Jane Smith','Employee','Permanent','HR Manager','1985-03-20','2026-06-29 13:41:41','en',NULL),(4,'2026-06-29 13:41:41','2026-06-29 13:41:41','tenant-user-4',1,4,1,'Bob Wilson','Freelancer','Temporary','Designer','1992-07-10','2026-06-29 13:41:41','en',NULL),(5,'2026-06-29 13:41:41','2026-06-29 13:41:41','tenant-user-5',1,5,1,'Alice Johnson','Employee','Permanent','Marketing Lead','1988-11-25','2026-06-29 13:41:41','en',NULL),(6,'2026-06-29 13:41:41','2026-06-29 13:41:41','tenant-user-6',1,6,2,'Charlie Brown','Employee','Permanent','Backend Developer','1993-02-14','2026-06-29 13:41:41','en',NULL),(7,'2026-06-29 13:41:41','2026-06-29 13:41:41','tenant-user-7',1,7,2,'Diana Prince','Employee','Permanent','Financial Analyst','1987-09-08','2026-06-29 13:41:41','en',NULL),(8,'2026-06-29 13:41:41','2026-06-29 13:41:41','tenant-user-8',1,8,2,'Edward Kim','Employee','Permanent','Sales Manager','1991-04-30','2026-06-29 13:41:41','en',NULL),(9,'2026-06-29 13:41:41','2026-06-29 13:41:41','tenant-user-9',1,9,2,'Fiona Garcia','Freelancer','Temporary','Content Writer','1995-12-03','2026-06-29 13:41:41','en',NULL),(10,'2026-06-29 13:41:41','2026-06-29 13:41:41','tenant-user-10',1,10,2,'George Miller','Employee','Permanent','HR Specialist','1989-06-18','2026-06-29 13:41:41','en',NULL);

--
-- TENANT_USER_AUTHENTICATOR
--
CREATE TABLE "TENANT_USER_AUTHENTICATOR" (
  id                serial PRIMARY KEY,
  created_at        timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at        timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  tenant_user_id    int NOT NULL,
  secret_enc        varchar(255),
  enabled           smallint NOT NULL DEFAULT 0,
  last_consumed_step bigint,
  account_label     varchar(14) NOT NULL,
  CONSTRAINT tenant_user_authenticator_tenant_user_id_uidx UNIQUE (tenant_user_id),
  CONSTRAINT tenant_user_authenticator_account_label_uidx UNIQUE (account_label)
);
CREATE INDEX tenant_user_authenticator_created_idx ON "TENANT_USER_AUTHENTICATOR" (created_at);

--
-- TENANT_USER_OTP
--
CREATE TABLE "TENANT_USER_OTP" (
  id             serial PRIMARY KEY,
  created_at     timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at     timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  uid            varchar(21) NOT NULL,
  tenant_user_id int NOT NULL,
  code           varchar(50) NOT NULL,
  account_label  varchar(14) NOT NULL,
  origin         varchar(32) NOT NULL,
  active         smallint NOT NULL DEFAULT 1,
  CONSTRAINT "IDX_49fb8b44e6d3f674d553534c4c" UNIQUE (uid),
  CONSTRAINT "IDX_51fca95efb81599c1d59a00174" UNIQUE (code),
  CONSTRAINT "IDX_b741ea41d662766bc8e41588de" UNIQUE (account_label)
);
CREATE INDEX tenant_user_otp_created_idx ON "TENANT_USER_OTP" (created_at);
CREATE INDEX tenant_user_otp_tenant_user_id_idx ON "TENANT_USER_OTP" (tenant_user_id);
CREATE INDEX tenant_user_otp_origin_active_idx ON "TENANT_USER_OTP" (origin);

--
-- TENANT_USER_TOKEN
--
CREATE TABLE "TENANT_USER_TOKEN" (
  id             serial PRIMARY KEY,
  tenant_user_id int NOT NULL,
  token_id       varchar(255) NOT NULL,
  expired_at     timestamptz NOT NULL,
  CONSTRAINT "FK_554a2eeb859cda8af561575fb3a" FOREIGN KEY (tenant_user_id) REFERENCES "TENANT_USER" (id)
);
CREATE INDEX tenant_user_token_tenant_user_id_idx ON "TENANT_USER_TOKEN" (tenant_user_id);
CREATE INDEX tenant_user_token_expired_at_idx ON "TENANT_USER_TOKEN" (expired_at);

--
-- USER
--
CREATE TABLE "USER" (
  id          serial PRIMARY KEY,
  created_at  timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  uid         varchar(21)  NOT NULL,
  full_name   varchar(255) NOT NULL,
  email       varchar(255) NOT NULL,
  password    varchar(255) NOT NULL,
  details     jsonb,
  CONSTRAINT "IDX_35f450f926d886257a72301052" UNIQUE (uid),
  CONSTRAINT "IDX_c090db0477be7a25259805e37c" UNIQUE (email)
);
CREATE INDEX user_created_idx ON "USER" (created_at);

INSERT INTO "USER" VALUES (1,'2026-06-29 13:41:41','2026-06-29 13:41:41','62ed0359e7a0df63','Tenant Director','tenant@example.com','password',NULL),(2,'2026-06-29 13:41:41','2026-06-29 13:41:41','b62a51d8642df5b1','John Doe','john@example.com','password',NULL),(3,'2026-06-29 13:41:41','2026-06-29 13:41:41','b22295d7aa37eb1f','Jane Smith','jane@example.com','password',NULL),(4,'2026-06-29 13:41:41','2026-06-29 13:41:41','1dca2a75abad1931','Bob Wilson','bob@example.com','password',NULL),(5,'2026-06-29 13:41:41','2026-06-29 13:41:41','a3ec3eebfe3622b3','Alice Johnson','alice@example.com','password',NULL),(6,'2026-06-29 13:41:41','2026-06-29 13:41:41','72558cccd2c9fa66','Charlie Brown','charlie@example.com','password',NULL),(7,'2026-06-29 13:41:41','2026-06-29 13:41:41','4c15681c9ea46a4e','Diana Prince','diana@example.com','password',NULL),(8,'2026-06-29 13:41:41','2026-06-29 13:41:41','30561b5354fe23fb','Edward Kim','edward@example.com','password',NULL),(9,'2026-06-29 13:41:41','2026-06-29 13:41:41','8866e901659bc173','Fiona Garcia','fiona@example.com','password',NULL),(10,'2026-06-29 13:41:41','2026-06-29 13:41:41','b38a2e5179347a9f','George Miller','george@example.com','password',NULL);

--
-- migration
--
CREATE TABLE "migration" (
  id        serial PRIMARY KEY,
  "timestamp" bigint NOT NULL,
  name      varchar(255) NOT NULL
);

INSERT INTO "migration" VALUES (1,1779187925738,'Initial1779187925738');

-- Advance sequences past explicitly inserted ids.
SELECT setval(pg_get_serial_sequence('"TENANT"','id'),            (SELECT max(id) FROM "TENANT"));
SELECT setval(pg_get_serial_sequence('"TENANT_GROUP"','id'),      (SELECT max(id) FROM "TENANT_GROUP"));
SELECT setval(pg_get_serial_sequence('"TENANT_GROUP_USER"','id'), (SELECT max(id) FROM "TENANT_GROUP_USER"));
SELECT setval(pg_get_serial_sequence('"TENANT_TEAM"','id'),       (SELECT max(id) FROM "TENANT_TEAM"));
SELECT setval(pg_get_serial_sequence('"TENANT_USER"','id'),       (SELECT max(id) FROM "TENANT_USER"));
SELECT setval(pg_get_serial_sequence('"USER"','id'),              (SELECT max(id) FROM "USER"));
SELECT setval(pg_get_serial_sequence('"migration"','id'),         (SELECT max(id) FROM "migration"));
