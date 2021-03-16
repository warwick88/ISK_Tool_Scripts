--Date: 08/05/2020
--Purpose: Update script for DocumentValidation to resolve the issues reported by QA.

DECLARE @DocumentcodeId VARCHAR(MAX)
DECLARE @CODE Varchar(100)
SET @CODE='69E559DD-1A4D-46D3-B91C-E89DA48E0038'
SET @DocumentcodeId=(Select DocumentCodeId from DocumentCodes 
                      where Code=@CODE And Active='Y' AND
                       ISNULL(Recorddeleted,'N')='N')

IF EXISTS (SELECT 1 FROM DocumentValidations Where DocumentcodeId=@DocumentcodeId   AND ColumnName='TreatmentNarrative'
AND ErrorMessage='Summary/LOC-Treatment- Discuss treatment focus and client preferences is required')
BEGIN
UPDATE DocumentValidations SET ErrorMessage='Summary/LOC - Treatment - Comment is required' Where DocumentcodeId=@DocumentcodeId   AND ColumnName='TreatmentNarrative'
AND ErrorMessage='Summary/LOC-Treatment- Discuss treatment focus and client preferences is required'
END

IF EXISTS (SELECT 1 FROM DocumentValidations Where DocumentcodeId=@DocumentcodeId   AND ColumnName='DDOneTimeOnly'
AND TabName='CRAFFT')
BEGIN
UPDATE DocumentValidations SET ErrorMessage='DD One Time Only - Not required to check the box when DD checkbox is not selected as population type in General tab.' 
Where DocumentcodeId=@DocumentcodeId   AND ColumnName='DDOneTimeOnly' AND TabName='CRAFFT'
END

IF EXISTS (SELECT 1 FROM DocumentValidations Where DocumentcodeId=@DocumentcodeId   AND ColumnName='DDOneTimeOnly'
AND TabName='UNCOPE')
BEGIN
UPDATE DocumentValidations SET ErrorMessage='DD One Time Only - Not required to check the box when DD checkbox is not selected as population type in General tab.' 
Where DocumentcodeId=@DocumentcodeId   AND ColumnName='DDOneTimeOnly' AND TabName='UNCOPE'
END

IF EXISTS (SELECT 1 FROM DocumentValidations Where DocumentcodeId=@DocumentcodeId   AND ColumnName='PsFamilyConcernsComment'
AND TabName='Psychosocial')
BEGIN
UPDATE DocumentValidations SET ValidationLogic=' FROM CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(PsFamilyConcernsComment,'''')='''' AND 
(ParentChildRelationshipIssue =''Y'' AND PsChildHousingIssues =''Y'' AND FamilyRelationshipIssues =''Y'' OR PsParentalParticipation =''N''  ) '
where DocumentcodeId=@DocumentcodeId   AND ColumnName='PsFamilyConcernsComment' AND TabName='Psychosocial'
END

IF EXISTS(Select 1 from DocumentValidations 
 Where TableName='CustomSubstanceUseAssessments' AND ColumnName='MedicationAssistedTreatmentRefferedReason' AND DocumentCodeId=@DocumentCodeId )
 BEGIN
 UPDATE DocumentValidations  SET ValidationLogic='from #CustomSUAssessments where isnull(MedicationAssistedTreatmentRefferedReason,'''') = '''' and isnull(MedicationAssistedTreatment,'''') <> '''' and isnull(MedicationAssistedTreatment,'''') <> ''A'' and isnull(@RunSUAssessmentValidations,''N'')=''Y'''
 Where TableName='CustomSubstanceUseAssessments' AND ColumnName='MedicationAssistedTreatmentRefferedReason' AND DocumentCodeId=@DocumentCodeId 
 END
 
 IF EXISTS (SELECT * FROM DocumentValidations Where DocumentcodeId=@DocumentcodeId   AND ColumnName='DrinksPerWeek'
AND TabName='UNCOPE')
BEGIN
UPDATE DocumentValidations SET  ValidationLogic='FROM #CustomDocumentAssessmentSubstanceUses CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE CS.DrinksPerWeek IS NULL and AdultOrChild = ''A'' and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
Where DocumentcodeId=@DocumentcodeId   AND ColumnName='DrinksPerWeek' AND TabName='UNCOPE'
END

 IF EXISTS (SELECT * FROM DocumentValidations Where DocumentcodeId=@DocumentcodeId   AND ColumnName='DrinksPerWeek'
AND TabName='CRAFFT')
BEGIN
UPDATE DocumentValidations SET  ValidationLogic= ' FROM #CustomDocumentAssessmentSubstanceUses CS JOIN #CustomDocumentMHAssessments CM ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE CS.DrinksPerWeek IS NULL AND ISNULL(CS.NotApplicable,''N'')=''N'' and AdultOrChild = ''C'' and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N''  '
Where DocumentcodeId=@DocumentcodeId   AND ColumnName='DrinksPerWeek' AND TabName='CRAFFT'
END


