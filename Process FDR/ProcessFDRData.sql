--use kcmhsasSupplemental
 use prodSmartCare
/**************************************************************************************
-- Update Log 
-- Date        Author      Description
-- 2017-02-27  lcox        Added Client Name to output data
--
--
-- 1.30.2018   LAlberts		1) MCO-related updates: 
--							2) Updated stored procedure and table names 
--								to standardized names.
--
--							3) Updated ProdPCM database names to ProdSmartCare
							4) Added check date into mix
--
-- 2.26.2018				1) Updated the process to collect data based on check date,
--								and ignore dates of service. 
--
--								Made this update based on the results required. 
--
-- 3.22.2018				Added report request to Sharepoint; this process
--							Could be accomplished as a report, rather than run 
--							manually. 
--
-- 4.19.2018	LAlberts	Updated the process to required just a check number as
--							Input parameter rather than date. 
--							The business process entails writing one check on one day
--							   for FDR payments, and should not 
--								clash with any other checks written on behalf of clients
--								on that day receiving FDR payments. 
    2020-01-29   esova       changed reference from gp2015.dynamics_kcmhsas_supplemental.dbo.v_VendorsFDR 
	                                    to     dynamicsdb.dynamics_kcmhsas_supplemental.dbo.v_VendorsFDR 
							 new version of Dynamics next upgrade (in 2023?) should only need to update DNS/cname
*****************************************************************************************/

/**************************************/
/*  Update the check date parameter  */
/**************************************/
/**********************************************************************************************/
/*   L Alberts comments, as of April 2018: 

	Also, here are steps to Back out of an FDR run - 

		1) Select * from kt_FDR_MasterCheckRun order by CreatedDate desc
			The key is the FDRMasterCheckRunId. 
			Take note of this value, for the runs you have created and want to back out.
		2) Delete from kt_FDR_GLSummary where FDRMasterCheckRunId > 89 --  = the one to back out
		3) Delete from [dbo].[kt_FDR_CheckRun] where FDRMasterCheckRunId > 89 = the one to back out
		4) Delete from kt_FDR_MasterCheckRun where FDRMasterCheckRunId > 89

	The other 2 kt_FDR tables in ProdSmartCare are reference tables
*/
/**********************************************************************************************/
--    L Alberts - updated April 2018: 

--  Instructions - 

  -- 1) enter the Date the FDR checks were created below, plus the check number : 
  --   @CheckDate = 'MM-DD-YYYY'.   Press F5 and run this procedure. 
  --   @CheckNumber = NNNNN   in integer format. 
  --
  -- 2) Cut and paste the results into an EXCEL spreadsheet, and forward these to Kathy Wait. 
  --
/**********************************************************************************************/
declare @FDRMasterCheckRunId int
declare @CheckDate datetime

exec ksp_Process_FDR_GLSummary
@CheckDate = '05-26-2020', -- Starting post-MCO, you must enter the date FDR checks were created
@CheckNumber = 2023480, -- Starting 4.19.2018, check number must be entered also. 
						-- This number is an integer in the database. 
@FDRMasterCheckRunId  = @FDRMasterCheckRunId output

/*  If running this one step at a time, 
     the FDRMasterCheckRunId to use below can be found by checking the first record
		resulting from this query: 

		 select * from kt_FDR_MasterCheckRun order by CreatedDate desc

  The check run id will be logged in a record dated today
*/   
--Process the claims:


use prodsmartcare
--exec ksp_FDR_ProcessClaims 97 --  @FDRMasterCheckRunId
exec ksp_FDR_ProcessClaims @FDRMasterCheckRunId

--Get Total to compare to check run
--  Note that if the total is close but not exact, check with accounting; 
--    some miscellaneous credits may have come thru which they can address by hand

	select mcr.*
	     , s.CheckRunTotal 
	  from kt_FDR_MasterCheckRun mcr
	         join (select FDRMasterCheckRunId
	                    , SUM(PURCHAMT) as CheckRunTotal
                     from kt_FDR_CheckRun
                    group by FDRMasterCheckRunId) s on mcr.FDRMasterCheckRunId = s.FDRMasterCheckRunId
    where mcr.FDRMasterCheckRunId = @FDRMasterCheckRunId

   --  where mcr.FDRMasterCheckRunId = @FDRMasterCheckRunId
 
--Pull the data from the FDR_CheckRun table:

 select DOCNUM       = 
	                   COALESCE(c.LastName, '') + ', ' + COALESCE(c.FirstName, '') + ' ' +
	                   CONVERT(varchar(7),CoverageMonth,120) + ' ' + 
                       --CAST(ClientId as Varchar(6)) +  ' ' + 
                       CAST(FDRCheckRunId as varchar(6))	
      , DOCDATE      = CoverageMonth
      , VENDORID     = cr.VendorId
      , DESCRIP      = m.DESCRIP
      , PURCHAMT     = cr.PURCHAMT * m.AmountMultiplier
      , DISTACCTNUM  = coalesce (m.DISTACCTNUM,cr.DISTACCTNUM)
      , DISTRIBTYPE  = m.DISTRIBTYPE
      , DISTAMT      = cr.PURCHAMT * m.AmountMultiplier
      , DOCTYPE      = m.DOCTYPE
      , BatchId      = 'FDR ' + right('00' + cast(DATEPART(mm,CoverageMonth) as varchar(2)),2) + '-' + 
                      right(DATEPART(yy,CoverageMonth),2)
      , TEN99        = v.TEN99TYPE
      , Ten99Amt     = case TEN99TYPE 
                            when 1 then 0
                            else abs(cr.PURCHAMT)
                       end 
      , cr.ClientId
	  , ClientName = COALESCE(c.LastName, '') + ', ' + COALESCE(c.FirstName, '') + ' ' + COALESCE(c.MiddleName, '')
      --, PopulationName
      --, PayerName
     from kt_FDR_CheckRun cr 
            join kt_FDR_CheckRunMask m on 1 = 1
     --       join kcmhsasSupplemental.dbo.v_VendorsFDR v on cr.VendorId = v.VENDORID
			join dynamicsdb.dynamics_kcmhsas_supplemental.dbo.v_VendorsFDR v on cr.VendorId = v.VENDORID
            join Clients c on c.clientid = cr.ClientId 
 -- where cr.FDRMasterCheckRunId = 89 --  @FDRMasterCheckRunId
 where cr.FDRMasterCheckRunId =  @FDRMasterCheckRunId
  order by CoverageMonth,DOCNUM,DISTRIBTYPE desc
