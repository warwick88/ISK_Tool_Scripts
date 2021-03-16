

/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportHRMTPClientNeeds]    Script Date: 11/27/2013 18:59:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportHRMTPClientNeeds]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportHRMTPClientNeeds]
GO



/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportHRMTPClientNeeds]    Script Date: 11/27/2013 18:59:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_RDLSubReportHRMTPClientNeeds]    
(                                            
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int, --Modified by Anuj Dated 03-May-2010  
@NeedId  int                                        
)                                            
As                                            
  
                                                                                                
/*********************************************************************/                                                      
/* Stored Procedure: csp_RDLSubReportTPGoals    */                                             
                                            
/* Copyright: 2006 Streamline SmartCare*/                                                      
/* Modified By			Modified Date			Purpose*/                                                      
/* Dasari Sunil			29/5/2020				What: Modified logic to remove the needs are with status "Defer" and "Completed/Resolved" on PDF.
												Why: The front end had check condition to show needs with status "Add To Tx Plan" and "Currently On Tx Plan" and avoiding needs with status  "Defer" and "Completed/Resolved".
												So in the PDF also we need to handle the same, KCMHSAS - Support #1423*/                                                      
                                            
/*********************************************************************/     
BEGIN TRY  
 BEGIN                                          
select c.NeedName, c.NeedDescription
From  TPNeeds a 
join CustomTPNeedsClientNeeds b on a.NeedId = b.NeedID
join CustomClientNeeds c on c.ClientNeedId = b.ClientNeedID
--Where a.DocumentId = @DocumentId
--and a.Version = @Version
Where a.DocumentVersionId = @DocumentVersionId  --Modified by Anuj Dated 03-May-2010
and a.NeedId = @NeedId
and isnull(a.RecordDeleted, 'N') = 'N'
and isnull(b.RecordDeleted, 'N') = 'N'
and isnull(c.RecordDeleted, 'N') = 'N' and c.NeedStatus not in (5236,5237)

END
                   
  --Checking For Errors                              
END TRY  
  
BEGIN CATCH  
 DECLARE @Error VARCHAR(8000)  
  
 SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLSubReportHRMTPClientNeeds') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + 
 CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
 RAISERROR (  
   @Error  
   ,-- Message text.           
   16  
   ,-- Severity.           
   1 -- State.                                                             
   );  
END CATCH 

GO

