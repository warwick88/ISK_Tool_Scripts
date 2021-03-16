--Date: 06/30/2020
--Purpose: Added Validation logic as per the requirement of KCMHSAS Improvements #7

DECLARE @DocumentCodeId int
SET @DocumentCodeId =(SELECT DocumentCodeId FROM DocumentCodes where Code='69E559DD-1A4D-46D3-B91C-E89DA48E0038' )

--UNCOPE
IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND ErrorMessage =  'Have you spent more time drinking or using than you intended to? is required'	)
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
		)
	VALUES (
		N'Y'
		,@DocumentCodeId
		,NULL
		,'UNCOPE'
		,2
		,N'CustomDocumentMHAssessments'
		,N'UncopeQuestionU'
		,'FROM #CustomDocumentMHAssessments CS  WHERE  AdultOrChild = ''A'' and ISNULL(UncopeQuestionU,'''')='''' and UncopeApplicable=''Y'' '
		,7
		,N'Have you spent more time drinking or using than you intended to? is required'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND ErrorMessage =  'Have you ever neglected some of your usual responsibilities... is required'	)
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
		)
	VALUES (
		N'Y'
		,@DocumentCodeId
		,NULL
		,'UNCOPE'
		,2
		,N'CustomDocumentMHAssessments'
		,N'UncopeQuestionN'
		,'FROM #CustomDocumentMHAssessments CS  WHERE  AdultOrChild = ''A'' and ISNULL(UncopeQuestionN,'''')='''' and UncopeApplicable=''Y'' '
		,8
		,N'Have you ever neglected some of your usual responsibilities... is required'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND ErrorMessage =  'Have you felt you wanted or needed to cut down on your drinking... is required'	)
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
		)
	VALUES (
		N'Y'
		,@DocumentCodeId
		,NULL
		,'UNCOPE'
		,2
		,N'CustomDocumentMHAssessments'
		,N'UncopeQuestionC'
		,'FROM #CustomDocumentMHAssessments CS  WHERE  AdultOrChild = ''A'' and ISNULL(UncopeQuestionC,'''')='''' and UncopeApplicable=''Y'' '
		,9
		,N'Have you felt you wanted or needed to cut down on your drinking... is required'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND ErrorMessage =  'Is UNCOPE applicable is required'	)
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
		)
	VALUES (
		N'Y'
		,@DocumentCodeId
		,NULL
		,'UNCOPE'
		,2
		,N'CustomDocumentMHAssessments'
		,N'UncopeApplicable'
		,'FROM #CustomDocumentMHAssessments CS  WHERE  AdultOrChild = ''A'' and ISNULL(UncopeApplicable,'''')='''' '
		,6
		,N'Is UNCOPE applicable is required'
		)
END


--Psycho - Adult
IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND ErrorMessage =  'Client experienced or witnessed abuse or neglect - Textbox is required'	)
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
		)
	VALUES (
		N'Y'
		,@DocumentCodeId
		,NULL
		,'Psychosocial'
		,7
		,N'CustomDocumentMHAssessments'
		,N'PsClientAbuesIssuesComment'
		,'FROM #CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND PsClientAbuseIssues = ''Y''  AND ISNULL(PsClientAbuesIssuesComment,'''')=''''  '
		,33
		,N'Client experienced or witnessed abuse or neglect - Textbox is required'
		)
END

--Summary 
IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND ErrorMessage =  'Summary/LOC - Transition/Level of Care/Discharge Plan - Reduction in symptoms - Textbox is required'	)
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
		)
	VALUES (
		N'Y'
		,@DocumentCodeId
		,NULL
		,null
		,18
		,N'CustomDocumentMHAssessments'
		,N'ReductionInSymptomsDescription'
		,'FROM #CustomDocumentMHAssessments WHERE ISNULL(ReductionInSymptoms,''N'')=''Y'' AND ISNULL(ReductionInSymptomsDescription,'''')=''''  '
		,9
		,N'Summary/LOC - Transition/Level of Care/Discharge Plan - Reduction in symptoms - Textbox is required'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND ErrorMessage =  'Summary/LOC - Transition/Level of Care/Discharge Plan - Attainment of higher level of functioning - Textbox is required'	)
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
		)
	VALUES (
		N'Y'
		,@DocumentCodeId
		,NULL
		,null
		,18
		,N'CustomDocumentMHAssessments'
		,N'AttainmentOfHigherFunctioning'
		,'FROM #CustomDocumentMHAssessments WHERE ISNULL(AttainmentOfHigherFunctioning,''N'')=''Y'' AND ISNULL(AttainmentOfHigherFunctioningDescription,'''')=''''  '
		,10
		,N'Summary/LOC - Transition/Level of Care/Discharge Plan - Attainment of higher level of functioning - Textbox is required'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND ErrorMessage =  'Summary/LOC - Transition/Level of Care/Discharge Plan - Treatment is no longer medically necessary - Textbox is required'	)
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
		)
	VALUES (
		N'Y'
		,@DocumentCodeId
		,NULL
		,null
		,18
		,N'CustomDocumentMHAssessments'
		,N'TreatmentNotNecessaryDescription'
		,'FROM #CustomDocumentMHAssessments WHERE ISNULL(TreatmentNotNecessary,''N'')=''Y'' AND ISNULL(TreatmentNotNecessaryDescription,'''')=''''  '
		,11
		,N'Summary/LOC - Transition/Level of Care/Discharge Plan - Treatment is no longer medically necessary - Textbox is required'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND ErrorMessage =  'Summary/LOC - Transition/Level of Care/Discharge Plan - Other - Textbox is required'	)
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
		)
	VALUES (
		N'Y'
		,@DocumentCodeId
		,NULL
		,null
		,18
		,N'CustomDocumentMHAssessments'
		,N'OtherTransitionCriteriaDescription'
		,'FROM #CustomDocumentMHAssessments WHERE ISNULL(OtherTransitionCriteria,''N'')=''Y'' AND ISNULL(OtherTransitionCriteriaDescription,'''')=''''  '
		,12
		,N'Summary/LOC - Transition/Level of Care/Discharge Plan - Other - Textbox is required'
		)
END