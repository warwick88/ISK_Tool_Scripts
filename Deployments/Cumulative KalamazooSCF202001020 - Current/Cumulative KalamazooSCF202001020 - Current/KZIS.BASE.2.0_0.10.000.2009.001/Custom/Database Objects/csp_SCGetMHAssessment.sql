IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'csp_SCGetMHAssessment')
	BEGIN
		DROP  PROCEDURE  csp_SCGetMHAssessment
	END

GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[csp_SCGetMHAssessment]      
(                                                                                                                                                                                                                                          
  @DocumentVersionId int                                                                                                                               
)                                                                                                                                                                                                                                          
As                                                                                                                                                                                      
                                                                                                                                                                                    
 /*********************************************************************/
 /* Stored Procedure: [csp_RdlMHAssessmentSupports]   */

 /*       Date              Author                  Purpose                   */ 
 /*       28/May/2020      Jyothi Bellapu        GET SP  as part of Kalamazoo - Improvements -#7 */
 /*       18/Jun/2020      Josekutty Varghese      What : Added intialization for newly added tabs such as Diagnosis-IDD Eligibility and Functional Assessment
                                                   Why  : Initialization needs to happened for newly added tables
											       Portal Task: #12 in KCMHSAS Improvement  */ 
/*		  18/Sep/2020		Packia				What : Modified the CurrentdocumentVersionId to InProgressDocumentversionId for fetching ClientId to avoid the issue reported by QA i.e. all tabs are visible while creating seconf version of the document.*/											       
 /*********************************************************************/                                                                                                                                                                                    
                                                                                                                                                                                  
                                                                                                                                                     
BEGIN                                                                                                                                        
DECLARE @later datetime                                                    
set @later  = GETDATE()                                                                                                                                                        
DECLARE @ClientId int                                                                                                                                                         
                                                                                                                                                        
                                                                                                                                                          
SELECT @ClientId = ClientId from Documents where                                                                                                                                                         
 InProgressDocumentVersionId = @DocumentVersionId and IsNull(RecordDeleted,'N')= 'N'                                                                          
                                                                         
                          
DECLARE @LatestDocumentVersionID int  
DECLARE @clientName    varchar(100)                                                 
DECLARE @clientFirstName varchar(100)  
DECLARE @clientLastName varchar(100)                                                                                                            
DECLARE @clientDOB varchar(10)   
DECLARE @GuardianCity VARCHAR(100)  
DECLARE @GuardianState VARCHAR(100)  
DECLARE @GuardianZipCode VARCHAR(100)  
DECLARE @GuardianRelationship INT                                                                                                                                                                                  
DECLARE @clientAge varchar(50)                                      
DECLARE @InitialRequestDate datetime                                
-- For GuardianTypeText                              
--DECLARE @GuardianTypeText varchar(250)                              
                                                                  
 DECLARE @CafasURL varchar(1024)                            
 set @CafasURL= (Select CafasURL from CustomConfigurations)                                                                                              
                                                                                                
set @clientName = (Select C.LastName + ', ' + C.FirstName as ClientName from Clients C                                                                              
    where C.ClientId=@ClientID and IsNull(C.RecordDeleted,'N')='N')  
	                                                                                                                 
set @clientDOB = (Select CONVERT(VARCHAR(10), DOB, 101) from Clients                                                   
    where ClientId=@ClientID and IsNull(RecordDeleted,'N')='N')            
                                                                                 
