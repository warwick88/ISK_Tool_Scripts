/********************************************************************************                                                      
-- Copyright: Streamline Healthcare Solutions    
-- Purpose: Adding Screen, Banner and DocumentCodes entry[Move document from PEP TO Kalamazoo(KCMHSAS Improvements #14)]
-- Author:  Preeti k
-- Date:    03 March 2020
*********************************************************************************/
----------------------------------------   DocumentCodes Table   -----------------------------------  
-- Declaration of variable
DECLARE @DocumentCodeId INT
DECLARE @DocumentName VARCHAR(100)
DECLARE @DocumentType INT
DECLARE @Active CHAR(1)
DECLARE @ServiceNote CHAR(1)
DECLARE @OnlyAvailableOnline CHAR(1)
DECLARE @ViewDocumentURL VARCHAR(500)
DECLARE @ViewDocumentRDL VARCHAR(500)
DECLARE @StoredProcedure VARCHAR(100)
DECLARE @TableList VARCHAR(MAX)
DECLARE @ToBeInitialized CHAR(1)
DECLARE @RequiresSignature CHAR(1)
DECLARE @InitializationStoredProcedure VARCHAR(100)
DECLARE @ValidationStoredProcedure VARCHAR(100)
DECLARE @ViewStoredProcedure VARCHAR(100)
DECLARE @RecreatePDFOnClientSignature CHAR(1)
DECLARE @RegenerateRDLOnCoSignature CHAR(1)
DECLARE @Code VARCHAR(100)
DECLARE @DiagnosisDocument CHAR(1)
DECLARE @DSMV CHAR(1)

-- Setting value to the variables 
SET @DocumentName = 'Adverse Childhood Experience'
SET @DocumentType = 10
SET @Active = 'Y'
SET @ServiceNote = NULL
SET @OnlyAvailableOnline = 'Y'
SET @StoredProcedure = 'csp_SCGetCustomAdverseChildhoodExperiences'
SET @TableList = 'CustomDocumentAdverseChildhoodExperiences'
SET @ToBeInitialized = 'Y'
SET @ViewDocumentURL = 'RDLCustomAdverseChildhoodExperiences'
SET @ViewDocumentRDL = 'RDLCustomAdverseChildhoodExperiences'
SET @RequiresSignature = 'Y'
SET @ValidationStoredProcedure = 'csp_validateCustomAdverseChildhoodExperiences'
SET @ViewStoredProcedure = 'RDLCustomAdverseChildhoodExperiences'
SET @InitializationStoredProcedure = 'csp_InitCustomAdverseChildhoodExperiences'
SET @RecreatePDFOnClientSignature = 'Y'
SET @RegenerateRDLOnCoSignature = 'Y'
SET @Code = 'FB6130A4-15FA-4E6F-B73D-21A33394D7EC'
SET @DiagnosisDocument = NULL
SET @DSMV = NULL

IF NOT EXISTS (
		SELECT 1
		FROM DocumentCodes
		WHERE Code = @Code
			AND ISNULL(RecordDeleted, 'N') <> 'Y'
			AND Active = 'Y'
		)
BEGIN
	INSERT INTO [dbo].[DocumentCodes] (
		[DocumentName]
		,[DocumentDescription]
		,[DocumentType]
		,[Active]
		,[ServiceNote]
		,[ViewDocumentURL]
		,[ViewDocumentRDL]
		,[StoredProcedure]
		,[TableList]
		,[RequiresSignature]
		,[ValidationStoredProcedure]
		,[ViewStoredProcedure]
		,[InitializationStoredProcedure]
		,[RecreatePDFOnClientSignature]
		,[RegenerateRDLOnCoSignature]
		,[Code]
		,[DiagnosisDocument]
		,[DSMV]
		)
	VALUES (
		@DocumentName
		,@DocumentName
		,@DocumentType
		,@Active
		,@ServiceNote
		,@ViewDocumentURL
		,@ViewDocumentRDL
		,@StoredProcedure
		,@TableList
		,@RequiresSignature
		,@ValidationStoredProcedure
		,@ViewStoredProcedure
		,@InitializationStoredProcedure
		,@RecreatePDFOnClientSignature
		,@RegenerateRDLOnCoSignature
		,@Code
		,@DiagnosisDocument
		,@DSMV
		)

	SET @DocumentCodeId = @@Identity
