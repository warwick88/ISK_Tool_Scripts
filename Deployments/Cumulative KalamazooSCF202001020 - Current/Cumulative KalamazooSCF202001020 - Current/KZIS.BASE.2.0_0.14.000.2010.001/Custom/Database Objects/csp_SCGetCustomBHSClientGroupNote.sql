/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomClientBHSGroupNote]    ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomClientBHSGroupNote]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_SCGetCustomClientBHSGroupNote]
GO

/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomClientBHSGroupNote]    Script Date: 04/06/2014 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_SCGetCustomClientBHSGroupNote] @DocumentVersionId INT
AS
/*********************************************************************/
/* Stored Procedure: csp_SCGetCustomClientBHSGroupNote               */
/* Creation Date:  04/Jun/2014                                    */
/* Purpose: To Get the for the service Document */
/* Input Parameters:  */
/* Output Parameters:                                */
/* Return:   */
/* Called By:  */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*   Updates:                                                          */
/*       Date              Author                   Purpose    */
/*     04/Jun/2014        Praveen Potnuru            Creation  */

/* 12-02-2018			 Kishore				New Module BHS GroupNote in F&CS- #7 copied from WWMU    */
/*********************************************************************/
BEGIN
	BEGIN TRY
		---------------------CustomDocumentClientGroupNotes---------------------------  
		SELECT 
		     DocumentVersionId
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedBy
			,DeletedDate
			,BHSGroupNoteId
			,MoodOrAffect
			,MoodOrAffectComments
			,ThoughtProcess
			,ThoughtProcessComments
			,Behavior
			,BehaviorComments
			,MedicalCondition
			,MedicalConditionComments
			,SubstanceUse
			,SubstanceUseComments
			,HomicidalNoneReportedorDangerTo
			,HomicidalSelf
			,HomicidalOthers
			,HomicidalProperty
			,Homicidalideation
			,HomicidalPlan
			,HomicidalIntent
			,HomicidalAttempt
			,HomicidalOther
			,HomicidalOtherComments
			,DocumentResponse
			,CurrentMedications
			,CurrentMedicationsComments
			,NumberOfClientsInSession
			,AttentionNormal
			,AttentionInattentive
			,AttentionDistractible
			,AttentionConfused
			,AttitudeCooperative
			,AttitudeUninterested
			,AttitudeResistance
			,AttitudeHostile
			,AttitudeIUnremarkable
			,InterPersonalShowedEmpathy
			,InterPersonalEngaged
			,InterPersonalProvideHelpfulFeedback
			,InterPersonalAttentionSeeking
			,InterPersonalDisruptive
			,InterPersonalNotRespectiveToOthers
			,InterPersonalNotinvolved
			,InterPersonalUnremarkable
			,TopicRecoveryExcellent
			,TopicRecoveryGood
			,TopicRecoverySatisfactory
			,TopicRecoveryMarginal
			,TopicRecoveryPoor
			,GroupDescription
		FROM CustomDocumentBHSClientNotes
		WHERE ISNULL(RecordDeleted, 'N') <> 'Y'
			AND DocumentVersionId = @DocumentVersionId
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_SCGetCustomClientBHSGroupNote') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                                      
				16
				,-- Severity.                                                                                                      
				1 -- State.                                                                                                      
				);
	END CATCH
END