DECLARE @DocumentCodeID INT

SELECT @DocumentCodeID = DocumentcodeID FROM DocumentCodes WHERE Code = '8AF7837B-05A7-4DF8-B2ED-6B852A5BA50A'
IF EXISTS (SELECT 1	FROM DocumentCodes WHERE Code = '8AF7837B-05A7-4DF8-B2ED-6B852A5BA50A')
BEGIN
	UPDATE DocumentCodes SET NewValidationStoredProcedure ='ssp_ValidateEpisodeCarePlan' where Code = '8AF7837B-05A7-4DF8-B2ED-6B852A5BA50A'
END
