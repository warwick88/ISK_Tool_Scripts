USE [ProdSmartCare]
GO

/****** Object:  StoredProcedure [dbo].[ksp_dfa_NoticeABDDFA]    Script Date: 7/30/2020 10:06:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








CREATE PROCEDURE [dbo].[ksp_dfa_NoticeABDDFA]
 	@DocumentVersionId INT
 AS  
 -- =============================================        
 -- Author: Warwick Barlow    
 -- Create date: 4/6/2020      
 -- Description: RDL Data Set
 -- Modified 6.30.20 fixes Guardian signature not displaying.
 -- =============================================        
 BEGIN  
 BEGIN TRY  
 	SELECT 
 		ABD.DocumentVersionId,
 		ABD.MailingDate,
 		--Need Beneficiary ID from ClientCoveragePlans
 		C.ClientId,   --Member ID
 		C.Firstname,
 		C.LastName,
 		CCP.InsuredId,
 		D.Documentid,
		D.EffectiveDate AS BackUpDate, --This was added as the default when no determinate date is elected.
 		GCD1.CodeName AS Determination,
 		GCS1.CodeName AS ServiceI,
 		GCS2.CodeName AS ServiceII,
 		GCS3.Codename AS ServiceIII,
 		GCS4.CodeName AS ServiceIV,
 		GCS5.CodeName AS ServiceV,
 		ABD.DocEffDate,
 		--coalesce(CheckBoxI,CheckBoxII,CheckBoxIII,CheckBoxIV,CheckBoxV,CheckBoxVI,CheckBoxVII,CheckBoxVIII,CheckBoxIX,CheckBoxX,CheckBoxXI,CheckBoxXII) as CheckBoxSelection
 		ABD.CheckBoxI,
 		ABD.CheckBoxII,
 		ABD.CheckBoxIII,
 		ABD.CheckBoxIV,
 		ABD.CheckBoxV,
 		ABD.CheckBoxVI,
 		ABD.CheckBoxVII,
 		ABD.CheckBoxVIII,
 		ABD.CheckBoxIX,
 		ABD.CheckBoxX,
 		ABD.CheckBoxXI,
 		ABD.CheckBoxXII,
 		ABD.DocEffDate2,
 		ABD.Units,
		ABD.UnitsII,
 		ABD.CommentI,
 		ABD.CommentII,
 		ABD.CommentIII,
 		S.FirstName AS AuthorFN,
 		S.LastName as AuthorLN,
 		S.SigningSuffix,
		AA.Guardian as GuardianName, --This is the name of the patient guardian
		AA.PhysicalSignature as PhysicalSignature, --Physical signature for the Guardian
		DS.StaffPrepDate AS PrepDate, --This is the signature Date field for staff member.
		AA.GuardianSignature AS GuardianSignature -- This is the signatureDATE for the Guardian.
 
 
 		FROM CustomDocumentabdnotice ABD
 		JOIN DocumentVersions DV ON ABD.DocumentVersionId = DV.DocumentVersionId
 		JOIN Documents D ON DV.DocumentId = D.DocumentId
 		LEFT JOIN
			(SELECT SIGNERNAME AS AUTHORAGAIN, SignatureDate as StaffPrepDate, DocumentId
			FROM DocumentSignatures DS
			WHERE DS.SignatureOrder = 1
			) AS DS ON D.DocumentId = DS.DocumentId
		--LEFT JOIN DocumentSignatures DS ON D.Documentid = DS.DocumentId
		LEFT JOIN 
			(SELECT SIGNERNAME AS Guardian, DocumentId, PhysicalSignature,ModifiedDate,SignatureDate as GuardianSignature
			FROM DocumentSignatures DS
			WHERE DS.RelationToClient = 25037
			) AS AA ON D.DocumentId = AA.DocumentId
 		LEFT JOIN STAFF S ON D.AuthorId = S.Staffid
 		JOIN Clients C ON D.ClientId = C.ClientId
 		-- adding new join
 		LEFT JOIN (SELECT * FROM ClientCoveragePlans where ClientCoveragePlanId in (
 				select MAX(ClientCoveragePlanId) from ClientCoveragePlans group by ClientId
 			  )) as CCP on C.ClientId = CCP.ClientId
 		LEFT JOIN GLOBALCODES GCD1 ON ABD.Determination = GCD1.GlobalCodeId
 		LEFT JOIN GLOBALCODES GCS1 ON ABD.ServiceI = GCS1.GlobalCodeId
 		LEFT JOIN GLOBALCODES GCS2 ON ABD.ServiceII = GCS2.GlobalCodeId
 		LEFT JOIN GLOBALCODES GCS3 ON ABD.ServiceIII = GCS3.GlobalCodeId
 		LEFT JOIN GLOBALCODES GCS4 ON ABD.ServiceIV = GCS4.GlobalCodeId
 		LEFT JOIN GLOBALCODES GCS5 ON ABD.ServiceV = GCS5.GlobalCodeId
 		WHERE ABD.DocumentVersionId = @DocumentVersionId
 
 END TRY  
   
 BEGIN CATCH  
 	DECLARE @Error VARCHAR(8000)  
 
 	SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ksp_dfa_NoticeABDDFA') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
 
 	RAISERROR (  
 		@Error,-- Message text.                                                                       
 		16,-- Severity.                                                              
 		1 -- State.                                                           
 	);  
 END CATCH  
 END
 
GO


