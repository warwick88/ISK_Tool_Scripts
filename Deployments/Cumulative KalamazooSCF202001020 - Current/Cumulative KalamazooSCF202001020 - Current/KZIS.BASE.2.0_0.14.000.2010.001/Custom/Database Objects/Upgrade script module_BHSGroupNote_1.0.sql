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
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomBHSGroupNotes')
BEGIN
/* 
 * TABLE: CustomBHSGroupNotes 
 */
  CREATE TABLE CustomBHSGroupNotes( 
		BHSGroupNoteId					int	identity(1,1)	 NOT NULL,
		CreatedBy						type_CurrentUser     NOT NULL,
		CreatedDate						type_CurrentDatetime NOT NULL,
		ModifiedBy						type_CurrentUser     NOT NULL,
		ModifiedDate					type_CurrentDatetime NOT NULL,
		RecordDeleted					type_YOrN			 NULL
										CHECK (RecordDeleted in ('Y','N')),
		DeletedBy						type_UserId          NULL,
		DeletedDate						datetime             NULL,
		DocumentVersionId				int					 NULL,
		NumberOfClientsInSession		int					 NULL,
		GroupDescription				type_Comment2		 NULL,
CONSTRAINT CustomBHSGroupNotes_PK PRIMARY KEY CLUSTERED (BHSGroupNoteId) 
 )
 
  IF OBJECT_ID('CustomBHSGroupNotes') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomBHSGroupNotes >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomBHSGroupNotes >>>', 16, 1)

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('CustomBHSGroupNotes') AND name='XIE1_CustomBHSGroupNotes')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_CustomBHSGroupNotes] ON [dbo].[CustomBHSGroupNotes] 
		(
		[DocumentVersionId] ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomBHSGroupNotes') AND name='XIE1_CustomBHSGroupNotes')
		PRINT '<<< CREATED INDEX CustomBHSGroupNotes.XIE1_CustomBHSGroupNotes >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX CustomBHSGroupNotes.XIE1_CustomBHSGroupNotes >>>', 16, 1)		
		END
		
/* 
 * TABLE: CustomBHSGroupNotes 
 */      
ALTER TABLE CustomBHSGroupNotes ADD CONSTRAINT DocumentVersions_CustomBHSGroupNotes_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
    
    PRINT 'STEP 4(A) COMPLETED'

END
 
 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentBHSClientNotes')
