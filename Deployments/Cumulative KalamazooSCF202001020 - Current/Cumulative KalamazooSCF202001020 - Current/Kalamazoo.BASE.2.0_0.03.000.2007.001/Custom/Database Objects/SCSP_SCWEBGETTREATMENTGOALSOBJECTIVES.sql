/****** Object:  StoredProcedure [dbo].[SCSP_SCWEBGETTREATMENTGOALSOBJECTIVES]      ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SCSP_SCWEBGETTREATMENTGOALSOBJECTIVES]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SCSP_SCWEBGETTREATMENTGOALSOBJECTIVES]
GO


/****** Object:  StoredProcedure [dbo].[SCSP_SCWEBGETTREATMENTGOALSOBJECTIVES]      ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
                    
CREATE PROCEDURE [DBO].[SCSP_SCWEBGETTREATMENTGOALSOBJECTIVES]   
(              
            
@ClientId bigint,                    
@DateOfService datetime,                     
@ProcedureCodeId int        
) As                          
                          
                          
/******************************************************************************                                          
**  File:                                           
**  Name: scsp_SCWebGetTreatmentGoalsObjectives                                          
**  Desc:                             
**                                          
**  This Stored procedure gets the latest signed Treatment Plan or Addendum for the client.                          
**                                                        
**  Return values:A Result set containing information about recent signed treatment plan or addendum.                                          
**                                           
                                    
**                                                        
**  Parameters:                                          
**  Input    Output                                          
**     ----------       -----------                                          
  28/12/2008   Vikas Vyas  
  15 Nov -2011 Rakesh Garg Rename this sp from  ssp_SCWebGetRecentTreatmentPlanOrAddendum to   scsp_SCWebGetTreatmentGoalsObjectives w.r.f to task 22  
  #22 Service Details - Use SCSP rather than SSP SCHoneyBadger      
**  --------  --------    -------------------------------------------                                          
**                                    
                                
     /*Vignesh  05/13/2020  What: Implemented the logic to get the core care plan document goals and objective. If it's recently signed care plan
							Why : KCMHSAS Improvements #13*/                     
*******************************************************************************/                             
Begin                                
 Begin Try             
          
            
 Declare @RecentDocumentVersionId as int  
 Declare @documentcodeid int                                    
                                 
 select top 1 @RecentDocumentVersionId = CurrentDocumentVersionId  
 ,  @documentcodeid=documentcodeid           
 from documents           
 where documentcodeid in (350,503,2,1620)                                 
   and ClientId=@ClientId                  
   and status=22           
   and effectivedate<=convert(datetime,convert(varchar,@DateOfService,101))                                 
   and isnull(RecordDeleted,'N')='N'                                
 order by effectivedate desc,modifieddate desc             
       
   
    if(@documentcodeid=1620)
	begin
		EXEC csp_GetCoreDocumentGoalsAndObjective @RecentDocumentVersionId=@RecentDocumentVersionId,@DateOfService=@DateOfService,@ProcedureCodeId=@ProcedureCodeId
	end  
	else
	begin                        
                             
            
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
       and ISNULL(apc.RecordDeleted, 'N')= 'N'      
       )      
     then 'Goals / Objectives indicating this procedure based upon intervention(s)'      
     else 'Other Goals / Objectives'      
    End as ObjectiveGrouping        
             
 FROM    TPObjectives o      
 Join TPNeeds n on n.NeedId = o.NeedId      
        
 WHERE          
   ISNULL(n.GoalActive, 'N') = 'Y'         
   AND o.DocumentVersionId = @RecentDocumentVersionId           
   AND o.ObjectiveStatus IN (191)           
   AND ISNULL(o.RecordDeleted, 'N') = 'N'      
   and ISNULL(n.RecordDeleted, 'N') = 'N'         
         
           
     END     
            
              
 End Try                                
 Begin Catch                                
  declare @Error varchar(8000)                                                
  set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                 
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'scsp_SCWebGetTreatmentGoalsObjectives')                        
  + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                  
  + '*****' + Convert(varchar,ERROR_STATE())                                 
 End Catch                                
End   