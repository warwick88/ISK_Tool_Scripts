IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomAssessmentFunctionalCommunications]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_RDLCustomAssessmentFunctionalCommunications]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLCustomAssessmentFunctionalCommunications]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_RDLCustomAssessmentFunctionalCommunications] (@DocumentVersionId INT)
AS
/*********************************************************************/
/* Stored Procedure: [csp_RDLCustomAssessmentFunctionalCommunications]              */
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
/*   26-05-2020         Josekutty Varghese		KCMHSAS Improvements Task #12    */
/*********************************************************************/
BEGIN
	BEGIN TRY   

	If Object_Id('tempdb..#TmpCommunications') is not null
	 Begin
	   Drop table #TmpCommunications;
	 End;

	Create Table #TmpCommunications
	( DocumentVersionId int,
	  Normal Char(1),
	 UsesSignlanguage Char(1),
	 NeedforBraille Char(1),
	 HearingImpaired Char(1),
	 DoesLipReading Char(1),
	 EnglishIsSecondLanguage char(1),
	 Translator Char(1),
	 UtilizeDeviceTechnology Char(1));
	
	Insert into #TmpCommunications(Normal,UsesSignlanguage,NeedforBraille,HearingImpaired,DoesLipReading,
	                               EnglishIsSecondLanguage,Translator,UtilizeDeviceTechnology)
	Select  Case [Normal] When 1 Then 'Y' When 0 Then 'N' Else 'N' End As Normal,
         Case [Uses sign language] When 1 Then 'Y' When 0 Then 'N' Else 'N' End As UsesSignlanguage,
		 Case [Need for Braille] When 1 Then 'Y' When 0 Then 'N' Else 'N' End As NeedforBraille,
		 Case [Hearing impaired] When 1 Then 'Y' When 0 Then 'N' Else 'N' End As HearingImpaired,
		 Case [Does lip reading] When 1 Then 'Y' When 0 Then 'N' Else 'N' End As DoesLipReading,
		 Case [English is second language] When 1 Then 'Y' When 0 Then 'N' Else 'N' End As EnglishIsSecondLanguage,
		 Case [Translator] When 1 Then 'Y' When 0 Then 'N' Else 'N' End As Translator,
		 Case [Utilize device/technology] When 1 Then 'Y' When 0 Then 'N' Else 'N' End As UtilizeDeviceTechnology
        from (
        SELECT  GC.CodeName,Case CAFC.IsChecked When 'Y' Then 1 When 'N' Then 0 Else 0 End As TotCount 
		FROM CustomAssessmentFunctionalCommunications CAFC 
		Inner JOIN GlobalCodes GC ON GC.GlobalCodeId  = CAFC.Communication 
		INNER JOIN CustomDocumentMHAssessments CHRMA ON CHRMA.DocumentVersionId = CAFC.DocumentVersionId
		AND CAFC.DocumentVersionId = @DocumentVersionId AND  CHRMA.ClientInDDPopulation = 'Y' AND ISNULL(CAFC.RecordDeleted, 'N') = 'N'			
		WHERE Category = 'XCommunication' )Tmp
		Pivot ( Avg(TotCount) For CodeName IN ([Normal],[Uses sign language],[Need for Braille],[Hearing impaired],
		[Does lip reading],[English is second language],[Translator],[Utilize device/technology])) As Pvt;	

   Update #TmpCommunications Set DocumentVersionId = @DocumentVersionId;
		
   Select top 1 A.Normal,A.UsesSignlanguage,A.NeedforBraille,A.HearingImpaired,A.DoesLipReading,
	      A.EnglishIsSecondLanguage,A.Translator,A.UtilizeDeviceTechnology from SystemConfigurations B
   Left Outer Join  #TmpCommunications A On A.DocumentVersionId = @DocumentVersionId;  
 	
  END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLCustomAssessmentFunctionalCommunications') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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