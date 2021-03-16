
 
/****** Object:  StoredProcedure [dbo].[csp_InitCustomMHAssessmentsStandardInitialization]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomMHAssessmentsStandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomMHAssessmentsStandardInitialization]
GO


/****** Object:  StoredProcedure [dbo].[csp_InitCustomMHAssessmentsStandardInitialization]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_InitCustomMHAssessmentsStandardInitialization]  
    (  
      @ClientID INT ,  
      @StaffID INT ,  
      @CustomParameters XML    
    )  
AS   
/*********************************************************************/                                                                                                                                                                                        
            
/*       Date              Author                Purpose  */                                                                                                                                                                          
                                                                                                                                                                 
/*********************************************************************/                                                                                                                                                                                        
 
  
    BEGIN    
        BEGIN TRY    
                                         
            DECLARE @later DATETIME    
    
            SET @later = GETDATE()    
    
            DECLARE @LatestDocumentVersionID INT    
            DECLARE @clientFirstName VARCHAR(100) 
			DECLARE @clientLastName VARCHAR(100)   
            DECLARE @clientDOB VARCHAR(50)    
            DECLARE @clientAge VARCHAR(50)    
            DECLARE @InitialRequestDate DATETIME    
            DECLARE @SAFETYPLANINITORREVIEW VARCHAR(10)     
            DECLARE @CRISISPLANINITORREVIEW VARCHAR(10)  
            DECLARE @MHAssessmentDocumentcodeId VARCHAR(MAX)  
            DECLARE @CODE VARCHAR(MAX)  
            SET @CODE='69E559DD-1A4D-46D3-B91C-E89DA48E0038'  
            SET @MHAssessmentDocumentcodeId=(Select DocumentCodeId from DocumentCodes where Code=@CODE)  
    
            SET @clientFirstName = ( SELECT   C.FirstName AS clientFirstName  
                                FROM    Clients C  
                                WHERE   C.ClientId = @ClientID  
                                        AND ISNULL(C.RecordDeleted, 'N') = 'N'  
                              )  
			SET @clientLastName = ( SELECT   C.LastName AS clientLastName  
                                FROM    Clients C  
                                WHERE   C.ClientId = @ClientID  
                                        AND ISNULL(C.RecordDeleted, 'N') = 'N'  
                              )    
            SET @clientDOB = ( SELECT   CONVERT(VARCHAR(10), DOB, 101)  
                               FROM     Clients  
                               WHERE    ClientId = @ClientID  
                                        AND ISNULL(RecordDeleted, 'N') = 'N'  
                             )    
    
       
            EXEC csp_CalculateAge @ClientID, @clientAge OUT    
    
            SET @InitialRequestDate = ( SELECT TOP 1  
                                                InitialRequestDate  
                                        FROM    ClientEpisodes CP  
                                        WHERE   CP.ClientId = @ClientID  
                                                AND ISNULL(Cp.RecordDeleted, 'N') = 'N'  
                                                AND ISNULL(CP.RecordDeleted, 'N') = 'N'  
                                        ORDER BY CP.InitialRequestDate DESC  
                                      )    
    
                                                                                               
            DECLARE @AxisIAxisIIOut NVARCHAR(1100)    
                                           
            SET ARITHABORT ON    
    
            DECLARE @AssessmentTypeCheck VARCHAR(10)    
            DECLARE @CurrentAuthorId INT    
            DECLARE @SafetyInitialorReview VARCHAR(10)  
            DECLARE @CrisisInitialorReview VARCHAR(10)  
            DECLARE @PHQ9DocumentVersionId INT
    
    
            SET @AssessmentTypeCheck = @CustomParameters.value('(/Root/Parameters/@ScreenType)[1]', 'varchar(10)')    
            SET @CurrentAuthorId = @CustomParameters.value('(/Root/Parameters/@CurrentAuthorId)[1]', 'int')    
    
            SET @LatestDocumentVersionID = -1    
            SET @LatestDocumentVersionID = ( SELECT TOP 1  
                                                    CurrentDocumentVersionId  
                       FROM   CustomDocumentMHAssessments C ,  
                                                    Documents D  
                                             WHERE  C.DocumentVersionId = D.CurrentDocumentVersionId  
                                                    AND D.ClientId = @ClientID  
                                                    AND D.STATUS = 22  
                                                    AND ISNULL(C.RecordDeleted, 'N') = 'N'  
                                                    AND ISNULL(D.RecordDeleted, 'N') = 'N'  
                                                    AND DocumentCodeId IN ( @MHAssessmentDocumentcodeId )  
                                             ORDER BY D.EffectiveDate DESC ,  
                                                    D.ModifiedDate DESC  
                                           )  
                                           
                                           
                                           
               SET @PHQ9DocumentVersionId = ( SELECT TOP 1  
                                                    CurrentDocumentVersionId  
                       FROM   PHQ9Documents C ,  
                                                    Documents D  
                                             WHERE  C.DocumentVersionId = D.CurrentDocumentVersionId  
                                                    AND D.ClientId = @ClientID  
                                                    AND D.STATUS = 22  
                                                    AND D.EffectiveDate <= convert(DATETIME, convert(VARCHAR, getDate(), 101))    
													AND DATEDIFF(dd, D.EffectiveDate, GETDATE()) <= 90    
                                                    AND ISNULL(C.RecordDeleted, 'N') = 'N'  
                                                    AND ISNULL(D.RecordDeleted, 'N') = 'N'  
                                                    AND DocumentCodeId IN ( @MHAssessmentDocumentcodeId, 1635 )  
                                             ORDER BY D.EffectiveDate DESC ,  
                                                    D.ModifiedDate DESC  
                                           )    
                            SET @PHQ9DocumentVersionId= ISNULL(@PHQ9DocumentVersionId,-1)            
                                             
     IF(@PHQ9DocumentVersionId>0) 
	 BEGIN           
    SELECT 'PHQ9Documents' AS TableName    
    ,-1 AS DocumentVersionId    
   , '' AS [CreatedBy] ,    
      GETDATE() AS [CreatedDate] ,    
      '' AS [ModifiedBy] ,    
      GETDATE() AS [ModifiedDate]    
    ,PH.RecordDeleted    
    ,PH.DeletedBy    
    ,PH.DeletedDate    
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
     FROM  PHQ9Documents PH WHERE PH.DocumentVersionId = @PHQ9DocumentVersionId    
     AND ISNULL(PH.RecordDeleted,'N')='N'
     END
	 ELSE
	 BEGIN
	  SELECT 'PHQ9Documents' AS TableName    
    ,-1 AS DocumentVersionId    
   , '' AS [CreatedBy] ,    
      GETDATE() AS [CreatedDate] ,    
      '' AS [ModifiedBy] ,    
      GETDATE() AS [ModifiedDate]    
    ,PH.RecordDeleted    
    ,PH.DeletedBy    
    ,PH.DeletedDate    
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
     FROM  SystemConfigurations AS S    
     LEFT JOIN PHQ9Documents PH ON s.DatabaseVersion = -1    
	 END          
     SELECT 'PHQ9ADocuments' AS TableName    
    ,-1 AS DocumentVersionId    
    , '' AS [CreatedBy] ,    
      GETDATE() AS [CreatedDate] ,    
      '' AS [ModifiedBy] ,    
      GETDATE() AS [ModifiedDate]    
    ,PH.RecordDeleted    
    ,PH.DeletedBy    
    ,PH.DeletedDate   
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
     FROM SystemConfigurations AS S    
     LEFT JOIN PHQ9ADocuments PH ON s.DatabaseVersion = -1                                 
    
            IF ( ( @AssessmentTypeCheck = 'U'  
                   OR @AssessmentTypeCheck = 'I'  
                   OR @AssessmentTypeCheck = 'A'  
                   AND @AssessmentTypeCheck != ''  
                 )  
                 AND @LatestDocumentVersionID > 0  
               )    
   --Execute Store Procedure based on Assessment Type                                            
                BEGIN    
                    EXEC scsp_SCMHGetRecentSignedAssessment @ClientId, @AssessmentTypeCheck, @LatestDocumentVersionID, @clientAge, @AxisIAxisIIOut, @InitialRequestDate, @clientDOB, @CurrentAuthorId    
                   -- EXEC csp_InitDocumentFamilyHistory @ClientID, @StaffID, @CustomParameters  
                    EXEC csp_InitCustomDiagnosisStandardInitializationNew @ClientID, @StaffID, @CustomParameters  
                  
                   END  
        ELSE  
              BEGIN    
  
              EXEC csp_InitCustomMHAssessmentDefaultIntialization @ClientID, @AxisIAxisIIOut, @clientAge, @AssessmentTypeCheck, @InitialRequestDate, @LatestDocumentVersionID, @clientDOB, @CurrentAuthorId   
    
               --     EXEC csp_InitDocumentFamilyHistory @ClientID, @StaffID, @CustomParameters  
                 EXEC csp_InitCustomDiagnosisStandardInitializationNew @ClientID, @StaffID, @CustomParameters    
                 
                     
         END   
      
     
        END TRY  
        BEGIN CATCH    
            DECLARE @Error VARCHAR(8000)    
    
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_InitCustomMHAssessmentsStandardInitialization') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())    
    
            RAISERROR (    
    @Error    
    ,-- Message text.                                                                                                                                            
    16    
    ,-- Severity.                                                                                                                                                                                                                                 
    1 -- State.                                                                                                                                                                                                                                                
  
     
    );    
        END CATCH    
    END    
  
  