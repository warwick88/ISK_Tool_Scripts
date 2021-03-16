IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomInitCarePlanInitial]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_CustomInitCarePlanInitial] 
GO
CREATE PROCEDURE [DBO].[csp_CustomInitCarePlanInitial] --3	,1	,NULL 
@ClientID INT
	,@StaffID INT
	,@CustomParameters XML
AS
-- =============================================                  
-- Author:  Pradeep                  
-- Create date: Sept 23, 2014                  
-- Description:               
/*                  
 Author   Modified Date   Reason                  
 Pradeep.A  Apr/16/2015    ProgramType configurations has been moved to Recodes            
            
*/
/* 2016.05.11    Veena S Mani       Review changes Valley Support Go live #390               */
-- =============================================                  
BEGIN
	BEGIN TRY
		DECLARE @CarePlanDocumentcodeId INT
		DECLARE @CarePlanCODE VARCHAR(MAX)

		SET @CarePlanCODE = '8AF7837B-05A7-4DF8-B2ED-6B852A5BA50A'
		SET @CarePlanDocumentcodeId = (
				SELECT DocumentCodeId
				FROM DocumentCodes
				WHERE Code = @CarePlanCODE
				)

		DECLARE @LatestCarePlanDocumentVersionID INT
			,@DocumentCodeID INT
			,@LatestHRMDocumentVersionID INT
			,@LatestMHADocumentVersionID INT
			,@LatestDocumentVersionID INT
			,@LatestCarePlanINDocumentVersionID INT
			,@LatestASAMDocumentVersionID INT
		DECLARE @EffectiveDate DATETIME
			,@EffectiveDateMHA DATETIME
			,@EffectiveDateASAM DATETIME
		DECLARE @Adult CHAR(1)
		DECLARE @EffectiveDateDifference INT
		DECLARE @CurrentDate DATETIME
		DECLARE @NeedNames VARCHAR(MAX)
			,@ClientFirstName VARCHAR(30)
		DECLARE @CarePlanAddendumInfo VARCHAR(MAX)
		DECLARE @CarePlanAddendumText VARCHAR(MAX)
		DECLARE @GenralAddendumDate DATE;
		DECLARE @LatestDocumentVersionFor1501100011002410357 INT = 0
			,@DocumentCodeIdFor1501100011002410357 INT = 0;
		DECLARE @EpisodeRegistrationDate DATETIME


		DECLARE @EpsiodeRegistrationDate AS DATETIME
		DECLARE @EpsiodeDischargeDate AS DATETIME
		DECLARE @MHAssessmentDocumentcodeId INT
		DECLARE @MHAssessmentCODE VARCHAR(MAX)
		DECLARE @AssessmentModifiedDate DATETIME


		SET @MHAssessmentCODE = '69E559DD-1A4D-46D3-B91C-E89DA48E0038'
		SET @MHAssessmentDocumentcodeId = (
				SELECT DocumentCodeId
				FROM DocumentCodes
				WHERE Code = @MHAssessmentCODE
				)


		SET @CurrentDate = GetDate()
		SET @EffectiveDateDifference = 0
		SET @DocumentCodeID = @CustomParameters.value('(/Root/Parameters/@DocumentCodeID)[1]', 'int')

		SELECT @EpisodeRegistrationDate = ce.RegistrationDate
		FROM Clients c
		INNER JOIN ClientEpisodes ce ON ce.ClientId = c.ClientId
			AND ce.EpisodeNumber = c.CurrentEpisodeNumber
		WHERE ISNULL(ce.RecordDeleted, 'N') = 'N'
			AND c.ClientId = @ClientId

		SELECT TOP 1 @LatestDocumentVersionFor1501100011002410357 = ISNULL(CurrentDocumentVersionId, 0)
			,@DocumentCodeIdFor1501100011002410357 = ISNULL(DocumentCodeId, 0)
		FROM Documents
		WHERE ClientId = @ClientID
			AND CONVERT(DATE, EffectiveDate) <= CONVERT(DATE, GETDATE(), 101)
			AND CONVERT(DATE, EffectiveDate) >= CONVERT(DATE, @EpisodeRegistrationDate, 101)
			AND STATUS = 22
			AND DocumentCodeId IN (@CarePlanDocumentcodeId)
			AND ISNULL(RecordDeleted, 'N') <> 'Y'
		ORDER BY EffectiveDate DESC
			,ModifiedDate DESC

		DECLARE @LevelOfCare VARCHAR(MAX) = NULL
			,@ReductionInSymptoms CHAR(1) = NULL
			,@ReductionInSymptomsDescription VARCHAR(MAX) = NULL
			,@AttainmentOfHigherFunctioning CHAR(1) = NULL
			,@AttainmentOfHigherFunctioningDescription VARCHAR(MAX) = NULL
			,@TreatmentNotNecessary CHAR(1) = NULL
			,@TreatmentNotNecessaryDescription VARCHAR(MAX) = NULL
			,@OtherTransitionCriteria CHAR(1) = NULL
			,@OtherTransitionCriteriaDescription VARCHAR(MAX) = NULL
			,@EstimatedDischargeDate DATE = NULL;

		IF (@LatestDocumentVersionFor1501100011002410357 > 0)
		BEGIN
			IF (@DocumentCodeIdFor1501100011002410357 = @CarePlanDocumentcodeId)
			BEGIN
				SELECT TOP 1 @LevelOfCare = LevelOfCare
					,@ReductionInSymptoms = ReductionInSymptoms
					,@ReductionInSymptomsDescription = ReductionInSymptomsDescription
					,@AttainmentOfHigherFunctioning = AttainmentOfHigherFunctioning
					,@AttainmentOfHigherFunctioningDescription = AttainmentOfHigherFunctioningDescription
					,@TreatmentNotNecessary = TreatmentNotNecessary
					,@TreatmentNotNecessaryDescription = TreatmentNotNecessaryDescription
					,@OtherTransitionCriteria = OtherTransitionCriteria
					,@OtherTransitionCriteriaDescription = OtherTransitionCriteriaDescription
					,@EstimatedDischargeDate = CONVERT(DATE, EstimatedDischargeDate, 101)
				FROM DocumentCarePlans
				WHERE DocumentVersionId = @LatestDocumentVersionFor1501100011002410357
					AND ISNULL(RecordDeleted, 'N') = 'N'
			END
		END

		SELECT @ClientFirstName = CA.FirstName
		FROM ClientAliases CA
		INNER JOIN GlobalCodes GC ON GC.GlobalCodeId = CA.AliasType
		WHERE GC.Category LIKE 'ALIASTYPE'
			AND GC.CodeName = 'Alias'
			AND CA.ClientId = @ClientID
			AND ISNULL(CA.RecordDeleted, 'N') = 'N'
			AND ISNULL(GC.RecordDeleted, 'N') = 'N'

		IF (@ClientFirstName IS NULL)
			SELECT @ClientFirstName = FirstName
			FROM Clients
			WHERE ClientId = @ClientID
				AND ISNULL(RecordDeleted, 'N') = 'N'
	-- Effective Date for DocumentCarePlans
		SELECT TOP 1 @LatestCarePlanDocumentVersionID = CurrentDocumentVersionId
			,@EffectiveDate = Doc.EffectiveDate
			,@EffectiveDateDifference = DATEDIFF(YEAR, Doc.EffectiveDate, GETDATE())
		FROM Documents Doc
		WHERE EXISTS (
				SELECT 1
				FROM DocumentCarePlans CDCP
				INNER JOIN Clients C ON C.ClientId = Doc.ClientId
				INNER JOIN ClientEpisodes CE ON CE.ClientId = C.ClientId
					AND CONVERT(DATE, DOC.EffectiveDate) >= CONVERT(DATE, CE.RegistrationDate)
				WHERE CDCP.DocumentVersionId = Doc.CurrentDocumentVersionId
					AND CDCP.CarePlanType IN (
						'IN'
						,'AD'
						--Added by Veena on 05/11/16 for CarePlan Review changes Valley Support Go live #390            
						,'RE'
						)
					AND ISNULL(CDCP.RecordDeleted, 'N') = 'N'
				)
			AND Doc.ClientId = @ClientID
			AND DocumentCodeId IN (@CarePlanDocumentcodeId)
			AND Doc.STATUS = 22
			AND DATEDIFF(MONTH, Doc.EffectiveDate, GETDATE()) <= 6
			AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
			AND CONVERT(DATE, DOC.EffectiveDate) <= CONVERT(DATE, GETDATE())
			AND CONVERT(DATE, DOC.EffectiveDate) >= CONVERT(DATE, @EpisodeRegistrationDate, 101)
		ORDER BY Doc.EffectiveDate DESC
			,Doc.ModifiedDate DESC

