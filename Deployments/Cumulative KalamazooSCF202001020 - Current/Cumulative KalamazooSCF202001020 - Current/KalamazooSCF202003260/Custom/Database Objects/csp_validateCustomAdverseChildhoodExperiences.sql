/****** Object:  StoredProcedure [dbo].[csp_validateCustomAdverseChildhoodExperiences]    Script Date: 11/08/2016 18:30:19 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomAdverseChildhoodExperiences]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_validateCustomAdverseChildhoodExperiences]
GO

/****** Object:  StoredProcedure [dbo].[csp_validateCustomAdverseChildhoodExperiences]    Script Date: 11/08/2016 18:30:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_validateCustomAdverseChildhoodExperiences] @DocumentVersionId INT
AS
----------------------------------------------------
--Author : Preeti k
--Date   : 10/March/2020
--Purpose: To validate "Adverse Childhood Experience" on sign.
/*Updates:
/*Date			Author    Purpose 
  08-NOV-2016   Preeti  Created.(Task KCMHSAS Improvements #14) */
*/
-----------------------------------------------------
BEGIN
	DECLARE @DocumentType VARCHAR(10)
	DECLARE @ClientId INT
	DECLARE @EffectiveDate DATETIME
	DECLARE @StaffId INT
	DECLARE @DocumentCodeID INT
	SET @DocumentCodeID = (SELECT top 1 DocumentCodeId 	FROM   DocumentCodes WHERE  Code ='FB6130A4-15FA-4E6F-B73D-21A33394D7EC')    

	BEGIN TRY
		SELECT @ClientId = d.ClientId
		FROM Documents d
		WHERE d.InProgressDocumentVersionId = @DocumentVersionId

		SELECT @StaffId = d.AuthorId
		FROM Documents d
		WHERE d.InProgressDocumentVersionId = @DocumentVersionId

		SET @EffectiveDate = CONVERT(DATETIME, convert(VARCHAR, getdate(), 101))

		CREATE TABLE [#validationReturnTable] (
			TableName VARCHAR(100) NULL
			,ColumnName VARCHAR(100) NULL
			,ErrorMessage VARCHAR(max) NULL
			,TabOrder INT NULL
			,ValidationOrder INT NULL
			)

		DECLARE @Variables VARCHAR(max)

		SET @Variables = 'DECLARE @DocumentVersionId int  
		  SET @DocumentVersionId = ' + convert(VARCHAR(20), @DocumentVersionId) + ' DECLARE @ClientId int  
		  SET @ClientId = ' + convert(VARCHAR(20), @ClientId) + 'DECLARE @EffectiveDate datetime  
		  SET @EffectiveDate = ''' + CONVERT(VARCHAR(20), @EffectiveDate, 101) + '''' + 'DECLARE @StaffId int  
		  SET @StaffId = ' + CONVERT(VARCHAR(20), @StaffId)

		IF NOT EXISTS (
				SELECT 1
				FROM CustomDocumentValidationExceptions
				WHERE DocumentVersionId = @DocumentVersionId
					AND DocumentValidationid IS NULL
				)
		BEGIN
			EXEC csp_validateDocumentsTableSelect @DocumentVersionId
				,@DocumentCodeID
				,@DocumentType
				,@Variables
		END

		SELECT TableName
			,ColumnName
			,ErrorMessage
			,TabOrder
			,ValidationOrder
		FROM #validationReturnTable
		ORDER BY taborder
			,ValidationOrder
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_validateCustomAdverseChildhoodExperiences') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,/* Message text.*/ 16
				,/* Severity.*/ 1 /*State.*/
				);
	END CATCH
END
GO


