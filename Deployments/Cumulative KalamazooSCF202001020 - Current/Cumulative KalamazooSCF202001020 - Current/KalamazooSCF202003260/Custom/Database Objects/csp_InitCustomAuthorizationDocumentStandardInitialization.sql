

/****** Object:  StoredProcedure [dbo].[csp_InitCustomAuthorizationDocumentStandardInitialization]    Script Date: 11/19/2013 16:07:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomAuthorizationDocumentStandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomAuthorizationDocumentStandardInitialization]
GO


/****** Object:  StoredProcedure [dbo].[csp_InitCustomAuthorizationDocumentStandardInitialization]    Script Date: 11/19/2013 16:07:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



 Create PROCEDURE  [dbo].[csp_InitCustomAuthorizationDocumentStandardInitialization]                         
(                                                  
 @ClientId int,                    
 @StaffID int,                  
 @CustomParameters xml                                                                
)                                                                          
As                                                                            
 /*********************************************************************/                                                                                      
 /* Stored Procedure: [csp_InitCustomAuthorizationDocumentStandardInitialization]               */                                                                                                                                                          
 /* Copyright: 2006 Streamline SmartCare*/                                                                                      
                                                                                                                                                            
 /*       Date              Author                  Purpose                                    */                                                                                      
 /*       Sept22,2009       Mohit Madaan  Create Standard Initlization for Authorization Document */            
 /*       Nov18,2009           Ankesh                Made changes as paer dataModel SCWebVenture3.0  */                            
 /* 10 Dec 2009   Ankesh       Modified According to an task# 139                                */        
 /* 17July2010   Loveena    Modified As ref to Task#13 to get latest signed document*/
 /*03 April 2012 Rakesh Garg  Task 634 in Kalamazoo bugs Information from previous documnent shoouldn't intialize */
 /*12-03-2020   Kavya.N  Added JOIN condition with CustomLOCs since the data is coming from CustomClientLOCs even if the records are deleted in the parent table(CustomLOCs)--KCMHSAS - Support#859*/
  /*********************************************************************************************/                        
Begin                                                              
                    
Begin try         
                                            
        
--declare @LatestDocumentVersionID int                                         
-- set @LatestDocumentVersionID =(select top 1 CurrentDocumentVersionId                    
--from Documents a                                        
--where a.ClientId = @ClientID                                        
--and a.EffectiveDate <= convert(datetime, convert(varchar, getDate(),101))                                        
--and a.Status = 22    
--and a.DocumentCodeId=253                                         
--and isNull(a.RecordDeleted,'N')<>'Y'                                                                           
--order by a.EffectiveDate desc,a.ModifiedDate desc )                                                                                                 
--if(exists(Select * from CustomAuthorizationDocuments C,Documents D ,                            
-- DocumentVersions V                                                       
--    where C.DocumentVersionId=V.DocumentVersionId and D.DocumentId = V.DocumentId                            
--     and D.ClientId=@ClientID                                                            
--and D.Status=22 and IsNull(C.RecordDeleted,'N')='N' and IsNull(D.RecordDeleted,'N')='N' ))                                                      
--BEGIN                                          
---- For CustomAuthorizationDocument and TpProcedure                                    
           
--SELECT     'TPProcedures' AS TableName, 'CustomGrid' AS ParentChildName, TP.TPProcedureId, TP.DocumentVersionId, TP.AuthorizationCodeId, TP.Units, TP.FrequencyType, TP.ProviderId, TP.SiteId,             
--                      TP.StartDate, TP.EndDate, TP.TotalUnits,A.AuthorizationCodeName AS AuthorizationCodeIdText,   
--                      TP.AuthorizationId,CASE isnull(P.ProviderName, 'N') WHEN 'N' THEN '' ELSE P.ProviderName END + CASE isnull(Tp.ProviderId, '0')       
--       WHEN '0' THEN Ag.AgencyName ELSE '' END AS ProviderIdText, TP.RowIdentifier, TP.CreatedBy, TP.CreatedDate, TP.ModifiedBy, TP.ModifiedDate, TP.RecordDeleted,             
--                      TP.DeletedDate, TP.DeletedBy,'Requested' as [Status]      
--FROM         Agency AS Ag CROSS JOIN      
--       TPProcedures AS TP LEFT OUTER JOIN      
--       Providers AS P ON P.ProviderId = TP.ProviderId AND (P.RecordDeleted = 'N' OR      
--       P.RecordDeleted IS NULL) AND (TP.RecordDeleted = 'N' OR      
--       TP.RecordDeleted IS NULL) INNER JOIN      
--       AuthorizationCodes AS A ON TP.AuthorizationCodeId = A.AuthorizationCodeId AND (A.RecordDeleted = 'N' OR      
--       A.RecordDeleted IS NULL)            
----       INNER JOIN            
----                      DocumentVersions AS DV ON TP.DocumentVersionId = DV.DocumentVersionId AND TP.DocumentVersionId = DV.DocumentVersionId INNER JOIN            
----                      Documents AS D ON DV.DocumentId = D.DocumentId AND DV.DocumentId = D.DocumentId            
----WHERE     (D.ClientId = @ClientID) AND (ISNULL(TP.RecordDeleted, 'N') = 'N') AND (D.Status = 22) AND (ISNULL(TP.RecordDeleted, 'N') = 'N') AND (ISNULL(D.RecordDeleted, 'N')             
----                      = 'N')            
----ORDER BY DV.DocumentVersionId DESC            
--where TP.DocumentVersionId=@LatestDocumentVersionID   AND (ISNULL(TP.RecordDeleted, 'N') = 'N')          
                                           
