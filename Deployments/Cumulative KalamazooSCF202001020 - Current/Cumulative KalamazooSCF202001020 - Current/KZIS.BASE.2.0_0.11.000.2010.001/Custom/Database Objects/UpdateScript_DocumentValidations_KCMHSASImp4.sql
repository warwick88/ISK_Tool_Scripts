/***************************************************************
Author : Vinay K S
Purpose: To fix the issue reported on Registration Document Validation
***************************************************************/

DECLARE @DocumentCodeId INT
DECLARE @DocumentCode VARCHAR(100)

SET @DocumentCode = 'BDE62873-41E5-4842-AB04-C7E4D6D32C8D'
SET @DocumentCodeId = (SELECT Top 1 DocumentCodeId FROM DocumentCodes WHERE Code = @DocumentCode)

update DocumentValidations set ValidationLogic='FROM DocumentRegistrationAdditionalInformations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(NumberOfArrestsLast30Days,-1)=-1' where DocumentCodeId = @DocumentCodeId and TableName='DocumentRegistrationAdditionalInformations' and ColumnName='NumberOfArrestsLast30Days'


update DocumentValidations set ValidationLogic= 'FROM DocumentRegistrationDemographics WHERE 
DocumentVersionId=@DocumentVersionId AND ISNULL(NumberOfDependents,-1)=-1' 
where DocumentCodeId = @DocumentCodeId and TableName='DocumentRegistrationDemographics' and ColumnName='NumberOfDependents'