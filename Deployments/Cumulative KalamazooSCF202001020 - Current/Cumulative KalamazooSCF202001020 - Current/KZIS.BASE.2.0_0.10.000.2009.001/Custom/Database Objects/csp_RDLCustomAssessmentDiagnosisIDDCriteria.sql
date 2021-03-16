IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomAssessmentDiagnosisIDDCriteria]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_RDLCustomAssessmentDiagnosisIDDCriteria]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLCustomAssessmentDiagnosisIDDCriteria]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_RDLCustomAssessmentDiagnosisIDDCriteria] (@DocumentVersionId INT)
AS
/*********************************************************************/
/* Stored Procedure: [csp_RDLCustomAssessmentDiagnosisIDDCriteria]              */
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
/*   Date               Author                      Purpose              */
/*   26-05-2020         Josekutty Varghese			KCMHSAS Improvements Task #12    */
/*********************************************************************/
BEGIN
	BEGIN TRY   
		
	  Select Case [Self-Care] When 1 Then 'Y' When 0 Then 'N' Else 'N' End As SelfCare,
         Case [Receptive/Expressive language] When 1 Then 'Y' When 0 Then 'N' Else 'N' End As ReceptiveExpressivelanguage,
		 Case [Learning] When 1 Then 'Y' When 0 Then 'N' Else 'N' End As Learning,
		 Case [Mobility] When 1 Then 'Y' When 0 Then 'N' Else 'N' End As Mobility,
		 Case [Self-Direction] When 1 Then 'Y' When 0 Then 'N' Else 'N' End As SelfDirection,
		 Case [Economic Self Sufficiency] When 1 Then 'Y' When 0 Then 'N' Else 'N' End As EconomicSelfSufficiency,
		 Case [Capability for Independent Living] When 1 Then 'Y' When 0 Then 'N' Else 'N' End As CapabilityforIndependentLiving
	  from  
	  (SELECT  GC.CodeName,Case C.IsChecked When 'Y' Then 1 When 'N' Then 0 Else 0 End As TotCount  
	   FROM CustomAssessmentDiagnosisIDDCriteria C   
	   Inner JOIN GlobalCodes GC ON GC.GlobalCodeId = C.SubstantialFunctional    
	   INNER JOIN CustomDocumentMHAssessments CHRMA ON CHRMA.DocumentVersionId = C.DocumentVersionId  
	   AND C.DocumentVersionId = @DocumentVersionId AND  CHRMA.ClientInDDPopulation = 'Y' AND ISNULL(C.RecordDeleted, 'N') = 'N'   
	   WHERE Category = 'XSubstantialFunction' )Tmp   
	   PIVOT ( Avg(TotCount)FOR CodeName IN ([Self-Care],[Receptive/Expressive language],[Learning],[Mobility],[Self-Direction],[Economic Self Sufficiency],[Capability for Independent Living])) As Pvt         
       
		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLCustomAssessmentDiagnosisIDDCriteria') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                  
				16
				,-- Severity.                                                                  
				1 -- State.                                                                  
				);
	END CATCH
END
Go