--      ------For CustomAuthorizationDocuments----                                                            
--      SELECT     TOP (1) 'CustomAuthorizationDocuments' AS TableName, 'Y' As IsChildTable, CA.DocumentVersionId, CA.ClientCoveragePlanId, CA.AuthorizationRequestorComment,             
--                      CA.AuthorizationReviewerComment, DC.DocumentName, CA.Assigned, CA.CreatedBy, CA.CreatedDate, CA.ModifiedBy, CA.ModifiedDate, CA.RecordDeleted,             
--                CA.DeletedDate, CA.DeletedBy            
--FROM         CustomAuthorizationDocuments AS CA INNER JOIN            
--                      --DocumentVersions AS DV ON CA.DocumentVersionId = DV.DocumentVersionId AND CA.DocumentVersionId = DV.DocumentVersionId INNER JOIN            
--                      Documents AS D ON D.CurrentDocumentVersionId = CA.DocumentVersionId INNER JOIN            
--                      DocumentCodes AS DC ON DC.DocumentCodeId = D.DocumentCodeId            
--WHERE     (ISNULL(CA.RecordDeleted, 'N') = 'N') AND (ISNULL(CA.RecordDeleted, 'N') = 'N')         
--    --AND (ISNULL(DV.RecordDeleted, 'N') = 'N')         
--    AND (ISNULL(D.RecordDeleted, 'N') = 'N')             
--                      AND (ISNULL(DC.RecordDeleted, 'N') = 'N') AND (D.ClientId = @ClientID)         
--                      AND CA.DocumentVersionId=@LatestDocumentVersionID                 
----ORDER BY DV.DocumentVersionId DESC                                                                                         
--END                                                      
--else                                                      
--BEGIN                            
 -- For CustomAuthorizationDocuments                                           
            
SELECT TOP 1 'CustomAuthorizationDocuments' AS TableName,  -1 as DocumentVersionId                  
      ,CA.[ClientCoveragePlanId],CA.[AuthorizationRequestorComment],CA.[AuthorizationReviewerComment]                  
      ,DC.DocumentName,CA.[Assigned],'' as CreatedBy,                              
getdate() as CreatedDate,                              
'' as ModifiedBy,                              
getdate() as ModifiedDate  ,CA.[RecordDeleted],CA.[DeletedDate],CA.[DeletedBy]                  
FROM systemconfigurations s              
left outer join CustomAuthorizationDocuments  as CA   on s.Databaseversion=-1                                                                                       
     left join DocumentVersions DV                 
      on CA.DocumentVersionId = DV.DocumentVersionId left join Documents D                
      on D.DocumentId = DV.DocumentId left join DocumentCodes DC                 
      on DC.DocumentCodeId = D.DocumentCodeId WHERE  ISNULL(CA.RecordDeleted,'N')='N'                      
      AND ISNULL(CA.RecordDeleted,'N')='N' AND ISNULL(DV.RecordDeleted,'N')='N'                 
      AND ISNULL(D.RecordDeleted,'N')='N' AND ISNULL(DC.RecordDeleted,'N')='N'                
                                    
--END 


--Added By Rakesh for UM Part 2 As Introduce LOCID 10 Jan 2010
if exists (SELECT ClientLOCId from CustomClientLOCs where ClientId = @ClientID and LOCEndDate IS NULL and Isnull(RecordDeleted,'N') = 'N')          
 Begin             
 select  top 1 CCL.ClientLOCId,CCL.ClientId, CCL.CreatedBy, CCL.CreatedDate, CCL.ModifiedBy,         
 CCL.ModifiedDate, CCL.RecordDeleted, CCL.DeletedDate, CCL.DeletedBy, CCL.LOCId, CCL.LOCStartDate, CCL.LOCEndDate, CCL.LOCBy ,   
 'CustomClientLOCs' as TableName,'N' as IsInitialize               
 from CustomClientLOCs CCL join CustomLOCs CL on CL.LOCId = CCL.LOCId  and Isnull(CL.RecordDeleted,'N') = 'N' 
 where ClientId = @ClientID  
 and LOCEndDate IS NULL and Isnull(CCL.RecordDeleted,'N') = 'N' order by 1 desc                                                            
 End          
 else            
 Begin          
  select  -1 as ClientLOCId,@ClientID as ClientId, -1 as LOCId  , '' as CreatedBy,               
  getdate() as CreatedDate, '' as ModifiedBy, getdate() as ModifiedDate, 'CustomClientLOCs' as TableName              
 End  



                                                   
end try                                                              
                                                                                                     
BEGIN CATCH                  
DECLARE @Error varchar(8000)                                                               
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                         
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_InitCustomDiagnosisStandardInitialization')                                                                                             
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


