--Validation scripts for Task #704 in MHP-Customizations
/******************************************************************************** 

-- *****History****  
/*       Date           Author				Purpose                                */
/*       10/Mar/2020	Preeti k			Moving document from PEP TO Kalamazoo  */
*********************************************************************************/

DECLARE @DocumentCodeID INT

SELECT @DocumentCodeID = documentcodeid
FROM dbo.DocumentCodes
WHERE Code = 'FB6130A4-15FA-4E6F-B73D-21A33394D7EC'

DELETE
FROM DocumentValidations
WHERE DocumentCodeId = @DocumentCodeID

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
	,@DocumentCodeID
	,NULL
	,N'Adverse Childhood Experience'
	,1
	,N'CustomDocumentAdverseChildhoodExperiences'
	,N'Humiliate'
	,N'FROM CustomDocumentAdverseChildhoodExperiences WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Humiliate,'''') = '''' AND ISNULL(RecordDeleted,''N'') = ''N'' AND ISNULL(UnableToComplete,''N'') = ''N'''
	,N'1. Did the parent or other adult in the household often swear at you is required.'
	,CAST(1 AS DECIMAL(18, 0))
	,N'1. Did the parent or other adult in the household often swear at you is required.'
	)
	,(
	N'Y'
	,@DocumentCodeID
	,NULL
	,N'Adverse Childhood Experience'
	,1
	,N'CustomDocumentAdverseChildhoodExperiences'
	,N'Injured'
	,N'FROM CustomDocumentAdverseChildhoodExperiences WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Injured,'''') = '''' AND ISNULL(RecordDeleted,''N'') = ''N'' AND ISNULL(UnableToComplete,''N'') = ''N'''
	,N'2. Did the parent or other adult in the household often push, grab...is required.'
	,CAST(2 AS DECIMAL(18, 0))
	,N'2. Did the parent or other adult in the household often push, grab...is required.'
	)
	,(
	N'Y'
	,@DocumentCodeID
	,NULL
	,N'Adverse Childhood Experience'
	,1
	,N'CustomDocumentAdverseChildhoodExperiences'
	,N'Touch'
	,N'FROM CustomDocumentAdverseChildhoodExperiences WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Touch,'''') = '''' AND ISNULL(RecordDeleted,''N'') = ''N'' AND ISNULL(UnableToComplete,''N'') = ''N'''
	,N'3. Did an adult or person at least 5 years older than you ever touch or fondle you... is required.'
	,CAST(3 AS DECIMAL(18, 0))
	,N'3. Did an adult or person at least 5 years older than you ever touch or fondle you... is required.'
	)
	,(
	N'Y'
	,@DocumentCodeID
	,NULL
	,N'Adverse Childhood Experience'
	,1
	,N'CustomDocumentAdverseChildhoodExperiences'
	,N'Support'
	,N'FROM CustomDocumentAdverseChildhoodExperiences WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Support,'''') = '''' AND ISNULL(RecordDeleted,''N'') = ''N'' AND ISNULL(UnableToComplete,''N'') = ''N'''
	,N'4. Did you often feel that... no one in your family loved you... is required.'
	,CAST(4 AS DECIMAL(18, 0))
	,N'4. Did you often feel that... no one in your family loved you... is required.'
	)
	,(
	N'Y'
	,@DocumentCodeID
	,NULL
	,N'Adverse Childhood Experience'
	,1
	,N'CustomDocumentAdverseChildhoodExperiences'
	,N'EnoughToEat'
	,N'FROM CustomDocumentAdverseChildhoodExperiences WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(EnoughToEat,'''') = '''' AND ISNULL(RecordDeleted,''N'') = ''N'' AND ISNULL(UnableToComplete,''N'') = ''N'''
	,N'5. Did you often feel that... you didn’t have enough to eat is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'5. Did you often feel that... you didn’t have enough to eat is required.'
	)
	,(
	N'Y'
	,@DocumentCodeID
	,NULL
	,N'Adverse Childhood Experience'
	,1
	,N'CustomDocumentAdverseChildhoodExperiences'
	,N'ParentsSeparated'
	,N'FROM CustomDocumentAdverseChildhoodExperiences WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(ParentsSeparated,'''') = '''' AND ISNULL(RecordDeleted,''N'') = ''N'' AND ISNULL(UnableToComplete,''N'') = ''N'''
	,N'6. Were your parents ever separated or divorced is required.'
	,CAST(6 AS DECIMAL(18, 0))
	,N'6. Were your parents ever separated or divorced is required.'
	)
	,(
	N'Y'
	,@DocumentCodeID
	,NULL
	,N'Adverse Childhood Experience'
	,1
	,N'CustomDocumentAdverseChildhoodExperiences'
	,N'Pushed'
	,N'FROM CustomDocumentAdverseChildhoodExperiences WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Pushed,'''') = '''' AND ISNULL(RecordDeleted,''N'') = ''N'' AND ISNULL(UnableToComplete,''N'') = ''N'''
	,N'7. Was your mother or stepmother often pushed, grabbed, slapped... is required.'
	,CAST(7 AS DECIMAL(18, 0))
	,N'7. Was your mother or stepmother often pushed, grabbed, slapped... is required.'
	)
	,(
	N'Y'
	,@DocumentCodeID
	,NULL
	,N'Adverse Childhood Experience'
	,1
	,N'CustomDocumentAdverseChildhoodExperiences'
	,N'DrinkerProblem'
	,N'FROM CustomDocumentAdverseChildhoodExperiences WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(DrinkerProblem,'''') = '''' AND ISNULL(RecordDeleted,''N'') = ''N'' AND ISNULL(UnableToComplete,''N'') = ''N'''
	,N'8. Did you live with anyone who was a problem drinker or alcohol or who used street drugs is required.'
	,CAST(8 AS DECIMAL(18, 0))
	,N'8. Did you live with anyone who was a problem drinker or alcohol or who used street drugs is required.'
	)
	,(
	N'Y'
	,@DocumentCodeID
	,NULL
	,N'Adverse Childhood Experience'
	,1
	,N'CustomDocumentAdverseChildhoodExperiences'
	,N'Suicide'
	,N'FROM CustomDocumentAdverseChildhoodExperiences WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Suicide,'''') = '''' AND ISNULL(RecordDeleted,''N'') = ''N'' AND ISNULL(UnableToComplete,''N'') = ''N'''
	,N'9. Was a household member depressed or mentally ill or did a household member attempt suicide is required.'
	,CAST(9 AS DECIMAL(18, 0))
	,N'9. Was a household member depressed or mentally ill or did a household member attempt suicide is required.'
	)
	,(
	N'Y'
	,@DocumentCodeID
	,NULL
	,N'Adverse Childhood Experience'
	,1
	,N'CustomDocumentAdverseChildhoodExperiences'
	,N'Prison'
	,N'FROM CustomDocumentAdverseChildhoodExperiences WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Prison,'''') = '''' AND ISNULL(RecordDeleted,''N'') = ''N'' AND ISNULL(UnableToComplete,''N'') = ''N'''
	,N'10. Did a household member go to prison is  required.'
	,CAST(10 AS DECIMAL(18, 0))
	,N'10. Did a household member go to prison is  required.'
	)