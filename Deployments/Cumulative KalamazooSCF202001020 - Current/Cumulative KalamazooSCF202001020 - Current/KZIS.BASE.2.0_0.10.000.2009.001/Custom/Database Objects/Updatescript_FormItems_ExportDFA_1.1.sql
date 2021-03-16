--Date : 01/03/2020
--Purpose: Update script for adding a label to the Mental Status Exam DFA screen. Gold #22

DECLARE @FormId int
DECLARE @FormSectionId int
DECLARE @FormSectionGroupId int
SET @FormId = (SELECT TOP 1 FormId FROM Forms where FormGUID='1ACAF7C6-1084-47D5-BC87-D35D45147228') 
SET @FormSectionId =( SELECT TOP 1 FormSectionId FROM FormSections where FormId=@FormId and Active='Y' and SectionLabel='<b>Thought Content and Process; Cognition</b>')
SET @FormSectionGroupId = (SELECT TOP 1 FormSectionGroupId FROM FormSectionGroups where FormSectionId=@FormSectionId and SortOrder=1 and Active='Y')

IF NOT EXISTS (SELECT * FROM Formitems WHERE FormSectionId=@FormSectionId AND ItemLabel='<span style="height:2px"> </span>')
BEGIN
INSERT INTO Formitems (
	formsectionid, 
	FormSectionGroupId, 
	ItemType, 
	ItemLabel, 
	SortOrder, 
	active, 
	GlobalCodeCategory, 
	ItemColumnName, 
	ItemRequiresComment,
	ItemCommentColumnName, 
	ItemWidth, 
	MaximumLength, 
	DropdownType, 
	SharedTableName, 
	StoredProcedureName, 
	ValueField, 
	TextField, 
	MultilineEditFieldHeight,
	EachRadioButtonOnNewLine )
VALUES(
   @FormSectionId,
   @FormSectionGroupId,
   '5374',
   '<span style="height:2px"> </span>',
   2,
   'Y',NULL,NULL,'N',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
 END 
  
 IF NOT EXISTS (SELECT * FROM Formitems WHERE FormSectionId=@FormSectionId AND ItemLabel='Thought Process Abnormalities (leave unchecked if not present)')
BEGIN
 INSERT INTO Formitems (
	formsectionid, 
	FormSectionGroupId, 
	ItemType, 
	ItemLabel, 
	SortOrder, 
	active, 
	GlobalCodeCategory, 
	ItemColumnName, 
	ItemRequiresComment, 
	ItemCommentColumnName, 
	ItemWidth, 
	MaximumLength, 
	DropdownType, 
	SharedTableName, 
	StoredProcedureName, 
	ValueField, 
	TextField, 
	MultilineEditFieldHeight, 
	EachRadioButtonOnNewLine) 
VALUES(
	@FormSectionId,
    @FormSectionGroupId,
	'5374',
	'Thought Process Abnormalities (leave unchecked if not present)',
	3,
	'Y',NULL,NULL,'N',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)  
END

--- Modified The flied of the column "MemoryImmediateEvidencedBy" from "Textbox" to "Integer"

DECLARE @FormItemId int
SET @FormItemId =(SELECT TOP 1 FormItemId FROM FormItems WHERE ItemColumnName='MemoryImmediateEvidencedBy' AND Active='Y')

IF EXISTS (SELECT 1 FROM FormItems WHERE ItemColumnName='MemoryImmediateEvidencedBy' AND Active='Y')
BEGIN
UPDATE FormItems SET ItemType=5366 WHERE FormItemId=@FormItemId
END

