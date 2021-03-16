-- Guid -- "5B6CCB3A-48B7-412D-AE5B-DE850A39F6DB"
---------------------------DocumentCodes-----------------------------------------------------
DECLARE @DocumentCodeId INT
DECLARE @ScreenID INT
DECLARE @BannerID INT

IF (
		NOT (
			EXISTS (
				SELECT DocumentCodeId
				FROM documentCodes
				WHERE Code = '5B6CCB3A-48B7-412D-AE5B-DE850A39F6DB'
				)
			)
		)
BEGIN
		INSERT INTO [DocumentCodes] (
		
		[DocumentName]
		,[DocumentDescription]
		,[DocumentType]
		,[Active]
		,[ServiceNote]
		,[PatientConsent]
		,[ViewDocument]
		,[OnlyAvailableOnline]
		,[ImageFormatType]
		,[DefaultImageFolderId]
		,[ViewDocumentURL]
		,[ViewDocumentRDL]
		,[StoredProcedure]
		,[TableList]
		,[RequiresSignature]
		,[ViewOnlyDocument]
		,[DocumentSchema]
		,[DocumentHTML]
		,[DocumentURL]
		,[ToBeInitialized]
		,[InitializationProcess]
		,[InitializationStoredProcedure]
		,[FormCollectionId]
		,[ValidationStoredProcedure]
		,[ViewStoredProcedure]
		,[RequiresLicensedSignature]
		,[DefaultCoSigner]
		,[DefaultGuardian]
		,[RegenerateRDLOnCoSignature]
		,[RecreatePDFOnClientSignature]
		,[Code]
		)
	VALUES (
		'Discharge'
		,'Discharge'
		,10
		,'Y'
		,'N'
		,NULL
		,NULL
		,'N'
		,NULL
		,NULL
		,'RDLCustomDocumentDischarges'
		,'RDLCustomDocumentDischarges'
		,'csp_SCGetCustomDocumentDischarges'
		,'CustomDocumentDischarges,ClientPrograms,CustomDischargePrograms,CustomDischargeReferrals'
		,'Y'
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,5849
		,'csp_InitCustomDocumentDischarges'
		,NULL
		,NULL
		,'csp_validateCustomDocumentDischarges'
		,NULL
		,'Y'
		,'Y'
		,'Y'
		,'Y'
		,'5B6CCB3A-48B7-412D-AE5B-DE850A39F6DB'
		)

	
END
ELSE
BEGIN
	UPDATE DocumentCodes
	SET DocumentName = 'Discharge'
		,DocumentDescription = 'Discharge'
		,DocumentType = 10
		,Active = 'Y'
		,ServiceNote = 'N'
		,ViewDocumentURL = 'RDLCustomDocumentDischarges'
		,ViewDocumentRDL = 'RDLCustomDocumentDischarges'
		,StoredProcedure = 'csp_SCGetCustomDocumentDischarges'
		,TableList = 'CustomDocumentDischarges,ClientPrograms,CustomDischargePrograms,CustomDischargeReferrals'
		,RequiresSignature = 'Y'
		,InitializationStoredProcedure = 'csp_InitCustomDocumentDischarges'
		,ValidationStoredProcedure = 'csp_validateCustomDocumentDischarges'
		,DefaultCoSigner = 'Y'
		,DefaultGuardian = 'Y'
		,RegenerateRDLOnCoSignature = 'Y'
		,RecreatePDFOnClientSignature = 'Y'
	WHERE Code = '5B6CCB3A-48B7-412D-AE5B-DE850A39F6DB'
END


SET @DocumentCodeId = (SELECT DocumentCodeId
				FROM documentCodes
				WHERE Code = '5B6CCB3A-48B7-412D-AE5B-DE850A39F6DB' )
---------------------------End---------------------------------------------------------------
---------------------------Screens-----------------------------------------------------------
IF (
		NOT (
			EXISTS (
				SELECT screenId
				FROM screens
				WHERE code = '5B6CCB3A-48B7-412D-AE5B-DE850A39F6DB'
				)
			)
		)
