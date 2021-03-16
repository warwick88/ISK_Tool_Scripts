 
 /*Date			Author			Purpose*/ 
/*18/06/2020    Josekutty          
							 -- What       :- Scripts for validating assessments
							 -- Why        :- Validations are not working as per the requirement
							 -- Portal Task:- #12 in KCMHSAS Improvements.    
							 */
 DECLARE @DocumentcodeId VARCHAR(MAX)
 DECLARE @CODE VARCHAR(MAX)
 SET @CODE='69E559DD-1A4D-46D3-B91C-E89DA48E0038'

 
 SET @DocumentcodeId=(Select DocumentCodeId from DocumentCodes 
                      where Code=@CODE And Active='Y' AND
                       ISNULL(Recorddeleted,'N')='N')   					    

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId
			AND TableName = 'CustomDocumentAssessmentDiagnosisIDDEligibilities' And ColumnName = 'MentalPhysicalImpairment'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Diagnosis-IDD Eligibility'
		,15
		,N'CustomDocumentAssessmentDiagnosisIDDEligibilities'
		,N'MentalPhysicalImpairment'
		,N'from #CustomDocumentAssessmentDiagnosisIDDEligibilities
           Inner Join CustomDocumentMHAssessments On #CustomDocumentAssessmentDiagnosisIDDEligibilities.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
           WHERE #CustomDocumentAssessmentDiagnosisIDDEligibilities.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentAssessmentDiagnosisIDDEligibilities.MentalPhysicalImpairment is null or #CustomDocumentAssessmentDiagnosisIDDEligibilities.MentalPhysicalImpairment = '''')  '
		,N'IDD Eligibility Criteria - Has documented severe, chronic condition attributable to mental or physical impairment is required'
		,CAST(1 AS DECIMAL(18, 0))
		,N'IDD Eligibility Criteria - Has documented severe, chronic condition attributable to mental or physical impairment is required'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId AND TableName = 'CustomDocumentAssessmentDiagnosisIDDEligibilities' And ColumnName = 'ManifestedPrior'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Diagnosis-IDD Eligibility'
		,15
		,N'CustomDocumentAssessmentDiagnosisIDDEligibilities'
		,N'ManifestedPrior'
		,N'from #CustomDocumentAssessmentDiagnosisIDDEligibilities
           Inner Join CustomDocumentMHAssessments On #CustomDocumentAssessmentDiagnosisIDDEligibilities.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
           WHERE #CustomDocumentAssessmentDiagnosisIDDEligibilities.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentAssessmentDiagnosisIDDEligibilities.ManifestedPrior is null or #CustomDocumentAssessmentDiagnosisIDDEligibilities.ManifestedPrior = '''') '
		,N'IDD Eligibility Criteria - Condition manifested prior to age 22 is required'
		,CAST(2 AS DECIMAL(18, 0))
		,N'IDD Eligibility Criteria - Condition manifested prior to age 22 is required'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId AND TableName = 'CustomDocumentAssessmentDiagnosisIDDEligibilities' And ColumnName = 'TestingReportsReviewed'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Diagnosis-IDD Eligibility'
		,15
		,N'CustomDocumentAssessmentDiagnosisIDDEligibilities'
		,N'TestingReportsReviewed'
		,N'from #CustomDocumentAssessmentDiagnosisIDDEligibilities
           Inner Join CustomDocumentMHAssessments On #CustomDocumentAssessmentDiagnosisIDDEligibilities.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
           WHERE #CustomDocumentAssessmentDiagnosisIDDEligibilities.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentAssessmentDiagnosisIDDEligibilities.TestingReportsReviewed is null or #CustomDocumentAssessmentDiagnosisIDDEligibilities.TestingReportsReviewed = '''') '
		,N'IDD Eligibility Criteria - Testing reports reviewed and verified is required'
		,CAST(3 AS DECIMAL(18, 0))
		,N'IDD Eligibility Criteria - Testing reports reviewed and verified is required'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId AND TableName = 'CustomDocumentAssessmentDiagnosisIDDEligibilities' And ColumnName = 'LikelyToContinue'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Diagnosis-IDD Eligibility'
		,15
		,N'CustomDocumentAssessmentDiagnosisIDDEligibilities'
		,N'LikelyToContinue'
		,N'from #CustomDocumentAssessmentDiagnosisIDDEligibilities
           Inner Join CustomDocumentMHAssessments On #CustomDocumentAssessmentDiagnosisIDDEligibilities.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
           WHERE #CustomDocumentAssessmentDiagnosisIDDEligibilities.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentAssessmentDiagnosisIDDEligibilities.LikelyToContinue is null or #CustomDocumentAssessmentDiagnosisIDDEligibilities.LikelyToContinue = '''') '
		,N'IDD Eligibility Criteria - Likely to continue indefinitely is required'
		,CAST(4 AS DECIMAL(18, 0))
		,N'IDD Eligibility Criteria - Likely to continue indefinitely is required'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId AND TableName = 'CustomAssessmentDiagnosisIDDCriteria' And ColumnName = 'IsChecked'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Diagnosis-IDD Eligibility'
		,15
		,N'CustomAssessmentDiagnosisIDDCriteria'
		,N'IsChecked'
		,N'from (Select Count(*) TotCount from #CustomAssessmentDiagnosisIDDCriteria 
           Inner Join CustomDocumentMHAssessments On #CustomAssessmentDiagnosisIDDCriteria.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
           where #CustomAssessmentDiagnosisIDDCriteria.DocumentVersionId= @DocumentVersionId AND IsNull(#CustomAssessmentDiagnosisIDDCriteria.IsChecked,''N'') = ''Y'' 
		   And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' AND ISNULL(#CustomAssessmentDiagnosisIDDCriteria.RecordDeleted,''N'') = ''N'') #CustomAssessmentDiagnosisIDDCriteria
		   Where TotCount = 0 '
		,N'IDD Eligibility Criteria - Results in substantial functional limitations in 3 or more of the following areas is required'
		,CAST(5 AS DECIMAL(18, 0))
		,N'IDD Eligibility Criteria - Results in substantial functional limitations in 3 or more of the following areas is required'
		)
