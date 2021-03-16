

/****** Object:  StoredProcedure [dbo].[csp_validateCustomMHAssessment]    Script Date: 01/16/2015 17:11:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomMHAssessment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomMHAssessment]
GO


/****** Object:  StoredProcedure [dbo].[csp_validateCustomMHAssessment]  2012618  Script Date: 01/16/2015 17:11:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    
CREATE PROCEDURE [dbo].[csp_validateCustomMHAssessment] @DocumentVersionId INT    
AS    

 /*********************************************************************/
 /* Stored Procedure: [csp_validateCustomMHAssessment]    */

 /*       Date              Author                  Purpose                   */ 
 /*       28/May/2020      Jyothi Bellapu         Validation SP for MH Assessment Document as part of Kalamazoo - Improvements -#7*/
 /*       24 June 2020     Josekutty Varghese    What : Added validations for the tables such as CustomDocumentAssessmentDiagnosisIDDEligibilities,CustomAssessmentDiagnosisIDDCriteria,CustomDocumentFunctionalAssessments and CustomAssessmentFunctionalCommunications.
                                                Why  : New tabs have been added in Assessment. Tabs are Diagnosis-IDD Eligibility and Functional Assessment.
										        Portal Task: #12 in KCMHSAS Improvements   */

 /*********************************************************************/  

DECLARE @DocumentCodeId INT    
    
SET @DocumentCodeId = (    
  SELECT DocumentCodeId    
  FROM Documents    
  WHERE CurrentDocumentVersionId = @DocumentVersionId    
  )    
    
DECLARE @DocumentId INT    
    
SET @DocumentId = (    
  SELECT DocumentId    
  FROM Documents    
  WHERE CurrentDocumentVersionId = @DocumentVersionId    
  )    
    
--      
--Create Temp Tables      
--      
CREATE TABLE #CustomDocumentMHAssessments (    
 DocumentVersionId INT    
 ,ClientName VARCHAR(150)    
 ,AssessmentType CHAR(1)  
 ,PreviousAssessmentDate DATETIME    
 ,ClientDOB DATETIME    
 ,AdultOrChild CHAR(1)    
 ,ChildHasNoParentalConsent CHAR(1)    
 ,ClientHasGuardian CHAR(1)     
 ,GuardianAddress VARCHAR(100)    
 ,GuardianPhone VARCHAR(50)   
 ,ClientInDDPopulation CHAR(1)    
 ,ClientInSAPopulation CHAR(1)    
 ,ClientInMHPopulation CHAR(1)    
 ,PreviousDiagnosisText VARCHAR(max)    
 ,ReferralType INT    
 ,PresentingProblem VARCHAR(max)    
 ,CurrentLivingArrangement INT    
 ,CurrentPrimaryCarePhysician VARCHAR(200)    
 ,ReasonForUpdate VARCHAR(max)    
 ,DesiredOutcomes VARCHAR(max)    
 ,PsMedicationsComment VARCHAR(max)    
 ,PsEducationComment VARCHAR(max)    
 ,IncludeFunctionalAssessment CHAR(1)    
 ,IncludeSymptomChecklist CHAR(1)    
 ,IncludeUNCOPE CHAR(1)    
 ,ClientIsAppropriateForTreatment CHAR(1)    
 ,SecondOpinionNoticeProvided CHAR(1)    
 ,TreatmentNarrative VARCHAR(max)    
 ,RapCiDomainIntensity VARCHAR(50)    
 ,RapCiDomainComment VARCHAR(max)    
 ,RapCiDomainNeedsList CHAR(1)    
 ,RapCbDomainIntensity VARCHAR(50)    
 ,RapCbDomainComment VARCHAR(max)    
 ,RapCbDomainNeedsList CHAR(1)    
 ,RapCaDomainIntensity VARCHAR(50)    
 ,RapCaDomainComment VARCHAR(max)    
 ,RapCaDomainNeedsList CHAR(1)    
 ,RapHhcDomainIntensity VARCHAR(50)    
 ,OutsideReferralsGiven CHAR(1)    
 ,ReferralsNarrative VARCHAR(max)    
 ,ServiceOther CHAR(1)    
 ,ServiceOtherDescription VARCHAR(100)    
 ,AssessmentAddtionalInformation VARCHAR(max)    
 ,TreatmentAccomodation VARCHAR(max)    
 ,Participants VARCHAR(max)    
 ,Facilitator VARCHAR(max)    
 ,TimeLocation VARCHAR(max)    
 ,AssessmentsNeeded VARCHAR(max)    
 ,CommunicationAccomodations VARCHAR(max)    
 ,IssuesToAvoid VARCHAR(max)    
 ,IssuesToDiscuss VARCHAR(max)    
 ,SourceOfPrePlanningInfo VARCHAR(max)    
 ,SelfDeterminationDesired CHAR(1)    
 ,FiscalIntermediaryDesired CHAR(1)    
 ,PamphletGiven CHAR(1)    
 ,PamphletDiscussed CHAR(1)    
 ,PrePlanIndependentFacilitatorDiscussed CHAR(1)    
 ,PrePlanIndependentFacilitatorDesired CHAR(1)    
 ,PrePlanGuardianContacted CHAR(1)    
 ,PrePlanSeparateDocument CHAR(1)    
 ,CommunityActivitiesCurrentDesired VARCHAR(max)    
 ,CommunityActivitiesIncreaseDesired CHAR(1)    
 ,CommunityActivitiesNeedsList CHAR(1)    
 ,PsCurrentHealthIssues CHAR(1)    
 ,PsCurrentHealthIssuesComment VARCHAR(max)    
 ,PsCurrentHealthIssuesNeedsList CHAR(1)    
 ,HistMentalHealthTx CHAR(1)    
 ,HistMentalHealthTxNeedsList CHAR(1)    
 ,HistMentalHealthTxComment VARCHAR(max)    
 ,HistFamilyMentalHealthTx CHAR(1)    
 ,HistFamilyMentalHealthTxNeedsList CHAR(1)    
 ,HistFamilyMentalHealthTxComment VARCHAR(max)    
 ,PsClientAbuseIssues CHAR(1)    
 ,PsClientAbuesIssuesComment VARCHAR(max)    
 ,PsClientAbuseIssuesNeedsList CHAR(1)    
 ,PsFamilyConcernsComment VARCHAR(max)    
 ,PsRiskLossOfPlacement CHAR(1)    
 ,PsRiskLossOfPlacementDueTo INT    
 ,PsRiskSensoryMotorFunction CHAR(1)    
 ,PsRiskSensoryMotorFunctionDueTo INT    
 ,PsRiskSafety CHAR(1)    
 ,PsRiskSafetyDueTo INT    
 ,PsRiskLossOfSupport CHAR(1)    
 ,PsRiskLossOfSupportDueTo INT    
 ,PsRiskExpulsionFromSchool CHAR(1)    
 ,PsRiskExpulsionFromSchoolDueTo INT    
 ,PsRiskHospitalization CHAR(1)    
 ,PsRiskHospitalizationDueTo INT    
 ,PsRiskCriminalJusticeSystem CHAR(1)    
 ,PsRiskCriminalJusticeSystemDueTo INT    
 ,PsRiskElopementFromHome CHAR(1)    
 ,PsRiskElopementFromHomeDueTo INT    
 ,PsRiskLossOfFinancialStatus CHAR(1)    
 ,PsRiskLossOfFinancialStatusDueTo INT    
 ,PsDevelopmentalMilestones CHAR(1)    
 ,PsDevelopmentalMilestonesComment VARCHAR(max)    
 ,PsDevelopmentalMilestonesNeedsList CHAR(1)    
 ,PsChildEnvironmentalFactors CHAR(1)    
 ,PsChildEnvironmentalFactorsComment VARCHAR(max)    
 ,PsChildEnvironmentalFactorsNeedsList CHAR(1)    
 ,PsLanguageFunctioning CHAR(1)    
 ,PsLanguageFunctioningComment VARCHAR(max)    
 ,PsLanguageFunctioningNeedsList CHAR(1)    
 ,PsVisualFunctioning CHAR(1)    
 ,PsVisualFunctioningComment VARCHAR(max)    
 ,PsVisualFunctioningNeedsList CHAR(1)    
 ,PsPrenatalExposure CHAR(1)    
 ,PsPrenatalExposureComment VARCHAR(max)    
 ,PsPrenatalExposureNeedsList CHAR(1)    
 ,PsChildMentalHealthHistory CHAR(1)    
 ,PsChildMentalHealthHistoryComment VARCHAR(max)    
 ,PsChildMentalHealthHistoryNeedsList CHAR(1)    
 ,PsIntellectualFunctioning CHAR(1)    
 ,PsIntellectualFunctioningComment VARCHAR(max)    
 ,PsIntellectualFunctioningNeedsList CHAR(1)    
 ,PsLearningAbility CHAR(1)    
 ,PsLearningAbilityComment VARCHAR(max)    
 ,PsLearningAbilityNeedsList CHAR(1)    
 ,PsFunctioningConcernComment VARCHAR(max)    
 ,PsPeerInteraction CHAR(1)    
 ,PsPeerInteractionComment VARCHAR(max)    
 ,PsPeerInteractionNeedsList CHAR(1)    
 ,PsParentalParticipation CHAR(1)    
 ,PsParentalParticipationComment VARCHAR(max)    
 ,PsParentalParticipationNeedsList CHAR(1)    
 ,PsSchoolHistory CHAR(1)    
 ,PsSchoolHistoryComment VARCHAR(max)    
 ,PsSchoolHistoryNeedsList CHAR(1)    
 ,PsImmunizations CHAR(1)    
 ,PsImmunizationsComment VARCHAR(max)    
 ,PsImmunizationsNeedsList CHAR(1)    
 ,PsChildHousingIssues CHAR(1)    
 ,PsChildHousingIssuesComment VARCHAR(max)    
 ,PsChildHousingIssuesNeedsList CHAR(1)    
 ,PsSexuality CHAR(1)    
 ,PsSexualityComment VARCHAR(max)    
 ,PsSexualityNeedsList CHAR(1)    
 ,PsFamilyFunctioning CHAR(1)    
 ,PsFamilyFunctioningComment VARCHAR(max)    
 ,PsFamilyFunctioningNeedsList CHAR(1)    
 ,PsTraumaticIncident CHAR(1)    
 ,PsTraumaticIncidentComment VARCHAR(max)    
 ,PsTraumaticIncidentNeedsList CHAR(1)    
 ,HistDevelopmental CHAR(1)    
 ,HistDevelopmentalComment VARCHAR(max)    
 ,HistResidential CHAR(1)    
 ,HistResidentialComment VARCHAR(max)    
 ,HistOccupational CHAR(1)    
 ,HistOccupationalComment VARCHAR(max)    
 ,HistLegalFinancial CHAR(1)    
 ,HistLegalFinancialComment VARCHAR(max)    
 ,SignificantEventsPastYear VARCHAR(max)    
 ,PsGrossFineMotor CHAR(1)    
 ,PsGrossFineMotorComment VARCHAR(max)    
 ,PsGrossFineMotorNeedsList CHAR(1)    
 ,PsSensoryPerceptual CHAR(1)    
 ,PsSensoryPerceptualComment VARCHAR(max)    
 ,PsSensoryPerceptualNeedsList CHAR(1)    
 ,PsCognitiveFunction CHAR(1)    
 ,PsCognitiveFunctionComment VARCHAR(max)    
 ,PsCognitiveFunctionNeedsList CHAR(1)    
 ,PsCommunicativeFunction CHAR(1)    
 ,PsCommunicativeFunctionComment VARCHAR(max)    
 ,PsCommunicativeFunctionNeedsList CHAR(1)    
 ,PsCurrentPsychoSocialFunctiion CHAR(1)    
 ,PsCurrentPsychoSocialFunctiionComment VARCHAR(max)    
 ,PsCurrentPsychoSocialFunctiionNeedsList CHAR(1)    
 ,PsAdaptiveEquipment CHAR(1)    
 ,PsAdaptiveEquipmentComment VARCHAR(max)    
 ,PsAdaptiveEquipmentNeedsList CHAR(1)    
 ,PsSafetyMobilityHome CHAR(1)    
 ,PsSafetyMobilityHomeComment VARCHAR(max)    
 ,PsSafetyMobilityHomeNeedsList CHAR(1)    
 ,PsHealthSafetyChecklistComplete CHAR(3)    
 ,PsAccessibilityIssues CHAR(1)    
 ,PsAccessibilityIssuesComment VARCHAR(max)    
 ,PsAccessibilityIssuesNeedsList CHAR(1)    
 ,PsEvacuationTraining CHAR(1)    
 ,PsEvacuationTrainingComment VARCHAR(max)    
 ,PsEvacuationTrainingNeedsList CHAR(1)    
 ,Ps24HourSetting CHAR(1)    
 ,Ps24HourSettingComment VARCHAR(max)    
 ,Ps24HourSettingNeedsList CHAR(1)    
 ,Ps24HourNeedsAwakeSupervision CHAR(1)    
 ,PsSpecialEdEligibility CHAR(1)    
 ,PsSpecialEdEligibilityComment VARCHAR(max)    
 ,PsSpecialEdEligibilityNeedsList CHAR(1)    
 ,PsSpecialEdEnrolled CHAR(1)    
 ,PsSpecialEdEnrolledComment VARCHAR(max)    
 ,PsSpecialEdEnrolledNeedsList CHAR(1)    
 ,PsEmployer CHAR(1)    
 ,PsEmployerComment VARCHAR(max)    
 ,PsEmployerNeedsList CHAR(1)    
 ,PsEmploymentIssues CHAR(1)    
 ,PsEmploymentIssuesComment VARCHAR(max)    
 ,PsEmploymentIssuesNeedsList CHAR(1)    
 ,PsRestrictionsOccupational CHAR(1)    
 ,PsRestrictionsOccupationalComment VARCHAR(max)    
 ,PsRestrictionsOccupationalNeedsList CHAR(1)    
 ,PsFunctionalAssessmentNeeded CHAR(1)    
 ,PsAdvocacyNeeded CHAR(1)    
 ,PsPlanDevelopmentNeeded CHAR(1)    
 ,PsLinkingNeeded CHAR(1)    
 ,PsDDInformationProvidedBy VARCHAR(max)    
 ,HistPreviousDx CHAR(1)    
 ,HistPreviousDxComment VARCHAR(max)    
 ,PsLegalIssues CHAR(1)    
 ,PsLegalIssuesComment VARCHAR(max)    
 ,PsLegalIssuesNeedsList CHAR(1)    
 ,PsCulturalEthnicIssues CHAR(1)    
 ,PsCulturalEthnicIssuesComment VARCHAR(max)    
 ,PsCulturalEthnicIssuesNeedsList CHAR(1)    
 ,PsSpiritualityIssues CHAR(1)    
 ,PsSpiritualityIssuesComment VARCHAR(max)    
 ,PsSpiritualityIssuesNeedsList CHAR(1)    
 --,SuicideNotPresent CHAR(1)    
 ,SuicideIdeation CHAR(1)    
 ,SuicideActive CHAR(1)    
 ,SuicidePassive CHAR(1)    
 ,SuicideMeans CHAR(1)    
 ,SuicidePlan CHAR(1)    
 --,SuicideCurrent CHAR(1)    
