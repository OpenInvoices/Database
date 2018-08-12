--
-- Based on https://www.red-gate.com/simple-talk/sql/database-administration/pop-rivetts-sql-server-faq-no-5-pop-on-the-audit-trail/
--

CREATE TABLE audit_trail (
	`type` CHAR(1) NOT NULL COMMENT 'I = INSERT, U = UPDATE, D = DELETE',
	table_name varchar(128) NOT NULL COMMENT 'The table name',
	pk varchar(1000) NULL,
	column_name varchar(128) NOT NULL COMMENT 'The column name',
	old_value varchar(1000) NULL COMMENT 'The old value',
	new_value varchar(1000) NULL COMMENT 'The new value',
	created_at DATETIME NOT NULL COMMENT 'The date and time this record was created',
	created_by varchar(128) NULL COMMENT 'The user that created this record'
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8
COLLATE=utf8_general_ci ;
