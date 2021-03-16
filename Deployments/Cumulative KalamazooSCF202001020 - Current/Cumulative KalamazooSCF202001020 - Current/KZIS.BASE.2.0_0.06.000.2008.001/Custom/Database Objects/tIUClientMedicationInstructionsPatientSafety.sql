 /****** Object:  Trigger [tIUClientMedicationInstructionsPatientSafety]     ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tIUClientMedicationInstructionsPatientSafety]'))
DROP TRIGGER [dbo].[tIUClientMedicationInstructionsPatientSafety]
GO


/****** Object:  Trigger [dbo].[tIUClientMedicationInstructionsPatientSafety]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO  

 create trigger tIUClientMedicationInstructionsPatientSafety on ClientMedicationInstructions after insert, update
 
/*********************************************************************************************  

 -- 12.13.2019   Bibhu       What : RaisError ErrorCode added and insert into ErrorLog Table.
 --                           Why :  Engineering Improvement Initiatives- NBL(I) #103012    

***********************************************************************************************/  
 
  as  
begin  

   
     
        DECLARE 
        @ClientMedicationNameId int, @MDMedicationNameId int, @ClientMedicationInstructionId int ,@ModifiedBy varchar(30)



select @ClientMedicationNameId=cm.MedicationNameId ,@MDMedicationNameId=mdm.MedicationNameId ,
@ClientMedicationInstructionId=ClientMedicationInstructionId, @ModifiedBy=i.ModifiedBy
  from Inserted as i  
  join ClientMedications as cm on cm.ClientMedicationId = i.ClientMedicationId  
  join MDMedications as mdm on mdm.MedicationId = i.StrengthId  
  where cm.MedicationNameId <> mdm.MedicationNameId  
  and ISNULL(cm.Discontinued, 'N') <> 'Y'  
  
  DECLARE 
        @OldStrengthId int, @NewStrengthId int, @OldQuantity decimal(10,2) ,@NewQuantity decimal(10,2) ,
        @OldSchedule int, @NewSchedule int
 
  Select
  @OldStrengthId =d.StrengthId, @NewStrengthId = i.StrengthId, @OldQuantity=d.Quantity ,@NewQuantity=i.Quantity,
   @NewSchedule=i.Schedule ,@OldSchedule=d.Schedule
  ,@ModifiedBy=i.ModifiedBy,@ClientMedicationInstructionId=i.ClientMedicationInstructionId
  from Inserted as i  
  join deleted as d on d.ClientMedicationInstructionId = i.ClientMedicationInstructionId  
  join ClientMedications as cm on cm.ClientMedicationId = i.ClientMedicationId  
  where cm.Ordered = 'Y'  
  and ISNULL(cm.Discontinued, 'N') <> 'Y'  


        
 -- Prevent update of ClientMedicationInstructions if issue found with MedicationNameId  
 if exists(  
  select *  
  from Inserted as i  
  join ClientMedications as cm on cm.ClientMedicationId = i.ClientMedicationId  
  join MDMedications as mdm on mdm.MedicationId = i.StrengthId  
  where cm.MedicationNameId <> mdm.MedicationNameId  
  and ISNULL(cm.Discontinued, 'N') <> 'Y'  
 )  
 --begin  
 -- if @@TRANCOUNT > 0 
 -- rollback tran  
 -- raiserror('ERR_tIUClientMedicationInstructionsPatientSafety : Client medication instruction name id does not match medication name id. Please contact your system administrator.', 16, 1)

 --  INSERT INTO dbo.ErrorLog 
	--			(  
	--				  ErrorMessage,  
	--				  VerboseInfo,  
	--				  DataSetInfo,  
	--				  ErrorType,  
	--				  CreatedBy  
	--			)  
				
 --       select ' MedicationNameId (' + RTRIM(cast(@ClientMedicationNameId as varchar)) + ') and (' + RTRIM(cast(@MDMedicationNameId as varchar)) + ') does not match of ClientMedicationInstructionId (' + RTRIM(cast(@ClientMedicationInstructionId as varchar)) + ') and modified by (' + cast(@ModifiedBy as varchar) + ') and ModifiedDate (' + cast(getdate() as varchar) + '). Created by tIUClientMedicationInstructionsPatientSafety.',  
 --          '',  
 --          '',  
 --          'Error',  
 --          'TRIGGER';   
               
 -- return  
 --end  
  
 -- Prevent update of ClientMedicationInstructions if ordered and the quantity, strength or schedule is changing  
 if exists(  
  select *  
  from Inserted as i  
  join deleted as d on d.ClientMedicationInstructionId = i.ClientMedicationInstructionId  
  join ClientMedications as cm on cm.ClientMedicationId = i.ClientMedicationId  
  where cm.Ordered = 'Y'  
  and ISNULL(cm.Discontinued, 'N') <> 'Y'  
  and (  
   ISNULL(i.StrengthId, 0) <> d.StrengthId  
   --or ISNULL(i.Quantity, 0.0) <> d.Quantity  
   --or ISNULL(i.Schedule, 0) <> d.Schedule  
  )  
    
 )  
 
 begin  
  if @@TRANCOUNT > 0 
  rollback tran  
  raiserror('ERR_tIUClientMedicationInstructionsPatientSafety : Strength, Quantity or Schedule changed on previously ordered medication. Please contact your system administrator.', 16, 1) 
  
                INSERT INTO dbo.ErrorLog 
				(  
					  ErrorMessage,  
					  VerboseInfo,  
					  DataSetInfo,  
					  ErrorType,  
					  CreatedBy  
				)  
				
           select 'StrengthId (' + cast(@OldStrengthId as varchar) + ') tried to Modified to (' + cast(@NewStrengthId as varchar) + ') of ClientMedicationInstructionId (' + cast(@ClientMedicationInstructionId as varchar) + ') by (' + cast(@ModifiedBy as varchar) + ') and ModifiedDate (' + cast(getdate() as varchar) + '). Created by tIUClientMedicationInstructionsPatientSafety.',  
           '',  
           '',  
           'Error',  
           'TRIGGER';   
             
  return  
 end
 
 
 if exists(  
  select *  
  from Inserted as i  
  join deleted as d on d.ClientMedicationInstructionId = i.ClientMedicationInstructionId  
  join ClientMedications as cm on cm.ClientMedicationId = i.ClientMedicationId  
  where cm.Ordered = 'Y'  
  and ISNULL(cm.Discontinued, 'N') <> 'Y'  
  and (  
   ---ISNULL(i.StrengthId, 0) <> d.StrengthId  
   ISNULL(i.Quantity, 0.0) <> d.Quantity  
   --or ISNULL(i.Schedule, 0) <> d.Schedule  
  )  
    
 )  
 
 begin  
  if @@TRANCOUNT > 0 
  rollback tran  
  raiserror('ERR_tIUClientMedicationInstructionsPatientSafety : Strength, Quantity or Schedule changed on previously ordered medication. Please contact your system administrator.', 16, 1) 

                INSERT INTO dbo.ErrorLog 
				(  
					  ErrorMessage,  
					  VerboseInfo,  
					  DataSetInfo,  
					  ErrorType,  
					  CreatedBy  
				)  
				
           select 'Quantity (' + cast(@OldQuantity as varchar) + ') tried to Modified to (' + cast(@NewQuantity as varchar) + ') of ClientMedicationInstructionId (' + cast(@ClientMedicationInstructionId as varchar) + ') by (' + cast(@ModifiedBy as varchar) + ') and ModifiedDate (' + cast(getdate() as varchar) + '). Created by tIUClientMedicationInstructionsPatientSafety.',  
           '',  
           '',  
           'Error',  
           'TRIGGER';   
             
  return  
 end
 
 
 if exists(  
  select *  
  from Inserted as i  
  join deleted as d on d.ClientMedicationInstructionId = i.ClientMedicationInstructionId  
  join ClientMedications as cm on cm.ClientMedicationId = i.ClientMedicationId  
  where cm.Ordered = 'Y'  
  and ISNULL(cm.Discontinued, 'N') <> 'Y'  
  and (  
  -- ISNULL(i.StrengthId, 0) <> d.StrengthId  
   --or ISNULL(i.Quantity, 0.0) <> d.Quantity  
  ISNULL(i.Schedule, 0) <> d.Schedule  
  )  
    
 )  
 
 begin  
  if @@TRANCOUNT > 0 
  rollback tran  
  raiserror('ERR_tIUClientMedicationInstructionsPatientSafety : Strength, Quantity or Schedule changed on previously ordered medication. Please contact your system administrator.', 16, 1) 
  
                INSERT INTO dbo.ErrorLog 
				(  
					  ErrorMessage,  
					  VerboseInfo,  
					  DataSetInfo,  
					  ErrorType,  
					  CreatedBy  
				)  
				
           select 'Schedule (' + cast(@OldSchedule as varchar) + ') tried to Modified to (' + cast(@NewSchedule as varchar) + ') of ClientMedicationInstructionId (' + cast(@ClientMedicationInstructionId as varchar) + ') by (' + cast(@ModifiedBy as varchar) + ') and ModifiedDate (' + cast(getdate() as varchar) + '). Created by tIUClientMedicationInstructionsPatientSafety.',  
           '',  
           '',  
           'Error',  
           'TRIGGER';   
             
  return  
 end
end  