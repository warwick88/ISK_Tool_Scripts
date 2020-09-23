USE [ISKzooSmartCareQA]
GO

/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomAcuteServicesPrescreen]    Script Date: 9/3/2020 9:16:47 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO











  
CREATE PROCEDURE [dbo].[csp_ValidateCustomAcuteServicesPrescreen]
@DocumentVersionId Int      
      
as      
SET NOCOUNT ON    
/******************************************************************************    
**  Change History    
*******************************************************************************    
  Date:  Author:    Description:    
  --------  -------- -------------------------------------------    
  11-04-2012   #134  Pralyankars  Added Validation Conditions
  2020-07-17  esova  removed TON of validations, added call to ICD10 validation
  2020-07-20  esova  removed primary care physician phone# added summary checkbox count
                     removed provider recommended required, removed currentproviderlastseen
					 changed consumeravailable <= servicedate
*******************************************************************************/  


DECLARE @ServiceId  int
SELECT 
     @ServiceId = ISNULL(d.ServiceId,0)
FROM documents d 
WHERE 
     d.CurrentDocumentVersionId = @DocumentVersionId 
     AND ISNULL(recordDeleted,'N') <> 'Y' 
--Pralyankars 11/04/2012 Declare and Initialize Service Variables.
DECLARE @DateTimeOut datetime, @DateOfService datetime
SELECT 
     @DateOfService = ISNULL(s.DateOfService,'1/1/1900'),
     @DateTimeOut = ISNULL(s.DateTimeOut,'1/1/1900')
FROM Services s 
WHERE 
     s.ServiceId = @ServiceId 
     AND ISNULL(recordDeleted,'N') <> 'Y'       
print @dateofservice
print @dateTimeOut

