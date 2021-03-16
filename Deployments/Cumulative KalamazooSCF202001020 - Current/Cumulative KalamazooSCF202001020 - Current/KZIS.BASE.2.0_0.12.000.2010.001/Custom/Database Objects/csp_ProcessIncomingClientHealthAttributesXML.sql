IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE type = 'P'
			AND name = 'csp_ProcessIncomingClientHealthAttributesXML'
		)
	DROP PROCEDURE csp_ProcessIncomingClientHealthAttributesXML
GO  

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO                         
CREATE PROCEDURE [dbo].[csp_ProcessIncomingClientHealthAttributesXML]                                                                 
    @DeImportMessageDetailId int                     
                                                     
AS                                                                
/********************************************************************************                                                                                                                    
  -- Stored Procedure: [ssp_InsertUpdateClientHealthAttributes]                                                                       
  --  EXEC [csp_ProcessIncomingClientHealthAttributesXML] 7404                                                                
  -- Copyright: Streamline Healthcate Solutions                                                                       
  --                                                                       
  -- Purpose: To insert client health attributes                                                                       
  --                                                                       
  -- Updates:                                                                                                                                                             
  -- Date           Author                Purpose                                                                                                          
  -- 13 APR 2020    RAVINDRA SINGH        insert client health attributes  .                                                                        
                                                                  
  *********************************************************************************/                                                                
BEGIN                                                                
 BEGIN TRY                                                                 
                                                                 
 DECLARE @xmlData XML                                                                 
 DECLARE @XML AS XML, @hDoc AS INT                                                                 
 DECLARE @ClientId AS int                                                 
 DECLARE @ClientIdText AS varchar(100)                                                                
 DECLARE @FirstName AS varchar(100)                                                             
 DECLARE @LastName AS varchar(100)                                                                
 DECLARE @SSN AS varchar(100)                                                  
 DECLARE @DOB AS datetime                                                          
 DECLARE @ClientHealthDataAttributeId AS int                                                             
 DECLARE @Command AS varchar(50)                                                             
 DECLARE @CreatedBy AS varchar(30)                                                             
 DECLARE @CreatedDate AS datetime                                                            
 DECLARE @ModifiedBy AS varchar(30)                                                             
 DECLARE @ModifiedDate AS datetime                                                              
 DECLARE @HealthDataAttributeId AS int                   
 DECLARE @Name AS varchar(250)                                                            
 DECLARE @Value AS varchar(200)                                                             
 DECLARE @HealthRecordDate AS datetime                                                             
 DECLARE @HealthDataSubTemplateId AS int                                                             
 DECLARE @SubTemplateCompleted AS char(1)                                                               
 DECLARE @HealthDataTemplateId AS int       
 DECLARE @Flag AS varchar(10)               
 DECLARE @Range AS varchar(250)                     
 DECLARE @IsCorrected AS char(1)                        
 DECLARE @Comments AS varchar(max)                         
 DECLARE @ResultStatus AS int                 
 DECLARE @Locked AS char(1)                                                             
 DECLARE @LockedBy AS varchar(30)                                                             
 DECLARE @LockedDate AS datetime                     
 DECLARE @CurrentClientHealthDataAttributeId AS INT                                                              
                                                             
select @xmlData =messagedetail from deimportmessagedetails where deimportmessagedetailid= @DeImportMessageDetailId                                                          
                                                                             
create table #Temp                                                            
(                                                            
 ClientId [varchar](100)                                                              
,FirstName [varchar](100)                                                             
,LastName [varchar](100)                                                                
,SSN[varchar](100)                                                
,DOB [datetime]                                                           
,ClientHealthDataAttributeId [int]                                                               
,CreatedBy [varchar](30)                                                             
,CreatedDate [datetime]                                       
,ModifiedBy [varchar](30)                                                             
,ModifiedDate  [datetime]                                                              
,HealthDataAttributeId [int]                  
,Name  [varchar](250)                                                           
,Value [varchar](200)                                                             
,HealthRecordDate [datetime]                                                             
,HealthDataSubTemplateId [int]                                                             
,SubTemplateCompleted [char](1)                                                               
,HealthDataTemplateId [int]                                                             
,Flag [varchar](10)                                                             
,Range [varchar](250)                                                       
,IsCorrected [char](1)                                                             
,Comments [varchar](max)                                                             
,ResultStatus [int]                                                             
,Locked [char](1)                                                         
,LockedBy [varchar](30)                                                             
,LockedDate  [datetime]                                                             
)                                                            
                                                                
