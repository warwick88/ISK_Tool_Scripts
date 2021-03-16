/*Date			Author			Prupose*/
/*05/26/2020	Packia			InsertScripts for  validations - Mental Status tab. KCMHSAS Improvements #7	*/

DECLARE @DocumentCodeId INT
	SELECT TOP 1 @DocumentCodeId = DocumentCodeId
		FROM DocumentCodes
		WHERE Code = '69E559DD-1A4D-46D3-B91C-E89DA48E0038'
			AND ISNULL(RecordDeleted, 'N') = 'N'
			

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'GeneralAppearance'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','GeneralAppearance'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(GeneralAppearance,'''')='''' '
		,NULL,1,'General Appearance is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'GeneralPoorlyAddresses' 
		AND ErrorMessage = 'General Appearance – at least one check box is required'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','GeneralPoorlyAddresses'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND GeneralAppearance=''A'' AND
ISNULL(GeneralPoorlyAddresses,''N'')=''N'' And
ISNULL(GeneralPoorlyGroomed,''N'')=''N'' And
ISNULL(GeneralDisheveled,''N'')=''N'' And
ISNULL(GeneralOdferous,''N'')=''N'' And
ISNULL(GeneralDeformities,''N'')=''N'' And
ISNULL(GeneralPoorNutrion,''N'')=''N'' And
ISNULL(GeneralPsychometer,''N'')=''N'' And
ISNULL(GeneralHyperActive,''N'')=''N'' And
ISNULL(GeneralEvasive,''N'')=''N'' And
ISNULL(GeneralInAttentive,''N'')=''N'' And
ISNULL(GeneralPoorEyeContact,''N'')=''N'' And
ISNULL(GeneralHostile,''N'')=''N'' And
ISNULL(GeneralRestless,''N'')=''N'' and ISNULL(GeneralAppearanceOthers,''N'')=''N'' ',NULL,2,'General Appearance- at least one check box is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'Speech'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','Speech'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Speech,'''')='''' '
		,NULL,3,'Speech is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'SpeechIncreased'
		 and ErrorMessage = 'Speech- at least one check box is required'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','SpeechIncreased'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND Speech=''A''  AND 
ISNULL(SpeechIncreased,''N'')=''N'' And
ISNULL(SpeechDecreased,''N'')=''N'' And
ISNULL(SpeechPaucity,''N'')=''N'' And
ISNULL(SpeechHyperverbal,''N'')=''N'' And
ISNULL(SpeechPoorArticulations,''N'')=''N'' And
ISNULL(SpeechLoud,''N'')=''N'' And
ISNULL(SpeechSoft,''N'')=''N'' And
ISNULL(SpeechMute,''N'')=''N'' And
ISNULL(SpeechStuttering,''N'')=''N'' And
ISNULL(SpeechImpaired,''N'')=''N'' And
ISNULL(SpeechPressured,''N'')=''N'' And
ISNULL(SpeechFlight,''N'')=''N'' and ISNULL(SpeechOthers,''N'')=''N'' ',NULL,4,'Speech- at least one check box is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'PsychiatricNoteExamLanguage'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','PsychiatricNoteExamLanguage'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(PsychiatricNoteExamLanguage,'''')='''' '
		,NULL,5,'Language is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'LanguageDifficultyNaming'
		and ErrorMessage = 'Language- at least one check box is required'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','LanguageDifficultyNaming'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND PsychiatricNoteExamLanguage=''A'' AND
		ISNULL(LanguageDifficultyNaming,''N'')=''N'' And ISNULL(LanguageDifficultyRepeating,''N'')=''N'' And ISNULL(LanguageNonVerbal,''N'')=''N''
		and ISNULL(LanguageOthers,''N'')=''N'' '
		,NULL,6,'Language- at least one check box is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'MoodAndAffect'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','MoodAndAffect'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(MoodAndAffect,'''')='''' '
		,NULL,7,'Mood and Affect is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'MoodHappy'
		and ErrorMessage = 'Mood- at least one check box is required'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','MoodHappy'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND MoodAndAffect=''A'' AND
ISNULL(MoodHappy,''N'')=''N'' And
ISNULL(MoodSad,''N'')=''N'' And
ISNULL(MoodAnxious,''N'')=''N'' And
ISNULL(MoodAngry,''N'')=''N'' And
ISNULL(MoodIrritable,''N'')=''N'' And
ISNULL(MoodElation,''N'')=''N'' And
ISNULL(MoodNormal,''N'')=''N'' and ISNULL(MoodOthers,''N'')=''N'' ',NULL,8,'Mood- at least one check box is required'
		)
