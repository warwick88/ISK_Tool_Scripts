/*********************************************************************************/
-- Copyright: Streamline Healthcare Solutions          
--          
-- Purpose: Scripts required for inserting entries into DocumentCodes and Screens for Group Note,
--          Project: WMU - Enhancements, Task: #14       
-- Author:  Venkatesh MR          
-- Date:    15-Oct-2014   

/* Data Modifications:                                                           */    
/*                                                                               */    
/* Date          Author       Purpose                                                 */    
/* 12-02-2018    Kishore	  BHS GroupNote Copied from WMU                                                                              */    
/*********************************************************************************/
--SET IDENTITY_INSERT dbo.DocumentCodes ON
--Select NEWID() 
-- B11C3969-FBA2-4E6F-BDCF-370AFE3A0094  -- DocumentCodeId1 = 40031
-- DC40159A-E64B-49BC-91F4-B2541CEDA58E  -- DocumentCodeId2=  40032
   
---------------------------------------- DocumentCodes - Begin -----------------------------------  
-- Declaration of variables
DECLARE @DocumentCodeId1 INT
DECLARE @DocumentCodeId2 INT
DECLARE @DocumentName VARCHAR(100)
DECLARE @DocumentDescription VARCHAR(250)
DECLARE @DocumentType INT 
DECLARE @Active CHAR(1) 
DECLARE @ServiceNote CHAR(1)
DECLARE @PatientConsent CHAR(1)
DECLARE @ViewDocument binary
DECLARE @OnlyAvailableOnline  CHAR(1)
DECLARE @ImageFormatType INT
DECLARE @DefaultImageFolderId INT
DECLARE @ImageFormat VARCHAR(1000)
DECLARE @ViewDocumentURL VARCHAR(500)
DECLARE @ViewDocumentRDL VARCHAR(500)
DECLARE @StoredProcedure VARCHAR(100)
DECLARE @TableList VARCHAR(500)
DECLARE @RequiresSignature CHAR(1)
DECLARE @ViewOnlyDocument CHAR(1)
DECLARE @DocumentSchema VARCHAR(500)
DECLARE @DocumentHTML VARCHAR(500)
DECLARE @DocumentURL VARCHAR(1000)
DECLARE @ToBeInitialized CHAR(1)
DECLARE @InitializationProcess INT
DECLARE @InitializationStoredProcedure VARCHAR(100)
DECLARE @FormCollectionId INT
DECLARE @ValidationStoredProcedure VARCHAR(100)
DECLARE @ViewStoredProcedure VARCHAR(100)
DECLARE @MetadataFormId INT
DECLARE @TextTemplate varchar(1000)
DECLARE @RequiresLicensedSignature CHAR(1)
DECLARE @ReviewFormId INT
DECLARE @MedicationReconciliationDocument CHAR(1)
DECLARE @NewValidationStoredProcedure varchar(100)
DECLARE @AllowEditingByNonAuthors CHAR(1)
DECLARE @EnableEditValidationStoredProcedure CHAR(1)
DECLARE @MultipleCredentials varchar(100)
DECLARE @RecreatePDFOnClientSignature CHAR(1)
DECLARE @DiagnosisDocument CHAR(1)
DECLARE @RegenerateRDLOnCoSignature CHAR(1)
DECLARE @DefaultCoSigner CHAR(1)
DECLARE @DefaultGuardian CHAR(1)
DECLARE @Need5Columns CHAR(1)
DECLARE @SignatureDateAsEffectiveDate CHAR(1)
DECLARE @FamilyHistoryDocument CHAR(1)
DECLARE @Code1 VARCHAR(100)
DECLARE @Code2 VARCHAR(100)


