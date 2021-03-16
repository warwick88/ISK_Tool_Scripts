----- STEP 1 ----------

------ STEP 2 ----------

--Part1 Begin

--Part1 Ends

--Part2 Begins

--Part2 Ends

-----End of Step 2 -------

------ STEP 3 ------------

------ END OF STEP 3 -----

------ STEP 4 ----------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentCarePlans')
 BEGIN
/* 
 * TABLE: CustomDocumentCarePlans 
 */

CREATE TABLE CustomDocumentCarePlans (
	DocumentVersionId							int							NOT NULL,
    CreatedBy									type_CurrentUser			NOT NULL,
    CreatedDate									type_CurrentDatetime		NOT NULL,
    ModifiedBy									type_CurrentUser			NOT NULL,
    ModifiedDate								type_CurrentDatetime		NOT NULL,
    RecordDeleted								type_YOrN					NULL
												CHECK (RecordDeleted in	('Y','N')),
    DeletedBy									type_UserId					NULL,
    DeletedDate									datetime					NULL,
    UMArea										type_GlobalCode				NULL,
	LevelOfCareAssessment						type_Comment2				NULL,
    CONSTRAINT CustomDocumentCarePlans_PK PRIMARY KEY CLUSTERED (DocumentVersionId)
)

IF OBJECT_ID('CustomDocumentCarePlans') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentCarePlans >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE CustomDocumentCarePlans >>>'

/* 
 * TABLE: CustomDocumentCarePlans 
 */

ALTER TABLE CustomDocumentCarePlans ADD CONSTRAINT DocumentVersions_CustomDocumentCarePlans_FK 
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)

EXEC sys.sp_addextendedproperty 'CustomDocumentCarePlans_Description'
	,'UMArea column stores globalcode of category "AUTHORIZATIONTEAM"'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentCarePlans'
	,'column'
	,'UMArea'	

PRINT 'STEP 4(A) COMPLETED'
END
Go

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomCarePlanPrescribedServices')
 BEGIN
/* 
 * TABLE: CustomCarePlanPrescribedServices 
 */

CREATE TABLE CustomCarePlanPrescribedServices (
	CarePlanPrescribedServiceId					int	IDENTITY(1,1)			NOT NULL,
    CreatedBy									type_CurrentUser			NOT NULL,
    CreatedDate									type_CurrentDatetime		NOT NULL,
    ModifiedBy									type_CurrentUser			NOT NULL,
    ModifiedDate								type_CurrentDatetime		NOT NULL,
    RecordDeleted								type_YOrN					NULL
												CHECK (RecordDeleted in	('Y','N')),
    DeletedBy									type_UserId					NULL,
    DeletedDate									datetime					NULL,
	DocumentVersionId							int							NULL,
	ProviderId									int							NULL,
    AuthorizationCodeId							int							NULL,
	FromDate									datetime					NULL,
	ToDate										datetime					NULL,
	Units										decimal(18,2)				NULL,
	Frequency									type_GlobalCode				NULL,
	PersonResponsible							type_GlobalCode				NULL,
	Detail										type_Comment2				NULL,
    CONSTRAINT CustomCarePlanPrescribedServices_PK PRIMARY KEY CLUSTERED (CarePlanPrescribedServiceId)
)

IF OBJECT_ID('CustomCarePlanPrescribedServices') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomCarePlanPrescribedServices >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE CustomCarePlanPrescribedServices >>>'