---------------------End Validation Conditions----------------------------------      
--*TABLE CREATE*--      
CREATE TABLE #CustomAcuteServicesPrescreens (      
DocumentVersionId int,      
DateOfPrescreen datetime,      
InitialCallTime datetime,      
ClientAvailableTimeForScreen datetime,      
DispositionTime datetime,      
ElapsedHours int,      
ElapsedMinutes int,
DateOfService datetime,
DateTimeOut datetime,
CMHStatus char(1),      
CMHStatusPrimaryClinician int,      
CMHCaseNumber varchar(MAX),      
ClientName varchar(MAX),      
ClientEthnicity char(2),      
ClientSex char(2),      
ClientMaritalStatus char(2),      
ClientSSN varchar(9),      
ClientDateOfBirth datetime,      
ClientAddress varchar(100),      
ClientCity varchar(30),      
ClientState varchar(max),      
ClientZip varchar(max),      
ClientCounty varchar(max),      
ClientHomePhone varchar(50),      
ClientEmergencyContact varchar(MAX),      
ClientRelationship int,      
ClientEmergencyPhone varchar(50),      
ClientGuardianName varchar(MAX),      
ClientGuardianPhone varchar(50),      
PaymentSourceIndigent char(1),      
PaymentSourcePrivate char(1),      
PaymentSourcePrivateEmployer varchar(MAX),      
PaymentSourcePrivateNumber varchar(MAX),      
PaymentSourceMedicare char(1),      
PaymentSourceMedicareNumber varchar(MAX),      
PaymentSourceMedicaid char(1),      
PaymentSourceMedicaidNumber varchar(MAX),      
PaymentSourceMedicaidType varchar(MAX),      
PaymentMedicaidOtherCounty varchar(max),      
PaymentSourceVA char(1),      
PaymentSourceOther char(1),      
PaymentSourceOtherDescribe varchar(MAX),      
PaymentMedicaidVerified char(1),      
ServiceRequested varchar(max),      
ClientRecentLocation varchar(max),      
ClientBelongingsLocation varchar(max),      
ClientMailLocation varchar(max),      
ClientReturnLocation varchar(max),      
ClientFromDifferentCounty varchar(max),      
ClientPriorLivingArrangement varchar(max),      
ClientIsWardofState varchar(max),      
ClientIsWardofStateCountyDetail varchar(max),      
COFRAdditionalInformation varchar(max),      
COFROtherCountyDetail varchar(max),      
ReferralSourceName varchar(MAX),      
ReferralSourcePhoneLocation varchar(MAX),      
ReferralSourceContacted char(1),      
ReferralSourceContactedExplain varchar(max),      
ReferralSourceJailLiason char(1),      
ReferralSourceFamilyMember char(1),      
ReferralSourcePhysician char(1),      
ReferralSourceMHProvider char(1),      
ReferralSourcePetitioned char(1),      
ReferralSourceOther char(1),      
ReferralSourceOtherSpecify varchar(MAX),      
ReferralContactTypeFaceToFace char(1),      
ReferralContactTypePhone char(1),      
ReferralContactTypePreBooking char(1),      
ReferralContactTypePostBooking char(1),      
ReferralPrecipitatingEvents varchar(max),      
RiskOthersAAgressiveWithin24Hours char(1),      
RiskOthersAgressivePast48Hours char(1),      
RiskOthersAgressiveWithinPast4Weeks char(1),      
RiskOthersCurrentHomicidalIdeation char(1),      
RiskOthersCurrentHomicidalActive char(1),      
RiskOthersCurrentHomicidalWithin48Hours char(1),      
RiskOthersCurrentHomicidalWithin14Days char(1),      
RiskOthersAWOL char(1),      
RiskOthersVerbal char(1),      
RiskOthersPhysical char(1),      
RiskOthersSexualActingOut char(1),      
RiskOthersDestructionOfProperty char(1),      
RiskOthersHasPlan char(1),      
RiskOthersHasPlanDescribe varchar(max),      
RiskOthersAccessToMeans char(1),      
RiskOthersAccessToMeansDescribe varchar(max),      
RiskOthersVerbalDescribe varchar(max),      
RiskOthersPhysicalDescribe varchar(max),      
RiskOthersSexualActingOutDescribe varchar(max),      
RiskOthersDestructionOfPropertyDescribe varchar(max),      
RiskOthersHistory varchar(max),      
RiskOthersChargesPending char(1),      
RiskOthersChargesPendingDescribe varchar(max),      
RiskOthersJailHold char(1),      
RiskSelfCurrentSuicidalIdeation char(1),      
RiskSelfCurrentSuicidalActive char(1),      
RiskSelfCurrentSuicidalWithin48Hours char(1),      
RiskSelfCurrentSuicidalWithin14Days char(1),      
RiskSelfHasPlan char(1),      
RiskSelfHasPlanDescribe varchar(max),      
RiskSelfEgoSyntonic char(1),      
RiskSelfEgoDystonic char(1),      
RiskSelfEgoDescribe varchar(max),      
RiskSelfAccessToMeans char(1),      
RiskSelfAccessToMeansDescribe varchar(max),      
RiskSelfCurrentSelfHarm char(1),      
RiskSelfCurrentSelfHarmDescribe varchar(max),      
RiskSelfCurrentSelfHarmOutcome varchar(max),      
RiskSelfPreviousSelfHarm char(1),      
RiskSelfPreviousSelfHarmDescribe varchar(max),      
RiskSelfPreviousSelfHarmOutcomes varchar(max),      
RiskSelfFamilySuicideHistory varchar(max),      
MentalStatusOrientaionPerson char(1),      
MentalStatusOrientaionPlace char(1),      
MentalStatusOrientaionTime char(1),      
MentalStatusOrientaionCircumstance char(1),      
MentalStatusLOCAlert char(1),      
MentalStatusLOCSedate char(1),      
MentalStatusLOCLethargic char(1),      
MentalStatusLOCObtunded char(1),      
MentalStatusLOCOther char(1),      
MentalStatusLOCOtherDescribe varchar(max),      
MentaStatusMoodAppropriate char(1),      
MentaStatusMoodIncongruent char(1),      
MentaStatusMoodHostile char(1),      
MentaStatusMoodTearful char(1),      
MentaStatusMoodOther char(1),      
MentaStatusMoodOtherDescribe varchar(max),      
MentaStatusAffectRestricted char(1),      
MentaStatusAffectUnremarkable char(1),      
MentaStatusAffectExpansive char(1),      
MentaStatusAffectOther char(1),      
MentaStatusAffectOtherDescribe varchar(max),      
MentaStatusThoughtLucid char(1),      
MentaStatusThoughtSuspicious char(1),      
MentaStatusThoughtObsessive char(1),      
MentaStatusThoughtObsessiveAbout varchar(max),      
MentaStatusThoughtTangential char(1),      
MentaStatusThoughtLoose char(1),      
MentaStatusThoughtDelusional char(1),      
MentaStatusThoughtPsychosis char(1),      
MentaStatusThoughtImpoverished char(1),      
MentaStatusThoughtConfused char(1),      
MentaStatusSpeechClear char(1),      
MentaStatusSpeechRapid char(1),      
MentaStatusSpeechSlurred char(1),      
MentaStatusJudgementImpaired char(1),      
MentaStatusJudgementImpairedDescribe varchar(max),      
MentalStatusImpulsivityApparent char(1),      
MentalStatusImpulsivityApparentDescribe varchar(max),      
MentalStatusInsightLimited char(1),      
MentalStatusInsightLimitedDescribe varchar(max),      
MentalStatusPxWithGrooming char(1),      
MentalStatusSleepDisturbance char(1),      
MentalStatusSleepDisturbanceDescribe varchar(max),      
MentalStatusEatingDisturbance char(1),      
MentalStatusEatingDisturbanceLbs int,      
MentalStatusNotMedicationComplaint char(1),      
SUCurrentUse char(1),      
SUOdorOfSubstance char(1),      
SUSlurredSpeech char(1),      
SUWithdrawalSymptoms char(1),      
SUDTOther char(1),      
SUOtherDescribe varchar(MAX),      
SUBlackOuts char(1),      
SURelatedArrests char(1),      
SURelatedSocialProblems char(1),      
SUFrequentAbsences char(1),      
SUCurrentTreatment char(1),      
SUCurrentTreatmentProvider varchar(MAX),      
SUProviderContactNumber varchar(MAX),      
SUHistory char(1),      
SUHistorySpecify varchar(max),      
SUPreviousTreatment char(1),      
SUReferralToSA char(1),      
SUWhereReferred varchar(MAX),      
SUNotReferredBecause varchar(max),      
SUToxicologyResults varchar(max),      
HHMentalHealthUnableToObtain char(1),      
HHNumberOfIPPsychHospitalizations int,      
HHMostRecentIPHospitalizationDate datetime,      
HHMostRecentIPHospitalizationFacility varchar(MAX),      
HHPreviousOPPsychTreatment char(1),      
HHOPPsychUnableToObtain char(1),      
HHTypeOfService varchar(MAX),      
HHCurrentProviderAndCredentials varchar(MAX),      
HHProviderCredentialsUnableToObtain char(1),      
HHDateLastSeenByCurrentProvider datetime,      
HHPrimaryCareProvider varchar(MAX),      
HHPrimaryCareProviderPhone varchar(MAX),      
HHNoPrimaryCarePhysician char(1),      
HHAllergies varchar(max),      
HHCurrentHealthConcerns varchar(max),      
HHPreviousHealthConcerns varchar(max),      
SIPsychiatricSymptoms char(2),      
SIPossibleHarmToSelf char(2),      
SIPossibleHarmToOthers char(2),      
SIMedicationDrugComplications char(2),      
SIDisruptionOfSelfCareAbilities char(2),      
SIImpairedPersonalAdjustment char(2),      
SIIntensityOfService char(1),      
SummaryVoluntary char(1),      
SummaryInvoluntary char(1),      
SummaryInpatientFacilityName varchar(MAX),      
AuthorizedDays int,      
SummaryCrisisResidential char(1),      
SummaryCrisisFacilityName varchar(MAX),      
SummaryPartialHospitalization char(1),      
SummaryPartialFacilityName varchar(MAX),      
SummaryACT char(1),      
SummaryCaseManagement char(1),      
SummaryIOP char(1),      
SummaryOutpatient char(1),      
SummarySubstanceAbuse char(1),      
SummaryOther char(1),      
SummaryOtherSpecify varchar(MAX),      
SummaryProviderRecommended varchar(MAX),      
SummaryFamilyNotificationOffered char(1),      
SummaryFamilyMemberName varchar(MAX),      
SummaryInpatientRequestedAndDenied char(1),      
SummarySecondOpinionRights char(1),      
SummaryOfferedAlternativeServices char(1),      
SummaryAlternativeServicesSpecify varchar(MAX),      
SummaryAgreedToAlternativeServices char(1),      
SummaryAlternativeAppointmentTime datetime,      
SummaryAlternativeAgencyName varchar(MAX),      
SummaryAlternativeAgencyContactNumber varchar(MAX),      
SummaryChooseOtherPlan char(1),      
SummaryChooseOtherPlanSpecify varchar(MAX),      
SummaryMedicaidRights char(1),      
SummaryMedicaidRightsWhyNot varchar(MAX),      
SummaryRefusedTreatment char(1),      
SummaryNoServicesNeeded char(1),      
SummaryUnableToObtainSignature char(1),      
SummaryUnableToObtainSignatureReason varchar(MAX),      
ClientSignedPaperCopy char(1),      
SummarySummary varchar(max),      
)      
      
