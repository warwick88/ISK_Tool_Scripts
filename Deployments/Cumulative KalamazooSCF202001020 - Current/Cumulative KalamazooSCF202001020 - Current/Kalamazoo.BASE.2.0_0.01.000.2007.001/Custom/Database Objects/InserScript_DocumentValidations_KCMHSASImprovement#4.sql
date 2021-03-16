/****************************************************************************************
Author : Vinay K S
Purpose: To fix the issues for the task KCMHSAS - Improvement#4 
****************************************************************************************/

DECLARE @DocumentCodeId INT
DECLARE @DocumentCode VARCHAR(100) 

SET @DocumentCode = 'BDE62873-41E5-4842-AB04-C7E4D6D32C8D'
SET @DocumentCodeId = (SELECT Top 1 DocumentCodeId FROM DocumentCodes WHERE Code = @DocumentCode)

Delete from DocumentValidations  where DocumentCodeId = @DocumentCodeId and TableName='DocumentRegistrationDemographics' and ColumnName='CountyOfTreatmentText'

Delete from DocumentValidations  where DocumentCodeId = @DocumentCodeId and TableName='DocumentRegistrationDemographics' and ColumnName='CountyOfResidenceText'
Delete from DocumentValidations  where DocumentCodeId = @DocumentCodeId and TableName='DocumentRegistrationClientEthnicities' and ColumnName='EthnicityId' 

Delete from DocumentValidations  where DocumentCodeId = @DocumentCodeId and TableName='DocumentRegistrationClientRaces' and ColumnName='RaceId'

If Not EXISTS(SELECT 1 from DocumentValidations where DocumentCodeId = @DocumentCodeId and TableName='DocumentRegistrationDemographics' and ColumnName='CountyOfResidence' )
Begin
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values
('Y',@DocumentCodeId,Null,'Demographics','2','DocumentRegistrationDemographics','CountyOfResidence','FROM DocumentRegistrationDemographics WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(CountyOfResidence,'''')='''' ', 'Living Arrangement – County of Residence is required',1,'Living Arrangement – County of Residence is required')
END

If Not EXISTS(SELECT 1 from DocumentValidations where DocumentCodeId = @DocumentCodeId and TableName='DocumentRegistrationDemographics' and ColumnName='CountyOfTreatment' )
Begin
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values
('Y',@DocumentCodeId,Null,'Demographics','2','DocumentRegistrationDemographics','CountyOfTreatment','FROM DocumentRegistrationDemographics WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(CountyOfTreatment,'''')='''' ', 'Living Arrangement – County of Financial Responsibility is required',1,'Living Arrangement – County of Financial Responsibility is required')
END

