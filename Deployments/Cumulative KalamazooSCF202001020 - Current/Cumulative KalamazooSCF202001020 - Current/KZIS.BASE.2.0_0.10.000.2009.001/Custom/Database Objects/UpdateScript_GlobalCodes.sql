
--General Appearance
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEGeneralAppearance' AND CodeName= 'Assessed')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='A' WHERE Category='MSEGeneralAppearance' AND CodeName= 'Assessed'
END
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEGeneralAppearance' AND CodeName= 'Not Assessed')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='N' WHERE Category='MSEGeneralAppearance' AND CodeName= 'Not Assessed'
END
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEGeneralAppearance' AND CodeName= 'WNL- Appropriately dressed and groomed for the occasion')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='W' WHERE Category='MSEGeneralAppearance' AND CodeName= 'WNL- Appropriately dressed and groomed for the occasion'
END

--Speech
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSESpeech' AND CodeName= 'Assessed')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='A' WHERE Category='MSESpeech' AND CodeName= 'Assessed'
END
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSESpeech' AND CodeName= 'Not Assessed')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='N' WHERE Category='MSESpeech' AND CodeName= 'Not Assessed'
END
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSESpeech' AND CodeName= 'WNL- non-pressured, with normal rate, tone, latency')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='W' WHERE Category='MSESpeech' AND CodeName= 'WNL- non-pressured, with normal rate, tone, latency'
END

--MSEMoodAndAffect
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEMoodAndAffect' AND CodeName= 'Assessed')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='A' WHERE Category='MSEMoodAndAffect' AND CodeName= 'Assessed'
END
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEMoodAndAffect' AND CodeName= 'Not Assessed')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='N' WHERE Category='MSEMoodAndAffect' AND CodeName= 'Not Assessed'
END
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEMoodAndAffect' AND CodeName= 'WNL- mood and affect euthymic and congruent')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='W' WHERE Category='MSEMoodAndAffect' AND CodeName= 'WNL- mood and affect euthymic and congruent'
END

--MSEAttentionSpan
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEAttentionSpan' AND CodeName= 'Assessed')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='A' WHERE Category='MSEAttentionSpan' AND CodeName= 'Assessed'
END
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEAttentionSpan' AND CodeName= 'Not Assessed')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='N' WHERE Category='MSEAttentionSpan' AND CodeName= 'Not Assessed'
END
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEAttentionSpan' AND CodeName= 'WNL- with good concentration and attention span')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='W' WHERE Category='MSEAttentionSpan' AND CodeName= 'WNL- with good concentration and attention span'
END

--MSEThoughtContent
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEThoughtContent' AND CodeName= 'Assessed all sections below')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='A' WHERE Category='MSEThoughtContent' AND CodeName= 'Assessed all sections below'
END
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEThoughtContent' AND CodeName= 'Not Assessed')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='N' WHERE Category='MSEThoughtContent' AND CodeName= 'Not Assessed'
END
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEThoughtContent' AND CodeName= 'WNL for age – coherent and goal directed with no evidence of abnormal or delusional thought content or cognitive disturbance; good fund of knowledge')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='W' WHERE Category='MSEThoughtContent' AND CodeName= 'WNL for age – coherent and goal directed with no evidence of abnormal or delusional thought content or cognitive disturbance; good fund of knowledge'
END

--MSEAssociations
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEAssociations' AND CodeName= 'Assessed all sections below')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='A' WHERE Category='MSEAssociations' AND CodeName= 'Assessed all sections below'
END
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEAssociations' AND CodeName= 'Not Assessed')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='N' WHERE Category='MSEAssociations' AND CodeName= 'Not Assessed'
END
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEAssociations' AND CodeName= 'WNL - Intact')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='W' WHERE Category='MSEAssociations' AND CodeName= 'WNL - Intact'
END

--MSEPsychoticThoughts
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEPsychoticThoughts' AND CodeName= 'Assessed')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='A' WHERE Category='MSEPsychoticThoughts' AND CodeName= 'Assessed'
END
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEPsychoticThoughts' AND CodeName= 'Not Assessed')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='N' WHERE Category='MSEPsychoticThoughts' AND CodeName= 'Not Assessed'
END

