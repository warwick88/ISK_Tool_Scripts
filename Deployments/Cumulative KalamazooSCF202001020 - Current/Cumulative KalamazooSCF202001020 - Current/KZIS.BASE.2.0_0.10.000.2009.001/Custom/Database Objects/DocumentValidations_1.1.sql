/*Date				Authour				Prupose                  */
/*05/20/2020		Packia				Insert script for adding Validation logics to UNCOPE,CREAFT,PES tab in MH Assessment. KCMHSAS Improvements #7*/

	 

DECLARE @DocumentCodeId int
SET @DocumentCodeId =(SELECT DocumentCodeId FROM DocumentCodes where Code='69E559DD-1A4D-46D3-B91C-E89DA48E0038' )

IF NOT EXISTS (
		SELECT 1
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND TableName = 'CustomDocumentAssessmentSubstanceUses' and ColumnName='DrinksPerWeek' AND TabName='UNCOPE'
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
		,'UNCOPE'
		,2
		,N'CustomDocumentAssessmentSubstanceUses'
		,N'DrinksPerWeek'
		,'FROM #CustomDocumentAssessmentSubstanceUses CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE ISNULL(DrinksPerWeek,0)=0 and AdultOrChild = ''A'' and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
		,1
		,N'How many drinks do you have per week? is required'
		,'Substance Use'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND TableName = 'CustomDocumentAssessmentSubstanceUses' and ColumnName='LastTimeDrinkDate' AND TabName='UNCOPE'
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
		,'UNCOPE'
		,2
		,N'CustomDocumentAssessmentSubstanceUses'
		,N'LastTimeDrinkDate'
		,'FROM #CustomDocumentAssessmentSubstanceUses CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE  AdultOrChild = ''A'' and (LastTimeDrinkDate IS NULL OR  LastTimeDrinks IS NULL)and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
		,2
		,N'When was the last time you had 4 or more... is required'
		,'Substance Use'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND TableName = 'CustomDocumentAssessmentSubstanceUses' and ColumnName='IllegalDrugs' AND TabName='UNCOPE'
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
		,'UNCOPE'
		,2
		,N'CustomDocumentAssessmentSubstanceUses'
		,N'IllegalDrugs'
		,'FROM #CustomDocumentAssessmentSubstanceUses CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE  AdultOrChild = ''A'' and ISNULL(IllegalDrugs,'''')='''' and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
		,3
		,N'In the past year, have you used or experimented... is required'
		,'Substance Use'
		)
END


