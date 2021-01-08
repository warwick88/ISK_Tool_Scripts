use ProdSmartCare

--Bad Procedure Code ID: 812
select * from services
where serviceid=805276

--New Procedure Code is 836

select * from services
where procedurecodeid=812
order by createddate desc

select * from ProcedureCodes
where procedurecodename like '%H2021:GT%'

UPDATE ProcedureCodes
set RecordDeleted=NULL,DeletedDate=NULL,DeletedBy=NULL
WHERE ProcedureCodeId=812