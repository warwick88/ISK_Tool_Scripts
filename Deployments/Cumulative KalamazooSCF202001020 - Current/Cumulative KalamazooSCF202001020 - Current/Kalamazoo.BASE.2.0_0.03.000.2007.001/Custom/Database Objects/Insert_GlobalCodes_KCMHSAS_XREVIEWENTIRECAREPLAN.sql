
/********************************************************************************                                                     
-- Copyright: Streamline Healthcare Solutions  
-- "Individualized Service Plan"
-- Purpose: GlobalCodes Entry for Task #8 KCMHSAS Improvements 
--  
-- Date:    11 May 2020
--  
-- *****History****  
--	Date			Author			  Description
   11 May 2020     Ankita Sinha      Task #8 KCMHSAS Improvements

*********************************************************************************/

IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodeCategories
		WHERE Category = 'XRENTIRECAREPLAN'
		)
BEGIN
	INSERT INTO GlobalCodeCategories (
		Category
		,CategoryName
		,Active
		,AllowAddDelete
		,AllowCodeNameEdit
		,AllowSortOrderEdit
		,UserDefinedCategory
		,HasSubcodes
		,UsedInPracticeManagement
		)
	VALUES (
		'XRENTIRECAREPLAN'
		,'Review Entire Care Plan'
		,'Y'
		,'Y'
		,'Y'
		,'Y'
		,'N'
		,'N'
		,'N'
		)
END

IF NOT EXISTS (	SELECT 1 FROM GlobalCodes WHERE ISNULL(RecordDeleted,'N')='N' AND ISNULL(Active,'N')='Y' AND Category = 'XRENTIRECAREPLAN' AND Code = '14DAYS')
BEGIN
INSERT INTO GlobalCodes (Category,CodeName,Code,Active,CannotModifyNameOrDelete, SortOrder)
VALUES ('XRENTIRECAREPLAN','14 days','14DAYS','Y','Y',1)
END

IF NOT EXISTS (	SELECT 1 FROM GlobalCodes WHERE ISNULL(RecordDeleted,'N')='N' AND ISNULL(Active,'N')='Y' AND Category = 'XRENTIRECAREPLAN' AND Code = '30DAYS')
BEGIN
INSERT INTO GlobalCodes (Category,CodeName,Code,Active,CannotModifyNameOrDelete, SortOrder)
VALUES ('XRENTIRECAREPLAN','30 days','30DAYS','Y','Y',2)
END

IF NOT EXISTS (	SELECT 1 FROM GlobalCodes WHERE ISNULL(RecordDeleted,'N')='N' AND ISNULL(Active,'N')='Y' AND Category = 'XRENTIRECAREPLAN' AND Code = '45DAYS')
BEGIN
INSERT INTO GlobalCodes (Category,CodeName,Code,Active,CannotModifyNameOrDelete, SortOrder)
VALUES ('XRENTIRECAREPLAN','45 days','45DAYS','Y','Y',3)
END
IF NOT EXISTS (	SELECT 1 FROM GlobalCodes WHERE ISNULL(RecordDeleted,'N')='N' AND ISNULL(Active,'N')='Y' AND Category = 'XRENTIRECAREPLAN' AND Code = '60DAYS')
BEGIN
INSERT INTO GlobalCodes (Category,CodeName,Code,Active,CannotModifyNameOrDelete, SortOrder)
VALUES ('XRENTIRECAREPLAN','60 days','60DAYS','Y','Y',4)
END
IF NOT EXISTS (	SELECT 1 FROM GlobalCodes WHERE ISNULL(RecordDeleted,'N')='N' AND ISNULL(Active,'N')='Y' AND Category = 'XRENTIRECAREPLAN' AND Code = '90DAYS')
BEGIN
INSERT INTO GlobalCodes (Category,CodeName,Code,Active,CannotModifyNameOrDelete, SortOrder)
VALUES ('XRENTIRECAREPLAN','90 days','90DAYS','Y','Y',5)
END
IF NOT EXISTS (	SELECT 1 FROM GlobalCodes WHERE ISNULL(RecordDeleted,'N')='N' AND ISNULL(Active,'N')='Y' AND Category = 'XRENTIRECAREPLAN' AND Code = '120DAYS')
BEGIN
INSERT INTO GlobalCodes (Category,CodeName,Code,Active,CannotModifyNameOrDelete, SortOrder)
VALUES ('XRENTIRECAREPLAN','120 days','120DAYS','Y','Y',6)
END
IF NOT EXISTS (	SELECT 1 FROM GlobalCodes WHERE ISNULL(RecordDeleted,'N')='N' AND ISNULL(Active,'N')='Y' AND Category = 'XRENTIRECAREPLAN' AND Code = '180DAYS')
BEGIN
INSERT INTO GlobalCodes (Category,CodeName,Code,Active,CannotModifyNameOrDelete, SortOrder)
VALUES ('XRENTIRECAREPLAN','180 days','180DAYS','Y','Y',6)
END
