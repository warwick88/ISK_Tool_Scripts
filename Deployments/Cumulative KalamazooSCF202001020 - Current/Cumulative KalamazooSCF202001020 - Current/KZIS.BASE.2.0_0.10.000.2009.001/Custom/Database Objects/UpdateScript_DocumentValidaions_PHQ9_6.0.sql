DECLARE @DocumentCodeId int
SET @DocumentCodeId =(SELECT DocumentCodeId FROM DocumentCodes where Code='69E559DD-1A4D-46D3-B91C-E89DA48E0038' )


IF  EXISTS (
		SELECT 1
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND TableName = 'PHQ9Documents' and ColumnName='LittleInterest' AND TabName='PHQ9'
		)
BEGIN
UPDATE DocumentValidations SET [ValidationLogic] = 'FROM PHQ9Documents CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE CS.LittleInterest IS NULL and AdultOrChild = ''A'' and ISNULL(CM.ClientInDDPopulation,''N'') = ''N'' AND ISNULL(CS.ClientDeclinedToParticipate,''N'') = ''N''  and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
WHERE DocumentCodeId = @DocumentCodeId AND TableName = 'PHQ9Documents' and ColumnName='LittleInterest' AND TabName='PHQ9'
END


IF  EXISTS (
		SELECT 1
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND TableName = 'PHQ9Documents' and ColumnName='FeelingDown' AND TabName='PHQ9'
		)
BEGIN
UPDATE DocumentValidations SET [ValidationLogic] = 'FROM PHQ9Documents CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE CS.FeelingDown IS NULL and AdultOrChild = ''A'' and ISNULL(CM.ClientInDDPopulation,''N'') = ''N'' AND ISNULL(CS.ClientDeclinedToParticipate,''N'') = ''N''  and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
WHERE DocumentCodeId = @DocumentCodeId AND TableName = 'PHQ9Documents' and ColumnName='FeelingDown' AND TabName='PHQ9'
END

IF  EXISTS (
		SELECT 1
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND TableName = 'PHQ9Documents' and ColumnName='TroubleFalling' AND TabName='PHQ9'
		)
BEGIN
UPDATE DocumentValidations SET [ValidationLogic] = 'FROM PHQ9Documents CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE CS.TroubleFalling IS NULL and AdultOrChild = ''A'' and ISNULL(CM.ClientInDDPopulation,''N'') = ''N'' AND ISNULL(CS.ClientDeclinedToParticipate,''N'') = ''N''  and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
WHERE DocumentCodeId = @DocumentCodeId AND TableName = 'PHQ9Documents' and ColumnName='TroubleFalling' AND TabName='PHQ9'
END

IF  EXISTS (
		SELECT 1
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND TableName = 'PHQ9Documents' and ColumnName='FeelingTired' AND TabName='PHQ9'
		)
BEGIN
UPDATE DocumentValidations SET [ValidationLogic] = 'FROM PHQ9Documents CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE CS.FeelingTired IS NULL and AdultOrChild = ''A'' and ISNULL(CM.ClientInDDPopulation,''N'') = ''N'' AND ISNULL(CS.ClientDeclinedToParticipate,''N'') = ''N''  and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
WHERE DocumentCodeId = @DocumentCodeId AND TableName = 'PHQ9Documents' and ColumnName='FeelingTired' AND TabName='PHQ9'
END

IF  EXISTS (
		SELECT 1
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND TableName = 'PHQ9Documents' and ColumnName='PoorAppetite' AND TabName='PHQ9'
		)
BEGIN
UPDATE DocumentValidations SET [ValidationLogic] = 'FROM PHQ9Documents CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE CS.PoorAppetite IS NULL and AdultOrChild = ''A'' and ISNULL(CM.ClientInDDPopulation,''N'') = ''N'' AND ISNULL(CS.ClientDeclinedToParticipate,''N'') = ''N''  and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
WHERE DocumentCodeId = @DocumentCodeId AND TableName = 'PHQ9Documents' and ColumnName='PoorAppetite' AND TabName='PHQ9'
END

IF  EXISTS (
		SELECT 1
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND TableName = 'PHQ9Documents' and ColumnName='FeelingBad' AND TabName='PHQ9'
		)
