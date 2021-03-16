/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomBHSGroupNote]    ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomBHSGroupNote]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_SCGetCustomBHSGroupNote]
GO

/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomBHSGroupNote] 11:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_SCGetCustomBHSGroupNote] (@DocumentVersionId INT)
AS
/******************************************************************************              
/* Stored Procedure: dbo.csp_SCGetCustomBHSGroupNote    */
/* Creation Date: 28/May/2014                                        */
/*                                                                  */
/* Purpose:                   */
/*  Exec csp_SCGetCustomBHSGroupNote                          */
/*  Date                 Author                Purpose            */
/* 17/10/2014            Venkatesh MR			Created             */  
/*  12-02-2018			 Kishore				New Module BHS GroupNote copied from WWMU */    
            
*******************************************************************************/
BEGIN
	BEGIN TRY
		SELECT BHSGroupNoteId
			,[DocumentVersionId]
			,[CreatedBy]
			,[CreatedDate]
			,[ModifiedBy]
			,[ModifiedDate]
			,[RecordDeleted]
			,[DeletedDate]
			,[DeletedBy]
			,NumberOfClientsInSession
			,GroupDescription
		FROM CustomBHSGroupNotes
		WHERE ISNull(RecordDeleted, 'N') = 'N'
			AND DocumentVersionId = @DocumentVersionId		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_SCGetCustomBHSGroupNote') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.              
				16
				,-- Severity.              
				1 -- State.              
				);
	END CATCH
END