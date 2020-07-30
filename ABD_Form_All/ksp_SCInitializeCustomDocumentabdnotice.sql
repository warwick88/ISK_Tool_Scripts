USE [ProdSmartCare]
GO

/****** Object:  StoredProcedure [dbo].[ksp_SCInitializeCustomDocumentabdnotice]    Script Date: 7/30/2020 10:12:15 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



  
  
CREATE PROCEDURE [dbo].[ksp_SCInitializeCustomDocumentabdnotice]         
      (        
       @ClientID INT        
      ,@StaffID INT        
      ,@CustomParameters xml        
      )        
AS        
  
BEGIN     
BEGIN TRY         
  
        
SELECT  'CustomDocumentabdnotice' AS TableName  -- Require Column  
       ,-1 AS DocumentVersionId      -- Require Column  
FROM    SystemConfigurations AS s   
END TRY                                                                                                   
                                                                                                                      
 BEGIN CATCH                                                                                                                                                                                                                
   DECLARE @Error varchar(8000)                                                                                                                                                           
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                          
                                                                     
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ksp_SCInitializeCustomDocumentabdnotice')                                                                  
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                                   
                                                                             
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                         
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                                                                         
 END CATCH                                                                    
 End   
GO


