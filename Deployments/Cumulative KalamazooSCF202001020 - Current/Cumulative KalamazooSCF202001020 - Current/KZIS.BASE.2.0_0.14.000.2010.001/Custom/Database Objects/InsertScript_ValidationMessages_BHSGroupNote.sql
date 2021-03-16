--Delete from DocumentValidations WHERE DocumentCodeId=@DocumentCodeId AND TableName='CustomDocumentBHSClientNotes'

Declare @DocumentCodeId int
Select @DocumentCodeId = DocumentCodeId From DocumentCodes Where Code = 'DC40159A-E64B-49BC-91F4-B2541CEDA58E'

Delete from DocumentValidations WHERE DocumentCodeId=@DocumentCodeId AND TableName='CustomDocumentBHSClientNotes'

--1
IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=@DocumentCodeId and ErrorMessage='Group Note-Shift note- Number of clients in session is required' and TableName = 'CustomDocumentBHSClientNotes')
BEGIN
INSERT [dbo].[DocumentValidations] ([Active], [DocumentCodeId], [DocumentType], [TabName], [TabOrder], [TableName], [ColumnName], [ValidationLogic], [ValidationDescription], [ValidationOrder], [ErrorMessage]) 
VALUES (N'Y', @DocumentCodeId, NULL, N'BHS Groups', 1, N'CustomDocumentBHSClientNotes', N'NumberOfClientsInSession', N'FROM CustomDocumentBHSClientNotes WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(NumberOfClientsInSession,'''') = ''''  AND ISNULL(RecordDeleted,''N'')=''N''', N'Group Note-Shift note- Number of clients in session is required', CAST(1 AS Decimal(18, 0)), N'Group Note-Shift note- Number of clients in session is required')
END
--2

IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=@DocumentCodeId and ErrorMessage='Group Note-Shift note- Describe providers intention is required' and TableName = 'CustomDocumentBHSClientNotes')
BEGIN
INSERT [dbo].[DocumentValidations] ([Active], [DocumentCodeId], [DocumentType], [TabName], [TabOrder], [TableName], [ColumnName], [ValidationLogic], [ValidationDescription], [ValidationOrder], [ErrorMessage]) 
VALUES (N'Y', @DocumentCodeId, NULL, N'BHS Groups', 1, N'CustomDocumentBHSClientNotes', N'GroupDescription', N'FROM CustomDocumentBHSClientNotes WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(GroupDescription,'''') = ''''  AND ISNULL(RecordDeleted,''N'')=''N''', N'Group Note-Shift note- Describe providers intention is required', CAST(2 AS Decimal(18, 0)), N'Group Note-Shift note- Describe providers intention is required')
END

--3
IF NOT EXISTS(SELECT * FROM DocumentValidations WHERE DocumentCodeId=@DocumentCodeId and ErrorMessage='Client Note-Client’s current condition- Mood affect is required' and TableName = 'CustomDocumentBHSClientNotes')
BEGIN
INSERT [dbo].[DocumentValidations] ([Active], [DocumentCodeId], [DocumentType], [TabName], [TabOrder], [TableName], [ColumnName], [ValidationLogic], [ValidationDescription], [ValidationOrder], [ErrorMessage]) 
VALUES (N'Y', @DocumentCodeId, NULL, N'BHS Groups', 1, N'CustomDocumentBHSClientNotes', N'MoodorAffect', N'FROM CustomDocumentBHSClientNotes WHERE DocumentVersionId=@DocumentVersionId AND (ISNULL(MoodorAffect,'''') = '''' OR ISNULL(MoodorAffectComments,'''') = '''') AND ISNULL(RecordDeleted,''N'')=''N''', N'Client Note-Client’s current condition- Mood affect is required', CAST(3 AS Decimal(18, 0)), N'Client Note-Client’s current condition- Mood affect is required')
END

