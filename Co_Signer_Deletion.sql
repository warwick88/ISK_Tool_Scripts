use ProdSmartCare

select * from documents
where documentid=2677802

select * from documentversions
where documentid=2677802


select top 100* from CustomBHTEDSDischargeSUHistory
where DocumentVersionId=2785092
order by createddate desc





select * from documents
where serviceid=861438

select * from documentversions
where documentid=2675359

update documentversions
SET REFRESHVIEW='Y'
where documentid=2675359


update documentversions
SET REFRESHVIEW='Y'
where documentid=2648217


select * from services
where serviceid=849531

select * from services
where serviceid=849590

select * from globalcodes

--service deletion

select * from documents
where documentid=849531

select * from documentversions
where documentid=849531

/*
	Script for fixing co signature issue.
*/

---Just feed it a list of the document ID's----And it takes care of the rest
begin tran
update DOCUMENTSIGNATURES
SET RecordDeleted='Y',DeletedBy='WBARLOW',DeletedDate=GETDATE()
WHERE SignedDocumentVersionId IS NULL
AND DocumentId in (
2665197,
2663561
)
commit tran
rollback tran


select * from documents
where documentid=2665197

--Kalicia Good doc
select * from documents
where documentid=2675794

update documents
SET DocumentShared='Y'
where documentid=2675794

select * from documentversions
where documentid=2675794






select * from DocumentSignatures
where documentid in (1225956,
1921306)




DECLARE @documentid INT;
SET @documentid = 2488616

select * from documents
where documentid=@documentid

select * from documentversions
where documentid=@documentid

select * from DocumentSignatures
where documentid=@documentid
AND SignedDocumentVersionId IS NULL

select * from documentsignatures
where signatureid in (2735507,2859028)











BEGIN TRAN
UPDATE DocumentSignatures
SET RecordDeleted='Y',DeletedBy='WBARLOW',DeletedDate=GETDATE()
WHERE SignatureId IN(2488616)
COMMIT TRAN
rollback tran



DECLARE @documentid INT;
SET @documentid = 2395836

select * from documents
where documentid=@documentid

select * from documentversions
where documentid=@documentid

select * from DocumentSignatures
where documentid=@documentid
AND SignedDocumentVersionId IS NULL

BEGIN TRAN
UPDATE DocumentSignatures
SET RecordDeleted='Y',DeletedBy='WBARLOW',DeletedDate=GETDATE()
WHERE SignatureId IN(2626932,2861273)
COMMIT TRAN
rollback tran


select * into #temp1 FROM Documents
where documentid in (2395836,2406535)

select * from DocumentSignatures
where DOCUMENTID IN (2395836,2406535)
AND SignedDocumentVersionId IS NULL
