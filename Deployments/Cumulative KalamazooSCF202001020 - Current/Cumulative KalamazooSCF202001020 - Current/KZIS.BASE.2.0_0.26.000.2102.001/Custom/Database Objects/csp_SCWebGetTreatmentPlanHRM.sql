
/****** Object:  StoredProcedure [dbo].[csp_SCWebGetTreatmentPlanHRM]    Script Date: 11/27/2013 17:32:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCWebGetTreatmentPlanHRM]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCWebGetTreatmentPlanHRM]
GO


/****** Object:  StoredProcedure [dbo].[csp_SCWebGetTreatmentPlanHRM]    Script Date: 11/27/2013 17:32:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

       
       
CREATE  procedure [dbo].[csp_SCWebGetTreatmentPlanHRM]                                
@DocumentVersionId as int,                                                                                                              
@StaffId as int                                                                         
as                                                                                                
/*********************************************************************/                                                                                                            
/* Stored Procedure: dbo.csp_SCWebGetTreatmentPlanHRM*/                                                                                                            
/* Copyright: 2005 Provider Claim Management System             */                                                                                                            
/* Creation Date:  10/13/2006                                   */                                                                                                            
/*                                                                   */                                                                                                            
/* Purpose:Returns the Details of the TreatementPlan      */                                                                                                           
/*                                                                   */                                                                                                          
/* Input Parameters: @TableName , @Version, @StaffId    */                                                                                                          
/*                                                                   */                                                                                                            
/* Output Parameters:                                */                                                                                                            
/*                                                                   */                                                                                                            
/* Return:   */                                                                                                            
/*                                                                      */                                                                                                            
/* Called By:  TreatmentPlanHRM.cs                                                      */                                                                                                            
/*                                                                   */                                                                                                            
/* Calls:                                                            */                                                                                                            
/*                                                                   */                                                                                                            
/* Data Modifications:                                               */                                                                                                            
/*                                                                   */                                                                                                            
/* Updates:                                                          */                                                                                                            
/*  Date              Author       Purpose   */                                                        
/* 14/05/2008   Sonia      Created                                    */                                                  
/* 08/10/2008   Sonia        Modified With Ref to Task #2644 SC-Support*/                 
/*09/April/09 Priya Modified the table TPNeedsClientNeeds to CustomTPNeedsClientNeeds */                    
/*13/Oct/2010 Damanpreet Kaur Modified for UM Part2        */     
/* 8 april 2011 modified by maninder  PlanDeliveryStaff  */                               
/* 06 May 2013  Modified By shikha  w.rf to #39 in Allegan Support
				What:comment this "csp_SCGetTreatmentPlanDeliveryStaffList" and is now called directly from screen
				Why: Plandeliverystaff table makes UnsavedChangesXML heavy*/                                          
/* May 19 2013	Chuck Blaine	Switched WHERE clause to look at InProgressDocumentVersionId instead of CurrentDocumentVersionId when
								looking up @DocumentId local variable
19 June 2015	Munish Sood	Added condition to ensure that only one LOC is returned even if 2 exist without end dates w.r.t task #315 KCMHSAS 3.5 Impl.								
*/
/* 02/03/2020   Arul Sonia       What: Modified "DeletedRecord" check to fix pulling bad data in Interventions tab
								 Why:	KCMHSAS - Support #1599                                      */ 
/*************************************************
********************/                                                            
Begin  
BEGIN TRY                                 
declare @ClientEpisodeId int                                                       
select * from TPGeneral where DocumentVersionId=@DocumentVersionId  and (RecordDeleted='N' or RecordDeleted is null)                                                                                        
                                                                    
select * from TPNeeds where DocumentVersionId=@DocumentVersionId and (RecordDeleted='N' or RecordDeleted is null)                                                                 
                                                                                           
select * from TPObjectives where DocumentVersionId=@DocumentVersionId and (RecordDeleted='N' or RecordDeleted is null)                                                                                    
                                                                                           
