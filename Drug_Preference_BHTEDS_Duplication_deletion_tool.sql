use ProdSmartCare


select * from documents
where documentid=2698964

select * from documentversions
where documentid=2698964

select top 100* from CustomBHTEDSDischargeSUHistory
where DocumentVersionId=2896085
order by createddate desc

begin tran
update CustomBHTEDSDischargeSUHistory
SET RECORDDELETED='Y',DeletedBy='wBarlow',DeletedDate=GETDATE()
WHERE BHTEDSDischargeSUHistoryId = 23042
commit tran