END; 

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'Dressing'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'Dressing'
		,N'from #CustomDocumentFunctionalAssessments
                   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.Dressing = '''' or #CustomDocumentFunctionalAssessments.Dressing is null  )'
		,N'Self-Care Skills - Dressing is required'
		,CAST(1 AS DECIMAL(18, 0))
		,N'Self-Care Skills - Dressing is required'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId AND Active = 'Y' And TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'Dressing,CodeName'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'Dressing,CodeName'
		,N'from #CustomDocumentFunctionalAssessments                     
		   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId 
		   Inner join GlobalCodes On GlobalCodes.GlobalCodeID = #CustomDocumentFunctionalAssessments.Dressing   
		   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId 
		   And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And CustomDocumentMHAssessments.AdultOrChild = ''A'' 
		   And GlobalCodes.CodeName like ''N/A%'''
		,N'Self-Care Skills - Dressing - N/A is not allowable for client age 18 or older'
		,CAST(2 AS DECIMAL(18, 0))
		,N'Self-Care Skills - Dressing - N/A is not allowable for client age 18 or older'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'PersonalHygiene'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'PersonalHygiene'
		,N'from #CustomDocumentFunctionalAssessments
                   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.PersonalHygiene is null or #CustomDocumentFunctionalAssessments.PersonalHygiene = '''') '
		,N'Self-Care Skills - Personal Hygiene is required'
		,CAST(3 AS DECIMAL(18, 0))
		,N'Self-Care Skills - Personal Hygiene is required'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'PersonalHygiene,CodeName'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'PersonalHygiene,CodeName'
		,N'from #CustomDocumentFunctionalAssessments                     
		   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId 
		   Inner join GlobalCodes On GlobalCodes.GlobalCodeID = #CustomDocumentFunctionalAssessments.PersonalHygiene   
		   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId 
		   And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And CustomDocumentMHAssessments.AdultOrChild = ''A'' 
		   And GlobalCodes.CodeName like ''N/A%'''
		,N'Self-Care Skills - Personal Hygiene - N/A is not allowable for client age 18 or older'
		,CAST(4 AS DECIMAL(18, 0))
		,N'Self-Care Skills - Personal Hygiene - N/A is not allowable for client age 18 or older'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'Bathing'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'Bathing'
		,N'from #CustomDocumentFunctionalAssessments
                   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.Bathing is null or #CustomDocumentFunctionalAssessments.Bathing = '''') '
		,N'Self-Care Skills - Bathing is required'
		,CAST(5 AS DECIMAL(18, 0))
		,N'Self-Care Skills - Bathing is required'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'Bathing,CodeName'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'Bathing,CodeName'
		,N'from #CustomDocumentFunctionalAssessments                     
		   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId 
		   Inner join GlobalCodes On GlobalCodes.GlobalCodeID = #CustomDocumentFunctionalAssessments.Bathing   
		   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId 
		   And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And CustomDocumentMHAssessments.AdultOrChild = ''A'' 
		   And GlobalCodes.CodeName like ''N/A%'''
		,N'Self-Care Skills - Bathing - N/A is not allowable for client age 18 or older'
		,CAST(6 AS DECIMAL(18, 0))
		,N'Self-Care Skills - Bathing - N/A is not allowable for client age 18 or older'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'Eating'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'Eating'
		,N'from #CustomDocumentFunctionalAssessments
                   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.Eating is null or #CustomDocumentFunctionalAssessments.Eating = '''') '
		,N'Self-Care Skills - Eating is required'
		,CAST(7 AS DECIMAL(18, 0))
		,N'Self-Care Skills - Eating is required'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'Eating,CodeName'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'Eating,CodeName'
		,N'from #CustomDocumentFunctionalAssessments                     
		   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId 
		   Inner join GlobalCodes On GlobalCodes.GlobalCodeID = #CustomDocumentFunctionalAssessments.Eating   
		   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId 
		   And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And CustomDocumentMHAssessments.AdultOrChild = ''A'' 
		   And GlobalCodes.CodeName like ''N/A%'''
		,N'Self-Care Skills - Eating - N/A is not allowable for client age 18 or older'
		,CAST(8 AS DECIMAL(18, 0))
		,N'Self-Care Skills - Eating - N/A is not allowable for client age 18 or older'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y'  AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'SleepHygiene'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'SleepHygiene'
		,N'from #CustomDocumentFunctionalAssessments
                   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.SleepHygiene is null or #CustomDocumentFunctionalAssessments.SleepHygiene = '''') '
		,N'Self-Care Skills - Sleep Hygiene is required'
		,CAST(9 AS DECIMAL(18, 0))
		,N'Self-Care Skills - Sleep Hygiene is required'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'SleepHygiene,CodeName'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'SleepHygiene,CodeName'
		,N'from #CustomDocumentFunctionalAssessments                     
		   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId 
		   Inner join GlobalCodes On GlobalCodes.GlobalCodeID = #CustomDocumentFunctionalAssessments.SleepHygiene   
		   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId 
		   And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And CustomDocumentMHAssessments.AdultOrChild = ''A'' 
		   And GlobalCodes.CodeName like ''N/A%'''
		,N'Self-Care Skills - Sleep Hygiene - N/A is not allowable for client age 18 or older'
		,CAST(10 AS DECIMAL(18, 0))
		,N'Self-Care Skills - Sleep Hygiene - N/A is not allowable for client age 18 or older'
		)
END; 

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'SelfCareSkillComments'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'SelfCareSkillComments'
		,N'from #CustomDocumentFunctionalAssessments
                   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.SelfCareSkillComments is null or #CustomDocumentFunctionalAssessments.SelfCareSkillComments = '''') '
		,N'Self-Care Skills - Comments is required'
		,CAST(11 AS DECIMAL(18, 0))
		,N'Self-Care Skills - Comments is required'
		)
END;
 
IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'FinancialTransactions'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'FinancialTransactions'
		,N'from #CustomDocumentFunctionalAssessments
                   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.FinancialTransactions is null or #CustomDocumentFunctionalAssessments.FinancialTransactions = '''') '
		,N'Daily Living Skills - Understands money/financial transactions is required'
		,CAST(12 AS DECIMAL(18, 0))
		,N'Daily Living Skills - Understands money/financial transactions is required'
		)
END;
 
IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'FinancialTransactions,CodeName'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'FinancialTransactions,CodeName'
		,N'from #CustomDocumentFunctionalAssessments                     
		   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId 
		   Inner join GlobalCodes On GlobalCodes.GlobalCodeID = #CustomDocumentFunctionalAssessments.FinancialTransactions   
		   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId 
		   And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And CustomDocumentMHAssessments.AdultOrChild = ''A'' 
		   And GlobalCodes.CodeName like ''N/A%'''
		,N'Daily Living Skills - Understands money/financial transactions - N/A is not allowable for client age 18 or older'
		,CAST(13 AS DECIMAL(18, 0))
		,N'Daily Living Skills - Understands money/financial transactions - N/A is not allowable for client age 18 or older'
		)
END; 

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'ManagesPersonalFinances'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'ManagesPersonalFinances'
		,N'from #CustomDocumentFunctionalAssessments
                   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.ManagesPersonalFinances is null or #CustomDocumentFunctionalAssessments.ManagesPersonalFinances = '''') '
		,N'Daily Living Skills - Manages personal finances is required'
		,CAST(14 AS DECIMAL(18, 0))
		,N'Daily Living Skills - Manages personal finances is required'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'ManagesPersonalFinances,CodeName'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'ManagesPersonalFinances,CodeName'
		,N'from #CustomDocumentFunctionalAssessments                     
		   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId 
		   Inner join GlobalCodes On GlobalCodes.GlobalCodeID = #CustomDocumentFunctionalAssessments.ManagesPersonalFinances   
		   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId 
		   And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And CustomDocumentMHAssessments.AdultOrChild = ''A'' 
		   And GlobalCodes.CodeName like ''N/A%'''
		,N'Daily Living Skills - Manages personal finances - N/A is not allowable for client age 18 or older'
		,CAST(15 AS DECIMAL(18, 0))
		,N'Daily Living Skills - Manages personal finances - N/A is not allowable for client age 18 or older'
		)
END; 

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'CookingMealPreparation'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'CookingMealPreparation'
		,N'from #CustomDocumentFunctionalAssessments
                   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.CookingMealPreparation is null or #CustomDocumentFunctionalAssessments.CookingMealPreparation = '''') '
		,N'Daily Living Skills - Cooking/meal preparation is required'
		,CAST(16 AS DECIMAL(18, 0))
		,N'Daily Living Skills - Cooking/meal preparation is required'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'CookingMealPreparation,CodeName'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'CookingMealPreparation,CodeName'
		,N'from #CustomDocumentFunctionalAssessments                     
		   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId 
		   Inner join GlobalCodes On GlobalCodes.GlobalCodeID = #CustomDocumentFunctionalAssessments.CookingMealPreparation   
		   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId 
		   And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And CustomDocumentMHAssessments.AdultOrChild = ''A'' 
		   And GlobalCodes.CodeName like ''N/A%'''
		,N'Daily Living Skills - Cooking/meal preparation - N/A is not allowable for client age 18 or older'
		,CAST(17 AS DECIMAL(18, 0))
		,N'Daily Living Skills - Cooking/meal preparation - N/A is not allowable for client age 18 or older'
		)
END; 


IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'KeepingRoomTidy'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'KeepingRoomTidy'
		,N'from #CustomDocumentFunctionalAssessments
                   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.KeepingRoomTidy is null or #CustomDocumentFunctionalAssessments.KeepingRoomTidy = '''' ) '
		,N'Daily Living Skills - Keeping room tidy/clean is required'
		,CAST(18 AS DECIMAL(18, 0))
		,N'Daily Living Skills - Keeping room tidy/clean is required'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'KeepingRoomTidy,CodeName'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'KeepingRoomTidy,CodeName'
		,N'from #CustomDocumentFunctionalAssessments                     
		   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId 
		   Inner join GlobalCodes On GlobalCodes.GlobalCodeID = #CustomDocumentFunctionalAssessments.KeepingRoomTidy   
		   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId 
		   And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And CustomDocumentMHAssessments.AdultOrChild = ''A'' 
		   And GlobalCodes.CodeName like ''N/A%'''
		,N'Daily Living Skills - Keeping room tidy/clean - N/A is not allowable for client age 18 or older'
		,CAST(19 AS DECIMAL(18, 0))
		,N'Daily Living Skills - Keeping room tidy/clean - N/A is not allowable for client age 18 or older'
		)
END; 

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'HouseholdTasks'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'HouseholdTasks'
		,N'from #CustomDocumentFunctionalAssessments
                   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.HouseholdTasks is null or #CustomDocumentFunctionalAssessments.HouseholdTasks = '''' )'
		,N'Daily Living Skills - Household tasks (vacuuming, dishes, dusting) is required'
		,CAST(20 AS DECIMAL(18, 0))
		,N'Daily Living Skills - Household tasks (vacuuming, dishes, dusting) is required'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'HouseholdTasks,CodeName'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'HouseholdTasks,CodeName'
		,N'from #CustomDocumentFunctionalAssessments                     
		   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId 
		   Inner join GlobalCodes On GlobalCodes.GlobalCodeID = #CustomDocumentFunctionalAssessments.HouseholdTasks   
		   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId 
		   And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And CustomDocumentMHAssessments.AdultOrChild = ''A'' 
		   And GlobalCodes.CodeName like ''N/A%'''
		,N'Daily Living Skills - Household tasks (vacuuming, dishes, dusting) - N/A is not allowable for client age 18 or older'
		,CAST(21 AS DECIMAL(18, 0))
		,N'Daily Living Skills - Household tasks (vacuuming, dishes, dusting) - N/A is not allowable for client age 18 or older'
		)
END; 
 
IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'LaundryTasks'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'LaundryTasks'
		,N'from #CustomDocumentFunctionalAssessments
                   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.LaundryTasks is null or  #CustomDocumentFunctionalAssessments.LaundryTasks = '''') '
		,N'Daily Living Skills - Laundry tasks is required'
		,CAST(22 AS DECIMAL(18, 0))
		,N'Daily Living Skills - Laundry tasks is required'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'LaundryTasks,CodeName'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'LaundryTasks,CodeName'
		,N'from #CustomDocumentFunctionalAssessments                     
		   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId 
		   Inner join GlobalCodes On GlobalCodes.GlobalCodeID = #CustomDocumentFunctionalAssessments.LaundryTasks   
		   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId 
		   And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And CustomDocumentMHAssessments.AdultOrChild = ''A'' 
		   And GlobalCodes.CodeName like ''N/A%'''
		,N'Daily Living Skills - Laundry tasks - N/A is not allowable for client age 18 or older'
		,CAST(23 AS DECIMAL(18, 0))
		,N'Daily Living Skills - Laundry tasks - N/A is not allowable for client age 18 or older'
		)
END; 
 
IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'HomeSafetyAwareness'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'HomeSafetyAwareness'
		,N'from #CustomDocumentFunctionalAssessments
                   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.HomeSafetyAwareness is null or #CustomDocumentFunctionalAssessments.HomeSafetyAwareness = '''' ) '
		,N'Daily Living Skills - In home safety awareness (hover help, kitchen safety, smoke alarm, calling 911, etc) is required'
		,CAST(24 AS DECIMAL(18, 0))
		,N'Daily Living Skills - In home safety awareness (hover help, kitchen safety, smoke alarm, calling 911, etc) is required'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'HomeSafetyAwareness,CodeName'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'HomeSafetyAwareness,CodeName'
		,N'from #CustomDocumentFunctionalAssessments                     
		   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId 
		   Inner join GlobalCodes On GlobalCodes.GlobalCodeID = #CustomDocumentFunctionalAssessments.HomeSafetyAwareness   
		   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId 
		   And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And CustomDocumentMHAssessments.AdultOrChild = ''A'' 
		   And GlobalCodes.CodeName like ''N/A%'''
		,N'Daily Living Skills - In home safety awareness (hover help, kitchen safety, smoke alarm, calling 911, etc) - N/A is not allowable for client age 18 or older'
		,CAST(25 AS DECIMAL(18, 0))
		,N'Daily Living Skills - In home safety awareness (hover help, kitchen safety, smoke alarm, calling 911, etc) - N/A is not allowable for client age 18 or older'
		)
END; 
  
IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'DailyLivingSkillComments'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'DailyLivingSkillComments'
		,N'from #CustomDocumentFunctionalAssessments
                   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.DailyLivingSkillComments is null or #CustomDocumentFunctionalAssessments.DailyLivingSkillComments = '''' ) '
		,N'Daily Living Skills - Comments is required'
		,CAST(26 AS DECIMAL(18, 0))
		,N'Daily Living Skills - Comments is required'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'ComfortableInteracting'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'ComfortableInteracting'
		,N'from #CustomDocumentFunctionalAssessments
                   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.ComfortableInteracting is null or #CustomDocumentFunctionalAssessments.ComfortableInteracting = '''') '
		,N'Social - Is comfortable interacting in small groups (less than 6) is required'
		,CAST(27 AS DECIMAL(18, 0))
		,N'Social - Is comfortable interacting in small groups (less than 6) is required'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'ComfortableInteracting,CodeName'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'ComfortableInteracting,CodeName'
		,N'from #CustomDocumentFunctionalAssessments                     
		   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId 
		   Inner join GlobalCodes On GlobalCodes.GlobalCodeID = #CustomDocumentFunctionalAssessments.ComfortableInteracting   
		   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId 
		   And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And CustomDocumentMHAssessments.AdultOrChild = ''A'' 
		   And GlobalCodes.CodeName like ''N/A%'''
		,N'Social - Is comfortable interacting in small groups (less than 6) - N/A is not allowable for client age 18 or older'
		,CAST(28 AS DECIMAL(18, 0))
		,N'Social - Is comfortable interacting in small groups (less than 6) - N/A is not allowable for client age 18 or older'
		)
END;   

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'ComfortableLargerGroups'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'ComfortableLargerGroups'
		,N'from #CustomDocumentFunctionalAssessments
                   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.ComfortableLargerGroups is null or #CustomDocumentFunctionalAssessments.ComfortableLargerGroups = '''') '
		,N'Social - Is comfortable while in larger groups (6+) is required'
		,CAST(29 AS DECIMAL(18, 0))
		,N'Social - Is comfortable while in larger groups (6+) is required'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'ComfortableLargerGroups,CodeName'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'ComfortableLargerGroups,CodeName'
		,N'from #CustomDocumentFunctionalAssessments                     
		   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId 
		   Inner join GlobalCodes On GlobalCodes.GlobalCodeID = #CustomDocumentFunctionalAssessments.ComfortableLargerGroups   
		   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId 
		   And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And CustomDocumentMHAssessments.AdultOrChild = ''A'' 
		   And GlobalCodes.CodeName like ''N/A%'''
		,N'Social - Is comfortable while in larger groups (6+) - N/A is not allowable for client age 18 or older'
		,CAST(30 AS DECIMAL(18, 0))
		,N'Social - Is comfortable while in larger groups (6+) - N/A is not allowable for client age 18 or older'
		)
END;   

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'AppropriateConversations'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'AppropriateConversations'
		,N'from #CustomDocumentFunctionalAssessments
                   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.AppropriateConversations is null or #CustomDocumentFunctionalAssessments.AppropriateConversations = '''') '
		,N'Social - Initiates appropriate conversations with others is required'
		,CAST(31 AS DECIMAL(18, 0))
		,N'Social - Initiates appropriate conversations with others is required'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'AppropriateConversations,CodeName'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'AppropriateConversations,CodeName'
		,N'from #CustomDocumentFunctionalAssessments                     
		   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId 
		   Inner join GlobalCodes On GlobalCodes.GlobalCodeID = #CustomDocumentFunctionalAssessments.AppropriateConversations   
		   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId 
		   And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And CustomDocumentMHAssessments.AdultOrChild = ''A'' 
		   And GlobalCodes.CodeName like ''N/A%'''
		,N'Social - Initiates appropriate conversations with others - N/A is not allowable for client age 18 or older'
		,CAST(32 AS DECIMAL(18, 0))
		,N'Social - Initiates appropriate conversations with others - N/A is not allowable for client age 18 or older'
		)
END;   
   
IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'AdvocatesForSelf'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'AdvocatesForSelf'
		,N'from #CustomDocumentFunctionalAssessments
                   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.AdvocatesForSelf is null or  #CustomDocumentFunctionalAssessments.AdvocatesForSelf = '''' ) '
		,N'Social - Advocates for self is required'
		,CAST(33 AS DECIMAL(18, 0))
		,N'Social - Advocates for self is required'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'AdvocatesForSelf,CodeName'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'AdvocatesForSelf,CodeName'
		,N'from #CustomDocumentFunctionalAssessments                     
		   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId 
		   Inner join GlobalCodes On GlobalCodes.GlobalCodeID = #CustomDocumentFunctionalAssessments.AdvocatesForSelf   
		   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId 
		   And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And CustomDocumentMHAssessments.AdultOrChild = ''A'' 
		   And GlobalCodes.CodeName like ''N/A%'''
		,N'Social - Advocates for self - N/A is not allowable for client age 18 or older'
		,CAST(34 AS DECIMAL(18, 0))
		,N'Social - Advocates for self - N/A is not allowable for client age 18 or older'
		)
END;   


IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'CommunicatesDailyLiving'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'CommunicatesDailyLiving'
		,N'from #CustomDocumentFunctionalAssessments
                   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.CommunicatesDailyLiving is null or #CustomDocumentFunctionalAssessments.CommunicatesDailyLiving = '''') '
		,N'Social - Communicates daily living choices/preferences is required'
		,CAST(35 AS DECIMAL(18, 0))
		,N'Social - Communicates daily living choices/preferences is required'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'CommunicatesDailyLiving,CodeName'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'CommunicatesDailyLiving,CodeName'
		,N'from #CustomDocumentFunctionalAssessments                     
		   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId 
		   Inner join GlobalCodes On GlobalCodes.GlobalCodeID = #CustomDocumentFunctionalAssessments.CommunicatesDailyLiving   
		   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId 
		   And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And CustomDocumentMHAssessments.AdultOrChild = ''A'' 
		   And GlobalCodes.CodeName like ''N/A%'''
		,N'Social - Communicates daily living choices/preferences - N/A is not allowable for client age 18 or older'
		,CAST(36 AS DECIMAL(18, 0))
		,N'Social - Communicates daily living choices/preferences - N/A is not allowable for client age 18 or older'
		)
END;    

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'SocialComments'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'SocialComments'
		,N'from #CustomDocumentFunctionalAssessments
                   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.SocialComments is null or #CustomDocumentFunctionalAssessments.SocialComments = '''') '
		,N'Social - Comments is required'
		,CAST(37 AS DECIMAL(18, 0))
		,N'Social - Comments is required'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'MaintainsFamily'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'MaintainsFamily'
		,N'from #CustomDocumentFunctionalAssessments
           Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
           WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.MaintainsFamily is null or #CustomDocumentFunctionalAssessments.MaintainsFamily = '''') '
		,N'Emotional - Has and maintains family relationships is required'
		,CAST(38 AS DECIMAL(18, 0))
		,N'Emotional - Has and maintains family relationships is required'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'MaintainsFamily,CodeName'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'MaintainsFamily,CodeName'
		,N'from #CustomDocumentFunctionalAssessments                     
		   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId 
		   Inner join GlobalCodes On GlobalCodes.GlobalCodeID = #CustomDocumentFunctionalAssessments.MaintainsFamily   
		   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId 
		   And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And CustomDocumentMHAssessments.AdultOrChild = ''A'' 
		   And GlobalCodes.CodeName like ''N/A%'''
		,N'Social - Has and maintains family relationships - N/A is not allowable for client age 18 or older'
		,CAST(39 AS DECIMAL(18, 0))
		,N'Social - Has and maintains family relationships - N/A is not allowable for client age 18 or older'
		)
END;    

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'MaintainsFriendships'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'MaintainsFriendships'
		,N'from #CustomDocumentFunctionalAssessments
                   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.MaintainsFriendships is null or #CustomDocumentFunctionalAssessments.MaintainsFriendships = '''') '
		,N'Emotional - Maintains friendships and community connections is required'
		,CAST(40 AS DECIMAL(18, 0))
		,N'Emotional - Maintains friendships and community connections is required'
		)