/*select * from TPInterventions where DocumentID=@DocumentId and Version =@Version and (RecordDeleted='N' or RecordDeleted is null)                                                                                  
If (@@error!=0)    RAISERROR  20006  'ssp_SCGetTreatmentPlanHRM: An Error Occured' */                                                                                         
                                                      
select * from CustomTPNeedsClientNeeds TNC                                                      
join TPNeeds TN on TNC.NeedId=TN.NeedId                                                      
where DocumentVersionId=@DocumentVersionId and (TN.RecordDeleted='N' or TN.RecordDeleted is null)                                                                                            
and (TNC.RecordDeleted='N' or TNC.RecordDeleted is null)                                                                                    
                                                                                          
                                                                                         
                           
 Declare @SiteName as  varchar(100)                          
 set @SiteName = ( select AgencyName from Agency)                           
                                                      
--select TIP.TPInterventionProcedureId,TIP.NeedId,                          
--TIP.InterventionNumber,TIP.InterventionText,TIP.AuthorizationCodeId,TIP.Units,                          
--TIP.FrequencyType,TIP.ProviderId,Isnull(TIP.SiteId,'-1') as SiteId,                          
 Select TIP.*,                                                                      
case ISNULL(TIP.TPProcedureId,0)                                                                      
when 0 then 'N'                                                                      
else 'Y'    
END as 'RequestAuthorization' ,                  
TP.DocumentVersionId as TPProcedureSourceDocumentId,                                                      
--Following added by Sonia with ref to Task #2644                                                    
--TPProcedureAssociatedOrNot will be returned as 'Y' if its TPProcedureId IS NOT NULL                                                    
case ISNULL(TIP.TPProcedureId,0)                                                                      
when 0 then Convert(char(1),'N')                                                                     
else Convert(char(1),'Y')                              
END as 'TPProcedureAssociatedOrNot',                                    
AC.DisplayAs as AuthorizationCodeName,                          
 Isnull(S.SiteName,@SiteName) as SiteName                                                       
--Changes end over here                                                    
from TPInterventionProcedures as TIP                         
left outer join TPProcedures TP on TP.TPProcedureId=TIP.TPProcedureId                                         
join TPNeeds TN on TIP.NeedId=TN.NeedId                                             
left join Sites S on TIP.SiteId = S.SiteId    -- Modified By Rakesh From join to left join as In case of agency records not fetched from TPInterventionProcedures                                     
left join AuthorizationCodes AC on TIP.AuthorizationCodeId = AC.AuthorizationCodeId                                            
Where TN.DocumentVersionId= @DocumentVersionId and (TN.RecordDeleted='N' or TN.RecordDeleted is null)                                                                                            
and (TIP.RecordDeleted='N' or TIP.RecordDeleted is null) 
and ISNULL(TP.RecordDeleted,'N')<>'Y'                  
                  
                    
                                                                                            
                                                                                            
                                                                                        
                                                                                        
select * from TPInterventionProcedureObjectives TIPO                                                      
JOIN TPInterventionProcedures TIP on TIP.TPInterventionProcedureId=TIPO.TPInterventionProcedureId                                                      
JOIN TPNeeds TN on TN.NeedId=TIP.NeedId                                                      
where DocumentVersionId=@DocumentVersionId and (TN.RecordDeleted='N' or TN.RecordDeleted is null)                                       
and (TIP.RecordDeleted='N' or TIP.RecordDeleted is null)                                                                                 
and (TIPO.RecordDeleted='N' or TIPO.RecordDeleted is null)                                               
                                                                                        
                                                                                                 
                                                                         
                                                                     
--select * from TPProcedures where DocumentID=@DocumentID and Version =@Version and (RecordDeleted='N' or RecordDeleted is null)                                                                                            
                                                                                            
-- Modified by Prabhakar on 19-Dec-06                                                                                            
--Modified by Dinesh on 3-Jan-07                                           
                       
select distinct '' as DeleteButton, 'N' as RadioButton,TP.*,case isnull(P.ProviderName ,'N')                                                                                            
   when 'N' then ''                                                                   
   else P.ProviderName                                                                                             
    end                                                                         
  +                                                          
  case isnull(Au.ProviderId,'0')                                                                                            
  when '0' then Ag.AgencyName                                                                                           
  else ''                
  end                                                                                            
    as                  
                                                                               
 ProviderName,A.AuthorizationCodeName,GCA.CodeName as FrequencyApprovedName,GCS.CodeName AS FrequencyRequestedName,                                                                  
