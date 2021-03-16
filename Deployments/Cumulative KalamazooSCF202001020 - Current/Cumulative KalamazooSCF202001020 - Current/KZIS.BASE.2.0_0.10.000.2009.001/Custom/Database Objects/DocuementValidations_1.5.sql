
 DECLARE @DocumentcodeId VARCHAR(MAX)
  DECLARE @CODE VARCHAR(MAX)
  DECLARE @TableName VARCHAR (MAX) 
  SET @CODE='69E559DD-1A4D-46D3-B91C-E89DA48E0038'
  SET @DocumentcodeId=(Select DocumentCodeId from DocumentCodes where Code=@CODE)
  SET @TableName='CustomDocumentMHAssessments'
--Risk Assessment


 

   IF NOT EXISTS 
   (
      SELECT
         * 
      FROM
         DocumentValidations 
      WHERE
         DocumentCodeId = @DocumentcodeId 
         and ErrorMessage = 'Risk Assessment- Other Risk Factors- Describe Risk Factors is required'
   )
   BEGIN
      insert into
         DocumentValidations ( Active, DocumentCodeId, DocumentType, TabName, TabOrder, TableName, ColumnName, ValidationLogic, ValidationDescription, ValidationOrder, ErrorMessage, RecordDeleted ) 
      values
         (
            'Y',
            @DocumentcodeId,
            NULL,
            NULL,
            12,
            @TableName,
            'RiskOtherFactors',
            'From #CustomDocumentMHAssessments  where isnull(RiskOtherFactors,'''')='''' and (select COUNT(*) from CustomOtherRiskFactors where DocumentVersionId = @DocumentVersionId AND ISNULL(RecordDeleted,''N'') = ''N'' AND ISNULL(OtherRiskFactor,0) > 0) > 0',
            '',
            4,
            'Risk Assessment- Other Risk Factors- Describe Risk Factors is required',
            NULL
         )
   END
   IF NOT EXISTS 
   (
      SELECT
         * 
      FROM
         DocumentValidations 
      WHERE
         DocumentCodeId = @DocumentcodeId 
         and ErrorMessage = 'Risk Assessment- Advance Directive- Does client have a advance directive is required'
   )
   BEGIN
      insert into
         DocumentValidations ( Active, DocumentCodeId, DocumentType, TabName, TabOrder, TableName, ColumnName, ValidationLogic, ValidationDescription, ValidationOrder, ErrorMessage, RecordDeleted ) 
      values
         (
            'Y',
            @DocumentcodeId,
            NULL,
            NULL,
            9,
            @TableName,
            'AdvanceDirectiveClientHasDirective',
            'From #CustomDocumentMHAssessments   where isnull(AdvanceDirectiveClientHasDirective,'''')='''' and AdultOrChild=''A''',
            '',
            5,
            'Risk Assessment- Advance Directive- Does client have a advance directive is required',
            NULL
         )
   END
   IF NOT EXISTS 
   (
      SELECT
         * 
      FROM
         DocumentValidations 
      WHERE
         DocumentCodeId = @DocumentcodeId 
         and ErrorMessage = 'Risk Assessment- Advance Directive- Does client desire a advance directive plan is required'
   )
   BEGIN
      insert into
         DocumentValidations ( Active, DocumentCodeId, DocumentType, TabName, TabOrder, TableName, ColumnName, ValidationLogic, ValidationDescription, ValidationOrder, ErrorMessage, RecordDeleted ) 
      values
         (
            'Y',
            @DocumentcodeId,
            NULL,
            NULL,
            9,
            @TableName,
            'AdvanceDirectiveDesired',
            'From #CustomDocumentMHAssessments   where isnull(AdvanceDirectiveDesired,'''')='''' and AdultOrChild=''A''',
            '',
            6,
            'Risk Assessment- Advance Directive- Does client desire a advance directive plan is required',
            NULL
         )
   END
   IF NOT EXISTS 
   (
      SELECT
         * 
      FROM
         DocumentValidations 
      WHERE
         DocumentCodeId = @DocumentcodeId 
         and ErrorMessage = 'Risk Assessment- Advance Directive- Would client like more information about advance directive planning is required'
   )
   BEGIN
      insert into
         DocumentValidations ( Active, DocumentCodeId, DocumentType, TabName, TabOrder, TableName, ColumnName, ValidationLogic, ValidationDescription, ValidationOrder, ErrorMessage, RecordDeleted ) 
      values
         (
            'Y',
            @DocumentcodeId,
            NULL,
            NULL,
            9,
            @TableName,
            'AdvanceDirectiveMoreInfo',
            'From #CustomDocumentMHAssessments   where isnull(AdvanceDirectiveMoreInfo,'''')='''' and AdultOrChild=''A''',
            '',
            7,
            'Risk Assessment- Advance Directive- Would client like more information about advance directive planning is required',
            NULL
         )
   END
   IF NOT EXISTS 
   (
      SELECT
         * 
      FROM
         DocumentValidations 
      WHERE
         DocumentCodeId = @DocumentcodeId 
         and ErrorMessage = 'Risk Assessment- Advance Directive- What information was the client given regarding advance directive is required'
   )
   BEGIN
      insert into
         DocumentValidations ( Active, DocumentCodeId, DocumentType, TabName, TabOrder, TableName, ColumnName, ValidationLogic, ValidationDescription, ValidationOrder, ErrorMessage, RecordDeleted ) 
      values
         (
            'Y',
            @DocumentcodeId,
            NULL,
            NULL,
            9,
           @TableName,
            'AdvanceDirectiveNarrative',
            'From #CustomDocumentMHAssessments   where isnull(AdvanceDirectiveNarrative,'''')='''' and AdultOrChild=''A''',
            '',
            8,
            'Risk Assessment- Advance Directive- What information was the client given regarding advance directive is required',
            NULL
         )
   END