--*INSERT LIST*--      
INSERT INTO #CustomAcuteServicesPrescreens (      
DocumentVersionId,       
DateOfPrescreen,       
InitialCallTime,       
ClientAvailableTimeForScreen,       
DispositionTime,       
ElapsedHours,       
ElapsedMinutes, 
DateOfService,
DateTimeOut,
CMHStatus,       
CMHStatusPrimaryClinician,       
CMHCaseNumber,       
ClientName,       
ClientEthnicity,       
ClientSex,       
ClientMaritalStatus,       
ClientSSN,       
ClientDateOfBirth,       
ClientAddress,       
ClientCity,       
ClientState,       
ClientZip,       
ClientCounty,       
ClientHomePhone,       
ClientEmergencyContact,       
ClientRelationship,       
ClientEmergencyPhone,       
ClientGuardianName,       
ClientGuardianPhone,       
PaymentSourceIndigent,       
PaymentSourcePrivate,       
PaymentSourcePrivateEmployer,       
PaymentSourcePrivateNumber,       
PaymentSourceMedicare,       
PaymentSourceMedicareNumber,       
PaymentSourceMedicaid,       
PaymentSourceMedicaidNumber,       
PaymentSourceMedicaidType,       
PaymentMedicaidOtherCounty,       
PaymentSourceVA,       
PaymentSourceOther,       
PaymentSourceOtherDescribe,       
PaymentMedicaidVerified,       
ServiceRequested,       
ClientRecentLocation,       
ClientBelongingsLocation,       
ClientMailLocation,       
ClientReturnLocation,       
ClientFromDifferentCounty,       
ClientPriorLivingArrangement,       
ClientIsWardofState,       
ClientIsWardofStateCountyDetail,       
COFRAdditionalInformation,       
COFROtherCountyDetail,       
ReferralSourceName,       
ReferralSourcePhoneLocation,       
ReferralSourceContacted,       
ReferralSourceContactedExplain,       
ReferralSourceJailLiason,       
ReferralSourceFamilyMember,       
ReferralSourcePhysician,       
ReferralSourceMHProvider,       
ReferralSourcePetitioned,       
ReferralSourceOther,       
ReferralSourceOtherSpecify,       
ReferralContactTypeFaceToFace,       
ReferralContactTypePhone,       
ReferralContactTypePreBooking,       
ReferralContactTypePostBooking,       
ReferralPrecipitatingEvents,       
RiskOthersAAgressiveWithin24Hours,       
RiskOthersAgressivePast48Hours,       
RiskOthersAgressiveWithinPast4Weeks,       
RiskOthersCurrentHomicidalIdeation,       
RiskOthersCurrentHomicidalActive,       
RiskOthersCurrentHomicidalWithin48Hours,       
RiskOthersCurrentHomicidalWithin14Days,       
RiskOthersAWOL,       
RiskOthersVerbal,       
RiskOthersPhysical,       
RiskOthersSexualActingOut,       
RiskOthersDestructionOfProperty,       
RiskOthersHasPlan,       
RiskOthersHasPlanDescribe,       
RiskOthersAccessToMeans,       
RiskOthersAccessToMeansDescribe,       
RiskOthersVerbalDescribe,       
RiskOthersPhysicalDescribe,       
RiskOthersSexualActingOutDescribe,       
RiskOthersDestructionOfPropertyDescribe,       
RiskOthersHistory,       
RiskOthersChargesPending,       
RiskOthersChargesPendingDescribe,       
RiskOthersJailHold,       
RiskSelfCurrentSuicidalIdeation,       
RiskSelfCurrentSuicidalActive,       
RiskSelfCurrentSuicidalWithin48Hours,       
RiskSelfCurrentSuicidalWithin14Days,       
RiskSelfHasPlan,       
RiskSelfHasPlanDescribe,       
RiskSelfEgoSyntonic,       
RiskSelfEgoDystonic,       
RiskSelfEgoDescribe,       
RiskSelfAccessToMeans,       
RiskSelfAccessToMeansDescribe,       
RiskSelfCurrentSelfHarm,       
RiskSelfCurrentSelfHarmDescribe,       
RiskSelfCurrentSelfHarmOutcome,      
RiskSelfPreviousSelfHarm,       
RiskSelfPreviousSelfHarmDescribe,      
RiskSelfPreviousSelfHarmOutcomes,       
RiskSelfFamilySuicideHistory,       
MentalStatusOrientaionPerson,       
MentalStatusOrientaionPlace,       
MentalStatusOrientaionTime,       
MentalStatusOrientaionCircumstance,       
MentalStatusLOCAlert,       
MentalStatusLOCSedate,       
MentalStatusLOCLethargic,       
MentalStatusLOCObtunded,       
MentalStatusLOCOther,       
MentalStatusLOCOtherDescribe,       
MentaStatusMoodAppropriate,       
MentaStatusMoodIncongruent,       
MentaStatusMoodHostile,       
MentaStatusMoodTearful,       
MentaStatusMoodOther,       
MentaStatusMoodOtherDescribe,       
MentaStatusAffectRestricted,       
MentaStatusAffectUnremarkable,       
MentaStatusAffectExpansive,       
MentaStatusAffectOther,       
MentaStatusAffectOtherDescribe,       
MentaStatusThoughtLucid,       
MentaStatusThoughtSuspicious,       
MentaStatusThoughtObsessive,       
MentaStatusThoughtObsessiveAbout,       
MentaStatusThoughtTangential,       
MentaStatusThoughtLoose,       
MentaStatusThoughtDelusional,       
MentaStatusThoughtPsychosis,       
MentaStatusThoughtImpoverished,       
MentaStatusThoughtConfused,       
MentaStatusSpeechClear,       
MentaStatusSpeechRapid,       
MentaStatusSpeechSlurred,       
MentaStatusJudgementImpaired,       
MentaStatusJudgementImpairedDescribe,       
MentalStatusImpulsivityApparent,       
MentalStatusImpulsivityApparentDescribe,       
MentalStatusInsightLimited,       
MentalStatusInsightLimitedDescribe,       
MentalStatusPxWithGrooming,       
MentalStatusSleepDisturbance,       
MentalStatusSleepDisturbanceDescribe,       
MentalStatusEatingDisturbance,       
MentalStatusEatingDisturbanceLbs,       
MentalStatusNotMedicationComplaint,       
SUCurrentUse,       
SUOdorOfSubstance,       
SUSlurredSpeech,       
SUWithdrawalSymptoms,       
SUDTOther,       
SUOtherDescribe,       
SUBlackOuts,       
SURelatedArrests,       
SURelatedSocialProblems,       
SUFrequentAbsences,       
SUCurrentTreatment,       
SUCurrentTreatmentProvider,       
SUProviderContactNumber,       
SUHistory,       
SUHistorySpecify,       
SUPreviousTreatment,       
SUReferralToSA,       
SUWhereReferred,       
SUNotReferredBecause,       
SUToxicologyResults,       
HHMentalHealthUnableToObtain,       
HHNumberOfIPPsychHospitalizations,       
HHMostRecentIPHospitalizationDate,       
HHMostRecentIPHospitalizationFacility,       
HHPreviousOPPsychTreatment,       
HHOPPsychUnableToObtain,       
HHTypeOfService,       
HHCurrentProviderAndCredentials,       
HHProviderCredentialsUnableToObtain,       
HHDateLastSeenByCurrentProvider,       
HHPrimaryCareProvider,       
HHPrimaryCareProviderPhone,       
HHNoPrimaryCarePhysician,       
HHAllergies,       
HHCurrentHealthConcerns,       
HHPreviousHealthConcerns,       
SIPsychiatricSymptoms,       
SIPossibleHarmToSelf,       
SIPossibleHarmToOthers,       
SIMedicationDrugComplications,       
SIDisruptionOfSelfCareAbilities,    
SIImpairedPersonalAdjustment,       
SIIntensityOfService,       
SummaryVoluntary,       
SummaryInvoluntary,       
SummaryInpatientFacilityName,       
AuthorizedDays,       
SummaryCrisisResidential,       
SummaryCrisisFacilityName,       
SummaryPartialHospitalization,       
SummaryPartialFacilityName,       
SummaryACT,       
SummaryCaseManagement,       
SummaryIOP,       
SummaryOutpatient,       
SummarySubstanceAbuse,       
SummaryOther,       
SummaryOtherSpecify,       
SummaryProviderRecommended,       
SummaryFamilyNotificationOffered,       
SummaryFamilyMemberName,       
SummaryInpatientRequestedAndDenied,       
SummarySecondOpinionRights,       
SummaryOfferedAlternativeServices,       
SummaryAlternativeServicesSpecify,       
SummaryAgreedToAlternativeServices,       
SummaryAlternativeAppointmentTime,       
SummaryAlternativeAgencyName,       
SummaryAlternativeAgencyContactNumber,       
SummaryChooseOtherPlan,       
SummaryChooseOtherPlanSpecify,       
SummaryMedicaidRights,       
SummaryMedicaidRightsWhyNot,       
SummaryRefusedTreatment,       
SummaryNoServicesNeeded,       
SummaryUnableToObtainSignature,       
SummaryUnableToObtainSignatureReason,       
ClientSignedPaperCopy,       
SummarySummary       
)      
 
