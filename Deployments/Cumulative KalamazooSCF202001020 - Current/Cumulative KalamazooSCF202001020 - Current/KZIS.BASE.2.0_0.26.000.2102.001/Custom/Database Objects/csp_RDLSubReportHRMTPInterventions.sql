
/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportHRMTPInterventions]    Script Date: 11/27/2013 19:01:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportHRMTPInterventions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportHRMTPInterventions]
GO


/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportHRMTPInterventions]    Script Date: 11/27/2013 19:01:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[csp_RDLSubReportHRMTPInterventions]    
(                                            
@NeedId  int                                        
)                                            
As                                            
                                                    
Begin                                                    
/*********************************************************************/                                                      
/* Stored Procedure: csp_RDLSubReportTPGoals    */                                             
                                            
/* Copyright: 2006 Streamline SmartCare*/                                                      
                                            
/*
avoss	10/2/2009	added logic to show tpprocedure frequency if tpinterventionProcedure associated frequency is null
--Changes made by Atul Pandey- Ref Task No. #36 of 3.x Issues - To add Inactive field and effectiveEndDate in RDL  

*/

/*
chernandez	08/08/2018	converted Provider to Site in RDL Why: KCMHSAS - Support #1177
*/
/* 02/03/2020   Arul Sonia       What: Modified "DeletedRecord" check to fix pulling bad data in Interventions tab
								 Why:	KCMHSAS - Support #1599                                      */ 
/*********************************************************************/                                             
select a.TPInterventionProcedureId, 
null as InterventionText, 
case when a.siteid = -2 then 'Community/Natural Support' 
	else ltrim(Rtrim(isnull(Displayas, ''))) + ' / ' + isnull(d.SiteName, Ag.AgencyName) end as ServiceProvider, 
a.Units, 
isnull(gc.CodeName,c.CodeName) as FrequencyType, 
 ISNULL(CONVERT(VARCHAR(10),a.StartDate ,101),NULL) As  StartDate,
ISNULL(CONVERT(VARCHAR(10),a.EndDate ,101),NULL) As  EndDate
--Changes made by Atul Pandey - Ref Task No. 36 of 3.x Issues - To add Inactive field and effectiveEndDate in RDL  
,f.effectiveEndDate,    
isnull(f.Inactive,'N') as Inactive,  
isnull(a.InitializedFromPreviousPlan,'N') as InitializedFromPreviousPlan  
--Changes End here 
From TpInterventionProcedures a with (nolock) 
left join AuthorizationCodes b with (nolock) on a.AuthorizationCodeId = b.AuthorizationCodeId
left join GlobalCodes c with (nolock) on a.FrequencyType = c.GlobalCodeId
left join Sites d with (nolock) on d.SiteId = a.SiteId
left join Providers e with (nolock) on e.ProviderId = d.ProviderId
left join TPProcedures f with (nolock) on f.TpProcedureId = a.TpProcedureId	
left join globalCodes gc with (nolock) on gc.GlobalCodeId = f.FrequencyType
join Agency ag with (nolock) on ag.AgencyName = ag.AgencyName
Where  a.NeedId = @NeedId
and isnull(a.RecordDeleted, 'N')= 'N' 
and isnull(b.RecordDeleted, 'N')= 'N'
and isnull(c.RecordDeleted, 'N')= 'N'
and isnull(d.RecordDeleted, 'N')= 'N'
and isnull(e.RecordDeleted, 'N')= 'N'
and isnull(f.RecordDeleted, 'N')= 'N'
order by a.InterventionNumber





                   
  --Checking For Errors                              
  If (@@error!=0)                                            
  Begin                                            
   RAISERROR  ('csp_RDLSubReportTPGoals : An Error Occured',16,1)                                             
   Return                                            
   End                                                     
                       
End 
GO


