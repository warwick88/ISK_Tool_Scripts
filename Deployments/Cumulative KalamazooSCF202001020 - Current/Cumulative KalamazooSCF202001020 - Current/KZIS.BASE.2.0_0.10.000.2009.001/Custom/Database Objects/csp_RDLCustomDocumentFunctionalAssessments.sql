IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentFunctionalAssessments]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_RDLCustomDocumentFunctionalAssessments]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentFunctionalAssessments]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_RDLCustomDocumentFunctionalAssessments] (@DocumentVersionId INT)
AS
/*********************************************************************/
/* Stored Procedure: [csp_RDLCustomDocumentFunctionalAssessments]              */
/* Creation Date:                                 */
/* Purpose: To RDL Get Data Conscents  Document     */
/* Input Parameters:   @DocumentVersionId         */
/* Output Parameters:                 */
/* Return:                 */
/* Called By:                                        */
/* Calls:                                                            */
/* CreatedBy:                                             */
/* Data Modifications:                                               */
/*   Updates:                                                        */
/*   Date               Author                  Purpose              */
/*	18-05-2020			Syed					KCMHSAS Improvements Task #12     */
/*	25-06-2020			Josekutty Varghese		What : Added new column named IsCommunicationExist in select query.
                                                Why  : Communication report do not show when no records exist in CustomAssessmentFunctionalCommunications table.			
												Portal Task: #12 in KCMHSAS Improvements  */
