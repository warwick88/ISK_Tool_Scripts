IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDischargePreviousDiagnosis]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDischargePreviousDiagnosis]
GO

CREATE PROCEDURE [dbo].[csp_RDLCustomDischargePreviousDiagnosis] (@DocumentVersionId INT = 0)
	/*************************************************
  Date:			Author:       Description:                            
  
  -------------------------------------------------------------------------            
 27-Mar-2015     Anto     What:Get Previous Diagnosis for Discharge

*******************************************************************/
AS
BEGIN
	BEGIN TRY
		DECLARE @ClientId INT
		DECLARE @EffectiveDate DATETIME

		SELECT @ClientId = D.ClientId
			,@EffectiveDate = D.EffectiveDate
		FROM Documents D
		WHERE D.CurrentDocumentVersionId = @DocumentVersionId
			AND ISNULL(D.RecordDeleted, 'N') = 'N'

		DECLARE @LatestICD10DocumentVersionID INT
		DECLARE @LastEffectiveDate DATETIME

		SELECT TOP 1 @LatestICD10DocumentVersionID = InProgressDocumentVersionId
			,@LastEffectiveDate = CONVERT(VARCHAR(10), a.EffectiveDate, 101)
		FROM Documents a
		INNER JOIN DocumentCodes Dc ON Dc.DocumentCodeid = a.DocumentCodeid
		WHERE a.ClientId = @ClientID
			AND a.EffectiveDate <= convert(DATETIME, convert(VARCHAR, getDate(), 101))
			AND a.STATUS = 22
			AND Dc.DiagnosisDocument = 'Y'
			AND isNull(a.RecordDeleted, 'N') <> 'Y'
			AND isNull(Dc.RecordDeleted, 'N') <> 'Y'
		ORDER BY a.EffectiveDate DESC
			,a.ModifiedDate DESC
			
			IF @LatestICD10DocumentVersionID IS NOT NULL
		BEGIN

		SELECT D.DocumentDiagnosisCodeId
				,D.CreatedBy
				,D.CreatedDate
				,D.ModifiedBy
				,D.ModifiedDate
				,D.RecordDeleted
				,D.DeletedDate
				,D.DeletedBy
				,D.DocumentVersionId
				,D.ICD10CodeId
				,D.ICD10Code
				,D.ICD9Code
				,dbo.csf_GetGlobalCodeNameById(D.DiagnosisType) AS DiagnosisType
				,D.RuleOut
				,D.Billable
				,dbo.csf_GetGlobalCodeNameById(D.Severity) AS Severity
				,D.DiagnosisOrder
				,D.Specifier
				,D.Remission
				,D.[Source]
				,CONVERT(VARCHAR(10), @LastEffectiveDate, 101) AS EffectiveDate
				,ICD10.ICDDescription AS ICDDescription
				,CASE D.RuleOut
					WHEN 'Y'
						THEN 'R/O'
					ELSE ''
					END AS RuleOutText
				,CASE ICD10.DSMVCode
					WHEN 'Y'
						THEN 'Yes'
					ELSE ''
					END AS DSMVCode
				,dbo.csf_GetGlobalCodeNameById(D.DiagnosisType) AS 'DiagnosisTypeText'
				,dbo.csf_GetGlobalCodeNameById(D.Severity) AS 'SeverityText'
			FROM DocumentDiagnosisCodes AS D --left JOIN              
				INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = D.ICD10CodeId
			WHERE (D.DocumentVersionId = @LatestICD10DocumentVersionID)
				AND (ISNULL(D.RecordDeleted, 'N') = 'N')
				
			END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLCustomPsychiatricServicePreviousDiagnosis') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	END CATCH
END

