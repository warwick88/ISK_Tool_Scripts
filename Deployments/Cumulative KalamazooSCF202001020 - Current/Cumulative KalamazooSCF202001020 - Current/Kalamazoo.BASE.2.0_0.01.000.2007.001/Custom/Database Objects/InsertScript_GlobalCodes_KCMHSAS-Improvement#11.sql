IF NOT EXISTS (select * from globalcodecategories where category ='XEDUCATIONALLEVEL')
BEGIN 
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XEDUCATIONALLEVEL','XEDUCATIONALLEVEL','Y','Y','Y','Y','','N','N','Y')
END 

IF NOT EXISTS (select * from globalcodecategories where category ='XCDFORENSICTREATMENT')
BEGIN 
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XCDFORENSICTREATMENT','XCDFORENSICTREATMENT','Y','Y','Y','Y','','N','N','Y')
END 

IF NOT EXISTS (select * from globalcodecategories where category ='XCDLEGAL')
BEGIN 
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XCDLEGAL','XCDLEGAL','Y','Y','Y','Y','','N','N','Y')
END 

IF NOT EXISTS (select * from globalcodecategories where category ='XCDJUSTICEINVOLVEMEN')
BEGIN 
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XCDJUSTICEINVOLVEMEN','XCDJUSTICEINVOLVEMEN','Y','Y','Y','Y','','N','N','Y')
END 

IF NOT EXISTS (select * from globalcodecategories where category ='XADVANCEDIRECTIVE')
BEGIN 
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XADVANCEDIRECTIVE','XADVANCEDIRECTIVE','Y','Y','Y','Y','','N','N','Y')
END 
IF NOT EXISTS (select * from globalcodecategories where category ='XCDTOBACCOUSE')
BEGIN 
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XCDTOBACCOUSE','XCDTOBACCOUSE','Y','Y','Y','Y','','N','N','Y')
END 

IF NOT EXISTS (select * from globalcodes where category ='XCDFORENSICTREATMENT' and CodeName='Not applicable')
BEGIN 
	INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES 
('XCDFORENSICTREATMENT','Not applicable','KCMHSAS-Improvement-11','Y','N',1)
END

IF NOT EXISTS (select * from globalcodes where category ='XCDFORENSICTREATMENT' and CodeName='Department of corrections client')
BEGIN 
	INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES 
('XCDFORENSICTREATMENT','Department of corrections client','KCMHSAS-Improvement-11','Y','N',2)
END

IF NOT EXISTS (select * from globalcodes where category ='XCDFORENSICTREATMENT' and CodeName='Unable to stand trial')
BEGIN 
	INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES 
('XCDFORENSICTREATMENT','Unable to stand trial','KCMHSAS-Improvement-11','Y','N',3)
END

IF NOT EXISTS (select * from globalcodes where category ='XCDFORENSICTREATMENT' and CodeName='Unable to stand trial – extended Term')
BEGIN 
	INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES 
('XCDFORENSICTREATMENT','Unable to stand trial – extended Term','KCMHSAS-Improvement-11','Y','N',4)
END

IF NOT EXISTS (select * from globalcodes where category ='XCDFORENSICTREATMENT' and CodeName='Unable to stand trial – G2')
BEGIN 
	INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES 
('XCDFORENSICTREATMENT','Unable to stand trial – G2','KCMHSAS-Improvement-11','Y','N',5)
END

IF NOT EXISTS (select * from globalcodes where category ='XCDFORENSICTREATMENT' and CodeName='Not guilty by reason of insanity')
BEGIN 
	INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES 
('XCDFORENSICTREATMENT','Not guilty by reason of insanity','KCMHSAS-Improvement-11','Y','N',6)
END

IF NOT EXISTS (select * from globalcodes where category ='XCDFORENSICTREATMENT' and CodeName='Civil Court ordered – treatment')
BEGIN 
	INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES 
('XCDFORENSICTREATMENT','Civil Court ordered – treatment','KCMHSAS-Improvement-11','Y','N',7)
END

IF NOT EXISTS (select * from globalcodes where category ='XCDFORENSICTREATMENT' and CodeName='Criminal court – ordered treatment')
BEGIN 
	INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES 
('XCDFORENSICTREATMENT','Criminal court – ordered treatment','KCMHSAS-Improvement-11','Y','N',8)
END

IF NOT EXISTS (select * from globalcodes where category ='XCDFORENSICTREATMENT' and CodeName='Court- ordered evaluation/assessment only')
BEGIN 
	INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES 
('XCDFORENSICTREATMENT','Court- ordered evaluation/assessment only','KCMHSAS-Improvement-11','Y','N',9)
END

IF NOT EXISTS (select * from globalcodes where category ='XCDFORENSICTREATMENT' and CodeName='Declined to answer')
BEGIN 
	INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES 
