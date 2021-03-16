
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomMHAssessmentCAFAS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomMHAssessmentCAFAS]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLCustomMHAssessmentCAFAS]    Script Date: 11/27/2013 16:30:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE  [dbo].[csp_RDLCustomMHAssessmentCAFAS] --12907
(                                                                                                                                                                                        
  @DocumentVersionId int                                                                                                                                                        
)                                                     
As                                                                                                                                    
                                                                                                                                  
/*********************************************************************/                                                                                                                                      
/* Stored Procedure: dbo.[csp_RDLCustomMHAssessmentCAFAS]    2012661                 */                                                                                                                              
/* Input Parameters:  @DocumentVersionId							 */                                                                                                                                    
/* Output Parameters:   None										 */ 
/* Return:  0=success, otherwise an error number                     */                                                                                                                                      
/* Called By:                                                        */                                                                                                                                      
/* Data Modifications:												 */                                          
/*      */                                                                                     
/* Updates:                                                                                       
 Date			Author      Purpose       
 ----------  --------- --------------------------------------                                                                               
 May 31 2020   Jyothi Bellapu          Get data for CAFAS Tab as part of KCMHSAS - Improvements -#7
           
*/                                                                                                           
/*********************************************************************/                                                                                                     
                                                                                                                                
                                                                                                   
BEGIN TRY                     
	BEGIN        
	  DECLARE @OrganizationName varchar(250)  
      SELECT top 1 @OrganizationName= OrganizationName from SystemConfigurations  
	
	            
	   SELECT @OrganizationName as OrganizationName  
             ,CONVERT(VARCHAR(10), D.EffectiveDate, 101)  as EffectiveDate    
             ,D.ClientId  
             ,CASE  WHEN ISNULL(C.ClientType, 'I') = 'I'   THEN ISNULL(C.LastName, '') + ' ' + ISNULL(C.FirstName, '')  
								ELSE ISNULL(C.OrganizationName, '')  END  AS ClientName     
			  ,CONVERT(VARCHAR(10), C.DOB, 101) as DOB   
			  ,DC.DocumentName
			  ,CASE WHEN ISNULL(C.Sex,'')='M' THEN 'Male' 
		       WHEN ISNULL(C.Sex,'')='F' THEN 'Female' 
		       WHEN ISNULL(C.Sex,'')='U' THEN 'UNknown' END Gender
			  ,[DocumentVersionId]
			  ,CAFAS.[CreatedBy]
			  ,CAFAS.[CreatedDate]
			  ,CAFAS.[ModifiedBy]
			  ,CAFAS.[ModifiedDate]
			  ,CAFAS.[RecordDeleted]
			  ,CAFAS.[DeletedBy]
			  ,CAFAS.[DeletedDate]
			  ,CAFAS.[CAFASDate]
			  ,Staff1.DisplayAs  AS RaterClinician
			  ,dbo.csf_GetGlobalCodeNameById(CAFAS.[CAFASInterval]) AS CAFASInterval
			  ,CAFAS.[SchoolPerformance]
			  ,CAFAS.[SchoolPerformanceComment]
			  ,CAFAS.[HomePerformance]
			  ,CAFAS.[HomePerfomanceComment]
			  ,CAFAS.[CommunityPerformance]
			  ,CAFAS.[CommunityPerformanceComment]
			  ,CAFAS.[BehaviorTowardsOther]
			  ,CAFAS.[BehaviorTowardsOtherComment]
			  ,CAFAS.[MoodsEmotion]
			  ,CAFAS.[MoodsEmotionComment]
			  ,CAFAS.[SelfHarmfulBehavior]
			  ,CAFAS.[SelfHarmfulBehaviorComment]
			  ,CAFAS.[SubstanceUse]
			  ,CAFAS.[SubstanceUseComment]
			  ,CAFAS.[Thinkng]
			  ,CAFAS.[ThinkngComment]
			  ,CAFAS.[YouthTotalScore]
			  ,CAFAS.[PrimaryFamilyMaterialNeeds]  
			  ,CAFAS.[PrimaryFamilyMaterialNeedsComment]
			  ,CAFAS.[PrimaryFamilySocialSupport]
			  ,CAFAS.[PrimaryFamilySocialSupportComment]
			  ,CAFAS.[NonCustodialMaterialNeeds]
			  ,CAFAS.[NonCustodialMaterialNeedsComment]
			  ,CAFAS.[NonCustodialSocialSupport]
			  ,CAFAS.[NonCustodialSocialSupportComment]
			  ,CAFAS.[SurrogateMaterialNeeds]
			  ,CAFAS.[SurrogateMaterialNeedsComment]
			  ,CAFAS.[SurrogateSocialSupport]
			  ,CAFAS.[SurrogateSocialSupportComment]
		  FROM [CustomDocumentMHAssessmentCAFASs] CAFAS
		  JOIN Documents D ON D.InProgressDocumentVersionId=CAFAS.DocumentVersionId
		  JOIN Clients C ON C.ClientId=D.ClientId
		  JOIN DocumentCodes DC ON DC.DocumentCodeId=D.DocumentCodeId
		  Left Join Staff as Staff1 with (nolock) on Staff1.StaffId = CAFAS.RaterClinician 
		  WHERE  CAFAS.DocumentVersionId = @DocumentVersionId 
		  AND  ISNULL(CAFAS.RecordDeleted, 'N') = 'N'  
		  AND ISNULL(D.RecordDeleted, 'N') = 'N'  
		  AND ISNULL(DC.RecordDeleted, 'N') = 'N'                                                  
	 END                                                                          
 END TRY                                                                                
                                                                                       
 BEGIN CATCH                                   
   DECLARE @Error varchar(8000)                                                                                                                 
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                      
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RDLCustomMHAssessmentCAFAS')                                                                                                              
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                                                                                     
          
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                                            
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                     
                                                                                                                
 END CATCH   