/*********************************************************************/
BEGIN
	BEGIN TRY

		SELECT CDFA.DocumentVersionId
			,dbo.csf_GetGlobalCodeNameById(CDFA.Dressing) AS Dressing						
			,dbo.csf_GetGlobalCodeNameById(CDFA.PersonalHygiene) AS PersonalHygiene		 				
			,dbo.csf_GetGlobalCodeNameById(CDFA.Bathing) AS Bathing								
			,dbo.csf_GetGlobalCodeNameById(CDFA.Eating) AS Eating								
			,dbo.csf_GetGlobalCodeNameById(CDFA.SleepHygiene) AS SleepHygiene						
			,CDFA.SelfCareSkillComments				
			,CDFA.SelfCareSkillNeedsList													
			,dbo.csf_GetGlobalCodeNameById(CDFA.FinancialTransactions) AS FinancialTransactions				
			,dbo.csf_GetGlobalCodeNameById(CDFA.ManagesPersonalFinances) AS ManagesPersonalFinances				
			,dbo.csf_GetGlobalCodeNameById(CDFA.CookingMealPreparation) AS 	CookingMealPreparation			
			,dbo.csf_GetGlobalCodeNameById(CDFA.KeepingRoomTidy) AS KeepingRoomTidy						
			,dbo.csf_GetGlobalCodeNameById(CDFA.HouseholdTasks) AS HouseholdTasks						
			,dbo.csf_GetGlobalCodeNameById(CDFA.LaundryTasks) AS LaundryTasks						
			,dbo.csf_GetGlobalCodeNameById(CDFA.HomeSafetyAwareness) AS HomeSafetyAwareness					
			,CDFA.DailyLivingSkillComments			
			,CDFA.DailyLivingSkillNeedsList			
			,dbo.csf_GetGlobalCodeNameById(CDFA.ComfortableInteracting) AS ComfortableInteracting				
			,dbo.csf_GetGlobalCodeNameById(CDFA.ComfortableLargerGroups) AS ComfortableLargerGroups				
			,dbo.csf_GetGlobalCodeNameById(CDFA.AppropriateConversations) AS AppropriateConversations			
			,dbo.csf_GetGlobalCodeNameById(CDFA.AdvocatesForSelf) AS AdvocatesForSelf					
			,dbo.csf_GetGlobalCodeNameById(CDFA.CommunicatesDailyLiving) AS CommunicatesDailyLiving				
			,CDFA.SocialComments						
			,CDFA.SocialSkillNeedsList				
			,dbo.csf_GetGlobalCodeNameById(CDFA.MaintainsFamily) AS MaintainsFamily						
			,dbo.csf_GetGlobalCodeNameById(CDFA.MaintainsFriendships) AS MaintainsFriendships				
			,dbo.csf_GetGlobalCodeNameById(CDFA.DemonstratesEmpathy) AS DemonstratesEmpathy					
			,dbo.csf_GetGlobalCodeNameById(CDFA.ManageEmotions) AS ManageEmotions						
			,CDFA.EmotionalComments					
			,CDFA.EmotionalNeedsList					
			,dbo.csf_GetGlobalCodeNameById(CDFA.RiskHarmToSelf) AS RiskHarmToSelf						
			,CDFA.RiskSelfComments					
			,dbo.csf_GetGlobalCodeNameById(CDFA.RiskHarmToOthers) AS RiskHarmToOthers					
			,CDFA.RiskOtherComments					
			,dbo.csf_GetGlobalCodeNameById(CDFA.PropertyDestruction) AS PropertyDestruction					
			,CDFA.PropertyDestructionComments			
			,dbo.csf_GetGlobalCodeNameById(CDFA.Elopement) AS Elopement							
			,CDFA.ElopementComments					
			,dbo.csf_GetGlobalCodeNameById(CDFA.MentalIllnessSymptoms) AS MentalIllnessSymptoms				
			,CDFA.MentalIllnessSymptomComments		
			,dbo.csf_GetGlobalCodeNameById(CDFA.RepetitiveBehaviors) AS RepetitiveBehaviors					
			,CDFA.RepetitiveBehaviorComments			
			,RTRIM(LTRIM(SocialEmotionalBehavioralOther)) As SocialEmotionalBehavioralOther				
			,CDFA.SocialEmotionalBehavioralNeedList	
			,CDFA.CommunicationComments				
			,CDFA.CommunicationNeedList				
			,dbo.csf_GetGlobalCodeNameById(CDFA.RentArrangements) AS RentArrangements					
			,dbo.csf_GetGlobalCodeNameById(CDFA.PayRentBillsOnTime) AS PayRentBillsOnTime					
			,dbo.csf_GetGlobalCodeNameById(CDFA.PersonalItems) AS PersonalItems						
			,dbo.csf_GetGlobalCodeNameById(CDFA.AttendSocialOutings) AS AttendSocialOutings					
			,dbo.csf_GetGlobalCodeNameById(CDFA.CommunityTransportation) AS CommunityTransportation				
			,dbo.csf_GetGlobalCodeNameById(CDFA.DangerousSituations) AS DangerousSituations					
			,dbo.csf_GetGlobalCodeNameById(CDFA.AdvocateForSelf) AS AdvocateForSelf						
			,dbo.csf_GetGlobalCodeNameById(CDFA.ManageChangesDailySchedule) AS ManageChangesDailySchedule			
			,CDFA.CommunityLivingSkillComments		
			,CDFA.PreferredActivities					
			,CDFA.CommunityLivingSkillNeedList	
			,(SELECT Case When Count(*) > 0 Then 'Y' Else 'N' End As IsCommunicationExist      
				FROM CustomAssessmentFunctionalCommunications C       
				Inner JOIN GlobalCodes GC ON GC.GlobalCodeId = C.Communication        
				INNER JOIN CustomDocumentMHAssessments CHRMA ON CHRMA.DocumentVersionId = C.DocumentVersionId      
				AND C.DocumentVersionId = @DocumentVersionId AND  CHRMA.ClientInDDPopulation = 'Y' AND ISNULL(C.RecordDeleted, 'N') = 'N'       
				WHERE Category = 'XCommunication' ) IsCommunicationExist    	
		FROM CustomDocumentFunctionalAssessments CDFA
		INNER JOIN CustomDocumentMHAssessments CHRMA ON CHRMA.DocumentVersionId = CDFA.DocumentVersionId
		WHERE CDFA.DocumentVersionId = @DocumentVersionId AND  CHRMA.ClientInDDPopulation = 'Y'
		AND ISNULL(CDFA.RecordDeleted, 'N') = 'N'	

	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLCustomDocumentFunctionalAssessments') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                  
				16
				,-- Severity.                                                                  
				1 -- State.                                                                  
				);
	END CATCH
END

