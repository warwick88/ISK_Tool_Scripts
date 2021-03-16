
/****** Object:  Trigger [cst_CreateScannedDocumentCodes]    Script Date: 04/09/2018 11:44:28 ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[cst_CreateScannedDocumentCodes]'))
DROP TRIGGER [dbo].[cst_CreateScannedDocumentCodes]
GO


/****** Object:  Trigger [dbo].[cst_CreateScannedDocumentCodes]    Script Date: 04/09/2018 11:44:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO  
  
-- =============================================  
-- Author:  Ryan Noble  
-- Create date: Mar.27.2012  
-- Description: Creates documentCode records for 'ScannedRecordType' globalCodes  

 -- 12.13.2019   Bibhu       What : RaisError ErrorCode added.
 --                           Why :  Engineering Improvement Initiatives- NBL(I) #103012  

-- =============================================  
Create TRIGGER [dbo].[cst_CreateScannedDocumentCodes] ON [dbo].[GlobalCodes]  
    AFTER INSERT, UPDATE  
AS  
    BEGIN  
        BEGIN TRY  
 --If there is a row in the update / insert which is a part of the 'ScannedRecordType' category then do some updates and inserts  
            IF EXISTS ( SELECT  *  
                        FROM    INSERTED a  
                        WHERE   a.category = 'SCANNEDRECORDTYPE' )   
                BEGIN  
  
                    CREATE TABLE #identity  
                        (  
                          id INT IDENTITY  
                                 NOT NULL ,  
                          data BIT NULL  
                        )        
                    DECLARE @idenity_seed INT        
       
                    SET @idenity_seed = @@identity        
  
                
                    DECLARE @DocumentCodes TABLE  
                        (  
                          GlobalCodeId INT ,  
                          DocumentCodeId INT  
                        )  
  
  -- For new scanned record types, create the documentCode record  
                    INSERT  INTO dbo.DocumentCodes  
                            ( DocumentName ,  
                              DocumentDescription ,  
                              DocumentType ,  
                              Active ,  
                              ServiceNote ,  
                              PatientConsent ,  
                              ViewDocument ,  
                              OnlyAvailableOnline ,  
                              ImageFormatType ,  
                              DefaultImageFolderId ,  
                              ImageFormat ,  
                              ViewDocumentURL ,  
                              ViewDocumentRDL ,  
                              StoredProcedure ,  
                              TableList ,  
                              RequiresSignature ,  
                              ViewOnlyDocument ,  
                              DocumentSchema ,  
                              DocumentHTML ,  
                              DocumentURL ,  
                              ToBeInitialized ,  
                              InitializationProcess ,  
                              InitializationStoredProcedure ,  
                              FormCollectionId ,  
                              ValidationStoredProcedure ,  
                              ViewStoredProcedure ,  
                              CreatedBy ,  
                              CreatedDate ,  
                              ModifiedBy ,  
                              ModifiedDate ,  
                              RecordDeleted ,  
                              DeletedDate ,  
                              DeletedBy  
                  )  
                    OUTPUT  INSERTED.DeletedBy ,  
                            inserted.DocumentCodeId  
                            INTO @DocumentCodes  
                            SELECT  a.CodeName ,  
                                    a.CodeName ,  
                                    17 ,  
                                    'Y' ,  
                                    'N' ,  
                                    NULL ,  
                                    NULL ,  
                                    'N' ,  
                                    NULL ,  
                                    NULL ,  
                                    NULL ,  
                                    'RDLScannedForms' ,  
                                    'RDLScannedForms' ,  
                                    NULL ,  
                                    NULL ,  
                                    'N' ,  
                                    NULL ,  
                                    NULL ,  
                                    NULL ,  
                                    NULL ,  
                                    NULL ,  
                                    NULL ,  
                                    NULL ,  
                                    NULL ,  
                                    NULL ,  
                                    NULL ,  
                                    'GCTrigger' ,  
                                    GETDATE() ,  
                                    'GCTrigger' ,  
                                    GETDATE() ,  
                                    NULL ,  
                                    NULL ,  
                                    CONVERT(VARCHAR(250), a.GlobalCodeId) --Use DeletedBy column to temporarily store globalCodeId for mapping  
                            FROM    INSERTED a  
                            WHERE   a.Category = 'SCANNEDRECORDTYPE'  
                                    AND NOT EXISTS ( SELECT *  
                                                     FROM   CustomMapDocumentCodesToGlobalCodes b  
                                                     WHERE  b.GlobalCodeId = a.GlobalCodeId )  
  
     -- Create the corresponding Screen record   
                    INSERT  INTO dbo.Screens  
                            ( ScreenName ,  
                              ScreenType ,  
                              ScreenURL ,  
                              ScreenToolbarURL ,  
                              TabId ,  
                              InitializationStoredProcedure ,  
                              ValidationStoredProcedureUpdate ,  
                              ValidationStoredProcedureComplete ,  
                              PostUpdateStoredProcedure ,  
                              RefreshPermissionsAfterUpdate ,  
                              DocumentCodeId ,  
                              CustomFieldFormId ,  
                              CreatedBy ,  
                              CreatedDate ,  
                              ModifiedBy ,  
                              ModifiedDate ,  
                              RecordDeleted ,  
                              DeletedDate ,  
                              DeletedBy  
                            )  
                            SELECT  a.CodeName , -- ScreenName - varchar(100)  
                                    5763 , -- ScreenType - type_GlobalCode  
                                    '/ActivityPages/Client/Detail/Documents/ScannedMedicalRecord.ascx' , -- ScreenURL - varchar(200)  
                                    NULL , -- ScreenToolbarURL - varchar(200)  
                                    2 , -- TabId - int  
                                    NULL , -- InitializationStoredProcedure - varchar(100)  
                                    NULL , -- ValidationStoredProcedureUpdate - varchar(100)  
                                    NULL , -- ValidationStoredProcedureComplete - varchar(100)  
                                    NULL , -- PostUpdateStoredProcedure - varchar(100)  
                                    NULL , -- RefreshPermissionsAfterUpdate - type_YOrN  
                                    b.DocumentCodeId , -- DocumentCodeId - int  
                                    NULL , -- CustomFieldFormId - int  
                                    a.CreatedBy , -- CreatedBy - type_CurrentUser  
                                    a.CreatedDate , -- CreatedDate - type_CurrentDatetime  
                                    a.ModifiedBy , -- ModifiedBy - type_CurrentUser  
                                    a.ModifiedDate , -- ModifiedDate - type_CurrentDatetime  
                                    NULL , -- RecordDeleted - type_YOrN  
                                    NULL , -- DeletedDate - datetime  
                                    NULL  -- DeletedBy - type_UserId  
                            FROM    INSERTED a  
                                    JOIN @DocumentCodes b ON a.GlobalCodeId = b.GlobalCodeId  
                            WHERE   a.Category = 'SCANNEDRECORDTYPE'  
                                    AND NOT EXISTS ( SELECT *  
                                                     FROM   CustomMapDocumentCodesToGlobalCodes c  
                                                     WHERE  c.GlobalCodeId = a.GlobalCodeId )  
  
  
     -- Create the corresponding DocumentNavigation Record  
                    INSERT  INTO dbo.DocumentNavigations  
                            ( NavigationName ,  
                              DisplayAs ,  
                              Active ,  
                              ParentDocumentNavigationId ,  
                              BannerId ,  
                              ScreenId ,  
                              RowIdentifier ,  
                              CreatedBy ,  
                              CreatedDate ,  
                              ModifiedBy ,  
                              ModifiedDate ,  
                              RecordDeleted ,  
                              DeletedDate ,  
                              DeletedBy  
       
                            )  
                            SELECT  a.CodeName , -- NavigationName - varchar(100)  
                                    a.CodeName , -- DisplayAs - varchar(100)  
                                    'Y' , -- Active - type_Active  
                                    56 , -- ParentDocumentNavigationId - int  
                                    NULL , -- BannerId - int  
                                    c.ScreenId , -- ScreenId - int  
                                    NEWID(),  
                                    a.CreatedBy , -- CreatedBy - type_CurrentUser  
                                    a.CreatedDate , -- CreatedDate - type_CurrentDatetime  
                                    a.ModifiedBy , -- ModifiedBy - type_CurrentUser  
                                    a.ModifiedDate , -- ModifiedDate - type_CurrentDatetime  
                                    NULL , -- RecordDeleted - type_YOrN  
                                    NULL , -- DeletedDate - datetime  
                                    NULL  -- DeletedBy - type_UserId  
                            FROM    INSERTED a  
                                    JOIN @DocumentCodes b ON a.GlobalCodeId = b.GlobalCodeId  
                                    JOIN Screens c ON c.DocumentCodeId = b.DocumentCodeId  
                            WHERE   a.Category = 'SCANNEDRECORDTYPE'  
                                    AND NOT EXISTS ( SELECT *  
                                                     FROM   CustomMapDocumentCodesToGlobalCodes d  
                                                     WHERE  d.GlobalCodeId = a.GlobalCodeId )  
  
  
                    INSERT  INTO CustomMapDocumentCodesToGlobalCodes  
                            ( DocumentCodeId ,  
                              GlobalCodeId  
                            )  
                            SELECT  DocumentCodeId ,  
                                    GlobalCodeId  
                            FROM    @DocumentCodes  
                                
    -- Because manipulation of inserted tables do not allow text, ntext, image, etc, we need to update those outside of the original scope  
                    UPDATE  a  
                    SET     a.DeletedBy = CASE WHEN ISNUMERIC(a.DeletedBy) = 1  
                                               THEN NULL  
                                               ELSE a.DeletedBy  
                                          END ,  
                            a.DocumentDescription = c.description  
                    FROM    DocumentCodes a  
                            JOIN @DocumentCodes b ON a.DocumentCodeId = b.DocumentCodeId  
                            JOIN GlobalCodes c ON c.GlobalCodeId = b.GlobalCodeId  
                    
       -- For existing scanned record types, update the corresponding DocumentCode  
                    UPDATE  a  
                    SET     a.DocumentName = c.CodeName ,  
                            a.DocumentDescription = c.CodeName ,  
                            a.ACTIVE = c.Active  
                    FROM    DocumentCodes a  
                            JOIN CustomMapDocumentCodesToGlobalCodes b ON a.DocumentCodeId = b.DocumentCodeId  
                            JOIN INSERTED c ON c.GlobalCodeId = b.GlobalCodeId  
                                               AND c.Category = 'SCANNEDRECORDTYPE'  
  
    -- For existing scanned record types, update the corresponding Screens record(s)  
     UPDATE a  
     SET a.ScreenName = c.CodeName        
     FROM Screens a  
     JOIN CustomMapDocumentCodesToGlobalCodes b ON a.DocumentCodeId = b.DocumentCodeId  
     JOIN INSERTED c ON c.GlobalCodeId = b.GlobalCodeId  
     AND c.Category = 'SCANNEDRECORDTYPE'  
  
    
    -- For existing scanned record types, update the corresponding DocumentNavigations record(s)  
     UPDATE a  
     SET a.NavigationName = c.CodeName,  
     a.DisplayAs = c.CodeName  
     FROM dbo.DocumentNavigations a  
     JOIN Screens s ON s.ScreenId = a.ScreenId  
     JOIN CustomMapDocumentCodesToGlobalCodes b ON s.DocumentCodeId = b.DocumentCodeId  
     JOIN INSERTED c ON c.GlobalCodeId = b.GlobalCodeId  
     AND c.Category = 'SCANNEDRECORDTYPE'  
  
    -- PM does a select @@Identity after insert.  To handle this, we need to restore @@Identity within scope        
                    IF @idenity_seed > 0   
                        BEGIN        
                            DBCC checkident('#identity', reseed, @idenity_seed) WITH no_infomsgs        
                            INSERT  INTO #identity  
                                    ( data )  
                            VALUES  ( 1 )        
                        END        
  
                END  
        END TRY  
        
        BEGIN CATCH  
            
            RAISERROR ('ERR_cst_CreateScannedDocumentCodes : Please contact your system administrator.', 16, 1);    

        END CATCH  
    
    END  
  