-- Setting value to the variables
-- Custom Group Note
--SET @DocumentCodeId = 40031
SET @DocumentName = 'Group Note'
SET @DocumentDescription ='Group Note'
SET @DocumentType = 10
SET @Active = 'Y'
SET @ServiceNote = 'N'
SET @PatientConsent ='N'
SET @ViewDocument = NULL
SET @OnlyAvailableOnline ='N'
SET @ImageFormatType = NULL
SET @DefaultImageFolderId = NULL
SET @ImageFormat = NULL
SET @ViewDocumentURL =NULL
SET @ViewDocumentRDL =NULL
SET @StoredProcedure ='csp_SCGetCustomBHSGroupNote'
SET @TableList ='CustomBHSGroupNotes'
SET @RequiresSignature ='Y'
SET @ViewOnlyDocument = 'N'
SET @DocumentSchema = NULL
SET @DocumentHTML = NULL
SET @DocumentURL = NULL
SET @ToBeInitialized = NULL
SET @InitializationProcess = NULL
SET @InitializationStoredProcedure = NULL
SET @FormCollectionId = NULL
SET @ValidationStoredProcedure = NULL
SET @ViewStoredProcedure ='csp_RDLCustomBHSGroupNote'
SET @MetadataFormId = NULL
SET @TextTemplate = 'Custom Group Note'
SET @RequiresLicensedSignature = 'N'
SET @ReviewFormId = NULL
SET @MedicationReconciliationDocument = 'N'
SET @NewValidationStoredProcedure = NULL
SET @AllowEditingByNonAuthors  = NULL
SET @EnableEditValidationStoredProcedure = NULL
SET @MultipleCredentials = NULL
SET @RecreatePDFOnClientSignature = NULL
SET @DiagnosisDocument = NULL
SET @RegenerateRDLOnCoSignature = NULL
SET @DefaultCoSigner = NULL
SET @DefaultGuardian = NULL
SET @Need5Columns = NULL
SET @SignatureDateAsEffectiveDate = NULL
SET @FamilyHistoryDocument = NULL
SET @Code1 = 'B11C3969-FBA2-4E6F-BDCF-370AFE3A0094'


IF NOT EXISTS (SELECT 1 
               FROM   DocumentCodes 
               WHERE  Code = @Code1  AND ISNULL(RecordDeleted, 'N') = 'N') 
               
	BEGIN 
		 
		INSERT INTO [dbo].[DocumentCodes] 
		([DocumentName], [DocumentDescription], [DocumentType], [Active], [ServiceNote], [PatientConsent], [ViewDocument], [OnlyAvailableOnline], [ImageFormatType], [DefaultImageFolderId], [ImageFormat], [ViewDocumentURL], [ViewDocumentRDL], [StoredProcedure], [TableList], [RequiresSignature], [ViewOnlyDocument], [DocumentSchema], [DocumentHTML], [DocumentURL], [ToBeInitialized], [InitializationProcess], [InitializationStoredProcedure], [FormCollectionId], [ValidationStoredProcedure], [ViewStoredProcedure], [MetadataFormId], [TextTemplate], [RequiresLicensedSignature], [ReviewFormId], [MedicationReconciliationDocument], [NewValidationStoredProcedure], [AllowEditingByNonAuthors], [EnableEditValidationStoredProcedure], [MultipleCredentials], [RecreatePDFOnClientSignature], [DiagnosisDocument], [RegenerateRDLOnCoSignature], [DefaultCoSigner], [DefaultGuardian], [Need5Columns], [SignatureDateAsEffectiveDate], [FamilyHistoryDocument],[Code]) 
		VALUES 
		(@DocumentName,  @DocumentDescription,   @DocumentType, @Active,  @ServiceNote,  @PatientConsent,  @ViewDocument,  @OnlyAvailableOnline,  @ImageFormatType, @DefaultImageFolderId,   @ImageFormat,  @ViewDocumentURL,   @ViewDocumentRDL, @StoredProcedure,  @TableList,  @RequiresSignature,  @ViewOnlyDocument,  @DocumentSchema,  @DocumentHTML,  @DocumentURL,  @ToBeInitialized,  @InitializationProcess,  @InitializationStoredProcedure,  @FormCollectionId,  @ValidationStoredProcedure,  @ViewStoredProcedure,  @MetadataFormId,  @TextTemplate,  @RequiresLicensedSignature,  @ReviewFormId,  @MedicationReconciliationDocument, @NewValidationStoredProcedure,   @AllowEditingByNonAuthors,  @EnableEditValidationStoredProcedure,  @MultipleCredentials,  @RecreatePDFOnClientSignature,  @DiagnosisDocument,   @RegenerateRDLOnCoSignature, @DefaultCoSigner,  @DefaultGuardian,   @Need5Columns,  @SignatureDateAsEffectiveDate,  @FamilyHistoryDocument,@Code1)
		SET @DocumentCodeId1 = SCOPE_IDENTITY();
	END 


