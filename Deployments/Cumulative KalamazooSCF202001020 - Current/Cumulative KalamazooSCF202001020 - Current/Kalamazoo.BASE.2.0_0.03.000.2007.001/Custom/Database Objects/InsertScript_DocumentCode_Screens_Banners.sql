
/********************************************************************************                                                     
-- Copyright: Streamline Healthcare Solutions  
-- "Individualized Service Plan"
-- Purpose: Script to add entries in Screens and DocumentCodes table for Task #8 KCMHSAS Improvements 
--  
-- Date:    11 May 2020
--  
-- *****History****  
--	Date			Author			  Description
   11 May 2020     Ankita Sinha      Task #8 KCMHSAS Improvements

*********************************************************************************/
DECLARE @DocumentCodeId INT
DECLARE @ScreenId INT
DECLARE @ScreenType INT
DECLARE @DocumentType INT
DECLARE @Active CHAR(1)
DECLARE @ScreenName VARCHAR(64)
DECLARE @BannerName VARCHAR(64)
DECLARE @DocumentName VARCHAR(64)
DECLARE @ScreenURL VARCHAR(200)
DECLARE @DetailScreenPostUpdateSP VARCHAR(64)
DECLARE @TableList VARCHAR(MAX)
DECLARE @RDLName VARCHAR(64)
DECLARE @ViewStoredProcedure VARCHAR(64)
DECLARE @GetDataSp VARCHAR(64)
DECLARE @InitializationStoredProcedure VARCHAR(64)
DECLARE @ValidationStoredProcedureComplete VARCHAR(64)
DECLARE @PostUpdateStoredProcedure VARCHAR(64)
DECLARE @WarningStoredProcedureComplete VARCHAR(100)
DECLARE @TabId INT
DECLARE @ServiceNote CHAR(1)
DECLARE @OnlyAvailableOnline CHAR(1)
DECLARE @RequiresSignature CHAR(1)
DECLARE @AllowEditingByNonAuthors CHAR(1)
DECLARE @DefaultCoSigner CHAR(1)
DECLARE @DefaultGuardian CHAR(1)
DECLARE @NewValidationStoredProcedure VARCHAR(64)
DECLARE @ValidationStoredProcedure VARCHAR(64)
DECLARE @MultipleCredentials  CHAR(1)
DECLARE @RecreatePDFOnClientSignature  CHAR(1)
DECLARE @DiagnosisDocument  CHAR(1)
DECLARE @SignatureDateAsEffectiveDate  CHAR(1)
DECLARE @Need5Columns  CHAR(1)
DECLARE @RequiresLicensedSignature  CHAR(1)
DECLARE @InitializationProcess  int
DECLARE @FormCollectionId int
DECLARE @RegenerateRDLOnCoSignature CHAR(1)
DECLARE @HelpURL VARCHAR(max)
DECLARE @Code VARCHAR(100)

SET @Code='8AF7837B-05A7-4DF8-B2ED-6B852A5BA50A'
SET @ScreenType = 5763
SET @DocumentType = 10
SET @Active = 'Y'
SET @ScreenName = 'Individualized Service Plan'
SET @BannerName ='Individualized Service Plan'
SET @DocumentName = 'Individualized Service Plan'
SET @ScreenURL = '/Custom/CarePlan/WebPages/CarePlanMain.ascx'
SET @TableList = 'DocumentCarePlans,CarePlanDomains,CarePlanDomainNeeds,CarePlanDomainGoals,CarePlanNeeds,CarePlanGoals,CarePlanGoalNeeds,CarePlanObjectives,CustomCarePlanPrescribedServices,CustomCarePlanPrescribedServiceObjectives,CarePlanPrograms,CarePlanDomainObjectives,ClientProgramsAuthorizationCodes,DocumentDiagnosisCodes,DocumentDiagnosis,DocumentDiagnosisFactors,CustomDocumentCarePlans' 
SET @RDLName = 'RDLGLDSTDCarePlan'
SET @ViewStoredProcedure = 'ssp_RdlCarePlan'
SET @GetDataSp = 'csp_CustomGetCarePlanInitial'
SET @InitializationStoredProcedure = 'csp_CustomInitCarePlanInitial'
SET @ValidationStoredProcedureComplete ='csp_SCValidateCarePlans';
SET @PostUpdateStoredProcedure = NULL 
SET @TabId = 2
SET @ServiceNote = 'N'
SET @OnlyAvailableOnline = 'N'
SET @RequiresSignature = 'Y'
SET @AllowEditingByNonAuthors = 'Y'
SET @DefaultCoSigner = 'N'
SET @DefaultGuardian = 'N'
set @NewValidationStoredProcedure = NULL; 
set @ValidationStoredProcedure = NULL;
set @MultipleCredentials  = 'Y'
set @RecreatePDFOnClientSignature = 'Y'
set @DiagnosisDocument = NULL;
set @SignatureDateAsEffectiveDate = 'Y'
set @Need5Columns = 'N'
set @RequiresLicensedSignature = NULL
set @InitializationProcess = NULL
set @FormCollectionId = NULL
set @RegenerateRDLOnCoSignature = 'Y'
SET @WarningStoredProcedureComplete=NULL

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentCodes
		WHERE Code = @Code
			AND DocumentType = @DocumentType
			AND ISNULL(Active,'N') = @Active AND ISNULL(RecordDeleted,'N')='N'
		)
