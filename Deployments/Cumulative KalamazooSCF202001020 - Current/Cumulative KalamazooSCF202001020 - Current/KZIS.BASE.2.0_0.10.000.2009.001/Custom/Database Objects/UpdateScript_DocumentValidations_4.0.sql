--Date: 06/24/2020
--Purpose : Modified the Validation logic as per the requirement of KCMHSAS Improvements #7

DECLARE @DocumentCodeId int
SET @DocumentCodeId =(SELECT DocumentCodeId FROM DocumentCodes where Code='69E559DD-1A4D-46D3-B91C-E89DA48E0038' )


IF EXISTS (SELECT 1 FROM DocumentValidations where   DocumentCodeId=@DocumentCodeId AND 
ErrorMessage='Client experienced or witnessed abuse or neglect - Radio button selection is required')
BEGIN
UPDATE DocumentValidations SET ValidationLogic = 'FROM #CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(PsClientAbuseIssues,'''')='''' '
  where   DocumentCodeId=@DocumentCodeId and ErrorMessage='Client experienced or witnessed abuse or neglect - Radio button selection is required'
END


IF EXISTS (SELECT 1 FROM DocumentValidations where   DocumentCodeId=@DocumentCodeId AND ColumnName='PsMedicationsComment' and TableName='CustomDocumentMHAssessments')
BEGIN
UPDATE DocumentValidations SET ErrorMessage ='Medications - Textbox is required' ,
ValidationLogic ='FROM CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND PsMedications=''I''  AND ISNULL(PsMedicationsComment,'''')='''' '
  where   DocumentCodeId=@DocumentCodeId and ColumnName='PsMedicationsComment' and TableName='CustomDocumentMHAssessments'

END

--Uncope

IF EXISTS (SELECT 1 FROM DocumentValidations where   DocumentCodeId=@DocumentCodeId AND 
ColumnName ='UncopeQuestionO' and TabName='UNCOPE')
BEGIN
UPDATE DocumentValidations SET ValidationOrder=10
  where   DocumentCodeId=@DocumentCodeId and ColumnName ='UncopeQuestionO' and TabName='UNCOPE'
END

IF EXISTS (SELECT 1 FROM DocumentValidations where   DocumentCodeId=@DocumentCodeId AND 
ColumnName ='UncopeQuestionP' and TabName='UNCOPE')
BEGIN
UPDATE DocumentValidations SET ValidationOrder=11
  where   DocumentCodeId=@DocumentCodeId and ColumnName ='UncopeQuestionP' and TabName='UNCOPE'
END

IF EXISTS (SELECT 1 FROM DocumentValidations where   DocumentCodeId=@DocumentCodeId AND 
ColumnName ='UncopeQuestionE' and TabName='UNCOPE')
BEGIN
UPDATE DocumentValidations SET ValidationOrder=12
  where   DocumentCodeId=@DocumentCodeId and ColumnName ='UncopeQuestionE' and TabName='UNCOPE'
END

IF EXISTS (SELECT 1 FROM DocumentValidations where   DocumentCodeId=@DocumentCodeId AND 
ColumnName ='StageOfChange' and TabName='UNCOPE')
BEGIN
UPDATE DocumentValidations SET ValidationOrder=13
  where   DocumentCodeId=@DocumentCodeId and ColumnName ='StageOfChange' and TabName='UNCOPE'
END