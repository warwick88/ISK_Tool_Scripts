----- STEP 1 ----------

------ STEP 2 ----------

--Part1 Begin

--Part1 Ends

--Part2 Begins

--Part2 Ends

-----End of Step 2 -------

------ STEP 3 ------------

------ END OF STEP 3 -----

------ STEP 4 ----------
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
    
PRINT 'STEP 4(A) COMPLETED'
END

--END Of STEP 4 ------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF NOT EXISTS (SELECT [key] FROM SystemConfigurationKeys WHERE  [key] = 'CDM_MentalStatusExamDFA')
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
				   ,'CDM_MentalStatusExamDFA'
				   ,'1.0'
				   )  

PRINT 'STEP 7 COMPLETED'
END
Go
