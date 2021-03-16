/****** Object:  StoredProcedure [dbo].[csp_GetCoreDocumentGoalsAndObjective]      ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetCoreDocumentGoalsAndObjective]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetCoreDocumentGoalsAndObjective]
GO


/****** Object:  StoredProcedure [dbo].[csp_GetCoreDocumentGoalsAndObjective]      ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_GetCoreDocumentGoalsAndObjective]      
(                                              
             
		@RecentDocumentVersionId  int, 
		@DateOfService datetime, 
		@ProcedureCodeId int  
)                                              
As                                              
                                                      
                                             
/*********************************************************************/                                                        
/* Stored Procedure: csp_GetCoreDocumentGoalsAndObjective   */                                               
                                              
/* Copyright: 2008 Streamline SmartCare*/                                                        
                                             
/********************************************************************  
Vignesh  05/13/2020  What: Implemented the logic to get the core care plan document goals and objective.
					 Why : KCMHSAS Improvements #13
  
********************************************************************/                                               
Begin    

 /* Goals Section  */   
          SELECT DISTINCT CDCPG.[CarePlanGoalId] as NeedId
						  ,CDCPG.[DocumentVersionId] AS DocumentVersionId  
						  ,CDCPG.[GoalNumber] AS NeedNumber 
						  ,CDCPG.[AssociatedGoalDescription] AS NeedText
						  ,CDCPG.[GoalReviewUpdate] AS NeedTextRTF
						  ,CDCPG.[CreatedDate] AS NeedCreatedDate             
						  ,CDCPG.[ModifiedDate] AS NeedModifiedDate 
						  ,CDCPG.[ClientGoal] AS GoalText
						  ,CDCPG.[AssociatedGoalDescription] AS GoalTextRTF
						  ,NULL AS GoalDesiredResults
						  ,CDCPG.GoalActive AS GoalActive 
						  ,NULL AS GoalNaturalSupports
						  ,NULL AS GoalLivingArrangement
						  ,NULL AS GoalEmployment
						  ,NULL AS GoalHealthSafety             
						  ,NULL AS GoalStrengths             
						  ,NULL AS GoalBarriers
						  ,CDCPG.GoalStartDate	AS GoalStartDate
						  ,CDCPG.GoalEndDate AS GoalTargetDate
						  ,CDCPG.IsError AS StageOfTreatment
						  ,CDCPG.CarePlanDomainGoalId AS SourceNeedId
                          ,CDCPG.[CreatedBy]   
                          ,CDCPG.[CreatedDate]   
                          ,CDCPG.[ModifiedBy]   
                          ,CDCPG.[ModifiedDate]   
                          ,CDCPG.[RecordDeleted]   
                          ,CDCPG.[DeletedBy]   
                          ,CDCPG.[DeletedDate]     
          FROM   [CarePlanGoals] CDCPG   
                 LEFT JOIN CarePlanDomainGoals CCPDG   
                        ON   
                 CDCPG.[CarePlanDomainGoalId] = CCPDG.[CarePlanDomainGoalId]   
                 AND ISNULL(CCPDG.RecordDeleted, 'N') = 'N'   
          WHERE  CDCPG.DocumentVersionId = @RecentDocumentVersionId    
                 AND ISNULL(CDCPG.RecordDeleted, 'N') = 'N'  
     AND ISNull(CDCPG.GoalActive,'N')='Y'    
    and (CDCPG.GoalEndDate IS NULL OR CAST(CDCPG.GoalEndDate AS DATE) >= CAST(@DateOfService AS DATE))  
          ORDER  BY CDCPG.DocumentVersionId     
                    ,CDCPG.GoalNumber      
                  
  
          /* Objectives Section */   
          SELECT DISTINCT CDCPO.[CarePlanObjectiveId]  AS ObjectiveId
						  ,@RecentDocumentVersionId AS DocumentVersionId 
						  ,CDCPO.[CarePlanGoalId]  AS NeedId
						  ,CDCPO.[ObjectiveNumber] AS ObjectiveNumber
						  ,CDCPO.[AssociatedObjectiveDescription] AS  ObjectiveText
						  ,CDCPO.[ObjectiveReview] AS ObjectiveTextRTF
						  ,CDCPO.[Status] AS ObjectiveStatus
						  ,CDCPO.[ObjectiveEndDate] AS TargetDate
						  ,NULL AS RowIdentifier
                          ,CDCPO.[CreatedBy]   
                          ,CDCPO.[CreatedDate]   
                          ,CDCPO.[ModifiedBy]   
                          ,CDCPO.[ModifiedDate]   
                          ,CDCPO.[RecordDeleted]   
                          ,CDCPO.[DeletedDate]
						  ,CDCPO.[DeletedBy]   
                          ,'Other Goals / Objectives' as ObjectiveGrouping  
          FROM   CarePlanObjectives CDCPO   
                 LEFT JOIN CarePlanDomainObjectives CCPDO   
                        ON   
      CDCPO.[CarePlanDomainObjectiveId] = CCPDO.[CarePlanDomainObjectiveId]   
      AND ISNULL(CCPDO.RecordDeleted, 'N') = 'N'   
      INNER JOIN CarePlanPrescribedServiceObjectives CDCPSO   
              ON CDCPSO.CarePlanObjectiveId = CDCPO.[CarePlanObjectiveId]   
      INNER JOIN CarePlanPrescribedServices CDCPS   
              ON   
      CDCPS.CarePlanPrescribedServiceId = CDCPSO.CarePlanPrescribedServiceId   
   Left JOIN  CarePlanGoals CDTPG  ON CDCPO.CarePlanGoalId = CDTPG.CarePlanGoalId   AND  ISNULL(CDTPG.RecordDeleted,'N')='N'  and  ISNULL(CDTPG.GoalActive,'Y') ='Y'  
          WHERE  CDCPS.DocumentVersionId = @RecentDocumentVersionId    
                 AND ISNULL(CDCPO.RecordDeleted, 'N') = 'N'   
                 AND ISNULL(CDCPS.RecordDeleted, 'N') = 'N'   
                 AND ISNULL(CDCPSO.RecordDeleted, 'N') = 'N'     
     and (CDTPG.GoalEndDate IS NULL OR CAST(CDTPG.GoalEndDate AS DATE) >= CAST(@DateOfService AS DATE))  
   order by CDCPO.ObjectiveNumber    

                
  If (@@error!=0)                                              
  Begin                                              
   RAISERROR ('csp_GetCoreDocumentGoalsAndObjective : An Error Occured',16,1)                                               
   Return                                              
   End  
End