/*
Insert script for Assessment - Document - Validation Messgae
Author :Jyothi Bellapu
Created Date : 25/05/2020
Purpose : What/Why : Task #
*/

 DECLARE @DocumentcodeId VARCHAR(MAX)
 DECLARE @CODE VARCHAR(MAX)
 DECLARE @TableName VARCHAR (MAX) 
 SET @CODE='69E559DD-1A4D-46D3-B91C-E89DA48E0038'
 SET @DocumentcodeId=(Select DocumentCodeId from DocumentCodes where Code=@CODE)
 SET @TableName='CustomDocumentMHAssessments'


--Psychosocial - Section 1
 IF NOT EXISTS ( SELECT *   FROM  DocumentValidations   WHERE  DocumentCodeId = @DocumentcodeId  and ErrorMessage = 'Psychosocial History - Are there any current or historical health issues? radio button selection is required'  )
   BEGIN
    INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentcodeId,Null,'Psychosocial','7',@TableName,'PsCurrentHealthIssues','FROM CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(PsCurrentHealthIssues,'''')='''' ', 'Psychosocial History - Are there any current or historical health issues? radio button selection is required', 1,  'Psychosocial History - Are there any current or historical health issues? radio button selection is required')
END


IF NOT EXISTS (
		SELECT 1
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND TableName = 'CustomMHAssessmentCurrentHealthIssues' and ColumnName='CurrentHealthIssues' AND TabName='Psychosocial'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
		[Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationOrder]
		,[ErrorMessage]
		,[SectionName]
		)
	VALUES (
		N'Y'
		,@DocumentCodeId
		,NULL
		,'Psychosocial'
		,7
		,N'CustomMHAssessmentCurrentHealthIssues'
		,N'CurrentHealthIssues'
		,'FROM #CustomDocumentMHAssessments CM where CM.DocumentVersionId =@DocumentVersionId AND CM.AdultOrChild= ''A'' AND CM.PsCurrentHealthIssues = ''Y'' and ISNULL(CM.RecordDeleted,''N'') = ''N'' 
		AND NOT EXISTS (select 1 from CustomMHAssessmentCurrentHealthIssues CA where CA.DocumentVersionId= @DocumentVersionId and ISNULL(CA.RecordDeleted,''N'') = ''N''  and CA.IsChecked=''Y'')
		AND NOT EXISTS (select 1 from CustomMHAssessmentPastHealthIssues CP where CP.DocumentVersionId= @DocumentVersionId and ISNULL(CP.RecordDeleted,''N'') = ''N''  and CP.IsChecked=''Y'')
		AND NOT EXISTS (select 1 from CustomMHAssessmentFamilyHistory CF where CF.DocumentVersionId= @DocumentVersionId and ISNULL(CF.RecordDeleted,''N'') = ''N''  and CF.IsChecked=''Y'')
		'
		,2
		,N'Psychosocial History - Atleast one checkbox selection is required'
		,null
		)
END

 IF NOT EXISTS ( SELECT *   FROM  DocumentValidations   WHERE  DocumentCodeId = @DocumentcodeId  and ErrorMessage = 'Are there any issues around current or past sexual behaviors is required')
 BEGIN
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentcodeId,Null,'Psychosocial','7',@TableName,'PsSexuality','FROM CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(PsSexuality,'''')=''''  AND (PsCurrentHealthIssues =''Y'' OR PsCurrentHealthIssues =''U'') ', 'Are there any issues around current or past sexual behaviors is required', 3,  'Are there any issues around current or past sexual behaviors is required')
END
 IF NOT EXISTS ( SELECT *   FROM  DocumentValidations   WHERE  DocumentCodeId = @DocumentcodeId  and ErrorMessage = 'Psychosocial History - are immunizations current is required')
 BEGIN
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentcodeId,Null,'Psychosocial','7',@TableName,'PsImmunizations','FROM CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(PsImmunizations,'''')=''''  ', 'Psychosocial History - are immunizations current is required ', 4,  'Psychosocial History - are immunizations current is required')
END
 IF NOT EXISTS ( SELECT *   FROM  DocumentValidations   WHERE  DocumentCodeId = @DocumentcodeId  and ErrorMessage = 'Psychosocial History - Comments textbox is required')
 BEGIN
    INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentcodeId,Null,'Psychosocial','7',@TableName,'PsCurrentHealthIssuesComment','FROM CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND ((AdultOrChild = ''A'' AND (PsCurrentHealthIssues = ''Y'' OR PsCurrentHealthIssues = ''U'')) OR (AdultOrChild = ''C'' AND (PsCurrentHealthIssues = ''N'' OR PsCurrentHealthIssues = ''U'' OR PsSexuality = ''N'' OR PsSexuality = ''U'' OR PsImmunizations = ''N'' OR PsImmunizations = ''U''))) and ISNULL(PsCurrentHealthIssuesComment,'''')=''''', 'Psychosocial History - Comments textbox is required', 5,  'Psychosocial History - Comments textbox is required')