('XCDFORENSICTREATMENT','Declined to answer','KCMHSAS-Improvement-11','Y','N',10)
END

IF NOT EXISTS (select * from globalcodes where category ='XCDFORENSICTREATMENT' and CodeName='New-(Justice Involved) OLD-Criminal Court Ordered Compelled for Tx')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XCDFORENSICTREATMENT','New-(Justice Involved) OLD-Criminal Court Ordered Compelled for Tx','KCMHSAS-Improvement-11','Y','N',11)
END


IF NOT EXISTS (select * from globalcodes where category ='XADVANCEDIRECTIVE' and CodeName='Yes')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES 
('XADVANCEDIRECTIVE','Yes','KCMHSAS-Improvement-11','Y','N',1)
END

IF NOT EXISTS (select * from globalcodes where category ='XADVANCEDIRECTIVE' and CodeName='No')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES 
('XADVANCEDIRECTIVE','No','KCMHSAS-Improvement-11','Y','N',2)
END


IF NOT EXISTS (select * from globalcodes where category ='XCDLEGAL' and CodeName='Voluntary')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XCDLEGAL','Voluntary','KCMHSAS-Improvement-11','Y','N',1)
END

IF NOT EXISTS (select * from globalcodes where category ='XCDLEGAL' and CodeName='Involuntary - Civil')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XCDLEGAL','Involuntary - Civil','KCMHSAS-Improvement-11','Y','N',2)
END

IF NOT EXISTS (select * from globalcodes where category ='XCDLEGAL' and CodeName='Involuntary - Criminal')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XCDLEGAL','Involuntary - Criminal','KCMHSAS-Improvement-11','Y','N',3)
END

IF NOT EXISTS (select * from globalcodes where category ='XCDLEGAL' and CodeName='Unrecorded')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XCDLEGAL','Unrecorded','KCMHSAS-Improvement-11','Y','N',4)
END

-- DELETE FROM GlobalCodes WHERE Category = 'XCDTOBACCOUSE'
IF NOT EXISTS (select * from globalcodes where category ='XCDTOBACCOUSE' and CodeName='NEVER SMOKED/VAPED')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES 
('XCDTOBACCOUSE','NEVER SMOKED/VAPED','KCMHSAS-Improvement-11','Y','N',1)
END

IF NOT EXISTS (select * from globalcodes where category ='XCDTOBACCOUSE' and CodeName='FORMER SMOKER/E-CIG USER')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XCDTOBACCOUSE','FORMER SMOKER/E-CIG USER','KCMHSAS-Improvement-11','Y','N',2)
END
IF NOT EXISTS (select * from globalcodes where category ='XCDTOBACCOUSE' and CodeName='CURRENT SOME DAY SMOKER/E-CIG USER')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XCDTOBACCOUSE','CURRENT SOME DAY SMOKER/E-CIG USER','KCMHSAS-Improvement-11','Y','N',3)
END

IF NOT EXISTS (select * from globalcodes where category ='XCDTOBACCOUSE' and CodeName='CURRENT EVERDAY SMOKER/E-CIG USER')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XCDTOBACCOUSE','CURRENT EVERDAY SMOKER/E-CIG USER','KCMHSAS-Improvement-11','Y','N',4)
END

IF NOT EXISTS (select * from globalcodes where category ='XCDTOBACCOUSE' and CodeName='USE SMOKELESS TOBACCO ONLY (In last 30 days)')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XCDTOBACCOUSE','USE SMOKELESS TOBACCO ONLY (In last 30 days)','KCMHSAS-Improvement-11','Y','N',5)
END

IF NOT EXISTS (select * from globalcodes where category ='XCDTOBACCOUSE' and CodeName='FORMER SMOKING STATUS UNKNOWN')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XCDTOBACCOUSE','FORMER SMOKING STATUS UNKNOWN','KCMHSAS-Improvement-11','Y','N',6)
END

IF NOT EXISTS (select * from globalcodes where category ='XCDTOBACCOUSE' and CodeName='Never Smoked')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XCDTOBACCOUSE','Never Smoked','KCMHSAS-Improvement-11','Y','N',7)
END

IF NOT EXISTS (select * from globalcodes where category ='XCDTOBACCOUSE' and CodeName='Former Smoker')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XCDTOBACCOUSE','Former Smoker','KCMHSAS-Improvement-11','Y','N',8)
END
IF NOT EXISTS (select * from globalcodes where category ='XCDTOBACCOUSE' and CodeName='Current Some Day Smoker')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XCDTOBACCOUSE','Current Some Day Smoker','KCMHSAS-Improvement-11','Y','N',9)
END

IF NOT EXISTS (select * from globalcodes where category ='XCDTOBACCOUSE' and CodeName='Current Everyday Smoker')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XCDTOBACCOUSE','Current Everyday Smoker','KCMHSAS-Improvement-11','Y','N',10)
END

