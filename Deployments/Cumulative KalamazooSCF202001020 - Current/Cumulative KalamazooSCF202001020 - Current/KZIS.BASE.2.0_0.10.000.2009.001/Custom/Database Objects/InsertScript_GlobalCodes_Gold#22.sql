/*********************************************************************/
--  Created By : Packia
--  Dated      : 11/20/2019
--  Purpose    : To insert new entry in  global codes for Mental staus exam DFA
--               What/Why: Project :  Gold- Task : #22
/*********************************************************************/

--Insert script GlobalCodeCategories- GeneralAppearance
IF(NOT EXISTS(SELECT Category FROM GlobalCodeCategories WHERE CATEGORY='MSEGeneralAppearance'))
BEGIN
	INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes) 
	VALUES('MSEGeneralAppearance','MSEGeneralAppearance','Y','Y','Y','Y','Y','N')
END

--Insert script Globalcodes

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEGeneralAppearance' AND CodeName= 'Assessed' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEGeneralAppearance','Assessed','A','Y','N')
END
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEGeneralAppearance' AND CodeName= 'Not Assessed' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEGeneralAppearance','Not Assessed','N','Y','N')
END
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEGeneralAppearance' AND CodeName= 'WNL- Appropriately dressed and groomed for the occasion' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEGeneralAppearance','WNL- Appropriately dressed and groomed for the occasion','W','Y','N')
END

--Insert script GlobalCodeCategories -- Speech
IF(NOT EXISTS(SELECT Category FROM GlobalCodeCategories WHERE CATEGORY='MSESpeech'))
BEGIN
	INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes) 
	VALUES('MSESpeech','MSESpeech','Y','Y','Y','Y','Y','N')
END

--Insert script Globalcodes

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSESpeech' AND CodeName= 'Assessed' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSESpeech','Assessed','A','Y','N')
END
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSESpeech' AND CodeName= 'Not Assessed' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSESpeech','Not Assessed','N','Y','N')
END
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSESpeech' AND CodeName= 'WNL- non-pressured, with normal rate, tone, latency' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSESpeech','WNL- non-pressured, with normal rate, tone, latency','W','Y','N')
END

--Insert script GlobalCodeCategories -- Mood and Affect
IF(NOT EXISTS(SELECT Category FROM GlobalCodeCategories WHERE CATEGORY='MSEMoodAndAffect'))
BEGIN
	INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes) 
	VALUES('MSEMoodAndAffect','MSEMoodAndAffect','Y','Y','Y','Y','Y','N')
END
--Insert script Globalcodes
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEMoodAndAffect' AND CodeName= 'Assessed' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEMoodAndAffect','Assessed','A','Y','N')
END
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEMoodAndAffect' AND CodeName= 'Not Assessed' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEMoodAndAffect','Not Assessed','N','Y','N')
END
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEMoodAndAffect' AND CodeName= 'WNL- mood and affect euthymic and congruent' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEMoodAndAffect','WNL- mood and affect euthymic and congruent','W','Y','N')
END

--Insert script GlobalCodeCategories -- Attention Span
IF(NOT EXISTS(SELECT Category FROM GlobalCodeCategories WHERE CATEGORY='MSEAttentionSpan'))
BEGIN
	INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes) 
	VALUES('MSEAttentionSpan','MSEAttentionSpan','Y','Y','Y','Y','Y','N')
END
--Insert script Globalcodes
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEAttentionSpan' AND CodeName= 'Assessed' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEAttentionSpan','Assessed','A','Y','N')
END
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEAttentionSpan' AND CodeName= 'Not Assessed' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEAttentionSpan','Not Assessed','N','Y','N')
END
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEAttentionSpan' AND CodeName= 'WNL- with good concentration and attention span' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEAttentionSpan','WNL- with good concentration and attention span','W','Y','N')
END

--Insert script GlobalCodeCategories -- Thought Content
IF(NOT EXISTS(SELECT Category FROM GlobalCodeCategories WHERE CATEGORY='MSEThoughtContent'))
BEGIN
	INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes) 
	VALUES('MSEThoughtContent','MSEThoughtContent','Y','Y','Y','Y','Y','N')
END
--Insert script Globalcodes
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEThoughtContent' AND CodeName= 'Assessed all sections below' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEThoughtContent','Assessed all sections below','A','Y','N')
END
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEThoughtContent' AND CodeName= 'Not Assessed' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEThoughtContent','Not Assessed','N','Y','N')
END
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEThoughtContent' AND CodeName= 'WNL for age – coherent and goal directed with no evidence of abnormal or delusional thought content or cognitive disturbance; good fund of knowledge' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEThoughtContent','WNL for age – coherent and goal directed with no evidence of abnormal or delusional thought content or cognitive disturbance; good fund of knowledge','W','Y','N')
END

--Insert script GlobalCodeCategories -- Associations
IF(NOT EXISTS(SELECT Category FROM GlobalCodeCategories WHERE CATEGORY='MSEAssociations'))
BEGIN
	INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes) 
	VALUES('MSEAssociations','MSEAssociations','Y','Y','Y','Y','Y','N')
END
--Insert script Globalcodes
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEAssociations' AND CodeName= 'Assessed all sections below' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEAssociations','Assessed all sections below','A','Y','N')
END
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEAssociations' AND CodeName= 'Not Assessed' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEAssociations','Not Assessed','N','Y','N')
END
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEAssociations' AND CodeName= 'WNL - Intact' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEAssociations','WNL - Intact','W','Y','N')
END

--Insert script GlobalCodeCategories -- Psychotic Thoughts
IF(NOT EXISTS(SELECT Category FROM GlobalCodeCategories WHERE CATEGORY='MSEPsychoticThoughts'))
BEGIN
	INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes) 
	VALUES('MSEPsychoticThoughts','MSEPsychoticThoughts','Y','Y','Y','Y','Y','N')
