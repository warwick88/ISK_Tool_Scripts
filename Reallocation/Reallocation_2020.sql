use ProdSmartCare

/* Change ClientMonthlyDeductibles from Unknown to Never Met   
     based on SystemConfiguration..DeductiblesNeverMetMonthsFromToday 
     
     Only run 1x per month at Finance request (2nd claims run of month)
2014-05-27 ed: took 2 seconds to update 86 rows
2016-07-08 april:  did not run this time as it was not requested from finance
	april:  ran undeleteClaimLines with no results
	april:  ran SC Reallocation - no errors
	april:  ran CM Reallocation - error
			"The maximum recursion 100 has been exhausted before statement completion."
			Tried for several days with no luck; even tried just exec sp with same error - emailing Streamline
2017-10-28 ed: fixed to allow no more than 9 smartcare reallocations, now checks for no new records to arledger
2018-02-06 ed: now uses new smartcare CMReallocation, queries claim related tables from smartcare
*************************************************************************/
/*spenddowns set to Never that we haven't heard in X months*/
select DeductiblesNeverMetMonthsFromToday from SystemConfigurations


/*mark SmartCare spenddowns that are unknown - to Never that we haven't heard in 2 months*/
exec dbo.ssp_SCSetClientMonthlyDeductiblesToNeverMet

/*see where the deductibles are stored - in SmartCare - ClientFundingSources, medicaid Monthly Deductible tab*/
select top 1000 * from ClientMonthlyDeductibles cmd join ClientCoveragePlans ccp on cmd.ClientCoveragePlanId=ccp.ClientCoveragePlanId
where DeductibleMet='U' order by DeductibleYear desc, DeductibleMonth desc


select top 1000 DeductibleYear, DeductibleMonth,  COUNT(*) from ClientMonthlyDeductibles cmd join ClientCoveragePlans ccp on cmd.ClientCoveragePlanId=ccp.ClientCoveragePlanId
where DeductibleMet='U' group by DeductibleYear, DeductibleMonth
order by DeductibleYear desc, DeductibleMonth desc

select * from Services where ProcedureCodeId between 592 and 598 and ProcedureCodeId<>596


/*deductibles marked in the last 12 hours*/
select  distinct(ccp.ClientId), min(DeductibleYear*100+DeductibleMonth) MinMonth,max(DeductibleYear*100+DeductibleMonth) MaxMonth
from prodsmartcare.dbo.ClientMonthlyDeductibles cmd join prodsmartcare.dbo.ClientCoveragePlans ccp 
    on ccp.ClientCoveragePlanId=cmd.ClientCoveragePlanId
where cmd.ModifiedDate>DATEADD(HH,-12,GETDATE()) and cmd.ModifiedBy='unknown2never'
group by ccp.clientid
order by 1


/*summary of deductibles marked by date ran*/
select  cmd.ModifiedDate , count(*), min(DeductibleMonth),max(DeductibleMonth)
from prodsmartcare.dbo.ClientMonthlyDeductibles cmd join prodsmartcare.dbo.ClientCoveragePlans ccp 
    on ccp.ClientCoveragePlanId=cmd.ClientCoveragePlanId
where cmd.ModifiedBy='unknown2never'
group by cmd.ModifiedDate 
order by cmd.ModifiedDate desc

select top 1 * from ErrorLog order by 1 desc

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

/*2019-11-12 smartcare not reallocating correctly for BCBSM - this seems to fix it took 24 seconds to exec*/
exec ssp_SetChargeReadyToBill 'READYTOBILL'


/*smartcare reallocations end in this table*/
select top 10 * from RetroactiveReallocationLog rrl order by 1 desc

select top 10 * from CustomFieldServiceNotes

/*general purpose query to figure out the nature of smartcare reallocations*/
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

select top 10 * from RetroactiveReallocationLog order by 1 desc

/*summary of realloations by date ran*/
select top 1000 convert(varchar(13),rrl.CreatedDate,112), COUNT(*)
from kdevsmartcare..RetroactiveReallocationLog rrl 
group by convert(varchar(13),rrl.CreatedDate,112)
order by 1 desc

/*this is the default adjustment code, you see it used below in smartcare reallocations*/
select * from globalcodes where globalcodeid=25718


/*smartcare reallocation, 2013-12-07 22:00 ran in 1:22 minutes
                          2013-12-15 22:00 ran in 0:34 minutes
                          2013-12-21 13:00 ran in 0:24 minutes
                          2014-01-12 18:00 ran in 0:37 minutes
						  2019-06-10 08:00 ran in 0:55 minutes
*/
exec ssp_CMReallocateClaimLineCoveragePlans
  @StartDate='10/1/2019',
  @EndDate='09/30/2020',
  @InsurerId= null,
  @ClientId=null,
  @ClaimLineId= null,
  @CoveragePlanId = null,
  @UserCode = 'esova'

select top 100 * from ClientMonthlyDeductibles cmd join clientcoverageplans ccp on cmd.ClientCoveragePlanId=ccp.clientcoverageplanid
where ccp.clientid=1484-- and deductibleyear=2019 --and deductiblemonth in (4,5)
order by deductibleyear desc,deductiblemonth desc

/*CareManagement reallocation  2013-12-07 22:00 ran in 6:47 seconds
                               2013-12-15 22:00 ran in 0:35 
                               2013-12-21 15:00 ran in 0:36 
                               2014-01-12 18:00 ran in 0:39
                               2019-07-08 12:49 ran in 0:51
							   2019-09-29 17:00 ran in 2:31 seconds ... entire FY reallocation
********************************************************/


/*care management reallocations get stored here*/
select top 100 * from ReallocatedClaimLines R order by 1 desc

/*MCO reallocation results query go to s:\fiscal\streamline\reallocations\....*.xlsx  */
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

select * from SystemConfigurationKeys where [KEY] like '%spend%'

/*summary of care management reallocations by date*/
SELECT  R.CreatedDate, COUNT(*)
from ReallocatedClaimLines R
where 1=1
and r.CreatedDate>'10/1/13'
group by r.CreatedDate
order by r.CreatedDate desc

--select top 10 * from ReallocatedClaimLines order by 1 desc
--select * from plans
/*look for a specific smartcare reallocation*/