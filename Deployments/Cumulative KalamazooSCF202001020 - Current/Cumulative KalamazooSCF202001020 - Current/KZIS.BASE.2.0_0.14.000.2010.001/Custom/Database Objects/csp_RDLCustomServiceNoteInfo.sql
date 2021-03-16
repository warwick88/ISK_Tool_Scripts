IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomServiceNoteInfo]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_RDLCustomServiceNoteInfo]
GO

CREATE PROCEDURE [dbo].[csp_RDLCustomServiceNoteInfo]    
@DocumentVersionId Int      
    
AS  
/******************************************************************************              
/* Stored Procedure: dbo.csp_RDLCustomServiceNoteInfo    */
/* Creation Date: 28/May/2014                                        */
/*                                                                  */
/* Purpose:                   */
/*  Exec csp_SCGetCustomBHSGroupNote                          */
/*  Date                  Author                 Purpose            */
/* 17/10/2014            Venkatesh MR				Created             */  
/* 12-02-2018			 Kishore				New Module BHS GroupNote in F&CS- #7 copied from WWMU  */        
            
*******************************************************************************/
BEGIN TRY  
Declare @ServiceId int  
Declare @DocumentId int  
DECLARE @Space1 VARCHAR(max) = Space(20)   
DECLARE @OrganizationName VARCHAR(300)  
Select @ServiceId = ServiceId, @DocumentId=Documentid from Documents where InProgressDocumentVersionId=@DocumentVersionId  
SELECT @OrganizationName = AgencyName FROM  Agency  
select 
  P.ProgramName as ProgramName  
  ,st.LastName+', '+ st.FirstName as ClinicianName  
  ,PC.ProcedureCodeName as ProcedureCodeName  
  ,L.LocationCode  as LocationName   
   ,dbo.csf_GetGlobalCodeNameById(S.[status]) AS [status]  
  ,S.Unit  
  ,dbo.csf_GetGlobalCodeNameById(S.UnitType) AS UnitType
  ,S.DateOfService as dsTime   
  
  from Documents D  
--left join Documents D on dv.DocumentVersionId  =D.ServiceId AND ISNULL(D.RecordDeleted,'N') = 'N'  
left join Services S on S.ServiceId=D.ServiceId AND ISNULL(S.RecordDeleted,'N') = 'N'  
left join Clients C on D.ClientId= C.ClientId AND ISNULL(C.RecordDeleted,'N') = 'N'  
left join DocumentCodes as DC on D.DocumentCodeId=DC.DocumentCodeId AND ISNULL(DC.RecordDeleted,'N') = 'N'  
left join Programs P on P.ProgramId=S.ProgramId AND ISNULL(P.RecordDeleted,'N') = 'N'  
left join Staff St on st.StaffId=S.ClinicianId AND ISNULL(St.RecordDeleted,'N') = 'N'  
left join ProcedureCodes PC on S.ProcedureCodeId=PC.ProcedureCodeId AND ISNULL(PC.RecordDeleted,'N') = 'N'  
left join Locations L on S.LocationId=L.LocationId AND ISNULL(L.RecordDeleted,'N') = 'N'  
where S.ServiceId=@ServiceId  
AND  ISNULL(D.RecordDeleted,'N') = 'N'  
 END TRY  
   
  BEGIN CATCH                                
  DECLARE @Error varchar(8000)                 
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                       
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RDLCustomServiceNoteInfo')                                                                                                           
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                            
   + '*****' + Convert(varchar,ERROR_STATE())                                                        
    
  RAISERROR                                                                                                           
   (                                                                             
     @Error, -- Message text.                                                                                                          
     16, -- Severity.                                                                                                          
     1 -- State.                                                                                                          
   );                                                                                                        
  END CATCH 