END;


IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'MaintainsFriendships,CodeName'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'MaintainsFriendships,CodeName'
		,N'from #CustomDocumentFunctionalAssessments                     
		   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId 
		   Inner join GlobalCodes On GlobalCodes.GlobalCodeID = #CustomDocumentFunctionalAssessments.MaintainsFriendships   
		   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId 
		   And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And CustomDocumentMHAssessments.AdultOrChild = ''A'' 
		   And GlobalCodes.CodeName like ''N/A%'''
		,N'Emotional - Maintains friendships and community connections - N/A is not allowable for client age 18 or older'
		,CAST(41 AS DECIMAL(18, 0))
		,N'Emotional - Maintains friendships and community connections - N/A is not allowable for client age 18 or older'
		)
END;     

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'DemonstratesEmpathy'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'DemonstratesEmpathy'
		,N'from #CustomDocumentFunctionalAssessments
           Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
           WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.DemonstratesEmpathy is null or  #CustomDocumentFunctionalAssessments.DemonstratesEmpathy = '''') '
		,N'Emotional - Demonstrates empathy toward others is required'
		,CAST(42 AS DECIMAL(18, 0))
		,N'Emotional - Demonstrates empathy toward others is required'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'DemonstratesEmpathy,CodeName'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'DemonstratesEmpathy,CodeName'
		,N'from #CustomDocumentFunctionalAssessments                     
		   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId 
		   Inner join GlobalCodes On GlobalCodes.GlobalCodeID = #CustomDocumentFunctionalAssessments.DemonstratesEmpathy   
		   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId 
		   And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And CustomDocumentMHAssessments.AdultOrChild = ''A'' 
		   And GlobalCodes.CodeName like ''N/A%'''
		,N'Emotional - Demonstrates empathy toward others - N/A is not allowable for client age 18 or older'
		,CAST(43 AS DECIMAL(18, 0))
		,N'Emotional - Demonstrates empathy toward others - N/A is not allowable for client age 18 or older'
		)
END;   

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'ManageEmotions'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'ManageEmotions'
		,N'from #CustomDocumentFunctionalAssessments
           Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
           WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.ManageEmotions is null or #CustomDocumentFunctionalAssessments.ManageEmotions = '''') '
		,N'Emotional - Can manage emotions appropriate to situation (frustration, anxiety, anger, etc) is required'
		,CAST(44 AS DECIMAL(18, 0))
		,N'Emotional - Can manage emotions appropriate to situation (frustration, anxiety, anger, etc) is required'
		)
