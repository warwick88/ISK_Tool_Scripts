--Adding PreviouslyRequested table to the TableList for the Previously Requested calculations in the Interventions tab

IF EXISTS (
		SELECT TableList
		FROM DocumentCodes
		WHERE Code = '8AF7837B-05A7-4DF8-B2ED-6B852A5BA50A'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	UPDATE DocumentCodes
	SET TableList = 'DocumentCarePlans,CarePlanDomains,CarePlanDomainNeeds,CarePlanDomainGoals,CarePlanNeeds,CarePlanGoals,CarePlanGoalNeeds,CarePlanObjectives,CustomCarePlanPrescribedServices,CustomCarePlanPrescribedServiceObjectives,CarePlanPrograms,CarePlanDomainObjectives,ClientProgramsAuthorizationCodes,DocumentDiagnosisCodes,DocumentDiagnosis,DocumentDiagnosisFactors,CustomDocumentCarePlans,PreviouslyRequested'
	WHERE Code = '8AF7837B-05A7-4DF8-B2ED-6B852A5BA50A'
END