BEGIN
	

	INSERT INTO DocumentCodes (
		
		 DocumentName
		,DocumentDescription
		,DocumentType
		,Active
		,ServiceNote
		,OnlyAvailableOnline
		,StoredProcedure
		,TableList
		,RequiresSignature
		,ViewDocumentURL
		,ViewDocumentRDL
		,ViewStoredProcedure
		,AllowEditingByNonAuthors
		,DefaultCoSigner
		,DefaultGuardian
		,NewValidationStoredProcedure 
		,ValidationStoredProcedure
		,MultipleCredentials
		,RecreatePDFOnClientSignature
		,DiagnosisDocument
		,SignatureDateAsEffectiveDate
		,Need5Columns
		,RequiresLicensedSignature 
		,InitializationProcess
		,FormCollectionId
		,RegenerateRDLOnCoSignature
		,Code
		)
	VALUES (
		
		@DocumentName
		,@DocumentName
		,@DocumentType
		,@Active
		,@ServiceNote
		,@OnlyAvailableOnline
		,@GetDataSp
		,@TableList
		,@RequiresSignature
		,@RDLName
		,@RDLName
		,@ViewStoredProcedure
		,@AllowEditingByNonAuthors
		,@DefaultCoSigner
		,@DefaultGuardian
		,@NewValidationStoredProcedure
		,@ValidationStoredProcedure
		,@MultipleCredentials
		,@RecreatePDFOnClientSignature
		,@DiagnosisDocument
		,@SignatureDateAsEffectiveDate
		,@Need5Columns
		,@RequiresLicensedSignature 
		,@InitializationProcess
		,@FormCollectionId
		,@RegenerateRDLOnCoSignature
		,@Code
		)
     SET @DocumentCodeId = SCOPE_IDENTITY()
END
ELSE
BEGIN
	SELECT @DocumentCodeId=DocumentCodeId
		FROM DocumentCodes
		WHERE Code = @Code
			AND DocumentType = @DocumentType
			AND ISNULL(Active,'N') = @Active AND ISNULL(RecordDeleted,'N')='N'
		
END

IF NOT EXISTS (
		SELECT ScreenId
		FROM Screens
		WHERE Code = @Code 
		AND ISNULL(RecordDeleted,'N')='N'
		)
BEGIN
	
	INSERT INTO [Screens] (
	
		[ScreenName]
		,[ScreenType]
		,[ScreenURL]
		,[TabId]
		,[DocumentCodeId]
		,[InitializationStoredProcedure]
		,[ValidationStoredProcedureComplete]
		,[PostUpdateStoredProcedure]
		,[WarningStoredProcedureComplete]
		,[HelpURL]
		,[Code]
		)
	VALUES (
		
		@ScreenName
		,@ScreenType
		,@ScreenURL
		,@TabId
		,@DocumentCodeId
		,@InitializationStoredProcedure
		,@ValidationStoredProcedureComplete
		,@PostUpdateStoredProcedure
		,@WarningStoredProcedureComplete
		,@HelpURL
		,@Code
		)
		SET @ScreenId=SCOPE_IDENTITY()
	
END
ELSE
BEGIN
	SELECT @ScreenId=ScreenId
		FROM Screens
		WHERE Code = @Code 
		AND ISNULL(RecordDeleted,'N')='N'
END

IF NOT EXISTS (
		SELECT *
		FROM dbo.Banners
		WHERE ScreenId = @ScreenId
		)
BEGIN
	INSERT dbo.Banners (
		BannerName
		,DisplayAs
		,Active
		,DefaultOrder
		,Custom
		,TabId
		,ParentBannerId
		,ScreenId
		)
	VALUES (
		@BannerName		,
		@BannerName		,
		'Y'		,
		1		,
		'Y'		,
		2		,
		21		,
		@ScreenId 
		)
END

----------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE @BannerId INT=(SELECT TOP 1 BannerID FROM Banners WHERE BannerName=@BannerName AND DisplayAs=@BannerName AND ISNULL(RecordDeleted,'N')<>'Y' AND Active='Y' AND ScreenId=@ScreenId)

IF NOT EXISTS (SELECT 1 FROM DocumentNavigations WHERE NavigationName=@ScreenName AND BannerId=@BannerId AND ScreenId=@ScreenId)
BEGIN
	INSERT INTO DocumentNavigations(NavigationName,DisplayAs,Active,ParentDocumentNavigationId,BannerId,ScreenId)
	VALUES (@ScreenName,@ScreenName,'Y',NULL,@BannerId,@ScreenId)
END

------------------------------------------------------------------------------------------------------------------------------------------------------