END;


IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'ManageEmotions,CodeName'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'ManageEmotions,CodeName'
		,N'from #CustomDocumentFunctionalAssessments                     
		   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId 
		   Inner join GlobalCodes On GlobalCodes.GlobalCodeID = #CustomDocumentFunctionalAssessments.ManageEmotions   
		   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId 
		   And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And CustomDocumentMHAssessments.AdultOrChild = ''A'' 
		   And GlobalCodes.CodeName like ''N/A%'''
		,N'Emotional - Can manage emotions appropriate to situation (frustration, anxiety, anger, etc) - N/A is not allowable for client age 18 or older'
		,CAST(45 AS DECIMAL(18, 0))
		,N'Emotional - Can manage emotions appropriate to situation (frustration, anxiety, anger, etc) - N/A is not allowable for client age 18 or older'
		)
END;   

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'EmotionalComments'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'EmotionalComments'
		,N'from #CustomDocumentFunctionalAssessments
                   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.EmotionalComments is null or #CustomDocumentFunctionalAssessments.EmotionalComments = '''') '
		,N'Emotional - Comments is required'
		,CAST(46 AS DECIMAL(18, 0))
		,N'Emotional - Comments is required'
		)
END; 

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'RiskHarmToSelf'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'RiskHarmToSelf'
		,N'from #CustomDocumentFunctionalAssessments
           Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
           WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.RiskHarmToSelf is null or #CustomDocumentFunctionalAssessments.RiskHarmToSelf = '''') '
		,N'Behavioral - Risk/harm to self is required'
		,CAST(47 AS DECIMAL(18, 0))
		,N'Behavioral - Risk/harm to self is required'
		)
END; 

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'RiskSelfComments,CodeName'
		)
BEGIN 
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'RiskSelfComments,CodeName'
		,N'from #CustomDocumentFunctionalAssessments                     
			Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId 
			Inner join GlobalCodes On GlobalCodes.GlobalCodeID = #CustomDocumentFunctionalAssessments.RiskHarmToSelf   
			WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId =  @DocumentVersionId  
			And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And 
			(#CustomDocumentFunctionalAssessments.RiskSelfComments is null or #CustomDocumentFunctionalAssessments.RiskSelfComments = '''')
			And (GlobalCodes.CodeName not like ''0%'' and GlobalCodes.CodeName not like ''N/A%'')'
		,N'Behavioral - Comments for Risk/harm to self is required'
		,CAST(48 AS DECIMAL(18, 0))
		,N'Behavioral - Comments for Risk/harm to self is required'
		)
END;    

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'RiskHarmToOthers'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'RiskHarmToOthers'
		,N'from #CustomDocumentFunctionalAssessments
                   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.RiskHarmToOthers is null or #CustomDocumentFunctionalAssessments.RiskHarmToOthers = '''') '
		,N'Behavioral - Risk/harm to others is required'
		,CAST(49 AS DECIMAL(18, 0))
		,N'Behavioral - Risk/harm to others is required'
		)
END;


IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'RiskOtherComments,CodeName'
		)
BEGIN 
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'RiskOtherComments,CodeName'
		,N'from #CustomDocumentFunctionalAssessments                     
			Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId 
			Inner join GlobalCodes On GlobalCodes.GlobalCodeID = #CustomDocumentFunctionalAssessments.RiskHarmToOthers   
			WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId =  @DocumentVersionId  
			And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And 
			(#CustomDocumentFunctionalAssessments.RiskOtherComments is null or #CustomDocumentFunctionalAssessments.RiskOtherComments = '''')
			And (GlobalCodes.CodeName not like ''0%'' and GlobalCodes.CodeName not like ''N/A%'')'
		,N'Behavioral - Comments for Risk/harm to others is required'
		,CAST(50 AS DECIMAL(18, 0))
		,N'Behavioral - Comments for Risk/harm to others is required'
		)