-- ,SuicidePriorAttempt CHAR(1)    
-- ,SuicideNeedsList CHAR(1)    
-- ,SuicideBehaviorsPastHistory VARCHAR(max)    
 ,SuicideOtherRiskSelf CHAR(1)    
 ,SuicideOtherRiskSelfComment VARCHAR(max)    
-- ,HomicideNotPresent CHAR(1)    
 ,HomicideIdeation CHAR(1)    
 ,HomicideActive CHAR(1)    
 ,HomicidePassive CHAR(1)    
 --,HomicideMeans CHAR(1)    
 ,HomicidePlan CHAR(1)    
 --,HomicideCurrent CHAR(1)    
-- ,HomicidePriorAttempt CHAR(1)    
 --,HomicideNeedsList CHAR(1)    
 --,HomicideBehaviorsPastHistory VARCHAR(max)    
 ,HomicdeOtherRiskOthers CHAR(1)    
 ,HomicideOtherRiskOthersComment VARCHAR(max)    
 ,PhysicalAgressionNotPresent CHAR(1)    
 ,PhysicalAgressionSelf CHAR(1)    
 ,PhysicalAgressionOthers CHAR(1)    
 ,PhysicalAgressionCurrentIssue CHAR(1)    
 ,PhysicalAgressionNeedsList CHAR(1)    
 ,PhysicalAgressionBehaviorsPastHistory VARCHAR(max)    
 ,RiskAccessToWeapons CHAR(1)    
 ,RiskAppropriateForAdditionalScreening CHAR(1)    
 ,RiskClinicalIntervention VARCHAR(max)    
 ,RiskOtherFactorsNone CHAR(1)    
 ,RiskOtherFactors VARCHAR(max)    
 ,RiskOtherFactorsNeedsList CHAR(1)    
 ,StaffAxisV INT    
 ,StaffAxisVReason VARCHAR(max)    
 ,ClientStrengthsNarrative VARCHAR(max)    
 ,CrisisPlanningClientHasPlan CHAR(1)    
 ,CrisisPlanningNarrative VARCHAR(max)    
 ,CrisisPlanningDesired CHAR(1)    
 ,CrisisPlanningNeedsList CHAR(1)    
 ,CrisisPlanningMoreInfo CHAR(1)    
 ,AdvanceDirectiveClientHasDirective CHAR(1)    
 ,AdvanceDirectiveDesired CHAR(1)    
 ,AdvanceDirectiveNarrative VARCHAR(max)    
 ,AdvanceDirectiveNeedsList CHAR(1)    
 ,AdvanceDirectiveMoreInfo CHAR(1)    
 ,NaturalSupportSufficiency CHAR(2)    
 ,NaturalSupportNeedsList CHAR(1)    
 ,NaturalSupportIncreaseDesired CHAR(1)    
 ,ClinicalSummary VARCHAR(max)    
 ,UncopeQuestionU CHAR(1)    
 ,UncopeApplicable CHAR(1)    
 ,UncopeApplicableReason VARCHAR(max)    
 ,UncopeQuestionN CHAR(1)    
 ,UncopeQuestionC CHAR(1)    
 ,UncopeQuestionO CHAR(1)    
 ,UncopeQuestionP CHAR(1)    
 ,UncopeQuestionE CHAR(1)    
 ,UncopeCompleteFullSUAssessment CHAR(1)    
 ,SubstanceUseNeedsList CHAR(1)    
 ,DecreaseSymptomsNeedsList CHAR(1)    
 ,DDEPreviouslyMet CHAR(1)    
 ,DDAttributableMentalPhysicalLimitation CHAR(1)    
 ,DDDxAxisI VARCHAR(max)    
 ,DDDxAxisII VARCHAR(max)    
 ,DDDxAxisIII VARCHAR(max)    
 ,DDDxAxisIV VARCHAR(max)    
 ,DDDxAxisV VARCHAR(max)    
 ,DDDxSource VARCHAR(max)    
 ,DDManifestBeforeAge22 CHAR(1)    
 ,DDContinueIndefinitely CHAR(1)    
 ,DDLimitSelfCare CHAR(1)    
 ,DDLimitLanguage CHAR(1)    
 ,DDLimitLearning CHAR(1)    
 ,DDLimitMobility CHAR(1)    
 ,DDLimitSelfDirection CHAR(1)    
 ,DDLimitEconomic CHAR(1)    
 ,DDLimitIndependentLiving CHAR(1)    
 ,DDNeedMulitpleSupports CHAR(1)    
 ,CAFASDate DATETIME    
 ,RaterClinician INT    
 ,CAFASInterval INT    
 ,SchoolPerformance INT    
 ,SchoolPerformanceComment VARCHAR(max)    
 ,HomePerformance INT    
 ,HomePerfomanceComment VARCHAR(max)    
 ,CommunityPerformance INT    
 ,CommunityPerformanceComment VARCHAR(max)    
 ,BehaviorTowardsOther INT    
 ,BehaviorTowardsOtherComment VARCHAR(max)    
 ,MoodsEmotion INT    
 ,MoodsEmotionComment VARCHAR(max)    
 ,SelfHarmfulBehavior INT    
 ,SelfHarmfulBehaviorComment VARCHAR(max)    
 ,SubstanceUse INT    
 ,SubstanceUseComment VARCHAR(max)    
 ,Thinkng INT    
 ,ThinkngComment VARCHAR(max)    
 ,YouthTotalScore INT    
 ,PrimaryFamilyMaterialNeeds INT    
 ,PrimaryFamilyMaterialNeedsComment VARCHAR(max)    
 ,PrimaryFamilySocialSupport INT    
 ,PrimaryFamilySocialSupportComment VARCHAR(max)    
 ,NonCustodialMaterialNeeds INT    
 ,NonCustodialMaterialNeedsComment VARCHAR(max)    
 ,NonCustodialSocialSupport INT    
 ,NonCustodialSocialSupportComment VARCHAR(max)    
 ,SurrogateMaterialNeeds INT    
 ,SurrogateMaterialNeedsComment VARCHAR(max)    
 ,SurrogateSocialSupport INT    
 ,SurrogateSocialSupportComment VARCHAR(max)    
 ,DischargeCriteria VARCHAR(max)    
 ,PrePlanFiscalIntermediaryComment VARCHAR(max)    
 ,StageOfChange INT    
 ,PsEducation CHAR(1)    
 ,PsEducationNeedsList CHAR(1)    
 ,PsMedications CHAR(1)    
 ,PsMedicationsNeedsList CHAR(1)    
 ,PsMedicationsListToBeModified CHAR(1)    
 ,PhysicalConditionQuadriplegic CHAR(1)    
 ,PhysicalConditionMultipleSclerosis CHAR(1)    
 ,PhysicalConditionBlindness CHAR(1)    
 ,PhysicalConditionDeafness CHAR(1)    
 ,PhysicalConditionParaplegic CHAR(1)    
 ,PhysicalConditionCerebral CHAR(1)    
 ,PhysicalConditionMuteness CHAR(1)    
 ,PhysicalConditionOtherHearingImpairment CHAR(1)    
 ,TestingReportsReviewed VARCHAR(2)    
 ,LOCId INT    
 ,SevereProfoundDisability CHAR(1)    
 ,SevereProfoundDisabilityComment VARCHAR(max)    
 ,EmploymentStatus INT    
 ,DxTabDisabled CHAR(1)  
 ,LegalIssues VARCHAR(max)    
,CSSRSAdultOrChild  CHAR(1)  
,Strengths VARCHAR(max)  
,TransitionLevelOfCare VARCHAR(max) 
,ReductionInSymptoms CHAR(1)  
,AttainmentOfHigherFunctioning CHAR(1)
,TreatmentNotNecessary CHAR(1)
,OtherTransitionCriteria CHAR(1)
,EstimatedDischargeDate DATETIME
,ReductionInSymptomsDescription VARCHAR(max) 
,AttainmentOfHigherFunctioningDescription VARCHAR(max) 
,TreatmentNotNecessaryDescription VARCHAR(max) 
,OtherTransitionCriteriaDescription  VARCHAR(max)  
 ,CreatedBy VARCHAR(30)    
 ,CreatedDate DATETIME    
 ,ModifiedBy VARCHAR(30)    
 ,ModifiedDate DATETIME    
 ,RecordDeleted CHAR(1)    
 ,DeletedDate DATETIME    
 ,DeletedBy VARCHAR(30)    
 ,GuardianFirstName VARCHAR(30)
 ,GuardianLastName  VARCHAR(50)
 ,RelationWithGuardian INT
 )    
    
CREATE TABLE #CustomSUAssessments (    
 DocumentVersionId INT    
 ,VoluntaryAbstinenceTrial VARCHAR(max)    
 ,Comment VARCHAR(max)    
 ,HistoryOrCurrentDUI CHAR(1)    
 ,NumberOfTimesDUI INT    
 ,HistoryOrCurrentDWI CHAR(1)    
 ,NumberOfTimesDWI INT    
 ,HistoryOrCurrentMIP CHAR(1)    
 ,NumberOfTimeMIP INT    
 ,HistoryOrCurrentBlackOuts CHAR(1)    
 ,NumberOfTimesBlackOut INT    
 ,HistoryOrCurrentDomesticAbuse CHAR(1)    
 ,NumberOfTimesDomesticAbuse INT    
 ,LossOfControl CHAR(1)    
 ,IncreasedTolerance CHAR(1)    
 ,OtherConsequence CHAR(1)    
 ,OtherConsequenceDescription VARCHAR(2000)    
 ,RiskOfRelapse VARCHAR(max)    
 ,PreviousTreatment CHAR(1)    
 ,CurrentSubstanceAbuseTreatment CHAR(1)    
 ,CurrentTreatmentProvider VARCHAR(max)    
 ,CurrentSubstanceAbuseReferralToSAorTx CHAR(1)    
 ,CurrentSubstanceAbuseRefferedReason VARCHAR(max)    
 --,ToxicologyResults VARCHAR(max)    
 ,ClientSAHistory CHAR(1)    
 ,FamilySAHistory CHAR(1)    
 ,SubstanceAbuseAdmittedOrSuspected CHAR(1)    
 ,CurrentSubstanceAbuse CHAR(1)    
 ,SuspectedSubstanceAbuse CHAR(1)    
 ,SubstanceAbuseDetail VARCHAR(max)    
 ,SubstanceAbuseTxPlan CHAR(1)    
 ,OdorOfSubstance CHAR(1)    
 ,SlurredSpeech CHAR(1)    
 ,WithdrawalSymptoms CHAR(1)    
 ,DTOther CHAR(1)    
 ,DTOtherText VARCHAR(max)    
 ,Blackouts CHAR(1)    
 ,RelatedArrests CHAR(1)    
 ,RelatedSocialProblems CHAR(1)    
 ,FrequentJobSchoolAbsence CHAR(1)    
 ,NoneSynptomsReportedOrObserved CHAR(1)  
,PreviousMedication  CHAR(1)
,CurrentSubstanceAbuseMedication  CHAR(1) 
,MedicationAssistedTreatmentRefferedReason  VARCHAR(max) 
,MedicationAssistedTreatment  CHAR(1)
,DUI30Days INT
,DUI5Years INT
,DWI30Days INT
,DWI5Years INT
,Possession30Days INT
,Possession5Years INT
 ,CreatedBy VARCHAR(100)    
 ,CreatedDate DATETIME    
 ,ModifiedBy VARCHAR(100)    
 ,ModifiedDate DATETIME    
 ,RecordDeleted CHAR(1)    
 ,DeletedDate DATETIME    
 ,DeletedBy VARCHAR(100) 
 )    
    
CREATE TABLE #CustomCAFAS2 (    
 DocumentVersionId INT    
 ,CAFASDate DATETIME    
 ,RaterClinician INT    
 ,CAFASInterval INT    
 ,SchoolPerformance INT    
 ,SchoolPerformanceComment VARCHAR(max)    
 ,HomePerformance INT    
 ,HomePerfomanceComment VARCHAR(max)    
 ,CommunityPerformance INT    
 ,CommunityPerformanceComment VARCHAR(max)    
 ,BehaviorTowardsOther INT    
 ,BehaviorTowardsOtherComment VARCHAR(max)    
 ,MoodsEmotion INT    
 ,MoodsEmotionComment VARCHAR(max)    
 ,SelfHarmfulBehavior INT    
 ,SelfHarmfulBehaviorComment VARCHAR(max)    
 ,SubstanceUse INT    
 ,SubstanceUseComment VARCHAR(max)    
 ,Thinkng INT    
 ,ThinkngComment VARCHAR(max)    
 ,PrimaryFamilyMaterialNeeds INT    
 ,PrimaryFamilyMaterialNeedsComment VARCHAR(max)    
 ,PrimaryFamilySocialSupport INT    
 ,PrimaryFamilySocialSupportComment VARCHAR(max)    
 ,NonCustodialMaterialNeeds INT    
 ,NonCustodialMaterialNeedsComment VARCHAR(max)    
 ,NonCustodialSocialSupport INT    
 ,NonCustodialSocialSupportComment VARCHAR(max)    
 ,SurrogateMaterialNeeds INT    
 ,SurrogateMaterialNeedsComment VARCHAR(max)    
 ,SurrogateSocialSupport INT    
 ,SurrogateSocialSupportComment VARCHAR(max)    
 ,CreatedDate DATETIME    
 ,CreatedBy VARCHAR(30)    
 ,ModifiedDate DATETIME    
 ,ModifiedBy VARCHAR(30)    
 ,RecordDeleted CHAR(1)    
 ,DeletedDate DATETIME    
 ,DeletedBy INT    
 )    
    
