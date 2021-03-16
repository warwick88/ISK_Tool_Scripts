/*********************************************************************/
--  Created By : Packia
--  Dated      : 05/27/2020
--  Purpose    : To insert new entry in  global codes for Psycho - Adult tab in MH Assessment
--               Project :  KCMHSAS Improvements : #7
/*********************************************************************/

--Insert script GlobalCodeCategories- GeneralAppearance
IF(NOT EXISTS(SELECT Category FROM GlobalCodeCategories WHERE CATEGORY='XMHAessHealthIssues'))
BEGIN
	INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes) 
	VALUES('XMHAessHealthIssues','XMHAessHealthIssues','Y','Y','Y','Y','Y','N')
END

--Insert script Globalcodes

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='XMHAessHealthIssues' AND CodeName= 'Hearing' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('XMHAessHealthIssues','Hearing','Y','N',1)
END

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='XMHAessHealthIssues' AND CodeName= 'Vision' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('XMHAessHealthIssues','Vision','Y','N',2)
END

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='XMHAessHealthIssues' AND CodeName= 'Pneumonia' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('XMHAessHealthIssues','Pneumonia','Y','N',3)
END

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='XMHAessHealthIssues' AND CodeName= 'Asthma' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('XMHAessHealthIssues','Asthma','Y','N',4)
END

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='XMHAessHealthIssues' AND CodeName= 'Upper Respiratory' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('XMHAessHealthIssues','Upper Respiratory','Y','N',5)
END

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='XMHAessHealthIssues' AND CodeName= 'Infections' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('XMHAessHealthIssues','Infections','Y','N',6)
END

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='XMHAessHealthIssues' AND CodeName= 'Gastroesophageal' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('XMHAessHealthIssues','Gastroesophageal','Y','N',7)
END

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='XMHAessHealthIssues' AND CodeName= 'Reflex(GERD)' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('XMHAessHealthIssues','Reflex(GERD)','Y','N',8)
END

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='XMHAessHealthIssues' AND CodeName= 'Chronic Bowel' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('XMHAessHealthIssues','Chronic Bowel','Y','N',9)
END

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='XMHAessHealthIssues' AND CodeName= 'Impactions' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('XMHAessHealthIssues','Impactions','Y','N',10)
END

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='XMHAessHealthIssues' AND CodeName= 'Seizures/Epilepsy' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('XMHAessHealthIssues','Seizures/Epilepsy','Y','N',11)
END

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='XMHAessHealthIssues' AND CodeName= 'Progressive Neurological' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('XMHAessHealthIssues','Progressive Neurological','Y','N',12)
END
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='XMHAessHealthIssues' AND CodeName= 'Disease (i.e. Alzheimers)' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('XMHAessHealthIssues','Disease (i.e. Alzheimers)','Y','N',13)
END
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='XMHAessHealthIssues' AND CodeName= 'Diabetes' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('XMHAessHealthIssues','Diabetes','Y','N',14)
END
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='XMHAessHealthIssues' AND CodeName= 'Hypertension' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('XMHAessHealthIssues','Hypertension','Y','N',15)
END
IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='XMHAessHealthIssues' AND CodeName= 'Obesity' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('XMHAessHealthIssues','Obesity','Y','N',16)
END