END


IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'AffectEuthymic'
		and ErrorMessage = 'Affect- at least one check box is required'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','AffectEuthymic'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND MoodAndAffect=''A'' AND
ISNULL(AffectEuthymic,''N'')=''N'' And
ISNULL(AffectDysphoric,''N'')=''N'' And
ISNULL(AffectAnxious,''N'')=''N'' And
ISNULL(AffectIrritable,''N'')=''N'' And
ISNULL(AffectBlunted,''N'')=''N'' And
ISNULL(AffectLabile,''N'')=''N'' And
ISNULL(AffectEuphoric,''N'')=''N'' And
ISNULL(AffectCongruent,''N'')=''N'' and ISNULL(AffectOthers,''N'')=''N''  ',NULL,9,'Affect- at least one check box is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'AttensionSpanAndConcentration'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','AttensionSpanAndConcentration'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(AttensionSpanAndConcentration,'''')='''' '
		,NULL,10,'Attention Span and Concentration is required'
		)
END


IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'AttensionPoorConcentration'
		and ErrorMessage = 'Attension Span and Concentration- at least one check box is required'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','AttensionPoorConcentration'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND AttensionSpanAndConcentration=''A'' AND
ISNULL(AttensionPoorConcentration,''N'')=''N'' And ISNULL(AttensionDistractible,''N'')=''N'' And
ISNULL(AttensionPoorAttension,''N'')=''N'' and ISNULL(AttentionSpanOthers,''N'')=''N'' '
		,NULL,12,'Attension Span and Concentration- at least one check box is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'ThoughtContentCognision'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','ThoughtContentCognision'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(ThoughtContentCognision,'''')='''' '
		,NULL,13,'Thought Content and Process; Cognition is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'TPDisOrganised'
		AND  ErrorMessage = 'Thought Content and Process; Cognition- at least one check box is required'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','TPDisOrganised'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND ThoughtContentCognision=''A''  AND 
ISNULL(TPDisOrganised,''N'')=''N'' And
ISNULL(TPBlocking,''N'')=''N'' And
ISNULL(TPPersecution,''N'')=''N'' And
ISNULL(TPBroadCasting,''N'')=''N'' And
ISNULL(TPDetrailed,''N'')=''N'' And
ISNULL(TPThoughtinsertion,''N'')=''N'' And
ISNULL(TPIncoherent,''N'')=''N'' And
ISNULL(TPRacing,''N'')=''N'' And
ISNULL(TPIllogical,''N'')=''N'' And
ISNULL(TCDelusional,''N'')=''N'' And
ISNULL(TCParanoid,''N'')=''N'' And
ISNULL(TCIdeas,''N'')=''N'' And
ISNULL(TCThoughtInsertion,''N'')=''N'' And
ISNULL(TCThoughtWithdrawal,''N'')=''N'' And
ISNULL(TCThoughtBroadcasting,''N'')=''N'' And
ISNULL(TCReligiosity,''N'')=''N'' And
ISNULL(TCGrandiosity,''N'')=''N'' And
ISNULL(TCPerserveration,''N'')=''N'' And
ISNULL(TCObsessions,''N'')=''N'' And
ISNULL(TCWorthlessness,''N'')=''N'' And
ISNULL(TCGuilt,''N'')=''N'' And
ISNULL(TCHopelessness,''N'')=''N'' And
ISNULL(TCHelplessness,''N'')=''N'' And
ISNULL(CAConcrete,''N'')=''N'' And
ISNULL(CAUnable,''N'')=''N'' And
ISNULL(CAPoorComputation,''N'')=''N'' And
ISNULL(TCLoneliness,''N'')=''N'' and 
ISNULL(ThoughtProcessOthers,''N'')=''N'' and 
ISNULL(ThoughtContentOthers,''N'')=''N'' and 
ISNULL(CognitiveAbnormalitiesOthers,''N'')=''N'' ',NULL,14,'Thought Content and Process; Cognition- at least one check box is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'Associations'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','Associations'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Associations,'''')='''' '
		,NULL,15,'Associations is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'AssociationsLoose'
		and ErrorMessage = 'Associations- at least one check box is required'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','AssociationsLoose'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND Associations=''A''  AND 
ISNULL(AssociationsLoose,''N'')=''N'' And
ISNULL(AssociationsClanging,''N'')=''N'' And
ISNULL(AssociationsCircumstantial,''N'')=''N'' And
ISNULL(AssociationsTangential,''N'')=''N'' And
ISNULL(AssociationsWordsalad,''N'')=''N'' and ISNULL(AssociationsOthers,''N'')=''N'' ',NULL,16,'Associations- at least one check box is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'AbnormalorPsychoticThoughts'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','AbnormalorPsychoticThoughts'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(AbnormalorPsychoticThoughts,'''')='''' '
		,NULL,17,'Abnormal/Psychotic Thoughts is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'PsychosisOrDisturbanceOfPerception'
		 and ErrorMessage = 'Abnormal/Psychotic Thoughts- When present is selected, at least one check box  is required'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','PsychosisOrDisturbanceOfPerception'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND PsychosisOrDisturbanceOfPerception=''P'' AND
ISNULL(PDAuditoryHallucinations,''N'')=''N'' And
ISNULL(PDVisualHallucinations,''N'')=''N'' And
ISNULL(PDCommandHallucinations,''N'')=''N'' And
ISNULL(PDDelusions,''N'')=''N'' And
ISNULL(PDPreoccupation,''N'')=''N'' And
ISNULL(PDOlfactoryHallucinations,''N'')=''N'' And
ISNULL(PDGustatoryHallucinations,''N'')=''N'' And
ISNULL(PDTactileHallucinations,''N'')=''N'' And
ISNULL(PDSomaticHallucinations,''N'')=''N'' And
ISNULL(PDIllusions,''N'')=''N'' and ISNULL(AbnormalPsychoticOthers,''N'')=''N''  '
,NULL,18,'Abnormal/Psychotic Thoughts- When present is selected, at least one check box  is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'PDCurrentSuicideIdeation'
		ANd ErrorMessage='Abnormal/Psychotic Thoughts- Current suicide ideation is required'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','PDCurrentSuicideIdeation'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND 
		PDCurrentSuicideIdeation is null AND  AbnormalorPsychoticThoughts=''A'' '
		,NULL,19,'Abnormal/Psychotic Thoughts- Current suicide ideation is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'PDCurrentSuicidalPlan'
		ANd ErrorMessage='Abnormal/Psychotic Thoughts- Current suicidal plan is required'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','PDCurrentSuicidalPlan'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND 
		PDCurrentSuicidalPlan is null AND  AbnormalorPsychoticThoughts=''A'' '
		,NULL,20,'Abnormal/Psychotic Thoughts- Current suicidal plan is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'PDCurrentSuicidalIntent'
		ANd ErrorMessage='Abnormal/Psychotic Thoughts- Current suicidal intent is required'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','PDCurrentSuicidalIntent'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND 
		PDCurrentSuicidalIntent is null AND  AbnormalorPsychoticThoughts=''A'' '
		,NULL,21,'Abnormal/Psychotic Thoughts- Current suicidal intent is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'PDMeanstocarry'
		ANd ErrorMessage='Abnormal/Psychotic Thoughts- Means to carry out attempt is required'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','PDMeanstocarry'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND 
		PDMeanstocarry is null AND  AbnormalorPsychoticThoughts=''A'' '
		,NULL,22,'Abnormal/Psychotic Thoughts- Means to carry out attempt is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'PDCurrentHomicidalIdeation'
		ANd ErrorMessage='Abnormal/Psychotic Thoughts- Current homicidal ideation is required'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','PDCurrentHomicidalIdeation'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND 
		PDCurrentHomicidalIdeation is null AND  AbnormalorPsychoticThoughts=''A'' '
		,NULL,23,'Abnormal/Psychotic Thoughts- Current homicidal ideation is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'PDCurrentHomicidalPlans'
		ANd ErrorMessage='Abnormal/Psychotic Thoughts- Current homicidal plans is required'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','PDCurrentHomicidalPlans'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND 
		PDCurrentHomicidalPlans is null AND  AbnormalorPsychoticThoughts=''A'' '
		,NULL,24,'Abnormal/Psychotic Thoughts- Current homicidal plans is required'
		)
