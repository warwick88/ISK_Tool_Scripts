
/****** Object:  StoredProcedure [dbo].[csp_RDLMHOtherRiskFactors]    Script Date: 02/03/2015 12:50:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLMHOtherRiskFactors]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLMHOtherRiskFactors]
GO


/****** Object:  StoredProcedure [dbo].[csp_RDLMHOtherRiskFactors]    Script Date: 02/03/2015 12:50:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROCEDURE [dbo].[csp_RDLMHOtherRiskFactors]                        
@DocumentVersionId  int                 
 AS                       
Begin           
             
/**************************************************************  
Created By   : Jyothi Bellapu
Created Date : 21th-May-2020  
Description  : Used to Bind The RDL for Risk Factor Control on any page  
Called From  : 'Risk Factor'  
**************************************************************/          
         
        
   ---CustomOtherRiskFactors---                                
 SELECT [OtherRiskFactorId]                                                           
      ,[DocumentVersionId]                                                                                
      ,[OtherRiskFactor]                                                                                                                                              
      ,GlobalCodes.CodeName               
                                                                                             
  FROM GlobalCodes join CustomOtherRiskFactors c                                                                                
  on GlobalCodes.GlobalCodeId = c.OtherRiskFactor                                                                          
  WHERE DocumentVersionId=@DocumentVersionId               
  AND ISNULL(GlobalCodes.RecordDeleted,'N')='N'  AND ISNULL(c.RecordDeleted,'N')='N'          
    order by CodeName         
            
    --Checking For Errors                        
  If (@@error!=0)                        
  Begin                        
    
   RAISERROR ('csp_RDLMHOtherRiskFactors failed.  Please contact your system administrator. We apologize for the inconvenience.',16,1)                  
   Return                        
   End                        
                 
                      
            
End  
GO