END;       

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'PropertyDestruction'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'PropertyDestruction'
		,N'from #CustomDocumentFunctionalAssessments
                   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.PropertyDestruction is null or #CustomDocumentFunctionalAssessments.PropertyDestruction = '''') '
		,N'Behavioral - Property Destruction is required'
		,CAST(51 AS DECIMAL(18, 0))
		,N'Behavioral - Property Destruction is required'
		)
END;
 

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'PropertyDestructionComments,CodeName'
		)
BEGIN 
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'PropertyDestructionComments,CodeName'
		,N'from #CustomDocumentFunctionalAssessments                     
			Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId 
			Inner join GlobalCodes On GlobalCodes.GlobalCodeID = #CustomDocumentFunctionalAssessments.PropertyDestruction   
			WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId =  @DocumentVersionId  
			And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And 
			(#CustomDocumentFunctionalAssessments.PropertyDestructionComments is null or #CustomDocumentFunctionalAssessments.PropertyDestructionComments = '''')
			And (GlobalCodes.CodeName not like ''0%'' and GlobalCodes.CodeName not like ''N/A%'')'
		,N'Behavioral - Comments for Property Destruction is required'
		,CAST(52 AS DECIMAL(18, 0))
		,N'Behavioral - Comments for Property Destruction is required'
		)
END;        

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'Elopement'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'Elopement'
		,N'from #CustomDocumentFunctionalAssessments
                   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.Elopement is null or #CustomDocumentFunctionalAssessments.Elopement = '''') '
		,N'Behavioral - Elopement is required'
		,CAST(53 AS DECIMAL(18, 0))
		,N'Behavioral - Elopement is required'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'ElopementComments,CodeName'
		)
BEGIN 
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'ElopementComments,CodeName'
		,N'from #CustomDocumentFunctionalAssessments                     
			Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId 
			Inner join GlobalCodes On GlobalCodes.GlobalCodeID = #CustomDocumentFunctionalAssessments.Elopement   
			WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId =  @DocumentVersionId  
			And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And 
			(#CustomDocumentFunctionalAssessments.ElopementComments is null or #CustomDocumentFunctionalAssessments.ElopementComments = '''')
			And (GlobalCodes.CodeName not like ''0%'' and GlobalCodes.CodeName not like ''N/A%'')'
		,N'Behavioral - Comments for Elopement is required'
		,CAST(54 AS DECIMAL(18, 0))
		,N'Behavioral - Comments for Elopement is required'
		)
END;      

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'MentalIllnessSymptoms'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'MentalIllnessSymptoms'
		,N'from #CustomDocumentFunctionalAssessments
                   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.MentalIllnessSymptoms is null or #CustomDocumentFunctionalAssessments.MentalIllnessSymptoms = '''') '
		,N'Behavioral - Co-occurring mental illness symptoms interfere with activities of daily life is required'
		,CAST(55 AS DECIMAL(18, 0))
		,N'Behavioral - Co-occurring mental illness symptoms interfere with activities of daily life is required'
		)
END;
 
IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'MentalIllnessSymptomComments,CodeName'
		)
BEGIN 
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'MentalIllnessSymptomComments,CodeName'
		,N'from #CustomDocumentFunctionalAssessments                     
			Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId 
			Inner join GlobalCodes On GlobalCodes.GlobalCodeID = #CustomDocumentFunctionalAssessments.MentalIllnessSymptoms   
			WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId =  @DocumentVersionId  
			And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And 
			(#CustomDocumentFunctionalAssessments.MentalIllnessSymptomComments is null or #CustomDocumentFunctionalAssessments.MentalIllnessSymptomComments = '''')
			And (GlobalCodes.CodeName not like ''0%'' and GlobalCodes.CodeName not like ''N/A%'')'
		,N'Behavioral - Comments for Co-occurring mental illness... is required'
		,CAST(56 AS DECIMAL(18, 0))
		,N'Behavioral - Comments for Co-occurring mental illness... is required'
		)
END;      

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'RepetitiveBehaviors'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'RepetitiveBehaviors'
		,N'from #CustomDocumentFunctionalAssessments
                   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.RepetitiveBehaviors is null or #CustomDocumentFunctionalAssessments.RepetitiveBehaviors = '''') '
		,N'Behavioral - Repetitive/ritualistic behaviors interfering with own or others activities of daily life is required'
		,CAST(57 AS DECIMAL(18, 0))
		,N'Behavioral - Repetitive/ritualistic behaviors interfering with own or others activities of daily life is required'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'RepetitiveBehaviorComments,CodeName'
		)
BEGIN 
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'RepetitiveBehaviorComments,CodeName'
		,N'from #CustomDocumentFunctionalAssessments                     
			Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId 
			Inner join GlobalCodes On GlobalCodes.GlobalCodeID = #CustomDocumentFunctionalAssessments.RepetitiveBehaviors   
			WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId =  @DocumentVersionId  
			And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And 
			(#CustomDocumentFunctionalAssessments.RepetitiveBehaviorComments is null or #CustomDocumentFunctionalAssessments.RepetitiveBehaviorComments = '''')
			And (GlobalCodes.CodeName not like ''0%'' and GlobalCodes.CodeName not like ''N/A%'')'
		,N'Behavioral - Comments for Repetitive/ritualistic behaviors... is required'
		,CAST(58 AS DECIMAL(18, 0))
		,N'Behavioral - Comments for Repetitive/ritualistic behaviors... is required'
		)