END
--Insert script Globalcodes
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEPsychoticThoughts' AND CodeName= 'Assessed' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEPsychoticThoughts','Assessed','A','Y','N')
END
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEPsychoticThoughts' AND CodeName= 'Not Assessed' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEPsychoticThoughts','Not Assessed','N','Y','N')
END

--Insert script GlobalCodeCategories -- Psychosis/Disturbance
IF(NOT EXISTS(SELECT Category FROM GlobalCodeCategories WHERE CATEGORY='MSEPsychoDisturbance'))
BEGIN
	INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes) 
	VALUES('MSEPsychoDisturbance','MSEPsychoDisturbance','Y','Y','Y','Y','Y','N')
END
--Insert script Globalcodes
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEPsychoDisturbance' AND CodeName= 'None' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEPsychoDisturbance','None','N','Y','N')
END
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEPsychoDisturbance' AND CodeName= 'Present(leave items below unchecked if not present)' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEPsychoDisturbance','Present(leave items below unchecked if not present)','P','Y','N')
END
--Insert script GlobalCodeCategories -- Orientation
IF(NOT EXISTS(SELECT Category FROM GlobalCodeCategories WHERE CATEGORY='MSEOrientation'))
BEGIN
	INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes) 
	VALUES('MSEOrientation','MSEOrientation','Y','Y','Y','Y','Y','N')
END

--Insert script Globalcodes

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEOrientation' AND CodeName= 'Assessed' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEOrientation','Assessed','A','Y','N')
END
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEOrientation' AND CodeName= 'Not Assessed' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEOrientation','Not Assessed','N','Y','N')
END
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEOrientation' AND CodeName= 'WNL- Oriented to person, place, time, situation' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEOrientation','WNL- Oriented to person, place, time, situation','W','Y','N')
END

--Insert script GlobalCodeCategories -- Fund of Knowledge
IF(NOT EXISTS(SELECT Category FROM GlobalCodeCategories WHERE CATEGORY='MSEFundOfKnowledge'))
BEGIN
	INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes) 
	VALUES('MSEFundOfKnowledge','MSEFundOfKnowledge','Y','Y','Y','Y','Y','N')
END

--Insert script Globalcodes

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEFundOfKnowledge' AND CodeName= 'Assessed' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEFundOfKnowledge','Assessed','A','Y','N')
END
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEFundOfKnowledge' AND CodeName= 'Not Assessed' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEFundOfKnowledge','Not Assessed','N','Y','N')
END
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEFundOfKnowledge' AND CodeName= 'Fund of knowledge WNL for developmental level' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEFundOfKnowledge','Fund of knowledge WNL for developmental level','W','Y','N')
END

--Insert script GlobalCodeCategories -- Insight 
IF(NOT EXISTS(SELECT Category FROM GlobalCodeCategories WHERE CATEGORY='MSEInsight'))
BEGIN
	INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes) 
	VALUES('MSEInsight','MSEInsight','Y','Y','Y','Y','Y','N')
END

--Insert script Globalcodes

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEInsight' AND CodeName= 'Excellent' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEInsight','Excellent','E','Y','N')
END
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEInsight' AND CodeName= 'Good' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEInsight','Good','G','Y','N')
END
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEInsight' AND CodeName= 'Fair' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEInsight','Fair','F','Y','N')
END
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEInsight' AND CodeName= 'Poor' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEInsight','Poor','P','Y','N')
END
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEInsight' AND CodeName= 'Grossly Impaired' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEInsight','Grossly Impaired','R','Y','N')
END

--Insert script GlobalCodeCategories -- Memory
IF(NOT EXISTS(SELECT Category FROM GlobalCodeCategories WHERE CATEGORY='MSEMemory'))
BEGIN
	INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes) 
	VALUES('MSEMemory','MSEMemory','Y','Y','Y','Y','Y','N')
END

--Insert script Globalcodes

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEMemory' AND CodeName= 'Good' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEMemory','Good','G','Y','N')
END
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEMemory' AND CodeName= 'Fair' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEMemory','Fair','F','Y','N')
END
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEMemory' AND CodeName= 'Impaired' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEMemory','Impaired','I','Y','N')
END

--Insert script GlobalCodeCategories- Muscle Strength
IF(NOT EXISTS(SELECT Category FROM GlobalCodeCategories WHERE CATEGORY='MSEMuscleStrength'))
BEGIN
	INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes) 
	VALUES('MSEMuscleStrength','MSEMuscleStrength','Y','Y','Y','Y','Y','N')
END

--Insert script Globalcodes

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEMuscleStrength' AND CodeName= 'Assessed' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEMuscleStrength','Assessed','A','Y','N')
END
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEMuscleStrength' AND CodeName= 'Not Assessed' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEMuscleStrength','Not Assessed','N','Y','N')
END
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEMuscleStrength' AND CodeName= 'WNL' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEMuscleStrength','WNL','W','Y','N')
END

--Insert script GlobalCodeCategories- Review
IF(NOT EXISTS(SELECT Category FROM GlobalCodeCategories WHERE CATEGORY='MSEReview'))
BEGIN
	INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes) 
	VALUES('MSEReview','MSEReview','Y','Y','Y','Y','Y','N')
END

--Insert script Globalcodes

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEReview' AND CodeName= 'Review with changes' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEReview','Review with changes','C','Y','N')
END
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEReview' AND CodeName= 'Review with no changes' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEReview','Review with no changes','N','Y','N')
END
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEReview' AND CodeName= 'N/A' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEReview','N/A','A','Y','N')
END