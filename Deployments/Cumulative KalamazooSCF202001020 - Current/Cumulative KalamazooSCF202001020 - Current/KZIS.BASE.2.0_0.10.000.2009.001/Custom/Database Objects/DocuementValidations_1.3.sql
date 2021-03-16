/*
Insert script for Assessment - Document - Validation Messgae
Author :Jyothi 
Created Date : 25/05/2020
Purpose : What/Why : Task #  
*/

 DECLARE @DocumentcodeId VARCHAR(MAX)
 DECLARE @CODE VARCHAR(MAX)
 DECLARE @TableName VARCHAR (MAX) 
 DECLARE @Taborder INT
 SET @CODE='69E559DD-1A4D-46D3-B91C-E89DA48E0038'

 SET @DocumentcodeId=(Select DocumentCodeId from DocumentCodes 
                      where Code=@CODE And Active='Y' AND
                       ISNULL(Recorddeleted,'N')='N')

 SET @TableName='CustomMHAssessmentSupports'
 SET @Taborder=10

-- delete  from documentvalidations where TableName='CustomHRMAssessmentSupports2'  and documentcodeid=67004
 
IF NOT EXISTS ( SELECT *  FROM DocumentValidations WHERE  DocumentCodeId = @DocumentcodeId  and ErrorMessage = 'Support- At least one current support is required.')
BEGIN
   INSERT INTO  DocumentValidations ( Active, DocumentCodeId, DocumentType, TabName, TabOrder, TableName, ColumnName, ValidationLogic, ValidationDescription, ValidationOrder, ErrorMessage, RecordDeleted )  values
      ( 'Y', @DocumentcodeId, NULL, 'Support', @Taborder, @TableName,'DeletedBy', 
	  'From #CustomMHAssessmentSupports  Where DocumentVersionId = @DocumentVersionId 
	   and isnull(SupportDescription,'''')<>''''  and isnull([Current],'''')=''''  
	     and @AssessmentType <> ''S''', '', 1, 'Support- At least one current support is required.',  NULL)
END

IF NOT EXISTS 
( SELECT * FROM DocumentValidations   WHERE  DocumentCodeId = @DocumentcodeId  and ErrorMessage = 'Support- Support Description narrative is required')
BEGIN
   INSERT INTO DocumentValidations ( Active, DocumentCodeId, DocumentType, TabName, TabOrder, TableName, ColumnName, ValidationLogic, ValidationDescription, ValidationOrder, ErrorMessage, RecordDeleted ) values
   ('Y', @DocumentcodeId, NULL, 'Support',@Taborder, @TableName,'SupportDescription', 'From #CustomMHAssessmentSupports  Where DocumentVersionId = @DocumentVersionId  and isnull(SupportDescription,'''')=''''    and @AssessmentType <> ''S''',
         '', 1, 'Support- Support Description narrative is required',NULL)
END

IF NOT EXISTS (SELECT  *  FROM  DocumentValidations WHERE DocumentCodeId = @DocumentcodeId  and ErrorMessage = 'Support- Current/Not Current selection is required')
BEGIN
   INSERT INTO
      DocumentValidations ( Active, DocumentCodeId, DocumentType, TabName, TabOrder, TableName, ColumnName, ValidationLogic, ValidationDescription, ValidationOrder, ErrorMessage, RecordDeleted ) values
      ( 'Y', @DocumentcodeId, NULL,'Support',@Taborder,@TableName,'Current',
         'From #CustomMHAssessmentSupports  Where DocumentVersionId = @DocumentVersionId  and isnull(SupportDescription,'''')<>''''  and isnull([Current],'''')=''''',
         '', 2, 'Support- Current/Not Current selection is required',NULL )
END

IF NOT EXISTS (SELECT *  FROM DocumentValidations WHERE  DocumentCodeId = @DocumentcodeId and ErrorMessage = 'Support- Paid/Unpaid selection is required')
BEGIN
   INSERT INTO DocumentValidations ( Active, DocumentCodeId, DocumentType, TabName, TabOrder, TableName, ColumnName, ValidationLogic, ValidationDescription, ValidationOrder, ErrorMessage, RecordDeleted )  values
      ( 'Y', @DocumentcodeId,NULL,'Support',@Taborder, @TableName,'DeletedBy',
         'From #CustomMHAssessmentSupports  Where DocumentVersionId = @DocumentVersionId  and isnull(SupportDescription,'''')<>''''  and isnull(PaidSupport,'''')=''''  and isnull(UnpaidSupport,'''')=''''  and isnull([Current],'''')=''Y''',
         '', 3,'Support- Paid/Unpaid selection is required', NULL )
END

IF NOT EXISTS ( SELECT *  FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId  and ErrorMessage = 'Support- Clinically Recommended/Customer Desired selection is required')
BEGIN
   INSERT INTO   DocumentValidations ( Active, DocumentCodeId, DocumentType, TabName, TabOrder, TableName, ColumnName, ValidationLogic, ValidationDescription, ValidationOrder, ErrorMessage, RecordDeleted )  values 
   ('Y', @DocumentcodeId, NULL,'Support',@Taborder,@TableName, 'DeletedBy',
         'From #CustomMHAssessmentSupports  Where DocumentVersionId = @DocumentVersionId  and isnull(SupportDescription,'''')<>''''  and isnull(ClinicallyRecommended,'''')=''''  and isnull(CustomerDesired,'''')=''''  and isnull([Current],'''')=''N''',
         '', 4,'Support- Clinically Recommended/Customer Desired selection is required',NULL )
END

-----------------------Summary/Level of Care--------------------------------------

SET @TableName='CustomDocumentMHAssessments'
 SET @Taborder=16

--DELETE FROM  DocumentValidations WHERE DocumentCodeId=@DocumentcodeId AND TableName='CustomDocumentMHAssessments' and taborder=18

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Summary/LOC-Treatment- Does client meet criteria for services is required') 
 BEGIN 
   INSERT INTO DocumentValidations (Active,DocumentCodeId,DocumentType,TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder,ErrorMessage,RecordDeleted ) values
  ('Y',@DocumentcodeId,NULL,NULL,@Taborder,@TableName,'ClientIsAppropriateForTreatment','From #CustomDocumentMHAssessments a  where DocumentVersionId = @DocumentVersionId  and  ClientIsAppropriateForTreatment is null','',1,'Summary/LOC-Treatment- Does client meet criteria for services is required',NULL) 
 END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Summary/LOC-Treatment- Was Adverse Benefit Determination provided is required') 
 BEGIN
     INSERT INTO DocumentValidations (Active,DocumentCodeId,DocumentType, TabName, TabOrder,  TableName, ColumnName, ValidationLogic, ValidationDescription,ValidationOrder,  ErrorMessage, RecordDeleted ) values
     ('Y',@DocumentcodeId,NULL,NULL,@Taborder,@TableName,'SecondOpinionNoticeProvided','From #CustomDocumentMHAssessments a  where DocumentVersionId = @DocumentVersionId  and  SecondOpinionNoticeProvided is null  and ClientIsAppropriateForTreatment = ''N''','',2,'Summary/LOC-Treatment- Was Adverse Benefit Determination provided is required',NULL)  
 END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Summary/LOC-Treatment- Discuss treatment focus and client preferences is required') 
BEGIN 
    INSERT INTO DocumentValidations ( Active,DocumentCodeId,DocumentType,TabName,TabOrder,TableName, ColumnName,ValidationLogic,ValidationDescription, ValidationOrder,   ErrorMessage,  RecordDeleted   ) values
     ('Y',@DocumentcodeId,NULL,NULL,@Taborder,@TableName,'TreatmentNarrative','From #CustomDocumentMHAssessments a    where DocumentVersionId = @DocumentVersionId  and  isnull(TreatmentNarrative,'''')=''''    and isnull(ClientIsAppropriateForTreatment,'''') = ''''    and isnull(SecondOpinionNoticeProvided,'''') = ''''','',3,'Summary/LOC-Treatment- Discuss treatment focus and client preferences is required',NULL)  
END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Summary/LOC-Treatment- Strengths, needs, abilities, preferences textbox is required') 
BEGIN 
    INSERT INTO DocumentValidations ( Active,DocumentCodeId,DocumentType,TabName,TabOrder,TableName, ColumnName,ValidationLogic,ValidationDescription, ValidationOrder,   ErrorMessage,  RecordDeleted   ) values
     ('Y',@DocumentcodeId,NULL,NULL,@Taborder,@TableName,'TreatmentNarrative','From #CustomDocumentMHAssessments a    where DocumentVersionId = @DocumentVersionId  and  isnull(Strengths,'''')='''' ','',4,'Summary/LOC-Treatment- Strengths, needs, abilities, preferences textbox is required',NULL)  
END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Summary/LOC- Clinical Interpretative summary-textbox is required ') 
BEGIN 
   INSERT INTO DocumentValidations (Active,  DocumentCodeId, DocumentType,  TabName,  TabOrder,  TableName,ColumnName, ValidationLogic, ValidationDescription,  ValidationOrder, ErrorMessage,  RecordDeleted ) values
   ('Y',@DocumentcodeId,NULL,NULL,@Taborder,@TableName,'ClinicalSummary','From #CustomDocumentMHAssessments  Where DocumentVersionId = @DocumentVersionId  and  isnull(ClinicalSummary,'''')=''''','',5,'Summary/LOC- Clinical Interpretative summary-textbox is required',NULL)  
END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Summary/LOC- Level of Care-textbox is required') 
BEGIN 
    INSERT INTO DocumentValidations (Active, DocumentCodeId, DocumentType,  TabName, TabOrder, TableName,  ColumnName, ValidationLogic, ValidationDescription, ValidationOrder,  ErrorMessage, RecordDeleted ) values
     ('Y',@DocumentcodeId,NULL,NULL,@Taborder,@TableName,'TransitionLevelOfCare','From #CustomDocumentMHAssessments  Where DocumentVersionId = @DocumentVersionId  and isnull(TransitionLevelOfCare,'''')=''''','',6,'Summary/LOC- Level of Care-textbox is required',NULL)  
END
--------------------------------------------------------------- 
--IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Summary/LOC- Level of Care-textbox is required') 
--BEGIN 
--     INSERT INTO DocumentValidations (Active, DocumentCodeId,DocumentType,TabName, TabOrder, TableName,  ColumnName,  ValidationLogic,  ValidationDescription,ValidationOrder, ErrorMessage,  RecordDeleted   ) values
--     ('Y',@DocumentcodeId,NULL,NULL,18,@TableName,'LevelOfCare','From #CustomDocumentMHAssessments a    where isnull(LOCId,'''')=''''','',4,'Summary/LOC- Level of Care-textbox is required',NULL)  
--END





IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Summary/LOC- Transition/LOC/Discharge Plan checkbox is required') 
BEGIN 
     INSERT INTO DocumentValidations (Active, DocumentCodeId, DocumentType, TabName, TabOrder,  TableName,  ColumnName, ValidationLogic, ValidationDescription,  ValidationOrder,ErrorMessage,  RecordDeleted) values
     ('Y',@DocumentcodeId,NULL,NULL,@Taborder,@TableName,'ReductionInSymptoms','From #CustomDocumentMHAssessments  Where DocumentVersionId = @DocumentVersionId  and  isnull(ReductionInSymptoms,''N'')=''N'' and isnull(TreatmentNotNecessary,''N'')=''N'' and isnull(AttainmentOfHigherFunctioning,''N'')='''' and isnull(OtherTransitionCriteria,''N'')=''''','',7,'Summary/LOC- Transition/LOC/Discharge Plan checkbox is required',NULL)  
END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Summary/LOC – Transition/LOC/Discharge Plan Estimated Discharge Date is required') 
BEGIN 
   INSERT INTO DocumentValidations ( Active, DocumentCodeId, DocumentType, TabName,TabOrder,TableName,  ColumnName, ValidationLogic, ValidationDescription,  ValidationOrder, ErrorMessage,RecordDeleted) values
   ('Y',@DocumentcodeId,NULL,NULL,@Taborder,@TableName,'EstimatedDischargeDate','From #CustomDocumentMHAssessments  Where DocumentVersionId = @DocumentVersionId  and  isnull(EstimatedDischargeDate,'''')=''''','',8,'Summary/LOC – Transition/LOC/Discharge Plan Estimated Discharge Date is required',NULL)  
 END


 ---------------  Diagnosis Tab

 IF NOT EXISTS ( SELECT  *
            FROM    dbo.DocumentValidations
            WHERE   DocumentCodeId = @DocumentcodeId
                    AND ISNULL(RecordDeleted, 'N') = 'N'
                    AND TabName = 'Dx' )
    BEGIN

        --DELETE  FROM dbo.DocumentValidations
        --WHERE   DocumentCodeId = @DocumentcodeId
        --        AND TabName = 'Dx'

        INSERT  INTO DocumentValidations
                ( DocumentCodeId ,
                  Active ,
                  TabName ,
                  TabOrder ,
                  TableName ,
                  ColumnName ,
                  ValidationLogic ,
                  ValidationOrder ,
                  ErrorMessage
                )
                SELECT  @DocumentcodeId ,
                        'Y' ,
                        'Dx' ,
                        14 ,
                        'DocumentDiagnosis' ,
                        'NoDiagnosis' ,
                        'FROM    dbo.CustomDocumentMHAssessments
WHERE   DocumentVersionId = @DocumentVersionId
        AND ( EXISTS ( SELECT   DISTINCT
                                b.DocumentVersionId
                       FROM     dbo.DocumentDiagnosis a
                                LEFT JOIN dbo.DocumentDiagnosisCodes b ON b.DocumentVersionId = a.DocumentVersionId
                                                                          AND ISNULL(b.RecordDeleted, ''N'') = ''N''
                       WHERE    ISNULL(a.NoDiagnosis, ''N'') = ''N''
                                AND ISNULL(a.RecordDeleted, ''N'') = ''N''
                                AND a.DocumentVersionId = @DocumentVersionId
                                AND b.DocumentVersionId IS NULL )
              AND NOT EXISTS ( SELECT    *
                              FROM      dbo.DocumentDiagnosis a
                              WHERE     ISNULL(a.NoDiagnosis, ''N'') = ''Y''
                                        AND ISNULL(a.RecordDeleted, ''N'') = ''N''
                                        AND a.DocumentVersionId = @DocumentVersionId )
            )' ,
                        1 ,
                        'Dx is required'
                
    END