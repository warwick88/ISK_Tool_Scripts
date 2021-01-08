/*
	If you need to run single client reallocation use this script
	Simple imput the clientID and then run first section 3-4 times
	Then run 2nd section with cell output, put this in excel and give to requestor.
*/


exec Prodsmartcare..csp_PMRetroactiveChargeReallocation --the new custom stored proc as of 2017 we use this one
       @TransferAdjustmentCode = 25718,
       @DaysRetroBill = 0,      
       @ClientId  = 62412,
       @ServiceId  = null,    
       @StartDate  = '10/8/19',
       @EndDate = '10/8/20'


select top 9000 p.ProgramName, pc.externalCode1, cp.CoveragePlanName , u.displayas StaffName, d.DoNotReallocate, rrl.* 
from ProdSmartCare..RetroactiveReallocationLog rrl join ProdSmartCare..Services s on rrl.ServiceId=s.ServiceId
     left join ProdSmartCare..ProcedureCodes pc on s.ProcedureCodeId=pc.ProcedureCodeId
     left join ProdSmartCare..programs p on s.ProgramId=p.ProgramId
     left join ProdSmartCare..coverageplans cp on cp.CoveragePlanId=rrl.CoveragePlanId
     left join ProdSmartCare..staff u on s.ClinicianId=u.staffid
       left join ProdSmartCare..CustomFieldServiceNotes d on s.ServiceId=d.ServiceId
where rrl.createddate>DATEADD(HH,-24,GETDATE()) --and ExternalCode1 not like 'H2021%'
and rrl.DateOfService between '10/1/2019' and '9/30/2020 23:59'
order by DateOfService desc


/*
	CM Side 
	So run this and make sure you get selection
*/

exec prodsmartcare..ssp_CMReallocateClaimLineCoveragePlans  
  @StartDate='10/1/2019',								
  @EndDate='09/30/2020',			<--Make sure you update this					
  @InsurerId= null,								
  @ClientId=null,			<--Make sure you update this!					
  @ClaimLineId= null,								
  @CoveragePlanId = null,								
  @UserCode = 'wbarlow'	
  

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
and cl.FromDate>='10/1/2020' and cl.FromDate<'10/1/2021'
order by 1													