END;      
 

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomAssessmentFunctionalCommunications' And ColumnName = 'Communication'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomAssessmentFunctionalCommunications'
		,N'Communication'
		,N'from (Select Count(*) TotCount from #CustomAssessmentFunctionalCommunications 
                   Inner Join CustomDocumentMHAssessments On #CustomAssessmentFunctionalCommunications.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   where #CustomAssessmentFunctionalCommunications.DocumentVersionId= @DocumentVersionId AND IsNull(#CustomAssessmentFunctionalCommunications.IsChecked,''N'') = ''Y'' 
		   And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' AND ISNULL(#CustomAssessmentFunctionalCommunications.RecordDeleted,''N'') = ''N'') #CustomAssessmentFunctionalCommunications
		   Where TotCount = 0 '
		,N'Communication - Communication is required'
		,CAST(59 AS DECIMAL(18, 0))
		,N'Communication - Communication is required'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'CommunicationComments'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'CommunicationComments'
		,N'from #CustomDocumentFunctionalAssessments
                   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.CommunicationComments is null or #CustomDocumentFunctionalAssessments.CommunicationComments = '''') '
		,N'Communication - Comments is required'
		,CAST(60 AS DECIMAL(18, 0))
		,N'Communication - Comments is required'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'RentArrangements'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'RentArrangements'
		,N'from #CustomDocumentFunctionalAssessments
                   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.RentArrangements is null or #CustomDocumentFunctionalAssessments.RentArrangements = '''') '
		,N'Community Living Skills - Find a place to live and manage leases and rent arrangements is required'
		,CAST(61 AS DECIMAL(18, 0))
		,N'Community Living Skills - Find a place to live and manage leases and rent arrangements is required'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'RentArrangements,CodeName'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'RentArrangements,CodeName'
		,N'from #CustomDocumentFunctionalAssessments                     
		   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId 
		   Inner join GlobalCodes On GlobalCodes.GlobalCodeID = #CustomDocumentFunctionalAssessments.RentArrangements   
		   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId 
		   And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And CustomDocumentMHAssessments.AdultOrChild = ''A'' 
		   And GlobalCodes.CodeName like ''N/A%'''
		,N'Community Living Skills - Find a place to live and manage leases and rent arrangements - N/A is not allowable for client age 18 or older.'
		,CAST(62 AS DECIMAL(18, 0))
		,N'Community Living Skills - Find a place to live and manage leases and rent arrangements - N/A is not allowable for client age 18 or older.'
		)
END;   
 

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'PayRentBillsOnTime'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'PayRentBillsOnTime'
		,N'from #CustomDocumentFunctionalAssessments
                   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.PayRentBillsOnTime is null or #CustomDocumentFunctionalAssessments.PayRentBillsOnTime = '''') '
		,N'Community Living Skills - Pay rent and bills on time is required'
		,CAST(63 AS DECIMAL(18, 0))
		,N'Community Living Skills - Pay rent and bills on time is required'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'PayRentBillsOnTime,CodeName'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'PayRentBillsOnTime,CodeName'
		,N'from #CustomDocumentFunctionalAssessments                     
		   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId 
		   Inner join GlobalCodes On GlobalCodes.GlobalCodeID = #CustomDocumentFunctionalAssessments.PayRentBillsOnTime   
		   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId 
		   And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And CustomDocumentMHAssessments.AdultOrChild = ''A'' 
		   And GlobalCodes.CodeName like ''N/A%'''
		,N'Community Living Skills - Pay rent and bills on time - N/A is not allowable for client age 18 or older.'
		,CAST(64 AS DECIMAL(18, 0))
		,N'Community Living Skills - Pay rent and bills on time - N/A is not allowable for client age 18 or older.'
		)
END;    

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'PersonalItems'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'PersonalItems'
		,N'from #CustomDocumentFunctionalAssessments
           Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
           WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.PersonalItems is null or #CustomDocumentFunctionalAssessments.PersonalItems = '''') '
		,N'Community Living Skills - Shop for food, clothes, and other personal items is required'
		,CAST(65 AS DECIMAL(18, 0))
		,N'Community Living Skills - Shop for food, clothes, and other personal items is required'
		)
END; 

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'PersonalItems,CodeName'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'PersonalItems,CodeName'
		,N'from #CustomDocumentFunctionalAssessments                     
		   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId 
		   Inner join GlobalCodes On GlobalCodes.GlobalCodeID = #CustomDocumentFunctionalAssessments.PersonalItems   
		   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId 
		   And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And CustomDocumentMHAssessments.AdultOrChild = ''A'' 
		   And GlobalCodes.CodeName like ''N/A%'''
		,N'Community Living Skills - Shop for food, clothes, and other personal items - N/A is not allowable for client age 18 or older.'
		,CAST(66 AS DECIMAL(18, 0))
		,N'Community Living Skills - Shop for food, clothes, and other personal items - N/A is not allowable for client age 18 or older.'
		)
END;    
 

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'AttendSocialOutings'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'AttendSocialOutings'
		,N'from #CustomDocumentFunctionalAssessments
                   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.AttendSocialOutings is null or #CustomDocumentFunctionalAssessments.AttendSocialOutings = '''') '
		,N'Community Living Skills - Arrange and attend social outings on a regular basis is required'
		,CAST(67 AS DECIMAL(18, 0))
		,N'Community Living Skills - Arrange and attend social outings on a regular basis is required'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'AttendSocialOutings,CodeName'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'AttendSocialOutings,CodeName'
		,N'from #CustomDocumentFunctionalAssessments                     
		   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId 
		   Inner join GlobalCodes On GlobalCodes.GlobalCodeID = #CustomDocumentFunctionalAssessments.AttendSocialOutings   
		   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId 
		   And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And CustomDocumentMHAssessments.AdultOrChild = ''A'' 
		   And GlobalCodes.CodeName like ''N/A%'''
		,N'Community Living Skills - Arrange and attend social outings on a regular basis - N/A is not allowable for client age 18 or older.'
		,CAST(68 AS DECIMAL(18, 0))
		,N'Community Living Skills - Arrange and attend social outings on a regular basis - N/A is not allowable for client age 18 or older.'
		)
END;     

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'CommunityTransportation'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'CommunityTransportation'
		,N'from #CustomDocumentFunctionalAssessments
                   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.CommunityTransportation is null or #CustomDocumentFunctionalAssessments.CommunityTransportation = '''') '
		,N'Community Living Skills - Use the community transportation system is required'
		,CAST(69 AS DECIMAL(18, 0))
		,N'Community Living Skills - Use the community transportation system is required'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'CommunityTransportation,CodeName'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'CommunityTransportation,CodeName'
		,N'from #CustomDocumentFunctionalAssessments                     
		   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId 
		   Inner join GlobalCodes On GlobalCodes.GlobalCodeID = #CustomDocumentFunctionalAssessments.CommunityTransportation   
		   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId 
		   And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And CustomDocumentMHAssessments.AdultOrChild = ''A'' 
		   And GlobalCodes.CodeName like ''N/A%'''
		,N'Community Living Skills - Use the community transportation system - N/A is not allowable for client age 18 or older.'
		,CAST(70 AS DECIMAL(18, 0))
		,N'Community Living Skills - Use the community transportation system - N/A is not allowable for client age 18 or older.'
		)
END;
 

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'DangerousSituations'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'DangerousSituations'
		,N'from #CustomDocumentFunctionalAssessments
                   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.DangerousSituations is null or #CustomDocumentFunctionalAssessments.DangerousSituations = '''') '
		,N'Community Living Skills - Keep self safe in neighbourhood, avoid being exploited, taken advantage of, and dangerous  situations or people is required'
		,CAST(71 AS DECIMAL(18, 0))
		,N'Community Living Skills - Keep self safe in neighbourhood, avoid being exploited, taken advantage of, and dangerous  situations or people is required'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'DangerousSituations,CodeName'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'DangerousSituations,CodeName'
		,N'from #CustomDocumentFunctionalAssessments                     
		   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId 
		   Inner join GlobalCodes On GlobalCodes.GlobalCodeID = #CustomDocumentFunctionalAssessments.DangerousSituations   
		   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId 
		   And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And CustomDocumentMHAssessments.AdultOrChild = ''A'' 
		   And GlobalCodes.CodeName like ''N/A%'''
		,N'Community Living Skills - Keep self safe in neighbourhood, avoid being exploited, taken advantage of, and dangerous  situations or people - N/A is not allowable for client age 18 or older.'
		,CAST(72 AS DECIMAL(18, 0))
		,N'Community Living Skills - Keep self safe in neighbourhood, avoid being exploited, taken advantage of, and dangerous  situations or people - N/A is not allowable for client age 18 or older.'
		)
END; 

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'AdvocateForSelf'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'AdvocateForSelf'
		,N'from #CustomDocumentFunctionalAssessments
                   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.AdvocateForSelf is null or #CustomDocumentFunctionalAssessments.AdvocateForSelf = '''') '
		,N'Community Living Skills - Know how to get assistance and advocate for self is required'
		,CAST(73 AS DECIMAL(18, 0))
		,N'Community Living Skills - Know how to get assistance and advocate for self is required'
		)
