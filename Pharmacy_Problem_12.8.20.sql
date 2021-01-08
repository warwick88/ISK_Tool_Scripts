USE [ProdSmartCare]
GO

/****** Object:  StoredProcedure [dbo].[ksp_ReprocessRXscripts]    Script Date: 12/10/2020 11:33:03 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE proc [dbo].[ksp_ReprocessRXscripts] as
/*************************************************************************************
    2020-01-14 Reprocess Rx scripts that failed transmission
				code shared by Tom Lohrman of Streamline
				turned into a proc by esova
*************************************************************************************/
BEGIN TRAN
       DECLARE @ReprocessProcess TABLE
         (
           ClientMedicationScriptActivityId INT ,
           ClientMedicationScriptId INT
         );
 
       INSERT    INTO @ReprocessProcess
                 ( ClientMedicationScriptActivityId ,
                   ClientMedicationScriptId
     )
                 SELECT  ClientMedicationScriptActivityId ,
                         ClientMedicationScriptId
                 FROM    dbo.ClientMedicationScriptActivities
                 WHERE   StatusDescription LIKE '%600%'
                         AND CreatedDate > '12/01/2020'; 
				SELECT * FROM @ReprocessProcess
					ROLLBACK TRAN
						 COMMIT TRAN



 
 update ClientMedicationScriptActivities set Status=5561,SureScriptsOutgoingMessageId=null,PrescriberOrderNumber=null,StatusDescription='' where ClientMedicationScriptActivityId IN (SELECT ClientMedicationScriptActivityId FROM @ReprocessProcess)


insert into kt_RXReprocessLog (ClientMedicationScriptActivityId,ClientMedicationScriptId,modifiedby,modifieddate)
 select ClientMedicationScriptActivityId
	,ClientMedicationScriptId
	,'AutoJobCorrection'
	,getdate()
	from @ReprocessProcess


 UPDATE dbo.SureScriptsOutgoingMessages SET SureScriptsMessageId=NULL,MessageType=NULL,MessageStatus=5541,ResponseDateTime=NULL,ResponseMessageText=NULL,MessageText=null
 WHERE ClientMedicationScriptId IN (SELECT ClientMedicationScriptId FROM @ReprocessProcess)
 
 --DROP TABLE @ReprocessProcess
 
 --ROLLBACK
 COMMIT
GO

select * from ClientMedicationScriptActivities
where statusDescription like '%600%'
and FaxStatusDate >= '2020-12-07'
order by createddate desc

select * from pharmacies
where pharmacyid=60

select * from pha