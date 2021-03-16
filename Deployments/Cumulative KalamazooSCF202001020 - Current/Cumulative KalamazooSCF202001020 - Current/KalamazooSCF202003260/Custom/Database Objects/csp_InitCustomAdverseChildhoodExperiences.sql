/****** Object:  StoredProcedure [dbo].[csp_InitCustomAdverseChildhoodExperiences]    Script Date: 11/08/2016 18:36:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomAdverseChildhoodExperiences]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomAdverseChildhoodExperiences]
GO

/****** Object:  StoredProcedure [dbo].[csp_InitCustomAdverseChildhoodExperiences]    Script Date: 11/08/2016 18:36:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_InitCustomAdverseChildhoodExperiences] @ClientID INT
	,@StaffID INT
	,@CustomParameters XML
AS
BEGIN
-- =============================================    
-- Author      : Preeti k
-- Date        : 10/March/2020  
-- Purpose     : Initializing SP [Move document from PEP TO Kalamazoo(KCMHSAS Improvements #14)]
-- =============================================
BEGIN TRY 
	DECLARE @LatestDocumentVersionID INT

	SELECT TOP 1 @LatestDocumentVersionID = CurrentDocumentVersionId
	FROM CustomDocumentAdverseChildhoodExperiences CDCE
	INNER JOIN Documents Doc ON CDCE.DocumentVersionId = Doc.CurrentDocumentVersionId
	WHERE Doc.ClientId = @ClientID
		AND Doc.[Status] = 22
		AND ISNULL(CDCE.RecordDeleted, 'N') = 'N'
		AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
		AND Doc.DocumentCodeId = 46100
	ORDER BY Doc.EffectiveDate DESC
		,Doc.ModifiedDate DESC

	SELECT TOP 1 'CustomDocumentAdverseChildhoodExperiences' AS TableName
		,- 1 AS DocumentVersionId
		,'' AS CreatedBy
		,GETDATE() AS CreatedDate
		,'' AS ModifiedBy
		,GETDATE() AS ModifiedDate
	FROM systemconfigurations s
	LEFT OUTER JOIN CustomDocumentAdverseChildhoodExperiences CDSD ON CDSD.DocumentVersionId = @LatestDocumentVersionID	
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_InitCustomAdverseChildhoodExperiences') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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