CREATE TABLE #CustomMentalStatuses2 (    
 DocumentVersionId INT    
 ,AppearanceAddToNeedsList CHAR(1)    
 ,AppearanceNeatClean CHAR(1)    
 ,AppearancePoorHygiene CHAR(1)    
 ,AppearanceWellGroomed CHAR(1)    
 ,AppearanceAppropriatelyDressed CHAR(1)    
 ,AppearanceYoungerThanStatedAge CHAR(1)    
 ,AppearanceOlderThanStatedAge CHAR(1)    
 ,AppearanceOverweight CHAR(1)    
 ,AppearanceUnderweight CHAR(1)    
 ,AppearanceEccentric CHAR(1)    
 ,AppearanceSeductive CHAR(1)    
 ,AppearanceUnkemptDisheveled CHAR(1)    
 ,AppearanceOther CHAR(1)    
 ,AppearanceComment VARCHAR(max)    
 ,IntellectualAddToNeedsList CHAR(1)    
 ,IntellectualAboveAverage CHAR(1)    
 ,IntellectualAverage CHAR(1)    
 ,IntellectualBelowAverage CHAR(1)    
 ,IntellectualPossibleMR CHAR(1)    
 ,IntellectualDocumentedMR CHAR(1)    
 ,IntellectualOther CHAR(1)    
 ,IntellectualComment VARCHAR(max)    
 ,CommunicationAddToNeedsList CHAR(1)    
 ,CommunicationNormal CHAR(1)    
 ,CommunicationUsesSignLanguage CHAR(1)    
 ,CommunicationUnableToRead CHAR(1)    
 ,CommunicationNeedForBraille CHAR(1)    
 ,CommunicationHearingImpaired CHAR(1)    
 ,CommunicationDoesLipReading CHAR(1)    
 ,CommunicationEnglishIsSecondLanguage CHAR(1)    
 ,CommunicationTranslatorNeeded CHAR(1)    
 ,CommunicationOther CHAR(1)    
 ,CommunicationComment VARCHAR(max)    
 ,MoodAddToNeedsList CHAR(1)    
 ,MoodUnremarkable CHAR(1)    
 ,MoodCooperative CHAR(1)    
 ,MoodAnxious CHAR(1)    
 ,MoodTearful CHAR(1)    
 ,MoodCalm CHAR(1)    
 ,MoodLabile CHAR(1)    
 ,MoodPessimistic CHAR(1)    
 ,MoodCheerful CHAR(1)    
 ,MoodGuilty CHAR(1)    
 ,MoodEuphoric CHAR(1)    
 ,MoodDepressed CHAR(1)    
 ,MoodHostile CHAR(1)    
 ,MoodIrritable CHAR(1)    
 ,MoodDramatized CHAR(1)    
 ,MoodFearful CHAR(1)    
 ,MoodSupicious CHAR(1)    
 ,MoodOther CHAR(1)    
 ,MoodComment VARCHAR(max)    
 ,AffectAddToNeedsList CHAR(1)    
 ,AffectPrimarilyAppropriate CHAR(1)    
 ,AffectRestricted CHAR(1)    
 ,AffectBlunted CHAR(1)    
 ,AffectFlattened CHAR(1)    
 ,AffectDetached CHAR(1)    
 ,AffectPrimarilyInappropriate CHAR(1)    
 ,AffectOther CHAR(1)    
 ,AffectComment VARCHAR(max)    
 ,SpeechAddToNeedsList CHAR(1)    
 ,SpeechNormal CHAR(1)    
 ,SpeechLogicalCoherent CHAR(1)    
 ,SpeechTangential CHAR(1)    
 ,SpeechSparseSlow CHAR(1)    
 ,SpeechRapidPressured CHAR(1)    
 ,SpeechSoft CHAR(1)    
 ,SpeechCircumstantial CHAR(1)    
 ,SpeechLoud CHAR(1)    
 ,SpeechRambling CHAR(1)    
 ,SpeechOther CHAR(1)    
 ,SpeechComment VARCHAR(max)    
 ,ThoughtAddToNeedsList CHAR(1)    
 ,ThoughtUnremarkable CHAR(1)    
 ,ThoughtParanoid CHAR(1)    
 ,ThoughtGrandiose CHAR(1)    
 ,ThoughtObsessive CHAR(1)    
 ,ThoughtBizarre CHAR(1)    
 ,ThoughtFlightOfIdeas CHAR(1)    
 ,ThoughtDisorganized CHAR(1)    
 ,ThoughtAuditoryHallucinations CHAR(1)    
 ,ThoughtVisualHallucinations CHAR(1)    
 ,ThoughtTactileHallucinations CHAR(1)    
 ,ThoughtOther CHAR(1)    
 ,ThoughtComment VARCHAR(max)    
 ,BehaviorAddToNeedsList CHAR(1)    
 ,BehaviorNormal CHAR(1)    
 ,BehaviorRestless CHAR(1)    
 ,BehaviorTremors CHAR(1)    
 ,BehaviorPoorEyeContact CHAR(1)    
 ,BehaviorAgitated CHAR(1)    
 ,BehaviorPeculiar CHAR(1)    
 ,BehaviorSelfDestructive CHAR(1)    
 ,BehaviorSlowed CHAR(1)    
 ,BehaviorDestructiveToOthers CHAR(1)    
 ,BehaviorCompulsive CHAR(1)    
 ,BehaviorOther CHAR(1)    
 ,BehaviorComment VARCHAR(max)    
 ,OrientationAddToNeedsList CHAR(1)    
 ,OrientationToPersonPlaceTime CHAR(1)    
 ,OrientationNotToPerson CHAR(1)    
 ,OrientationNotToPlace CHAR(1)    
 ,OrientationNotToTime CHAR(1)    
 ,OrientationOther CHAR(1)    
 ,OrientationComment VARCHAR(max)    
 ,InsightAddToNeedsList CHAR(1)    
 ,InsightGood CHAR(1)    
 ,InsightFair CHAR(1)    
 ,InsightPoor CHAR(1)    
 ,InsightLacking CHAR(1)    
 ,InsightOther CHAR(1)    
 ,InsightComment VARCHAR(max)    
 ,MemoryAddToNeedsList CHAR(1)    
 ,MemoryGoodNormal CHAR(1)    
 ,MemoryImpairedShortTerm CHAR(1)    
 ,MemoryImpairedLongTerm CHAR(1)    
 ,MemoryOther CHAR(1)    
 ,MemoryComment VARCHAR(max)    
 ,RealityOrientationAddToNeedsList CHAR(1)    
 ,RealityOrientationIntact CHAR(1)    
 ,RealityOrientationTenuous CHAR(1)    
 ,RealityOrientationPoor CHAR(1)    
 ,RealityOrientationOther CHAR(1)    
 ,RealityOrientationComment VARCHAR(max)    
 ,CreatedBy VARCHAR(30)    
 ,CreatedDate DATETIME    
 ,ModifiedBy VARCHAR(30)    
 ,ModifiedDate DATETIME    
 ,RecordDeleted CHAR(1)    
 ,DeletedDate DATETIME    
 ,DeletedBy VARCHAR(30)    
 )    
    
CREATE TABLE #CustomMHAssessmentSupports (    
 DocumentVersionId INT    
 ,SupportDescription VARCHAR(max)    
 ,[Current] CHAR(1)    
 ,PaidSupport CHAR(1)    
 ,UnpaidSupport CHAR(1)    
 ,ClinicallyRecommended CHAR(1)    
 ,CustomerDesired CHAR(1)    
 ,CreatedBy VARCHAR(30)    
 ,CreatedDate DATETIME    
 ,ModifiedBy VARCHAR(30)    
 ,ModifiedDate DATETIME    
 ,RecordDeleted CHAR(1)    
 ,DeletedDate DATETIME    
 ,DeletedBy VARCHAR(30)    
 )    
    
----      
----Insert into Temp Tables     

----      
INSERT INTO #CustomSUAssessments (    
 DocumentVersionId    
 ,VoluntaryAbstinenceTrial    
 ,[Comment]    
 ,HistoryOrCurrentDUI    
 ,NumberOfTimesDUI    
 ,HistoryOrCurrentDWI    
 ,NumberOfTimesDWI    
 ,HistoryOrCurrentMIP    
 ,NumberOfTimeMIP    
 ,HistoryOrCurrentBlackOuts    
 ,NumberOfTimesBlackOut    
 ,HistoryOrCurrentDomesticAbuse    
 ,NumberOfTimesDomesticAbuse    
 ,LossOfControl    
 ,IncreasedTolerance    
 ,OtherConsequence    
 ,OtherConsequenceDescription    
 ,RiskOfRelapse    
 ,PreviousTreatment    
 ,CurrentSubstanceAbuseTreatment    
 ,CurrentTreatmentProvider    
 ,CurrentSubstanceAbuseReferralToSAorTx    
 ,CurrentSubstanceAbuseRefferedReason    
 --,ToxicologyResults    
 ,ClientSAHistory    
 ,FamilySAHistory    
 ,SubstanceAbuseAdmittedOrSuspected    
 ,CurrentSubstanceAbuse    
 ,SuspectedSubstanceAbuse    
 ,SubstanceAbuseDetail    
 ,SubstanceAbuseTxPlan    
 ,OdorOfSubstance    
 ,SlurredSpeech    
 ,WithdrawalSymptoms    
 ,DTOther    
 ,DTOtherText    
 ,Blackouts    
 ,RelatedArrests    
 ,RelatedSocialProblems    
 ,FrequentJobSchoolAbsence    
 ,NoneSynptomsReportedOrObserved 
,PreviousMedication  
,CurrentSubstanceAbuseMedication   
,MedicationAssistedTreatmentRefferedReason
,MedicationAssistedTreatment   
,DUI30Days
,DUI5Years
,DWI30Days
,DWI5Years
,Possession30Days
,Possession5Years
 ,CreatedBy    
 ,CreatedDate    
 ,ModifiedBy    
 ,ModifiedDate    
 ,RecordDeleted    
 ,DeletedDate    
 ,DeletedBy
 )    
SELECT a.DocumentVersionId    
 ,VoluntaryAbstinenceTrial    
 ,[Comment]    
 ,HistoryOrCurrentDUI    
 ,NumberOfTimesDUI    
 ,HistoryOrCurrentDWI    
 ,NumberOfTimesDWI    
 ,HistoryOrCurrentMIP    
 ,NumberOfTimeMIP    
 ,HistoryOrCurrentBlackOuts    
 ,NumberOfTimesBlackOut    
 ,HistoryOrCurrentDomesticAbuse    
 ,NumberOfTimesDomesticAbuse    
 ,LossOfControl    
 ,IncreasedTolerance    
 ,OtherConsequence    
 ,OtherConsequenceDescription    
 ,RiskOfRelapse    
 ,PreviousTreatment    
 ,CurrentSubstanceAbuseTreatment    
 ,CurrentTreatmentProvider    
 ,CurrentSubstanceAbuseReferralToSAorTx    
 ,CurrentSubstanceAbuseRefferedReason    
-- ,ToxicologyResults    
 ,ClientSAHistory    
 ,FamilySAHistory    
 ,SubstanceAbuseAdmittedOrSuspected    
 ,CurrentSubstanceAbuse    
 ,SuspectedSubstanceAbuse    
 ,SubstanceAbuseDetail    
 ,SubstanceAbuseTxPlan    
 ,OdorOfSubstance    
 ,SlurredSpeech    
 ,WithdrawalSymptoms    
 ,DTOther   
 ,DTOtherText    
 ,Blackouts    
 ,RelatedArrests    
 ,RelatedSocialProblems    
 ,FrequentJobSchoolAbsence    
 ,NoneSynptomsReportedOrObserved   
 ,PreviousMedication       
 ,CurrentSubstanceAbuseMedication   
 ,MedicationAssistedTreatmentRefferedReason
 ,MedicationAssistedTreatment
,DUI30Days
,DUI5Years
,DWI30Days
,DWI5Years
,Possession30Days
,Possession5Years
 ,a.CreatedBy    
 ,a.CreatedDate    
 ,a.ModifiedBy    
 ,a.ModifiedDate    
 ,a.RecordDeleted    
 ,a.DeletedDate    
 ,a.DeletedBy 
FROM CustomSubstanceUseAssessments a    
WHERE a.documentversionId = @documentversionId    
 AND isnull(a.RecordDeleted, 'N') = 'N'    
    
