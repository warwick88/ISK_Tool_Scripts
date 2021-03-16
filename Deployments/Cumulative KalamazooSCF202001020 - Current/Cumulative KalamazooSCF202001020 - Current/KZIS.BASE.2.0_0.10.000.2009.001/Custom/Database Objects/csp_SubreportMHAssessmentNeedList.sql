 
 
/****** Object:  StoredProcedure [dbo].[csp_SubreportMHAssessmentNeedList]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SubreportMHAssessmentNeedList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SubreportMHAssessmentNeedList]
GO

/****** Object:  StoredProcedure [dbo].[csp_SubreportMHAssessmentNeedList]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
 CREATE PROCEDURE [dbo].[csp_SubreportMHAssessmentNeedList]                                            
(      
@DocumentVersionId  int           
)    
AS                                                                                                                                                        
/*********************************************************************/
 /* Stored Procedure: [csp_SubreportMHAssessmentNeedList]   */

 /*       Date              Author                  Purpose                   */ 
 /*       28/May/2020      Jyothi Bellapu          RDL Sp for Custom Needs as  part of Kalamazoo - Improvements -#7*/
 /*		  07/10/2020		Packia					Added condition to sort based n Domain Name. KCMHSAS Improvements #7*/
 /*********************************************************************/                         
BEGIN TRY    
    
BEGIN    
 SELECT CPN.[CarePlanNeedId]    
  ,CPN.[DocumentVersionId]    
  ,CPN.[CarePlanDomainNeedId]    
  ,CPN.[NeedDescription]    
  ,CPN.[AddressOnCarePlan]    
  ,CPN.[Source]    
  ,CPD.[CarePlanDomainId]    
  ,CPDN.[NeedName]    
  ,CASE CPN.[Source]    
   WHEN 'C' THEN 'Care Plan'     
   END AS SourceName    
   ,CPD.DomainName 
 FROM CarePlanNeeds CPN    
 JOIN CarePlanDomainNeeds CPDN ON CPDN.CarePlanDomainNeedId = CPN.CarePlanDomainNeedId    
 JOIN CarePlanDomains CPD ON CPD.CarePlanDomainId = CPDN.CarePlanDomainId    
 WHERE ISNull(CPN.RecordDeleted, 'N') = 'N'    
  AND CPN.DocumentVersionId = @DocumentVersionId   Order by  CPD.DomainName 
    
END    
    
END TRY                                                                            
BEGIN CATCH                                
DECLARE @Error varchar(8000)                                                                          
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                       
+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_SubreportMHAssessmentNeedList')                                                                                                           
+ '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                            
+ '*****' + Convert(varchar,ERROR_STATE())                                                        
RAISERROR                                                                                                           
(                                                                             
@Error, -- Message text.         
16, -- Severity.         
1 -- State.                                                           
);                                                                                                        
END CATCH      