BEGIN
/* 
 * TABLE: CustomDocumentBHSClientNotes 
 */
  CREATE TABLE CustomDocumentBHSClientNotes( 
		DocumentVersionId					int					 NOT NULL,
		CreatedBy							type_CurrentUser     NOT NULL,
		CreatedDate							type_CurrentDatetime NOT NULL,
		ModifiedBy							type_CurrentUser     NOT NULL,
		ModifiedDate						type_CurrentDatetime NOT NULL,
		RecordDeleted						type_YOrN			 NULL
											CHECK (RecordDeleted in ('Y','N')),
		DeletedBy							type_UserId          NULL,
		DeletedDate							datetime             NULL,
		BHSGroupNoteId						int					 NULL,
		MoodOrAffect						type_YOrN			 NULL
											CHECK (MoodOrAffect in ('Y','N')),
		MoodOrAffectComments				Varchar(100)		 NULL,
		ThoughtProcess						type_YOrN			 NULL
											CHECK (ThoughtProcess in ('Y','N')),
		ThoughtProcessComments				Varchar(100)		 NULL,
		Behavior							type_YOrN			 NULL
											CHECK (Behavior in ('Y','N')),
		BehaviorComments					Varchar(100)		 NULL,
		MedicalCondition					type_YOrN			 NULL
											CHECK (MedicalCondition in ('Y','N')),
		MedicalConditionComments			Varchar(100)		 NULL,
		SubstanceUse						type_YOrN			 NULL
											CHECK (SubstanceUse in ('Y','N')),
		SubstanceUseComments				Varchar(100)		 NULL,
		HomicidalNoneReportedorDangerTo		type_YOrN			 NULL
											CHECK (HomicidalNoneReportedorDangerTo in ('Y','N')),
		HomicidalSelf						type_YOrN			 NULL
											CHECK (HomicidalSelf in ('Y','N')),
		HomicidalOthers						type_YOrN			 NULL
											CHECK (HomicidalOthers in ('Y','N')),
		HomicidalProperty					type_YOrN			 NULL
											CHECK (HomicidalProperty in ('Y','N')),
		Homicidalideation					type_YOrN			 NULL
											CHECK (Homicidalideation in ('Y','N')),
		HomicidalPlan						type_YOrN			 NULL
											CHECK (HomicidalPlan in ('Y','N')),
		HomicidalIntent						type_YOrN			 NULL
											CHECK (HomicidalIntent in ('Y','N')),
		HomicidalAttempt					type_YOrN			 NULL
											CHECK (HomicidalAttempt in ('Y','N')),
		HomicidalOther						type_YOrN			 NULL
											CHECK (HomicidalOther in ('Y','N')),
		HomicidalOtherComments				Varchar(100)		 NULL,
		DocumentResponse					type_Comment2		 NULL,
		CurrentMedications					type_YOrN			 NULL
											CHECK (CurrentMedications in ('Y','N')),
		CurrentMedicationsComments			type_Comment2		 NULL,
		NumberOfClientsInSession			int					 NULL,
		AttentionNormal						type_YOrN			 NULL
											CHECK (AttentionNormal in ('Y','N')),
		AttentionInattentive				type_YOrN			 NULL
											CHECK (AttentionInattentive in ('Y','N')),
		AttentionDistractible				type_YOrN			 NULL
											CHECK (AttentionDistractible in ('Y','N')),
		AttentionConfused					type_YOrN			 NULL
											CHECK (AttentionConfused in ('Y','N')),
		AttitudeCooperative					type_YOrN			 NULL
											CHECK (AttitudeCooperative in ('Y','N')),
		AttitudeUninterested				type_YOrN			 NULL
											CHECK (AttitudeUninterested in ('Y','N')),
		AttitudeResistance					type_YOrN			 NULL
											CHECK (AttitudeResistance in ('Y','N')),
		AttitudeHostile						type_YOrN			 NULL
											CHECK (AttitudeHostile in ('Y','N')),
		AttitudeIUnremarkable				type_YOrN			 NULL
											CHECK (AttitudeIUnremarkable in ('Y','N')),
		InterPersonalShowedEmpathy			type_YOrN			 NULL
											CHECK (InterPersonalShowedEmpathy in ('Y','N')),
		InterPersonalEngaged				type_YOrN			 NULL
											CHECK (InterPersonalEngaged in ('Y','N')),
		InterPersonalProvideHelpfulFeedback	type_YOrN			 NULL
											CHECK (InterPersonalProvideHelpfulFeedback in ('Y','N')),
		InterPersonalAttentionSeeking		type_YOrN			 NULL
											CHECK (InterPersonalAttentionSeeking in ('Y','N')),
		InterPersonalDisruptive				type_YOrN			 NULL
											CHECK (InterPersonalDisruptive in ('Y','N')),
		InterPersonalNotRespectiveToOthers	type_YOrN			 NULL
											CHECK (InterPersonalNotRespectiveToOthers in ('Y','N')),
		InterPersonalNotinvolved			type_YOrN			 NULL
											CHECK (InterPersonalNotinvolved in ('Y','N')),
		InterPersonalUnremarkable			type_YOrN			 NULL
											CHECK (InterPersonalUnremarkable in ('Y','N')),
		TopicRecoveryExcellent				type_YOrN			 NULL
											CHECK (TopicRecoveryExcellent in ('Y','N')),
		TopicRecoveryGood					type_YOrN			 NULL
											CHECK (TopicRecoveryGood in ('Y','N')),
		TopicRecoverySatisfactory			type_YOrN			 NULL
											CHECK (TopicRecoverySatisfactory in ('Y','N')),
		TopicRecoveryMarginal				type_YOrN			 NULL
											CHECK (TopicRecoveryMarginal in ('Y','N')),
		TopicRecoveryPoor					type_YOrN			 NULL
											CHECK (TopicRecoveryPoor in ('Y','N')),
		GroupDescription					type_Comment2		 NULL,
CONSTRAINT CustomDocumentBHSClientNotes_PK PRIMARY KEY CLUSTERED (DocumentVersionId) 
 )
 
  IF OBJECT_ID('CustomDocumentBHSClientNotes') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentBHSClientNotes >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentBHSClientNotes >>>', 16, 1)

  IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('CustomDocumentBHSClientNotes') AND name='XIE1_CustomDocumentBHSClientNotes')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_CustomDocumentBHSClientNotes] ON [dbo].[CustomDocumentBHSClientNotes] 
		(
		[BHSGroupNoteId] ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomDocumentBHSClientNotes') AND name='XIE1_CustomDocumentBHSClientNotes')
		PRINT '<<< CREATED INDEX CustomDocumentBHSClientNotes.XIE1_CustomDocumentBHSClientNotes >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX CustomDocumentBHSClientNotes.XIE1_CustomDocumentBHSClientNotes >>>', 16, 1)		
		END
		
/* 
 * TABLE: CustomDocumentBHSClientNotes 
 */   
    
ALTER TABLE CustomDocumentBHSClientNotes ADD CONSTRAINT DocumentVersions_CustomDocumentBHSClientNotes_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
    
        
ALTER TABLE CustomDocumentBHSClientNotes ADD CONSTRAINT CustomBHSGroupNotes_CustomDocumentBHSClientNotes_FK
    FOREIGN KEY (BHSGroupNoteId)
    REFERENCES CustomBHSGroupNotes(BHSGroupNoteId)
    
    PRINT 'STEP 4(B) COMPLETED'

END
----END Of STEP 4 ---------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
If not exists (select [key] from SystemConfigurationKeys where [key] = 'CDM_BHSGroupNote')
	begin
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
				   ,'CDM_BHSGroupNote'
				   ,'1.0'
				   )
				    PRINT 'STEP 7 COMPLETED'
	End
 GO