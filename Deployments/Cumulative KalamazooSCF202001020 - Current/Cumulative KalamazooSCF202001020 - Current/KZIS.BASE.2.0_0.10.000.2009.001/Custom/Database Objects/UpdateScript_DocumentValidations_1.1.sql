-- Update Script to Order the validations
--Date: 05/26/2020

DECLARE @DocumentCodeId INT
	SELECT TOP 1 @DocumentCodeId = DocumentCodeId
		FROM DocumentCodes
		WHERE Code ='69E559DD-1A4D-46D3-B91C-E89DA48E0038'
			AND ISNULL(RecordDeleted, 'N') = 'N'
IF EXISTS(SELECT 1 FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'PsychosisOrDisturbanceOfPerception'
		 and ErrorMessage = 'Abnormal/Psychotic Thoughts- Psychosis/Disturbance of Perception is required' )
BEGIN
UPDATE DocumentValidations SET ValidationOrder=18 WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'PsychosisOrDisturbanceOfPerception'
		 and ErrorMessage = 'Abnormal/Psychotic Thoughts- Psychosis/Disturbance of Perception is required'
END

IF EXISTS(SELECT 1 FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'PsychosisOrDisturbanceOfPerception'
		 and ErrorMessage = 'Abnormal/Psychotic Thoughts- When present is selected, at least one check box  is required' )
BEGIN
UPDATE DocumentValidations SET ValidationOrder=19 WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'PsychosisOrDisturbanceOfPerception'
		 and ErrorMessage = 'Abnormal/Psychotic Thoughts- When present is selected, at least one check box  is required'
END

IF EXISTS(SELECT 1 FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'PDCurrentSuicideIdeation'
		ANd ErrorMessage='Abnormal/Psychotic Thoughts- Current suicide ideation is required')
BEGIN
UPDATE DocumentValidations SET ValidationOrder=20 WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'PDCurrentSuicideIdeation'
		ANd ErrorMessage='Abnormal/Psychotic Thoughts- Current suicide ideation is required'
END

IF EXISTS(SELECT 1 FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'PDCurrentSuicidalPlan'
		ANd ErrorMessage='Abnormal/Psychotic Thoughts- Current suicidal plan is required')
BEGIN
UPDATE DocumentValidations SET ValidationOrder=21 WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'PDCurrentSuicidalPlan'
		ANd ErrorMessage='Abnormal/Psychotic Thoughts- Current suicidal plan is required'
END

IF EXISTS(SELECT 1 FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'PDCurrentSuicidalIntent'
		ANd ErrorMessage='Abnormal/Psychotic Thoughts- Current suicidal intent is required')
BEGIN
UPDATE DocumentValidations SET ValidationOrder=22 WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'PDCurrentSuicidalIntent'
		ANd ErrorMessage='Abnormal/Psychotic Thoughts- Current suicidal intent is required'
END

IF EXISTS(SELECT 1 FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'PDMeanstocarry'
		ANd ErrorMessage='Abnormal/Psychotic Thoughts- Means to carry out attempt is required')
BEGIN
UPDATE DocumentValidations SET ValidationOrder=23 WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'PDMeanstocarry'
		ANd ErrorMessage='Abnormal/Psychotic Thoughts- Means to carry out attempt is required'
END

IF EXISTS(SELECT 1 FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'PDCurrentHomicidalIdeation'
		ANd ErrorMessage='Abnormal/Psychotic Thoughts- Current homicidal ideation is required')
BEGIN
UPDATE DocumentValidations SET ValidationOrder=24 WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'PDCurrentHomicidalIdeation'
		ANd ErrorMessage='Abnormal/Psychotic Thoughts- Current homicidal ideation is required'
END

IF EXISTS(SELECT 1 FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'PDCurrentHomicidalPlans'
		ANd ErrorMessage='Abnormal/Psychotic Thoughts- Current homicidal plans is required')
BEGIN
UPDATE DocumentValidations SET ValidationOrder=25 WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'PDCurrentHomicidalPlans'
		ANd ErrorMessage='Abnormal/Psychotic Thoughts- Current homicidal plans is required'
END