--Summary/Level of Care
--DELETE FROM  DocumentValidations WHERE DocumentCodeId=10018 AND TableName='CustomDocumentMHAssessments' and taborder=18
--IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = 10018 and ErrorMessage= 'Summary/LOC-Treatment- Does client meet criteria for services is required') BEGIN insert into DocumentValidations (                          Active,                          DocumentCodeId,                          DocumentType,                          TabName,                          TabOrder,                          TableName,                          ColumnName,                          ValidationLogic,                          ValidationDescription,                          ValidationOrder,                          ErrorMessage,                          RecordDeleted                                                  ) values('Y',10018,NULL,NULL,18,'CustomHRMAssessments','ClientIsAppropriateForTreatment','From #CustomHRMAssessments a  where ClientIsAppropriateForTreatment is null','',1,'Summary/LOC-Treatment- Does client meet criteria for services is required',NULL)  END
--IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = 10018 and ErrorMessage= 'Summary/LOC-Treatment- If client does not meet criteria, was referral or other options offered is required') BEGIN insert into DocumentValidations (                          Active,                          DocumentCodeId,                          DocumentType,                          TabName,                          TabOrder,                          TableName,                          ColumnName,                          ValidationLogic,                          ValidationDescription,                          ValidationOrder,                          ErrorMessage,                          RecordDeleted                                                  ) values('Y',10018,NULL,NULL,18,'CustomHRMAssessments','SecondOpinionNoticeProvided','From #CustomHRMAssessments a  where SecondOpinionNoticeProvided is null  and ClientIsAppropriateForTreatment = ''N''','',2,'Summary/LOC-Treatment- If client does not meet criteria, was referral or other options offered is required',NULL)  END
--IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = 10018 and ErrorMessage= 'Summary/LOC-Treatment- Discuss treatment focus and client preferences is required') BEGIN insert into DocumentValidations (                          Active,                          DocumentCodeId,                          DocumentType,                          TabName,                          TabOrder,                          TableName,                          ColumnName,                          ValidationLogic,                          ValidationDescription,                          ValidationOrder,                          ErrorMessage,                          RecordDeleted                                                  ) values('Y',10018,NULL,NULL,18,'CustomHRMAssessments','TreatmentNarrative','From #CustomHRMAssessments a    where isnull(TreatmentNarrative,'''')=''''    and isnull(ClientIsAppropriateForTreatment,'''') = ''''    and isnull(SecondOpinionNoticeProvided,'''') = ''''','',3,'Summary/LOC-Treatment- Discuss treatment focus and client preferences is required',NULL)  END
--IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = 10018 and ErrorMessage= 'Summary/LOC- Level of Care-textbox is required') BEGIN insert into DocumentValidations (                          Active,                          DocumentCodeId,                          DocumentType,                          TabName,                          TabOrder,                          TableName,                          ColumnName,                          ValidationLogic,                          ValidationDescription,                          ValidationOrder,                          ErrorMessage,                          RecordDeleted                                                  ) values('Y',10018,NULL,NULL,18,'CustomHRMAssessments','LevelOfCare','From #CustomHRMAssessments a    where isnull(LOCId,'''')=''''','',4,'Summary/LOC- Level of Care-textbox is required',NULL)  END
--IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = 10018 and ErrorMessage= 'Summary/LOC- Clinical Interpretative summary-textbox is required ') BEGIN insert into DocumentValidations (                          Active,                          DocumentCodeId,                          DocumentType,                          TabName,                          TabOrder,                          TableName,                          ColumnName,                          ValidationLogic,                          ValidationDescription,                          ValidationOrder,                          ErrorMessage,                          RecordDeleted                                                  ) values('Y',10018,NULL,NULL,18,'CustomHRMAssessments','ClinicalSummary','From #CustomHRMAssessments  Where isnull(ClinicalSummary,'''')=''''','',5,'Summary/LOC- Clinical Interpretative summary-textbox is required',NULL)  END
--IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = 10018 and ErrorMessage= 'Summary/LOC- LOC textbox is required') BEGIN insert into DocumentValidations (                          Active,                          DocumentCodeId,                          DocumentType,                          TabName,                          TabOrder,                          TableName,                          ColumnName,                          ValidationLogic,                          ValidationDescription,                          ValidationOrder,                          ErrorMessage,                          RecordDeleted                                                  ) values('Y',10018,NULL,NULL,18,'CustomHRMAssessments','TransitionLevelOfCare','From #CustomHRMAssessments  Where isnull(TransitionLevelOfCare,'''')=''''','',6,'Summary/LOC- LOC textbox is required',NULL)  END
--IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = 10018 and ErrorMessage= 'Summary/LOC- Transition/LOC/Discharge Plan checkbox is required') BEGIN insert into DocumentValidations (                          Active,                          DocumentCodeId,                          DocumentType,                          TabName,                          TabOrder,                          TableName,                          ColumnName,                          ValidationLogic,                          ValidationDescription,                          ValidationOrder,                          ErrorMessage,                          RecordDeleted                                                  ) values('Y',10018,NULL,NULL,18,'CustomHRMAssessments','ReductionInSymptoms','From #CustomHRMAssessments  Where isnull(ReductionInSymptoms,''N'')=''N'' and isnull(TreatmentNotNecessary,''N'')=''N'' and isnull(AttainmentOfHigherFunctioning,''N'')='''' and isnull(OtherTransitionCriteria,''N'')=''''','',7,'Summary/LOC- Transition/LOC/Discharge Plan checkbox is required',NULL)  END
--IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = 10018 and ErrorMessage= 'Summary/LOC – Transition/LOC/Discharge Plan Estimated Discharge Date is required') BEGIN insert into DocumentValidations (                          Active,                          DocumentCodeId,                          DocumentType,                          TabName,                          TabOrder,                          TableName,                          ColumnName,                          ValidationLogic,                          ValidationDescription,                          ValidationOrder,                          ErrorMessage,                          RecordDeleted                                                  ) values('Y',10018,NULL,NULL,18,'CustomHRMAssessments','EstimatedDischargeDate','From #CustomHRMAssessments  Where isnull(EstimatedDischargeDate,'''')=''''','',8,'Summary/LOC – Transition/LOC/Discharge Plan Estimated Discharge Date is required',NULL)  END


