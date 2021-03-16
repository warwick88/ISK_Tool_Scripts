------- STEP 1 ----------
IF ((SELECT value FROM SystemConfigurationKeys WHERE [key] = 'CDM_MHAssessment')  < 1.0 ) or
Not exists(SELECT 1 FROM SystemConfigurationKeys WHERE [key] = 'CDM_MHAssessment')
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 1.0 for CDM_MHAssessment update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

--Part1 Begin

--Part1 Ends

--Part2 Begins 

--Part2 Ends

-----End of Step 2 -------

------ STEP 3 ------------

-----End of Step 3 -------

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentAssessmentDiagnosisIDDEligibilities')
BEGIN
/*  
 * TABLE: CustomDocumentAssessmentDiagnosisIDDEligibilities
 */ 
CREATE TABLE CustomDocumentAssessmentDiagnosisIDDEligibilities(
		DocumentVersionId					int							NOT NULL,
		CreatedBy							type_CurrentUser			NOT NULL,
		CreatedDate							type_CurrentDatetime		NOT NULL,
		ModifiedBy							type_CurrentUser			NOT NULL,
		ModifiedDate						type_CurrentDatetime		NOT NULL,
		RecordDeleted						type_YOrN					NULL
											CHECK (RecordDeleted in ('Y','N')),
		DeletedBy							type_UserId					NULL,
		DeletedDate							datetime					NULL,
		MentalPhysicalImpairment			char(1)						NULL
											CHECK (MentalPhysicalImpairment in ('Y','N','D')),
		ManifestedPrior						type_YOrN					NULL
											CHECK (ManifestedPrior in ('Y','N')),
		TestingReportsReviewed 				type_YOrN					NULL
											CHECK (TestingReportsReviewed in ('Y','N')),
		LikelyToContinue					type_YOrN					NULL
											CHECK (LikelyToContinue in ('Y','N')),
		CONSTRAINT CustomDocumentAssessmentDiagnosisIDDEligibilities_PK PRIMARY KEY CLUSTERED (DocumentVersionId)		 	
)
 IF OBJECT_ID('CustomDocumentAssessmentDiagnosisIDDEligibilities') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentAssessmentDiagnosisIDDEligibilities >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentAssessmentDiagnosisIDDEligibilities >>>', 16, 1)
    	
/* 
 * TABLE: CustomDocumentAssessmentDiagnosisIDDEligibilities 
 */ 

ALTER TABLE CustomDocumentAssessmentDiagnosisIDDEligibilities ADD CONSTRAINT DocumentVersions_CustomDocumentAssessmentDiagnosisIDDEligibilities_FK 
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)        

EXEC sys.sp_addextendedproperty 'CustomDocumentAssessmentDiagnosisIDDEligibilities_Description'
	,'MentalPhysicalImpairment field stores Y,N,D. Y- Yes, N- No, D- Documentation Requested'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentAssessmentDiagnosisIDDEligibilities'
	,'column'
	,'MentalPhysicalImpairment'	
	    
PRINT 'STEP 4(A) COMPLETED' 
END
Go

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomAssessmentDiagnosisIDDCriteria')
BEGIN
/*  
 * TABLE: CustomAssessmentDiagnosisIDDCriteria
 */ 
CREATE TABLE CustomAssessmentDiagnosisIDDCriteria(
		AssessmentDiagnosisIDDCriteriaId	int IDENTITY(1,1)			NOT NULL,
		CreatedBy							type_CurrentUser			NOT NULL,
		CreatedDate							type_CurrentDatetime		NOT NULL,
		ModifiedBy							type_CurrentUser			NOT NULL,
		ModifiedDate						type_CurrentDatetime		NOT NULL,
		RecordDeleted						type_YOrN					NULL
											CHECK (RecordDeleted in ('Y','N')),
		DeletedBy							type_UserId					NULL,
		DeletedDate							datetime					NULL,
		DocumentVersionId					int							NULL,
		SubstantialFunctional				type_GlobalCode				NULL,
		IsChecked							type_YOrN					NULL
											CHECK (IsChecked in ('Y','N')),
		CONSTRAINT CustomAssessmentDiagnosisIDDCriteria_PK PRIMARY KEY CLUSTERED (AssessmentDiagnosisIDDCriteriaId)		 	
)
 IF OBJECT_ID('CustomAssessmentDiagnosisIDDCriteria') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomAssessmentDiagnosisIDDCriteria >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomAssessmentDiagnosisIDDCriteria >>>', 16, 1)
    	
/* 
 * TABLE: CustomAssessmentDiagnosisIDDCriteria 
 */ 

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CustomAssessmentDiagnosisIDDCriteria]') AND name = N'XIE1_CustomAssessmentDiagnosisIDDCriteria')
  BEGIN
   CREATE NONCLUSTERED INDEX [XIE1_CustomAssessmentDiagnosisIDDCriteria] ON [dbo].[CustomAssessmentDiagnosisIDDCriteria] 
   (
   [DocumentVersionId]  ASC
   )
   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomAssessmentDiagnosisIDDCriteria') AND name='XIE1_CustomAssessmentDiagnosisIDDCriteria')
   PRINT '<<< CREATED INDEX CustomAssessmentDiagnosisIDDCriteria.XIE1_CustomAssessmentDiagnosisIDDCriteria >>>'
   ELSE
   RAISERROR('<<< FAILED CREATING INDEX CustomAssessmentDiagnosisIDDCriteria.XIE1_CustomAssessmentDiagnosisIDDCriteria >>>', 16, 1)  
  END    		

