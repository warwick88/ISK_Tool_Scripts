----- STEP 1 ----------

------ STEP 2 ----------

--Part1 Begin

--Part1 Ends

--Part2 Begins

--Part2 Ends

-----End of Step 2 -------

------ STEP 3 ------------

-- add new column(s) into CustomSubstanceUseAssessments
IF OBJECT_ID('CustomSubstanceUseAssessments') IS NOT NULL
BEGIN

	IF COL_LENGTH('CustomSubstanceUseAssessments','PreviousMedication')IS  NULL
	BEGIN
		ALTER TABLE CustomSubstanceUseAssessments  ADD PreviousMedication	type_YOrN	NULL
												   CHECK (PreviousMedication in ('Y','N'))
	END

	IF COL_LENGTH('CustomSubstanceUseAssessments','CurrentSubstanceAbuseMedication')IS  NULL
	BEGIN
		ALTER TABLE CustomSubstanceUseAssessments  ADD CurrentSubstanceAbuseMedication	type_YOrN	NULL
												   CHECK (CurrentSubstanceAbuseMedication in ('Y','N'))
	END	
	
	IF COL_LENGTH('CustomSubstanceUseAssessments','MedicationAssistedTreatment')IS  NULL
	BEGIN
		ALTER TABLE CustomSubstanceUseAssessments  ADD MedicationAssistedTreatment	type_YOrNOrNA	NULL
												   CHECK (MedicationAssistedTreatment in ('Y','N','A'))
	END	
	
	IF COL_LENGTH('CustomSubstanceUseAssessments','MedicationAssistedTreatmentRefferedReason')IS  NULL
	BEGIN
		ALTER TABLE CustomSubstanceUseAssessments  ADD MedicationAssistedTreatmentRefferedReason type_Comment2	NULL
	END	
END
Go


------ END OF STEP 3 -----

------ STEP 4 ----------

 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentMHCRAFFTs')
 BEGIN
/* 
 * TABLE: CustomDocumentMHCRAFFTs 
 */
CREATE TABLE CustomDocumentMHCRAFFTs(
	DocumentVersionId							int							NOT NULL,
	CreatedBy								    type_CurrentUser			NOT NULL,
    CreatedDate                                 type_CurrentDatetime		NOT NULL,
    ModifiedBy                                  type_CurrentUser			NOT NULL,
    ModifiedDate                                type_CurrentDatetime		NOT NULL,
    RecordDeleted                               type_YOrN					NULL
												CHECK (RecordDeleted in ('Y','N')),
    DeletedBy                                   type_UserId					NULL,
    DeletedDate                                 datetime					NULL,
    CrafftApplicable							type_YOrN					NULL
												CHECK (CrafftApplicable in ('Y','N')),
	CrafftApplicableReason						type_Comment2				NULL,
	CrafftQuestionC								type_YOrN					NULL
												CHECK (CrafftQuestionC in ('Y','N')),
	CrafftQuestionR								type_YOrN					NULL
												CHECK (CrafftQuestionR in ('Y','N')),
	CrafftQuestionA								type_YOrN					NULL
												CHECK (CrafftQuestionA in ('Y','N')),
	CrafftQuestionF								type_YOrN					NULL
												CHECK (CrafftQuestionF in ('Y','N')),
	CrafftQuestionFR							type_YOrN					NULL
												CHECK (CrafftQuestionFR in ('Y','N')),
	CrafftQuestionT								type_YOrN					NULL
												CHECK (CrafftQuestionT in ('Y','N')),
	CrafftCompleteFullSUAssessment				type_YOrN					NULL
												CHECK (CrafftCompleteFullSUAssessment in ('Y','N')),
	CrafftStageOfChange							type_GlobalCode				NULL,
	CONSTRAINT CustomDocumentMHCRAFFTs_PK PRIMARY KEY CLUSTERED (DocumentVersionId)
)

IF OBJECT_ID('CustomDocumentMHCRAFFTs') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentMHCRAFFTs >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentMHCRAFFTs >>>', 16, 1)

/* 
 * TABLE: CustomDocumentMHCRAFFTs 
 */   
    
ALTER TABLE CustomDocumentMHCRAFFTs ADD CONSTRAINT DocumentVersions_CustomDocumentMHCRAFFTs_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
     
PRINT 'STEP 4(A) COMPLETED'
END
Go

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentPreEmploymentActivities')
BEGIN
/* 
 * TABLE: CustomDocumentPreEmploymentActivities 
 */
 CREATE TABLE CustomDocumentPreEmploymentActivities( 
		DocumentVersionId						int					 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,		
		EducationTraining						char(1)				 NULL
												CHECK (EducationTraining in ('A','B','C','D','E')),	
		EducationTrainingNeeds					type_YOrN			 NULL
												CHECK (EducationTrainingNeeds in ('Y','N')),
		EducationTrainingNeedsComments			type_Comment2		 NULL,
		PersonalCareerPlanning					char(1)				 NULL
												CHECK (PersonalCareerPlanning in ('A','B','C','D','E')),
		PersonalCareerPlanningNeeds				type_YOrN			 NULL
												CHECK (PersonalCareerPlanningNeeds in ('Y','N')),
		PersonalCareerPlanningNeedsComments		type_Comment2		 NULL,
		EmploymentOpportunities					char(1)				 NULL
												CHECK (EmploymentOpportunities in ('A','B','C','D','E')),
		EmploymentOpportunitiesNeeds			type_YOrN			 NULL
												CHECK (EmploymentOpportunitiesNeeds in ('Y','N')),
		EmploymentOpportunitiesNeedsComments	type_Comment2		 NULL,
		SupportedEmployment 					char(1)				 NULL
												CHECK (SupportedEmployment in ('A','B','C','D','E')),
		SupportedEmploymentNeeds 				type_YOrN			 NULL
												CHECK (SupportedEmploymentNeeds in ('Y','N')),
		SupportedEmploymentNeedsComments 		type_Comment2		 NULL,
		WorkHistory								char(1)				 NULL
												CHECK (WorkHistory in ('A','B','C','D','E')),
		WorkHistoryNeeds						type_YOrN			 NULL
												CHECK (WorkHistoryNeeds in ('Y','N')),
		WorkHistoryNeedsComments				type_Comment2		 NULL,
		GainfulEmploymentBenefits 				char(1)				 NULL
												CHECK (GainfulEmploymentBenefits in ('A','B','C','D','E')),
		GainfulEmploymentBenefitsNeeds 			type_YOrN			 NULL
												CHECK (GainfulEmploymentBenefitsNeeds in ('Y','N')),
		GainfulEmploymentBenefitsNeedsComments 	type_Comment2		NULL,
		GainfulEmployment						char(1)				NULL
												CHECK (GainfulEmployment in ('A','B','C','D','E')),
		GainfulEmploymentNeeds 					type_YOrN			NULL
												CHECK (GainfulEmploymentNeeds in ('Y','N')),
		GainfulEmploymentNeedsComments 			type_Comment2		NULL,
	CONSTRAINT CustomDocumentPreEmploymentActivities_PK PRIMARY KEY CLUSTERED (DocumentVersionId) 
 )
 
  IF OBJECT_ID('CustomDocumentPreEmploymentActivities') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentPreEmploymentActivities >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentPreEmploymentActivities >>>', 16, 1)

/* 
 * TABLE: CustomDocumentPreEmploymentActivities 
 */   
    
ALTER TABLE CustomDocumentPreEmploymentActivities ADD CONSTRAINT DocumentVersions_CustomDocumentPreEmploymentActivities_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)

EXEC sys.sp_addextendedproperty 'CustomDocumentPreEmploymentActivities_Description'
,'EducationTraining column stores A,B,C,D,E. A- This is just like me, B- This is mostly like me, C- Somewhat like me, D- Less like me, D- Not at all like me'
,'schema'
,'dbo'
,'table'
,'CustomDocumentPreEmploymentActivities'
,'column'
,'EducationTraining'

EXEC sys.sp_addextendedproperty 'CustomDocumentPreEmploymentActivities_Description'
,'PersonalCareerPlanning column stores A,B,C,D,E. A- This is just like me, B- This is mostly like me, C- Somewhat like me, D- Less like me, D- Not at all like me'
,'schema'
,'dbo'
,'table'
,'CustomDocumentPreEmploymentActivities'
,'column'
,'PersonalCareerPlanning'

EXEC sys.sp_addextendedproperty 'CustomDocumentPreEmploymentActivities_Description'
,'EmploymentOpportunities column stores A,B,C,D,E. A- This is just like me, B- This is mostly like me, C- Somewhat like me, D- Less like me, D- Not at all like me'
,'schema'
,'dbo'
,'table'
,'CustomDocumentPreEmploymentActivities'
,'column'
,'EmploymentOpportunities'

EXEC sys.sp_addextendedproperty 'CustomDocumentPreEmploymentActivities_Description'
,'SupportedEmployment column stores A,B,C,D,E. A- This is just like me, B- This is mostly like me, C- Somewhat like me, D- Less like me, D- Not at all like me'
,'schema'
,'dbo'
,'table'
,'CustomDocumentPreEmploymentActivities'
,'column'
,'SupportedEmployment'

EXEC sys.sp_addextendedproperty 'CustomDocumentPreEmploymentActivities_Description'
,'WorkHistory column stores A,B,C,D,E. A- This is just like me, B- This is mostly like me, C- Somewhat like me, D- Less like me, D- Not at all like me'
,'schema'
,'dbo'
,'table'
,'CustomDocumentPreEmploymentActivities'
,'column'
,'WorkHistory'

EXEC sys.sp_addextendedproperty 'CustomDocumentPreEmploymentActivities_Description'
,'GainfulEmploymentBenefits column stores A,B,C,D,E. A- This is just like me, B- This is mostly like me, C- Somewhat like me, D- Less like me, D- Not at all like me'
,'schema'
,'dbo'
,'table'
,'CustomDocumentPreEmploymentActivities'
,'column'
,'GainfulEmploymentBenefits'

EXEC sys.sp_addextendedproperty 'CustomDocumentPreEmploymentActivities_Description'
,'GainfulEmployment column stores A,B,C,D,E. A- This is just like me, B- This is mostly like me, C- Somewhat like me, D- Less like me, D- Not at all like me'
,'schema'
,'dbo'
,'table'
,'CustomDocumentPreEmploymentActivities'
,'column'
,'GainfulEmployment'

        
     PRINT 'STEP 4(B) COMPLETED'
 END
Go

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentMentalStatusExams')
 BEGIN
/* 
 * TABLE: CustomDocumentMentalStatusExams 
 */

