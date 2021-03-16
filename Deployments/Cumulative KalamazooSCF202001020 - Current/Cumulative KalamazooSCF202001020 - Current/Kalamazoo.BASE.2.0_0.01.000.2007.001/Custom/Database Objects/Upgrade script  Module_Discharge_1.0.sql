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

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentDischarges')
BEGIN
/*		 
 * TABLE: DROP TABLE CustomDocumentDischarges 
 */
 CREATE TABLE CustomDocumentDischarges( 
		DocumentVersionId						int					 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,	
		NewPrimaryClientProgramId				int					 NULL,	
		DischargeType							char(1)				 NULL
												CHECK (DischargeType in ('P', 'A')),      			
		TransitionDischarge						type_GlobalCode		 NULL,	
		DischargeDetails						type_Comment2		 NULL,
		OverallProgress 						type_Comment2		 NULL,	
		StatusLastContact						type_Comment2		 NULL,
		EducationLevel							type_GlobalCode		 NULL,
		MaritalStatus							type_GlobalCode		 NULL,
		EducationStatus							type_GlobalCode		 NULL,	
		EmploymentStatus						type_GlobalCode		 NULL,	
		ForensicCourtOrdered 					type_GlobalCode		 NULL,
		CurrentlyServingMilitary				type_GlobalCode		 NULL,	
		Legal									type_GlobalCode		 NULL,
		JusticeSystem							type_GlobalCode		 NULL,
		LivingArrangement 						type_GlobalCode		 NULL,
		Arrests									varchar(20)			 NULL,
		AdvanceDirective						type_GlobalCode		 NULL,
		TobaccoUse								type_GlobalCode		 NULL,
		AgeOfFirstTobaccoUse					varchar(20)			 NULL,
		CountyResidence							type_GlobalCode		 NULL,
		CountyFinancialResponsibility			type_GlobalCode		 NULL,
		NoReferral 								type_YOrN			 NULL
												CHECK (NoReferral in ('Y','N')),
		SymptomsReoccur 						type_Comment2		 NULL,
		ReferredTo 								type_Comment2		 NULL,
		Reason									type_Comment2		 NULL,
		DatesTimes 								type_Comment2		 NULL,
		ReferralDischarge					    type_GlobalCode		 NULL,
		TreatmentCompletion						type_GlobalCode		 NULL,
		CONSTRAINT CustomDocumentDischarges_PK PRIMARY KEY CLUSTERED (DocumentVersionId) 
 )
 
 IF OBJECT_ID('CustomDocumentDischarges') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentDischarges >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentDischarges >>>', 16, 1)

/* 
 * TABLE: CustomDocumentDischarges 
 */   
    
ALTER TABLE CustomDocumentDischarges ADD CONSTRAINT DocumentVersions_CustomDocumentDischarges_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
 
 EXEC sys.sp_addextendedproperty 'CustomDocumentDischarges_Description'
,'DischargeType column stores P and A. A- Agency Discharge, P- Program Discharge'
,'schema'
,'dbo'
,'table'
,'CustomDocumentDischarges'
,'column'
,'DischargeType'
 
 
 PRINT 'STEP 4(A) COMPLETED'
 END
Go
 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDischargePrograms')
BEGIN
/* 
 * TABLE: CustomDischargePrograms 
 */
 CREATE TABLE CustomDischargePrograms( 
		DischargeProgramId						int identity(1,1)    NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,		
		DocumentVersionId						int					 NULL,
		ClientProgramId							int					 NULL,
		CONSTRAINT CustomDischargePrograms_PK PRIMARY KEY CLUSTERED (DischargeProgramId) 
 )
 
 IF OBJECT_ID('CustomDischargePrograms') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDischargePrograms >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDischargePrograms >>>', 16, 1)

