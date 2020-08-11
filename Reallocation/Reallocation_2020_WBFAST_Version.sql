use ProdSmartCare

/* 
	Warwick Reallocation Process ALL STEPS
	EXCEL File for results:   S:\FISCAL\Streamline\REALLOCATIONS
	First select 9k statement goes into first tab

*/




--Step 1: Run this EXEC
exec dbo.ssp_SCSetClientMonthlyDeductiblesToNeverMet


--Step 2: Run this entire block 3-5 Times!
/*Run smartcare reallocation repeatedly until no more changes to RetroactiveReallocationLog ~*/
declare @RRLBeforeCt int=1, @RRLAfterCt int=2, @iteration int=0, @arledgerbeforect int=1, @arledgerafterct int=2, @sMessage varchar(255)
while (@ARledgerAfterCt<>@ARledgerBeforeCt and @iteration<9)
begin
	select @iteration=@iteration+1
	select @RRLBeforeCt=count(*) from RetroactiveReallocationLog
	select @arledgerbeforect=count(*) from ARledger

	exec csp_PMRetroactiveChargeReallocation --the new custom stored proc as of 2017 we use this one
	@TransferAdjustmentCode = 25718,
	@DaysRetroBill = 0,      
	@ClientId  = null,
	@ServiceId  = null,    
	@StartDate  = '10/1/19',
	@EndDate = '9/30/20'

	select @RRLAfterCt=count(*) from RetroactiveReallocationLog
	select @arledgerafterct=count(*) from ARledger
    select @sMessage='@Iteration='+convert(varchar(9),@Iteration)
	    + '  @RRLBeforeCt='+convert(varchar(9),@RRLBeforeCt)
	    + '  @RRLAfterCt='+convert(varchar(9),@RRLAfterCt)
		+ '  Difference:'+convert(varchar(9),@RRLAfterCt-@RRLBeforeCt)
	    + '  @ARledgerBeforeCt='+convert(varchar(9),@ARledgerBeforeCt)
	    + '  @ARledgerAfterCt='+convert(varchar(9),@ARledgerAfterCt)
		+ '  Difference:'+convert(varchar(9),@ARledgerAfterCt-@ARledgerBeforeCt)
	print @sMessage
end


/*
	Step 3: Open excel file at S:\FISCAL\Streamline\REALLOCATIONS   -- Link in your local copies
	Your results from this 9000 select statement REPLACE all values in first tab smartcare_retroreallocationlog
	Make sure to replace all the previous data on this tab.
*/

select top 9000 p.ProgramName, pc.externalCode1, cp.CoveragePlanName , u.displayas StaffName, d.DoNotReallocate, rrl.* 
from RetroactiveReallocationLog rrl join Services s on rrl.ServiceId=s.ServiceId
     left join ProcedureCodes pc on s.ProcedureCodeId=pc.ProcedureCodeId
     left join programs p on s.ProgramId=p.ProgramId
     left join coverageplans cp on cp.CoveragePlanId=rrl.CoveragePlanId
     left join staff u on s.ClinicianId=u.staffid
	 left join CustomFieldServiceNotes d on s.ServiceId=d.ServiceId
where rrl.createddate>DATEADD(HH,-24,GETDATE()) --and ExternalCode1 not like 'H2021%'
and rrl.DateOfService between '10/1/2019' and '9/30/2020 23:59'
order by DateOfService desc


--------------------------------------------------------------------------------------
--Step 5: Run script Undeleted_Lines_Reallocation
--If there are results paste  info on the tab Undeleted claim lines: Just results
--Then Make a new tab and insert or paste the claim lines restored, this doesnt happen often.
--------------------------------------------------------------------------------------



--Step 6: Run this block multiple times. Like 8 times.
exec ssp_CMReallocateClaimLineCoveragePlans
  @StartDate='10/1/2019',
  @EndDate='09/30/2020',
  @InsurerId= null,
  @ClientId=null,
  @ClaimLineId= null,
  @CoveragePlanId = null,
  @UserCode = 'esova'


--Step 7: Run this block this is MCO Reallocation
--Paset results into the tab CM DETAIL. Wipe out everything in there and replace with these results.
SELECT distinct
	R.Claimlineid, R.OrignalplanID, OP.CoveragePlanName as OriginalPlanName
	, Pl.Coverageplanid as newplanid, Pl.CoveragePlanName as NewPlanName
	, R.Status, CL.status CLStatus, R.PaidAmount, R.ReallocationId
	, R.CreatedDate, R.CreatedBy, R.ModifiedDate, R.ModifiedBy, P.ProviderName
	, kcmhsasSupplemental.dbo.fn_join_composite_svc_cde(null,B.BillingCode, cl.modifier1, cl.modifier2, cl.modifier3, cl.modifier4 ) as CompleteBillingCode
	, B.BillingCode as BillingCodeName, cl.modifier1, cl.modifier2, modifier3, modifier4
	, gc.CodeName as PopulationName, cou.CountyName
	, clt.ClientID, pc.MasterClientId, i.InsurerName
	, cl.Units, cl.FromDate as 'ClaimLineFromDate', cl.ToDate as 'ClaimLineToDate'
--into #ReallocTmp
from ReallocatedClaimLines R
	left join CoveragePlans Pl  on Pl.CoveragePlanId = R.NewPlanId  and isnull(Pl.RecordDeleted,'N' )<> 'Y'
	left join CoveragePlans OP  on OP.CoveragePlanId = R.OrignalPlanId  and isnull(Pl.RecordDeleted,'N' )<> 'Y'
	inner join ClaimLines CL on CL.ClaimLineId = R.ClaimLineId
	inner join Claims C on CL.ClaimId = C.ClaimId and isnull(C.RecordDeleted,'N') <> 'Y'
	left join Insurers i on C.InsurerId = i.InsurerId and isnull(i.RecordDeleted,'N') <> 'Y'
	inner join Sites S on C.SiteId = S.SiteId and isnull(S.RecordDeleted,'N') <> 'Y'
	inner join Providers P on P.ProviderId = S.ProviderId and isnull(P.RecordDeleted,'N') <> 'Y'
	inner join BillingCodes B on CL.BillingCodeId = B.BillingCodeID and isnull(B.RecordDeleted,'N') <> 'Y'
	left join customclaimlines ccl on CL.ClaimLineId=ccl.claimlineid
	--left join CustomFieldsData CFD on CFD.PrimaryKey1 = C.CLIENTID AND CFD.DocumentType = 4941 
	--and isnull(cfd.RecordDeleted,'N') <> 'Y'
	left join GlobalCodes gc on ccl.AuthorizationPopulation= Gc.GlobalCodeId and isnull(gc.RecordDeleted, 'N') <> 'Y'
	AND gc.Active = 'Y'
	inner join Clients clt on clt.ClientID = C.ClientId
	left join Counties cou on clt.CountyOfTreatment = cou.CountyFIPS
	left outer join ProviderClients pc on pc.ProviderId = p.ProviderId and pc.ClientId = c.ClientId
	and isnull(pc.RecordDeleted, 'N') <> 'Y'
where 1=1  and r.CreatedDate >DATEADD(DD,-9,GETDATE())
and cl.FromDate>='10/1/2019' and cl.FromDate<'10/1/2020'
order by 1



--Step 8: Refresh the graphs Amy has
--Step 9: Relay that the process is completed and give amy a link.