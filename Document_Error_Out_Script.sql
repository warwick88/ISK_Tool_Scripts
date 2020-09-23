use ProdSmartCare

DECLARE @DocumentId INT;

SET @DocumentId = 2382401

select * from documents
where documentid=@DocumentId

select * From documentversions
where documentid= @DocumentId

select * from documentsignatures
where documentid= @DocumentId

begin tran
update Documents
SET Status=26,CurrentVersionStatus=26,ModifiedBy='WbarlowScript',ModifiedDate=getdate()
WHERE DocumentId = 2499458

commit tran
ROLLBACK TRAN