CREATE TABLE CustomDocumentMentalStatusExams(
    DocumentVersionId					int						NOT NULL,
    CreatedBy							type_CurrentUser		NOT NULL,
    CreatedDate							type_CurrentDatetime	NOT NULL,
    ModifiedBy							type_CurrentUser		NOT NULL,
    ModifiedDate						type_CurrentDatetime	NOT NULL,
    RecordDeleted						type_YOrN				NULL
										CHECK (RecordDeleted in	('Y','N')),
    DeletedBy							type_UserId				NULL,
    DeletedDate							datetime				NULL,	
	--GeneralAppearance
	GeneralAppearance					char(1)					NULL
										CHECK (GeneralAppearance in ('A','N','G')) ,
	GeneralPoorlyAddresses				type_YOrN				NULL
										CHECK (GeneralPoorlyAddresses in ('Y','N')),
	GeneralPoorlyGroomed				type_YOrN				NULL
										CHECK (GeneralPoorlyGroomed in ('Y','N')),
	GeneralDisheveled					type_YOrN				NULL
										CHECK (GeneralDisheveled in ('Y','N')),
	GeneralOdferous						type_YOrN				NULL
										CHECK (GeneralOdferous in ('Y','N')),
	GeneralDeformities					type_YOrN				NULL
										CHECK (GeneralDeformities in ('Y','N')),
	GeneralPoorNutrion					type_YOrN				NULL
										CHECK (GeneralPoorNutrion in ('Y','N')),
	GeneralRestless						type_YOrN				NULL
										CHECK (GeneralRestless in ('Y','N')),
	GeneralPsychometer					type_YOrN				NULL
										CHECK (GeneralPsychometer in ('Y','N')),
	GeneralHyperActive					type_YOrN				NULL
										CHECK (GeneralHyperActive in ('Y','N')),
	GeneralEvasive						type_YOrN				NULL
										CHECK (GeneralEvasive in ('Y','N')),
	GeneralInAttentive					type_YOrN				NULL
										CHECK (GeneralInAttentive in ('Y','N')),
	GeneralPoorEyeContact				type_YOrN				NULL
										CHECK (GeneralPoorEyeContact in ('Y','N')),
	GeneralHostile						type_YOrN				NULL
										CHECK (GeneralHostile in ('Y','N')),
	GeneralAppearanceOthers				type_YOrN				NULL
										CHECK (GeneralAppearanceOthers in ('Y','N')),
	GeneralAppearanceOtherComments		type_Comment2			NULL,	
	--Speech
	Speech								char(1)					NULL
										CHECK (Speech in('A','N','W')),
	SpeechIncreased						type_YOrN				NULL
										CHECK (SpeechIncreased in ('Y','N')),
	SpeechDecreased						type_YOrN				NULL
										CHECK (SpeechDecreased in ('Y','N')),
	SpeechPaucity						type_YOrN				NULL
										CHECK (SpeechPaucity in ('Y','N')),
	SpeechHyperverbal					type_YOrN				NULL
										CHECK (SpeechHyperverbal in ('Y','N')),
	SpeechPoorArticulations				type_YOrN				NULL
										CHECK (SpeechPoorArticulations in ('Y','N')),
	SpeechLoud							type_YOrN				NULL
										CHECK (SpeechLoud in ('Y','N')),
	SpeechSoft							type_YOrN				NULL
										CHECK (SpeechSoft in ('Y','N')),
	SpeechMute							type_YOrN				NULL
										CHECK (SpeechMute in ('Y','N')),
	SpeechStuttering					type_YOrN				NULL
										CHECK (SpeechStuttering in ('Y','N')),
	SpeechImpaired						type_YOrN				NULL
										CHECK (SpeechImpaired in ('Y','N')),
	SpeechPressured						type_YOrN				NULL
										CHECK (SpeechPressured in ('Y','N')),
	SpeechFlight						type_YOrN				NULL
										CHECK (SpeechFlight in ('Y','N')),
	--SpeechComment						type_Comment2			NULL,
	SpeechOthers						type_YOrN				NULL
										CHECK (SpeechOthers in ('Y','N')),
	SpeechOtherComments					type_Comment2			NULL,
	--Language		
	PsychiatricNoteExamLanguage			char(1)					NULL
										CHECK (PsychiatricNoteExamLanguage in ('A','N','W')),
	LanguageDifficultyNaming			type_YOrN				NULL
										CHECK (LanguageDifficultyNaming in	('Y','N')),
	LanguageDifficultyRepeating			type_YOrN				NULL
										CHECK (LanguageDifficultyRepeating in	('Y','N')),
	LanguageNonVerbal					type_YOrN				NULL
										CHECK (LanguageNonVerbal in ('Y','N')),										
	LanguageOthers						type_YOrN				NULL
										CHECK (LanguageOthers in ('Y','N')),
	LanguageOtherComments				type_Comment2			NULL,	
	--Mood
	MoodAndAffect						char(1)					NULL
										CHECK (MoodAndAffect in ('A','N','W')),
	MoodHappy							type_YOrN				NULL
										CHECK (MoodHappy in	('Y','N')),
	MoodSad								type_YOrN				NULL
										CHECK (MoodSad in	('Y','N')),
	MoodAnxious							type_YOrN				NULL
										CHECK (MoodAnxious in('Y','N')),
	MoodAngry							type_YOrN				NULL
										CHECK (MoodAngry in	('Y','N')),
	MoodIrritable						type_YOrN				NULL
										CHECK (MoodIrritable in('Y','N')),	
	MoodElation							type_YOrN				NULL
										CHECK (MoodElation in	('Y','N')),
	MoodNormal							type_YOrN				NULL
										CHECK (MoodNormal in	('Y','N')),									
	MoodOthers							type_YOrN				NULL
										CHECK (MoodOthers in ('Y','N')),
	MoodOtherComments					type_Comment2			NULL,	
	--	Affect								
	AffectEuthymic						type_YOrN				NULL
										CHECK (AffectEuthymic in	('Y','N')),
	AffectDysphoric						type_YOrN				NULL
										CHECK (AffectDysphoric in	('Y','N')),
	AffectAnxious						type_YOrN				NULL
										CHECK (AffectAnxious in	('Y','N')),
	AffectIrritable						type_YOrN				NULL
										CHECK (AffectIrritable in	('Y','N')),
	AffectBlunted						type_YOrN				NULL
										CHECK (AffectBlunted in	('Y','N')),	
	AffectLabile						type_YOrN				NULL
										CHECK (AffectLabile in	('Y','N')),
	AffectEuphoric						type_YOrN				NULL
										CHECK (AffectEuphoric in	('Y','N')),
	AffectCongruent						type_YOrN				NULL
										CHECK (AffectCongruent in	('Y','N')),
	AffectOthers						type_YOrN				NULL
										CHECK (AffectOthers in ('Y','N')),
	AffectOtherComments					type_Comment2			NULL,	
	--AttensionSpanAndConcentration
	AttensionSpanAndConcentration		char(1)					NULL
										CHECK (AttensionSpanAndConcentration in ('A','N','W')),
	AttensionPoorConcentration			type_YOrN				NULL
										CHECK (AttensionPoorConcentration in	('Y','N')),
	AttensionPoorAttension				type_YOrN				NULL
										CHECK (AttensionPoorAttension in	('Y','N')),
	AttensionDistractible				type_YOrN				NULL
										CHECK (AttensionDistractible in	('Y','N')),
	AttentionSpanOthers					type_YOrN				NULL
										CHECK (AttentionSpanOthers in ('Y','N')),
	AttentionSpanOtherComments			type_Comment2			NULL,	
	--ThoughtContentCognision
	ThoughtContentCognision				char(1)					NULL
										CHECK (ThoughtContentCognision in ('A','N','W')),
	TPDisOrganised						type_YOrN				NULL
										CHECK (TPDisOrganised in	('Y','N')),
	TPBlocking							type_YOrN				NULL
										CHECK (TPBlocking in	('Y','N')),
	TPPersecution						type_YOrN				NULL
										CHECK (TPPersecution in	('Y','N')),
	TPBroadCasting						type_YOrN				NULL
										CHECK (TPBroadCasting in	('Y','N')),
	TPDetrailed							type_YOrN				NULL
										CHECK (TPDetrailed in	('Y','N')),
	TPThoughtInsertion					type_YOrN				NULL
										CHECK (TPThoughtinsertion in	('Y','N')),
	TPIncoherent						type_YOrN				NULL
										CHECK (TPIncoherent in	('Y','N')),
	TPRacing							type_YOrN				NULL
										CHECK (TPRacing in	('Y','N')),
	TPIllogical							type_YOrN				NULL
										CHECK (TPIllogical in	('Y','N')),
	ThoughtProcessOthers				type_YOrN				NULL
										CHECK (ThoughtProcessOthers in ('Y','N')),
	ThoughtProcessOtherComments			type_Comment2			NULL,			
	--ThoughtContent
	TCDelusional						type_YOrN				NULL
										CHECK (TCDelusional in	('Y','N')),
	TCParanoid							type_YOrN				NULL
										CHECK (TCParanoid in	('Y','N')),
	TCIdeas								type_YOrN				NULL
										CHECK (TCIdeas in	('Y','N')),
	TCThoughtInsertion					type_YOrN				NULL
										CHECK (TCThoughtInsertion in	('Y','N')),
	TCThoughtWithdrawal					type_YOrN				NULL
										CHECK (TCThoughtWithdrawal in	('Y','N')),
	TCThoughtBroadcasting				type_YOrN				NULL
										CHECK (TCThoughtBroadcasting in	('Y','N')),
	TCReligiosity						type_YOrN					NULL
										CHECK (TCReligiosity in	('Y','N')),
	TCGrandiosity						type_YOrN				NULL
										CHECK (TCGrandiosity in	('Y','N')),
	TCPerserveration					type_YOrN				NULL
										CHECK (TCPerserveration in	('Y','N')),
	TCObsessions						type_YOrN				NULL
										CHECK (TCObsessions in	('Y','N')),
	TCWorthlessness						type_YOrN				NULL
										CHECK (TCWorthlessness in	('Y','N')),
	TCLoneliness						type_YOrN				NULL
										CHECK (TCLoneliness in	('Y','N')),
	TCGuilt								type_YOrN				NULL
										CHECK (TCGuilt in	('Y','N')),
	TCHopelessness						type_YOrN				NULL
										CHECK (TCHopelessness in	('Y','N')),
	TCHelplessness						type_YOrN				NULL
										CHECK (TCHelplessness in	('Y','N')),
	ThoughtContentOthers				type_YOrN				NULL
										CHECK (ThoughtContentOthers in ('Y','N')),
	ThoughtContentOtherComments			type_Comment2			NULL,	
	--Cognitive Abnormalities
	CAConcrete							type_YOrN				NULL
										CHECK (CAConcrete in	('Y','N')),
	CAUnable							type_YOrN				NULL
										CHECK (CAUnable in	('Y','N')),
	CAPoorComputation					type_YOrN				NULL
										CHECK (CAPoorComputation in	('Y','N')),
	CognitiveAbnormalitiesOthers		type_YOrN				NULL
										CHECK (CognitiveAbnormalitiesOthers in ('Y','N')),
	CognitiveAbnormalitiesOtherComments	type_Comment2			NULL,	
	--Associations
	Associations						char(1)					NULL
										CHECK (Associations in ('A','N','W')),
	AssociationsLoose					type_YOrN				NULL
										CHECK (AssociationsLoose in	('Y','N')),
	AssociationsClanging				type_YOrN				NULL
										CHECK (AssociationsClanging in	('Y','N')),
	AssociationsWordsalad				type_YOrN				NULL
										CHECK (AssociationsWordsalad in	('Y','N')),
	AssociationsCircumstantial			type_YOrN				NULL
										CHECK (AssociationsCircumstantial in	('Y','N')),
	AssociationsTangential				type_YOrN				NULL
										CHECK (AssociationsTangential in	('Y','N')),
	AssociationsOthers					type_YOrN				NULL
										CHECK (AssociationsOthers in ('Y','N')),
	AssociationsOtherComments			type_Comment2			NULL,	
	--AbnormalorPsychoticThoughts
	AbnormalorPsychoticThoughts			char(1)					NULL
										CHECK (AbnormalorPsychoticThoughts in ('A','N')),
	PsychosisOrDisturbanceOfPerception	char(1)	NULL
										CHECK (PsychosisOrDisturbanceOfPerception in ('N','P')),
	PDAuditoryHallucinations			type_YOrN				NULL
										CHECK (PDAuditoryHallucinations in	('Y','N')),
	PDVisualHallucinations				type_YOrN				NULL
										CHECK (PDVisualHallucinations in	('Y','N')),
	PDCommandHallucinations				type_YOrN				NULL
										CHECK (PDCommandHallucinations in	('Y','N')),
	PDDelusions							type_YOrN				NULL
										CHECK (PDDelusions in	('Y','N')),
	PDPreoccupation						type_YOrN				NULL
										CHECK (PDPreoccupation in	('Y','N')),
	PDOlfactoryHallucinations			type_YOrN				NULL
										CHECK (PDOlfactoryHallucinations in	('Y','N')),
	PDGustatoryHallucinations			type_YOrN				NULL
										CHECK (PDGustatoryHallucinations in	('Y','N')),
	PDTactileHallucinations				type_YOrN				NULL
										CHECK (PDTactileHallucinations in	('Y','N')),
	PDSomaticHallucinations				type_YOrN				NULL
										CHECK (PDSomaticHallucinations in	('Y','N')),
	PDIllusions							type_YOrN				NULL
										CHECK (PDIllusions in	('Y','N')),
	AbnormalPsychoticOthers				type_YOrN				NULL
										CHECK (AbnormalPsychoticOthers in ('Y','N')),
	AbnormalPsychoticOthersComments		type_Comment2			NULL,											
	--								
	PDCurrentSuicideIdeation			type_YOrN				NULL
										CHECK (PDCurrentSuicideIdeation in	('Y','N')),
	PDCurrentSuicidalPlan				type_YOrN				NULL
										CHECK (PDCurrentSuicidalPlan in	('Y','N')),
	PDCurrentSuicidalIntent				type_YOrN				NULL
										CHECK (PDCurrentSuicidalIntent in	('Y','N')),
	PDMeansToCarry						type_YOrN				NULL
										CHECK (PDMeansToCarry in	('Y','N')),
	PDCurrentHomicidalIdeation			type_YOrN				NULL
										CHECK (PDCurrentHomicidalIdeation in	('Y','N')),
	PDCurrentHomicidalPlans				type_YOrN				NULL
										CHECK (PDCurrentHomicidalPlans in	('Y','N')),
	PDCurrentHomicidalIntent			type_YOrN				NULL
										CHECK (PDCurrentHomicidalIntent in	('Y','N')),
	PDMeansToCarryNew					type_YOrN				NULL
										CHECK (PDMeansToCarryNew in	('Y','N')),
	--Orientation
	Orientation							char(1)					NULL
										CHECK (Orientation in ('A','N','W')),
	OrientationPerson					type_YOrN				NULL
										CHECK (OrientationPerson in	('Y','N')),				
	OrientationPlace					type_YOrN				NULL
										CHECK (OrientationPlace in	('Y','N')),
	OrientationTime						type_YOrN				NULL
										CHECK (OrientationTime in	('Y','N')),
	OrientationSituation				type_YOrN				NULL
										CHECK (OrientationSituation in	('Y','N')),
	OrientationOthers					type_YOrN				NULL
										CHECK (OrientationOthers in ('Y','N')),
	OrientationOtherComments			type_Comment2			NULL,	
	OrientationDescribeSituation		varchar(250)			NULL,
	OrientationFullName					varchar(100)			NULL,
	OrientationEvidencedPlace			varchar(150)			NULL,
	OrientationFullDate					varchar(50)				NULL,
	--FundOfKnowledge
	FundOfKnowledge						char(1)					NULL
										CHECK (FundOfKnowledge in ('A','N','W')),
	FundOfKnowledgeCurrentEvents		type_YOrN				NULL
										CHECK (FundOfKnowledgeCurrentEvents in	('Y','N')),
	FundOfKnowledgePastHistory			type_YOrN				NULL
										CHECK (FundOfKnowledgePastHistory in	('Y','N')),
	FundOfKnowledgeVocabulary			type_YOrN				NULL
										CHECK (FundOfKnowledgeVocabulary in	('Y','N')),
	FundOfKnowledgeOthers				type_YOrN				NULL
										CHECK (FundOfKnowledgeOthers in ('Y','N')),
	FundOfKnowledgeOtherComments		type_Comment2			NULL,	
	--FundOfEvidence
	FundEvidenceVocabulary				type_YOrN				NULL
										CHECK (FundEvidenceVocabulary in ('Y','N')),
	FundEvidenceKnowledge				type_YOrN				NULL
										CHECK (FundEvidenceKnowledge in ('Y','N')),
	FundEvidenceResponses				type_YOrN				NULL
										CHECK (FundEvidenceResponses in ('Y','N')),
	FundEvidenceSchool					type_YOrN				NULL
										CHECK (FundEvidenceSchool in ('Y','N')),
	FundEvidenceIQ						type_YOrN				NULL
										CHECK (FundEvidenceIQ in ('Y','N')),
	FundEvidenceOthers					type_YOrN				NULL
										CHECK (FundEvidenceOthers in ('Y','N')),
	FundEvidenceOtherComments			type_Comment2			NULL,
	--InsightAndJudgement
	InsightAndJudgement					char(1)					NULL
										CHECK (InsightAndJudgement in ('A','N')),
	InsightAndJudgementStatus			char(1)					NULL
										CHECK (InsightAndJudgementStatus in ('E','G','F','P','R')),
	InsightAndJudgementSubstance		type_YOrN				NULL
										CHECK (InsightAndJudgementSubstance in	('Y','N')),
	InsightAndJudgementOthers			type_YOrN				NULL
										CHECK (InsightAndJudgementOthers in ('Y','N')),
	InsightAndJudgementOtherComments	type_Comment2			NULL,	
	--InsightAndJudgementEvidence	
	InsightEvidenceAwareness			type_YOrN				NULL
										CHECK (InsightEvidenceAwareness in ('Y','N')),
	InsightEvidenceAcceptance			type_YOrN				NULL
										CHECK (InsightEvidenceAcceptance in ('Y','N')),
	InsightEvidenceUnderstanding		type_YOrN				NULL
										CHECK (InsightEvidenceUnderstanding in ('Y','N')),
	InsightEvidenceSelfDefeating		type_YOrN				NULL
										CHECK (InsightEvidenceSelfDefeating in ('Y','N')),
	InsightEvidenceDenial				type_YOrN				NULL
										CHECK (InsightEvidenceDenial in ('Y','N')),
	InsightEvidenceOthers				type_YOrN				NULL
										CHECK (InsightEvidenceOthers in ('Y','N')),
	InsightEvidenceOtherComments		type_Comment2			NULL,
	--Memory
	Memory								char(1)					NULL
										CHECK (Memory in ('A','N','W')),
	MemoryImmediate					    char(1)				NULL
										CHECK (MemoryImmediate in ('G','F','I')),
	MemoryRecent						char(1)					NULL
										CHECK (MemoryRecent in ('G','F','I')),
	MemoryRemote						char(1)					NULL
										CHECK (MemoryRemote in ('G','F','I')),
	MemoryOthers						type_YOrN				NULL
										CHECK (MemoryOthers in ('Y','N')),
	MemoryOtherComments					type_Comment2			NULL,
	MemoryImmediateEvidencedBy			int						NULL,
	MemoryRecentEvidencedBy				varchar(100)			NULL,
	MemoryRemoteEvidencedBy				varchar(100)			NULL,
											
	--MuscleStrengthorTone
	MuscleStrengthorTone				char(1)					NULL
										CHECK (MuscleStrengthorTone in ('A','N','W')),
	MuscleStrengthorToneAtrophy			type_YOrN				NULL
										CHECK (MuscleStrengthorToneAtrophy in	('Y','N')),
	MuscleStrengthorToneAbnormal		type_YOrN				NULL
										CHECK (MuscleStrengthorToneAbnormal in	('Y','N')),
	MuscleStrengthOthers				type_YOrN				NULL
										CHECK (MuscleStrengthOthers in ('Y','N')),
	MuscleStrengthOtherComments			type_Comment2			NULL,	

	--GaitandStation
	GaitandStation						char(1)					NULL
										CHECK (GaitandStation in ('A','N','W')),
	GaitandStationRestlessness			type_YOrN				NULL
										CHECK (GaitandStationRestlessness in	('Y','N')),
	GaitandStationStaggered				type_YOrN				NULL
										CHECK (GaitandStationStaggered in	('Y','N')),
	GaitandStationShuffling				type_YOrN				NULL
										CHECK (GaitandStationShuffling in	('Y','N')),
	GaitandStationUnstable				type_YOrN				NULL
										CHECK (GaitandStationUnstable in	('Y','N')),
	GaitAndStationOthers				type_YOrN				NULL
										CHECK (GaitAndStationOthers in ('Y','N')),
	GaitAndStationOtherComments			type_Comment2			NULL,
	MentalStatusComments				type_Comment2			NULL,	
	ReviewWithChanges					char(1)					NULL
										CHECK (ReviewWithChanges in('C','N','A')),
										
    CONSTRAINT CustomDocumentMentalStatusExams_PK PRIMARY KEY CLUSTERED (DocumentVersionId)		 	
)
 IF OBJECT_ID('CustomDocumentMentalStatusExams') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentMentalStatusExams >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentMentalStatusExams >>>', 16, 1)
    
    EXEC sys.sp_addextendedproperty 'CustomDocumentMentalStatusExams_Description'
		,'ReviewWithChanges column stores C,N,A .C-Review with changes, N-Review with no changes, A-N/A'
		,'schema'
		,'dbo'
		,'table'
		,'CustomDocumentMentalStatusExams'
		,'column'
		,'ReviewWithChanges' 
		
	EXEC sys.sp_addextendedproperty 'CustomDocumentMentalStatusExams_Description'
	,'Speech column stores A,N,W. A- Assessed , N- Not Assessed, W-WNL – non-pressured, with normal rate, tone, latency'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentMentalStatusExams'
	,'column'
	,'Speech'
		
	EXEC sys.sp_addextendedproperty 'CustomDocumentMentalStatusExams_Description'
	,'GeneralAppearance column stores A,N,G. A- Assessed , N- Not Assessed, G-Appropriately dressed and groomed for the occasion'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentMentalStatusExams'
	,'column'
	,'GeneralAppearance' 
		
	EXEC sys.sp_addextendedproperty 'CustomDocumentMentalStatusExams_Description'
	,'PsychiatricNoteExamLanguage column stores A,N,W. A- Assessed , N- Not Assessed, W-WNL – non-pressured, with normal rate, tone, latency'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentMentalStatusExams'
	,'column'
	,'PsychiatricNoteExamLanguage' 
	
	EXEC sys.sp_addextendedproperty 'CustomDocumentMentalStatusExams_Description'
	,'MoodAndAffect column stores A,N,W. A- Assessed , N- Not Assessed, W-WNL – mood and affect euthymic and congruent'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentMentalStatusExams'
	,'column'
	,'MoodAndAffect' 				
										
	EXEC sys.sp_addextendedproperty 'CustomDocumentMentalStatusExams_Description'
	,'AttensionSpanAndConcentration column stores A,N,W. A- Assessed , N- Not Assessed, W-WNL – with good concentration and attention span'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentMentalStatusExams'
	,'column'
	,'AttensionSpanAndConcentration' 	
	
	EXEC sys.sp_addextendedproperty 'CustomDocumentMentalStatusExams_Description'
	,'ThoughtContentCognision column stores A,N,W. A- Assessed , N- Not Assessed, W-coherent and goal directed with no evidence of abnormal or delusional thought content or cognitive disturbance; good fund of knowledge'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentMentalStatusExams'
	,'column'
	,'ThoughtContentCognision' 	
	
	 EXEC sys.sp_addextendedproperty 'CustomDocumentMentalStatusExams_Description'
	,'Associations column stores A,N,W. A- Assessed , N- Not Assessed, W-WNL - Intact'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentMentalStatusExams'
	,'column'
	,'Associations' 
	
	EXEC sys.sp_addextendedproperty 'CustomDocumentMentalStatusExams_Description'
	,'AbnormalorPsychoticThoughts column stores A,N. A- Assessed , N- Not Assessed'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentMentalStatusExams'
	,'column'
	,'AbnormalorPsychoticThoughts' 
	
	EXEC sys.sp_addextendedproperty 'CustomDocumentMentalStatusExams_Description'
	,'PsychosisOrDisturbanceOfPerception column stores P,N. P- Present (leave items below unchecked if not present) , N- None'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentMentalStatusExams'
	,'column'
	,'PsychosisOrDisturbanceOfPerception' 
	
	EXEC sys.sp_addextendedproperty 'CustomDocumentMentalStatusExams_Description'
	,'Orientation column stores A,N,W. A- Assessed , N- Not Assessed, W-WNL – Oriented to person, place, time, situation'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentMentalStatusExams'
	,'column'
	,'Orientation' 
	
	 EXEC sys.sp_addextendedproperty 'CustomDocumentMentalStatusExams_Description'
	,'FundOfKnowledge column stores A,N,W. A- Assessed , N- Not Assessed, W-Fund of knowledge WNL for developmental level'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentMentalStatusExams'
	,'column'
	,'FundOfKnowledge' 
	
	EXEC sys.sp_addextendedproperty 'CustomDocumentMentalStatusExams_Description'
	,'InsightAndJudgement column stores A,N,W. A- Assessed , N- Not Assessed'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentMentalStatusExams'
	,'column'
	,'InsightAndJudgement'  
	
	 EXEC sys.sp_addextendedproperty 'CustomDocumentMentalStatusExams_Description'
	,'InsightAndJudgementStatus column stores E,G,F,P,R. E- Excellent , G- Good, F-Fair,P-Poor,G-Grossly Impaired'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentMentalStatusExams'
	,'column'
	,'InsightAndJudgementStatus'  
	
	 EXEC sys.sp_addextendedproperty 'CustomDocumentMentalStatusExams_Description'
	,'Memory column stores A,N,W. A- Assessed , N- Not Assessed, W-WNL – Immediate, recent, and remote memory intact'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentMentalStatusExams'
	,'column'
	,'Memory' 
	
	EXEC sys.sp_addextendedproperty 'CustomDocumentMentalStatusExams_Description'
	,'MemoryImmediate column stores G,F,I. G- Good, F- Fair , I- Impaired'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentMentalStatusExams'
	,'column'
	,'MemoryImmediate'
	
	EXEC sys.sp_addextendedproperty 'CustomDocumentMentalStatusExams_Description'
	,'MemoryRecent column stores G,F,I. G- Good, F- Fair , I- Impaired'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentMentalStatusExams'
	,'column'
	,'MemoryRecent'
	
	EXEC sys.sp_addextendedproperty 'CustomDocumentMentalStatusExams_Description'
	,'MemoryRemote column stores G,F,I. G- Good, F- Fair , I- Impaired'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentMentalStatusExams'
	,'column'
	,'MemoryRemote' 
	
	EXEC sys.sp_addextendedproperty 'CustomDocumentMentalStatusExams_Description'
	,'MuscleStrengthorTone column stores A,N,W. A- Assessed , N- Not Assessed, W-WNL'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentMentalStatusExams'
	,'column'
	,'MuscleStrengthorTone' 
	
	EXEC sys.sp_addextendedproperty 'CustomDocumentMentalStatusExams_Description'
	,'GaitandStation column stores A,N,W. A- Assessed , N- Not Assessed, W-WNL'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentMentalStatusExams'
	,'column'
	,'GaitandStation' 

