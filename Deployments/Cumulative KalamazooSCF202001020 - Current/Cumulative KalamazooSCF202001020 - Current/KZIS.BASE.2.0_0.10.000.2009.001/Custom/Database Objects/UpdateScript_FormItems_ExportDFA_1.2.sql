--Date : 01/27/2020
--Purporse: update script for modifiying the textbox into textarea in Mental status exam document. Gold #22

DECLARE @FormSectionId int
DECLARE @FormId int
SET @FormId =(SELECT TOP 1 FormId FROM Forms where FormGUID='1ACAF7C6-1084-47D5-BC87-D35D45147228')
SET @FormSectionId = (SELECT TOP 1 FormSectionId FROM  FormSections where FormId=@FormId 
AND SectionLabel='<b> Mental status exam additional comments, Descriptions</b>')

IF EXISTS (SELECT 1 FROM FormItems where FormSectionId= @FormSectionId)
BEGIN
Update FormItems SET ItemType=5363,MultilineEditFieldHeight=NULL where FormSectionId= @FormSectionId
END

