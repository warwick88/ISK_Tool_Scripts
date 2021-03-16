----- STEP 1 ----------
IF ((SELECT value FROM SystemConfigurationKeys WHERE [key] = 'CDM_CarePlan')  < 1.0) or
Not exists(SELECT 1 FROM SystemConfigurationKeys WHERE [key] = 'CDM_CarePlan')
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 1.0 for CDM_CarePlan update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
----------- STEP 2 ----------

--------End of Step 2 -------

---------- STEP 3 ------------
---Added New columns in CustomCarePlanPrescribedServices 
IF OBJECT_ID('CustomCarePlanPrescribedServices') IS NOT NULL
BEGIN
	IF COL_LENGTH('CustomCarePlanPrescribedServices','AuthorizationId')IS  NULL
	BEGIN
		ALTER TABLE CustomCarePlanPrescribedServices  ADD AuthorizationId int NULL 
	END

	IF COL_LENGTH('CustomCarePlanPrescribedServices','TotalUnits')IS  NULL
	BEGIN
		ALTER TABLE CustomCarePlanPrescribedServices  ADD TotalUnits decimal(18,2) NULL 
	END
END
PRINT 'STEP 3 COMPLETED' 
---------- END OF STEP 3 -----

------------ STEP 4 ----------

--------END Of STEP 4---------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  --------------

------ STEP 7 --------------

IF ((SELECT cast(value as decimal(10,2)) FROM SystemConfigurationKeys WHERE [key] = 'CDM_CarePlan')  = 1.0)
BEGIN
	
UPDATE SystemConfigurationKeys SET value ='1.1' WHERE [key] = 'CDM_CarePlan'
PRINT 'STEP 7 COMPLETED'
END
ELSE
IF NOT EXISTS (	SELECT [key] FROM SystemConfigurationKeys	WHERE [key] = 'CDM_CarePlan')
BEGIN
INSERT INTO SystemConfigurationKeys (
		CreatedBy
		,CreateDate
		,ModifiedBy
		,ModifiedDate
		,[key]
		,Value
		)
	VALUES (
		'SHSDBA'
		,GETDATE()
		,'SHSDBA'
		,GETDATE()
		,'CDM_CarePlan'
		,'1.1'
		)

	PRINT 'STEP 7 COMPLETED'
END
Go

