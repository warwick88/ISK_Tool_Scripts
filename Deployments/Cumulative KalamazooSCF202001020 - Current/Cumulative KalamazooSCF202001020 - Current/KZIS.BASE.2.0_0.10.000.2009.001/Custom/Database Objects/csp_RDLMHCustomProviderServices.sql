IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'csp_RDLMHCustomProviderServices')
	BEGIN
		DROP  Procedure csp_RDLMHCustomProviderServices
		                 
	END
GO
CREATE PROCEDURE  [dbo].[csp_RDLMHCustomProviderServices]                        
(                              
 @CustomServiceDispositionId  int                              
)                              
As   
begin                   
/**************************************************************  
Created By   :Jyothi Bellapu
Created Date : 21th-May-2020  
Description  : Used to Bind The RDL for Disposition Control on any page  
Called From  : 'Disposition'  


**************************************************************/  
  
BEGIN TRY                      
Select
	CPS.CustomProviderServiceId
	,CPS.CreatedBy
	,CPS.CreatedDate
	,CPS.ModifiedBy
	,CPS.ModifiedDate
	,CPS.RecordDeleted
	,CPS.DeletedBy
	,CPS.DeletedDate
	,Pr.ProgramName AS Program
	,CPS.CustomServiceDispositionId
  FROM CustomProviderServices CPS
 -- LEFT OUTER JOIN CustomServiceTypePrograms CSTP ON CPS.ProgramId = CSTP.CustomServiceTypeProgramId
  INNER JOIN Programs Pr ON Pr.ProgramId = CPS.ProgramId
  WHERE ISNull(CPS.RecordDeleted,'N')='N' AND CPS.[CustomServiceDispositionId]=@CustomServiceDispositionId    
  END TRY                                                                        
BEGIN CATCH                            
DECLARE @Error varchar(8000)                                                                         
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                   
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RDLMHCustomProviderServices')                                                                                                       
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