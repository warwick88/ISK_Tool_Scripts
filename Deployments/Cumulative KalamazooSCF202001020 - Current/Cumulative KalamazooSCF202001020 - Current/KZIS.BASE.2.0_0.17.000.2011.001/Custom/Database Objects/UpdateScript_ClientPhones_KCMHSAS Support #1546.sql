--Removed duplicate home phones KCMHSAS Support #1546
;
WITH CTE_AliasList
AS (
	SELECT ClientPhoneId
		,ROW_NUMBER() OVER (
			PARTITION BY 
			CA.ClientId
			,CA.Phonetype ORDER BY CA.ClientPhoneId ASC
			) AS ROW
	FROM ClientPhones CA
	WHERE 
 ISNULL(CA.RecordDeleted, 'N') = 'N' AND Phonetype = 30

	)

UPDATE CA
SET CA.Recorddeleted = 'Y',
CA.DeletedBy = 'KCMHSAS#1546',
CA.DeletedDate = GETDATE()
FROM ClientPhones CA
INNER JOIN CTE_AliasList CPs ON CA.ClientPhoneId = CPs.ClientPhoneId
	AND CPs.ROW > 1