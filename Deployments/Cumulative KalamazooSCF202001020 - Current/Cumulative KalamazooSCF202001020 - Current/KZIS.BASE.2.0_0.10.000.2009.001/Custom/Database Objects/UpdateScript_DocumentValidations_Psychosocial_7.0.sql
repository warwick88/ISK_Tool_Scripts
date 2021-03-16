DECLARE @DocumentcodeId VARCHAR(MAX)
DECLARE @CODE Varchar(100)
SET @CODE='69E559DD-1A4D-46D3-B91C-E89DA48E0038'
SET @DocumentcodeId=(Select DocumentCodeId from DocumentCodes 
                      where Code=@CODE )
                      
IF EXISTS (SELECT 1 FROM DocumentValidations where DocumentCodeId =@DocumentcodeId and ColumnName='PsSexuality')
BEGIN
UPDATE DocumentValidations SET Errormessage='Psychosocial History - Are there any issues regarding current or past sexual behaviors is required'
where DocumentCodeId =@DocumentcodeId and ColumnName='PsSexuality'
END
                      
IF EXISTS (SELECT 1 FROM DocumentValidations where DocumentCodeId =@DocumentcodeId and ColumnName='WhereMedicationUsed')
BEGIN
UPDATE DocumentValidations SET Errormessage='Developmental/Attachment History - Were medications used during pregnancy  is required'
where DocumentCodeId =@DocumentcodeId and ColumnName='WhereMedicationUsed'
END

IF EXISTS (SELECT 1 FROM DocumentValidations where DocumentCodeId =@DocumentcodeId and ColumnName='IssueWithDelivery')
BEGIN
UPDATE DocumentValidations SET Errormessage='Developmental/Attachment History - Were there any issues during delivery  is required'
where DocumentCodeId =@DocumentcodeId and ColumnName='IssueWithDelivery'
END

IF EXISTS (SELECT 1 FROM DocumentValidations where DocumentCodeId =@DocumentcodeId and ColumnName='DevelopmentalAttachmentComments')
BEGIN
UPDATE DocumentValidations SET Errormessage='Development/Attachment History – Please address any issues from above and the initial relationships between parent and child is required',
ValidationLogic='FROM CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(DevelopmentalAttachmentComments,'''')='''' 
AND (ReceivePrenatalCare =''Y'' OR ProblemInPregnancy =''Y'' OR PrenatalExposer =''Y'' OR WhereMedicationUsed =''Y'' OR IssueWithDelivery =''Y'' OR ChildDevelopmentalMilestones =''N'')'
where DocumentCodeId =@DocumentcodeId and ColumnName='DevelopmentalAttachmentComments'
END

IF EXISTS (SELECT 1 FROM DocumentValidations where DocumentCodeId =@DocumentcodeId and ColumnName='PsImmunizations')
BEGIN
UPDATE DocumentValidations SET Errormessage='Psychosocial History - Are immunizations current is required '
where DocumentCodeId =@DocumentcodeId and ColumnName='PsImmunizations'
END

IF EXISTS (SELECT 1 FROM DocumentValidations where DocumentCodeId =@DocumentcodeId and ColumnName='ReductionInSymptoms')
BEGIN
UPDATE DocumentValidations SET ValidationLogic=' From #CustomDocumentMHAssessments  Where DocumentVersionId = @DocumentVersionId  and  isnull(ReductionInSymptoms,''N'')=''N''
 and isnull(TreatmentNotNecessary,''N'')=''N'' and isnull(AttainmentOfHigherFunctioning,''N'')=''N'' and isnull(OtherTransitionCriteria,''N'')=''N'' '
where DocumentCodeId =@DocumentcodeId and ColumnName='ReductionInSymptoms'
END


