
DECLARE @Code VARCHAR(50) ='69E559DD-1A4D-46D3-B91C-E89DA48E0038'
DECLARE @DocumentCodeId int 
SET @DocumentCodeId =(SELECT TOP 1 DocumentCodeId FROM DocumentCodes where Code=@Code)

IF EXISTS(SELECT 1 FROM DocumentValidations where DocumentCodeId=@DocumentCodeId and ColumnName='PsCurrentHealthIssuesComment')
BEGIN
UPDATE DocumentValidations SET ValidationLogic = 'FROM CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND ((AdultOrChild = ''A'' AND PsCurrentHealthIssues = ''Y'') OR (AdultOrChild = ''C'' AND (PsCurrentHealthIssues = ''Y'' OR PsSexuality = ''Y''
  OR PsImmunizations = ''Y'' ))) and ISNULL(PsCurrentHealthIssuesComment,'''')='''' '  where DocumentCodeId=@DocumentCodeId and ColumnName='PsCurrentHealthIssuesComment'
END 

IF EXISTS(SELECT * FROM DocumentValidations where DocumentCodeId=@DocumentCodeId and
 ErrorMessage ='Dx - Primary Diagnosis must have a billing order of 1')
BEGIN
UPDATE DocumentValidations SET ValidationLogic = 'where exists (Select 1 from DocumentDiagnosisCodes where DocumentVersionId=@DocumentVersionId and ISNULL(RecordDeleted,''N'')=''N'' and ((DiagnosisOrder <> 1 and DiagnosisType = 140) or
     (DiagnosisOrder = 1 and DiagnosisType <> 140))) and Not Exists (Select 1 from DocumentDiagnosis Where NoDiagnosis = ''Y''
     and DocumentVersionId=@DocumentVersionId) '  where DocumentCodeId=@DocumentCodeId and 
 ErrorMessage ='Dx - Primary Diagnosis must have a billing order of 1'
END 


   
   
