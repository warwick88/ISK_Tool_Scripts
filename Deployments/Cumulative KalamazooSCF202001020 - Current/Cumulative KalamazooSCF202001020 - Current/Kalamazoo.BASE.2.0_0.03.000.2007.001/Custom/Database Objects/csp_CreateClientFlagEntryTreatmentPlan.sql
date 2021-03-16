IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_CreateFlagTratmentPlanDue]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_CreateFlagTratmentPlanDue] 
GO
CREATE PROCEDURE [dbo].csp_CreateFlagTratmentPlanDue
AS
/******************************************************************************                                    
**  File: csp_CreateFlagTratmentPlanDue.sql                  
**  Name: csp_CreateFlagTratmentPlanDue             
**  Desc:                   
**                                    
**  Return values: <Return Values>                                   
**                                     
**  Called by: <Code file that calls>                                      
**                                                  
**                           
**  Input   Output                                    
**  ----    -----------                                    
**                                    
**  Created By: Ankita Sinha                  
**  Date:  June 18 2020                  
*******************************************************************************                                    
**  Change History                                    
*******************************************************************************                                    
**  Date:   Author:    Description:   
 -----   -------  -----------  
 June 18 2020  Ankita Sinha	Task #8 KCMHSAS Improvements
                            
*******************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @EpsiodeRegistrationDate AS DATETIME
		DECLARE @EffectiveDate DATETIME
		DECLARE @EpsiodeDischargeDate AS DATETIME
		DECLARE @LatestsignedDocumentVersionId INT
		DECLARE @SameEpisode CHAR(1)
		DECLARE @CarePlanDocumentcodeId INT
		DECLARE @CarePlanCODE VARCHAR(MAX)
		DECLARE @CODE VARCHAR(MAX)
		DECLARE @ReviewEntireCarePlan INT
		DECLARE @ReviewEntireCareType CHAR(1)
		DECLARE @ReviewEntireCarePlanDate DATETIME
		DECLARE @TodaysDate DATETIME
		DECLARE @DiffOfDate DATETIME
		DECLARE @NoteType INT

		SET @TodaysDate = GETDATE()

		DECLARE @DateAddFrequencyEffectiveDate DATETIME
		DECLARE @Frequency INT
		DECLARE @PriorDate DATETIME
		DECLARE @Note VARCHAR(Max)
		DECLARE @StartDate DATETIME
		DECLARE @EndDate DATETIME
		DECLARE @CLINICIANID INT
		DECLARE @Notelavel INT

		SET @CarePlanCODE = '8AF7837B-05A7-4DF8-B2ED-6B852A5BA50A'
		SET @CarePlanDocumentcodeId = (
				SELECT DocumentCodeId
				FROM DocumentCodes
				WHERE Code = @CarePlanCODE
				)


		-- To Get all the Active Clinets and Looping into each Client
		DECLARE @NoOfClient INT
		DECLARE @Clientid INT

		DECLARE cursor_ActiveClients CURSOR
		FOR
		SELECT Count(D.Clientid)
			,D.Clientid
		FROM Clients C
		INNER JOIN Documents D ON D.ClientId = C.clientid
		WHERE C.Active = 'Y'
			AND D.DocumentCodeid = @CarePlanDocumentcodeId
			AND D.STATUS = 22
		GROUP BY D.Clientid

		OPEN cursor_ActiveClients;

		FETCH NEXT
		FROM cursor_ActiveClients
		INTO @NoOfClient
			,@Clientid;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT TOP 1 @LatestsignedDocumentVersionId = dv.DocumentVersionId
				,@EffectiveDate = d.EffectiveDate
			FROM DocumentVersions dv
			INNER JOIN Documents d ON dv.documentid = d.DocumentId
			INNER JOIN DocumentCodes dc ON d.DocumentCodeId = dc.DocumentCodeId
			WHERE d.ClientId = @Clientid
				AND d.[Status] = 22
				AND dc.DocumentCodeId IN (@CarePlanDocumentcodeId)
			ORDER BY d.CurrentDocumentVersionId DESC

			-- For Checking In current Episode
			SELECT @EpsiodeRegistrationDate = CE.RegistrationDate
				,@EpsiodeDischargeDate = CE.DischargeDate
			FROM ClientEpisodes CE
			INNER JOIN GlobalCodes GC ON GC.GlobalCodeId = CE.[Status]
			WHERE ClientId = @Clientid
				AND ISNULL(CE.RecordDeleted, 'N') = 'N'
				AND CE.DischargeDate IS NULL
				AND GC.GlobalCodeId IN (
					100
					,101
					)

			IF (@EpsiodeDischargeDate IS NULL)
			BEGIN
				IF (
						@EpsiodeRegistrationDate IS NOT NULL
						AND @EffectiveDate >= @EpsiodeRegistrationDate
						)
					SET @SameEpisode = 'Y'
			END
			ELSE
			BEGIN
				IF (
						@EpsiodeDischargeDate IS NOT NULL
						AND @EffectiveDate <= @EpsiodeDischargeDate
						)
					SET @SameEpisode = 'Y'
			END

			--For Checking In current Episode End
			--Flag note = Plan due on [Indicate date based on frequency selected on previous plan, if no previous care plan in current episode., indicate today's date]
			IF @SameEpisode IS NOT NULL
				AND @LatestsignedDocumentVersionId > 0
			BEGIN
				--SET @Note = ' Plan due on' + @EffectiveDate
				SET @Note='';
			END
			ELSE
			BEGIN
				--SET @Note = ' Plan due on' + @TodaysDate
				SET @Note=''
			END

			--Start date = date flag is triggered.
			SET @StartDate = @TodaysDate

			--Assigned To =  staff name that is listed in Primary Clinician field of Client Information for the client flag is triggered for.
			SELECT @CLINICIANID = PrimaryClinicianId
			FROM Clients C
			INNER JOIN Documents DC ON DC.ClientId = C.ClientId
				AND DC.CurrentDocumentVersionId = @LatestsignedDocumentVersionId

			SET @EndDate = ''
			--End Date = NULL. Once a new care plan is signed, then flag end date will auto update with the effective date of the new Care Plan.
			SET @Notelavel = 4502 -- Warning

			
			--print 'd'
			SELECT @NoteType = FlagTypeId
			FROM FlagTypes
			WHERE FlagType = 'Treatment Plan Due'
				AND Active = 'Y'

			SELECT @ReviewEntireCarePlan = ReviewEntireCarePlan
				,@ReviewEntireCareType = ReviewEntireCareType
				,@ReviewEntireCarePlanDate = ReviewEntireCarePlanDate
			FROM DocumentCarePlans DCP
			WHERE DCP.DocumentversionId = @LatestsignedDocumentVersionId

			-- If last signed care plan in current episode has frequency selected, look at frequency and if today's date is 14 days (or less to include overdue for first run of job)
			SELECT @Frequency = REPLACE(@ReviewEntireCarePlan, ' days', '')

			SET @DateAddFrequencyEffectiveDate = DATEADD(DAY, @Frequency, @EffectiveDate)
			SET @PriorDate = DATEADD(DAY, - 14, @DateAddFrequencyEffectiveDate)

			--(Effectivedate+ Frequecy ) -14 days
			-- Current date > = priordate
			--set @DiffOfDate =DATEDIFF(day, @ReviewEntireCarePlanDate, @TodaysDate)  
			IF @SameEpisode IS NOT NULL
				AND @Frequency > 0
			BEGIN
				IF @TodaysDate >= @PriorDate
				BEGIN
					INSERT INTO ClientNotes (
						ClientId
						,NoteType
						,NoteSubtype
						,NoteLevel
						,Note
						,Active
						,StartDate
						,EndDate
						,Comment
						,AssignedTo
						)
					VALUES (
						@Clientid
						,@NoteType
						,NULL
						,@Notelavel
						,@Note
						,'Y'
						,@StartDate
						,@EndDate
						,NULL
						,@CLINICIANID
						)
				
				END
			END

			--If last signed care plan in current episode has an actual date in the Review section, then the flag should trigger 14 days (or less to include overdue for first run of job)  prior to that date.
			SET @PriorDate = DATEADD(DAY, - 14, @ReviewEntireCarePlanDate)

			IF @SameEpisode IS NOT NULL
				AND @ReviewEntireCarePlanDate IS NOT NULL
			BEGIN
				IF @TodaysDate >= @PriorDate
					-- Current date > = priordate
				BEGIN
				
					INSERT INTO ClientNotes (
						ClientId
						,NoteType
						,NoteSubtype
						,NoteLevel
						,Note
						,Active
						,StartDate
						,EndDate
						,Comment
						,AssignedTo
						)
					VALUES (
						@Clientid
						,@NoteType
						,NULL
						,@Notelavel
						,@Note
						,'Y'
						,@StartDate
						,@EndDate
						,NULL
						,@CLINICIANID
						)
				END
			END

			--If no care plan exists in current episode, then flag should trigger.
			IF @SameEpisode IS NULL
			BEGIN
				INSERT INTO ClientNotes (
					ClientId
					,NoteType
					,NoteSubtype
					,NoteLevel
					,Note
					,Active
					,StartDate
					,EndDate
					,Comment
					,AssignedTo
					)
				VALUES (
					@Clientid
					,@NoteType
					,NULL
					,@Notelavel
					,@Note
					,'Y'
					,@StartDate
					,@EndDate
					,NULL
					,@CLINICIANID
					)

				
			END

			FETCH NEXT
			FROM cursor_ActiveClients
			INTO @NoOfClient
				,@Clientid;
		END

		CLOSE cursor_ActiveClients;

		DEALLOCATE cursor_ActiveClients;
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_CreateFlagTratmentPlanDue') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,16
				,- 1
				);
	END CATCH
END