Au.Units as UnitsApproved,Au.StartDate as StartDateApproved,Au.EndDate as EndDateApproved,Au.Frequency as FrequencyApproved,Au.TotalUnits As TotalUnitsApproved, Au.AuthorizationNumber,Au.Status,Glc.CodeName,Au.UnitsUsed from Agency AS Ag, TpProcedures TP
  
     
     
        
          
            
              
                                                                                   
left join Sites S on S.SiteID = TP.SiteID and ( S.RecordDeleted='N' or  s.RecordDeleted is null)  and ( TP.RecordDeleted='N' or  TP.RecordDeleted is null)                                                                                            
                                                                                          
left join Providers P on P.ProviderID = S.ProviderID and ( P.RecordDeleted='N' or  P.RecordDeleted is null)  and ( S.RecordDeleted='N' or  S.RecordDeleted is null)                                                                                            
inner join AuthorizationCodes A on TP.AuthorizationCodeID = A.AuthorizationCodeID and ( A.RecordDeleted='N' or  A.RecordDeleted is null)                                                                                            
-- inner join GlobalCodes Gl on TP.UnitType = Gl.GlobalCodeId  Commented by Piytush as Unit Type field is now removed, 18th Jan 2007                                                                                            
left join Authorizations Au on Au.TpProcedureId = Tp.TpProcedureId  and ( Au.RecordDeleted='N' or  Au.RecordDeleted is null)                                                            
left join GlobalCodes GCA on GCA.GlobalCodeId = Au.Frequency  and (GCA.RecordDeleted='N' or GCA.RecordDeleted is null)                                                                                         
left join GlobalCodes GCR on GCR.GlobalCodeId = Au.FrequencyRequested and (GCR.RecordDeleted='N' or GCR.RecordDeleted is null)                                                                                            
left join  GlobalCodes Glc on  Au.Status=Glc.GlobalCodeId and (Glc.RecordDeleted='N' or Glc.RecordDeleted is null)                                                                                            
left join GlobalCodes  GCS  on GCS.GlobalCodeId = TP.FrequencyType and (GCS.RecordDeleted='N' or GCS.RecordDeleted is null)  --Add by sandeep trivedi                                                                                          
where TP.DocumentVersionId=@DocumentVersionId                                              
and (TP.RecordDeleted='N' or TP.RecordDeleted is null)                                                                                          
                                                          
                                                                                              
                                                                                            
-- Modified by Prabhakar on 19-Dec-06                                                                                            
select  AD.* from AuthorizationDocuments AD inner join Authorizations A                                                                                            
on AD.AuthorizationDocumentID = A.AuthorizationDocumentID             
inner join TPProcedures TP on TP.TPPRocedureID = A.TpPRocedureID                                                                                            
where Tp.DocumentVersionId=@DocumentVersionId                                              
and isnull(Tp.RecordDeleted,'N')='N'                                                                                          
                                                                                               
                                                     
-- Modified by Prabhakar on 19-Dec-06                                                               
Select TPA.* from TPProcedureAssociations TPA inner join TPProcedures TP                                                                                            
on TP.TPPRocedureID = TPA.TpPRocedureID where Tp.DocumentVersionId=@DocumentVersionId                                              
and isnull(Tp.RecordDeleted,'N')='N' and isnull(TPA.RecordDeleted,'N')='N'                                                                                          
                                                                     
                                                                                            
select * from TPQuickNeeds where StaffID=@StaffId and isnull(RecordDeleted,'N')='N' Order by TPElementORder                                                                                
                                                                                               
select * from TPQuickGoals where StaffID=@StaffId and isnull(RecordDeleted,'N')='N' Order by TPElementORder                                                                                            
                                                                                               
select * from TPQuickObjectives where StaffID=@StaffId and isnull(RecordDeleted,'N')='N' Order by TPElementORder                                                                      
                                                                                           