INSERT INTO #CustomDocumentMHAssessments (    
 DocumentVersionId    
 ,ClientName    
 ,AssessmentType   
 ,PreviousAssessmentDate    
 ,ClientDOB    
 ,AdultOrChild    
 ,ChildHasNoParentalConsent    
 ,ClientHasGuardian 
 ,GuardianAddress    
 ,GuardianPhone    
 ,ClientInDDPopulation    
 ,ClientInSAPopulation    
 ,ClientInMHPopulation    
 ,PreviousDiagnosisText    
 ,ReferralType    
 ,PresentingProblem    
 ,CurrentLivingArrangement    
 ,CurrentPrimaryCarePhysician    
 ,ReasonForUpdate    
 ,DesiredOutcomes    
 ,PsMedicationsComment    
 ,PsEducationComment    
 ,IncludeFunctionalAssessment    
 ,IncludeSymptomChecklist    
 ,IncludeUNCOPE    
 ,ClientIsAppropriateForTreatment    
 ,SecondOpinionNoticeProvided    
 ,TreatmentNarrative    
 ,RapCiDomainIntensity    
 ,RapCiDomainComment    
 ,RapCiDomainNeedsList    
 ,RapCbDomainIntensity    
 ,RapCbDomainComment    
 ,RapCbDomainNeedsList    
 ,RapCaDomainIntensity    
 ,RapCaDomainComment    
 ,RapCaDomainNeedsList    
 ,RapHhcDomainIntensity    
 ,OutsideReferralsGiven    
 ,ReferralsNarrative    
 ,ServiceOther    
 ,ServiceOtherDescription    
 ,AssessmentAddtionalInformation    
 ,TreatmentAccomodation    
 ,Participants    
 ,Facilitator    
 ,TimeLocation    
 ,AssessmentsNeeded    
 ,CommunicationAccomodations    
 ,IssuesToAvoid    
 ,IssuesToDiscuss    
 ,SourceOfPrePlanningInfo    
 ,SelfDeterminationDesired    
 ,FiscalIntermediaryDesired    
 ,PamphletGiven    
 ,PamphletDiscussed    
 ,PrePlanIndependentFacilitatorDiscussed    
 ,PrePlanIndependentFacilitatorDesired    
 ,PrePlanGuardianContacted    
 ,PrePlanSeparateDocument    
 ,CommunityActivitiesCurrentDesired    
 ,CommunityActivitiesIncreaseDesired    
 ,CommunityActivitiesNeedsList    
 ,PsCurrentHealthIssues    
 ,PsCurrentHealthIssuesComment    
 ,PsCurrentHealthIssuesNeedsList    
 ,HistMentalHealthTx    
 ,HistMentalHealthTxNeedsList    
 ,HistMentalHealthTxComment    
 ,HistFamilyMentalHealthTx    
 ,HistFamilyMentalHealthTxNeedsList    
 ,HistFamilyMentalHealthTxComment    
 ,PsClientAbuseIssues    
 ,PsClientAbuesIssuesComment    
 ,PsClientAbuseIssuesNeedsList    
 ,PsFamilyConcernsComment    
 ,PsRiskLossOfPlacement    
 ,PsRiskLossOfPlacementDueTo    
 ,PsRiskSensoryMotorFunction    
 ,PsRiskSensoryMotorFunctionDueTo    
 ,PsRiskSafety    
 ,PsRiskSafetyDueTo    
 ,PsRiskLossOfSupport    
 ,PsRiskLossOfSupportDueTo    
 ,PsRiskExpulsionFromSchool    
 ,PsRiskExpulsionFromSchoolDueTo    
 ,PsRiskHospitalization    
 ,PsRiskHospitalizationDueTo    
 ,PsRiskCriminalJusticeSystem    
 ,PsRiskCriminalJusticeSystemDueTo    
 ,PsRiskElopementFromHome    
 ,PsRiskElopementFromHomeDueTo    
 ,PsRiskLossOfFinancialStatus    
 ,PsRiskLossOfFinancialStatusDueTo    
 ,PsDevelopmentalMilestones    
 ,PsDevelopmentalMilestonesComment    
 ,PsDevelopmentalMilestonesNeedsList    
 ,PsChildEnvironmentalFactors    
 ,PsChildEnvironmentalFactorsComment    
 ,PsChildEnvironmentalFactorsNeedsList    
 ,PsLanguageFunctioning    
 ,PsLanguageFunctioningComment    
 ,PsLanguageFunctioningNeedsList    
 ,PsVisualFunctioning    
 ,PsVisualFunctioningComment    
 ,PsVisualFunctioningNeedsList    
 ,PsPrenatalExposure    
 ,PsPrenatalExposureComment    
 ,PsPrenatalExposureNeedsList    
 ,PsChildMentalHealthHistory    
 ,PsChildMentalHealthHistoryComment    
 ,PsChildMentalHealthHistoryNeedsList    
 ,PsIntellectualFunctioning    
 ,PsIntellectualFunctioningComment    
 ,PsIntellectualFunctioningNeedsList    
 ,PsLearningAbility    
 ,PsLearningAbilityComment    
 ,PsLearningAbilityNeedsList    
 ,PsFunctioningConcernComment    
 ,PsPeerInteraction    
 ,PsPeerInteractionComment    
 ,PsPeerInteractionNeedsList    
 ,PsParentalParticipation    
 ,PsParentalParticipationComment    
 ,PsParentalParticipationNeedsList    
 ,PsSchoolHistory    
 ,PsSchoolHistoryComment    
 ,PsSchoolHistoryNeedsList    
 ,PsImmunizations    
 ,PsImmunizationsComment    
 ,PsImmunizationsNeedsList    
 ,PsChildHousingIssues    
 ,PsChildHousingIssuesComment    
 ,PsChildHousingIssuesNeedsList    
 ,PsSexuality    
 ,PsSexualityComment    
 ,PsSexualityNeedsList    
 ,PsFamilyFunctioning    
 ,PsFamilyFunctioningComment    
 ,PsFamilyFunctioningNeedsList    
 ,PsTraumaticIncident    
 ,PsTraumaticIncidentComment    
 ,PsTraumaticIncidentNeedsList    
 ,HistDevelopmental    
 ,HistDevelopmentalComment    
 ,HistResidential    
 ,HistResidentialComment    
 ,HistOccupational    
 ,HistOccupationalComment    
 ,HistLegalFinancial    
 ,HistLegalFinancialComment    
 ,SignificantEventsPastYear    
 ,PsGrossFineMotor    
 ,PsGrossFineMotorComment    
 ,PsGrossFineMotorNeedsList    
 ,PsSensoryPerceptual    
 ,PsSensoryPerceptualComment    
 ,PsSensoryPerceptualNeedsList    
 ,PsCognitiveFunction    
 ,PsCognitiveFunctionComment    
 ,PsCognitiveFunctionNeedsList    
 ,PsCommunicativeFunction    
 ,PsCommunicativeFunctionComment    
 ,PsCommunicativeFunctionNeedsList    
 ,PsCurrentPsychoSocialFunctiion    
 ,PsCurrentPsychoSocialFunctiionComment    
 ,PsCurrentPsychoSocialFunctiionNeedsList    
 ,PsAdaptiveEquipment    
 ,PsAdaptiveEquipmentComment    
 ,PsAdaptiveEquipmentNeedsList    
 ,PsSafetyMobilityHome    
 ,PsSafetyMobilityHomeComment    
 ,PsSafetyMobilityHomeNeedsList    
 ,PsHealthSafetyChecklistComplete    
 ,PsAccessibilityIssues    
 ,PsAccessibilityIssuesComment    
 ,PsAccessibilityIssuesNeedsList    
 ,PsEvacuationTraining    
 ,PsEvacuationTrainingComment    
 ,PsEvacuationTrainingNeedsList    
 ,Ps24HourSetting    
 ,Ps24HourSettingComment    
 ,Ps24HourSettingNeedsList    
 ,Ps24HourNeedsAwakeSupervision    
 ,PsSpecialEdEligibility    
 ,PsSpecialEdEligibilityComment    
 ,PsSpecialEdEligibilityNeedsList    
 ,PsSpecialEdEnrolled    
 ,PsSpecialEdEnrolledComment    
 ,PsSpecialEdEnrolledNeedsList    
 ,PsEmployer    
 ,PsEmployerComment    
 ,PsEmployerNeedsList    
 ,PsEmploymentIssues    
 ,PsEmploymentIssuesComment    
 ,PsEmploymentIssuesNeedsList    
 ,PsRestrictionsOccupational    
 ,PsRestrictionsOccupationalComment    
 ,PsRestrictionsOccupationalNeedsList    
 ,PsFunctionalAssessmentNeeded    
 ,PsAdvocacyNeeded    
 ,PsPlanDevelopmentNeeded    
 ,PsLinkingNeeded    
 ,PsDDInformationProvidedBy    
 ,HistPreviousDx    
 ,HistPreviousDxComment    
 ,PsLegalIssues    
 ,PsLegalIssuesComment    
 ,PsLegalIssuesNeedsList    
 ,PsCulturalEthnicIssues    
 ,PsCulturalEthnicIssuesComment    
 ,PsCulturalEthnicIssuesNeedsList    
 ,PsSpiritualityIssues    
 ,PsSpiritualityIssuesComment    
 ,PsSpiritualityIssuesNeedsList 
 ,SuicideIdeation    
 ,SuicideActive    
 ,SuicidePassive    
 ,SuicideMeans    
 ,SuicidePlan    
 ,SuicideOtherRiskSelf    
 ,SuicideOtherRiskSelfComment 
 ,HomicideIdeation    
 ,HomicideActive    
 ,HomicidePassive   
 ,HomicidePlan      
 ,HomicdeOtherRiskOthers    
 ,HomicideOtherRiskOthersComment    
 ,PhysicalAgressionNotPresent    
 ,PhysicalAgressionSelf    
 ,PhysicalAgressionOthers    
 ,PhysicalAgressionCurrentIssue    
 ,PhysicalAgressionNeedsList    
 ,PhysicalAgressionBehaviorsPastHistory    
 ,RiskAccessToWeapons    
 ,RiskAppropriateForAdditionalScreening    
 ,RiskClinicalIntervention    
 ,RiskOtherFactorsNone    
 ,RiskOtherFactors    
 ,RiskOtherFactorsNeedsList    
 ,StaffAxisV    
 ,StaffAxisVReason    
 ,ClientStrengthsNarrative    
 ,CrisisPlanningClientHasPlan    
 ,CrisisPlanningNarrative    
 ,CrisisPlanningDesired    
 ,CrisisPlanningNeedsList    
 ,CrisisPlanningMoreInfo    
 ,AdvanceDirectiveClientHasDirective    
 ,AdvanceDirectiveDesired    
 ,AdvanceDirectiveNarrative    
 ,AdvanceDirectiveNeedsList    
 ,AdvanceDirectiveMoreInfo    
 ,NaturalSupportSufficiency    
 ,NaturalSupportNeedsList    
 ,NaturalSupportIncreaseDesired    
 ,ClinicalSummary    
 ,UncopeQuestionU    
 ,UncopeApplicable    
 ,UncopeApplicableReason    
 ,UncopeQuestionN    
 ,UncopeQuestionC    
 ,UncopeQuestionO    
 ,UncopeQuestionP    
 ,UncopeQuestionE    
 ,UncopeCompleteFullSUAssessment    
 ,SubstanceUseNeedsList    
 ,DecreaseSymptomsNeedsList    
 ,DDEPreviouslyMet    
 ,DDAttributableMentalPhysicalLimitation    
 ,DDDxAxisI    
 ,DDDxAxisII    
 ,DDDxAxisIII    
 ,DDDxAxisIV    
 ,DDDxAxisV    
 ,DDDxSource    
 ,DDManifestBeforeAge22    
 ,DDContinueIndefinitely    
 ,DDLimitSelfCare    
 ,DDLimitLanguage    
 ,DDLimitLearning    
 ,DDLimitMobility    
 ,DDLimitSelfDirection    
 ,DDLimitEconomic    
 ,DDLimitIndependentLiving    
 ,DDNeedMulitpleSupports    
 ,CAFASDate    
 ,RaterClinician    
 ,CAFASInterval    
 ,SchoolPerformance    
 ,SchoolPerformanceComment    
 ,HomePerformance    
 ,HomePerfomanceComment    
 ,CommunityPerformance    
 ,CommunityPerformanceComment    
 ,BehaviorTowardsOther    
 ,BehaviorTowardsOtherComment    
 ,MoodsEmotion    
 ,MoodsEmotionComment    
 ,SelfHarmfulBehavior    
 ,SelfHarmfulBehaviorComment    
 ,SubstanceUse    
 ,SubstanceUseComment    
 ,Thinkng    
 ,ThinkngComment    
 ,YouthTotalScore    
 ,PrimaryFamilyMaterialNeeds    
 ,PrimaryFamilyMaterialNeedsComment    
 ,PrimaryFamilySocialSupport    
 ,PrimaryFamilySocialSupportComment    
 ,NonCustodialMaterialNeeds    
 ,NonCustodialMaterialNeedsComment    
 ,NonCustodialSocialSupport    
 ,NonCustodialSocialSupportComment    
 ,SurrogateMaterialNeeds    
 ,SurrogateMaterialNeedsComment    
 ,SurrogateSocialSupport    
 ,SurrogateSocialSupportComment    
 ,DischargeCriteria    
 ,PrePlanFiscalIntermediaryComment    
 ,StageOfChange    
 ,PsEducation    
 ,PsEducationNeedsList    
 ,PsMedications    
 ,PsMedicationsNeedsList    
 ,PsMedicationsListToBeModified    
 ,PhysicalConditionQuadriplegic    
 ,PhysicalConditionMultipleSclerosis    
 ,PhysicalConditionBlindness    
 ,PhysicalConditionDeafness    
 ,PhysicalConditionParaplegic    
 ,PhysicalConditionCerebral    
 ,PhysicalConditionMuteness    
 ,PhysicalConditionOtherHearingImpairment    
 ,TestingReportsReviewed    
 ,LOCId    
 ,SevereProfoundDisability    
 ,SevereProfoundDisabilityComment    
 ,EmploymentStatus    
 ,DxTabDisabled  
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
 ,CreatedBy    
 ,CreatedDate    
 ,ModifiedBy    
 ,ModifiedDate    
 ,RecordDeleted    
 ,DeletedDate    
 ,DeletedBy 
  ,GuardianFirstName
 ,GuardianLastName
 ,RelationWithGuardian   
 )    
