
DECLARE @ScreenType INT
DECLARE @ScreenURL VARCHAR(200)
DECLARE @TabId INT
DECLARE @ScreenName VARCHAR(100)
DECLARE @CODE VARCHAR(max)

SET @ScreenType = 5765
SET @ScreenURL =  '/Custom/MH Assessment/WebPages/HRMOtherRiskFactors.ascx'
SET @TabId = 2
SET @ScreenName='Custom HRMOtherRiskFactorsLookup Popup'
SET @CODE = 'CC0C17C7-3B40-460C-9DB4-1ED2959C5879'

DECLARE @ScreenId INT

IF NOT EXISTS (
		SELECT TOP 1 ScreenId
		FROM Screens
		WHERE Code = @Code
			AND ISNULL(RecordDeleted, 'N') <> 'Y'
		)
BEGIN
	INSERT INTO [Screens] (
		[ScreenName]
		,[ScreenType]
		,[ScreenURL]
		,[TabId]		
		,[Code]
		)
	VALUES (
		@ScreenName
		,@ScreenType
		,@ScreenURL
		,@TabId
		,@Code
		)

	SET @ScreenId = @@Identity

	END
	
SET @ScreenType = 5761
SET @ScreenURL =  '/Custom/MH Assessment/WebPages/HRMGuardianInformation.ascx'
SET @TabId = 2
SET @ScreenName='Guardian Information'
SET @CODE = 'B12360B8-94ED-4C33-90E6-BF50B233CC61'

IF NOT EXISTS (
		SELECT TOP 1 ScreenId
		FROM Screens
		WHERE Code = @Code
			AND ISNULL(RecordDeleted, 'N') <> 'Y'
		)
BEGIN
	INSERT INTO [Screens] (
		[ScreenName]
		,[ScreenType]
		,[ScreenURL]
		,[TabId]		
		,[Code]
		)
	VALUES (
		@ScreenName
		,@ScreenType
		,@ScreenURL
		,@TabId
		,@Code
		)

	SET @ScreenId = @@Identity

	END