/*  
 * TABLE: CustomDocumentMentalStatusExams 
 */ 

 ALTER TABLE CustomDocumentMentalStatusExams ADD CONSTRAINT DocumentVersions_CustomDocumentMentalStatusExams_FK 
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
    
PRINT 'STEP 4(C) COMPLETED'
END
GO


IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentAssessmentSubstanceUses')
BEGIN
/* 
 * TABLE: CustomDocumentAssessmentSubstanceUses 
 */
 CREATE TABLE CustomDocumentAssessmentSubstanceUses( 
		DocumentVersionId						int					 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,		
		UseOfAlcohol							Char(1)				 NULL
												CHECK (UseOfAlcohol in ('N','R','M','D')),	
		AlcoholAddToNeedsList					type_YOrN			 NULL
												CHECK (AlcoholAddToNeedsList in ('Y','N')),
		UseOfTobaccoNicotine					Char(1)				 NULL
												CHECK (UseOfTobaccoNicotine in ('N','P','T')),		  
		UseOfTobaccoNicotineQuit				Datetime			 NULL,
		UseOfTobaccoNicotineTypeOfFrequency		Varchar(100)		 NULL,
		UseOfTobaccoNicotineAddToNeedsList		type_YOrN			 NULL
												CHECK (UseOfTobaccoNicotineAddToNeedsList in ('Y','N')),
		UseOfIllicitDrugs						type_YOrN			 NULL
												CHECK (UseOfIllicitDrugs in ('Y','N')),
		UseOfIllicitDrugsTypeFrequency			Varchar(100)		 NULL,
		UseOfIllicitDrugsAddToNeedsList			type_YOrN			 NULL
												CHECK (UseOfIllicitDrugsAddToNeedsList in ('Y','N')),
		PrescriptionOTCDrugs					type_YOrN			 NULL
												CHECK (PrescriptionOTCDrugs in ('Y','N')),
		PrescriptionOTCDrugsTypeFrequency		Varchar(100)		 NULL,
		PrescriptionOTCDrugsAddtoNeedsList		type_YOrN			 NULL
												CHECK (PrescriptionOTCDrugsAddtoNeedsList in ('Y','N')),
		DrinksPerWeek							int					 NULL,
		LastTimeDrinkDate						datetime			 NULL,
		LastTimeDrinks							char(1)				 NULL
												CHECK (LastTimeDrinks in ('N','U')),
		IllegalDrugs							type_YesNoUnknown	 NULL
												CHECK (IllegalDrugs in ('Y','N')),
		BriefCounseling							type_YOrN             NULL
												CHECK (BriefCounseling in ('Y','N')),
		FeedBackOnAlcoholUse					type_YOrN             NULL
												CHECK (FeedBackOnAlcoholUse in ('Y','N')),
		Harms									type_YOrN             NULL
												CHECK (Harms in ('Y','N')),
		DevelopmentOfPlans						type_YOrN             NULL
												CHECK (DevelopmentOfPlans in ('Y','N')),
		Refferal								type_YOrN             NULL
												CHECK (Refferal in ('Y','N')),
		DDOneTimeOnly							type_YOrN             NULL
												CHECK (DDOneTimeOnly in ('Y','N')),
		NotApplicable							type_YOrN             NULL
												CHECK (NotApplicable in ('Y','N')),
	CONSTRAINT CustomDocumentAssessmentSubstanceUses_PK PRIMARY KEY CLUSTERED (DocumentVersionId) 
 )
 
  IF OBJECT_ID('CustomDocumentAssessmentSubstanceUses') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentAssessmentSubstanceUses >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentAssessmentSubstanceUses >>>', 16, 1)
/* 
 * TABLE: CustomDocumentAssessmentSubstanceUses 
 */   

    
ALTER TABLE CustomDocumentAssessmentSubstanceUses ADD CONSTRAINT DocumentVersions_CustomDocumentAssessmentSubstanceUses_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
        
     PRINT 'STEP 4(D) COMPLETED'
 END
Go




IF Not EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomMHAssessmentSupports')
 BEGIN
/* 
 * TABLE: CustomMHAssessmentSupports 
 */
CREATE TABLE CustomMHAssessmentSupports(
	MHAssessmentSupportId						int IDENTITY(1,1)			NOT NULL,
	CreatedBy								    type_CurrentUser			NOT NULL,
    CreatedDate                                 type_CurrentDatetime		NOT NULL,
    ModifiedBy                                  type_CurrentUser			NOT NULL,
    ModifiedDate                                type_CurrentDatetime		NOT NULL,
    RecordDeleted                               type_YOrN					NULL
												CHECK (RecordDeleted in ('Y','N')),
    DeletedBy                                   type_UserId					NULL,
    DeletedDate                                 datetime					NULL,
    DocumentVersionId							int							NOT NULL,
    SupportDescription							type_Comment2				NULL,
	[Current]									type_YOrN					NULL
												CHECK ([Current] in ('Y','N')),
	PaidSupport									type_YOrN					NULL
												CHECK (PaidSupport in ('Y','N')),
	UnpaidSupport								type_YOrN					NULL
												CHECK (UnpaidSupport in ('Y','N')),
	ClinicallyRecommended						type_YOrN					NULL
												CHECK (ClinicallyRecommended in ('Y','N')),
	CustomerDesired								type_YOrN					NULL
												CHECK (CustomerDesired in ('Y','N')),
	CONSTRAINT CustomMHAssessmentSupports_PK PRIMARY KEY CLUSTERED (MHAssessmentSupportId)
)

IF OBJECT_ID('CustomMHAssessmentSupports') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomMHAssessmentSupports >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomMHAssessmentSupports >>>', 16, 1)

/* 
 * TABLE: CustomMHAssessmentSupports 
 */   

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CustomMHAssessmentSupports]') AND name = N'XIE1_CustomMHAssessmentSupports')
  BEGIN
   CREATE NONCLUSTERED INDEX [XIE1_CustomMHAssessmentSupports] ON [dbo].[CustomMHAssessmentSupports] 
   (
   [DocumentVersionId]  ASC
   )
   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomMHAssessmentSupports') AND name='XIE1_CustomMHAssessmentSupports')
   PRINT '<<< CREATED INDEX CustomMHAssessmentSupports.XIE1_CustomMHAssessmentSupports >>>'
   ELSE
   RAISERROR('<<< FAILED CREATING INDEX CustomMHAssessmentSupports.XIE1_CustomMHAssessmentSupports >>>', 16, 1)  
  END      

/* 
 * TABLE: CustomMHAssessmentSupports 
 */  
     
ALTER TABLE CustomMHAssessmentSupports ADD CONSTRAINT DocumentVersions_CustomMHAssessmentSupports_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
     
PRINT 'STEP 4(E) COMPLETED'
 END
GO



IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentMHAssessments')
 BEGIN
/* 
 * TABLE: CustomDocumentMHAssessments 
 */

