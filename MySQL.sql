CREATE TABLE IF NOT EXISTS invoice_id (
    company_id INT unsigned not null COMMENT 'The company registered with this invoice.',
	invoice_prefix char(5) NOT NULL COMMENT 'The invoice series prefix',
	invoice_number INT UNSIGNED NOT NULL COMMENT 'The last invoice number for the serie',
	CONSTRAINT invoice_id_pk PRIMARY KEY (company_id, invoice_prefix,invoice_number)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8
COLLATE=utf8_general_ci
COMMENT='The last invoice IDs per series' ;
