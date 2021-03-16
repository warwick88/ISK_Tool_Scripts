/****** Object:  StoredProcedure [dbo].[csp_SCUpdateCustomDocumentBHSCustomClientGroupNotes]    Script Date: 06/04/2014 13:26:03 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCUpdateCustomDocumentBHSCustomClientGroupNotes]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_SCUpdateCustomDocumentBHSCustomClientGroupNotes]
GO

/****** Object:  StoredProcedure [dbo].[csp_SCUpdateCustomDocumentBHSCustomClientGroupNotes]    Script Date: 06/04/2014 13:26:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_SCUpdateCustomDocumentBHSCustomClientGroupNotes] (
	@GroupServiceId INT
	,@StaffId INT
	)
AS
/******************************************************************************                        
**  File:                         
**  Name: csp_SCUpdateCustomDocumentBHSCustomClientGroupNotes                        
**  Desc:  Called from ssp_SCExecuteClientNoteCopyProcedure on click of update my notes                       
**  Return values:                        
**                         
**  Called by:                           
**                                      
**  Parameters:                        
**  Input       Output                        
**     ----------       -----------                        
**                        
**  Auth:                         
**  Date:                         
*******************************************************************************                        
**  Change History                        
*******************************************************************************                        
**  Date:      Author:     Description:                        
**  ---------  --------    -------------------------------------------                        
**16 10 2014   Venkatesh      Created for WMU Enahancements Task #14
**12-02-2018			 Kishore				New Module BHS GroupNote in F&CS- #7 copied from WWMU 
*************************************************************************************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @GroupId INT
		DECLARE @GroupNoteId INT
        
        Declare @DocumentCodeId int
        Select @DocumentCodeId = DocumentCodeId From DocumentCodes Where Code ='DC40159A-E64B-49BC-91F4-B2541CEDA58E'  

		SELECT @GroupId = Groupid
		FROM GroupServices
		WHERE GroupServiceId = @GroupServiceId

		DECLARE @GroupDescription VARCHAR(max)
		DECLARE @NumberOfClientsInSession int

		SELECT @GroupDescription = CGN.GroupDescription
			,@GroupNoteId = CGN.BHSGroupNoteId, @NumberOfClientsInSession=CGN.NumberOfClientsInSession
		FROM Documents D
		INNER JOIN CustomBHSGroupNotes CGN ON CGN.DocumentVersionId = D.CurrentDocumentVersionId
		WHERE GroupServiceId = @GroupServiceId
			AND ClientId IS NULL
			AND D.AuthorId = @StaffId
     
		UPDATE CustomDocumentBHSClientNotes
		SET GroupDescription = @GroupDescription
			,BHSGroupNoteId = @GroupNoteId,NumberOfClientsInSession=@NumberOfClientsInSession
		--from  GroupClients GC INNER join Documents D on GC.ClientId = D.ClientId   
		FROM Documents D
		INNER JOIN CustomDocumentBHSClientNotes CCGN ON D.CurrentDocumentVersionId = CCGN.DocumentVersionId
		INNER JOIN Services S ON S.ClinicianId = D.AuthorId
			AND S.ServiceId = D.ServiceId
		WHERE D.DocumentCodeId = @DocumentCodeId
			AND AuthorId = @StaffId
			AND S.ClinicianId = @StaffId
			AND S.GroupServiceId = @GroupServiceId
			AND D.STATUS <> 22
			AND ISNULL(D.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(CCGN.RecordDeleted, 'N') <> 'Y'
			--GroupId = @GroupId AND  ISNULL(GC.RecordDeleted,'N')<>'Y'   
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_SCUpdateCustomDocumentBHSCustomClientGroupNotes') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,/* Message text.*/ 16
				,/* Severity.*/ 1 /*State.*/
				);
	END CATCH
END
GO