CREATE TABLE CustomDocumentMHAssessments (
	DocumentVersionId							int				        NOT NULL,
    CreatedBy									type_CurrentUser		NOT NULL,
    CreatedDate									type_CurrentDatetime	NOT NULL,
    ModifiedBy									type_CurrentUser		NOT NULL,
    ModifiedDate								type_CurrentDatetime	NOT NULL,
    RecordDeleted								type_YOrN				NULL
												CHECK (RecordDeleted in	('Y','N')),
    DeletedBy									type_UserId	            NULL,
    DeletedDate									datetime                NULL,
    LOCId										int						NULL,
	ClientName									varchar(150)			NULL,
	AssessmentType								char(1)					NULL
												CHECK (AssessmentType in('S','A','U','I')),	
	PreviousAssessmentDate						datetime				NULL,
	ClientDOB									datetime				NULL,
	AdultOrChild								char(1)					NULL,
	ChildHasNoParentalConsent					type_YOrN				NULL
												CHECK (ChildHasNoParentalConsent in	('Y','N')),	
	ClientHasGuardian							type_YOrN				NULL
												CHECK (ClientHasGuardian in	('Y','N')),	
	GuardianAddress								type_Address			NULL,
	GuardianPhone								type_PhoneNumber		NULL,
	ClientInDDPopulation						type_YOrN				NULL
												CHECK (ClientInDDPopulation in	('Y','N')),	
	ClientInSAPopulation						type_YOrN				NULL
												CHECK (ClientInSAPopulation in	('Y','N')),	
	ClientInMHPopulation						type_YOrN				NULL
												CHECK (ClientInMHPopulation in	('Y','N')),	
	PreviousDiagnosisText						type_Comment2			NULL,
	ReferralType								type_GlobalCode			NULL,
	PresentingProblem							type_Comment2			NULL,
	CurrentLivingArrangement					type_GlobalCode			NULL,
	CurrentPrimaryCarePhysician					varchar(50)				NULL,
	ReasonForUpdate								type_Comment2			NULL,
	DesiredOutcomes								type_Comment2			NULL,
	PsMedicationsComment						type_Comment2			NULL,
	PsEducationComment							type_Comment2			NULL,
	IncludeFunctionalAssessment					type_YOrN				NULL
												CHECK (IncludeFunctionalAssessment in ('Y','N')),	
	IncludeSymptomChecklist						type_YOrN				NULL
												CHECK (IncludeSymptomChecklist in	('Y','N')),	
	IncludeUNCOPE								type_YOrN				NULL
												CHECK (IncludeUNCOPE in	('Y','N')),	
	ClientIsAppropriateForTreatment				type_YOrN				NULL
												CHECK (ClientIsAppropriateForTreatment in('Y','N')),	
	SecondOpinionNoticeProvided					type_YOrN				NULL
												CHECK (SecondOpinionNoticeProvided in('Y','N')),	
	TreatmentNarrative							type_Comment2			NULL,
	RapCiDomainIntensity						varchar(50)				NULL,
	RapCiDomainComment							type_Comment2			NULL,
	RapCiDomainNeedsList						type_YOrN				NULL
												CHECK (RapCiDomainNeedsList in	('Y','N')),	
	RapCbDomainIntensity						varchar(50)				NULL,
	RapCbDomainComment							type_Comment2			NULL,
	RapCbDomainNeedsList						type_YOrN				NULL
												CHECK (RapCbDomainNeedsList in	('Y','N')),	
	RapCaDomainIntensity						varchar(50)				NULL,
	RapCaDomainComment							type_Comment2			NULL,
	RapCaDomainNeedsList						type_YOrN				NULL
												CHECK (RapCaDomainNeedsList in	('Y','N')),	
	RapHhcDomainIntensity						varchar(50)				NULL,
	OutsideReferralsGiven						type_YOrN				NULL
												CHECK (OutsideReferralsGiven in	('Y','N')),	
	ReferralsNarrative							type_Comment2			NULL,
	ServiceOther								type_YOrN				NULL
												CHECK (ServiceOther in	('Y','N')),	
	ServiceOtherDescription						varchar(100)			NULL,
	AssessmentAddtionalInformation				type_Comment2			NULL,
	TreatmentAccomodation						type_Comment2			NULL,
	Participants								type_Comment2			NULL,
	Facilitator									type_Comment2			NULL,
	TimeLocation								type_Comment2			NULL,
	AssessmentsNeeded							type_Comment2			NULL,
	CommunicationAccomodations					type_Comment2			NULL,
	IssuesToAvoid								type_Comment2			NULL,
	IssuesToDiscuss								type_Comment2			NULL,
	SourceOfPrePlanningInfo						type_Comment2			NULL,
	SelfDeterminationDesired					type_YOrNOrNA			NULL
												CHECK (SelfDeterminationDesired in('Y','N','A')),	
	FiscalIntermediaryDesired					type_YOrNOrNA			NULL
												CHECK (FiscalIntermediaryDesired in	('Y','N','A')),	
	PamphletGiven								type_YOrN				NULL
												CHECK (PamphletGiven in	('Y','N')),	
	PamphletDiscussed							type_YOrN				NULL
												CHECK (PamphletDiscussed in	('Y','N')),	
	PrePlanIndependentFacilitatorDiscussed		type_YOrN				NULL
												CHECK (PrePlanIndependentFacilitatorDiscussed in('Y','N')),	
	PrePlanIndependentFacilitatorDesired		type_YOrN				NULL
												CHECK (PrePlanIndependentFacilitatorDesired in('Y','N')),	
	PrePlanGuardianContacted					type_YOrN				NULL
												CHECK (PrePlanGuardianContacted in	('Y','N')),	
	PrePlanSeparateDocument						type_YOrN				NULL
												CHECK (PrePlanSeparateDocument in	('Y','N')),	
	CommunityActivitiesCurrentDesired			type_Comment2			NULL,
	CommunityActivitiesIncreaseDesired			type_YOrN				NULL
												CHECK (CommunityActivitiesIncreaseDesired in('Y','N')),	
	CommunityActivitiesNeedsList				type_YOrN				NULL
												CHECK (CommunityActivitiesNeedsList in	('Y','N')),	
	PsCurrentHealthIssues						type_YesNoUnknown		NULL
												CHECK (PsCurrentHealthIssues in ('Y','N','U')),
	PsCurrentHealthIssuesComment				type_Comment2			NULL,
	PsCurrentHealthIssuesNeedsList				type_YOrN				NULL
												CHECK (PsCurrentHealthIssuesNeedsList in('Y','N')),	
	HistMentalHealthTx							type_YesNoUnknown		NULL
												CHECK (HistMentalHealthTx in ('Y','N','U')),
	HistMentalHealthTxNeedsList					type_YOrN				NULL
												CHECK (HistMentalHealthTxNeedsList in('Y','N')),	
	HistMentalHealthTxComment					type_Comment2			NULL,
	HistFamilyMentalHealthTx					type_YesNoUnknown		NULL
												CHECK (HistFamilyMentalHealthTx in ('Y','N','U')),
	HistFamilyMentalHealthTxNeedsList			type_YOrN				NULL
												CHECK (HistFamilyMentalHealthTxNeedsList in	('Y','N')),	
	HistFamilyMentalHealthTxComment				type_Comment2			NULL,
	PsClientAbuseIssues							type_YesNoUnknown		NULL
												CHECK (PsClientAbuseIssues in ('Y','N','U')),
	PsClientAbuesIssuesComment					type_Comment2			NULL,
	PsClientAbuseIssuesNeedsList				type_YOrN				NULL
												CHECK (PsClientAbuseIssuesNeedsList in('Y','N')),	
	PsFamilyConcernsComment						type_Comment2			NULL,
	PsRiskLossOfPlacement						type_YOrN				NULL
												CHECK (PsRiskLossOfPlacement in	('Y','N')),	
	PsRiskLossOfPlacementDueTo					type_GlobalCode			NULL,
	PsRiskSensoryMotorFunction					type_YOrN				NULL
												CHECK (PsRiskSensoryMotorFunction in	('Y','N')),	
	PsRiskSensoryMotorFunctionDueTo				type_GlobalCode			NULL,
	PsRiskSafety								type_YOrN				NULL
												CHECK (PsRiskSafety in	('Y','N')),	
	PsRiskSafetyDueTo							type_GlobalCode			NULL,
	PsRiskLossOfSupport							type_YOrN				NULL
												CHECK (PsRiskLossOfSupport in	('Y','N')),	
	PsRiskLossOfSupportDueTo					type_GlobalCode			NULL,
	PsRiskExpulsionFromSchool					type_YOrN				NULL
												CHECK (PsRiskExpulsionFromSchool in	('Y','N')),	
	PsRiskExpulsionFromSchoolDueTo				type_GlobalCode			NULL,
	PsRiskHospitalization						type_YOrN				NULL
												CHECK (PsRiskHospitalization in	('Y','N')),	
	PsRiskHospitalizationDueTo					type_GlobalCode			NULL,
	PsRiskCriminalJusticeSystem					type_YOrN				NULL
												CHECK (PsRiskCriminalJusticeSystem in	('Y','N')),	
	PsRiskCriminalJusticeSystemDueTo			type_GlobalCode			NULL,
	PsRiskElopementFromHome						type_YOrN				NULL
												CHECK (PsRiskElopementFromHome in	('Y','N')),	
	PsRiskElopementFromHomeDueTo				type_GlobalCode			NULL,
	PsRiskLossOfFinancialStatus					type_YOrN				NULL
												CHECK (PsRiskLossOfFinancialStatus in	('Y','N')),	
	PsRiskLossOfFinancialStatusDueTo			type_GlobalCode			NULL,
	PsDevelopmentalMilestones					type_YesNoUnknown		NULL
												CHECK (PsDevelopmentalMilestones in ('Y','N','U')),
	PsDevelopmentalMilestonesComment			type_Comment2			NULL,
	PsDevelopmentalMilestonesNeedsList			type_YOrN				NULL
												CHECK (PsDevelopmentalMilestonesNeedsList in	('Y','N')),	
	PsChildEnvironmentalFactors					type_YesNoUnknown		NULL
												CHECK (PsChildEnvironmentalFactors in ('Y','N','U')),
	PsChildEnvironmentalFactorsComment			type_Comment2			NULL,
	PsChildEnvironmentalFactorsNeedsList		type_YOrN				NULL
												CHECK (PsChildEnvironmentalFactorsNeedsList in	('Y','N')),	
	PsLanguageFunctioning						type_YesNoUnknown		NULL
												CHECK (PsLanguageFunctioning in ('Y','N','U')),
	PsLanguageFunctioningComment				type_Comment2			NULL,
	PsLanguageFunctioningNeedsList				type_YOrN				NULL
												CHECK (PsLanguageFunctioningNeedsList in('Y','N')),	
	PsVisualFunctioning							type_YesNoUnknown		NULL
												CHECK (PsVisualFunctioning in ('Y','N','U')),
	PsVisualFunctioningComment					type_Comment2			NULL,
	PsVisualFunctioningNeedsList				type_YOrN				NULL
												CHECK (PsVisualFunctioningNeedsList in('Y','N')),	
	PsPrenatalExposure							type_YesNoUnknown		NULL
												CHECK (PsPrenatalExposure in ('Y','N','U')),
	PsPrenatalExposureComment					type_Comment2			NULL,
	PsPrenatalExposureNeedsList					type_YOrN				NULL
												CHECK (PsPrenatalExposureNeedsList in	('Y','N')),	
	PsChildMentalHealthHistory					type_YesNoUnknown		NULL
												CHECK (PsChildMentalHealthHistory in ('Y','N','U')),
	PsChildMentalHealthHistoryComment			type_Comment2			NULL,
	PsChildMentalHealthHistoryNeedsList			type_YOrN				NULL
												CHECK (PsChildMentalHealthHistoryNeedsList in	('Y','N')),	
	PsIntellectualFunctioning					type_YesNoUnknown		NULL,
	PsIntellectualFunctioningComment			type_Comment2			NULL,
	PsIntellectualFunctioningNeedsList			type_YOrN				NULL
												CHECK (PsIntellectualFunctioningNeedsList in	('Y','N')),	
	PsLearningAbility							type_YesNoUnknown		NULL
												CHECK (PsLearningAbility in ('Y','N','U')),
	PsLearningAbilityComment					type_Comment2			NULL,
	PsLearningAbilityNeedsList					type_YOrN				NULL
												CHECK (PsLearningAbilityNeedsList in ('Y','N')),	
	PsFunctioningConcernComment					type_Comment2			NULL,
	PsPeerInteraction							type_YesNoUnknown		NULL
												CHECK (PsPeerInteraction in ('Y','N','U')),
	PsPeerInteractionComment					type_Comment2			NULL,
	PsPeerInteractionNeedsList					type_YOrN				NULL
												CHECK (PsPeerInteractionNeedsList in('Y','N')),	
	PsParentalParticipation						type_YesNoUnknown		NULL
												CHECK (PsParentalParticipation in ('Y','N','U')),
	PsParentalParticipationComment				type_Comment2			NULL,
	PsParentalParticipationNeedsList			type_YOrN				NULL
												CHECK (PsParentalParticipationNeedsList in('Y','N')),	
	PsSchoolHistory								type_YesNoUnknown		NULL
												CHECK (PsSchoolHistory in ('Y','N','U')),
	PsSchoolHistoryComment						type_Comment2			NULL,
	PsSchoolHistoryNeedsList					type_YOrN				NULL
												CHECK (PsSchoolHistoryNeedsList in	('Y','N')),	
	PsImmunizations								type_YesNoUnknown		NULL
												CHECK (PsImmunizations in ('Y','N','U')),
	PsImmunizationsComment						type_Comment2			NULL,
	PsImmunizationsNeedsList					type_YOrN				NULL
												CHECK (PsImmunizationsNeedsList in('Y','N')),	
	PsChildHousingIssues						type_YesNoUnknown		NULL
												CHECK (PsChildHousingIssues in ('Y','N','U')),
	PsChildHousingIssuesComment					type_Comment2			NULL,
	PsChildHousingIssuesNeedsList				type_YOrN				NULL
												CHECK (PsChildHousingIssuesNeedsList in	('Y','N')),	
	PsSexuality									type_YesNoUnknown		NULL
												CHECK (PsSexuality in ('Y','N','U')),
	PsSexualityComment							type_Comment2			NULL,
	PsSexualityNeedsList						type_YOrN				NULL
												CHECK (PsSexualityNeedsList in	('Y','N')),	
	PsFamilyFunctioning							type_YesNoUnknown		NULL
												CHECK (PsFamilyFunctioning in ('Y','N','U')),
	PsFamilyFunctioningComment					type_Comment2			NULL,
	PsFamilyFunctioningNeedsList				type_YOrN				NULL
												CHECK (PsFamilyFunctioningNeedsList in	('Y','N')),	
	PsTraumaticIncident							type_YesNoUnknown		NULL
												CHECK (PsTraumaticIncident in ('Y','N','U')),
	PsTraumaticIncidentComment					type_Comment2			NULL,
	PsTraumaticIncidentNeedsList				type_YOrN				NULL
												CHECK (PsTraumaticIncidentNeedsList in	('Y','N')),	
	HistDevelopmental							type_YesNoUnknown		NULL
												CHECK (HistDevelopmental in ('Y','N','U')),
	HistDevelopmentalComment					type_Comment2			NULL,
	HistResidential								type_YesNoUnknown		NULL
												CHECK (HistResidential in ('Y','N','U')),
	HistResidentialComment						type_Comment2			NULL,
	HistOccupational							type_YesNoUnknown		NULL
												CHECK (HistOccupational in ('Y','N','U')),
	HistOccupationalComment						type_Comment2			NULL,
	HistLegalFinancial							type_YesNoUnknown		NULL
												CHECK (HistLegalFinancial in ('Y','N','U')),
	HistLegalFinancialComment					type_Comment2			NULL,
	SignificantEventsPastYear					type_Comment2			NULL,
	PsGrossFineMotor							type_YesNoUnknown		NULL
												CHECK (PsGrossFineMotor in ('Y','N','U')),
	PsGrossFineMotorComment						type_Comment2			NULL,
	PsGrossFineMotorNeedsList					type_YOrN				NULL
												CHECK (PsGrossFineMotorNeedsList in	('Y','N')),	
	PsSensoryPerceptual							type_YesNoUnknown		NULL
												CHECK (PsSensoryPerceptual in ('Y','N','U')),
	PsSensoryPerceptualComment					type_Comment2			NULL,
	PsSensoryPerceptualNeedsList				type_YOrN				NULL
												CHECK (PsSensoryPerceptualNeedsList in	('Y','N')),	
	PsCognitiveFunction							type_YesNoUnknown		NULL
												CHECK (PsCognitiveFunction in ('Y','N','U')),
	PsCognitiveFunctionComment					type_Comment2			NULL,
	PsCognitiveFunctionNeedsList				type_YOrN				NULL
												CHECK (PsCognitiveFunctionNeedsList in	('Y','N')),	
	PsCommunicativeFunction						type_YesNoUnknown		NULL,
	PsCommunicativeFunctionComment				type_Comment2			NULL,
	PsCommunicativeFunctionNeedsList			type_YOrN				NULL
												CHECK (PsCommunicativeFunctionNeedsList in	('Y','N')),	
	PsCurrentPsychoSocialFunctiion				type_YesNoUnknown		NULL
												CHECK (PsCurrentPsychoSocialFunctiion in ('Y','N','U')),
	PsCurrentPsychoSocialFunctiionComment		type_Comment2			NULL,
	PsCurrentPsychoSocialFunctiionNeedsList 	type_YOrN				NULL
												CHECK (PsCurrentPsychoSocialFunctiionNeedsList in('Y','N')),	
	PsAdaptiveEquipment							type_YesNoUnknown		NULL
												CHECK (PsAdaptiveEquipment in ('Y','N','U')),
	PsAdaptiveEquipmentComment					type_Comment2			NULL,
	PsAdaptiveEquipmentNeedsList				type_YOrN				NULL
												CHECK (PsAdaptiveEquipmentNeedsList in	('Y','N')),	
	PsSafetyMobilityHome						type_YesNoUnknown		NULL
												CHECK (PsSafetyMobilityHome in ('Y','N','U')),
	PsSafetyMobilityHomeComment					type_Comment2			NULL,
	PsSafetyMobilityHomeNeedsList				type_YOrN				NULL
												CHECK (PsSafetyMobilityHomeNeedsList in	('Y','N')),	
	PsHealthSafetyChecklistComplete				type_YesNoNoanswerNotasked NULL
												CHECK (PsHealthSafetyChecklistComplete in('NAS','NAN','Y','N')),	
	PsAccessibilityIssues						type_YesNoUnknown		NULL
												CHECK (PsAccessibilityIssues in ('Y','N','U')),
	PsAccessibilityIssuesComment				type_Comment2			NULL,
	PsAccessibilityIssuesNeedsList				type_YOrN				NULL
												CHECK (PsAccessibilityIssuesNeedsList in	('Y','N')),	
	PsEvacuationTraining						type_YesNoUnknown		NULL
												CHECK (PsEvacuationTraining in ('Y','N','U')),
	PsEvacuationTrainingComment					type_Comment2			NULL,
	PsEvacuationTrainingNeedsList				type_YOrN				NULL
												CHECK (PsEvacuationTrainingNeedsList in	('Y','N')),	
	Ps24HourSetting								type_YesNoUnknown		NULL
												CHECK (Ps24HourSetting in ('Y','N','U')),
	Ps24HourSettingComment						type_Comment2			NULL,
	Ps24HourSettingNeedsList					type_YOrN				NULL
												CHECK (Ps24HourSettingNeedsList in	('Y','N')),	
	Ps24HourNeedsAwakeSupervision				type_YesNoUnknown		NULL
												CHECK (Ps24HourNeedsAwakeSupervision in ('Y','N','U')),
	PsSpecialEdEligibility						type_YesNoUnknown		NULL
												CHECK (PsSpecialEdEligibility in ('Y','N','U')),
	PsSpecialEdEligibilityComment				type_Comment2			NULL,
	PsSpecialEdEligibilityNeedsList				type_YOrN				NULL
												CHECK (PsSpecialEdEligibilityNeedsList in	('Y','N')),	
	PsSpecialEdEnrolled							type_YesNoUnknown		NULL
												CHECK (PsSpecialEdEnrolled in ('Y','N','U')),
	PsSpecialEdEnrolledComment					type_Comment2			NULL,
	PsSpecialEdEnrolledNeedsList				type_YOrN				NULL
												CHECK (PsSpecialEdEnrolledNeedsList in	('Y','N')),	
	PsEmployer									type_YesNoUnknown		NULL
												CHECK (PsEmployer in('Y','N','U')),		
	PsEmployerComment							type_Comment2			NULL,
	PsEmployerNeedsList							type_YOrN				NULL
												CHECK (PsEmployerNeedsList in	('Y','N')),	
	PsEmploymentIssues							type_YesNoUnknown		NULL
												CHECK (PsEmploymentIssues in('Y','N')),	
	PsEmploymentIssuesComment					type_Comment2			NULL,
	PsEmploymentIssuesNeedsList					type_YOrN				NULL
												CHECK (PsEmploymentIssuesNeedsList in('Y','N')),	
	PsRestrictionsOccupational					type_YesNoUnknown		NULL
												CHECK (PsRestrictionsOccupational in ('Y','N','U')),
	PsRestrictionsOccupationalComment			type_Comment2			NULL,
	PsRestrictionsOccupationalNeedsList			type_YOrN				NULL
												CHECK (PsRestrictionsOccupationalNeedsList in('Y','N')),	
	PsFunctionalAssessmentNeeded				type_YOrN				NULL
												CHECK (PsFunctionalAssessmentNeeded in	('Y','N')),	
	PsAdvocacyNeeded							type_YOrN				NULL
												CHECK (PsAdvocacyNeeded in	('Y','N')),	
	PsPlanDevelopmentNeeded						type_YOrN				NULL
												CHECK (PsPlanDevelopmentNeeded in ('Y','N')),	
	PsLinkingNeeded								type_YOrN				NULL
												CHECK (PsLinkingNeeded in('Y','N')),	
	PsDDInformationProvidedBy					type_Comment2			NULL,
	HistPreviousDx								type_YesNoUnknown		NULL
												CHECK (HistPreviousDx in ('Y','N','U')),
	HistPreviousDxComment						type_Comment2			NULL,
	PsLegalIssues								type_YesNoUnknown		NULL
												CHECK (PsLegalIssues in ('Y','N','U')),
	PsLegalIssuesComment						type_Comment2			NULL,
	PsLegalIssuesNeedsList						type_YOrN				NULL
												CHECK (PsLegalIssuesNeedsList in	('Y','N')),	
	PsCulturalEthnicIssues						type_YesNoUnknown		NULL
												CHECK (PsCulturalEthnicIssues in ('Y','N','U')),
	PsCulturalEthnicIssuesComment				type_Comment2			NULL,
	PsCulturalEthnicIssuesNeedsList				type_YOrN				NULL
												CHECK (PsCulturalEthnicIssuesNeedsList in('Y','N')),	
	PsSpiritualityIssues						type_YesNoUnknown		NULL
												CHECK (PsSpiritualityIssues in	('Y','N','U')),	
	PsSpiritualityIssuesComment					type_Comment2			NULL,
	PsSpiritualityIssuesNeedsList				type_YOrN				NULL
												CHECK (PsSpiritualityIssuesNeedsList in	('Y','N')),		
	SuicideIdeation								type_YOrN				NULL
												CHECK (SuicideIdeation in	('Y','N')),	
	SuicideActive								type_YOrN				NULL
												CHECK (SuicideActive in	('Y','N')),	
	SuicidePassive								type_YOrN				NULL
												CHECK (SuicidePassive in	('Y','N')),	
	SuicideMeans								type_YOrN				NULL
												CHECK (SuicideMeans in	('Y','N')),	
	SuicidePlan									type_YOrN				NULL
												CHECK (SuicidePlan in	('Y','N')),		
	SuicideOtherRiskSelf						type_YOrN				NULL
												CHECK (SuicideOtherRiskSelf in	('Y','N')),	
	SuicideOtherRiskSelfComment					type_Comment2			NULL,	
	HomicideIdeation							type_YOrN				NULL
												CHECK (HomicideIdeation in	('Y','N')),	
	HomicideActive								type_YOrN				NULL
												CHECK (HomicideActive in	('Y','N')),	
	HomicidePassive								type_YOrN				NULL
												CHECK (HomicidePassive in	('Y','N')),	
	HomicidePlan								type_YOrN				NULL
												CHECK (HomicidePlan in	('Y','N')),
	HomicdeOtherRiskOthers						type_YOrN				NULL
												CHECK (HomicdeOtherRiskOthers in	('Y','N')),	
	HomicideOtherRiskOthersComment				type_Comment2			NULL,
	PhysicalAgressionNotPresent					type_YOrN				NULL
												CHECK (PhysicalAgressionNotPresent in	('Y','N')),	
	PhysicalAgressionSelf						type_YOrN				NULL
												CHECK (PhysicalAgressionSelf in	('Y','N')),	
	PhysicalAgressionOthers						type_YOrN				NULL
												CHECK (PhysicalAgressionOthers in	('Y','N')),	
	PhysicalAgressionCurrentIssue				type_YOrN				NULL
												CHECK (PhysicalAgressionCurrentIssue in	('Y','N')),	
	PhysicalAgressionNeedsList					type_YOrN				NULL
												CHECK (PhysicalAgressionNeedsList in	('Y','N')),	
	PhysicalAgressionBehaviorsPastHistory		type_Comment2			NULL,
	RiskAccessToWeapons							type_YOrN				NULL
												CHECK (RiskAccessToWeapons in	('Y','N')),	
	RiskAppropriateForAdditionalScreening		type_YOrN				NULL
												CHECK (RiskAppropriateForAdditionalScreening in	('Y','N')),	
	RiskClinicalIntervention					type_Comment2			NULL,
	RiskOtherFactorsNone						type_YOrN				NULL
												CHECK (RiskOtherFactorsNone in	('Y','N')),	
	RiskOtherFactors							type_Comment2			NULL,
	RiskOtherFactorsNeedsList					type_YOrN				NULL
												CHECK (RiskOtherFactorsNeedsList in	('Y','N')),	
	StaffAxisV									int						NULL,
	StaffAxisVReason							type_Comment2			NULL,
	ClientStrengthsNarrative					type_Comment2			NULL,
	CrisisPlanningClientHasPlan					type_YOrN				NULL
												CHECK (CrisisPlanningClientHasPlan in	('Y','N')),	
	CrisisPlanningNarrative						type_Comment2			NULL,
	CrisisPlanningDesired						type_YOrN				NULL
												CHECK (CrisisPlanningDesired in	('Y','N')),	
	CrisisPlanningNeedsList						type_YOrN				NULL
												CHECK (CrisisPlanningNeedsList in	('Y','N')),	
	CrisisPlanningMoreInfo						type_YOrN				NULL
												CHECK (CrisisPlanningMoreInfo in	('Y','N')),	
	AdvanceDirectiveClientHasDirective			type_YOrN				NULL
												CHECK (AdvanceDirectiveClientHasDirective in	('Y','N')),	
	AdvanceDirectiveDesired						type_YOrN				NULL
												CHECK (AdvanceDirectiveDesired in	('Y','N')),	
	AdvanceDirectiveNarrative					type_Comment2			NULL,
	AdvanceDirectiveNeedsList					type_YOrN				NULL
												CHECK (AdvanceDirectiveNeedsList in	('Y','N')),	
	AdvanceDirectiveMoreInfo					type_YOrN				NULL
												CHECK (AdvanceDirectiveMoreInfo in	('Y','N')),	
	NaturalSupportSufficiency					char(2)					NULL,
	NaturalSupportNeedsList						type_YOrN				NULL
												CHECK (NaturalSupportNeedsList in	('Y','N')),	
	NaturalSupportIncreaseDesired				type_YOrN				NULL
												CHECK (NaturalSupportIncreaseDesired in	('Y','N')),	
	ClinicalSummary								type_Comment2			NULL,
	UncopeQuestionU								type_YOrN				NULL
												CHECK (UncopeQuestionU in('Y','N')),	
	UncopeApplicable							type_YOrN				NULL
												CHECK (UncopeApplicable in	('Y','N')),	
	UncopeApplicableReason						type_Comment2			NULL,
	UncopeQuestionN								type_YOrN				NULL
												CHECK (UncopeQuestionN in	('Y','N')),	
	UncopeQuestionC								type_YOrN				NULL
												CHECK (UncopeQuestionC in	('Y','N')),	
	UncopeQuestionO								type_YOrN				NULL
												CHECK (UncopeQuestionO in	('Y','N')),	
	UncopeQuestionP								type_YOrN				NULL
												CHECK (UncopeQuestionP in	('Y','N')),	
	UncopeQuestionE								type_YOrN				NULL
												CHECK (UncopeQuestionE in	('Y','N')),	
	UncopeCompleteFullSUAssessment				type_YOrN				NULL
												CHECK (UncopeCompleteFullSUAssessment in('Y','N')),	
	SubstanceUseNeedsList						type_YOrN				NULL
												CHECK (SubstanceUseNeedsList in	('Y','N')),	
	DecreaseSymptomsNeedsList					type_YOrN				NULL
												CHECK (DecreaseSymptomsNeedsList in	('Y','N')),	
	DDEPreviouslyMet							type_YOrN				NULL
												CHECK (DDEPreviouslyMet in	('Y','N')),	
	DDAttributableMentalPhysicalLimitation		type_YOrN				NULL
												CHECK (DDAttributableMentalPhysicalLimitation in('Y','N')),	
	DDDxAxisI									type_Comment2			NULL,
	DDDxAxisII									type_Comment2			NULL,
	DDDxAxisIII									type_Comment2			NULL,
	DDDxAxisIV									type_Comment2			NULL,
	DDDxAxisV									type_Comment2			NULL,
	DDDxSource									type_Comment2			NULL,
	DDManifestBeforeAge22						type_YOrN				NULL
												CHECK (DDManifestBeforeAge22 in	('Y','N')),	
	DDContinueIndefinitely						type_YOrN				NULL
												CHECK (DDContinueIndefinitely in	('Y','N')),	
	DDLimitSelfCare								type_YOrN				NULL
												CHECK (DDLimitSelfCare in	('Y','N')),	
	DDLimitLanguage								type_YOrN				NULL
												CHECK (DDLimitLanguage in	('Y','N')),	
	DDLimitLearning								type_YOrN				NULL
												CHECK (DDLimitLearning in	('Y','N')),	
	DDLimitMobility								type_YOrN				NULL
												CHECK (DDLimitMobility in	('Y','N')),	
	DDLimitSelfDirection						type_YOrN				NULL
												CHECK (DDLimitSelfDirection in	('Y','N')),	
	DDLimitEconomic								type_YOrN				NULL
												CHECK (DDLimitEconomic in	('Y','N')),	
	DDLimitIndependentLiving					type_YOrN				NULL
												CHECK (DDLimitIndependentLiving in('Y','N')),	
	DDNeedMulitpleSupports						type_YOrN				NULL
												CHECK (DDNeedMulitpleSupports in('Y','N')),	
	CAFASDate									datetime				NULL,
	RaterClinician								int						NULL,
	CAFASInterval								type_GlobalCode			NULL,
	SchoolPerformance							int						NULL,
	SchoolPerformanceComment					type_Comment2			NULL,
	HomePerformance								int						NULL,
	HomePerfomanceComment						type_Comment2			NULL,
	CommunityPerformance						int						NULL,
	CommunityPerformanceComment					type_Comment2			NULL,
	BehaviorTowardsOther						int						NULL,
	BehaviorTowardsOtherComment					type_Comment2			NULL,
	MoodsEmotion								int						NULL,
	MoodsEmotionComment							type_Comment2			NULL,
	SelfHarmfulBehavior							int						NULL,
	SelfHarmfulBehaviorComment					type_Comment2			NULL,
	SubstanceUse								int						NULL,
	SubstanceUseComment							type_Comment2			NULL,
	Thinkng										int						NULL,
	ThinkngComment								type_Comment2			NULL,
	YouthTotalScore								int						NULL,
	PrimaryFamilyMaterialNeeds					int						NULL,
	PrimaryFamilyMaterialNeedsComment			type_Comment2			NULL,
	PrimaryFamilySocialSupport					int						NULL,
	PrimaryFamilySocialSupportComment			type_Comment2			NULL,
	NonCustodialMaterialNeeds					int						NULL,
	NonCustodialMaterialNeedsComment			type_Comment2			NULL,
	NonCustodialSocialSupport					int						NULL,
	NonCustodialSocialSupportComment			type_Comment2			NULL,
	SurrogateMaterialNeeds						int						NULL,
	SurrogateMaterialNeedsComment				type_Comment2			NULL,
	SurrogateSocialSupport						int						NULL,
	SurrogateSocialSupportComment				type_Comment2			NULL,
	DischargeCriteria							type_Comment2			NULL,
	PrePlanFiscalIntermediaryComment			type_Comment2			NULL,
	StageOfChange								type_GlobalCode			NULL,
	PsEducation									type_YesNoUnknown		NULL
												CHECK (PsEducation in('Y','N','U')),
	PsEducationNeedsList						type_YOrN				NULL
												CHECK (PsEducationNeedsList in('Y','N')),
	PsMedications								char(1)					NULL
												CHECK (PsMedications in	('Y','U','N','I','L')),	
	PsMedicationsNeedsList						type_YOrN				NULL
												CHECK (PsMedicationsNeedsList in	('Y','N')),	
	PsMedicationsListToBeModified				type_YOrN				NULL
												CHECK (PsMedicationsListToBeModified in	('Y','N')),	
	PhysicalConditionQuadriplegic				type_YOrN				NULL
												CHECK (PhysicalConditionQuadriplegic in	('Y','N')),	
	PhysicalConditionMultipleSclerosis			type_YOrN				NULL
												CHECK (PhysicalConditionMultipleSclerosis in ('Y','N')),	
	PhysicalConditionBlindness					type_YOrN				NULL
												CHECK (PhysicalConditionBlindness in('Y','N')),	
	PhysicalConditionDeafness					type_YOrN				NULL
												CHECK (PhysicalConditionDeafness in	('Y','N')),	
	PhysicalConditionParaplegic					type_YOrN				NULL
												CHECK (PhysicalConditionParaplegic in	('Y','N')),	
	PhysicalConditionCerebral					type_YOrN				NULL
												CHECK (PhysicalConditionCerebral in	('Y','N')),	
	PhysicalConditionMuteness					type_YOrN				NULL
												CHECK (PhysicalConditionMuteness in	('Y','N')),	
	PhysicalConditionOtherHearingImpairment 	type_YOrN				NULL
												CHECK (PhysicalConditionOtherHearingImpairment in	('Y','N')),	
	TestingReportsReviewed						varchar(2)				NULL,	
	SevereProfoundDisability					type_YOrN				NULL
												CHECK (SevereProfoundDisability in	('Y','N')),	
	SevereProfoundDisabilityComment				type_Comment2			NULL,
	EmploymentStatus							type_GlobalCode			NULL,
	DxTabDisabled								type_YOrN				NULL
												CHECK (DxTabDisabled in	('Y','N')),
	PsMedicationsSideEffects					type_Comment2			NULL,	
	AutisticallyImpaired						type_YOrN				NULL
												CHECK (AutisticallyImpaired in	('Y','N')),
	CognitivelyImpaired							type_YOrN				NULL
												CHECK (CognitivelyImpaired in	('Y','N')),
	EmotionallyImpaired							type_YOrN				NULL
												CHECK (EmotionallyImpaired in	('Y','N')),
	BehavioralConcern							type_YOrN				NULL
												CHECK (BehavioralConcern in	('Y','N')),
	LearningDisabilities						type_YOrN				NULL
												CHECK (LearningDisabilities in	('Y','N')),
	PhysicalImpaired							type_YOrN				NULL
												CHECK (PhysicalImpaired in	('Y','N')),
	IEP											type_YOrN				NULL
												CHECK (IEP in	('Y','N')),
	ChallengesBarrier							type_YOrN				NULL
												CHECK (ChallengesBarrier in	('Y','N')),
	UnProtectedSexualRelationMoreThenOnePartner	type_YOrN				NULL
												CHECK (UnProtectedSexualRelationMoreThenOnePartner in	('Y','N')),
	SexualRelationWithHIVInfected				type_YOrN				NULL
												CHECK (SexualRelationWithHIVInfected in	('Y','N')),
	SexualRelationWithDrugInject				type_YOrN				NULL
												CHECK (SexualRelationWithDrugInject in	('Y','N')),
	InjectsDrugsSharedNeedle					type_YOrN				NULL
												CHECK (InjectsDrugsSharedNeedle in	('Y','N')),
	ReceivedAnyFavorsForSexualRelation			type_YOrN				NULL
												CHECK (ReceivedAnyFavorsForSexualRelation in('Y','N')),
	FamilyFriendFeelingsCausedDistress			type_YOrN				NULL
												CHECK (FamilyFriendFeelingsCausedDistress in('Y','N')),
	FeltNervousAnxious							type_GlobalCode			NULL,
	NotAbleToStopWorrying						type_GlobalCode			NULL,	
	StressPeoblemForHandlingThing				type_GlobalCode			NULL,
	SocialAndEmotionalNeed						type_GlobalCode			NULL,
	DepressionAnxietyRecommendation				type_YOrN				NULL
												CHECK (DepressionAnxietyRecommendation in('Y','N')),	---
	CommunicableDiseaseRecommendation			type_YOrN				NULL
												CHECK (CommunicableDiseaseRecommendation in('Y','N')),
	PleasureInDoingThings						type_GlobalCode			NULL,
	DepressedHopelessFeeling					type_GlobalCode			NULL,
	AsleepSleepingFalling						type_GlobalCode			NULL,
	TiredFeeling								type_GlobalCode			NULL,
	OverEating									type_GlobalCode			NULL,
	BadAboutYourselfFeeling						type_GlobalCode			NULL,
	TroubleConcentratingOnThings				type_GlobalCode			NULL,
	SpeakingSlowlyOrOpposite					type_GlobalCode			NULL,
	BetterOffDeadThought						type_GlobalCode			NULL,
	DifficultProblem							type_GlobalCode			NULL,
	SexualityComment							type_Comment2			NULL,
	ReceivePrenatalCare							type_YesNoUnknown		NULL
												CHECK(ReceivePrenatalCare in ('Y','N','U')),
	ReceivePrenatalCareNeedsList				type_YOrN				NULL
												CHECK (ReceivePrenatalCareNeedsList in('Y','N')),
	ProblemInPregnancy							type_YesNoUnknown		NULL
												CHECK(ProblemInPregnancy  in ('Y','N','U')),
	ProblemInPregnancyNeedsList					type_YOrN				NULL
												CHECK (ProblemInPregnancyNeedsList in('Y','N')),
	DevelopmentalAttachmentComments				type_Comment2			NULL,
	PrenatalExposer								type_YesNoUnknown		NULL
												CHECK(PrenatalExposer  in ('Y','N','U')),
	PrenatalExposerNeedsList					type_YOrN				NULL
												CHECK (PrenatalExposerNeedsList in('Y','N')),
	WhereMedicationUsed							type_YesNoUnknown		NULL
												CHECK(WhereMedicationUsed  in ('Y','N','U')),
	WhereMedicationUsedNeedsList				type_YOrN				NULL
												CHECK (WhereMedicationUsedNeedsList in('Y','N')),
	IssueWithDelivery							type_YesNoUnknown		NULL
												CHECK(IssueWithDelivery  in ('Y','N','U')),
	IssueWithDeliveryNeedsList					type_YOrN				NULL
												CHECK (IssueWithDeliveryNeedsList in('Y','N')),
	ChildDevelopmentalMilestones				type_YesNoUnknown		NULL
												CHECK(ChildDevelopmentalMilestones  in ('Y','N','U')),
	ChildDevelopmentalMilestonesNeedsList		type_YOrN				NULL
												CHECK (ChildDevelopmentalMilestonesNeedsList in('Y','N')),
	TalkBeforeNeedsList							type_YOrN				NULL
												CHECK(TalkBeforeNeedsList in ('Y','N')),
	ParentChildRelationshipIssue				type_YesNoUnknown		NULL
												CHECK(ParentChildRelationshipIssue in ('Y','N','U')),
	ParentChildRelationshipNeedsList			type_YOrN				NULL
												CHECK(ParentChildRelationshipNeedsList in ('Y','N')),
	FamilyRelationshipIssues					type_YesNoUnknown		NULL
												CHECK(FamilyRelationshipIssues in ('Y','N','U')),
	FamilyRelationshipNeedsList					type_YOrN				NULL
												CHECK(FamilyRelationshipNeedsList in ('Y','N')),
	AddSexualitytoNeedList						type_YesNoUnknown       NULL
												CHECK (AddSexualitytoNeedList in ('Y','N','U')),
	WhenTheyWalkUnknown							type_YesNoUnknown		NULL
												CHECK (WhenTheyWalkUnknown in ('Y','N','U')),
	WhenTheyTalkUnknown							type_YesNoUnknown		NULL
												CHECK (WhenTheyTalkUnknown in ('Y','N','U')),
	WhenTheyTalkSentenceUnknown					type_YesNoUnknown		NULL
												CHECK (WhenTheyTalkSentenceUnknown  in ('Y','N','U')),	
	LegalIssues									type_Comment2			NULL,	
	CSSRSAdultOrChild							Char(1)					NULL	
												CHECK (CSSRSAdultOrChild  in ('A','C')),
	Strengths									type_Comment2			NULL,
	TransitionLevelOfCare						type_Comment2			NULL,
	ReductionInSymptoms							type_YOrN				NULL
												CHECK (ReductionInSymptoms in('Y','N')),
	AttainmentOfHigherFunctioning				type_YOrN				NULL
												CHECK (AttainmentOfHigherFunctioning in('Y','N')),
	TreatmentNotNecessary						type_YOrN				NULL
												CHECK (TreatmentNotNecessary in('Y','N')),
    OtherTransitionCriteria						type_YOrN				NULL
												CHECK (OtherTransitionCriteria in('Y','N'))	,
	EstimatedDischargeDate						datetime				NULL,	
	ReductionInSymptomsDescription				type_Comment2			NULL,
	AttainmentOfHigherFunctioningDescription	type_Comment2			NULL,
	TreatmentNotNecessaryDescription			type_Comment2			NULL,
	OtherTransitionCriteriaDescription			type_Comment2			NULL,
	DepressionPHQToNeedList						type_YOrN				NULL
												CHECK (DepressionPHQToNeedList in('Y','N')),
	GuardianFirstName							varchar(30)				NULL,
	GuardianLastName							varchar(50)				NULL,
	GuardianCity								type_City				NULL,
	GuardianState								type_State				NULL,
	GuardianZipcode								type_ZipCode			NULL,
	RelationWithGuardian						type_GlobalCode			NULL,
	ClientAdvanceDirective						type_YOrN				NULL
												CHECK (ClientAdvanceDirective in('Y','N')),
	ClientAdvanceADirectivePlan					type_YOrN				NULL
												CHECK (ClientAdvanceADirectivePlan in('Y','N')),
	NeedMoreInfoAboutClientADPlan				type_YOrN				NULL
												CHECK (NeedMoreInfoAboutClientADPlan in('Y','N')),
	AdvanceDirectiveInformation					type_Comment2			NULL,
	AddAdvanceDirectiveNeedsList				type_YOrN				NULL
												CHECK (AddAdvanceDirectiveNeedsList in('Y','N')),
    CONSTRAINT CustomDocumentMHAssessments_PK PRIMARY KEY CLUSTERED (DocumentVersionId)
)