END;


IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'AdvocateForSelf,CodeName'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'AdvocateForSelf,CodeName'
		,N'from #CustomDocumentFunctionalAssessments                     
		   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId 
		   Inner join GlobalCodes On GlobalCodes.GlobalCodeID = #CustomDocumentFunctionalAssessments.AdvocateForSelf   
		   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId 
		   And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And CustomDocumentMHAssessments.AdultOrChild = ''A'' 
		   And GlobalCodes.CodeName like ''N/A%'''
		,N'Community Living Skills - Know how to get assistance and advocate for self - N/A is not allowable for client age 18 or older.'
		,CAST(74 AS DECIMAL(18, 0))
		,N'Community Living Skills - Know how to get assistance and advocate for self - N/A is not allowable for client age 18 or older.'
		)
END;
 

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'ManageChangesDailySchedule'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'ManageChangesDailySchedule'
		,N'from #CustomDocumentFunctionalAssessments
                   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.ManageChangesDailySchedule is null or #CustomDocumentFunctionalAssessments.ManageChangesDailySchedule = '''') '
		,N'Community Living Skills - Manage changes in daily schedule is required'
		,CAST(75 AS DECIMAL(18, 0))
		,N'Community Living Skills - Manage changes in daily schedule is required'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'ManageChangesDailySchedule,CodeName'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'ManageChangesDailySchedule,CodeName'
		,N'from #CustomDocumentFunctionalAssessments                     
		   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId 
		   Inner join GlobalCodes On GlobalCodes.GlobalCodeID = #CustomDocumentFunctionalAssessments.ManageChangesDailySchedule   
		   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId 
		   And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And CustomDocumentMHAssessments.AdultOrChild = ''A'' 
		   And GlobalCodes.CodeName like ''N/A%'''
		,N'Community Living Skills - Manage changes in daily schedule - N/A is not allowable for client age 18 or older.'
		,CAST(76 AS DECIMAL(18, 0))
		,N'Community Living Skills - Manage changes in daily schedule - N/A is not allowable for client age 18 or older.'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'CommunityLivingSkillComments'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'CommunityLivingSkillComments'
		,N'from #CustomDocumentFunctionalAssessments
                   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.CommunityLivingSkillComments is null or #CustomDocumentFunctionalAssessments.CommunityLivingSkillComments = '''') '
		,N'Community Living Skills - Comments is required'
		,CAST(77 AS DECIMAL(18, 0))
		,N'Community Living Skills - Comments is required'
		)
END;

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'PreferredActivities'
		)
BEGIN
	
	INSERT [dbo].[DocumentValidations] (
		 [Active]
		,[DocumentCodeId]
		,[DocumentType]
		,[TabName]
		,[TabOrder]
		,[TableName]
		,[ColumnName]
		,[ValidationLogic]
		,[ValidationDescription]
		,[ValidationOrder]
		,[ErrorMessage]
		)
	VALUES (
		N'Y'
		,@DocumentcodeId
		,NULL
		,N'Functional Assessment'
		,16
		,N'CustomDocumentFunctionalAssessments'
		,N'PreferredActivities'
		,N'from #CustomDocumentFunctionalAssessments
                   Inner Join CustomDocumentMHAssessments On #CustomDocumentFunctionalAssessments.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId
                   WHERE #CustomDocumentFunctionalAssessments.DocumentVersionId = @DocumentVersionId And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' And (#CustomDocumentFunctionalAssessments.PreferredActivities is null or #CustomDocumentFunctionalAssessments.PreferredActivities = '''') '
		,N'Community Living Skills - Preferred activities/interests is required'
		,CAST(78 AS DECIMAL(18, 0))
		,N'Community Living Skills - Preferred activities/interests is required'
		)
END;
 
 
IF EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId AND TableName = 'CustomAssessmentDiagnosisIDDCriteria' And ColumnName = 'IsChecked'
		)
BEGIN

  Update DocumentValidations 
  Set ValidationLogic = N'from (
						Select @DocumentVersionId DocumentVersionId,Count(*) TotCount from #CustomAssessmentDiagnosisIDDCriteria              
						where #CustomAssessmentDiagnosisIDDCriteria.DocumentVersionId= @DocumentVersionId AND IsNull(#CustomAssessmentDiagnosisIDDCriteria.IsChecked,''N'') = ''Y''        
						AND ISNULL(#CustomAssessmentDiagnosisIDDCriteria.RecordDeleted,''N'') = ''N'' 
						) #CustomAssessmentDiagnosisIDDCriteria
						Inner Join CustomDocumentMHAssessments On #CustomAssessmentDiagnosisIDDCriteria.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId             
						Where TotCount = 0 And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' '
  WHERE DocumentCodeId = @DocumentcodeId AND TableName = 'CustomAssessmentDiagnosisIDDCriteria' And ColumnName = 'IsChecked';
	  
END; 


IF EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomAssessmentFunctionalCommunications' And ColumnName = 'Communication'
		)
BEGIN

    Update DocumentValidations 
	Set ValidationLogic = N'from (
							Select  @DocumentVersionId DocumentVersionId,Count(*) TotCount from #CustomAssessmentFunctionalCommunications                      
							where #CustomAssessmentFunctionalCommunications.DocumentVersionId= @DocumentVersionId 
							AND IsNull(#CustomAssessmentFunctionalCommunications.IsChecked,''N'') = ''Y''        
							AND ISNULL(#CustomAssessmentFunctionalCommunications.RecordDeleted,''N'') = ''N''
							) #CustomAssessmentFunctionalCommunications    
							Inner Join CustomDocumentMHAssessments On #CustomAssessmentFunctionalCommunications.DocumentVersionId = CustomDocumentMHAssessments.DocumentVersionId                     
							Where TotCount = 0 And IsNull(CustomDocumentMHAssessments.ClientInDDPopulation,''N'') = ''Y'' '
	WHERE DocumentCodeId = @DocumentcodeId And Active = 'Y' AND TableName = 'CustomAssessmentFunctionalCommunications' And ColumnName = 'Communication' 
END;

IF EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentcodeId AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'MaintainsFamily,CodeName'
		)
BEGIN

  Update DocumentValidations
  Set ValidationDescription = 'Emotional - Has and maintains family relationships - N/A is not allowable for client age 18 or older',
  ErrorMessage = 'Emotional - Has and maintains family relationships - N/A is not allowable for client age 18 or older'
  WHERE DocumentCodeId = @DocumentcodeId AND TableName = 'CustomDocumentFunctionalAssessments' And ColumnName = 'MaintainsFamily,CodeName';
  
END; 