select * from TPQuickInterventions where StaffID=@StaffId and isnull(RecordDeleted,'N')='N' Order by TPElementORder                                                                                            
--Checking For Errors                                               
                                                                                               
select * from PeriodicReviews where DocumentVersionId=@DocumentVersionId  and (RecordDeleted='N' or RecordDeleted is null)                                                                                      
                                                        
select * from PeriodicReviewNeeds where DocumentVersionId=@DocumentVersionId  and (RecordDeleted='N' or RecordDeleted is null)                                                                                            
                                                                                          
                                                                                        
declare @DocumentId int                
declare @ClientId int                                           
Select  @DocumentId=DocumentId, @ClientId= ClientId from Documents where InProgressDocumentVersionId=@DocumentVersionId                                                              
exec ssp_SCWebGetHRMTPClientNeeds @ClientId,@DocumentId,'N',@DocumentVersionId                                                
                                       
                                
                                
select TPBC.[TPProcedureBillingCodeId]                              
      ,TPBC.[CreatedBy]                                
      ,TPBC.[CreatedDate]                                
      ,TPBC.[ModifiedBy]                                
      ,TPBC.[ModifiedDate]                                
 ,TPBC.[RecordDeleted]                                
      ,TPBC.[DeletedDate]                                
      ,TPBC.[DeletedBy]                                
      ,TPBC.[TPProcedureId]                                
 ,TPBC.[BillingCodeId]                                
      ,TPBC.[Modifier1]                           
      ,TPBC.[Modifier2]                                 
      ,TPBC.[Modifier3]                               
      ,TPBC.[Modifier4]                             
      ,TPBC.[Units]                                
      ,TPBC.[SystemGenerated]   from TPProcedureBillingCodes                                 
TPBC  join TPProcedures TP  on TPBC.TPProcedureId = TP.TPProcedureId                
where TP.DocumentVersionId = @DocumentVersionId                                
                                 
                               
                               
 -- Added By Rakesh Garg for Getting Custom CLient LOC        
         
 if exists (SELECT  ClientLOCId from CustomClientLOCs where ClientId = @ClientID and LOCEndDate IS NULL and Isnull(RecordDeleted,'N') = 'N')                  
 Begin                     
  select top 1 CCLoc.ClientLOCId,CCLoc.ClientId, CCLoc.CreatedBy, CCLoc.CreatedDate, CCLoc.ModifiedBy,                                 
 CCLoc.ModifiedDate, CCLoc.RecordDeleted, CCLoc.DeletedDate, CCLoc.DeletedBy,         
 CCLoc.LOCId, CCLoc.LOCStartDate, CCLoc.LOCEndDate, CCLoc.LOCBy                     
 from CustomClientLOCs CCLoc                    
 inner join Documents d on d.ClientId=CCLoc.ClientId                    
 inner join DocumentVersions dv on dv.DocumentId=d.DocumentId                    
 where dv.DocumentVersionId = @DocumentVersionId           
 and CCLoc.LOCEndDate IS NULL and Isnull(CCLoc.RecordDeleted,'N') = 'N' order by LOCStartDate DESC                                                           
 End                  
 else                    
 Begin          
  -- This is for getting existing document which have no CustomCLientLOCID  and have treatment plan HRM document signed or Inprogress previously                
  select  -1 as ClientLOCId,@ClientID as ClientId, -1 as LOCId  , '' as CreatedBy,                       
  getdate() as CreatedDate, '' as ModifiedBy, getdate() as ModifiedDate, 'CustomClientLOCs' as TableName                      
  End            
     
       
-- PlanDeliveryStaff                                 
-- commented by shikha as this sp is now called directly from code behind
--exec csp_SCGetTreatmentPlanDeliveryStaffList                                               
                      -- PreviouslyRequested  
exec ssp_SCTxPlanGetPreviouslyRequestedUnits @ClientId,@DocumentVersionId   
                                     
END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_SCWebGetTreatmentPlanHRM') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.    
				16
				,-- Severity.    
				1 -- State.    
				);
	END CATCH
END


