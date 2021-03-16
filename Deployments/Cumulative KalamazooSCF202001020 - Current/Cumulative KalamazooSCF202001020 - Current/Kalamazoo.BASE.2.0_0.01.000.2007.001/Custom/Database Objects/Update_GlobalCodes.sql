IF NOT EXISTS (SELECT 1 FROM GlobalCodes WHERE Category='xPROGDISCHARGEREASON' AND CodeName='Service requested ended - Client hasn’t received treatment in X number of days (add comment)')
BEGIN
	INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
	VALUES ('xPROGDISCHARGEREASON','Service requested ended - Client hasn’t received treatment in X number of days (add comment)','Valley - Customizations #929','Y','N',23)
END
 

UPDATE GlobalCodes SET Code='HAVEUSEDNOTCURRENTUSER' WHERE Category='XCDTOBACCOUSE' AND CodeName = 'HAVE USED/NOT CUR. USER'
UPDATE GlobalCodes SET Code='OCCASIONALUSER' WHERE Category='XCDTOBACCOUSE' AND CodeName = 'OCCASIONAL USER'
UPDATE GlobalCodes SET Code='USESMOKELESSTOBACCO' WHERE Category='XCDTOBACCOUSE' AND CodeName = 'USE SMOKELESS TOBACCO'
UPDATE GlobalCodes SET Code='REGULARUSER' WHERE Category='XCDTOBACCOUSE' AND CodeName = 'REGULAR USER'