END

 IF NOT EXISTS ( SELECT *   FROM  DocumentValidations   WHERE  DocumentCodeId = @DocumentcodeId  and ErrorMessage = 'Medications - List has been reviewed with client is required')
 BEGIN
  INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentcodeId,Null,'Psychosocial','7',@TableName,'PsMedicationsListToBeModified','FROM CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND PsMedications = ''L'' AND  ISNULL(PsMedicationsListToBeModified,'''')='''' ', 'Medications - List has been reviewed with client is required',6,'Medications - List has been reviewed with client is required')
END

 IF NOT EXISTS ( SELECT *   FROM  DocumentValidations   WHERE  DocumentCodeId = @DocumentcodeId  and ErrorMessage = 'Medications - Note efficacy of current and historical medications textbox is required')
 BEGIN
  INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('N',@DocumentcodeId,Null,'Psychosocial','7',@TableName,'PsMedicationsComment','FROM CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND PsCurrentHealthIssues IS NOT NULL AND ISNULL(PsMedicationsComment,'''')='''' ', 'Medications - Note efficacy of current and historical medications textbox is required', 7, 'Medications - Note efficacy of current and historical medications textbox is required')
END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Medications - Note efficacy of current and historical medications and their side effect textbox is required') 
BEGIN insert into DocumentValidations (Active,DocumentCodeId, DocumentType,TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder,ErrorMessage,RecordDeleted)
values('Y',@DocumentcodeId,NULL,'Psychosocial',7,@TableName,'PsMedicationsSideEffects','FROM CustomHRMAssessmentMedications CHAM INNER JOIN CustomDocumentMHAssessments CHA ON CHAM.DocumentVersionId=CHA.DocumentVersionId WHERE CHAM.DocumentVersionId=@DocumentVersionId AND ISNULL(CHAM.RecordDeleted,''N'') = ''N'' AND ISNULL(CHA.RecordDeleted,''N'') = ''N''   AND CHA.PsMedicationsSideEffects IS NULL AND CHA.PsMedications = ''L''','Medications - Note efficacy of current and historical medications and their side effect textbox is required',7,'Medications - Note efficacy of current and historical medications and their side effect textbox is required',NULL)  END


