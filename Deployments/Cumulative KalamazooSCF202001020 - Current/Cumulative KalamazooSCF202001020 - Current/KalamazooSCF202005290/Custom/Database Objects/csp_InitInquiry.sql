  IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitInquiry]')
			AND type IN (	
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_InitInquiry]
GO
                  
Create PROCEDURE [DBO].[csp_InitInquiry]               
 (                  
 @ClientID INT                  
 ,@StaffID INT                  
 ,@CustomParameters XML                  
 )                  
AS                  
-- =============================================                      
-- Author      : vinay                   
-- Date        : 26/Dec/2017                    
-- Purpose     : Initializing SP Created for Custom Inquiries               
-- =============================================                     
BEGIN                  
 BEGIN TRY     
 SELECT 'CustomInquiries' AS TableName                
			,- 1 AS InquiryId                
			,'' AS CreatedBy                
			,GETDATE() AS CreatedDate                
			,'' AS ModifiedBy                
			,GETDATE() AS ModifiedDate,                
			RecordDeleted,                
			DeletedBy,                
			DeletedDate,                
			@StaffID as RecordedBy,                
			@StaffID as GatheredBy
			 FROM systemconfigurations s                
	 LEFT OUTER JOIN CustomInquiries  ON InquiryId = -1     
	 
	 SELECT 'CustomDispositions' AS TableName                
  ,- 1 AS CustomDispositionId                
  ,'' AS CreatedBy                
  ,GETDATE() AS CreatedDate                
  ,'' AS ModifiedBy                
  ,GETDATE() AS ModifiedDate                  
  FROM systemconfigurations s                
 LEFT OUTER JOIN InquiryDispositions  ON InquiryId = -1                 
                 
SELECT 'CustomServiceDispositions' AS TableName                
  ,- 1 AS CustomDispositionId                
  ,'' AS CreatedBy                
  ,GETDATE() AS CreatedDate                
  ,'' AS ModifiedBy                
  ,GETDATE() AS ModifiedDate                  
  FROM systemconfigurations s                
 LEFT OUTER JOIN InquiryServiceDispositions  ON InquiryDispositionId = -1                 
                 
SELECT 'CustomProviderServices' AS TableName                
  ,- 1 AS CustomServiceDispositionId                
  ,'' AS CreatedBy                
  ,GETDATE() AS CreatedDate                
  ,'' AS ModifiedBy                
  ,GETDATE() AS ModifiedDate                  
  FROM systemconfigurations s                
 LEFT OUTER JOIN InquiryProviderServices  ON InquiryServiceDispositionId = -1  
                                    
  ; With CTE AS(Select                    
  'CustomInquiryCoverageInformations' AS TableName            
  --,- 1 AS InquiryCoverageInformationId                   
  ,CRCP.CreatedBy                           
  ,CRCP.CreatedDate                           
  ,CRCP.ModifiedBy                           
  ,CRCP.ModifiedDate                          
  ,CRCP.RecordDeleted                        
  ,CRCP.DeletedBy                           
  ,CRCP.DeletedDate                  
  ,-1 as InquiryId                           
  ,CRCP.CoveragePlanId  
  ,CRCP.InsuredId                           
  ,CRCP.GroupNumber AS GroupId                  
  ,CRCP.Comment    
  ,CRCP.ClientId       
  ,ROW_NUMBER() OVER (    
    PARTITION BY  CRCP.CoveragePlanId  ,CRCP.InsuredId    
    ORDER BY CRCP.CoveragePlanId  
    )  as RRank               
     FROM ClientCoveragePlans CRCP                  
 left join CoveragePlans CP on CP.CoveragePlanId = CRCP.CoveragePlanId                  
   where ISNULL(CRCP.RecordDeleted, 'N') = 'N' and ISNULL(CP.RecordDeleted, 'N') = 'N' and ClientId =@ClientID   )    
   Select * from CTE Where   RRank=1        
                    
 END TRY                  
                  
 BEGIN CATCH                  
  DECLARE @Error VARCHAR(8000)                  
                  
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_InitInquiry') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())                  
                  
  RAISERROR (                  
    @Error                  
    ,-- Message text.                                                                                                                    
    16                  
    ,-- Severity.                                        
    1 -- State.                                                                                                                    
    );                  
 END CATCH                  
END 