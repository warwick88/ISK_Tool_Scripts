
/**********************************************************************************************************
Date          Auther
22/05/2020    Josekutty          
							 -- What       :- Scripts for inserting global codes (XSubstantialFunction,XFA5PointScale,XFAB5PointScale,XCommunication).
							 -- Why        :- Dropdown values have to be loaded from global codes.
							 -- Portal Task:- #12 in KCMHSAS Improvements. 
************************************************************************************************************/

IF NOT EXISTS(SELECT * FROM GlobalCodeCategories Where Category='XSubstantialFunction')
	Begin
		INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,Description,UserDefinedCategory,HasSubcodes) 
		Values('XSubstantialFunction','XSubstantialFunction','Y','Y','Y','Y','KCMHSAS Improvements #12','N','N')
	End
IF NOT EXISTS(SELECT * FROM GlobalCodes Where Category='XSubstantialFunction')
	Begin
		INSERT INTO GlobalCodes(Category,CodeName,Active,Description,SortOrder) Values('XSubstantialFunction','Self-Care','Y','KCMHSAS Improvements #12',1)
		INSERT INTO GlobalCodes(Category,CodeName,Active,Description,SortOrder) Values('XSubstantialFunction','Receptive/Expressive language','Y','KCMHSAS Improvements #12',2) 
		INSERT INTO GlobalCodes(Category,CodeName,Active,Description,SortOrder) Values('XSubstantialFunction','Learning','Y','KCMHSAS Improvements #12',3)
		INSERT INTO GlobalCodes(Category,CodeName,Active,Description,SortOrder) Values('XSubstantialFunction','Mobility','Y','KCMHSAS Improvements #12',4) 
		INSERT INTO GlobalCodes(Category,CodeName,Active,Description,SortOrder) Values('XSubstantialFunction','Self-Direction','Y','KCMHSAS Improvements #12',5)
		INSERT INTO GlobalCodes(Category,CodeName,Active,Description,SortOrder) Values('XSubstantialFunction','Economic Self Sufficiency','Y','KCMHSAS Improvements #12',6) 
		INSERT INTO GlobalCodes(Category,CodeName,Active,Description,SortOrder) Values('XSubstantialFunction','Capability for Independent Living','Y','KCMHSAS Improvements #12',7)		
	End



IF NOT EXISTS(SELECT * FROM GlobalCodeCategories Where Category='XFA5PointScale')
	Begin
		INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,Description,UserDefinedCategory,HasSubcodes) 
		Values('XFA5PointScale','XFA5PointScale','Y','Y','Y','Y','KCMHSAS Improvements #12','N','N')
	End
IF NOT EXISTS(SELECT * FROM GlobalCodes Where Category='XFA5PointScale')
	Begin
		INSERT INTO GlobalCodes(Category,CodeName,Active,Description,SortOrder) Values('XFA5PointScale','0 = Independent','Y','KCMHSAS Improvements #12',1)
		INSERT INTO GlobalCodes(Category,CodeName,Active,Description,SortOrder) Values('XFA5PointScale','1 = Verbal prompts','Y','KCMHSAS Improvements #12',2) 
		INSERT INTO GlobalCodes(Category,CodeName,Active,Description,SortOrder) Values('XFA5PointScale','2 = Limited assistance','Y','KCMHSAS Improvements #12',3)
		INSERT INTO GlobalCodes(Category,CodeName,Active,Description,SortOrder) Values('XFA5PointScale','3 = Moderate assistance','Y','KCMHSAS Improvements #12',4) 
		INSERT INTO GlobalCodes(Category,CodeName,Active,Description,SortOrder) Values('XFA5PointScale','4 = Total assistance','Y','KCMHSAS Improvements #12',5)
		INSERT INTO GlobalCodes(Category,CodeName,Active,Description,SortOrder) Values('XFA5PointScale','N/A = Not applicable','Y','KCMHSAS Improvements #12',6) 
	End



IF NOT EXISTS(SELECT * FROM GlobalCodeCategories Where Category='XFAB5PointScale')
	Begin
		INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,Description,UserDefinedCategory,HasSubcodes) 
		Values('XFAB5PointScale','XFAB5PointScale','Y','Y','Y','Y','KCMHSAS Improvements #12','N','N')
	End
IF NOT EXISTS(SELECT * FROM GlobalCodes Where Category='XFAB5PointScale')
	Begin
		INSERT INTO GlobalCodes(Category,CodeName,Active,Description,SortOrder) Values('XFAB5PointScale','0 = Not present','Y','KCMHSAS Improvements #12',1)
		INSERT INTO GlobalCodes(Category,CodeName,Active,Description,SortOrder) Values('XFAB5PointScale','1 = Minor occurrences','Y','KCMHSAS Improvements #12',2) 
		INSERT INTO GlobalCodes(Category,CodeName,Active,Description,SortOrder) Values('XFAB5PointScale','2 = Mild occurrences','Y','KCMHSAS Improvements #12',3)
		INSERT INTO GlobalCodes(Category,CodeName,Active,Description,SortOrder) Values('XFAB5PointScale','3= Moderate occurrences','Y','KCMHSAS Improvements #12',4) 
		INSERT INTO GlobalCodes(Category,CodeName,Active,Description,SortOrder) Values('XFAB5PointScale','4 = Significant occurrences','Y','KCMHSAS Improvements #12',5)
		INSERT INTO GlobalCodes(Category,CodeName,Active,Description,SortOrder) Values('XFAB5PointScale','N/A = Not assessed','Y','KCMHSAS Improvements #12',6) 
	End
	 

IF NOT EXISTS(SELECT * FROM GlobalCodeCategories Where Category='XCommunication')
	Begin
		INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,Description,UserDefinedCategory,HasSubcodes) 
		Values('XCommunication','XCommunication','Y','Y','Y','Y','KCMHSAS Improvements #12','N','N')
	End
IF NOT EXISTS(SELECT * FROM GlobalCodes Where Category='XCommunication')
	Begin
		INSERT INTO GlobalCodes(Category,CodeName,Active,Description,SortOrder) Values('XCommunication','Normal','Y','KCMHSAS Improvements #12',1)
		INSERT INTO GlobalCodes(Category,CodeName,Active,Description,SortOrder) Values('XCommunication','Uses sign language','Y','KCMHSAS Improvements #12',2) 
		INSERT INTO GlobalCodes(Category,CodeName,Active,Description,SortOrder) Values('XCommunication','Need for Braille','Y','KCMHSAS Improvements #12',3)
		INSERT INTO GlobalCodes(Category,CodeName,Active,Description,SortOrder) Values('XCommunication','Hearing impaired','Y','KCMHSAS Improvements #12',4) 
		INSERT INTO GlobalCodes(Category,CodeName,Active,Description,SortOrder) Values('XCommunication','Does lip reading','Y','KCMHSAS Improvements #12',5)
		INSERT INTO GlobalCodes(Category,CodeName,Active,Description,SortOrder) Values('XCommunication','English is second language','Y','KCMHSAS Improvements #12',6) 
		INSERT INTO GlobalCodes(Category,CodeName,Active,Description,SortOrder) Values('XCommunication','Translator','Y','KCMHSAS Improvements #12',7)		
		INSERT INTO GlobalCodes(Category,CodeName,Active,Description,SortOrder) Values('XCommunication','Utilize device/technology','Y','KCMHSAS Improvements #12',8)	
	End

