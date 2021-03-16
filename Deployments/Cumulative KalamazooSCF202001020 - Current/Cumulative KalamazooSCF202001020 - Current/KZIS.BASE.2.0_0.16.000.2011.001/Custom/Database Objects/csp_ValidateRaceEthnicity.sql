IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateRaceEthnicity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateRaceEthnicity] 
GO
CREATE PROCEDURE [dbo].[csp_ValidateRaceEthnicity]  
	@DocumentVersionId INT    
AS
BEGIN

If NOT EXISTS(SELECT 1 FROM DocumentRegistrationClientEthnicities WHERE DocumentVersionId=@DocumentVersionId and isnull(RecordDeleted,'N')='N')
BEGIN
Insert into #validationReturnTable        
(TableName,        
ColumnName,        
ErrorMessage,        
TabOrder,        
ValidationOrder        
)values (    
'DocumentRegistrationClientEthnicities',    
'EthnicityId',    
'Demographics - Identifying Information – Ethnicity is required',    
2,    
1    
)   
END

IF NOT EXISTS(SELECT 1 FROM DocumentRegistrationClientRaces WHERE DocumentVersionId=@DocumentVersionId and isnull(RecordDeleted,'N')='N')
BEGIN
Insert into #validationReturnTable        
(TableName,        
ColumnName,        
ErrorMessage,        
TabOrder,        
ValidationOrder        
)values (    
'DocumentRegistrationClientRaces',    
'Race',    
'Demographics - Identifying Information – Race is required',    
2,    
1    
)   
END


If NOT EXISTS(SELECT 1 FROM DocumentRegistrationClientAddresses WHERE DocumentVersionId=@DocumentVersionId and isnull(RecordDeleted,'N')='N')
BEGIN
Insert into #validationReturnTable        
(TableName,        
ColumnName,        
ErrorMessage,        
TabOrder,        
ValidationOrder        
)values (    
'DocumentRegistrationClientAddresses',    
'Address',    
'General - Addresses – Address is required',    
1,    
2    
)   
END
END