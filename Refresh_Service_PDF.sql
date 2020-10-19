use ProdSmartCare

DECLARE @ServiceId INT;
SET @ServiceId = 846739

update DocumentVersions
SET RefreshView='Y'
FROM DocumentVersions DV
JOIN Documents D ON DV.DocumentId = D.DocumentId
JOIN Services S on D.ServiceId = S.ServiceId
WHERE S.ServiceId = @ServiceId
COMMIT TRAN