/* 
 * TABLE: CustomCarePlanPrescribedServices 
 */
 
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CustomCarePlanPrescribedServices]') AND name = N'XIE1_CustomCarePlanPrescribedServices')
  BEGIN
   CREATE NONCLUSTERED INDEX [XIE1_CustomCarePlanPrescribedServices] ON [dbo].[CustomCarePlanPrescribedServices] 
   (
   [DocumentVersionId]  ASC
   )
   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomCarePlanPrescribedServices') AND name='XIE1_CustomCarePlanPrescribedServices')
   PRINT '<<< CREATED INDEX CustomCarePlanPrescribedServices.XIE1_CustomCarePlanPrescribedServices >>>'
   ELSE
   RAISERROR('<<< FAILED CREATING INDEX CustomCarePlanPrescribedServices.XIE1_CustomCarePlanPrescribedServices >>>', 16, 1)  
  END    		

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CustomCarePlanPrescribedServices]') AND name = N'XIE2_CustomCarePlanPrescribedServices')
  BEGIN
   CREATE NONCLUSTERED INDEX [XIE2_CustomCarePlanPrescribedServices] ON [dbo].[CustomCarePlanPrescribedServices] 
   (
   [ProviderId]  ASC
   )
   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomCarePlanPrescribedServices') AND name='XIE2_CustomCarePlanPrescribedServices')
   PRINT '<<< CREATED INDEX CustomCarePlanPrescribedServices.XIE2_CustomCarePlanPrescribedServices >>>'
   ELSE
   RAISERROR('<<< FAILED CREATING INDEX CustomCarePlanPrescribedServices.XIE2_CustomCarePlanPrescribedServices >>>', 16, 1)  
  END 

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CustomCarePlanPrescribedServices]') AND name = N'XIE3_CustomCarePlanPrescribedServices')
  BEGIN
   CREATE NONCLUSTERED INDEX [XIE3_CustomCarePlanPrescribedServices] ON [dbo].[CustomCarePlanPrescribedServices] 
   (
   AuthorizationCodeId  ASC
   )
   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomCarePlanPrescribedServices') AND name='XIE3_CustomCarePlanPrescribedServices')
   PRINT '<<< CREATED INDEX CustomCarePlanPrescribedServices.XIE3_CustomCarePlanPrescribedServices >>>'
   ELSE
   RAISERROR('<<< FAILED CREATING INDEX CustomCarePlanPrescribedServices.XIE3_CustomCarePlanPrescribedServices >>>', 16, 1)  
  END 
    
/* 
 * TABLE: CustomCarePlanPrescribedServices 
 */

ALTER TABLE CustomCarePlanPrescribedServices ADD CONSTRAINT DocumentVersions_CustomCarePlanPrescribedServices_FK 
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)

ALTER TABLE CustomCarePlanPrescribedServices ADD CONSTRAINT Providers_CustomCarePlanPrescribedServices_FK 
    FOREIGN KEY (ProviderId)
    REFERENCES Providers(ProviderId)
 
ALTER TABLE CustomCarePlanPrescribedServices ADD CONSTRAINT AuthorizationCodes_CustomCarePlanPrescribedServices_FK 
    FOREIGN KEY (AuthorizationCodeId)
    REFERENCES AuthorizationCodes(AuthorizationCodeId) 
    
EXEC sys.sp_addextendedproperty 'CustomCarePlanPrescribedServices_Description'
	,'Frequency column stores globalcode of category "TPFREQUENCYTYPE"'
	,'schema'
	,'dbo'
	,'table'
	,'CustomCarePlanPrescribedServices'
	,'column'
	,'Frequency'	

EXEC sys.sp_addextendedproperty 'CustomCarePlanPrescribedServices_Description'
	,'PersonResponsible column stores globalcode of category "PRESCRIBEDRESP"'
	,'schema'
	,'dbo'
	,'table'
	,'CustomCarePlanPrescribedServices'
	,'column'
	,'PersonResponsible'	
	
PRINT 'STEP 4(B) COMPLETED' 
END
Go

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomCarePlanPrescribedServiceObjectives')
 BEGIN
/* 
 * TABLE: CustomCarePlanPrescribedServiceObjectives 
 */

CREATE TABLE CustomCarePlanPrescribedServiceObjectives (
	CarePlanPrescribedServiceObjectiveId			int IDENTITY(1,1)		NOT NULL,
    CreatedBy										type_CurrentUser		NOT NULL,
    CreatedDate										type_CurrentDatetime	NOT NULL,
    ModifiedBy										type_CurrentUser		NOT NULL,
    ModifiedDate									type_CurrentDatetime	NOT NULL,
    RecordDeleted									type_YOrN				NULL
													CHECK (RecordDeleted in	('Y','N')),
    DeletedBy										type_UserId	            NULL,
    DeletedDate										datetime                NULL,
    CarePlanPrescribedServiceId						int						NULL,
	CarePlanObjectiveId								int						NULL,
    CONSTRAINT CustomCarePlanPrescribedServiceObjectives_PK PRIMARY KEY CLUSTERED (CarePlanPrescribedServiceObjectiveId)
)

