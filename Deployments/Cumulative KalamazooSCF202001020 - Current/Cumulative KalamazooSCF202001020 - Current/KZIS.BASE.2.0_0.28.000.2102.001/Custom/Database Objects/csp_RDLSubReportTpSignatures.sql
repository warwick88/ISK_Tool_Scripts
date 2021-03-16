
/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportTpSignatures]    Script Date: 11/27/2013 19:07:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportTpSignatures]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportTpSignatures] 
GO



/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportTpSignatures]    Script Date: 11/27/2013 19:07:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROCEDURE  [dbo].[csp_RDLSubReportTpSignatures]   
(                                    
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010                                     
)                                    
As   
   
/* 
select top 100 * from documentSignatures where SignerName is not null order by signatureId desc
select db_name()
*/    
DECLARE @DocumentId INT

SET @DocumentId = (
			SELECT DISTINCT DocumentId
			FROM DocumentSignatures
			WHERE SignedDocumentVersionId = @DocumentVersionId
			)
			
select	d.DocumentId, 
		ds.SignatureId,
		dv.Version,
		ds.SignerName,
		ds.PhysicalSignature,
		ds.SignatureDate
FROM documentSignatures ds
	LEFT JOIN Staff b ON ds.staffid = b.staffid
	LEFT JOIN Clients c ON c.Clientid = ds.Clientid
	LEFT JOIN DocumentVersions dv ON dv.DocumentVersionId = ds.SignedDocumentVersionId
	LEFT JOIN Documents d ON d.DocumentId = ds.DocumentId
	WHERE ds.DocumentId = @DocumentId
		AND (
			ds.SignatureDate IS NOT NULL
			OR ISNULL(DeclinedSignature, 'N') = 'Y'
			)
		AND (
			ds.RecordDeleted = 'N'
			OR ds.RecordDeleted IS NULL
			)
		AND (ds.SignedDocumentVersionId = @DocumentVersionId)




