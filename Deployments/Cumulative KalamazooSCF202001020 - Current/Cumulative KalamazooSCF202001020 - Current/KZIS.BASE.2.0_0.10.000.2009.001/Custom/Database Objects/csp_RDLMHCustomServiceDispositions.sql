/****** Object:  StoredProcedure [dbo].[csp_RDLMHCustomServiceDispositions]   ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLMHCustomServiceDispositions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLMHCustomServiceDispositions]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLMHCustomServiceDispositions]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

Create PROCEDURE  [dbo].[csp_RDLMHCustomServiceDispositions]                        
(                              
 @CustomDispositionId  int                              
)                              
As   
begin                   
/**************************************************************  
Created By   : Jyothi Bellapu
Created Date : 21th-May-2020  
Description  : Used to Bind The RDL for Disposition Control on any page  
Called From  : 'Disposition'  
**************************************************************/  
  
BEGIN TRY                      
Select
	CSD.CustomServiceDispositionId
	,CSD.CreatedBy
	,CSD.CreatedDate
	,CSD.ModifiedBy
	,CSD.ModifiedDate
	,CSD.RecordDeleted
	,CSD.DeletedBy
	,CSD.DeletedDate
	,GSC.SubCodeName AS ServiceType
	,CSD.CustomDispositionId
  FROM CustomServiceDispositions CSD
  LEFT OUTER JOIN GlobalSubCodes GSC ON CSD.ServiceType = GSC.GlobalsubCodeId
  WHERE ISNull(CSD.RecordDeleted,'N')='N' AND CSD.[CustomDispositionId]=@CustomDispositionId    
  END TRY                                                                        
BEGIN CATCH                            
DECLARE @Error varchar(8000)                                                                         
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                   
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RDLMHCustomServiceDispositions')                                                                                                       
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