EXEC sp_xml_preparedocument @hDoc OUTPUT, @xmlData                                               
                                                            
INSERT INTO  #Temp                                                              
SELECT                                                            
 ClientId                                                                
,FirstName                                                                
,LastName                                                                
,SSN                                               
,DOB                                                             
,ClientHealthDataAttributeId                                                                                           
,CreatedBy                                               
,CreatedDate                                                            
,ModifiedBy                                                
,ModifiedDate                                                            
,HealthDataAttributeId                   
,Name                                                             
,Value                                                       
,HealthRecordDate                                         
,HealthDataSubTemplateId                                                                
,SubTemplateCompleted                                    
,HealthDataTemplateId                                                             
,Flag                                                            
,Range                                                            
,IsCorrected                                                            
,Comments                                                            
,ResultStatus                               
,Locked                                                            
,LockedBy                                                            
,LockedDate                                                            
FROM OPENXML(@hDoc, 'Clients/C/chda')                                                                
WITH                                                                 
(                                                                
ClientId [int] '../@ClientId'                                                         
,FirstName [varchar](100) '../@FirstName'                                                                
,LastName [varchar](100) '../@LastName'                         
,SSN[varchar](100)  '../@SSN'                                              
,DOB  [datetime]  '../@DOB'                                                              
,ClientHealthDataAttributeId [int] '@ClientHealthDataAttributeId'                                                                                               
,CreatedBy [varchar](30) '@createdby'                                                            
,CreatedDate [datetime] '@createddate'                                                            
,ModifiedBy [varchar](30) '@ModifiedBy'                                                            
,ModifiedDate  [datetime]  '@ModifiedDate'                                                            
,HealthDataAttributeId[int] '@HealthDataAttributeId'                   
,Name  [varchar](250) '@Name'                                                             
,Value [varchar](200) '@Value'                                                                
,HealthRecordDate [datetime] '@HealthRecordDate'                                                                
,HealthDataSubTemplateId [int] '@HealthDataSubTemplateId'                                                                
,SubTemplateCompleted [char](1) '@SubTemplateCompleted'                                                                
,HealthDataTemplateId [int] '@HealthDataTemplateId'                                                              
,Flag [varchar](10) '@Flag'                                                            
,Range [varchar](250) '@Range'                                                            
,IsCorrected [char](1) '@IsCorrected'                                                            
,Comments [varchar](max) '@Comments'                                                            
,ResultStatus [int] '@ResultStatus'                                                            
,Locked [char](1) '@Locked'                                                            
,LockedBy [varchar](30) '@LockedBy'                                                            
,LockedDate  [datetime] '@LockedDate'                                                          
)                                                                
                       
 DECLARE Cursor_ClientHealth CURSOR                                                            
 FOR SELECT                                                             
 ClientId                                  
,FirstName                                                    
,LastName                                                                
,SSN                                                
,DOB                       
,ClientHealthDataAttributeId                                                                                                
,CreatedBy                                                            
,CreatedDate                                     
,ModifiedBy                                                            
,ModifiedDate                                                            
,HealthDataAttributeId                   
,Name                    
,Value                                                                
,HealthRecordDate                                                                
,HealthDataSubTemplateId                                                                
,SubTemplateCompleted                                        
,HealthDataTemplateId                                                             
,Flag                                                            
,Range                                                            
,IsCorrected                                                    
,Comments                                       
,ResultStatus                                                            
,Locked                                                            
,LockedBy                                                            
,LockedDate                                                            
 FROM  #Temp ;                                                            
                                          
 OPEN Cursor_ClientHealth;                                                            
 FETCH NEXT FROM Cursor_ClientHealth INTO                                                             
  @ClientIdText                                                              
 ,@FirstName                                                             
 ,@LastName                                                              
 ,@SSN                                                
 ,@DOB                                                          
 ,@ClientHealthDataAttributeId                                                                                               
 ,@CreatedBy                                                             
 ,@CreatedDate                                                             
 ,@ModifiedBy                                                             
 ,@ModifiedDate                                                             
 ,@HealthDataAttributeId                   
 ,@Name                                                          
 ,@Value                                                             
 ,@healthrecorddate                                                             
 ,@HealthDataSubTemplateId                                                             
 ,@SubTemplateCompleted                                                             
 ,@HealthDataTemplateId                                                             
 ,@Flag                                                             
 ,@Range                                                             
 ,@IsCorrected                                                            
 ,@Comments                                                             
 ,@ResultStatus                                                             
 ,@Locked                                                             
 ,@LockedBy                                                             
 ,@LockedDate                                                  
         
 WHILE @@FETCH_STATUS = 0                                                            
    BEGIN                                                         
                                                         
 --##########################                                              
                    
 IF isnumeric(isnull(@ClientIdText, '')) <> 0                                              
    BEGIN                                     
  SET @ClientId=0                                                   
     SELECT @ClientId = ClientId                                                        
     FROM Clients                                        
     WHERE ClientId=CONVERT(BIGINT,@ClientIdText)                                              
 AND(                                                        
       LastName = @LastName                                                        
       OR FirstName = @FirstName            
       )                                                        
      AND ISNULL(RecordDeleted, 'N') = 'N'                                                        
      AND Active = 'Y'                                                    
                                                                  
    END              
                                               
 --MATCH on (SSN with lastname/firstname)                                              
   IF ISNULL(@ClientId, 0) = 0                                              
    AND ISNULL(@ssn, '') <> ''                                              
   BEGIN                                              
    SELECT @ClientId = ClientId                                              
