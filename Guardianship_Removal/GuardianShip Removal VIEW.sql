
CREATE VIEW [GuardianShip Removal] AS
select * from clientcontacts
where modifiedby = 'AutoGuardianChg'
