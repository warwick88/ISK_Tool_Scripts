
IF NOT EXISTS(SELECT CategoryCode from RecodeCategories WHERE CategoryCode='PROGRAMAANDD')
BEGIN
	INSERT INTO dbo.RecodeCategories (CategoryCode,CategoryName,Description,MappingEntity)
	VALUES  ('PROGRAMAANDD','A & D Program',
			'A & D Program',
			 'Programs')
END 