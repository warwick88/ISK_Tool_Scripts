IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetCustomCarePlanPrescribedServicesAuthorizationCodes]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_GetCustomCarePlanPrescribedServicesAuthorizationCodes] --3,2015039,'G'
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_GetCustomCarePlanPrescribedServicesAuthorizationCodes] (
	@ClientID INT
	,@DocumentVersionId INT
	,@FlagInitGet CHAR(1)
	)
AS
/*******************************************************************************
* Author:	Jeffin Scaria
* Create date: 13/08/2020
* Description:	Get Authorization Codes for CustomCarePlanPrescribedServices
*      
*	Date		Author			Reason      
22 Oct 2020		Ankita			What: Commented the join with AuthorizationCodeProcedureCodes as required only last signed PrescribedServices
			
*******************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @EffectiveDate DATE
		DECLARE @DocumentStatus INT
		DECLARE @LatestConvCarePlanVersionId INT
		DECLARE @ConvCarePlanEffectiveDate DATE

		-- If the document is signed, use the effective date otherwise use the current date to get data.      
		SELECT @EffectiveDate = b.EffectiveDate
			,@DocumentStatus = b.STATUS
		FROM DocumentVersions a
		INNER JOIN Documents b ON (a.DocumentId = b.DocumentId)
		WHERE a.DocumentVersionId = @DocumentVersionId

		IF isnull(@DocumentStatus, 0) = 22
			SET @EffectiveDate = convert(DATE, getdate(), 101)

		-- List of Authorization Codes based on    
		INSERT INTO #CustomTempAuthorizationCodes (
			AuthorizationCodeId
			,AuthorizationCodeName
			,CarePlanPrescribedServiceId
			,DocumentVersionId
			,ProviderId
			,FromDate
			,ToDate
			,Units
			,Frequency
			,PersonResponsible
			,Detail
			,TotalUnits
			,IsInitializedFrom
			,TableName
			)
		SELECT AC.AuthorizationCodeId
		,LTRIM(RTRIM(AC.DisplayAs)) AS AuthorizationCodeName -- Added Ltrim and trim by Lakshmi, 08-08-2016, pathway support go live #12.21 
			,ISNULL(CarePlanPrescribedServiceId, CONVERT(INT, '-' + CONVERT(VARCHAR(50), row_number() OVER (
							ORDER BY AC.AuthorizationCodeId
							)))) AS PrescribedServiceId
			,@DocumentVersionId AS DocumentVersionId
			,CDCP.ProviderId
			,CDCP.FromDate
			,CDCP.ToDate
			,CDCP.Units
			,CDCP.Frequency
			,CDCP.PersonResponsible
			,CDCP.Detail
			,CDCP.TotalUnits
			,CarePlanPrescribedServiceId
			,'CustomCarePlanPrescribedServices' AS TableName
		FROM AuthorizationCodes AC
		JOIN CustomCarePlanPrescribedServices CDCP ON AC.AuthorizationCodeId = CDCP.AuthorizationCodeId
			AND CDCP.DocumentVersionId = @DocumentVersionId
		--INNER JOIN (
		--	SELECT DISTINCT ACPC.AuthorizationCodeId
		--	FROM AuthorizationCodeProcedureCodes ACPC
		--	INNER JOIN ProcedureCodes pro on pro.ProcedureCodeId=ACPC.ProcedureCodeId
		--	WHERE ISNULL(ACPC.RecordDeleted, 'N') <> 'Y'
		--	AND (ISNULL(Pro.AllowAllPrograms,'N') ='Y' OR EXISTS(SELECT 1 FROM ProgramProcedures pp 
		--		LEFT JOIN ClientPrograms CP ON CP.ProgramId = pp.ProgramId
		--		AND  CP.ClientId = @ClientID 
		--		AND ISNULL(CP.RecordDeleted, 'N') <> 'Y'
		--		AND CP.STATUS IN (
		--			1
		--			,4
		--			) /*GloablCodeId - 1-'Requested',4-'Enrolled' Status*/
		--	LEFT JOIN Programs P ON CP.ProgramId = P.ProgramId
		--		WHERE pp.ProcedureCodeId = ACPC.ProcedureCodeId
		--		AND ISNULL(pp.RecordDeleted, 'N') <> 'Y'
		--		AND ( pp.StartDate <= CONVERT(DATE,@EffectiveDate) OR pp.StartDate IS NULL )
		--		AND ( pp.EndDate >= CONVERT(DATE,@EffectiveDate) OR pp.EndDate IS NULL )
		--		AND (
		--			Convert(DATE, CP.EnrolledDate) <= @EffectiveDate
		--			OR Convert(DATE, CP.RequestedDate) <= @EffectiveDate
		--			)
		--		AND (
		--			CP.DischargedDate IS NULL
		--			OR Convert(DATE, CP.DischargedDate) >= @EffectiveDate
		--			)
		--		AND EXISTS (
		--				SELECT *
		--				FROM dbo.ssf_RecodeValuesCurrent('CAREPLANPROGRAMTYPE') AS CD
		--				WHERE CD.IntegerCodeId = P.ProgramType
		--				)))		
		--	) AS ACID ON AC.AuthorizationCodeId = ACID.AuthorizationCodeId
		WHERE ISNULL(AC.RecordDeleted, 'N') <> 'Y' AND ISNULL(CDCP.RecordDeleted, 'N') <> 'Y'
			AND AC.Active = 'Y'
			AND AC.Internal = 'Y'
		ORDER BY LTRIM(RTRIM(AC.DisplayAs)) ASC



	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_GetCustomCarePlanPrescribedServicesAuthorizationCodes') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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