IF EXISTS(SELECT 1 FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'PDCurrentHomicidalIntent'
		ANd ErrorMessage='Abnormal/Psychotic Thoughts- Current homicidal intent is required')
BEGIN
UPDATE DocumentValidations SET ValidationOrder=26 WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'PDCurrentHomicidalIntent'
		ANd ErrorMessage='Abnormal/Psychotic Thoughts- Current homicidal intent is required'
END

IF EXISTS(SELECT 1 FROM DocumentValidations
		WHERE  DocumentCodeId = @DocumentCodeId AND  Active = 'Y' AND ColumnName = 'PDMeansToCarryNew'
		ANd ErrorMessage='Abnormal/Psychotic Thoughts- Means to carry out attempt is required')
BEGIN
UPDATE DocumentValidations SET ValidationOrder=27 WHERE  DocumentCodeId = @DocumentCodeId AND  Active = 'Y' AND ColumnName = 'PDMeansToCarryNew'
		ANd ErrorMessage='Abnormal/Psychotic Thoughts- Means to carry out attempt is required'
END

IF EXISTS(SELECT 1 FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'Orientation')
BEGIN
UPDATE DocumentValidations SET ValidationOrder=28 WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'Orientation'
END

IF EXISTS(SELECT 1 FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'OrientationPerson'
		AND ErrorMessage='Orientation- at least one check box is required')
BEGIN
UPDATE DocumentValidations SET ValidationOrder=29 WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'OrientationPerson'
		AND ErrorMessage='Orientation- at least one check box is required'
END

IF EXISTS(SELECT 1 FROM DocumentValidations
	WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'OrientationDescribeSituations'
		AND ErrorMessage='Orientation- How would you describe the situation we are in? is required')
BEGIN
UPDATE DocumentValidations SET ValidationOrder=30 WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'OrientationDescribeSituations'
		AND ErrorMessage='Orientation- How would you describe the situation we are in? is required'
END

IF EXISTS(SELECT 1 FROM DocumentValidations
	WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'OrientationFullName'
		AND ErrorMessage='Orientation- What is your full name? is required')
BEGIN
UPDATE DocumentValidations SET ValidationOrder=31 WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'OrientationFullName'
		AND ErrorMessage='Orientation- What is your full name? is required'
END

IF EXISTS(SELECT 1 FROM DocumentValidations
	WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'OrientationEvidencedPlace'
		AND ErrorMessage='Orientation- Where are we right now? is required')
BEGIN
UPDATE DocumentValidations SET ValidationOrder=32 WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'OrientationEvidencedPlace'
		AND ErrorMessage='Orientation- Where are we right now? is required'
END

IF EXISTS(SELECT 1 FROM DocumentValidations
	WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'OrientationFullDate'
		AND ErrorMessage='Orientation- What is the full date today? is required')
BEGIN
UPDATE DocumentValidations SET ValidationOrder=33 WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'OrientationFullDate'
		AND ErrorMessage='Orientation- What is the full date today? is required'
END

IF EXISTS(SELECT 1 FROM DocumentValidations
	WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'OrientationFullDate'
		AND ErrorMessage='Orientation- What is the full date today? is required')
BEGIN
UPDATE DocumentValidations SET ValidationOrder=34 WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'OrientationFullDate'
		AND ErrorMessage='Orientation- What is the full date today? is required'
END

IF EXISTS(SELECT 1 FROM DocumentValidations
	WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'FundOfKnowledge')
BEGIN
UPDATE DocumentValidations SET ValidationOrder=35 WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'FundOfKnowledge'
END

IF EXISTS(SELECT 1 FROM DocumentValidations
	WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'FundOfKnowledgeCurrentEvents'
		and ErrorMessage = 'Fund of Knowledge- at least one check box is required')
BEGIN
UPDATE DocumentValidations SET ValidationOrder=36 WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'FundOfKnowledgeCurrentEvents'
		and ErrorMessage = 'Fund of Knowledge- at least one check box is required'
END

IF EXISTS(SELECT 1 FROM DocumentValidations
	WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'FundEvidenceVocabulary'
		and ErrorMessage = 'Fund of Knowledge- As evidenced by age appropriate- at least one check box is required')
