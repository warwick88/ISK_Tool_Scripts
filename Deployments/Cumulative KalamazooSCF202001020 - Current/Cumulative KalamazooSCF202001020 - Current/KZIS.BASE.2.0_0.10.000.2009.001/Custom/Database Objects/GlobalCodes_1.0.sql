-- GlobalCodes for Columbia

-- Yes or No
IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XCSSRSYESNO' AND Category = 'XCSSRSYESNO')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes)
	VALUES ('XCSSRSYESNO','XCSSRSYESNO','Y','Y','Y','Y','KCMHSAS - Improvements -#7','N','N')
END


IF NOT EXISTS (SELECT * FROM GlobalCodes WHERE Category = 'XCSSRSYESNO' AND CodeName = 'Yes')
BEGIN
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XCSSRSYESNO','Yes','KCMHSAS - Improvements -#7','Y','N',1)
END

IF NOT EXISTS (SELECT * FROM GlobalCodes WHERE Category = 'XCSSRSYESNO' AND CodeName = 'Yes')
BEGIN
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XCSSRSYESNO','No','KCMHSAS - Improvements -#7','Y','N',2)
END
-- Severity

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XSEVERITY' AND Category = 'XSEVERITY')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes)
	VALUES ('XSEVERITY','XSEVERITY','Y','Y','Y','Y','KCMHSAS - Improvements -#7','N','N')
END

IF NOT EXISTS (SELECT * FROM GlobalCodes WHERE Category = 'XSEVERITY' AND CodeName = '1')
BEGIN
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XSEVERITY','1','KCMHSAS - Improvements -#7','Y','N',1)
END

IF NOT EXISTS (SELECT * FROM GlobalCodes WHERE Category = 'XSEVERITY' AND CodeName = '2')
BEGIN
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XSEVERITY','2','KCMHSAS - Improvements -#7','Y','N',2)
END

IF NOT EXISTS (SELECT * FROM GlobalCodes WHERE Category = 'XSEVERITY' AND CodeName = '3')
BEGIN
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES('XSEVERITY','3','KCMHSAS - Improvements -#7','Y','N',3)
END

IF NOT EXISTS (SELECT * FROM GlobalCodes WHERE Category = 'XSEVERITY' AND CodeName = '4')
BEGIN
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES('XSEVERITY','4','KCMHSAS - Improvements -#7','Y','N',4)
END

IF NOT EXISTS (SELECT * FROM GlobalCodes WHERE Category = 'XSEVERITY' AND CodeName = '5')
BEGIN
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES('XSEVERITY','5','KCMHSAS - Improvements -#7','Y','N',5)
END


-- Frequency One

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XFrequencyOne' AND Category = 'XFrequencyOne')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes)
	VALUES ('XFrequencyOne','XFrequencyOne','Y','Y','Y','Y','KCMHSAS - Improvements -#7','N','N')
END

IF NOT EXISTS (SELECT * FROM GlobalCodes WHERE Category = 'XFrequencyOne' AND CodeName = '1')
BEGIN
	INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
	VALUES ('XFrequencyOne','1','KCMHSAS - Improvements -#7','Y','N',1)
END

IF NOT EXISTS (SELECT * FROM GlobalCodes WHERE Category = 'XFrequencyOne' AND CodeName = '2')
BEGIN
	INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
	VALUES('XFrequencyOne','2','KCMHSAS - Improvements -#7','Y','N',2)
END

IF NOT EXISTS (SELECT * FROM GlobalCodes WHERE Category = 'XFrequencyOne' AND CodeName = '3')
BEGIN
	INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
	VALUES('XFrequencyOne','3','KCMHSAS - Improvements -#7','Y','N',3)
END

IF NOT EXISTS (SELECT * FROM GlobalCodes WHERE Category = 'XFrequencyOne' AND CodeName = '4')
BEGIN
	INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
	VALUES('XFrequencyOne','4','KCMHSAS - Improvements -#7','Y','N',4)
END

