

/*
	This script was created to address duplication of funding sources for clients
*/

select * from ClientCoveragePlans
where createddate > '2020-01-01'
order by ClientId,CoveragePlanId

select * from ClientCoveragePlans s
join (
	select clientid,coverageplanid, count(*) as qty
	from ClientCoveragePlans
	group by ClientId,CoveragePlanId
	having count(*) > 1
	) t  on s.ClientId = t.ClientId and s.CoveragePlanId = t.CoveragePlanId

--Tells you the count of each coverage plan they have.
SELECT clientid,coverageplanid, count(*) as qty 
 FROM ClientCoveragePlans 
 GROUP BY clientid,coverageplanid HAVING count(*)> 1



--Logic shown below was used for another fix----

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
