use ProdSmartCare

BEGIN TRAN
update clientcontactnotes
SET RecordDeleted='Y',DeletedDate=GETDATE(),DELETEDBY='Wbarlow'
where clientcontactnoteid=44094
COMMIT TRAN
ROLLBACK TRAN