IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCSignGroupServicesDocuments]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_SCSignGroupServicesDocuments]
GO

/****** Object:  StoredProcedure [dbo].[csp_SCSignGroupServicesDocuments]    Script Date: 05/28/2014 11:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_SCSignGroupServicesDocuments] (
	@StaffID INT
	,@DocumentIds VARCHAR(1000)
	,@Password VARCHAR(100)
	,@ClientSignedPaper VARCHAR(1)
	)
AS
/******************************************************************************                                      
**  File: [csp_SCSignGroupServicesDocuments]                                  
**  Name: [csp_SCSignGroupServicesDocuments]              
**  Desc: For Validation  for GroupServices documents        
**  Return values: Resultset having validation messages                                      
**  Called by:                                       
**  Parameters:                  
**  Auth:  Umesh                      
**  Date:  Jun 17 2010                                  
*******************************************************************************                                      
**  Change History                                      
*******************************************************************************                                      
**  Date:       Author:       Description:      
**  17Nov2011 Shifali    Modified - Added new param @TOSignDocumentVersionId to sp call ssp_SCSignatureSignedByStaff    
**  12-02-2018			 Kishore				New Module BHS GroupNote in F&CS- #7 copied from WWMU                              
*******************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @Counter INT
		DECLARE @MaxCount INT
		DECLARE @TOSignDocumentId INT
		DECLARE @TOSignDocumentVersionId INT

		SET @Counter = 1

		DECLARE @t1 TABLE (
			RowId INT IDENTITY(1, 1)
			,DocumentId INT
			)

		INSERT INTO @t1
		SELECT *
		FROM [dbo].fnSplit(@DocumentIds, ',')

		SELECT @MaxCount = MAX(RowId)
		FROM @t1

		SELECT *
		FROM @t1

		WHILE (@Counter <= @MaxCount)
		BEGIN
			SELECT @ToSignDocumentId = DocumentId
			FROM @t1
			WHERE RowId = @Counter

			--Pick DOcumentVersionId to sign  
			SELECT @TOSignDocumentVersionId = DocumentVersionId
			FROM DocumentVersions
			WHERE DocumentId = @TOSignDocumentId

			--Call the DOcument Signature  procedure  
			EXEC ssp_SCSignatureSignedByStaff @StaffID
				,@ToSignDocumentId
				,@Password
				,@ClientSignedPaper
				,@TOSignDocumentVersionId

			SET @Counter = @Counter + 1
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[csp_SCSignGroupServicesDocuments]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                  
				16
				,-- Severity.                                                                                  
				1 -- State.                                                                                  
				);
	END CATCH
END