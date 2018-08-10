###
### Drops
###
DROP TABLE if exists invoice_series;
DROP TABLE if exists invoice_numbers;

###
### Invoice series
###
CREATE TABLE IF NOT EXISTS invoice_series(
	company_id INT UNSIGNED NOT NULL,
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
    company_id INT unsigned not null COMMENT 'The company registered with this invoice.',
    invoice_prefix char(5) NOT NULL COMMENT 'The invoice series prefix',
    invoice_number INT UNSIGNED NOT NULL COMMENT 'The last invoice number for the serie',
    CONSTRAINT invoice_id_pk PRIMARY KEY (company_id, invoice_prefix)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8
COLLATE=utf8_general_ci
COMMENT='The last invoice IDs per series' ;

###
### Stored procedure for invoice_id
###
DROP PROCEDURE if exists spInvoiceInsert;

CREATE PROCEDURE spInvoiceInsert(in companyId int unsigned, invoicePrefix char(5))
BEGIN
	
	DECLARE myInvoiceNumber int unsigned;
	
	SELECT invoice_number INTO myInvoiceNumber FROM invoice_numbers WHERE company_id=companyId AND invoice_prefix=invoicePrefix;
	
	SET myInvoiceNumber = IFNULL(myInvoiceNumber, 0);

	SET myInvoiceNumber = myInvoiceNumber + 1;

	INSERT INTO invoice_numbers (company_id, invoice_prefix, invoice_number) VALUES(companyId, invoicePrefix, myInvoiceNumber) ON DUPLICATE KEY UPDATE invoice_number=myInvoiceNumber;

END