IF EXISTS (SELECT 1 FROM DocumentValidations Where DocumentcodeId=@DocumentcodeId   AND ColumnName='MemoryImmediateEvidencedBy')
BEGIN
UPDATE DocumentValidations SET ValidationLogic='FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND Memory=''A''   AND  
ISNULL(MemoryImmediateEvidencedBy,-1)=-1 ' Where DocumentcodeId=@DocumentcodeId   AND ColumnName='MemoryImmediateEvidencedBy'
END

IF EXISTS (SELECT 1 FROM DocumentValidations Where DocumentcodeId=@DocumentcodeId   AND ColumnName='MemoryRecentEvidencedBy')
BEGIN
UPDATE DocumentValidations SET ValidationLogic='FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND Memory=''A''   AND  
ISNULL(MemoryRecentEvidencedBy,'''')='''' ' Where DocumentcodeId=@DocumentcodeId   AND ColumnName='MemoryRecentEvidencedBy'
END

IF EXISTS (SELECT 1 FROM DocumentValidations Where DocumentcodeId=@DocumentcodeId   AND ColumnName='MemoryRemoteEvidencedBy')
BEGIN
UPDATE DocumentValidations SET ValidationLogic='FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND Memory=''A''  AND  
ISNULL(MemoryRemoteEvidencedBy,'''')='''' ' Where DocumentcodeId=@DocumentcodeId   AND ColumnName='MemoryRemoteEvidencedBy'
END


IF EXISTS (SELECT 1 FROM DocumentValidations Where DocumentcodeId=@DocumentcodeId   AND ColumnName='OrientationDescribeSituation')
BEGIN
UPDATE DocumentValidations SET ValidationLogic='FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND Orientation=''A''   AND  ISNULL(OrientationDescribeSituation,'''')=''''  '
 Where DocumentcodeId=@DocumentcodeId   AND ColumnName='OrientationDescribeSituation'
END

IF EXISTS (SELECT 1 FROM DocumentValidations Where DocumentcodeId=@DocumentcodeId   AND ColumnName='OrientationFullName')
BEGIN
UPDATE DocumentValidations SET ValidationLogic='FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND Orientation=''A''   AND  ISNULL(OrientationFullName,'''')=''''  '
 Where DocumentcodeId=@DocumentcodeId   AND ColumnName='OrientationFullName'
END


IF EXISTS (SELECT 1 FROM DocumentValidations Where DocumentcodeId=@DocumentcodeId   AND ColumnName='OrientationEvidencedPlace')
BEGIN
UPDATE DocumentValidations SET ValidationLogic='FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND Orientation=''A''   AND  ISNULL(OrientationEvidencedPlace,'''')=''''  '
 Where DocumentcodeId=@DocumentcodeId   AND ColumnName='OrientationEvidencedPlace'
END


IF EXISTS (SELECT 1 FROM DocumentValidations Where DocumentcodeId=@DocumentcodeId   AND ColumnName='OrientationFullDate')
BEGIN
UPDATE DocumentValidations SET ValidationLogic='FROM CustomDocumentMentalStatusExams WHERE DocumentVersionId=@DocumentVersionId AND Orientation=''A''   AND  ISNULL(OrientationFullDate,'''')=''''  '
 Where DocumentcodeId=@DocumentcodeId   AND ColumnName='OrientationFullDate'
END