--END Effective Date for Careplan
	-- Effective Date for MHAssessments
		SELECT TOP 1 @EffectiveDateMHA = Doc.EffectiveDate
			--,@EffectiveDateDifference = DATEDIFF(YEAR, Doc.EffectiveDate, GETDATE())
		FROM Documents Doc
		WHERE EXISTS (
				SELECT 1
				FROM CustomDocumentMHAssessments CDCP
				INNER JOIN Clients C ON C.ClientId = Doc.ClientId
				INNER JOIN ClientEpisodes CE ON CE.ClientId = C.ClientId
					AND CONVERT(DATE, DOC.EffectiveDate) >= CONVERT(DATE, CE.RegistrationDate)
				WHERE CDCP.DocumentVersionId = Doc.CurrentDocumentVersionId
					--AND CDCP.CarePlanType IN (
					--	'IN'
					--	,'AD'					
					--	,'RE'
					--	)
					AND ISNULL(CDCP.RecordDeleted, 'N') = 'N'
				)
			AND Doc.ClientId = @ClientID
			AND DocumentCodeId IN (@MHAssessmentDocumentcodeId)
			AND Doc.STATUS = 22
			AND DATEDIFF(MONTH, Doc.EffectiveDate, GETDATE()) <= 6
			AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
			AND CONVERT(DATE, DOC.EffectiveDate) <= CONVERT(DATE, GETDATE())
			AND CONVERT(DATE, DOC.EffectiveDate) >= CONVERT(DATE, @EpisodeRegistrationDate, 101)
		ORDER BY Doc.EffectiveDate DESC
			,Doc.ModifiedDate DESC
		-- END Effective Date for MHAssessments
		DECLARE @LatestCarePlanANDocumentVersionID INT;
		DECLARE @EffectiveDateAN DATE;
		DECLARE @EffectiveDateDifferenceAN INT;

		SELECT TOP 1 @LatestCarePlanANDocumentVersionID = CurrentDocumentVersionId
			,@EffectiveDateAN = Doc.EffectiveDate
			,@EffectiveDateDifferenceAN = DATEDIFF(YEAR, Doc.EffectiveDate, GETDATE())
		FROM Documents Doc
		WHERE EXISTS (
				SELECT 1
				FROM DocumentCarePlans CDCP
				INNER JOIN Clients C ON C.ClientId = Doc.ClientId
				INNER JOIN ClientEpisodes CE ON CE.ClientId = C.ClientId
					AND CONVERT(DATE, DOC.EffectiveDate) >= CONVERT(DATE, CE.RegistrationDate)
				WHERE CDCP.DocumentVersionId = Doc.CurrentDocumentVersionId
					AND CDCP.CarePlanType = 'IN'
					AND ISNULL(CDCP.RecordDeleted, 'N') = 'N'
				)
			AND Doc.ClientId = @ClientID
			AND DocumentCodeId IN (@CarePlanDocumentcodeId)
			AND Doc.STATUS = 22
			AND DATEDIFF(MONTH, Doc.EffectiveDate, GETDATE()) <= 6
			AND CONVERT(DATE, Doc.EffectiveDate, 101) >= CONVERT(DATE, @EpisodeRegistrationDate, 101)
			AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
			AND CONVERT(DATE, DOC.EffectiveDate) <= CONVERT(DATE, GETDATE())
		ORDER BY Doc.EffectiveDate DESC
			,Doc.ModifiedDate DESC

		IF (@LatestCarePlanANDocumentVersionID IS NOT NULL)
		BEGIN
			SELECT @CarePlanAddendumInfo = 'Addendum to:' + CHAR(13) + 'Care Plan Document Dated ' + convert(VARCHAR, Doc.EffectiveDate, 101) + ' - ' + convert(VARCHAR, DateAdd(Month, 6, Doc.EffectiveDate), 101)
				,@GenralAddendumDate = CONVERT(VARCHAR(10), DATEADD(MONTH, 6, Doc.EffectiveDate), 101)
			FROM DOCUMENTS Doc
			WHERE Doc.CurrentDocumentVersionId = @LatestCarePlanANDocumentVersionID

			SELECT @CarePlanAddendumText = COALESCE(@CarePlanAddendumText + CHAR(13), '') + 'Care Plan Addendum Document Dated ' + CONVERT(VARCHAR, Doc.EffectiveDate, 101) + ' - ' + CONVERT(VARCHAR(10), @GenralAddendumDate, 101)
			FROM DOCUMENTS Doc
			INNER JOIN DocumentCarePlans C ON doc.CurrentDocumentVersionId = c.DocumentVersionId
			WHERE Doc.ClientId = @ClientID
				AND ISNULL(C.RecordDeleted, 'N') = 'N'
				AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
				AND C.CarePlanType = 'AD'
				AND DATEDIFF(MONTH, Doc.EffectiveDate, GETDATE()) <= 6
				AND (
					Convert(DATE, Doc.EffectiveDate) >= @EffectiveDateAN
					AND CONVERT(DATE, GETDATE()) >= (Convert(DATE, Doc.EffectiveDate))
					)

			SET @CarePlanAddendumInfo = ISNULL(@CarePlanAddendumInfo, '') + CHAR(13) + ISNULL(@CarePlanAddendumText, '')
		END
		ELSE IF (@LatestCarePlanINDocumentVersionID IS NOT NULL)
		BEGIN
			SELECT @CarePlanAddendumInfo = 'Addendum to:' + CHAR(13) + 'Care Plan Document Dated ' + convert(VARCHAR, Doc.EffectiveDate, 101) + ' - ' + convert(VARCHAR, DateAdd(Month, 6, Doc.EffectiveDate), 101)
				,@GenralAddendumDate = CONVERT(VARCHAR(10), DATEADD(MONTH, 6, Doc.EffectiveDate), 101)
			FROM DOCUMENTS Doc
			WHERE Doc.CurrentDocumentVersionId = @LatestCarePlanINDocumentVersionID

			SELECT @CarePlanAddendumText = COALESCE(@CarePlanAddendumText + CHAR(13), '') + 'Care Plan Addendum Document Dated ' + CONVERT(VARCHAR, Doc.EffectiveDate, 101) + ' - ' + CONVERT(VARCHAR(10), @GenralAddendumDate, 101)
			FROM DOCUMENTS Doc
			INNER JOIN DocumentCarePlans C ON doc.CurrentDocumentVersionId = c.DocumentVersionId
			WHERE Doc.ClientId = @ClientID
				AND ISNULL(C.RecordDeleted, 'N') = 'N'
				AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
				AND C.CarePlanType = 'AD'
				AND DATEDIFF(MONTH, Doc.EffectiveDate, GETDATE()) <= 6
				AND CONVERT(DATE, Doc.EffectiveDate, 101) >= CONVERT(DATE, @EpisodeRegistrationDate, 101)

			SET @CarePlanAddendumInfo = ISNULL(@CarePlanAddendumInfo, '') + CHAR(13) + ISNULL(@CarePlanAddendumText, '')
		END

		SET @EffectiveDate = ISNULL(@EffectiveDate, DATEADD(YEAR, - 100, GETDATE()))

		DECLARE @ReviewEntireCareType CHAR(1)
		DECLARE @ReviewEntireCarePlan INT
		DECLARE @ReviewEntireCarePlanDate DATETIME
		DECLARE @LatestDocumentVersionIdCarePlan INT
		DECLARE @CarePlanType VARCHAR(5)

		IF (
				@LatestCarePlanDocumentVersionID IS NULL
				AND @LatestCarePlanANDocumentVersionID IS NULL
				)
			SET @CarePlanType = 'IN'
		ELSE
			SET @CarePlanType = 'AD'

		IF (dbo.ssf_GetSystemConfigurationKeyValue('SetReviewInCarePlan') = 'Y')
		BEGIN
			SELECT TOP 1 @LatestDocumentVersionIdCarePlan = ISNULL(InProgressDocumentVersionId, 0)
			FROM Documents
			WHERE ClientId = @ClientID
				AND CONVERT(DATE, EffectiveDate) <= CONVERT(DATE, GETDATE(), 101)
				AND STATUS = 22
				AND DocumentCodeId IN (@CarePlanDocumentcodeId)
				AND ISNULL(RecordDeleted, 'N') <> 'Y'
			ORDER BY EffectiveDate DESC
				,ModifiedDate DESC

			IF (@LatestDocumentVersionIdCarePlan IS NOT NULL)
			BEGIN
				SELECT @ReviewEntireCareType = ReviewEntireCareType
					,@ReviewEntireCarePlan = ReviewEntireCarePlan
					,@ReviewEntireCarePlanDate = ReviewEntireCarePlanDate
				FROM DocumentCarePlans
				WHERE DocumentVersionId = @LatestDocumentVersionIdCarePlan

				IF (CONVERT(DATE, @ReviewEntireCarePlanDate) <= CONVERT(DATE, GETDATE(), 101))
					SET @ReviewEntireCarePlanDate = NULL
			END
		END

		--Task #8      
		DECLARE @StrengthsCarePlan VARCHAR(max)
		DECLARE @StrengthsMHAssessments VARCHAR(max)
		DECLARE @Strengths VARCHAR(max)
		DECLARE @Barriers VARCHAR(max)
		DECLARE @Abilities VARCHAR(max)
		DECLARE @LatestModifiedDateCarePlan DATETIME
		DECLARE @LatestModifiedDateMHAssessments DATETIME

		SELECT TOP 1 @StrengthsCarePlan = Strengths
			,@LatestModifiedDateCarePlan = Doc.EffectiveDate
			,@Barriers = Barriers
			,@Abilities = Abilities
		FROM DocumentCarePlans DCP
		INNER JOIN Documents Doc ON Doc.CurrentDocumentVersionId = DCP.DocumentVersionId
		WHERE DCP.CarePlanType IN (
				'AD'
				,'RE'
				)
			AND ISNULL(DCP.RecordDeleted, 'N') = 'N'
			AND Doc.ClientId = @ClientID
			--DocumentCodeId IN (67005)      
			AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
			AND Doc.STATUS = 22
		ORDER BY 1 DESC

		SELECT TOP 1 @StrengthsMHAssessments = Strengths
			,@LatestModifiedDateMHAssessments = Doc.EffectiveDate
		FROM CustomDocumentMHAssessments CDMA
		INNER JOIN Documents Doc ON Doc.CurrentDocumentVersionId = CDMA.DocumentVersionId
		WHERE ISNULL(CDMA.RecordDeleted, 'N') = 'N'
			AND Doc.ClientId = @ClientID
			AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
			AND Doc.STATUS = 22
		ORDER BY 1 DESC


		IF (
				@LatestModifiedDateCarePlan IS NOT NULL
				AND @LatestModifiedDateMHAssessments IS NOT NULL
				)
		BEGIN
			IF (@LatestModifiedDateCarePlan > @LatestModifiedDateMHAssessments)
				SET @Strengths = @StrengthsCarePlan
			ELSE
				SET @Strengths = @StrengthsMHAssessments
		END
		ELSE IF (
				@LatestModifiedDateCarePlan IS NULL
				AND @LatestModifiedDateMHAssessments IS NOT NULL
				)
			SET @Strengths = @StrengthsMHAssessments
		ELSE IF (
				@LatestModifiedDateCarePlan IS NOT NULL
				AND @LatestModifiedDateMHAssessments IS NULL
				)
			SET @Strengths = @StrengthsCarePlan

		--DECLARE @PreSignedEpisodeNo int      
		--DECLARE @CurrentEpisodeNo int      
		DECLARE @Preferences VARCHAR(max)
		DECLARE @LevelOfCare1 VARCHAR(max)
		DECLARE @TransitionLevelOfCare VARCHAR(max)
		DECLARE @EstimatedDischargeDate1 DATETIME
		DECLARE @ASAMLavelofcare VARCHAR(max)

		SET @ASAMLavelofcare = ''
		

		SELECT @EpsiodeRegistrationDate = CE.RegistrationDate
			,@EpsiodeDischargeDate = CE.DischargeDate
		FROM ClientEpisodes CE
		INNER JOIN GlobalCodes GC ON GC.GlobalCodeId = CE.[Status]
		WHERE ClientId = @ClientID
			AND ISNULL(CE.RecordDeleted, 'N') = 'N'
			AND CE.DischargeDate IS NULL
			AND GC.GlobalCodeId IN (
				100
				,101
				)

		DECLARE @LatestsignedDocumentVersionId INT
		DECLARE @SameEpisode CHAR(1)

		SELECT TOP 1 @LatestsignedDocumentVersionId = dv.DocumentVersionId
			,@AssessmentModifiedDate = d.ModifiedDate
		FROM DocumentVersions dv
		INNER JOIN Documents d ON dv.documentid = d.DocumentId
		INNER JOIN DocumentCodes dc ON d.DocumentCodeId = dc.DocumentCodeId
		WHERE d.ClientId = @ClientID
			AND d.[Status] = 22
			AND dc.DocumentCodeId IN (
				@CarePlanDocumentcodeId
				,@MHAssessmentDocumentcodeId
				)
		ORDER BY d.CurrentDocumentVersionId DESC

		IF (@EpsiodeDischargeDate IS NULL)
		BEGIN
			IF (
					@EpsiodeRegistrationDate IS NOT NULL
					AND (@EffectiveDate >= @EpsiodeRegistrationDate OR @EffectiveDateMHA >= @EpsiodeRegistrationDate)
					)
				SET @SameEpisode = 'Y'
		END
		ELSE
		BEGIN
			IF (
					@EpsiodeDischargeDate IS NOT NULL
					AND (@EffectiveDate <= @EpsiodeDischargeDate OR @EffectiveDateMHA >= @EpsiodeRegistrationDate)
					)
				SET @SameEpisode = 'Y'
		END

		
		-- For     
		DECLARE @LatestsignedLocusorCarePlanDocumentVersionId INT
		DECLARE @AssessmentLocusorEffectiveDate DATETIME
		DECLARE @SameEpisodeLocusorCarePlan CHAR(1)

		SELECT TOP 1 @LatestsignedLocusorCarePlanDocumentVersionId = dv.DocumentVersionId
			,@AssessmentLocusorEffectiveDate = d.EffectiveDate
		FROM DocumentVersions dv
		INNER JOIN Documents d ON dv.documentid = d.DocumentId
		INNER JOIN DocumentCodes dc ON d.DocumentCodeId = dc.DocumentCodeId
		WHERE d.ClientId = @ClientID
			AND d.[Status] = 22
			AND dc.DocumentCodeId IN (
				@CarePlanDocumentcodeId
				,1638
				) --LOCUS Document-1638    
		ORDER BY d.CurrentDocumentVersionId DESC

		IF (@EpsiodeDischargeDate IS NULL)
		BEGIN
			IF (
					@EpsiodeRegistrationDate IS NOT NULL
					AND @AssessmentLocusorEffectiveDate >= @EpsiodeRegistrationDate
					)
				SET @SameEpisodeLocusorCarePlan = 'Y'
		END
		ELSE
		BEGIN
			IF (
					@EpsiodeDischargeDate IS NOT NULL
					AND @EffectiveDate <= @EpsiodeRegistrationDate
					)
				SET @SameEpisodeLocusorCarePlan = 'Y'
		END

		--ASAM    
		DECLARE @LatestsignedASAMDocumentVersionId INT

		SELECT TOP 1 @LatestsignedASAMDocumentVersionId = dv.DocumentVersionId
		FROM DocumentVersions dv
		INNER JOIN Documents d ON dv.documentid = d.DocumentId
		INNER JOIN DocumentCodes dc ON d.DocumentCodeId = dc.DocumentCodeId
		WHERE d.ClientId = @ClientID
			AND d.[Status] = 22
			AND dc.DocumentCodeId IN (2701)

		IF EXISTS (
				SELECT 1
				FROM DocumentASAMs DA
				WHERE DA.DocumentVersionId = @LatestsignedASAMDocumentVersionId
				)
		BEGIN
			SET @ASAMLavelofcare = (
					SELECT FinalDeterminationComments
					FROM DocumentASAMs DA
					WHERE DA.DocumentVersionId = @LatestsignedASAMDocumentVersionId
					)
		END

		IF EXISTS (
				SELECT 1
				FROM CustomDocumentPrePlanningWorksheet CDMA
				WHERE CDMA.DocumentVersionId = @LatestsignedDocumentVersionId
				)
		BEGIN
	
			SET @Preferences = (
					SELECT ServicesToDiscussAtMeeting
					FROM CustomDocumentPrePlanningWorksheet CDMA
					WHERE CDMA.DocumentVersionId = @LatestsignedDocumentVersionId
					)
		END
		ELSE
		BEGIN
	
			SET @Preferences = (
					SELECT Preferences
					FROM DocumentCarePlans DCA
					WHERE DCA.DocumentVersionId = @LatestsignedDocumentVersionId
					)
		END

		IF EXISTS (
				SELECT 1
				FROM DocumentLOCUS DL
				WHERE DL.DocumentVersionId = @LatestsignedLocusorCarePlanDocumentVersionId
				)
		BEGIN
			SET @LevelOfCare1 = (
					SELECT EvaluationNotes
					FROM DocumentLOCUS CDMA
					WHERE CDMA.DocumentVersionId = @LatestsignedLocusorCarePlanDocumentVersionId
					)
		END
		ELSE
		BEGIN
			SET @LevelOfCare1 = (
					SELECT LevelOfCare
					FROM DocumentCarePlans DCA
					WHERE DCA.DocumentVersionId = @LatestsignedLocusorCarePlanDocumentVersionId
					)
		END

		IF EXISTS (
				SELECT 1
				FROM CustomDocumentPrePlanningWorksheet CDMA
				WHERE CDMA.DocumentVersionId = @LatestsignedDocumentVersionId
				)
		BEGIN
			SET @TransitionLevelOfCare = (
					SELECT TransitionLevelOfCare
					FROM CustomDocumentMHAssessments CDMA
					WHERE CDMA.DocumentVersionId = @LatestsignedDocumentVersionId
					)
		END
		ELSE
		BEGIN
			SET @TransitionLevelOfCare = (
					SELECT MHAssessmentLevelOfCare
					FROM DocumentCarePlans DCA
					WHERE DCA.DocumentVersionId = @LatestsignedDocumentVersionId
					)
		END

		IF EXISTS (
				SELECT 1
				FROM CustomDocumentMHAssessments CDMA
				WHERE CDMA.DocumentVersionId = @LatestsignedDocumentVersionId
				)
		BEGIN
			
					SELECT @EstimatedDischargeDate = EstimatedDischargeDate
					,@ReductionInSymptoms = ReductionInSymptoms
					,@ReductionInSymptomsDescription = ReductionInSymptomsDescription
					,@AttainmentOfHigherFunctioning = AttainmentOfHigherFunctioning
					,@AttainmentOfHigherFunctioningDescription = AttainmentOfHigherFunctioningDescription
					,@TreatmentNotNecessary = TreatmentNotNecessary
					,@TreatmentNotNecessaryDescription = TreatmentNotNecessaryDescription
					,@OtherTransitionCriteria = OtherTransitionCriteria
					,@OtherTransitionCriteriaDescription = OtherTransitionCriteriaDescription
					FROM CustomDocumentMHAssessments CDMA
					WHERE CDMA.DocumentVersionId = @LatestsignedDocumentVersionId
					

		END
		ELSE
		BEGIN
			SET @EstimatedDischargeDate = (
					SELECT EstimatedDischargeDate
					FROM DocumentCarePlans DCA
					WHERE DCA.DocumentVersionId = @LatestsignedDocumentVersionId
					)
		END	

		--END Task #8       


		DECLARE @DocumentRecent AS BIGINT --Most recent plan, addendum, or periodic review                                
		DECLARE @VersionRecent AS BIGINT     

		-- Fetch the most recent document (Treatment Plan, Addendum, Periodic Review)                                
		select top 1 @DocumentRecent= a.DocumentId,@VersionRecent=a.CurrentDocumentVersionId                                      
		from Documents a                                     
		where a.ClientId = @ClientID                                  
		and a.EffectiveDate <= convert(datetime, convert(varchar, getdate(),101))                                 
		and a.Status = 22                                     
		and a.DocumentCodeId in (350,503,2, 352, 3)                                 
		and isNull(a.RecordDeleted,'N')<>'Y'                                 
		order by a.EffectiveDate desc,ModifiedDate desc   


		IF (ISNULL(@LatestCarePlanDocumentVersionID, 0) <= 0)
		BEGIN
		
			SELECT TOP 1 Placeholder.TableName
				,- 1 AS DocumentVersionId
				,CASE 
					WHEN @LatestCarePlanDocumentVersionID IS NULL
						AND @LatestCarePlanANDocumentVersionID IS NULL
						THEN 'IN'
					WHEN @LatestCarePlanDocumentVersionID IS NOT NULL
						AND (dbo.ssf_GetSystemConfigurationKeyValue('SetReviewInCarePlan') = 'Y')
						THEN NULL
					ELSE 'AD'
					END AS CarePlanType
				,@Adult AS [Adult]
				,@ClientFirstName AS NameInGoalDescriptions				
				,@Strengths AS Strengths
				,@NeedNames AS 'Needs'
				,'' AS Abilities
				,CASE 
					WHEN @SameEpisode = 'Y'
						THEN @Preferences
					ELSE ''
					END AS 'Preferences'
				,CASE 
					WHEN @SameEpisode = 'Y'
						THEN @TransitionLevelOfCare
					ELSE ''
					END AS 'MHAssessmentLevelOfCare'
				,@ASAMLavelofcare AS ASAMLevelOfCare
				,CASE 
					WHEN @SameEpisodeLocusorCarePlan = 'Y'
						THEN @LevelOfCare1
					ELSE ''
					END AS 'LevelOfCare'
				,@CarePlanAddendumInfo AS CarePlanAddendumInfo
				
				
				--,'' AS MHAssessmentLevelOfCare     
				--,CASE 
				--	WHEN @SameEpisode = 'Y'
				--		THEN @TransitionLevelOfCare
				--	ELSE ''
				--	END AS 'MHAssessmentLevelOfCare'
				--,@ASAMLavelofcare AS ASAMLevelOfCare
				--,@CarePlanAddendumInfo AS CarePlanAddendumInfo
				--,CASE 
				--	WHEN @SameEpisodeLocusorCarePlan = 'Y'
				--		THEN @LevelOfCare1
				--	ELSE ''
				--	END AS 'LevelOfCare'
				--,'' AS 'LevelOfCare'            
				,@ReductionInSymptoms AS 'ReductionInSymptoms'
				,@ReductionInSymptomsDescription AS 'ReductionInSymptomsDescription'
				,@AttainmentOfHigherFunctioning AS 'AttainmentOfHigherFunctioning'
				,@AttainmentOfHigherFunctioningDescription AS 'AttainmentOfHigherFunctioningDescription'
				,@TreatmentNotNecessary AS 'TreatmentNotNecessary'
				,@TreatmentNotNecessaryDescription AS 'TreatmentNotNecessaryDescription'
				,@OtherTransitionCriteria AS 'OtherTransitionCriteria'
				,@OtherTransitionCriteriaDescription AS 'OtherTransitionCriteriaDescription'
				,CASE 
					WHEN @SameEpisode = 'Y'
						THEN @EstimatedDischargeDate
					ELSE NULL
					END AS 'EstimatedDischargeDate'
				--,NULL AS 'EstimatedDischargeDate'            
				,0 AS SupportsInvolvement
				--,'S' AS ReviewEntireCareType            
				--Added by Veena            
				,CASE 
					WHEN (
							@CarePlanType = 'AD'
							AND dbo.ssf_GetSystemConfigurationKeyValue('SetReviewInCarePlan') = 'Y'
							)
						THEN @ReviewEntireCareType
					ELSE 'S'
					END AS ReviewEntireCareType
				,CASE 
					WHEN (
							@CarePlanType = 'AD'
							AND dbo.ssf_GetSystemConfigurationKeyValue('SetReviewInCarePlan') = 'Y'
							)
						THEN @ReviewEntireCarePlan
					ELSE NULL
					END AS ReviewEntireCarePlan
				,CASE 
					WHEN (
							@CarePlanType = 'AD'
							AND dbo.ssf_GetSystemConfigurationKeyValue('SetReviewInCarePlan') = 'Y'
							)
						THEN @ReviewEntireCarePlanDate
					ELSE NULL
					END AS ReviewEntireCarePlanDate
				--code ends here            
				,CASE 
					WHEN @LatestCarePlanDocumentVersionID IS NULL
						THEN 'N'
					ELSE 'Y'
					END AS PreviousCP
			FROM (
				SELECT 'DocumentCarePlans' AS TableName
				) AS Placeholder
		END
		ELSE
		BEGIN
	
			SELECT TOP 1 Placeholder.TableName
				,ISNULL(CSLD.DocumentVersionId, - 1) AS DocumentVersionId
				,CASE 
					WHEN @LatestCarePlanDocumentVersionID IS NULL
						AND @LatestCarePlanANDocumentVersionID IS NULL
						THEN 'IN'
					WHEN @LatestCarePlanDocumentVersionID IS NOT NULL
						AND (dbo.ssf_GetSystemConfigurationKeyValue('SetReviewInCarePlan') = 'Y')
						THEN NULL
					ELSE 'AD'
					END AS CarePlanType
				,@Adult AS [Adult]
				,@ClientFirstName AS NameInGoalDescriptions
				--,CASE 
				--	WHEN @LatestModifiedDateCarePlan > @LatestModifiedDateMHAssessments
				--		THEN @StrengthsCarePlan
				--	ELSE @StrengthsMHAssessments
				--	END AS Strengths
				,@Strengths AS Strengths
				,@Barriers AS Barriers
				,@Abilities AS Abilities
				,CASE 
					WHEN @SameEpisode = 'Y'
						THEN @Preferences
					ELSE ''
					END AS 'Preferences'
				--,CSLD.[Strengths]            
				--,CSLD.[Barriers]            
				--,CSLD.[Abilities]            
				--,CSLD.[Preferences]            
				-- ,'' AS MHAssessmentLevelOfCare      
				,CASE 
					WHEN @SameEpisode = 'Y'
						THEN @TransitionLevelOfCare
					ELSE ''
					END AS 'MHAssessmentLevelOfCare'
				,@ASAMLavelofcare AS ASAMLevelOfCare
				,CASE 
					WHEN @SameEpisodeLocusorCarePlan = 'Y'
						THEN @LevelOfCare1
					ELSE ''
					END AS 'LevelOfCare'
				--,@LevelOfCare AS 'LevelOfCare'            
				,@ReductionInSymptoms AS 'ReductionInSymptoms'
				,@ReductionInSymptomsDescription AS 'ReductionInSymptomsDescription'
				,@AttainmentOfHigherFunctioning AS 'AttainmentOfHigherFunctioning'
				,@AttainmentOfHigherFunctioningDescription AS 'AttainmentOfHigherFunctioningDescription'
				,@TreatmentNotNecessary AS 'TreatmentNotNecessary'
				,@TreatmentNotNecessaryDescription AS 'TreatmentNotNecessaryDescription'
				,@OtherTransitionCriteria AS 'OtherTransitionCriteria'
				,@OtherTransitionCriteriaDescription AS 'OtherTransitionCriteriaDescription'
				--,@EstimatedDischargeDate AS 'EstimatedDischargeDate'       
				,CASE 
					WHEN @SameEpisode = 'Y'
						THEN @EstimatedDischargeDate
					ELSE NULL
					END AS 'EstimatedDischargeDate'
				,@CarePlanAddendumInfo AS CarePlanAddendumInfo
				--,0 AS SupportsInvolvement              
				,CSLD.SupportsInvolvement AS SupportsInvolvement
				,CASE 
					WHEN (
							@CarePlanType = 'AD'
							AND dbo.ssf_GetSystemConfigurationKeyValue('SetReviewInCarePlan') = 'Y'
							)
						THEN @ReviewEntireCareType
					ELSE 'S'
					END AS ReviewEntireCareType
				,CASE 
					WHEN (
							@CarePlanType = 'AD'
							AND dbo.ssf_GetSystemConfigurationKeyValue('SetReviewInCarePlan') = 'Y'
							)
						THEN @ReviewEntireCarePlan
					ELSE NULL
					END AS ReviewEntireCarePlan
				,CASE 
					WHEN (
							@CarePlanType = 'AD'
							AND dbo.ssf_GetSystemConfigurationKeyValue('SetReviewInCarePlan') = 'Y'
							)
						THEN @ReviewEntireCarePlanDate
					ELSE NULL
					END AS ReviewEntireCarePlanDate
				,CASE 
					WHEN @LatestCarePlanDocumentVersionID IS NULL
						THEN 'N'
					ELSE 'Y'
					END AS PreviousCP
			FROM (
				SELECT 'DocumentCarePlans' AS TableName
				) AS Placeholder
			LEFT JOIN DocumentCarePlans CSLD ON (
					CSLD.DocumentVersionId = @LatestCarePlanDocumentVersionID
					AND ISNULL(CSLD.RecordDeleted, 'N') = 'N'
					)
		END

		----For CarePlanDomains                  
		--SELECT 'CarePlanDomains' AS TableName            
		-- ,CPD.[CarePlanDomainId]            
		-- ,CPD.[CreatedBy]            
		-- ,CPD.[CreatedDate]            
		-- ,CPD.[ModifiedBy]            
		-- ,CPD.[ModifiedDate]            
		-- ,CPD.[RecordDeleted]            
		-- ,CPD.[DeletedBy]            
		-- ,CPD.[DeletedDate]            
		-- ,CPD.[DomainName]            
		--FROM CarePlanDomains AS CPD            
		--WHERE ISNull(CPD.RecordDeleted, 'N') = 'N'            
		--ORDER BY CPD.DomainName            
		----CarePlanDomainNeeds                  
		--SELECT 'CarePlanDomainNeeds' AS TableName            
		-- ,CPDN.CarePlanDomainNeedId            
		-- ,CPDN.CreatedBy            
		-- ,CPDN.CreatedDate            
		-- ,CPDN.ModifiedBy            
		-- ,CPDN.ModifiedDate            
		-- ,CPDN.RecordDeleted            
		-- ,CPDN.DeletedBy            
		-- ,CPDN.DeletedDate            
		-- ,CPDN.NeedName            
		-- ,CPDN.CarePlanDomainId            
		-- ,CPDN.MHAFieldIdentifierCode            
		-- ,CPDN.MHANeedDescription            
		--FROM CarePlanDomainNeeds AS CPDN            
		--WHERE ISNull(CPDN.RecordDeleted, 'N') = 'N'            
		----CarePlanDomainGoals                  
		--SELECT 'CarePlanDomainGoals' AS TableName            
		-- ,CPDG.CarePlanDomainGoalId            
		-- ,CPDG.CreatedBy            
		-- ,CPDG.CreatedDate            
		-- ,CPDG.ModifiedBy            
		-- ,CPDG.ModifiedDate            
		-- ,CPDG.RecordDeleted            
		-- ,CPDG.DeletedBy            
		-- ,CPDG.DeletedDate            
		-- ,CPDG.CarePlanDomainNeedId            
		-- ,CPDG.GoalDescription            
		-- ,CPDG.Adult            
		--FROM CarePlanDomainGoals AS CPDG            
		--WHERE ISNull(CPDG.RecordDeleted, 'N') = 'N'            
		----CarePlanDomainObjectives                   
		--SELECT 'CarePlanDomainObjectives' AS TableName            
		-- ,CPDO.[CarePlanDomainObjectiveId]            
		-- ,CPDO.[CreatedBy]            
		-- ,CPDO.[CreatedDate]            
		-- ,CPDO.[ModifiedBy]            
		-- ,CPDO.[ModifiedDate]            
		-- ,CPDO.[RecordDeleted]            
		-- ,CPDO.[DeletedBy]            
		-- ,CPDO.[DeletedDate]            
		-- ,CPDO.[CarePlanDomainGoalId]            
		-- ,CPDO.[ObjectiveDescription]            
		-- ,CPDO.[Adult]            
		--FROM [CarePlanDomainObjectives] CPDO            
		--WHERE ISNULL(CPDO.RecordDeleted, 'N') = 'N'            
		EXEC CSP_CustomINITCAREPLANNEEDS @ClientID
			,@LatestCarePlanDocumentVersionID
			,@EffectiveDateDifference;

		CREATE TABLE #TempAuthorizationCodes (
			AuthorizationCodeId INT
			,AuthorizationCodeName VARCHAR(100)
			,CarePlanPrescribedServiceId INT
			,DocumentVersionId INT
			,NumberOfSessions INT
			,[Units] DECIMAL
			,[UnitType] INT
			,[FrequencyType] INT
			,[PersonResponsible] INT
			,[IsChecked] CHAR(1)
			,TableName VARCHAR(100)
			)

		EXEC ssp_GetCarePlanPrescribedServicesAuthorizationCodes @ClientID
			,@LatestCarePlanDocumentVersionID
			,'I';

		SELECT AuthorizationCodeId
			,AuthorizationCodeName
			,CarePlanPrescribedServiceId
			,DocumentVersionId
			,NumberOfSessions
			,[Units]
			,[UnitType]
			,[FrequencyType]
			,[PersonResponsible]
			,[IsChecked]
			,TableName
		FROM #TempAuthorizationCodes

		SELECT 'CustomCarePlanPrescribedServiceObjectives' AS TableName
			,CPSO.CarePlanPrescribedServiceObjectiveId
			,CPS.CarePlanPrescribedServiceId
			,CPSO.CarePlanObjectiveId
			,CAST(CPO.ObjectiveNumber AS VARCHAR(100)) ObjectiveNumber
			,CDO.ObjectiveDescription
		FROM CustomCarePlanPrescribedServiceObjectives CPSO
		LEFT JOIN CustomCarePlanPrescribedServices CPS ON CPS.CarePlanPrescribedServiceId = CPSO.CarePlanPrescribedServiceId
			AND ISNULL(CPS.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(CPSO.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN CarePlanObjectives CPO ON CPO.CarePlanObjectiveId = CPSO.CarePlanObjectiveId
			AND ISNULL(CPO.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN CarePlanDomainObjectives CDO ON CDO.CarePlanDomainObjectiveId = CPO.CarePlanDomainObjectiveId
		WHERE CPS.DocumentVersionID = @LatestCarePlanDocumentVersionID;

		EXEC ssp_InitCustomDiagnosisStandardInitializationNew @ClientID
			,@StaffID
			,@CustomParameters;

		EXEC ssp_InitCarePlanGoals @LatestCarePlanDocumentVersionID

		SELECT 'CarePlanPrograms' AS TableName
			,P.ProgramId
			,P.ProgramName
			,CP.AssignedStaffId AS StaffId
			,COALESCE(S.LastName, '') + ', ' + COALESCE(S.FirstName, '') AS [StaffName]
			,- 1 AS DocumentVersionId
			,CAST(NULL AS CHAR(1)) AS AssignForContribution
		--CAST(NULL AS INT) AS DocumentAssignedTaskId               
		FROM ClientPrograms CP
		LEFT JOIN Programs P ON CP.ProgramId = P.ProgramId
		LEFT JOIN Staff S ON S.StaffId = CP.AssignedStaffId
			AND S.Active = 'Y'
		WHERE ISNULL(CP.RecordDeleted, 'N') <> 'Y'
			AND CP.AssignedStaffId IS NOT NULL
			AND CP.ClientId = @ClientID
			AND CP.STATUS IN (
				1
				,4
				) /*GloablCodeId - 1-'Requested',4-'Enrolled' Status*/
			AND EXISTS (
				SELECT *
				FROM dbo.ssf_RecodeValuesCurrent('CAREPLANPROGRAMTYPE') AS CD
				WHERE CD.IntegerCodeId = P.ProgramType
				)

		-- SELECT 'CustomDocumentCarePlans' AS TableName    
		-- --,-1 AS DocumentVersionId    
		-- --,CDCP.CreatedBy    
		-- --,CDCP.CreatedDate    
		-- --,CDCP.ModifiedBy    
		-- --,CDCP.ModifiedDate    
		-- --,CDCP.RecordDeleted    
		-- --,CDCP.DeletedBy    
		-- ,CDCP.UMArea    
		--FROM SystemConfigurations AS s    
		--LEFT JOIN CustomDocumentCarePlans CDCP ON s.DatabaseVersion = - 1    
		SELECT 'CustomDocumentCarePlans' AS TableName
			,- 1 AS DocumentVersionId
			,'' AS CreatedBy
			,GETDATE() AS CreatedDate
			,'' AS ModifiedBy
			,GETDATE() AS ModifiedDate
			,CDCP.UMArea
		FROM systemconfigurations s
		LEFT OUTER JOIN CustomDocumentCarePlans CDCP ON DocumentVersionId = - 1

		SELECT 'CustomCarePlanPrescribedServices' AS TableName
			,- 1 AS DocumentVersionId
			,CCPPS.CreatedBy
			,CCPPS.CreatedDate
			,CCPPS.ModifiedBy
			,CCPPS.ModifiedDate
			,CCPPS.RecordDeleted
			,CCPPS.DeletedBy
			,CCPPS.DeletedDate
		FROM SystemConfigurations AS s
		LEFT JOIN CustomCarePlanPrescribedServices CCPPS ON s.DatabaseVersion = - 1

		--IF(@VersionRecent IS NOT NULL )
		--	BEGIN
		--		Select DISTINCT TIP.SiteId AS 'ProviderId',TIP.AuthorizationCodeId AS 'AuthorizationCodeId',TIP.StartDate AS 'FromDate',
		--		TIP.EndDate AS 'ToDate',TIP.Units AS 'Units',
		--		TIP.CreatedBy, TIP.CreatedDate, TIP.ModifiedBy, TIP.ModifiedDate, 
		--		TIP.RecordDeleted, TIP.DeletedDate, TIP.DeletedBy,'CustomCarePlanPrescribedServices' as TableName       

		--		from TPInterventionProcedures   TIP                                    
		--		left join TPProcedures TP on  TIP.TPProcedureId=TP.TPProcedureId  and ISNULL(TP.RecordDeleted,'N')='N'                                                                            
		--		where NeedId In(Select NeedID from TPNeeds                                 
		--		where DocumentVersionId  = @VersionRecent                                 
		--		and (RecordDeleted is null or RecordDeleted ='N')                                 
		--		and GoalActive='Y'                                
		--		)                                                                          
		--		and (TIP.RecordDeleted is null or TIP.RecordDeleted ='N')     
		--	END
		--ELSE
		--	BEGIN
		--		SELECT 'CustomCarePlanPrescribedServices' AS TableName
		--			,- 1 AS DocumentVersionId
		--			,CCPPS.CreatedBy
		--			,CCPPS.CreatedDate
		--			,CCPPS.ModifiedBy
		--			,CCPPS.ModifiedDate
		--			,CCPPS.RecordDeleted
		--			,CCPPS.DeletedBy
		--			,CCPPS.DeletedDate
		--		FROM SystemConfigurations AS s
		--		LEFT JOIN CustomCarePlanPrescribedServices CCPPS ON s.DatabaseVersion = - 1
		--	END

		-- PreviouslyRequested              
		EXEC ssp_SCGetPreviouslyRequestedUMCodeUnits @ClientID,@VersionRecent   


	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_CustomInitCarePlanInitial') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                 
				16
				,-- Severity.                                                                        
				1 -- State.                                                                     
				);
	END CATCH
END