/* 
 * TABLE: CustomAssessmentDiagnosisIDDCriteria 
 */ 
 
ALTER TABLE CustomAssessmentDiagnosisIDDCriteria ADD CONSTRAINT DocumentVersions_CustomAssessmentDiagnosisIDDCriteria_FK 
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)        

EXEC sys.sp_addextendedproperty 'CustomAssessmentDiagnosisIDDCriteria_Description'
	,'SubstantialFunctional column stores globalcode of category "XSubstantialFunction"'
	,'schema'
	,'dbo'
	,'table'
	,'CustomAssessmentDiagnosisIDDCriteria'         
	,'column'
	,'SubstantialFunctional'
	
PRINT 'STEP 4(B) COMPLETED' 
END
Go

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentFunctionalAssessments')
BEGIN
/*  
 * TABLE: CustomDocumentFunctionalAssessments 
 */ 
CREATE TABLE CustomDocumentFunctionalAssessments(
		DocumentVersionId					int							NOT NULL,
		CreatedBy							type_CurrentUser			NOT NULL,
		CreatedDate							type_CurrentDatetime		NOT NULL,
		ModifiedBy							type_CurrentUser			NOT NULL,
		ModifiedDate						type_CurrentDatetime		NOT NULL,
		RecordDeleted						type_YOrN					NULL
											CHECK (RecordDeleted in ('Y','N')),
		DeletedBy							type_UserId					NULL,
		DeletedDate							datetime					NULL,
		Dressing							type_GlobalCode				NULL,
		PersonalHygiene						type_GlobalCode				NULL,
		Bathing								type_GlobalCode				NULL,
		Eating								type_GlobalCode				NULL,
		SleepHygiene						type_GlobalCode				NULL,
		SelfCareSkillComments				type_Comment2				NULL,
		SelfCareSkillNeedsList				type_YOrN					NULL
											CHECK (SelfCareSkillNeedsList in ('Y','N')),
		FinancialTransactions				type_GlobalCode				NULL,
		ManagesPersonalFinances				type_GlobalCode				NULL,
		CookingMealPreparation				type_GlobalCode				NULL,
		KeepingRoomTidy						type_GlobalCode				NULL,
		HouseholdTasks						type_GlobalCode				NULL,
		LaundryTasks						type_GlobalCode				NULL,
		HomeSafetyAwareness					type_GlobalCode				NULL,
		DailyLivingSkillComments			type_Comment2				NULL,
		DailyLivingSkillNeedsList			type_YOrN					NULL
											CHECK (DailyLivingSkillNeedsList in ('Y','N')),
		ComfortableInteracting				type_GlobalCode				NULL,
		ComfortableLargerGroups				type_GlobalCode				NULL,
		AppropriateConversations			type_GlobalCode				NULL,
		AdvocatesForSelf					type_GlobalCode				NULL,
		CommunicatesDailyLiving				type_GlobalCode				NULL,
		SocialComments						type_Comment2				NULL,
		SocialSkillNeedsList				type_YOrN					NULL
											CHECK (SocialSkillNeedsList in ('Y','N')),
		MaintainsFamily						type_GlobalCode				NULL,
		MaintainsFriendships				type_GlobalCode				NULL,
		DemonstratesEmpathy					type_GlobalCode				NULL,
		ManageEmotions						type_GlobalCode				NULL,
		EmotionalComments					type_Comment2				NULL,
		EmotionalNeedsList					type_YOrN					NULL
											CHECK (EmotionalNeedsList in ('Y','N')),
		RiskHarmToSelf						type_GlobalCode				NULL,
		RiskSelfComments					type_Comment2				NULL,
		RiskHarmToOthers					type_GlobalCode				NULL,
		RiskOtherComments					type_Comment2				NULL,
		PropertyDestruction					type_GlobalCode				NULL,
		PropertyDestructionComments			type_Comment2				NULL,
		Elopement							type_GlobalCode				NULL,
		ElopementComments					type_Comment2				NULL,
		MentalIllnessSymptoms				type_GlobalCode				NULL,
		MentalIllnessSymptomComments		type_Comment2				NULL,
		RepetitiveBehaviors					type_GlobalCode				NULL,
		RepetitiveBehaviorComments			type_Comment2				NULL,
		SocialEmotionalBehavioralOther		type_Comment2				NULL,
		SocialEmotionalBehavioralNeedList	type_YOrN					NULL
											CHECK (SocialEmotionalBehavioralNeedList in ('Y','N')),
		CommunicationComments				type_Comment2				NULL,
		CommunicationNeedList				type_YOrN					NULL
											CHECK (CommunicationNeedList in ('Y','N')),
		RentArrangements					type_GlobalCode				NULL,
		PayRentBillsOnTime					type_GlobalCode				NULL,
		PersonalItems						type_GlobalCode				NULL,
		AttendSocialOutings					type_GlobalCode				NULL,
		CommunityTransportation				type_GlobalCode				NULL,
		DangerousSituations					type_GlobalCode				NULL,
		AdvocateForSelf						type_GlobalCode				NULL,
		ManageChangesDailySchedule			type_GlobalCode				NULL,
		CommunityLivingSkillComments		type_Comment2				NULL,
		PreferredActivities					type_Comment2				NULL,
		CommunityLivingSkillNeedList		type_YOrN					NULL
											CHECK (CommunityLivingSkillNeedList in ('Y','N')),
		CONSTRAINT CustomDocumentFunctionalAssessments_PK PRIMARY KEY CLUSTERED (DocumentVersionId)		 	
)
 IF OBJECT_ID('CustomDocumentFunctionalAssessments') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentFunctionalAssessments >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentFunctionalAssessments >>>', 16, 1)
	