IF OBJECT_ID('CustomDocumentMHAssessments') IS NOT NULL	
    PRINT '<<< CREATED TABLE CustomDocumentMHAssessments >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE CustomDocumentMHAssessments >>>'

/* 
 * TABLE:  CustomDocumentMHAssessments 
 */

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CustomDocumentMHAssessments]') AND name = N'XIE1_CustomDocumentMHAssessments')
  BEGIN
   CREATE NONCLUSTERED INDEX [XIE1_CustomDocumentMHAssessments] ON [dbo].[CustomDocumentMHAssessments] 
   (
   [LOCId]  ASC
   )
   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomDocumentMHAssessments') AND name='XIE1_CustomDocumentMHAssessments')
   PRINT '<<< CREATED INDEX CustomDocumentMHAssessments.XIE1_CustomDocumentMHAssessments >>>'
   ELSE
   RAISERROR('<<< FAILED CREATING INDEX CustomDocumentMHAssessments.XIE1_CustomDocumentMHAssessments >>>', 16, 1)  
  END  
 
/* 
 * TABLE: CustomDocumentMHAssessments 
 */
  
ALTER TABLE CustomDocumentMHAssessments ADD CONSTRAINT DocumentVersions_CustomDocumentMHAssessments_FK 
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)

ALTER TABLE CustomDocumentMHAssessments ADD CONSTRAINT CustomLOCs_CustomDocumentMHAssessments_FK 
	FOREIGN KEY (LOCId)
	REFERENCES CustomLOCs(LOCId)
		
