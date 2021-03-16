/*
Created By: Arul Sonia
Created On: 03-Dec-2020
What: Changed the validation logic for CRAFFT Tab "Substance Use - When was the last time you had 4 or more... is required"
Why: KCMHSAS Build Cycle Tasks #119
*/

DECLARE @DocumentCodeId INT
SELECT @DocumentCodeId=DocumentCodeId FROM DocumentCodes WHERE Code='69E559DD-1A4D-46D3-B91C-E89DA48E0038'

IF (ISNULL(@DocumentCodeId, -1) > 0)
BEGIN

	IF EXISTS(SELECT 1 FROM DocumentValidations 
		WHERE TableName = 'CustomDocumentAssessmentSubstanceUses' 
			AND ColumnName = 'LastTimeDrinkDate' 
			AND TabName ='CRAFFT'
			AND DocumentCodeId = @DocumentCodeId
			AND ErrorMessage = 'Substance Use - When was the last time you had 4 or more... is required'
			AND ValidationLogic ='FROM #CustomDocumentAssessmentSubstanceUses CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE  AdultOrChild = ''C'' and (CS.LastTimeDrinkDate IS NULL OR  CS.LastTimeDrinks IS NULL) AND ISNULL(CS.NotApplicable,''N'')=''N'' and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '	
			AND ISNULL(RecordDeleted, 'N') = 'N'
			AND Active = 'Y')
	BEGIN
		UPDATE DocumentValidations 
		SET ValidationLogic ='FROM #CustomDocumentAssessmentSubstanceUses CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE  AdultOrChild = ''C'' and (CS.LastTimeDrinkDate IS NULL AND  CS.LastTimeDrinks IS NULL) AND ISNULL(CS.NotApplicable,''N'')=''N'' and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '	
		WHERE TableName = 'CustomDocumentAssessmentSubstanceUses' 
			AND ColumnName = 'LastTimeDrinkDate' 
			AND TabName ='CRAFFT'
			AND DocumentCodeId = @DocumentCodeId
			AND ErrorMessage = 'Substance Use - When was the last time you had 4 or more... is required'
			AND ValidationLogic ='FROM #CustomDocumentAssessmentSubstanceUses CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE  AdultOrChild = ''C'' and (CS.LastTimeDrinkDate IS NULL OR  CS.LastTimeDrinks IS NULL) AND ISNULL(CS.NotApplicable,''N'')=''N'' and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '	
			AND ISNULL(RecordDeleted, 'N') = 'N'
			AND Active = 'Y'
	END

END