-------------- Functioning
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Functioning- Are there concerns with  language functioning is required')
BEGIN
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentcodeId,Null,'Psychosocial','7',@TableName,'PsLanguageFunctioning','FROM CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(PsLanguageFunctioning,'''')=''''  ', 'Functioning-Are there concerns with  language functioning is required', 8,  'Functioning- Are there concerns with  language functioning is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Functioning- Are there concerns with visual functioning is required')
BEGIN
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentcodeId,Null,'Psychosocial','7',@TableName,'PsVisualFunctioning','FROM CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(PsVisualFunctioning,'''')=''''  ', 'Functioning- Are there concerns with visual functioning is required', 9,  'Functioning- Are there concerns with visual functioning is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Functioning- Are there concerns with intellectual functioning is required')
BEGIN
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentcodeId,Null,'Psychosocial','7',@TableName,'PsIntellectualFunctioning','FROM CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(PsIntellectualFunctioning,'''')=''''  ', 'Functioning- Are there concerns with intellectual functioning is required', 10,  'Functioning- Are there concerns with intellectual functioning is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Functioning- Are there concerns with learning ability is required')
BEGIN
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentcodeId,Null,'Psychosocial','7',@TableName,'PsLearningAbility','FROM CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(PsLearningAbility,'''')=''''  ', 'Functioning- Are there concerns with learning ability is required', 11,  'Functioning- Are there concerns with learning ability is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'functioning –please address all of the above items that have been identified is required')
BEGIN
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentcodeId,Null,'Psychosocial','7',@TableName,'PsFunctioningConcernComment','FROM CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(PsFunctioningConcernComment,'''')=''''  AND (PsLanguageFunctioning =''Y'' OR PsVisualFunctioning =''Y'' OR PsIntellectualFunctioning =''Y'' OR PsLearningAbility =''Y'') ', 'functioning –please address all of the above items that have been identified is required', 12,  'functioning –please address all of the above items that have been identified is required')
END
-----------Developmental/Attachment History
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Developmental/Attachment History-Did mother receive prenatal care is required')
BEGIN
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentcodeId,Null,'Psychosocial','7',@TableName,'ReceivePrenatalCare','FROM CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(ReceivePrenatalCare,'''')=''''  ', 'Developmental/Attachment History-Did mother receive prenatal care is required', 13,  'Developmental/Attachment History-Did mother receive prenatal care is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Developmental/Attachment History-Were there any issues or problems during pregnancy  is required')
BEGIN
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentcodeId,Null,'Psychosocial','7',@TableName,'ProblemInPregnancy','FROM CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(ProblemInPregnancy,'''')=''''  ', 'Developmental/Attachment History-Were there any issues or problems during pregnancy  is required', 14,  'Developmental/Attachment History-Were there any issues or problems during pregnancy  is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Developmental/Attachment History- Prenatal exposer to substances  is required')
BEGIN
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentcodeId,Null,'Psychosocial','7',@TableName,'PrenatalExposer','FROM CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(PrenatalExposer,'''')=''''  ', 'Developmental/Attachment History- Prenatal exposer to substances  is required', 15,  'Developmental/Attachment History- Prenatal exposer to substances  is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Developmental/Attachment History-Where medications used during pregnancy  is required')
BEGIN
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentcodeId,Null,'Psychosocial','7',@TableName,'WhereMedicationUsed','FROM CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(WhereMedicationUsed,'''')=''''  ', 'Developmental/Attachment History-Where medications used during pregnancy  is required', 16,  'Developmental/Attachment History-Where medications used during pregnancy  is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Developmental/Attachment History-Where there any issues during delivery  is required')
BEGIN
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentcodeId,Null,'Psychosocial','7',@TableName,'IssueWithDelivery','FROM CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(IssueWithDelivery,'''')=''''  ', 'Developmental/Attachment History-Where there any issues during delivery  is required', 17,  'Developmental/Attachment History-Where there any issues during delivery  is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Developmental/Attachment History-Has the child met developmental milestones  is required')
BEGIN
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentcodeId,Null,'Psychosocial','7',@TableName,'ChildDevelopmentalMilestones','FROM CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(ChildDevelopmentalMilestones,'''')=''''  ', 'Developmental/Attachment History-Has the child met developmental milestones  is required', 18,  'Developmental/Attachment History-Has the child met developmental milestones  is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Development/Attachment History –please address all of the above items that have been identified is required')
BEGIN
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentcodeId,Null,'Psychosocial','7',@TableName,'DevelopmentalAttachmentComments','FROM CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(DevelopmentalAttachmentComments,'''')='''' AND (ReceivePrenatalCare =''Y'' OR ProblemInPregnancy =''Y'' OR PrenatalExposer =''Y'' OR WhereMedicationUsed =''Y'' OR IssueWithDelivery =''Y'' OR ChildDevelopmentalMilestones =''Y'')', 'Development/Attachment History –please address all of the above items that have been identified is required', 19,  'Development/Attachment History –please address all of the above items that have been identified is required')
END
--------------Family Functioning
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Family Functioning- Are there any parent/child relationship issues that are of concern  is required')
BEGIN
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentcodeId,Null,'Psychosocial','7',@TableName,'ParentChildRelationshipIssue','FROM CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(ParentChildRelationshipIssue,'''')=''''  ', 'Family Functioning- Are there any parent/child relationship issues that are of concern  is required', 20,  'Family Functioning- Are there any parent/child relationship issues that are of concern  is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Family Functioning-Are there current housing issues for the child  is required')
BEGIN
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentcodeId,Null,'Psychosocial','7',@TableName,'PsChildHousingIssues','FROM CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(PsChildHousingIssues,'''')=''''  ', 'Family Functioning-Are there current housing issues for the child  is required', 21,  'Family Functioning-Are there current housing issues for the child  is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Family Functioning-Are parents/guardians willing to participate in treatment  is required')
BEGIN
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentcodeId,Null,'Psychosocial','7',@TableName,'PsParentalParticipation','FROM CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(PsParentalParticipation,'''')=''''  ', 'Family Functioning-Are parents/guardians willing to participate in treatment  is required', 22,  'Family Functioning-Are parents/guardians willing to participate in treatment  is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Family Functioning-Are there any other family relationship issues that are of concerns  is required')
BEGIN
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentcodeId,Null,'Psychosocial','7',@TableName,'FamilyRelationshipIssues','FROM CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(FamilyRelationshipIssues,'''')=''''  ', 'Family Functioning-Are there any other family relationship issues that are of concerns  is required', 23,  'Family Functioning-Are there any other family relationship issues that are of concerns  is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Family Functioning-Family functioning textbox  is required')
BEGIN
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentcodeId,Null,'Psychosocial','7',@TableName,'PsFamilyConcernsComment','FROM CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(PsFamilyConcernsComment,'''')='''' AND (ParentChildRelationshipIssue =''Y'' OR PsChildHousingIssues =''Y'' OR FamilyRelationshipIssues =''Y'' OR PsParentalParticipation =''Y'')', 'Family Functioning-Family functioning textbox  is required ', 24,  'Family Functioning-Family functioning textbox  is required')
END
-- Client experienced or witnessed abuse or neglect
 IF NOT EXISTS ( SELECT *   FROM  DocumentValidations   WHERE  DocumentCodeId = @DocumentcodeId  and ErrorMessage = 'Client experienced or witnessed abuse or neglect - Radio button selection is required')
 BEGIN
  INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentcodeId,Null,'Psychosocial','7',@TableName,'PsClientAbuseIssues','FROM CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND PsClientAbuseIssues = ''Y''  AND ISNULL(PsClientAbuesIssuesComment,'''')='''' ', 'Client experienced or witnessed abuse or neglect - Radio button selection is required',25,'Client experienced or witnessed abuse or neglect - Radio button selection is required')
 END


 -- Mental health treatment history 
 IF NOT EXISTS ( SELECT *   FROM  DocumentValidations   WHERE  DocumentCodeId = @DocumentcodeId  and ErrorMessage = 'Mental health treatment history - Radio button selection is required')
 BEGIN
  INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentcodeId,Null,'Psychosocial','7',@TableName,'HistMentalHealthTx','FROM CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(HistMentalHealthTx,'''')='''' ', 'Mental health treatment history - Radio button selection is required',26,'Mental health treatment history - Radio button selection is required')