Exec csp_CalculateAge @ClientId, @clientAge out                    
                                                                      
                                                
set @InitialRequestDate=(Select Top 1 InitialRequestDate from ClientEpisodes CP where CP.ClientId=@ClientID                                                
and IsNull(Cp.RecordDeleted,'N')='N' and IsNull(CP.RecordDeleted,'N')='N' order by CP.InitialRequestDate desc)                                                 
                                
                                                                                                                                 
   BEGIN TRY                                                                     
    -----For CustomDocumentMHAssessments-----                                                                                                                                                                                
      SELECT                                                              
       [DocumentVersionId]                                          
      ,[ClientName]                                          
      ,[AssessmentType]                                          
      --,[CurrentAssessmentDate]                                          
      ,[PreviousAssessmentDate]                                          
      ,[ClientDOB]                                          
      ,[AdultOrChild]                                          
      ,[ChildHasNoParentalConsent]                                          
      ,[ClientHasGuardian]                                          
      ,[GuardianFirstName]
	  ,[GuardianLastName]                                          
      ,[GuardianAddress] 
	  ,[GuardianCity] 
	  ,[GuardianState]
	  ,[GuardianZipcode]                                        
      ,[GuardianPhone]                                          
      ,[RelationWithGuardian]                                          
      ,[ClientInDDPopulation]                                          
      ,[ClientInSAPopulation]                                          
      ,[ClientInMHPopulation]                                          
      ,[PreviousDiagnosisText]                                          
      ,[ReferralType]                                          
      ,[PresentingProblem]                        
      ,[CurrentLivingArrangement]                                          
      ,[CurrentPrimaryCarePhysician]                      
      ,[ReasonForUpdate]           
      ,[DesiredOutcomes]                                          
      ,[PsMedicationsComment]                                          
      ,[PsEducationComment]                             
      ,[IncludeFunctionalAssessment]                                          
      ,[IncludeSymptomChecklist]                                          
      ,[IncludeUNCOPE]                                          
      ,[ClientIsAppropriateForTreatment]                                          
      ,[SecondOpinionNoticeProvided]                                          
      ,[TreatmentNarrative]                                          
      ,[RapCiDomainIntensity]                                          
      ,[RapCiDomainComment]                                          
      ,[RapCiDomainNeedsList]                                          
      ,[RapCbDomainIntensity]                                         
      ,[RapCbDomainComment]                      
      ,[RapCbDomainNeedsList]                                          
      ,[RapCaDomainIntensity]                                          
      ,[RapCaDomainComment]                                          
      ,[RapCaDomainNeedsList]                                          
      ,[RapHhcDomainIntensity]                                          
      ,[OutsideReferralsGiven]                                          
      ,[ReferralsNarrative]                                          
      ,[ServiceOther]                                          
      ,[ServiceOtherDescription]                                          
      ,[AssessmentAddtionalInformation]                                          
      ,[TreatmentAccomodation]                                          
      ,[Participants]                                          
      ,[Facilitator]                                          
      ,[TimeLocation]                                          
      ,[AssessmentsNeeded]                                          
      ,[CommunicationAccomodations]                                          
      ,[IssuesToAvoid]                                          
      ,[IssuesToDiscuss]                                          
      ,[SourceOfPrePlanningInfo]                                          
      ,[SelfDeterminationDesired]                                  
      ,[FiscalIntermediaryDesired]                                          
      ,[PamphletGiven]                                          
      ,[PamphletDiscussed]                                          
      ,[PrePlanIndependentFacilitatorDiscussed]                                          
      ,[PrePlanIndependentFacilitatorDesired]                                          
      ,[PrePlanGuardianContacted]                                          
      ,[PrePlanSeparateDocument]                                          
      ,[CommunityActivitiesCurrentDesired]                                          
      ,[CommunityActivitiesIncreaseDesired]                                          
      ,[CommunityActivitiesNeedsList]                                          
      ,[PsCurrentHealthIssues]                                          
      ,[PsCurrentHealthIssuesComment]                                          
      ,[PsCurrentHealthIssuesNeedsList]                                          
      ,[HistMentalHealthTx]                                          
      ,[HistMentalHealthTxNeedsList]                                          
      ,[HistMentalHealthTxComment]                                          
      ,[HistFamilyMentalHealthTx]                                          
      ,[HistFamilyMentalHealthTxNeedsList]                                          
      ,[HistFamilyMentalHealthTxComment]                          
      ,[PsClientAbuseIssues]                                          
      ,[PsClientAbuesIssuesComment]                                          
      ,[PsClientAbuseIssuesNeedsList]                                          
      ,[PsFamilyConcernsComment]                                          
      ,[PsRiskLossOfPlacement]                                          
      ,[PsRiskLossOfPlacementDueTo]                                          
      ,[PsRiskSensoryMotorFunction]                                          
      ,[PsRiskSensoryMotorFunctionDueTo]                                          
      ,[PsRiskSafety]                                          
      ,[PsRiskSafetyDueTo]                                          
      ,[PsRiskLossOfSupport]                                          
      ,[PsRiskLossOfSupportDueTo]                                          
      ,[PsRiskExpulsionFromSchool]                                          
     ,[PsRiskExpulsionFromSchoolDueTo]                                          
      ,[PsRiskHospitalization]                                          
      ,[PsRiskHospitalizationDueTo]                                          
      ,[PsRiskCriminalJusticeSystem]                           
      ,[PsRiskCriminalJusticeSystemDueTo]                                          
      ,[PsRiskElopementFromHome]                                          
      ,[PsRiskElopementFromHomeDueTo]                                          
      ,[PsRiskLossOfFinancialStatus]                                          
      ,[PsRiskLossOfFinancialStatusDueTo]                                          
      ,[PsDevelopmentalMilestones]                                          
      ,[PsDevelopmentalMilestonesComment]                                          
      ,[PsDevelopmentalMilestonesNeedsList]                                          
      ,[PsChildEnvironmentalFactors]                                            
      ,[PsChildEnvironmentalFactorsComment]                                          
      ,[PsChildEnvironmentalFactorsNeedsList]                                          
      ,[PsLanguageFunctioning]                              
      ,[PsLanguageFunctioningComment]                                          
      ,[PsLanguageFunctioningNeedsList]                                          
      ,[PsVisualFunctioning]                                          
      ,[PsVisualFunctioningComment]                                          
      ,[PsVisualFunctioningNeedsList]                                          
      ,[PsPrenatalExposure]                                          
      ,[PsPrenatalExposureComment]                                          
      ,[PsPrenatalExposureNeedsList]                                          
      ,[PsChildMentalHealthHistory]                                          
      ,[PsChildMentalHealthHistoryComment]                                          
      ,[PsChildMentalHealthHistoryNeedsList]                                          
      ,[PsIntellectualFunctioning]                                         
      ,[PsIntellectualFunctioningComment]                                          
      ,[PsIntellectualFunctioningNeedsList]                                          
      ,[PsLearningAbility]                                          
      ,[PsLearningAbilityComment]                                          
      ,[PsLearningAbilityNeedsList]                                          
      ,[PsFunctioningConcernComment]                                          
      ,[PsPeerInteraction]                                          
      ,[PsPeerInteractionComment]                                          
      ,[PsPeerInteractionNeedsList]                                          
      ,[PsParentalParticipation]                                          
      ,[PsParentalParticipationComment]                                          
     ,[PsParentalParticipationNeedsList]                                          
      ,[PsSchoolHistory]                                          
      ,[PsSchoolHistoryComment]                                          
      ,[PsSchoolHistoryNeedsList]                                          
      ,[PsImmunizations]      
      ,[PsImmunizationsComment]                                          
      ,[PsImmunizationsNeedsList]                                          
      ,[PsChildHousingIssues]                                          
      ,[PsChildHousingIssuesComment]                       
      ,[PsChildHousingIssuesNeedsList]                                          
      ,[PsSexuality]                                          
      ,[PsSexualityComment]                                          
      ,[PsSexualityNeedsList]                                          
      ,[PsFamilyFunctioning]                                          
      ,[PsFamilyFunctioningComment]                               
      ,[PsFamilyFunctioningNeedsList]                                          
      ,[PsTraumaticIncident]                                          
      ,[PsTraumaticIncidentComment]                                          
      ,[PsTraumaticIncidentNeedsList]                                          
      ,[HistDevelopmental]                            
      ,[HistDevelopmentalComment]                                          
      ,[HistResidential]                                          
      ,[HistResidentialComment]                                          
      ,[HistOccupational]                                          
      ,[HistOccupationalComment]                                          
      ,[HistLegalFinancial]                                          
      ,[HistLegalFinancialComment]                                          
      ,[SignificantEventsPastYear]                                          
      ,[PsGrossFineMotor]                                          
      ,[PsGrossFineMotorComment]                                          
      ,[PsGrossFineMotorNeedsList]                                          
      ,[PsSensoryPerceptual]                                          
      ,[PsSensoryPerceptualComment]                      
      ,[PsSensoryPerceptualNeedsList]                                          
      ,[PsCognitiveFunction]                                          
      ,[PsCognitiveFunctionComment]                                          
      ,[PsCognitiveFunctionNeedsList]                                          
      ,[PsCommunicativeFunction]                                          
      ,[PsCommunicativeFunctionComment]                                          
      ,[PsCommunicativeFunctionNeedsList]                         
      ,[PsCurrentPsychoSocialFunctiion]                                          
      ,[PsCurrentPsychoSocialFunctiionComment]                                          
      ,[PsCurrentPsychoSocialFunctiionNeedsList]                                          
      ,[PsAdaptiveEquipment]                                          
      ,[PsAdaptiveEquipmentComment]                                          
      ,[PsAdaptiveEquipmentNeedsList]                                          
      ,[PsSafetyMobilityHome]                                          
      ,[PsSafetyMobilityHomeComment]                                          
      ,[PsSafetyMobilityHomeNeedsList]                                          
      ,[PsHealthSafetyChecklistComplete]                                          
      ,[PsAccessibilityIssues]                                          
      ,[PsAccessibilityIssuesComment]                                          
     ,[PsAccessibilityIssuesNeedsList]                                          
      ,[PsEvacuationTraining]                                          
      ,[PsEvacuationTrainingComment]    
      ,[PsEvacuationTrainingNeedsList]                                          
      ,[Ps24HourSetting]                                          
      ,[Ps24HourSettingComment]                                          
      ,[Ps24HourSettingNeedsList]                                          
      ,[Ps24HourNeedsAwakeSupervision]                                          
      ,[PsSpecialEdEligibility]                  
      ,[PsSpecialEdEligibilityComment]                                          
      ,[PsSpecialEdEligibilityNeedsList]                                          
      ,[PsSpecialEdEnrolled]                                          
      ,[PsSpecialEdEnrolledComment]                                          
      ,[PsSpecialEdEnrolledNeedsList]                             
      ,[PsEmployer]                                          
      ,[PsEmployerComment]                                          
      ,[PsEmployerNeedsList]                                          
      ,[PsEmploymentIssues]                                          
      ,[PsEmploymentIssuesComment]                                          
      ,[PsEmploymentIssuesNeedsList]                                          
      ,[PsRestrictionsOccupational]                                          
      ,[PsRestrictionsOccupationalComment]                                          
      ,[PsRestrictionsOccupationalNeedsList]                                          
      ,[PsFunctionalAssessmentNeeded]                                          
      ,[PsAdvocacyNeeded]                                          
      ,[PsPlanDevelopmentNeeded]                                          
      ,[PsLinkingNeeded]                                          
      ,[PsDDInformationProvidedBy]                                          
    ,[HistPreviousDx]                                          
      ,[HistPreviousDxComment]                                          
      ,[PsLegalIssues]                                          
      ,[PsLegalIssuesComment]                                        
      ,[PsLegalIssuesNeedsList]                                          
      ,[PsCulturalEthnicIssues]                                          
      ,[PsCulturalEthnicIssuesComment]                                          
      ,[PsCulturalEthnicIssuesNeedsList]                        
      ,[PsSpiritualityIssues]                                          
      ,[PsSpiritualityIssuesComment]                                          
      ,[PsSpiritualityIssuesNeedsList]                              
      ,[SuicideIdeation]                                          
      ,[SuicideActive]                                          
      ,[SuicidePassive]                                          
      ,[SuicideMeans]                              
      ,[SuicidePlan]                                         
      ,[SuicideOtherRiskSelf]                                          
      ,[SuicideOtherRiskSelfComment]                                
      ,[HomicideIdeation]                                          
      ,[HomicideActive]                                          
      ,[HomicidePassive]                                        
      ,[HomicidePlan]                                          
      ,[HomicdeOtherRiskOthers]                                          
      ,[HomicideOtherRiskOthersComment]                                          
      ,[PhysicalAgressionNotPresent]                                          
      ,[PhysicalAgressionSelf]                                          
      ,[PhysicalAgressionOthers]                                          
      ,[PhysicalAgressionCurrentIssue]                                    
      ,[PhysicalAgressionNeedsList]                                          
      ,[PhysicalAgressionBehaviorsPastHistory]                                          
      ,[RiskAccessToWeapons]                                          
      ,[RiskAppropriateForAdditionalScreening]                                          
      ,[RiskClinicalIntervention]                                          
      ,[RiskOtherFactorsNone]                     
      ,[RiskOtherFactors]                                          
      ,[RiskOtherFactorsNeedsList]                                          
      ,[StaffAxisV]                                          
      ,[StaffAxisVReason]                                          
      ,[ClientStrengthsNarrative]                                          
      ,[CrisisPlanningClientHasPlan]                                          
      ,[CrisisPlanningNarrative]                                          
      ,[CrisisPlanningDesired]                                          
      ,[CrisisPlanningNeedsList]                                          
    ,[CrisisPlanningMoreInfo]                                          
      ,[AdvanceDirectiveClientHasDirective]                                          
      ,[AdvanceDirectiveDesired]                                          
      ,[AdvanceDirectiveNarrative]                                          
      ,[AdvanceDirectiveNeedsList]                                          
      ,[AdvanceDirectiveMoreInfo]                                          
      ,[NaturalSupportSufficiency]                                          
      ,[NaturalSupportNeedsList]                                          
      ,[NaturalSupportIncreaseDesired]                                   
      ,[ClinicalSummary]                                          
      ,[UncopeQuestionU]                                          
      ,[UncopeApplicable]                                          
      ,[UncopeApplicableReason]                                          
      ,[UncopeQuestionN]                                          
      ,[UncopeQuestionC]                                          
      ,[UncopeQuestionO]                                          
      ,[UncopeQuestionP]                                          
      ,[UncopeQuestionE]                                          
      ,[UncopeCompleteFullSUAssessment]                        
      ,[SubstanceUseNeedsList]                                          
      ,[DecreaseSymptomsNeedsList]                                          
      ,[DDEPreviouslyMet]                                          
      ,[DDAttributableMentalPhysicalLimitation]                                          
      ,[DDDxAxisI]                                          
      ,[DDDxAxisII]                                          
      ,[DDDxAxisIII]                                          
      ,[DDDxAxisIV]                                          
      ,[DDDxAxisV]                                          
      ,[DDDxSource]                                          
      ,[DDManifestBeforeAge22]                                          
      ,[DDContinueIndefinitely]                                          
      ,[DDLimitSelfCare]                                          
      ,[DDLimitLanguage]                                          
      ,[DDLimitLearning]    
      ,[DDLimitMobility]                                    
      ,[DDLimitSelfDirection]                                          
      ,[DDLimitEconomic]                                          
      ,[DDLimitIndependentLiving]                                          
      ,[DDNeedMulitpleSupports]                                          
      ,[CAFASDate]                                          
      ,[RaterClinician]                                          
      ,[CAFASInterval]                                          
      ,[SchoolPerformance]                                          
      ,[SchoolPerformanceComment]                                          
      ,[HomePerformance]                                          
      ,[HomePerfomanceComment]                                          
      ,[CommunityPerformance]                                          
      ,[CommunityPerformanceComment]                                          
      ,[BehaviorTowardsOther]                                          
      ,[BehaviorTowardsOtherComment]                                          
      ,[MoodsEmotion]                                          
      ,[MoodsEmotionComment]                        
      ,[SelfHarmfulBehavior]                                          
      ,[SelfHarmfulBehaviorComment]                                
      ,[SubstanceUse]                                          
      ,[SubstanceUseComment]                                          
      ,[Thinkng]                                          
      ,[ThinkngComment]                                          
      ,[YouthTotalScore]                                          
      ,[PrimaryFamilyMaterialNeeds]                                          
      ,[PrimaryFamilyMaterialNeedsComment]                                          
      ,[PrimaryFamilySocialSupport]                                          
      ,[PrimaryFamilySocialSupportComment]             
      ,[NonCustodialMaterialNeeds]                                          
      ,[NonCustodialMaterialNeedsComment]                                          
      ,[NonCustodialSocialSupport]                                          
      ,[NonCustodialSocialSupportComment]                         
      ,[SurrogateMaterialNeeds]                                          
      ,[SurrogateMaterialNeedsComment]                                          
      ,[SurrogateSocialSupport]                                          
      ,[SurrogateSocialSupportComment]                                          
      ,[DischargeCriteria]                                          
      ,[PrePlanFiscalIntermediaryComment]                                          
      ,[StageOfChange]                                         
      ,[PsEducation]                                          
      ,[PsEducationNeedsList]                                          
      ,[PsMedications]                                          
      ,[PsMedicationsNeedsList]                                          
      ,[PsMedicationsListToBeModified]                                          
      ,[PhysicalConditionQuadriplegic]                                          
      ,[PhysicalConditionMultipleSclerosis]                                          
      ,[PhysicalConditionBlindness]                                          
      ,[PhysicalConditionDeafness]                                          
      ,[PhysicalConditionParaplegic]                                          
      ,[PhysicalConditionCerebral]                                      
      ,[PhysicalConditionMuteness]                                          
      ,[PhysicalConditionOtherHearingImpairment]                                          
      ,[TestingReportsReviewed]                                          
      ,C.[LOCId]                                          
      ,SevereProfoundDisability                                        
      ,SevereProfoundDisabilityComment                                       
      ,EmploymentStatus                                   
      ,DxTabDisabled                                        
      --,C.RowIdentifier                                          
      ,C.CreatedBy                                          
      ,C.CreatedDate                                          
      ,C.ModifiedBy                                          
      ,C.ModifiedDate                                          
      ,C.RecordDeleted                             
      ,C.DeletedDate                                          
      ,C.DeletedBy                                          
    --  ,InitialRequestDate                     
	   ,@clientAge as clientAge                                
	   ,G.CodeName as GuardianTypeText                       
	   ,@CafasURL as CafasURL                                  
	   ,locat.LOCCategoryName + ' / ' + loc.LOCName as LevelOfCare  -- need to add CustomLOCs.LOCName                  
	   ,locat.DeterminationDescription                   
	   ,loc.[Description]                  
	   ,loc.ADTCriteria                  
	   ,loc.ProviderQualifications     
		,PsMedicationsSideEffects        
		,AutisticallyImpaired        
		,CognitivelyImpaired        
		,EmotionallyImpaired        
		,BehavioralConcern        
		,LearningDisabilities        
		,PhysicalImpaired        
		,IEP        
		,ChallengesBarrier        
		,UnProtectedSexualRelationMoreThenOnePartner        
		,SexualRelationWithHIVInfected        
		,SexualRelationWithDrugInject        
		,InjectsDrugsSharedNeedle        
		,ReceivedAnyFavorsForSexualRelation        
		,FamilyFriendFeelingsCausedDistress        
		,FeltNervousAnxious        
		,NotAbleToStopWorrying        
		,StressPeoblemForHandlingThing        
		,SocialAndEmotionalNeed        
		,DepressionAnxietyRecommendation        
		,CommunicableDiseaseRecommendation        
		,PleasureInDoingThings        
		,DepressedHopelessFeeling        
		,AsleepSleepingFalling        
		,TiredFeeling        
		,OverEating        
		,BadAboutYourselfFeeling        
		,TroubleConcentratingOnThings        
		,SpeakingSlowlyOrOpposite        
		,BetterOffDeadThought        
		,DifficultProblem   
		,SexualityComment  
		,ReceivePrenatalCare  
		,ReceivePrenatalCareNeedsList  
		,ProblemInPregnancy  
		,ProblemInPregnancyNeedsList  
		,DevelopmentalAttachmentComments  
		,PrenatalExposer  
		,PrenatalExposerNeedsList  
		,WhereMedicationUsed  
		,WhereMedicationUsedNeedsList  
		,IssueWithDelivery  
		,IssueWithDeliveryNeedsList  
		,ChildDevelopmentalMilestones  
		,ChildDevelopmentalMilestonesNeedsList  
		,TalkBeforeNeedsList  
		,ParentChildRelationshipIssue  
		,ParentChildRelationshipNeedsList  
		,FamilyRelationshipIssues  
		,FamilyRelationshipNeedsList  
		,WhenTheyTalkSentenceUnknown  
		,WhenTheyTalkUnknown  
		,WhenTheyWalkUnknown  
		,AddSexualitytoNeedList  
		,LegalIssues  
		,CSSRSAdultOrChild  
		,Strengths
		,TransitionLevelOfCare
		,ReductionInSymptoms
		,AttainmentOfHigherFunctioning
		,TreatmentNotNecessary
		,OtherTransitionCriteria
		,EstimatedDischargeDate
		,ReductionInSymptomsDescription
		,AttainmentOfHigherFunctioningDescription
		,TreatmentNotNecessaryDescription
		,OtherTransitionCriteriaDescription
		,DepressionPHQToNeedList
		,ClientAdvanceDirective,
		ClientAdvanceADirectivePlan,
		NeedMoreInfoAboutClientADPlan,
		AdvanceDirectiveInformation,
		AddAdvanceDirectiveNeedsList   
	   FROM CustomDocumentMHAssessments  C                       
	   left outer JOIN  GlobalCodes G ON C.RelationWithGuardian = G.GlobalCodeId                     
	   left outer join  CustomLOCs loc on loc.LOCId =C.LOCId                  
	   left outer join CustomLOCCategories locat on locat.LOCCategoryId = loc.LOCCategoryId                  
	   where (ISNULL(C.RecordDeleted, 'N') = 'N') AND (C.DocumentVersionId = @DocumentVersionId)                        
	   AND IsNull(G.RecordDeleted,'N')='N'                    
    
	     --CustomDocumentAssessmentSubstanceUses--    
  SELECT      
   DocumentVersionId      
  ,CreatedBy      
  ,CreatedDate      
  ,ModifiedBy      
  ,ModifiedDate      
  ,RecordDeleted      
  ,DeletedBy      
  ,DeletedDate      
  ,UseOfAlcohol      
  ,AlcoholAddToNeedsList      
  ,UseOfTobaccoNicotine      
  ,UseOfTobaccoNicotineQuit      
  ,UseOfTobaccoNicotineTypeOfFrequency      
  ,UseOfTobaccoNicotineAddToNeedsList      
  ,UseOfIllicitDrugs      
  ,UseOfIllicitDrugsTypeFrequency      
  ,UseOfIllicitDrugsAddToNeedsList      
  ,PrescriptionOTCDrugs      
  ,PrescriptionOTCDrugsTypeFrequency      
  ,PrescriptionOTCDrugsAddtoNeedsList  
	, DrinksPerWeek
	,LastTimeDrinkDate
	,LastTimeDrinks
	,IllegalDrugs
	,BriefCounseling
	,FeedBackOnAlcoholUse
	,Harms
	,DevelopmentOfPlans
	,Refferal
	,DDOneTimeOnly
	,NotApplicable
    
  FROM CustomDocumentAssessmentSubstanceUses          
  WHERE ISNULL(RecordDeleted, 'N') = 'N'          
  AND DocumentVersionId = @DocumentVersionId          
    
	                                                                            
   --CustomDocumentMHCRAFFTs-- 
     SELECT   DocumentVersionId ,  
                    CDMH.CreatedBy ,  
                    CDMH.CreatedDate ,  
                    CDMH.ModifiedBy ,  
                    CDMH.ModifiedDate ,  
                    CDMH.RecordDeleted ,  
                    CDMH.DeletedBy ,  
                    CDMH.DeletedDate ,  
                    CrafftApplicable ,  
                    CrafftApplicableReason ,  
                    CrafftQuestionC ,  
                    CrafftQuestionR ,  
                    CrafftQuestionA ,  
                    CrafftQuestionF ,  
                    CrafftQuestionFR ,  
                    CrafftQuestionT ,  
                    CrafftCompleteFullSUAssessment ,  
                    CrafftStageOfChange  
            FROM    CustomDocumentMHCRAFFTs  CDMH
			 WHERE (ISNULL(CDMH.RecordDeleted, 'N') = 'N') AND (DocumentVersionId = @DocumentVersionId)
  --END    
  
    --- CustomSubstanceUseAssessments ----                                                                                                                
    select  [DocumentVersionId]                                          
      ,[VoluntaryAbstinenceTrial]                                          
      ,[Comment]                                          
      ,[HistoryOrCurrentDUI]                                          
      ,[NumberOfTimesDUI]                                          
      ,[HistoryOrCurrentDWI]                                          
      ,[NumberOfTimesDWI]                                          
      ,[HistoryOrCurrentMIP]                                          
      ,[NumberOfTimeMIP]                                          
      ,[HistoryOrCurrentBlackOuts]                                          
      ,[NumberOfTimesBlackOut]                                          
      ,[HistoryOrCurrentDomesticAbuse]                                          
      ,[NumberOfTimesDomesticAbuse]                                          
      ,[LossOfControl]                                          
      ,[IncreasedTolerance]                                          
      ,[OtherConsequence]                                          
      ,[OtherConsequenceDescription]                                          
      ,[RiskOfRelapse]                                          
      ,[PreviousTreatment]                                          
      ,[CurrentSubstanceAbuseTreatment]                                          
      ,[CurrentTreatmentProvider]                                          
      ,[CurrentSubstanceAbuseReferralToSAorTx]                                          
      ,[CurrentSubstanceAbuseRefferedReason]                                          
      ,[ToxicologyResults]                                          
      ,[SubstanceAbuseAdmittedOrSuspected]                  
      ,[ClientSAHistory]                                          
      ,[FamilySAHistory]                                          
      ,[NoSubstanceAbuseSuspected]                                          
      ,[DUI30Days]                              
      ,[DUI5Years]                                          
      ,[DWI30Days]                                          
      ,[DWI5Years]                                          
      ,[Possession30Days]                                          
      ,[Possession5Years]                                          
      ,[CurrentSubstanceAbuse]                                          
      ,[SuspectedSubstanceAbuse]                                          
      ,[SubstanceAbuseDetail]                                          
      ,[SubstanceAbuseTxPlan]                                          
      ,[OdorOfSubstance]                                          
      ,[SlurredSpeech]                              
      ,[WithdrawalSymptoms]                                          
      ,[DTOther]                                          
      ,[DTOtherText]                                          
      ,[Blackouts]                                          
      ,[RelatedArrests]                                          
      ,[RelatedSocialProblems]                                          
      ,[FrequentJobSchoolAbsence]                                          
      ,[NoneSynptomsReportedOrObserved]                             
      --,cs.[RowIdentifier]                                                                                                                                  
      ,cs.[CreatedBy]                                                                                                                
      ,cs.[CreatedDate]                                                                                                         
      ,cs.[ModifiedBy]                                                
      ,cs.[ModifiedDate]                                                                                                                          
      ,cs.[RecordDeleted]                                                   
      ,cs.[DeletedDate]                                                                                                                                                
      ,cs.[DeletedBy]          
    ,cs.[PreviousMedication]        
      ,cs.[CurrentSubstanceAbuseMedication]   
      ,cs.[MedicationAssistedTreatment]
      ,cs.[MedicationAssistedTreatmentRefferedReason]
                       
  FROM CustomSubstanceUseAssessments cs                                                                                                                                                                                   
  WHERE (ISNULL(cs.RecordDeleted, 'N') = 'N') AND (DocumentVersionId = @DocumentVersionId)                           
      
	                                                                                                                                         
   ---CustomSubstanceUseHistory2---                                                                                                                
  SELECT 
     [SubstanceUseHistoryId]                                                                                                                        
      ,[DocumentVersionId]                                                                                                                
      ,[SUDrugId]                                                                                                                               
      ,[AgeOfFirstUse]                                                                     
      ,[Frequency]                                                                                        
      ,[Route]                                                       
      ,[LastUsed]                                                                                                                                    
      ,[InitiallyPrescribed]                                                                                                                                    
      ,[Preference]                                                                                                                                    
      ,[FamilyHistory]                                                                                                            
      --,[RowIdentifier]                                                                                                                      
      ,[CreatedBy]                                                                                                                                    
      ,[CreatedDate]                                                                                         
      ,[ModifiedBy]                                                                                         
      ,[ModifiedDate]                                               
      ,[RecordDeleted]                                                                                                                                    
      ,[DeletedDate]                                                        
      ,[DeletedBy]                                                                                                                                    
  FROM CustomSubstanceUseHistory2                                                                                                                                    
  WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,'N')='N'  
   
    --CustomDocumentPreEmploymentActivities--      
 SELECT       
  DocumentVersionId      
 ,CreatedBy      
 ,CreatedDate      
 ,ModifiedBy      
 ,ModifiedDate      
 ,RecordDeleted      
 ,DeletedBy      
 ,DeletedDate      
 ,EducationTraining      
 ,EducationTrainingNeeds      
 ,EducationTrainingNeedsComments      
 ,PersonalCareerPlanning      
 ,PersonalCareerPlanningNeeds      
 ,PersonalCareerPlanningNeedsComments      
 ,EmploymentOpportunities      
 ,EmploymentOpportunitiesNeeds      
 ,EmploymentOpportunitiesNeedsComments      
 ,SupportedEmployment      
 ,SupportedEmploymentNeeds      
 ,SupportedEmploymentNeedsComments      
 ,WorkHistory      
 ,WorkHistoryNeeds      
 ,WorkHistoryNeedsComments      
 ,GainfulEmploymentBenefits      
 ,GainfulEmploymentBenefitsNeeds      
 ,GainfulEmploymentBenefitsNeedsComments      
 ,GainfulEmployment      
 ,GainfulEmploymentNeeds      
 ,GainfulEmploymentNeedsComments      
 FROM CustomDocumentPreEmploymentActivities      
 WHERE ISNULL(RecordDeleted, 'N') = 'N'               
    AND DocumentVersionId = @DocumentVersionId         
  
                                                                    
      -- CustomHRMAssessmentMedications                                                                                  
      Select       
	   HRMAssessmentMedicationId,      
	 CreatedBy,      
	 CreatedDate,      
	 ModifiedBy,      
	 ModifiedDate,      
	 RecordDeleted,      
	 DeletedBy,      
	 DeletedDate,      
	 DocumentVersionId,      
	 Name,      
	 Dosage,      
	 Purpose,      
	 PrescribingPhysician      
	 From      
    CustomHRMAssessmentMedications HM      
     WHERE ISNULL(RecordDeleted, 'N') = 'N'           
    AND HM.DocumentVersionId = @DocumentVersionId  
    
  --CustomMHAssessmentCurrentHealthIssues--
	SELECT
	 MHAssessmentCurrentHealthIssueId
	,CreatedBy
	,CreatedDate
	,ModifiedBy
	,ModifiedDate
	,RecordDeleted
	,DeletedBy
	,DeletedDate
	,DocumentVersionId
	,CurrentHealthIssues
	,IsChecked
	FROM CustomMHAssessmentCurrentHealthIssues cs                                                                                                                                                                                   
  WHERE (ISNULL(cs.RecordDeleted, 'N') = 'N') AND (DocumentVersionId = @DocumentVersionId)                           
   
    --CustomMHAssessmentPastHealthIssues--
	SELECT
	MHAssessmentPastHealthIssueId
	,CreatedBy
	,CreatedDate
	,ModifiedBy
	,ModifiedDate
	,RecordDeleted
	,DeletedBy
	,DeletedDate
	,DocumentVersionId
	,PastHealthIssues
	,IsChecked
	FROM CustomMHAssessmentPastHealthIssues cs                                                                                                                                                                                   
  WHERE (ISNULL(cs.RecordDeleted, 'N') = 'N') AND (DocumentVersionId = @DocumentVersionId)                           
   
     
   --CustomMHAssessmentFamilyHistory--
	SELECT
	MHAssessmentFamilyHistoryId
	,CreatedBy
	,CreatedDate
	,ModifiedBy
	,ModifiedDate
	,RecordDeleted
	,DeletedBy
	,DeletedDate
	,DocumentVersionId
	,FamilyHistory
	,IsChecked
	FROM CustomMHAssessmentFamilyHistory cs                                                                                                                                                                                   
  WHERE (ISNULL(cs.RecordDeleted, 'N') = 'N') AND (DocumentVersionId = @DocumentVersionId)                           
    
	
      --PHQ9Documents--
	SELECT
	DocumentVersionId
	,CreatedBy
	,CreatedDate
	,ModifiedBy
	,ModifiedDate
	,RecordDeleted
	,DeletedBy
	,DeletedDate
	,LittleInterest
	,FeelingDown
	,TroubleFalling
	,FeelingTired
	,PoorAppetite
	,FeelingBad
	,TroubleConcentrating
	,MovingOrSpeakingSlowly
	,HurtingYourself
	,GetAlongOtherPeople
	,TotalScore
	,DepressionSeverity
	,Comments
	,AdditionalEvalForDepressionPerformed
	,ReferralForDepressionOrdered
	,DepressionMedicationOrdered
	,SuicideRiskAssessmentPerformed
	,ClientRefusedOrContraIndicated
	,PharmacologicalIntervention
	,OtherInterventions
	,DocumentationFollowUp
	,ClientDeclinedToParticipate
	,PerformedAt
	FROM PHQ9Documents PHQ9                                                                                                                                                                                   
  WHERE (ISNULL(PHQ9.RecordDeleted, 'N') = 'N') AND (DocumentVersionId = @DocumentVersionId)                           
   
   --PHQ9ADocuments--
	SELECT
	DocumentVersionId
	,CreatedBy
	,CreatedDate
	,ModifiedBy
	,ModifiedDate
	,RecordDeleted
	,DeletedBy
	,DeletedDate
	,FeelingDown
	,LittleInterest
	,TroubleFalling
	,FeelingTired
	,PoorAppetite
	,FeelingBad
	,TroubleConcentrating
	,MovingOrSpeakingSlowly
	,HurtingYourself
	,PastYear
	,ProblemDifficulty
	,PastMonth
	,SuicideAttempt
	,SeverityScore
	,TotalScore
	,AdditionalEvalForDepressionPerformed
	,ReferralForDepressionOrdered
	,DepressionMedicationOrdered
	,SuicideRiskAssessmentPerformed
	,ClientRefusedOrContraIndicated
	,Comments
	,ClientDeclinedToParticipate
	,PerformedAt
	FROM PHQ9ADocuments PHQ9A                                                                                                                                                                                   
  WHERE (ISNULL(PHQ9A.RecordDeleted, 'N') = 'N') AND (DocumentVersionId = @DocumentVersionId) 

 
  --CustomMHAssessmentSupports--
   
   	SELECT
	 MHAssessmentSupportId	
	,DocumentVersionId
	,SupportDescription
	,[Current]
	,PaidSupport
	,UnpaidSupport
	,ClinicallyRecommended
	,CustomerDesired
	,CreatedBy
	,CreatedDate
	,ModifiedBy
	,ModifiedDate
	,RecordDeleted
	,DeletedBy
	,DeletedDate
	FROM CustomMHAssessmentSupports CDMS                                                                                                                                                                                   
  WHERE (ISNULL(CDMS.RecordDeleted, 'N') = 'N') AND (DocumentVersionId = @DocumentVersionId) 

      --CustomDocumentMentalStatusExams--
   
   	SELECT
	DocumentVersionId
	,CreatedBy
	,CreatedDate
	,ModifiedBy
	,ModifiedDate
	,RecordDeleted
	,DeletedBy
	,DeletedDate
	,GeneralAppearance
	,GeneralPoorlyAddresses
	,GeneralPoorlyGroomed
	,GeneralDisheveled
	,GeneralOdferous
	,GeneralDeformities
	,GeneralPoorNutrion
	,GeneralRestless
	,GeneralPsychometer
	,GeneralHyperActive
	,GeneralEvasive
	,GeneralInAttentive
	,GeneralPoorEyeContact
	,GeneralHostile
	,GeneralAppearanceOthers
	,GeneralAppearanceOtherComments
	,Speech
	,SpeechIncreased
	,SpeechDecreased
	,SpeechPaucity
	,SpeechHyperverbal
	,SpeechPoorArticulations
	,SpeechLoud
	,SpeechSoft
	,SpeechMute
	,SpeechStuttering
	,SpeechImpaired
	,SpeechPressured
	,SpeechFlight
	,SpeechOthers
	,SpeechOtherComments
	,PsychiatricNoteExamLanguage
	,LanguageDifficultyNaming
	,LanguageDifficultyRepeating
	,LanguageNonVerbal
	,LanguageOthers
	,LanguageOtherComments
	,MoodAndAffect
	,MoodHappy
	,MoodSad
	,MoodAnxious
	,MoodAngry
	,MoodIrritable
	,MoodElation
	,MoodNormal
	,MoodOthers
	,MoodOtherComments
	,AffectEuthymic
	,AffectDysphoric
	,AffectAnxious
	,AffectIrritable
	,AffectBlunted
	,AffectLabile
	,AffectEuphoric
	,AffectCongruent
	,AffectOthers
	,AffectOtherComments
	,AttensionSpanAndConcentration
	,AttensionPoorConcentration
	,AttensionPoorAttension
	,AttensionDistractible
	,AttentionSpanOthers
	,AttentionSpanOtherComments
	,ThoughtContentCognision
	,TPDisOrganised
	,TPBlocking
	,TPPersecution
	,TPBroadCasting
	,TPDetrailed
	,TPThoughtInsertion
	,TPIncoherent
	,TPRacing
	,TPIllogical
	,ThoughtProcessOthers
	,ThoughtProcessOtherComments
	,TCDelusional
	,TCParanoid
	,TCIdeas
	,TCThoughtInsertion
	,TCThoughtWithdrawal
	,TCThoughtBroadcasting
	,TCReligiosity
	,TCGrandiosity
	,TCPerserveration
	,TCObsessions
	,TCWorthlessness
	,TCLoneliness
	,TCGuilt
	,TCHopelessness
	,TCHelplessness
	,ThoughtContentOthers
	,ThoughtContentOtherComments
	,CAConcrete
	,CAUnable
	,CAPoorComputation
	,CognitiveAbnormalitiesOthers
	,CognitiveAbnormalitiesOtherComments
	,Associations
	,AssociationsLoose
	,AssociationsClanging
	,AssociationsWordsalad
	,AssociationsCircumstantial
	,AssociationsTangential
	,AssociationsOthers
	,AssociationsOtherComments
	,AbnormalorPsychoticThoughts
	,PsychosisOrDisturbanceOfPerception
	,PDAuditoryHallucinations
	,PDVisualHallucinations
	,PDCommandHallucinations
	,PDDelusions
	,PDPreoccupation
	,PDOlfactoryHallucinations
	,PDGustatoryHallucinations
	,PDTactileHallucinations
	,PDSomaticHallucinations
	,PDIllusions
	,AbnormalPsychoticOthers
	,AbnormalPsychoticOthersComments
	,PDCurrentSuicideIdeation
	,PDCurrentSuicidalPlan
	,PDCurrentSuicidalIntent
	,PDMeansToCarry
	,PDCurrentHomicidalIdeation
	,PDCurrentHomicidalPlans
	,PDCurrentHomicidalIntent
	,PDMeansToCarryNew
	,Orientation
	,OrientationPerson
	,OrientationPlace
	,OrientationTime
	,OrientationSituation
	,OrientationOthers
	,OrientationOtherComments
	,OrientationDescribeSituation
	,OrientationFullName
	,OrientationEvidencedPlace
	,OrientationFullDate
	,FundOfKnowledge
	,FundOfKnowledgeCurrentEvents
	,FundOfKnowledgePastHistory
	,FundOfKnowledgeVocabulary
	,FundOfKnowledgeOthers
	,FundOfKnowledgeOtherComments
	,FundEvidenceVocabulary
	,FundEvidenceKnowledge
	,FundEvidenceResponses
	,FundEvidenceSchool
	,FundEvidenceIQ
	,FundEvidenceOthers
	,FundEvidenceOtherComments
	,InsightAndJudgement
	,InsightAndJudgementStatus
	,InsightAndJudgementSubstance
	,InsightAndJudgementOthers
	,InsightAndJudgementOtherComments
	,InsightEvidenceAwareness
	,InsightEvidenceAcceptance
	,InsightEvidenceUnderstanding
	,InsightEvidenceSelfDefeating
	,InsightEvidenceDenial
	,InsightEvidenceOthers
	,InsightEvidenceOtherComments
	,Memory
	,MemoryImmediate
	,MemoryRecent
	,MemoryRemote
	,MemoryOthers
	,MemoryOtherComments
	,MemoryImmediateEvidencedBy
	,MemoryRecentEvidencedBy
	,MemoryRemoteEvidencedBy
	,MuscleStrengthorTone
	,MuscleStrengthorToneAtrophy
	,MuscleStrengthorToneAbnormal
	,MuscleStrengthOthers
	,MuscleStrengthOtherComments
	,GaitandStation
	,GaitandStationRestlessness
	,GaitandStationStaggered
	,GaitandStationShuffling
	,GaitandStationUnstable
	,GaitAndStationOthers
	,GaitAndStationOtherComments
	,MentalStatusComments
	,ReviewWithChanges
	FROM CustomDocumentMentalStatusExams CDMSE                                                                                                                                                                                   
  WHERE (ISNULL(CDMSE.RecordDeleted, 'N') = 'N') AND (DocumentVersionId = @DocumentVersionId) 

    ---CustomOtherRiskFactors---                                                                                                                  
 SELECT [OtherRiskFactorId]                                                                                                                                        
     ,[DocumentVersionId]                                                                                                                                        
      ,[OtherRiskFactor]                                                                             
      --,c.[RowIdentifier]                                                                                                                                        
      ,c.[CreatedBy]                                                                                                                                        
      ,c.[CreatedDate]                                                                                                        
      ,c.[ModifiedBy]                                                                                                                                    
      ,c.[ModifiedDate]                                                                                                                
      ,c.[RecordDeleted]                                                                                                                                        
      ,c.[DeletedDate]                                                                                                   
      ,c.[DeletedBy]                                                             
      ,CodeName                                             
  FROM CustomOtherRiskFactors c join GlobalCodes                                                                
  on GlobalCodes.GlobalCodeId = c.OtherRiskFactor                                    
  WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(GlobalCodes.RecordDeleted,'N')='N'   AND ISNULL(c.RecordDeleted,'N')='N'                                                                                          
     
	 ---- CustomDocumentMHColumbiaAdultSinceLastVisits-----
	 SELECT DocumentVersionId
	,CDMCASV.CreatedBy
	,CDMCASV.CreatedDate
	,CDMCASV.ModifiedBy
	,CDMCASV.ModifiedDate
	,CDMCASV.RecordDeleted
	,CDMCASV.DeletedBy
	,CDMCASV.DeletedDate
	,WishToBeDead
	,WishToBeDeadDescription
	,NonSpecificActiveSuicidalThoughts
	,NonSpecificActiveSuicidalThoughtsDescription
	,ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToAct
	,ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToActDescription
	,ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlan
	,ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlanDescription
	,AciveSuicidalIdeationWithSpecificPlanAndIntent
	,AciveSuicidalIdeationWithSpecificPlanAndIntentDescription
	,MostSevereIdeation
	,MostSevereIdeationDescription
	,Frequency
	,ActualAttempt
	,TotalNumberOfAttempts
	,ActualAttemptDescription
	,HasSubjectEngagedInNonSuicidalSelfInjuriousBehavior
	,HasSubjectEngagedInSelfInjuriousBehaviorIntentUnknown
	,InterruptedAttempt
	,TotalNumberOfAttemptsInterrupted
	,InterruptedAttemptDescription
	,AbortedOrSelfInterruptedAttempt
	,TotalNumberAttemptsAbortedOrSelfInterrupted
	,AbortedOrSelfInterruptedAttemptDescription
	,PreparatoryActsOrBehavior
	,TotalNumberOfPreparatoryActs
	,PreparatoryActsOrBehaviorDescription
	,SuicidalBehavior
	,MostLethalAttemptDate
	,ActualLethalityMedicalDamage
	,PotentialLethality
	FROM CustomDocumentMHColumbiaAdultSinceLastVisits  CDMCASV
	 WHERE (ISNULL(CDMCASV.RecordDeleted, 'N') = 'N') AND (DocumentVersionId = @DocumentVersionId)
	    
	

