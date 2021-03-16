/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportServiceNoteFooter]    Script Date: 11/28/2013 18:38:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportServiceNoteFooter]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlSubReportServiceNoteFooter]
GO

/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportServiceNoteFooter]    Script Date: 11/28/2013 18:38:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
        
CREATE PROCEDURE   [dbo].[csp_RdlSubReportServiceNoteFooter]                               
@DocumentVersionId int      
as            
/*            
** Object Name:  [dbo].[csp_RdlSubReportServiceNoteFooter]            
**            
**            
** Notes:  Accepts two parameters (DocumentId & Version) and returns a record set             
**    which matches those parameters. This procedure is used for displaying the            
**    footer information.            
**            
** Programmers Log:            
** Date			  Programmer     Description      
** 28-11-2013		Vithobha	 commented ds.signatureorder = 1 to add co signer      
** 13th Aug 2014  Vichee Humane  modified signaturedate format also given order by  signaturedate desc  
** 08 Oct 2015  Munish Added new parameter PhysicalSignature to display Signature on RDL
** 13 Jan 2021  Amith What:modified the logic for SIGNERNAME. 
				      Why:KCMHSAS - Support #1579
**------------------------------------------------------------------------------------------            
** 19/07/2007 ETECH   Procedure Created.            
*/

  DECLARE @SystemConfigKeyValue VARCHAR(500)  
  DECLARE @ShowElectronicallySignedWordings VARCHAR(20)
  DECLARE @ShowTimeStamp VARCHAR(20)  
    
  SET @SystemConfigKeyValue = (SELECT dbo.ssf_GetSystemConfigurationKeyValue('ShowSigningSuffixORBillingDegreeInSignatureRDL'))
  SET @ShowElectronicallySignedWordings = (SELECT dbo.ssf_GetSystemConfigurationKeyValue('ShowElectronicallySignedTextInSignatureRDL'))  
  SET @ShowTimeStamp = (SELECT dbo.ssf_GetSystemConfigurationKeyValue('ShowTimeAlongWithDateInSignatureRDL')) 
              
SELECT               
case                                     
when DS.IsClient='Y'             
 THEN 
 case 
 when  ISNULL(C.ClientType,'I')='I' 
 then RTRIM(ISNULL(c.FirstName,'') + ' ' + ISNULL(c.LastName,'')) else ISNULL(C.OrganizationName,'') 
 end                                                                                                          
when (@SystemConfigKeyValue='SigningSuffix')
  then IsNull(ST.FirstName,'')+' '+IsNull(ST.LastName,'') +', '+  IsNull(ST.SigningSuffix,'') 
when ds.StaffId IS NOT NULL AND (@SystemConfigKeyValue='BillingDegree' OR  @SystemConfigKeyValue='OnlyBillingDegree') 
  then IsNull(ST.FirstName,'')+' '+IsNull(ST.LastName,'') + IsNull((select dbo.ssf_GetDocumentSignatureCredentials(ST.staffid, @DocumentVersionId)),'')  --fetches degree(Only or All)                
else                               
IsNull(DS.SignerName, IsNull(ST.FirstName,'')+' '+IsNull(ST.LastName,''))                      
end as 'SIGNERNAME',
@ShowElectronicallySignedWordings AS ShowElectronicallySignedWordings, 
 case
 WHEN @ShowTimeStamp = 'Yes' THEN CONVERT(VARCHAR(10), DS.SignatureDate, 101) + ' ' + CONVERT(varchar(15),CAST(DS.SignatureDate AS TIME),100)  
 ELSE CONVERT(VARCHAR(10), DS.SignatureDate, 101)   
 END AS 'SignatureDate' ,              
 SIGNATUREORDER ,     
 DS.PHYSICALSIGNATURE,                  
CASE  WHEN DV.VERSION > 1 THEN            
D.MODIFIEDBY             
ELSE            
''            
END            
 AMMENDEDBY,           
CASE WHEN DV.VERSION > 1 THEN            
D.MODIFIEDDATE             
ELSE            
''            
END AMMENDEDDATE               
FROM DOCUMENTS D            
JOIN DOCUMENTSIGNATURES DS  ON DS.DOCUMENTID = D.DOCUMENTID            
JOIN DOCUMENTVERSIONS DV ON DV.DOCUMENTID = D.DOCUMENTID AND ISNULL(DV.RECORDDELETED,'N')<>'Y'
LEFT JOIN Staff ST on ST.StaffId=DS.staffid
LEFT JOIN Clients c ON c.Clientid=DS.Clientid                           
WHERE  DV.DOCUMENTVERSIONID = @DocumentVersionId            
AND ISNULL(D.RECORDDELETED,'N')<>'Y'                           
AND ISNULL(DS.RECORDDELETED,'N')<>'Y'     
AND ISNULL(SIGNERNAME,'N')<>'N'             
ORDER BY SIGNATUREORDER           
          
GO