-- Setting value to the variables
-- Custom Client Group Note

--SET @DocumentCodeId = 40032
SET @DocumentName = 'BHS Note'
SET @DocumentDescription ='Client BHS Group Note'
SET @DocumentType = 10
SET @Active = 'Y'
SET @ServiceNote = 'Y'
SET @PatientConsent ='N'
SET @ViewDocument = NULL
SET @OnlyAvailableOnline ='N'
SET @ImageFormatType = NULL
SET @DefaultImageFolderId = NULL
SET @ImageFormat = NULL
SET @ViewDocumentURL ='RDLCustomBHSClientGroupNote'
SET @ViewDocumentRDL ='RDLCustomBHSClientGroupNote'
SET @StoredProcedure ='csp_SCGetCustomClientBHSGroupNote'
SET @TableList ='CustomDocumentBHSClientNotes'
SET @RequiresSignature ='Y'
SET @ViewOnlyDocument = 'N'
SET @DocumentSchema = NULL
SET @DocumentHTML = NULL
SET @DocumentURL = NULL
SET @ToBeInitialized = NULL
SET @InitializationProcess = NULL
SET @InitializationStoredProcedure = NULL
SET @FormCollectionId = NULL
SET @ValidationStoredProcedure = NULL
SET @ViewStoredProcedure ='csp_RDLCustomClientGroupNote'
SET @MetadataFormId = NULL
SET @TextTemplate = 'Custom Client Group Note'
SET @RequiresLicensedSignature = 'N'
SET @ReviewFormId = NULL
SET @MedicationReconciliationDocument = 'N'
SET @NewValidationStoredProcedure = NULL
SET @AllowEditingByNonAuthors  = NULL
SET @EnableEditValidationStoredProcedure = NULL
SET @MultipleCredentials = NULL
SET @RecreatePDFOnClientSignature = NULL
SET @DiagnosisDocument = NULL
SET @RegenerateRDLOnCoSignature = NULL
SET @DefaultCoSigner = NULL
SET @DefaultGuardian = NULL
SET @Need5Columns = NULL
SET @SignatureDateAsEffectiveDate = NULL
SET @FamilyHistoryDocument = NULL
SET @Code2 = 'DC40159A-E64B-49BC-91F4-B2541CEDA58E'

IF NOT EXISTS (SELECT 1 
               FROM   DocumentCodes 
               WHERE  Code = @Code2  AND ISNULL(RecordDeleted, 'N') = 'N') 
               
	BEGIN 
		 
		INSERT INTO [dbo].[DocumentCodes] ([DocumentName], [DocumentDescription], [DocumentType], [Active], [ServiceNote], [PatientConsent], [ViewDocument], [OnlyAvailableOnline], [ImageFormatType], [DefaultImageFolderId], [ImageFormat], [ViewDocumentURL], [ViewDocumentRDL], [StoredProcedure], [TableList], [RequiresSignature], [ViewOnlyDocument], [DocumentSchema], [DocumentHTML], [DocumentURL], [ToBeInitialized], [InitializationProcess], [InitializationStoredProcedure], [FormCollectionId], [ValidationStoredProcedure], [ViewStoredProcedure], [MetadataFormId], [TextTemplate], [RequiresLicensedSignature], [ReviewFormId], [MedicationReconciliationDocument], [NewValidationStoredProcedure], [AllowEditingByNonAuthors], [EnableEditValidationStoredProcedure], [MultipleCredentials], [RecreatePDFOnClientSignature], [DiagnosisDocument], [RegenerateRDLOnCoSignature], [DefaultCoSigner], [DefaultGuardian], [Need5Columns], [SignatureDateAsEffectiveDate], [FamilyHistoryDocument],[Code] ) VALUES 
										(@DocumentName,  @DocumentDescription,   @DocumentType, @Active,  @ServiceNote,  @PatientConsent,  @ViewDocument,  @OnlyAvailableOnline,  @ImageFormatType, @DefaultImageFolderId,   @ImageFormat,  @ViewDocumentURL,   @ViewDocumentRDL, @StoredProcedure,  @TableList,  @RequiresSignature,  @ViewOnlyDocument,  @DocumentSchema,  @DocumentHTML,  @DocumentURL,  @ToBeInitialized,  @InitializationProcess,  @InitializationStoredProcedure,  @FormCollectionId,  @ValidationStoredProcedure,  @ViewStoredProcedure,  @MetadataFormId,  @TextTemplate,  @RequiresLicensedSignature,  @ReviewFormId,  @MedicationReconciliationDocument, @NewValidationStoredProcedure,   @AllowEditingByNonAuthors,  @EnableEditValidationStoredProcedure,  @MultipleCredentials,  @RecreatePDFOnClientSignature,  @DiagnosisDocument,   @RegenerateRDLOnCoSignature, @DefaultCoSigner,  @DefaultGuardian,   @Need5Columns,  @SignatureDateAsEffectiveDate,  @FamilyHistoryDocument,@Code2)
		SET @DocumentCodeId2 = SCOPE_IDENTITY();
	END 
	