IF NOT EXISTS (select * from globalcodes where category ='XCDTOBACCOUSE' and CodeName='Use Smokeless tobacco Only (In last 30 days)')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XCDTOBACCOUSE','Use Smokeless tobacco Only (In last 30 days)','KCMHSAS-Improvement-11','Y','N',11)
END
IF NOT EXISTS (select * from globalcodes where category ='XCDTOBACCOUSE' and CodeName='Current Status Unknown')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XCDTOBACCOUSE','Current Status Unknown','KCMHSAS-Improvement-11','Y','N',12)
END
IF NOT EXISTS (select * from globalcodes where category ='XCDTOBACCOUSE' and CodeName='NOT APPLICABLE')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XCDTOBACCOUSE','NOT APPLICABLE','KCMHSAS-Improvement-11','Y','N',13)
END
IF NOT EXISTS (select * from globalcodes where category ='XCDTOBACCOUSE' and CodeName='FORMER SMOKING STATUS UNKNOWN')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XCDTOBACCOUSE','FORMER SMOKING STATUS UNKNOWN','KCMHSAS-Improvement-11','Y','N',14)
END

IF NOT EXISTS (select * from globalcodes where category ='XCDTOBACCOUSE' and CodeName='E-CIGARETTES/VAPE')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XCDTOBACCOUSE','E-CIGARETTES/VAPE','KCMHSAS-Improvement-11','Y','N',15)
END

--DELETE FROM GlobalCodes WHERE Category = 'XCDJUSTICEINVOLVEMEN'

IF NOT EXISTS (select * from globalcodes where category ='XCDJUSTICEINVOLVEMEN' and CodeName='Not applicable')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XCDJUSTICEINVOLVEMEN','Not applicable','KCMHSAS-Improvement-11','Y','N',1)
END


IF NOT EXISTS (select * from globalcodes where category ='XCDJUSTICEINVOLVEMEN' and CodeName='Arrested')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XCDJUSTICEINVOLVEMEN','Arrested','KCMHSAS-Improvement-11','Y','N',2)
END
IF NOT EXISTS (select * from globalcodes where category ='XCDJUSTICEINVOLVEMEN' and CodeName='Charged with a crime')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XCDJUSTICEINVOLVEMEN','Charged with a crime','KCMHSAS-Improvement-11','Y','N',3)
END

IF NOT EXISTS (select * from globalcodes where category ='XCDJUSTICEINVOLVEMEN' and CodeName='Incarcerated – Jail')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XCDJUSTICEINVOLVEMEN','Incarcerated – Jail','KCMHSAS-Improvement-11','Y','N',4)
END

IF NOT EXISTS (select * from globalcodes where category ='XCDJUSTICEINVOLVEMEN' and CodeName='Incarcerated – Prison')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XCDJUSTICEINVOLVEMEN','Incarcerated – Prison','KCMHSAS-Improvement-11','Y','N',4)
END

IF NOT EXISTS (select * from globalcodes where category ='XCDJUSTICEINVOLVEMEN' and CodeName='Detained – Jail')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XCDJUSTICEINVOLVEMEN','Detained – Jail','KCMHSAS-Improvement-11','Y','N',4)
END

IF NOT EXISTS (select * from globalcodes where category ='XCDJUSTICEINVOLVEMEN' and CodeName='Mental Health Court')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XCDJUSTICEINVOLVEMEN','Mental Health Court','KCMHSAS-Improvement-11','Y','N',4)
END

IF NOT EXISTS (select * from globalcodes where category ='XCDJUSTICEINVOLVEMEN' and CodeName='Other')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XCDJUSTICEINVOLVEMEN','Other','KCMHSAS-Improvement-11','Y','N',4)
END

IF NOT EXISTS (select * from globalcodes where category ='XCDJUSTICEINVOLVEMEN' and CodeName='Unknown, decline to answer')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES('XCDJUSTICEINVOLVEMEN','Unknown, decline to answer','KCMHSAS-Improvement-11','Y','N',4)
END

	

-- DELETE FROM GlobalCodes WHERE Category = 'XEDUCATIONALLEVEL'


IF NOT EXISTS (select * from globalcodes where category ='XEDUCATIONALLEVEL' and CodeName='Preschool/Nursery/Head St')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XEDUCATIONALLEVEL','Preschool/Nursery/Head St','KCMHSAS-Improvement-11','Y','N',1)
END

IF NOT EXISTS (select * from globalcodes where category ='XEDUCATIONALLEVEL' and CodeName='Kindergarten')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XEDUCATIONALLEVEL','Kindergarten','KCMHSAS-Improvement-11','Y','N',2)
END

IF NOT EXISTS (select * from globalcodes where category ='XEDUCATIONALLEVEL' and CodeName='1st Grade')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XEDUCATIONALLEVEL','1st Grade','KCMHSAS-Improvement-11','Y','N',3)
END

