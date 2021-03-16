 DECLARE @DocumentcodeId VARCHAR(MAX)
 DECLARE @CODE VARCHAR(MAX)
 SET @CODE='69E559DD-1A4D-46D3-B91C-E89DA48E0038'

 
 SET @DocumentcodeId=(Select DocumentCodeId from DocumentCodes 
                      where Code=@CODE And Active='Y' AND
                       ISNULL(Recorddeleted,'N')='N')   

If exists (select * from DocumentCodes Where DocumentCodeID = @DocumentcodeId)
 Begin
    Update DocumentCodes Set TableList = 'CustomDocumentMHAssessments,CustomDocumentAssessmentSubstanceUses,CustomDocumentMHCRAFFTs,CustomSubstanceUseAssessments,CustomSubstanceUseHistory2,CustomDocumentPreEmploymentActivities,CustomHRMAssessmentMedications,CustomMHAssessmentCurrentHealthIssues,CustomMHAssessmentPastHealthIssues,CustomMHAssessmentFamilyHistory,PHQ9Documents,PHQ9ADocuments,CustomMHAssessmentSupports,CustomDocumentMentalStatusExams,CustomOtherRiskFactors,CustomDocumentMHColumbiaAdultSinceLastVisits,CustomDailyLivingActivityScores,CarePlanDomains,CarePlanDomainNeeds,CarePlanNeeds,CustomHRMAssessmentLevelOfCareOptions,CustomDocumentPrePlanningWorksheet,CustomDispositions,CustomServiceDispositions,CustomProviderServices,CustomDocumentMHAssessmentCAFASs,CustomDocumentAssessmentPECFASs,DocumentDiagnosisCodes,DocumentDiagnosis,DocumentDiagnosisFactors,CustomDocumentAssessmentDiagnosisIDDEligibilities,CustomAssessmentDiagnosisIDDCriteria,CustomDocumentFunctionalAssessments,CustomAssessmentFunctionalCommunications'
    Where DocumentCodeID = @DocumentcodeId; 
 End;