--4
IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=@DocumentCodeId and ErrorMessage='Client Note-Client’s current condition- Thought process/orientation  is required ' and TableName = 'CustomDocumentBHSClientNotes')
BEGIN
INSERT [dbo].[DocumentValidations] ([Active], [DocumentCodeId], [DocumentType], [TabName], [TabOrder], [TableName], [ColumnName], [ValidationLogic], [ValidationDescription], [ValidationOrder], [ErrorMessage]) 
VALUES (N'Y', @DocumentCodeId, NULL, N'BHS Groups', 1, N'CustomDocumentBHSClientNotes', N'ThoughtProcess', N'FROM CustomDocumentBHSClientNotes WHERE DocumentVersionId=@DocumentVersionId AND (ISNULL(ThoughtProcess,'''') = '''' OR ISNULL(ThoughtProcessComments,'''') = '''') AND ISNULL(RecordDeleted,''N'')=''N''', N'Client Note-Client’s current condition- Thought process/orientation  is required', CAST(4 AS Decimal(18, 0)), N'Client Note-Client’s current condition- Thought process/orientation  is required')
END


--5
IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=@DocumentCodeId and ErrorMessage='Client Note-Client’s current condition- Behavior/functioning is required' and TableName = 'CustomDocumentBHSClientNotes')
BEGIN
INSERT [dbo].[DocumentValidations] ([Active], [DocumentCodeId], [DocumentType], [TabName], [TabOrder], [TableName], [ColumnName], [ValidationLogic], [ValidationDescription], [ValidationOrder], [ErrorMessage]) 
VALUES (N'Y', @DocumentCodeId, NULL, N'BHS Groups', 1, N'CustomDocumentBHSClientNotes', N'Behavior', N'FROM CustomDocumentBHSClientNotes WHERE DocumentVersionId=@DocumentVersionId AND (ISNULL(Behavior,'''') = '''' OR ISNULL(BehaviorComments,'''') = '''') AND ISNULL(RecordDeleted,''N'')=''N''', N'Client Note-Client’s current condition- Behavior/functioning is required', CAST(5 AS Decimal(18, 0)), N'Client Note-Client’s current condition- Behavior/functioning is required')
END

--6
IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=@DocumentCodeId and ErrorMessage='Client Note-Client’s current condition- Medical condition is required' and TableName = 'CustomDocumentBHSClientNotes')
BEGIN
INSERT [dbo].[DocumentValidations] ([Active], [DocumentCodeId], [DocumentType], [TabName], [TabOrder], [TableName], [ColumnName], [ValidationLogic], [ValidationDescription], [ValidationOrder], [ErrorMessage]) 
VALUES (N'Y', @DocumentCodeId, NULL, N'BHS Groups', 1, N'CustomDocumentBHSClientNotes', N'MedicalCondition', N'FROM CustomDocumentBHSClientNotes WHERE DocumentVersionId=@DocumentVersionId AND (ISNULL(MedicalCondition,'''') = '''' OR ISNULL(MedicalConditionComments,'''') = '''') AND ISNULL(RecordDeleted,''N'')=''N''', N'Client Note-Client’s current condition- Medical condition is required', CAST(6 AS Decimal(18, 0)), N'Client Note-Client’s current condition- Medical condition is required')
END

--7
IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=@DocumentCodeId and ErrorMessage='Client Note-Client’s current condition- Substance use is required' and TableName = 'CustomDocumentBHSClientNotes')
BEGIN
INSERT [dbo].[DocumentValidations] ([Active], [DocumentCodeId], [DocumentType], [TabName], [TabOrder], [TableName], [ColumnName], [ValidationLogic], [ValidationDescription], [ValidationOrder], [ErrorMessage]) 
VALUES (N'Y', @DocumentCodeId, NULL, N'BHS Groups', 1, N'CustomDocumentBHSClientNotes', N'SubstanceUse', N'FROM CustomDocumentBHSClientNotes WHERE DocumentVersionId=@DocumentVersionId AND (ISNULL(SubstanceUse,'''') = '''' OR ISNULL(SubstanceUseComments,'''') = '''') AND ISNULL(RecordDeleted,''N'')=''N''', N'Client Note-Client’s current condition- Substance use is required', CAST(7 AS Decimal(18, 0)), N'Client Note-Client’s current condition- Substance use is required')
END



