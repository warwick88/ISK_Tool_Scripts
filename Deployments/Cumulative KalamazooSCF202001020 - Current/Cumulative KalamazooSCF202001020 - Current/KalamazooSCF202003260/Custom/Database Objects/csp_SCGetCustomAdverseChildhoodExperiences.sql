/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomAdverseChildhoodExperiences]    Script Date: 11/10/2016 15:30:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomAdverseChildhoodExperiences]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomAdverseChildhoodExperiences]
GO

/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomAdverseChildhoodExperiences]    Script Date: 11/10/2016 15:30:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


---------------------------------------
--Author : Preeti K
--Date   : 10/March/2020  
--Purpose :Get data for "Adverse Childhood Experience"
/*Updates:
/*Date			Author    Purpose 
  08-NOV-2016   Preeti k  Created.(Move document from PEP TO Kalamazoo(KCMHSAS Improvements #14)) */
*/
--------------------------------------
CREATE PROCEDURE [dbo].[csp_SCGetCustomAdverseChildhoodExperiences] @DocumentVersionId INT
AS
BEGIN TRY
	SELECT DocumentVersionId
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedBy
		,DeletedDate
		,UnableToComplete
		,Humiliate
		,Injured
		,Touch
		,Support
		,EnoughToEat
		,ParentsSeparated
		,Pushed
		,DrinkerProblem
		,Suicide
		,Prison
		,AceScore
	FROM CustomDocumentAdverseChildhoodExperiences
	WHERE (ISNULL(RecordDeleted, 'N') = 'N')
		AND (DocumentVersionId = @DocumentVersionId)
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_SCGetCustomAdverseChildhoodExperiences') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.    
			16
			,-- Severity.    
			1 -- State.    
			);
END CATCH

GO