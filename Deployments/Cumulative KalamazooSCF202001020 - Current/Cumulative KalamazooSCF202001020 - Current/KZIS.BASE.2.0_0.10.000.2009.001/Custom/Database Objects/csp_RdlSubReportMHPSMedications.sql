/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportMHPSMedications]  ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportMHPSMedications]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlSubReportMHPSMedications]
GO

/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportMHPSMedications]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[csp_RdlSubReportMHPSMedications]       
            
@DocumentVersionId  int 
AS                 
BEGIN          
/**************************************************************  
Created By   : Jyothi Bellapu
Created Date : 21th-May-2020  
Description  : Used to Bind The RDL for Medications details in Psycho Social Child Screen
Called From  : 'PsychoSocial Child'  
**************************************************************/                


Select 
HRMAssessmentMedicationId,

DocumentVersionId,
Name,
Dosage,
Purpose,
PrescribingPhysician
From 
CustomHRMAssessmentMedications where DocumentVersionId=@DocumentVersionId
    

    
--Checking For Errors                  
  If (@@error!=0)                  
  Begin                  

      RAISERROR ('csp_RdlSubReportMHPSMedications failed.  Please contact your system administrator. We apologize for the inconvenience.',16,1)                   
   Return                  
   End                  
           
                
      
End




GO


