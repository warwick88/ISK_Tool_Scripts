--Date: 06/17/2020
--Purpose: Update script for DocumentValidation to resolve the issues reported by QA.


DECLARE @DocumentcodeId VARCHAR(MAX)
 DECLARE @CODE VARCHAR(MAX)
SET @CODE='69E559DD-1A4D-46D3-B91C-E89DA48E0038'
SET @DocumentcodeId=(Select DocumentCodeId from DocumentCodes 
                      where Code=@CODE And Active='Y' AND
                       ISNULL(Recorddeleted,'N')='N')
                       
                       
--UNCOPE

IF EXISTS (SELECT 1 FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId  AND TabName='UNCOPE' AND ColumnName='DrinksPerWeek')
BEGIN
UPDATE DocumentValidations SET ErrorMessage= 'Substance Use - How many drinks do you have per week? is required', SectionName = NULL
WHERE DocumentCodeId = @DocumentcodeId AND ColumnName='DrinksPerWeek'  AND TabName='UNCOPE'
END

IF EXISTS (SELECT 1 FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId  AND TabName='UNCOPE' AND ColumnName='LastTimeDrinkDate')
BEGIN
UPDATE DocumentValidations SET ErrorMessage= 'Substance Use - When was the last time you had 4 or more... is required', SectionName = NULL
WHERE DocumentCodeId = @DocumentcodeId AND ColumnName='LastTimeDrinkDate'  AND TabName='UNCOPE'
END

IF EXISTS (SELECT 1 FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId  AND TabName='UNCOPE' AND ColumnName='IllegalDrugs')
BEGIN
UPDATE DocumentValidations SET ErrorMessage= 'Substance Use - In the past year, have you used or experimented... is required', SectionName = NULL
WHERE DocumentCodeId = @DocumentcodeId AND ColumnName='IllegalDrugs'  AND TabName='UNCOPE'
END

IF EXISTS (SELECT 1 FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId  AND TabName='UNCOPE' AND ColumnName='DDOneTimeOnly')
BEGIN
UPDATE DocumentValidations SET ErrorMessage= 'DD One Time Only - Not required to check the box when DD checkbox is selected as population type in General tab.', SectionName = NULL
WHERE DocumentCodeId = @DocumentcodeId AND ColumnName='DDOneTimeOnly'  AND TabName='UNCOPE'
END

--CRAFFT
IF EXISTS (SELECT 1 FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId  AND TabName='CRAFFT' AND ColumnName='DrinksPerWeek')
BEGIN
UPDATE DocumentValidations SET ErrorMessage= 'Substance Use - How many drinks do you have per week? is required', SectionName = NULL,
ValidationLogic='FROM #CustomDocumentAssessmentSubstanceUses CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE ISNULL(CS.DrinksPerWeek,0)=0 AND ISNULL(CS.NotApplicable,''N'')=''N'' and AdultOrChild = ''C'' and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
WHERE DocumentCodeId = @DocumentcodeId AND ColumnName='DrinksPerWeek'  AND TabName='CRAFFT'
END

IF EXISTS (SELECT 1 FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId  AND TabName='CRAFFT' AND ColumnName='LastTimeDrinkDate')
BEGIN
UPDATE DocumentValidations SET ErrorMessage= 'Substance Use - When was the last time you had 4 or more... is required', SectionName = NULL,
ValidationLogic ='FROM #CustomDocumentAssessmentSubstanceUses CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE  AdultOrChild = ''C'' and (CS.LastTimeDrinkDate IS NULL OR  CS.LastTimeDrinks IS NULL) AND ISNULL(CS.NotApplicable,''N'')=''N'' and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
WHERE DocumentCodeId = @DocumentcodeId AND ColumnName='LastTimeDrinkDate'  AND TabName='CRAFFT'
END

IF EXISTS (SELECT 1 FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId  AND TabName='CRAFFT' AND ColumnName='IllegalDrugs')
BEGIN
UPDATE DocumentValidations SET ErrorMessage= 'Substance Use - In the past year, have you used or experimented... is required', SectionName = NULL,
ValidationLogic =	'FROM #CustomDocumentAssessmentSubstanceUses CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE  AdultOrChild = ''C'' and ISNULL(CS.IllegalDrugs,'''')='''' AND ISNULL(CS.NotApplicable,''N'')=''N'' and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
WHERE DocumentCodeId = @DocumentcodeId AND ColumnName='IllegalDrugs'  AND TabName='CRAFFT'
END

IF EXISTS (SELECT 1 FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId  AND TabName='CRAFFT' AND ColumnName='DDOneTimeOnly')
BEGIN
UPDATE DocumentValidations SET ErrorMessage= 'DD One Time Only - Not required to check the box when DD checkbox is selected as population type in General tab.', SectionName = NULL,
ValidationLogic = 'FROM #CustomDocumentAssessmentSubstanceUses CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE  AdultOrChild = ''C'' AND ISNULL(CS.NotApplicable,''N'')=''N''  and CS.DDOneTimeOnly=''Y'' AND ISNULL(CM.ClientInDDPopulation,''N'')=''N''  and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
WHERE DocumentCodeId = @DocumentcodeId AND ColumnName='DDOneTimeOnly'  AND TabName='CRAFFT'
END