--8

IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=@DocumentCodeId and ErrorMessage='Client Note-Client’s current condition- Homicidal/suicidal is required' and TableName = 'CustomDocumentBHSClientNotes')
BEGIN
INSERT [dbo].[DocumentValidations] ([Active], [DocumentCodeId], [DocumentType], [TabName], [TabOrder], [TableName], [ColumnName], [ValidationLogic], [ValidationDescription], [ValidationOrder], [ErrorMessage]) 
VALUES (N'Y', @DocumentCodeId, NULL, N'BHS Groups', 1, N'CustomDocumentBHSClientNotes', N'Homicidal', N'FROM CustomDocumentBHSClientNotes WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(MedicalCondition,'''') = '''' 
AND ISNULL(MedicalConditionComments,'''') = '''' AND ISNULL(HomicidalNoneReportedorDangerTo,'''') = '''' AND ISNULL(HomicidalSelf,'''') = '''' AND ISNULL(HomicidalOthers,'''') = '''' AND ISNULL(HomicidalProperty,'''') = '''' 
AND ISNULL(Homicidalideation,'''') = '''' AND ISNULL(HomicidalPlan,'''') = '''' AND ISNULL(HomicidalIntent,'''') = '''' AND ISNULL(HomicidalAttempt,'''') = '''' AND ISNULL(HomicidalOther,'''') = '''' 
AND ISNULL(RecordDeleted,''N'')=''N''', N'Client Note-Client’s current condition- Homicidal/suicidal is required', CAST(8 AS Decimal(18, 0)), N'Client Note-Client’s current condition- Homicidal/suicidal is required')
END

--9
IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=@DocumentCodeId and ErrorMessage='Client Note-Client’s current condition- Homicidal/suicidal comments are required' and TableName = 'CustomDocumentBHSClientNotes')
BEGIN
INSERT [dbo].[DocumentValidations] ([Active], [DocumentCodeId], [DocumentType], [TabName], [TabOrder], [TableName], [ColumnName], [ValidationLogic], [ValidationDescription], [ValidationOrder], [ErrorMessage]) 
VALUES (N'Y', @DocumentCodeId, NULL, N'BHS Groups', 1, N'CustomDocumentBHSClientNotes', N'HomicidalOtherComments', N'FROM CustomDocumentBHSClientNotes WHERE DocumentVersionId=@DocumentVersionId AND HomicidalOther = ''Y'' AND ISNULL(HomicidalOtherComments,'''') = '''' AND ISNULL(RecordDeleted,''N'')=''N''',
 N'Client Note-Client’s current condition- Homicidal/suicidal comments are required', CAST(9 AS Decimal(18, 0)), N'Client Note-Client’s current condition- Homicidal/suicidal comments are required')
END

--10

IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=@DocumentCodeId and ErrorMessage='Client Note-Client’s current condition- Document response to any identified risk is required' and TableName = 'CustomDocumentBHSClientNotes')
BEGIN
INSERT [dbo].[DocumentValidations] ([Active], [DocumentCodeId], [DocumentType], [TabName], [TabOrder], [TableName], [ColumnName], [ValidationLogic], [ValidationDescription], [ValidationOrder], [ErrorMessage]) 
VALUES (N'Y', @DocumentCodeId, NULL, N'BHS Groups', 1, N'CustomDocumentBHSClientNotes', N'DocumentResponse', N'FROM CustomDocumentBHSClientNotes WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(DocumentResponse,'''') = ''''  AND ISNULL(RecordDeleted,''N'')=''N''', N'Client Note-Client’s current condition- Document response to any identified risk is required', CAST(10 AS Decimal(18, 0)), N'Client Note-Client’s current condition- Document response to any identified risk is required')
END

--11
IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=@DocumentCodeId and ErrorMessage='Client Note-Client’s current condition- Any concerns with current medications is required' and TableName = 'CustomDocumentBHSClientNotes')
BEGIN
INSERT [dbo].[DocumentValidations] ([Active], [DocumentCodeId], [DocumentType], [TabName], [TabOrder], [TableName], [ColumnName], [ValidationLogic], [ValidationDescription], [ValidationOrder], [ErrorMessage]) 
VALUES (N'Y', @DocumentCodeId, NULL, N'BHS Groups', 1, N'CustomDocumentBHSClientNotes', N'CurrentMedications', N'FROM CustomDocumentBHSClientNotes WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(CurrentMedications,'''') = ''''  AND ISNULL(RecordDeleted,''N'')=''N''', N'Client Note-Client’s current condition- Any concerns with current medications is required', CAST(11 AS Decimal(18, 0)), N'Client Note-Client’s current condition- Any concerns with current medications is required')
END