SELECT DocumentVersionId    
 ,ClientName    
 ,AssessmentType    
 --,CurrentAssessmentDate    
 ,PreviousAssessmentDate    
 ,ClientDOB    
 ,AdultOrChild    
 ,ChildHasNoParentalConsent    
 ,ClientHasGuardian    
 --,GuardianName    
 ,GuardianAddress    
 ,GuardianPhone    
 --,GuardianType    
 ,ClientInDDPopulation    
 ,ClientInSAPopulation    
 ,ClientInMHPopulation    
 ,PreviousDiagnosisText    
 ,ReferralType    
 ,PresentingProblem    
 ,CurrentLivingArrangement    
 ,CurrentPrimaryCarePhysician    
 ,ReasonForUpdate    
 ,DesiredOutcomes    
 ,PsMedicationsComment    
 ,PsEducationComment    
 ,IncludeFunctionalAssessment    
 ,IncludeSymptomChecklist    
 ,IncludeUNCOPE    
 ,ClientIsAppropriateForTreatment    
 ,SecondOpinionNoticeProvided    
 ,TreatmentNarrative    
 ,RapCiDomainIntensity    
 ,RapCiDomainComment    
 ,RapCiDomainNeedsList    
 ,RapCbDomainIntensity    
 ,RapCbDomainComment    
 ,RapCbDomainNeedsList    
 ,RapCaDomainIntensity    
 ,RapCaDomainComment    
 ,RapCaDomainNeedsList    
 ,RapHhcDomainIntensity    
 ,OutsideReferralsGiven    
 ,ReferralsNarrative    
 ,ServiceOther    
 ,ServiceOtherDescription    
 ,AssessmentAddtionalInformation    
 ,TreatmentAccomodation    
 ,Participants    
 ,Facilitator    
 ,TimeLocation    
 ,AssessmentsNeeded    
 ,CommunicationAccomodations    
 ,IssuesToAvoid    
 ,IssuesToDiscuss    
 ,SourceOfPrePlanningInfo    
 ,SelfDeterminationDesired    
 ,FiscalIntermediaryDesired    
 ,PamphletGiven    
 ,PamphletDiscussed    
 ,PrePlanIndependentFacilitatorDiscussed    
 ,PrePlanIndependentFacilitatorDesired    
 ,PrePlanGuardianContacted    
 ,PrePlanSeparateDocument    
 ,CommunityActivitiesCurrentDesired    
 ,CommunityActivitiesIncreaseDesired    
 ,CommunityActivitiesNeedsList    
 ,PsCurrentHealthIssues    
 ,PsCurrentHealthIssuesComment    
 ,PsCurrentHealthIssuesNeedsList    
 ,HistMentalHealthTx    
 ,HistMentalHealthTxNeedsList    
 ,HistMentalHealthTxComment    
 ,HistFamilyMentalHealthTx    
 ,HistFamilyMentalHealthTxNeedsList    
 ,HistFamilyMentalHealthTxComment    
 ,PsClientAbuseIssues    
 ,PsClientAbuesIssuesComment    
 ,PsClientAbuseIssuesNeedsList    
 ,PsFamilyConcernsComment    
 ,PsRiskLossOfPlacement    
 ,PsRiskLossOfPlacementDueTo    
 ,PsRiskSensoryMotorFunction    
 ,PsRiskSensoryMotorFunctionDueTo    
 ,PsRiskSafety    
 ,PsRiskSafetyDueTo    
 ,PsRiskLossOfSupport    
 ,PsRiskLossOfSupportDueTo    
 ,PsRiskExpulsionFromSchool    
 ,PsRiskExpulsionFromSchoolDueTo    
 ,PsRiskHospitalization    
 ,PsRiskHospitalizationDueTo    
 ,PsRiskCriminalJusticeSystem    
 ,PsRiskCriminalJusticeSystemDueTo    
 ,PsRiskElopementFromHome    
 ,PsRiskElopementFromHomeDueTo    
 ,PsRiskLossOfFinancialStatus    
 ,PsRiskLossOfFinancialStatusDueTo    
 ,PsDevelopmentalMilestones    
 ,PsDevelopmentalMilestonesComment    
 ,PsDevelopmentalMilestonesNeedsList    
 ,PsChildEnvironmentalFactors    
 ,PsChildEnvironmentalFactorsComment    
 ,PsChildEnvironmentalFactorsNeedsList    
 ,PsLanguageFunctioning    
 ,PsLanguageFunctioningComment    
 ,PsLanguageFunctioningNeedsList    
 ,PsVisualFunctioning    
 ,PsVisualFunctioningComment    
 ,PsVisualFunctioningNeedsList    
 ,PsPrenatalExposure    
 ,PsPrenatalExposureComment    
 ,PsPrenatalExposureNeedsList    
 ,PsChildMentalHealthHistory    
 ,PsChildMentalHealthHistoryComment    
 ,PsChildMentalHealthHistoryNeedsList    
 ,PsIntellectualFunctioning    
 ,PsIntellectualFunctioningComment    
 ,PsIntellectualFunctioningNeedsList    
 ,PsLearningAbility    
 ,PsLearningAbilityComment    
 ,PsLearningAbilityNeedsList    
 ,PsFunctioningConcernComment    
 ,PsPeerInteraction    
 ,PsPeerInteractionComment    
 ,PsPeerInteractionNeedsList    
 ,PsParentalParticipation    
 ,PsParentalParticipationComment    
 ,PsParentalParticipationNeedsList    
 ,PsSchoolHistory    
 ,PsSchoolHistoryComment    
 ,PsSchoolHistoryNeedsList    
 ,PsImmunizations    
 ,PsImmunizationsComment    
 ,PsImmunizationsNeedsList    
 ,PsChildHousingIssues    
 ,PsChildHousingIssuesComment    
 ,PsChildHousingIssuesNeedsList    
 ,PsSexuality    
 ,PsSexualityComment    
 ,PsSexualityNeedsList    
 ,PsFamilyFunctioning    
 ,PsFamilyFunctioningComment    
 ,PsFamilyFunctioningNeedsList    
 ,PsTraumaticIncident    
 ,PsTraumaticIncidentComment    
 ,PsTraumaticIncidentNeedsList    
 ,HistDevelopmental    
 ,HistDevelopmentalComment    
 ,HistResidential    
 ,HistResidentialComment    
 ,HistOccupational    
 ,HistOccupationalComment    
 ,HistLegalFinancial    
 ,HistLegalFinancialComment    
 ,SignificantEventsPastYear    
 ,PsGrossFineMotor    
 ,PsGrossFineMotorComment    
 ,PsGrossFineMotorNeedsList    
 ,PsSensoryPerceptual    
 ,PsSensoryPerceptualComment    
 ,PsSensoryPerceptualNeedsList    
 ,PsCognitiveFunction    
 ,PsCognitiveFunctionComment    
 ,PsCognitiveFunctionNeedsList    
 ,PsCommunicativeFunction    
 ,PsCommunicativeFunctionComment    
 ,PsCommunicativeFunctionNeedsList    
 ,PsCurrentPsychoSocialFunctiion    
 ,PsCurrentPsychoSocialFunctiionComment    
 ,PsCurrentPsychoSocialFunctiionNeedsList    
 ,PsAdaptiveEquipment    
 ,PsAdaptiveEquipmentComment    
 ,PsAdaptiveEquipmentNeedsList    
 ,PsSafetyMobilityHome    
 ,PsSafetyMobilityHomeComment    
 ,PsSafetyMobilityHomeNeedsList    
 ,PsHealthSafetyChecklistComplete    
 ,PsAccessibilityIssues    
 ,PsAccessibilityIssuesComment    
 ,PsAccessibilityIssuesNeedsList    
 ,PsEvacuationTraining    
 ,PsEvacuationTrainingComment    
 ,PsEvacuationTrainingNeedsList    
 ,Ps24HourSetting    
 ,Ps24HourSettingComment    
 ,Ps24HourSettingNeedsList    
 ,Ps24HourNeedsAwakeSupervision    
 ,PsSpecialEdEligibility    
 ,PsSpecialEdEligibilityComment    
 ,PsSpecialEdEligibilityNeedsList    
 ,PsSpecialEdEnrolled    
 ,PsSpecialEdEnrolledComment    
 ,PsSpecialEdEnrolledNeedsList    
 ,PsEmployer    
 ,PsEmployerComment    
 ,PsEmployerNeedsList    
 ,PsEmploymentIssues    
 ,PsEmploymentIssuesComment    
 ,PsEmploymentIssuesNeedsList    
 ,PsRestrictionsOccupational    
 ,PsRestrictionsOccupationalComment    
 ,PsRestrictionsOccupationalNeedsList    
 ,PsFunctionalAssessmentNeeded    
 ,PsAdvocacyNeeded    
 ,PsPlanDevelopmentNeeded    
 ,PsLinkingNeeded    
 ,PsDDInformationProvidedBy    
 ,HistPreviousDx    
 ,HistPreviousDxComment    
 ,PsLegalIssues    
 ,PsLegalIssuesComment    
 ,PsLegalIssuesNeedsList    
 ,PsCulturalEthnicIssues    
 ,PsCulturalEthnicIssuesComment    
 ,PsCulturalEthnicIssuesNeedsList    
 ,PsSpiritualityIssues    
 ,PsSpiritualityIssuesComment    
 ,PsSpiritualityIssuesNeedsList    
 --,SuicideNotPresent    
 ,SuicideIdeation    
 ,SuicideActive    
 ,SuicidePassive    
 ,SuicideMeans    
 ,SuicidePlan     
 ,SuicideOtherRiskSelf    
 ,SuicideOtherRiskSelfComment
 ,HomicideIdeation    
 ,HomicideActive    
 ,HomicidePassive    
 ,HomicidePlan  
 ,HomicdeOtherRiskOthers    
 ,HomicideOtherRiskOthersComment    
 ,PhysicalAgressionNotPresent    
 ,PhysicalAgressionSelf    
 ,PhysicalAgressionOthers    
 ,PhysicalAgressionCurrentIssue    
 ,PhysicalAgressionNeedsList    
 ,PhysicalAgressionBehaviorsPastHistory    
 ,RiskAccessToWeapons    
 ,RiskAppropriateForAdditionalScreening    
 ,RiskClinicalIntervention    
 ,RiskOtherFactorsNone    
 ,RiskOtherFactors    
 ,RiskOtherFactorsNeedsList    
 ,StaffAxisV    
 ,StaffAxisVReason    
 ,ClientStrengthsNarrative    
 ,CrisisPlanningClientHasPlan    
 ,CrisisPlanningNarrative    
 ,CrisisPlanningDesired    
 ,CrisisPlanningNeedsList    
 ,CrisisPlanningMoreInfo    
 ,AdvanceDirectiveClientHasDirective    
 ,AdvanceDirectiveDesired    
 ,AdvanceDirectiveNarrative    
 ,AdvanceDirectiveNeedsList    
 ,AdvanceDirectiveMoreInfo    
 ,NaturalSupportSufficiency    
 ,NaturalSupportNeedsList    
 ,NaturalSupportIncreaseDesired    
 ,ClinicalSummary    
 ,UncopeQuestionU    
 ,UncopeApplicable    
 ,UncopeApplicableReason    
 ,UncopeQuestionN    
 ,UncopeQuestionC    
 ,UncopeQuestionO    
 ,UncopeQuestionP    
 ,UncopeQuestionE    
 ,UncopeCompleteFullSUAssessment    
 ,SubstanceUseNeedsList    
 ,DecreaseSymptomsNeedsList    
 ,DDEPreviouslyMet    
 ,DDAttributableMentalPhysicalLimitation    
 ,DDDxAxisI    
 ,DDDxAxisII    
 ,DDDxAxisIII    
 ,DDDxAxisIV    
 ,DDDxAxisV    
 ,DDDxSource    
 ,DDManifestBeforeAge22    
 ,DDContinueIndefinitely    
 ,DDLimitSelfCare    
 ,DDLimitLanguage    
 ,DDLimitLearning    
 ,DDLimitMobility    
 ,DDLimitSelfDirection    
 ,DDLimitEconomic    
 ,DDLimitIndependentLiving    
 ,DDNeedMulitpleSupports    
 ,CAFASDate    
 ,RaterClinician    
 ,CAFASInterval    
 ,SchoolPerformance    
 ,SchoolPerformanceComment    
 ,HomePerformance    
 ,HomePerfomanceComment    
 ,CommunityPerformance    
 ,CommunityPerformanceComment    
 ,BehaviorTowardsOther    
 ,BehaviorTowardsOtherComment    
 ,MoodsEmotion    
 ,MoodsEmotionComment    
 ,SelfHarmfulBehavior    
 ,SelfHarmfulBehaviorComment    
 ,SubstanceUse    
 ,SubstanceUseComment    
 ,Thinkng    
 ,ThinkngComment    
 ,YouthTotalScore    
 ,PrimaryFamilyMaterialNeeds    
 ,PrimaryFamilyMaterialNeedsComment    
 ,PrimaryFamilySocialSupport    
 ,PrimaryFamilySocialSupportComment    
 ,NonCustodialMaterialNeeds    
 ,NonCustodialMaterialNeedsComment    
 ,NonCustodialSocialSupport    
 ,NonCustodialSocialSupportComment    
 ,SurrogateMaterialNeeds    
 ,SurrogateMaterialNeedsComment    
 ,SurrogateSocialSupport    
 ,SurrogateSocialSupportComment    
 ,DischargeCriteria    
 ,PrePlanFiscalIntermediaryComment    
 ,StageOfChange    
 ,PsEducation    
 ,PsEducationNeedsList    
 ,PsMedications    
 ,PsMedicationsNeedsList    
 ,PsMedicationsListToBeModified    
 ,PhysicalConditionQuadriplegic    
 ,PhysicalConditionMultipleSclerosis    
 ,PhysicalConditionBlindness    
 ,PhysicalConditionDeafness    
 ,PhysicalConditionParaplegic    
 ,PhysicalConditionCerebral    
 ,PhysicalConditionMuteness    
 ,PhysicalConditionOtherHearingImpairment    
 ,TestingReportsReviewed    
 ,LOCId    
 ,SevereProfoundDisability    
 ,SevereProfoundDisabilityComment    
 ,EmploymentStatus    
 ,DxTabDisabled
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
 ,CreatedBy    
 ,CreatedDate    
 ,ModifiedBy    
 ,ModifiedDate    
 ,RecordDeleted    
 ,DeletedDate    
 ,DeletedBy 
  ,GuardianFirstName
 ,GuardianLastName
 ,RelationWithGuardian   
FROM CustomDocumentMHAssessments a    
WHERE a.documentVersionId = @DocumentVersionId    
 AND isnull(a.RecordDeleted, 'N') = 'N'    
    
--INSERT INTO #CustomCAFAS2 (    
-- DocumentVersionId    
-- ,CAFASDate    
-- ,RaterClinician    
-- ,CAFASInterval    
-- ,SchoolPerformance    
-- ,SchoolPerformanceComment    
-- ,HomePerformance    
-- ,HomePerfomanceComment    
-- ,CommunityPerformance    
-- ,CommunityPerformanceComment    
-- ,BehaviorTowardsOther    
-- ,BehaviorTowardsOtherComment    
-- ,MoodsEmotion    
-- ,MoodsEmotionComment    
-- ,SelfHarmfulBehavior    
-- ,SelfHarmfulBehaviorComment    
-- ,SubstanceUse    
-- ,SubstanceUseComment    
-- ,Thinkng    
-- ,ThinkngComment    
-- ,PrimaryFamilyMaterialNeeds    
-- ,PrimaryFamilyMaterialNeedsComment    
-- ,PrimaryFamilySocialSupport    
-- ,PrimaryFamilySocialSupportComment    
-- ,NonCustodialMaterialNeeds    
-- ,NonCustodialMaterialNeedsComment    
-- ,NonCustodialSocialSupport    
-- ,NonCustodialSocialSupportComment    
-- ,SurrogateMaterialNeeds    
-- ,SurrogateMaterialNeedsComment    
-- ,SurrogateSocialSupport    
-- ,SurrogateSocialSupportComment    
-- ,CreatedBy    
-- ,CreatedDate    
-- ,ModifiedBy    
-- ,ModifiedDate    
-- ,RecordDeleted    
-- ,DeletedDate    
-- ,DeletedBy    
-- )    
--SELECT DocumentVersionId    
-- ,CAFASDate    
-- ,RaterClinician    
-- ,CAFASInterval    
-- ,SchoolPerformance    
-- ,SchoolPerformanceComment    
-- ,HomePerformance    
-- ,HomePerfomanceComment    
-- ,CommunityPerformance    
-- ,CommunityPerformanceComment    
-- ,BehaviorTowardsOther    
-- ,BehaviorTowardsOtherComment    
-- ,MoodsEmotion    
-- ,MoodsEmotionComment    
-- ,SelfHarmfulBehavior    
-- ,SelfHarmfulBehaviorComment    
-- ,SubstanceUse    
-- ,SubstanceUseComment    
-- ,Thinkng    
-- ,ThinkngComment    
-- ,PrimaryFamilyMaterialNeeds    
-- ,PrimaryFamilyMaterialNeedsComment    
-- ,PrimaryFamilySocialSupport    
-- ,PrimaryFamilySocialSupportComment    
-- ,NonCustodialMaterialNeeds    
-- ,NonCustodialMaterialNeedsComment    
-- ,NonCustodialSocialSupport    
-- ,NonCustodialSocialSupportComment    
-- ,SurrogateMaterialNeeds    
-- ,SurrogateMaterialNeedsComment    
-- ,SurrogateSocialSupport    
-- ,SurrogateSocialSupportComment    
-- ,CreatedBy    
-- ,CreatedDate    
-- ,ModifiedBy    
-- ,ModifiedDate    
-- ,RecordDeleted    
-- ,DeletedDate    
-- ,DeletedBy    
--FROM CustomCAFAS2    
--WHERE DocumentVersionId = @DocumentVersionId    
-- AND isnull(RecordDeleted, 'N') = 'N'    
    