--*Select LIST*--      
Select      
DocumentVersionId,       
DateOfPrescreen,       
InitialCallTime,       
ClientAvailableTimeForScreen,       
DispositionTime,       
ElapsedHours,       
ElapsedMinutes,
S.DateOfService,
S.DateTimeOut, 
CMHStatus,       
CMHStatusPrimaryClinician,       
CMHCaseNumber,       
ClientName,       
ClientEthnicity,       
ClientSex,       
ClientMaritalStatus,       
ClientSSN,       
ClientDateOfBirth,       
ClientAddress,       
ClientCity,       
ClientState,       
ClientZip,       
ClientCounty,       
ClientHomePhone,       
ClientEmergencyContact,       
ClientRelationship,       
ClientEmergencyPhone,       
ClientGuardianName,       
ClientGuardianPhone,       
PaymentSourceIndigent,       
PaymentSourcePrivate,       
PaymentSourcePrivateEmployer,       
PaymentSourcePrivateNumber,       
PaymentSourceMedicare,       
PaymentSourceMedicareNumber,       
PaymentSourceMedicaid,       
PaymentSourceMedicaidNumber,       
PaymentSourceMedicaidType,       
PaymentMedicaidOtherCounty,       
PaymentSourceVA,       
PaymentSourceOther,       
PaymentSourceOtherDescribe,       
PaymentMedicaidVerified,       
ServiceRequested,       
ClientRecentLocation,       
ClientBelongingsLocation,       
ClientMailLocation,       
ClientReturnLocation,       
ClientFromDifferentCounty,       
ClientPriorLivingArrangement,       
ClientIsWardofState,       
ClientIsWardofStateCountyDetail,       
COFRAdditionalInformation,       
COFROtherCountyDetail,       
ReferralSourceName,       
ReferralSourcePhoneLocation,       
ReferralSourceContacted,       
ReferralSourceContactedExplain,       
ReferralSourceJailLiason,       
ReferralSourceFamilyMember,       
ReferralSourcePhysician,       
ReferralSourceMHProvider,       
ReferralSourcePetitioned,       
ReferralSourceOther,       
ReferralSourceOtherSpecify,       
ReferralContactTypeFaceToFace,       
ReferralContactTypePhone,       
ReferralContactTypePreBooking,       
ReferralContactTypePostBooking,       
ReferralPrecipitatingEvents,       
RiskOthersAAgressiveWithin24Hours,       
RiskOthersAgressivePast48Hours,       
RiskOthersAgressiveWithinPast4Weeks,       
RiskOthersCurrentHomicidalIdeation,       
RiskOthersCurrentHomicidalActive,       
RiskOthersCurrentHomicidalWithin48Hours,       
RiskOthersCurrentHomicidalWithin14Days,       
RiskOthersAWOL,       
RiskOthersVerbal,       
RiskOthersPhysical,       
RiskOthersSexualActingOut,       
RiskOthersDestructionOfProperty,       
RiskOthersHasPlan,       
RiskOthersHasPlanDescribe,       
RiskOthersAccessToMeans,       
RiskOthersAccessToMeansDescribe,       
RiskOthersVerbalDescribe,       
RiskOthersPhysicalDescribe,       
RiskOthersSexualActingOutDescribe,       
RiskOthersDestructionOfPropertyDescribe,      
RiskOthersHistory,       
RiskOthersChargesPending,       
RiskOthersChargesPendingDescribe,       
RiskOthersJailHold,       
RiskSelfCurrentSuicidalIdeation,       
RiskSelfCurrentSuicidalActive,       
RiskSelfCurrentSuicidalWithin48Hours,       
RiskSelfCurrentSuicidalWithin14Days,       
RiskSelfHasPlan,       
RiskSelfHasPlanDescribe,       
RiskSelfEgoSyntonic,       
RiskSelfEgoDystonic,       
RiskSelfEgoDescribe,       
RiskSelfAccessToMeans,       
RiskSelfAccessToMeansDescribe,       
RiskSelfCurrentSelfHarm,       
RiskSelfCurrentSelfHarmDescribe,       
RiskSelfCurrentSelfHarmOutcome,      
RiskSelfPreviousSelfHarm,       
RiskSelfPreviousSelfHarmDescribe,      
RiskSelfPreviousSelfHarmOutcomes,       
RiskSelfFamilySuicideHistory,       
MentalStatusOrientaionPerson,       
MentalStatusOrientaionPlace,       
MentalStatusOrientaionTime,       
MentalStatusOrientaionCircumstance,       
MentalStatusLOCAlert,       
MentalStatusLOCSedate,       
MentalStatusLOCLethargic,       
MentalStatusLOCObtunded,       
MentalStatusLOCOther,       
MentalStatusLOCOtherDescribe,       
MentaStatusMoodAppropriate,       
MentaStatusMoodIncongruent,       
MentaStatusMoodHostile,       
MentaStatusMoodTearful,       
MentaStatusMoodOther,       
MentaStatusMoodOtherDescribe,       
MentaStatusAffectRestricted,       
MentaStatusAffectUnremarkable,       
MentaStatusAffectExpansive,       
MentaStatusAffectOther,       
MentaStatusAffectOtherDescribe,       
MentaStatusThoughtLucid,       
MentaStatusThoughtSuspicious,       
MentaStatusThoughtObsessive,       
MentaStatusThoughtObsessiveAbout,       
MentaStatusThoughtTangential,       
MentaStatusThoughtLoose,       
MentaStatusThoughtDelusional,       
MentaStatusThoughtPsychosis,       
MentaStatusThoughtImpoverished,       
MentaStatusThoughtConfused,       
MentaStatusSpeechClear,       
MentaStatusSpeechRapid,       
MentaStatusSpeechSlurred,       
MentaStatusJudgementImpaired,       
MentaStatusJudgementImpairedDescribe,       
MentalStatusImpulsivityApparent,       
MentalStatusImpulsivityApparentDescribe,       
MentalStatusInsightLimited,       
MentalStatusInsightLimitedDescribe,       
MentalStatusPxWithGrooming,       
MentalStatusSleepDisturbance,       
MentalStatusSleepDisturbanceDescribe,       
MentalStatusEatingDisturbance,       
MentalStatusEatingDisturbanceLbs,       
MentalStatusNotMedicationComplaint,       
SUCurrentUse,       
SUOdorOfSubstance,       
SUSlurredSpeech,       
SUWithdrawalSymptoms,       
SUDTOther,       
SUOtherDescribe,       
SUBlackOuts,       
SURelatedArrests,       
SURelatedSocialProblems,       
SUFrequentAbsences,       
SUCurrentTreatment,       
SUCurrentTreatmentProvider,       
SUProviderContactNumber,       
SUHistory,       
SUHistorySpecify,       
SUPreviousTreatment,       
SUReferralToSA,       
SUWhereReferred,       
SUNotReferredBecause,       
SUToxicologyResults,       
HHMentalHealthUnableToObtain,       
HHNumberOfIPPsychHospitalizations,       
HHMostRecentIPHospitalizationDate,       
HHMostRecentIPHospitalizationFacility,       
HHPreviousOPPsychTreatment,       
HHOPPsychUnableToObtain,       
HHTypeOfService,       
HHCurrentProviderAndCredentials,       
HHProviderCredentialsUnableToObtain,       
HHDateLastSeenByCurrentProvider,       
HHPrimaryCareProvider,       
HHPrimaryCareProviderPhone,       
HHNoPrimaryCarePhysician,       
HHAllergies,       
HHCurrentHealthConcerns,       
HHPreviousHealthConcerns,       
SIPsychiatricSymptoms,       
SIPossibleHarmToSelf,       
SIPossibleHarmToOthers,       
SIMedicationDrugComplications,       
SIDisruptionOfSelfCareAbilities,       
SIImpairedPersonalAdjustment,       
SIIntensityOfService,       
SummaryVoluntary,       
SummaryInvoluntary,       
SummaryInpatientFacilityName,       
AuthorizedDays,       
SummaryCrisisResidential,       
SummaryCrisisFacilityName,       
SummaryPartialHospitalization,       
SummaryPartialFacilityName,       
SummaryACT,       
SummaryCaseManagement,       
SummaryIOP,       
SummaryOutpatient,       
SummarySubstanceAbuse,       
SummaryOther,       
SummaryOtherSpecify,       
SummaryProviderRecommended,       
SummaryFamilyNotificationOffered,       
SummaryFamilyMemberName,       
SummaryInpatientRequestedAndDenied,       
SummarySecondOpinionRights,       
SummaryOfferedAlternativeServices,       
SummaryAlternativeServicesSpecify,       
SummaryAgreedToAlternativeServices,       
SummaryAlternativeAppointmentTime,       
SummaryAlternativeAgencyName,       
SummaryAlternativeAgencyContactNumber,       
SummaryChooseOtherPlan,       
SummaryChooseOtherPlanSpecify,       
SummaryMedicaidRights,       
SummaryMedicaidRightsWhyNot,       
SummaryRefusedTreatment,       
SummaryNoServicesNeeded,       
SummaryUnableToObtainSignature,       
SummaryUnableToObtainSignatureReason,       
ClientSignedPaperCopy,       
SummarySummary      
FROM CustomAcuteServicesPrescreens   
JOIN DOCUMENTS D ON InProgressDocumentVersionId = CustomAcuteServicesPrescreens.DocumentVersionId 
JOIN SERVICES S ON D.ServiceId = S.ServiceId
WHERE DocumentVersionId = @DocumentVersionId      
and isnull(CustomAcuteServicesPrescreens.RecordDeleted,'N')<>'Y'  

      
if @DocumentVersionId not in ( 266252       
,270225      
)      
      
