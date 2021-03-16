/*Date				Authour				Prupose                 */
/*06/09/2020		Packia				Insert script for adding Validation logics to PHQ9 tab in MH Assessment. KCMHSAS Improvements #7*/

DECLARE @DocumentCodeId int
SET @DocumentCodeId =(SELECT DocumentCodeId FROM DocumentCodes where Code='69E559DD-1A4D-46D3-B91C-E89DA48E0038' )

IF NOT EXISTS (
		SELECT 1
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND TableName = 'PHQ9Documents' and ColumnName='LittleInterest' AND TabName='PHQ9'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationOrder]
		,[ErrorMessage]
		,[SectionName]
		)
	VALUES (
		N'Y'
		,@DocumentCodeId
		,NULL
		,'PHQ9'
		,8
		,N'PHQ9Documents'
		,N'LittleInterest'
		,'FROM PHQ9Documents CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE CS.LittleInterest IS NULL and AdultOrChild = ''A'' and CM.ClientInDDPopulation <> ''Y'' AND ISNULL(CS.ClientDeclinedToParticipate,''N'') = ''N''  and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
		,1
		,N'Little interest or pleasure in doing things is required'
		,'Over the last weeks'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND TableName = 'PHQ9Documents' and ColumnName='FeelingDown' AND TabName='PHQ9'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationOrder]
		,[ErrorMessage]
		,[SectionName]
		)
	VALUES (
		N'Y'
		,@DocumentCodeId
		,NULL
		,'PHQ9'
		,8
		,N'PHQ9Documents'
		,N'FeelingDown'
		,'FROM PHQ9Documents CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE CS.FeelingDown IS NULL and AdultOrChild = ''A'' and CM.ClientInDDPopulation <> ''Y'' AND ISNULL(CS.ClientDeclinedToParticipate,''N'') = ''N''  and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
		,2
		,N'Feeling down, depressed, or hopeless is required'
		,'Over the last weeks'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND TableName = 'PHQ9Documents' and ColumnName='TroubleFalling' AND TabName='PHQ9'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationOrder]
		,[ErrorMessage]
		,[SectionName]
		)
	VALUES (
		N'Y'
		,@DocumentCodeId
		,NULL
		,'PHQ9'
		,8
		,N'PHQ9Documents'
		,N'TroubleFalling'
		,'FROM PHQ9Documents CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE CS.TroubleFalling IS NULL and AdultOrChild = ''A'' and CM.ClientInDDPopulation <> ''Y'' AND ISNULL(CS.ClientDeclinedToParticipate,''N'') = ''N''  and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
		,3
		,N'Trouble falling or staying asleep... is required'
		,'Over the last weeks'
		)
END



IF NOT EXISTS (
		SELECT 1
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND TableName = 'PHQ9Documents' and ColumnName='FeelingTired' AND TabName='PHQ9'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationOrder]
		,[ErrorMessage]
		,[SectionName]
		)
	VALUES (
		N'Y'
		,@DocumentCodeId
		,NULL
		,'PHQ9'
		,8
		,N'PHQ9Documents'
		,N'FeelingTired'
		,'FROM PHQ9Documents CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE CS.FeelingTired IS NULL and AdultOrChild = ''A'' and CM.ClientInDDPopulation <> ''Y'' AND ISNULL(CS.ClientDeclinedToParticipate,''N'') = ''N''  and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
		,4
		,N'Feeling tired or having little energy is required'
		,'Over the last weeks'
		)
END



IF NOT EXISTS (
		SELECT 1
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND TableName = 'PHQ9Documents' and ColumnName='PoorAppetite' AND TabName='PHQ9'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationOrder]
		,[ErrorMessage]
		,[SectionName]
		)
	VALUES (
		N'Y'
		,@DocumentCodeId
		,NULL
		,'PHQ9'
		,8
		,N'PHQ9Documents'
		,N'PoorAppetite'
		,'FROM PHQ9Documents CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE CS.PoorAppetite IS NULL and AdultOrChild = ''A'' and CM.ClientInDDPopulation <> ''Y'' AND ISNULL(CS.ClientDeclinedToParticipate,''N'') = ''N''  and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
		,5
		,N'Poor appetite or overeating is required'
		,'Over the last weeks'
		)
END


IF NOT EXISTS (
		SELECT 1
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND TableName = 'PHQ9Documents' and ColumnName='FeelingBad' AND TabName='PHQ9'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationOrder]
		,[ErrorMessage]
		,[SectionName]
		)
	VALUES (
		N'Y'
		,@DocumentCodeId
		,NULL
		,'PHQ9'
		,8
		,N'PHQ9Documents'
		,N'FeelingBad'
		,'FROM PHQ9Documents CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE CS.FeelingBad IS NULL and AdultOrChild = ''A'' and CM.ClientInDDPopulation <> ''Y'' AND ISNULL(CS.ClientDeclinedToParticipate,''N'') = ''N''  and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
		,6
		,N'Feeling bad about yourself... is required'
		,'Over the last weeks'
		)
END