BEGIN
	

	INSERT INTO [Screens] (
		[ScreenName]
		,[ScreenType]
		,[ScreenURL]
		,[ScreenToolbarURL]
		,[TabId]
		,[InitializationStoredProcedure]
		,[ValidationStoredProcedureUpdate]
		,[ValidationStoredProcedureComplete]
		,[PostUpdateStoredProcedure]
		,[RefreshPermissionsAfterUpdate]
		,[DocumentCodeId]
		,[CustomFieldFormId]
		,[Code]
		)
	VALUES (
		'Discharge'
		,5763
		,'/Custom/Discharge/WebPages/DischargeMain.ascx'
		,NULL
		,2
		,'csp_InitCustomDocumentDischarges'
		,NULL
		,'csp_validateCustomDocumentDischarges'
		,'csp_PostSignatureUpdateDischarges'
		,NULL
		,@DocumentCodeId
		,NULL
		,'5B6CCB3A-48B7-412D-AE5B-DE850A39F6DB'
		)

	
END
ELSE
BEGIN
	UPDATE Screens
	SET ScreenName = 'Discharge'
		,ScreenType = 5763
		,ScreenURL = '/Custom/Discharge/WebPages/DischargeMain.ascx'
		,TabId = 2
		,InitializationStoredProcedure = 'csp_InitCustomDocumentDischarges'
		,ValidationStoredProcedureComplete = 'csp_validateCustomDocumentDischarges'
		,PostUpdateStoredProcedure = 'csp_PostSignatureUpdateDischarges'
		,DocumentCodeId = @DocumentCodeId
	WHERE code = '5B6CCB3A-48B7-412D-AE5B-DE850A39F6DB'
END

set @ScreenID = (SELECT screenId
				FROM screens
				WHERE code = '5B6CCB3A-48B7-412D-AE5B-DE850A39F6DB')

---------------------------End----------------------------------------------------------------------
---------------------------Banners------------------------------------------------------------------


IF (
		NOT (
			EXISTS (
				SELECT screenId
				FROM Banners
				WHERE screenId = @ScreenID
				)
			)
		)
BEGIN
	INSERT INTO [Banners] (
		[BannerName]
		,[DisplayAs]
		,[Active]
		,[DefaultOrder]
		,[Custom]
		,[TabId]
		,[ScreenId]
		,[ParentBannerId]
		)
	VALUES (
		'Discharge'
		,'Discharge'
		,'Y'
		,1
		,'N'
		,'2'
		,@ScreenID
		,21
		)
END
ELSE
BEGIN
	UPDATE Banners
	SET BannerName = 'Discharge'
		,DisplayAs = 'Discharge'
		,Active = 'Y'
		,DefaultOrder = 1
		,Custom = 'N'
		,TabId = '2'
		,ParentBannerId = 21
	WHERE ScreenId = @ScreenID
END


---------------------------End----------------------------------------------------------------------

---------------------------DocumentNavigations------------------------------------------------------------------
IF (
		NOT (
			EXISTS (
				SELECT ScreenId
				FROM DocumentNavigations
				WHERE ScreenId = @ScreenID
				)
			)
		)
BEGIN
	INSERT INTO [DocumentNavigations] (
		[NavigationName]
		,[DisplayAs]
		,[Active]
		,[ParentDocumentNavigationId]
		,[BannerId]
		,[ScreenId]
		,[CreatedBy]
		,[CreatedDate]
		,[ModifiedBy]
		,[ModifiedDate]
		)
	VALUES (
		'Discharge'
		,'Discharge'
		,'Y'
		,NULL
		,(SELECT TOP 1 BannerId FROM Banners WHERE screenId = @ScreenID)
		,@ScreenID
		,SYSTEM_USER
		,GETDATE()
		,SYSTEM_USER
		,GETDATE()
		)
END
ELSE
BEGIN
	UPDATE DocumentNavigations
	SET [NavigationName] = 'Discharge'
		,[DisplayAs] = 'Discharge'
		,[Active] = 'Y'
		,[ParentDocumentNavigationId] = NULL
		,[BannerId] = (SELECT TOP 1 BannerId FROM Banners WHERE screenId = 46225)
		,[ScreenId] = @ScreenID
		,[ModifiedBy] = SYSTEM_USER
		,[ModifiedDate] = GETDATE()
	WHERE ScreenId = @ScreenID
END
---------------------------End----------------------------------------------------------------------
