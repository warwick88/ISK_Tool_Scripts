 
 
/****** Object:  StoredProcedure [dbo].[csp_InitCustomMHAssessmentDefaultIntialization]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomMHAssessmentDefaultIntialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomMHAssessmentDefaultIntialization]
GO


/****** Object:  StoredProcedure [dbo].[csp_InitCustomMHAssessmentDefaultIntialization]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [dbo].[csp_InitCustomMHAssessmentDefaultIntialization]    
    (    
      @ClientID INT ,    
      @AxisIAxisIIOut VARCHAR(100) ,    
      @clientAge VARCHAR(100)      
 --,@DocumentVersionId int                                                                
      ,    
      @AssessmentType CHAR(1) ,    
      @InitialRequestDate DATETIME ,    
      @LatestDocumentVersionID INT ,    
      @ClientDOB VARCHAR(50) ,    
      @CurrentAuthorId INT      
     
    )    
AS /*********************************************************************/        
/* 18/Jun/2020      Josekutty Varghese      What : Added intialization for newly added tabs such as Diagnosis-IDD Eligibility and Functional Assessment
                                            Why  : Initialization needs to happened for newly added tables
											Portal Task: #12 in KCMHSAS Improvement  */
/*********************************************************************/      
--- CustomHRMAssessments --                                                                                                                                         
    BEGIN      
        BEGIN TRY      
          DECLARE @ClientHasGuardian CHAR(1) = NULL    
          DECLARE @GuardianFirstName VARCHAR(150) = NULL   
    DECLARE @GuardianLastName VARCHAR(150) = NULL   
          DECLARE @GuardianAddress VARCHAR(100) = NULL    
    DECLARE @GuardianCity VARCHAR(100)  
    DECLARE @GuardianState VARCHAR(100)  
    DECLARE @GuardianZipCode VARCHAR(100)  
   -- DECLARE @GuardianRelationship VARCHAR(100)  
   DECLARE @GuardianRelationship INT  
            DECLARE @ClientContactId INT = NULL    
            IF EXISTS ( SELECT  *    
                        FROM    ClientContacts    
                        WHERE   ClientId = @ClientID    
                                AND ISNULL(Guardian, 'N') = 'Y'    
                                AND ISNULL(Active, 'N') = 'Y' )    
                BEGIN    
                    SET @ClientHasGuardian = 'Y'     
                    SELECT TOP 1    
                            @ClientContactId = ClientContactId    
                    FROM    ClientContacts    
                    WHERE   ClientId = @ClientID    
                            AND ISNULL(Guardian, 'N') = 'Y'    
                            AND ISNULL(Active, 'N') = 'Y'    
                            AND ISNULL(RecordDeleted, 'N') = 'N'    
                    ORDER BY ModifiedDate DESC    
                    IF @ClientContactId IS NOT NULL    
                        BEGIN    
                           SELECT TOP 1  @GuardianFirstName = FirstName FROM ClientContacts  WHERE  ClientContactId = @ClientContactId    
                           SELECT TOP 1  @GuardianLastName = LastName FROM ClientContacts  WHERE  ClientContactId = @ClientContactId    
                           SELECT TOP 1  @GuardianAddress = [Address]  FROM  ClientContactAddresses  WHERE  ClientContactId = @ClientContactId AND AddressType=90  
						   SELECT TOP 1  @GuardianCity = City  FROM  ClientContactAddresses  WHERE  ClientContactId = @ClientContactId  AND AddressType=90 
						   SELECT TOP 1  @GuardianState = [State]  FROM  ClientContactAddresses  WHERE  ClientContactId = @ClientContactId   AND AddressType=90
						   SELECT TOP 1  @GuardianZipCode = [Zip]  FROM  ClientContactAddresses  WHERE  ClientContactId = @ClientContactId   AND AddressType=90
                           SELECT TOP 1 @GuardianRelationship = Relationship FROM ClientContacts WHERE ClientContactId = @ClientContactId    
                        END    
                END    
                     
            DECLARE @ClientAgeNum VARCHAR(50)      
      
            SET @ClientAgeNum = SUBSTRING(@clientAge, 1, CHARINDEX(' ', @clientAge))      
      
            DECLARE @CafasURL VARCHAR(1024)      
      
            SET @CafasURL = ( SELECT    CafasURL    
                              FROM      CustomConfigurations    
                            )      
      
            DECLARE @DispostionComment AS VARCHAR(MAX)      
            DECLARE @PresentingProblem AS VARCHAR(MAX)      
            DECLARE @AccomationNeeded AS VARCHAR(10)      
            DECLARE @AccomationNeededInquiryValues VARCHAR(200)      
            DECLARE @LatestScreeenTypeDocumentVersionId AS INT      
            DECLARE @ReferralSubType AS INT      
            DECLARE @Living AS INT      
            DECLARE @EmploymentStatus AS INT      
            DECLARE @HASGUARDIAN AS VARCHAR(10)    
            DECLARE @GUARDIANAME AS VARCHAR(100)    
            DECLARE @GUARDIANNADDRESS AS VARCHAR(MAX)    
            DECLARE @REFERRALSOURCE INT    
            DECLARE @CONTACTID INT    
            DECLARE @CLIENTPHONE VARCHAR(500)    
            DECLARE @CurrentLiving INT    
            DECLARE @EmpStatus INT    
            DECLARE @ExternalReferralProviderId INT     
            DECLARE @INQUIRYDATE DATETIME    
            DECLARE @REGISTRATIONDATE DATETIME    
            DECLARE @PrimaryPhysician VARCHAR(500) 
			DECLARE @LegalIssues  VARCHAR(500)
            DECLARE @MHAssessmentDocumentcodeId VARCHAR(MAX)  
			Declare @ClientInDDPopulationDocumentVersionId as int  
            DECLARE @CODE VARCHAR(MAX)  
            SET @CODE='69E559DD-1A4D-46D3-B91C-E89DA48E0038'  
            SET @MHAssessmentDocumentcodeId=(Select DocumentCodeId from DocumentCodes where Code=@CODE)  
     
            SELECT  @CurrentLiving = livingArrangement ,    
                    @EmpStatus = EmploymentStatus ,    
                    @ExternalReferralProviderId = ExternalReferralProviderId    
            FROM    Clients    
            WHERE   ClientId = @ClientID    
    
            SELECT  @PrimaryPhysician = Name 
            FROM    ExternalReferralProviders  
            WHERE   ExternalReferralProviderId = @ExternalReferralProviderId     
    
   
            --SELECT Top 1  @PrimaryPhysician = ISNULL(a.LastName, '') + CASE WHEN a.LastName IS NOT NULL THEN ', '    
            --                                                          ELSE ''    
            --                                                  END + ISNULL(a.FirstName, '')    
            --FROM    dbo.ClientContacts a    
            --WHERE   a.ClientId = @ClientId    
            --        AND ISNULL(a.RecordDeleted, 'N') = 'N'    
            --        AND a.Active = 'Y'    
            --        AND a.Relationship IN ( SELECT TOP 1    
            --                                        GlobalCodeId    
            --                                FROM    dbo.GlobalCodes    
            --                                WHERE   Category = 'RELATIONSHIP'    
            --                                        AND Active = 'Y'    
            --                                        AND Code = 'PrimaryPhysician' --Modified 7/16    
            --                                        AND ISNULL(RecordDeleted, 'N') = 'N' ) order by ClientContactId desc    
    
            SELECT TOP 1    
                    @GUARDIANAME = ISNULL(CC.LastName, '') + CASE WHEN LastName IS NOT NULL THEN ', '    
                                                                  ELSE ''    
                                                             END + ISNULL(CC.FirstName, '') ,    
                    @HASGUARDIAN = CC.Guardian ,    
                    @GUARDIANNADDRESS = CCA.Display , 
                    @CONTACTID = CC.ClientContactId    
            FROM    clientcontacts CC    
                    JOIN ClientContactAddresses CCA ON CC.ClientContactId = CCA.ClientContactId    
            WHERE   CC.ClientId = @ClientID    
                    AND ISNULL(CC.Guardian, 'N') = 'Y'    
            ORDER BY CC.modifieddate DESC    
            IF ( @CONTACTID IS NOT NULL )    
                BEGIN    
                    SET @CLIENTPHONE = ( SELECT TOP ( 1 )    
                                                PhoneNumber    
                                         FROM   ClientContactPhones    
                                         WHERE  ( ClientContactId = @CONTACTID )    
                                                AND ( PhoneNumber IS NOT NULL )  
                                                AND (PhoneNumber <> '')  
                                                AND(PhoneType in (SELECT GlobalCodeId from GlobalCodes where Category='PHONETYPE' AND CodeName in ('Home','Home 2','Mobile','Mobile 2')))
                                                AND ( ISNULL(RecordDeleted, 'N') = 'N' )    
                                         ORDER BY PhoneType    
                                       )    
                  
                END    
                  
            --SELECT TOP 1    
      --        @REFERRALSOURCE = CR.ReferralType ,    
            --        @REGISTRATIONDATE = d.EffectiveDate    
            --FROM    CustomDocumentRegistrations CR    
            --        INNER JOIN Documents d ON CR.DocumentVersionId = d.CurrentDocumentVersionId    
            --                                  AND d.ClientId = @ClientID    
            --                                  AND ISNULL(d.RecordDeleted, 'N') = 'N'    
            --                                  AND ISNULL(CR.RecordDeleted, 'N') = 'N'    
            --                                  AND d.[Status] = 22    
            --                                  AND d.DocumentCodeId = 10500    
            --ORDER BY d.CurrentDocumentVersionId DESC  
			
			 SELECT Top 1 @REFERRALSOURCE = ReferralType    
            FROM    ClientEpisodes CE    
                    INNER JOIN GlobalCodes GC ON GC.GlobalCodeId = CE.[Status]    
            WHERE   ClientId = @ClientID    
                    AND ISNULL(CE.RecordDeleted, 'N') = 'N'    
                    AND CE.DischargeDate IS NULL    
                    AND GC.GlobalCodeId IN ( select GlobalCodeId from  Globalcodes where Category= 'EPISODESTATUS'  and
					 codename in ('Registered','In Treatment' ) )        
         
            IF @REGISTRATIONDATE IS NOT NULL    
                BEGIN    
                    SELECT TOP 1    
                            @INQUIRYDATE = InquiryStartDateTime    
                    FROM    CustomInquiries    
                    WHERE   CAST(Createddate AS DATE) <= CAST(@REGISTRATIONDATE AS DATE)    
                            AND ClientId = @ClientID    
                    ORDER BY Createddate DESC    
                END    
     
            
            IF ( @AssessmentType = 'I'    
                 OR @AssessmentType = 'S'    
               )    
                BEGIN      
                    SELECT TOP 1    
                            @DispostionComment = CI.DispositionComment ,    
                            @PresentingProblem = CI.PresentingProblem ,    
                            @AccomationNeeded = CI.AccomodationNeeded ,    
                            @ReferralSubType = ReferralSubtype ,    
                            @Living = Living ,    
                            @EmploymentStatus = EmploymentStatus    
                    FROM    CustomInquiries CI    
                            LEFT JOIN GlobalCodes gc ON CI.InquiryStatus = gc.GlobalCodeId    
                    WHERE   CI.ClientId = @ClientID    
                            AND ISNULL(CI.RecordDeleted, 'N') = 'N'    
                            --AND gc.Category = 'XINQUIRYSTATUS'    
                          --  AND gc.CodeName = 'COMPLETE'    
                    ORDER BY InquiryId DESC --Get DispositionComment For Last Completed Inquiry                   
      
                    IF ( @AccomationNeeded IS NOT NULL )    
                        BEGIN      
                            SELECT  @AccomationNeededInquiryValues = COALESCE(@AccomationNeededInquiryValues + ', ', '') + CASE WHEN item = 0 THEN 'Interpreter'    
                                                                                                                                WHEN item = 1 THEN 'Reading Assistance'    
                                                                                                                                WHEN item = 2 THEN 'Sign Language'    
                                                                                                                END    
                            FROM    dbo.fnSplit(@AccomationNeeded, ',') -- Need to hardocode values as in database only 0,1,2 values saves for this & there is no globalcodeId for this                  
      
                            SET @AccomationNeededInquiryValues = 'Accommodation Needed-' + @AccomationNeededInquiryValues      
                        END      
      
   --End                   
   -- Get Registration date for Current Episode with Status Registrer or In treatment                  
   --if (@AssessmentType = 'I' or @AssessmentType = 'S')                  
   --begin              
                    DECLARE @EpsiodeRegistrationDate AS DATETIME      
                    DECLARE @SameEpisode CHAR(1)    
                    DECLARE @PrevEffectiveDate AS DATETIME    
                    SELECT  @EpsiodeRegistrationDate = CE.RegistrationDate    
                    FROM    ClientEpisodes CE    
                            INNER JOIN GlobalCodes GC ON GC.GlobalCodeId = CE.[Status]    
                    WHERE   ClientId = @ClientID    
                            AND ISNULL(CE.RecordDeleted, 'N') = 'N'    
                            AND CE.DischargeDate IS NULL    
                            AND GC.GlobalCodeId IN ( 100, 101 )      
   -- Select the latest document version Id for previous signeed Screen type assessment before Client Episiode registration                  
      
                    SELECT TOP 1    
                            @LatestScreeenTypeDocumentVersionId = d.CurrentDocumentVersionId ,    
                            @PrevEffectiveDate = d.EffectiveDate 
							--,@LegalIssues = LegalIssues 
                    FROM    CustomDocumentMHAssessments CHA    
                            INNER JOIN Documents d ON CHA.DocumentVersionId = d.CurrentDocumentVersionId    
                                                      AND d.ClientId = @ClientID    
                                                      AND ISNULL(d.RecordDeleted, 'N') = 'N'    
                                                      AND ISNULL(CHA.RecordDeleted, 'N') = 'N' 
                                                      AND d.[Status] = 22    
                                                      AND d.DocumentCodeId = @MHAssessmentDocumentcodeId     
                    ORDER BY d.CurrentDocumentVersionId DESC    

					   SELECT TOP 1 
							@LegalIssues = LegalIssues 
                    FROM    CustomDocumentMHAssessments CHA    
                            INNER JOIN Documents d ON CHA.DocumentVersionId = d.CurrentDocumentVersionId    
                                                      AND d.ClientId = @ClientID    
                                                      AND ISNULL(d.RecordDeleted, 'N') = 'N'    
                                                      AND ISNULL(CHA.RecordDeleted, 'N') = 'N' 
                                                      AND d.DocumentCodeId = @MHAssessmentDocumentcodeId     
                    ORDER BY d.CurrentDocumentVersionId DESC 
    
                END      
            IF ( @EpsiodeRegistrationDate IS NOT NULL    
                 AND @EpsiodeRegistrationDate <= @PrevEffectiveDate    
               )    
                SET @SameEpisode = 'Y'    
    
           
			  Select TOP 1 @ClientInDDPopulationDocumentVersionId = d.CurrentDocumentVersionId from CustomDocumentMHAssessments CHA 
			  join Documents d  on  CHA.DocumentVersionId = d.CurrentDocumentVersionId  
			  Where d.ClientId = @ClientID and Isnull(d.RecordDeleted,'N') = 'N' and Isnull(CHA.RecordDeleted,'N') = 'N'    
			  and d.DocumentCodeId = @MHAssessmentDocumentcodeId And  IsNull(ClientInDDPopulation,'N') = 'Y' and d.[Status] = 22
			  ORDER BY d.CurrentDocumentVersionId DESC 

            DECLARE @ExistLatestSignedDocumentVersion CHAR      
      
            IF ( @LatestDocumentVersionID > 0 )    
                SET @ExistLatestSignedDocumentVersion = 'Y'      
            ELSE    
                SET @ExistLatestSignedDocumentVersion = 'N'      
  
  
  
            SELECT  'CustomDocumentMHAssessments' AS TableName ,    
                    -1 AS 'DocumentVersionId' ,   
                     '' AS [CreatedBy] ,    
                    GETDATE() AS [CreatedDate] ,    
                    '' AS [ModifiedBy] ,    
                    GETDATE() AS [ModifiedDate] ,    
                    CHA.[RecordDeleted] ,    
                    CHA.[DeletedDate] ,    
                    CHA.[DeletedBy] ,     
                    [ClientName] ,    
                    @AssessmentType AS [AssessmentType] ,  
                    [PreviousAssessmentDate] ,    
                    @ClientDOB AS [ClientDOB] ,    
                    CASE WHEN @ClientAgeNum >= 18 THEN 'A'    
                         ELSE 'C'    
                    END AS [AdultOrChild] ,    
                    [ChildHasNoParentalConsent] ,    
                    @ClientHasGuardian AS ClientHasGuardian ,    
                    @GuardianFirstName AS GuardianFirstName ,   
                   @GuardianLastName AS GuardianLastName ,    
                    @GuardianAddress AS GuardianAddress ,    
                    CASE WHEN @CLIENTPHONE IS NOT NULL THEN @CLIENTPHONE    
                         ELSE NULL    
                    END AS [GuardianPhone]   
					,CASE WHEN @GuardianCity  IS NOT NULL THEN @GuardianCity     
                         ELSE NULL    
                    END AS [GuardianCity]  
					
					 ,CASE WHEN @GuardianState  IS NOT NULL THEN @GuardianState     
                         ELSE NULL    
                    END AS [GuardianState]   
                  --,GC1.CodeName as GuardianStateText
					,CASE WHEN @GuardianZipCode  IS NOT NULL THEN @GuardianZipCode     
                         ELSE NULL    
                    END AS [GuardianZipcode]
                  -- dbo.ssf_GetGlobalCodeNameById(@GuardianRelationship) AS RelationWithGuardian,    
                   ,@GuardianRelationship AS RelationWithGuardian,  
                  GC.CodeName as GuardianTypeText,
                    [ClientInDDPopulation] ,    
                    [ClientInSAPopulation] ,    
                    [ClientInMHPopulation] ,    
                    [PreviousDiagnosisText] ,    
                    CASE WHEN @REFERRALSOURCE IS NOT NULL THEN @REFERRALSOURCE    
                         ELSE NULL    
                    END AS [ReferralType] ,    
                    CASE WHEN @PresentingProblem IS NOT NULL THEN @PresentingProblem    
                         ELSE NULL    
                    END AS [PresentingProblem] ,    
                    CASE WHEN @CurrentLiving IS NOT NULL THEN @CurrentLiving    
                         ELSE NULL    
                    END AS [CurrentLivingArrangement] ,    
                    CASE WHEN @PrimaryPhysician IS NOT NULL THEN @PrimaryPhysician    
                         ELSE NULL    
                    END AS [CurrentPrimaryCarePhysician] ,   
					@LegalIssues AS  LegalIssues, 
                    [ReasonForUpdate] ,    
                    'N' AS DxTabDisabled ,    
                     DesiredOutcomes,    
                    [PsMedicationsComment] ,    
                    AutisticallyImpaired ,    
                    CognitivelyImpaired ,    
                    EmotionallyImpaired ,    
                    BehavioralConcern ,    
                    LearningDisabilities ,    
                    PhysicalImpaired ,    
                    IEP ,    
                    ChallengesBarrier ,    
                    UnProtectedSexualRelationMoreThenOnePartner ,    
                    SexualRelationWithHIVInfected ,    
                    SexualRelationWithDrugInject ,    
                    InjectsDrugsSharedNeedle ,    
                    ReceivedAnyFavorsForSexualRelation ,    
                    FamilyFriendFeelingsCausedDistress ,    
                    FeltNervousAnxious ,    
                    NotAbleToStopWorrying ,    
                    StressPeoblemForHandlingThing ,    
                    SocialAndEmotionalNeed ,    
                    ReceivePrenatalCare ,    
                    ProblemInPregnancy ,    
                    SexualityComment ,    
                    PrenatalExposer ,    
                    WhereMedicationUsed ,    
                    IssueWithDelivery ,    
                    ChildDevelopmentalMilestones ,    
                     ParentChildRelationshipIssue ,    
                    [PsEducationComment] ,    
                    [IncludeFunctionalAssessment] ,    
                    [IncludeSymptomChecklist] ,    
                    [IncludeUNCOPE] ,    
                    [ClientIsAppropriateForTreatment] ,    
                    [SecondOpinionNoticeProvided] ,    
                    [TreatmentNarrative] ,    
                    [RapCiDomainIntensity] ,    
                    [RapCbDomainIntensity] ,    
                    [RapCaDomainIntensity] ,    
                    [RapHhcDomainIntensity] ,    
                    [OutsideReferralsGiven] ,    
                    [ReferralsNarrative] ,    
                    [ServiceOther] ,    
                    [ServiceOtherDescription] ,    
                    [AssessmentAddtionalInformation] ,    
                    CASE WHEN @SameEpisode = 'Y' THEN TreatmentAccomodation    
                         ELSE NULL    
                    END AS [TreatmentAccomodation] ,    
                    [Participants] ,    
                    [Facilitator] ,    
                    [TimeLocation] ,    
                    [AssessmentsNeeded] ,    
                    [CommunicationAccomodations] ,    
                    [IssuesToAvoid] ,    
                    [IssuesToDiscuss] ,    
                    [SourceOfPrePlanningInfo] ,    
                    [SelfDeterminationDesired] ,    
                    [FiscalIntermediaryDesired] ,    
                    [PamphletGiven] ,    
                    [PamphletDiscussed] ,    
                    [PrePlanIndependentFacilitatorDiscussed] ,    
                    [PrePlanIndependentFacilitatorDesired] ,    
                    [PrePlanGuardianContacted] ,    
                    [CommunityActivitiesCurrentDesired] ,    
                  [CommunityActivitiesIncreaseDesired] ,    
                    [CommunityActivitiesNeedsList] ,    
                    [PsCurrentHealthIssues] ,    
                    [PsCurrentHealthIssuesComment]  , 
					PsMedicationsListToBeModified,   
                    PsMedicationsSideEffects ,    
                    [HistMentalHealthTx] ,    
                    [HistMentalHealthTxComment] ,    
                    [HistFamilyMentalHealthTx] ,    
                    [HistFamilyMentalHealthTxComment] ,    
                    [PsClientAbuseIssues] ,    
                    [PsClientAbuesIssuesComment] ,    
                    [PsClientAbuseIssuesNeedsList] ,    
                    [PsDevelopmentalMilestones] ,    
                    [PsDevelopmentalMilestonesComment] ,    
                    [PsDevelopmentalMilestonesNeedsList] ,    
                    [PsChildEnvironmentalFactors] ,    
                    [PsChildEnvironmentalFactorsComment] ,    
                    [PsChildEnvironmentalFactorsNeedsList] ,    
                    [PsLanguageFunctioning] ,    
                    [PsLanguageFunctioningComment] ,    
                    [PsLanguageFunctioningNeedsList] ,    
                    [PsVisualFunctioning] ,    
                    [PsVisualFunctioningComment] ,    
                    [PsVisualFunctioningNeedsList] ,    
                    [PsPrenatalExposure] ,    
                    [PsPrenatalExposureComment] ,    
                    [PsPrenatalExposureNeedsList] ,    
                    [PsChildMentalHealthHistory] ,    
                    [PsChildMentalHealthHistoryComment] ,    
                    [PsChildMentalHealthHistoryNeedsList] ,    
                    [PsIntellectualFunctioning] ,    
                    [PsIntellectualFunctioningComment] ,    
                    [PsIntellectualFunctioningNeedsList] ,    
                    [PsLearningAbility] ,    
                    [PsLearningAbilityComment] ,    
                    [PsLearningAbilityNeedsList] ,    
                    [PsPeerInteraction] ,    
                    [PsPeerInteractionComment] ,    
                    [PsPeerInteractionNeedsList] ,    
                    CASE WHEN @SameEpisode = 'Y' THEN PsParentalParticipation    
                         ELSE NULL    
                    END AS [PsParentalParticipation] ,    
                    CASE WHEN @SameEpisode = 'Y' THEN FamilyRelationshipIssues    
                         ELSE NULL    
                    END AS FamilyRelationshipIssues ,    
                    [PsParentalParticipationComment] ,    
                    [PsParentalParticipationNeedsList] ,    
                    [PsSchoolHistory] ,    
                    [PsSchoolHistoryComment] ,    
                    [PsSchoolHistoryNeedsList] ,    
                    [PsImmunizations] ,    
                    [PsImmunizationsComment] ,    
                    [PsImmunizationsNeedsList] ,    
                    CASE WHEN @SameEpisode = 'Y' THEN PsChildHousingIssues    
                         ELSE NULL    
                    END AS [PsChildHousingIssues] ,    
                    [PsChildHousingIssuesComment] ,    
                    [PsChildHousingIssuesNeedsList] ,    
                    [PsSexuality] ,    
                    [PsSexualityComment] ,    
                    [PsSexualityNeedsList] ,    
                    [PsFamilyFunctioning] ,    
                    [PsFamilyFunctioningComment] ,    
                    [PsFamilyFunctioningNeedsList] ,    
                    [PsTraumaticIncident] ,    
                    [PsTraumaticIncidentComment] ,    
                    [PsTraumaticIncidentNeedsList] ,    
                    [HistDevelopmental] ,    
                    [HistDevelopmentalComment] ,    
                    [HistResidential] ,    
                    [HistResidentialComment] ,    
                    [HistOccupational] ,    
                    [HistOccupationalComment] ,    
                    [HistLegalFinancial] ,    
                    [HistLegalFinancialComment] ,    
                  [SignificantEventsPastYear] ,    
                    [PsGrossFineMotor] ,    
                    [PsGrossFineMotorComment] ,    
                    [PsGrossFineMotorNeedsList] ,    
                    [PsSensoryPerceptual] ,    
                    [PsSensoryPerceptualComment] ,    
                    [PsSensoryPerceptualNeedsList] ,    
                    [PsCognitiveFunction] ,    
                    [PsCognitiveFunctionComment] ,    
                    [PsCognitiveFunctionNeedsList] ,    
                    [PsCommunicativeFunction] ,    
                    [PsCommunicativeFunctionComment] ,    
                    [PsCommunicativeFunctionNeedsList] ,    
                    [PsCurrentPsychoSocialFunctiion] ,    
                    [PsCurrentPsychoSocialFunctiionComment] ,    
                    [PsCurrentPsychoSocialFunctiionNeedsList] ,    
                    [PsAdaptiveEquipment] ,    
                    [PsAdaptiveEquipmentComment] ,    
                    [PsAdaptiveEquipmentNeedsList] ,    
                    [PsSafetyMobilityHome] ,    
                    [PsSafetyMobilityHomeComment] ,    
                    [PsSafetyMobilityHomeNeedsList] ,    
                    [PsHealthSafetyChecklistComplete] ,    
                    [PsAccessibilityIssues] ,    
                    [PsAccessibilityIssuesComment] ,    
                    [PsAccessibilityIssuesNeedsList] ,    
                    [PsEvacuationTraining] ,    
                    [PsEvacuationTrainingComment] ,    
                    [PsEvacuationTrainingNeedsList] ,    
                    [Ps24HourSetting] ,    
                    [Ps24HourSettingComment] ,    
                    [Ps24HourSettingNeedsList] ,    
                    [Ps24HourNeedsAwakeSupervision] ,    
                    [PsSpecialEdEligibility] ,    
                    [PsSpecialEdEligibilityComment] ,    
                    [PsSpecialEdEligibilityNeedsList] ,    
                    [PsSpecialEdEnrolled] ,    
                    [PsSpecialEdEnrolledComment] ,    
                    [PsSpecialEdEnrolledNeedsList] ,    
                    [PsEmployer] ,    
                    [PsEmployerComment] ,    
                    [PsEmployerNeedsList] ,    
                    [PsEmploymentIssues] ,    
                    [PsEmploymentIssuesComment] ,    
                    [PsEmploymentIssuesNeedsList] ,    
                    [PsRestrictionsOccupational] ,    
                    [PsRestrictionsOccupationalComment] ,    
                    [PsRestrictionsOccupationalNeedsList] ,    
                    [PsFunctionalAssessmentNeeded] ,    
                    [PsAdvocacyNeeded] ,    
                    [PsPlanDevelopmentNeeded] ,    
                    [PsLinkingNeeded] ,    
                    [PsDDInformationProvidedBy] ,    
                    [HistPreviousDx] ,    
                    [HistPreviousDxComment] ,    
                    [PsLegalIssues] ,    
                    [PsLegalIssuesComment] ,    
                    [PsLegalIssuesNeedsList] ,    
                    [PsCulturalEthnicIssues] ,    
                    [PsCulturalEthnicIssuesComment] ,    
                    [PsCulturalEthnicIssuesNeedsList] ,    
                    [PsSpiritualityIssues] ,    
                    [PsSpiritualityIssuesComment] ,    
                    [PsSpiritualityIssuesNeedsList] ,  
                    [SuicideIdeation] ,    
                    [SuicideActive] ,    
                    [SuicidePassive] ,    
                    [SuicideMeans] ,    
                    [SuicidePlan] ,    
                    [SuicideOtherRiskSelf] ,    
                    [SuicideOtherRiskSelfComment] ,   
                    [HomicideIdeation] ,    
                    [HomicideActive] ,    
                    [HomicidePassive] ,    
                    [HomicidePlan] ,     
                    [HomicdeOtherRiskOthers] ,    
                    [HomicideOtherRiskOthersComment] ,    
                    [PhysicalAgressionNotPresent] ,    
                   [PhysicalAgressionSelf] ,    
                    [PhysicalAgressionOthers] ,    
                    [PhysicalAgressionCurrentIssue] ,    
                    [PhysicalAgressionNeedsList] ,    
                    [PhysicalAgressionBehaviorsPastHistory] ,    
                    [RiskAccessToWeapons] ,    
                    [RiskAppropriateForAdditionalScreening] ,    
                    [RiskClinicalIntervention] ,    
                    [RiskOtherFactors] ,    
                    [StaffAxisV] ,    
                    [StaffAxisVReason] ,    
                    [ClientStrengthsNarrative] ,    
                    [CrisisPlanningClientHasPlan] ,    
                    [CrisisPlanningNarrative] ,    
                    [CrisisPlanningDesired] ,    
                    [CrisisPlanningNeedsList] ,    
                    [CrisisPlanningMoreInfo] ,    
                    [AdvanceDirectiveClientHasDirective] ,    
                    [AdvanceDirectiveDesired] ,    
                    [AdvanceDirectiveNarrative] ,    
                    [AdvanceDirectiveNeedsList] ,    
                    [AdvanceDirectiveMoreInfo] ,    
                    [NaturalSupportSufficiency] ,    
                    [NaturalSupportNeedsList] ,    
                    [NaturalSupportIncreaseDesired] ,    
                    CASE WHEN @SameEpisode = 'Y' THEN ClinicalSummary    
                         ELSE NULL    
                    END AS [ClinicalSummary]  ,    
                    [UncopeQuestionU] ,    
                    [UncopeApplicable] ,    
                    [UncopeApplicableReason] ,    
                    [UncopeQuestionN] ,    
            [UncopeQuestionC] ,    
                    [UncopeQuestionO] ,    
                    [UncopeQuestionP] ,    
                    [UncopeQuestionE] ,    
                    [SubstanceUseNeedsList] ,    
                    [DecreaseSymptomsNeedsList] ,    
                    [DDEPreviouslyMet] ,    
                    [DDAttributableMentalPhysicalLimitation] ,    
                    [DDDxAxisI] ,    
                    [DDDxAxisII] ,    
                    [DDDxAxisIII] ,    
                    [DDDxAxisIV] ,    
                    [DDDxAxisV] ,    
                    [DDDxSource] ,    
                    [DDManifestBeforeAge22] ,    
                    [DDContinueIndefinitely] ,    
                    [DDLimitSelfCare] ,    
                    [DDLimitLanguage] ,    
                    [DDLimitLearning] ,    
                    [DDLimitMobility] ,    
                    [DDLimitSelfDirection] ,    
                    [DDLimitEconomic] ,    
                    [DDLimitIndependentLiving] ,    
                    [DDNeedMulitpleSupports] ,    
                    [CAFASDate] ,    
                    [RaterClinician] ,    
                    [CAFASInterval] ,    
                    [SchoolPerformance] ,    
                    [SchoolPerformanceComment] ,    
                    [HomePerformance] ,    
                    [HomePerfomanceComment] ,    
                    [CommunityPerformance] ,    
                    [CommunityPerformanceComment] ,    
                    [BehaviorTowardsOther] ,    
                    [BehaviorTowardsOtherComment] ,    
                    [MoodsEmotion] ,    
                    [MoodsEmotionComment] ,    
                    [SelfHarmfulBehavior] ,    
                    [SelfHarmfulBehaviorComment] ,    
                    [SubstanceUse] ,    
                    [SubstanceUseComment] ,    
                    [Thinkng] ,    
                    [ThinkngComment] ,    
                    [PrimaryFamilyMaterialNeeds] ,    
                    [PrimaryFamilyMaterialNeedsComment] ,    
                    [PrimaryFamilySocialSupport] ,    
                    [PrimaryFamilySocialSupportComment] ,    
                    [NonCustodialMaterialNeeds] ,    
                    [NonCustodialMaterialNeedsComment] ,    
                    [NonCustodialSocialSupport] ,    
                    [NonCustodialSocialSupportComment] ,    
                    [SurrogateMaterialNeeds] ,    
                    [SurrogateMaterialNeedsComment] ,    
                    [SurrogateSocialSupport] ,    
                    [SurrogateSocialSupportComment] ,    
                    [DischargeCriteria] ,    
                    [PrePlanFiscalIntermediaryComment] ,    
                    [StageOfChange] ,    
                    [PsEducation] ,    
                    [PsEducationNeedsList] ,    
                    [PsMedications] ,    
                    [PsMedicationsNeedsList] ,    
                    [PsMedicationsNeedsList] ,    
                    [PhysicalConditionQuadriplegic] ,    
                    [PhysicalConditionMultipleSclerosis] ,    
                    [PhysicalConditionBlindness] ,    
                    [PhysicalConditionDeafness] ,    
                    [PhysicalConditionParaplegic] ,    
                    [PhysicalConditionCerebral] ,    
                    [PhysicalConditionMuteness] ,    
                    [PhysicalConditionOtherHearingImpairment] ,    
                    [TestingReportsReviewed] ,    
                    [LOCId] ,    
                    [PrePlanSeparateDocument] ,    
                    [UncopeCompleteFullSUAssessment] ,    
                    SevereProfoundDisability ,    
                    SevereProfoundDisabilityComment ,    
                    CASE WHEN @EmpStatus IS NOT NULL THEN @EmpStatus    
                         ELSE NULL    
                    END AS EmploymentStatus ,    
                    @CafasURL AS CafasURL ,    
                    CASE WHEN @SameEpisode = 'Y' THEN PsRiskLossOfPlacement    
                          ELSE NULL    
                    END AS PsRiskLossOfPlacement ,    
                    CASE WHEN @SameEpisode = 'Y' THEN PsRiskLossOfSupport    
                         ELSE NULL    
                    END AS PsRiskLossOfSupport ,    
                    CASE WHEN @SameEpisode = 'Y' THEN PsRiskExpulsionFromSchool    
                         ELSE NULL    
                    END AS PsRiskExpulsionFromSchool ,    
                    CASE WHEN @SameEpisode = 'Y' THEN PsRiskHospitalization    
                         ELSE NULL    
                    END AS PsRiskHospitalization ,    
                    CASE WHEN @SameEpisode = 'Y' THEN PsRiskCriminalJusticeSystem    
                         ELSE NULL    
                    END AS PsRiskCriminalJusticeSystem ,    
                    CASE WHEN @SameEpisode = 'Y' THEN PsRiskElopementFromHome    
                         ELSE NULL    
                    END AS PsRiskElopementFromHome ,    
                    CASE WHEN @SameEpisode = 'Y' THEN PsRiskLossOfFinancialStatus    
                         ELSE NULL    
                    END AS PsRiskLossOfFinancialStatus ,    
                    CASE WHEN @SameEpisode = 'Y' THEN PsRiskLossOfPlacementDueTo    
                         ELSE NULL    
                    END AS PsRiskLossOfPlacementDueTo ,    
                    CASE WHEN @SameEpisode = 'Y' THEN PsRiskLossOfSupportDueTo    
                         ELSE NULL    
                    END AS PsRiskLossOfSupportDueTo ,    
                    CASE WHEN @SameEpisode = 'Y' THEN PsRiskExpulsionFromSchoolDueTo    
                         ELSE NULL    
                    END AS PsRiskExpulsionFromSchoolDueTo ,    
                    CASE WHEN @SameEpisode = 'Y' THEN PsRiskHospitalizationDueTo    
                         ELSE NULL    
                    END AS PsRiskHospitalizationDueTo ,    
                   CASE WHEN @SameEpisode = 'Y' THEN PsRiskCriminalJusticeSystemDueTo    
                         ELSE NULL    
                    END AS PsRiskCriminalJusticeSystemDueTo ,    
                    CASE WHEN @SameEpisode = 'Y' THEN PsRiskElopementFromHomeDueTo    
                         ELSE NULL    
                    END AS PsRiskElopementFromHomeDueTo ,    
                    CASE WHEN @SameEpisode = 'Y' THEN PsRiskLossOfFinancialStatusDueTo    
                         ELSE NULL    
                    END AS PsRiskLossOfFinancialStatusDueTo ,    
                    CASE WHEN @SameEpisode = 'Y' THEN PsFamilyConcernsComment    
                         ELSE NULL    
                    END AS PsFamilyConcernsComment ,    
                    PsFunctioningConcernComment  
                    ,@clientAge AS clientAge                        
                    ,@ExistLatestSignedDocumentVersion AS ExistLatestSignedDocumentVersion    
            FROM    SystemConfigurations AS s    
                    LEFT JOIN CustomDocumentMHAssessments CHA ON s.DatabaseVersion = -1      
                    left join GlobalCodes GC on GC.GlobalCodeId= @GuardianRelationship 
                 -- left outer join GlobalCodes GC1 on GC1.GlobalCodeId= @GuardianState
            
			  SELECT  'CustomDocumentMHCRAFFTs' AS TableName ,        
                    -1 AS DocumentVersionId ,        
                     '' AS [CreatedBy] ,    
                    GETDATE() AS [CreatedDate] ,    
                    '' AS [ModifiedBy] ,    
                    GETDATE() AS [ModifiedDate] ,        
                    CDC.RecordDeleted ,        
                    CDC.DeletedBy ,        
                    CDC.DeletedDate ,        
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
            FROM    SystemConfigurations AS s        
                    LEFT JOIN CustomDocumentMHCRAFFTs CDC ON s.DatabaseVersion = -1  
                      
  --END  
      
