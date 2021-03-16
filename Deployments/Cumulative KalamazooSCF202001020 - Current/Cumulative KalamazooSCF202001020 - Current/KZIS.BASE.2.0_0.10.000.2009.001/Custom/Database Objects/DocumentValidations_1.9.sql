/*
Insert script for Assessment - Document - Validation Messgae
Author :Jyothi 
Created Date : 25/05/2020
Purpose : What/Why : Validation scripts for Preplan and Disposition and additional Initial Tab   
*/



 DECLARE @DocumentcodeId VARCHAR(MAX)
 DECLARE @CODE VARCHAR(MAX)
 DECLARE @TableName VARCHAR (MAX) 
 DECLARE @TabName  VARCHAR (MAX) 
 DECLARE @TabOrder INT
 SET @CODE='69E559DD-1A4D-46D3-B91C-E89DA48E0038'

 
  SET @DocumentcodeId=(Select DocumentCodeId from DocumentCodes 
                      where Code=@CODE And Active='Y' AND
                       ISNULL(Recorddeleted,'N')='N')
   SET @TableName='CustomDocumentPrePlanningWorksheet'
   SET @TabName='Pre Plan'
   SET @TabOrder =19

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'IndividualName') 
BEGIN 
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'IndividualName','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(IndividualName,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','Pre-Planning Worksheet - Individual''s Name is required',1,'Pre-Planning Worksheet - Individual''s Name is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'DOB') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'DOB','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND  Assessmenttype!=''U'' and   isnull(DOB,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','Pre-Planning Worksheet - DOB is required',2,'Pre-Planning Worksheet - DOB is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'CaseNumber') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'CaseNumber','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(CaseNumber,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','Pre-Planning Worksheet - Case Number is required',3,'Pre-Planning Worksheet - Case Number is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'DateOfPrePlan') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'DateOfPrePlan','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(DateOfPrePlan,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','Pre-Planning Worksheet - Date of Pre-Plan is required',4,'Pre-Planning Worksheet - Date of Pre-Plan is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'DreamsAndDesires') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'DreamsAndDesires','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(DreamsAndDesires,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','Pre-Planning Worksheet - My dreams and desires for the future are textbox is required',5,'Pre-Planning Worksheet - My dreams and desires for the future are textbox is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'HowServicesCanHelp') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'HowServicesCanHelp','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(HowServicesCanHelp,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','Pre-Planning Worksheet - How services can help to get there textbox is required',6,'Pre-Planning Worksheet - How services can help to get there textbox is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'LivingArrangements') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'LivingArrangements','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(LivingArrangements,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','Areas I might want to work on - My living arrangements is required',7,'Areas I might want to work on - My living arrangements is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'LivingArragementsComment') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'LivingArragementsComment','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(LivingArragementsComment,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','Areas I might want to work on - My living arrangements textbox is required',8,'Areas I might want to work on - My living arrangements textbox is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'MyRelationships') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'MyRelationships','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(MyRelationships,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','Areas I might want to work on - My relationships is required',9,'Areas I might want to work on - My relationships is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'RelationshipsComment') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'RelationshipsComment','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(RelationshipsComment,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','Areas I might want to work on - My relationships textbox is required',10,'Areas I might want to work on - My relationships textbox is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'CommunityInvolvment') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'CommunityInvolvment','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(CommunityInvolvment,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','Areas I might want to work on - Community involvement / activities is required',11,'Areas I might want to work on - Community involvement / activities is required' )
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'CommunityComment') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'CommunityComment','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(CommunityComment,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','Areas I might want to work on - Community involvement / activities textbox is required',12,'Areas I might want to work on - Community involvement / activities textbox is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'Wellness') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'Wellness','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(Wellness,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','Areas I might want to work on - Wellness is required',13,'Areas I might want to work on - Wellness is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'WellnessComment') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'WellnessComment','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(WellnessComment,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','Areas I might want to work on - Wellness textbox is required',14,'Areas I might want to work on - Wellness textbox is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'Education') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'Education','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(Education,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','Areas I might want to work on - Education is required',15,'Areas I might want to work on - Education is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'EducationComment') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'EducationComment','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(EducationComment,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','Areas I might want to work on - Education textbox is required',16,'Areas I might want to work on - Education textbox is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'Employment') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'Employment','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(Employment,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','Areas I might want to work on - Employment is required',17,'Areas I might want to work on - Employment is required' )
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'EmploymentComment') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'EmploymentComment','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(EmploymentComment,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','Areas I might want to work on - Employment textbox required',18,'Areas I might want to work on - Employment textbox required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'Legal') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'Legal','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(Legal,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','Areas I might want to work on - Legal is required',19,'Areas I might want to work on - Legal is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'LegalComment') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'LegalComment','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(LegalComment,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','Areas I might want to work on - Legal textbox is required',20,'Areas I might want to work on - Legal textbox is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'Other') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'Other','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(Other,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','Areas I might want to work on - Other is required',21,'Areas I might want to work on - Other is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'OtherComment') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'OtherComment','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(OtherComment,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','Areas I might want to work on - Other textbox is required',22,'Areas I might want to work on - Other textbox is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'AdditionalComments1') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'AdditionalComments1','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(AdditionalComments1,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','Areas I might want to work on - Additional Comments textbox is required',23,'Areas I might want to work on - Additional Comments textbox is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'PrePlanProcessExplained') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'PrePlanProcessExplained','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(PrePlanProcessExplained,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','Service Planning Options - The Person/Family-Centered Planning Process was explained to me is required',24,'Service Planning Options - The Person/Family-Centered Planning Process was explained to me is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'SelfDExplained') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'SelfDExplained','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(SelfDExplained,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','Service Planning Options - Self-Determination (SD) options were explained to me is required',25,'Service Planning Options - Self-Determination (SD) options were explained to me is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'WantToExploreSelfD') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'WantToExploreSelfD','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(WantToExploreSelfD,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','Service Planning Options - I want to explore SD in my planning process is required',26,'Service Planning Options - I want to explore SD in my planning process is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'CommentsPCPOrSD') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'CommentsPCPOrSD','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(CommentsPCPOrSD,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','Service Planning Options - Comments about PCP and/or SD  textbox is required',27,'Service Planning Options - Comments about PCP and/or SD  textbox is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'ImportantToTalkAbout') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'ImportantToTalkAbout','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(ImportantToTalkAbout,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','At my Person/Family-Centered Planning meeting - It is important to me to talk about textbox is required',28,'At my Person/Family-Centered Planning meeting - It is important to me to talk about textbox is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'ImportantToNotTalkAbout') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'ImportantToNotTalkAbout','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(ImportantToNotTalkAbout,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','At my Person/Family-Centered Planning meeting - It is important to me we NOT talk about textbox is required',29,'At my Person/Family-Centered Planning meeting - It is important to me we NOT talk about textbox is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'WHSIssuesToTalkAbout') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'WHSIssuesToTalkAbout','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(WHSIssuesToTalkAbout,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','At my Person/Family-Centered Planning meeting - Wellness, Health, and Safety issues I would like to talk about textbox is required',30,'At my Person/Family-Centered Planning meeting - Wellness, Health, and Safety issues I would like to talk about textbox is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'ServicesToDiscussAtMeeting') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'ServicesToDiscussAtMeeting','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(ServicesToDiscussAtMeeting,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','At my Person/Family-Centered Planning meeting - The Customer Handbook was reviewed with me including covered services textbox is required',31,'At my Person/Family-Centered Planning meeting - The Customer Handbook was reviewed with me including covered services textbox is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'ServiceProviderOptions') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'ServiceProviderOptions','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(ServiceProviderOptions,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','At my Person/Family-Centered Planning meeting - I was provided information from the Provider Directory about different options of Providers for covered services textbox is required',32,'At my Person/Family-Centered Planning meeting - I was provided information from the Provider Directory about different options of Providers for covered services textbox is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'PeopleInvitedToMeeting') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'PeopleInvitedToMeeting','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(PeopleInvitedToMeeting,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','At my Person/Family-Centered Planning meeting - I would like to invite these people to my planning meeting textbox is required',33,'At my Person/Family-Centered Planning meeting - I would like to invite these people to my planning meeting textbox is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'PeopleNotInivtedToMeeting') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'PeopleNotInivtedToMeeting','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(PeopleNotInivtedToMeeting,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','At my Person/Family-Centered Planning meeting - I do not want these people at my planning meeting textbox is required',34,'At my Person/Family-Centered Planning meeting - I do not want these people at my planning meeting textbox is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'MeetingLocation') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'MeetingLocation','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(MeetingLocation,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','At my Person/Family-Centered Planning meeting - I would like my planning meeting to be held at Location is required',35,'At my Person/Family-Centered Planning meeting - I would like my planning meeting to be held at Location is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'MeetingDate') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'MeetingDate','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(MeetingDate,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','At my Person/Family-Centered Planning meeting - I would like my planning meeting to be held on Date is required',36,'At my Person/Family-Centered Planning meeting - I would like my planning meeting to be held on Date is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'MeetingTime') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'MeetingTime','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(MeetingTime,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','At my Person/Family-Centered Planning meeting - I would like my planning meeting to be held at Time is required',37,'At my Person/Family-Centered Planning meeting - I would like my planning meeting to be held at Time is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'UnderstandPersonOfChoice') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'UnderstandPersonOfChoice','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(UnderstandPersonOfChoice,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','At my Person/Family-Centered Planning meeting - I understand that I may have a person of my choice help run my planning meeting is required',38,'At my Person/Family-Centered Planning meeting - I understand that I may have a person of my choice help run my planning meeting is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'OIFExplained') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'OIFExplained','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(OIFExplained,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','At my Person/Family-Centered Planning meeting - Outside independent Facilitation was clearly explained to me is required',39,'At my Person/Family-Centered Planning meeting - Outside independent Facilitation was clearly explained to me is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'HelpRunMeeting') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'HelpRunMeeting','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(HelpRunMeeting,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','At my Person/Family-Centered Planning meeting - Name of the person who helped to run planning meeting is required',40,'At my Person/Family-Centered Planning meeting - Name of the person who helped to run planning meeting is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'TakeNotesMeeting') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'TakeNotesMeeting','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(TakeNotesMeeting,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','At my Person/Family-Centered Planning meeting - Name of the person who helped to write written notes  is required is required',41,'At my Person/Family-Centered Planning meeting - Name of the person who helped to write written notes  is required is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'ChoseNotToParticipate') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'ChoseNotToParticipate','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(ChoseNotToParticipate,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','At my Person/Family-Centered Planning meeting - Individual/Legal Guardian chose not to participate in the Pre-Planning process via this format checkbox is required',42,'At my Person/Family-Centered Planning meeting - Individual/Legal Guardian chose not to participate in the Pre-Planning process via this format checkbox is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'AlternativeManner') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'AlternativeManner','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(AlternativeManner,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','At my Person/Family-Centered Planning meeting - Individual/Legal Guardian chose not to participate in the Pre-Planning process via this format textbox is required',43,'At my Person/Family-Centered Planning meeting - Individual/Legal Guardian chose not to participate in the Pre-Planning process via this format textbox is required')
END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ColumnName= 'AdditionalComments2') 
BEGIN
INSERT INTO [documentvalidations] ( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])VALUES('Y',@DocumentcodeId,NULL, @TabName,@TabOrder,@TableName,'AdditionalComments2','FROM  CustomDocumentPrePlanningWorksheet CPW  inner join CustomDocumentMHAssessments CDHA  on CPW.DocumentVersionId=CDHA.DocumentVersionId  where  ISNULL(SeparateDocumentRequired,''N'')=''N'' AND Assessmenttype!=''U'' and   isnull(AdditionalComments2,'''')=''''  and  CPW.DocumentVersionId=@DocumentVersionId','At my Person/Family-Centered Planning meeting - Additional Comments is required',44,'At my Person/Family-Centered Planning meeting - Additional Comments is required')
END


---- VAlidation for Disposition  --
 SET @TabOrder =18
 IF NOT EXISTS ( SELECT *  FROM DocumentValidations WHERE  DocumentCodeId = @DocumentcodeId  and Columnname = 'Disposition')
BEGIN
 INSERT INTO DocumentValidations (Active,DocumentCodeId,DocumentType,TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder,ErrorMessage ) values
  ('Y',@DocumentcodeId,NULL,NULL,18,'customdispositions','Disposition','From customdispositions   where DocumentVersionId = @DocumentVersionId  and   Disposition IS NULL','Disposition - Disposition is required.',1,'Disposition - Disposition is required.') 

 END