EXEC sys.sp_addextendedproperty 'CustomDocumentMHAssessments_Description'
	,'RelationWithGuardian column stores globalcode of category "RELATIONSHIP"'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentMHAssessments'
	,'column'
	,'RelationWithGuardian'	

PRINT 'STEP 4(F) COMPLETED'
END
Go

 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomMHAssessmentCurrentHealthIssues')
 BEGIN
/* 
 * TABLE: CustomMHAssessmentCurrentHealthIssues 
 */
CREATE TABLE CustomMHAssessmentCurrentHealthIssues(
	MHAssessmentCurrentHealthIssueId			int	IDENTITY(1,1)			NOT NULL,
	CreatedBy								    type_CurrentUser			NOT NULL,
    CreatedDate                                 type_CurrentDatetime		NOT NULL,
    ModifiedBy                                  type_CurrentUser			NOT NULL,
    ModifiedDate                                type_CurrentDatetime		NOT NULL,
    RecordDeleted                               type_YOrN					NULL
												CHECK (RecordDeleted in ('Y','N')),
    DeletedBy                                   type_UserId					NULL,
    DeletedDate                                 datetime					NULL,
    DocumentVersionId							int							NULL,
    CurrentHealthIssues							type_GlobalCode				NULL,
    IsChecked									type_YOrN					NULL
												CHECK (IsChecked in ('Y','N')),
	CONSTRAINT CustomMHAssessmentCurrentHealthIssues_PK PRIMARY KEY CLUSTERED (MHAssessmentCurrentHealthIssueId)
)

IF OBJECT_ID('CustomMHAssessmentCurrentHealthIssues') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomMHAssessmentCurrentHealthIssues >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomMHAssessmentCurrentHealthIssues >>>', 16, 1)

/* 
 * TABLE: CustomMHAssessmentCurrentHealthIssues 
 */ 
 
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CustomMHAssessmentCurrentHealthIssues]') AND name = N'XIE1_CustomMHAssessmentCurrentHealthIssues')
  BEGIN
   CREATE NONCLUSTERED INDEX [XIE1_CustomMHAssessmentCurrentHealthIssues] ON [dbo].[CustomMHAssessmentCurrentHealthIssues] 
   (
   [DocumentVersionId]  ASC
   )
   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomMHAssessmentCurrentHealthIssues') AND name='XIE1_CustomMHAssessmentCurrentHealthIssues')
   PRINT '<<< CREATED INDEX CustomMHAssessmentCurrentHealthIssues.XIE1_CustomMHAssessmentCurrentHealthIssues >>>'
   ELSE
   RAISERROR('<<< FAILED CREATING INDEX CustomMHAssessmentCurrentHealthIssues.XIE1_CustomMHAssessmentCurrentHealthIssues >>>', 16, 1)  
  END  
  
/* 
 * TABLE: CustomMHAssessmentCurrentHealthIssues  
 */   
    
ALTER TABLE CustomMHAssessmentCurrentHealthIssues ADD CONSTRAINT DocumentVersions_CustomMHAssessmentCurrentHealthIssues_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)

EXEC sys.sp_addextendedproperty 'CustomMHAssessmentCurrentHealthIssues_Description'
	,'CurrentHealthIssues column stores globalcode of category "XMHAessHealthIssues"'
	,'schema'
	,'dbo'
	,'table'
	,'CustomMHAssessmentCurrentHealthIssues'         
	,'column'
	,'CurrentHealthIssues'
	     
PRINT 'STEP 4(G) COMPLETED'
END
Go

 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomMHAssessmentPastHealthIssues')
 BEGIN
/* 
 * TABLE: CustomMHAssessmentPastHealthIssues 
 */
CREATE TABLE CustomMHAssessmentPastHealthIssues(
	MHAssessmentPastHealthIssueId				int	IDENTITY(1,1)			NOT NULL,
	CreatedBy								    type_CurrentUser			NOT NULL,
    CreatedDate                                 type_CurrentDatetime		NOT NULL,
    ModifiedBy                                  type_CurrentUser			NOT NULL,
    ModifiedDate                                type_CurrentDatetime		NOT NULL,
    RecordDeleted                               type_YOrN					NULL
												CHECK (RecordDeleted in ('Y','N')),
    DeletedBy                                   type_UserId					NULL,
    DeletedDate                                 datetime					NULL,
    DocumentVersionId							int							NULL,
    PastHealthIssues							type_GlobalCode				NULL,
    IsChecked									type_YOrN					NULL
												CHECK (IsChecked in ('Y','N')),
	CONSTRAINT CustomMHAssessmentPastHealthIssues_PK PRIMARY KEY CLUSTERED (MHAssessmentPastHealthIssueId)
)

IF OBJECT_ID('CustomMHAssessmentPastHealthIssues') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomMHAssessmentPastHealthIssues >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomMHAssessmentPastHealthIssues >>>', 16, 1)

/* 
 * TABLE: CustomMHAssessmentPastHealthIssues 
 */ 
 
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CustomMHAssessmentPastHealthIssues]') AND name = N'XIE1_CustomMHAssessmentPastHealthIssues')
  BEGIN
   CREATE NONCLUSTERED INDEX [XIE1_CustomMHAssessmentPastHealthIssues] ON [dbo].[CustomMHAssessmentPastHealthIssues] 
   (
   [DocumentVersionId]  ASC
   )
   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomMHAssessmentPastHealthIssues') AND name='XIE1_CustomMHAssessmentPastHealthIssues')
   PRINT '<<< CREATED INDEX CustomMHAssessmentPastHealthIssues.XIE1_CustomMHAssessmentPastHealthIssues >>>'
   ELSE
   RAISERROR('<<< FAILED CREATING INDEX CustomMHAssessmentPastHealthIssues.XIE1_CustomMHAssessmentPastHealthIssues >>>', 16, 1)  
  END  
  
/* 
 * TABLE: CustomMHAssessmentPastHealthIssues 
 */   
    
ALTER TABLE CustomMHAssessmentPastHealthIssues ADD CONSTRAINT DocumentVersions_CustomMHAssessmentPastHealthIssues_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)

EXEC sys.sp_addextendedproperty 'CustomMHAssessmentPastHealthIssues_Description'
	,'PastHealthIssues column stores globalcode of category "XMHAessHealthIssues"'
	,'schema'
	,'dbo'
	,'table'
	,'CustomMHAssessmentPastHealthIssues'         
	,'column'
	,'PastHealthIssues'
	     
PRINT 'STEP 4(H) COMPLETED'
END
Go

 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomMHAssessmentFamilyHistory')
 BEGIN
/* 
 * TABLE: CustomMHAssessmentFamilyHistory 
 */
CREATE TABLE CustomMHAssessmentFamilyHistory(
	MHAssessmentFamilyHistoryId					int	IDENTITY(1,1)			NOT NULL,
	CreatedBy								    type_CurrentUser			NOT NULL,
    CreatedDate                                 type_CurrentDatetime		NOT NULL,
    ModifiedBy                                  type_CurrentUser			NOT NULL,
    ModifiedDate                                type_CurrentDatetime		NOT NULL,
    RecordDeleted                               type_YOrN					NULL
												CHECK (RecordDeleted in ('Y','N')),
    DeletedBy                                   type_UserId					NULL,
    DeletedDate                                 datetime					NULL,
    DocumentVersionId							int							NULL,
    FamilyHistory								type_GlobalCode				NULL,
    IsChecked									type_YOrN					NULL
												CHECK (IsChecked in ('Y','N')),
	CONSTRAINT CustomMHAssessmentFamilyHistory_PK PRIMARY KEY CLUSTERED (MHAssessmentFamilyHistoryId)
)

IF OBJECT_ID('CustomMHAssessmentFamilyHistory') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomMHAssessmentFamilyHistory >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomMHAssessmentFamilyHistory >>>', 16, 1)

/* 
 * TABLE: CustomMHAssessmentFamilyHistory 
 */ 
 
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CustomMHAssessmentFamilyHistory]') AND name = N'XIE1_CustomMHAssessmentFamilyHistory')
  BEGIN
   CREATE NONCLUSTERED INDEX [XIE1_CustomMHAssessmentFamilyHistory] ON [dbo].[CustomMHAssessmentFamilyHistory] 
   (
   [DocumentVersionId]  ASC
   )
   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomMHAssessmentFamilyHistory') AND name='XIE1_CustomMHAssessmentFamilyHistory')
   PRINT '<<< CREATED INDEX CustomMHAssessmentFamilyHistory.XIE1_CustomMHAssessmentFamilyHistory >>>'
   ELSE
   RAISERROR('<<< FAILED CREATING INDEX CustomMHAssessmentFamilyHistory.XIE1_CustomMHAssessmentFamilyHistory >>>', 16, 1)  
  END  
  
/* 
 * TABLE: CustomMHAssessmentFamilyHistory 
  */   
    
ALTER TABLE CustomMHAssessmentFamilyHistory ADD CONSTRAINT DocumentVersions_CustomMHAssessmentFamilyHistory_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)

EXEC sys.sp_addextendedproperty 'CustomMHAssessmentFamilyHistory_Description'
	,'PastHealthIssues column stores globalcode of category "XMHAessHealthIssues"'
	,'schema'
	,'dbo'
	,'table'
	,'CustomMHAssessmentFamilyHistory'         
	,'column'
	,'FamilyHistory'
	     
PRINT 'STEP 4(I) COMPLETED'
END
Go

 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomHRMAssessmentMedications')
 BEGIN
/* 
 * TABLE: CustomHRMAssessmentMedications 
 */
CREATE TABLE CustomHRMAssessmentMedications(
	HRMAssessmentMedicationId					int	IDENTITY(1,1)			NOT NULL,
	CreatedBy								    type_CurrentUser			NOT NULL,
    CreatedDate                                 type_CurrentDatetime		NOT NULL,
    ModifiedBy                                  type_CurrentUser			NOT NULL,
    ModifiedDate                                type_CurrentDatetime		NOT NULL,
    RecordDeleted                               type_YOrN					NULL
												CHECK (RecordDeleted in ('Y','N')),
    DeletedBy                                   type_UserId					NULL,
    DeletedDate                                 datetime					NULL,
    DocumentVersionId							int							NULL,
    Name										varchar(250)				NULL,
	Dosage										varchar(250)				NULL,
	Purpose										varchar(max)				NULL,
	PrescribingPhysician						varchar(250)				NULL,
	CONSTRAINT CustomHRMAssessmentMedications_PK PRIMARY KEY CLUSTERED (HRMAssessmentMedicationId)
)

IF OBJECT_ID('CustomHRMAssessmentMedications') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomHRMAssessmentMedications >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomHRMAssessmentMedications >>>', 16, 1)

/* 
 * TABLE: CustomHRMAssessmentMedications 
 */ 
 
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CustomHRMAssessmentMedications]') AND name = N'XIE1_CustomHRMAssessmentMedications')
  BEGIN
   CREATE NONCLUSTERED INDEX [XIE1_CustomHRMAssessmentMedications] ON [dbo].[CustomHRMAssessmentMedications] 
   (
   [DocumentVersionId]  ASC
   )
   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomHRMAssessmentMedications') AND name='XIE1_CustomHRMAssessmentMedications')
   PRINT '<<< CREATED INDEX CustomHRMAssessmentMedications.XIE1_CustomHRMAssessmentMedications >>>'
   ELSE
   RAISERROR('<<< FAILED CREATING INDEX CustomHRMAssessmentMedications.XIE1_CustomHRMAssessmentMedications >>>', 16, 1)  
  END  
  
