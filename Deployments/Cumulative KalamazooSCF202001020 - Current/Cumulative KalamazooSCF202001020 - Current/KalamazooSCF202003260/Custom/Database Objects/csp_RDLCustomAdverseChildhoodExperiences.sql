/****** Object:  StoredProcedure [dbo].[csp_RDLCustomAdverseChildhoodExperiences]    Script Date: 07/13/2015 19:36:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomAdverseChildhoodExperiences]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomAdverseChildhoodExperiences]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLCustomAdverseChildhoodExperiences]    Script Date: 07/13/2015 19:36:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_RDLCustomAdverseChildhoodExperiences] (@DocumentVersionId INT)
AS
/*************************************************************************************/
/* Stored Procedure: [csp_RDLCustomAdverseChildhoodExperiences]                      */
/* Creation Date:  10/March/2020                                                    */
/* Purpose: Gets Data from CustomDocumentAdverseChildhoodExperiences
[Move document from PEP TO Kalamazoo(KCMHSAS Improvements #14)]                        */
/* Input Parameters: @DocumentVersionId                                              */
/* Purpose: Use For Rdl Report                                                       */
/* Author: Preeti K                                                                  */
/*************************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @OrganizationName VARCHAR(250)
		DECLARE @ClientName VARCHAR(100)
		DECLARE @ClinicianName VARCHAR(100)
		DECLARE @ClientID INT
		DECLARE @EffectiveDate VARCHAR(10)
		DECLARE @DOB VARCHAR(10)
		DECLARE @DocumentName  VARCHAR(100)
		
		SELECT TOP 1 @OrganizationName = OrganizationName
		FROM SystemConfigurations
		
		SELECT @ClientName = C.LastName + ', ' + C.FirstName
			,@ClinicianName = S.LastName + ', ' + S.FirstName + ' ' + isnull(GC.CodeName, '')
			,@ClientID = Documents.ClientID
			,@EffectiveDate = CASE 
				WHEN Documents.EffectiveDate IS NOT NULL
					THEN CONVERT(VARCHAR(10), Documents.EffectiveDate, 101)
				ELSE ''
				END
			,@DOB = CASE 
				WHEN C.DOB IS NOT NULL
					THEN CONVERT(VARCHAR(10), C.DOB, 101)
				ELSE ''
				END
			,@DocumentName = DocumentCodes.DocumentName 
		FROM Documents
		JOIN Staff S ON Documents.AuthorId = S.StaffId
		JOIN Clients C ON Documents.ClientId = C.ClientId
			AND isnull(C.RecordDeleted, 'N') <> 'Y'
		JOIN DocumentVersions dv ON dv.DocumentId = documents.DocumentId
		INNER JOIN DocumentCodes on DocumentCodes.DocumentCodeid= Documents.DocumentCodeId      
			AND ISNULL(DocumentCodes.RecordDeleted,'N')='N' 
		LEFT JOIN GlobalCodes GC ON S.Degree = GC.GlobalCodeId
		WHERE dv.DocumentVersionId = @DocumentVersionId
			AND isnull(Documents.RecordDeleted, 'N') = 'N'
				
		SELECT ISNULL(@OrganizationName, '') AS OrganizationName
			,ISNULL(@DocumentName, '') AS DocumentName
			,ISNULL(@ClientName, '') AS ClientName
			,ISNULL(@ClinicianName, '') AS ClinicianName
			,ISNULL(@ClientID, '') AS ClientID
			,ISNULL(@EffectiveDate, '') AS EffectiveDate
			,ISNULL(@DOB, '') AS DOB
			,ISNULL(UnableToComplete,'N') AS UnableToComplete
			,CASE WHEN ISNULL(Humiliate,'') = 'Y'        THEN 'Yes' WHEN ISNULL(Humiliate,'') = 'N'        THEN 'No' ELSE '' END AS Humiliate
			,CASE WHEN ISNULL(Injured,'') = 'Y'          THEN 'Yes' WHEN ISNULL(Injured,'') = 'N'          THEN 'No' ELSE '' END AS Injured
			,CASE WHEN ISNULL(Touch,'') = 'Y'            THEN 'Yes' WHEN ISNULL(Touch,'') = 'N'            THEN 'No' ELSE '' END AS Touch
			,CASE WHEN ISNULL(Support,'') = 'Y'          THEN 'Yes' WHEN ISNULL(Support,'') = 'N'          THEN 'No' ELSE '' END AS Support
			,CASE WHEN ISNULL(EnoughToEat,'') = 'Y'      THEN 'Yes' WHEN ISNULL(EnoughToEat,'') = 'N'      THEN 'No' ELSE '' END AS EnoughToEat
			,CASE WHEN ISNULL(ParentsSeparated,'') = 'Y' THEN 'Yes' WHEN ISNULL(ParentsSeparated,'') = 'N' THEN 'No' ELSE '' END AS ParentsSeparated
			,CASE WHEN ISNULL(Pushed,'') = 'Y'           THEN 'Yes' WHEN ISNULL(Pushed,'') = 'N'           THEN 'No' ELSE '' END AS Pushed
			,CASE WHEN ISNULL(DrinkerProblem,'') = 'Y'   THEN 'Yes' WHEN ISNULL(DrinkerProblem,'') = 'N'   THEN 'No' ELSE '' END AS DrinkerProblem
			,CASE WHEN ISNULL(Suicide,'') = 'Y'          THEN 'Yes' WHEN ISNULL(Suicide,'') = 'N'          THEN 'No' ELSE '' END AS Suicide
			,CASE WHEN ISNULL(Prison,'') = 'Y'           THEN 'Yes' WHEN ISNULL(Prison,'') = 'N'           THEN 'No' ELSE '' END AS Prison
			,AceScore
		FROM CustomDocumentAdverseChildhoodExperiences CDACE
		WHERE CDACE.DocumentVersionId = @DocumentVersionId
			AND isnull(CDACE.RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLCustomAdverseChildhoodExperiences') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	END CATCH
END

GO


