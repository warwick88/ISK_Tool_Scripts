 IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[CSP_INITCAREPLANINITIAL]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[CSP_INITCAREPLANINITIAL] 
GO

CREATE PROCEDURE [DBO].[CSP_INITCAREPLANINITIAL] --5,560,NULL  
 @ClientID INT  
 ,@StaffID INT  
 ,@CustomParameters XML  
AS  
-- =============================================        
-- Author:  Pradeep        
-- Create date: Sept 23, 2014        
-- Description:     
/*        
 Modified Date Author  Reason        
     
11 May 2020     Ankita Sinha      Task #8 KCMHSAS Improvements       
*/  
-- =============================================        
BEGIN  
 BEGIN TRY  
  EXEC csp_CustomInitCarePlanInitial @ClientID  
          ,@StaffID  
          ,@CustomParameters  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'CSP_INITCAREPLANINITIAL') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, 
ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.                                                                       
    16  
    ,-- Severity.                                                              
    1 -- State.                                                           
    );  
 END CATCH  
END  