---CustomDailyLivingActivityScores---            
            SELECT  'CustomDailyLivingActivityScores' AS TableName ,        
                    DailyLivingActivityScoreId ,        
                    [DocumentVersionId] ,        
                    [HRMActivityId] ,        
                    [ActivityScore] ,        
                    [ActivityComment]  ,        
                     '' AS [CreatedBy] ,    
                    GETDATE() AS [CreatedDate] ,    
                    '' AS [ModifiedBy] ,    
                    GETDATE() AS [ModifiedDate] ,       
                    CDL.[RecordDeleted] ,        
                    CDL.[DeletedDate] ,        
                    CDL.[DeletedBy]        
            FROM    CustomDailyLivingActivityScores CDL        
            WHERE   CDL.DocumentVersionId = @LatestDocumentVersionID        
                    AND ISNULL(CDL.RecordDeleted, 'N') = 'N'      
     
	      SELECT  'CustomSubstanceUseAssessments' AS TableName ,    
                    -1 AS [DocumentVersionId] ,    
                    [VoluntaryAbstinenceTrial] ,    
                    [Comment] ,    
                    [HistoryOrCurrentDUI] ,    
                    [NumberOfTimesDUI] ,    
                    [HistoryOrCurrentDWI] ,    
                    [NumberOfTimesDWI] ,    
                    [HistoryOrCurrentMIP] ,    
                    [NumberOfTimeMIP] ,                        [HistoryOrCurrentBlackOuts] ,    
                    [NumberOfTimesBlackOut] ,    
                    [HistoryOrCurrentDomesticAbuse] ,    
                    [NumberOfTimesDomesticAbuse] ,    
                    [LossOfControl] ,    
                    [IncreasedTolerance] ,    
                    [OtherConsequence] ,    
                    [OtherConsequenceDescription] ,    
                    [RiskOfRelapse] ,    
                    [PreviousTreatment] ,    
                    [CurrentSubstanceAbuseTreatment] ,    
                    [CurrentTreatmentProvider] ,    
                    [CurrentSubstanceAbuseReferralToSAorTx] ,    
                    [CurrentSubstanceAbuseRefferedReason] ,    
                   -- [ToxicologyResults] ,    
                    [SubstanceAbuseAdmittedOrSuspected] ,    
                    [ClientSAHistory] ,    
                    [FamilySAHistory] ,    
                    [NoSubstanceAbuseSuspected] ,    
                    [DUI30Days] ,    
                    [DUI5Years] ,    
                    [DWI30Days] ,    
                    [DWI5Years] ,    
                    [Possession30Days] ,    
                    [Possession5Years] ,    
                    [CurrentSubstanceAbuse] ,    
                    [SuspectedSubstanceAbuse] ,    
                    [SubstanceAbuseDetail] ,    
                    [SubstanceAbuseTxPlan] ,    
                    [OdorOfSubstance] ,    
                    [SlurredSpeech] ,    
                    [WithdrawalSymptoms] ,    
                    [DTOther] ,    
                    [DTOtherText] ,    
                    [Blackouts] ,    
                    [RelatedArrests] ,    
                    [RelatedSocialProblems] ,    
                    [FrequentJobSchoolAbsence] ,    
                    [NoneSynptomsReportedOrObserved]  
					,PreviousMedication
					,CurrentSubstanceAbuseMedication
					,MedicationAssistedTreatment
					,MedicationAssistedTreatmentRefferedReason    
										-- , [RowIdentifier]      
                    ,    
                    '' AS [CreatedBy] ,    
                    GETDATE() AS [CreatedDate] ,    
                    '' AS [ModifiedBy] ,    
                    GETDATE() AS [ModifiedDate] ,   
                    [RecordDeleted] ,    
                    [DeletedDate] ,    
                    [DeletedBy]    
            FROM    SystemConfigurations AS s    
                    LEFT JOIN CustomSubstanceUseAssessments CSUA ON s.DatabaseVersion = -1      
  --END    
         	SELECT  'CustomSubstanceUseHistory2' as TableName ,    
						-1 AS DocumentVersionId ,    
						'' AS CreatedBy ,    
						GETDATE() AS CreatedDate ,    
						'' AS ModifiedBy ,    
						GETDATE() AS ModifiedDate,
						CSUH.RecordDeleted ,
						CSUH.DeletedDate ,
						CSUH.DeletedBy ,
						CSUH.SUDrugId ,
						CSUH.AgeOfFirstUse ,
						CSUH.Frequency ,
						CSUH.[Route] ,
						CSUH.LastUsed ,
						CSUH.InitiallyPrescribed ,
						CSUH.Preference ,
						CSUH.FamilyHistory                         
			FROM  systemconfigurations s    
			INNER JOIN CustomSubstanceUseHistory2 CSUH ON CSUH.DocumentVersionId = @LatestScreeenTypeDocumentVersionId    
    

            SELECT  'CustomDocumentMHAssessmentCAFASs' AS TableName ,    
                    -1 AS 'DocumentVersionId' ,    
                    [CAFASDate] ,    
                    [RaterClinician] ,    
                    [CAFASInterval] ,    
                    0 AS [SchoolPerformance] ,    
                    [SchoolPerformanceComment] ,    
                    0 AS [HomePerformance] ,    
                    [HomePerfomanceComment] ,    
                    0 AS [CommunityPerformance] ,    
                    [CommunityPerformanceComment] ,    
                    0 AS [BehaviorTowardsOther] ,    
                    [BehaviorTowardsOtherComment] ,    
                    0 AS [MoodsEmotion] ,    
                    [MoodsEmotionComment] ,    
                    0 AS [SelfHarmfulBehavior] ,    
                    [SelfHarmfulBehaviorComment] ,    
                    0 AS [SubstanceUse] ,    
                    [SubstanceUseComment] ,    
                    0 AS [Thinkng] ,    
                    [ThinkngComment] ,    
                    [YouthTotalScore] ,    
                    0 AS [PrimaryFamilyMaterialNeeds] ,    
                    [PrimaryFamilyMaterialNeedsComment] ,    
                    0 AS [PrimaryFamilySocialSupport] ,    
                    [PrimaryFamilySocialSupportComment] ,    
                    0 AS [NonCustodialMaterialNeeds] ,    
                    [NonCustodialMaterialNeedsComment] ,    
                    0 AS [NonCustodialSocialSupport] ,    
                    [NonCustodialSocialSupportComment] ,    
                    0 AS [SurrogateMaterialNeeds] ,    
                    [SurrogateMaterialNeedsComment] ,    
                    0 AS [SurrogateSocialSupport] ,    
                    [SurrogateSocialSupportComment] ,    
                     '' AS [CreatedBy] ,    
                    GETDATE() AS [CreatedDate] ,    
                    '' AS [ModifiedBy] ,    
                    GETDATE() AS [ModifiedDate] , 
                    CC2.[RecordDeleted] ,    
                    CC2.[DeletedDate] ,    
                    CC2.[DeletedBy]    
            FROM    SystemConfigurations AS s    
                    LEFT JOIN CustomCAFAS2 CC2 ON s.DatabaseVersion = -1      
     
            
      
  -- CustomMHAssessmentSupports--                   
            SELECT  'CustomMHAssessmentSupports' AS TableName ,    
                    0 AS 'MHAssessmentSupportId' ,    
                    -1 AS 'DocumentVersionId' ,    
                    [SupportDescription] ,    
                    [Current] ,    
                    [PaidSupport] ,    
                    [UnpaidSupport] ,    
                    [ClinicallyRecommended] ,    
                    [CustomerDesired]      
				  ,'' as [CreatedBy]       
				 ,getdate() as [CreatedDate]      
				 ,'' as [ModifiedBy]     
				 ,getdate() as [ModifiedDate]     
                    ,[RecordDeleted] ,    
                    [DeletedDate] ,    
                    [DeletedBy]    
            FROM    SystemConfigurations AS s    
                    LEFT JOIN CustomMHAssessmentSupports CS2 ON s.DatabaseVersion = -1      
  
         SELECT  'CustomDocumentMentalStatusExams' AS TableName ,        
                    -1 AS 'DocumentVersionId'       
                   ,GeneralAppearance      
		 ,GeneralPoorlyAddresses      
		 ,GeneralPoorlyGroomed      
		 ,GeneralDisheveled      
		 ,GeneralOdferous      
		 ,GeneralDeformities      
		 ,GeneralPoorNutrion      
		 ,GeneralRestless         ,GeneralPsychometer      
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
         , '' AS [CreatedBy] ,    
         GETDATE() AS [CreatedDate] ,    
         '' AS [ModifiedBy] ,    
         GETDATE() AS [ModifiedDate] ,       
           [RecordDeleted]        
           ,[DeletedDate]         
            ,[DeletedBy]        
            FROM    SystemConfigurations AS s        
                    LEFT JOIN CustomDocumentMentalStatusExams CMS ON s.DatabaseVersion = -1          
      
          
      
  --- CustomDispositions                    
            SELECT  'CustomDispositions' AS TableName ,    
                    -1 AS CustomDispositionId ,    
                     '' AS [CreatedBy] ,    
                    GETDATE() AS [CreatedDate] ,    
                    '' AS [ModifiedBy] ,    
                    GETDATE() AS [ModifiedDate] ,   
                    CD.RecordDeleted ,    
                    CD.DeletedBy ,    
                    CD.DeletedDate ,    
                    InquiryId ,    
                    DocumentVersionId ,    
                    Disposition    
            FROM    SystemConfigurations AS s    
                    LEFT JOIN CustomDispositions CD ON s.DatabaseVersion = -1      
      
  --- CustomServiceDispositions                    
            SELECT  'CustomServiceDispositions' AS TableName ,    
                    -1 AS CustomServiceDispositionId ,    
                    '' AS [CreatedBy] ,    
                    GETDATE() AS [CreatedDate] ,    
                    '' AS [ModifiedBy] ,    
                    GETDATE() AS [ModifiedDate] ,   
                    CSD.RecordDeleted ,    
                    CSD.DeletedBy ,    
                    CSD.DeletedDate ,    
                    ServiceType ,    
                    -1 AS CustomDispositionId    
            FROM    SystemConfigurations AS s    
                    LEFT JOIN CustomServiceDispositions CSD ON s.DatabaseVersion = -1      
      
  --- CustomProviderServices                    
            SELECT  'CustomProviderServices' AS TableName ,    
                    -1 AS CustomProviderServiceId ,    
                     '' AS [CreatedBy] ,    
                    GETDATE() AS [CreatedDate] ,    
                    '' AS [ModifiedBy] ,    
                    GETDATE() AS [ModifiedDate] , 
                    CPS.RecordDeleted ,    
                    CPS.DeletedBy ,    
                    CPS.DeletedDate ,    
                    ProgramId ,    
                    -1 AS CustomServiceDispositionId    
            FROM    SystemConfigurations AS s    
                    LEFT JOIN CustomProviderServices CPS ON s.DatabaseVersion = -1      
      
   
   --- CustomASAMPlacements                      
            SELECT  'CustomASAMPlacements' AS TableName ,        
                    ISNULL(b.DocumentVersionId, -1) AS DocumentVersionId ,        
                    b.Dimension1LevelOfCare ,        
                    b.Dimension1Need ,        
                    b.Dimension2LevelOfCare ,        
                    b.Dimension2Need ,        
                    b.Dimension3LevelOfCare ,        
                    b.Dimension3Need ,        
                    b.Dimension4LevelOfCare ,        
                    b.Dimension4Need ,        
                    b.Dimension5LevelOfCare ,        
                    b.Dimension5Need ,        
                    b.Dimension6LevelOfCare ,        
                    b.Dimension6Need ,        
                    b.SuggestedPlacement ,        
                    b.FinalPlacement ,        
                    b.FinalPlacementComment ,        
                    '' AS [b.CreatedBy] ,    
                    GETDATE() AS [b.CreatedDate] ,    
                    '' AS [b.ModifiedBy] ,    
                    GETDATE() AS [b.ModifiedDate] ,         
          
                    b.RecordDeleted ,        
                    b.DeletedDate ,        
                    b.DeletedBy        
            FROM    SystemConfigurations AS s        
                    LEFT JOIN CustomASAMPlacements b ON s.DatabaseVersion = -1         
     
            SELECT  'CustomOtherRiskFactors' AS TableName   ,    
                    -1 AS [DocumentVersionId] ,    
                    [OtherRiskFactor]  ,    
                    '' AS [CreatedBy] ,    
                    GETDATE() AS [CreatedDate] ,    
                    '' AS [ModifiedBy] ,    
                    GETDATE() AS [ModifiedDate] ,   
                    c.[RecordDeleted] ,    
                    c.[DeletedDate] ,    
                    c.[DeletedBy] ,
                    c.RowIdentifier,    
                    CodeName    
            FROM    SystemConfigurations AS s    
                    LEFT JOIN CustomOtherRiskFactors c ON s.DatabaseVersion = -1    
                    JOIN GlobalCodes ON GlobalCodes.GlobalCodeId = c.OtherRiskFactor     
     
        SELECT  'CustomDocumentAssessmentSubstanceUses' AS TableName ,        
                    ISNULL(CDA.DocumentVersionId, -1) AS DocumentVersionId ,        
                     '' AS [CreatedBy] ,    
                    GETDATE() AS [CreatedDate] ,    
                    '' AS [ModifiedBy] ,    
                    GETDATE() AS [ModifiedDate] ,      
                    CDA.RecordDeleted ,        
                    CDA.DeletedBy ,        
                    CDA.DeletedDate ,        
                    CDA.UseOfAlcohol ,        
                    CDA.AlcoholAddToNeedsList ,        
                    CDA.UseOfTobaccoNicotine ,        
                    CDA.UseOfTobaccoNicotineQuit ,        
                    CDA.UseOfTobaccoNicotineTypeOfFrequency ,        
                    CDA.UseOfTobaccoNicotineAddToNeedsList ,        
                    CDA.UseOfIllicitDrugs ,        
                    CDA.UseOfIllicitDrugsTypeFrequency ,        
                    CDA.UseOfIllicitDrugsAddToNeedsList ,        
                    CDA.PrescriptionOTCDrugs ,        
                    CDA.PrescriptionOTCDrugsTypeFrequency ,        
                    CDA.PrescriptionOTCDrugsAddtoNeedsList ,  
                    CDA.DrinksPerWeek,  
					 CDA.LastTimeDrinkDate,  
					 CDA.LastTimeDrinks,  
					 CDA.IllegalDrugs,  
					 CDA.BriefCounseling,  
					 CDA.FeedBackOnAlcoholUse,  
					 CDA.Harms,  
					 CDA.DevelopmentOfPlans,  
					 CDA.Refferal,  
					 CDA.DDOneTimeOnly       
            FROM    SystemConfigurations AS s        
                    LEFT JOIN CustomDocumentAssessmentSubstanceUses CDA ON s.DatabaseVersion = -1          
  --END 
        
            SELECT  'CustomDocumentPreEmploymentActivities' AS TableName ,        
                    ISNULL(CDP.DocumentVersionId, -1) AS DocumentVersionId ,        
                     '' AS [CreatedBy] ,    
                    GETDATE() AS [CreatedDate] ,    
                    '' AS [ModifiedBy] ,    
                    GETDATE() AS [ModifiedDate] ,       
                    RecordDeleted ,        
                    DeletedBy ,        
                    DeletedDate ,        
                    EducationTraining ,        
                    EducationTrainingNeeds ,        
                    EducationTrainingNeedsComments ,        
                    PersonalCareerPlanning ,        
                    PersonalCareerPlanningNeeds ,        
                    PersonalCareerPlanningNeedsComments ,        
                    EmploymentOpportunities ,        
                    EmploymentOpportunitiesNeeds ,        
                    EmploymentOpportunitiesNeedsComments ,        
                    SupportedEmployment ,        
                    SupportedEmploymentNeeds ,        
                    SupportedEmploymentNeedsComments ,        
                    WorkHistory ,        
                    WorkHistoryNeeds ,        
                    WorkHistoryNeedsComments ,        
                    GainfulEmploymentBenefits ,        
                    GainfulEmploymentBenefitsNeeds ,        
                    GainfulEmploymentBenefitsNeedsComments ,        
                    GainfulEmployment ,        
                    GainfulEmploymentNeeds ,        
                    GainfulEmploymentNeedsComments        
            FROM    SystemConfigurations AS s        
                    LEFT JOIN CustomDocumentPreEmploymentActivities CDP ON s.DatabaseVersion = -1          
 -- END  

       
       SELECT  'CustomDocumentPrePlanningWorksheet' AS TableName , 
	          -1 AS [DocumentVersionId] ,
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
	                 '' AS [CreatedBy] ,    
                    GETDATE() AS [CreatedDate] ,    
                    '' AS [ModifiedBy] ,    
                    GETDATE() AS [ModifiedDate] ,       
                    CDPW.[RecordDeleted] ,        
                    CDPW.[DeletedDate] ,        
                    CDPW.[DeletedBy] 
					 FROM    SystemConfigurations AS s    
                    LEFT JOIN CustomDocumentPrePlanningWorksheet CDPW ON s.DatabaseVersion = -1    
					
			 SELECT 'CustomDocumentMHColumbiaAdultSinceLastVisits'  AS TableName 
	   , -1 AS [DocumentVersionId]
		 ,'' AS [CreatedBy] ,    
                    GETDATE() AS [CreatedDate] ,    
                    '' AS [ModifiedBy] ,    
                    GETDATE() AS [ModifiedDate] 
		,CDMHAS.RecordDeleted
		,CDMHAS.DeletedBy
		,CDMHAS.DeletedDate
		,CDMHAS.WishToBeDead
		,CDMHAS.WishToBeDeadDescription
		,CDMHAS.NonSpecificActiveSuicidalThoughts
		,CDMHAS.NonSpecificActiveSuicidalThoughtsDescription
		,CDMHAS.ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToAct
		,CDMHAS.ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToActDescription
		,CDMHAS.ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlan
		,CDMHAS.ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlanDescription
		,CDMHAS.AciveSuicidalIdeationWithSpecificPlanAndIntent
		,CDMHAS.AciveSuicidalIdeationWithSpecificPlanAndIntentDescription
		,CDMHAS.MostSevereIdeation
		,CDMHAS.MostSevereIdeationDescription
		,CDMHAS.Frequency
		,CDMHAS.ActualAttempt
		,CDMHAS.TotalNumberOfAttempts
		,CDMHAS.ActualAttemptDescription
		,CDMHAS.HasSubjectEngagedInNonSuicidalSelfInjuriousBehavior
		,CDMHAS.HasSubjectEngagedInSelfInjuriousBehaviorIntentUnknown
		,CDMHAS.InterruptedAttempt
		,CDMHAS.TotalNumberOfAttemptsInterrupted
		,CDMHAS.InterruptedAttemptDescription
		,CDMHAS.AbortedOrSelfInterruptedAttempt
		,CDMHAS.TotalNumberAttemptsAbortedOrSelfInterrupted
		,CDMHAS.AbortedOrSelfInterruptedAttemptDescription
		,CDMHAS.PreparatoryActsOrBehavior
		,CDMHAS.TotalNumberOfPreparatoryActs
		,CDMHAS.PreparatoryActsOrBehaviorDescription
		,CDMHAS.SuicidalBehavior
		,CDMHAS.MostLethalAttemptDate
		,CDMHAS.ActualLethalityMedicalDamage
		,CDMHAS.PotentialLethality
         FROM    SystemConfigurations AS s  
         LEFT JOIN CustomDocumentMHColumbiaAdultSinceLastVisits CDMHAS ON s.DatabaseVersion = -1 

	 SELECT 'CustomDocumentAssessmentPECFASs'  AS TableName 
	   , -1 AS [DocumentVersionId]
	   ,'' AS [CreatedBy] ,    
                    GETDATE() AS [CreatedDate] ,    
                    '' AS [ModifiedBy] ,    
                    GETDATE() AS [ModifiedDate] 
		,CDAP.RecordDeleted
		,CDAP.DeletedBy
		,CDAP.DeletedDate
		,CDAP.SchoolDayCare
		,CDAP.HomeRolePerformance
		,CDAP.CommunityRolePerformance
		,CDAP.BehaviourTowardOthers
		,CDAP.MoodsEmotions
		,CDAP.SelfHarmfulBehavior
		,CDAP.ThinkingCommunication
		,CDAP.TotalChild
		,CDAP.PrimaryScaleScore
		,CDAP.OtherScaleScore
		,CDAP.MaterialNeeds1
		,CDAP.MaterialNeeds2
		,CDAP.FamilySocialSupport1
		,CDAP.FamilySocialSupport2
	   FROM    SystemConfigurations AS s  
      LEFT JOIN CustomDocumentAssessmentPECFASs CDAP ON s.DatabaseVersion = -1 
  
	
           
            SELECT  'CarePlanDomains' AS TableName ,    
                    CPD.[CarePlanDomainId] ,    
                    CPD.[CreatedBy] ,    
                    CPD.[CreatedDate] ,    
                    CPD.[ModifiedBy] ,    
                    CPD.[ModifiedDate] ,    
                    CPD.[RecordDeleted] ,    
                    CPD.[DeletedBy] ,    
                    CPD.[DeletedDate] ,    
                    CPD.[DomainName]    
            FROM    CarePlanDomains AS CPD    
            WHERE   ISNULL(CPD.RecordDeleted, 'N') = 'N'    
            ORDER BY CPD.DomainName      
      
  --CarePlanDomainNeeds          
            SELECT  'CarePlanDomainNeeds' AS TableName ,    
                    CPDN.CarePlanDomainNeedId ,    
                    CPDN.CreatedBy ,    
                    CPDN.CreatedDate ,    
                    CPDN.ModifiedBy ,    
                    CPDN.ModifiedDate ,    
                    CPDN.RecordDeleted ,    
                    CPDN.DeletedBy ,    
                    CPDN.DeletedDate ,    
                    CPDN.NeedName ,    
                    CPDN.CarePlanDomainId ,    
                    CPDN.MHAFieldIdentifierCode ,    
                    CPDN.MHANeedDescription    
            FROM    CarePlanDomainNeeds AS CPDN    
            WHERE   ISNULL(CPDN.RecordDeleted, 'N') = 'N'      
      
       EXEC csp_InitCarePlanNeedsMHAssessments @ClientID, -1, 0;       
        
		  if(@ClientInDDPopulationDocumentVersionId > 0)    
   begin    
     SELECT top 1 'CustomDocumentAssessmentDiagnosisIDDEligibilities' AS TableName ,      
          -1 AS DocumentVersionId,      
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
   From SystemConfigurations AS s LEFT OUTER JOIN CustomDocumentAssessmentDiagnosisIDDEligibilities b     
          ON b.DocumentVersionId = @ClientInDDPopulationDocumentVersionId    
   end  
  else  
   begin  
    SELECT  'CustomDocumentAssessmentDiagnosisIDDEligibilities' AS TableName ,      
          ISNULL(b.DocumentVersionId, -1) AS DocumentVersionId,      
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
   From SystemConfigurations AS s LEFT OUTER JOIN CustomDocumentAssessmentDiagnosisIDDEligibilities b ON s.DatabaseVersion = - 1       
   end  
  
   if(@ClientInDDPopulationDocumentVersionId > 0)    
   begin    
      SELECT    'CustomAssessmentDiagnosisIDDCriteria' AS TableName ,      
           Convert(int,0 - Row_Number() Over (Order by AssessmentDiagnosisIDDCriteriaId asc)) AS AssessmentDiagnosisIDDCriteriaId,                
   b.CreatedBy,  
   b.CreatedDate,  
   b.ModifiedBy,  
   b.ModifiedDate,  
   b.RecordDeleted,  
   b.DeletedBy,  
   b.DeletedDate,  
   -1 DocumentVersionId,  
   b.SubstantialFunctional,  
   b.IsChecked  
   FROM   CustomAssessmentDiagnosisIDDCriteria b    
   where b.DocumentVersionId = @ClientInDDPopulationDocumentVersionId    
   end  
    
   
	 if(@ClientInDDPopulationDocumentVersionId > 0)    
	   begin    
			SELECT  top 1  'CustomDocumentFunctionalAssessments' AS TableName ,      
				-1 AS DocumentVersionId,                   
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
	   b.ManageChangesDailySchedule,  
	   b.CommunityLivingSkillComments,  
	   b.PreferredActivities,  
	   b.CommunityLivingSkillNeedList  
	   From SystemConfigurations AS s LEFT OUTER JOIN CustomDocumentFunctionalAssessments b     
			  ON b.DocumentVersionId = @ClientInDDPopulationDocumentVersionId    
	   end  
	 else  
	   begin  
		  SELECT 'CustomDocumentFunctionalAssessments' AS TableName ,      
				ISNULL(b.DocumentVersionId, -1) AS DocumentVersionId,                   
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
	   b.ManageChangesDailySchedule,  
	   b.CommunityLivingSkillComments,  
	   b.PreferredActivities,  
	   b.CommunityLivingSkillNeedList  
		 From SystemConfigurations AS s LEFT OUTER JOIN CustomDocumentFunctionalAssessments b ON s.DatabaseVersion = - 1    
	   end  
  
	  if(@ClientInDDPopulationDocumentVersionId > 0)    
	   Begin  
		  SELECT    'CustomAssessmentFunctionalCommunications' AS TableName ,      
				Convert(int,0 - Row_Number() Over (Order by AssessmentFunctionalCommunicationId asc)) AS AssessmentFunctionalCommunicationId,                   
	   b.CreatedBy,  
	   b.CreatedDate,  
	   b.ModifiedBy,  
	   b.ModifiedDate,  
	   b.RecordDeleted,  
	   b.DeletedBy,  
	   b.DeletedDate,  
		  -1 DocumentVersionId,  
	   b.Communication,  
	   b.IsChecked  
	   FROM   CustomAssessmentFunctionalCommunications b    
	   where b.DocumentVersionId = @ClientInDDPopulationDocumentVersionId   
	   end  
	      
		
		END TRY      
      
        BEGIN CATCH      
            DECLARE @Error VARCHAR(8000)      
      
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_InitCustomMHAssessmentDefaultIntialization') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())      
      
            RAISERROR (      
    @Error      
    ,-- Message text.                                                                                                                                                                  
    16      
    ,-- Severity.                                                                                                                                                                                                                                              
  
    
      
    1 -- State.                                                             
    );      
        END CATCH      
    END  