--INSERT INTO #CustomMentalStatuses2 (    
-- DocumentVersionId    
-- ,AppearanceAddToNeedsList    
-- ,AppearanceNeatClean    
-- ,AppearancePoorHygiene    
-- ,AppearanceWellGroomed    
-- ,AppearanceAppropriatelyDressed    
-- ,AppearanceYoungerThanStatedAge    
-- ,AppearanceOlderThanStatedAge    
-- ,AppearanceOverweight    
-- ,AppearanceUnderweight    
-- ,AppearanceEccentric    
-- ,AppearanceSeductive    
-- ,AppearanceUnkemptDisheveled    
-- ,AppearanceOther    
-- ,AppearanceComment    
-- ,IntellectualAddToNeedsList    
-- ,IntellectualAboveAverage    
-- ,IntellectualAverage    
-- ,IntellectualBelowAverage    
-- ,IntellectualPossibleMR    
-- ,IntellectualDocumentedMR    
-- ,IntellectualOther    
-- ,IntellectualComment    
-- ,CommunicationAddToNeedsList    
-- ,CommunicationNormal    
-- ,CommunicationUsesSignLanguage    
-- ,CommunicationUnableToRead    
-- ,CommunicationNeedForBraille    
-- ,CommunicationHearingImpaired    
-- ,CommunicationDoesLipReading    
-- ,CommunicationEnglishIsSecondLanguage    
-- ,CommunicationTranslatorNeeded    
-- ,CommunicationOther    
-- ,CommunicationComment    
-- ,MoodAddToNeedsList    
-- ,MoodUnremarkable    
-- ,MoodCooperative    
-- ,MoodAnxious    
-- ,MoodTearful    
-- ,MoodCalm    
-- ,MoodLabile    
-- ,MoodPessimistic    
-- ,MoodCheerful    
-- ,MoodGuilty    
-- ,MoodEuphoric    
-- ,MoodDepressed    
-- ,MoodHostile    
-- ,MoodIrritable    
-- ,MoodDramatized    
-- ,MoodFearful    
-- ,MoodSupicious    
-- ,MoodOther    
-- ,MoodComment    
-- ,AffectAddToNeedsList    
-- ,AffectPrimarilyAppropriate    
-- ,AffectRestricted    
-- ,AffectBlunted    
-- ,AffectFlattened    
-- ,AffectDetached    
-- ,AffectPrimarilyInappropriate    
-- ,AffectOther    
-- ,AffectComment    
-- ,SpeechAddToNeedsList    
-- ,SpeechNormal    
-- ,SpeechLogicalCoherent    
-- ,SpeechTangential    
-- ,SpeechSparseSlow    
-- ,SpeechRapidPressured    
-- ,SpeechSoft    
-- ,SpeechCircumstantial    
-- ,SpeechLoud    
-- ,SpeechRambling    
-- ,SpeechOther    
-- ,SpeechComment    
-- ,ThoughtAddToNeedsList    
-- ,ThoughtUnremarkable    
-- ,ThoughtParanoid    
-- ,ThoughtGrandiose    
-- ,ThoughtObsessive    
-- ,ThoughtBizarre    
-- ,ThoughtFlightOfIdeas    
-- ,ThoughtDisorganized    
-- ,ThoughtAuditoryHallucinations    
-- ,ThoughtVisualHallucinations    
-- ,ThoughtTactileHallucinations    
-- ,ThoughtOther    
-- ,ThoughtComment    
-- ,BehaviorAddToNeedsList    
-- ,BehaviorNormal    
-- ,BehaviorRestless    
-- ,BehaviorTremors    
-- ,BehaviorPoorEyeContact    
-- ,BehaviorAgitated    
-- ,BehaviorPeculiar    
-- ,BehaviorSelfDestructive    
-- ,BehaviorSlowed    
-- ,BehaviorDestructiveToOthers    
-- ,BehaviorCompulsive    
-- ,BehaviorOther    
-- ,BehaviorComment    
-- ,OrientationAddToNeedsList    
-- ,OrientationToPersonPlaceTime    
-- ,OrientationNotToPerson    
-- ,OrientationNotToPlace    
-- ,OrientationNotToTime    
-- ,OrientationOther    
-- ,OrientationComment    
-- ,InsightAddToNeedsList    
-- ,InsightGood    
-- ,InsightFair    
-- ,InsightPoor    
-- ,InsightLacking    
-- ,InsightOther    
-- ,InsightComment    
-- ,MemoryAddToNeedsList    
-- ,MemoryGoodNormal    
-- ,MemoryImpairedShortTerm    
-- ,MemoryImpairedLongTerm    
-- ,MemoryOther    
-- ,MemoryComment    
-- ,RealityOrientationAddToNeedsList    
-- ,RealityOrientationIntact    
-- ,RealityOrientationTenuous    
-- ,RealityOrientationPoor    
-- ,RealityOrientationOther    
-- ,RealityOrientationComment    
-- ,CreatedBy    
-- ,CreatedDate    
-- ,ModifiedBy    
-- ,ModifiedDate    
-- ,RecordDeleted    
-- ,DeletedDate    
-- ,DeletedBy    
-- )    
--SELECT DocumentVersionId    
-- ,AppearanceAddToNeedsList    
-- ,AppearanceNeatClean    
-- ,AppearancePoorHygiene    
-- ,AppearanceWellGroomed    
-- ,AppearanceAppropriatelyDressed    
-- ,AppearanceYoungerThanStatedAge    
-- ,AppearanceOlderThanStatedAge    
-- ,AppearanceOverweight    
-- ,AppearanceUnderweight    
-- ,AppearanceEccentric    
-- ,AppearanceSeductive    
-- ,AppearanceUnkemptDisheveled    
-- ,AppearanceOther    
-- ,AppearanceComment    
-- ,IntellectualAddToNeedsList    
-- ,IntellectualAboveAverage    
-- ,IntellectualAverage    
-- ,IntellectualBelowAverage    
-- ,IntellectualPossibleMR    
-- ,IntellectualDocumentedMR    
-- ,IntellectualOther    
-- ,IntellectualComment    
-- ,CommunicationAddToNeedsList    
-- ,CommunicationNormal    
-- ,CommunicationUsesSignLanguage    
-- ,CommunicationUnableToRead    
-- ,CommunicationNeedForBraille    
-- ,CommunicationHearingImpaired    
-- ,CommunicationDoesLipReading    
-- ,CommunicationEnglishIsSecondLanguage    
-- ,CommunicationTranslatorNeeded    
-- ,CommunicationOther    
-- ,CommunicationComment    
-- ,MoodAddToNeedsList    
-- ,MoodUnremarkable    
-- ,MoodCooperative    
-- ,MoodAnxious    
-- ,MoodTearful    
-- ,MoodCalm    
-- ,MoodLabile    
-- ,MoodPessimistic    
-- ,MoodCheerful    
-- ,MoodGuilty    
-- ,MoodEuphoric    
-- ,MoodDepressed    
-- ,MoodHostile    
-- ,MoodIrritable    
-- ,MoodDramatized    
-- ,MoodFearful    
-- ,MoodSupicious    
-- ,MoodOther    
-- ,MoodComment    
-- ,AffectAddToNeedsList    
-- ,AffectPrimarilyAppropriate    
-- ,AffectRestricted    
-- ,AffectBlunted    
-- ,AffectFlattened    
-- ,AffectDetached    
-- ,AffectPrimarilyInappropriate    
-- ,AffectOther    
-- ,AffectComment    
-- ,SpeechAddToNeedsList    
-- ,SpeechNormal    
-- ,SpeechLogicalCoherent    
-- ,SpeechTangential    
-- ,SpeechSparseSlow    
-- ,SpeechRapidPressured    
-- ,SpeechSoft    
-- ,SpeechCircumstantial    
-- ,SpeechLoud    
-- ,SpeechRambling    
-- ,SpeechOther    
-- ,SpeechComment     ,ThoughtAddToNeedsList    
-- ,ThoughtUnremarkable    
-- ,ThoughtParanoid    
-- ,ThoughtGrandiose    
-- ,ThoughtObsessive    
-- ,ThoughtBizarre    
-- ,ThoughtFlightOfIdeas    
-- ,ThoughtDisorganized    
-- ,ThoughtAuditoryHallucinations    
-- ,ThoughtVisualHallucinations    
-- ,ThoughtTactileHallucinations    
-- ,ThoughtOther    
-- ,ThoughtComment    
-- ,BehaviorAddToNeedsList    
-- ,BehaviorNormal    
-- ,BehaviorRestless    
-- ,BehaviorTremors    
-- ,BehaviorPoorEyeContact    
-- ,BehaviorAgitated    
-- ,BehaviorPeculiar    
-- ,BehaviorSelfDestructive    
-- ,BehaviorSlowed    
-- ,BehaviorDestructiveToOthers    
-- ,BehaviorCompulsive    
-- ,BehaviorOther    
-- ,BehaviorComment    
-- ,OrientationAddToNeedsList    
-- ,OrientationToPersonPlaceTime    
-- ,OrientationNotToPerson    
-- ,OrientationNotToPlace    
-- ,OrientationNotToTime    
-- ,OrientationOther    
-- ,OrientationComment    
-- ,InsightAddToNeedsList    
-- ,InsightGood    
-- ,InsightFair    
-- ,InsightPoor    
-- ,InsightLacking    
-- ,InsightOther    
-- ,InsightComment    
-- ,MemoryAddToNeedsList    
-- ,MemoryGoodNormal    
-- ,MemoryImpairedShortTerm    
-- ,MemoryImpairedLongTerm    
-- ,MemoryOther    
-- ,MemoryComment    
-- ,RealityOrientationAddToNeedsList    
-- ,RealityOrientationIntact    
-- ,RealityOrientationTenuous    
-- ,RealityOrientationPoor    
-- ,RealityOrientationOther    
-- ,RealityOrientationComment    
-- ,CreatedBy    
-- ,CreatedDate    
-- ,ModifiedBy    
-- ,ModifiedDate    
-- ,RecordDeleted    
-- ,DeletedDate    
-- ,DeletedBy    
--FROM CustomMentalStatuses2    
--WHERE DocumentVersionId = @DocumentVersionId    
-- AND isnull(RecordDeleted, 'N') = 'N'    
    
INSERT INTO #CustomMHAssessmentSupports (    
 DocumentVersionId    
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
 ,DeletedDate    
 ,DeletedBy    
 )    
SELECT DocumentVersionId    
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
 ,DeletedDate    
 ,DeletedBy    
FROM CustomMHAssessmentSupports    
WHERE DocumentVersionId = @DocumentVersionId    
 AND isnull(RecordDeleted, 'N') = 'N'    
    
--	select * from #CustomHRMAssessmentSupports2
----      
----DX Tables      
----      
--CREATE TABLE #DiagnosesIandII (    
-- DocumentVersionId INT    
-- ,Axis INT NOT NULL    
-- ,DSMCode CHAR(6) NOT NULL    
-- ,DSMNumber INT NOT NULL    
-- ,DiagnosisType INT    
-- ,RuleOut CHAR(1)    
-- ,Billable CHAR(1)    
-- ,Severity INT    
-- ,DSMVersion VARCHAR(6) NULL    
-- ,DiagnosisOrder INT NOT NULL    
-- ,Specifier TEXT NULL    
-- ,RowIdentifier CHAR(36)    
-- ,CreatedBy VARCHAR(100)    
-- ,CreatedDate DATETIME    
-- ,ModifiedBy VARCHAR(100)    
-- ,ModifiedDate DATETIME    
-- ,RecordDeleted CHAR(1)    
-- ,DeletedDate DATETIME NULL    
-- ,DeletedBy VARCHAR(100)    
-- )    
    
--INSERT INTO #DiagnosesIandII (    
-- DocumentVersionId    
-- ,Axis    
-- ,DSMCode    
-- ,DSMNumber    
-- ,DiagnosisType    
-- ,RuleOut    
-- ,Billable    
-- ,Severity    
-- ,DSMVersion    
-- ,DiagnosisOrder    
-- ,Specifier    
-- ,RowIdentifier    
-- ,CreatedBy    
-- ,CreatedDate    
-- ,ModifiedBy    
-- ,ModifiedDate    
-- ,RecordDeleted    
-- ,DeletedDate    
-- ,DeletedBy    
-- )    
--SELECT DocumentVersionId    
-- ,Axis    
-- ,DSMCode    
-- ,DSMNumber    
-- ,DiagnosisType    
-- ,RuleOut    
-- ,Billable    
-- ,Severity    
-- ,DSMVersion    
-- ,DiagnosisOrder    
-- ,Specifier    
-- ,a.RowIdentifier    
-- ,a.CreatedBy    
-- ,a.CreatedDate    
-- ,a.ModifiedBy    
-- ,a.ModifiedDate    
-- ,a.RecordDeleted    
-- ,a.DeletedDate    
-- ,a.DeletedBy    
--FROM DiagnosesIAndII a    
--WHERE a.documentversionId = @documentversionId    
-- AND isnull(a.RecordDeleted, 'N') = 'N'    
    
--CREATE TABLE #DiagnosesV (    
-- DocumentVersionId INT    
-- ,AxisV INT NULL    
-- ,CreatedBy VARCHAR(100)    
-- ,CreatedDate DATETIME    
-- ,ModifiedBy VARCHAR(100)    
-- ,ModifiedDate DATETIME    
-- ,RecordDeleted CHAR(1)    
-- ,DeletedDate DATETIME NULL    
-- ,DeletedBy VARCHAR(100)    
-- )    
    
