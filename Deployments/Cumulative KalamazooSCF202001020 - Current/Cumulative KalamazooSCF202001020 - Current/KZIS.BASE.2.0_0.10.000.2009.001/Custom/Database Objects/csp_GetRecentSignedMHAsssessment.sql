

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'csp_GetRecentSignedMHAsssessment')
	BEGIN
		DROP  Procedure  csp_GetRecentSignedMHAsssessment --139,444,0
	END

GO  
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO   
CREATE PROCEDURE [dbo].[csp_GetRecentSignedMHAsssessment] (        
 @ClientID INT        
 ,@AxisIAxisIIOut VARCHAR(100)        
 ,@ClientAge VARCHAR(50)        
 ,@AssessmentType CHAR(1)        
 ,@LatestDocumentVersionId INT        
 ,@InitialRequestDate DATETIME        
 ,@ClientDOB VARCHAR(50)        
 ,@CurrentAuthorId INT        
 )        
AS        
 /*********************************************************************/
 /* Stored Procedure: [csp_GetRecentSignedMHAsssessment]   */

 /*       Date              Author                  Purpose                   */ 
 /*       28/May/2020      Jyothi Bellapu          This SP will return Latest signed document data part of Kalamazoo - Improvements -#7*/
 /*       18/Jun/2020      Josekutty Varghese      What : Added intialization for newly added tabs such as Diagnosis-IDD Eligibility and Functional Assessment
                                                   Why  : Initialization needs to happened for newly added tables
												   Portal Task: #12 in KCMHSAS Improvements    */
 /*********************************************************************/  
       
BEGIN        
 -- For GuardianTypeText                        
 DECLARE @GuardianTypeText VARCHAR(250)        
        
 BEGIN TRY        
  DECLARE @ClientHasGuardian CHAR(1) = NULL      
  DECLARE @GuardianFirstName VARCHAR(150) = NULL   
  DECLARE  @GuardianLastName VARCHAR(150) = NULL     
  DECLARE @GuardianAddress VARCHAR(100) = NULL      
  DECLARE @GuardianCity VARCHAR(100)  
  DECLARE @GuardianState VARCHAR(100)  
  DECLARE @GuardianZipCode VARCHAR(100)  
  DECLARE @GuardianRelationship int  
  DECLARE @ClientContactId INT = NULL      
  DECLARE @MHAssessmentDocumentcodeId VARCHAR(MAX)  
  Declare @ClientInDDPopulationDocumentVersionId as int
  DECLARE @CODE VARCHAR(MAX)  
  SET @CODE='69E559DD-1A4D-46D3-B91C-E89DA48E0038'  
  SET @MHAssessmentDocumentcodeId=(Select DocumentCodeId from DocumentCodes where Code=@CODE)  
  
  IF EXISTS(SELECT * FROM ClientContacts WHERE ClientId = @ClientID and isnull(Guardian,'N') = 'Y' and isnull(Active,'N') = 'Y')      
  BEGIN      
 SET @ClientHasGuardian = 'Y'       
 SELECT TOP 1 @ClientContactId = ClientContactId FROM ClientContacts WHERE ClientId = @ClientID AND ISNULL(Guardian,'N') = 'Y' AND ISNULL(Active,'N') = 'Y' AND ISNULL(RecordDeleted,'N') = 'N' ORDER BY ModifiedDate DESC      
 IF @ClientContactId IS NOT NULL      
 BEGIN      
  SELECT TOP 1 @GuardianFirstName = FirstName FROM ClientContacts WHERE ClientContactId = @ClientContactId  
    SELECT TOP 1 @GuardianLastName = LastName FROM ClientContacts WHERE ClientContactId = @ClientContactId     
 SELECT TOP 1 @GuardianRelationship = Relationship FROM ClientContacts WHERE ClientContactId = @ClientContactId   
  SELECT TOP 1 @GuardianAddress = Address FROM ClientContactAddresses WHERE ClientContactId = @ClientContactId   
  SELECT TOP 1 @GuardianCity = City FROM ClientContactAddresses WHERE ClientContactId = @ClientContactId   
  SELECT TOP 1 @GuardianState = State FROM ClientContactAddresses WHERE ClientContactId = @ClientContactId   
  SELECT TOP 1 @GuardianZipCode = Zip FROM ClientContactAddresses WHERE ClientContactId = @ClientContactId      
 END      
  END      
   DECLARE @ClientAgeNum VARCHAR(50)        
        
   SET @ClientAgeNum = Substring(@ClientAge, 1, CHARINDEX(' ', @ClientAge))        
        
   DECLARE @CafasURL VARCHAR(1024)        
        
   SET @CafasURL = (        
     SELECT CafasURL        
     FROM CustomConfigurations        
     )        
        
  --Added by Rakesh w.rf to task 135 in General Implementation Initialize the Inquiry Disposition Comments field from the last completed Inquiry. Only for Screen and Initial Assessment types           
  DECLARE @DispostionComment AS VARCHAR(max)        
  DECLARE @PresentingProblem AS VARCHAR(max)        
  DECLARE @AccomationNeeded AS VARCHAR(10)        
  DECLARE @AccomationNeededInquiryValues VARCHAR(200)        
  DECLARE @LatestScreeenTypeDocumentVersionId AS INT       
  DECLARE @LatestInitialTypeDocumentVersionId AS INT        
  DECLARE @ReferralSubType AS INT        
  DECLARE @Living AS INT        
  DECLARE @EmploymentStatus AS INT        
  DECLARE @HASGUARDIAN AS VARCHAR(10)      
  DECLARE @GUARDIANAME AS VARCHAR(100)      
  DECLARE @GUARDIANNADDRESS AS VARCHAR(max)      
  DECLARE @REFERRALSOURCE INT      
  DECLARE @CONTACTID INT      
  DECLARE @CLIENTPHONE VARCHAR(500)      
  DECLARE @CurrentLiving INT      
  DECLARE @EmpStatus INT      
  DECLARE @ExternalReferralProviderId INT       
  DECLARE @INQUIRYDATE DATETIME      
  DECLARE @REGISTRATIONDATE DATETIME      
  DECLARE @PrimaryPhysician VARCHAR(500)   
  DECLARE @LegalIssues   VARCHAR(max) 
  DECLARE @DesiredOutcomes VARCHAR(max)
 Select       
@CurrentLiving = livingArrangement,      
@EmpStatus = EmploymentStatus,      
@ExternalReferralProviderId=ExternalReferralProviderId      
From Clients where ClientId=@ClientID      
      
SELECT  @PrimaryPhysician = Name 
            FROM    ExternalReferralProviders  
            WHERE   ExternalReferralProviderId = @ExternalReferralProviderId      
      
   
                                                          
  select top 1       
 @GUARDIANAME= isnull(CC.LastName,'') + case when LastName is not null then  ', ' else '' end +isnull(CC.FirstName,''),      
 @HASGUARDIAN = CC.Guardian,      
 @GUARDIANNADDRESS=CCA.Display,      
--CCA.Address,      
--CCA.City,      
 @CONTACTID=CC.ClientContactId      
from       
clientcontacts CC join      
ClientContactAddresses CCA on CC.ClientContactId=CCA.ClientContactId      
where CC.ClientId=@ClientID and Isnull(CC.Guardian,'N')='Y' Order By CC.modifieddate DESC      
  IF (@CONTACTID IS NOT NULL)      
  BEGIN      
  SET @CLIENTPHONE=(SELECT TOP ( 1 )        
                        PhoneNumber        
              FROM      ClientContactPhones        
              WHERE     ( ClientContactId = @CONTACTID )        
                        AND ( PhoneNumber IS NOT NULL ) 
                        AND (PhoneNumber <> '')         
                        AND(PhoneType in (SELECT GlobalCodeId from GlobalCodes where Category='PHONETYPE' AND CodeName in ('Home','Home 2','Mobile','Mobile 2')))
						AND ( ISNULL(RecordDeleted, 'N') = 'N' )       
              ORDER BY  PhoneType)      
                    
              END      
                    
    
           
    IF @REGISTRATIONDATE IS NOT NULL      
    BEGIN      
  Select top 1 @INQUIRYDATE = InquiryStartDateTime from CustomInquiries where cast(Createddate as Date)<=cast(@REGISTRATIONDATE as Date) AND ClientId = @ClientID      
  order by  Createddate Desc      
    END      
             
   IF (@AssessmentType = 'I')        
   BEGIN        
   SELECT TOP 1 @DispostionComment = CI.DispositionComment        
    ,@PresentingProblem = CI.PresentingProblem        
    ,@AccomationNeeded = CI.AccomodationNeeded        
    ,@ReferralSubType = ReferralSubtype        
    ,@Living = Living        
    ,@EmploymentStatus = EmploymentStatus        
    FROM CustomInquiries CI        
    LEFT JOIN GlobalCodes gc ON CI.InquiryStatus = gc.GlobalCodeId        
    WHERE CI.ClientId = @ClientID        
     AND ISNULL(CI.RecordDeleted, 'N') = 'N'        
    -- AND gc.Category = 'XINQUIRYSTATUS'        
    -- AND gc.CodeName = 'COMPLETE'        
    ORDER BY InquiryId DESC --Get Information For Last Completed Inquiry         
        
    IF (@AccomationNeeded IS NOT NULL)        
    BEGIN        
     SELECT @AccomationNeededInquiryValues = COALESCE(@AccomationNeededInquiryValues + ', ', '') + CASE         
       WHEN item = 0        
        THEN 'Interpreter'        
       WHEN item = 1        
        THEN 'Reading Assistance'        
       WHEN item = 2        
        THEN 'Sign Language'        
       END        
     FROM dbo.fnSplit(@AccomationNeeded, ',') -- Need to hardocode values as in database only 0,1,2 values saves for this & there is no globalcodeId for this        
        
     SET @AccomationNeededInquiryValues = 'Accommodation Needed-' + @AccomationNeededInquiryValues        
    END        
  END  

  IF(@AssessmentType='U'OR @AssessmentType='A')
	BEGIN
	  SELECT TOP 1  @PresentingProblem = PresentingProblem ,
	                 @LegalIssues =LegalIssues  
					 ,@DesiredOutcomes=DesiredOutcomes
                    FROM    CustomDocumentMHAssessments CHA    
                            INNER JOIN Documents d ON CHA.DocumentVersionId = d.CurrentDocumentVersionId    
                                                      AND d.ClientId = @ClientID    
                                                      AND ISNULL(d.RecordDeleted, 'N') = 'N'    
                                                      AND ISNULL(CHA.RecordDeleted, 'N') = 'N' 
                                                      AND d.[Status] = 22    
                                                      AND d.DocumentCodeId = @MHAssessmentDocumentcodeId     
                    ORDER BY d.CurrentDocumentVersionId DESC    
	END
	    
    DECLARE @EpsiodeRegistrationDate AS DATETIME        
   DECLARE  @SameEpisode char(1)      
   DECLARE @PrevEffectiveDate AS DateTime      
   SELECT @EpsiodeRegistrationDate = CE.RegistrationDate ,@REFERRALSOURCE = ReferralType      
   FROM ClientEpisodes CE        
   INNER JOIN GlobalCodes GC ON GC.GlobalCodeId = CE.[Status]        
    WHERE ClientId = @ClientID        
     AND ISNULL(CE.RecordDeleted, 'N') = 'N'        
     AND CE.DischargeDate IS NULL        
     AND GC.GlobalCodeId IN (        
      100        
      ,101        
      )        
        
    -- Select the latest document version Id for previous signeed Screen type assessment before Client Episiode registration        
        
    SELECT TOP 1 @LatestScreeenTypeDocumentVersionId = d.CurrentDocumentVersionId       
    ,@PrevEffectiveDate=d.EffectiveDate      
    FROM CustomDocumentMHAssessments CHA        
    INNER JOIN Documents d ON CHA.DocumentVersionId = d.CurrentDocumentVersionId        
     AND d.ClientId = @ClientID        
     AND Isnull(d.RecordDeleted, 'N') = 'N'        
     AND Isnull(CHA.RecordDeleted, 'N') = 'N'   
     AND d.[Status] = 22        
     AND d.DocumentCodeId = @MHAssessmentDocumentcodeId  ORDER BY d.EffectiveDate DESC        
     ,d.ModifiedDate DESC       
           
      
           
     
    IF(@EpsiodeRegistrationDate IS NOT NULL and @EpsiodeRegistrationDate <=@PrevEffectiveDate)      
    SET @SameEpisode='Y'   
	 
 
	   Select TOP 1 @ClientInDDPopulationDocumentVersionId = d.CurrentDocumentVersionId from CustomDocumentMHAssessments CHA 
	   join Documents d  on  CHA.DocumentVersionId = d.CurrentDocumentVersionId  
	   Where d.ClientId = @ClientID and Isnull(d.RecordDeleted,'N') = 'N' and Isnull(CHA.RecordDeleted,'N') = 'N'    
	   and d.DocumentCodeId = @MHAssessmentDocumentcodeId And  IsNull(ClientInDDPopulation,'N') = 'Y' and d.[Status] = 22
	   ORDER BY d.CurrentDocumentVersionId DESC
	   
  DECLARE @ExistLatestSignedDocumentVersion CHAR        
        
  IF (@LatestDocumentVersionID > 0)        
   SET @ExistLatestSignedDocumentVersion = 'Y'        
  ELSE        
   SET @ExistLatestSignedDocumentVersion = 'N'        
        
   --- CustomDocumentMHAssessments --           
   SELECT 'CustomDocumentMHAssessments' AS TableName        
    ,[DocumentVersionId]        
    ,[ClientName]        
    ,@AssessmentType AS [AssessmentType]     
                                                                                                                                  
    
    ,[PreviousAssessmentDate]        
    ,@ClientDOB AS [ClientDOB]        
    ,CASE         
     WHEN @ClientAgeNum >= 18        
      THEN 'A'        
     ELSE 'C'        
     END AS [AdultOrChild]        
    ,[ChildHasNoParentalConsent]        
    ,@ClientHasGuardian AS ClientHasGuardian      
    ,@GuardianFirstName AS GuardianFirstName   
   ,@GuardianLastName AS GuardianLastName        
    ,@GuardianAddress AS GuardianAddress     
   ,@GuardianCity    AS GuardianCity  
    ,@GuardianState   AS GuardianState   
   -- ,GC1.CodeName as GuardianStateText
    ,@GuardianZipCode  AS GuardianZipcode  
    ,CASE WHEN @CLIENTPHONE IS NOT NULL THEN @CLIENTPHONE ELSE NULL END AS [GuardianPhone]        
    ,@GuardianRelationship AS RelationWithGuardian 
    ,GC.CodeName as GuardianTypeText        
    ,[ClientInDDPopulation]        
    ,[ClientInSAPopulation]        
    ,[ClientInMHPopulation]        
    ,[PreviousDiagnosisText]        
      ,CASE WHEN @SameEpisode = 'Y' THEN  @REFERRALSOURCE ELSE NULL END AS  [ReferralType]        
    ,@PresentingProblem  AS  PresentingProblem      
    ,CASE WHEN @CurrentLiving IS NOT NULL THEN @CurrentLiving ELSE NULL END AS [CurrentLivingArrangement]        
    ,CASE WHEN @PrimaryPhysician IS NOT NULL THEN @PrimaryPhysician ELSE NULL END AS [CurrentPrimaryCarePhysician]        
    ,[ReasonForUpdate]                                  
     ,@DesiredOutcomes AS [DesiredOutcomes]        
      
      
