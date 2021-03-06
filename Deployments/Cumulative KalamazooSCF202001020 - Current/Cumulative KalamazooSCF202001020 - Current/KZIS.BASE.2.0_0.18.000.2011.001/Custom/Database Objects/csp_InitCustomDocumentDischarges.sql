
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentDischarges]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomDocumentDischarges]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[csp_InitCustomDocumentDischarges] 
 (
	@ClientID INT
	,@StaffID INT
	,@CustomParameters XML
	)
AS
-- =============================================    
-- Author      : Anto.G 
-- Date        : 12/FEB/2015  
-- Purpose     : Initializing SP Created.	
-- =============================================   
BEGIN
	BEGIN TRY
	DECLARE @LatestDocumentVersionID INT
	DECLARE @SummaryOfServiceProvided VARCHAR(MAX)
	DECLARE @ProgramIDs VARCHAR(200)
	DECLARE @LatestAssessmentDocumentVersionID INT
	DECLARE @PresentingProblem VARCHAR(MAX)
	DECLARE @LatestMHAssessmentDocumentVersionID INT
	DECLARE @CustomEducationLevel INT
	DECLARE @CustomServingMilitary INT
	DECLARE @RegMartialStatus INT
	DECLARE @EducationalStatus INT
	DECLARE @EmploymentStatus INT
	DECLARE @CustomForensicTreatment INT
	DECLARE @CustomLegal INT
	DECLARE @JusticeSystemInvolvement INT
	DECLARE @LivingArrangement INT
	DECLARE @CustomAdvanceDirective INT
	DECLARE @CountyResidence INT
	DECLARE @CountyResponsibility INT
	DECLARE @PrimaryProgramID INT
	DECLARE @DiagnosisDocumentVersionID INT
	DECLARE @TobaccoUse INT
	DECLARE @AgeOfFirstTobaccoUse VARCHAR(25)
    DECLARE @DocumentCodeId INT

	SELECT TOP 1 @LatestDocumentVersionID = CurrentDocumentVersionId
	FROM CustomDocumentDischarges CDSA
	INNER JOIN Documents Doc ON CDSA.DocumentVersionId = Doc.CurrentDocumentVersionId
	WHERE Doc.ClientId = @ClientID
		AND Doc.[Status] = 22
		AND ISNULL(CDSA.RecordDeleted, 'N') = 'N'
		AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
	ORDER BY Doc.EffectiveDate DESC
		,Doc.ModifiedDate DESC
		
	SET @LatestDocumentVersionId = ISNULL(@LatestDocumentVersionId, - 1)
	
	SELECT @ProgramIDs = COALESCE(@ProgramIDs + ', ' + CONVERT(VARCHAR(20), ClientProgramId), CONVERT(VARCHAR(20), ClientProgramId))
		FROM ClientPrograms
		WHERE ClientId = @ClientID
			AND IsNull(RecordDeleted, 'N') = 'N'
			AND [Status] <> 5   
 
    EXEC csp_SCGetSummaryServicesProvided @ClientId =@ClientId,@ProgramIdCSV=@ProgramIDs,@SummaryOfService=@SummaryOfServiceProvided OUTPUT      	
	
	
	--Assessment PresentingProblem--
	
	--SELECT TOP 1 @LatestAssessmentDocumentVersionID = CurrentDocumentVersionId
	--FROM CustomHRMAssessments CDCD
	--INNER JOIN Documents Doc ON CDCD.DocumentVersionId = Doc.CurrentDocumentVersionId
	--WHERE Doc.ClientId = @ClientID
	--	AND Doc.[Status] = 22
	--	AND ISNULL(CDCD.RecordDeleted, 'N') = 'N'
	--	AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
	--ORDER BY Doc.EffectiveDate DESC
	--	,Doc.ModifiedDate DESC
	
	--SET @LatestAssessmentDocumentVersionID = ISNULL(@LatestAssessmentDocumentVersionID, -2)
	
	--SELECT top 1 @PresentingProblem = PresentingProblem from CustomHRMAssessments where DocumentVersionId = @LatestAssessmentDocumentVersionID and isnull(RecordDeleted,'N')='N'

	--END PresentingProblem

    SELECT TOP 1 @LatestMHAssessmentDocumentVersionID = D.CurrentDocumentVersionId,@DocumentCodeId = D.DocumentCodeId FROM Documents D
	INNER JOIN DocumentCodes DC ON DC.DocumentCodeId = D.DocumentCodeId
	WHERE D.ClientId = @ClientID AND D.[Status] = 22 AND D.DocumentCodeId IN (1469,60064) AND ISNULL(DC.RecordDeleted, 'N') = 'N' AND ISNULL(D.RecordDeleted, 'N') = 'N' 
	ORDER BY D.EffectiveDate DESC,D.ModifiedDate DESC
	
	SET @LatestAssessmentDocumentVersionID = ISNULL(@LatestMHAssessmentDocumentVersionID, -2)
	
	IF @DocumentCodeId = 1469
	BEGIN
	SELECT top 1 @PresentingProblem = PresentingProblem from CustomHRMAssessments where DocumentVersionId = @LatestAssessmentDocumentVersionID and isnull(RecordDeleted,'N')='N'
	END
	ELSE
	BEGIN
	SELECT top 1 @PresentingProblem = PresentingProblem from CustomDocumentMHAssessments where DocumentVersionId = @LatestAssessmentDocumentVersionID and isnull(RecordDeleted,'N')='N'
	END	
	
	--SELECT TOP 1 @TobaccoUse = TobaccoUse,@AgeOfFirstTobaccoUse = AgeOfFirstTobaccoUse,@CustomEducationLevel = EducationLevel,@CustomForensicTreatment = ForensicTreatment,@CustomLegal = Legal,@JusticeSystemInvolvement = JusticeSystemInvolvement,@CustomAdvanceDirective = AdvanceDirective  from CustomClients where ClientId = @ClientID
	SELECT TOP 1 @RegMartialStatus = MaritalStatus,@CustomServingMilitary=MilitaryStatus,@EducationalStatus = EducationalStatus,@EmploymentStatus = EmploymentStatus,@LivingArrangement = LivingArrangement,@CountyResidence = CountyOfResidence,@CountyResponsibility = CountyOfTreatment from clients where  ClientId = @ClientID
	
	SELECT @PrimaryProgramID = ClientProgramId
		FROM ClientPrograms
		WHERE ClientId = @ClientID
			AND PrimaryAssignment = 'Y'
			AND IsNull(RecordDeleted, 'N') = 'N'
			AND [Status] <> 5  
			
			
			
			
	SELECT TOP 1 @DiagnosisDocumentVersionID = CurrentDocumentVersionId
	FROM DocumentDiagnosis D
	INNER JOIN Documents Doc ON D.DocumentVersionId = Doc.CurrentDocumentVersionId
	WHERE Doc.ClientId = @ClientID
		AND Doc.[Status] = 22
		AND ISNULL(D.RecordDeleted, 'N') = 'N'
		AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
	ORDER BY Doc.EffectiveDate DESC
		,Doc.ModifiedDate DESC
	--IF(@DiagnosisDocumentVersionID > 0 )
	
	
