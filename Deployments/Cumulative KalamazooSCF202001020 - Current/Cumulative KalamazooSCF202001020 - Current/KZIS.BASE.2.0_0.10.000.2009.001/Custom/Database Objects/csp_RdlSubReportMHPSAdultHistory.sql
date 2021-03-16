/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportMHPSAdultHistory]  ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportMHPSAdultHistory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlSubReportMHPSAdultHistory]
GO

/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportMHPSAdultHistory] 2012630  ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[csp_RdlSubReportMHPSAdultHistory]       
            
@DocumentVersionId  int 
AS                 
BEGIN          
/**************************************************************  
Created By   : Jyothi Bellapu
Created Date : 21th-May-2020  
Description  : Used to Bind The RDL for Medications details in Psycho Social Child Screen
Called From  : 'PsychoSocial Child'  
/*09/18/2020		Packia		Added IsChecked column condition. KCMHSAS Improvements #7*/
**************************************************************/                


--SELECT dbo.csf_GetGlobalCodeNameById(CMCHI.CurrentHealthIssues)
--from CustomMHAssessmentCurrentHealthIssues CMCHI
--WHERE CMCHI.DocumentVersionId= @DocumentVersionId
    
DECLARE @CurrentHealthIssues VARCHAR(MAX)
DECLARE @PastHealthIssues VARCHAR(MAX) 
DECLARE @FamilyHistory VARCHAR(MAX)

SELECT @CurrentHealthIssues = COALESCE(@CurrentHealthIssues+' , ' ,'') + dbo.csf_GetGlobalCodeNameById(CMCHI.CurrentHealthIssues)
FROM CustomMHAssessmentCurrentHealthIssues CMCHI
WHERE CMCHI.DocumentVersionId= @DocumentVersionId AND CMCHI.IsChecked='Y'
--SELECT @CurrentHealthIssues AS CurrentHealthIssues
    

SELECT @PastHealthIssues = COALESCE(@PastHealthIssues+' , ' ,'') + dbo.csf_GetGlobalCodeNameById(CMCPHI.PastHealthIssues)
FROM CustomMHAssessmentPastHealthIssues CMCPHI
WHERE CMCPHI.DocumentVersionId= @DocumentVersionId AND CMCPHI.IsChecked='Y'
--SELECT @PastHealthIssues AS PastHealthIssues


SELECT @FamilyHistory = COALESCE(@FamilyHistory+' , ' ,'') + dbo.csf_GetGlobalCodeNameById(CMCHFH.FamilyHistory)
FROM CustomMHAssessmentFamilyHistory CMCHFH
WHERE CMCHFH.DocumentVersionId= @DocumentVersionId AND CMCHFH.IsChecked='Y'
--SELECT @FamilyHistory AS FamilyHistory

SELECT @CurrentHealthIssues AS CurrentHealthIssues , @PastHealthIssues AS PastHealthIssues ,@FamilyHistory AS FamilyHistory
--Checking For Errors                  
  If (@@error!=0)                  
  Begin                  

      RAISERROR ('csp_RdlSubReportMHPSAdultHistory failed.  Please contact your system administrator. We apologize for the inconvenience.',16,1)                   
   Return                  
   End                  
           
                
      
End




GO