/* 
 * TABLE: CustomDocumentFunctionalAssessments 
 */ 

ALTER TABLE CustomDocumentFunctionalAssessments ADD CONSTRAINT DocumentVersions_CustomDocumentFunctionalAssessments_FK 
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)        

EXEC sys.sp_addextendedproperty 'CustomDocumentFunctionalAssessments_Description'
	,'Dressing column stores globalcode of category "XFA5PointScale"'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentFunctionalAssessments'         
	,'column'
	,'Dressing'
	
PRINT 'STEP 4(C) COMPLETED'
END
Go

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomAssessmentFunctionalCommunications')
BEGIN
/*  
 * TABLE: CustomAssessmentFunctionalCommunications
 */ 
CREATE TABLE CustomAssessmentFunctionalCommunications(
		AssessmentFunctionalCommunicationId	int IDENTITY(1,1)			NOT NULL,
		CreatedBy							type_CurrentUser			NOT NULL,
		CreatedDate							type_CurrentDatetime		NOT NULL,
		ModifiedBy							type_CurrentUser			NOT NULL,
		ModifiedDate						type_CurrentDatetime		NOT NULL,
		RecordDeleted						type_YOrN					NULL
											CHECK (RecordDeleted in ('Y','N')),
		DeletedBy							type_UserId					NULL,
		DeletedDate							datetime					NULL,
		DocumentVersionId					int							NULL,
		Communication						type_GlobalCode				NULL,
		IsChecked							type_YOrN					NULL
											CHECK (IsChecked in ('Y','N')),
		CONSTRAINT CustomAssessmentFunctionalCommunications_PK PRIMARY KEY CLUSTERED (AssessmentFunctionalCommunicationId)		 	
)
 IF OBJECT_ID('CustomAssessmentFunctionalCommunications') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomAssessmentFunctionalCommunications >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomAssessmentFunctionalCommunications >>>', 16, 1)
    	
/* 
 * TABLE: CustomAssessmentFunctionalCommunications 
 */ 

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CustomAssessmentFunctionalCommunications]') AND name = N'XIE1_CustomAssessmentFunctionalCommunications')
  BEGIN
   CREATE NONCLUSTERED INDEX [XIE1_CustomAssessmentFunctionalCommunications] ON [dbo].[CustomAssessmentFunctionalCommunications] 
   (
   [DocumentVersionId]  ASC
   )
   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomAssessmentFunctionalCommunications') AND name='XIE1_CustomAssessmentFunctionalCommunications')
   PRINT '<<< CREATED INDEX CustomAssessmentFunctionalCommunications.XIE1_CustomAssessmentFunctionalCommunications >>>'
   ELSE
   RAISERROR('<<< FAILED CREATING INDEX CustomAssessmentFunctionalCommunications.XIE1_CustomAssessmentFunctionalCommunications >>>', 16, 1)  
  END    		

/* 
 * TABLE: CustomAssessmentFunctionalCommunications 
 */ 
 
ALTER TABLE CustomAssessmentFunctionalCommunications ADD CONSTRAINT DocumentVersions_CustomAssessmentFunctionalCommunications_FK 
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)        

EXEC sys.sp_addextendedproperty 'CustomAssessmentFunctionalCommunications_Description'
	,'Communication column stores globalcode of category "XCommunication"'
	,'schema'
	,'dbo'
	,'table'
	,'CustomAssessmentFunctionalCommunications'         
	,'column'
	,'Communication'
	
PRINT 'STEP 4(D) COMPLETED' 
END
Go
---- END Of STEP 4 --------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((SELECT cast(value as decimal(10,2)) FROM SystemConfigurationKeys WHERE [key] = 'CDM_MHAssessment')  = 1.0)
BEGIN
	
UPDATE SystemConfigurationKeys SET value ='1.1' WHERE [key] = 'CDM_MHAssessment'
PRINT 'STEP 7 COMPLETED'
END
ELSE
IF NOT EXISTS (	SELECT [key] FROM SystemConfigurationKeys	WHERE [key] = 'CDM_MHAssessment')
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
		,'CDM_MHAssessment'
		,'1.1'
		)

	PRINT 'STEP 7 COMPLETED'
END
Go
