/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentMentalStatusExams]    Script Date: 07/24/2015 10:40:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentMentalStatusExams]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentMentalStatusExams]
GO

CREATE PROCEDURE [dbo].[csp_RDLCustomDocumentMentalStatusExams] 
@DocumentVersionId INT    
AS    
/*********************************************************************/       
/* Date				Author        Purpose						     */ 
/*11/21/2019		Packia		  To retrieve data for Mental Status Exam.Gold #22*/             
/*********************************************************************/   
BEGIN    
 BEGIN TRY 
DECLARE @OrganizationName VARCHAR(250)
		DECLARE @ClientName VARCHAR(100)
		DECLARE @ClinicianName VARCHAR(100)
		DECLARE @ClientID INT
		DECLARE @EffectiveDate VARCHAR(10)
		DECLARE @DOB VARCHAR(10)
		DECLARE @DocumentName  VARCHAR(100)
		DECLARE @Age varchar(10) 
		SELECT TOP 1 @OrganizationName = OrganizationName
		FROM SystemConfigurations
		 
		SELECT @ClientName = C.LastName + ', ' + C.FirstName
			,@ClinicianName = S.LastName + ', ' + S.FirstName + ' ' + isnull(GC.CodeName, '')
			,@ClientID = Documents.ClientID
			,@EffectiveDate = CASE 
				WHEN Documents.EffectiveDate IS NOT NULL
					THEN CONVERT(VARCHAR(10), Documents.EffectiveDate, 101)
				ELSE ''
				END
			,@DOB = CASE 
				WHEN C.DOB IS NOT NULL
					THEN CONVERT(VARCHAR(10), C.DOB, 101)
				ELSE ''
				END
			,@DocumentName = DocumentCodes.DocumentName 
		FROM Documents
		JOIN Staff S ON Documents.AuthorId = S.StaffId
		JOIN Clients C ON Documents.ClientId = C.ClientId
			AND isnull(C.RecordDeleted, 'N') <> 'Y'
		JOIN DocumentVersions dv ON dv.DocumentId = documents.DocumentId
		INNER JOIN DocumentCodes on DocumentCodes.DocumentCodeid= Documents.DocumentCodeId      
			AND ISNULL(DocumentCodes.RecordDeleted,'N')='N' 
		LEFT JOIN GlobalCodes GC ON S.Degree = GC.GlobalCodeId
		WHERE dv.DocumentVersionId = @DocumentVersionId
			AND isnull(Documents.RecordDeleted, 'N') = 'N'

	   
 SELECT @OrganizationName AS OrganizationName
			,@DocumentName AS DocumentName
			,@ClientName AS ClientName
			,@ClinicianName AS ClinicianName
			,@ClientID AS ClientID
			,@EffectiveDate AS EffectiveDate
			,@DOB AS DOB
			,dbo.[GetAge](@DOB, GETDATE()) AS AGE  
             ,DocumentVersionId
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedBy
			,DeletedDate
			,GeneralAppearance
			,GeneralPoorlyAddresses
			,GeneralPoorlyGroomed
			,GeneralDisheveled
			,GeneralOdferous
			,GeneralDeformities
			,GeneralPoorNutrion
			,GeneralRestless
			,GeneralPsychometer
			,GeneralHyperActive
			,GeneralEvasive
			,GeneralInAttentive
			,GeneralPoorEyeContact
			,GeneralHostile
			,GeneralAppearanceOthers
			,GeneralAppearanceOtherComments
			,Speech
			,SpeechIncreased
			,SpeechDecreased
			,SpeechPaucity
			,SpeechHyperverbal
			,SpeechPoorArticulations
			,SpeechLoud
			,SpeechSoft
			,SpeechMute
			,SpeechStuttering
			,SpeechImpaired
			,SpeechPressured
			,SpeechFlight
			,SpeechOthers
			,SpeechOtherComments
			,PsychiatricNoteExamLanguage
			,LanguageDifficultyNaming
			,LanguageDifficultyRepeating
			,LanguageOthers
			,LanguageOtherComments
			,MoodAndAffect
			,MoodHappy
			,MoodSad
			,MoodAnxious
			,MoodAngry
			,MoodIrritable
			,MoodElation
			,MoodNormal
			,MoodOthers
			,MoodOtherComments
			,AffectEuthymic
			,AffectDysphoric
			,AffectAnxious
			,AffectIrritable
			,AffectBlunted
			,AffectLabile
			,AffectEuphoric
			,AffectCongruent
			,AffectOthers
			,AffectOtherComments
			,AttensionSpanAndConcentration
			,AttensionPoorConcentration
			,AttensionPoorAttension
			,AttensionDistractible
			,AttentionSpanOthers
			,AttentionSpanOtherComments
			,ThoughtContentCognision
			,TPDisOrganised
			,TPBlocking
			,TPPersecution
			,TPBroadCasting
			,TPDetrailed
			,TPThoughtInsertion
			,TPIncoherent
			,TPRacing
			,TPIllogical
			,ThoughtProcessOthers
			,ThoughtProcessOtherComments
			,TCDelusional
			,TCParanoid
			,TCIdeas
			,TCThoughtInsertion
			,TCThoughtWithdrawal
			,TCThoughtBroadcasting
			,TCReligiosity
			,TCGrandiosity
			,TCPerserveration
			,TCObsessions
			,TCWorthlessness
			,TCLoneliness
			,TCGuilt
			,TCHopelessness
			,TCHelplessness
			,ThoughtContentOthers
			,ThoughtContentOtherComments
			,CAConcrete
			,CAUnable
			,CAPoorComputation
			,CognitiveAbnormalitiesOthers
			,CognitiveAbnormalitiesOtherComments
			,Associations
			,AssociationsLoose
			,AssociationsClanging
			,AssociationsWordsalad
			,AssociationsCircumstantial
			,AssociationsTangential
			,AssociationsOthers
			,AssociationsOtherComments
			,AbnormalorPsychoticThoughts
			,PsychosisOrDisturbanceOfPerception
			,PDAuditoryHallucinations
			,PDVisualHallucinations
			,PDCommandHallucinations
			,PDDelusions
			,PDPreoccupation
			,PDOlfactoryHallucinations
			,PDGustatoryHallucinations
			,PDTactileHallucinations
			,PDSomaticHallucinations
			,PDIllusions
			,AbnormalPsychoticOthers
			,AbnormalPsychoticOthersComments
			,PDCurrentSuicideIdeation
			,PDCurrentSuicidalPlan
			,PDCurrentSuicidalIntent
			,PDMeansToCarry
			,PDCurrentHomicidalIdeation
			,PDCurrentHomicidalPlans
			,PDCurrentHomicidalIntent
			,PDMeansToCarryNew
			,Orientation
			,OrientationPerson
			,OrientationPlace
			,OrientationTime
			,OrientationSituation
			,OrientationOthers
			,OrientationOtherComments
			,FundOfKnowledge
			,FundOfKnowledgeCurrentEvents
			,FundOfKnowledgePastHistory
			,FundOfKnowledgeVocabulary
			,FundOfKnowledgeOthers
			,FundOfKnowledgeOtherComments
			,FundEvidenceVocabulary
			,FundEvidenceKnowledge
			,FundEvidenceResponses
			,FundEvidenceSchool
			,FundEvidenceIQ
			,FundEvidenceOthers
			,FundEvidenceOtherComments
			,InsightAndJudgement
			,InsightAndJudgementStatus
			,InsightAndJudgementSubstance
			,InsightAndJudgementOthers
			,InsightAndJudgementOtherComments
			,InsightEvidenceAwareness
			,InsightEvidenceAcceptance
			,InsightEvidenceUnderstanding
			,InsightEvidenceSelfDefeating
			,InsightEvidenceDenial
			,InsightEvidenceOthers
			,InsightEvidenceOtherComments
			,Memory
			,MemoryImmediate
			,MemoryRecent
			,MemoryRemote
			,MemoryOthers
			,MemoryOtherComments
			,MuscleStrengthorTone
			,MuscleStrengthorToneAtrophy
			,MuscleStrengthorToneAbnormal
			,MuscleStrengthOthers
			,MuscleStrengthOtherComments
			,GaitandStation
			,GaitandStationRestlessness
			,GaitandStationStaggered
			,GaitandStationShuffling
			,GaitandStationUnstable
			,GaitAndStationOthers
			,GaitAndStationOtherComments
			,MentalStatusComments
			,ReviewWithChanges
			,LanguageNonVerbal
			,OrientationDescribeSituation
			,OrientationFullName
			,OrientationFullDate
			,MemoryImmediateEvidencedBy
			,MemoryRecentEvidencedBy
			,MemoryRemoteEvidencedBy
			,OrientationEvidencedPlace
		FROM CustomDocumentMentalStatusExams
		WHERE DocumentVersionId = @DocumentVersionId
			AND ISNULL(RecordDeleted, 'N') = 'N'  
  
 END TRY    
    
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)    
    
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLCustomDocumentMentalStatusExams') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())    
    
  RAISERROR (    
    @Error    
    ,-- Message text.    
    16    
    ,-- Severity.    
    1 -- State.    
    );    
 END CATCH    
END    