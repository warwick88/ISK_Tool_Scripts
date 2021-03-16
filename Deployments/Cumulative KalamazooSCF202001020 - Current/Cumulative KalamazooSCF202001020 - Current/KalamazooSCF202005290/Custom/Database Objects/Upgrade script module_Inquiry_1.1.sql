----- STEP 1 ----------
IF ((SELECT value FROM SystemConfigurationKeys WHERE [key] = 'CDM_Inquiry')  < 1.0) or
Not exists(SELECT 1 FROM SystemConfigurationKeys WHERE [key] = 'CDM_Inquiry')
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 1.0 for CDM_Inquiry update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

--Part1 Begin

--Part1 Ends

--Part2 Begins

--Part2 Ends

-----End of Step 2 -------

------ STEP 3 ------------

-- add new column(s) into CustomInquiries table
IF OBJECT_ID('CustomInquiries') IS NOT NULL
BEGIN
	IF COL_LENGTH('CustomInquiries','ReceivingPrenatalCare')IS  NULL
	BEGIN
		ALTER TABLE CustomInquiries  ADD ReceivingPrenatalCare type_YOrN	NULL
									 CHECK (ReceivingPrenatalCare in ('Y','N'))
	END

	IF COL_LENGTH('CustomInquiries','CoverageInformation')IS  NULL
	BEGIN
		ALTER TABLE CustomInquiries  ADD CoverageInformation type_Comment2 NULL 
	END
	PRINT 'STEP 3 COMPLETED'
END
Go
------ END OF STEP 3 -----

------ STEP 4 ----------

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomInquiryCoverageInformations')
 BEGIN
/* 
 * TABLE: CustomInquiryCoverageInformations 
 */
CREATE TABLE CustomInquiryCoverageInformations(
    InquiryCoverageInformationId			int	identity(1,1)		NOT NULL,
	CreatedBy								type_CurrentUser        NOT NULL,
    CreatedDate								type_CurrentDatetime    NOT NULL,
    ModifiedBy								type_CurrentUser        NOT NULL,
    ModifiedDate							type_CurrentDatetime    NOT NULL,
    RecordDeleted							type_YOrN               NULL
											CHECK (RecordDeleted in ('Y','N')),
    DeletedBy								type_UserId             NULL,
    DeletedDate								datetime                NULL,
	InquiryId								int						NULL,
	CoveragePlanId							int						NULL,
	InsuredId								varchar(25)				NULL,
	GroupId									varchar(35)				NULL,
	Comment									type_Comment2			NULL,
	NewlyAddedPlan							type_YOrN               NULL
											CHECK (NewlyAddedPlan in ('Y','N')),
	CONSTRAINT CustomInquiryCoverageInformations_PK PRIMARY KEY CLUSTERED (InquiryCoverageInformationId)                                
)

IF OBJECT_ID('CustomInquiryCoverageInformations') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomInquiryCoverageInformations >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomInquiryCoverageInformations >>>', 16, 1)

/* 
 * TABLE: CustomInquiryCoverageInformations 
 */
 
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CustomInquiryCoverageInformations]') AND name = N'XIE1_CustomInquiryCoverageInformations')
  BEGIN
   CREATE NONCLUSTERED INDEX [XIE1_CustomInquiryCoverageInformations] ON [dbo].[CustomInquiryCoverageInformations] 
   (
   [InquiryId]  ASC
   )
   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomInquiryCoverageInformations') AND name='XIE1_CustomInquiryCoverageInformations')
   PRINT '<<< CREATED INDEX CustomInquiryCoverageInformations.XIE1_CustomInquiryCoverageInformations >>>'
   ELSE
   RAISERROR('<<< FAILED CREATING INDEX CustomInquiryCoverageInformations.XIE1_CustomInquiryCoverageInformations >>>', 16, 1)  
  END  

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CustomInquiryCoverageInformations]') AND name = N'XIE2_CustomInquiryCoverageInformations')
  BEGIN
   CREATE NONCLUSTERED INDEX [XIE2_CustomInquiryCoverageInformations] ON [dbo].[CustomInquiryCoverageInformations] 
   (
   [CoveragePlanId]  ASC
   )
   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomInquiryCoverageInformations') AND name='XIE2_CustomInquiryCoverageInformations')
   PRINT '<<< CREATED INDEX CustomInquiryCoverageInformations.XIE2_CustomInquiryCoverageInformations >>>'
   ELSE
   RAISERROR('<<< FAILED CREATING INDEX CustomInquiryCoverageInformations.XIE2_CustomInquiryCoverageInformations >>>', 16, 1)  
  END 
        
/* 
 * TABLE: CustomInquiryCoverageInformations 
 */
	
ALTER TABLE CustomInquiryCoverageInformations ADD CONSTRAINT CustomInquiries_CustomInquiryCoverageInformations_FK 
	FOREIGN KEY (InquiryId)
	REFERENCES CustomInquiries(InquiryId)

ALTER TABLE CustomInquiryCoverageInformations ADD CONSTRAINT CoveragePlans_CustomInquiryCoverageInformations_FK 
	FOREIGN KEY (CoveragePlanId)
	REFERENCES CoveragePlans(CoveragePlanId) 
	
 PRINT 'STEP 4(A) COMPLETED'	
END
Go
---- END Of STEP 4 ------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((SELECT cast(value as decimal(10,2)) FROM SystemConfigurationKeys WHERE [key] = 'CDM_Inquiry')  = 1.0)
BEGIN
	
UPDATE SystemConfigurationKeys SET value ='1.1' WHERE [key] = 'CDM_Inquiry'
PRINT 'STEP 7 COMPLETED'
END
ELSE
IF NOT EXISTS (	SELECT [key] FROM SystemConfigurationKeys	WHERE [key] = 'CDM_Inquiry')
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
		,'CDM_Inquiry'
		,'1.1'
		)

	PRINT 'STEP 7 COMPLETED'
END
Go