--12
IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=@DocumentCodeId and ErrorMessage='Client Note-Client’s current condition- Any concerns with current medications comments are required' and TableName = 'CustomDocumentBHSClientNotes')
BEGIN
INSERT [dbo].[DocumentValidations] ([Active], [DocumentCodeId], [DocumentType], [TabName], [TabOrder], [TableName], [ColumnName], [ValidationLogic], [ValidationDescription], [ValidationOrder], [ErrorMessage]) 
VALUES (N'Y', @DocumentCodeId, NULL, N'BHS Groups', 1, N'CustomDocumentBHSClientNotes', N'CurrentMedicationsComments', N'FROM CustomDocumentBHSClientNotes WHERE DocumentVersionId=@DocumentVersionId AND CurrentMedications = ''Y'' AND ISNULL(CurrentMedicationsComments,'''') = '''' AND ISNULL(RecordDeleted,''N'')=''N''',
 N'Client Note-Client’s current condition- Any concerns with current medications comments are required', CAST(12 AS Decimal(18, 0)), N'Client Note-Client’s current condition- Any concerns with current medications comments are required')
END

--13
IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=@DocumentCodeId and ErrorMessage='Client Note-Client group participation- Attention-at least one checkbox is required' and TableName = 'CustomDocumentBHSClientNotes')
BEGIN
INSERT [dbo].[DocumentValidations] ([Active], [DocumentCodeId], [DocumentType], [TabName], [TabOrder], [TableName], [ColumnName], [ValidationLogic], [ValidationDescription], [ValidationOrder], [ErrorMessage]) 
VALUES (N'Y', @DocumentCodeId, NULL, N'BHS Groups', 1, N'CustomDocumentBHSClientNotes', N'Attention', N'FROM CustomDocumentBHSClientNotes WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(AttentionNormal,'''') = '''' 
AND ISNULL(AttentionInattentive,'''') = '''' AND ISNULL(AttentionDistractible,'''') = '''' AND ISNULL(AttentionConfused,'''') = '''' 
AND ISNULL(RecordDeleted,''N'')=''N''', N'Client Note-Client group participation- Attention-at least one checkbox is required', CAST(13 AS Decimal(18, 0)), N'Client Note-Client group participation- Attention-at least one checkbox is required')
END

--14

IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=@DocumentCodeId and ErrorMessage='Client Note-Client group participation- Attitude-at least one checkbox is required' and TableName = 'CustomDocumentBHSClientNotes')
BEGIN
INSERT [dbo].[DocumentValidations] ([Active], [DocumentCodeId], [DocumentType], [TabName], [TabOrder], [TableName], [ColumnName], [ValidationLogic], [ValidationDescription], [ValidationOrder], [ErrorMessage]) 
VALUES (N'Y', @DocumentCodeId, NULL, N'BHS Groups', 1, N'CustomDocumentBHSClientNotes', N'Attitude', N'FROM CustomDocumentBHSClientNotes WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(AttitudeIUnremarkable,'''') = '''' 
AND ISNULL(AttitudeCooperative,'''') = '''' AND ISNULL(AttitudeUninterested,'''') = '''' AND ISNULL(AttitudeResistance,'''') = '''' AND ISNULL(AttitudeHostile,'''') = '''' 
AND ISNULL(RecordDeleted,''N'')=''N''', N'Client Note-Client group participation- Attitude-at least one checkbox is required', CAST(14 AS Decimal(18, 0)), N'Client Note-Client group participation- Attitude-at least one checkbox is required')
END

--15
IF NOT EXISTS(SELECT * FROM DocumentValidations WHERE DocumentCodeId=@DocumentCodeId and ErrorMessage='Client Note-Client group participation- Interpersonal-at least one checkbox is required' and TableName = 'CustomDocumentBHSClientNotes')
BEGIN
INSERT [dbo].[DocumentValidations] ([Active], [DocumentCodeId], [DocumentType], [TabName], [TabOrder], [TableName], [ColumnName], [ValidationLogic], [ValidationDescription], [ValidationOrder], [ErrorMessage]) 
VALUES (N'Y', @DocumentCodeId, NULL, N'BHS Groups', 1, N'CustomDocumentBHSClientNotes', N'Interpersonal', N'FROM CustomDocumentBHSClientNotes WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(InterPersonalShowedEmpathy,'''') = '''' 
AND ISNULL(InterPersonalEngaged,'''') = '''' AND ISNULL(InterPersonalProvideHelpfulFeedback,'''') = '''' AND ISNULL(InterPersonalAttentionSeeking,'''') = '''' AND ISNULL(InterPersonalDisruptive,'''') = '''' 
AND ISNULL(InterPersonalNotRespectiveToOthers,'''') = '''' AND ISNULL(InterPersonalNotinvolved,'''') = '''' AND ISNULL(InterPersonalUnremarkable,'''') = '''' AND ISNULL(RecordDeleted,''N'')=''N''', N'Client Note-Client group participation- Interpersonal-at least one checkbox is required', CAST(15 AS Decimal(18, 0)), N'Client Note-Client group participation- Interpersonal-at least one checkbox is required')
END

--16
IF NOT EXISTS(SELECT * FROM DocumentValidations WHERE DocumentCodeId=@DocumentCodeId and ErrorMessage='Client Note-Client group participation- Demonstrated understanding of topic/recovery- at least one checkbox is required' and TableName = 'CustomDocumentBHSClientNotes')
BEGIN
INSERT [dbo].[DocumentValidations] ([Active], [DocumentCodeId], [DocumentType], [TabName], [TabOrder], [TableName], [ColumnName], [ValidationLogic], [ValidationDescription], [ValidationOrder], [ErrorMessage]) 
VALUES (N'Y', @DocumentCodeId, NULL, N'BHS Groups', 1, N'CustomDocumentBHSClientNotes', N'Interpersonal', N'FROM CustomDocumentBHSClientNotes WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(TopicRecoveryExcellent,'''') = '''' 
AND ISNULL(TopicRecoveryGood,'''') = '''' AND ISNULL(TopicRecoverySatisfactory,'''') = '''' AND ISNULL(TopicRecoveryMarginal,'''') = '''' AND ISNULL(TopicRecoveryPoor,'''') = '''' 
AND ISNULL(RecordDeleted,''N'')=''N''', N'Client Note-Client group participation- Demonstrated understanding of topic/recovery- at least one checkbox is required', CAST(16 AS Decimal(18, 0)), N'Client Note-Client group participation- Demonstrated understanding of topic/recovery- at least one checkbox is required')
END





