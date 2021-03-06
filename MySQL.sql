###
### Drops
###
DROP TABLE IF EXISTS invoice_ids;
DROP TABLE IF EXISTS invoices;
DROP TABLE IF EXISTS invoice_series;
DROP TABLE IF EXISTS invoice_numbers;

###
### Invoice IDs
###
CREATE TABLE IF NOT EXISTS invoice_ids (
	company_id SMALLINT UNSIGNED NOT NULL COMMENT 'The company identifier',
	customer_id INT UNSIGNED NOT NULL COMMENT 'The customer identifier',
	invoice_id BIGINT UNSIGNED NOT NULL COMMENT 'The last inserted invoice identifier',
	CONSTRAINT invoice_ids_pk PRIMARY KEY (company_id)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8
COLLATE=utf8_general_ci
COMMENT='Table that hold the last inserted invoice ID per company' ;

###
### Invoices
###
CREATE TABLE IF NOT EXISTS invoices (
	company_id SMALLINT UNSIGNED NOT NULL COMMENT 'The owner of this invoice',
	customer_id INT UNSIGNED NOT NULL COMMENT 'The customer identifier.',
	invoice_id BIGINT UNSIGNED NOT NULL COMMENT 'The identifier of the invoice',
	invoice_prefix char(5) NULL COMMENT 'The invoice prefix of the series',
	invoice_number INT UNSIGNED NULL COMMENT 'The invoice number.',
	invoice_issued_date DATETIME NULL COMMENT 'The issue date of the invoice',
	created_at DATETIME NOT NULL COMMENT 'The date and time when the invoice was created',
	created_by varchar(100) NOT NULL COMMENT 'The user that created this invoice.',
	modified_at DATETIME NULL COMMENT 'The date and time when the invoice was last modified',
	modified_by varchar(100) NULL COMMENT 'The user that last modified the invoice',
	CONSTRAINT invoices_pk PRIMARY KEY (company_id,customer_id,invoice_id)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8
COLLATE=utf8_general_ci ;

###
### Invoice series
###
CREATE TABLE IF NOT EXISTS invoice_series(
	company_id SMALLINT UNSIGNED NOT NULL,
	invoice_prefix CHAR(5) NOT NULL,
	created_at DATETIME NOT NULL,
	modified_at DATETIME NULL,
	CONSTRAINT invoice_series_pk PRIMARY KEY (company_id,invoice_prefix)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8
COLLATE=utf8_general_ci ;

###
### Invoice numbers
###
CREATE TABLE IF NOT EXISTS invoice_numbers (
    company_id SMALLINT unsigned not null COMMENT 'The company registered with this invoice.',
    invoice_prefix char(5) NOT NULL COMMENT 'The invoice series prefix',
    invoice_number INT UNSIGNED NOT NULL COMMENT 'The last invoice number for the serie',
    CONSTRAINT invoice_id_pk PRIMARY KEY (company_id, invoice_prefix)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8
COLLATE=utf8_general_ci
COMMENT='The last invoice IDs per series' ;

###
### Stored procedure to insert an invoice
###
DROP PROCEDURE if exists spInvoiceInsert;

CREATE PROCEDURE spInvoiceInsert(IN companyId SMALLINT UNSIGNED,IN customerId INT UNSIGNED, IN userName VARCHAR(100))
BEGIN
	
	DECLARE myInvoiceId bigint unsigned;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
	BEGIN
		rollback;
		SELECT 0 AS invoice_id;
	END;

	SELECT invoice_id INTO myInvoiceId FROM invoice_ids WHERE company_id=companyId AND customer_id=customerId;
	
	SET myInvoiceId = IFNULL(myInvoiceId, 0);

	SET myInvoiceId = myInvoiceId + 1;

	START TRANSACTION;

		INSERT INTO invoice_ids (company_id, customer_id, invoice_id) VALUES(companyId, customerId, myInvoiceId) ON DUPLICATE KEY UPDATE invoice_id=myInvoiceId;

		INSERT INTO invoices (company_id, customer_id, invoice_id, created_at, created_by) VALUES(companyId, customerId, myInvoiceId, NOW(), userName);
	
	COMMIT;

	SELECT myInvoiceId AS invoice_id;
END

###
### Stored procedure for invoice_id
###
DROP PROCEDURE if exists spHistoricalInvoiceInsert;

CREATE PROCEDURE spHistoricalInvoiceInsert(IN companyId SMALLINT UNSIGNED, IN invoicePrefix CHAR(5))
BEGIN
	
	DECLARE myInvoiceNumber int unsigned;
	
	SELECT invoice_number INTO myInvoiceNumber FROM invoice_numbers WHERE company_id=companyId AND invoice_prefix=invoicePrefix;
	
	SET myInvoiceNumber = IFNULL(myInvoiceNumber, 0);

	SET myInvoiceNumber = myInvoiceNumber + 1;

	INSERT INTO invoice_numbers (company_id, invoice_prefix, invoice_number) VALUES(companyId, invoicePrefix, myInvoiceNumber) ON DUPLICATE KEY UPDATE invoice_number=myInvoiceNumber;

END