/* 
 * TABLE: CustomHRMAssessmentMedications 
  */   
    
ALTER TABLE CustomHRMAssessmentMedications ADD CONSTRAINT DocumentVersions_CustomHRMAssessmentMedications_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
	     
PRINT 'STEP 4(J) COMPLETED'
END
Go

 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentAssessmentPECFASs')
 BEGIN
/* 
 * TABLE: CustomDocumentAssessmentPECFASs 
 */

CREATE TABLE CustomDocumentAssessmentPECFASs(
    DocumentVersionId					int							NOT NULL,
    CreatedBy							type_CurrentUser			NOT NULL,
    CreatedDate							type_CurrentDatetime		NOT NULL,
    ModifiedBy							type_CurrentUser			NOT NULL,
    ModifiedDate						type_CurrentDatetime		NOT NULL,
    RecordDeleted						type_YOrN					NULL
										CHECK (RecordDeleted in('Y','N')),
    DeletedBy							type_UserId					NULL,
    DeletedDate							datetime					NULL,
    SchoolDayCare						varchar(100)				NULL,
	HomeRolePerformance					varchar(100)				NULL,
	CommunityRolePerformance			varchar(100)				NULL,
	BehaviourTowardOthers				varchar(100)				NULL,
	MoodsEmotions						varchar(100)				NULL,
	SelfHarmfulBehavior					varchar(100)				NULL,
	ThinkingCommunication				varchar(100)				NULL,
	TotalChild							varchar(100)				NULL,
	PrimaryScaleScore					varchar(100)				NULL,
	OtherScaleScore						varchar(100)				NULL,
	MaterialNeeds1						varchar(100)				NULL,
	MaterialNeeds2						varchar(100)				NULL,
	FamilySocialSupport1				varchar(100)				NULL,
	FamilySocialSupport2				varchar(100)				NULL,
	CONSTRAINT CustomDocumentAssessmentPECFASs_PK PRIMARY KEY CLUSTERED (DocumentVersionId)		 	
)
 IF OBJECT_ID('CustomDocumentAssessmentPECFASs') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentAssessmentPECFASs >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentAssessmentPECFASs >>>', 16, 1)
    
/*  
 * TABLE: CustomDocumentAssessmentPECFASs 
 */ 
    
 ALTER TABLE CustomDocumentAssessmentPECFASs ADD CONSTRAINT DocumentVersions_CustomDocumentAssessmentPECFASs_FK 
	FOREIGN KEY (DocumentVersionId)
	REFERENCES DocumentVersions(DocumentVersionId)
	
PRINT 'STEP 4(K) COMPLETED'
END
Go

 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentMHAssessmentCAFASs')
 BEGIN
/* 
 * TABLE: CustomDocumentMHAssessmentCAFASs 
 */
CREATE TABLE CustomDocumentMHAssessmentCAFASs(
	DocumentVersionId							int							NOT NULL,
	CreatedBy								    type_CurrentUser			NOT NULL,
    CreatedDate                                 type_CurrentDatetime		NOT NULL,
    ModifiedBy                                  type_CurrentUser			NOT NULL,
    ModifiedDate                                type_CurrentDatetime		NOT NULL,
    RecordDeleted                               type_YOrN					NULL
												CHECK (RecordDeleted in ('Y','N')),
    DeletedBy                                   type_UserId					NULL,
    DeletedDate                                 datetime					NULL,
    CAFASDate									datetime					NULL,
	RaterClinician								int							NULL,
	CAFASInterval								int							NULL,
	SchoolPerformance							int							NULL,
	SchoolPerformanceComment					type_Comment2				NULL,
	HomePerformance								int							NULL,
	HomePerfomanceComment						type_Comment2				NULL,
	CommunityPerformance						int							NULL,
	CommunityPerformanceComment					type_Comment2				NULL,
	BehaviorTowardsOther						int							NULL,
	BehaviorTowardsOtherComment					type_Comment2				NULL,
	MoodsEmotion								int							NULL,
	MoodsEmotionComment							type_Comment2				NULL,
	SelfHarmfulBehavior							int							NULL,
	SelfHarmfulBehaviorComment					type_Comment2				NULL,
	SubstanceUse								int							NULL,
	SubstanceUseComment							type_Comment2				NULL,
	Thinkng										int							NULL,
	ThinkngComment								type_Comment2				NULL,
	YouthTotalScore								int							NULL,
	PrimaryFamilyMaterialNeeds					int							NULL,
	PrimaryFamilyMaterialNeedsComment			type_Comment2				NULL,
	PrimaryFamilySocialSupport					int							NULL,
	PrimaryFamilySocialSupportComment			type_Comment2				NULL,
	NonCustodialMaterialNeeds					int							NULL,
	NonCustodialMaterialNeedsComment			type_Comment2				NULL,
	NonCustodialSocialSupport					int							NULL,
	NonCustodialSocialSupportComment			type_Comment2				NULL,
	SurrogateMaterialNeeds						int							NULL,
	SurrogateMaterialNeedsComment				type_Comment2				NULL,
	SurrogateSocialSupport						int							NULL,
	SurrogateSocialSupportComment				type_Comment2				NULL,
	CONSTRAINT CustomDocumentMHAssessmentCAFASs_PK PRIMARY KEY CLUSTERED (DocumentVersionId)
)

IF OBJECT_ID('CustomDocumentMHAssessmentCAFASs') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentMHAssessmentCAFASs >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentMHAssessmentCAFASs >>>', 16, 1)

/* 
 * TABLE: CustomDocumentMHAssessmentCAFASs 
 */   
    
ALTER TABLE CustomDocumentMHAssessmentCAFASs ADD CONSTRAINT DocumentVersions_CustomDocumentMHAssessmentCAFASs_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
     
PRINT 'STEP 4(L) COMPLETED'
 END
Go


 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentMHColumbiaAdultSinceLastVisits')
 BEGIN
/* 
 * TABLE: CustomDocumentMHColumbiaAdultSinceLastVisits 
 */
CREATE TABLE CustomDocumentMHColumbiaAdultSinceLastVisits(
	DocumentVersionId														int							NOT NULL,
	CreatedBy								    							type_CurrentUser			NOT NULL,
    CreatedDate                                 							type_CurrentDatetime		NOT NULL,
    ModifiedBy                                  							type_CurrentUser			NOT NULL,
    ModifiedDate                                							type_CurrentDatetime		NOT NULL,
    RecordDeleted                               							type_YOrN					NULL
																			CHECK (RecordDeleted in ('N','Y')),
    DeletedBy                                   							type_UserId					NULL,
    DeletedDate                                 							datetime					NULL,
    WishToBeDead															type_GlobalCode				NULL,
	WishToBeDeadDescription													type_Comment2				NULL,
	NonSpecificActiveSuicidalThoughts										type_GlobalCode				NULL,
	NonSpecificActiveSuicidalThoughtsDescription							type_Comment2				NULL,
	ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToAct					type_GlobalCode				NULL,
	ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToActDescription		type_Comment2				NULL,
	ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlan			type_GlobalCode				NULL,
	ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlanDescription	type_Comment2				NULL,
	AciveSuicidalIdeationWithSpecificPlanAndIntent							type_GlobalCode				NULL,
	AciveSuicidalIdeationWithSpecificPlanAndIntentDescription				type_Comment2				NULL,
	MostSevereIdeation														type_GlobalCode				NULL,
	MostSevereIdeationDescription											type_Comment2				NULL,
	Frequency																type_GlobalCode				NULL,
	ActualAttempt															type_GlobalCode				NULL,
	TotalNumberOfAttempts													int							NULL,
	ActualAttemptDescription												type_Comment2				NULL,
	HasSubjectEngagedInNonSuicidalSelfInjuriousBehavior						type_GlobalCode				NULL,
	HasSubjectEngagedInSelfInjuriousBehaviorIntentUnknown					type_GlobalCode				NULL,
	InterruptedAttempt														type_GlobalCode				NULL,
	TotalNumberOfAttemptsInterrupted										int							NULL,
	InterruptedAttemptDescription											type_Comment2				NULL,
	AbortedOrSelfInterruptedAttempt											type_GlobalCode				NULL,
	TotalNumberAttemptsAbortedOrSelfInterrupted								int							NULL,
	AbortedOrSelfInterruptedAttemptDescription								type_Comment2				NULL,
	PreparatoryActsOrBehavior												type_GlobalCode				NULL,
	TotalNumberOfPreparatoryActs											int							NULL,
	PreparatoryActsOrBehaviorDescription									type_Comment2				NULL,
	SuicidalBehavior														type_GlobalCode				NULL,
	MostLethalAttemptDate													datetime					NULL,
	ActualLethalityMedicalDamage											type_GlobalCode				NULL,
	PotentialLethality														type_GlobalCode				NULL,
	CONSTRAINT CustomDocumentMHColumbiaAdultSinceLastVisits_PK PRIMARY KEY CLUSTERED (DocumentVersionId)
)

IF OBJECT_ID('CustomDocumentMHColumbiaAdultSinceLastVisits') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentMHColumbiaAdultSinceLastVisits >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentMHColumbiaAdultSinceLastVisits >>>', 16, 1)

/* 
 * TABLE: CustomDocumentMHColumbiaAdultSinceLastVisits 
 */ 
     
ALTER TABLE CustomDocumentMHColumbiaAdultSinceLastVisits ADD CONSTRAINT DocumentVersions_CustomDocumentMHColumbiaAdultSinceLastVisits_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)

EXEC sys.sp_addextendedproperty 'CustomDocumentMHColumbiaAdultSinceLastVisits_Description'
	,'WishToBeDead column stores globalcode of category "XCSSRSYESNO"'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentMHColumbiaAdultSinceLastVisits'         
	,'column'
	,'WishToBeDead'

EXEC sys.sp_addextendedproperty 'CustomDocumentMHColumbiaAdultSinceLastVisits_Description'
	,'NonSpecificActiveSuicidalThoughts column stores globalcode of category "XCSSRSYESNO"'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentMHColumbiaAdultSinceLastVisits'         
	,'column'
	,'NonSpecificActiveSuicidalThoughts'

EXEC sys.sp_addextendedproperty 'CustomDocumentMHColumbiaAdultSinceLastVisits_Description'
	,'ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToAct column stores globalcode of category "XCSSRSYESNO"'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentMHColumbiaAdultSinceLastVisits'         
	,'column'
	,'ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToAct'

EXEC sys.sp_addextendedproperty 'CustomDocumentMHColumbiaAdultSinceLastVisits_Description'
	,'ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlan column stores globalcode of category "XCSSRSYESNO"'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentMHColumbiaAdultSinceLastVisits'         
	,'column'
	,'ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlan'	

EXEC sys.sp_addextendedproperty 'CustomDocumentMHColumbiaAdultSinceLastVisits_Description'
	,'AciveSuicidalIdeationWithSpecificPlanAndIntent column stores globalcode of category "XCSSRSYESNO"'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentMHColumbiaAdultSinceLastVisits'         
	,'column'
	,'AciveSuicidalIdeationWithSpecificPlanAndIntent'	

EXEC sys.sp_addextendedproperty 'CustomDocumentMHColumbiaAdultSinceLastVisits_Description'
	,'MostSevereIdeation column stores globalcode of category "XCSSRSCASLTSEVERE"'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentMHColumbiaAdultSinceLastVisits'         
	,'column'
	,'MostSevereIdeation'

EXEC sys.sp_addextendedproperty 'CustomDocumentMHColumbiaAdultSinceLastVisits_Description'
	,'ActualAttempt column stores globalcode of category "XCSSRSYESNO"'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentMHColumbiaAdultSinceLastVisits'         
	,'column'
	,'ActualAttempt'

EXEC sys.sp_addextendedproperty 'CustomDocumentMHColumbiaAdultSinceLastVisits_Description'
	,'HasSubjectEngagedInNonSuicidalSelfInjuriousBehavior column stores globalcode of category "XCSSRSYESNO"'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentMHColumbiaAdultSinceLastVisits'         
	,'column'
	,'HasSubjectEngagedInNonSuicidalSelfInjuriousBehavior'

EXEC sys.sp_addextendedproperty 'CustomDocumentMHColumbiaAdultSinceLastVisits_Description'
	,'HasSubjectEngagedInSelfInjuriousBehaviorIntentUnknown column stores globalcode of category "XCSSRSYESNO"'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentMHColumbiaAdultSinceLastVisits'         
	,'column'
	,'HasSubjectEngagedInSelfInjuriousBehaviorIntentUnknown'

EXEC sys.sp_addextendedproperty 'CustomDocumentMHColumbiaAdultSinceLastVisits_Description'
	,'InterruptedAttempt column stores globalcode of category "XCSSRSYESNO"'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentMHColumbiaAdultSinceLastVisits'         
	,'column'
	,'InterruptedAttempt'

EXEC sys.sp_addextendedproperty 'CustomDocumentMHColumbiaAdultSinceLastVisits_Description'
	,'AbortedOrSelfInterruptedAttempt column stores globalcode of category "XCSSRSYESNO"'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentMHColumbiaAdultSinceLastVisits'         
	,'column'
	,'AbortedOrSelfInterruptedAttempt'

EXEC sys.sp_addextendedproperty 'CustomDocumentMHColumbiaAdultSinceLastVisits_Description'
	,'PreparatoryActsOrBehavior column stores globalcode of category "XCSSRSYESNO"'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentMHColumbiaAdultSinceLastVisits'         
	,'column'
	,'PreparatoryActsOrBehavior'		

EXEC sys.sp_addextendedproperty 'CustomDocumentMHColumbiaAdultSinceLastVisits_Description'
	,'SuicidalBehavior column stores globalcode of category "XCSSRSYESNO"'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentMHColumbiaAdultSinceLastVisits'         
	,'column'
	,'SuicidalBehavior'
	
EXEC sys.sp_addextendedproperty 'CustomDocumentMHColumbiaAdultSinceLastVisits_Description'
	,'Frequency column stores globalcode of category "XCSSRSCASLTFREQUENCY"'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentMHColumbiaAdultSinceLastVisits'         
	,'column'
	,'Frequency'

EXEC sys.sp_addextendedproperty 'CustomDocumentMHColumbiaAdultSinceLastVisits_Description'
	,'ActualLethalityMedicalDamage column stores globalcode of category "XActualLethality"'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentMHColumbiaAdultSinceLastVisits'         
	,'column'
	,'ActualLethalityMedicalDamage'

EXEC sys.sp_addextendedproperty 'CustomDocumentMHColumbiaAdultSinceLastVisits_Description'
	,'PotentialLethality column stores globalcode of category "XPotentialLethality"'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentMHColumbiaAdultSinceLastVisits'         
	,'column'
	,'PotentialLethality'
									     
PRINT 'STEP 4(M) COMPLETED' 
END
Go

IF Not EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentSafetyCrisisPlans')
 BEGIN
/* 
 * TABLE: CustomDocumentSafetyCrisisPlans 
 */
CREATE TABLE CustomDocumentSafetyCrisisPlans(
	 DocumentVersionId 							int						  NOT NULL,
	 CreatedBy                                  type_CurrentUser          NOT NULL,
     CreatedDate                                type_CurrentDatetime      NOT NULL,
     ModifiedBy                                 type_CurrentUser          NOT NULL,
     ModifiedDate                               type_CurrentDatetime      NOT NULL,
     RecordDeleted                              type_YOrN                 NULL
												CHECK (RecordDeleted in ('N','Y')),
     DeletedBy                                  type_UserId               NULL,
     DeletedDate                                datetime                  NULL,
	 ProgramId									int						  NULL,
	 StaffId									int						  NULL,
     ClientHasCurrentCrisis						type_YOrN				  NULL
												CHECK (ClientHasCurrentCrisis in ('N','Y')),
     WarningSignsCrisis							type_Comment2			  NULL,
     CopingStrategies							type_Comment2			  NULL,
     ThreeMonths								type_YOrN				  NULL
												CHECK (ThreeMonths in ('N','Y')),
	 TwelveMonths								type_YOrN				  NULL
												CHECK (TwelveMonths in ('N','Y')),
	 DateOfCrisis								datetime				  NULL,
	 DOB										datetime				  NULL,
	 SignificantOther							varchar(100)			  NULL,
	 CurrentCrisisDescription					type_Comment2			  NULL,
	 CurrentCrisisSpecificactions				type_Comment2			  NULL,
	 InitialSafetyPlan							type_YOrN				  NULL
												CHECK (InitialSafetyPlan in ('Y','N')),
	 InitialCrisisPlan							type_YOrN				  NULL
												CHECK (InitialCrisisPlan in ('Y','N')),
	 SafetyPlanNotReviewed						type_YOrN				  NULL
												CHECK (SafetyPlanNotReviewed in ('Y','N')),
	 ReviewCrisisPlanXDays						int						  NULL,
	 NextCrisisPlanReviewDate					datetime				  NULL,
	 NextSafetyPlanInitialReviewDate			datetime				  NULL,
	 InitialSafetyReviewEveryXDays				int						  NULL,
	 CONSTRAINT CustomDocumentSafetyCrisisPlans_PK PRIMARY KEY CLUSTERED (DocumentVersionId)
)

  IF OBJECT_ID('CustomDocumentSafetyCrisisPlans') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentSafetyCrisisPlans >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentSafetyCrisisPlans >>>', 16, 1)