/* 
 * TABLE: CustomDischargePrograms 
 */   

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CustomDischargePrograms]') AND name = N'XIE1_CustomDischargePrograms')
  BEGIN
   CREATE NONCLUSTERED INDEX [XIE1_CustomDischargePrograms] ON [dbo].[CustomDischargePrograms] 
   (
   [DocumentVersionId]  ASC
   )
   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomDischargePrograms') AND name='XIE1_CustomDischargePrograms')
   PRINT '<<< CREATED INDEX CustomDischargePrograms.XIE1_CustomDischargePrograms >>>'
   ELSE
   RAISERROR('<<< FAILED CREATING INDEX CustomDischargePrograms.XIE1_CustomDischargePrograms >>>', 16, 1)  
  END  
  
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CustomDischargePrograms]') AND name = N'XIE2_CustomDischargePrograms')
  BEGIN
   CREATE NONCLUSTERED INDEX [XIE2_CustomDischargePrograms] ON [dbo].[CustomDischargePrograms] 
   (
   [ClientProgramId]  ASC
   )
   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomDischargePrograms') AND name='XIE2_CustomDischargePrograms')
   PRINT '<<< CREATED INDEX CustomDischargePrograms.XIE2_CustomDischargePrograms >>>'
   ELSE
   RAISERROR('<<< FAILED CREATING INDEX CustomDischargePrograms.XIE2_CustomDischargePrograms >>>', 16, 1)  
  END  
        
/* 
 * TABLE: CustomDischargePrograms 
 */ 
 
ALTER TABLE CustomDischargePrograms ADD CONSTRAINT DocumentVersions_CustomDischargePrograms_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
 
 ALTER TABLE CustomDischargePrograms ADD CONSTRAINT ClientPrograms_CustomDischargePrograms_FK
    FOREIGN KEY (ClientProgramId)
    REFERENCES ClientPrograms(ClientProgramId)
 
 PRINT 'STEP 4(B) COMPLETED'
 END
Go
 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDischargeReferrals')
BEGIN
/* 
 * TABLE: CustomDischargeReferrals 
 */
 CREATE TABLE CustomDischargeReferrals( 
		DischargeReferralId						int identity(1,1)    NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		DocumentVersionId						int					 NULL,
		Referral								type_GlobalCode		 NULL,
		Program									type_GlobalCode		 NULL,
		CONSTRAINT CustomDischargeReferrals_PK PRIMARY KEY CLUSTERED (DischargeReferralId) 
 )
 
 IF OBJECT_ID('CustomDischargeReferrals') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDischargeReferrals >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDischargeReferrals >>>', 16, 1)

/* 
 * TABLE: CustomDischargeReferrals 
 */   

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CustomDischargeReferrals]') AND name = N'XIE1_CustomDischargeReferrals')
  BEGIN
   CREATE NONCLUSTERED INDEX [XIE1_CustomDischargeReferrals] ON [dbo].[CustomDischargeReferrals] 
   (
   [DocumentVersionId]  ASC
   )
   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomDischargeReferrals') AND name='XIE1_CustomDischargeReferrals')
   PRINT '<<< CREATED INDEX CustomDischargeReferrals.XIE1_CustomDischargeReferrals >>>'
   ELSE
   RAISERROR('<<< FAILED CREATING INDEX CustomDischargeReferrals.XIE1_CustomDischargeReferrals >>>', 16, 1)  
  END  
  
/* 
 * TABLE: CustomDischargeReferrals 
 */
     
ALTER TABLE CustomDischargeReferrals ADD CONSTRAINT DocumentVersions_CustomDischargeReferrals_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
 
 PRINT 'STEP 4(C) COMPLETED'
 END
Go
---- END Of STEP 4 --------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF NOT EXISTS (SELECT [key] FROM SystemConfigurationKeys WHERE [key] = 'CDM_Discharge')
	BEGIN
		INSERT INTO SystemConfigurationKeys
				   (CreatedBy
				   ,CreateDate 
				   ,ModifiedBy
				   ,ModifiedDate
				   ,[key]
				   ,Value
				   )
			 VALUES    
				   ('SHSDBA'
				   ,GETDATE()
				   ,'SHSDBA'
				   ,GETDATE()
				   ,'CDM_Discharge'
				   ,'1.0'
				   )
		PRINT 'STEP 7 COMPLETED'
	END
 GO