begin      
Insert into #validationReturnTable (       
TableName,      
ColumnName,      
ErrorMessage      
)      
/*      
--*VALIDATIION SELECT/UNION*--      
select 'Eds test validation', 'Dates to validate', 'InitialCallTime:'+convert(varchar(16),InitialCallTime,20)
      +' ClientAvailable:'+convert(varchar(16),isnull(ClientAvailableTimeForScreen,'1/1/1900'),20) 
	  +' DispositionTime:'+convert(varchar(16),isnull(DispositionTime,'1/1/1900'),20)
	  +' DateofService:'+convert(varchar(16),isnull(@DateOfService,'1/1/1900'),20)
	  +' DateTimeOut:'+convert(varchar(16),isnull(@DateTimeOut,'1/1/1900'),20)
	  +' DocumentVersionId:'+convert(varchar(16),isnull(@DocumentVersionId,0))
FROM #CustomAcuteServicesPrescreens      
union  */    
SELECT 'CustomAcuteServicesPrescreens', 'DateOfPrescreen', 'General - Date of pre-screen required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(DateOfPrescreen,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'InitialCallTime', 'General - Initial call time required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(InitialCallTime,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'ClientAvailableTimeForScreen', 'General - Consumer available for screen time required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(ClientAvailableTimeForScreen,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'DispositionTime', 'General - Disposition time required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(DispositionTime,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'DeletedBy', 'General - Elapsed time of screen required'      
FROM #CustomAcuteServicesPrescreens      
WHERE (isnull(ElapsedHours,'')='' and isnull(ElapsedMinutes,'')='')      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'DateOfPrescreen', 'General - Date of Service AND Time IN of service cannot be before Initial Call Time.'      
FROM #CustomAcuteServicesPrescreens      
WHERE (ISNULL(@DateOfService,DateOfService)<ISNULL(InitialCallTime,'1/1/1900'))      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'DateOfPrescreen', 'General - Date of Service AND Time IN of service cannot be before Consumer Available for Screen.'        
FROM #CustomAcuteServicesPrescreens        
WHERE (ISNULL(@DateOfService,DateOfService)<ISNULL(ClientAvailableTimeForScreen,'1/1/1900'))
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'ClientAvailableTimeForScreen', 'General - Consumer Available for Screen must come after initial call time'      
FROM #CustomAcuteServicesPrescreens      
WHERE (ISNULL(InitialCallTime,'1/1/1900')>ISNULL(ClientAvailableTimeForScreen,'1/1/1900'))
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'DispositionTime', 'General - Disposition time must be <= service end time'        
FROM #CustomAcuteServicesPrescreens        
WHERE (ISNULL(DispositionTime,'1/1/1900')>ISNULL(@DateTimeOut,DateTimeOut))
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'ClientAvailableTimeForScreen', 'General - Consumer Available for Screen must come before disposition time'      
FROM #CustomAcuteServicesPrescreens      
WHERE (ISNULL(ClientAvailableTimeForScreen,'1/1/1900')>=ISNULL(DispositionTime,'1/1/1900'))
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'RiskOthersChargesPending', 'General - must answer risk: other charges pending'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(RiskOthersChargesPending,'')=''
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'RiskOthersJailHold', 'General - must answer risk: jail hold'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(RiskOthersJailHold,'')=''
/***************************************************************/
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'CMHStatus', 'General - CMH status required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(CMHStatus,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'CMHCaseNumber', 'General - CMH case number required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(CMHCaseNumber,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'ClientName', 'General - Name required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(ClientName,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'ClientEthnicity', 'General - Ethnicity required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(ClientEthnicity,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'ClientSex', 'General - Sex required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(ClientSex,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'ClientMaritalStatus', 'General - Marital status required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(ClientMaritalStatus,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'ClientSSN', 'General - Social Security # required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(ClientSSN,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'ClientDateOfBirth', 'General - DOB required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(ClientDateOfBirth,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'ClientAddress', 'General - Consumer address street required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(ClientAddress,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'ClientCity', 'General - Cosumer address city required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(ClientCity,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'ClientState', 'General - Consumer address state required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(ClientState,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'ClientZip', 'General - Consumer address zip code required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(ClientZip,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'ClientCounty', 'General - Consumer county required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(ClientCounty,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'ServiceRequested', 'General - Service requested by consumer or referral source required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(ServiceRequested,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'DeletedBy', 'Mental Status - Level of Consciousness: Other description required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(MentalStatusLOCOtherDescribe,'')=''      
and isnull(MentalStatusLOCOther,'N')='Y'      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'DeletedBy', 'Mental Status - Mood: Other description required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(MentaStatusMoodOtherDescribe,'')=''      
and isnull(MentaStatusMoodOther,'N')='Y'
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'DeletedBy', 'Mental Status - Affect: Other description required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(MentaStatusAffectOtherDescribe,'')=''      
and isnull(MentaStatusAffectOther,'N')='Y'      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'MentaStatusThoughtObsessiveAbout', 'Mental Status - Thought processing: Obsessive description required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(MentaStatusThoughtObsessiveAbout,'')=''      
and isnull(MentaStatusThoughtObsessive,'N')='Y'      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'MentaStatusJudgementImpaired', 'Mental Status - Judgement selection required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(MentaStatusJudgementImpaired,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'MentaStatusJudgementImpairedDescribe', 'Mental Status - Judgement: Impairment description required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(MentaStatusJudgementImpairedDescribe,'')=''      
and isnull(MentaStatusJudgementImpaired,'X')='Y'      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'MentalStatusImpulsivityApparent', 'Mental Status - Impulsivity required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(MentalStatusImpulsivityApparent,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'MentalStatusImpulsivityApparentDescribe', 'Mental Status - Impulsivity: Descrption required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(MentalStatusImpulsivityApparentDescribe,'')=''      
and isnull(MentalStatusImpulsivityApparent,'X')='Y'      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'MentalStatusInsightLimited', 'Mental Status - Insight about illness/behavior required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(MentalStatusInsightLimited,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'MentalStatusInsightLimitedDescribe', 'Mental Status - Insight about illness/behavior: Description required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(MentalStatusInsightLimitedDescribe,'')=''      
and isnull(MentalStatusInsightLimited,'X')='Y'    
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'SUCurrentUse', 'Substance Use - Current use selection required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(SUCurrentUse,'')=''
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'SUOtherDescribe', 'Substance Use - SUOtherDescribe required'      
FROM #CustomAcuteServicesPrescreens      
WHERE  isnull(SUDTOther,'X')='Y'      
       AND isnull(SUOtherDescribe,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'SUCurrentTreatment', 'Substance Use - Current substance abuse treatment selection required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(SUCurrentTreatment,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'SUCurrentTreatmentProvider', 'Substance Use - Current substance abuse treatment provider required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(SUCurrentTreatmentProvider,'')=''      
and isnull(SUCurrentTreatment,'X')='Y'      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'SUHistory', 'Substance Use - Does consumer have a history of substance use selection required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(SUHistory,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'SUHistorySpecify', 'Substance Use - History of substance use specification required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(SUHistorySpecify,'')=''      
and isnull(SUHistory,'N')='Y'      
      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'SUPreviousTreatment', 'Substance Use - Previous substance abuse treatment? selection required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(SUPreviousTreatment,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'SUReferralToSA', 'Substance Use - If current substance abuse symptoms, referral to SA or co-occurring tx? selection required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(SUReferralToSA,'')=''      
and isnull(SUCurrentUse,'X')='Y'      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'SUWhereReferred', 'Substance Use - SA/Co-occuring: Yes, where referred required'  FROM #CustomAcuteServicesPrescreens      
WHERE isnull(SUWhereReferred,'')=''      
and isnull(SUReferralToSA,'X')='Y'      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'SUNotReferredBecause', 'Substance Use - SA/Co-occuring: No, because required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(SUNotReferredBecause,'')=''      
and isnull(SUReferralToSA,'X')='N'      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'SUToxicologyResults', 'Substance Use - Toxicology results required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(SUToxicologyResults,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'HHNumberOfIPPsychHospitalizations', 'Health History - Number of IP psychiatric hospitalizations required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(HHNumberOfIPPsychHospitalizations,-1)=-1      
and isnull(HHMentalHealthUnableToObtain,'N')='N'      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'HHPreviousOPPsychTreatment', 'Health History - Previous OP psychiatric treatment selection required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(HHPreviousOPPsychTreatment,'')=''      
and isnull(HHMentalHealthUnableToObtain,'N')='N'      
and isnull(HHOPPsychUnableToObtain,'N')='N'      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'HHTypeOfService', 'Health History - Previous OP: If yes, Type of service description required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(HHTypeOfService,'')=''      
and isnull(HHMentalHealthUnableToObtain,'N')='N'      
and isnull(HHPreviousOPPsychTreatment,'X')='Y'      
      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'HHCurrentProviderAndCredentials', 'Health History - Current provider and credentials required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(HHCurrentProviderAndCredentials,'')=''      
and isnull(HHMentalHealthUnableToObtain,'N')='N'      
and isnull(HHPreviousOPPsychTreatment,'X')='Y'      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'HHPrimaryCareProvider', 'Health History - Name of primary care physician required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(HHPrimaryCareProvider,'')=''      
and isnull(HHNoPrimaryCarePhysician,'N')='N'      
      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'HHAllergies', 'Health History - Allergies required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(HHAllergies,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'HHCurrentHealthConcerns', 'Health History - Current health concerns required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(HHCurrentHealthConcerns,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'HHPreviousHealthConcerns', 'Health History - Previous health concerns required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(HHPreviousHealthConcerns,'')=''      
      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'SIPsychiatricSymptoms', 'Severity/Intensity - Psychiatric symptoms required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(SIPsychiatricSymptoms,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'SIPossibleHarmToSelf', 'Severity/Intensity - Possible harm to self selection required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(SIPossibleHarmToSelf,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'SIPossibleHarmToOthers', 'Severity/Intensity - Possible harm to others selection required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(SIPossibleHarmToOthers,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'SIMedicationDrugComplications', 'Severity/Intensity - Medication/drug complications selection required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(SIMedicationDrugComplications,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'SIDisruptionOfSelfCareAbilities', 'Severity/Intensity - Disruption of self-care abilities selection required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(SIDisruptionOfSelfCareAbilities,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'SIIntensityOfService', 'Severity/Intensity - Intensity of service selection required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(SIIntensityOfService,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'SummaryInpatientFacilityName', 'Recommendations/Summary - Inpatient facility name required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(SummaryInpatientFacilityName,'')=''      
and (isnull(SummaryInvoluntary,'N')='Y' or isnull(SummaryVoluntary,'N')='Y')      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'SummaryCrisisFacilityName', 'Recommendations/Summary - Crisis residential: Program name required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(SummaryCrisisFacilityName,'')=''      
and isnull(SummaryCrisisResidential,'N')='Y'      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'SummaryPartialFacilityName', 'Recommendations/Summary - Partial hospitalization: Facility name required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(SummaryPartialFacilityName,'')=''      
and isnull(SummaryPartialHospitalization,'N')='Y'      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'SummaryOtherSpecify', 'Recommendations/Summary - Other(specify) description required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(SummaryOtherSpecify,'')=''      
and isnull(SummaryOther,'X')='Y'      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'SummaryFamilyNotificationOffered', 'Recommendations/Summary - Screener Recommendations - Family notification acute services offered selection required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(SummaryFamilyNotificationOffered,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'SummaryFamilyMemberName', 'Recommendations/Summary - Screener Recommendations- Family members name required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(SummaryFamilyMemberName,'')=''      
and isnull(SummaryFamilyNotificationOffered,'X')='Y'      

/*~**********************************************************************************************************/
UNION
SELECT 'CustomAcuteServicesPrescreens', 'Summary Checkboxes', 'Recommendations/Summary - Too many checkboxes'      
FROM #CustomAcuteServicesPrescreens      
WHERE 1=1 and 
case when isnull(SummaryInvoluntary,'N')='N' then 0 else 1 end 
+case when isnull(SummaryVoluntary,'N')='N' then 0 else 1 end 
+case when isnull(SummaryCrisisResidential,'N')='N' then 0 else 1 end 
+case when isnull(SummaryPartialHospitalization,'N')='N' then 0 else 1 end 
+case when isnull(SummaryACT, 'N')='N' then 0 else 1 end 
+case when isnull(SummaryCaseManagement, 'N')='N' then 0 else 1 end 
+case when isnull(SummaryIOP, 'N')='N' then 0 else 1 end 
+case when isnull(SummaryOutpatient,  'N')='N' then 0 else 1 end 
+case when isnull(SummarySubstanceAbuse, 'N')='N' then 0 else 1 end 
+case when isnull(SummaryOther, 'N')='N' then 0 else 1 end >1
UNION
SELECT 'CustomAcuteServicesPrescreens', 'Summary Checkboxes', 'Recommendations/Summary - must select 1 disposition'      
FROM #CustomAcuteServicesPrescreens      
WHERE 1=1 and 
case when isnull(SummaryInvoluntary,'N')='N' then 0 else 1 end +
case when isnull(SummaryVoluntary,'N')='N' then 0 else 1 end +
case when isnull(SummaryCrisisResidential,'N')='N' then 0 else 1 end +
case when isnull(SummaryPartialHospitalization,'N')='N' then 0 else 1 end +
case when isnull(SummaryACT, 'N')='N' then 0 else 1 end +
case when isnull(SummaryCaseManagement, 'N')='N' then 0 else 1 end +
case when isnull(SummaryIOP, 'N')='N' then 0 else 1 end +
case when isnull(SummaryOutpatient,  'N')='N' then 0 else 1 end +
case when isnull(SummarySubstanceAbuse, 'N')='N' then 0 else 1 end +
case when isnull(SummaryOther, 'N')='N' then 0 else 1 end =0
UNION
SELECT 'CustomAcuteServicesPrescreens', 'Referral Contact Type', 'Referral: check face to face or phone'      
FROM #CustomAcuteServicesPrescreens      
WHERE 1=1 and 
case when isnull(ReferralContactTypeFaceToFace,'N')='N' then 0 else 1 end +
case when isnull(ReferralContactTypePhone,'N')='N' then 0 else 1 end 
= 0
/***********************************************************************************************************/

--------------------------------------------------Rights Notification---------------------------------------------
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'SummaryInpatientRequestedAndDenied', 'Recommendations/Summary - Inpatient treatment requested then denied selection required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(SummaryInpatientRequestedAndDenied,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'SummarySecondOpinionRights', 'Recommendations/Summary - Second opinion rights explained/given selection required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(SummarySecondOpinionRights,'')=''      
and isnull(SummaryInpatientRequestedAndDenied,'X')='Y'      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'SummaryOfferedAlternativeServices', 'Recommendations/Summary - Was consumer offered alternative services selection required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(SummaryOfferedAlternativeServices,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'SummaryAlternativeServicesSpecify', 'Recommendations/Summary - Alternative services specification is required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(SummaryAlternativeServicesSpecify,'')=''      
and isnull(SummaryOfferedAlternativeServices,'X')='Y'      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'SummaryAgreedToAlternativeServices', 'Recommendations/Summary - Consumer agreed to alternative services selection required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(SummaryAgreedToAlternativeServices,'')=''      
and isnull(SummaryOfferedAlternativeServices,'X')='Y'      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'SummaryAlternativeAppointmentTime', 'Recommendations/Summary - Alt services: Date & time of appointment required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(SummaryAlternativeAppointmentTime,'')=''      
and isnull(SummaryAgreedToAlternativeServices,'X')='Y'      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'SummaryAlternativeAgencyName', 'Recommendations/Summary -  Alt services: Agency name required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(SummaryAlternativeAgencyName,'')=''      
and isnull(SummaryAgreedToAlternativeServices,'X')='Y'      
      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'SummaryAlternativeAgencyContactNumber', 'Recommendations/Summary - Alt services: Agency contact number required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(SummaryAlternativeAgencyContactNumber,'')=''      
and isnull(SummaryAgreedToAlternativeServices,'X')='Y'      
      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'SummaryChooseOtherPlan', 'Recommendations/Summary - Did consumer choose an alternative plan other than those offered selection required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(SummaryChooseOtherPlan,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'SummaryChooseOtherPlanSpecify', 'Recommendations/Summary - Other plan specification required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(SummaryChooseOtherPlanSpecify,'')=''      
and isnull(SummaryChooseOtherPlan,'X')='Y'      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'SummaryMedicaidRights', 'Recommendations/Summary - Was adequate notice of rights givin? selection required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(SummaryMedicaidRights,'')=''      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'SummaryMedicaidRightsWhyNot', 'Recommendations/Summary - Why was no adequate notice given description required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(SummaryMedicaidRightsWhyNot,'')=''      
and isnull(SummaryMedicaidRights,'X')='N'      
/**  11-04-2012    #134  Pralyankars  Added Validation Conditions  */
UNION        
SELECT 'CustomAcuteServicesPrescreens', 'DeletedBy', 'Recommendations/Summary - Summary - One check box required'        
FROM #CustomAcuteServicesPrescreens        
WHERE isnull(SummaryUnableToObtainSignature,'')='' AND  isnull(SummaryNoServicesNeeded,'')=''  AND   isnull(SummaryRefusedTreatment,'')=''   AND  isnull(ClientSignedPaperCopy,'')=''          
--End Validation
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'SummaryUnableToObtainSignatureReason', 'Recommendations/Summary - If unable to obtain consumer signature, provide rationale description required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(SummaryUnableToObtainSignatureReason,'')=''      
and isnull(SummaryUnableToObtainSignature,'X')='Y'      
UNION      
SELECT 'CustomAcuteServicesPrescreens', 'SummarySummary', 'Recommendations/Summary - Summary required'      
FROM #CustomAcuteServicesPrescreens      
WHERE isnull(SummarySummary,'')=''      
      
      
exec [csp_ValidateCustomAcuteServicesPrescreen_icd10] @DocumentVersionId      
      
exec [csp_validateCustomServicesTab] @DocumentVersionId      
      
      
end      
      
if @@error <> 0 goto error      
      
return      
      
error:      
RAISERROR ('csp_validateCustomAcuteServicesPrescreens failed.  Please contact your system administrator. We apologize for the inconvenience.',16,1)      

select top 10 * from errorlog order by 1 desc
GO


