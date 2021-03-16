/****** Object:  Trigger [TriggerInsertUpdate_ClientMedicationScriptDrugs]    Script Date: 04/09/2018 11:44:28 ******/
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TriggerInsertUpdate_ClientMedicationScriptDrugs]'))
	DROP TRIGGER [dbo].[TriggerInsertUpdate_ClientMedicationScriptDrugs]
GO

/****** Object:  Trigger [dbo].[TriggerInsertUpdate_ClientMedicationScriptDrugs]    Script Date: 04/09/2018 11:44:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO 
 
 CREATE TRIGGER TriggerInsertUpdate_ClientMedicationScriptDrugs    
   ON  ClientMedicationScriptDrugs    
   AFTER INSERT,UPDATE    
      
-- =============================================    
-- Author:  <Author,,Name>    
-- Create date: <Create Date,,>    
-- Description: <Description,,>  
    
-- Date        Author    
 
 -- 12.13.2019   Bibhu       What : RaisError ErrorCode added and insert into ErrorLog Table.
 --                           Why :  Engineering Improvement Initiatives- NBL(I) #103012  

-- =============================================    
AS     
BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 
        DECLARE  @ModifiedBy varchar(30),@ClientMedicationScriptDrugId int,
       @ClientId1 int, @ClientId2 int
       
      SELECT  @ClientMedicationScriptDrugId=i.ClientMedicationScriptDrugId,@ModifiedBy = i.ModifiedBy, 
      @ClientId1 = cm.ClientId ,@ClientId2=cms.ClientId
      FROM inserted i 
	 join ClientMedicationInstructions b3 on b3.ClientMedicationInstructionId = i.ClientMedicationInstructionId  
	  JOIN ClientMedications cm on cm.clientMedicationId = b3.ClientMedicationId  
	 JOIN ClientMedicationScripts cms on cms.ClientMedicationScriptId = i.ClientMedicationScriptId  
	 
 SET NOCOUNT ON;    
    
-- Insert statements for trigger here    
if exists    
 (select * from inserted a    
 join ClientMedicationInstructions b on a.ClientMedicationInstructionId = b.ClientMedicationInstructionId    
 join ClientMedications c on c.clientMedicationId = b.ClientMedicationId    
 join ClientMedicationScripts d on d.ClientMedicationScriptId = a.ClientMedicationScriptId    
 where     
 exists    
 (select * from ClientMedicationScriptDrugs a2    
 join ClientMedicationInstructions b2 on a2.ClientMedicationInstructionId = b2.ClientMedicationInstructionId    
 join ClientMedications c2 on c2.clientMedicationId = b2.ClientMedicationId    
 join ClientMedicationScripts d2 on d2.ClientMedicationScriptId = a2.ClientMedicationScriptId    
 where a2.ClientMedicationScriptId = a.ClientMedicationScriptId    
 and (c2.clientId <> c.Clientid    
  or    
  d2.ClientId <> c.ClientId)))    
  begin    
    --raiserror 50010 'A medication on this script belongs to a different client'       
    raiserror ('ERR_TriggerInsertUpdate_ClientMedicationScriptDrugs;: A medication on this script belongs to a different client. Please contact your system administrator.',16,1)  
     rollback transaction      
      
           INSERT INTO dbo.ErrorLog
				(  
					  ErrorMessage,  
					  VerboseInfo,  
					  DataSetInfo,  
					  ErrorType,  
					  CreatedBy  
				)  
    select 'ClientMedicationScriptDrugId (' + cast(@ClientMedicationScriptDrugId as varchar) + ') has been tried to be modified. ClintId (' + cast(@ClientId1 as varchar) + ') from ClientMedications and ClientId (' + cast(@ClientId2 as varchar) + ') from ClientMedicationScripts does not match. ModifiedBy (' + cast(@ModifiedBy as varchar) + ') and ModifiedDate (' + cast(getdate() as varchar) + '). Created by TriggerInsertUpdate_ClientMedicationScriptDrugs.',  
           '',  
           '',  
           'Error',  
           'TR_CMedicationScriptDrugs';   
        
     /*Create a bug tracking record.  The detail captured can be modified as needed.*/    
   insert into CustomBugTracking    
   (ClientId,    
   DocumentId,    
   ServiceId,    
   Description,    
   CreatedDate,    
   DocumentVersionId)    
   Select null, null, null, 'Incorrect client mapping occurred in MedicationManagement script process', getdate(), null    
    
  end    
    
END 