FROM Clients                                              
    WHERE SSN = @ssn                                              
     AND SSN <> '999999999'                                              
     AND (                                              
      LastName = @LastName                                       
      OR FirstName = @FirstName                                              
      )                                              
     AND MasterRecord = 'Y'                                          
     AND Active = 'Y'                                              
     AND ISNULL(RecordDeleted, 'N') = 'N'                                              
   END                                                   
                                                  
 --MATCH on (lastname, firstname, DOB)                                              
   IF ISNULL(@ClientId, 0) = 0                                              
    AND ISNULL(@DOB, '') <> ''                                              
  BEGIN                                      
    SELECT @ClientId = ClientId                                              
    FROM Clients                                              
    WHERE DOB = CAST(@DOB AS DATETIME)                                              
     AND LastName = @LastName                                              
     AND FirstName = @FirstName                                              
     AND MasterRecord = 'Y'                                              
     AND Active = 'Y'                                              
     AND ISNULL(RecordDeleted, 'N') = 'N'                                              
   END                              
                           
  IF ISNULL(@ClientId, 0) = 0                              
  BEGIN                      
  DECLARE @message as varchar(500)= '<EventLog>' + 'ClientId=' + @ClientIdText + 'ssn=' + @ssn  + ' does not exist</EventLog>'      
  DECLARE @tmp DATETIME      
  SET @tmp = GETDATE()      
      
  EXEC [dbo].[ssp_SCLogError] 'SENt App Information' ,@message,'Client Information', 'SENt App',@tmp,''      
      
   Goto Cont      
      
  END                                     
  --##########################                                              
                                     
-- fetch health data attribute id by name in kdev                                  
  select @HealthDataAttributeId=HealthDataAttributeId from HealthDataAttributes hda where hda.name=@Name                  
  select @HealthDataSubTemplateId=HealthDataSubTemplateId from HealthDataSubTemplateAttributes hdsta where hdsta.HealthDataAttributeId=@HealthDataAttributeId                                                     
                
  IF (NOT EXISTS ( SELECT TOP 1 c.CurrentClientHealthDataAttributeId  FROM CustomClientHealthDataAttributeMappings c  WHERE  c.ReferenceClientHealthDataAttributeId=@ClientHealthDataAttributeId AND C.RecordDeleted IS NULL ))                               
   
    
      
        
          
            
              
               
   BEGIN                                    
                             
  INSERT INTO [dbo].[ClientHealthDataAttributes]                                            
           ([CreatedBy]                                                            
           ,[CreatedDate]                                                            
           ,[ModifiedBy]                                                         
           ,[ModifiedDate]                                                            
           ,[HealthDataAttributeId]                                                            
           ,[Value]                                                            
           ,[ClientId]                                                            
           ,[HealthRecordDate]                                                            
           ,[HealthDataSubTemplateId]                                                            
           ,[SubTemplateCompleted]                                                            
           ,[HealthDataTemplateId]                                     
           ,[Flag]                                             
           ,[Range]                                                            
           ,[IsCorrected]                                                            
           ,[Comments]                                                            
           ,[ResultStatus]                                                            
           ,[Locked]                                                            
           ,[LockedBy]                                                            
           ,[LockedDate])                                                            
     VALUES                                                            
           (                                                            
       'istaff'                                                            
      ,GETDATE()                                                            
   ,'istaff'                                                            
   ,GETDATE()                                                            
   ,@HealthDataAttributeId                                                             
   ,@Value                                           
   ,@ClientId                                                            
   ,@HealthRecordDate                                                             
   ,@HealthDataSubTemplateId                                                             
   ,@SubTemplateCompleted                                                             
   ,@HealthDataTemplateId                                                             
   ,@Flag                                          
   ,@Range                                                             
   ,@IsCorrected                                                            
   ,@Comments                                                             
   ,@ResultStatus                                                             
   ,@Locked                                                             
,@LockedBy                                                             
   ,@LockedDate                                                          
     )                                               
                                        
