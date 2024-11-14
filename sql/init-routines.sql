CREATE OR REPLACE DEFINER=`locked-admin-account`@localhost` 
FUNCTION tokenize(IN arg1 varchar(320), IN arg2 varchar(32))
RETURNS BINARY(32)
DETERMINISTIC
SQL SECURITY DEFINER
RETURN SHA2(CONCAT(arg1,arg2),256);

CREATE TRIGGER AFTER INSERT on qdefinitions

CREATE DATABASE qd.associated_schema;
USE qd.associated_schema;

CREATE SEQUENCE message_id as BIGINT UNSIGNED START WITH 1 INCREMENT BY 1 CACHE=250 CYCLE;

CREATE TABLE messages (
id BIGINT unsigned if(qd.type = "P", "DEFAULT message_id.nextval()") primary key,
broker_id TINYINT unsigned NOT NULL,
header JSON NOT NULL if qd.type="P" CHECK(JSON_VALID(header)),
body JSON NOT NULL if qd.type="P" CHECK(JSON_VALID(body)),
) engine= myrocks;

CREATE TABLE qmetadatas (
id BIGINT unsigned NOT NULL,
published_by INT unsigned NOT NULL, -- mmqusers.id
published_at DATETIME(6) NOT NULL,
published_on INT unsigned NOT NULL, -- mmqbrokers.id
GTID varbinary() NOT NULL,
priority TINYINT unsigned NOT NULL DEFAULT 0,
TTL INT unsigned DEFAULT 0, -- TTL in seconds
savepoint TINYINT unsigned NOT NULL DEFAULT 0,
consumed_by INT unsigned NOT NULL DEFAULT "0", -- mmqusers.id
consumed_at BIGINT unsigned, -- epoch timestamp expected here
consumed_on INT unsigned, -- mmqbrokers.id
consumed_count TINYINT unsigned NOT NULL DEFAULT 0,
primary key(consumed_by, id)
) engine= innodb;

CREATE TABLE event_history (
message_id BIGINT unsigned NOT NULL,
GTID varbinary() NOT NULL,
type CHAR(1) check(type in ("P","A","K","C","S","Q","D")), -- P[ublished],[ac]K[nowledged],C[onsumed],S[avepointed],R[eset],[DL]Q,D[eleted]
at DATETIME(6) NOT NULL,
by INT unsigned NOT NULL, -- mmqusers.id
on INT unsigned NOT NULL -- mmqbrokers.id
) engine=innodb;

CREATE TABLE DLQ (
id BIGINT unsigned NOT NULL primary key,
header JSON NOT NULL,
body JSON NOT NULL,
) engine=innodb;
