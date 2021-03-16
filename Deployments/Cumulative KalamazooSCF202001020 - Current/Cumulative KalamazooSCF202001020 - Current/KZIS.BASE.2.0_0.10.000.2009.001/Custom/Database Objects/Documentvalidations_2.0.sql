/*Pupose :  Validation script for Dx Tab*/
 DECLARE @DocumentcodeId VARCHAR(MAX)
 DECLARE @CODE VARCHAR(MAX)
 DECLARE @TableName VARCHAR (MAX) 
 SET @CODE='69E559DD-1A4D-46D3-B91C-E89DA48E0038'

  SET @TableName='DocumentDiagnosisCodes'
 SET @DocumentcodeId=(Select DocumentCodeId from DocumentCodes 
                      where Code=@CODE And Active='Y' AND
                       ISNULL(Recorddeleted,'N')='N')


IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Dx - Primary Diagnosis must have a billing order of 1') 
BEGIN 
INSERT INTO DocumentValidations (DocumentCodeId,Active,TableName,TabOrder,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder,ErrorMessage)Values

 (@DocumentcodeId,'Y','DocumentDiagnosisCodes',14,'DiagnosisType','where exists (Select 1 from DocumentDiagnosisCodes where (DiagnosisOrder <> 1 and DiagnosisType = 140) or (DiagnosisOrder = 1 and DiagnosisType <> 140)) and Not Exists (Select 1 from DocumentDiagnosis Where NoDiagnosis = ''Y'' and DocumentVersionId=@DocumentVersionId)','Dx - Primary Diagnosis must have a billing order of 1',2,'Dx - Primary Diagnosis must have a billing order of 1')
END


IF  EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'IndividualName') 
BEGIN 
UPDATE DocumentValidations SET ErrorMessage='Pre-Planning Worksheet - Individual'+'"'+'s Name is required'
WHERE  DocumentCodeId = @DocumentcodeId and ColumnName= 'IndividualName'
END