----------------------------------------------- DocumentCodes - End --------------------------------------------  

---------------------------------------- Screens - Begin -----------------------------------  
/*   
  Please change these variables for supporting a new page/document/widget   
  Screen Types:   
		None:               0,   
        Detail:             5761,   
        List:               5762,   
        Document:           5763,   
        Summary:            5764,   
        Custom:             5765,   
        ExternalScreen:     5766   
*/

DECLARE @ScreenTypeDocument INT = 5763
DECLARE @TabIdOne INT = 1

DECLARE @ScreenId1 INT
DECLARE @ScreenId2 INT
DECLARE @ScreenName VARCHAR(100) 
DECLARE @ScreenType INT 
DECLARE @ScreenURL VARCHAR(200)
DECLARE @ScreenToolbarURL VARCHAR(200) 
DECLARE @TabId INT 
DECLARE @ValidationStoredProcedureUpdate VARCHAR(500) 
DECLARE @ValidationStoredProcedureComplete VARCHAR(500) 
DECLARE @WarningStoredProcedureComplete VARCHAR(500) 
DECLARE @PostUpdateStoredProcedure VARCHAR(500) 
DECLARE @RefreshPermissionsAfterUpdate VARCHAR(500) 

 
-- Group Note
--SET @ScreenId = 40031
SET @ScreenName = 'Group Note' 
SET @ScreenType = @ScreenTypeDocument 
SET @ScreenURL = '/Custom/BHS GroupNote/WebPages/GroupNote.ascx' 
SET @ScreenToolbarURL = NULL
SET @TabId = @TabIdOne 
SET @InitializationStoredProcedure = NULL 
SET @ValidationStoredProcedureUpdate = NULL 
SET @ValidationStoredProcedureComplete =  NULL
SET @WarningStoredProcedureComplete = NULL
SET @PostUpdateStoredProcedure = NULL
SET @RefreshPermissionsAfterUpdate = NULL 
--SET @DocumentCodeId1 = @ScreenId1       -- Change the document code id if it is different than screen id

IF NOT EXISTS (SELECT TOP 1 @ScreenId1 
               FROM   Screens 
               WHERE  Code = @Code1 AND ISNULL(RecordDeleted, 'N') = 'N') 
               
               
	BEGIN 
		
		INSERT INTO [dbo].[Screens]
				  ( 
				   [ScreenName], 
				   [ScreenType], 
				   [ScreenURL], 
				   [TabId], 
				   [InitializationStoredProcedure], 
				   [ValidationStoredProcedureUpdate], 
				   [ValidationStoredProcedureComplete], 
				   [PostUpdateStoredProcedure], 
				   [RefreshPermissionsAfterUpdate], 
				   [DocumentCodeId],
				   [Code]) 
		VALUES      (  
					@ScreenName, 
					@ScreenType, 
					@ScreenURL, 
					@TabId, 
					@InitializationStoredProcedure, 
					@ValidationStoredProcedureUpdate, 
					@ValidationStoredProcedureComplete, 
					@PostUpdateStoredProcedure, 
					@RefreshPermissionsAfterUpdate, 
					@DocumentCodeId1,
					@Code1
					) 

		SET @ScreenId1 = SCOPE_IDENTITY(); 
	END 