DECLARE @LatestICD10DocumentVersionID INT
DECLARE @ICD10Check Char(1)
DECLARE @AdminCloseGlobalcode INT

set @LatestICD10DocumentVersionID =(select top 1 CurrentDocumentVersionId                                    
from Documents a  Inner Join DocumentCodes Dc on Dc.DocumentCodeid=a.DocumentCodeid                                                       
where a.ClientId = @ClientID and a.EffectiveDate <= convert(datetime, convert(varchar, getDate(),101))                                                        
and a.Status = 22    and Dc.DiagnosisDocument='Y' and a.DocumentCodeId=1601 and isNull(a.RecordDeleted,'N')<>'Y' and isNull(Dc.RecordDeleted,'N')<>'Y'                                                                                          
order by a.EffectiveDate desc,a.ModifiedDate desc )
SELECT @AdminCloseGlobalcode = GlobalCodeId FROM GlobalCodes where Category = 'xPROGDISCHARGEREASON' and CodeName = 'Administrative Close'


IF(@LatestICD10DocumentVersionID <> '')
BEGIN
Set @ICD10Check = 'Y'
END
ELSE
BEGIN
Set @ICD10Check = 'N'
END	
	
	
	
	
	
SELECT 'CustomDocumentDischarges' AS TableName
		,- 1 AS DocumentVersionId
		,'' AS CreatedBy
		,GETDATE() AS CreatedDate
		,'' AS ModifiedBy
		,GETDATE() AS ModifiedDate,
		RecordDeleted,
		DeletedBy,
		DeletedDate,
		@PrimaryProgramID as NewPrimaryClientProgramId,
		DischargeType,
		--TransitionDischarge,
		CASE When @ICD10Check = 'N' THEN @AdminCloseGlobalcode ELSE NULL END as TransitionDischarge, 
		DischargeDetails,
		OverallProgress, 
		StatusLastContact,
		@CustomEducationLevel as EducationLevel,
		@RegMartialStatus as MaritalStatus,
		@EducationalStatus as EducationStatus,
		@EmploymentStatus as EmploymentStatus,
		@CustomForensicTreatment as ForensicCourtOrdered, 
		@CustomServingMilitary as CurrentlyServingMilitary,
		@CustomLegal as Legal,
		@JusticeSystemInvolvement as JusticeSystem,
		@LivingArrangement as LivingArrangement, 
		Arrests,
		@CustomAdvanceDirective as AdvanceDirective,
		@TobaccoUse AS TobaccoUse,
		@AgeOfFirstTobaccoUse AS AgeOfFirstTobaccoUse,
		@CountyResidence as CountyResidence,
		@CountyResponsibility as CountyFinancialResponsibility,
		NoReferral, 
		SymptomsReoccur, 
		ReferredTo, 
		Reason,
		DatesTimes,
		ReferralDischarge,
		Treatmentcompletion,
		--ISNULL(@SummaryOfServiceProvided, 'No services have been providedd') AS 'SummaryOfServicesProvided'
		--,ISNULL(@PresentingProblem, 'No formal assessmentt') AS 'PresentingProblems'
		ISNULL(@SummaryOfServiceProvided, '') AS 'SummaryOfServicesProvided'
		,ISNULL(@PresentingProblem, 'No formal assessment') AS 'PresentingProblems'
		
	FROM systemconfigurations s
	LEFT OUTER JOIN CustomDocumentDischarges  ON DocumentVersionId = @LatestDocumentVersionID	
	
	
	DECLARE @RecordCount INT

		SELECT @RecordCount = (SELECT count(ClientProgramId) AS RecordCount FROM ClientPrograms CP WHERE CP.ClientId = @ClientID AND IsNull(CP.RecordDeleted, 'N') = 'N' AND CP.Status IN (4)) /*Program Status 'Reguested','Enrolled' */

		IF(@RecordCount>0)        
		BEGIN
		SELECT Placeholder.TableName
			,CP.ClientProgramId
			,CP.ClientId
			,CP.ProgramId
			,CP.Status
			,CP.RequestedDate
			,CP.EnrolledDate
			,CP.DischargedDate
			,CP.PrimaryAssignment
			,CP.Comment
			,AssignedStaffId
			,CP.CreatedBy
			,CP.CreatedDate
			,CP.ModifiedBy
			,CP.ModifiedDate
			,CP.RecordDeleted
			,CP.DeletedDate
			,CP.DeletedBy
			,'N' AS IsInitialize			
			,@LatestDocumentVersionID AS 'CurrentDocumentVersionId'
		FROM (SELECT 'ClientPrograms' AS TableName) AS Placeholder
		LEFT JOIN ClientPrograms CP ON (CP.ClientId = @ClientID AND IsNull(CP.RecordDeleted, 'N') = 'N' AND CP.[Status] IN (4))
		END
	

	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_InitCustomDocumentDischarges') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                                  
				16
				,-- Severity.                                                                                                  
				1 -- State.                                                                                                  
				);
	END CATCH
END

