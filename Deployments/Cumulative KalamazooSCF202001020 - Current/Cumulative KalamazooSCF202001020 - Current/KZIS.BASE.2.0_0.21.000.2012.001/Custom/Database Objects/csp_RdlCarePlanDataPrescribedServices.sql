--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlCarePlanDataPrescribedServices]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_RdlCarePlanDataPrescribedServices]
GO

CREATE PROCEDURE [dbo].[csp_RdlCarePlanDataPrescribedServices] --2582502
 (@DocumentVersionId AS INT)
AS
BEGIN
	/************************************************************************/
	/* Stored Procedure: csp_RdlCarePlanDataPrescribedServices    */
	/* Creation Date:  25-03-2013           */
	/* Purpose: Get Data for the RDL          */
	/* Input Parameters: DocumentVersionId         */
	/* Purpose: Use For Rdl Report           */
	/* Author:  Gayathri Naik            */
	/* Modifications                                                        */
	/* ---------------------------------------------------------------------*/
	--06-19-2020 Ankita Sinha  Task#8:         
	-- 28/12/2020			Arul Sonia		What :  Showing the Agency Name when Provider is Null in RDL 
	--										Why  :  KCMHSAS - Support #1614 
	/************************************************************************/
	BEGIN TRY
		DECLARE @CustomFieldsFlag CHAR(1)
		DECLARE @LableTimeDuration VARCHAR(10)

		--27/Aug/2015   R.M.Manikandan        
		SET @CustomFieldsFlag = (
				SELECT TOP 1 value
				FROM SystemConfigurationKeys
				WHERE [Key] = 'ShowAdditionalTimeAndDurationInCarePlanIntervention'
				)

		IF @CustomFieldsFlag = 'Y'
		BEGIN
			SET @LableTimeDuration = 'Time:'
		END
		ELSE
		BEGIN
			SET @LableTimeDuration = 'Duration:'
		END

		DECLARE @Results TABLE (
			AuthorizationCodeName VARCHAR(max)
			,ProviderName VARCHAR(max)
			,DocumentVersionId INT
			,FrequencyType VARCHAR(max)
			,PersonResponsible VARCHAR(max)
			,Units DECIMAL
			,TotalUnits DECIMAL
			,FromDate DATETIME
			,ToDate DATETIME
			,PrescribedServiceId INT
			,ObjectiveNumbers VARCHAR(max)
			,InterventionDetails VARCHAR(max)
			,RowNumber INT
			,TotalRequeste INT
			)

		INSERT INTO @Results (
			AuthorizationCodeName
			,ProviderName
			,DocumentVersionId
			,FrequencyType
			,PersonResponsible
			,Units
			,TotalUnits
			,FromDate
			,ToDate
			,PrescribedServiceId
			,InterventionDetails
			,RowNumber
			)
		SELECT DISTINCT AC.DisplayAs AS AuthorizationCodeName
			--, Case When Isnull(s.SiteName, '') = '' Then Rtrim(PV.ProviderName)       
			-- Else  Ltrim(s.SiteName)  
			-- End  As ProviderName 

			,CASE WHEN ISNULL(CPPS.ProviderId, '') = '' THEN (SELECT TOP 1 AgencyName FROM Agency) 
				WHEN CPPS.ProviderId = -2 THEN 'Community/Natural Support'
				ELSE Ltrim(s.SiteName)
			 END AS ProviderName

			,CPPS.DocumentVersionId
			,dbo.csf_GetGlobalCodeNameById(CPPS.[Frequency]) AS [FrequencyType]
			,GC.CodeName AS PersonResponsible
			,CPPS.Units
			,CPPS.TotalUnits
			,CPPS.FromDate
			,CPPS.ToDate
			,CPPS.CarePlanPrescribedServiceId
			,CPPS.Detail
			,'' AS RowNumber
		-- Changes End               
		FROM CustomCarePlanPrescribedServices CPPS
		LEFT JOIN CustomCarePlanPrescribedServiceObjectives CPPSO ON CPPSO.CarePlanPrescribedServiceId = CPPS.CarePlanPrescribedServiceId
			AND ISNULL(CPPSO.RecordDeleted, 'N') = 'N'
		--LEFT JOIN CarePlanObjectives CPO ON CPO.CarePlanObjectiveId= CPPSO.CarePlanObjectiveId  
		LEFT JOIN AuthorizationCodes AC ON AC.AuthorizationCodeId = CPPS.AuthorizationCodeId
			AND ISNULL(AC.RecordDeleted, 'N') = 'N'
		LEFT JOIN Globalcodes GC ON CPPS.PersonResponsible = GC.GlobalcOdeid
			AND ISNULL(GC.RecordDeleted, 'N') = 'N'
		LEFT JOIN Providers PV ON CPPS.ProviderId = PV.ProviderId
			AND ISNULL(PV.RecordDeleted, 'N') = 'N'
		Left Join Sites s on  s.siteid=CPPS.ProviderId
		WHERE CPPS.DocumentversionId = @DocumentversionId
			AND ISNULL(CPPS.RecordDeleted, 'N') = 'N'

		UPDATE r
		SET r.ObjectiveNumbers = (
				SELECT CONVERT(VARCHAR, o.ObjectiveNumber) + ','
				FROM CustomCarePlanPrescribedServiceObjectives pso
				JOIN CarePlanObjectives o ON o.CarePlanObjectiveId = pso.CarePlanObjectiveId
				WHERE pso.CarePlanPrescribedServiceId = r.PrescribedServiceId
					AND ISNULL(pso.RecordDeleted, 'N') = 'N'
				FOR XML PATH('')
				)
		FROM @Results r

		DECLARE @Units DECIMAL
		DECLARE @TotalUnits DECIMAL
		DECLARE @frequencyType INT
		DECLARE @StartDate DATETIME
		DECLARE @EndDate DATETIME
		DECLARE @Days INT
		DECLARE @UnitDays DECIMAL
		DECLARE @unitWeeks DECIMAL
		DECLARE @unitYear DECIMAL
		DECLARE @unitMonths DECIMAL
		DECLARE @unitQuarter DECIMAL
		DECLARE @totalUnitRequested INT
		-- Select Units,Frequency,FromDate, ToDate from CustomCareplanprescribedservices WHERE DOcumentversionID= 2013758
		DECLARE @Count INT
		DECLARE @coo INT = 0
		DECLARE @CarePlanPrescribedServiceId INT
		SELECT @Count = count(DOcumentversionID)
		FROM CustomCareplanprescribedservices where DOcumentversionID = @DocumentVersionId

		IF @Count > 0
		BEGIN
			DECLARE cursor_ActiveClients CURSOR
			FOR
			SELECT CarePlanPrescribedServiceId
			FROM CustomCareplanprescribedservices
			WHERE DOcumentversionID = @DocumentVersionId

			OPEN cursor_ActiveClients;

			FETCH NEXT
			FROM cursor_ActiveClients
			INTO @CarePlanPrescribedServiceId

			WHILE @@FETCH_STATUS = 0
			BEGIN
				SELECT @Units = Units
				    ,@TotalUnits=TotalUnits
					,@frequencyType = Frequency
					,@StartDate = FromDate
					,@EndDate = ToDate
				FROM CustomCareplanprescribedservices
				WHERE CarePlanPrescribedServiceId = @CarePlanPrescribedServiceId
				print @Units
				SET @Days = DATEDIFF(day, @EndDate, @StartDate)
				SET @UnitDays = @Days + 1
				SET @unitWeeks = @UnitDays / 7
				SET @unitYear = @UnitDays / 365
				SET @unitMonths = @UnitDays / 30
				SET @unitQuarter = @unitMonths / 3

				IF @UnitDays > 0
				BEGIN
					IF @frequencyType = 160
						AND @Units > 0 --for daily
					BEGIN
						SET @totalUnitRequested = @Units * @UnitDays
					END

					IF @frequencyType = 161
						AND @Units > 0 --for 2 days/week
					BEGIN
						SET @totalUnitRequested = (@unitWeeks * @Units) * 2
					END

					IF @frequencyType = 162
						AND @Units > 0 --for 3 days/week
					BEGIN
						SET @totalUnitRequested = (@unitWeeks * @Units) * 3
					END

					IF @frequencyType = 163
						AND @Units > 0 --for 4 days/week
					BEGIN
						SET @totalUnitRequested = (@unitWeeks * @Units) * 4
					END

					IF @frequencyType = 164
						AND @Units > 0 -- for 5 days/week
					BEGIN
						SET @totalUnitRequested = (@unitWeeks * @Units) * 5
					END

					IF @frequencyType = 165
						AND @Units > 0 -- for 6 days/week
					BEGIN
						SET @totalUnitRequested = (@unitWeeks * @Units) * 6
					END

					IF @frequencyType = 166
						AND @Units > 0 -- for weekly
					BEGIN
						SET @totalUnitRequested = (@unitWeeks * @Units)
					END

					IF @frequencyType = 167
						AND @Units > 0 --for every two weeks
					BEGIN
						SET @totalUnitRequested = (@unitWeeks * @Units) / 2
					END

					IF @frequencyType = 168
						AND @Units > 0 -- for monthly
					BEGIN
						SET @totalUnitRequested = (@unitMonths * @Units)
					END

					IF @frequencyType = 169
						AND @Units > 0 -- for twice a month
					BEGIN
						SET @totalUnitRequested = (@unitMonths * @Units) * 2
					END

					IF @frequencyType = 170
						AND @Units > 0 -- for every four weeks
					BEGIN
						SET @totalUnitRequested = (@Units * (@unitWeeks / 4))
					END

					IF @frequencyType = 171
						AND @Units > 0 -- for quarterly
					BEGIN
						SET @totalUnitRequested = @Units * @unitQuarter
					END

					IF @frequencyType = 172
						AND @Units > 0 -- for  twice a quarterly
					BEGIN
						SET @totalUnitRequested = (@Units * (@unitQuarter * 2))
					END

					IF @frequencyType = 173
						AND @Units > 0 -- for  every two month
					BEGIN
						SET @totalUnitRequested = (@unitMonths * (@Units / 2))
					END

					IF @frequencyType = 174
						AND @Units > 0 -- for  twice a year
					BEGIN
						SET @totalUnitRequested = ((2 * @Units) * @unitYear)
					END

					IF @frequencyType = 175
						AND @Units > 0 -- for  once a year
					BEGIN
						SET @totalUnitRequested = ((1 * @Units) * @unitYear)
					END

					IF @frequencyType = 176
						AND @Units > 0 -- for only  once
					BEGIN
						SET @totalUnitRequested = @Units
					END

					IF @frequencyType = 177
						AND @Units > 0 -- for Every 3 weeks
					BEGIN
						SET @totalUnitRequested = @Units * @unitWeeks / 3
					END
					print @totalUnitRequested
					
			 --   UPDATE r
				--SET r.TotalRequeste = 0
				--FROM @Results r WHERE r.PrescribedServiceId=@CarePlanPrescribedServiceId
				END
				print @totalUnitRequested
				FETCH NEXT
				FROM cursor_ActiveClients
				INTO @CarePlanPrescribedServiceId

				print @CarePlanPrescribedServiceId
				print @totalUnitRequested
			END

			CLOSE cursor_ActiveClients;

			DEALLOCATE cursor_ActiveClients;
		END
		ELSE
		BEGIN
			PRINT 2

			SELECT @Units = Units
			  ,@TotalUnits=TotalUnits
				,@frequencyType = Frequency
				,@StartDate = FromDate
				,@EndDate = ToDate
			FROM CustomCareplanprescribedservices
			WHERE DOcumentversionID = @DocumentVersionId

			SET @Days = DATEDIFF(day, @EndDate, @StartDate)
			SET @UnitDays = @Days + 1
			SET @unitWeeks = @UnitDays / 7
			SET @unitYear = @UnitDays / 365
			SET @unitMonths = @UnitDays / 30
			SET @unitQuarter = @unitMonths / 3

			

			IF @UnitDays > 0
			BEGIN
				IF @frequencyType = 160
					AND @Units > 0 --for daily
				BEGIN
					SET @totalUnitRequested = @Units * @UnitDays
				END

				IF @frequencyType = 161
					AND @Units > 0 --for 2 days/week
				BEGIN
					SET @totalUnitRequested = (@unitWeeks * @Units) * 2
				END

				IF @frequencyType = 162
					AND @Units > 0 --for 3 days/week
				BEGIN
					SET @totalUnitRequested = (@unitWeeks * @Units) * 3
				END

				IF @frequencyType = 163
					AND @Units > 0 --for 4 days/week
				BEGIN
					SET @totalUnitRequested = (@unitWeeks * @Units) * 4
				END

				IF @frequencyType = 164
					AND @Units > 0 -- for 5 days/week
				BEGIN
					SET @totalUnitRequested = (@unitWeeks * @Units) * 5
				END

				IF @frequencyType = 165
					AND @Units > 0 -- for 6 days/week
				BEGIN
					SET @totalUnitRequested = (@unitWeeks * @Units) * 6
				END

				IF @frequencyType = 166
					AND @Units > 0 -- for weekly
				BEGIN
					SET @totalUnitRequested = (@unitWeeks * @Units)
				END

				IF @frequencyType = 167
					AND @Units > 0 --for every two weeks
				BEGIN
					SET @totalUnitRequested = (@unitWeeks * @Units) / 2
				END

				IF @frequencyType = 168
					AND @Units > 0 -- for monthly
				BEGIN
					SET @totalUnitRequested = (@unitMonths * @Units)
				END

				IF @frequencyType = 169
					AND @Units > 0 -- for twice a month
				BEGIN
					SET @totalUnitRequested = (@unitMonths * @Units) * 2
				END

				IF @frequencyType = 170
					AND @Units > 0 -- for every four weeks
				BEGIN
					SET @totalUnitRequested = (@Units * (@unitWeeks / 4))
				END

				IF @frequencyType = 171
					AND @Units > 0 -- for quarterly
				BEGIN
					SET @totalUnitRequested = @Units * @unitQuarter
				END

				IF @frequencyType = 172
					AND @Units > 0 -- for  twice a quarterly
				BEGIN
					SET @totalUnitRequested = (@Units * (@unitQuarter * 2))
				END

				IF @frequencyType = 173
					AND @Units > 0 -- for  every two month
				BEGIN
					SET @totalUnitRequested = (@unitMonths * (@Units / 2))
				END

				IF @frequencyType = 174
					AND @Units > 0 -- for  twice a year
				BEGIN
					SET @totalUnitRequested = ((2 * @Units) * @unitYear)
				END

				IF @frequencyType = 175
					AND @Units > 0 -- for  once a year
				BEGIN
					SET @totalUnitRequested = ((1 * @Units) * @unitYear)
				END

				IF @frequencyType = 176
					AND @Units > 0 -- for only  once
				BEGIN
					SET @totalUnitRequested = @Units
				END

				IF @frequencyType = 177
					AND @Units > 0 -- for Every 3 weeks
				BEGIN
					SET @totalUnitRequested = @Units * @unitWeeks / 3
				END
			END
		END

		--UPDATE r
		--SET r.TotalRequeste = @totalUnitRequested
		--FROM @Results r

		SELECT r.AuthorizationCodeName
			,r.ProviderName
			,r.DocumentVersionId
			,r.PrescribedServiceId
			,r.FrequencyType
			,r.PersonResponsible
			,r.Units
			,r.TotalUnits
			,r.FromDate
			,r.ToDate
			,r.InterventionDetails
			,@LableTimeDuration AS LableTimeDuration
			,@CustomFieldsFlag AS CustomFieldsFlag
			
			,left(r.ObjectiveNumbers, len(r.ObjectiveNumbers) - 1) AS ObjectiveNumbers
			,r.TotalRequeste
			,ROW_NUMBER() OVER (  
			ORDER BY r.PrescribedServiceId ASC  
			) AS RowNumber   
		FROM @Results r
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_RdlCarePlanDataPrescribedServices') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                                                  
				16
				,-- Severity.                                                                                          
				1 -- State.                                                                                                                  
				);
	END CATCH
END
