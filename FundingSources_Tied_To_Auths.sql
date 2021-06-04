use ProdSmartCare


select * from documents
where documentid=2779237


--so we need the document version to feed tpprocedures
select * from documentversions
where documentid=2779237

select * from tpprocedures
where documentversionid=2889375

select * from authorizations
where authorizationid in (
307041,
307042
)

select * from authorizationplans

--Now we need to look at client coverage plans - the record is deleted causing this problem

select * from ClientCoveragePlans
where clientid=124258
and recorddeleted = 'Y'

update ClientCoveragePlans
SET RecordDeleted=NULL,DeletedDate=NULL,DELETEDBY=NULL
where clientid=124258
and recorddeleted = 'Y'

select * from clientcoverageplans
where clientcoverageplanid=294939

select * from clientcoverageplans
where coverageplanid=49
and clientid=124258
and clientcoverageplanid=294939

--39 is the good one.

begin tran
update clientcoverageplans
SET RecordDeleted='Y',DeletedDate=getdate(),DELETEDBY='WarwickREfix'
where clientcoverageplanid in (
294938
)
commit tran

select * from ClientCoveragePlans
where clientid=124258
and recorddeleted = 'Y'



BEGIN TRAN
update clientcoverageplans
SET RecordDeleted=NULL,DeletedDate=NULL,DELETEDBY=NULL
WHERE ClientCoveragePlanId IN (
294938)
COMMIT TRAN

SELECT * FROM ClientCoveragePlans
WHERE ClientCoveragePlanId IN (
294938)

SELECT * FROM ClientCoveragePlans
where coverageplanid=49
and clientid=124258

begin tran
update clientcoverageplans
SET RecordDeleted='Y',DeletedDate=getdate(),DELETEDBY='WarwickREfix'
where clientcoverageplanid in (
294939,
268558
)
commit tran


Select CCP.* from Authorizations A
JOIN AuthorizationDocuments AD on A.AuthorizationDocumentId=A.AuthorizationDocumentId
Join ClientCoveragePlans CCP ON AD.ClientCoveragePlanId=CCP.ClientCoveragePlanId
JOIN CoveragePlans CP ON CP.CoveragePlanId=CCP.CoveragePlanId
WHERE CCP.ClientId=52728


SELECT * FROM ClientCoveragePlans CCP
WHERE CCP.ClientId=52728
AND CCP.RECORDDELETED = 'Y'
AND ccp.DELETEDBY LIKE '%Support#1668%'


BEGIN TRAN
update clientcoverageplans
SET RecordDeleted=NULL,DeletedDate=NULL,DELETEDBY=NULL
WHERE ClientCoveragePlanId IN (
291700,
294323,
294324,
294325,
294326)
COMMIT TRAN

begin tran
update clientcoverageplans
SET RecordDeleted='Y',DeletedDate=getdate(),DELETEDBY='WarwickREfix'
where clientcoverageplanid in (
294323,
294324,
294325,
294326
)
commit tran

SELECT * FROM CLIENTCOVERAGEPLANS
WHERE CLIENTCOVERAGEPLANID=291700

Select CCP.* from Authorizations A
LEFT JOIN AuthorizationDocuments AD on A.AuthorizationDocumentId=A.AuthorizationDocumentId
LEFT Join ClientCoveragePlans CCP ON AD.ClientCoveragePlanId=CCP.ClientCoveragePlanId
LEFT JOIN CoveragePlans CP ON CP.CoveragePlanId=CCP.CoveragePlanId
WHERE CCP.ClientId=52728
AND ccp.DELETEDBY LIKE '%WarwickREfix%'

SELECT * FROM AuthorizationDocuments AD
Join ClientCoveragePlans CCP ON AD.ClientCoveragePlanId=CCP.ClientCoveragePlanId
WHERE CCP.CLIENTID=52728
AND CCP.DeletedBy LIKE '%Support#1668%'

select * from clientcoverageplans CCP
WHERE CCP.DeletedBy LIKE '%Support#1668%'

SELECT * FROM AuthorizationDocuments AD
Join ClientCoveragePlans CCP ON AD.ClientCoveragePlanId=CCP.ClientCoveragePlanId
WHERE CCP.DeletedBy LIKE '%Support#1668%'

SELECT AD.AUTHORIZATIONDOCUMENTID,AD.ClientCoveragePlanId FROM AuthorizationDocuments AD
Join ClientCoveragePlans CCP ON AD.ClientCoveragePlanId=CCP.ClientCoveragePlanId
WHERE CCP.DeletedBy LIKE '%Support#1668%'



--We target all the deleted funding sources!
SELECT AD.AUTHORIZATIONDOCUMENTID,AD.ClientCoveragePlanId INTO #TEMP2 FROM AuthorizationDocuments AD
Join ClientCoveragePlans CCP ON AD.ClientCoveragePlanId=CCP.ClientCoveragePlanId
WHERE CCP.DeletedBy LIKE '%Support#1668%'

--pull them into a distinct table as we had duplication
SELECT DISTINCT(CLIENTCOVERAGEPLANID) INTO #TEMP3 FROM #TEMP2

--review your data
SELECT * FROM #TEMP3


--confirm update is right language.
SELECT * FROM CLIENTCOVERAGEPLANS
WHERE CLIENTCOVERAGEPLANID IN (SELECT CLIENTCOVERAGEPLANID FROM #TEMP3)

select * FROM ClientCoveragePlans
WHERE ClientCoveragePlanId=266032


--fix it!
begin tran
update clientcoverageplans
SET ModifiedBy = 'WbarlowAuthListP'
WHERE ClientCoveragePlanId IN (SELECT CLIENTCOVERAGEPLANID FROM #TEMP3)
commit tran








