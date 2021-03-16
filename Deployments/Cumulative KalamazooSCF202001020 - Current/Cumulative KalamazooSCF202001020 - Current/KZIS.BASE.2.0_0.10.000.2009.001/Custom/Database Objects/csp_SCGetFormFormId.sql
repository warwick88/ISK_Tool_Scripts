
/****** Object:  StoredProcedure [dbo].[csp_SCGetFormFormId]    Script Date: 01/07/2019 14:36:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetFormFormId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetFormFormId]
GO


/****** Object:  StoredProcedure [dbo].[csp_SCGetFormFormId]  '05CC45C2-B5A4-4D36-978B-499A13E1DE50'    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


    
CREATE PROCEDURE  [dbo].[csp_SCGetFormFormId] 
@FormGUID VARCHAR(100)      
AS 

 /*********************************************************************/
 /* Stored Procedure: [csp_SCGetFormFormId]   */

 /*       Date              Author                  Purpose                   */ 
 /*       28/May/2020      Jyothi Bellapu          This SP will return formid based on formGUIDas part of Kalamazoo - Improvements -#7*/
 /*********************************************************************/       

BEGIN   

BEGIN TRY   
          
     SELECT Formid FROM forms  
  
 WHERE     (ISNULL(RecordDeleted, 'N') = 'N') AND  FormGUID =@FormGUID 
      
 END TRY 
 
 BEGIN CATCH
 
  DECLARE @Error varchar(8000)                                                   
    SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                 
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_SCGetFormFormId')                                                                                 
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                  
    + '*****' + Convert(varchar,ERROR_STATE())                              
    RAISERROR                                                                                 
   (                                                   
    @Error, -- Message text.                                                                                
    16, -- Severity.                                                                                
    1 -- State.                                                                                
   );     
             
 END CATCH    
        
END 

GO