,UnProtectedSexualRelationMoreThenOnePartner        
,SexualRelationWithHIVInfected        
,SexualRelationWithDrugInject        
,InjectsDrugsSharedNeedle        
,ReceivedAnyFavorsForSexualRelation        
    
        
,CASE  WHEN @AssessmentType IN ( 'U','A' )  THEN [ReceivePrenatalCare]  ELSE NULL   END AS [ReceivePrenatalCare]  
,CASE  WHEN @AssessmentType IN ( 'U','A' )  THEN [ReceivePrenatalCareNeedsList]  ELSE NULL   END AS [ReceivePrenatalCareNeedsList]            
,CASE  WHEN @AssessmentType IN ( 'U','A' )  THEN [ProblemInPregnancy]  ELSE NULL   END AS ProblemInPregnancy     
,CASE  WHEN @AssessmentType IN ( 'U','A' )  THEN [ProblemInPregnancyNeedsList]  ELSE NULL   END AS ProblemInPregnancyNeedsList      
,CASE  WHEN @AssessmentType IN ( 'U','A' )  THEN [PrenatalExposer]  ELSE NULL   END AS PrenatalExposer 
,CASE  WHEN @AssessmentType IN ( 'U','A' )  THEN [PrenatalExposerNeedsList]  ELSE NULL   END AS PrenatalExposerNeedsList  
,CASE  WHEN @AssessmentType IN ( 'U','A' )  THEN [WhereMedicationUsed]  ELSE NULL   END AS WhereMedicationUsed 
,CASE  WHEN @AssessmentType IN ( 'U','A' )  THEN [WhereMedicationUsedNeedsList]  ELSE NULL   END AS WhereMedicationUsedNeedsList     
,CASE  WHEN @AssessmentType IN ( 'U','A' )  THEN [IssueWithDelivery]  ELSE NULL   END AS IssueWithDelivery   
,CASE  WHEN @AssessmentType IN ( 'U','A' )  THEN [IssueWithDeliveryNeedsList]  ELSE NULL   END AS IssueWithDeliveryNeedsList     
,CASE  WHEN @AssessmentType IN ( 'U','A' )  THEN [ChildDevelopmentalMilestones]  ELSE NULL   END AS  ChildDevelopmentalMilestones 
,CASE  WHEN @AssessmentType IN ( 'U','A' )  THEN [ChildDevelopmentalMilestonesNeedsList]  ELSE NULL   END AS   ChildDevelopmentalMilestonesNeedsList
,CASE  WHEN @AssessmentType IN ( 'U','A' )  THEN [DevelopmentalAttachmentComments]  ELSE NULL   END AS   DevelopmentalAttachmentComments
,CASE  WHEN @AssessmentType IN ( 'U','A' )  THEN [ParentChildRelationshipIssue]  ELSE NULL   END AS  ParentChildRelationshipIssue 
,CASE  WHEN @AssessmentType IN ( 'U','A' )  THEN [ParentChildRelationshipNeedsList]  ELSE NULL   END AS  ParentChildRelationshipNeedsList
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN  PsChildHousingIssues ELSE NULL   END AS [PsChildHousingIssues]        
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN  PsChildHousingIssuesNeedsList ELSE NULL   END AS PsChildHousingIssuesNeedsList
--,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN  [PsChildHousingIssuesComment]   ELSE NULL   END AS    PsChildHousingIssuesComment    
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN  PsParentalParticipation ELSE NULL end as [PsParentalParticipation] 
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN PsParentalParticipationNeedsList ELSE NULL   END AS  PsParentalParticipationNeedsList
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN FamilyRelationshipIssues  ELSE NULL   END AS FamilyRelationshipIssues
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN FamilyRelationshipNeedsList ELSE NULL   END AS  FamilyRelationshipNeedsList
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN PsFamilyConcernsComment ELSE NULL   END AS  PsFamilyConcernsComment
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN PsClientAbuseIssues  ELSE NULL   END AS  PsClientAbuseIssues
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN PsClientAbuesIssuesComment ELSE NULL   END AS  PsClientAbuesIssuesComment
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN AddSexualitytoNeedList ELSE NULL   END AS AddSexualitytoNeedList
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN SexualityComment ELSE NULL   END AS SexualityComment
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN HistMentalHealthTx  ELSE NULL   END AS HistMentalHealthTx
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN HistMentalHealthTxNeedsList  ELSE NULL   END AS HistMentalHealthTxNeedsList
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN HistMentalHealthTxComment ELSE NULL   END AS HistMentalHealthTxComment
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN PsCulturalEthnicIssues ELSE NULL   END AS PsCulturalEthnicIssues
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN PsCulturalEthnicIssuesNeedsList ELSE NULL   END AS  PsCulturalEthnicIssuesNeedsList
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN PsCulturalEthnicIssuesComment ELSE NULL   END AS  PsCulturalEthnicIssuesComment
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN AutisticallyImpaired ELSE NULL   END AS AutisticallyImpaired
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN CognitivelyImpaired ELSE NULL   END AS CognitivelyImpaired
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN EmotionallyImpaired ELSE NULL   END AS EmotionallyImpaired
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN BehavioralConcern ELSE NULL   END AS BehavioralConcern
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN LearningDisabilities ELSE NULL   END AS LearningDisabilities
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN PhysicalImpaired ELSE NULL   END AS PhysicalImpaired
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN IEP ELSE NULL   END AS IEP
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN ChallengesBarrier ELSE NULL   END AS ChallengesBarrier
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN PsEducationNeedsList ELSE NULL   END AS  PsEducationNeedsList
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN PsEducationComment ELSE NULL   END AS PsEducationComment
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN PsRiskLossOfPlacement ELSE NULL   END AS PsRiskLossOfPlacement
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN PsRiskLossOfPlacementDueTo ELSE NULL   END AS PsRiskLossOfPlacementDueTo
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN [PsRiskSensoryMotorFunction]   ELSE NULL   END AS  [PsRiskSensoryMotorFunction]     
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN [PsRiskSensoryMotorFunctionDueTo]  ELSE NULL   END AS   [PsRiskSensoryMotorFunctionDueTo]    
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN [PsRiskSafety]       ELSE NULL   END AS  [PsRiskSafety]
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN [PsRiskSafetyDueTo]   ELSE NULL   END AS    [PsRiskSafetyDueTo]  
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN [PsRiskLossOfSupport]     ELSE NULL   END AS   [PsRiskLossOfSupport] 
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN [PsRiskLossOfSupportDueTo]   ELSE NULL   END AS   [PsRiskLossOfSupportDueTo]    
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN [PsRiskExpulsionFromSchool]   ELSE NULL   END AS   [PsRiskExpulsionFromSchool]   
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN [PsRiskExpulsionFromSchoolDueTo]     ELSE NULL   END AS  [PsRiskExpulsionFromSchoolDueTo]  
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN [PsRiskHospitalization]        ELSE NULL   END AS [PsRiskHospitalization] 
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN [PsRiskHospitalizationDueTo]     ELSE NULL   END AS [PsRiskHospitalizationDueTo]    
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN [PsRiskCriminalJusticeSystem]     ELSE NULL   END AS   [PsRiskCriminalJusticeSystem]  
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN [PsRiskCriminalJusticeSystemDueTo]   ELSE NULL   END AS   [PsRiskCriminalJusticeSystemDueTo]    
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN [PsRiskElopementFromHome]        ELSE NULL   END AS [PsRiskElopementFromHome] 
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN [PsRiskElopementFromHomeDueTo]    ELSE NULL   END AS   [PsRiskElopementFromHomeDueTo]  
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN [PsRiskLossOfFinancialStatus]      ELSE NULL   END AS   [PsRiskLossOfFinancialStatus] 
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN [PsRiskLossOfFinancialStatusDueTo]  ELSE NULL   END AS  [PsRiskLossOfFinancialStatusDueTo]
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN PsLanguageFunctioningNeedsList  ELSE NULL   END AS PsLanguageFunctioningNeedsList
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN PsVisualFunctioningNeedsList  ELSE NULL   END AS PsVisualFunctioningNeedsList
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN PsIntellectualFunctioningNeedsList  ELSE NULL   END AS PsIntellectualFunctioningNeedsList
,CASE  WHEN @AssessmentType IN ( 'U','A' ) THEN PsLearningAbilityNeedsList  ELSE NULL   END AS PsLearningAbilityNeedsList


    ,[PsParentalParticipationComment]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [PsParentalParticipationNeedsList]        
     ELSE NULL        
     END AS [PsParentalParticipationNeedsList]  