--	sp_helptext ssp_SCGetDataDiagnosisNew
	  ---CustomDailyLivingActivityScores  ---    
  SELECT 
       CDLA.DocumentVersionId ,  
       CDLA.CreatedBy ,  
       CDLA.CreatedDate ,  
       CDLA.ModifiedBy ,  
       CDLA.ModifiedDate ,  
       CDLA.RecordDeleted ,  
       CDLA.DeletedBy ,  
       CDLA.DeletedDate ,  
       DailyLivingActivityScoreId               
      ,[DocumentVersionId]                                                                                                                                    
      ,[HRMActivityId]                                                                           
      ,[ActivityScore]                                                          
      ,[ActivityComment]                                                                                                                                           
  FROM CustomDailyLivingActivityScores      CDLA                                                                                                                              
  WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,'N')='N'                                                                                                                                    
      
	 
 --For CarePlanDomains      
  SELECT CPD.[CarePlanDomainId]  
   ,CPD.[CreatedBy]  
   ,CPD.[CreatedDate]  
   ,CPD.[ModifiedBy]  
   ,CPD.[ModifiedDate]  
   ,CPD.[RecordDeleted]  
   ,CPD.[DeletedBy]  
   ,CPD.[DeletedDate]  
   ,CPD.[DomainName]  
  FROM CarePlanDomains AS CPD  
  WHERE ISNull(CPD.RecordDeleted, 'N') = 'N'  
  ORDER BY CPD.DomainName  
  
  --CarePlanDomainNeeds      
  SELECT CPDN.CarePlanDomainNeedId  
   ,CPDN.CreatedBy  
   ,CPDN.CreatedDate  
   ,CPDN.ModifiedBy  
   ,CPDN.ModifiedDate  
   ,CPDN.RecordDeleted  
   ,CPDN.DeletedBy  
   ,CPDN.DeletedDate  
   ,CPDN.NeedName  
   ,CPDN.CarePlanDomainId  
   ,CPDN.MHAFieldIdentifierCode  
   ,CPDN.MHANeedDescription  
  FROM CarePlanDomainNeeds AS CPDN  
  WHERE ISNull(CPDN.RecordDeleted, 'N') = 'N'
                               
   --CarePlanNeeds                                                                              
     SELECT CPN.[CarePlanNeedId]  
  ,CPN.[CreatedBy]  
  ,CPN.[CreatedDate]  
  ,CPN.[ModifiedBy]  
  ,CPN.[ModifiedDate]  
  ,CPN.[RecordDeleted]  
  ,CPN.[DeletedBy]  
  ,CPN.[DeletedDate]  
  ,CPN.[DocumentVersionId]  
  ,CPN.[CarePlanDomainNeedId]  
  ,CPN.[NeedDescription]  
  ,CPN.[AddressOnCarePlan]  
  ,CPN.[Source]  
  ,CPD.[CarePlanDomainId]  
  ,CPDN.[NeedName]  
  ,CASE CPN.[Source]  
   WHEN 'C' THEN 'Care Plan'   
   END AS Source     
 FROM CarePlanNeeds CPN  
 JOIN CarePlanDomainNeeds CPDN ON CPDN.CarePlanDomainNeedId = CPN.CarePlanDomainNeedId  
 JOIN CarePlanDomains CPD ON CPD.CarePlanDomainId = CPDN.CarePlanDomainId  
 WHERE ISNull(CPN.RecordDeleted, 'N') = 'N'  
  AND CPN.DocumentVersionId = @DocumentVersionId  
    
    ---CustomHRMAssessmentLevelOfCareOptions---                                                                                                   
             
