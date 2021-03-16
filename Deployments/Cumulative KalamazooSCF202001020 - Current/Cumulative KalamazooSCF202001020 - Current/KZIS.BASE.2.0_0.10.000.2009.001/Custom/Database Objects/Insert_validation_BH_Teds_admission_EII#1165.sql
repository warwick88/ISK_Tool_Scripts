/*
Author: Mritunjay 
Date: 16-Sep-2020
Task: Engineering Improvement Initiatives- NBL(I) #1165
*/


/*For DocumentCodeId=35101*/
DECLARE @DocumentCodeId INT
SET @DocumentCodeId=(SELECT DocumentCodeID FROM DocumentCodes WHERE DocumentName='BH TEDS Admission' AND DocumentCodeId=35101 AND ISNULL(Active,'N')='Y' AND ISNULL(RecordDeleted,'N')='N')

IF @DocumentCodeId=35101
BEGIN
IF NOT EXISTS(SELECT * FROM documentvalidations WHERE DocumentCodeId=@DocumentCodeId AND ErrorMessage ='General Demographics – Have you or your family ever served in the military? must be Yes.' 
AND ColumnName ='FamilyMilitaryService' AND ISNULL(RecordDeleted,'N')='N' AND Active='Y')
BEGIN 
	INSERT INTO [documentvalidations] (
		[Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		,[SectionName]
		,[CreatedBy])
		VALUES
		('Y'
		,@DocumentCodeId
		,NULL
		,'Admission'
		,1
		,'CustomDocumentBHTEDSAdmissions'
		,'FamilyMilitaryService'
		,'FROM CustomDocumentBHTEDSDemographics CD JOIN CustomDocumentBHTEDSAdmissions CA ON CA.DocumentVersionId = CD.DocumentVersionId 
      WHERE CD.DocumentVersionId=@DocumentVersionId AND CA.AdmissionDate > ''9/30/2020'' AND 
	  CA.ServiceType NOT IN (SELECT GlobalCodeId FROM GlobalCodes WHERE Category=''XSERVICETYPE'' AND ISNULL(ExternalCode1,'''') = ''Q'' AND ISNULL(RecordDeleted,''N'')=''N'' AND Active=''Y'') AND 
	  CD.VeteranStatus IN (SELECT GlobalCodeId FROM GlobalCodes WHERE Category=''XBHTEDSVETERANSTATUS'' AND ISNULL(ExternalCode1,'''') = ''1'' AND ISNULL(RecordDeleted,''N'')=''N'' AND Active=''Y'') AND 
	  CD.FamilyMilitaryService IN (SELECT GlobalCodeId FROM GlobalCodes WHERE Category=''XBHTEDSFAMILYMILITAR'' AND ISNULL(ExternalCode1,'''') IN (''02'', ''95'', ''97'', ''98'') AND ISNULL(RecordDeleted,''N'')=''N'' AND Active=''Y'')'
		,'General Demographics – Have you or your family ever served in the military? must be Yes.'
		,62
		,'General Demographics – Have you or your family ever served in the military? must be Yes.'
		,NULL
		,'EII#1165')
END 

IF NOT EXISTS(SELECT * FROM documentvalidations WHERE DocumentCodeId=@DocumentCodeId AND ErrorMessage ='General Demographics - ''Branch Served In'' – A branch must be specified as Veteran is Answered ''Yes''.' 
AND ColumnName ='BranchServedIn' AND ISNULL(RecordDeleted,'N')='N' AND Active='Y')
BEGIN 
	INSERT INTO [documentvalidations] (
		[Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		,[SectionName]
		,[CreatedBy])
		VALUES
		('Y'
		,@DocumentCodeId
		,NULL
		,'Admission'
		,1
		,'CustomDocumentBHTEDSAdmissions'
		,'BranchServedIn'
		,'FROM CustomDocumentBHTEDSDemographics CD JOIN CustomDocumentBHTEDSAdmissions CA ON CA.DocumentVersionId = CD.DocumentVersionId 
      WHERE CD.DocumentVersionId=@DocumentVersionId AND CA.AdmissionDate > ''9/30/2020'' AND 
	  CA.ServiceType NOT IN (SELECT GlobalCodeId FROM GlobalCodes WHERE Category=''XSERVICETYPE'' AND ISNULL(ExternalCode1,'''') = ''Q'' AND ISNULL(RecordDeleted,''N'')=''N'' AND Active=''Y'') AND 
	  CD.VeteranStatus IN (SELECT GlobalCodeId FROM GlobalCodes WHERE Category=''XBHTEDSVETERANSTATUS'' AND ISNULL(ExternalCode1,'''') = ''1'' AND ISNULL(RecordDeleted,''N'')=''N'' AND Active=''Y'') AND 
	  CD.BranchServedIn IN (SELECT GlobalCodeId FROM GlobalCodes WHERE Category=''XBHTEDSMILITARYBRANC'' AND ISNULL(ExternalCode1,'''') IN (''95'', ''96'', ''97'', ''98'') AND ISNULL(RecordDeleted,''N'')=''N'' AND Active=''Y'')'
		,'General Demographics - ''Branch Served In'' – A branch must be specified as Veteran is Answered ''Yes''.'
		,54
		,'General Demographics - ''Branch Served In'' – A branch must be specified as Veteran is Answered ''Yes''.'
		,NULL
		,'EII#1165')
END 
	
IF NOT EXISTS(SELECT * FROM documentvalidations WHERE DocumentCodeId=@DocumentCodeId AND ErrorMessage ='General Demographics – ''Most Recent Military Service Era'' cannot be Unknown or Not Applicable as ''Veteran Status'' is Yes.' 
AND ColumnName ='MostRecentMilitaryServiceEra' AND ISNULL(RecordDeleted,'N')='N' AND Active='Y')
BEGIN 
	INSERT INTO [documentvalidations] (
		[Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		,[SectionName]
		,[CreatedBy])
		VALUES
		('Y'
		,@DocumentCodeId
		,NULL
		,'Admission'
		,1
		,'CustomDocumentBHTEDSAdmissions'
		,'MostRecentMilitaryServiceEra'
		,'FROM CustomDocumentBHTEDSDemographics CD JOIN CustomDocumentBHTEDSAdmissions CA ON CA.DocumentVersionId = CD.DocumentVersionId 
		  WHERE CD.DocumentVersionId=@DocumentVersionId AND CA.AdmissionDate > ''9/30/2020'' AND 
		  CA.ServiceType NOT IN (SELECT GlobalCodeId FROM GlobalCodes WHERE Category=''XSERVICETYPE'' AND ISNULL(ExternalCode1,'''') = ''Q'' AND ISNULL(RecordDeleted,''N'')=''N'' AND Active=''Y'') AND 
		  CD.VeteranStatus IN (SELECT GlobalCodeId FROM GlobalCodes WHERE Category=''XBHTEDSVETERANSTATUS'' AND ISNULL(ExternalCode1,'''') = ''1'' AND ISNULL(RecordDeleted,''N'')=''N'' AND Active=''Y'') AND 
		  CD.MostRecentMilitaryServiceEra IN (SELECT GlobalCodeId FROM GlobalCodes WHERE Category=''XBHTEDSMILITARYERA'' AND ISNULL(ExternalCode1,'''') IN (''95'', ''96'', ''97'', ''98'') AND ISNULL(RecordDeleted,''N'')=''N'' AND Active=''Y'')'
		,'General Demographics – ''Most Recent Military Service Era'' cannot be Unknown or Not Applicable as ''Veteran Status'' is Yes.'
		,58
		,'General Demographics – ''Most Recent Military Service Era'' cannot be Unknown or Not Applicable as ''Veteran Status'' is Yes.'
		,NULL
		,'EII#1165')
END 

IF NOT EXISTS(SELECT * FROM documentvalidations WHERE DocumentCodeId=@DocumentCodeId AND ErrorMessage ='General Demographics – Client/Family enrolled in/connected to VA/Veteran… must be Yes or No, because ''Veteran Status'' is Yes.' 
AND ColumnName ='ClientFamilyEnrolled' AND ISNULL(RecordDeleted,'N')='N' AND Active='Y')
BEGIN 
	INSERT INTO [documentvalidations] (
		[Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		,[SectionName]
		,[CreatedBy])
		VALUES
		('Y'
		,@DocumentCodeId
		,NULL
		,'Admission'
		,1
		,'CustomDocumentBHTEDSAdmissions'
		,'ClientFamilyEnrolled'
		,'FROM CustomDocumentBHTEDSDemographics CD JOIN CustomDocumentBHTEDSAdmissions CA ON CA.DocumentVersionId = CD.DocumentVersionId 
		  WHERE CD.DocumentVersionId=@DocumentVersionId AND CA.AdmissionDate > ''9/30/2020'' AND 
		  CA.ServiceType NOT IN (SELECT GlobalCodeId FROM GlobalCodes WHERE Category=''XSERVICETYPE'' AND ISNULL(ExternalCode1,'''') = ''Q'' AND ISNULL(RecordDeleted,''N'')=''N'' AND Active=''Y'') AND 
		  CD.VeteranStatus IN (SELECT GlobalCodeId FROM GlobalCodes WHERE Category=''XBHTEDSVETERANSTATUS'' AND ISNULL(ExternalCode1,'''') = ''1'' AND ISNULL(RecordDeleted,''N'')=''N'' AND Active=''Y'') AND 
		  CD.ClientFamilyEnrolled IN (SELECT GlobalCodeId FROM GlobalCodes WHERE Category=''XBHTEDSVARESOURCES'' AND ISNULL(ExternalCode1,'''') IN (''95'', ''97'', ''98'') AND ISNULL(RecordDeleted,''N'')=''N'' AND Active=''Y'')'
		,'General Demographics – Client/Family enrolled in/connected to VA/Veteran… must be Yes or No, because ''Veteran Status'' is Yes.'
		,66
		,'General Demographics – Client/Family enrolled in/connected to VA/Veteran… must be Yes or No, because ''Veteran Status'' is Yes.'
		,NULL
		,'EII#1165')
END 
END 


/*For DocumentCodeId=35102*/
SET @DocumentCodeId=(SELECT DocumentCodeID FROM DocumentCodes WHERE DocumentName='BH TEDS Admission' AND DocumentCodeId=35102 AND ISNULL(Active,'N')='Y' AND ISNULL(RecordDeleted,'N')='N')
IF @DocumentCodeId=35102
BEGIN 
IF NOT EXISTS(SELECT * FROM documentvalidations WHERE DocumentCodeId=@DocumentCodeId AND ErrorMessage ='General Demographics – Have you or your family ever served in the military? must be Yes.' 
AND ColumnName ='FamilyMilitaryService' AND ISNULL(RecordDeleted,'N')='N' AND Active='Y')
BEGIN 
	INSERT INTO [documentvalidations] (
		[Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		,[SectionName]
		,[CreatedBy])
		VALUES
		('Y'
		,@DocumentCodeId
		,NULL
		,'Admission'
		,1
		,'CustomDocumentBHTEDSAdmissions'
		,'FamilyMilitaryService'
		,'FROM CustomDocumentBHTEDSDemographics CD JOIN CustomDocumentBHTEDSAdmissions CA ON CA.DocumentVersionId = CD.DocumentVersionId 
      WHERE CD.DocumentVersionId=@DocumentVersionId AND CA.AdmissionDate > ''9/30/2020'' AND 
	  CA.ServiceType NOT IN (SELECT GlobalCodeId FROM GlobalCodes WHERE Category=''XSERVICETYPE'' AND ISNULL(ExternalCode1,'''') = ''Q'' AND ISNULL(RecordDeleted,''N'')=''N'' AND Active=''Y'') AND 
	  CD.VeteranStatus IN (SELECT GlobalCodeId FROM GlobalCodes WHERE Category=''XBHTEDSVETERANSTATUS'' AND ISNULL(ExternalCode1,'''') = ''1'' AND ISNULL(RecordDeleted,''N'')=''N'' AND Active=''Y'') AND 
	  CD.FamilyMilitaryService IN (SELECT GlobalCodeId FROM GlobalCodes WHERE Category=''XBHTEDSFAMILYMILITAR'' AND ISNULL(ExternalCode1,'''') IN (''02'', ''95'', ''97'', ''98'') AND ISNULL(RecordDeleted,''N'')=''N'' AND Active=''Y'')'
		,'General Demographics – Have you or your family ever served in the military? must be Yes.'
		,62
		,'General Demographics – Have you or your family ever served in the military? must be Yes.'
		,NULL
		,'EII#1165')
END 

IF NOT EXISTS(SELECT * FROM documentvalidations WHERE DocumentCodeId=@DocumentCodeId AND ErrorMessage ='General Demographics - ''Branch Served In'' – A branch must be specified as Veteran is Answered ''Yes''.' 
AND ColumnName ='BranchServedIn' AND ISNULL(RecordDeleted,'N')='N' AND Active='Y')
BEGIN 
	INSERT INTO [documentvalidations] (
		[Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		,[SectionName]
		,[CreatedBy])
		VALUES
		('Y'
		,@DocumentCodeId
		,NULL
		,'Admission'
		,1
		,'CustomDocumentBHTEDSAdmissions'
		,'BranchServedIn'
		,'FROM CustomDocumentBHTEDSDemographics CD JOIN CustomDocumentBHTEDSAdmissions CA ON CA.DocumentVersionId = CD.DocumentVersionId 
      WHERE CD.DocumentVersionId=@DocumentVersionId AND CA.AdmissionDate > ''9/30/2020'' AND 
	  CA.ServiceType NOT IN (SELECT GlobalCodeId FROM GlobalCodes WHERE Category=''XSERVICETYPE'' AND ISNULL(ExternalCode1,'''') = ''Q'' AND ISNULL(RecordDeleted,''N'')=''N'' AND Active=''Y'') AND 
	  CD.VeteranStatus IN (SELECT GlobalCodeId FROM GlobalCodes WHERE Category=''XBHTEDSVETERANSTATUS'' AND ISNULL(ExternalCode1,'''') = ''1'' AND ISNULL(RecordDeleted,''N'')=''N'' AND Active=''Y'') AND 
	  CD.BranchServedIn IN (SELECT GlobalCodeId FROM GlobalCodes WHERE Category=''XBHTEDSMILITARYBRANC'' AND ISNULL(ExternalCode1,'''') IN (''95'', ''96'', ''97'', ''98'') AND ISNULL(RecordDeleted,''N'')=''N'' AND Active=''Y'')'
		,'General Demographics - ''Branch Served In'' – A branch must be specified as Veteran is Answered ''Yes''.'
		,54
		,'General Demographics - ''Branch Served In'' – A branch must be specified as Veteran is Answered ''Yes''.'
		,NULL
		,'EII#1165')
END 
	
IF NOT EXISTS(SELECT * FROM documentvalidations WHERE DocumentCodeId=@DocumentCodeId AND ErrorMessage ='General Demographics – ''Most Recent Military Service Era'' cannot be Unknown or Not Applicable as ''Veteran Status'' is Yes.' 
AND ColumnName ='MostRecentMilitaryServiceEra' AND ISNULL(RecordDeleted,'N')='N' AND Active='Y')
BEGIN 
	INSERT INTO [documentvalidations] (
		[Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		,[SectionName]
		,[CreatedBy])
		VALUES
		('Y'
		,@DocumentCodeId
		,NULL
		,'Admission'
		,1
		,'CustomDocumentBHTEDSAdmissions'
		,'MostRecentMilitaryServiceEra'
		,'FROM CustomDocumentBHTEDSDemographics CD JOIN CustomDocumentBHTEDSAdmissions CA ON CA.DocumentVersionId = CD.DocumentVersionId 
		  WHERE CD.DocumentVersionId=@DocumentVersionId AND CA.AdmissionDate > ''9/30/2020'' AND 
		  CA.ServiceType NOT IN (SELECT GlobalCodeId FROM GlobalCodes WHERE Category=''XSERVICETYPE'' AND ISNULL(ExternalCode1,'''') = ''Q'' AND ISNULL(RecordDeleted,''N'')=''N'' AND Active=''Y'') AND 
		  CD.VeteranStatus IN (SELECT GlobalCodeId FROM GlobalCodes WHERE Category=''XBHTEDSVETERANSTATUS'' AND ISNULL(ExternalCode1,'''') = ''1'' AND ISNULL(RecordDeleted,''N'')=''N'' AND Active=''Y'') AND 
		  CD.MostRecentMilitaryServiceEra IN (SELECT GlobalCodeId FROM GlobalCodes WHERE Category=''XBHTEDSMILITARYERA'' AND ISNULL(ExternalCode1,'''') IN (''95'', ''96'', ''97'', ''98'') AND ISNULL(RecordDeleted,''N'')=''N'' AND Active=''Y'')'
		,'General Demographics – ''Most Recent Military Service Era'' cannot be Unknown or Not Applicable as ''Veteran Status'' is Yes.'
		,58
		,'General Demographics – ''Most Recent Military Service Era'' cannot be Unknown or Not Applicable as ''Veteran Status'' is Yes.'
		,NULL
		,'EII#1165')
END 

IF NOT EXISTS(SELECT * FROM documentvalidations WHERE DocumentCodeId=@DocumentCodeId AND ErrorMessage ='General Demographics – Client/Family enrolled in/connected to VA/Veteran… must be Yes or No, because ''Veteran Status'' is Yes.' 
AND ColumnName ='ClientFamilyEnrolled' AND ISNULL(RecordDeleted,'N')='N' AND Active='Y')
BEGIN 
	INSERT INTO [documentvalidations] (
		[Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		,[SectionName]
		,[CreatedBy])
		VALUES
		('Y'
		,@DocumentCodeId
		,NULL
		,'Admission'
		,1
		,'CustomDocumentBHTEDSAdmissions'
		,'ClientFamilyEnrolled'
		,'FROM CustomDocumentBHTEDSDemographics CD JOIN CustomDocumentBHTEDSAdmissions CA ON CA.DocumentVersionId = CD.DocumentVersionId 
		  WHERE CD.DocumentVersionId=@DocumentVersionId AND CA.AdmissionDate > ''9/30/2020'' AND 
		  CA.ServiceType NOT IN (SELECT GlobalCodeId FROM GlobalCodes WHERE Category=''XSERVICETYPE'' AND ISNULL(ExternalCode1,'''') = ''Q'' AND ISNULL(RecordDeleted,''N'')=''N'' AND Active=''Y'') AND 
		  CD.VeteranStatus IN (SELECT GlobalCodeId FROM GlobalCodes WHERE Category=''XBHTEDSVETERANSTATUS'' AND ISNULL(ExternalCode1,'''') = ''1'' AND ISNULL(RecordDeleted,''N'')=''N'' AND Active=''Y'') AND 
		  CD.ClientFamilyEnrolled IN (SELECT GlobalCodeId FROM GlobalCodes WHERE Category=''XBHTEDSVARESOURCES'' AND ISNULL(ExternalCode1,'''') IN (''95'', ''97'', ''98'') AND ISNULL(RecordDeleted,''N'')=''N'' AND Active=''Y'')'
		,'General Demographics – Client/Family enrolled in/connected to VA/Veteran… must be Yes or No, because ''Veteran Status'' is Yes.'
		,66
		,'General Demographics – Client/Family enrolled in/connected to VA/Veteran… must be Yes or No, because ''Veteran Status'' is Yes.'
		,NULL
		,'EII#1165')
END 
END