IF NOT EXISTS (SELECT * FROM GlobalCodes WHERE Category = 'XFrequencyOne' AND CodeName = '5')
BEGIN
	INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
	VALUES('XFrequencyOne','5','KCMHSAS - Improvements -#7','Y','N',5)
END

IF NOT EXISTS (SELECT * FROM GlobalCodes WHERE Category = 'XFrequencyOne' AND CodeName = '6')
BEGIN
	INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
	VALUES('XFrequencyOne','6','KCMHSAS - Improvements -#7','Y','N',6)
END



-- Frequency Two

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XFrequencyTwo' AND Category = 'XFrequencyTwo')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes)
	VALUES ('XFrequencyTwo','XFrequencyTwo','Y','Y','Y','Y','KCMHSAS - Improvements -#7','N','N')
END

IF NOT EXISTS (SELECT * FROM GlobalCodes WHERE Category = 'XFrequencyOne' AND CodeName = '1')
BEGIN
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XFrequencyTwo','1','KCMHSAS - Improvements -#7','Y','N',1)
END
IF NOT EXISTS (SELECT * FROM GlobalCodes WHERE Category = 'XFrequencyTwo' AND CodeName = '2')
BEGIN
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XFrequencyTwo','2','KCMHSAS - Improvements -#7','Y','N',2)
END

IF NOT EXISTS (SELECT * FROM GlobalCodes WHERE Category = 'XFrequencyTwo' AND CodeName = '3')
BEGIN
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XFrequencyTwo','3','KCMHSAS - Improvements -#7','Y','N',3)
END

IF NOT EXISTS (SELECT * FROM GlobalCodes WHERE Category = 'XFrequencyTwo' AND CodeName = '4')
BEGIN
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES('XFrequencyTwo','4','KCMHSAS - Improvements -#7','Y','N',4)
END

IF NOT EXISTS (SELECT * FROM GlobalCodes WHERE Category = 'XFrequencyTwo' AND CodeName = '5')
BEGIN
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XFrequencyTwo','5','KCMHSAS - Improvements -#7','Y','N',5)
END

IF NOT EXISTS (SELECT * FROM GlobalCodes WHERE Category = 'XFrequencyTwo' AND CodeName = '6')
BEGIN
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XFrequencyTwo','6','KCMHSAS - Improvements -#7','Y','N',6)
END



IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XConDetReason' AND Category = 'XConDetReason')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes)
	VALUES ('XConDetReason','XConDetReason','Y','Y','Y','Y','KCMHSAS - Improvements -#7','N','N')
END

IF NOT EXISTS (SELECT * FROM GlobalCodes WHERE Category = 'XConDetReason' AND CodeName = '1')
BEGIN
	INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
	VALUES ('XConDetReason','1','KCMHSAS - Improvements -#7','Y','N',1)
END

IF NOT EXISTS (SELECT * FROM GlobalCodes WHERE Category = 'XConDetReason' AND CodeName = '2')
BEGIN
	INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
	VALUES('XConDetReason','2','KCMHSAS - Improvements -#7','Y','N',2)
END
IF NOT EXISTS (SELECT * FROM GlobalCodes WHERE Category = 'XConDetReason' AND CodeName = '3')
BEGIN
	INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
	VALUES('XConDetReason','3','KCMHSAS - Improvements -#7','Y','N',3)
END
IF NOT EXISTS (SELECT * FROM GlobalCodes WHERE Category = 'XConDetReason' AND CodeName = '4')
BEGIN
	INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
	VALUES('XConDetReason','4','KCMHSAS - Improvements -#7','Y','N',4)
END
IF NOT EXISTS (SELECT * FROM GlobalCodes WHERE Category = 'XConDetReason' AND CodeName = '5')
BEGIN
	INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
	VALUES('XConDetReason','5','KCMHSAS - Improvements -#7','Y','N',5)