/* 
 * TABLE: CustomDocumentSafetyCrisisPlans 
 */   

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CustomDocumentSafetyCrisisPlans]') AND name = N'XIE1_CustomDocumentSafetyCrisisPlans')
  BEGIN
   CREATE NONCLUSTERED INDEX [XIE1_CustomDocumentSafetyCrisisPlans] ON [dbo].[CustomDocumentSafetyCrisisPlans] 
   (
   [ProgramId]  ASC
   )
   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomDocumentSafetyCrisisPlans') AND name='XIE1_CustomDocumentSafetyCrisisPlans')
   PRINT '<<< CREATED INDEX CustomDocumentSafetyCrisisPlans.XIE1_CustomDocumentSafetyCrisisPlans >>>'
   ELSE
   RAISERROR('<<< FAILED CREATING INDEX CustomDocumentSafetyCrisisPlans.XIE1_CustomDocumentSafetyCrisisPlans >>>', 16, 1)  
  END    

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CustomDocumentSafetyCrisisPlans]') AND name = N'XIE2_CustomDocumentSafetyCrisisPlans')
  BEGIN
   CREATE NONCLUSTERED INDEX [XIE2_CustomDocumentSafetyCrisisPlans] ON [dbo].[CustomDocumentSafetyCrisisPlans] 
   (
   [StaffId]  ASC
   )
   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomDocumentSafetyCrisisPlans') AND name='XIE2_CustomDocumentSafetyCrisisPlans')
   PRINT '<<< CREATED INDEX CustomDocumentSafetyCrisisPlans.XIE2_CustomDocumentSafetyCrisisPlans >>>'
   ELSE
   RAISERROR('<<< FAILED CREATING INDEX CustomDocumentSafetyCrisisPlans.XIE2_CustomDocumentSafetyCrisisPlans >>>', 16, 1)  
  END 
  
/* 
 * TABLE: CustomDocumentSafetyCrisisPlans 
 */ 
       
ALTER TABLE CustomDocumentSafetyCrisisPlans ADD CONSTRAINT DocumentVersions_CustomDocumentSafetyCrisisPlans_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)

ALTER TABLE CustomDocumentSafetyCrisisPlans ADD CONSTRAINT Programs_CustomDocumentSafetyCrisisPlans_FK
    FOREIGN KEY (ProgramId)
    REFERENCES Programs(ProgramId)

ALTER TABLE CustomDocumentSafetyCrisisPlans ADD CONSTRAINT Staff_CustomDocumentSafetyCrisisPlans_FK
    FOREIGN KEY (StaffId)
    REFERENCES Staff(StaffId)
    
     PRINT 'STEP 4(N) COMPLETED'
 END
Go

 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomSupportContacts')
BEGIN
/* 
 * TABLE: CustomSupportContacts 
 */
 CREATE TABLE CustomSupportContacts( 
		SupportContactId						int	 identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		DocumentVersionId						int					 NULL,
		ClientContactId							int					 NULL,
		Name									varchar(200)		 NULL,
		Relationship							varchar(200)		 NULL,
		[Address]								type_Comment2		 NULL,
		Phone									type_PhoneNumber	 NULL,
		CONSTRAINT CustomSupportContacts_PK PRIMARY KEY CLUSTERED (SupportContactId)
)

  IF OBJECT_ID('CustomSupportContacts') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomSupportContacts >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomSupportContacts >>>', 16, 1)

/* 
 * TABLE: CustomSupportContacts 
 */   

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CustomSupportContacts]') AND name = N'XIE1_CustomSupportContacts')
  BEGIN
   CREATE NONCLUSTERED INDEX [XIE1_CustomSupportContacts] ON [dbo].[CustomSupportContacts] 
   (
   [DocumentVersionId]  ASC
   )
   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomSupportContacts') AND name='XIE1_CustomSupportContacts')
   PRINT '<<< CREATED INDEX CustomSupportContacts.XIE1_CustomSupportContacts >>>'
   ELSE
   RAISERROR('<<< FAILED CREATING INDEX CustomSupportContacts.XIE1_CustomSupportContacts >>>', 16, 1)  
  END    

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CustomSupportContacts]') AND name = N'XIE2_CustomSupportContacts')
  BEGIN
   CREATE NONCLUSTERED INDEX [XIE2_CustomSupportContacts] ON [dbo].[CustomSupportContacts] 
   (
   [ClientContactId]  ASC
   )
   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomSupportContacts') AND name='XIE2_CustomSupportContacts')
   PRINT '<<< CREATED INDEX CustomSupportContacts.XIE2_CustomSupportContacts >>>'
   ELSE
   RAISERROR('<<< FAILED CREATING INDEX CustomSupportContacts.XIE2_CustomSupportContacts >>>', 16, 1)  
  END
  
/* 
 * TABLE: CustomSupportContacts 
 */
   
ALTER TABLE CustomSupportContacts ADD CONSTRAINT DocumentVersions_CustomSupportContacts_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)  
     
ALTER TABLE CustomSupportContacts ADD CONSTRAINT ClientContacts_CustomSupportContacts_FK
    FOREIGN KEY (ClientContactId)
    REFERENCES ClientContacts(ClientContactId)
    
     PRINT 'STEP 4(O) COMPLETED'
 END
Go

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomSafetyCrisisPlanReviews')
BEGIN
/* 
 * TABLE: CustomSafetyCrisisPlanReviews 
 */
 CREATE TABLE CustomSafetyCrisisPlanReviews( 
		SafetyCrisisPlanReviewId				int	identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		DocumentVersionId						int					 NULL,
		SafetyCrisisPlanReviewed				type_YOrN			 NULL
												CHECK (SafetyCrisisPlanReviewed in ('Y','N')),
		DateReviewed							datetime			 NULL,
		ReviewEveryXDays						int					 NULL,
		DescribePlanReview						type_Comment2		 NULL,
		CrisisDisposition						type_Comment2		 NULL,
		CrisisResolved							type_YOrN			 NULL
												CHECK (CrisisResolved in ('Y','N')),
		NextSafetyPlanReviewDate				datetime			 NULL,
		PreviousDate							type_YOrN			 NULL
												CHECK (PreviousDate in ('Y','N')),
		CONSTRAINT CustomSafetyCrisisPlanReviews_PK PRIMARY KEY CLUSTERED (SafetyCrisisPlanReviewId)
)

 IF OBJECT_ID('CustomSafetyCrisisPlanReviews') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomSafetyCrisisPlanReviews >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomSafetyCrisisPlanReviews >>>', 16, 1)

/* 
 * TABLE: CustomSafetyCrisisPlanReviews 
 */   

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CustomSafetyCrisisPlanReviews]') AND name = N'XIE1_CustomSafetyCrisisPlanReviews')
  BEGIN
   CREATE NONCLUSTERED INDEX [XIE1_CustomSafetyCrisisPlanReviews] ON [dbo].[CustomSafetyCrisisPlanReviews] 
   (
   [DocumentVersionId]  ASC
   )
   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomSafetyCrisisPlanReviews') AND name='XIE1_CustomSafetyCrisisPlanReviews')
   PRINT '<<< CREATED INDEX CustomSafetyCrisisPlanReviews.XIE1_CustomSafetyCrisisPlanReviews >>>'
   ELSE
   RAISERROR('<<< FAILED CREATING INDEX CustomSafetyCrisisPlanReviews.XIE1_CustomSafetyCrisisPlanReviews >>>', 16, 1)  
  END    
  
/* 
 * TABLE: CustomSafetyCrisisPlanReviews 
 */   

ALTER TABLE CustomSafetyCrisisPlanReviews ADD CONSTRAINT DocumentVersions_CustomSafetyCrisisPlanReviews_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)   
  
  PRINT 'STEP 4(P) COMPLETED'
 END
Go

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomCrisisPlanMedicalProviders')
BEGIN
/* 
 * TABLE: CustomCrisisPlanMedicalProviders 
 */
 CREATE TABLE CustomCrisisPlanMedicalProviders( 
		CrisisPlanMedicalProviderId				int	identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		DocumentVersionId                       int					 NULL,
		Name									varchar(50)			 NULL,
		AddressType								type_GlobalCode		 NULL,
		[Address]								varchar(150)		 NULL,
		Phone									type_PhoneNumber	 NULL,
		CONSTRAINT CustomCrisisPlanMedicalProviders_PK PRIMARY KEY CLUSTERED (CrisisPlanMedicalProviderId)
)

IF OBJECT_ID('CustomCrisisPlanMedicalProviders') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomCrisisPlanMedicalProviders >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomCrisisPlanMedicalProviders >>>', 16, 1)

/* 
 * TABLE: CustomCrisisPlanMedicalProviders 
 */   

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CustomCrisisPlanMedicalProviders]') AND name = N'XIE1_CustomCrisisPlanMedicalProviders')
  BEGIN
   CREATE NONCLUSTERED INDEX [XIE1_CustomCrisisPlanMedicalProviders] ON [dbo].[CustomCrisisPlanMedicalProviders] 
   (
   [DocumentVersionId]  ASC
   )
   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomCrisisPlanMedicalProviders') AND name='XIE1_CustomCrisisPlanMedicalProviders')
   PRINT '<<< CREATED INDEX CustomCrisisPlanMedicalProviders.XIE1_CustomCrisisPlanMedicalProviders >>>'
   ELSE
   RAISERROR('<<< FAILED CREATING INDEX CustomCrisisPlanMedicalProviders.XIE1_CustomCrisisPlanMedicalProviders >>>', 16, 1)  
  END    
  
/* 
 * TABLE: CustomCrisisPlanMedicalProviders 
 */   

ALTER TABLE CustomCrisisPlanMedicalProviders ADD CONSTRAINT DocumentVersions_CustomCrisisPlanMedicalProviders_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)   
	  
  PRINT 'STEP 4(Q) COMPLETED'
 END
Go

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomCrisisPlanNetworkProviders')
BEGIN
/* 
 * TABLE: CustomCrisisPlanNetworkProviders 
 */
 CREATE TABLE CustomCrisisPlanNetworkProviders( 
		CrisisPlanNetworkProviderId				int	identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		DocumentVersionId                       int					 NULL,
		Name									varchar(50)			 NULL,
		AddressType								type_GlobalCode		 NULL,
		[Address]								varchar(150)		 NULL,
		Phone									type_PhoneNumber	 NULL,
		CONSTRAINT CustomCrisisPlanNetworkProviders_PK PRIMARY KEY CLUSTERED (CrisisPlanNetworkProviderId)
)

IF OBJECT_ID('CustomCrisisPlanNetworkProviders') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomCrisisPlanNetworkProviders >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomCrisisPlanNetworkProviders >>>', 16, 1)

/* 
 * TABLE: CustomCrisisPlanNetworkProviders 
 */ 
 
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CustomCrisisPlanNetworkProviders]') AND name = N'XIE1_CustomCrisisPlanNetworkProviders')
  BEGIN
   CREATE NONCLUSTERED INDEX [XIE1_CustomCrisisPlanNetworkProviders] ON [dbo].[CustomCrisisPlanNetworkProviders] 
   (
   [DocumentVersionId]  ASC
   )
   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomCrisisPlanNetworkProviders') AND name='XIE1_CustomCrisisPlanNetworkProviders')
   PRINT '<<< CREATED INDEX CustomCrisisPlanNetworkProviders.XIE1_CustomCrisisPlanNetworkProviders >>>'
   ELSE
   RAISERROR('<<< FAILED CREATING INDEX CustomCrisisPlanNetworkProviders.XIE1_CustomCrisisPlanNetworkProviders >>>', 16, 1)  
  END  
  
/* 
 * TABLE: CustomCrisisPlanNetworkProviders 
 */   

ALTER TABLE CustomCrisisPlanNetworkProviders ADD CONSTRAINT DocumentVersions_CustomCrisisPlanNetworkProviders_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)  
     
  PRINT 'STEP 4(R) COMPLETED'
 END
 Go

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentPrePlanningWorksheet')
BEGIN
/* 
 * TABLE: CustomDocumentPrePlanningWorksheet 
 */
 CREATE TABLE CustomDocumentPrePlanningWorksheet( 
		DocumentVersionId						int					 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		IndividualName							varchar(110)		 NULL,
		DOB										datetime			 NULL,
		CaseNumber								varchar(10)			 NULL,
		DateOfPrePlan							datetime			 NULL,
		DreamsAndDesires						varchar(max)		 NULL,
		HowServicesCanHelp						varchar(max)		 NULL,
		LivingArrangements						type_YOrN			 NULL
												CHECK (LivingArrangements in ('Y','N')),
		LivingArragementsComment				varchar(max)		 NULL,
		MyRelationships							type_YOrN			 NULL
												CHECK (MyRelationships in ('Y','N')),
		RelationshipsComment					varchar(max)		 NULL,
		CommunityInvolvment						type_YOrN			 NULL
												CHECK (CommunityInvolvment in ('Y','N')),
		CommunityComment						varchar(max)		 NULL,
		Wellness								type_YOrN			 NULL
												CHECK (Wellness in ('Y','N')),
		WellnessComment							varchar(max)		 NULL,
		Education								type_YOrN			 NULL
												CHECK (Education in ('Y','N')),
		EducationComment						varchar(max)		 NULL,
		Employment								type_YOrN			 NULL
												CHECK (Employment in ('Y','N')),
		EmploymentComment						varchar(max)		 NULL,
		Legal									type_YOrN			 NULL
												CHECK (Legal in ('Y','N')),
		LegalComment							varchar(max)		 NULL,
		Other									type_YOrN			 NULL
												CHECK (Other in ('Y','N')),
		OtherComment							varchar(max)		 NULL,
		AdditionalComments1						varchar(max)		 NULL,
		PrePlanProcessExplained					type_YOrN			 NULL
												CHECK (PrePlanProcessExplained in ('Y','N')),
		SelfDExplained							type_YOrN			 NULL
												CHECK (SelfDExplained in ('Y','N')),
		WantToExploreSelfD						type_YOrNOrNA		 NULL
												CHECK (WantToExploreSelfD in ('Y','N','A')),
		CommentsPCPOrSD							varchar(max)		 NULL,
		ImportantToTalkAbout					varchar(max)		 NULL,
		ImportantToNotTalkAbout					varchar(max)		 NULL,
		WHSIssuesToTalkAbout					varchar(max)		 NULL,
		ServicesToDiscussAtMeeting				varchar(max)		 NULL,
		ServiceProviderOptions					varchar(max)		 NULL,
		PeopleInvitedToMeeting					varchar(max)		 NULL,
		PeopleNotInivtedToMeeting				varchar(max)		 NULL,
		MeetingLocation							varchar(1000)		 NULL,
		MeetingDate								datetime			 NULL,
		MeetingTime								varchar(10)			 NULL,
		UnderstandPersonOfChoice				type_YOrN			 NULL
												CHECK (UnderstandPersonOfChoice in ('Y','N')),
		OIFExplained							type_YOrN			 NULL
												CHECK (OIFExplained in ('Y','N')),
		HelpRunMeeting							varchar(1000)		 NULL,
		TakeNotesMeeting						varchar(1000)		 NULL,
		ChoseNotToParticipate					type_YOrN			 NULL
												CHECK (ChoseNotToParticipate in ('Y','N')),
		AlternativeManner						varchar(max)		 NULL,
		AdditionalComments2						varchar(max)		 NULL,
		SeparateDocumentRequired				type_YOrN			 NULL
												CHECK (SeparateDocumentRequired in ('Y','N')),												
		CONSTRAINT CustomDocumentPrePlanningWorksheet_PK PRIMARY KEY CLUSTERED (DocumentVersionId)
)

IF OBJECT_ID('CustomDocumentPrePlanningWorksheet') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentPrePlanningWorksheet >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentPrePlanningWorksheet >>>', 16, 1)
  
/* 
 * TABLE: CustomDocumentPrePlanningWorksheet 
 */   

ALTER TABLE CustomDocumentPrePlanningWorksheet ADD CONSTRAINT DocumentVersions_CustomDocumentPrePlanningWorksheet_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)  
     
  PRINT 'STEP 4(S) COMPLETED'
 END
 Go

---- END Of STEP 4 -------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF NOT EXISTS (SELECT [key] FROM SystemConfigurationKeys WHERE [key] = 'CDM_MHAssessment')
	BEGIN
		INSERT INTO [dbo].[SystemConfigurationKeys]
				   (CreatedBy
				   ,CreateDate 
				   ,ModifiedBy
				   ,ModifiedDate
				   ,[Key]
				   ,Value
				   )
			 VALUES    
				   ('SHSDBA'
				   ,GETDATE()
				   ,'SHSDBA'
				   ,GETDATE()
				   ,'CDM_MHAssessment'
				   ,'1.0'
				   )
				   
 PRINT 'STEP 7 COMPLETED'            
END
Go

