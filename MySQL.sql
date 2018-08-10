CREATE TABLE IF NOT EXISTS invoice_id (
    company_id INT unsigned not null COMMENT 'The company registered with this invoice.',
    invoice_prefix char(5) NOT NULL COMMENT 'The invoice series prefix',
    invoice_number INT UNSIGNED NOT NULL COMMENT 'The last invoice number for the serie',
    CONSTRAINT invoice_id_pk PRIMARY KEY (company_id, invoice_prefix)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8
COLLATE=utf8_general_ci
COMMENT='The last invoice IDs per series' ;

---
--- Stored procedure for invoice_id
---
DROP PROCEDURE if exists spInvoiceInsert;

CREATE PROCEDURE spInvoiceInsert(in companyId int unsigned, invoicePrefix char(5))
begin
	
	declare myInvoiceId int unsigned;
	
	select invoice_number into myInvoiceId from invoice_id where company_id=companyId and invoice_prefix=invoicePrefix;
	
	set myInvoiceId = IFNULL(myInvoiceId, 0);

	set myInvoiceId = myInvoiceId + 1;

	INSERT INTO invoice_id (company_id, invoice_prefix, invoice_number) VALUES(companyId, invoicePrefix, myInvoiceId) ON DUPLICATE KEY UPDATE invoice_number=myInvoiceId;

end