-- Client Group Note
--SET @ScreenId = 40032
SET @ScreenName = 'Client Group Note' 
SET @ScreenType = @ScreenTypeDocument 
SET @ScreenURL = '/Custom/BHS GroupNote/WebPages/ClientGroupNote.ascx' 
SET @ScreenToolbarURL = NULL
SET @TabId = @TabIdOne 
SET @InitializationStoredProcedure = NULL 
SET @ValidationStoredProcedureUpdate = Null
SET @ValidationStoredProcedureComplete =  'csp_ValidateCustomBHSGroupServiceNote'
SET @WarningStoredProcedureComplete = NULL
SET @PostUpdateStoredProcedure = NULL
SET @RefreshPermissionsAfterUpdate = NULL 
--SET @DocumentCodeId = @ScreenId       -- Change the document code id if it is different than screen id

IF NOT EXISTS (SELECT TOP 1 @ScreenId2 
               FROM   Screens 
               WHERE  Code = @Code2 AND ISNULL(RecordDeleted, 'N') = 'N') 
	BEGIN 

		INSERT INTO [dbo].[Screens]
				  ( 
				   [ScreenName], 
				   [ScreenType], 
				   [ScreenURL], 
				   [TabId], 
				   [InitializationStoredProcedure], 
				   [ValidationStoredProcedureUpdate], 
				   [ValidationStoredProcedureComplete], 
				   [PostUpdateStoredProcedure], 
				   [RefreshPermissionsAfterUpdate], 
				   [DocumentCodeId],
				   [Code]) 
		VALUES      ( 
					@ScreenName, 
					@ScreenType, 
					@ScreenURL, 
					@TabId, 
					@InitializationStoredProcedure, 
					@ValidationStoredProcedureUpdate, 
					@ValidationStoredProcedureComplete, 
					@PostUpdateStoredProcedure, 
					@RefreshPermissionsAfterUpdate, 
					@DocumentCodeId2,
					@Code2) 

		SET @ScreenId2 = SCOPE_IDENTITY(); 
	END 

---------------------------------------------- Screens - End --------------------------------------------  


--IF NOT EXISTS (
--		SELECT *
--		FROM GroupNoteDocumentCodes
--		WHERE [GroupNoteCodeId] = '40031' AND [ServiceNoteCodeId] = '40032'
--		)



--DECLARE @GroupNoteCodeId INT = @DocumentCodeId1
--DECLARE @ServiceNoteCodeId INT = @DocumentCodeId2

DECLARE @GroupNoteCodeId INT 
DECLARE @ServiceNoteCodeId INT 

                                                                    
select @GroupNoteCodeId = DocumentCodeid from DocumentCodes Where Code = 'B11C3969-FBA2-4E6F-BDCF-370AFE3A0094'
select @ServiceNoteCodeId = DocumentCodeid from DocumentCodes Where Code = 'DC40159A-E64B-49BC-91F4-B2541CEDA58E' 
 


IF NOT EXISTS ( 
				SELECT TOP 1 GroupNoteDocumentCodeId
				FROM GroupNoteDocumentCodes
				WHERE [GroupNoteCodeId] = @GroupNoteCodeId AND [ServiceNoteCodeId] = @ServiceNoteCodeId
				)

BEGIN
	--SET IDENTITY_INSERT GroupNoteDocumentCodes ON

	INSERT INTO [dbo].[GroupNoteDocumentCodes] (
		[GroupNoteName]
		,[Active]
		,[GroupNoteCodeId]
		,[ServiceNoteCodeId]
		,[CopyStoredProcedureName]
		,[RowIdentifier]
		,[CreatedBy]
		,[CreatedDate]
		,[ModifiedBy]
		,[ModifiedDate]
		,[RecordDeleted]
		,[DeletedDate]
		,[DeletedBy]
		)
	VALUES (
		'BHS Group Note'
		,'Y'
		--,'40031'
		--,'40032'
		,@GroupNoteCodeId
		,@ServiceNoteCodeId
		,'csp_SCUpdateCustomDocumentBHSCustomClientGroupNotes'
		,'8470D32D-0F55-412B-AF99-145838354C03'
		,'shstest'
		,GETDATE()
		,'shstest'
		,GETDATE()
		,NULL
		,NULL
		,NULL
		)

	--SET IDENTITY_INSERT GroupNoteDocumentCodes OFF
END


