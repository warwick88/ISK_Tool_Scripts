
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'csp_RDLCustomDocumentMHCraft')
BEGIN
	DROP  PROCEDURE csp_RDLCustomDocumentMHCraft
END

GO
CREATE PROCEDURE  [dbo].[csp_RDLCustomDocumentMHCraft] --733272             
(                                                    
	 @DocumentVersionId  INT                                                
)                                                                            
AS  
/*********************************************************************/ 

/* Stored Procedure: [csp_RDLCustomDocumentMHCraft] 2012606			   */                                                                                                                                             
/* Creation Date:   21-05-2020										   */                                                                                                                                                                                                                                                                                                         
/* Input Parameters: @DocumentVersionId									   */                                                                                                                                                                                                                                                                                                                                

/* 21-05-2020    Jyothi Bellapu     What/Why: RDL Sp for Creaft Tab                                */
/*07/19/2020	 Packia				What/Why: Modified the CrafftStageOfChange to display the CodeName instead of GlobalCodeId*/
  /*********************************************************************/ 
 
 BEGIN                          
	BEGIN TRY 
	
    DECLARE @ClientId int 
                               

	SELECT
		DocumentVersionId
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedBy
		,DeletedDate
		,CrafftApplicable
		,CrafftApplicableReason
		,CrafftQuestionC
		,CrafftQuestionR
		,CrafftQuestionA
		,CrafftQuestionF
		,CrafftQuestionFR
		,CrafftQuestionT
		,CrafftCompleteFullSUAssessment
		,dbo.csf_GetGlobalCodeNameById(CrafftStageOfChange) as CrafftStageOfChange    
	FROM CustomDocumentMHCRAFFTs CDPW 
	Where CDPW.DocumentVersionId=@DocumentVersionId  
		AND ISNULL(CDPW.RecordDeleted,'N') <> 'Y'  
 	
				
	END TRY
  BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)    
    
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLCustomDocumentMHCraft') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())    
    
  RAISERROR (    
    @Error    
    ,-- Message text.    
    16    
    ,-- Severity.    
    1 -- State.    
    );    
 END CATCH    
END  