IF NOT EXISTS (select * from globalcodes where category ='XEDUCATIONALLEVEL' and CodeName='2nd Grade')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XEDUCATIONALLEVEL','2nd Grade','KCMHSAS-Improvement-11','Y','N',4)
END

IF NOT EXISTS (select * from globalcodes where category ='XEDUCATIONALLEVEL' and CodeName='3rd Grade')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XEDUCATIONALLEVEL','3rd Grade','KCMHSAS-Improvement-11','Y','N',5)
END

IF NOT EXISTS (select * from globalcodes where category ='XEDUCATIONALLEVEL' and CodeName='4th Grade')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XEDUCATIONALLEVEL','4th Grade','KCMHSAS-Improvement-11','Y','N',6)
END

IF NOT EXISTS (select * from globalcodes where category ='XEDUCATIONALLEVEL' and CodeName='5th Grade')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XEDUCATIONALLEVEL','5th Grade','KCMHSAS-Improvement-11','Y','N',6)
END

IF NOT EXISTS (select * from globalcodes where category ='XEDUCATIONALLEVEL' and CodeName='6th Grade')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XEDUCATIONALLEVEL','6th Grade','KCMHSAS-Improvement-11','Y','N',7)
END

IF NOT EXISTS (select * from globalcodes where category ='XEDUCATIONALLEVEL' and CodeName='7th Grade')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XEDUCATIONALLEVEL','7th Grade','KCMHSAS-Improvement-11','Y','N',8)
END

IF NOT EXISTS (select * from globalcodes where category ='XEDUCATIONALLEVEL' and CodeName='8th Grade')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XEDUCATIONALLEVEL','8th Grade','KCMHSAS-Improvement-11','Y','N',9)
END

IF NOT EXISTS (select * from globalcodes where category ='XEDUCATIONALLEVEL' and CodeName='9th Grade')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES('XEDUCATIONALLEVEL','9th Grade','KCMHSAS-Improvement-11','Y','N',10)
END

IF NOT EXISTS (select * from globalcodes where category ='XEDUCATIONALLEVEL' and CodeName='10th Grade')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XEDUCATIONALLEVEL','10th Grade','KCMHSAS-Improvement-11','Y','N',11)
END

IF NOT EXISTS (select * from globalcodes where category ='XEDUCATIONALLEVEL' and CodeName='11th Grade')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XEDUCATIONALLEVEL','11th Grade','KCMHSAS-Improvement-11','Y','N',12)
END

IF NOT EXISTS (select * from globalcodes where category ='XEDUCATIONALLEVEL' and CodeName='12th Grade')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XEDUCATIONALLEVEL','12th Grade','KCMHSAS-Improvement-11','Y','N',13)
END

IF NOT EXISTS (select * from globalcodes where category ='XEDUCATIONALLEVEL' and CodeName='High School Graduate')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES
('XEDUCATIONALLEVEL','High School Graduate','KCMHSAS-Improvement-11','Y','N',14)
END

IF NOT EXISTS (select * from globalcodes where category ='XEDUCATIONALLEVEL' and CodeName='Post High School Program')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES('XEDUCATIONALLEVEL','Post High School Program','KCMHSAS-Improvement-11','Y','N',15)
END

IF NOT EXISTS (select * from globalcodes where category ='XEDUCATIONALLEVEL' and CodeName='College Graduate')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES('XEDUCATIONALLEVEL','College Graduate','KCMHSAS-Improvement-11','Y','N',16)
END

IF NOT EXISTS (select * from globalcodes where category ='XEDUCATIONALLEVEL' and CodeName='Some Graduate School')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES('XEDUCATIONALLEVEL','Some Graduate School','KCMHSAS-Improvement-11','Y','N',17)
END

IF NOT EXISTS (select * from globalcodes where category ='XEDUCATIONALLEVEL' and CodeName='Graduate School Graduate')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES('XEDUCATIONALLEVEL','Graduate School Graduate','KCMHSAS-Improvement-11','Y','N',18)
END

IF NOT EXISTS (select * from globalcodes where category ='XEDUCATIONALLEVEL' and CodeName='Never Attended School')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES('XEDUCATIONALLEVEL','Never Attended School','KCMHSAS-Improvement-11','Y','N',19)
END

IF NOT EXISTS (select * from globalcodes where category ='XEDUCATIONALLEVEL' and CodeName='Special Education')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES('XEDUCATIONALLEVEL','Special Education','KCMHSAS-Improvement-11','Y','N',20)
END


IF NOT EXISTS (select * from globalcodes where category ='XEDUCATIONALLEVEL' and CodeName='Vocational')
BEGIN 
INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES('XEDUCATIONALLEVEL','Vocational','KCMHSAS-Improvement-11','Y','N',21)
END
