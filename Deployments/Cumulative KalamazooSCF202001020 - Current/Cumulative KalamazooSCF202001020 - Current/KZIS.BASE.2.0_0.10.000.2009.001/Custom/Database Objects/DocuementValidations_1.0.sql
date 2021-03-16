/*
Insert script for Assessment - Document - Validation Messgae
Author :Jyothi
Created Date : 25/05/2020
Purpose : What/Why : Initial Tab validations Task #
*/

 DECLARE @DocumentcodeId VARCHAR(MAX)
 DECLARE @CODE VARCHAR(MAX)
 DECLARE @TableName VARCHAR (MAX) 
 SET @CODE='69E559DD-1A4D-46D3-B91C-E89DA48E0038'

  SET @TableName='CustomDocumentMHAssessments'
 SET @DocumentcodeId=(Select DocumentCodeId from DocumentCodes 
                      where Code=@CODE And Active='Y' AND
                       ISNULL(Recorddeleted,'N')='N')
--- INITIAL TAB VALIDATIONS -----------------


 --- Initial Tab  ---

 IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and Columnname= 'GuardianFirstName') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId, DocumentType,TabName,TabOrder,TableName,ColumnName,ValidationLogic, ValidationDescription,ValidationOrder,ErrorMessage,RecordDeleted) values
     ('Y',@DocumentcodeId,NULL,'Initial',0,'CustomDocumentMHAssessments','GuardianFirstName','FROM  #CustomDocumentMHAssessments  WHERE ISNULL(ClientHasGuardian,''N'')=''Y'' AND GuardianFirstName IS NULL','Guardian/ Authorized Representative - First Name is required.',1,'Guardian/ Authorized Representative - First Name is required.',NULL) 
 END
 
 IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and Columnname= 'GuardianLastName') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId, DocumentType,TabName,TabOrder,TableName,ColumnName,ValidationLogic, ValidationDescription,ValidationOrder,ErrorMessage,RecordDeleted) values
     ('Y',@DocumentcodeId,NULL,'Initial',0,'CustomDocumentMHAssessments','GuardianLastName','From  #CustomDocumentMHAssessments  WHERE ISNULL(ClientHasGuardian,''N'')=''Y'' AND GuardianLastName IS NULL ','Guardian/ Authorized Representative - Last Name is required.',2,'Guardian/ Authorized Representative - Last Name is required.',NULL) 
 END

 
 IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and Columnname= 'RelationWithGuardian') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId, DocumentType,TabName,TabOrder,TableName,ColumnName,ValidationLogic, ValidationDescription,ValidationOrder,ErrorMessage,RecordDeleted) values
     ('Y',@DocumentcodeId,NULL,'Initial',0,'CustomDocumentMHAssessments','RelationWithGuardian','From #CustomDocumentMHAssessments  WHERE ISNULL(ClientHasGuardian,''N'')=''Y'' AND RelationWithGuardian IS NULL','Guardian/ Authorized Representative - Relationship is required.',3,'Guardian/ Authorized Representative - Relationship is required.',NULL) 
 END

 -- END Guardian Validation

 IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'General section- Reason for Update textbox is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active, DocumentCodeId, DocumentType,TabName,TabOrder,TableName,ColumnName,ValidationLogic, ValidationDescription,ValidationOrder,ErrorMessage,RecordDeleted) values
     ('Y',@DocumentcodeId,NULL,'Initial',0,@TableName,'ReasonForUpdate','From #CustomDocumentMHAssessments  where isnull(AssessmentType,''X'')=''U''  and isnull(convert(varchar(8000), ReasonForUpdate),'''')=''''','',4,'General section- Reason for Update textbox is required',NULL)
  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'General section- Summary of Progress textbox is required') 
BEGIN 
    INSERT INTO DocumentValidations (  Active,  DocumentCodeId, DocumentType,TabName,TabOrder,TableName,ColumnName,ValidationLogic, ValidationDescription,ValidationOrder,ErrorMessage,RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,'Initial',0,@TableName,'ReasonForUpdate','From #CustomDocumentMHAssessments  where isnull(AssessmentType,''X'')=''A''  and isnull(convert(varchar(8000), ReasonForUpdate),'''')=''''','',5,'General section- Summary of Progress textbox is required',NULL) 
 END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'General section- Current Living Arrangement is required') 
BEGIN 
    INSERT INTO DocumentValidations (Active, DocumentCodeId, DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic, ValidationDescription,ValidationOrder,ErrorMessage,RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,'Initial',0,@TableName,'CurrentLivingArrangement','From #CustomDocumentMHAssessments where isnull(CurrentLivingArrangement,0)=0','',6,'General section- Current Living Arrangement is required',NULL) 
 END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'General section- Current Employment status is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId, DocumentType,TabName,TabOrder,TableName,ColumnName,ValidationLogic, ValidationDescription,ValidationOrder,ErrorMessage,RecordDeleted) values
     ('Y',@DocumentcodeId,NULL,'Initial',0,@TableName,'EmploymentStatus','From #CustomDocumentMHAssessments where isnull(EmploymentStatus,0)=0','',7,'General section- Current Employment status is required',NULL) 
 END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'General section- Current Primary Care Physician is required') 
BEGIN 
     INSERT INTO DocumentValidations (  Active,  DocumentCodeId,DocumentType,TabName,TabOrder,TableName, ColumnName,ValidationLogic,ValidationDescription,ValidationOrder,ErrorMessage,RecordDeleted  ) values
     ('Y',@DocumentcodeId,NULL,'Initial',0,@TableName,'CurrentPrimaryCarePhysician','From #CustomDocumentMHAssessments where isnull(CurrentPrimaryCarePhysician,'''')=''''','',8,'General section- Current Primary Care Physician is required',NULL)  
END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'General section- Presenting Problem is required') 
BEGIN 
     INSERT INTO DocumentValidations (  Active, DocumentCodeId,  DocumentType,TabName,TabOrder,TableName,ColumnName,ValidationLogic, ValidationDescription,ValidationOrder,ErrorMessage,RecordDeleted) values
     ('Y',@DocumentcodeId,NULL,'Initial',0,@TableName,'PresentingProblem','From #CustomDocumentMHAssessments where isnull(PresentingProblem,'''')=''''','',9,'General section- Presenting Problem is required',NULL) 
 END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'General section- Presence or absence of relevant legal issues of the client and/or family is required') 
BEGIN 
     INSERT INTO DocumentValidations (Active,DocumentCodeId, DocumentType,TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder,ErrorMessage, RecordDeleted ) values
     ('Y',@DocumentcodeId,NULL,'Initial',0,@TableName,'LegalIssues','From #CustomDocumentMHAssessments where isnull(LegalIssues,'''')=''''','',10,'General section- Presence or absence of relevant legal issues of the client and/or family is required',NULL) 
 END



IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'General section- Desired Outcomes is required') 
BEGIN 
    INSERT INTO DocumentValidations (Active, DocumentCodeId,DocumentType,TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription, ValidationOrder,ErrorMessage,RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,'Initial',0,@TableName,'DesiredOutcomes','From #CustomDocumentMHAssessments where isnull(DesiredOutcomes,'''')=''''','',11,'General section- Desired Outcomes is required',NULL)  
END






