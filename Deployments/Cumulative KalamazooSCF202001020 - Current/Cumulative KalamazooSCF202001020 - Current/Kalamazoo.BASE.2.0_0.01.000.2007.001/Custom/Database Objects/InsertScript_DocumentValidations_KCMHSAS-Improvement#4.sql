/**********************************************************************************************
Purpose : AS per the task adding validations to Registration Document.
Author : Vinay K S
***********************************************************************************************/

DECLARE @DocumentCodeId INT
DECLARE @DocumentCode VARCHAR(100)

SET @DocumentCode = 'BDE62873-41E5-4842-AB04-C7E4D6D32C8D'
SET @DocumentCodeId = (SELECT Top 1 DocumentCodeId FROM DocumentCodes WHERE Code = @DocumentCode)

If Not EXISTS(SELECT 1 from DocumentValidations where DocumentCodeId = @DocumentCodeId and TableName='DocumentRegistrationClientAddresses' and ColumnName='ClientAddress' )
Begin
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentCodeId,Null,'General','1','DocumentRegistrationClientAddresses','ClientAddress','FROM DocumentRegistrationClientAddresses WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(ClientAddress,'''')='''' ', 'Addresses – Address is required',1,'Addresses – Address is required')
END
-----------------------------------------------------------------------------------------------------

If Not EXISTS(SELECT 1 from DocumentValidations where DocumentCodeId = @DocumentCodeId and TableName='DocumentRegistrationDemographics' and ColumnName='Sex' )
Begin
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values
('Y',@DocumentCodeId,Null,'Demographics','2','DocumentRegistrationDemographics','Sex','FROM DocumentRegistrationDemographics WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Sex,'''')='''' ', 'Identifying Information – Sex is required',1,'Identifying Information – Sex is required')
END

If Not EXISTS(SELECT 1 from DocumentValidations where DocumentCodeId = @DocumentCodeId and TableName='DocumentRegistrationClientEthnicities' and ColumnName='EthnicityId' )
Begin
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values
('Y',@DocumentCodeId,Null,'Demographics','2','DocumentRegistrationClientEthnicities','EthnicityId','FROM DocumentRegistrationClientEthnicities WHERE DocumentVersionId=@DocumentVersionId', 'Identifying Information – Ethnicity is required',1,'Identifying Information – Ethnicity is required')
END	

If Not EXISTS(SELECT 1 from DocumentValidations where DocumentCodeId = @DocumentCodeId and TableName='DocumentRegistrationClientRaces' and ColumnName='RaceId' )
Begin
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values
('Y',@DocumentCodeId,Null,'Demographics','2','DocumentRegistrationClientRaces','RaceId','FROM DocumentRegistrationClientRaces WHERE DocumentVersionId=@DocumentVersionId', 'Identifying Information – Race is required',1,'Identifying Information – Race is required')
END

If Not EXISTS(SELECT 1 from DocumentValidations where DocumentCodeId = @DocumentCodeId and TableName='DocumentRegistrationDemographics' and ColumnName='ExternalReferralProviderId' )
Begin
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values
('Y',@DocumentCodeId,Null,'Demographics','2','DocumentRegistrationDemographics','ExternalReferralProviderId','FROM DocumentRegistrationDemographics WHERE DocumentVersionId=@DocumentVersionId AND (ISNULL(ExternalReferralProviderId,'''')='''' AND ISNULL(ClientDoesNotHavePCP,''N'')=''N'')', 'Primary Care Physician – Primary Care Physician is required or Client does not have PCP checkbox need to be checked',1,'Primary Care Physician – Primary Care Physician is required or Client does not have PCP checkbox need to be checked')
END

If Not EXISTS(SELECT 1 from DocumentValidations where DocumentCodeId = @DocumentCodeId and TableName='DocumentRegistrationDemographics' and ColumnName='NumberOfDependents' )
Begin
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values
('Y',@DocumentCodeId,Null,'Demographics','2','DocumentRegistrationDemographics','NumberOfDependents','FROM DocumentRegistrationDemographics WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(NumberOfDependents,'''')='''' ', 'Financial Information – # of Dependents is required',1,'Financial Information – # of Dependents is required')
END

--If Not EXISTS(SELECT 1 from DocumentValidations where DocumentCodeId = @DocumentCodeId and TableName='DocumentRegistrationDemographics' and ColumnName='CountyOfResidenceText' )
--Begin
--INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values
--('Y',@DocumentCodeId,Null,'Demographics','2','DocumentRegistrationDemographics','CountyOfResidenceText','FROM DocumentRegistrationDemographics WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(CountyOfResidenceText,'''')='''' ', 'Living Arrangement – County of Residence is required',1,'Living Arrangement – County of Residence is required')
--END

