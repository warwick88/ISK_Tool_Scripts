/*for best results: set the results to come back as text - tab delimited, run the whole script
  paste results into a sheet in the s:\fiscal\streamline\reallocations\ workbooks */  
-- 2018-08-06 ed: now undelete 0 payment and 0 credit claims commented out the and .Amount>0

use prodsmartcare
select * 
into #undelete
from (
SELECT cl.ClaimLineId, c.clientid, cl.FromDate, cl.DeletedBy, cl.DeletedDate, cp.Amount AS Amount, ch.CheckDate, ch.CheckNumber, ch.Amount AS CheckAmount, ch.PayeeName 
FROM Claims c
INNER JOIN ClaimLines cl ON c.ClaimId = cl.ClaimId
INNER JOIN ClaimLinePayments cp ON cp.ClaimLineId = cl.ClaimLineId AND ISNULL(cp.RecordDeleted,'N')='N' 
INNER JOIN Checks ch ON cp.CheckId = ch.CheckId AND ISNULL(ch.RecordDeleted,'N')='N' 
WHERE (c.RecordDeleted = 'Y' 
		OR cl.RecordDeleted = 'Y')
AND (c.DeletedDate between '10/1/12' and GETDATE()
		OR cl.DeletedDate between '10/1/12' and GETDATE() )
--AND cp.Amount > 0	
UNION
SELECT cl.ClaimLineId, c.ClientId, cl.FromDate, cl.DeletedBy, cl.DeletedDate, -(cc.Amount) AS Amount, ch.CheckDate, ch.CheckNumber, ch.Amount AS CheckAmount, ch.PayeeName 
FROM Claims c
INNER JOIN ClaimLines cl ON c.ClaimId = cl.ClaimId
INNER JOIN ClaimLineCredits cc ON cc.ClaimLineId = cl.ClaimLineId AND ISNULL(cc.RecordDeleted,'N')='N' 
INNER JOIN Checks ch ON cc.CheckId = ch.CheckId AND ISNULL(ch.RecordDeleted,'N')='N' 
WHERE (c.RecordDeleted = 'Y' 
		OR cl.RecordDeleted = 'Y')
AND (c.DeletedDate between '10/1/12' and GETDATE() 
		OR cl.DeletedDate between '10/1/12' and GETDATE())
--AND cc.Amount > 0
) as p

select * from #undelete

select * from Claims c join ClaimLines cl on c.ClaimId=cl.ClaimId where c.ClientId=1753 and cl.FromDate='1/5/15'

--Claims, ClaimLines, ClaimLineHistory, Adjudications, ClaimLinePlans
set nocount on

update c set RecordDeleted=null, DeletedBy=null, DeletedDate=null
--select c.claimid, c.RecordDeleted, c.DeletedBy, c.DeletedDate 
from Claims c join ClaimLines cl on c.ClaimId=cl.ClaimId
where ClaimLineId in (select ClaimLineId from #undelete)
print kcmhsasSupplemental.dbo.fn_Msg('claims records undeleted: ')

select * from #undelete

update ClaimLines set RecordDeleted=null, DeletedBy=null, DeletedDate=null
where ClaimLineId in (select ClaimLineId from #undelete)
print kcmhsasSupplemental.dbo.fn_Msg('claimlines records undeleted: ')


update ClaimLineHistory set RecordDeleted=null, DeletedBy=null, DeletedDate=null
where ClaimLineId in (select ClaimLineId from #undelete)
print kcmhsasSupplemental.dbo.fn_Msg('ClaimLineHistory records undeleted: ')

update Adjudications set RecordDeleted=null, DeletedBy=null, DeletedDate=null
where ClaimLineId in (select ClaimLineId from #undelete)
print kcmhsasSupplemental.dbo.fn_Msg('Adjudications records undeleted: ')

update ClaimLinePlans set RecordDeleted=null, DeletedBy=null, DeletedDate=null
where ClaimLineId in (select ClaimLineId from #undelete)
print kcmhsasSupplemental.dbo.fn_Msg('ClaimLinePlans records undeleted: ')

