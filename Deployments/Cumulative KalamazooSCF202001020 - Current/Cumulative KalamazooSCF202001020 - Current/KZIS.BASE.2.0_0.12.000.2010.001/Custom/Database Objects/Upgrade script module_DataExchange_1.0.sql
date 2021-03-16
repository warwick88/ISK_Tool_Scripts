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

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomClientHealthDataAttributeMappings')
 BEGIN
/* 
 * TABLE:  CustomClientHealthDataAttributeMappings
 */

CREATE TABLE CustomClientHealthDataAttributeMappings (
	ClientHealthDataAttributeMappingId				int IDENTITY(1,1)		NOT NULL,
    CreatedBy										type_CurrentUser		NOT NULL,
    CreatedDate										type_CurrentDatetime	NOT NULL,
    ModifiedBy										type_CurrentUser		NOT NULL,
    ModifiedDate									type_CurrentDatetime	NOT NULL,
    RecordDeleted									type_YOrN				NULL
													CHECK (RecordDeleted in	('Y','N')),
    DeletedBy										type_UserId	            NULL,
    DeletedDate										datetime                NULL,	
	CurrentClientHealthDataAttributeId				int 					NOT NULL,
	ReferenceClientHealthDataAttributeId			int 					NOT NULL,
    CONSTRAINT CustomClientHealthDataAttributeMappings_PK PRIMARY KEY CLUSTERED (ClientHealthDataAttributeMappingId)
)

IF OBJECT_ID('CustomClientHealthDataAttributeMappings') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomClientHealthDataAttributeMappings >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE CustomClientHealthDataAttributeMappings >>>'

/* 
 * TABLE: CustomClientHealthDataAttributeMappings 
 */

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CustomClientHealthDataAttributeMappings]') AND name = N'XIE1_CustomClientHealthDataAttributeMappings')
  BEGIN
   CREATE NONCLUSTERED INDEX [XIE1_CustomClientHealthDataAttributeMappings] ON [dbo].[CustomClientHealthDataAttributeMappings] 
   (
   [CurrentClientHealthDataAttributeId]  ASC
   )
   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomClientHealthDataAttributeMappings') AND name='XIE1_CustomClientHealthDataAttributeMappings')
   PRINT '<<< CREATED INDEX CustomClientHealthDataAttributeMappings.XIE1_CustomClientHealthDataAttributeMappings >>>'
   ELSE
   RAISERROR('<<< FAILED CREATING INDEX CustomClientHealthDataAttributeMappings.XIE1_CustomClientHealthDataAttributeMappings >>>', 16, 1)  
  END 
  
/* 
 * TABLE: CustomClientHealthDataAttributeMappings 
 */	

ALTER TABLE CustomClientHealthDataAttributeMappings ADD CONSTRAINT ClientHealthDataAttributes_CustomClientHealthDataAttributeMappings_FK 
	FOREIGN KEY (CurrentClientHealthDataAttributeId)
	REFERENCES ClientHealthDataAttributes(ClientHealthDataAttributeId)
	    
EXEC sys.sp_addextendedproperty 'CustomClientHealthDataAttributeMappings_Description'
	,'this table is mapping table used to identify the request is coming for insert or modify health data attribute for a client.'
	,'schema'
	,'dbo'
	,'table'
	,'CustomClientHealthDataAttributeMappings'
												  
 PRINT 'STEP 4(A) COMPLETED' 
END
Go
------END Of STEP 4---------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

If NOT EXISTS (SELECT [key] FROM SystemConfigurationKeys WHERE [key] = 'CDM_DataExchange')
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
       ,'CDM_DataExchange'
       ,'1.0'
       )

	PRINT 'STEP 7 COMPLETED'            
 END
Go