----############## mapping table entry#################                                        
                                        
INSERT INTO CustomClientHealthDataAttributeMappings(CurrentClientHealthDataAttributeId,ReferenceClientHealthDataAttributeId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                                        
VALUES(@@IDENTITY,@ClientHealthDataAttributeId,'SHS',GETDATE(),'SHS',GETDATE() )                                        
                                        
--############## End statement ######################                                        
  END                                              
ELSE                            
                            
  BEGIN                                  
                              
   SELECT TOP 1 @CurrentClientHealthDataAttributeId = c.CurrentClientHealthDataAttributeId                              
   FROM CustomClientHealthDataAttributeMappings c  WHERE  c.ReferenceClientHealthDataAttributeId=@ClientHealthDataAttributeId                                    
                                  
  UPDATE [ClientHealthDataAttributes]                                               
  SET           
   ModifiedBy='istaff'                                            
   ,ModifiedDate=getdate()                                              
  ,value=@value                                               
  ,HealthDataSubTemplateId=@HealthDataSubTemplateId                                 
  ,SubTemplateCompleted=@SubTemplateCompleted                                                           
  ,HealthDataTemplateId=@HealthDataTemplateId                                               
   WHERE ClientHealthDataAttributeId=  @CurrentClientHealthDataAttributeId                                      
                                
  END      
      
   Goto Cont      
                                               
       Cont:                                                      
        FETCH NEXT FROM Cursor_ClientHealth INTO                                                             
            @ClientIdText                                                              
 ,@FirstName                                                             
 ,@LastName                                            
 ,@SSN                                                  
 ,@DOB                                                        
,@ClientHealthDataAttributeId                                                                                             
 ,@CreatedBy                                                             
 ,@CreatedDate                                     
 ,@ModifiedBy                                                             
 ,@ModifiedDate                                                             
 ,@HealthDataAttributeId                
 ,@Name                                                             
 ,@Value                                                   
 ,@HealthRecordDate                                                             
 ,@HealthDataSubTemplateId                                                             
 ,@SubTemplateCompleted                                                             
 ,@HealthDataTemplateId                                                
 ,@Flag                                                             
 ,@Range                                                             
 ,@IsCorrected                                                            
 ,@Comments                                                             
 ,@ResultStatus                                                             
 ,@Locked                                          
 ,@LockedBy                                                             
 ,@LockedDate                                      
                                 
  END;                                             
                                                 
                                                            
CLOSE Cursor_ClientHealth;                                                            
                                                            
DEALLOCATE Cursor_ClientHealth;                                                            
                                                                                     
Drop Table #Temp                                                            
                       
 END TRY                                                                
BEGIN CATCH                                                                
 DECLARE @Error VARCHAR(8000)                             
                                                                
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_ProcessIncomingClientHealthAttributesXML') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '****
   
   
       
       
          
            
              
                
                  
*                    
' + CONVERT                      
                        
                          
                      
                              
                                
                                  
  (VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())                                                                
                                                    
                             
                                   
  INSERT INTO ErrorLog (                                    
   ErrorMessage                                    
   ,VerboseInfo                                    
   ,DataSetInfo                                    
   ,ErrorType                                    
   ,CreatedBy                                    
   ,CreatedDate                                    
   )                                    
  VALUES (                                    
   @Error                                    
   ,NULL                           
   ,NULL                                    
   ,'csp_ProcessIncomingClientHealthAttributesXML Procedure Error'                                    
   ,NULL                                  
   ,GETDATE()                                    
   )                                   
                               
    RAISERROR (                                                                
    @Error                                                                
    ,-- Message text.                                                                       
    16                                                                
    ,-- Severity.                                                                       
    1 -- State.                                                           
    );                                                                 
 END CATCH                                                                
                                                                        
END 