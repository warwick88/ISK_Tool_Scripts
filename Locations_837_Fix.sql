use ProdSmartCare


select * from locations
order by createddate desc

select * from locations
where locationname like '%02%'
order by createddate desc

select * from globalcodes
where globalcodeid=73441

select top 100* from reports

select top 100* from Documents

select top 100* from ProcedureCodes
order by ModifiedDate desc

--Prior to this action, these were all NULL values
begin tran
update locations
SET Address='2030 Portage St', City='Kalamazoo',State='MI',ZipCode='49001-3836'
where locationid in (228,225)
commit tran

