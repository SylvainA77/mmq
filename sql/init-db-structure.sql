CREATE DATABASE MMQMANAGEMENT;

USE MMQMANAGEMENT;

-- C[consumer]
-- P[ublisher]
-- U[ser]
-- M[onitor]
-- A[dmin]
CREATE TABLE mmqusers (
id INT unsigned NOT NULL DEFAULT uuid_short() primary key,
name VARCHAR(32) NOT NULLL,
type CHAR(1) NOT NULL CHECK(type in ("C","P","A","M","U")), 
email VARCHAR(320) NOT NULL CHECK (email REGEXP '^[^@]+@[^@]+\\.[^@]+$'),
token BINARY(32) generated always as tokenize(name, email) stored,
created_at DATETIME NOT NULL DEFAULT current_datetime(),
updated_at DATETIME on update current_datetime()
UNIQUE(name)
) engine = InnoDB;
-- default users : 
-- 0 nobody
-- 1 admin
-- 2 replication


INSERT INTO mmqusers (name, type, email) values 
('nobody', 'U', 'nodoby@localhost.org'),
('admin','A','admin@localhost.org'),
('monitor','M', 'monitor@localhost.org');

  
-- a Q queue is a single user async mq
-- a T queue is a multi-user shared queue
-- a P queue is a publishing queue
CREATE TABLE qdefinitions ( 
id INT unsigned NOT NULL DEFAULT uuid_short() primary key,
name VARCHAR(32) NOT NULL,
-- type CHAR(1) NOT NULL CHECK(type in ("Q","T","P")), -- Q[ueue],T[opic],P[ublisher]
-- associated_schema VARCHAR(42) AS concat(decode(type,Q,"brkr_",T,"brk_", "P","pub_"),name) VIRTUAL,
has_priority TINYINT(1) NOT NULL DEFAULT 0,
has_savepoint TINYINT(1) NOT NULL DEFAULT 0,
has_TTL TINYINT(1) NOT NULL DEFAULT 0,
default_TTL INT unsigned DEFAULT 500, -- seconds
has_DLQ TINYINT(1) NOT NULL DEFAULT 0,
has_ACK TINYINT(1) NOT NULL DEFAULT 0,
has_history TINYINT(1) NOT NULL DEFAULT 0,
created_by INT unsigned NOT NULL,
created_at DATETIME NOT NULL DEFAULT current_datetime(),
update_at DATETIME on update current_datetime()
UNIQUE(name)
) engine=InnoDB;

-- a  C user should only subscribe to Q or T queues
-- a  P user should only subscrive to a P queue
-- an A user should sucribe to any of them
CREATE TABLE qsubscriptions (
id INT unsigned NOT NULL DEFAULT uuid_short() primary key,
user_id INT unsigned NOT NULL,
queue_id INT unsigned NOT NULL,
token BINARY(32) generated always as tokenize( ) stored,
created_at DATETIME NOT NULL DEFAULT current_datetime(),
updated_at DATETIME on update current_datetime(),
UNIQUE(user_id, queue_id)
) engine=InnoDB;

CREATE TABLE mmqbrokers (
id INT unsigned NOT NULL DEFAULT uuid_short() primary key,
name varchar() NOT NULL, -- can hold hostname or FQDN
type CHAR(1) NOT NULL CHECK(type in ("C","P","B")), -- C[onsumer],P[ublisher],B[oth]
address INET4 NOT NULL,
port SMALLINT unsigned NOT NULL DEFAULT 3306,
registration_date DATETIME NOT NULL DEFAULT current_datetime() 
) engine =InnoDB;
