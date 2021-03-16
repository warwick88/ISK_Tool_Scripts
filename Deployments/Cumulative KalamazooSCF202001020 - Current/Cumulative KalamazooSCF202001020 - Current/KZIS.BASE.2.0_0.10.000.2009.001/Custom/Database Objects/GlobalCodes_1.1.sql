IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'XRiskFactorLookup') 
	BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) 
	VALUES('XRiskFactorLookup','XRiskFactorLookup','Y','Y','Y','Y',NULL,'N','N','N','N') END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= '“All or none” thinking') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','“All or none” thinking',NULL,'Y','N',1) END 
	
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Acting out behavior at home and/or school') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Acting out behavior at home and/or school',NULL,'Y','N',2) 
	END 	

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Client has access to weapons') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Client has access to weapons',NULL,'Y','N',3) END

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Constricted thinking') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Constricted thinking',NULL,'Y','N',4) END 
	 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Dangerous neighborhood') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Dangerous neighborhood',NULL,'Y','N',5) END 
	

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Diagnosis of Major Depression, Personality Disorder, Alcohol/Drug Abuse or Dependence or Dissociative Disorder') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Diagnosis of Major Depression, Personality Disorder, Alcohol/Drug Abuse or Dependence or Dissociative Disorder',NULL,'Y','N',6) END 
	 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Drug manufacturing or selling in the home') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Drug manufacturing or selling in the home',NULL,'Y','N',7) END 
	
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Egosyntonic attitude') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Egosyntonic attitude',NULL,'Y','N',8) END 
	

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Explosive Behavior') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Explosive Behavior',NULL,'Y','N',9) END 
	

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Family – minimal or no support') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Family – minimal or no support',NULL,'Y','N',10) END 
	

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Family support available, but unwilling to help') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Family support available, but unwilling to help',NULL,'Y','N',11) END 
	

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Gambling') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Gambling',NULL,'Y','N',12) END 
	

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Giving away personal possessions') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Giving away personal possessions',NULL,'Y','N',13) END 
	
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Helplessness') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Helplessness',NULL,'Y','N',14) END 
	 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'History of 2 or more suicide attempts in past 24 months') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','History of 2 or more suicide attempts in past 24 months',NULL,'Y','N',15) END 
	  

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'History of family completions') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','History of family completions',NULL,'Y','N',16) END 
	  

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Hoarding') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Hoarding',NULL,'Y','N',17) END 
	

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Hopelessness') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Hopelessness',NULL,'Y','N',18) END 
	

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Impulsive Behavior') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Impulsive Behavior',NULL,'Y','N',19) END 
	 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Interpersonal conflicts') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Interpersonal conflicts',NULL,'Y','N',19) END 
	
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'LGBT factors and acceptance') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','LGBT factors and acceptance',NULL,'Y','N',20) END 
	

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Loss of emotional support system') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Loss of emotional support system',NULL,'Y','N',21) END 
	

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Making preparations') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Making preparations',NULL,'Y','N',22) END 
	

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'No ambivalence') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','No ambivalence',NULL,'Y','N',23) END 
	

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Other Risk Factor(s)') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Other Risk Factor(s)',NULL,'Y','N',24) END 
	

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Poor Ability to Communicate') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Poor Ability to Communicate',NULL,'Y','N',25) END 
	

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Previous rescue(s) accidental') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Previous rescue(s) accidental',NULL,'Y','N',26) END 
	

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Sexual Addictions') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Sexual Addictions',NULL,'Y','N',27) END 
	

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Sexual Reactivity') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Sexual Reactivity',NULL,'Y','N',28) END 
	

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Substance abuse / dependence') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Substance abuse / dependence',NULL,'Y','N',28) END 
	

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Unusual Behavior') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Unusual Behavior',NULL,'Y','N',29) END 
	

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Video Game Addictions') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Video Game Addictions',NULL,'Y','N',30) END 
	

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Volatile living environment') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Volatile living environment',NULL,'Y','N',31) END 
	

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Withdrawn or isolated') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Withdrawn or isolated',NULL,'Y','N',31) END 



