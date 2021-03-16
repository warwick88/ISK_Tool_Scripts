
IF NOT EXISTS(SELECT CategoryCode from RecodeCategories WHERE CategoryCode='XRESIDENTIALPROGRAM')
BEGIN
	INSERT INTO dbo.RecodeCategories (CategoryCode,CategoryName,Description,MappingEntity)
	VALUES  ('XRESIDENTIALPROGRAM','Residential Program',
			'Residential Program',
			 'Programs')
END 