END


IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'PDCurrentHomicidalIntent'
		ANd ErrorMessage='Abnormal/Psychotic Thoughts- Current homicidal intent is required'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','PDCurrentHomicidalIntent'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND 
		PDCurrentHomicidalIntent is null AND  AbnormalorPsychoticThoughts=''A'' '
		,NULL,25,'Abnormal/Psychotic Thoughts- Current homicidal intent is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'PDMeansToCarryNew'
		ANd ErrorMessage='Abnormal/Psychotic Thoughts- Means to carry out attempt is required'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','PDMeansToCarryNew'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND 
		PDMeansToCarryNew is null AND  AbnormalorPsychoticThoughts=''A'' '
		,NULL,26,'Abnormal/Psychotic Thoughts- Means to carry out attempt is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'Orientation'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','Orientation'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Orientation,'''')='''' '
		,NULL,27,'Orientation is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'OrientationPerson'
		AND ErrorMessage='Orientation- at least one check box is required'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','OrientationPerson'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND Orientation=''A''  AND
ISNULL(OrientationPerson,''N'')=''N'' And
ISNULL(OrientationPlace,''N'')=''N'' And
ISNULL(OrientationTime,''N'')=''N'' And
ISNULL(OrientationSituation,''N'')=''N''  and ISNULL(OrientationOthers,''N'')=''N'' ' ,NULL,28,'Orientation- at least one check box is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'OrientationDescribeSituations'
		AND ErrorMessage='Orientation- How would you describe the situation we are in? is required'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','OrientationDescribeSituation'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND ( Orientation=''A'' OR Orientation=''W'')  AND