--INSERT INTO #DiagnosesV (    
-- DocumentVersionId    
-- ,AxisV    
-- ,CreatedBy    
-- ,CreatedDate    
-- ,ModifiedBy    
-- ,ModifiedDate    
-- ,RecordDeleted    
-- ,DeletedDate    
-- ,DeletedBy    
-- )    
--SELECT DocumentVersionId    
-- ,AxisV    
-- ,a.CreatedBy    
-- ,a.CreatedDate    
-- ,a.ModifiedBy    
-- ,a.ModifiedDate    
-- ,a.RecordDeleted    
-- ,a.DeletedDate    
-- ,a.DeletedBy    
--FROM DiagnosesV a    
--WHERE a.documentversionId = @documentversionId    
-- AND isnull(a.RecordDeleted, 'N') = 'N'    
    
----Changes Made By Rakesh to validate ASAM Pop up for Kalamazoo    
----*TABLE CREATE*--                     
--CREATE TABLE #CustomASAMPlacements (    
-- DocumentVersionId INT    
-- ,Dimension1LevelOfCare INT    
-- ,Dimension2LevelOfCare INT    
-- ,Dimension3LevelOfCare INT    
-- ,Dimension4LevelOfCare INT    
-- ,Dimension5LevelOfCare INT    
-- ,Dimension6LevelOfCare INT    
-- )    
    
----*INSERT LIST*--                     
--INSERT INTO #CustomASAMPlacements (    
-- DocumentVersionId    
-- ,Dimension1LevelOfCare    
-- ,Dimension2LevelOfCare    
-- ,Dimension3LevelOfCare    
-- ,Dimension4LevelOfCare    
-- ,Dimension5LevelOfCare    
-- ,Dimension6LevelOfCare    
-- )    
----*Select LIST*--                     
--SELECT DocumentVersionId    
-- ,Dimension1LevelOfCare    
-- ,Dimension2LevelOfCare    
-- ,Dimension3LevelOfCare    
-- ,Dimension4LevelOfCare    
-- ,Dimension5LevelOfCare    
-- ,Dimension6LevelOfCare    
--FROM CustomASAMPlacements    
--WHERE DocumentVersionId = @documentversionId    
-- AND isnull(RecordDeleted, 'N') = 'N'    
    
----Changes End here    
    
------CustomDocumentAssessmentSubstanceUses--    
CREATE TABLE #CustomDocumentAssessmentSubstanceUses (    
 DocumentVersionId int    
 ,CreatedBy VARCHAR(100)    
 ,CreatedDate DATETIME    
 ,ModifiedBy VARCHAR(100)    
 ,ModifiedDate DATETIME    
 ,RecordDeleted CHAR(1)    
 ,DeletedDate DATETIME NULL    
 ,DeletedBy VARCHAR(100)    
 ,UseOfAlcohol char(1)    
 ,AlcoholAddToNeedsList char(1)    
 ,UseOfTobaccoNicotine char(1)    
 ,UseOfTobaccoNicotineQuit DATETIME  NULL  
 ,UseOfTobaccoNicotineTypeOfFrequency varchar(100)    
 ,UseOfTobaccoNicotineAddToNeedsList char(1)   
 ,UseOfIllicitDrugs char(1)    
 ,UseOfIllicitDrugsTypeFrequency varchar(100)    
 ,UseOfIllicitDrugsAddToNeedsList char(1)   
 ,PrescriptionOTCDrugs char(1)    
 ,PrescriptionOTCDrugsTypeFrequency varchar(100)    
 ,PrescriptionOTCDrugsAddtoNeedsList char(1) 
 ,DrinksPerWeek int
 ,LastTimeDrinkDate datetime
 ,LastTimeDrinks char(1)
 ,IllegalDrugs char(1)
 ,BriefCounseling CHAR(1)
 ,FeedBackOnAlcoholUse CHAR(1)
 ,Harms CHAR(1)
 ,DevelopmentOfPlans CHAR(1)
 ,Refferal CHAR(1)
 ,DDOneTimeOnly CHAR(1)
 ,NotApplicable    CHAR(1)
 )    
     
--Insert CustomDocumentAssessmentSubstanceUses     
INSERT INTO #CustomDocumentAssessmentSubstanceUses (    
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
 ,DrinksPerWeek
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
 )    
     
--Select CustomDocumentAssessmentSubstanceUses    
SELECT DocumentVersionId    
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
 ,DrinksPerWeek
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
WHERE DocumentVersionId = @documentversionId    
 AND isnull(RecordDeleted, 'N') = 'N'      
   
 
    
---- CustomDocumentPreEmploymentActivities  
CREATE TABLE #CustomDocumentPreEmploymentActivities (    
  DocumentVersionId int  
  ,CreatedBy varchar(100)  
  ,CreatedDate DATETIME  
  ,ModifiedBy VARCHAR(100)  
  ,ModifiedDate DATETIME  
  ,RecordDeleted CHAR(1)  
  ,DeletedBy DATETIME  
  ,DeletedDate DATETIME  
  ,EducationTraining char(1)  
  ,EducationTrainingNeeds char(1)  
  ,EducationTrainingNeedsComments varchar(MAX)  
  ,PersonalCareerPlanning char(1)  
  ,PersonalCareerPlanningNeeds char(1)  
  ,PersonalCareerPlanningNeedsComments varchar(MAX)  
  ,EmploymentOpportunities char(1)  
  ,EmploymentOpportunitiesNeeds char(1)  
  ,EmploymentOpportunitiesNeedsComments varchar(MAX)  
  ,SupportedEmployment char(1)  
  ,SupportedEmploymentNeeds char(1)  
  ,SupportedEmploymentNeedsComments varchar(MAX)  
  ,WorkHistory char(1)  
  ,WorkHistoryNeeds char(1)  
  ,WorkHistoryNeedsComments varchar(MAX)  
  ,GainfulEmploymentBenefits char(1)  
  ,GainfulEmploymentBenefitsNeeds char(1)  
  ,GainfulEmploymentBenefitsNeedsComments varchar(MAX)  
  ,GainfulEmployment char(1)  
  ,GainfulEmploymentNeeds char(1)  
  ,GainfulEmploymentNeedsComments varchar(MAX)  
 )    
     
--Insert CustomDocumentPreEmploymentActivities     
INSERT INTO #CustomDocumentPreEmploymentActivities (    
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
 )    
     
--Select CustomDocumentPreEmploymentActivities    
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
      
  
----CustomDocumentCraffts For Kalamazoo--  
CREATE TABLE #CustomDocumentCraffts (   
 DocumentVersionId int ,   
  CreatedBy varchar(100) ,          
  CreatedDate DATETIME,          
  ModifiedBy varchar(100),          
  ModifiedDate DATETIME,          
  RecordDeleted DATETIME,          
  DeletedBy DATETIME,          
  DeletedDate DATETIME,          
  CrafftApplicable char(1),          
  CrafftApplicableReason varchar(MAX),     
  CrafftQuestionC char(1),          
  CrafftQuestionR char(1),          
  CrafftQuestionA char(1),          
  CrafftQuestionF char(1),          
  CrafftQuestionFR char(1),          
  CrafftQuestionT char(1),          
  CrafftCompleteFullSUAssessment char(1),          
  CrafftStageOfChange int          
 )    
     
----Insert CustomDocumentCraffts     
INSERT INTO #CustomDocumentCraffts (    
  DocumentVersionId,  
  CreatedBy,          
  CreatedDate,          
  ModifiedBy,          
  ModifiedDate,          
  RecordDeleted,          
  DeletedBy,          
  DeletedDate,          
  CrafftApplicable,          
  CrafftApplicableReason,     
  CrafftQuestionC,          
  CrafftQuestionR,          
  CrafftQuestionA,          
  CrafftQuestionF,          
  CrafftQuestionFR,          
  CrafftQuestionT,          
  CrafftCompleteFullSUAssessment,          
  CrafftStageOfChange          
 )    
     
 --Select CustomDocumentCraffts            
  SELECT DocumentVersionId,          
  CreatedBy,          
  CreatedDate,          
  ModifiedBy,          
  ModifiedDate,          
  RecordDeleted,          
  DeletedBy,          
  DeletedDate,          
  CrafftApplicable,          
  CrafftApplicableReason,     
  CrafftQuestionC,          
  CrafftQuestionR,          
  CrafftQuestionA,          
  CrafftQuestionF,          
  CrafftQuestionFR,          
  CrafftQuestionT,          
  CrafftCompleteFullSUAssessment,          
  CrafftStageOfChange          
  From CustomDocumentMHCRAFFTs          
  WHERE (ISNULL(RecordDeleted, 'N') = 'N')           
  AND (DocumentVersionId = @DocumentVersionId)     
  
  Create Table #CustomDocumentAssessmentDiagnosisIDDEligibilities(  
DocumentVersionId	int,
CreatedBy	varchar(30),  
CreatedDate	datetime,
ModifiedBy	varchar(30),
ModifiedDate	datetime,
RecordDeleted	char(1),
DeletedBy	varchar(30),
DeletedDate	datetime,
MentalPhysicalImpairment char(1),
ManifestedPrior	char(1),
TestingReportsReviewed	char(1),
LikelyToContinue char(1))  

Insert into #CustomDocumentAssessmentDiagnosisIDDEligibilities
(DocumentVersionId,CreatedBy,  CreatedDate,ModifiedBy,ModifiedDate,RecordDeleted,DeletedBy,DeletedDate,
MentalPhysicalImpairment,ManifestedPrior,TestingReportsReviewed,LikelyToContinue)
Select DocumentVersionId,CreatedBy,  CreatedDate,ModifiedBy,ModifiedDate,RecordDeleted,DeletedBy,DeletedDate,
MentalPhysicalImpairment,ManifestedPrior,TestingReportsReviewed,LikelyToContinue
From CustomDocumentAssessmentDiagnosisIDDEligibilities  
Where DocumentVersionId = @DocumentVersionId  
and isnull(RecordDeleted,'N')='N'  

Create Table #CustomAssessmentDiagnosisIDDCriteria(
AssessmentDiagnosisIDDCriteriaId int,
CreatedBy	varchar(30),
CreatedDate	datetime,
ModifiedBy	varchar(30),
ModifiedDate	datetime,
RecordDeleted	char(1),
DeletedBy	varchar(30),
DeletedDate	datetime,
DocumentVersionId	int,
SubstantialFunctional	int,
IsChecked	char(1));

Insert into #CustomAssessmentDiagnosisIDDCriteria(AssessmentDiagnosisIDDCriteriaId,
CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RecordDeleted,DeletedBy,DeletedDate,
DocumentVersionId,SubstantialFunctional,IsChecked)
Select AssessmentDiagnosisIDDCriteriaId,
CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RecordDeleted,DeletedBy,DeletedDate,
DocumentVersionId,SubstantialFunctional,IsChecked from CustomAssessmentDiagnosisIDDCriteria
Where DocumentVersionId = @DocumentVersionId  and isnull(RecordDeleted,'N')='N'

Create Table #CustomDocumentFunctionalAssessments(
DocumentVersionId	int,
CreatedBy	varchar(max),
CreatedDate	datetime,
ModifiedBy	varchar(max),
ModifiedDate	datetime,
RecordDeleted	char(1),
DeletedBy	varchar(max),
DeletedDate	datetime,
Dressing	int,
PersonalHygiene	int,
Bathing	int,
Eating	int,
SleepHygiene	int,
SelfCareSkillComments	varchar(max),
SelfCareSkillNeedsList	char(1),
FinancialTransactions	int,
ManagesPersonalFinances	int,
CookingMealPreparation	int,
KeepingRoomTidy	int,
HouseholdTasks	int,
LaundryTasks	int,
HomeSafetyAwareness	int,
DailyLivingSkillComments	varchar(max),
DailyLivingSkillNeedsList	char(1),
ComfortableInteracting	int,
ComfortableLargerGroups	int,
AppropriateConversations	int,
AdvocatesForSelf	int,
CommunicatesDailyLiving	int,
SocialComments	varchar(max),
SocialSkillNeedsList	char(1),
MaintainsFamily	int,
MaintainsFriendships	int,
DemonstratesEmpathy	int,
ManageEmotions	int,
EmotionalComments	varchar(max),
EmotionalNeedsList	char(1),
RiskHarmToSelf	int,
RiskSelfComments	varchar(max),
RiskHarmToOthers	int,
RiskOtherComments	varchar(max),
PropertyDestruction	int,
PropertyDestructionComments	varchar(max),
Elopement	int,
ElopementComments	varchar(max),
MentalIllnessSymptoms	int,
MentalIllnessSymptomComments	varchar(max),
RepetitiveBehaviors	int,
RepetitiveBehaviorComments	varchar(max),
SocialEmotionalBehavioralOther	varchar(max),
SocialEmotionalBehavioralNeedList	char(1),
CommunicationComments	varchar(max),
CommunicationNeedList	char(1),
RentArrangements	int,
PayRentBillsOnTime	int,
PersonalItems	int,
AttendSocialOutings	int,
CommunityTransportation	int,
DangerousSituations	int,
AdvocateForSelf	int,
ManageChangesDailySchedule	int,
CommunityLivingSkillComments	varchar(max),
PreferredActivities	varchar(max),
CommunityLivingSkillNeedList	char(1))

