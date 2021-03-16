  -- Updating the formitem datatype
  DECLARE @FormID INT
  DECLARE @FormSectionID INT
  DECLARE @GlobalcodeiDTIME INT
  DECLARE @FormSectionGroupid INT

  SET @FormID=(select FormID from forms where formguid='2C489D56-66EF-4C48-939C-501A5449D387')
  SET @FormSectionID=( select FormSectionID from formsections where FormId=@FormID  and SectionLabel='Pre-Planning Worksheet')
 
   IF EXISTS(select 1 from FormSectionGroups where FormSectionId=@FormSectionId  AND GroupLabel IS NULL  AND Active='Y')
  BEGIN
  SET @FormSectionGroupid =(select FormSectionGroupid from FormSectionGroups where FormSectionId=@FormSectionId AND GroupLabel IS NULL  AND Active='Y')
  
 
 IF NOT EXISTS(SELECT 1 FROM Formitems where ItemColumnName='SeparateDocumentRequired' AND Active='Y' AND formsectionid=@FormSectionID  )
 BEGIN
  INSERT INTO  Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
        VALUES  (   @FormSectionID, @FormSectionGroupid,'5362','Separate preplanning document to be completed prior to treatment planning', 0, 'Y', NULL, 'SeparateDocumentRequired','N', NULL,NULL, NULL, NULL,NULL,  NULL, NULL, NULL, NULL, NULL ) 
  INSERT INTO    Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
        VALUES (@FormSectionID, @FormSectionGroupid,  '5374','', 1, 'Y', NULL, NULL,'N', NULL, NULL,NULL,NULL,NULL,NULL, NULL,NULL, NULL,NULL )
  END
  IF EXISTS(SELECT 1 FROM Formitems where  Active='Y' AND formsectionid=@FormSectionID AND ItemLabel='Individual''s Name:')
  BEGIN 
  UPDATE Formitems set Sortorder=2 where Active='Y' AND formsectionid=@FormSectionID AND ItemLabel='Individual''s Name:'
  END
  IF EXISTS(SELECT 1 FROM Formitems where  Active='Y' AND formsectionid=@FormSectionID AND ItemLabel='DOB:')
  BEGIN 
  UPDATE Formitems set Sortorder=3 where Active='Y' AND formsectionid=@FormSectionID AND ItemLabel='DOB:'
  END
  IF EXISTS(SELECT 1 FROM Formitems where  Active='Y' AND formsectionid=@FormSectionID AND ItemColumnName='IndividualName')
  BEGIN 
  UPDATE Formitems set Sortorder=4 where Active='Y' AND formsectionid=@FormSectionID  AND ItemColumnName='IndividualName'
  END
  IF EXISTS(SELECT 1 FROM Formitems where  Active='Y' AND formsectionid=@FormSectionID AND ItemColumnName='DOB')
  BEGIN 
  UPDATE Formitems set Sortorder=5 where Active='Y' AND formsectionid=@FormSectionID AND ItemColumnName='DOB'
  END
  IF EXISTS(SELECT 1 FROM Formitems where  Active='Y' AND formsectionid=@FormSectionID AND ItemLabel='Case Number:')
  BEGIN 
  UPDATE Formitems set Sortorder=6 where Active='Y' AND formsectionid=@FormSectionID AND ItemLabel='Case Number:'
  END
  IF EXISTS(SELECT 1 FROM Formitems where  Active='Y' AND formsectionid=@FormSectionID AND ItemLabel='Date of Pre-Plan:')
  BEGIN 
  UPDATE Formitems set Sortorder=7 where Active='Y' AND formsectionid=@FormSectionID AND ItemLabel='Date of Pre-Plan:'
  END
  IF EXISTS(SELECT 1 FROM Formitems where  Active='Y' AND formsectionid=@FormSectionID AND ItemColumnName='CaseNumber')
  BEGIN 
  UPDATE Formitems set Sortorder=8 where Active='Y' AND formsectionid=@FormSectionID AND ItemColumnName='CaseNumber'
  END
  IF EXISTS(SELECT 1 FROM Formitems where  Active='Y' AND formsectionid=@FormSectionID AND ItemColumnName='DateOfPrePlan')
  BEGIN 
  UPDATE Formitems set Sortorder=9 where Active='Y' AND formsectionid=@FormSectionID AND ItemColumnName='DateOfPrePlan'
  END
 
END

  SET @FormSectionID=( select FormSectionID from formsections where FormId=@FormID  and SectionLabel='At my Person/Family-Centered Planning meeting:')
  SET @GlobalcodeiDTIME =(select Globalcodeid from globalcodes where Category='FORMFIELDTYPE' and CodeName='Time')

  IF EXISTS(select FormItemId,* from formitems where  ItemColumnName='MeetingTime' and FormSectionId=@FormSectionID)
  BEGIN
  UPDATE formitems set ItemType=@GlobalcodeiDTIME where  ItemColumnName='MeetingTime' and FormSectionId=@FormSectionID
  END