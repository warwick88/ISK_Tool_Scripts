-- Added by Mrunali : 10 Nov 2020
---What : Added Recode Category XISKZOOEmerSvcsPrograms
-- Why : KCMHSAS Improvements #19

IF NOT EXISTS(SELECT CategoryCode from RecodeCategories WHERE CategoryCode='XISKZOOEmerSvcsPrograms')
BEGIN
	INSERT INTO RecodeCategories(CategoryCode,CategoryName,Description,MappingEntity)
	VALUES( 'XISKZOOEmerSvcsPrograms','Emergency Services programs','Emergency Services programs','ProgramId') 
END

-------------------------------------------------------------------------------------------------------------------------
