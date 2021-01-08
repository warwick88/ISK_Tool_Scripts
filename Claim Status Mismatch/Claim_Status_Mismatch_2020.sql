;WITH CTE_ClaimLineHistory
AS
(
SELECT CL.ClaimLineId
,CLH.[Status]
,CLH.ClaimLineHistoryId
,ROW_NUMBER() OVER(PARTITION BY CLH.ClaimLineId ORDER BY CLH.ClaimLineHistoryId DESC,CLH.ModifiedDate DESC) AS ROW
FROM ClaimLines CL 
JOIN ClaimLineHistory CLH ON CL.ClaimLineId=CLH.ClaimLineId 
WHERE ISNULL(CL.RecordDeleted, 'N') = 'N' 
AND ISNULL(CLH.RecordDeleted, 'N') = 'N' 
)

  /* SELECT CL.ClaimLineId,CL.[Status] as claimLineStaus,CLH.[Status] as claimLineHistoryStaus, CTE.[Status]
FROM ClaimLines CL 
JOIN ClaimLineHistory CLH ON CL.ClaimLineId=CLH.ClaimLineId
JOIN CTE_ClaimLineHistory CTE ON CLH.ClaimLineHistoryId=CTE.ClaimLineHistoryId
WHERE ROW=1  
AND CL.[Status]<>CLH.[Status]
and CL.[Status] in(2023, 2025, 2026) and clh.[Status]=2022 */ 
 
Update CL SET CL.[Status]=CTE.[Status] , CL.ModifiedBy='KCMHSAS#1346'  FROM ClaimLines CL 
JOIN ClaimLineHistory CLH ON CL.ClaimLineId=CLH.ClaimLineId
JOIN CTE_ClaimLineHistory CTE ON CLH.ClaimLineHistoryId=CTE.ClaimLineHistoryId
WHERE ROW=1  
AND CL.[Status]<>CLH.[Status]
and CL.[Status] in(2023, 2025, 2026) and clh.[Status]=2022 