USE [ProdSmartCare]
GO

/****** Object:  StoredProcedure [dbo].[ksp_dfa_NoticeABD]    Script Date: 7/30/2020 10:05:32 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[ksp_dfa_NoticeABD](
	@DocumentVersionId INT
)
AS
/********************************************************************************                                                       
--      
-- Author: Warwick Barlow     
-- Date: 01/17/2018
--      
-- Purpose: Pull Notice of Adverse Benefit Determination documents
--
*********************************************************************************/
BEGIN TRY
	SELECT
		*
	FROM customdocumentabdnotice
	WHERE
		DocumentVersionId = @DocumentVersionId AND
		ISNULL(RecordDeleted, 'N') <> 'Y'
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ksp_dfa_NoticeABD') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

	RAISERROR (
		@Error,-- Message text.                    
		16,-- Severity.                    
		1 -- State.                    
	);
END CATCH

GO