Insert into #CustomDocumentFunctionalAssessments(DocumentVersionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RecordDeleted,
DeletedBy,DeletedDate,Dressing,PersonalHygiene,Bathing,Eating,SleepHygiene,SelfCareSkillComments,SelfCareSkillNeedsList,
FinancialTransactions,ManagesPersonalFinances,CookingMealPreparation,KeepingRoomTidy,HouseholdTasks,LaundryTasks,HomeSafetyAwareness,
DailyLivingSkillComments,DailyLivingSkillNeedsList,ComfortableInteracting,ComfortableLargerGroups,AppropriateConversations,
AdvocatesForSelf,CommunicatesDailyLiving,SocialComments,SocialSkillNeedsList,MaintainsFamily,MaintainsFriendships,DemonstratesEmpathy,
ManageEmotions,EmotionalComments,EmotionalNeedsList,RiskHarmToSelf,RiskSelfComments,RiskHarmToOthers,RiskOtherComments,PropertyDestruction,
PropertyDestructionComments,Elopement,ElopementComments,MentalIllnessSymptoms,MentalIllnessSymptomComments,RepetitiveBehaviors,
RepetitiveBehaviorComments,SocialEmotionalBehavioralOther,SocialEmotionalBehavioralNeedList,CommunicationComments,
CommunicationNeedList,RentArrangements,PayRentBillsOnTime,PersonalItems,AttendSocialOutings,CommunityTransportation,DangerousSituations,
AdvocateForSelf,ManageChangesDailySchedule,CommunityLivingSkillComments,PreferredActivities,CommunityLivingSkillNeedList)
Select DocumentVersionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RecordDeleted,
DeletedBy,DeletedDate,Dressing,PersonalHygiene,Bathing,Eating,SleepHygiene,SelfCareSkillComments,SelfCareSkillNeedsList,
FinancialTransactions,ManagesPersonalFinances,CookingMealPreparation,KeepingRoomTidy,HouseholdTasks,LaundryTasks,HomeSafetyAwareness,
DailyLivingSkillComments,DailyLivingSkillNeedsList,ComfortableInteracting,ComfortableLargerGroups,AppropriateConversations,
AdvocatesForSelf,CommunicatesDailyLiving,SocialComments,SocialSkillNeedsList,MaintainsFamily,MaintainsFriendships,DemonstratesEmpathy,
ManageEmotions,EmotionalComments,EmotionalNeedsList,RiskHarmToSelf,RiskSelfComments,RiskHarmToOthers,RiskOtherComments,PropertyDestruction,
PropertyDestructionComments,Elopement,ElopementComments,MentalIllnessSymptoms,MentalIllnessSymptomComments,RepetitiveBehaviors,
RepetitiveBehaviorComments,SocialEmotionalBehavioralOther,SocialEmotionalBehavioralNeedList,CommunicationComments,
CommunicationNeedList,RentArrangements,PayRentBillsOnTime,PersonalItems,AttendSocialOutings,CommunityTransportation,DangerousSituations,
AdvocateForSelf,ManageChangesDailySchedule,CommunityLivingSkillComments,PreferredActivities,CommunityLivingSkillNeedList
From CustomDocumentFunctionalAssessments 
Where DocumentVersionId = @DocumentVersionId  and isnull(RecordDeleted,'N')='N'

Create Table #CustomAssessmentFunctionalCommunications(
AssessmentFunctionalCommunicationId	int,
CreatedBy	varchar(max),
CreatedDate	datetime,
ModifiedBy	varchar(max),
ModifiedDate	datetime,
RecordDeleted	char(1),
DeletedBy	varchar(max),
DeletedDate	datetime,
DocumentVersionId	int,
Communication	int,
IsChecked	char(1))

Insert into #CustomAssessmentFunctionalCommunications(AssessmentFunctionalCommunicationId,
CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RecordDeleted,DeletedBy,DeletedDate,DocumentVersionId,Communication,IsChecked)
Select AssessmentFunctionalCommunicationId,
CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RecordDeleted,DeletedBy,DeletedDate,DocumentVersionId,Communication,IsChecked 
from CustomAssessmentFunctionalCommunications
Where DocumentVersionId = @DocumentVersionId  and isnull(RecordDeleted,'N')='N'      
    
-- DECLARE VARIABLES      
--      
DECLARE @AdultOrChild CHAR(1)    
DECLARE @Diagnosis CHAR(2)    
DECLARE @AssessmentType CHAR(1)    
DECLARE @CafasRater CHAR(1)    
DECLARE @ClientId INT    
 ,@EffectiveDate DATETIME    
DECLARE @Age DECIMAL(10, 2)    
DECLARE @AuthorId INT    
DECLARE @Variables VARCHAR(max)    
DECLARE @DocumentType VARCHAR(20)    
DECLARE @RunSUAssessmentValidations CHAR(1)    
DECLARE @AxisIIIBug CHAR(1) 
Declare @ClientSU CHAR(1)  
DECLARE @ClientSex CHAR(1)
    
--Determine if SU Assessment validation are required      

set @ClientSU = (    
  SELECT ClientInSAPopulation    
  FROM #CustomDocumentMHAssessments   
  ) 
    
SET @AdultOrChild = (    
  SELECT AdultOrChild    
  FROM #CustomDocumentMHAssessments    
  ) 
 IF @AdultOrChild='A'
 BEGIN
			 IF EXISTS (    
			  SELECT DocumentVersionId    
			  FROM #CustomDocumentMHAssessments    
			  WHERE (    
				CASE     
				 WHEN isnull(UncopeQuestionU, 'X') = 'Y'    
				  THEN 1    
				 ELSE 0    
				 END + CASE     
				 WHEN isnull(UncopeQuestionN, 'X') = 'Y'    
				  THEN 1    
				 ELSE 0    
				 END + CASE     
				 WHEN isnull(UncopeQuestionC, 'X') = 'Y'    
				  THEN 1    
				 ELSE 0    
				 END + CASE     
				 WHEN isnull(UncopeQuestionO, 'X') = 'Y'    
				  THEN 1    
				 ELSE 0    
				 END + CASE     
				 WHEN isnull(UncopeQuestionP, 'X') = 'Y'    
				  THEN 1    
				 ELSE 0    
				 END + CASE     
				 WHEN isnull(UncopeQuestionE, 'X') = 'Y'    
				  THEN 1    
				 ELSE 0    
				 END > 2    
				)  
				OR isnull(ClientInSAPopulation, 'N') = 'Y'
			  )    
			BEGIN   
		
			 SET @RunSUAssessmentValidations = 'Y'    
			END       
	END
 ELSE
	 BEGIN
	  IF EXISTS (SELECT DocumentVersionId    
	  FROM #CustomDocumentCraffts    
	  WHERE (    
		CASE     
		 WHEN isnull(CrafftQuestionC, 'X') = 'Y'    
		  THEN 1    
		 ELSE 0    
		 END + CASE     
		 WHEN isnull(CrafftQuestionR, 'X') = 'Y'    
		  THEN 1    
		 ELSE 0    
		 END + CASE     
		 WHEN isnull(CrafftQuestionA, 'X') = 'Y'    
		  THEN 1    
		 ELSE 0    
		 END + CASE     
		 WHEN isnull(CrafftQuestionF, 'X') = 'Y'    
		  THEN 1    
		 ELSE 0    
		 END + CASE     
		 WHEN isnull(CrafftQuestionFR, 'X') = 'Y'    
		  THEN 1    
		 ELSE 0    
		 END + CASE     
		 WHEN isnull(CrafftQuestionT, 'X') = 'Y'    
		  THEN 1    
		 ELSE 0    
		 END > 2    
		)
		OR isnull(@ClientSU, 'N') = 'Y'
		)
	BEGIN    
	 SET @RunSUAssessmentValidations = 'Y'    
	END     
 END
 
SET @Diagnosis = (    
  SELECT CASE     
    WHEN isnull(ClientInDDPopulation, 'N') = 'Y'    
     THEN 'DD'    
    ELSE 'MH'    
    END    
  FROM #CustomDocumentMHAssessments    
  )    
SET @AssessmentType = (    
  SELECT AssessmentType    
  FROM #CustomDocumentMHAssessments    
  )    
    
IF EXISTS (    
  SELECT a.DocumentVersionId    
  FROM #CustomDocumentMHAssessments a    
  JOIN Documents d ON d.CurrentDocumentVersionId = a.DocumentVersionId    
  JOIN CustomCafasRaters cr ON cr.StaffId = d.AuthorId    
  WHERE d.CurrentDocumentVersionId = @DocumentVersionId    
   AND isnull(cr.Active, 'N') = 'Y'    
  )    
BEGIN    
 SET @CafasRater = 'Y'    
END    
    
SELECT @ClientId = clientId    
 ,@AuthorId = AuthorId    
 ,@EffectiveDate = EffectiveDate    
FROM documents    
WHERE CurrentdocumentVersionId = @DocumentVersionId    
    
SELECT @Age = dbo.GetAge(isnull(a.ClientDOB, '1/1/1900'), @EffectiveDate)    
FROM #CustomDocumentMHAssessments a    
 
 SELECT @ClientSex =   ( SELECT Sex from Clients where clientid=@ClientId)
--      
--TEMP Axis III Fix      
--      
IF EXISTS (    
  SELECT d.DocumentId    
  FROM documents d    
  JOIN clients c ON c.ClientId = d.CLientId    
  WHERE documentcodeid IN (    
    349    
    ,10018    
    )    
   AND STATUS IN (21)    
   AND EXISTS (    
    SELECT di.DocumentVersionId    
    FROM diagnosesIandII di    
    WHERE di.documentversionid = d.currentdocumentversionid    
     AND isnull(di.recorddeleted, 'N') = 'N'    
    )    
   AND NOT EXISTS (    
    SELECT di.DocumentVersionId    
    FROM diagnosesIII di    
    WHERE di.documentversionid = d.currentdocumentversionid    
     AND isnull(di.recorddeleted, 'N') = 'N'    
    )    
   AND isnull(d.recorddeleted, 'n') = 'N'    
   AND d.currentdocumentversionId = @DocumentVersionId    
  )    
BEGIN    
 BEGIN TRAN    
    
 INSERT INTO diagnosesIII (DocumentVersionId)    
 VALUES (@DocumentVersionId)    
    
 INSERT INTO diagnosesIV (DocumentVersionId)    
 VALUES (@DocumentVersionId)    
    
 INSERT INTO diagnosesV (DocumentVersionId)    
 VALUES (@DocumentVersionId)    
    
 COMMIT TRAN    
    
 --Update GAF Score on MI ADULT      
 DECLARE @Gafscore INT    
    
 IF @AdultOrChild = 'A'    
  AND @Diagnosis = 'MH'    
 BEGIN    
  EXEC scsp_HRMCalculateGAFScoreFromDLA @DocumentVersionId    
   ,@GAFScore OUTPUT    
    
  IF @@error = 0    
  BEGIN    
   UPDATE DiagnosesV    
   SET AxisV = @GAFScore    
   WHERE DocumentVersionId = @DocumentVersionId    
  END    
 END    
    
 -- Track the issue      
 INSERT INTO CustomBugTrackingHRMAssessmentAxisVIssue (    
  DocumentVersionId    
  ,CreatedDate    
  )    
 VALUES (    
  @DocumentVersionId    
  ,getdate()    
  )    
    
 SET @AxisIIIBug = 'Y'    
END    
    
--      
-- Intake Consult Document Type to restrict validations      
--      
DECLARE @Consult CHAR(1)    
    
SET @Consult = 'N'    
    
SELECT @Consult = CASE     
  WHEN isnull(ClientIsAppropriateForTreatment, 'Y') = 'N'    
   THEN 'Y'    
  ELSE @Consult    
  END    
FROM #CustomDocumentMHAssessments    
    
   
DECLARE @SevereProfoundDisability CHAR(1)    
    
SET @SevereProfoundDisability = (    
  SELECT SevereProfoundDisability    
  FROM #CustomDocumentMHAssessments    
  )    
--      
-- DECLARE TABLE SELECT VARIABLES      
--      
SET @Variables = 'Declare @DocumentVersionId int,@AssessmentType char(1),@DocumentId int      
     ,@CafasRater char(1),@ClientId int, @EffectiveDate datetime,@Age decimal(10,2),@ClientSex char(1),@AuthorId int      
     ,@RunSUAssessmentValidations char(1), @AxisIIIBug char(1), @SevereProfoundDisability char(1)      
     Set @DocumentVersionId = ' + convert(VARCHAR(20), @DocumentVersionId) + ' ' + 'Set @DocumentId = ' + convert(VARCHAR(20), @DocumentId) + ' ' + 'Set @AssessmentType = ''' + isnull(@AssessmentType, '') + ''' ' + 'Set @CafasRater = ''' + isnull(@CafasRater, '') + ''' ' + 'Set @ClientId = ''' + isnull(convert(VARCHAR(20), @ClientId), '') + ''' ' + 'Set @EffectiveDate = ''' + convert(VARCHAR(10), @EffectiveDate, 101) + ''' ' + 'Set @Age = ''' + isnull(convert(VARCHAR(10), @Age), '') + ''''+'Set @ClientSex ='''+ isnull(@ClientSex, '') + ''' ' + 'Set @AuthorId = ''' + isnull(convert(VARCHAR(20), @AuthorId), '') + ''' ' + 'Set @RunSUAssessmentValidations = ''' + isnull(@RunSUAssessmentValidations, 'N') + ''' ' + 'Set @AxisIIIBug = ''' + isnull(@AxisIIIBug, 'N') + ''' ' + 'Set @SevereProfoundDisability = ''' 
  
+ isnull(    
  @SevereProfoundDisability, 'N') + ''' '    
    
IF isnull(@Consult, 'N') = 'Y'    
BEGIN    
 SET @DocumentType = 'Cx' + CASE     
   WHEN @Diagnosis = 'MH'    
    THEN 'MHSA'    
   ELSE @Diagnosis    
   END --Groups MH & SA      
  + CASE     
   WHEN @Diagnosis = 'DD'    
    THEN ''    
   ELSE @AdultOrChild    
   END --Excludes Age if      
  + CASE     
   WHEN @AssessmentType = 'A'    
    THEN 'A'    
   ELSE ''    
   END --Add Annual specifier for pencil icon validations      
END    
ELSE    
 IF isnull(@Consult, 'N') = 'N'    
 BEGIN    
  SET @DocumentType = CASE     
    WHEN @Diagnosis = 'MH'    
     THEN 'MHSA'    
    ELSE @Diagnosis    
    END --Groups MH & SA      
   + CASE     
    WHEN @Diagnosis = 'DD'    
     THEN ''    
    ELSE @AdultOrChild    
    END --Excludes Age if        
   + CASE     
    WHEN @AssessmentType = 'A'    
     THEN 'A'    
    ELSE ''    
    END --Add Annual specifier for pencil icon validations      
 END    
 ELSE    
 BEGIN    
  SET @DocumentType = CASE     
    WHEN @Diagnosis = 'MH'    
     THEN 'MHSA'    
    ELSE @Diagnosis    
    END --Groups MH & SA      
   + CASE     
    WHEN @Diagnosis = 'DD'    
     THEN ''    
    ELSE @AdultOrChild    
    END --Excludes Age if       
   + CASE     
    WHEN @AssessmentType = 'A'    
     THEN 'A'    
    ELSE ''    
    END --Add Annual specifier for pencil icon validations      
 END    
 
-- Msood 8/11/2017
   CREATE TABLE [#validationReturnTable] (        
   TableName varchar(100) null,       
   ColumnName varchar(100) null,       
   ErrorMessage varchar(max) null,
   TabOrder int null,  
   ValidationOrder int null  
   )
 
EXEC csp_validateDocumentsTableSelect @DocumentVersionId    
 ,@DocumentCodeId    
 ,@DocumentType    
 ,@Variables 
  
  select TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder  from #validationReturnTable order by taborder,ValidationOrder
  
IF @@error <> 0    
 GOTO error    
    
    
RETURN    
    
error:    
    
RAISERROR ('csp_validateCustomMHAssessment failed.  Please contact your system administrator. We apologize for the inconvenience.',16,1)
GO