END

 IF NOT EXISTS ( SELECT *   FROM  DocumentValidations   WHERE  DocumentCodeId = @DocumentcodeId  and ErrorMessage = 'Mental health treatment history - Mental Health Treatment History textbox  is required')
 BEGIN
  INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentcodeId,Null,'Psychosocial','7',@TableName,'HistMentalHealthTxComment','FROM CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(HistMentalHealthTxComment,'''')='''' AND HistMentalHealthTx = ''Y'' AND AdultOrChild = ''C'' ', 'Mental health treatment history - Mental Health Treatment History textbox  is required',27,'Mental health treatment history - Mental Health Treatment History textbox  is required')
 END

 ---Are there cultural / ethnic issues that are of concern 
 IF NOT EXISTS ( SELECT *   FROM  DocumentValidations   WHERE  DocumentCodeId = @DocumentcodeId  and ErrorMessage = 'Are there cultural/ethinic issues that are of concerns – Radio button selection is required')
 BEGIN
   INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentcodeId,Null,'Psychosocial','7',@TableName,'PsCulturalEthnicIssues','FROM CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(PsCulturalEthnicIssues,'''')='''' ', 'Are there cultural/ethinic issues that are of concerns – Radio button selection is required',28,'Are there cultural/ethinic issues that are of concerns – Radio button selection is required')
 END

 IF NOT EXISTS ( SELECT *   FROM  DocumentValidations   WHERE  DocumentCodeId = @DocumentcodeId  and ErrorMessage = 'Are there cultural/ethnic issues - Comment textbox is required')
 BEGIN
  INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentcodeId,Null,'Psychosocial','7',@TableName,'PsCulturalEthnicIssuesComment','FROM CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND (PsCulturalEthnicIssues =''Y'' OR PsCulturalEthnicIssues = ''U'') AND ISNULL(PsCulturalEthnicIssuesComment,'''')='''' ', 'Are there cultural/ethnic issues - Comment textbox is required',29,'Are there cultural/ethnic issues - Comment textbox is required')
 END

 --- Educational Challenges/Barriers
 IF NOT EXISTS ( SELECT *   FROM  DocumentValidations   WHERE  DocumentCodeId = @DocumentcodeId  and ErrorMessage = 'Educational Challenges/Barriers - Education Status is required')
 BEGIN
  INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentcodeId,Null,'Psychosocial','7',@TableName,'AutisticallyImpaired','FROM CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(AutisticallyImpaired,''N'')=''N'' AND ISNULL(CognitivelyImpaired,''N'')=''N'' AND ISNULL(EmotionallyImpaired,''N'')=''N'' AND ISNULL(BehavioralConcern,''N'')=''N'' AND ISNULL(LearningDisabilities,''N'')=''N'' AND ISNULL(PhysicalImpaired,''N'')=''N'' AND ISNULL(IEP,''N'')=''N'' AND ISNULL(ChallengesBarrier,''N'')=''N''  ', 'Educational Challenges/Barriers - Education Status is required',30,'Educational Challenges/Barriers - Education Status is required')
