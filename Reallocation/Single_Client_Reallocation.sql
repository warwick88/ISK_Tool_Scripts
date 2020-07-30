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
