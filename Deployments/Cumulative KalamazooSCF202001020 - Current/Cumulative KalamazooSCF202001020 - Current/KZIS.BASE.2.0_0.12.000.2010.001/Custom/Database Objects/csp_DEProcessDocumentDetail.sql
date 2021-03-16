IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE type = 'P'
			AND name = 'csp_DEProcessDocumentDetail'
		)
	DROP PROCEDURE csp_DEProcessDocumentDetail
GO  

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
                
CREATE PROCEDURE [DBO].[csp_DEProcessDocumentDetail] (                
 @FromDeOrganizationId INT                
 ,@ToDeOrganizationId INT                
 ,@CentralTransferDocumentTypeId INT                
 ,@DocumentFormatId INT                
 ,@LastVersionImportMessageDetailId INT                
 ,@DeImportMessageDetailId INT                
 ,@StaffId INT                
 --@CentralTransferDocumentTypeId INT,--(CentralTransferDocumentTypeId)                  
 --@DocumentFormatId INT,--(PDF/XML/EDI)                  
 --@LastVersionImportMessageDetailId INT  ,                
 )                
 /******************************************************************************                                            
**  File:                                              
**  Name: [dbo].[csp_DEProcessDocumentDetail]                                        
**  Desc: This is a SWMBH specific CSP.  NOT FOR AFFILIATE USE <<<-------!!!!                
**                                            
**  Auth:    MJW                                        
**  Date:    04/08/2015                                         
*******************************************************************************                                            
**  Change History                                            
*******************************************************************************                                            
**  Date:      Author:   Description:                                            
**  --------  --------    -------------------------------------------                                            
** 17 Mar 2016  Vithobha  Added if else condition to differentiate DOCFORMAT(XML,Others or EDI) for MiHIN            
** 14 MAY 2020  Ravindra modified for  kalamazoo                                      
*******************************************************************************/                
AS                
 BEGIN              
              
            DECLARE @ImportFailed INTEGER              
            DECLARE @ImportSuccessful INTEGER              
            DECLARE @MessageDetail type_comment2      
   DECLARE @DEExportMessageId INTEGER          
   DECLARE @ErrorMessage VARCHAR(MAX)                           
            DECLARE @ThisProcedureName varchar(255)              
            DECLARE @ErrorProc varchar(4000)              
            DECLARE @ICBRccdXMLsp varchar(100)              
                   
                          
                                  
            SELECT  @ImportFailed = dbo.ssf_GetGlobalCodeIdByNameAndCategory('Failed', 'dataexchdocstatus')              
            SELECT  @ImportSuccessful = dbo.ssf_GetGlobalCodeIdByNameAndCategory('Successful', 'dataexchdocstatus')              
                              
                --#############################################################################              
                -- set messages to failure.  We'll set to success if we succeed              
                --#############################################################################               
                              
                UPDATE  md              
                SET     Status = @ImportFailed              
                       ,Comment = 'General Failure'              
                FROM    DEImportMessageDetails md              
                WHERE   md.DEImportMessageDetailId = @DeImportMessageDetailId              
                               
                UPDATE  m              
                SET     Status = @ImportFailed              
                       ,Comment = 'General Failure'              
                FROM    DEImportMessages m              
                        JOIN DEImportMessageDetails MD ON m.DEImportMessageId = MD.DEImportMessageId              
                WHERE   md.DEImportMessageDetailId = @DeImportMessageDetailId              
                                             
   
                SELECT  @MessageDetail = DIMD.MessageDetail              
                       ,@DEExportMessageId = DIM.SenderDBMessageId              
                FROM    DEImportMessageDetails DIMD              
                        JOIN DEImportMessages DIM ON DIMD.DEImportMessageId = DIM.DEImportMessageId              
                WHERE   DIMD.DEImportMessageDetailId = @DeImportMessageDetailId               
   IF @DocumentFormatId = 8247     
   BEGIN  
 BEGIN TRY       
            
   IF @MessageDetail IS NULL               
   BEGIN              
    UPDATE  m              
     SET     Status = @ImportFailed              
         ,Comment = 'FAILED WITH Error: MessageDetail IS NULL'              
     FROM    DEImportMessages m              
       JOIN DEImportMessageDetails MD ON m.DEImportMessageId = MD.DEImportMessageId              
     WHERE   md.DEImportMessageDetailId = @DeImportMessageDetailId               
                        
    UPDATE md                
    SET STATUS = @ImportFailed                
    ,Comment = 'FAILED WITH Error: MessageDetail IS NULL'               
      FROM DEImportMessageDetails md                
      WHERE md.DEImportMessageDetailId = @DeImportMessageDetailId                  
      RAISERROR ('FAILED WITH Error: MessageDetail IS NULL',16,1);              
   END              
   ELSE              
   BEGIN              
               
   -- CALL THE SP TO PROCESS THE INCOMING ICBR CCD XML INTO DOCUMENTS/PDF                
        
  --PRINT 'ACTUAL SP'            
     SELECT @ICBRccdXMLsp = StoredProcedureName FROM DEImportExportDocumentFormats WHERE FromDEOrganizationId=@FromDeOrganizationId               
     AND ToDEOrganizationId=@ToDeOrganizationId AND DocumentFormat=@DocumentFormatId AND CentralTransferDocumentTypeId=@CentralTransferDocumentTypeId              
     IF @ICBRccdXMLsp IS NOT NULL               
     BEGIN              
     EXEC @ICBRccdXMLsp @DeImportMessageDetailId              
     UPDATE md                
     SET STATUS = @ImportSuccessful                
     ,Comment = 'Success'                
     FROM DEImportMessageDetails md                
     WHERE md.DEImportMessageDetailId = @DeImportMessageDetailId                
                         
     UPDATE m                
     SET STATUS = @ImportSuccessful                
     ,Comment = 'Success'                
     FROM DEImportMessages m                
     JOIN DEImportMessageDetails MD ON m.DEImportMessageId = MD.DEImportMessageId                
     WHERE md.DEImportMessageDetailId = @DeImportMessageDetailId              
     END              
     ELSE              
     BEGIN              
     UPDATE m              
     SET Status = @ImportFailed,              
     Comment = 'COULD NOT FIND THE SP TO PROCESS THE INCOMING ICBR CCD XML INTO DOCUMENTS/PDF'              
     FROM DEImportMessages m              
     JOIN DEImportMessageDetails MD              
     ON m.DEImportMessageId = MD.DEImportMessageId              
     WHERE md.DEImportMessageDetailId = @DeImportMessageDetailId              
                      
     UPDATE md                
     SET STATUS = @ImportFailed                
     ,Comment = 'COULD NOT FIND THE SP TO PROCESS THE INCOMING ICBR CCD XML INTO DOCUMENTS/PDF'                
     FROM DEImportMessageDetails md                
     WHERE md.DEImportMessageDetailId = @DeImportMessageDetailId              
     RAISERROR ('COULD NOT FIND THE SP TO PROCESS THE INCOMING ICBR CCD XML INTO DOCUMENTS/PDF',16,1);              
     END              
   END              
 END TRY               
 BEGIN CATCH              
    UPDATE m              
 SET Status = @ImportFailed,              
 Comment = 'FAILED TO PROCESS THE INCOMING XML'              
 FROM DEImportMessages m              
 JOIN DEImportMessageDetails MD              
 ON m.DEImportMessageId = MD.DEImportMessageId              
 WHERE md.DEImportMessageDetailId = @DeImportMessageDetailId              
                  
    UPDATE md                
 SET STATUS = @ImportFailed                
 ,Comment = 'FAILED TO PROCESS THE INCOMING ICBR CCD XML INTO DOCUMENTS/PDF'                
 FROM DEImportMessageDetails md                
 WHERE md.DEImportMessageDetailId = @DeImportMessageDetailId              
                  
    SET @ThisProcedureName  = 'csp_DEProcessDocumentDetail'              
    SET @ErrorProc  = CONVERT(varchar(4000), ISNULL(ERROR_PROCEDURE(), @ThisProcedureName))              
    SET @ErrorMessage = @ThisProcedureName + ' Reports Error Thrown by: ' + @ErrorProc + CHAR(13)              
    SET @ErrorMessage += ISNULL(+CONVERT(varchar(4000), ERROR_MESSAGE()), 'Unknown')              
              
    RAISERROR              
    (              
    @ErrorMessage, -- Message text.                                                                                                                          
    16, -- Severity.                                               
    1 -- State.                                                                                      
    );              
  END CATCH               
 END              
 END          