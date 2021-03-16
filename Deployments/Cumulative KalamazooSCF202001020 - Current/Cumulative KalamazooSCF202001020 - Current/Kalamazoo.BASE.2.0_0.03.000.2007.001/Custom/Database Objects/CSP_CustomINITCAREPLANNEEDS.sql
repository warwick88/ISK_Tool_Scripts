IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[CSP_CustomINITCAREPLANNEEDS]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[CSP_CustomINITCAREPLANNEEDS] 
GO

CREATE PROCEDURE [DBO].[CSP_CustomINITCAREPLANNEEDS] (   
 @ClientID INT    
 ,@CarePlanDocumentVersionID INT    
 ,@EffectiveDateDifference INT -- Difference is in years        
 )    
AS    
-- =============================================      
-- Author:  Pradeep.A      
-- Create date: 01/19/2015      
-- Description: Initializae Needs      
 -- 11 May 2020     Ankita Sinha      Task #8 KCMHSAS Improvements
-- =============================================      
BEGIN TRY    
 EXEC csp_InitCarePlanNeeds @ClientID  
   ,@CarePlanDocumentVersionID  
   ,@EffectiveDateDifference  
END TRY    
    
BEGIN CATCH    
 DECLARE @Error VARCHAR(8000)    
    
 SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'CSP_CustomINITCAREPLANNEEDS') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' +   
 Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())    
    
 RAISERROR (    
   @Error    
   ,-- Message text.             
   16    
   ,-- Severity.             
   1 -- State.                                                               
   );    
END CATCH   