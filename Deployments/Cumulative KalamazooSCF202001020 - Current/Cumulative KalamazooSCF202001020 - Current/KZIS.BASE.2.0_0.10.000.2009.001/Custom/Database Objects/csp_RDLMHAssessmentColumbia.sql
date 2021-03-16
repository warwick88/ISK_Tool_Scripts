IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLMHAssessmentColumbia]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_RDLMHAssessmentColumbia]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_RDLMHAssessmentColumbia] (@DocumentVersionId AS INT)
AS
 /*********************************************************************/
 /* Stored Procedure: [csp_PostUpdateMHAssessment]   */

 /*       Date              Author                  Purpose                   */ 
 /*       28/May/2020      Jyothi Bellapu          RDL sp for Columbia part of Kalamazoo - Improvements -#7*/
 /*********************************************************************/  
 
BEGIN
	 BEGIN TRY  
  DECLARE @OrganizationName VARCHAR(250)  
  declare @ActualLethalityMedicalDamageDES Varchar(max)  
  declare @ActualLethalityMedicalDamage Varchar(max)  
  
  SELECT TOP 1 @OrganizationName = OrganizationName  
  FROM SystemConfigurations  
  set @ActualLethalityMedicalDamageDES =(select dbo.csf_GetGlobalCodeNameById(ActualLethalityMedicalDamage) from CustomDocumentMHColumbiaAdultSinceLastVisits where DocumentVersionId = @DocumentVersionId)  
    
  if(@ActualLethalityMedicalDamageDES = '0 - No physical damage or very minor')  
    begin  
    set @ActualLethalityMedicalDamage ='0.No physical damage or very minor physical damage (e.g., surface scratches).'   
    end  
    else if(@ActualLethalityMedicalDamageDES = '1 - Minor physical damage')  
    begin  
    set @ActualLethalityMedicalDamage ='1.Minor physical damage (e.g., lethargic speech; first-degree burns; mild bleeding; sprains).'  
    end  
    else if(@ActualLethalityMedicalDamageDES = '2 - Moderate physical damage')  
    begin  
    set @ActualLethalityMedicalDamage ='2.Moderate physical damage; medical attention needed (e.g., conscious but sleepy, somewhat responsive; second-degree burns; bleeding of major vessel).'  
    end  
    else if(@ActualLethalityMedicalDamageDES = '3 - Moderately severe physical damage')  
    begin  
    set @ActualLethalityMedicalDamage ='3.Moderately severe physical damage; medical hospitalization and likely intensive care required (e.g., comatose with reflexes intact; third-degree burns less than 20% of body; extensive blood loss but can recover; m
ajor fractures).'  
    end  
    else if(@ActualLethalityMedicalDamageDES = '4 - Severe physical damage')  
    begin  
    set @ActualLethalityMedicalDamage ='4.Severe physical damage; medical hospitalization with intensive care required (e.g., comatose without reflexes; third-degree burns over 20% of body; extensive blood loss with unstable vital signs; major damage to a
 vital area).'  
    end  
    else if(@ActualLethalityMedicalDamageDES = '5 - Death')  
    begin  
    set @ActualLethalityMedicalDamage ='5.Death'  
    end  
  
  SELECT CDCSLV.DocumentVersionId  
   ,dbo.csf_GetGlobalCodeNameById(CDCSLV.WishToBeDead) AS WishToBeDead  
   ,CDCSLV.WishToBeDeadDescription  
   ,dbo.csf_GetGlobalCodeNameById(CDCSLV.NonSpecificActiveSuicidalThoughts) AS NonSpecificActiveSuicidalThoughts  
   ,CDCSLV.NonSpecificActiveSuicidalThoughtsDescription  
   ,dbo.csf_GetGlobalCodeNameById(CDCSLV.ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToAct) AS ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToAct  
   ,CDCSLV.ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToActDescription  
   ,dbo.csf_GetGlobalCodeNameById(CDCSLV.ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlan) AS ActiveSuicidalIdeationWithSomeIntenttoActWithoutSpecificPlan  
   ,CDCSLV.ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlanDescription  
   ,dbo.csf_GetGlobalCodeNameById(CDCSLV.AciveSuicidalIdeationWithSpecificPlanAndIntent) AS AciveSuicidalIdeationWithSpecificPlanAndIntent  
   ,CDCSLV.AciveSuicidalIdeationWithSpecificPlanAndIntentDescription  
   ,dbo.csf_GetGlobalCodeNameById(CDCSLV.MostSevereIdeation) AS MostSevereIdeation  
   ,CDCSLV.MostSevereIdeationDescription  
   ,dbo.csf_GetGlobalCodeNameById(CDCSLV.Frequency) AS Frequency  
   ,dbo.csf_GetGlobalCodeNameById(CDCSLV.ActualAttempt) AS ActualAttempt  
   ,CDCSLV.TotalNumberOfAttempts  
   ,CDCSLV.ActualAttemptDescription  
   ,dbo.csf_GetGlobalCodeNameById(CDCSLV.HasSubjectEngagedInNonSuicidalSelfInjuriousBehavior) AS HasSubjectEngagedInNonSuicidalSelfInjuriousBehavior  
   ,dbo.csf_GetGlobalCodeNameById(CDCSLV.HasSubjectEngagedInSelfInjuriousBehaviorIntentUnknown) AS HasSubjectEngagedInSelfInjuriousBehaviorIntentUnknown  
   ,dbo.csf_GetGlobalCodeNameById(CDCSLV.InterruptedAttempt) AS InterruptedAttempt  
   ,CDCSLV.TotalNumberOfAttemptsInterrupted  
   ,CDCSLV.InterruptedAttemptDescription  
   ,dbo.csf_GetGlobalCodeNameById(CDCSLV.AbortedOrSelfInterruptedAttempt) AS AbortedOrSelfInterruptedAttempt  
   ,CDCSLV.TotalNumberAttemptsAbortedOrSelfInterrupted  
   ,CDCSLV.AbortedOrSelfInterruptedAttemptDescription  
   ,dbo.csf_GetGlobalCodeNameById(CDCSLV.PreparatoryActsOrBehavior) AS PreparatoryActsOrBehavior  
   ,CDCSLV.TotalNumberOfPreparatoryActs  
   ,CDCSLV.PreparatoryActsOrBehaviorDescription  
   ,dbo.csf_GetGlobalCodeNameById(CDCSLV.SuicidalBehavior) AS SuicidalBehavior  
   ,convert(varchar(20),CDCSLV.MostLethalAttemptDate,101) as MostLethalAttemptDate  
   ,dbo.csf_GetGlobalCodeNameById(CDCSLV.PotentialLethality) AS PotentialLethality  
   ,D.ClientID AS ClientID  
   ,@OrganizationName AS OrganizationName  
   ,@ActualLethalityMedicalDamage as ActualLethalityMedicalDamage   
     
  FROM [CustomDocumentMHColumbiaAdultSinceLastVisits] CDCSLV  
  INNER JOIN DocumentVersions dv ON dv.DocumentVersionId = CDCSLV.DocumentVersionId  
  INNER JOIN Documents D ON D.DocumentId = dv.DocumentId  
  INNER JOIN Clients C ON D.ClientId = C.ClientId  
   AND ISNULL(C.RecordDeleted, 'N') <> 'Y'  
  WHERE CDCSLV.DocumentVersionId = @DocumentVersionId  
   AND ISNULL(CDCSLV.RecordDeleted, 'N') = 'N'  
 END TRY  
  

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLMHAssessmentColumbia') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                          
				16
				,-- Severity.                                                          
				1 -- State.                                                          
				)
	END CATCH
END

