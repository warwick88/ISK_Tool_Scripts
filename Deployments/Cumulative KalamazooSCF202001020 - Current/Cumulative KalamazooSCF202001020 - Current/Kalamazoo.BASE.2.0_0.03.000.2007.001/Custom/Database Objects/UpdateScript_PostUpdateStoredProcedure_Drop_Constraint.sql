IF OBJECT_ID('CustomCarePlanPrescribedServices') IS NOT NULL
BEGIN
	IF COL_LENGTH('CustomCarePlanPrescribedServices', 'ProviderId') IS NOT NULL
	BEGIN
		IF EXISTS (
				SELECT *
				FROM sys.foreign_keys
				WHERE object_id = OBJECT_ID(N'[dbo].[Providers_CustomCarePlanPrescribedServices_FK]')
					AND parent_object_id = OBJECT_ID(N'[dbo].[CustomCarePlanPrescribedServices]')
				)
		BEGIN
			ALTER TABLE CustomCarePlanPrescribedServices

			DROP CONSTRAINT Providers_CustomCarePlanPrescribedServices_FK
		END
	END
END

IF EXISTS (
		SELECT ScreenId
		FROM Screens
		WHERE Code = '8AF7837B-05A7-4DF8-B2ED-6B852A5BA50A'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	UPDATE Screens
	SET PostUpdateStoredProcedure = 'csp_SCPostSignatureUpdateCarePlan'
	WHERE Code = '8AF7837B-05A7-4DF8-B2ED-6B852A5BA50A'
END