BEGIN
UPDATE DocumentValidations SET ValidationOrder=37 WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'FundEvidenceVocabulary'
		and ErrorMessage = 'Fund of Knowledge- As evidenced by age appropriate- at least one check box is required'
END

IF EXISTS(SELECT 1 FROM DocumentValidations
	WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'InsightAndJudgement')
BEGIN
UPDATE DocumentValidations SET ValidationOrder=38 WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'InsightAndJudgement'
END

IF EXISTS(SELECT 1 FROM DocumentValidations
	WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'InsightAndJudgementStatus'
		 and ErrorMessage = 'Insight and Judgement- When Assessed is selected, below radio button selection is required')
BEGIN
UPDATE DocumentValidations SET ValidationOrder=39 WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'InsightAndJudgementStatus'
		 and ErrorMessage = 'Insight and Judgement- When Assessed is selected, below radio button selection is required'
END

IF EXISTS(SELECT 1 FROM DocumentValidations
	 WHERE  DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'InsightEvidenceAwareness')
BEGIN
UPDATE DocumentValidations SET ValidationOrder=40 WHERE  DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'InsightEvidenceAwareness'
END

IF EXISTS(SELECT 1 FROM DocumentValidations
	WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'Memory')
BEGIN
UPDATE DocumentValidations SET ValidationOrder=41 WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'Memory'
END

IF EXISTS(SELECT 1 FROM DocumentValidations
	WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'MemoryImmediate')
BEGIN
UPDATE DocumentValidations SET ValidationOrder=41 WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'MemoryImmediate'
END

IF EXISTS(SELECT 1 FROM DocumentValidations
	WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'MemoryImmediateEvidencedBy')
BEGIN
UPDATE DocumentValidations SET ValidationOrder=42 WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'MemoryImmediateEvidencedBy'
END

IF EXISTS(SELECT 1 FROM DocumentValidations
	WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'MemoryRecent')
BEGIN
UPDATE DocumentValidations SET ValidationOrder=43 WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'MemoryRecent'
END

IF EXISTS(SELECT 1 FROM DocumentValidations
	WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'MemoryRecentEvidencedBy')
BEGIN
UPDATE DocumentValidations SET ValidationOrder=44 WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'MemoryRecentEvidencedBy'
END

IF EXISTS(SELECT 1 FROM DocumentValidations
	WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'MemoryRemote')
BEGIN
UPDATE DocumentValidations SET ValidationOrder=45 WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'MemoryRemote'
END

IF EXISTS(SELECT 1 FROM DocumentValidations
	WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'MemoryRemoteEvidencedBy')
BEGIN
UPDATE DocumentValidations SET ValidationOrder=46 WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'MemoryRemoteEvidencedBy'
END

IF EXISTS(SELECT 1 FROM DocumentValidations
	WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'MuscleStrengthorTone')
BEGIN
UPDATE DocumentValidations SET ValidationOrder=47 WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'MuscleStrengthorTone'
END

IF EXISTS(SELECT 1 FROM DocumentValidations
	WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'MuscleStrengthorToneAtrophy')
BEGIN
UPDATE DocumentValidations SET ValidationOrder=48 WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'MuscleStrengthorToneAtrophy'
END

IF EXISTS(SELECT 1 FROM DocumentValidations
	WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'GaitandStation')
BEGIN
UPDATE DocumentValidations SET ValidationOrder=49 WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'GaitandStation'
END

IF EXISTS(SELECT 1 FROM DocumentValidations
	WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'GaitandStationRestlessness')
BEGIN
UPDATE DocumentValidations SET ValidationOrder=50 WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'GaitandStationRestlessness'
END

IF EXISTS(SELECT 1 FROM DocumentValidations
	WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'ReviewWithChanges')
BEGIN
UPDATE DocumentValidations SET ValidationOrder=51 WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ColumnName = 'ReviewWithChanges'
END

IF EXISTS(SELECT * FROM DocumentValidations
	WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ErrorMessage='Abnormal/Psychotic Thoughts- C Means to carry out attempt is required')
BEGIN
UPDATE DocumentValidations SET Active='N' WHERE DocumentCodeId = @DocumentCodeId AND Active = 'Y' AND ErrorMessage='Abnormal/Psychotic Thoughts- C Means to carry out attempt is required'
END