END
IF NOT EXISTS (SELECT * FROM GlobalCodes WHERE Category = 'XConDetReason' AND CodeName = '0')
BEGIN
	INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
	VALUES('XConDetReason','0','KCMHSAS - Improvements -#7','Y','N',6)
END
-- GlobalCodes for Actual Lethality 

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XActualLethality' AND Category = 'XActualLethality')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes)
	VALUES ('XActualLethality','XActualLethality','Y','Y','Y','Y','KCMHSAS - Improvements -#7','N','N')
END

IF NOT EXISTS (SELECT * FROM GlobalCodes WHERE Category = 'XActualLethality' AND CodeName = '0 - No physical damage or very minor')
BEGIN	
	INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
	VALUES ('XActualLethality','0 - No physical damage or very minor','KCMHSAS - Improvements -#7','Y','N',1)
END

IF NOT EXISTS (SELECT * FROM GlobalCodes WHERE Category = 'XActualLethality' AND CodeName = '1 - Minor physical damage')
BEGIN
	INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
	VALUES('XActualLethality','1 - Minor physical damage','KCMHSAS - Improvements -#7','Y','N',2)
END
IF NOT EXISTS (SELECT * FROM GlobalCodes WHERE Category = 'XActualLethality' AND CodeName = '2 - Moderate physical damage')
BEGIN
	INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
	VALUES('XActualLethality','2 - Moderate physical damage','KCMHSAS - Improvements -#7','Y','N',3)
END
IF NOT EXISTS (SELECT * FROM GlobalCodes WHERE Category = 'XActualLethality' AND CodeName = '3 - Moderately severe physical damage')
BEGIN
	INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
	VALUES('XActualLethality','3 - Moderately severe physical damage','KCMHSAS - Improvements -#7','Y','N',4)
END
IF NOT EXISTS (SELECT * FROM GlobalCodes WHERE Category = 'XActualLethality' AND CodeName = '4 - Severe physical damage')
BEGIN
	INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
	VALUES('XActualLethality','4 - Severe physical damage','KCMHSAS - Improvements -#7','Y','N',5)
END

IF NOT EXISTS (SELECT * FROM GlobalCodes WHERE Category = 'XActualLethality' AND CodeName = '5 - Death')
BEGIN
	INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
	VALUES('XActualLethality','5 - Death','KCMHSAS - Improvements -#7','Y','N',6)
END

-- GlobalCodes for Potential Lethality 

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XPotentialLethality' AND Category = 'XPotentialLethality')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes)
	VALUES ('XPotentialLethality','XPotentialLethality','Y','Y','Y','Y','KCMHSAS - Improvements -#7','N','N')
END

IF NOT EXISTS (SELECT * FROM GlobalCodes WHERE Category = 'XPotentialLethality' AND CodeName = '0 - Behavior not likely to result in injury')
BEGIN
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XPotentialLethality','0 - Behavior not likely to result in injury','KCMHSAS - Improvements -#7','Y','N',1)
END
IF NOT EXISTS (SELECT * FROM GlobalCodes WHERE Category = 'XPotentialLethality' AND CodeName = '1 - Behavior likely to result in injury but not likely to cause death')
BEGIN
	INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
	VALUES('XPotentialLethality','1 - Behavior likely to result in injury but not likely to cause death','KCMHSAS - Improvements -#7','Y','N',2)
END

IF NOT EXISTS (SELECT * FROM GlobalCodes WHERE Category = 'XPotentialLethality' AND CodeName = '2 - Behavior likely to result in death despite available medical care')
BEGIN
	INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
	VALUES('XPotentialLethality','2 - Behavior likely to result in death despite available medical care','KCMHSAS - Improvements -#7','Y','N',3)
END



IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'XEMPLOYMENTSTATUS') 
	BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) 
	VALUES('XEMPLOYMENTSTATUS','XEMPLOYMENTSTATUS','Y','Y','Y','Y',NULL,'N','N','N','N') END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XEMPLOYMENTSTATUS' and CodeName= 'Employed Full Time (35 Hrs or More)') begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('XEMPLOYMENTSTATUS','Employed Full Time (35 Hrs or More)',NULL,'Y','N',0,'1') END  
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XEMPLOYMENTSTATUS' and CodeName= 'Employed Part Time (less than 35 Hrs)') begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('XEMPLOYMENTSTATUS','Employed Part Time (less than 35 Hrs)',NULL,'Y','N',0,'2') END 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XEMPLOYMENTSTATUS' and CodeName= 'Supported/Trans Employment') begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('XEMPLOYMENTSTATUS','Supported/Trans Employment',NULL,'Y','N',0,'13') END 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XEMPLOYMENTSTATUS' and CodeName= 'Homemaker') begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('XEMPLOYMENTSTATUS','Homemaker',NULL,'Y','N',0,'11') END 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XEMPLOYMENTSTATUS' and CodeName= 'Student') begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('XEMPLOYMENTSTATUS','Student',NULL,'Y','N',0,'15') END 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XEMPLOYMENTSTATUS' and CodeName= 'Retired') begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('XEMPLOYMENTSTATUS','Retired',NULL,'Y','N',0,'14') END 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XEMPLOYMENTSTATUS' and CodeName= 'Unemployed, seeking work') begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('XEMPLOYMENTSTATUS','Unemployed, seeking work',NULL,'Y','N',0,'7') END 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XEMPLOYMENTSTATUS' and CodeName= 'Unemployed, NOT seeking work') begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('XEMPLOYMENTSTATUS','Unemployed, NOT seeking work',NULL,'Y','N',0,'12') END 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XEMPLOYMENTSTATUS' and CodeName= 'Disabled - Not in Labor Force') begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('XEMPLOYMENTSTATUS','Disabled - Not in Labor Force',NULL,'Y','N',0,'3') END 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XEMPLOYMENTSTATUS' and CodeName= 'Ages 0-5') begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('XEMPLOYMENTSTATUS','Ages 0-5',NULL,'Y','N',0,'10') END 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XEMPLOYMENTSTATUS' and CodeName= 'Unknown') begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) values('XEMPLOYMENTSTATUS','Unknown',NULL,'Y','N',0) END 


IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'XLIVINGARRANGEMENT') 
	BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) 
	VALUES('XLIVINGARRANGEMENT','XLIVINGARRANGEMENT','Y','Y','Y','Y',NULL,'N','N','N','N') END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XLIVINGARRANGEMENT' and CodeName= 'On Street/Homeless Shelter') begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) values('XLIVINGARRANGEMENT','On Street/Homeless Shelter',NULL,'Y','N',0) END 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XLIVINGARRANGEMENT' and CodeName= 'Private Residence-Independent') begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) values('XLIVINGARRANGEMENT','Private Residence-Independent',NULL,'Y','N',0) END 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XLIVINGARRANGEMENT' and CodeName= 'Private Residence-Dependent') begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) values('XLIVINGARRANGEMENT','Private Residence-Dependent',NULL,'Y','N',0) END 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XLIVINGARRANGEMENT' and CodeName= 'Jail/Correctional Facility Institutional Setting (NH, IMD, Psych, IP, VA, State Hospital)') begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) values('XLIVINGARRANGEMENT','Jail/Correctional Facility Institutional Setting (NH, IMD, Psych, IP, VA, State Hospital)',NULL,'Y','N',0) END 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XLIVINGARRANGEMENT' and CodeName= '24 Hour Residential Care') begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) values('XLIVINGARRANGEMENT','24 Hour Residential Care',NULL,'Y','N',0) END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XLIVINGARRANGEMENT' and CodeName= 'Adult/Child Foster Home') begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) values('XLIVINGARRANGEMENT','Adult/Child Foster Home',NULL,'Y','N',0) END 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XLIVINGARRANGEMENT' and CodeName= 'Unknown') begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) values('XLIVINGARRANGEMENT','Unknown',NULL,'Y','N',0) END 