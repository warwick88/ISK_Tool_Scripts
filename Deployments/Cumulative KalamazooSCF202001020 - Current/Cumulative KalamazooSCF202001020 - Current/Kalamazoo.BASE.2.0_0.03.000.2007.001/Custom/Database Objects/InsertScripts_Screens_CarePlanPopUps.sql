----------------------------------------  Screens Table   -----------------------------------  
/*   
  Please change these variables for supporting a new page/document/widget   
  Screen Types:   
    None:               0,   
        Detail:             5761,   
        List:               5762,   
        Document:           5763,   
        Summary:            5764,   
        Custom:             5765,   
        ExternalScreen:     5766   
*/

DECLARE @Code VARCHAR(100) 
DECLARE @ScreenName VARCHAR(100) 
DECLARE @ScreenType INT 
DECLARE @ScreenURL VARCHAR(200) 
DECLARE @TabId INT 

SET @Code = '823BF8A6-80AF-4473-8AB8-DE179672944D'
SET @ScreenName = 'Care Plan PopUps'
SET @ScreenType = 5765
SET @ScreenURL = '/Custom/CarePlan/WebPages/CarePlanPopUps.ascx'
SET @TabId = 2

IF NOT EXISTS (
		SELECT TOP 1 ScreenId
		FROM Screens
		WHERE Code = @Code
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
END
ELSE
BEGIN
	UPDATE Screens
	SET ScreenName = @ScreenName
		,ScreenType = @ScreenType
		,ScreenURL = @ScreenURL
		,TabId = @TabId
	WHERE Code = @Code
END
		-----------------------------------------------END--------------------------------------------  
