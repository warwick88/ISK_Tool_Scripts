 /****** Object:  Trigger [tIUClientMedicationsPatientSafety]     ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tIUClientMedicationsPatientSafety]'))
DROP TRIGGER [dbo].[tIUClientMedicationsPatientSafety]
GO


/****** Object:  Trigger [dbo].[tIUClientMedicationsPatientSafety]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 create trigger tIUClientMedicationsPatientSafety on ClientMedications after insert, update
 
  /*********************************************************************************************  

 -- 12.13.2019   Bibhu       What : RaisError ErrorCode added and insert into ErrorLog Table.
 --                           Why :  Engineering Improvement Initiatives- NBL(I) #103012    

***********************************************************************************************/ 

 as  
begin  
  
          DECLARE 
        @ClientMedicationNameId int, @MDMedicationNameId int, @ClientMedicationId int ,@ModifiedBy varchar(30)

        
        SELECT  @ModifiedBy = i.ModifiedBy, @ClientMedicationNameId = i.MedicationNameId,
        @MDMedicationNameId = mdm.MedicationNameId, @ClientMedicationId=i.ClientMedicationId
         from Inserted as i  
		  join ClientMedicationInstructions as cmi on cmi.ClientMedicationId = i.ClientMedicationId  
		  join MDMedications as mdm on mdm.MedicationId = cmi.StrengthId  
		  where i.MedicationNameId <> mdm.MedicationNameId  
		  and ISNULL(i.Discontinued, 'N') <> 'Y'  
 

		
 -- Prevent update of ClientMedications if issue found with MedicationNameId  
 if exists(  
  select *  
  from Inserted as i  
  join ClientMedicationInstructions as cmi on cmi.ClientMedicationId = i.ClientMedicationId  
  join MDMedications as mdm on mdm.MedicationId = cmi.StrengthId  
  where i.MedicationNameId <> mdm.MedicationNameId  
  and ISNULL(i.Discontinued, 'N') <> 'Y'  
  )  
 begin  
 
  if @@TRANCOUNT > 0 
  rollback tran  
  raiserror('ERR_tIUClientMedicationsPatientSafety : Client medication name id does not match instruction name id. Please contact your system administrator.', 16, 1)  
  
   INSERT INTO dbo.ErrorLog 
				(  
					  ErrorMessage,  
					  VerboseInfo,  
					  DataSetInfo,  
					  ErrorType,  
					  CreatedBy  
				)  
				
        select 'ClientMedicationNameId (' + RTRIM(cast(@ClientMedicationNameId as varchar)) + ') and MDMedicationNameId (' + RTRIM(cast(@MDMedicationNameId as varchar)) + ') does not match of ClientMedicationId (' + RTRIM(cast(@ClientMedicationId as varchar)) + ') and modified by (' + cast(@ModifiedBy as varchar) + ') and ModifiedDate (' + cast(getdate() as varchar) + '). Created by tIUClientMedicationsPatientSafety.',  
           '',  
           '',  
           'Error',  
           'tIUCMedicationsPatientSafety';  
           
 end  
  
end  