--IF NOT EXISTS (
--		SELECT 1
--		FROM DocumentValidations
--		WHERE DocumentCodeId = @DocumentCodeId
--		AND TableName = 'CustomDocumentAssessmentSubstanceUses' and ColumnName='BriefCounseling' AND TabName='UNCOPE'
--		)
--BEGIN
--	INSERT [dbo].[DocumentValidations] (
--		[Active]
--		,[DocumentCodeId]
--		,[DocumentType]
--		,[TabName]
--		,[TabOrder]
--		,[TableName]
--		,[ColumnName]
--		,[ValidationLogic]
--		,[ValidationOrder]
--		,[ErrorMessage]
--		,[SectionName]
--		)
--	VALUES (
--		N'Y'
--		,@DocumentCodeId
--		,NULL
--		,'UNCOPE'
--		,2
--		,N'CustomDocumentAssessmentSubstanceUses'
--		,N'BriefCounseling'
--		,'FROM #CustomDocumentAssessmentSubstanceUses CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE  AdultOrChild = ''A'' 
--		and( (@ClientSex =''M'' and @Age > 65 and CS.DrinksPerWeek >=7 ) OR 
--		(@ClientSex =''F''  and CS.DrinksPerWeek >=7) OR
--		(@ClientSex =''M'' and @Age between 0 and 64 and CS.DrinksPerWeek >= 14 ) OR
--		 DATEDIFF(dd, CS.LastTimeDrinkDate, GETDATE()) <= 90 OR 
--		 CS.IllegalDrugs =''Y'' AND ISNULL(CS.BriefCounseling,'''') = '''' 
--		 AND ISNULL(CS.FeedBackOnAlcoholUse,'''') = '''' AND ISNULL(CS.Harms,'''') = ''''  AND ISNULL(CS.DevelopmentOfPlans,'''') = '''' AND ISNULL(CS.Refferal,'''') = '''')
--		and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
--		,4
--		,N'Atleast one checkbox selection is required'
--		,'Follow up'
--		)
--END

IF NOT EXISTS (
		SELECT 1
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND TableName = 'CustomDocumentAssessmentSubstanceUses' and ColumnName='DDOneTimeOnly' AND TabName='UNCOPE'
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
		,'UNCOPE'
		,2
		,N'CustomDocumentAssessmentSubstanceUses'
		,N'DDOneTimeOnly'
		,'FROM #CustomDocumentAssessmentSubstanceUses CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE  AdultOrChild = ''A'' and CS.DDOneTimeOnly=''Y'' AND ISNULL(CM.ClientInDDPopulation,''N'')=''N''  and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
		,5
		,N'Not required to check the box when DD checkbox is selected as population type in General tab.'
		,'DD One Time Only'
		)
END


IF NOT EXISTS (
		SELECT 1
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND TableName = 'CustomDocumentMHAssessments' and ColumnName='UncopeQuestionO' AND TabName='UNCOPE'
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
		,'UNCOPE'
		,2
		,N'CustomDocumentMHAssessments'
		,N'UncopeQuestionO'
		,'FROM #CustomDocumentMHAssessments CS  WHERE  AdultOrChild = ''A'' and ISNULL(UncopeQuestionO,'''')='''' and UncopeApplicable=''Y'' '
		,6
		,N'Has your family, a friend, or anyone else ever told you they objected to your alcohol... is required'
		,null
		)
END


IF NOT EXISTS (
		SELECT 1
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND TableName = 'CustomDocumentMHAssessments' and ColumnName='UncopeQuestionP' AND TabName='UNCOPE'
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
		,'UNCOPE'
		,2
		,N'CustomDocumentMHAssessments'
		,N'UncopeQuestionP'
		,'FROM #CustomDocumentMHAssessments CS  WHERE  AdultOrChild = ''A'' and ISNULL(UncopeQuestionP,'''')='''' and UncopeApplicable=''Y'' '
		,7
		,N'Have you ever found yourself preoccupied with wanting... is required'
		,null
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND TableName = 'CustomDocumentMHAssessments' and ColumnName='UncopeQuestionE' AND TabName='UNCOPE'
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
		,'UNCOPE'
		,2
		,N'CustomDocumentMHAssessments'
		,N'UncopeQuestionE'
		,'FROM #CustomDocumentMHAssessments CS  WHERE  AdultOrChild = ''A'' and ISNULL(UncopeQuestionE,'''')='''' and UncopeApplicable=''Y'' '
		,8
		,N'Have you ever used alcohol or drugs to relieve... is required'
		,null
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND TableName = 'CustomDocumentMHAssessments' and ColumnName='StageOfChange' AND TabName='UNCOPE'
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
		,'UNCOPE'
		,2
		,N'CustomDocumentMHAssessments'
		,N'StageOfChange'
		,'FROM #CustomDocumentMHAssessments CS  WHERE  AdultOrChild = ''A'' and StageOfChange IS NULL'
		,9
		,N'Stage of Change is required'
		,null
		)
END

--CRAFFT

IF NOT EXISTS (
		SELECT 1
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND TableName = 'CustomDocumentAssessmentSubstanceUses' and ColumnName='DrinksPerWeek' AND TabName='CRAFFT'
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
		,'CRAFFT'
		,2
		,N'CustomDocumentAssessmentSubstanceUses'
		,N'DrinksPerWeek'
		,'FROM #CustomDocumentAssessmentSubstanceUses CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE ISNULL(DrinksPerWeek,0)=0 and AdultOrChild = ''C'' and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
		,1
		,N'How many drinks do you have per week? is required'
		,'Substance Use'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND TableName = 'CustomDocumentAssessmentSubstanceUses' and ColumnName='LastTimeDrinkDate' AND TabName='CRAFFT'
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
		,'CRAFFT'
		,2
		,N'CustomDocumentAssessmentSubstanceUses'
		,N'LastTimeDrinkDate'
		,'FROM #CustomDocumentAssessmentSubstanceUses CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE  AdultOrChild = ''C'' and (LastTimeDrinkDate IS NULL OR  LastTimeDrinks IS NULL)and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
		,2
		,N'When was the last time you had 4 or more... is required'
		,'Substance Use'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND TableName = 'CustomDocumentAssessmentSubstanceUses' and ColumnName='IllegalDrugs' AND TabName='CRAFFT'
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
		,'CRAFFT'
		,2
		,N'CustomDocumentAssessmentSubstanceUses'
		,N'IllegalDrugs'
		,'FROM #CustomDocumentAssessmentSubstanceUses CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE  AdultOrChild = ''C'' and ISNULL(IllegalDrugs,'''')='''' and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
		,3
		,N'In the past year, have you used or experimented... is required'
		,'Substance Use'
		)
END


--IF NOT EXISTS (
--		SELECT 1
--		FROM DocumentValidations
--		WHERE DocumentCodeId = @DocumentCodeId
--		AND TableName = 'CustomDocumentAssessmentSubstanceUses' and ColumnName='BriefCounseling' AND TabName='CRAFFT'
--		)
--BEGIN
--	INSERT [dbo].[DocumentValidations] (
--		[Active]
--		,[DocumentCodeId]
--		,[DocumentType]
--		,[TabName]
--		,[TabOrder]
--		,[TableName]
--		,[ColumnName]
--		,[ValidationLogic]
--		,[ValidationOrder]
--		,[ErrorMessage]
--		,[SectionName]
--		)
--	VALUES (
--		N'Y'
--		,@DocumentCodeId
--		,NULL
--		,'CRAFFT'
--		,2
--		,N'CustomDocumentAssessmentSubstanceUses'
--		,N'BriefCounseling'
--		,'FROM #CustomDocumentAssessmentSubstanceUses CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE  AdultOrChild = ''C'' 
--		and ((@ClientSex =''M'' and @Age > 65 and CS.DrinksPerWeek >=7 ) OR 
--		(@ClientSex =''F''  and CS.DrinksPerWeek >=7) OR
--		(@ClientSex =''M'' and @Age between 0 and 64 and CS.DrinksPerWeek >= 14 ) OR
--		 DATEDIFF(dd, CS.LastTimeDrinkDate, GETDATE()) <= 90 OR 
--		 CS.IllegalDrugs =''Y'' AND ISNULL(CS.BriefCounseling,'''') = '''' 
--		 AND ISNULL(CS.FeedBackOnAlcoholUse,'''') = '''' AND ISNULL(CS.Harms,'''') = ''''  AND ISNULL(CS.DevelopmentOfPlans,'''') = '''' AND ISNULL(CS.Refferal,'''') = ''''
--		)and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
--		,4
--		,N'Atleast one checkbox selection is required'
--		,'Follow up'
--		)
--END

IF NOT EXISTS (
		SELECT 1
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND TableName = 'CustomDocumentAssessmentSubstanceUses' and ColumnName='DDOneTimeOnly' AND TabName='CRAFFT'
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
		,'CRAFFT'
		,2
		,N'CustomDocumentAssessmentSubstanceUses'
		,N'DDOneTimeOnly'
		,'FROM #CustomDocumentAssessmentSubstanceUses CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE  AdultOrChild = ''C'' and CS.DDOneTimeOnly=''Y'' AND ISNULL(CM.ClientInDDPopulation,''N'')=''N''  and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
		,5
		,N'Not required to check the box when DD checkbox is selected as population type in General tab.'
		,'DD One Time Only'
		)
END


--PES

IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=@DocumentCodeId and ErrorMessage='I am able to identify and find employment opportunities consistent with my strengths, abilities, and preferences - is required' and TableName = '#CustomDocumentPreEmploymentActivities') 
BEGIN
INSERT [dbo].[DocumentValidations] ([Active], [DocumentCodeId], [DocumentType], [TabName], [TabOrder], [TableName], [ColumnName], [ValidationLogic], [ValidationDescription], [ValidationOrder], [ErrorMessage]) VALUES (N'Y', @DocumentCodeId, NULL, N'PES', 5, N'#CustomDocumentPreEmploymentActivities', N'EmploymentOpportunities', N'from #CustomDocumentPreEmploymentActivities CDPA join CustomDocumentMHAssessments CHRM on CDPA.DocumentVersionId = CHRM.DocumentVersionId where isnull(CDPA.EmploymentOpportunities,'''')='''' and AdultOrChild = ''A'' and CDPA.DocumentVersionId=@DocumentVersionId AND ISNULL(CDPA.RecordDeleted,''N'') = ''N''', N'I am able to identify and find employment opportunities consistent with my strengths, abilities, and preferences - is required', 1,N'I am able to identify and find employment opportunities consistent with my strengths, abilities, and preferences - is required')
END

IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=@DocumentCodeId and ErrorMessage='Employment Opportunities comment is required' and TableName = '#CustomDocumentPreEmploymentActivities') 
BEGIN
INSERT [dbo].[DocumentValidations] 
([Active], [DocumentCodeId], [DocumentType], [TabName], [TabOrder], [TableName], [ColumnName], [ValidationLogic], [ValidationDescription], [ValidationOrder], [ErrorMessage]) VALUES (N'Y', @DocumentCodeId, NULL, N'PES', 5, N'#CustomDocumentPreEmploymentActivities', N'EmploymentOpportunitiesNeedsComments', N'from #CustomDocumentPreEmploymentActivities CDPA join CustomDocumentMHAssessments CHRM on CDPA.DocumentVersionId = CHRM.DocumentVersionId where CDPA.EmploymentOpportunitiesNeeds=''Y'' and isnull(EmploymentOpportunitiesNeedsComments,'''')='''' and AdultOrChild = ''A'' and CDPA.DocumentVersionId=@DocumentVersionId AND ISNULL(CDPA.RecordDeleted,''N'') = ''N''', N'Employment Opportunities comment is required', 2, N'Employment Opportunities comment is required')
END 


IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=@DocumentCodeId
 and ErrorMessage='I have worked consistently in the past and I am able to maintain employment - is required' 
 and TableName = '#CustomDocumentPreEmploymentActivities') 
BEGIN
INSERT [dbo].[DocumentValidations] ([Active], [DocumentCodeId], [DocumentType], [TabName], [TabOrder], [TableName], [ColumnName], [ValidationLogic], [ValidationDescription], [ValidationOrder], [ErrorMessage]) 
VALUES (N'Y', @DocumentCodeId, NULL, N'PES', 5, N'#CustomDocumentPreEmploymentActivities', N'WorkHistory', N'from #CustomDocumentPreEmploymentActivities CDPA join CustomDocumentMHAssessments CHRM on CDPA.DocumentVersionId = CHRM.DocumentVersionId where isnull(CDPA.WorkHistory,'''')='''' and AdultOrChild = ''A'' and CDPA.DocumentVersionId=@DocumentVersionId AND ISNULL(CDPA.RecordDeleted,''N'') = ''N''', N'I have worked consistently in the past and I am able to maintain employment - is required', 3,N'I have worked consistently in the past and I am able to maintain employment - is required')
END

IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=@DocumentCodeId and ErrorMessage='Work History comment is required' and TableName = '#CustomDocumentPreEmploymentActivities') 
BEGIN
INSERT [dbo].[DocumentValidations] ([Active], [DocumentCodeId], [DocumentType], [TabName], [TabOrder], [TableName], [ColumnName], [ValidationLogic], [ValidationDescription], [ValidationOrder], [ErrorMessage]) VALUES (N'Y', @DocumentCodeId, NULL, N'PES', 5, N'#CustomDocumentPreEmploymentActivities', N'WorkHistoryNeedsComments', N'from #CustomDocumentPreEmploymentActivities CDPA join CustomDocumentMHAssessments CHRM on CDPA.DocumentVersionId = CHRM.DocumentVersionId where CDPA.WorkHistoryNeeds = ''Y'' and isnull(CDPA.WorkHistoryNeedsComments,'''')='''' and AdultOrChild = ''A'' and CDPA.DocumentVersionId=@DocumentVersionId AND ISNULL(CDPA.RecordDeleted,''N'') = ''N''', N'Work History comment is required', 4,N'Work History comment is required')
END 


IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=@DocumentCodeId and ErrorMessage='I understand how employment income will affect benefits - is required' and TableName = '#CustomDocumentPreEmploymentActivities') 
BEGIN
INSERT [dbo].[DocumentValidations] ([Active], [DocumentCodeId], [DocumentType], [TabName], [TabOrder], [TableName], [ColumnName], [ValidationLogic], [ValidationDescription], [ValidationOrder], [ErrorMessage]) VALUES (N'Y', @DocumentCodeId, NULL, N'PES', 5, N'#CustomDocumentPreEmploymentActivities', N'GainfulEmploymentBenefits', N'from #CustomDocumentPreEmploymentActivities CDPA join CustomDocumentMHAssessments CHRM on CDPA.DocumentVersionId = CHRM.DocumentVersionId where isnull(CDPA.GainfulEmploymentBenefits,'''')='''' and AdultOrChild = ''A'' and CDPA.DocumentVersionId=@DocumentVersionId AND ISNULL(CDPA.RecordDeleted,''N'') = ''N''', N'I understand how employment income will affect benefits - is required', 5,N'I understand how employment income will affect benefits - is required')
END

IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=@DocumentCodeId and ErrorMessage='Gainful Employment - Benefits comment is required' and TableName = '#CustomDocumentPreEmploymentActivities') 
BEGIN
INSERT [dbo].[DocumentValidations] 
([Active], [DocumentCodeId], [DocumentType], [TabName], [TabOrder], [TableName], [ColumnName], [ValidationLogic], [ValidationDescription], [ValidationOrder], [ErrorMessage]) VALUES (N'Y', @DocumentCodeId, NULL, N'PES', 5, N'#CustomDocumentPreEmploymentActivities', N'GainfulEmploymentBenefitsNeedsComments', N'from #CustomDocumentPreEmploymentActivities CDPA join CustomDocumentMHAssessments CHRM on CDPA.DocumentVersionId = CHRM.DocumentVersionId where CDPA.GainfulEmploymentBenefitsNeeds = ''Y'' and isnull(GainfulEmploymentBenefitsNeedsComments,'''')='''' and AdultOrChild = ''A'' and CDPA.DocumentVersionId=@DocumentVersionId AND ISNULL(CDPA.RecordDeleted,''N'') = ''N''', N'Gainful Employment - Benefits comment is required', 6,N'Gainful Employment - Benefits comment is required')
END

IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=@DocumentCodeId and ErrorMessage='I have been successful in the interview process and I am able to get and maintain a job - is required' and TableName = '#CustomDocumentPreEmploymentActivities') 
BEGIN
INSERT [dbo].[DocumentValidations]  ([Active], [DocumentCodeId], [DocumentType], [TabName], [TabOrder], [TableName], [ColumnName], [ValidationLogic], [ValidationDescription], [ValidationOrder], [ErrorMessage]) VALUES (N'Y', @DocumentCodeId, NULL, N'PES', 5, N'#CustomDocumentPreEmploymentActivities', N'GainfulEmployment', N'from #CustomDocumentPreEmploymentActivities CDPA join CustomDocumentMHAssessments CHRM on CDPA.DocumentVersionId = CHRM.DocumentVersionId where isnull(CDPA.GainfulEmployment,'''')='''' and AdultOrChild = ''A'' and CDPA.DocumentVersionId=@DocumentVersionId AND ISNULL(CDPA.RecordDeleted,''N'') = ''N''', N'I have been successful in the interview process and I am able to get and maintain a job - is required', 7, N'I have been successful in the interview process and I am able to get and maintain a job - is required')
END

IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=@DocumentCodeId and ErrorMessage='Gainful Employment comment is required' and TableName = '#CustomDocumentPreEmploymentActivities') 
BEGIN
INSERT [dbo].[DocumentValidations] ([Active], [DocumentCodeId], [DocumentType], [TabName], [TabOrder], [TableName], [ColumnName], [ValidationLogic], [ValidationDescription], [ValidationOrder], [ErrorMessage]) VALUES (N'Y', @DocumentCodeId, NULL, N'PES', 5, N'#CustomDocumentPreEmploymentActivities', N'GainfulEmploymentNeedsComments', N'from #CustomDocumentPreEmploymentActivities CDPA join CustomDocumentMHAssessments CHRM on CDPA.DocumentVersionId = CHRM.DocumentVersionId  where CDPA.GainfulEmploymentNeeds = ''Y'' and isnull(GainfulEmploymentNeedsComments,'''')='''' and AdultOrChild = ''A'' and CDPA.DocumentVersionId=@DocumentVersionId AND ISNULL(CDPA.RecordDeleted,''N'') = ''N''', N'Gainful Employment comment is required', 8,N'Gainful Employment comment is required')
END