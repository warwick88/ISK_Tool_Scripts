 IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SCSP_SCWEBGETRECENTTREATMENTPLANORADDENDUM]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SCSP_SCWEBGETRECENTTREATMENTPLANORADDENDUM]
GO
 
 CREATE PROCEDURE [DBO].[SCSP_SCWEBGETRECENTTREATMENTPLANORADDENDUM]   
/********************************************************************************                                                      
-- Stored Procedure: [scsp_ListPageAllergies]  
--    
-- Copyright: Streamline Healthcate Solutions    
--    
-- Purpose: Customization support for list page depending on the custom filter selection.    
--    
 Date                    Author               Purpose        
 01-03-2018				Kishore			      F&CS Enhancement -Task #7		        
*********************************************************************************/    
    
 @ClientId BIGINT,  
    @DateOfService DATETIME,  
    @ProcedureCodeId INT  
     
AS    
BEGIN    
 BEGIN TRY  
   
  DECLARE @RecentDocumentVersionId AS INT                               
                                 
   SELECT TOP 1 @RecentDocumentVersionId = CurrentDocumentVersionId           
   FROM documents           
   WHERE documentcodeid in (350,503,2)                                 
     and ClientId=@ClientId                  
     and status=22           
     and effectivedate<=CONVERT(DATETIME,CONVERT(VARCHAR,@DateOfService,101))                                 
     and ISNULL(RecordDeleted,'N')='N'                                
   ORDER BY effectivedate DESC,modifieddate DESC   
   
   
   SELECT NeedId,             
   DocumentVersionId,             
   NeedNumber,             
   NeedText,             
   NeedTextRTF,             
   NeedCreatedDate,             
   NeedModifiedDate,             
   GoalText,             
   GoalTextRTF,             
   GoalDesiredResults,             
   GoalActive,             
   GoalNaturalSupports,             
   GoalLivingArrangement,             
   GoalEmployment,             
   GoalHealthSafety,             
   GoalStrengths,             
   GoalBarriers,             
   --GoalMonitoredBy,             
   GoalStartDate,             
   GoalTargetDate,             
   StageOfTreatment,             
   SourceNeedId,            
   --RowIdentifier,                                
   CreatedBy,                                
   CreatedDate,                                
   ModifiedBy,                                
   ModifiedDate,                                
   RecordDeleted,                                
   DeletedDate,                                
   DeletedBy           
    FROM TpNeeds       
    where DocumentVersionId=@RecentDocumentVersionId       
    and Isnull(RecordDeleted,'N')='N'       
    and GoalActive='Y'              
           
             
    -- Data from TPObjectives            
           
   SELECT  o.ObjectiveId,             
   o.DocumentVersionId,             
   o.NeedId,             
   o.ObjectiveNumber,             
   o.ObjectiveText,             
   o.ObjectiveTextRTF,             
   o.ObjectiveStatus,             
   o.TargetDate,             
   o.RowIdentifier,             
   o.CreatedBy,             
   o.CreatedDate,             
   o.ModifiedBy,             
   o.ModifiedDate,             
   o.RecordDeleted,             
   o.DeletedDate,             
   o.DeletedBy,      
   Case when exists (Select * from TPInterventionProcedures ip      
      Join AuthorizationCodeProcedureCodes apc on apc.AuthorizationCodeId = ip.AuthorizationCodeId       
      Where ip.NeedId = o.NeedId      
      and apc.ProcedureCodeId = @ProcedureCodeId      
      and ISNULL(ip.RecordDeleted, 'N')= 'N'      
      and ISNULL(apc.RecordDeleted, 'N')= 'N' )      
    then 'Goals / Objectives indicating this procedure based upon intervention(s)'      
    else 'Other Goals / Objectives'      
   End as ObjectiveGrouping        
               
   FROM  TPObjectives o      
   Join TPNeeds n on n.NeedId = o.NeedId      
          
   WHERE          
     ISNULL(n.GoalActive, 'N') = 'Y'         
     AND o.DocumentVersionId = @RecentDocumentVersionId           
     AND o.ObjectiveStatus IN (191)           
     AND ISNULL(o.RecordDeleted, 'N') = 'N'      
     and ISNULL(n.RecordDeleted, 'N') = 'N'  
    
 END TRY  
 BEGIN CATCH  
 DECLARE @Error VARCHAR(8000)  
 set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())  
 + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'scsp_SCWebGetRecentTreatmentPlanOrAddendum')  
 + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())  
 + '*****' + Convert(varchar,ERROR_STATE())  
 End Catch  
    
   
END    
  
  