END

DECLARE @ScreenType INT
DECLARE @ScreenURL VARCHAR(200)
DECLARE @TabId INT
DECLARE @ValidationStoredProcedureComplete VARCHAR(100)
DECLARE @PostUpdateStoredProcedure VARCHAR(100)

SET @ScreenType = 5763
SET @ScreenURL = '/Custom/AdverseChildhoodExperiences/WebPages/AdverseChildhoodExperience.ascx'
SET @TabId = 2
SET @ValidationStoredProcedureComplete = 'csp_validateCustomAdverseChildhoodExperiences'
SET @PostUpdateStoredProcedure = ''

DECLARE @ScreenId INT

IF NOT EXISTS (
		SELECT TOP 1 ScreenId
		FROM Screens
		WHERE Code = @Code
			AND ISNULL(RecordDeleted, 'N') <> 'Y'
		)
BEGIN
	INSERT INTO [Screens] (
		[ScreenName]
		,[ScreenType]
		,[ScreenURL]
		,[TabId]
		,[InitializationStoredProcedure]
		,[ValidationStoredProcedureComplete]
		,[PostUpdateStoredProcedure]
		,[DocumentCodeId]
		,[Code]
		)
	VALUES (
		@DocumentName
		,@ScreenType
		,@ScreenURL
		,@TabId
		,@InitializationStoredProcedure
		,@ValidationStoredProcedureComplete
		,@PostUpdateStoredProcedure
		,@DocumentCodeId
		,@Code
		)

	SET @ScreenId = @@Identity

	----------------------------------------   Banner Table   -----------------------------------  
	DECLARE @BannerName VARCHAR(100)
	DECLARE @dispalyAs VARCHAR(100)
	DECLARE @BannerActive CHAR(1)
	DECLARE @DefaultOrder INT
	DECLARE @IsCustom CHAR(1)
	DECLARE @ParentBannerId INT
	DECLARE @ParentBannerIdForNavigation INT
	DECLARE @BHTEDSBannerId INT

	SET @BannerActive = 'Y'
	SET @DefaultOrder = 1
	SET @IsCustom = 'N'
	SET @ParentBannerId = (
			SELECT TOP 1 BannerId
			FROM dbo.Banners
			WHERE BannerName = 'Documents'
			)

	IF NOT EXISTS (
			SELECT *
			FROM dbo.Banners
			WHERE ScreenId = @ScreenId
				AND BannerName = @DocumentName
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
			@DocumentName
			,-- BannerName - varchar(100)
			@DocumentName
			,-- DisplayAs - varchar(100)
			@BannerActive
			,-- Active - type_Active
			@DefaultOrder
			,-- DefaultOrder - int
			@IsCustom
			,-- Custom - type_YOrN
			@TabId
			,-- TabId - int
			@ParentBannerId
			,@ScreenId
			)
	END

	--------------------------------------   Document Navigation   -----------------------------------  
	DECLARE @NavigationName VARCHAR(500)
	DECLARE @DisplayAs VARCHAR(500)
	DECLARE @ParentDocumentNavigationId INT
	DECLARE @BannerId INT

	SET @NavigationName = @DocumentName
	SET @DisplayAs = @DocumentName
	SET @ParentDocumentNavigationId = (
			SELECT TOP 1 DocumentNavigationId
			FROM dbo.DocumentNavigations
			WHERE NavigationName = 'Documents'
			)
	SET @BannerId = (
			SELECT TOP 1 BannerId
			FROM dbo.Banners
			WHERE BannerName = @DocumentName
				AND Screenid = @ScreenId
			)
	SET @Active = 'Y'

	IF NOT EXISTS (
			SELECT DocumentNavigationId
			FROM DocumentNavigations
			WHERE BannerId = @BannerId
			)
	BEGIN
		INSERT INTO [DocumentNavigations] (
			NavigationName
			,DisplayAs
			,ParentDocumentNavigationId
			,BannerId
			,[Active]
			,ScreenId
			)
		VALUES (
			@NavigationName
			,@DisplayAs
			,@ParentDocumentNavigationId
			,@BannerId
			,@Active
			,@ScreenId
			)
	END
			---------------------------------------------END-------------------------------------------- 
END