,CASE WHEN @AssessmentType='U' THEN UncopeApplicable ELSE NULL END AS UncopeApplicable 
,CASE WHEN @AssessmentType='U' THEN UncopeApplicableReason ELSE NULL END AS UncopeApplicableReason 
,CASE WHEN @AssessmentType='U' THEN UncopeQuestionU ELSE NULL END AS UncopeQuestionU 
,CASE WHEN @AssessmentType='U' THEN UncopeQuestionN ELSE NULL END AS UncopeQuestionN 
,CASE WHEN @AssessmentType='U' THEN UncopeQuestionC ELSE NULL END AS UncopeQuestionC 
,CASE WHEN @AssessmentType='U' THEN UncopeQuestionO ELSE NULL END AS UncopeQuestionO   
,CASE WHEN @AssessmentType='U' THEN UncopeQuestionP ELSE NULL END AS UncopeQuestionP      
,CASE WHEN @AssessmentType='U' THEN UncopeQuestionE ELSE NULL END AS UncopeQuestionE   
,CASE WHEN @AssessmentType='U' THEN StageOfChange ELSE NULL END AS StageOfChange              
           
         
    ,[IncludeFunctionalAssessment]        
    ,[IncludeSymptomChecklist]        
    ,[IncludeUNCOPE]        
        
    ,CASE         
     WHEN @AssessmentType IN (        
        'U','A'         
       ,'I'        
       )        
      THEN [RapCiDomainIntensity]        
     ELSE NULL        
     END AS [RapCiDomainIntensity]        
    ,[RapCiDomainComment]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [RapCiDomainNeedsList]        
     ELSE NULL        
     END AS [RapCiDomainNeedsList]        
    ,CASE         
     WHEN @AssessmentType IN (        
        'U','A'         
       ,'I'        
       )        
      THEN [RapCbDomainIntensity]        
     ELSE NULL        
     END AS [RapCbDomainIntensity]        
    ,[RapCbDomainComment]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [RapCbDomainNeedsList]        
     ELSE NULL        
     END AS [RapCbDomainNeedsList]        
    ,CASE         
     WHEN @AssessmentType IN (        
        'U','A'         
       ,'I'        
       )        
      THEN [RapCaDomainIntensity]        
     ELSE NULL        
     END AS [RapCaDomainIntensity]        
    ,[RapCaDomainComment]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [RapCaDomainNeedsList]        
     ELSE NULL        
     END AS [RapCaDomainNeedsList]        
    ,CASE         
     WHEN @AssessmentType IN (        
        'U','A'         
       ,'I'        
       )        
      THEN [RapHhcDomainIntensity]        
     ELSE NULL        
     END AS [RapHhcDomainIntensity]        
    ,CASE         
     WHEN @AssessmentType IN (        
        'U','A'         
       ,'I'        
       )        
      THEN [OutsideReferralsGiven]        
     ELSE NULL        
     END AS [OutsideReferralsGiven]        
    ,CASE         
     WHEN @AssessmentType IN (        
        'U','A'         
       ,'I'        
       )        
      THEN [ReferralsNarrative]        
     ELSE NULL        
     END AS [ReferralsNarrative]        
    ,CASE         
     WHEN @AssessmentType IN (        
        'U','A'         
       ,'I'        
       )        
      THEN [ServiceOther]        
     ELSE NULL        
     END AS [ServiceOther]        
    ,CASE         
     WHEN @AssessmentType IN (        
        'U','A'         
       ,'I'        
       )        
      THEN [ServiceOtherDescription]        
     ELSE NULL        
     END AS [ServiceOtherDescription]        
    ,[AssessmentAddtionalInformation]        
     ,CASE         
     WHEN @AssessmentType IN (        
        'U','A'         
       ,'I'        
       )        
      THEN [Participants]        
     ELSE NULL        
     END AS [Participants]        
    ,CASE         
     WHEN @AssessmentType IN (        
        'U','A'         
       ,'I'        
       )        
      THEN [Facilitator]        
     ELSE NULL        
     END AS [Facilitator]        
    ,CASE         
     WHEN @AssessmentType IN (        
        'U','A'         
       ,'I'        
       )        
      THEN [TimeLocation]        
     ELSE NULL        
     END AS [TimeLocation]        
    ,CASE         
     WHEN @AssessmentType IN (        
        'U','A'         
       ,'I'        
       )        
      THEN [AssessmentsNeeded]        
     ELSE NULL        
     END AS [AssessmentsNeeded]        
    ,CASE         
     WHEN @AssessmentType IN (        
        'U','A'         
       ,'I'        
       )        
      THEN [CommunicationAccomodations]        
     ELSE NULL        
     END AS [CommunicationAccomodations]        
    ,CASE         
     WHEN @AssessmentType IN (        
        'U','A'         
       ,'I'        
       )        
      THEN [IssuesToAvoid]        
     ELSE NULL        
     END AS [IssuesToAvoid]        
    ,CASE         
     WHEN @AssessmentType IN (        
        'U','A'         
       ,'I'        
       )        
      THEN [IssuesToDiscuss]        
     ELSE NULL        
     END AS [IssuesToDiscuss]        
    ,CASE         
     WHEN @AssessmentType IN (        
        'U','A'         
       ,'I'        
       )        
      THEN [SourceOfPrePlanningInfo]        
     ELSE NULL        
     END AS [SourceOfPrePlanningInfo]        
    ,CASE         
     WHEN @AssessmentType IN (        
        'U','A'         
       ,'I'        
       )        
      THEN [SelfDeterminationDesired]        
     ELSE NULL        
     END AS [SelfDeterminationDesired]        
    ,CASE         
     WHEN @AssessmentType IN (        
        'U','A'         
       ,'I'        
       )        
      THEN [FiscalIntermediaryDesired]        
     ELSE NULL        
     END AS [FiscalIntermediaryDesired]        
    ,CASE         
     WHEN @AssessmentType IN (        
        'U','A'         
       ,'I'        
       )        
      THEN [PamphletGiven]        
     ELSE NULL        
     END AS [PamphletGiven]        
    ,CASE         
     WHEN @AssessmentType IN (        
        'U','A'         
       ,'I'        
       )        
      THEN [PamphletDiscussed]        
     ELSE NULL        
     END AS [PamphletDiscussed]        
    ,CASE         
     WHEN @AssessmentType IN (        
        'U','A'         
       ,'I'        
       )        
      THEN [PrePlanIndependentFacilitatorDiscussed]        
     ELSE NULL        
     END AS [PrePlanIndependentFacilitatorDiscussed]        
    ,CASE         
     WHEN @AssessmentType IN (        
        'U','A'         
       ,'I'        
       )        
      THEN [PrePlanIndependentFacilitatorDesired]        
     ELSE NULL        
     END AS [PrePlanIndependentFacilitatorDesired]        
    ,CASE         
     WHEN @AssessmentType IN (        
        'U','A'         
       ,'I'        
       )        
      THEN [PrePlanGuardianContacted]        
     ELSE NULL        
     END AS [PrePlanGuardianContacted]        
    ,CASE         
     WHEN @AssessmentType IN (        
        'U','A'         
       ,'I'       
       )        
      THEN [PrePlanSeparateDocument]        
     ELSE NULL        
     END AS [PrePlanSeparateDocument]        
    ,[CommunityActivitiesCurrentDesired]        
    ,[CommunityActivitiesIncreaseDesired]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [CommunityActivitiesNeedsList]        
     ELSE NULL        
     END AS [CommunityActivitiesNeedsList]        
    ,[PsCurrentHealthIssues]       
    ,[PsCurrentHealthIssuesComment]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [PsCurrentHealthIssuesNeedsList]        
     ELSE NULL        
     END AS [PsCurrentHealthIssuesNeedsList]        
     ,CASE WHEN @AssessmentType IN ( 'U','A' )  THEN PsMedicationsSideEffects ELSE NULL END AS PsMedicationsSideEffects        
    ,[HistMentalHealthTx]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [HistMentalHealthTxNeedsList]        
     ELSE NULL        
     END AS [HistMentalHealthTxNeedsList]        
    ,[HistMentalHealthTxComment]        
    ,[HistFamilyMentalHealthTx]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [HistFamilyMentalHealthTxNeedsList]        
     ELSE NULL        
     END AS [HistFamilyMentalHealthTxNeedsList]        
    ,[HistFamilyMentalHealthTxComment]        
    ,[PsClientAbuseIssues]        
    ,[PsClientAbuesIssuesComment]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [PsClientAbuseIssuesNeedsList]        
     ELSE NULL        
     END AS [PsClientAbuseIssuesNeedsList]        
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
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [PsDevelopmentalMilestonesNeedsList]        
     ELSE NULL        
     END AS [PsDevelopmentalMilestonesNeedsList]        
    ,[PsChildEnvironmentalFactors]        
    ,[PsChildEnvironmentalFactorsComment]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [PsChildEnvironmentalFactorsNeedsList]        
     ELSE NULL        
     END AS [PsChildEnvironmentalFactorsNeedsList]        
    ,[PsLanguageFunctioning]        
    ,[PsLanguageFunctioningComment]    
    ,[PsVisualFunctioning]        
    ,[PsVisualFunctioningComment]        
    ,[PsPrenatalExposure]        
    ,[PsPrenatalExposureComment]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [PsPrenatalExposureNeedsList]        
     ELSE NULL        
     END AS [PsPrenatalExposureNeedsList]        
    ,[PsChildMentalHealthHistory]        
    ,[PsChildMentalHealthHistoryComment]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [PsChildMentalHealthHistoryNeedsList]        
     ELSE NULL        
     END AS [PsChildMentalHealthHistoryNeedsList]        
    ,[PsIntellectualFunctioning]        
    ,[PsIntellectualFunctioningComment]         
    ,[PsLearningAbility]        
    ,[PsLearningAbilityComment]         
    ,[PsFunctioningConcernComment]        
    ,[PsPeerInteraction]        
    ,[PsPeerInteractionComment]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [PsPeerInteractionNeedsList]        
     ELSE NULL        
     END AS [PsPeerInteractionNeedsList]        
     ,case when @SameEpisode='Y' then PsParentalParticipation ELSE NULL end as [PsParentalParticipation]       
      ,case when @SameEpisode='Y' then FamilyRelationshipIssues ELSE NULL end as FamilyRelationshipIssues      
    ,[PsParentalParticipationComment]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [PsParentalParticipationNeedsList]        
     ELSE NULL        
     END AS [PsParentalParticipationNeedsList]        
    ,[PsSchoolHistory]        
    ,[PsSchoolHistoryComment]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [PsSchoolHistoryNeedsList]        
     ELSE NULL        
     END AS [PsSchoolHistoryNeedsList]   
     ,CASE WHEN adultorchild = 'C' THEN [PsImmunizations] ELSE NULL END AS [PsImmunizations]
     ,CASE WHEN adultorchild = 'C' THEN [PsImmunizationsNeedsList] ELSE NULL END AS [PsImmunizationsNeedsList]
    ,[PsImmunizationsComment]         
    ,case when @SameEpisode='Y' then PsChildHousingIssues else null end as [PsChildHousingIssues]        
    ,[PsChildHousingIssuesComment]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [PsChildHousingIssuesNeedsList]        
     ELSE NULL        
     END AS [PsChildHousingIssuesNeedsList]        
    ,CASE WHEN adultorchild = 'C' THEN [PsSexuality]   ELSE NULL END AS     [PsSexuality] 
    , [PsSexualityComment]    
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [PsSexualityNeedsList]        
     ELSE NULL        
     END AS [PsSexualityNeedsList]        
    ,[PsFamilyFunctioning]        
    ,[PsFamilyFunctioningComment]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [PsFamilyFunctioningNeedsList]        
     ELSE NULL        
     END AS [PsFamilyFunctioningNeedsList]        
    ,[PsTraumaticIncident]        
    ,[PsTraumaticIncidentComment]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [PsTraumaticIncidentNeedsList]        
     ELSE NULL        
     END AS [PsTraumaticIncidentNeedsList]        
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
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [PsGrossFineMotorNeedsList]        
     ELSE NULL        
     END AS [PsGrossFineMotorNeedsList]        
    ,[PsSensoryPerceptual]        
    ,[PsSensoryPerceptualComment]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [PsSensoryPerceptualNeedsList]        
     ELSE NULL        
     END AS [PsSensoryPerceptualNeedsList]        
    ,[PsCognitiveFunction]        
    ,[PsCognitiveFunctionComment]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [PsCognitiveFunctionNeedsList]        
     ELSE NULL        
     END AS [PsCognitiveFunctionNeedsList]        
    ,[PsCommunicativeFunction]        
    ,[PsCommunicativeFunctionComment]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [PsCommunicativeFunctionNeedsList]        
     ELSE NULL        
     END AS [PsCommunicativeFunctionNeedsList]        
    ,[PsCurrentPsychoSocialFunctiion]        
    ,[PsCurrentPsychoSocialFunctiionComment]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [PsCurrentPsychoSocialFunctiionNeedsList]        
     ELSE NULL        
     END AS [PsCurrentPsychoSocialFunctiionNeedsList]        
    ,[PsAdaptiveEquipment]        
    ,[PsAdaptiveEquipmentComment]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [PsAdaptiveEquipmentNeedsList]        
     ELSE NULL        
     END AS [PsAdaptiveEquipmentNeedsList]        
    ,[PsSafetyMobilityHome]        
    ,[PsSafetyMobilityHomeComment]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [PsSafetyMobilityHomeNeedsList]        
     ELSE NULL        
     END AS [PsSafetyMobilityHomeNeedsList]        
    ,[PsHealthSafetyChecklistComplete]        
    ,[PsAccessibilityIssues]        
    ,[PsAccessibilityIssuesComment]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [PsAccessibilityIssuesNeedsList]        
     ELSE NULL        
     END AS [PsAccessibilityIssuesNeedsList]        
    ,[PsEvacuationTraining]        
    ,[PsEvacuationTrainingComment]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [PsEvacuationTrainingNeedsList]        
     ELSE NULL        
     END AS [PsEvacuationTrainingNeedsList]        
    ,[Ps24HourSetting]        
    ,[Ps24HourSettingComment]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [Ps24HourSettingNeedsList]        
     ELSE NULL        
     END AS [Ps24HourSettingNeedsList]        
    ,[Ps24HourNeedsAwakeSupervision]        
    ,[PsSpecialEdEligibility]        
    ,[PsSpecialEdEligibilityComment]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [PsSpecialEdEligibilityNeedsList]        
     ELSE NULL        
     END AS [PsSpecialEdEligibilityNeedsList]        
    ,[PsSpecialEdEnrolled]        
    ,[PsSpecialEdEnrolledComment]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [PsSpecialEdEnrolledNeedsList]        
     ELSE NULL        
     END AS [PsSpecialEdEnrolledNeedsList]        
    ,[PsEmployer]        
    ,[PsEmployerComment]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [PsEmployerNeedsList]        
     ELSE NULL        
     END AS [PsEmployerNeedsList]        
    ,[PsEmploymentIssues]        
    ,[PsEmploymentIssuesComment]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [PsEmploymentIssuesNeedsList]        
     ELSE NULL        
     END AS [PsEmploymentIssuesNeedsList]        
    ,[PsRestrictionsOccupational]        
    ,[PsRestrictionsOccupationalComment]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [PsRestrictionsOccupationalNeedsList]        
     ELSE NULL        
     END AS [PsRestrictionsOccupationalNeedsList]        
    ,[PsFunctionalAssessmentNeeded]        
    ,[PsAdvocacyNeeded]        
    ,[PsPlanDevelopmentNeeded]        
    ,[PsLinkingNeeded]        
    ,[PsDDInformationProvidedBy]        
    ,[HistPreviousDx]        
    ,[HistPreviousDxComment]        
    ,[PsLegalIssues]        
    ,[PsLegalIssuesComment]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [PsLegalIssuesNeedsList]        
     ELSE NULL        
     END AS [PsLegalIssuesNeedsList]        
    ,[PsCulturalEthnicIssues]        
    ,[PsCulturalEthnicIssuesComment]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [PsCulturalEthnicIssuesNeedsList]        
     ELSE NULL        
     END AS [PsCulturalEthnicIssuesNeedsList]        
    ,[PsSpiritualityIssues]        
    ,[PsSpiritualityIssuesComment]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [PsSpiritualityIssuesNeedsList]        
     ELSE NULL        
     END AS [PsSpiritualityIssuesNeedsList]        
       
    ,CASE         
     WHEN @AssessmentType IN (        
        'U','A'         
       ,'I'        
       )        
      THEN [SuicideIdeation]        
     ELSE NULL        
     END AS [SuicideIdeation]        
    ,CASE         
     WHEN @AssessmentType IN (        
        'U','A'         
       ,'I'        
       )        
      THEN [SuicideActive]        
     ELSE NULL        
     END AS [SuicideActive]        
    ,CASE         
     WHEN @AssessmentType IN (        
        'U','A'         
       ,'I'        
       )        
      THEN [SuicidePassive]        
     ELSE NULL        
     END AS [SuicidePassive]        
    ,CASE         
     WHEN @AssessmentType IN (        
        'U','A'         
       ,'I'        
       )        
      THEN [SuicideMeans]        
     ELSE NULL        
     END AS [SuicideMeans]        
    ,CASE         
     WHEN @AssessmentType IN (        
        'U','A'         
       ,'I'        
       )        
      THEN [SuicidePlan]        
     ELSE NULL        
     END AS [SuicidePlan]        
         
    ,[SuicideOtherRiskSelf]        
    ,[SuicideOtherRiskSelfComment]      
         
    ,CASE         
     WHEN @AssessmentType IN (        
        'U','A'         
       ,'I'        
       )        
      THEN [HomicideIdeation]        
     ELSE NULL        
     END AS [HomicideIdeation]        
    ,CASE         
     WHEN @AssessmentType IN (        
        'U','A'         
       ,'I'        
       )        
      THEN [HomicideActive]        
     ELSE NULL        
     END AS [HomicideActive]        
    ,CASE         
     WHEN @AssessmentType IN (        
        'U','A'         
       ,'I'        
       )        
      THEN [HomicidePassive]        
     ELSE NULL        
     END AS [HomicidePassive]        
      
    ,CASE         
     WHEN @AssessmentType IN (        
        'U','A'         
       ,'I'        
       )        
      THEN [HomicidePlan]        
     ELSE NULL        
     END AS [HomicidePlan]        
          
    ,[HomicdeOtherRiskOthers]        
    ,[HomicideOtherRiskOthersComment]        
    ,[PhysicalAgressionNotPresent]        
    ,[PhysicalAgressionSelf]        
    ,[PhysicalAgressionOthers]        
    ,[PhysicalAgressionCurrentIssue]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [PhysicalAgressionNeedsList]        
     ELSE NULL        
     END AS [PhysicalAgressionNeedsList]        
    ,[PhysicalAgressionBehaviorsPastHistory]        
    ,[RiskAccessToWeapons]        
    ,[RiskAppropriateForAdditionalScreening]        
    ,[RiskClinicalIntervention]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [RiskOtherFactorsNone]    
	   ELSE NULL        
     END AS    [RiskOtherFactorsNone]
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [RiskOtherFactors] 
	   ELSE NULL        
     END AS    [RiskOtherFactors] 
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [RiskOtherFactorsNeedsList]        
     ELSE NULL        
     END AS [RiskOtherFactorsNeedsList]        
    ,[StaffAxisV]        
    ,[StaffAxisVReason]        
    ,[ClientStrengthsNarrative]        
    ,[CrisisPlanningClientHasPlan]        
    ,[CrisisPlanningNarrative]        
    ,[CrisisPlanningDesired]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [CrisisPlanningNeedsList]        
     ELSE NULL        
     END AS [CrisisPlanningNeedsList]        
    ,[CrisisPlanningMoreInfo]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [AdvanceDirectiveClientHasDirective]  
	  ELSE NULL        
     END AS  [AdvanceDirectiveClientHasDirective]  
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [AdvanceDirectiveDesired]  
	  ELSE NULL        
     END AS AdvanceDirectiveDesired
	,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [AdvanceDirectiveMoreInfo]  
	  ELSE NULL        
     END AS AdvanceDirectiveMoreInfo
	 ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [AdvanceDirectiveNarrative]
	  ELSE NULL        
     END AS [AdvanceDirectiveNarrative]     
    ,[NaturalSupportSufficiency]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [NaturalSupportNeedsList]        
     ELSE NULL        
     END AS [NaturalSupportNeedsList]        
    ,[NaturalSupportIncreaseDesired]   
    ,CASE         
      WHEN @AssessmentType IN ( 'U','A' )      
      THEN [DecreaseSymptomsNeedsList]        
     ELSE NULL        
     END AS [DecreaseSymptomsNeedsList]        
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
    ,CASE         
     WHEN @AssessmentType IN (        
        'U','A'         
       ,'I'        
       )        
      THEN [DischargeCriteria]        
     ELSE NULL        
     END AS [DischargeCriteria]        
    ,CASE         
     WHEN @AssessmentType IN (        
        'U','A'         
       ,'I'        
       )        
      THEN [PrePlanFiscalIntermediaryComment]        
     ELSE NULL        
     END AS [PrePlanFiscalIntermediaryComment]  
    ,[PsEducation]        
       
    ,CASE         
     WHEN @AssessmentType IN (        
        'U','A'         
       ,'I'        
       )        
      THEN [PsMedications]        
     ELSE NULL        
     END AS [PsMedications]        
    ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN [PsMedicationsNeedsList]        
     ELSE NULL        
     END AS [PsMedicationsNeedsList]     
     ,CASE         
     WHEN @AssessmentType IN ( 'U','A' )      
      THEN CommunicableDiseaseRecommendation  ELSE NULL        
     END AS  CommunicableDiseaseRecommendation
    --,CASE         
    -- WHEN @AssessmentType IN (        
    --    'U','A'         
    --   ,'I'        
    --   )        
    --  THEN [PsMedicationsListToBeModified]        
    -- ELSE NULL        
    -- END AS [PsMedicationsListToBeModified]        
    ,[PhysicalConditionQuadriplegic]        
    ,[PhysicalConditionMultipleSclerosis]        
    ,[PhysicalConditionBlindness]        
    ,[PhysicalConditionDeafness]        
    ,[PhysicalConditionParaplegic]        
    ,[PhysicalConditionCerebral]        
    ,[PhysicalConditionMuteness]        
    ,[PhysicalConditionOtherHearingImpairment]        
    ,[TestingReportsReviewed]        
    ,[LOCId]        
    ,[PreplanSeparateDocument]   
    ,CASE           
     WHEN @AssessmentType IN ('I')          
      THEN [SevereProfoundDisability]          
     ELSE NULL          
     END AS [SevereProfoundDisability]        
    ,SevereProfoundDisabilityComment        
    ,CASE WHEN @EmpStatus IS NOT NULL THEN @EmpStatus ELSE NULL END AS EmploymentStatus        
    ,@CafasURL AS CafasURL        
     
    ,'' AS [CreatedBy]        
    ,getdate() AS [CreatedDate]        
    ,'' AS [ModifiedBy]        
    ,getdate() AS [ModifiedDate]        
    ,CHA.[RecordDeleted]        
    ,CHA.[DeletedDate]        
    ,CHA.[DeletedBy]        
    ,@AxisIAxisIIOut AS AxisIAxisII        
    ,@clientAge AS clientAge        
    ,CASE WHEN @INQUIRYDATE IS NOT NULL THEN @INQUIRYDATE ELSE NULL END AS InitialRequestDate        
    ,@ExistLatestSignedDocumentVersion AS ExistLatestSignedDocumentVersion        
    
 ,@LegalIssues AS [LegalIssues]      
 ,CASE WHEN  @AssessmentType IN (  'U','A' )  THEN Strengths ELSE NULL END AS [Strengths]      
 ,CASE WHEN  @AssessmentType IN (  'U','A' )  THEN TransitionLevelOfCare ELSE NULL END AS [TransitionLevelOfCare]       
     
   FROM CustomDocumentMHAssessments CHA        
  left join GlobalCodes GC on GC.GlobalCodeId= @GuardianRelationship 
  --left join GlobalCodes GC1 on GC1.GlobalCodeId= @GuardianState      
   WHERE (ISNULL(CHA.RecordDeleted, 'N') = 'N')        
    AND (CHA.DocumentVersionId = @LatestDocumentVersionID)        
   -- AND IsNull(G.RecordDeleted, 'N') = 'N'        

	           
   SELECT 'CustomDocumentMHCRAFFTs' AS TableName        
    , -1 AS [DocumentVersionId]
    ,'' AS [CreatedBy] ,    
    GETDATE() AS [CreatedDate] ,    
    '' AS [ModifiedBy] ,    
    GETDATE() AS [ModifiedDate]       
    ,CDC.RecordDeleted        
    ,CDC.DeletedBy        
    ,CDC.DeletedDate        
    ,CrafftApplicable        
    ,CrafftApplicableReason        
    ,CrafftQuestionC        
    ,CrafftQuestionR        
    ,CrafftQuestionA        
    ,CrafftQuestionF        
    ,CrafftQuestionFR        
    ,CrafftQuestionT        
    ,CrafftCompleteFullSUAssessment        
    ,CrafftStageOfChange        
   FROM SystemConfigurations AS s        
   LEFT OUTER JOIN CustomDocumentMHCRAFFTs CDC ON s.DatabaseVersion = - 1        
   
    ---CustomDailyLivingActivityScores---          
  SELECT 'CustomDailyLivingActivityScores' AS TableName        
   ,DailyLivingActivityScoreId        
   ,[DocumentVersionId]        
   ,[HRMActivityId]        
   ,[ActivityScore]        
   ,[ActivityComment]        
   ,[RowIdentifier]        
    ,'' AS [CreatedBy] ,    
     GETDATE() AS [CreatedDate] ,    
     '' AS [ModifiedBy] ,    
     GETDATE() AS [ModifiedDate]          
   ,CDL.[RecordDeleted]        
   ,CDL.[DeletedDate]        
   ,CDL.[DeletedBy]        
  FROM CustomDailyLivingActivityScores CDL        
  WHERE CDL.DocumentVersionId = @LatestDocumentVersionId       
   AND ISNULL(CDL.RecordDeleted, 'N') = 'N'      
  
  SELECT 'CustomSubstanceUseAssessments' AS TableName        
    ,- 1 AS [DocumentVersionId]        
     ,CASE WHEN @AssessmentType IN ('U','A') THEN [VoluntaryAbstinenceTrial] ELSE NULL END AS [VoluntaryAbstinenceTrial]
	 ,CASE WHEN @AssessmentType IN ('U','A') THEN [PreviousTreatment]  ELSE NULL END AS [PreviousTreatment]
	 ,CASE WHEN @AssessmentType IN ('U','A') THEN CurrentSubstanceAbuseTreatment ELSE NULL END AS CurrentSubstanceAbuseTreatment
	 ,CASE WHEN @AssessmentType IN ('U','A') THEN PreviousMedication ELSE NULL END AS PreviousMedication
	 ,CASE WHEN @AssessmentType IN ('U','A') THEN CurrentSubstanceAbuseMedication ELSE NULL END AS CurrentSubstanceAbuseMedication
	 ,CASE WHEN @AssessmentType IN ('U','A') THEN CurrentTreatmentProvider ELSE NULL END AS CurrentTreatmentProvider
	 ,CASE WHEN @AssessmentType IN ('U','A') THEN CurrentSubstanceAbuseReferralToSAorTx ELSE NULL END AS CurrentSubstanceAbuseReferralToSAorTx
	 ,CASE WHEN @AssessmentType IN ('U','A') THEN CurrentSubstanceAbuseRefferedReason ELSE NULL END AS CurrentSubstanceAbuseRefferedReason
	 ,CASE WHEN @AssessmentType IN ('U','A') THEN MedicationAssistedTreatment ELSE NULL END AS MedicationAssistedTreatment
	 ,CASE WHEN @AssessmentType IN ('U','A') THEN MedicationAssistedTreatmentRefferedReason ELSE NULL END AS MedicationAssistedTreatmentRefferedReason
	 ,CASE WHEN @AssessmentType IN ('U','A') THEN RiskOfRelapse ELSE NULL END AS RiskOfRelapse
     ,CASE         
      WHEN @AssessmentType IN (        
         'U'      
        )        
       THEN [SubstanceAbuseAdmittedOrSuspected]        
      ELSE NULL        
      END AS [SubstanceAbuseAdmittedOrSuspected]        
     ,CASE         
      WHEN @AssessmentType IN (        
         'U'       
        )        
       THEN [ClientSAHistory]        
      ELSE NULL        
      END AS [ClientSAHistory]        
     ,CASE WHEN @AssessmentType IN ('U') THEN [FamilySAHistory]  ELSE NULL END AS [FamilySAHistory]      
	 ,CASE WHEN @AssessmentType IN ('U')  THEN [CurrentSubstanceAbuse]  ELSE NULL END AS [CurrentSubstanceAbuse]        
     ,CASE WHEN @AssessmentType IN ('U')  THEN [SuspectedSubstanceAbuse] ELSE NULL END AS [SuspectedSubstanceAbuse]
	 ,CASE WHEN @AssessmentType IN ('U','A')  THEN [SubstanceAbuseDetail]  ELSE NULL  END AS [SubstanceAbuseDetail]  
	 ,CASE WHEN @AssessmentType IN ('U') THEN [OdorOfSubstance]   ELSE NULL  END AS [OdorOfSubstance]        
     ,CASE WHEN @AssessmentType IN ('U') THEN [SlurredSpeech]  ELSE NULL END AS [SlurredSpeech]        
     ,CASE WHEN @AssessmentType IN ('U')  THEN [WithdrawalSymptoms] ELSE NULL END AS [WithdrawalSymptoms] 
	 ,CASE WHEN @AssessmentType IN ('U')  THEN [IncreasedTolerance]  ELSE NULL END AS [IncreasedTolerance]
	 ,CASE WHEN @AssessmentType IN ('U')  THEN [Blackouts] ELSE NULL  END AS [Blackouts]    
	 ,CASE WHEN @AssessmentType IN ('U')  THEN [LossOfControl]  ELSE NULL END AS [LossOfControl]  
	 ,CASE WHEN @AssessmentType IN ('U')  THEN [RelatedArrests]ELSE NULL   END AS [RelatedArrests] 
	 ,CASE WHEN @AssessmentType IN ('U')  THEN [RelatedSocialProblems]  ELSE NULL   END AS [RelatedSocialProblems]  
	 ,CASE WHEN @AssessmentType IN ('U')  THEN [FrequentJobSchoolAbsence] ELSE NULL  END AS [FrequentJobSchoolAbsence]  
	 ,CASE WHEN @AssessmentType IN ('U')  THEN [NoneSynptomsReportedOrObserved] ELSE NULL  END AS [NoneSynptomsReportedOrObserved]     
     ,CASE WHEN @AssessmentType IN ('U')  THEN [DTOther] ELSE NULL END AS [DTOther]        
     ,CASE WHEN @AssessmentType IN ('U')  THEN [DTOtherText]  ELSE NULL  END AS [DTOtherText]        
     ,CASE WHEN @AssessmentType IN ('U')  THEN [NoSubstanceAbuseSuspected]  ELSE NULL   END AS [NoSubstanceAbuseSuspected]  
	 ,CASE WHEN @AssessmentType IN ('U')  THEN [DUI30Days] ELSE  NULL END AS  [DUI30Days]        
     ,CASE WHEN @AssessmentType IN ('U')  THEN  [DUI5Years] ELSE NULL END AS [DUI5Years]        
     ,CASE WHEN @AssessmentType IN ('U')  THEN  [DWI30Days] ELSE NULL END AS [DWI30Days]        
     ,CASE WHEN @AssessmentType IN ('U')  THEN  [DWI5Years] ELSE NULL END AS [DWI5Years]        
     ,CASE WHEN @AssessmentType IN ('U')  THEN [Possession30Days] ELSE NULL END AS [Possession30Days]        
     ,CASE WHEN @AssessmentType IN ('U')  THEN [Possession5Years]  ELSE NULL END AS [Possession5Years]        
     ,CASE WHEN @AssessmentType IN ('U')THEN [Comment]  ELSE NULL  END AS  [Comment]  
     ,[RowIdentifier]  
     ,'' AS [CreatedBy] ,    
     GETDATE() AS [CreatedDate] ,    
     '' AS [ModifiedBy] ,    
     GETDATE() AS [ModifiedDate]       
     ,[RecordDeleted]        
     ,[DeletedDate]        
     ,[DeletedBy]      
   FROM CustomSubstanceUseAssessments CSUA        
   WHERE CSUA.DocumentVersionId = @LatestDocumentVersionID        
     AND IsNull(RecordDeleted, 'N') = 'N'   
	 
   SELECT 'CustomSubstanceUseHistory2' AS TableName     
   ,'' AS [CreatedBy] ,    
     GETDATE() AS [CreatedDate] ,    
     '' AS [ModifiedBy] ,    
     GETDATE() AS [ModifiedDate]       
     ,[RecordDeleted]        
     ,[DeletedDate]        
     ,[DeletedBy]        
    ,- 1 AS DocumentVersionId      
    ,SUDrugId      
   ,AgeOfFirstUse      
   ,Frequency      
   ,Route      
  ,LastUsed      
   ,InitiallyPrescribed      
   ,Preference      
  ,FamilyHistory
  ,RowIdentifier      
  FROM CustomSubstanceUseHistory2 CSUA        
   WHERE CSUA.DocumentVersionId = @LatestDocumentVersionID        
     AND IsNull(RecordDeleted, 'N') = 'N'   
	 
   SELECT 'CustomDocumentMHAssessmentCAFASs' AS TableName        
    ,- 1 AS 'DocumentVersionId'        
    ,[CAFASDate]        
    ,[RaterClinician]        
    ,[CAFASInterval]        
    ,0 AS [SchoolPerformance]        
    ,[SchoolPerformanceComment]        
    ,0 AS [HomePerformance]        
    ,[HomePerfomanceComment]        
    ,0 AS [CommunityPerformance]        
    ,[CommunityPerformanceComment]        
    ,0 AS [BehaviorTowardsOther]        
    ,[BehaviorTowardsOtherComment]        
    ,0 AS [MoodsEmotion]        
    ,[MoodsEmotionComment]        
    ,0 AS [SelfHarmfulBehavior]        
    ,[SelfHarmfulBehaviorComment]        
    ,0 AS [SubstanceUse]        
    ,[SubstanceUseComment]        
    ,0 AS [Thinkng]        
    ,[ThinkngComment]        
    ,[YouthTotalScore]        
    ,0 AS [PrimaryFamilyMaterialNeeds]        
    ,[PrimaryFamilyMaterialNeedsComment]        
    ,0 AS [PrimaryFamilySocialSupport]        
    ,[PrimaryFamilySocialSupportComment]        
    ,0 AS [NonCustodialMaterialNeeds]        
    ,[NonCustodialMaterialNeedsComment]        
    ,0 AS [NonCustodialSocialSupport]        
    ,[NonCustodialSocialSupportComment]        
    ,0 AS [SurrogateMaterialNeeds]        
    ,[SurrogateMaterialNeedsComment]        
    ,0 AS [SurrogateSocialSupport]        
    ,[SurrogateSocialSupportComment]        
    ,'' as [CreatedBy]       
    ,getdate() as [CreatedDate]      
    ,'' as [ModifiedBy]     
    ,getdate() as [ModifiedDate]      
    ,CC2.[RecordDeleted]        
    ,CC2.[DeletedDate]        
    ,CC2.[DeletedBy]        
   FROM CustomDocumentMHAssessmentCAFASs CC2        
   WHERE CC2.DocumentVersionId = @LatestScreeenTypeDocumentVersionId        
   
     -- CustomMHAssessmentSupports--                     
     
  SELECT 'CustomMHAssessmentSupports' AS TableName 
   ,- 1 AS 'DocumentVersionId'  
   ,0 as MHAssessmentSupportId      
   ,[SupportDescription]        
   ,[Current]        
   ,[PaidSupport]        
   ,[UnpaidSupport]        
   ,[ClinicallyRecommended]        
   ,[CustomerDesired]   
    ,'' as [CreatedBy]       
    ,getdate() as [CreatedDate]      
    ,'' as [ModifiedBy]     
    ,getdate() as [ModifiedDate]        
   ,[RecordDeleted]        
   ,[DeletedDate]        
   ,[DeletedBy]        
  FROM SystemConfigurations AS s        
  LEFT JOIN CustomMHAssessmentSupports CS2 ON s.DatabaseVersion = - 1        
   
      -- CustomDocumentMentalStatusExams--                                                                           
   SELECT 'CustomDocumentMentalStatusExams' AS TableName
		,- 1 AS DocumentVersionId
		,'' AS CreatedBy
		,GETDATE() AS CreatedDate
		,'' AS ModifiedBy
		,GETDATE() AS ModifiedDate
		,CASE WHEN @SameEpisode = 'Y' THEN GeneralAppearance ELSE NULL 
		 END AS GeneralAppearance 
		,CASE WHEN @SameEpisode = 'Y' THEN GeneralPoorlyAddresses ELSE NULL 
		 END AS GeneralPoorlyAddresses  
		,CASE WHEN @SameEpisode = 'Y' THEN GeneralPoorlyGroomed ELSE NULL 
		 END AS GeneralPoorlyGroomed 
		 ,CASE WHEN @SameEpisode = 'Y' THEN GeneralDisheveled ELSE NULL 
		 END AS GeneralDisheveled 
		  ,CASE WHEN @SameEpisode = 'Y' THEN GeneralOdferous ELSE NULL 
		 END AS GeneralOdferous 			
		 ,CASE WHEN @SameEpisode = 'Y' THEN GeneralDeformities ELSE NULL 
		 END AS GeneralDeformities 
		  ,CASE WHEN @SameEpisode = 'Y' THEN GeneralPoorNutrion ELSE NULL 
		 END AS GeneralPoorNutrion
		 ,CASE WHEN @SameEpisode = 'Y' THEN GeneralRestless ELSE NULL 
		 END AS GeneralRestless
		  ,CASE WHEN @SameEpisode = 'Y' THEN GeneralPsychometer ELSE NULL 
		 END AS GeneralPsychometer
		 ,CASE WHEN @SameEpisode = 'Y' THEN GeneralHyperActive ELSE NULL 
		 END AS GeneralHyperActive
		 ,CASE WHEN @SameEpisode = 'Y' THEN GeneralEvasive ELSE NULL 
		 END AS GeneralEvasive
		 ,CASE WHEN @SameEpisode = 'Y' THEN GeneralInAttentive ELSE NULL 
		 END AS GeneralInAttentive
		 ,CASE WHEN @SameEpisode = 'Y' THEN GeneralPoorEyeContact ELSE NULL 
		 END AS GeneralPoorEyeContact
		  ,CASE WHEN @SameEpisode = 'Y' THEN GeneralHostile ELSE NULL 
		 END AS GeneralHostile
		  ,CASE WHEN @SameEpisode = 'Y' THEN GeneralAppearanceOthers ELSE NULL 
		 END AS GeneralAppearanceOthers
		,GeneralAppearanceOtherComments
		  ,CASE WHEN @SameEpisode = 'Y' THEN Speech ELSE NULL 
		 END AS Speech
		 ,CASE WHEN @SameEpisode = 'Y' THEN SpeechIncreased ELSE NULL 
		 END AS SpeechIncreased
		  ,CASE WHEN @SameEpisode = 'Y' THEN SpeechDecreased ELSE NULL 
		 END AS SpeechDecreased
		 ,CASE WHEN @SameEpisode = 'Y' THEN SpeechPaucity ELSE NULL 
		 END AS SpeechPaucity
		  ,CASE WHEN @SameEpisode = 'Y' THEN SpeechHyperverbal ELSE NULL 
		 END AS SpeechHyperverbal
		  ,CASE WHEN @SameEpisode = 'Y' THEN SpeechPoorArticulations ELSE NULL 
		 END AS SpeechPoorArticulations	
		  ,CASE WHEN @SameEpisode = 'Y' THEN SpeechLoud ELSE NULL 
		 END AS SpeechLoud
		  ,CASE WHEN @SameEpisode = 'Y' THEN SpeechSoft ELSE NULL 
		 END AS SpeechSoft	
		   ,CASE WHEN @SameEpisode = 'Y' THEN SpeechMute ELSE NULL 
		 END AS SpeechMute	
		  ,CASE WHEN @SameEpisode = 'Y' THEN SpeechStuttering ELSE NULL 
		 END AS SpeechStuttering
		 ,CASE WHEN @SameEpisode = 'Y' THEN SpeechImpaired ELSE NULL 
		 END AS SpeechImpaired	
		  ,CASE WHEN @SameEpisode = 'Y' THEN SpeechPressured ELSE NULL 
		 END AS SpeechPressured	
		  ,CASE WHEN @SameEpisode = 'Y' THEN SpeechFlight ELSE NULL 
		 END AS SpeechFlight
		   ,CASE WHEN @SameEpisode = 'Y' THEN SpeechOthers ELSE NULL 
		 END AS SpeechOthers			
		,SpeechOtherComments
		 ,CASE WHEN @SameEpisode = 'Y' THEN PsychiatricNoteExamLanguage ELSE NULL 
		 END AS PsychiatricNoteExamLanguage
		  ,CASE WHEN @SameEpisode = 'Y' THEN LanguageDifficultyNaming ELSE NULL 
		 END AS LanguageDifficultyNaming
		  ,CASE WHEN @SameEpisode = 'Y' THEN LanguageDifficultyRepeating ELSE NULL 
		 END AS LanguageDifficultyRepeating
		 ,CASE WHEN @SameEpisode = 'Y' THEN LanguageNonVerbal ELSE NULL 
		 END AS LanguageNonVerbal
		  ,CASE WHEN @SameEpisode = 'Y' THEN LanguageOthers ELSE NULL 
		 END AS LanguageOthers
		,LanguageOtherComments
		 ,CASE WHEN @SameEpisode = 'Y' THEN MoodAndAffect ELSE NULL 
		 END AS MoodAndAffect
		  ,CASE WHEN @SameEpisode = 'Y' THEN MoodHappy ELSE NULL 
		 END AS MoodHappy
		  ,CASE WHEN @SameEpisode = 'Y' THEN MoodSad ELSE NULL 
		 END AS MoodSad
		  ,CASE WHEN @SameEpisode = 'Y' THEN MoodAnxious ELSE NULL 
		 END AS MoodAnxious
		  ,CASE WHEN @SameEpisode = 'Y' THEN MoodAngry ELSE NULL 
		 END AS MoodAngry
		  ,CASE WHEN @SameEpisode = 'Y' THEN MoodIrritable ELSE NULL 
		 END AS MoodIrritable
		   ,CASE WHEN @SameEpisode = 'Y' THEN MoodElation ELSE NULL 
		 END AS MoodElation
		    ,CASE WHEN @SameEpisode = 'Y' THEN MoodNormal ELSE NULL 
		 END AS MoodNormal
		   ,CASE WHEN @SameEpisode = 'Y' THEN MoodOthers ELSE NULL 
		 END AS MoodOthers
		,MoodOtherComments
		,AffectEuthymic
		 ,CASE WHEN @SameEpisode = 'Y' THEN AffectDysphoric ELSE NULL 
		 END AS AffectDysphoric
		 ,CASE WHEN @SameEpisode = 'Y' THEN AffectAnxious ELSE NULL 
		 END AS AffectAnxious
		  ,CASE WHEN @SameEpisode = 'Y' THEN AffectIrritable ELSE NULL 
		 END AS AffectIrritable
		 ,CASE WHEN @SameEpisode = 'Y' THEN AffectBlunted ELSE NULL 
		 END AS AffectBlunted
		  ,CASE WHEN @SameEpisode = 'Y' THEN AffectLabile ELSE NULL 
		 END AS AffectLabile
		   ,CASE WHEN @SameEpisode = 'Y' THEN AffectEuphoric ELSE NULL 
		 END AS AffectEuphoric
		  ,CASE WHEN @SameEpisode = 'Y' THEN AffectCongruent ELSE NULL 
		 END AS AffectCongruent	
		 ,CASE WHEN @SameEpisode = 'Y' THEN AffectOthers ELSE NULL 
		 END AS AffectOthers		
		,AffectOtherComments
		 ,CASE WHEN @SameEpisode = 'Y' THEN AttensionSpanAndConcentration ELSE NULL 
		 END AS AttensionSpanAndConcentration
		  ,CASE WHEN @SameEpisode = 'Y' THEN AttensionPoorConcentration ELSE NULL 
		 END AS AttensionPoorConcentration
		  ,CASE WHEN @SameEpisode = 'Y' THEN AttensionPoorAttension ELSE NULL 
		 END AS AttensionPoorAttension
		 ,CASE WHEN @SameEpisode = 'Y' THEN AttensionDistractible ELSE NULL 
		 END AS AttensionDistractible
		  ,CASE WHEN @SameEpisode = 'Y' THEN AttentionSpanOthers ELSE NULL 
		 END AS AttentionSpanOthers
		,AttentionSpanOtherComments
		,CASE WHEN @SameEpisode = 'Y' THEN ThoughtContentCognision ELSE NULL 
		 END AS ThoughtContentCognision
		 ,CASE WHEN @SameEpisode = 'Y' THEN TPDisOrganised ELSE NULL 
		 END AS TPDisOrganised
		  ,CASE WHEN @SameEpisode = 'Y' THEN TPBlocking ELSE NULL 
		 END AS TPBlocking
		  ,CASE WHEN @SameEpisode = 'Y' THEN TPPersecution ELSE NULL 
		 END AS TPPersecution
		  ,CASE WHEN @SameEpisode = 'Y' THEN TPBroadCasting ELSE NULL 
		 END AS TPBroadCasting
		  ,CASE WHEN @SameEpisode = 'Y' THEN TPDetrailed ELSE NULL 
		 END AS TPDetrailed	
		   ,CASE WHEN @SameEpisode = 'Y' THEN TPThoughtInsertion ELSE NULL 
		 END AS TPThoughtInsertion	
		   ,CASE WHEN @SameEpisode = 'Y' THEN TPIncoherent ELSE NULL 
		 END AS TPIncoherent
		  ,CASE WHEN @SameEpisode = 'Y' THEN TPRacing ELSE NULL 
		 END AS TPRacing		
		,CASE WHEN @SameEpisode = 'Y' THEN TPIllogical ELSE NULL 
		 END AS TPIllogical
		 ,CASE WHEN @SameEpisode = 'Y' THEN ThoughtProcessOthers ELSE NULL 
		 END AS ThoughtProcessOthers
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
		 ,CASE WHEN @SameEpisode = 'Y' THEN CAConcrete ELSE NULL 
		 END AS CAConcrete
		  ,CASE WHEN @SameEpisode = 'Y' THEN CAUnable ELSE NULL 
		 END AS CAUnable
		 ,CASE WHEN @SameEpisode = 'Y' THEN CAPoorComputation ELSE NULL 
		 END AS CAPoorComputation
		  ,CASE WHEN @SameEpisode = 'Y' THEN CognitiveAbnormalitiesOthers ELSE NULL 
		 END AS CognitiveAbnormalitiesOthers
		
		,CognitiveAbnormalitiesOtherComments
		 ,CASE WHEN @SameEpisode = 'Y' THEN Associations ELSE NULL 
		 END AS Associations
		  ,CASE WHEN @SameEpisode = 'Y' THEN AssociationsLoose ELSE NULL 
		 END AS AssociationsLoose
		  ,CASE WHEN @SameEpisode = 'Y' THEN AssociationsWordsalad ELSE NULL 
		 END AS AssociationsWordsalad
		   ,CASE WHEN @SameEpisode = 'Y' THEN AssociationsClanging ELSE NULL 
		 END AS AssociationsClanging
		,CASE WHEN @SameEpisode = 'Y' THEN AssociationsCircumstantial ELSE NULL 
		 END AS AssociationsCircumstantial
		  ,CASE WHEN @SameEpisode = 'Y' THEN AssociationsTangential ELSE NULL 
		 END AS AssociationsTangential
		,AssociationsTangential
		 ,CASE WHEN @SameEpisode = 'Y' THEN AssociationsOthers ELSE NULL 
		 END AS AssociationsOthers
		,AssociationsOtherComments
		,CASE WHEN @SameEpisode = 'Y' THEN AbnormalorPsychoticThoughts ELSE NULL 
		 END AS AbnormalorPsychoticThoughts
		 ,CASE WHEN @SameEpisode = 'Y' THEN PsychosisOrDisturbanceOfPerception ELSE NULL 
		 END AS PsychosisOrDisturbanceOfPerception
		--,'A' as AbnormalorPsychoticThoughts
		--,'N' as PsychosisOrDisturbanceOfPerception
		 ,CASE WHEN @SameEpisode = 'Y' THEN PDAuditoryHallucinations ELSE NULL 
		 END AS PDAuditoryHallucinations
		 ,CASE WHEN @SameEpisode = 'Y' THEN PDVisualHallucinations ELSE NULL 
		 END AS PDVisualHallucinations
		  ,CASE WHEN @SameEpisode = 'Y' THEN PDCommandHallucinations ELSE NULL 
		 END AS PDCommandHallucinations
		 ,CASE WHEN @SameEpisode = 'Y' THEN PDDelusions ELSE NULL 
		 END AS PDDelusions
		  ,CASE WHEN @SameEpisode = 'Y' THEN PDPreoccupation ELSE NULL 
		 END AS PDPreoccupation
		  ,CASE WHEN @SameEpisode = 'Y' THEN PDOlfactoryHallucinations ELSE NULL 
		 END AS PDOlfactoryHallucinations
		  ,CASE WHEN @SameEpisode = 'Y' THEN PDGustatoryHallucinations ELSE NULL 
		 END AS PDGustatoryHallucinations
		  ,CASE WHEN @SameEpisode = 'Y' THEN PDTactileHallucinations ELSE NULL 
		 END AS PDTactileHallucinations
		 ,CASE WHEN @SameEpisode = 'Y' THEN PDSomaticHallucinations ELSE NULL 
		 END AS PDSomaticHallucinations
		,CASE WHEN @SameEpisode = 'Y' THEN PDIllusions ELSE NULL 
		 END AS PDIllusions
		 ,CASE WHEN @SameEpisode = 'Y' THEN AbnormalPsychoticOthers ELSE NULL 
		 END AS AbnormalPsychoticOthers
		,AbnormalPsychoticOthersComments
		 ,CASE WHEN @SameEpisode = 'Y' THEN PDCurrentSuicideIdeation ELSE NULL 
		 END AS PDCurrentSuicideIdeation
		  ,CASE WHEN @SameEpisode = 'Y' THEN PDCurrentSuicidalIntent ELSE NULL 
		 END AS PDCurrentSuicidalIntent
		,PDCurrentSuicideIdeation
		,CASE WHEN @SameEpisode = 'Y' THEN PDCurrentSuicidalPlan ELSE NULL 
		 END AS PDCurrentSuicidalPlan
		,PDCurrentSuicidalIntent
		,CASE WHEN @SameEpisode = 'Y' THEN PDMeansToCarry ELSE NULL 
		 END AS PDMeansToCarry
		,CASE WHEN @SameEpisode = 'Y' THEN PDCurrentHomicidalIdeation ELSE NULL 
		 END AS PDCurrentHomicidalIdeation
		 ,CASE WHEN @SameEpisode = 'Y' THEN PDCurrentHomicidalIntent ELSE NULL 
		 END AS PDCurrentHomicidalIntent
		 ,CASE WHEN @SameEpisode = 'Y' THEN PDCurrentHomicidalPlans ELSE NULL 
		 END AS PDCurrentHomicidalPlans
		,CASE WHEN @SameEpisode = 'Y' THEN PDMeansToCarryNew ELSE NULL 
		 END AS PDMeansToCarryNew
		 ,CASE WHEN @SameEpisode = 'Y' THEN Orientation ELSE NULL 
		 END AS Orientation
		 ,CASE WHEN @SameEpisode = 'Y' THEN OrientationPerson ELSE NULL 
		 END AS OrientationPerson
		  ,CASE WHEN @SameEpisode = 'Y' THEN OrientationPlace ELSE NULL 
		 END AS OrientationPlace
		  ,CASE WHEN @SameEpisode = 'Y' THEN OrientationTime ELSE NULL 
		 END AS OrientationTime
		  ,CASE WHEN @SameEpisode = 'Y' THEN OrientationSituation ELSE NULL 
		 END AS OrientationSituation
		 ,CASE WHEN @SameEpisode = 'Y' THEN OrientationOthers ELSE NULL 
		 END AS OrientationOthers
		,OrientationOtherComments
		,CASE WHEN @SameEpisode = 'Y' THEN FundOfKnowledge ELSE NULL 
		 END AS FundOfKnowledge
		 ,CASE WHEN @SameEpisode = 'Y' THEN FundOfKnowledgeCurrentEvents ELSE NULL 
		 END AS FundOfKnowledgeCurrentEvents
		 ,CASE WHEN @SameEpisode = 'Y' THEN FundOfKnowledgePastHistory ELSE NULL 
		 END AS FundOfKnowledgePastHistory
		  ,CASE WHEN @SameEpisode = 'Y' THEN FundOfKnowledgeVocabulary ELSE NULL 
		 END AS FundOfKnowledgeVocabulary
		 ,CASE WHEN @SameEpisode = 'Y' THEN FundOfKnowledgeOthers ELSE NULL 
		 END AS FundOfKnowledgeOthers
		,FundOfKnowledgeOtherComments
		,CASE WHEN @SameEpisode = 'Y' THEN InsightAndJudgement ELSE NULL 
		 END AS InsightAndJudgement
		 ,CASE WHEN @SameEpisode = 'Y' THEN InsightAndJudgementStatus ELSE NULL 
		 END AS InsightAndJudgementStatus
		,InsightAndJudgementSubstance
		,CASE WHEN @SameEpisode = 'Y' THEN InsightAndJudgementOthers ELSE NULL 
		 END AS InsightAndJudgementOthers
		,InsightAndJudgementOtherComments
		,CASE WHEN @SameEpisode = 'Y' THEN Memory ELSE NULL 
		 END AS Memory
		 ,CASE WHEN @SameEpisode = 'Y' THEN MemoryImmediate ELSE NULL 
		 END AS MemoryImmediate
		 ,CASE WHEN @SameEpisode = 'Y' THEN MemoryRecent ELSE NULL 
		 END AS MemoryRecent
		  ,CASE WHEN @SameEpisode = 'Y' THEN MemoryRemote ELSE NULL 
		 END AS MemoryRemote
		 ,CASE WHEN @SameEpisode = 'Y' THEN MemoryOthers ELSE NULL 
		 END AS MemoryOthers
		,MemoryOtherComments
		,CASE WHEN @SameEpisode = 'Y' THEN MuscleStrengthorTone ELSE NULL 
		 END AS MuscleStrengthorTone
		 ,CASE WHEN @SameEpisode = 'Y' THEN MuscleStrengthorToneAtrophy ELSE NULL 
		 END AS MuscleStrengthorToneAtrophy
		  ,CASE WHEN @SameEpisode = 'Y' THEN MuscleStrengthorToneAbnormal ELSE NULL 
		 END AS MuscleStrengthorToneAbnormal
		 ,CASE WHEN @SameEpisode = 'Y' THEN MuscleStrengthOthers ELSE NULL 
		 END AS MuscleStrengthOthers
		,MuscleStrengthOtherComments
		,CASE WHEN @SameEpisode = 'Y' THEN GaitandStation ELSE NULL 
		 END AS GaitandStation
		 ,CASE WHEN @SameEpisode = 'Y' THEN GaitandStationRestlessness ELSE NULL 
		 END AS GaitandStationRestlessness
		 ,CASE WHEN @SameEpisode = 'Y' THEN GaitandStationStaggered ELSE NULL 
		 END AS GaitandStationStaggered
		  ,CASE WHEN @SameEpisode = 'Y' THEN GaitandStationShuffling ELSE NULL 
		 END AS GaitandStationShuffling
		  ,CASE WHEN @SameEpisode = 'Y' THEN GaitandStationUnstable ELSE NULL 
		 END AS GaitandStationUnstable
		  ,CASE WHEN @SameEpisode = 'Y' THEN GaitAndStationOthers ELSE NULL 
		 END AS GaitAndStationOthers
		,GaitAndStationOtherComments
		 ,CASE WHEN @SameEpisode = 'Y' THEN MentalStatusComments ELSE NULL 
		 END AS MentalStatusComments
		--,ReviewWithChanges
		FROM systemconfigurations s
		LEFT JOIN CustomDocumentMentalStatusExams CMS ON CMS.DocumentVersionId = @LatestDocumentVersionID      
   
      --- CustomDispositions            
   SELECT 'CustomDispositions' AS TableName        
    ,- 1 AS CustomDispositionId        
   ,'' AS [CreatedBy] ,    
     GETDATE() AS [CreatedDate] ,    
     '' AS [ModifiedBy] ,    
     GETDATE() AS [ModifiedDate]        
    ,CD.RecordDeleted        
    ,CD.DeletedBy        
    ,CD.DeletedDate        
    ,InquiryId        
     ,- 1 AS DocumentVersionId        
    ,CASE WHEN  @SameEpisode='Y' THEN Disposition ELSE NULL END AS Disposition        
   FROM CustomDispositions CD        
   WHERE CD.DocumentVersionId = @LatestScreeenTypeDocumentVersionId  AND ISNULL(CD.RecordDeleted, 'N') = 'N'      
         
        
   --- CustomServiceDispositions            
   SELECT 'CustomServiceDispositions' AS TableName        
    ,- 1 AS CustomServiceDispositionId        
   ,'' AS [CreatedBy] ,    
     GETDATE() AS [CreatedDate] ,    
     '' AS [ModifiedBy] ,    
     GETDATE() AS [ModifiedDate]        
    ,CSD.RecordDeleted        
    ,CSD.DeletedBy        
    ,CSD.DeletedDate        
    , NULL  AS ServiceType        
    ,- 1 AS CustomDispositionId       
    FROM  CustomServiceDispositions CSD JOIN       
    CustomDispositions CD  ON CSD.CustomDispositionId=CD.CustomDispositionId      
    WHERE CD.DocumentVersionId = @LatestScreeenTypeDocumentVersionId  AND ISNULL(CSD.RecordDeleted, 'N') = 'N'      
        
   --- CustomProviderServices            
   SELECT 'CustomProviderServices' AS TableName        
    ,- 1 AS CustomProviderServiceId        
    ,'' AS [CreatedBy] ,    
     GETDATE() AS [CreatedDate] ,    
     '' AS [ModifiedBy] ,    
     GETDATE() AS [ModifiedDate]       
    ,CPS.RecordDeleted        
    ,CPS.DeletedBy        
    ,CPS.DeletedDate        
    ,NULL  AS ProgramId        
     ,- 1 AS CustomServiceDispositionId       
    FROM CustomProviderServices CPS JOIN      
    CustomServiceDispositions CSD ON CPS.CustomServiceDispositionId = CSD.CustomServiceDispositionId      
    JOIN       
    CustomDispositions CD  ON CSD.CustomDispositionId=CD.CustomDispositionId      
    WHERE CD.DocumentVersionId = @LatestScreeenTypeDocumentVersionId AND ISNULL(CPS.RecordDeleted, 'N') = 'N'   

     --- CustomASAMPlacements ----         
   SELECT 'CustomASAMPlacements' AS TableName        
    ,ISNULL(b.DocumentVersionId, - 1) AS DocumentVersionId        
    ,b.Dimension1LevelOfCare        
    ,b.Dimension1Need        
    ,b.Dimension2LevelOfCare        
    ,b.Dimension2Need        
    ,b.Dimension3LevelOfCare        
    ,b.Dimension3Need        
    ,b.Dimension4LevelOfCare        
    ,b.Dimension4Need        
    ,b.Dimension5LevelOfCare        
    ,b.Dimension5Need        
    ,b.Dimension6LevelOfCare        
    ,b.Dimension6Need        
    ,b.SuggestedPlacement        
    ,b.FinalPlacement        
    ,b.FinalPlacementComment        
    ,'' AS [b.CreatedBy] ,    
     GETDATE() AS [b.CreatedDate] ,    
      '' AS [b.ModifiedBy] ,    
      GETDATE() AS [b.ModifiedDate]      
    --,b.RowIdentifier        
    ,b.RecordDeleted        
    ,b.DeletedDate        
    ,b.DeletedBy        
   FROM CustomASAMPlacements b        
   WHERE b.DocumentVersionId = @LatestScreeenTypeDocumentVersionId  

      SELECT  'CustomOtherRiskFactors' AS TableName   ,    
                    -1 AS [DocumentVersionId]     
                      ,[OtherRiskFactor]      
                      ,c.[CreatedBy]      
					  ,c.[CreatedDate]      
					  ,c.[ModifiedBy]      
					  ,c.[ModifiedDate]      
					  ,c.[RecordDeleted]      
					  ,c.[DeletedDate]      
					  ,c.[DeletedBy]      
					  ,GC.CodeName    
					  ,c.RowIdentifier
            FROM   CustomOtherRiskFactors c     
                     JOIN GlobalCodes GC ON GC.GlobalCodeId = c.OtherRiskFactor    
                     WHERE c.DocumentVersionId =@LatestDocumentVersionId      
  AND IsNull(c.RecordDeleted, 'N') = 'N'      
	 
	  SELECT 'CustomDocumentAssessmentSubstanceUses' AS TableName                  
    ,- 1 AS 'DocumentVersionId'        
   ,'' AS [CreatedBy] ,    
     GETDATE() AS [CreatedDate] ,    
     '' AS [ModifiedBy] ,    
     GETDATE() AS [ModifiedDate]      
    ,CDA.RecordDeleted        
    ,CDA.DeletedBy        
    ,CDA.DeletedDate        
     ,CASE WHEN @AssessmentType='U' THEN CDA.DrinksPerWeek ELSE NULL END AS DrinksPerWeek
	,CASE WHEN @AssessmentType='U' THEN CDA.LastTimeDrinkDate ELSE NULL END AS LastTimeDrinkDate
	,CASE WHEN @AssessmentType='U' THEN CDA.LastTimeDrinks ELSE NULL END AS LastTimeDrinks
	,CASE WHEN @AssessmentType='U' THEN CDA.IllegalDrugs ELSE NULL END AS IllegalDrugs
	,CASE WHEN @AssessmentType='U' THEN CDA.BriefCounseling ELSE NULL END AS BriefCounseling
	,CASE WHEN @AssessmentType='U' THEN CDA.FeedBackOnAlcoholUse ELSE NULL END AS FeedBackOnAlcoholUse
	,CASE WHEN @AssessmentType='U' THEN  CDA.Harms ELSE NULL END AS Harms
	,CASE WHEN @AssessmentType='U' THEN  CDA.DevelopmentOfPlans ELSE NULL END AS DevelopmentOfPlans
	,CASE WHEN @AssessmentType='U' THEN  CDA.Refferal ELSE NULL END AS Refferal
	,CASE WHEN @AssessmentType='U' THEN  CDA.DDOneTimeOnly  ELSE NULL END AS DDOneTimeOnly          
   FROM CustomDocumentAssessmentSubstanceUses CDA        
   WHERE DocumentVersionId = @LatestScreeenTypeDocumentVersionId        
       
   
   SELECT 'CustomDocumentPreEmploymentActivities' AS TableName        
    ,- 1 AS DocumentVersionId     
    ,'' AS [CreatedBy] ,    
     GETDATE() AS [CreatedDate] ,    
     '' AS [ModifiedBy] ,    
     GETDATE() AS [ModifiedDate]      
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
   FROM CustomDocumentPreEmploymentActivities CDP        
   WHERE DocumentVersionId = @LatestScreeenTypeDocumentVersionId        
      
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

	    --CustomDocumentCSSRSAdultSinceLastVisits      
  SELECT 'CustomDocumentMHColumbiaAdultSinceLastVisits' AS TableName      
  , -1 AS [DocumentVersionId]
  ,'' AS [CreatedBy] ,    
   GETDATE() AS [CreatedDate] ,    
   '' AS [ModifiedBy] ,    
   GETDATE() AS [ModifiedDate]      
  ,RecordDeleted      
  ,DeletedBy      
  ,DeletedDate      
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
 FROM CustomDocumentMHColumbiaAdultSinceLastVisits      
 WHERE DocumentVersionId = @LatestDocumentVersionId      
  AND ISNULL(RecordDeleted, 'N') <> 'Y'    
     
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

	     --For CarePlanDomains            
  SELECT 'CarePlanDomains' AS TableName        
   ,CPD.[CarePlanDomainId]        
   ,'' AS [CreatedBy] ,    
     GETDATE() AS [CreatedDate] ,    
     '' AS [ModifiedBy] ,    
     GETDATE() AS [ModifiedDate]       
   ,CPD.[RecordDeleted]        
   ,CPD.[DeletedBy]        
   ,CPD.[DeletedDate]        
   ,CPD.[DomainName]        
  FROM CarePlanDomains AS CPD        
  WHERE ISNull(CPD.RecordDeleted, 'N') = 'N'        
  ORDER BY CPD.DomainName        
        
  --CarePlanDomainNeeds            
  SELECT 'CarePlanDomainNeeds' AS TableName        
   ,CPDN.CarePlanDomainNeedId        
   ,'' AS [CreatedBy] ,    
     GETDATE() AS [CreatedDate] ,    
     '' AS [ModifiedBy] ,    
     GETDATE() AS [ModifiedDate]   
   ,CPDN.RecordDeleted        
   ,CPDN.DeletedBy        
   ,CPDN.DeletedDate        
   ,CPDN.NeedName        
   ,CPDN.CarePlanDomainId        
   ,CPDN.MHAFieldIdentifierCode        
   ,CPDN.MHANeedDescription        
  FROM CarePlanDomainNeeds AS CPDN        
  WHERE ISNull(CPDN.RecordDeleted, 'N') = 'N'    
  
  SELECT 'CustomMHAssessmentCurrentHealthIssues' AS TableName
    ,CH.MHAssessmentCurrentHealthIssueId
	,CH.CreatedBy
	,CH.CreatedDate
	,CH.ModifiedBy
	,CH.ModifiedDate
	,CH.RecordDeleted
	,CH.DeletedBy
	,CH.DeletedDate
	,CH.DocumentVersionId
	,CH.CurrentHealthIssues
	,CH.IsChecked
	FROM CustomMHAssessmentCurrentHealthIssues AS CH Where CH.DocumentVersionId = @LatestDocumentVersionId    AND ISNull(CH.RecordDeleted, 'N') = 'N' 
	
	