--If Not EXISTS(SELECT 1 from DocumentValidations where DocumentCodeId = @DocumentCodeId and TableName='DocumentRegistrationDemographics' and ColumnName='CountyOfTreatmentText' )
--Begin
--INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values
--('Y',@DocumentCodeId,Null,'Demographics','2','DocumentRegistrationDemographics','CountyOfTreatmentText','FROM DocumentRegistrationDemographics WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(CountyOfTreatmentText,'''')='''' ', 'Living Arrangement – County of Financial Responsibility is required',1,'Living Arrangement – County of Financial Responsibility is required')
--END

If Not EXISTS(SELECT 1 from DocumentValidations where DocumentCodeId = @DocumentCodeId and TableName='DocumentRegistrationDemographics' and ColumnName='PrimaryLanguage' )
Begin
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values
('Y',@DocumentCodeId,Null,'Demographics','2','DocumentRegistrationDemographics','PrimaryLanguage','FROM DocumentRegistrationDemographics WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(PrimaryLanguage,'''')='''' ', 'Language – Primary/Preferred Language is required',1,'Language – Primary/Preferred Language is required')
END


If EXISTS(SELECT 1 from DocumentValidations where DocumentCodeId = @DocumentCodeId and TableName='DocumentRegistrationAdditionalInformations' and ColumnName='EducationStatus' )
BEGIN
	update DocumentValidations set RecordDeleted='Y'
	Where DocumentCodeId = @DocumentCodeId and TableName='DocumentRegistrationAdditionalInformations' and ColumnName='EducationStatus'
END

If EXISTS(SELECT 1 from DocumentValidations where DocumentCodeId = @DocumentCodeId and TableName='DocumentRegistrationAdditionalInformations' and ColumnName='LivingArrangments' )
BEGIN
	update DocumentValidations set RecordDeleted='Y'
	Where DocumentCodeId = @DocumentCodeId and TableName='DocumentRegistrationAdditionalInformations' and ColumnName='LivingArrangments'
END

If EXISTS(SELECT 1 from DocumentValidations where DocumentCodeId = @DocumentCodeId and TableName='DocumentRegistrationAdditionalInformations' and ColumnName='EmploymentStatus' )
BEGIN
	update DocumentValidations set RecordDeleted='Y'
	Where DocumentCodeId = @DocumentCodeId and TableName='DocumentRegistrationAdditionalInformations' and ColumnName='EmploymentStatus'
END

If EXISTS(SELECT 1 from DocumentValidations where DocumentCodeId = @DocumentCodeId and TableName='DocumentRegistrationAdditionalInformations' and ColumnName='SmokingStatus' )
BEGIN
	update DocumentValidations set RecordDeleted='Y'
	Where DocumentCodeId = @DocumentCodeId and TableName='DocumentRegistrationAdditionalInformations' and ColumnName='SmokingStatus'
END

If EXISTS(SELECT 1 from DocumentValidations where DocumentCodeId = @DocumentCodeId and TableName='DocumentRegistrationAdditionalInformations' and ColumnName='SmokingStatus' )
BEGIN
	update DocumentValidations set RecordDeleted='Y'
	Where DocumentCodeId = @DocumentCodeId and TableName='DocumentRegistrationAdditionalInformations' and ColumnName='SmokingStatus'
END


If Not EXISTS(SELECT 1 from DocumentValidations where DocumentCodeId = @DocumentCodeId and TableName='DocumentRegistrationAdditionalInformations' and ColumnName='Religion' )
Begin
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentCodeId,Null,'Additional Information','4','DocumentRegistrationAdditionalInformations','Religion','FROM DocumentRegistrationAdditionalInformations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Religion,'''')='''' ', 'Additional Information – Religion is required',1,'Additional Information – Religion is required')
END

If Not EXISTS(SELECT 1 from DocumentValidations where DocumentCodeId = @DocumentCodeId and TableName='DocumentRegistrationAdditionalInformations' and ColumnName='NumberOfArrestsLast30Days' )
Begin
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentCodeId,Null,'Additional Information','4','DocumentRegistrationAdditionalInformations','NumberOfArrestsLast30Days','FROM DocumentRegistrationAdditionalInformations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Religion,'''')='''' ', 'Additional Information – # of ArrestsLast in last 30 Days is required',1,'Additional Information – # of ArrestsLast in last 30 Days is required')
END
