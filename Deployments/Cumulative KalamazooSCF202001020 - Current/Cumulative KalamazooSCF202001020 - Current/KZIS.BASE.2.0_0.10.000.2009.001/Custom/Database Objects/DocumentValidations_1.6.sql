-- Date				Authour				Purpose		
--6/11/2020			Packia				Insert script for validation in Columbia tab in MH Assessment. KCMHSAS Improvements #7  	


DECLARE @DocumentCodeId int
SET @DocumentCodeId =(SELECT DocumentCodeId FROM DocumentCodes where Code='69E559DD-1A4D-46D3-B91C-E89DA48E0038' )
DECLARE @TabName varchar(50)
 DECLARE @TabOrder INT
SET @TabName = 'Columbia'
 SET @TabOrder =13


IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
			AND ErrorMessage = 'Wish To Be Dead Description is required'
			AND TableName = 'CustomDocumentMHColumbiaAdultSinceLastVisits'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active],
		[DocumentCodeId],
		[DocumentType],
		[TabName],
		[TabOrder],
		[TableName],
		[ColumnName],
		[ValidationLogic],
		[ValidationDescription],
		[ValidationOrder],
		[ErrorMessage]
		)
	VALUES (
		N'Y',
		@DocumentCodeId,
		NULL,
		@TabName,
		@TabOrder,
		N'CustomDocumentMHColumbiaAdultSinceLastVisits',
		N'WishToBeDeadDescription',
		'FROM CustomDocumentMHColumbiaAdultSinceLastVisits CDCCSLV inner join CustomDocumentMHAssessments CHA ON CDCCSLV.DocumentVersionId = CHA.DocumentVersionId WHERE CDCCSLV.DocumentVersionId=@DocumentVersionId
 AND ISNULL(CDCCSLV.WishToBeDead,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''Yes'' and Category = ''XCSSRSYESNO'') 
 AND ISNULL(CDCCSLV.WishToBeDeadDescription,'''') = ''''  AND ISNULL(CDCCSLV.RecordDeleted,''N'') = ''N'' ',
		N'Wish To Be Dead Description is required',
		2,
		N'Wish To Be Dead Description is required'
		)
END




IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
			AND ErrorMessage = 'Non-Specific Active Suicidal Thoughts Description is required'
			AND TableName = 'CustomDocumentMHColumbiaAdultSinceLastVisits'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active],
		[DocumentCodeId],
		[DocumentType],
		[TabName],
		[TabOrder],
		[TableName],
		[ColumnName],
		[ValidationLogic],
		[ValidationDescription],
		[ValidationOrder],
		[ErrorMessage]
		)
	VALUES (
		N'Y',
		@DocumentCodeId,
		NULL,
		@TabName,
		@TabOrder,
		N'CustomDocumentMHColumbiaAdultSinceLastVisits',
		N'NonSpecificActiveSuicidalThoughtsDescription',
		'FROM CustomDocumentMHColumbiaAdultSinceLastVisits CDCCSLV inner join CustomDocumentMHAssessments CHA ON CDCCSLV.DocumentVersionId = CHA.DocumentVersionId WHERE CDCCSLV.DocumentVersionId=@DocumentVersionId
 AND ISNULL(CDCCSLV.NonSpecificActiveSuicidalThoughts,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''Yes'' and Category = ''XCSSRSYESNO'') 
 AND ISNULL(CDCCSLV.NonSpecificActiveSuicidalThoughtsDescription,'''') = ''''  AND ISNULL(CDCCSLV.RecordDeleted,''N'') = ''N'' ',
		N'Non-Specific Active Suicidal Thoughts Description is required',
		4,
		N'Non-Specific Active Suicidal Thoughts Description is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
			AND ErrorMessage = 'Active Suicidal Ideation with Any Methods (Not Plan) without Intent to Act is required'
			AND TableName = 'CustomDocumentMHColumbiaAdultSinceLastVisits'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active],
		[DocumentCodeId],
		[DocumentType],
		[TabName],
		[TabOrder],
		[TableName],
		[ColumnName],
		[ValidationLogic],
		[ValidationDescription],
		[ValidationOrder],
		[ErrorMessage]
		)
	VALUES (
		N'Y',
		@DocumentCodeId,
		NULL,
		@TabName,
		@TabOrder,
		N'CustomDocumentMHColumbiaAdultSinceLastVisits',
		N'ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToAct',
		'FROM CustomDocumentMHColumbiaAdultSinceLastVisits CDCCSLV inner join CustomDocumentMHAssessments CHA ON CDCCSLV.DocumentVersionId = CHA.DocumentVersionId WHERE CDCCSLV.DocumentVersionId=@DocumentVersionId
 AND ISNULL(CDCCSLV.NonSpecificActiveSuicidalThoughts,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''Yes'' and Category = ''XCSSRSYESNO'') 
 AND ISNULL(CDCCSLV.ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToAct,'''') = ''''  AND ISNULL(CDCCSLV.RecordDeleted,''N'') = ''N'' ',
		N'Active Suicidal Ideation with Any Methods (Not Plan) without Intent to Act is required',
		5,
		N'Active Suicidal Ideation with Any Methods (Not Plan) without Intent to Act is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
			AND ErrorMessage = 'Active Suicidal Ideation with Any Methods (Not Plan) without Intent to Act Description is required'
			AND TableName = 'CustomDocumentMHColumbiaAdultSinceLastVisits'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active],
		[DocumentCodeId],
		[DocumentType],
		[TabName],
		[TabOrder],
		[TableName],
		[ColumnName],
		[ValidationLogic],
		[ValidationDescription],
		[ValidationOrder],
		[ErrorMessage]
		)
	VALUES (
		N'Y',
		@DocumentCodeId,
		NULL,
		@TabName,
		@TabOrder,
		N'CustomDocumentMHColumbiaAdultSinceLastVisits',
		N'ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToActDescription',
		'FROM CustomDocumentMHColumbiaAdultSinceLastVisits CDCCSLV inner join CustomDocumentMHAssessments CHA ON CDCCSLV.DocumentVersionId = CHA.DocumentVersionId WHERE CDCCSLV.DocumentVersionId=@DocumentVersionId
 AND ISNULL(CDCCSLV.ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToAct,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''Yes'' and Category = ''XCSSRSYESNO'') AND 
		ISNULL(CDCCSLV.ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToActDescription,'''') = ''''  
		AND (ISNULL(CDCCSLV.WishToBeDead,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''Yes'' and Category = ''XCSSRSYESNO'')
		 or ISNULL(CDCCSLV.NonSpecificActiveSuicidalThoughts,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''Yes'' and Category = ''XCSSRSYESNO''))
		AND ISNULL(CDCCSLV.RecordDeleted,''N'') = ''N'' ',
		N'Active Suicidal Ideation with Any Methods (Not Plan) without Intent to Act Description is required',
		6,
		N'Active Suicidal Ideation with Any Methods (Not Plan) without Intent to Act Description is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
			AND ErrorMessage = 'Active Suicidal Ideation with Some Intent to Act, without Specific Plan is required'
			AND TableName = 'CustomDocumentMHColumbiaAdultSinceLastVisits'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active],
		[DocumentCodeId],
		[DocumentType],
		[TabName],
		[TabOrder],
		[TableName],
		[ColumnName],
		[ValidationLogic],
		[ValidationDescription],
		[ValidationOrder],
		[ErrorMessage]
		)
	VALUES (
		N'Y',
		@DocumentCodeId,
		NULL,
		@TabName,
		@TabOrder,
		N'CustomDocumentMHColumbiaAdultSinceLastVisits',
		N'ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlan',
		'FROM CustomDocumentMHColumbiaAdultSinceLastVisits CDCCSLV inner join CustomDocumentMHAssessments CHA ON CDCCSLV.DocumentVersionId = CHA.DocumentVersionId WHERE CDCCSLV.DocumentVersionId=@DocumentVersionId 
AND ISNULL(CDCCSLV.NonSpecificActiveSuicidalThoughts,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''Yes'' and Category = ''XCSSRSYESNO'') 
AND ISNULL(CDCCSLV.ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlan,'''') = ''''  AND ISNULL(CDCCSLV.RecordDeleted,''N'') = ''N'' ',
		N'Active Suicidal Ideation with Some Intent to Act, without Specific Plan is required',
		7,
		N'Active Suicidal Ideation with Some Intent to Act, without Specific Plan is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
			AND ErrorMessage = 'Active Suicidal Ideation with Some Intent to Act, without Specific Plan Description is required'
			AND TableName = 'CustomDocumentMHColumbiaAdultSinceLastVisits'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active],
		[DocumentCodeId],
		[DocumentType],
		[TabName],
		[TabOrder],
		[TableName],
		[ColumnName],
		[ValidationLogic],
		[ValidationDescription],
		[ValidationOrder],
		[ErrorMessage]
		)
	VALUES (
		N'Y',
		@DocumentCodeId,
		NULL,
		@TabName,
		@TabOrder,
		N'CustomDocumentMHColumbiaAdultSinceLastVisits',
		N'ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlanDescription',
		'FROM CustomDocumentMHColumbiaAdultSinceLastVisits CDCCSLV inner join CustomDocumentMHAssessments CHA ON CDCCSLV.DocumentVersionId = CHA.DocumentVersionId WHERE CDCCSLV.DocumentVersionId=@DocumentVersionId
AND ISNULL(CDCCSLV.ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlan,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''Yes'' 
		and Category = ''XCSSRSYESNO'')
			AND (ISNULL(CDCCSLV.WishToBeDead,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''Yes'' and Category = ''XCSSRSYESNO'')
		 or ISNULL(CDCCSLV.NonSpecificActiveSuicidalThoughts,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''Yes'' and Category = ''XCSSRSYESNO'')) 
		AND ISNULL(CDCCSLV.ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlanDescription,'''') = ''''  
		AND ISNULL(CDCCSLV.RecordDeleted,''N'') = ''N'' ',
		N'Active Suicidal Ideation with Some Intent to Act, without Specific Plan Description is required',
		8,
		N'Active Suicidal Ideation with Some Intent to Act, without Specific Plan Description is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
			AND ErrorMessage = 'Active Suicidal Ideation with Specific Plan and Intent is required'
			AND TableName = 'CustomDocumentMHColumbiaAdultSinceLastVisits'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active],
		[DocumentCodeId],
		[DocumentType],
		[TabName],
		[TabOrder],
		[TableName],
		[ColumnName],
		[ValidationLogic],
		[ValidationDescription],
		[ValidationOrder],
		[ErrorMessage]
		)
	VALUES (
		N'Y',
		@DocumentCodeId,
		NULL,
		@TabName,
		@TabOrder,
		N'CustomDocumentMHColumbiaAdultSinceLastVisits',
		N'AciveSuicidalIdeationWithSpecificPlanAndIntent',
		'FROM CustomDocumentMHColumbiaAdultSinceLastVisits CDCCSLV inner join CustomDocumentMHAssessments CHA ON CDCCSLV.DocumentVersionId = CHA.DocumentVersionId WHERE CDCCSLV.DocumentVersionId=@DocumentVersionId
AND ISNULL(CDCCSLV.NonSpecificActiveSuicidalThoughts,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''Yes'' and Category = ''XCSSRSYESNO'') 
AND ISNULL(CDCCSLV.AciveSuicidalIdeationWithSpecificPlanAndIntent,'''') = ''''  AND ISNULL(CDCCSLV.RecordDeleted,''N'') = ''N'' ',
		N'Active Suicidal Ideation with Specific Plan and Intent is required',
		9,
		N'Active Suicidal Ideation with Specific Plan and Intent is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
			AND ErrorMessage = 'Active Suicidal Ideation with Specific Plan and Intent Description is required'
			AND TableName = 'CustomDocumentMHColumbiaAdultSinceLastVisits'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active],
		[DocumentCodeId],
		[DocumentType],
		[TabName],
		[TabOrder],
		[TableName],
		[ColumnName],
		[ValidationLogic],
		[ValidationDescription],
		[ValidationOrder],
		[ErrorMessage]
		)
	VALUES (
		N'Y',
		@DocumentCodeId,
		NULL,
		@TabName,
		@TabOrder,
		N'CustomDocumentMHColumbiaAdultSinceLastVisits',
		N'AciveSuicidalIdeationWithSpecificPlanAndIntentDescription',
		'FROM CustomDocumentMHColumbiaAdultSinceLastVisits CDCCSLV inner join CustomDocumentMHAssessments CHA ON CDCCSLV.DocumentVersionId = CHA.DocumentVersionId WHERE CDCCSLV.DocumentVersionId=@DocumentVersionId
		AND ISNULL(CDCCSLV.AciveSuicidalIdeationWithSpecificPlanAndIntent,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''Yes'' and Category = ''XCSSRSYESNO'') 
	    AND (ISNULL(CDCCSLV.WishToBeDead,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''Yes'' and Category = ''XCSSRSYESNO'')
		 or ISNULL(CDCCSLV.NonSpecificActiveSuicidalThoughts,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''Yes'' and Category = ''XCSSRSYESNO''))
		AND ISNULL(CDCCSLV.AciveSuicidalIdeationWithSpecificPlanAndIntentDescription,'''') = ''''  
		AND ISNULL(CDCCSLV.RecordDeleted,''N'') = ''N'' ',
		N'Active Suicidal Ideation with Specific Plan and Intent Description is required',
		10,
		N'Active Suicidal Ideation with Specific Plan and Intent Description is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
			AND ErrorMessage = 'Most Severe Ideation is required'
			AND TableName = 'CustomDocumentMHColumbiaAdultSinceLastVisits'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active],
		[DocumentCodeId],
		[DocumentType],
		[TabName],
		[TabOrder],
		[TableName],
		[ColumnName],
		[ValidationLogic],
		[ValidationDescription],
		[ValidationOrder],
		[ErrorMessage]
		)
	VALUES (
		N'Y',
		@DocumentCodeId,
		NULL,
		@TabName,
		@TabOrder,
		N'CustomDocumentMHColumbiaAdultSinceLastVisits',
		N'MostSevereIdeation',
		'FROM CustomDocumentMHColumbiaAdultSinceLastVisits CDCCSLV inner join CustomDocumentMHAssessments CHA ON CDCCSLV.DocumentVersionId = CHA.DocumentVersionId WHERE CDCCSLV.DocumentVersionId=@DocumentVersionId
		AND (ISNULL(CDCCSLV.WishToBeDead,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''Yes'' and Category = ''XCSSRSYESNO'') 
		or ISNULL(CDCCSLV.NonSpecificActiveSuicidalThoughts,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''Yes'' and Category = ''XCSSRSYESNO'')) 
		AND ISNULL(CDCCSLV.MostSevereIdeation,'''') = '''' AND ISNULL(CDCCSLV.RecordDeleted,''N'') = ''N'' ',
		N'Most Severe Ideation is required',
		11,
		N'Most Severe Ideation is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
			AND ErrorMessage = 'Frequency is required'
			AND TableName = 'CustomDocumentMHColumbiaAdultSinceLastVisits'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active],
		[DocumentCodeId],
		[DocumentType],
		[TabName],
		[TabOrder],
		[TableName],
		[ColumnName],
		[ValidationLogic],
		[ValidationDescription],
		[ValidationOrder],
		[ErrorMessage]
		)
	VALUES (
		N'Y',
		@DocumentCodeId,
		NULL,
		@TabName,
		@TabOrder,
		N'CustomDocumentMHColumbiaAdultSinceLastVisits',
		N'Frequency',
		'FROM CustomDocumentMHColumbiaAdultSinceLastVisits CDCCSLV inner join CustomDocumentMHAssessments CHA ON CDCCSLV.DocumentVersionId = CHA.DocumentVersionId WHERE CDCCSLV.DocumentVersionId=@DocumentVersionId
		AND (ISNULL(CDCCSLV.WishToBeDead,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''Yes'' and Category = ''XCSSRSYESNO'') or 
		ISNULL(CDCCSLV.NonSpecificActiveSuicidalThoughts,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''Yes'' and Category = ''XCSSRSYESNO'')) 
		AND ISNULL(CDCCSLV.Frequency,'''') = ''''  AND ISNULL(CDCCSLV.RecordDeleted,''N'') = ''N'' ',
		N'Frequency is required',
		12,
		N'Frequency is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
			AND ErrorMessage = 'Most Severe Ideation Description is required'
			AND TableName = 'CustomDocumentMHColumbiaAdultSinceLastVisits'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active],
		[DocumentCodeId],
		[DocumentType],
		[TabName],
		[TabOrder],
		[TableName],
		[ColumnName],
		[ValidationLogic],
		[ValidationDescription],
		[ValidationOrder],
		[ErrorMessage]
		)
	VALUES (
		N'Y',
		@DocumentCodeId,
		NULL,
		@TabName,
		@TabOrder,
		N'CustomDocumentMHColumbiaAdultSinceLastVisits',
		N'MostSevereIdeationDescription',
		'FROM CustomDocumentMHColumbiaAdultSinceLastVisits CDCCSLV inner join CustomDocumentMHAssessments CHA ON CDCCSLV.DocumentVersionId = CHA.DocumentVersionId WHERE CDCCSLV.DocumentVersionId=@DocumentVersionId
 AND (
		ISNULL(CDCCSLV.WishToBeDead,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''Yes'' and Category = ''XCSSRSYESNO'')
		 or ISNULL(CDCCSLV.NonSpecificActiveSuicidalThoughts,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''Yes'' and Category = ''XCSSRSYESNO'')) 
		 AND CDCCSLV.MostSevereIdeation is not null AND ISNULL(CDCCSLV.MostSevereIdeationDescription,'''') = ''''  AND ISNULL(CDCCSLV.RecordDeleted,''N'') = ''N'' ',
		N'Most Severe Ideation Description is required',
		13,
		N'Most Severe Ideation Description is required'
		)
END  

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
			AND ErrorMessage = 'Actual Attempt is required'
			AND TableName = 'CustomDocumentMHColumbiaAdultSinceLastVisits'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active],
		[DocumentCodeId],
		[DocumentType],
		[TabName],
		[TabOrder],
		[TableName],
		[ColumnName],
		[ValidationLogic],
		[ValidationDescription],
		[ValidationOrder],
		[ErrorMessage]
		)
	VALUES (
		N'Y',
		@DocumentCodeId,
		NULL,
		@TabName,
		@TabOrder,
		N'CustomDocumentMHColumbiaAdultSinceLastVisits',
		N'ActualAttempt',
		'FROM CustomDocumentMHColumbiaAdultSinceLastVisits CDCCSLV inner join CustomDocumentMHAssessments CHA ON CDCCSLV.DocumentVersionId = CHA.DocumentVersionId WHERE CDCCSLV.DocumentVersionId=@DocumentVersionId
AND ISNULL(CDCCSLV.WishToBeDead,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''No'' and Category = ''XCSSRSYESNO'') 
AND ISNULL(CDCCSLV.NonSpecificActiveSuicidalThoughts,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''No'' and Category = ''XCSSRSYESNO'') 
AND ISNULL(CDCCSLV.ActualAttempt,'''') = ''''  AND ISNULL(CDCCSLV.RecordDeleted,''N'') = ''N'' ',
		N'Actual Attempt is required',
		14,
		N'Actual Attempt is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
			AND ErrorMessage = 'Total Number Of Attempts is required'
			AND TableName = 'CustomDocumentMHColumbiaAdultSinceLastVisits'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active],
		[DocumentCodeId],
		[DocumentType],
		[TabName],
		[TabOrder],
		[TableName],
		[ColumnName],
		[ValidationLogic],
		[ValidationDescription],
		[ValidationOrder],
		[ErrorMessage]
		)
	VALUES (
		N'Y',
		@DocumentCodeId,
		NULL,
		@TabName,
		@TabOrder,
		N'CustomDocumentMHColumbiaAdultSinceLastVisits',
		N'TotalNumberOfAttempts',
		'FROM CustomDocumentMHColumbiaAdultSinceLastVisits CDCCSLV inner join CustomDocumentMHAssessments CHA ON CDCCSLV.DocumentVersionId = CHA.DocumentVersionId WHERE CDCCSLV.DocumentVersionId=@DocumentVersionId
AND ISNULL(CDCCSLV.WishToBeDead,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''No'' and Category = ''XCSSRSYESNO'') 
AND ISNULL(CDCCSLV.NonSpecificActiveSuicidalThoughts,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''No'' and Category = ''XCSSRSYESNO'') 
AND ISNULL(CDCCSLV.ActualAttempt,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''Yes'' and Category = ''XCSSRSYESNO'') 
AND ISNULL(CDCCSLV.TotalNumberOfAttempts,'''') = ''''  AND ISNULL(CDCCSLV.RecordDeleted,''N'') = ''N'' ',
		N'Total Number Of Attempts is required',
		15,
		N'Total Number Of Attempts is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
			AND ErrorMessage = 'Actual Attempt Description is required'
			AND TableName = 'CustomDocumentMHColumbiaAdultSinceLastVisits'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active],
		[DocumentCodeId],
		[DocumentType],
		[TabName],
		[TabOrder],
		[TableName],
		[ColumnName],
		[ValidationLogic],
		[ValidationDescription],
		[ValidationOrder],
		[ErrorMessage]
		)
	VALUES (
		N'Y',
		@DocumentCodeId,
		NULL,
		@TabName,
		@TabOrder,
		N'CustomDocumentMHColumbiaAdultSinceLastVisits',
		N'ActualAttemptDescription',
		'FROM CustomDocumentMHColumbiaAdultSinceLastVisits CDCCSLV inner join CustomDocumentMHAssessments CHA ON CDCCSLV.DocumentVersionId = CHA.DocumentVersionId WHERE CDCCSLV.DocumentVersionId=@DocumentVersionId
 AND ISNULL(CDCCSLV.WishToBeDead,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''No'' and Category = ''XCSSRSYESNO'') 
 AND ISNULL(CDCCSLV.NonSpecificActiveSuicidalThoughts,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''No'' 
 and Category = ''XCSSRSYESNO'')
 AND ISNULL(CDCCSLV.ActualAttempt,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''Yes'' and Category = ''XCSSRSYESNO'') AND ISNULL(ActualAttemptDescription,'''') = ''''  
 AND ISNULL(CDCCSLV.RecordDeleted,''N'') = ''N'' ',
		N'Actual Attempt Description is required',
		16,
		N'Actual Attempt Description is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
			AND ErrorMessage = 'Has Subject Engaged In Non Suicidal Self Injurious Behavior is required'
			AND TableName = 'CustomDocumentMHColumbiaAdultSinceLastVisits'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active],
		[DocumentCodeId],
		[DocumentType],
		[TabName],
		[TabOrder],
		[TableName],
		[ColumnName],
		[ValidationLogic],
		[ValidationDescription],
		[ValidationOrder],
		[ErrorMessage]
		)
	VALUES (
		N'Y',
		@DocumentCodeId,
		NULL,
		@TabName,
		@TabOrder,
		N'CustomDocumentMHColumbiaAdultSinceLastVisits',
		N'HasSubjectEngagedInNonSuicidalSelfInjuriousBehavior',
		'FROM CustomDocumentMHColumbiaAdultSinceLastVisits CDCCSLV inner join CustomDocumentMHAssessments CHA ON CDCCSLV.DocumentVersionId = CHA.DocumentVersionId WHERE CDCCSLV.DocumentVersionId=@DocumentVersionId
 AND ISNULL(CDCCSLV.WishToBeDead,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''No'' and Category = ''XCSSRSYESNO'')
  AND ISNULL(CDCCSLV.NonSpecificActiveSuicidalThoughts,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''No'' and Category = ''XCSSRSYESNO'') 
  AND ISNULL(CDCCSLV.HasSubjectEngagedInNonSuicidalSelfInjuriousBehavior,'''') = ''''  AND ISNULL(CDCCSLV.RecordDeleted,''N'') = ''N'' ',
		N'Has Subject Engaged In Non Suicidal Self Injurious Behavior is required',
		17,
		N'Has Subject Engaged In Non Suicidal Self Injurious Behavior is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
			AND ErrorMessage = 'Has Subject Engaged In Self Injurious Behavior Intent Unknown is required'
			AND TableName = 'CustomDocumentMHColumbiaAdultSinceLastVisits'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active],
		[DocumentCodeId],
		[DocumentType],
		[TabName],
		[TabOrder],
		[TableName],
		[ColumnName],
		[ValidationLogic],
		[ValidationDescription],
		[ValidationOrder],
		[ErrorMessage]
		)
	VALUES (
		N'Y',
		@DocumentCodeId,
		NULL,
		@TabName,
		@TabOrder,
		N'CustomDocumentMHColumbiaAdultSinceLastVisits',
		N'HasSubjectEngagedInSelfInjuriousBehaviorIntentUnknown',
		'FROM CustomDocumentMHColumbiaAdultSinceLastVisits CDCCSLV inner join CustomDocumentMHAssessments CHA ON CDCCSLV.DocumentVersionId = CHA.DocumentVersionId WHERE CDCCSLV.DocumentVersionId=@DocumentVersionId
  AND ISNULL(CDCCSLV.WishToBeDead,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''No'' and Category = ''XCSSRSYESNO'') 
  AND ISNULL(CDCCSLV.NonSpecificActiveSuicidalThoughts,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''No'' and Category = ''XCSSRSYESNO'') 
  AND ISNULL(CDCCSLV.HasSubjectEngagedInSelfInjuriousBehaviorIntentUnknown,'''') = ''''  AND ISNULL(CDCCSLV.RecordDeleted,''N'') = ''N'' ',
		N'Has Subject Engaged In Self Injurious Behavior Intent Unknown is required',
		18,
		N'Has Subject Engaged In Self Injurious Behavior Intent Unknown is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
			AND ErrorMessage = 'Interrupted Attempt is required'
			AND TableName = 'CustomDocumentMHColumbiaAdultSinceLastVisits'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active],
		[DocumentCodeId],
		[DocumentType],
		[TabName],
		[TabOrder],
		[TableName],
		[ColumnName],
		[ValidationLogic],
		[ValidationDescription],
		[ValidationOrder],
		[ErrorMessage]
		)
	VALUES (
		N'Y',
		@DocumentCodeId,
		NULL,
		@TabName,
		@TabOrder,
		N'CustomDocumentMHColumbiaAdultSinceLastVisits',
		N'InterruptedAttempt',
		'FROM CustomDocumentMHColumbiaAdultSinceLastVisits CDCCSLV inner join CustomDocumentMHAssessments CHA ON CDCCSLV.DocumentVersionId = CHA.DocumentVersionId WHERE CDCCSLV.DocumentVersionId=@DocumentVersionId
  AND ISNULL(CDCCSLV.WishToBeDead,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''No'' and Category = ''XCSSRSYESNO'') 
  AND ISNULL(CDCCSLV.NonSpecificActiveSuicidalThoughts,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''No'' and Category = ''XCSSRSYESNO'') 
  AND ISNULL(CDCCSLV.InterruptedAttempt,'''') = ''''  AND ISNULL(CDCCSLV.RecordDeleted,''N'') = ''N'' ',
		N'Interrupted Attempt is required',
		19,
		N'Interrupted Attempt is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
			AND ErrorMessage = 'Total Number Of Attempts Interrupted is required'
			AND TableName = 'CustomDocumentMHColumbiaAdultSinceLastVisits'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active],
		[DocumentCodeId],
		[DocumentType],
		[TabName],
		[TabOrder],
		[TableName],
		[ColumnName],
		[ValidationLogic],
		[ValidationDescription],
		[ValidationOrder],
		[ErrorMessage]
		)
	VALUES (
		N'Y',
		@DocumentCodeId,
		NULL,
		@TabName,
		@TabOrder,
		N'CustomDocumentMHColumbiaAdultSinceLastVisits',
		N'TotalNumberOfAttemptsInterrupted',
		'FROM CustomDocumentMHColumbiaAdultSinceLastVisits CDCCSLV inner join CustomDocumentMHAssessments CHA ON CDCCSLV.DocumentVersionId = CHA.DocumentVersionId WHERE CDCCSLV.DocumentVersionId=@DocumentVersionId
  AND ISNULL(CDCCSLV.WishToBeDead,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''No'' and Category = ''XCSSRSYESNO'') 
  AND ISNULL(CDCCSLV.NonSpecificActiveSuicidalThoughts,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''No'' and Category = ''XCSSRSYESNO'') 
  AND ISNULL(CDCCSLV.InterruptedAttempt,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''Yes'' and Category = ''XCSSRSYESNO'') 
  AND ISNULL(CDCCSLV.TotalNumberOfAttemptsInterrupted,'''') = ''''  AND ISNULL(CDCCSLV.RecordDeleted,''N'') = ''N'' ',
		N'Total Number Of Attempts Interrupted is required',
		20,
		N'Total Number Of Attempts Interrupted is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
			AND ErrorMessage = 'Interrupted Attempt Description is required'
			AND TableName = 'CustomDocumentMHColumbiaAdultSinceLastVisits'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active],
		[DocumentCodeId],
		[DocumentType],
		[TabName],
		[TabOrder],
		[TableName],
		[ColumnName],
		[ValidationLogic],
		[ValidationDescription],
		[ValidationOrder],
		[ErrorMessage]
		)
	VALUES (
		N'Y',
		@DocumentCodeId,
		NULL,
		@TabName,
		@TabOrder,
		N'CustomDocumentMHColumbiaAdultSinceLastVisits',
		N'InterruptedAttemptDescription',
		'FROM CustomDocumentMHColumbiaAdultSinceLastVisits CDCCSLV inner join CustomDocumentMHAssessments CHA ON CDCCSLV.DocumentVersionId = CHA.DocumentVersionId WHERE CDCCSLV.DocumentVersionId=@DocumentVersionId
  AND ISNULL(CDCCSLV.WishToBeDead,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''No'' and Category = ''XCSSRSYESNO'')
   AND ISNULL(CDCCSLV.NonSpecificActiveSuicidalThoughts,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''No'' and Category = ''XCSSRSYESNO'') 
   AND ISNULL(CDCCSLV.InterruptedAttempt,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''Yes'' and Category = ''XCSSRSYESNO'') 
   AND ISNULL(CDCCSLV.InterruptedAttemptDescription,'''') = ''''  
   AND ISNULL(CDCCSLV.RecordDeleted,''N'') = ''N'' ',
		N'Interrupted Attempt Description is required',
		21,
		N'Interrupted Attempt Description is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
			AND ErrorMessage = 'Aborted Or Self Interrupted Attempt is required'
			AND TableName = 'CustomDocumentMHColumbiaAdultSinceLastVisits'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active],
		[DocumentCodeId],
		[DocumentType],
		[TabName],
		[TabOrder],
		[TableName],
		[ColumnName],
		[ValidationLogic],
		[ValidationDescription],
		[ValidationOrder],
		[ErrorMessage]
		)
	VALUES (
		N'Y',
		@DocumentCodeId,
		NULL,
		@TabName,
		@TabOrder,
		N'CustomDocumentMHColumbiaAdultSinceLastVisits',
		N'AbortedOrSelfInterruptedAttempt',
		'FROM CustomDocumentMHColumbiaAdultSinceLastVisits CDCCSLV inner join CustomDocumentMHAssessments CHA ON CDCCSLV.DocumentVersionId = CHA.DocumentVersionId WHERE CDCCSLV.DocumentVersionId=@DocumentVersionId
   AND ISNULL(CDCCSLV.WishToBeDead,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''No'' and Category = ''XCSSRSYESNO'') 
   AND ISNULL(CDCCSLV.NonSpecificActiveSuicidalThoughts,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''No'' and Category = ''XCSSRSYESNO'') 
   AND ISNULL(CDCCSLV.AbortedOrSelfInterruptedAttempt,'''') = ''''  AND ISNULL(CDCCSLV.RecordDeleted,''N'') = ''N'' ',
		N'Aborted Or Self Interrupted Attempt is required',
		22,
		N'Aborted Or Self Interrupted Attempt is required'
		)
END


IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
			AND ErrorMessage = 'Total Number Attempts Aborted Or SelfInterrupted is required'
			AND TableName = 'CustomDocumentMHColumbiaAdultSinceLastVisits'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active],
		[DocumentCodeId],
		[DocumentType],
		[TabName],
		[TabOrder],
		[TableName],
		[ColumnName],
		[ValidationLogic],
		[ValidationDescription],
		[ValidationOrder],
		[ErrorMessage]
		)
	VALUES (
		N'Y',
		@DocumentCodeId,
		NULL,
		@TabName,
		@TabOrder,
		N'CustomDocumentMHColumbiaAdultSinceLastVisits',
		N'TotalNumberAttemptsAbortedOrSelfInterrupted',
		'FROM CustomDocumentMHColumbiaAdultSinceLastVisits CDCCSLV inner join CustomDocumentMHAssessments CHA ON CDCCSLV.DocumentVersionId = CHA.DocumentVersionId WHERE CDCCSLV.DocumentVersionId=@DocumentVersionId
   AND ISNULL(CDCCSLV.WishToBeDead,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''No'' and Category = ''XCSSRSYESNO'') 
   AND ISNULL(CDCCSLV.NonSpecificActiveSuicidalThoughts,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''No'' and Category = ''XCSSRSYESNO'') 
   AND ISNULL(CDCCSLV.AbortedOrSelfInterruptedAttempt,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''Yes'' and Category = ''XCSSRSYESNO'') 
   AND ISNULL(CDCCSLV.TotalNumberAttemptsAbortedOrSelfInterrupted,'''') = ''''  
   AND ISNULL(CDCCSLV.RecordDeleted,''N'') = ''N'' ',
		N'Total Number Attempts Aborted Or SelfInterrupted is required',
		23,
		N'Total Number Attempts Aborted Or SelfInterrupted is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
			AND ErrorMessage = 'Aborted Or Self Interrupted Attempt Description is required'
			AND TableName = 'CustomDocumentMHColumbiaAdultSinceLastVisits'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active],
		[DocumentCodeId],
		[DocumentType],
		[TabName],
		[TabOrder],
		[TableName],
		[ColumnName],
		[ValidationLogic],
		[ValidationDescription],
		[ValidationOrder],
		[ErrorMessage]
		)
	VALUES (
		N'Y',
		@DocumentCodeId,
		NULL,
		@TabName,
		@TabOrder,
		N'CustomDocumentMHColumbiaAdultSinceLastVisits',
		N'AbortedOrSelfInterruptedAttemptDescription',
		'FROM CustomDocumentMHColumbiaAdultSinceLastVisits CDCCSLV inner join CustomDocumentMHAssessments CHA ON CDCCSLV.DocumentVersionId = CHA.DocumentVersionId WHERE CDCCSLV.DocumentVersionId=@DocumentVersionId
    AND ISNULL(CDCCSLV.WishToBeDead,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''No'' and Category = ''XCSSRSYESNO'') 
    AND ISNULL(CDCCSLV.NonSpecificActiveSuicidalThoughts,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''No'' and Category = ''XCSSRSYESNO'') 
    AND ISNULL(CDCCSLV.AbortedOrSelfInterruptedAttempt,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''Yes'' and Category = ''XCSSRSYESNO'') 
    AND ISNULL(CDCCSLV.AbortedOrSelfInterruptedAttemptDescription,'''') = '''' 
     AND ISNULL(CDCCSLV.RecordDeleted,''N'') = ''N'' ',
		N'Aborted Or Self Interrupted Attempt Description is required',
		24,
		N'Aborted Or Self Interrupted Attempt Description is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
			AND ErrorMessage = 'Preparatory Acts Or Behavior is required'
			AND TableName = 'CustomDocumentMHColumbiaAdultSinceLastVisits'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active],
		[DocumentCodeId],
		[DocumentType],
		[TabName],
		[TabOrder],
		[TableName],
		[ColumnName],
		[ValidationLogic],
		[ValidationDescription],
		[ValidationOrder],
		[ErrorMessage]
		)
	VALUES (
		N'Y',
		@DocumentCodeId,
		NULL,
		@TabName,
		@TabOrder,
		N'CustomDocumentMHColumbiaAdultSinceLastVisits',
		N'PreparatoryActsOrBehavior',
		'FROM CustomDocumentMHColumbiaAdultSinceLastVisits CDCCSLV inner join CustomDocumentMHAssessments CHA ON CDCCSLV.DocumentVersionId = CHA.DocumentVersionId WHERE CDCCSLV.DocumentVersionId=@DocumentVersionId
AND ISNULL(CDCCSLV.WishToBeDead,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''No'' and Category = ''XCSSRSYESNO'') 
AND ISNULL(CDCCSLV.NonSpecificActiveSuicidalThoughts,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''No'' and Category = ''XCSSRSYESNO'') 
AND ISNULL(CDCCSLV.PreparatoryActsOrBehavior,'''') = ''''  
AND ISNULL(CDCCSLV.RecordDeleted,''N'') = ''N'' ',
		N'Preparatory Acts Or Behavior is required',
		25,
		N'Preparatory Acts Or Behavior is required'
		)
END


IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
			AND ErrorMessage = 'Total Number Of Preparatory Acts is required'
			AND TableName = 'CustomDocumentMHColumbiaAdultSinceLastVisits'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active],
		[DocumentCodeId],
		[DocumentType],
		[TabName],
		[TabOrder],
		[TableName],
		[ColumnName],
		[ValidationLogic],
		[ValidationDescription],
		[ValidationOrder],
		[ErrorMessage]
		)
	VALUES (
		N'Y',
		@DocumentCodeId,
		NULL,
		@TabName,
		@TabOrder,
		N'CustomDocumentMHColumbiaAdultSinceLastVisits',
		N'TotalNumberOfPreparatoryActs',
		'FROM CustomDocumentMHColumbiaAdultSinceLastVisits CDCCSLV inner join CustomDocumentMHAssessments CHA ON CDCCSLV.DocumentVersionId = CHA.DocumentVersionId WHERE CDCCSLV.DocumentVersionId=@DocumentVersionId
AND ISNULL(CDCCSLV.WishToBeDead,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''No'' and Category = ''XCSSRSYESNO'')
AND ISNULL(CDCCSLV.NonSpecificActiveSuicidalThoughts,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''No'' and Category = ''XCSSRSYESNO'')
AND ISNULL(CDCCSLV.PreparatoryActsOrBehavior,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''Yes'' and Category = ''XCSSRSYESNO'') 
AND ISNULL(CDCCSLV.TotalNumberOfPreparatoryActs,'''') = ''''  AND ISNULL(CDCCSLV.RecordDeleted,''N'') = ''N'' ',
		N'Total Number Of Preparatory Acts is required',
		26,
		N'Total Number Of Preparatory Acts is required'
		)
END


IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
			AND ErrorMessage = 'Preparatory Acts Or Behavior Description is required'
			AND TableName = 'CustomDocumentMHColumbiaAdultSinceLastVisits'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active],
		[DocumentCodeId],
		[DocumentType],
		[TabName],
		[TabOrder],
		[TableName],
		[ColumnName],
		[ValidationLogic],
		[ValidationDescription],
		[ValidationOrder],
		[ErrorMessage]
		)
	VALUES (
		N'Y',
		@DocumentCodeId,
		NULL,
		@TabName,
		@TabOrder,
		N'CustomDocumentMHColumbiaAdultSinceLastVisits',
		N'PreparatoryActsOrBehaviorDescription',
		'FROM CustomDocumentMHColumbiaAdultSinceLastVisits CDCCSLV inner join CustomDocumentMHAssessments CHA ON CDCCSLV.DocumentVersionId = CHA.DocumentVersionId WHERE CDCCSLV.DocumentVersionId=@DocumentVersionId
AND ISNULL(CDCCSLV.WishToBeDead,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''No'' and Category = ''XCSSRSYESNO'') 
AND ISNULL(CDCCSLV.NonSpecificActiveSuicidalThoughts,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''No'' and Category = ''XCSSRSYESNO'') 
AND ISNULL(CDCCSLV.PreparatoryActsOrBehavior,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''Yes'' and Category = ''XCSSRSYESNO'') 
AND ISNULL(CDCCSLV.PreparatoryActsOrBehaviorDescription,'''') = ''''  AND ISNULL(CDCCSLV.RecordDeleted,''N'') = ''N'' ',
		N'Preparatory Acts Or Behavior Description is required',
		27,
		N'Preparatory Acts Or Behavior Description is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
			AND ErrorMessage = 'Suicidal Behavior is required'
			AND TableName = 'CustomDocumentMHColumbiaAdultSinceLastVisits'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active],
		[DocumentCodeId],
		[DocumentType],
		[TabName],
		[TabOrder],
		[TableName],
		[ColumnName],
		[ValidationLogic],
		[ValidationDescription],
		[ValidationOrder],
		[ErrorMessage]
		)
	VALUES (
		N'Y',
		@DocumentCodeId,
		NULL,
		@TabName,
		@TabOrder,
		N'CustomDocumentMHColumbiaAdultSinceLastVisits',
		N'SuicidalBehavior',
		'FROM CustomDocumentMHColumbiaAdultSinceLastVisits CDCCSLV inner join CustomDocumentMHAssessments CHA ON CDCCSLV.DocumentVersionId = CHA.DocumentVersionId WHERE CDCCSLV.DocumentVersionId=@DocumentVersionId
AND ISNULL(CDCCSLV.WishToBeDead,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''No'' and Category = ''XCSSRSYESNO'') 
AND ISNULL(CDCCSLV.NonSpecificActiveSuicidalThoughts,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''No'' and Category = ''XCSSRSYESNO'') 
AND ISNULL(CDCCSLV.SuicidalBehavior,'''') = ''''  AND ISNULL(CDCCSLV.RecordDeleted,''N'') = ''N'' ',
		N'Suicidal Behavior is required',
		28,
		N'Suicidal Behavior is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
			AND ErrorMessage = 'Actual Lethality Medical Damage is required'
			AND TableName = 'CustomDocumentMHColumbiaAdultSinceLastVisits'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active],
		[DocumentCodeId],
		[DocumentType],
		[TabName],
		[TabOrder],
		[TableName],
		[ColumnName],
		[ValidationLogic],
		[ValidationDescription],
		[ValidationOrder],
		[ErrorMessage]
		)
	VALUES (
		N'Y',
		@DocumentCodeId,
		NULL,
		@TabName,
		@TabOrder,
		N'CustomDocumentMHColumbiaAdultSinceLastVisits',
		N'ActualLethalityMedicalDamage',
		'FROM CustomDocumentMHColumbiaAdultSinceLastVisits CDCCSLV inner join CustomDocumentMHAssessments CHA ON CDCCSLV.DocumentVersionId = CHA.DocumentVersionId WHERE CDCCSLV.DocumentVersionId=@DocumentVersionId
 AND ISNULL(CDCCSLV.WishToBeDead,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''No'' and Category = ''XCSSRSYESNO'') 
 AND ISNULL(CDCCSLV.NonSpecificActiveSuicidalThoughts,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''No'' and Category = ''XCSSRSYESNO'') 
 AND ISNULL(CDCCSLV.ActualLethalityMedicalDamage,'''') = ''''  AND ISNULL(CDCCSLV.RecordDeleted,''N'') = ''N'' ',
		N'Actual Lethality Medical Damage is required',
		29,
		N'Actual Lethality Medical Damage is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
			AND ErrorMessage = 'Potential Lethality: Only Answer if Actual Lethality is required'
			AND TableName = 'CustomDocumentMHColumbiaAdultSinceLastVisits'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active],
		[DocumentCodeId],
		[DocumentType],
		[TabName],
		[TabOrder],
		[TableName],
		[ColumnName],
		[ValidationLogic],
		[ValidationDescription],
		[ValidationOrder],
		[ErrorMessage]
		)
	VALUES (
		N'Y',
		@DocumentCodeId,
		NULL,
		@TabName,
		@TabOrder,
		N'CustomDocumentMHColumbiaAdultSinceLastVisits',
		N'PotentialLethality',
		'FROM CustomDocumentMHColumbiaAdultSinceLastVisits CDCCSLV inner join CustomDocumentMHAssessments CHA ON CDCCSLV.DocumentVersionId = CHA.DocumentVersionId WHERE CDCCSLV.DocumentVersionId=@DocumentVersionId
 AND ISNULL(CDCCSLV.WishToBeDead,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''No'' and Category = ''XCSSRSYESNO'') 
 AND ISNULL(CDCCSLV.NonSpecificActiveSuicidalThoughts,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''No'' and Category = ''XCSSRSYESNO'') 
 AND ISNULL(CDCCSLV.ActualLethalityMedicalDamage,'''') = (select GlobalCodeId from GlobalCodes where CodeName = ''0 - No physical damage or very minor'' and Category = ''XActualLethality'') 
 AND ISNULL(CDCCSLV.PotentialLethality,'''') = ''''  AND ISNULL(CDCCSLV.RecordDeleted,''N'') = ''N'' ',
		N'Potential Lethality: Only Answer if Actual Lethality is required',
		30,
		N'Potential Lethality: Only Answer if Actual Lethality is required'
		)
END
