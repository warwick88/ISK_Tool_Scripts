
/*Date				Authour				Prupose                 */
/*05/20/2020		Packia				Insert script for adding Validation logics to UNCOPE tab in MH Assessment. KCMHSAS Improvements #7*/



DECLARE @DocumentCodeId int
SET @DocumentCodeId =(SELECT DocumentCodeId FROM DocumentCodes where Code='69E559DD-1A4D-46D3-B91C-E89DA48E0038' )

IF NOT EXISTS (
		SELECT 1
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND TableName = 'CustomDocumentAssessmentSubstanceUses' and ColumnName='BriefCounseling' AND TabName='UNCOPE'
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
		,N'BriefCounseling'
		,'FROM #CustomDocumentAssessmentSubstanceUses CS JOIN #CustomDocumentMHAssessments CM 
ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE  CM.AdultOrChild = ''A''
		and ((@ClientSex =''M'' and @Age > 65 and CS.DrinksPerWeek >=7 ) OR 
		(@ClientSex =''F''  and CS.DrinksPerWeek >=7) OR
		(@ClientSex =''M'' and @Age between 0 and 64 and CS.DrinksPerWeek >= 14 ) OR
		 (DATEDIFF(dd, CS.LastTimeDrinkDate, GETDATE()) <= 90) OR 
		 (CS.IllegalDrugs =''Y'' ))AND ISNULL(CS.BriefCounseling,'''') = '''' AND ISNULL(CS.BriefCounseling,'''') = ''''
		 AND ISNULL(CS.FeedBackOnAlcoholUse,'''') = '''' AND ISNULL(CS.Harms,'''') = ''''  AND ISNULL(CS.DevelopmentOfPlans,'''') = '''' 
		 AND ISNULL(CS.Refferal,'''') = ''''
		and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N''' 
		,4
		,N'Follow up - Atleast one checkbox selection is required'
		,NULL
		)
END



IF NOT EXISTS (
		SELECT 1
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND TableName = 'CustomDocumentAssessmentSubstanceUses' and ColumnName='BriefCounseling' AND TabName='CRAFFT'
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
		,N'BriefCounseling'
		,'FROM #CustomDocumentAssessmentSubstanceUses CS JOIN #CustomDocumentMHAssessments CM 
ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE  CM.AdultOrChild = ''C''
		and ((@ClientSex =''M'' and @Age > 65 and CS.DrinksPerWeek >=7 ) OR 
		(@ClientSex =''F''  and CS.DrinksPerWeek >=7) OR
		(@ClientSex =''M'' and @Age between 0 and 64 and CS.DrinksPerWeek >= 14 ) OR
		 (DATEDIFF(dd, CS.LastTimeDrinkDate, GETDATE()) <= 90) OR 
		 (CS.IllegalDrugs =''Y'' ))AND ISNULL(CS.BriefCounseling,'''') = '''' AND ISNULL(CS.BriefCounseling,'''') = ''''
		 AND ISNULL(CS.FeedBackOnAlcoholUse,'''') = '''' AND ISNULL(CS.Harms,'''') = ''''  AND ISNULL(CS.DevelopmentOfPlans,'''') = '''' 
		 AND ISNULL(CS.Refferal,'''') = ''''
		and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N''' 
		,4
		,N'Follow up - Atleast one checkbox selection is required'
		,null
		)
END




