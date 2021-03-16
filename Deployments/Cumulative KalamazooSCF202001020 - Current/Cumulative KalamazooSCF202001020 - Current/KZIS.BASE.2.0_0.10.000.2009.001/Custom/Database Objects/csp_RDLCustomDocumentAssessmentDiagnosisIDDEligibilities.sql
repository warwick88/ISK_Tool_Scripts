IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentAssessmentDiagnosisIDDEligibilities]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_RDLCustomDocumentAssessmentDiagnosisIDDEligibilities]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentAssessmentDiagnosisIDDEligibilities]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_RDLCustomDocumentAssessmentDiagnosisIDDEligibilities] (@DocumentVersionId INT)
AS
/*********************************************************************/
/* Stored Procedure: [csp_RDLCustomDocumentAssessmentDiagnosisIDDEligibilities]              */
/* Creation Date:                                 */
/* Purpose: To RDL Get Data Conscents  Document     */
/* Input Parameters:   @DocumentVersionId         */
/* Output Parameters:                 */
/* Return:                 */
/* Called By:                                        */
/* Calls:                                                            */
/* CreatedBy:                                             */
/* Data Modifications:                                               */
/*   Updates:                                                        */
/*   Date               Author                  Purpose              */
/*	26-05-2020			Josekutty Varghese		KCMHSAS Improvements Task #12     */
/*********************************************************************/
BEGIN
	BEGIN TRY

		SELECT C.DocumentVersionId
			 ,C.MentalPhysicalImpairment	
		 	 ,C.ManifestedPrior						
			 ,C.TestingReportsReviewed
			 ,C.LikelyToContinue					
			 ,(SELECT Case When Count(*) > 0 Then 'Y' Else 'N' End As IsDiagnosisIDDCriteriaExist    
				FROM CustomAssessmentDiagnosisIDDCriteria C     
				Inner JOIN GlobalCodes GC ON GC.GlobalCodeId = C.SubstantialFunctional      
				INNER JOIN CustomDocumentMHAssessments CHRMA ON CHRMA.DocumentVersionId = C.DocumentVersionId    
				AND C.DocumentVersionId = @DocumentVersionId AND  CHRMA.ClientInDDPopulation = 'Y' AND ISNULL(C.RecordDeleted, 'N') = 'N'     
				WHERE Category = 'XSubstantialFunction' ) IsDiagnosisIDDCriteriaExist	 
		FROM CustomDocumentAssessmentDiagnosisIDDEligibilities C
		INNER JOIN CustomDocumentMHAssessments CHRMA ON CHRMA.DocumentVersionId = C.DocumentVersionId
		WHERE C.DocumentVersionId = @DocumentVersionId
		AND  CHRMA.ClientInDDPopulation = 'Y' AND ISNULL(C.RecordDeleted, 'N') = 'N'	

	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLCustomDocumentAssessmentDiagnosisIDDEligibilities') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                  
				16
				,-- Severity.                                                                  
				1 -- State.                                                                  
				);
	END CATCH
END