IF NOT EXISTS (
		SELECT 1
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND TableName = 'PHQ9Documents' and ColumnName='TroubleConcentrating' AND TabName='PHQ9'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationOrder]
		,[ErrorMessage]
		,[SectionName]
		)
	VALUES (
		N'Y'
		,@DocumentCodeId
		,NULL
		,'PHQ9'
		,8
		,N'PHQ9Documents'
		,N'TroubleConcentrating'
		,'FROM PHQ9Documents CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE CS.TroubleConcentrating IS NULL and AdultOrChild = ''A'' and CM.ClientInDDPopulation <> ''Y'' AND ISNULL(CS.ClientDeclinedToParticipate,''N'') = ''N''  and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
		,7
		,N'Trouble concentrating on things... is required'
		,'Over the last weeks'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND TableName = 'PHQ9Documents' and ColumnName='MovingOrSpeakingSlowly' AND TabName='PHQ9'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationOrder]
		,[ErrorMessage]
		,[SectionName]
		)
	VALUES (
		N'Y'
		,@DocumentCodeId
		,NULL
		,'PHQ9'
		,8
		,N'PHQ9Documents'
		,N'MovingOrSpeakingSlowly'
		,'FROM PHQ9Documents CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE CS.MovingOrSpeakingSlowly IS NULL and AdultOrChild = ''A'' and CM.ClientInDDPopulation <> ''Y'' AND ISNULL(CS.ClientDeclinedToParticipate,''N'') = ''N''  and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
		,8
		,N'Moving or speaking so slowly... is required'
		,'Over the last weeks'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND TableName = 'PHQ9Documents' and ColumnName='HurtingYourself' AND TabName='PHQ9'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationOrder]
		,[ErrorMessage]
		,[SectionName]
		)
	VALUES (
		N'Y'
		,@DocumentCodeId
		,NULL
		,'PHQ9'
		,8
		,N'PHQ9Documents'
		,N'HurtingYourself'
		,'FROM PHQ9Documents CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE CS.HurtingYourself IS NULL and AdultOrChild = ''A'' and CM.ClientInDDPopulation <> ''Y'' AND ISNULL(CS.ClientDeclinedToParticipate,''N'') = ''N''  and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
		,9
		,N'Thoughts that you would be better off dead... is required'
		,'Over the last weeks'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND TableName = 'PHQ9Documents' and ColumnName='GetAlongOtherPeople' AND TabName='PHQ9'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationOrder]
		,[ErrorMessage]
		,[SectionName]
		)
	VALUES (
		N'Y'
		,@DocumentCodeId
		,NULL
		,'PHQ9'
		,8
		,N'PHQ9Documents'
		,N'GetAlongOtherPeople'
		,'FROM PHQ9Documents CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE CS.GetAlongOtherPeople IS NULL and AdultOrChild = ''A'' and CM.ClientInDDPopulation <> ''Y'' AND ISNULL(CS.ClientDeclinedToParticipate,''N'') = ''N''  and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
		,10
		,N'If you checked off any problems... is required'
		,'Over the last weeks'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND TableName = 'PHQ9Documents' and ColumnName='DocumentationFollowup' AND TabName='PHQ9'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationOrder]
		,[ErrorMessage]
		,[SectionName]
		)
	VALUES (
		N'Y'
		,@DocumentCodeId
		,NULL
		,'PHQ9'
		,8
		,N'PHQ9Documents'
		,N'DocumentationFollowup'
		,'FROM PHQ9Documents CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE  AdultOrChild = ''A'' and CM.ClientInDDPopulation <> ''Y'' AND ISNULL(CS.ClientDeclinedToParticipate,''N'') = ''N'' AND ISNULL(CS.OtherInterventions, ''Y'') = ''Y'' AND ISNULL(CS.DocumentationFollowup,'''')='''' AND ISNULL(CS.ClientRefusedOrContraIndicated,''N'')=''N''  and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
		,11
		,N'Documentation of follow-up plan is required'
		,'Additional Question'
		)
END

--Risk Assessment tab
IF NOT EXISTS (SELECT 1 FROM DocumentValidations WHERE DocumentCodeId = @DocumentCodeId and ErrorMessage= 'At lease 1 Risk Factor Lookup must be selected or No Known Other Risk Factors should be checked') 
BEGIN 
insert into DocumentValidations 
(Active,
DocumentCodeId, 
DocumentType,
TabName, 
TabOrder, 
TableName, 
ColumnName, 
ValidationLogic, 
ValidationDescription, 
ValidationOrder, 
ErrorMessage, 
RecordDeleted,
SectionName ) 
values('Y',@DocumentCodeId,NULL,'Risk Assessment',12,'CustomDocumentMHAssessments','RiskOtherFactorsNone',
'From #CustomDocumentMHAssessments  where isnull(RiskOtherFactorsNone,'''')='''' 
OR NOT EXISTS(select 1 from CustomOtherRiskFactors where DocumentVersionId = @DocumentVersionId AND ISNULL(RecordDeleted,''N'') = ''N'' ) ',
'',1,'At lease 1 Risk Factor Lookup must be selected or No Known Other Risk Factors should be checked',NULL,'Other Risk Factors')
END