ISNULL(OrientationDescribeSituation,'''')='''' ' ,NULL,29,'Orientation- How would you describe the situation we are in? is required'
		)
END


IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'OrientationFullName'
		AND ErrorMessage='Orientation- What is your full name? is required'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','OrientationFullName'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND ( Orientation=''A'' OR Orientation=''W'')  AND
ISNULL(OrientationFullName,'''')='''' ' ,NULL,30,'Orientation- What is your full name? is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'OrientationEvidencedPlace'
		AND ErrorMessage='Orientation- Where are we right now? is required'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','OrientationEvidencedPlace'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND ( Orientation=''A'' OR Orientation=''W'')  AND
ISNULL(OrientationEvidencedPlace,'''')='''' ' ,NULL,31,'Orientation- Where are we right now? is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'OrientationFullDate'
		AND ErrorMessage='Orientation- What is the full date today? is required'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','OrientationFullDate'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND ( Orientation=''A'' OR Orientation=''W'')  AND
ISNULL(OrientationFullDate,'''')='''' ' ,NULL,32,'Orientation- What is the full date today? is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'FundOfKnowledge'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','FundOfKnowledge'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(FundOfKnowledge,'''')='''' '
		,NULL,33,'Fund of Knowledge is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'FundOfKnowledgeCurrentEvents'
		and ErrorMessage = 'Fund of Knowledge- at least one check box is required'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','FundOfKnowledgeCurrentEvents'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND FundOfKnowledge=''A''  AND 
ISNULL(FundOfKnowledgeCurrentEvents,''N'')=''N'' And
ISNULL(FundOfKnowledgePastHistory,''N'')=''N'' And
ISNULL(FundOfKnowledgeVocabulary,''N'')=''N''  and ISNULL(FundOfKnowledgeOthers,''N'')=''N'' '
		,NULL,34,'Fund of Knowledge- at least one check box is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'FundEvidenceVocabulary'
		and ErrorMessage = 'Fund of Knowledge- As evidenced by age appropriate- at least one check box is required'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','FundEvidenceVocabulary'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND FundOfKnowledge=''A''  AND 
ISNULL(FundEvidenceVocabulary,''N'')=''N'' And
ISNULL(FundEvidenceKnowledge,''N'')=''N'' And
ISNULL(FundEvidenceResponses,''N'')=''N'' And
ISNULL(FundEvidenceSchool,''N'')=''N'' And
ISNULL(FundEvidenceIQ,''N'')=''N'' And
ISNULL(FundEvidenceOthers,''N'')=''N'' ',NULL,35,'Fund of Knowledge- As evidenced by age appropriate- at least one check box is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'InsightAndJudgement'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','InsightAndJudgement'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(InsightAndJudgement,'''')='''' '
		,NULL,36,'Insight and Judgement- Assessed/Not Assessed is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'InsightAndJudgementStatus'
		 and ErrorMessage = 'Insight and Judgement- When Assessed is selected, below radio button selection is required'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','InsightAndJudgementStatus'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND InsightAndJudgement=''A''  AND 
		ISNULL(InsightAndJudgementStatus,'''')='''' '
		,NULL,37, 'Insight and Judgement- When Assessed is selected, below radio button selection is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'Memory'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','Memory'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Memory,'''')='''' '
		,NULL,38,'Memory is required'
		)
END


IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'MemoryImmediate'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','MemoryImmediate'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND Memory=''A''  AND 
ISNULL(MemoryImmediate,'''')='''' ',NULL,39,'Memory- Immediate radio button selection is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'MemoryImmediateEvidencedBy'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','MemoryImmediateEvidencedBy'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND (Memory=''A'' OR Memory=''W'')  AND  
ISNULL(MemoryImmediateEvidencedBy,-1)=-1 ',NULL,40,'Memory- Immediate As evidenced by is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'MemoryRecent'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','MemoryRecent'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND Memory=''A''   AND  
ISNULL(MemoryRecent,'''')='''' ',NULL,41,'Memory- Recent radio button selection is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'MemoryRecentEvidencedBy'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','MemoryRecentEvidencedBy'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND (Memory=''A'' OR Memory=''W'')  AND  
ISNULL(MemoryRecentEvidencedBy,'''')='''' ',NULL,42,'Memory- Recent As evidenced by is required'
		)
END


IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'MemoryRemote'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','MemoryRemote'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND Memory=''A''   AND  
ISNULL(MemoryRemote,'''')='''' ',NULL,43,'Memory- Remote radio button selection is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'MemoryRemoteEvidencedBy'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','MemoryRemoteEvidencedBy'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND (Memory=''A'' OR Memory=''W'')  AND  
ISNULL(MemoryRemoteEvidencedBy,'''')='''' ',NULL,44,'Memory- Remote As evidenced by is required'
		)
END



IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'MuscleStrengthorTone'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','MuscleStrengthorTone'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(MuscleStrengthorTone,'''')='''' '
		,NULL,45,'Muscle Strength/Tone is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'MuscleStrengthorToneAtrophy'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','MuscleStrengthorToneAtrophy'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND MuscleStrengthorTone=''A''  AND
ISNULL(MuscleStrengthorToneAtrophy,''N'')=''N'' And
ISNULL(MuscleStrengthorToneAbnormal,''N'')=''N'' and ISNULL(MuscleStrengthOthers,''N'')=''N'' '
		,NULL,46,'Muscle Strength/Tone- at least one check box is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'GaitandStation'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','GaitandStation'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(GaitandStation,'''')='''' '
		,NULL,47,'Gait and Station is required'
		)
END


IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'GaitandStationRestlessness'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','GaitandStationRestlessness'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND GaitandStation=''A''  AND 
ISNULL(GaitandStationRestlessness,''N'')=''N'' And
ISNULL(GaitandStationStaggered,''N'')=''N'' And
ISNULL(GaitandStationShuffling,''N'')=''N'' And
ISNULL(GaitandStationUnstable,''N'')=''N''  and ISNULL(GaitAndStationOthers,''N'')=''N'' '
		,NULL,48,'Gait and Station- at least one check box is required'
		)
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'ReviewWithChanges'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','ReviewWithChanges'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(ReviewWithChanges,'''')='''' '
		,NULL,49,'Review is required'
		)
END

IF NOT EXISTS (
		  SELECT 1 FROM DocumentValidations WHERE  DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'InsightEvidenceAwareness'
		 
		)
BEGIN
INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES ( 'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','InsightEvidenceAwareness'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND InsightAndJudgement=''A''
		AND ISNULL(InsightEvidenceAwareness,''N'')=''N'' 
		AND ISNULL(InsightEvidenceAcceptance,''N'')=''N''
		AND ISNULL(InsightEvidenceUnderstanding,''N'')=''N''
		AND ISNULL(InsightEvidenceSelfDefeating,''N'')=''N'' 
		AND ISNULL(InsightEvidenceDenial,''N'')=''N''
		AND ISNULL(InsightEvidenceOthers,''N'')=''N''  
		 '
		,NULL,50,'Mental Status – Insight and Judgement - As evidenced by age appropriate - at least one check box  is required')
END

IF NOT EXISTS (
		SELECT * FROM dbo.DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'PsychosisOrDisturbanceOfPerception'
		 and ErrorMessage = 'Abnormal/Psychotic Thoughts- Psychosis/Disturbance of Perception is required'
		)
BEGIN
	INSERT INTO [DocumentValidations] (
		[Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]
		)
	VALUES (
		'Y',@DocumentCodeId,NULL,'Mental Status',8,'CustomDocumentMentalStatusExams','PsychosisOrDisturbanceOfPerception'
		,'FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND AbnormalorPsychoticThoughts=''A'' AND
		ISNULL(PsychosisOrDisturbanceOfPerception,'''')=''''   '
,NULL,51,'Abnormal/Psychotic Thoughts- Psychosis/Disturbance of Perception is required'
		)
END



