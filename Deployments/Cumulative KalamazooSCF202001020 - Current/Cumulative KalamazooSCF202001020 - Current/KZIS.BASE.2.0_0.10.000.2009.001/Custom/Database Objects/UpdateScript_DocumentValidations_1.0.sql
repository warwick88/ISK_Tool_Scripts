--Date: 06/17/2020
--Purpose: Update script for DocumentValidation to resolve the issues reported by QA.

DECLARE @DocumentcodeId VARCHAR(MAX)
DECLARE @CODE Varchar(100)
SET @CODE='69E559DD-1A4D-46D3-B91C-E89DA48E0038'
SET @DocumentcodeId=(Select DocumentCodeId from DocumentCodes 
                      where Code=@CODE And Active='Y' AND
                       ISNULL(Recorddeleted,'N')='N')

IF EXISTS (SELECT * FROM DocumentValidations Where DocumentcodeId=@DocumentcodeId and TabName='Risk Assessment'  AND ColumnName='RiskOtherFactorsNone')
BEGIN
Update DocumentValidations set ValidationLogic = 'From #CustomDocumentMHAssessments  where isnull(RiskOtherFactorsNone,''N'')=''N''   
AND NOT EXISTS(select 1 from CustomOtherRiskFactors where DocumentVersionId = @DocumentVersionId AND ISNULL(RecordDeleted,''N'') = ''N'' ) '
where DocumentCodeId=@DocumentcodeId and TabName='Risk Assessment' AND ColumnName='RiskOtherFactorsNone'
END


IF EXISTS (SELECT * FROM DocumentValidations Where DocumentcodeId=@DocumentcodeId and TabName='UNCOPE' and ColumnName='LastTimeDrinkDate')
BEGIN
update DocumentValidations Set ValidationLogic= 'FROM #CustomDocumentAssessmentSubstanceUses CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId
  WHERE  AdultOrChild = ''A'' and (LastTimeDrinkDate IS NULL AND LastTimeDrinks IS NULL)
  and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
  where DocumentCodeId=@DocumentcodeId and TabName='UNCOPE' and ColumnName='LastTimeDrinkDate'
END

IF EXISTS (SELECT * FROM DocumentValidations Where DocumentcodeId=@DocumentcodeId and TabName='CRAFFT' and ColumnName='LastTimeDrinkDate')
BEGIN
update DocumentValidations Set ValidationLogic= 'FROM #CustomDocumentAssessmentSubstanceUses CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId
  WHERE  AdultOrChild = ''C'' and (LastTimeDrinkDate IS NULL AND LastTimeDrinks IS NULL) AND ISNULL(CS.NotApplicable,''N'')=''N''
  and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
  where DocumentCodeId=@DocumentcodeId and TabName='CRAFFT' and ColumnName='LastTimeDrinkDate'

END

