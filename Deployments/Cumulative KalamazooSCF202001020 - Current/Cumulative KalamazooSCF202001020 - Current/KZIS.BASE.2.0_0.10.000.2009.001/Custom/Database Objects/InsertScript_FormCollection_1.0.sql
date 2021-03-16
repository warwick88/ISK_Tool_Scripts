 DECLARE  @FormID INT
 DECLARE @FormCollectionId INT
 DECLARE @FormGUID VARCHAR(100)
 SET @FormGUID ='1ACAF7C6-1084-47D5-BC87-D35D45147228' 
     
SET @FormID=(select formid from forms where  FormGUID =@FormGUID) 
/*-------FormCollections Start-------*/
IF NOT EXISTS (SELECT  formid FROM FormCollectionForms  WHERE formid = @FormID AND (ISNULL(RecordDeleted,'N')<>'Y'))
BEGIN 
  INSERT INTO FormCollections(NumberOfForms) values(1) 
  SET @FormCollectionId = @@IDENTITY
   END
/*-------FormCollections End-------*/                      
       
/*-------FormCollectionForms Start-------*/
IF NOT EXISTS (SELECT Top 1 FormID FROM FormCollectionForms WHERE FormID  = @FormID AND (ISNULL(RecordDeleted,'N')<>'Y')) 
BEGIN 
 INSERT INTO FormCollectionForms(FormCollectionId, FormId, Active, FormOrder) values(@FormCollectionId,@FormID, 'Y', 1) 
END
  
