 /****** Object:  StoredProcedure [dbo].[csp_RDLSubReportSignatureImages]    Script Date: 07/25/2013 16:25:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportSignatureImages]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].csp_RDLSubReportSignatureImages
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO  

CREATE PROCEDURE  [dbo].[csp_RDLSubReportSignatureImages]        
(                                        
@DocumentVersionId int                                     
)                                        
As

/*************************************************************************/                                                                
/* Stored Procedure: csp_RDLSubReportSignatureImages					 */                                                                                                                     
/* Creation Date:  25 July 2013											 */                                                                                                                           
/* Purpose: Gets Data for Health History								 */                                                               
/* Input Parameters: @DocumentVersionId									 */                                                              
/* Output Parameters:													 */                                                                                                                                                                                                                                                
/* Author: Gayathri Naik											     */      
/* Pull this sp from Newaygo database from 3.5xMerged with task #25 in Ionia County CMH - Customizations*/   
/*************************************************************************/     
       
                         
Begin                          
  DECLARE @DocumentId INT     
  DECLARE @Need5Columns char(1)                         
  SET @DocumentId = (Select Distinct DocumentId from DocumentSignatures Where SignedDocumentVersionId = @DocumentVersionId);    
  SET @Need5Columns = (SELECT DocumentCodes.Need5Columns FROM DocumentCodes INNER JOIN Documents ON DocumentCodes.DocumentCodeId = Documents.DocumentCodeId WHERE Documents.DocumentId = @DocumentId);  
-- If the isClient='Y'  Then Get The name from client other wise from staff,Signername from DocumentSignature Table                        
select a.SignatureID,a.DocumentID,a.VerificationMode ,       
                     
case                                 
when a.IsClient='Y' then                         
 RTRIM(c.lastName+', '+ c.Firstname)                        
else                           
IsNull(a.SignerName, IsNull(b.Firstname,'')+' '+IsNull(b.LastName,''))                  
end as 'SignerName',      
                      
                      
case                               
 WHEN ISNULL(DeclinedSignature,'N')='Y' THEN                              
  ' (Signature not available)'                        
 WHEN ISNULL(ClientSignedPaper,'N')='Y' THEN                              
  ' (Signed Paper Copy)'                        
 ELSE                         
''                      
end as 'Signature',                
DeclinedSignature,      
a.StaffId,    
a.PhysicalSignature ,    
    
Case WHEN a.RelationToClient IS NOT NULL THEN dbo.csf_GetGlobalCodeNameById(a.RelationToClient)    
        WHEN a.StaffId IS NULL THEN ' Client' ELSE ' Clinician' End As Relation,      
  case WHEN ISNULL(a.ClientSignedPaper,'N')='Y' THEN ' See Paper Copy' ELSE CONVERT(VARCHAR(10),a.SignatureDate,101) end as 'SignatureDate'  ,  
  Case WHEN a.staffid IS NOT NULL THEN dbo.csf_GetDegrees(a.staffid)    
         ELSE '' end as 'Degree' ,  
         @Need5Columns As 'Need5Columns'   
                      
from documentSignatures a               
left join Staff b on a.staffid=b.staffid                          
left join Clients c ON c.Clientid=a.Clientid    
LEFT JOIN DocumentVersions DV on DV.DocumentVersionId =  a.SignedDocumentVersionId                          
where a.DocumentId=@DocumentId and     
(a.SignatureDate is Not Null OR ISNULL(DeclinedSignature,'N')='Y')     
and (a.RecordDeleted='N' or a. RecordDeleted Is  NULL)             
--AND (a.SignedDocumentVersionId = @DocumentVersionId)                   
                        
 IF (@@error!=0)                   
    BEGIN                        
        RAISERROR('csp_RDLSubReportSignatureImages: An Error Occured',10,1)                        
        RETURN(1)                        
                            
    END                        
                        
RETURN(0)                        
                        
END             