SELECT [HRMAssessmentLevelOfCareOptionId]                                                                                  
      ,[DocumentVersionId]                                                                                                                                            
      ,c.HRMLevelOfCareOptionId                                                                 
      ,[OptionSelected]                                                                                                                                            
      --,c.Rowidentifier                                                                                                                                            
      ,c.CreatedBy                                                                   
      ,c.CreatedDate                                                                                                          
      ,c.ModifiedBy                                                                                                                                            
      ,c.ModifiedDate                                                                 
      ,c.RecordDeleted                                                                               
      ,c.DeletedDate                                                                                                                                     
      ,c.DeletedBy                                                                                                                              
 ,ServiceChoiceLabel                                                          
  FROM CustomHRMAssessmentLevelOfCareOptions c join CustomHRMLevelOfCareOptions                                                                                        
  on CustomHRMLevelOfCareOptions.HRMLevelOfCareOptionId = c.HRMLevelOfCareOptionId                                                              
  WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(CustomHRMLevelOfCareOptions.RecordDeleted,'N')='N'   AND ISNULL(c.RecordDeleted,'N')='N'                                                           
                                       
   		  --  CustomDocumentPrePlanningWorksheet
   SELECT   [DocumentVersionId] ,
                 IndividualName,
	                CDPW.DOB,
					CaseNumber,
					CDPW.DateOfPrePlan,
					DreamsAndDesires,
					HowServicesCanHelp,
					LivingArrangements,
					LivingArragementsComment,
					MyRelationships,
					RelationshipsComment,
					CommunityInvolvment,
					CommunityComment,
					Wellness,
					WellnessComment,
					Education,
					EducationComment,
					Employment,
					EmploymentComment,
					Legal,
					LegalComment,
					Other,
					OtherComment,
					AdditionalComments1,
					PrePlanProcessExplained,
					SelfDExplained,
					WantToExploreSelfD,
					CommentsPCPOrSD,
					ImportantToTalkAbout,
					ImportantToNotTalkAbout,
					WHSIssuesToTalkAbout,
					ServicesToDiscussAtMeeting,
					ServiceProviderOptions,
					PeopleInvitedToMeeting,
					PeopleNotInivtedToMeeting,
					MeetingLocation,
					MeetingDate,
					MeetingTime,
					UnderstandPersonOfChoice,
					OIFExplained,
					HelpRunMeeting,
					TakeNotesMeeting,
					ChoseNotToParticipate,
					AlternativeManner,
					AdditionalComments2,
					SeparateDocumentRequired,
	                CDPW.[CreatedBy] ,        
                    CDPW.[CreatedDate] ,        
                    CDPW.[ModifiedBy] ,        
                    CDPW.[ModifiedDate] ,        
                    CDPW.[RecordDeleted] ,        
                    CDPW.[DeletedDate] ,        
                    CDPW.[DeletedBy] 
					 FROM    CustomDocumentPrePlanningWorksheet CDPW
                   WHERE ISNULL(RecordDeleted, 'N') = 'N'               
                 AND DocumentVersionId = @DocumentVersionId  
  
   --- CustomDispositions            
  SELECT            
  CustomDispositionId,            
  CreatedBy,            
  CreatedDate,            
  ModifiedBy,            
  ModifiedDate,            
  RecordDeleted,            
  DeletedBy,            
  DeletedDate,           
  InquiryId,          
  DocumentVersionId,          
  Disposition from CustomDispositions           
  WHERE ISNULL(RecordDeleted, 'N') = 'N'          
  AND DocumentVersionId = @DocumentVersionId          
           
  --- CustomServiceDispositions            
  SELECT            
  CustomServiceDispositionId,            
  csd.CreatedBy,            
  csd.CreatedDate,            
  csd.ModifiedBy,            
  csd.ModifiedDate,            
  csd.RecordDeleted,            
  csd.DeletedBy,            
  csd.DeletedDate,           
  csd.ServiceType,          
  csd.CustomDispositionId           
  FROM          
  CustomServiceDispositions AS csd JOIN CustomDispositions AS cd ON csd.CustomDispositionId = cd.CustomDispositionId           
  WHERE ISNULL(csd.RecordDeleted, 'N') = 'N'           
  AND cd.DocumentVersionId = @DocumentVersionId          
            
  --- CustomProviderServices            
  SELECT           
  CustomProviderServiceId,            
  cps.CreatedBy,            
  cps.CreatedDate,            
  cps.ModifiedBy,            
  cps.ModifiedDate,            
  cps.RecordDeleted,            
  cps.DeletedBy,            
  cps.DeletedDate,           
  cps.ProgramId,          
  cps.CustomServiceDispositionId          
  FROM CustomProviderServices AS cps           
  JOIN CustomServiceDispositions AS csd ON cps.CustomServiceDispositionId = csd.CustomServiceDispositionId          
  JOIN CustomDispositions AS cd ON csd.CustomDispositionId = cd.CustomDispositionId          
  WHERE ISNULL(cps.RecordDeleted, 'N') = 'N'           
  AND cd.DocumentVersionId = @DocumentVersionId          
            
    ---CustomDocumentMHAssessmentCAFASs---                                                                                                                        
  SELECT [DocumentVersionId]                                                                                               
      ,[CAFASDate]                                                                                                                                    
      ,[RaterClinician]                             
      ,[CAFASInterval]                                                                                                                                    
      ,[SchoolPerformance]                                                                                                                                    
      ,[SchoolPerformanceComment]                                                                                                                  
      ,[HomePerformance]                                                                                   
      ,[HomePerfomanceComment]                                        
      ,[CommunityPerformance]                                                                                                                                    
      ,[CommunityPerformanceComment]                         
      ,[BehaviorTowardsOther]                                                                                                                               
      ,[BehaviorTowardsOtherComment]                                                                                                                                    
      ,[MoodsEmotion]                                                           
      ,[MoodsEmotionComment]                                                     
      ,[SelfHarmfulBehavior]                                                                                                                              
      ,[SelfHarmfulBehaviorComment]                                                                  
      ,[SubstanceUse]                                                                                     
      ,[SubstanceUseComment]                                                                                                    
      ,[Thinkng]                                                                        
      ,[ThinkngComment]                                                         
      ,[YouthTotalScore]                                                                                                                                 
      ,[PrimaryFamilyMaterialNeeds]                                                                        
      ,[PrimaryFamilyMaterialNeedsComment]                                             
      ,[PrimaryFamilySocialSupport]                                                                                   
      ,[PrimaryFamilySocialSupportComment]                                                                                                                                    
      ,[NonCustodialMaterialNeeds]                                                                                                               
      ,[NonCustodialMaterialNeedsComment]                
      ,[NonCustodialSocialSupport]                                                                                                                      
      ,[NonCustodialSocialSupportComment]                                                                                           
      ,[SurrogateMaterialNeeds]                                                                                                                                    
      ,[SurrogateMaterialNeedsComment]                                                                                                
      ,[SurrogateSocialSupport]                                                                                                                                    
      ,[SurrogateSocialSupportComment]                                                                                                                                    
      ,[CreatedDate]                                                        
      ,[CreatedBy]                                                                                                      
      ,[ModifiedDate]                                                                                                 
      ,[ModifiedBy]                         
      ,[RecordDeleted]                                                                                                                                    
      ,[DeletedDate]                                                                                                                                    
      ,[DeletedBy]                                                    
  FROM CustomDocumentMHAssessmentCAFASs          
  WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,'N')='N'                                                                    
                                                                   
      --CustomDocumentAssessmentPECFASs--
     	SELECT
		DocumentVersionId
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedBy
		,DeletedDate
		,SchoolDayCare
		,HomeRolePerformance
		,CommunityRolePerformance
		,BehaviourTowardOthers
		,MoodsEmotions
		,SelfHarmfulBehavior
		,ThinkingCommunication
		,TotalChild
		,PrimaryScaleScore
		,OtherScaleScore
		,MaterialNeeds1
		,MaterialNeeds2
		,FamilySocialSupport1
		,FamilySocialSupport2
	FROM CustomDocumentAssessmentPECFASs CDAP                                                                                                                                                                                   
  WHERE (ISNULL(CDAP.RecordDeleted, 'N') = 'N') AND (DocumentVersionId = @DocumentVersionId) 

     exec ssp_SCGetDataDiagnosisNew   @DocumentVersionId               
  
		Select  b.DocumentVersionId,
			b.CreatedBy,
			b.CreatedDate,
			b.ModifiedBy,
			b.ModifiedDate,
			b.RecordDeleted,
			b.DeletedBy,
			b.DeletedDate,
			b.MentalPhysicalImpairment,
			b.ManifestedPrior,
			b.TestingReportsReviewed,
			b.LikelyToContinue
	FROM   CustomDocumentAssessmentDiagnosisIDDEligibilities b  
	WHERE ISNULL(b.RecordDeleted, 'N') = 'N' 
	AND b.DocumentVersionId = @DocumentVersionId       
	
	Select  b.AssessmentDiagnosisIDDCriteriaId,
			b.CreatedBy,
			b.CreatedDate,
			b.ModifiedBy,
			b.ModifiedDate,
			b.RecordDeleted,
			b.DeletedBy,
			b.DeletedDate,
			b.DocumentVersionId,
			b.SubstantialFunctional,
			b.IsChecked
	FROM CustomAssessmentDiagnosisIDDCriteria b
	WHERE ISNULL(b.RecordDeleted, 'N') = 'N' 
	AND b.DocumentVersionId = @DocumentVersionId  
	
	SELECT  b.DocumentVersionId,
			b.CreatedBy,
			b.CreatedDate,
			b.ModifiedBy,
			b.ModifiedDate,
			b.RecordDeleted,
			b.DeletedBy,
			b.DeletedDate,
			b.Dressing,
			b.PersonalHygiene,
			b.Bathing,
			b.Eating,
			b.SleepHygiene,
			b.SelfCareSkillComments,
			b.SelfCareSkillNeedsList,
			b.FinancialTransactions,
			b.ManagesPersonalFinances,
			b.CookingMealPreparation,
			b.KeepingRoomTidy,
			b.HouseholdTasks,
			b.LaundryTasks,
			b.HomeSafetyAwareness,
			b.DailyLivingSkillComments,
			b.DailyLivingSkillNeedsList,
			b.ComfortableInteracting,
			b.ComfortableLargerGroups,
			b.AppropriateConversations,
			b.AdvocatesForSelf,
			b.CommunicatesDailyLiving,
			b.SocialComments,
			b.SocialSkillNeedsList,
			b.MaintainsFamily,
			b.MaintainsFriendships,
			b.DemonstratesEmpathy,
			b.ManageEmotions,
			b.EmotionalComments,
			b.EmotionalNeedsList,
			b.RiskHarmToSelf,
			b.RiskSelfComments,
			b.RiskHarmToOthers,
			b.RiskOtherComments,
			b.PropertyDestruction,
			b.PropertyDestructionComments,
			b.Elopement,
			b.ElopementComments,
			b.MentalIllnessSymptoms,
			b.MentalIllnessSymptomComments,
			b.RepetitiveBehaviors,
			b.RepetitiveBehaviorComments,
			b.SocialEmotionalBehavioralOther,
			b.SocialEmotionalBehavioralNeedList,
			b.CommunicationComments,
			b.CommunicationNeedList,
			b.RentArrangements,
			b.PayRentBillsOnTime,
			b.PersonalItems,
			b.AttendSocialOutings,
			b.CommunityTransportation,
			b.DangerousSituations,
			b.AdvocateForSelf,
			ManageChangesDailySchedule,
			b.CommunityLivingSkillComments,
			b.PreferredActivities,
			b.CommunityLivingSkillNeedList 
	FROM CustomDocumentFunctionalAssessments b
	WHERE ISNULL(b.RecordDeleted, 'N') = 'N' 
	AND b.DocumentVersionId = @DocumentVersionId 

	SELECT  b.AssessmentFunctionalCommunicationId,
			b.CreatedBy,
			b.CreatedDate,
			b.ModifiedBy,
			b.ModifiedDate,
			b.RecordDeleted,
			b.DeletedBy,
			b.DeletedDate,
			b.DocumentVersionId,
			b.Communication,
			b.IsChecked
	FROM CustomAssessmentFunctionalCommunications b
	WHERE ISNULL(b.RecordDeleted, 'N') = 'N' 
	AND b.DocumentVersionId = @DocumentVersionId 
                                                            
 END TRY                                                                                                           
                        
 BEGIN CATCH                                                                                                                                                                                                                        
   DECLARE @Error varchar(8000)                                                                                                                                                                   
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                  
                                                                           
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_SCGetMHAssessment')                                                                          
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                                           
                                                                                  
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                 
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                                                                                 
 END CATCH                                                                            
 End           