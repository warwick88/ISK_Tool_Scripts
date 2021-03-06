 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentDischarges]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentDischarges]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[csp_RDLCustomDocumentDischarges]                                          
(                                                            
 @DocumentVersionId as int                                                            
)                                            
AS          
                                                       
                                                          
/*********************************************************************                        
-- Stored Procedure: dbo.[csp_RDLCustomDocumentDischarges]                                                           
                          
-- Creation Date:    28.11.2014                       
--                         
-- Purpose:  Return Tables for CustomDocumentDischarge and fill the type Dataset                        
--                        
-- Create:                        
--   Date       Author    Purpose                        
--  03.FEB.2015  Anto     To fetch CustomDocumentDischarge               
--        
*********************************************************************/     
BEGIN                                                      
  BEGIN TRY  

	DECLARE @ClientId INT
	DECLARE @OrganizationName VARCHAR(250)
	DECLARE @DocumentName  VARCHAR(100)
	
	
	DECLARE @SummaryOfServiceProvided VARCHAR(MAX)
	DECLARE @ProgramIDs VARCHAR(200)
	DECLARE @LatestAssessmentDocumentVersionID INT
	DECLARE @PresentingProblem VARCHAR(MAX)
	DECLARE @CountyResidence VARCHAR(200)
	DECLARE @CountyResponse VARCHAR(200)
	DECLARE @CountyResidenceId INT
	DECLARE @CountyResponseId INT
	DECLARE @AddressDetails VARCHAR(MAX)
	DECLARE @LatestMHAssessmentDocumentVersionID INT
	DECLARE @ClientName VARCHAR(100)			
	DECLARE @EffectiveDate VARCHAR(10)
	DECLARE @DOB VARCHAR(10)
	

	select @ClientId = ClientId from documents where InProgressDocumentVersionId = @DocumentVersionId		
	SELECT TOP 1 @OrganizationName = OrganizationName FROM SystemConfigurations
	
	SELECT @ClientName = C.LastName + ', ' + C.FirstName						
			,@EffectiveDate = CASE 
				WHEN Documents.EffectiveDate IS NOT NULL
					THEN CONVERT(VARCHAR(10), Documents.EffectiveDate, 101)
				ELSE ''
				END
			,@DOB = CASE 
				WHEN C.DOB IS NOT NULL
					THEN CONVERT(VARCHAR(10), C.DOB, 101)
				ELSE ''
				END			
		FROM Documents
		JOIN Staff S ON Documents.AuthorId = S.StaffId
		JOIN Clients C ON Documents.ClientId = C.ClientId
			AND isnull(C.RecordDeleted, 'N') <> 'Y'
		JOIN DocumentVersions dv ON dv.DocumentId = documents.DocumentId
		INNER JOIN DocumentCodes on DocumentCodes.DocumentCodeid= Documents.DocumentCodeId      
			AND ISNULL(DocumentCodes.RecordDeleted,'N')='N' 
		LEFT JOIN GlobalCodes GC ON S.Degree = GC.GlobalCodeId
		WHERE dv.DocumentVersionId = @DocumentVersionId
			AND isnull(Documents.RecordDeleted, 'N') = 'N'
	
	
	SELECT @DocumentName = DocumentCodes.DocumentName 
		FROM Documents
		JOIN Staff S ON Documents.AuthorId = S.StaffId
		JOIN Clients C ON Documents.ClientId = C.ClientId
			AND isnull(C.RecordDeleted, 'N') <> 'Y'
		JOIN DocumentVersions dv ON dv.DocumentId = documents.DocumentId
		INNER JOIN DocumentCodes on DocumentCodes.DocumentCodeid= Documents.DocumentCodeId      
			AND ISNULL(DocumentCodes.RecordDeleted,'N')='N' 
		LEFT JOIN GlobalCodes GC ON S.Degree = GC.GlobalCodeId
		WHERE dv.DocumentVersionId = @DocumentVersionId
			AND isnull(Documents.RecordDeleted, 'N') = 'N'	
			
			
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
	
	--SELECT top 1 @PresentingProblem = PresentingProblem from CustomHRMAssessments where DocumentVersionId = @LatestAssessmentDocumentVersionID
	SELECT TOP 1 @LatestMHAssessmentDocumentVersionID = CurrentDocumentVersionId
	FROM CustomDocumentMHAssessments CDCD
	INNER JOIN Documents Doc ON CDCD.DocumentVersionId = Doc.CurrentDocumentVersionId
	WHERE Doc.ClientId = @ClientID
		AND Doc.[Status] = 22
		AND ISNULL(CDCD.RecordDeleted, 'N') = 'N'
		AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
	ORDER BY Doc.EffectiveDate DESC
		,Doc.ModifiedDate DESC
	
	SET @LatestAssessmentDocumentVersionID = ISNULL(@LatestMHAssessmentDocumentVersionID, -2)
	
	SELECT top 1 @PresentingProblem = PresentingProblem from CustomDocumentMHAssessments where DocumentVersionId = @LatestAssessmentDocumentVersionID and isnull(RecordDeleted,'N')='N'
	--END PresentingProblem	
	
	-- CountyResidence and CountyFinancialResponsibility --

	Select @CountyResidenceId = CountyResidence from CustomDocumentDischarges where  DocumentVersionId = @DocumentVersionId
	Select @CountyResponseId = CountyFinancialResponsibility from CustomDocumentDischarges where  DocumentVersionId = @DocumentVersionId
	
	IF @CountyResidenceId != ''
	BEGIN
	select @CountyResidence = CountyName from Counties where CountyFIPS = @CountyResidenceId
	END
	ELSE
	BEGIN
	SET @CountyResidence = ''
	END
	PRINT @CountyResidence
	
	IF @CountyResponseId != ''
	BEGIN
	select @CountyResponse = CountyName from Counties where CountyFIPS = @CountyResponseId
	END
	ELSE
	BEGIN
	SET @CountyResponse = ''
	END
	
	select @CountyResponse = CountyName from Counties where CountyFIPS = @CountyResponseId
	
	--	END CountyResidence		
	
	---Address
	
	SELECT  @AddressDetails = CA.[Address] + '' + CA.City + '' + CA.[State] + '' + CA.Zip  FROM ClientAddresses CA LEFT JOIN GlobalCodes GC ON CA.AddressType = GC.GlobalCodeId WHERE ClientId =  @ClientId
	
	AND ISNULL(CA.RecordDeleted, 'N') = 'N'
	
	
	--Discharge
	
	
	DECLARE @Discharge Char(2) = ''
	DECLARE @Count INT
	select @Count = Count(*) from CustomDischargePrograms where DocumentVersionId = @DocumentVersionId and recorddeleted = 'N'
	IF ( @Count >= 1)
	BEGIN
	SET @Discharge = 'D'
	END
	
	
	
		SELECT DocumentVersionId,
		CreatedBy,
		CreatedDate,
		ModifiedBy,
		ModifiedDate,
		RecordDeleted,
		DeletedBy,
		DeletedDate,
		@ClientId as ClientId,
		NewPrimaryClientProgramId,
		DischargeType,
		dbo.csf_GetGlobalCodeNameById([TransitionDischarge])as TransitionDischarge,
		DischargeDetails,
		OverallProgress, 
		StatusLastContact,
		dbo.csf_GetGlobalCodeNameById([EducationLevel])as  EducationLevel,
		dbo.csf_GetGlobalCodeNameById([MaritalStatus])as MaritalStatus,
		dbo.csf_GetGlobalCodeNameById([EducationStatus])as EducationStatus,
		dbo.csf_GetGlobalCodeNameById([EmploymentStatus])as EmploymentStatus,
		dbo.csf_GetGlobalCodeNameById([ForensicCourtOrdered])as ForensicCourtOrdered, 
		dbo.csf_GetGlobalCodeNameById([CurrentlyServingMilitary])as CurrentlyServingMilitary,
		dbo.csf_GetGlobalCodeNameById([Legal])as Legal,
		dbo.csf_GetGlobalCodeNameById([JusticeSystem])as JusticeSystem,
		dbo.csf_GetGlobalCodeNameById([LivingArrangement])as LivingArrangement, 
		Arrests,
		dbo.csf_GetGlobalCodeNameById([AdvanceDirective])as AdvanceDirective,
		dbo.csf_GetGlobalCodeNameById([TobaccoUse])as TobaccoUse,
		AgeOfFirstTobaccoUse,
		@CountyResidence as CountyResidence,
		@CountyResponse as CountyFinancialResponsibility,
		@AddressDetails as AddressDetails,
		NoReferral, 
		SymptomsReoccur, 
		ReferredTo, 
		Reason,
		DatesTimes,
		dbo.csf_GetGlobalCodeNameById([ReferralDischarge])as ReferralDischarge,
		dbo.csf_GetGlobalCodeNameById([Treatmentcompletion])as Treatmentcompletion,
		@OrganizationName AS OrganizationName,	
		@DocumentName AS DocumentName,
		ISNULL(@SummaryOfServiceProvided, 'No services have been providedd') AS 'SummaryOfServicesProvided'
		,ISNULL(@PresentingProblem, 'No formal assessment') AS 'PresentingProblems'
		,@ClientName as ClientName
		,@EffectiveDate as EffectiveDate
		,@DOB as DOB

		FROM CustomDocumentDischarges Where DocumentVersionId = @DocumentVersionId AND ISNULL (RecordDeleted,'N') = 'N'
		
		
		
		SELECT
		CR.DischargeReferralId,
		CR.CreatedBy,
		CR.CreatedDate,
		CR.ModifiedBy,
		CR.ModifiedDate,
		CR.RecordDeleted,
		CR.DeletedBy,
		CR.DeletedDate,
		CR.DocumentVersionId,
		CR.Referral,
		CR.Program,
		GC.CodeName as ReferralText,
		GSC.SubCodeName as ProgramText
	FROM CustomDischargeReferrals CR 
	  left join GlobalCodes GC 
	  ON CR.Referral = GC.GlobalCodeId  left join GlobalSubCodes GSC ON CR.Program = GSC.GlobalSubCodeId
	WHERE CR.DocumentVersionId = @DocumentVersionId
		
		
		
		
  
	END TRY	                                             
   
 BEGIN CATCH  
  DECLARE @Error varchar(8000)                             
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                           
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RDLCustomDocumentDischarges')                                                           
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                            
   + '*****' + Convert(varchar,ERROR_STATE())                                                          
  RAISERROR                                                           
  (                                                          
   @Error, -- Message text.                                                          
   16, -- Severity.                                                          
   1 -- State.                                                          
  )           
 END CATCH                                                
End  