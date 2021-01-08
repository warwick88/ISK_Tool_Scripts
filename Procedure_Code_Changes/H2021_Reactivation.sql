use SmartCarePreProd

select * from ProcedureCodes
where procedurecodename like '%H2021:GT%'

UPDATE ProcedureCodes
set RecordDeleted=NULL,DeletedDate=NULL,DeletedBy=NULL
WHERE ProcedureCodeId=812




select * from Authorizations
order by CreatedDate desc

use SmartCarePreProd

select * from Authorizations
where CreatedDate > '12-31-2019'
and CreatedDate <= '12-31-2020'

select * from ProviderAuthorizations
where ClientId=129133
order by CreatedDate desc

select * from ProviderAuthorizations
where ProviderAuthorizationId in (
366015,
366016)