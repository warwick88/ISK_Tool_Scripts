--Date: 11/25/2019
--Purpose : Insert script GlobalCodeCategories -- Memory section in Mental Status Exam . Gold #22

IF(NOT EXISTS(SELECT Category FROM GlobalCodeCategories WHERE CATEGORY='MSEMemoryANW'))
BEGIN
	INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes) 
	VALUES('MSEMemoryANW','MSEMemoryANW','Y','Y','Y','Y','Y','N')
END

--Insert script Globalcodes

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEMemoryANW' AND CodeName= 'Assessed' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEMemoryANW','Assessed','A','Y','N')
END
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEMemoryANW' AND CodeName= 'Not Assessed' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEMemoryANW','Not Assessed','N','Y','N')
END
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='MSEMemoryANW' AND CodeName= 'WNL – Immediate, recent, and remote memory intact' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete])
	VALUES('MSEMemoryANW','WNL – Immediate, recent, and remote memory intact','W','Y','N')
END