
----- STEP 1 ----------

------ STEP 2 ----------

-----END OF STEP 2 -------

------ STEP 3 ------------

------ END OF STEP 3 -----

------ STEP 4 ----------

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentAdverseChildhoodExperiences')
BEGIN
/*  
 * TABLE:  CustomDocumentAdverseChildhoodExperiences 
 */ 
CREATE TABLE CustomDocumentAdverseChildhoodExperiences(
	DocumentVersionId							int							NOT NULL,
	CreatedBy									type_CurrentUser			NOT NULL,
	CreatedDate									type_CurrentDatetime		NOT NULL,
	ModifiedBy									type_CurrentUser			NOT NULL,
	ModifiedDate								type_CurrentDatetime		NOT NULL,
	RecordDeleted								type_YOrN					NULL
												CHECK (RecordDeleted in ('Y','N')),
	DeletedBy									type_UserId					NULL,
	DeletedDate									datetime					NULL,
	UnableToComplete							type_YOrN					NULL
												CHECK (UnableToComplete in ('Y','N')),
	Humiliate									type_YOrN					NULL
												CHECK (Humiliate in ('Y','N')),
	Injured										type_YOrN					NULL
												CHECK (Injured in ('Y','N')),
	Touch										type_YOrN					NULL
												CHECK (Touch in ('Y','N')),
	Support										type_YOrN					NULL
												CHECK (Support in ('Y','N')),
	EnoughToEat									type_YOrN					NULL
												CHECK (EnoughToEat in ('Y','N')),
	ParentsSeparated							type_YOrN					NULL
												CHECK (ParentsSeparated in ('Y','N')),
	Pushed										type_YOrN					NULL
												CHECK (Pushed in ('Y','N')),
	DrinkerProblem								type_YOrN					NULL
												CHECK (DrinkerProblem in ('Y','N')),
	Suicide										type_YOrN					NULL
												CHECK (Suicide in ('Y','N')),
	Prison										type_YOrN					NULL
												CHECK (Prison in ('Y','N')),
	AceScore									int							NULL,
	CONSTRAINT CustomDocumentAdverseChildhoodExperiences_PK PRIMARY KEY CLUSTERED (DocumentVersionId) 
) 
 IF OBJECT_ID('CustomDocumentAdverseChildhoodExperiences') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentAdverseChildhoodExperiences >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentAdverseChildhoodExperiences >>>', 16, 1)
 
 	    
/* 
 * TABLE: CustomDocumentAdverseChildhoodExperiences 
 */ 
  ALTER TABLE CustomDocumentAdverseChildhoodExperiences ADD CONSTRAINT DocumentVersions_CustomDocumentAdverseChildhoodExperiences_FK 
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)   
   
    
PRINT 'STEP 4(A) COMPLETED'
END

--------------------------------------------------------------
--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF NOT EXISTS (	SELECT [key] FROM SystemConfigurationKeys	WHERE [key] = 'CDM_AdverseChildhoodExperience')
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
		,'CDM_AdverseChildhoodExperience'
		,'1.0'
		)
	PRINT 'STEP 7 COMPLETED'
END
GO