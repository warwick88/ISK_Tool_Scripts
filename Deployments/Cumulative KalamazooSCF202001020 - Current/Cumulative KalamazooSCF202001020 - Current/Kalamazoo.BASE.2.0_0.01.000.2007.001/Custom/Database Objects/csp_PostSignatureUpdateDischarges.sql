
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PostSignatureUpdateDischarges]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PostSignatureUpdateDischarges] 
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_PostSignatureUpdateDischarges] (@DocumentVersionId INT,@CurrentUserId INT = NULL, 
@CurrentUser VARCHAR(30) ,          
@CustomParameters XML)
AS
/******************************************************************** */
/* Stored Procedure: [csp_PostSignatureUpdateDischarges]               */
/* Creation Date:  08/FEB/2015                                    */
/* Purpose: To Create a Todo document */
/* Updates:                                                                                                         
** Date            Author              Purpose   
** 06-Aug-2015	   Akwinass			   What:CustomClientFee table changed to ClientFee      
**									   Why:Task #441 in Valley Client Acceptance Testing Issues
** 10-Aug-2015	   Akwinass			   What:Insert Script Included,If not Exist in Custom Clients table.      
**									   Why:Task #441 in Valley Client Acceptance Testing Issues
** 13-Aug-2015	   Akwinass			   What:Included Forensic Court Ordered Treatment.      
**									   Why:Task #441 in Valley Client Acceptance Testing Issues */
/***********************************************************************/
BEGIN
	BEGIN TRY

		DECLARE @ClientId INT
		DECLARE @ToDoDocumentId INT		
		DECLARE @CurrentUserCode VARCHAR(20)
		DECLARE @AssignedTo INT
		DECLARE @ToDoEffectiveDate DATETIME
		DECLARE @DocumentCodeId INT
		DECLARE @EffectiveDate DATETIME
		DECLARE @ToDoDocumentVersionId INT
		DECLARE @Day VARCHAR(20)
		DECLARE @AssignedTo1 INT
		
		DECLARE @CustomServingMilitary INT
		DECLARE @TobaccoUse INT
		DECLARE @AgeOfFirstTobaccoUse VARCHAR(25)
		DECLARE @ForensicTreatment INT
		DECLARE @CurrentDocumentVersionId INT
		SET @CurrentDocumentVersionId = (select CurrentDocumentVersionId from documents where documentid=@DocumentVersionId)
		SELECT @ClientId = ClientId
			,@EffectiveDate = EffectiveDate
			,@DocumentCodeId = DocumentCodeId
			,@AssignedTo = AuthorId
		FROM Documents
		WHERE CurrentDocumentVersionid = @CurrentDocumentVersionId
		
		SELECT TOP 1 @CustomServingMilitary = CurrentlyServingMilitary
			,@TobaccoUse = TobaccoUse
			,@AgeOfFirstTobaccoUse = AgeOfFirstTobaccoUse
			,@ForensicTreatment = ForensicCourtOrdered
		FROM CustomDocumentDischarges
		WHERE DocumentVersionId = @CurrentDocumentVersionId
			AND ISNULL(RecordDeleted, 'N') = 'N'
			
		UPDATE Clients
		SET MilitaryStatus = @CustomServingMilitary
		WHERE ClientId = @ClientId
			AND ISNULL(RecordDeleted, 'N') = 'N'
		
		--IF EXISTS(SELECT 1 FROM CustomClients WHERE ClientId = @ClientId AND ISNULL(RecordDeleted, 'N') = 'N')
		--BEGIN
		--	UPDATE CustomClients
		--	SET TobaccoUse = @TobaccoUse
		--		,AgeOfFirstTobaccoUse = @AgeOfFirstTobaccoUse
		--		,ForensicTreatment = @ForensicTreatment
		--	WHERE ClientId = @ClientId
		--		AND ISNULL(RecordDeleted, 'N') = 'N'
		--END
		--ELSE
		--BEGIN
		--	SELECT TOP 1 @CurrentUserCode = UserCode FROM Staff where StaffId = @CurrentUserId AND ISNULL(RecordDeleted, 'N') = 'N' 
		--	INSERT INTO CustomClients(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,TobaccoUse,AgeOfFirstTobaccoUse,ClientId,ForensicTreatment)
		--	VALUES(ISNULL(@CurrentUserCode,''),GETDATE(),ISNULL(@CurrentUserCode,''),GETDATE(),@TobaccoUse,@AgeOfFirstTobaccoUse,@ClientId,@ForensicTreatment)			
		--END

		DECLARE @TypeOfDischarge VARCHAR(1)
		DECLARE @ClientEpisodeId INT
		DECLARE @ClientProgramId INT

		SET @ClientProgramId = (
				SELECT NewPrimaryClientProgramId
				FROM CustomDocumentDischarges
				WHERE DocumentVersionId = @CurrentDocumentVersionId
				)

		UPDATE ClientPrograms
		SET PrimaryAssignment = 'N'
		WHERE ClientId = @ClientId
			AND PrimaryAssignment = 'Y'

		UPDATE ClientPrograms
		SET PrimaryAssignment = 'Y'
		WHERE ClientProgramId = @ClientProgramId
			AND ClientId = @ClientId

		SET @TypeOfDischarge = (
				SELECT DischargeType
				FROM CustomDocumentDischarges
				WHERE DocumentVersionId = @CurrentDocumentVersionId
				)
		SET @ClientEpisodeId = (
				SELECT max(ce.ClientEpisodeId)
				FROM ClientEpisodes ce
				WHERE ISNULL(ce.RecordDeleted, 'N') = 'N'
					AND ce.ClientId = @ClientId
					AND ce.DischargeDate IS NULL
				)

		UPDATE ClientPrograms
		SET [Status] = 5
			,DischargedDate = CASE 
				WHEN (cast(convert(VARCHAR(10), EnrolledDate, 101) AS DATE) <= cast(convert(VARCHAR(10), @EffectiveDate, 101) AS DATE))
					THEN convert(VARCHAR(10), @EffectiveDate, 101)
				ELSE convert(VARCHAR(10), GETDATE(), 101)
				END
		WHERE ClientId = @ClientId
			AND ClientProgramId IN (
				SELECT ClientProgramId
				FROM CustomDischargePrograms
				WHERE DocumentVersionId = @CurrentDocumentVersionId
					AND RecordDeleted = 'N'
				)

		IF (@TypeOfDischarge = 'A')
		BEGIN
			UPDATE ClientEpisodes
			SET [Status] = 102
				,DischargeDate = @EffectiveDate
			WHERE ClientId = @ClientId
				AND ClientEpisodeId = @ClientEpisodeId
		END

		IF (@TypeOfDischarge = 'A')
		BEGIN
			UPDATE ClientCoverageHistory
			SET EndDate = convert(VARCHAR(10), @EffectiveDate, 101)
			WHERE ClientCoveragePlanId IN (
					SELECT CCP.ClientCoveragePlanId
					FROM dbo.ClientCoveragePlans CCP
					JOIN CoveragePlans CP ON CP.CoveragePlanId = CCP.CoveragePlanId
					WHERE ClientId = @ClientId
						AND CP.Active = 'Y'
					)
				AND IsNULL(StartDate, '') != ''
				AND IsNULL(EndDate, '') = ''
		END

		IF (@TypeOfDischarge = 'A')
		BEGIN
			UPDATE ClientFees
			SET EndDate = convert(VARCHAR(10), @EffectiveDate, 101)
			WHERE ClientId = @ClientId
				AND StartDate IS NOT NULL
				AND EndDate IS NULL
		END
		IF (@TypeOfDischarge = 'A')
		BEGIN
			update Authorizations set EndDate = @EffectiveDate 
			where AuthorizationId in (select AuthorizationId  from Authorizations A
			join AuthorizationDocuments AD on A.AuthorizationDocumentId=AD.AuthorizationDocumentId
			join ClientCoveragePlans CCP on CCP.ClientCoveragePlanId =AD.ClientCoveragePlanId
			where A.[Status] in (305,4242,4243) -- status for Authorization 
			AND CCP.Clientid = @ClientId)
		END

		
										
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_PostSignatureUpdateDischarges') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                                  
				16
				,-- Severity.                                                                                                  
				1 -- State.                                                                                                  
				);
	END CATCH
END

