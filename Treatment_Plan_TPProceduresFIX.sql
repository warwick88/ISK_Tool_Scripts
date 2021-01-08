use ProdSmartCare

--Your going to use this to get the DocumentVersionID
select * from documents
where documentid=2756971



UPDATE DOCUMENTVERSIONS
SET RefreshView='Y'
where documentversionid=2853644


--Take the DocumentVersionID you got and plug it into this.
select * from tpprocedures
where documentversionid=2866332

--AND TPPROCEDUREID IN (319360,319362)

BEGIN TRAN
update tpprocedures
set recorddeleted='Y',DeletedBy='Wbarlow',DeletedDate=GETDATE()
WHERE TPPROCEDUREID=319360
COMMIT TRAN

SELECT * FROM AUTHORIZATIONS
WHERE AUTHORIZATIONID=302225

begin tran
UPDATE AUTHORIZATIONS
SET RecordDeleted='Y',DeletedDate=GETDATE(),DeletedBy='Wbarlow'
WHERE AUTHORIZATIONID=302225
commit tran

begin tran
update providerauthorizations
SET RecordDeleted='Y',DeletedDate=GETDATE(),DeletedBy='Wbarlow'
WHERE pROVIDERAUTHORIZATIONID=370595
commit tran







select * from Services
where serviceid=887578

select * from documents
where serviceid=887578

select * from procedurecodes	
where procedurecodeid=615

--DocumentVersionId Key
select SummaryAgreedtoAlternativeSErvices from customacuteservicesprescreens
where documentversionid=2850336

BEGIN TRAN
update customacuteservicesprescreens
SET SummaryAgreedtoAlternativeSErvices=NULL
where documentversionid=2850336
COMMIT TRAN