SELECT 'CustomMHAssessmentPastHealthIssues' AS TableName
	,CP.MHAssessmentPastHealthIssueId
	,CP.CreatedBy
	,CP.CreatedDate
	,CP.ModifiedBy
	,CP.ModifiedDate
	,CP.RecordDeleted
	,CP.DeletedBy
	,CP.DeletedDate
	,CP.DocumentVersionId
	,CP.PastHealthIssues
	,CP.IsChecked
	FROM CustomMHAssessmentPastHealthIssues AS CP Where CP.DocumentVersionId = @LatestDocumentVersionId    AND ISNull(CP.RecordDeleted, 'N') = 'N' 
	
SELECT 'CustomMHAssessmentFamilyHistory' as TableName
	    ,CF.MHAssessmentFamilyHistoryId
		,CF.CreatedBy
		,CF.CreatedDate
		,CF.ModifiedBy
		,CF.ModifiedDate
		,CF.RecordDeleted
		,CF.DeletedBy
		,CF.DeletedDate
		,CF.DocumentVersionId
		,CF.FamilyHistory
		,CF.IsChecked
		FROM CustomMHAssessmentFamilyHistory AS CF Where CF.DocumentVersionId = @LatestDocumentVersionId    AND ISNull(CF.RecordDeleted, 'N') = 'N'    
        
  EXEC csp_InitCarePlanNeedsMHAssessments @ClientID        
   ,-1        
   ,0  ;   
	 
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
        
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_GetRecentSignedMHAsssessment') + '*****' + Convert(VARCHAR, ERROR_LINE()) +  
    
      
 '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())        
        
  RAISERROR (        
    @Error        
    ,-- Message text.                                           
    16        
    ,-- Severity.                                                                                                             
    1 -- State.                                                                    
    );        
 END CATCH        
END   