IF OBJECT_ID('CustomCarePlanPrescribedServiceObjectives') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomCarePlanPrescribedServiceObjectives >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE CustomCarePlanPrescribedServiceObjectives >>>'

/* 
 * TABLE: CustomCarePlanPrescribedServiceObjectives 
 */
 
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CustomCarePlanPrescribedServiceObjectives]') AND name = N'XIE1_CustomCarePlanPrescribedServiceObjectives')
  BEGIN
   CREATE NONCLUSTERED INDEX [XIE1_CustomCarePlanPrescribedServiceObjectives] ON [dbo].[CustomCarePlanPrescribedServiceObjectives] 
   (
   [CarePlanPrescribedServiceId]  ASC
   )
   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomCarePlanPrescribedServiceObjectives') AND name='XIE1_CustomCarePlanPrescribedServiceObjectives')
   PRINT '<<< CREATED INDEX CustomCarePlanPrescribedServiceObjectives.XIE1_CustomCarePlanPrescribedServiceObjectives >>>'
   ELSE
   RAISERROR('<<< FAILED CREATING INDEX CustomCarePlanPrescribedServiceObjectives.XIE1_CustomCarePlanPrescribedServiceObjectives >>>', 16, 1)  
  END    
 
 IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CustomCarePlanPrescribedServiceObjectives]') AND name = N'XIE2_CustomCarePlanPrescribedServiceObjectives')
  BEGIN
   CREATE NONCLUSTERED INDEX [XIE2_CustomCarePlanPrescribedServiceObjectives] ON [dbo].[CustomCarePlanPrescribedServiceObjectives] 
   (
   [CarePlanObjectiveId]  ASC
   )
   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomCarePlanPrescribedServiceObjectives') AND name='XIE2_CustomCarePlanPrescribedServiceObjectives')
   PRINT '<<< CREATED INDEX CustomCarePlanPrescribedServiceObjectives.XIE2_CustomCarePlanPrescribedServiceObjectives >>>'
   ELSE
   RAISERROR('<<< FAILED CREATING INDEX CustomCarePlanPrescribedServiceObjectives.XIE2_CustomCarePlanPrescribedServiceObjectives >>>', 16, 1)  
  END    
   
/* 
 * TABLE: CustomCarePlanPrescribedServiceObjectives 
 */

ALTER TABLE CustomCarePlanPrescribedServiceObjectives ADD CONSTRAINT CustomCarePlanPrescribedServices_CustomCarePlanPrescribedServiceObjectives_FK 
    FOREIGN KEY (CarePlanPrescribedServiceId)
    REFERENCES CustomCarePlanPrescribedServices(CarePlanPrescribedServiceId)
    
ALTER TABLE CustomCarePlanPrescribedServiceObjectives ADD CONSTRAINT CarePlanObjectives_CustomCarePlanPrescribedServiceObjectives_FK 
    FOREIGN KEY (CarePlanObjectiveId)
    REFERENCES CarePlanObjectives(CarePlanObjectiveId)

 PRINT 'STEP 4(C) COMPLETED'
END
Go
---- END Of STEP 4 -------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF NOT EXISTS (SELECT [key] FROM SystemConfigurationKeys WHERE [key] = 'CDM_CarePlan')
	BEGIN
		INSERT INTO [dbo].[SystemConfigurationKeys]
				   (CreatedBy
				   ,CreateDate 
				   ,ModifiedBy
				   ,ModifiedDate
				   ,[Key]
				   ,Value
				   )
			 VALUES    
				   ('SHSDBA'
				   ,GETDATE()
				   ,'SHSDBA'
				   ,GETDATE()
				   ,'CDM_CarePlan'
				   ,'1.0'
				   )
				   
 PRINT 'STEP 7 COMPLETED'            
END
Go

