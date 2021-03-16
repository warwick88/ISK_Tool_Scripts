IF EXISTS (SELECT 1 FROM GlobalCodes WHERE Category='DEGREE' AND CodeName='LMHT' AND ISNULL(Code,'')='')
BEGIN
	UPDATE GlobalCodes 
	SET Code='LMHT'
	WHERE Category='DEGREE' AND CodeName='LMHT' AND ISNULL(Code,'')=''
END 