END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Educational Challenges/Barriers - Educational Challenges/Barriers  textbox is required') 
BEGIN INSERT INTO DocumentValidations (Active,DocumentCodeId, DocumentType,TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder,ErrorMessage,RecordDeleted)
VALUES('Y',@DocumentcodeId,NULL,'Psychosocial',7,@TableName,'PsEducationComment','FROM CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND (AutisticallyImpaired=''Y'' OR CognitivelyImpaired=''Y'' OR EmotionallyImpaired=''Y'' OR BehavioralConcern=''Y'' OR LearningDisabilities=''Y'' OR PhysicalImpaired=''Y'' OR IEP=''Y'') AND PsEducationComment IS NULL','',31,'Educational Challenges/Barriers - Educational Challenges/Barriers  textbox is required',NULL)  END
--
--- Client is At risk of.
 IF NOT EXISTS ( SELECT *   FROM  DocumentValidations   WHERE  DocumentCodeId = @DocumentcodeId  and ErrorMessage = 'Client is at risk of - Dropdown is required')
 BEGIN
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentcodeId,Null,'Psychosocial','7',@TableName,'PsRiskLossOfPlacementDueTo','FROM CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND ((PsRiskLossOfPlacement = ''Y'' AND PsRiskLossOfPlacementDueTo IS NULL) OR
(PsRiskLossOfSupport = ''Y'' AND PsRiskLossOfSupportDueTo IS NULL) OR
(PsRiskExpulsionFromSchool = ''Y'' AND PsRiskExpulsionFromSchoolDueTo IS NULL) OR
(PsRiskHospitalization = ''Y'' AND PsRiskHospitalizationDueTo IS NULL) OR
(PsRiskCriminalJusticeSystem = ''Y'' AND PsRiskCriminalJusticeSystemDueTo IS NULL) OR
(PsRiskElopementFromHome = ''Y'' AND PsRiskElopementFromHomeDueTo IS NULL) OR
(PsRiskLossOfFinancialStatus = ''Y'' AND PsRiskLossOfFinancialStatusDueTo IS NULL))', 'Client is at risk of - Dropdown is required',32,'Client is at risk of - Dropdown is required')
 END





 


