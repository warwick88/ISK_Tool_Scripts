/****** Object:  StoredProcedure [dbo].[csp_RDLAssessmentPCAFAS]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLMHAssessmentPCAFAS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLMHAssessmentPCAFAS] --1670
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLMHAssessmentPCAFAS]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE  [dbo].[csp_RDLMHAssessmentPCAFAS] --416  
(                                                                                                                                                                                        
  @DocumentVersionId int                                                                                                                                                        
)                                                     
As                                                                                                                                    
                                                                                                                                  
 /*********************************************************************/
 /* Stored Procedure: [csp_PostUpdateMHAssessment]   */

 /*       Date              Author                  Purpose                   */ 
 /*       28/May/2020      Jyothi Bellapu        RDL SP for PCAFAS Tab part of Kalamazoo - Improvements -#7*/
 /*********************************************************************/  
                                                                                                    
                                                                                                                                
                                                                                                   
BEGIN Try                     
Begin                    
  
SELECT
		
			 replace(replace(SchoolDayCare, '&lt;', '<'), '&gt;', '>') as SchoolDayCare
			,replace(replace(HomeRolePerformance, '&lt;', '<'), '&gt;', '>') as HomeRolePerformance
			,replace(replace(CommunityRolePerformance, '&lt;', '<'), '&gt;', '>') as CommunityRolePerformance
			,replace(replace(BehaviourTowardOthers, '&lt;', '<'), '&gt;', '>') as BehaviourTowardOthers
			,replace(replace(MoodsEmotions, '&lt;', '<'), '&gt;', '>') as MoodsEmotions
			,replace(replace(SelfHarmfulBehavior, '&lt;', '<'), '&gt;', '>') as SelfHarmfulBehavior
			,replace(replace(ThinkingCommunication, '&lt;', '<'), '&gt;', '>') as ThinkingCommunication
			,replace(replace(TotalChild, '&lt;', '<'), '&gt;', '>') as TotalChild
			,replace(replace(PrimaryScaleScore, '&lt;', '<'), '&gt;', '>') as PrimaryScaleScore
			,replace(replace(OtherScaleScore, '&lt;', '<'), '&gt;', '>') as OtherScaleScore
			,replace(replace(MaterialNeeds1, '&lt;', '<'), '&gt;', '>') as MaterialNeeds1
			,replace(replace(MaterialNeeds2, '&lt;', '<'), '&gt;', '>') as MaterialNeeds2
			,replace(replace(FamilySocialSupport1, '&lt;', '<'), '&gt;', '>') as FamilySocialSupport1
			,replace(replace(FamilySocialSupport2, '&lt;', '<'), '&gt;', '>') as FamilySocialSupport2
     
      FROM  CustomDocumentAssessmentPECFASs    
      WHERE DocumentVersionId=@DocumentVersionId   
  
                                                  
 end                                                                        
 END TRY                                                                                 
                     
                    
                                                                       
 BEGIN CATCH                                   
   DECLARE @Error varchar(8000)                                                                                                                 
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                      
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RDLMHAssessmentPCAFAS')                                                                                                              
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                                                                                     
          
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                                            
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                     
                                                                                                                
 END CATCH   