--GLOBALCODE SCRIPT FOR PSYCHO SOCIAL CHILD AND ADULT ADDED BY VEENA


IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XPSDDRISKDUETO' and CodeName= 'Support Limitations') 
BEGIN
INSERT INTO [GlobalCodes] ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1])
VALUES('XPSDDRISKDUETO','Support Limitations',NULL,'Y','Y',NULL)
END

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XPSDDRISKDUETO' and CodeName= 'Support Limitations') 
BEGIN
INSERT INTO [GlobalCodes] ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1])VALUES('XPSDDRISKDUETO','Behavioral Issues',NULL,'Y','Y',NULL)
END

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XPSDDRISKDUETO' and CodeName= 'Medical Issues') 
BEGIN
INSERT INTO [GlobalCodes] ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1])VALUES('XPSDDRISKDUETO','Medical Issues',NULL,'Y','Y',NULL)
END

IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'XHHoptions1') 
	BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) 
	VALUES('XHHoptions1','XHHoptions1','Y','Y','Y','Y',NULL,'N','N','N','N') END 


IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XHHoptions1' and CodeName= 'Almost all of the time') 
BEGIN
INSERT INTO [GlobalCodes] ([Category],[CodeName],[code],[Active],[CannotModifyNameOrDelete],[ExternalCode1])
VALUES('XHHoptions1','Almost all of the time','1','Y','N',NULL)
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XHHoptions1' and CodeName= 'Most of the time') 
BEGIN
INSERT INTO [GlobalCodes] ([Category],[CodeName],[code],[Active],[CannotModifyNameOrDelete],[ExternalCode1])VALUES('XHHoptions1','Most of the time','2','Y','N',NULL)
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XHHoptions1' and CodeName= 'Some of the time') 
BEGIN
INSERT INTO [GlobalCodes] ([Category],[CodeName],[code],[Active],[CannotModifyNameOrDelete],[ExternalCode1])VALUES('XHHoptions1','Some of the time','3','Y','N',NULL)
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XHHoptions1' and CodeName= 'Almost Never') 
BEGIN
INSERT INTO [GlobalCodes] ([Category],[CodeName],[code],[Active],[CannotModifyNameOrDelete],[ExternalCode1])VALUES('XHHoptions1','Almost Never','4','Y','N',NULL)
END

IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'XHHPHQ9') 
	BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) 
	VALUES('XHHPHQ9','XHHPHQ9','Y','Y','Y','Y',NULL,'N','N','N','N') END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XHHPHQ9' and CodeName= '0 = Not at all') 
BEGIN
INSERT INTO [GlobalCodes] ([Category],[CodeName],[code],[Active],[CannotModifyNameOrDelete],[ExternalCode1])VALUES('XHHPHQ9','0 = Not at all','1','Y','N',NULL)
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XHHPHQ9' and CodeName= '1 = Several Days') 
BEGIN
INSERT INTO [GlobalCodes] ([Category],[CodeName],[code],[Active],[CannotModifyNameOrDelete],[ExternalCode1])VALUES('XHHPHQ9','1 = Several Days','2','Y','N',NULL)
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XHHPHQ9' and CodeName= '2 = More than half the days') 
BEGIN
INSERT INTO [GlobalCodes] ([Category],[CodeName],[code],[Active],[CannotModifyNameOrDelete],[ExternalCode1])VALUES('XHHPHQ9','2 = More than half the days','3','Y','N',NULL)
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XHHPHQ9' and CodeName= '3 = Nearly every day') 
BEGIN
INSERT INTO [GlobalCodes] ([Category],[CodeName],[code],[Active],[CannotModifyNameOrDelete],[ExternalCode1])VALUES('XHHPHQ9','3 = Nearly every day','4','Y','N',NULL)
END	