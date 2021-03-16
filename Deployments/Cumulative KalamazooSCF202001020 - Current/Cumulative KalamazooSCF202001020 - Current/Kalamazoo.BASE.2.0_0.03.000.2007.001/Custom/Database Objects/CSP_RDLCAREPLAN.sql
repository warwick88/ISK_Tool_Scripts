 IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[CSP_RDLCAREPLAN]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[CSP_RDLCAREPLAN] 
GO
CREATE PROCEDURE [DBO].[CSP_RDLCAREPLAN]  --2013868
 (  
  @DocumentVersionId AS INT    
 )      
AS  
       
/******************************************************************************************************/                                                            
/* Stored Procedure: ssp_RdlCarePlan                                                                  */                                                   
/*        */                                                            
/* Creation Date:  24 Dec 2014                                                                        */                                                            
/*                                                                                                    */                                                            
/* Purpose: Gets Data for CSP_RDLCAREPLAN                                                             */                                                           

/*****************************************************************************/        
BEGIN   
 DECLARE @DocumentCodeID INT  
SELECT @DocumentCodeID= DocumentcodeID from DocumentCodes where Code='8AF7837B-05A7-4DF8-B2ED-6B852A5BA50A'     
print @DocumentCodeID
 SELECT @DocumentVersionId AS DocumentVersionId  
 ,(select OrganizationName from SystemConfigurations) as OrganizationName  
  ,d.EffectiveDate  
  ,d.ClientId  
  --Pavani  4/5/2016  
  ,(  
   SELECT DocumentName  
   FROM DocumentCodes  
   WHERE DocumentcodeId = @DocumentCodeID  
   ) AS DocumentName  
  ,(  
   SELECT upper(Value)  
   FROM SystemConfigurationKeys  
   WHERE [Key] = 'SHOWORGANIZATIONNAMEONCAREPLANRDL'  
   ) AS SHOWORGANIZATIONNAMEONCAREPLANRDL  
 FROM DocumentVersions dv  
 INNER JOIN Documents d ON dv.DocumentId = d.DocumentId  
  AND isnull(d.RecordDeleted, 'N') = 'N'  
 WHERE isnull(dv.RecordDeleted, 'N') = 'N'  
  AND dv.DocumentVersionId = @DocumentVersionId  
   
END  