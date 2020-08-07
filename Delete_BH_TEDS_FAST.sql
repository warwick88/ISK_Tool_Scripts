use ProdSmartCare	

--Simply feed this a list of BH TEDS you need to delete.

BEGIN TRAN
update Documents
set Status=26, CurrentVersionStatus=26,ModifiedBy='WBarlowBHTEDSCleanup',ModifiedDate=getdate()
where DocumentId in (2614417)
COMMIT TRAN