BEGIN
UPDATE DocumentValidations SET [ValidationLogic] = 'FROM PHQ9Documents CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE CS.FeelingBad IS NULL and AdultOrChild = ''A'' and ISNULL(CM.ClientInDDPopulation,''N'') = ''N'' AND ISNULL(CS.ClientDeclinedToParticipate,''N'') = ''N''  and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
WHERE DocumentCodeId = @DocumentCodeId AND TableName = 'PHQ9Documents' and ColumnName='FeelingBad' AND TabName='PHQ9'
END

IF  EXISTS (
		SELECT 1
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND TableName = 'PHQ9Documents' and ColumnName='TroubleConcentrating' AND TabName='PHQ9'
		)
BEGIN
UPDATE DocumentValidations SET [ValidationLogic] = 'FROM PHQ9Documents CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE CS.TroubleConcentrating IS NULL and AdultOrChild = ''A'' and ISNULL(CM.ClientInDDPopulation,''N'') = ''N'' AND ISNULL(CS.ClientDeclinedToParticipate,''N'') = ''N''  and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
WHERE DocumentCodeId = @DocumentCodeId AND TableName = 'PHQ9Documents' and ColumnName='TroubleConcentrating' AND TabName='PHQ9'
END

IF  EXISTS (
		SELECT 1
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND TableName = 'PHQ9Documents' and ColumnName='MovingOrSpeakingSlowly' AND TabName='PHQ9'
		)
BEGIN
UPDATE DocumentValidations SET [ValidationLogic] = 'FROM PHQ9Documents CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE CS.MovingOrSpeakingSlowly IS NULL and AdultOrChild = ''A'' and ISNULL(CM.ClientInDDPopulation,''N'') = ''N'' AND ISNULL(CS.ClientDeclinedToParticipate,''N'') = ''N''  and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
WHERE DocumentCodeId = @DocumentCodeId AND TableName = 'PHQ9Documents' and ColumnName='MovingOrSpeakingSlowly' AND TabName='PHQ9'
END

IF  EXISTS (
		SELECT 1
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND TableName = 'PHQ9Documents' and ColumnName='HurtingYourself' AND TabName='PHQ9'
		)
BEGIN
UPDATE DocumentValidations SET [ValidationLogic] = 'FROM PHQ9Documents CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE CS.HurtingYourself IS NULL and AdultOrChild = ''A'' and ISNULL(CM.ClientInDDPopulation,''N'') = ''N'' AND ISNULL(CS.ClientDeclinedToParticipate,''N'') = ''N''  and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
WHERE DocumentCodeId = @DocumentCodeId AND TableName = 'PHQ9Documents' and ColumnName='HurtingYourself' AND TabName='PHQ9'
END

IF  EXISTS (
		SELECT 1
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND TableName = 'PHQ9Documents' and ColumnName='GetAlongOtherPeople' AND TabName='PHQ9'
		)
BEGIN
UPDATE DocumentValidations SET [ValidationLogic] = 'FROM PHQ9Documents CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE CS.GetAlongOtherPeople IS NULL and AdultOrChild = ''A'' and ISNULL(CM.ClientInDDPopulation,''N'') = ''N'' AND ISNULL(CS.ClientDeclinedToParticipate,''N'') = ''N''  and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
WHERE DocumentCodeId = @DocumentCodeId AND TableName = 'PHQ9Documents' and ColumnName='GetAlongOtherPeople' AND TabName='PHQ9'
END

IF  EXISTS (
		SELECT 1
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND TableName = 'PHQ9Documents' and ColumnName='DocumentationFollowup' AND TabName='PHQ9'
		)
BEGIN
UPDATE DocumentValidations SET [ValidationLogic] = 'FROM PHQ9Documents CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE  AdultOrChild = ''A'' and ISNULL(CM.ClientInDDPopulation,''N'') = ''N'' AND ISNULL(CS.ClientDeclinedToParticipate,''N'') = ''N'' AND ISNULL(CS.OtherInterventions, ''Y'') = ''Y'' AND ISNULL(CS.DocumentationFollowup,'''')='''' AND ISNULL(CS.ClientRefusedOrContraIndicated,''N'')=''N''  and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
WHERE DocumentCodeId = @DocumentCodeId AND TableName = 'PHQ9Documents' and ColumnName='DocumentationFollowup' AND TabName='PHQ9'
END