

/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportMHSubstanceUse]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportMHSubstanceUse]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportMHSubstanceUse]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportMHSubstanceUse]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    
CREATE PROCEDURE  [dbo].[csp_RDLSubReportMHSubstanceUse]                           
(                                          
  @DocumentVersionId int                  
)                                           
As                                                                                                                                                          
/************************************************************/                                                                  
/* Stored Procedure: csp_RDLSubReportMHSubstanceUse           */                                                                                                                   
/* Creation Date:       */                                                                                                                               
/* Purpose: Gets Data for Substance USE    */                                                                 
/* Input Parameters: @DocumentVersionId      */                                                                                                                            
/* Author:         */      
    
/************************************************************/                                                                                                                                              
BEGIN TRY                                         
       
  BEGIN        
   SELECT     
  CDA.DocumentVersionId     
 ,CDA.CreatedBy      
 ,CDA.CreatedDate      
 ,CDA.ModifiedBy      
 ,CDA.ModifiedDate      
 ,CDA.RecordDeleted      
 ,CDA.DeletedBy      
 ,CDA.DeletedDate      
 ,CDA.UseOfAlcohol      
 ,CDA.AlcoholAddToNeedsList      
 ,CDA.UseOfTobaccoNicotine      
 ,CASE WHEN CDA.UseOfTobaccoNicotineQuit IS NOT NULL
		THEN CONVERT(VARCHAR(10), CDA.UseOfTobaccoNicotineQuit, 101)
	ELSE '' END UseOfTobaccoNicotineQuit     
 ,CDA.UseOfTobaccoNicotineTypeOfFrequency      
 ,CDA.UseOfTobaccoNicotineAddToNeedsList      
 ,CDA.UseOfIllicitDrugs      
 ,CDA.UseOfIllicitDrugsTypeFrequency      
 ,CDA.UseOfIllicitDrugsAddToNeedsList      
 ,CDA.PrescriptionOTCDrugs      
 ,CDA.PrescriptionOTCDrugsTypeFrequency      
 ,CDA.PrescriptionOTCDrugsAddtoNeedsList 
 ,CDA.DrinksPerWeek
 ,CASE WHEN CDA.LastTimeDrinkDate IS NOT NULL
    THEN   CONVERT(VARCHAR(10),CDA.LastTimeDrinkDate,101) 
	ELSE '1/1/1900' END AS LastTimeDrinkDate
	,CDA.LastTimeDrinks
	,CDA.IllegalDrugs
	,CDA.BriefCounseling
	,CDA.FeedBackOnAlcoholUse
	,CDA.Harms
	,CDA.DevelopmentOfPlans
	,CDA.Refferal
	,CDA.DDOneTimeOnly
	,CDA.NotApplicable     
 FROM CustomDocumentAssessmentSubstanceUses CDA        
   WHERE DocumentVersionId = @DocumentVersionId     
   

        
 END      
                                                                                         
 END TRY                                                                                                     
 BEGIN CATCH                                                       
   DECLARE @Error varchar(8000)                                                                                                                                     
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                          
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RDLSubReportMHSubstanceUse')                         
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                          
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                                                                
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                         
                                                                                                                                    
 END CATCH 
GO


