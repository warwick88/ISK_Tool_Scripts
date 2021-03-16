/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomBHSGroupServiceNote]    Script Date: 06/20/2013 19:40:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomBHSGroupServiceNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomBHSGroupServiceNote]
GO

/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomBHSGroupServiceNote]    Script Date: 06/20/2013 19:40:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_ValidateCustomBHSGroupServiceNote] --897
 @DocumentVersionId int    
AS  
   
/**************************************************************  
Created By   : Venkatesh MR
Created Date : 18 Oct 2014  
Description  : Used to validate the BHS client note
/*  Date			  Author				  Description */

**************************************************************/
   
-- Declare Variables  
DECLARE @DocumentType varchar(10)      
DECLARE @DateOfService datetime  
      
-- Get ClientId      
DECLARE @ClientId int      
Declare @DocumentCodeId int
Select @DocumentCodeId = DocumentCodeId From DocumentCodes Where Code ='DC40159A-E64B-49BC-91F4-B2541CEDA58E'      
      
SELECT @ClientId = d.ClientId      
FROM Documents d      
WHERE d.CurrentDocumentVersionId = @DocumentVersionId      
  
-- Set ServiceId  
DECLARE @ServiceId int  
DECLARE @GroupServiceId int  
SELECT @ServiceId = d.ServiceId, @GroupServiceId = s.GroupServiceId, @DateOfService = s.DateOfService  
FROM Documents d  
JOIN Services s ON s.ServiceId = d.ServiceId  
WHERE d.InProgressDocumentVersionId = @DocumentVersionId  
      
-- Set Variables sql text      
DECLARE @Variables varchar(max)        
SET @Variables = 'DECLARE @DocumentVersionId int      
      SET @DocumentVersionId = ' + convert(varchar(20), @DocumentVersionId) +      
     --'DECLARE @DocumentType varchar(10)      
     -- SET @DocumentType = ' +''''+ @DocumentType+'''' +      
     ' DECLARE @ClientId int      
      SET @ClientId = ' + convert(varchar(20), @ClientId) +  
  'DECLARE @ServiceId int  
   SET @ServiceId = ' + CONVERT(varchar(25), @ServiceId) +  
  'DECLARE @GroupServiceId int  
   SET @GroupServiceId = ' + CONVERT(varchar(25), @GroupServiceId)  
  
      
-- Exec csp_validateDocumentsTableSelect to determine validation list        
If Not Exists (Select * From CustomDocumentValidationExceptions where DocumentVersionId = @DocumentVersionId and DocumentValidationid is null)        
Begin        
Exec csp_validateDocumentsTableSelect @DocumentVersionId, @DocumentCodeId, @DocumentType, @Variables        
if @@error <> 0 goto error        
End        
       
if @@error <> 0 goto error        
        
return       
      
error:        
raiserror ('csp_ValidateCustomBHSGroupServiceNote failed.  Please contact your system administrator. We apologize for the inconvenience.',16,1)