--MSEPsychoDisturbance
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEPsychoDisturbance' AND CodeName= 'Present(leave items below unchecked if not present)')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='P' WHERE Category='MSEPsychoDisturbance' AND CodeName= 'Present(leave items below unchecked if not present)'
END
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEPsychoDisturbance' AND CodeName= 'None')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='N' WHERE Category='MSEPsychoDisturbance' AND CodeName= 'None'
END

--MSEOrientation
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEOrientation' AND CodeName= 'Assessed')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='A' WHERE Category='MSEOrientation' AND CodeName= 'Assessed'
END
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEOrientation' AND CodeName= 'Not Assessed')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='N' WHERE Category='MSEOrientation' AND CodeName= 'Not Assessed'
END
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEOrientation' AND CodeName= 'WNL- Oriented to person, place, time, situation')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='W' WHERE Category='MSEOrientation' AND CodeName= 'WNL- Oriented to person, place, time, situation'
END

--MSEFundOfKnowledge
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEFundOfKnowledge' AND CodeName= 'Assessed')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='A' WHERE Category='MSEFundOfKnowledge' AND CodeName= 'Assessed'
END
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEFundOfKnowledge' AND CodeName= 'Not Assessed')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='N' WHERE Category='MSEFundOfKnowledge' AND CodeName= 'Not Assessed'
END
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEFundOfKnowledge' AND CodeName= 'Fund of knowledge WNL for developmental level')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='W' WHERE Category='MSEFundOfKnowledge' AND CodeName= 'Fund of knowledge WNL for developmental level'
END

--MSEInsight
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEInsight' AND CodeName= 'Good')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='G' WHERE Category='MSEInsight' AND CodeName= 'Good'
END
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEInsight' AND CodeName= 'Fair')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='F' WHERE Category='MSEInsight' AND CodeName= 'Fair'
END
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEInsight' AND CodeName= 'Poor')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='P' WHERE Category='MSEInsight' AND CodeName= 'Poor'
END
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEInsight' AND CodeName= 'Grossly Impaired')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='R' WHERE Category='MSEInsight' AND CodeName= 'Grossly Impaired'
END
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEInsight' AND CodeName= 'Excellent')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='E' WHERE Category='MSEInsight' AND CodeName= 'Excellent'
END

--MSEMemoryANW
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEMemoryANW' AND CodeName= 'Assessed')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='A' WHERE Category='MSEMemoryANW' AND CodeName= 'Assessed'
END
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEMemoryANW' AND CodeName= 'Not Assessed')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='N' WHERE Category='MSEMemoryANW' AND CodeName= 'Not Assessed'
END
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEMemoryANW' AND CodeName= 'WNL – Immediate, recent, and remote memory intact')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='W' WHERE Category='MSEMemoryANW' AND CodeName= 'WNL – Immediate, recent, and remote memory intact'
END

--MSEMemory
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEMemory' AND CodeName= 'Fair')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='F' WHERE Category='MSEMemory' AND CodeName= 'Fair'
END
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEMemory' AND CodeName= 'Impaired')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='I' WHERE Category='MSEMemory' AND CodeName= 'Impaired'
END
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEMemory' AND CodeName= 'Good')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='G' WHERE Category='MSEMemory' AND CodeName= 'Good'
END

--MSEMuscleStrength
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEMuscleStrength' AND CodeName= 'Assessed')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='A' WHERE Category='MSEMuscleStrength' AND CodeName= 'Assessed'
END
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEMuscleStrength' AND CodeName= 'Not Assessed')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='N' WHERE Category='MSEMuscleStrength' AND CodeName= 'Not Assessed'
END
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEMuscleStrength' AND CodeName= 'WNL')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='W' WHERE Category='MSEMuscleStrength' AND CodeName= 'WNL'
END

--MSEReview
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEReview' AND CodeName= 'Review with changes')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='C' WHERE Category='MSEReview' AND CodeName= 'Review with changes'
END
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEReview' AND CodeName= 'Review with no changes')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='N' WHERE Category='MSEReview' AND CodeName= 'Review with no changes'
END
IF EXISTS(SELECT * FROM GlobalCodes WHERE Category='MSEReview' AND CodeName= 'N/A')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='A' WHERE Category='MSEReview' AND CodeName= 'N/A'
END

