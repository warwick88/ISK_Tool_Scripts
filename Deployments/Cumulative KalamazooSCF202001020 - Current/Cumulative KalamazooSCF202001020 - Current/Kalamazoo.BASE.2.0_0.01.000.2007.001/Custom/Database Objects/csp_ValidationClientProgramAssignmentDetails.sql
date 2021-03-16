SET ANSI_NULLS ON
GO 

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[csp_ValidationClientProgramAssignmentDetails]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].[csp_ValidationClientProgramAssignmentDetails]
GO

/************************************************************************************************
 Stored Procedure: dbo.csp_ValidationClientProgramAssignmentDetails                                     
                                                                                                 
 Created By: Jay                                                                                    
 Purpose:                        
                                                                                                 
 Test Call:  
      Exec csp_ValidationClientProgramAssignmentDetails
                                                                                                 
                                                                                                 
 Change Log:                                                                                     
 04/11/2017 - Robert Caffrey - Changed @CurrentUserID Parameter to @StaffId - Valley Support #628                                                                                                 
                                                                                                 
****************************************************************************************************/


CREATE PROCEDURE [dbo].csp_ValidationClientProgramAssignmentDetails
    @StaffId VARCHAR(30)
,   @ScreenKeyId INT -- clientProgramid
AS
    BEGIN
        DECLARE @ErrorMessage VARCHAR(MAX) = ''
        DECLARE @ClientId INTEGER
        DECLARE @ProgramId INTEGER
        DECLARE @SomethingToCheck type_YOrN = 'Y'
        DECLARE @FutureScheduledServices INT
        DECLARE @DischargeDate DATE
	
		
        
        BEGIN TRY
            SELECT  @ClientId = CP.ClientId
            ,       @ProgramId = CP.ProgramId
            ,       @DischargeDate = ISNULL(CP.DischargedDate, '9/9/9999') -- I dunno why not
            FROM    ClientPrograms CP
            WHERE   CP.ClientProgramId = @ScreenKeyId


            --#############################################################################
            -- find out if we should even check
            --############################################################################# 
            SELECT  @SomethingToCheck = 'N'
            FROM    ClientPrograms CP
            WHERE   CP.ClientProgramId = @ScreenKeyId
                    AND ( 
                    --#############################################################################
                    -- Bail if this isn't a discharge (GC ClientPrograms.Status = 5)
                    --############################################################################# 
                          ISNULL(CP.Status, 4) <> 5
                        --#############################################################################
                        -- Bail if there's another instance of this program type with an enrolled date
                        -- greater than this discharge date.
                        --############################################################################# 
                          OR EXISTS ( SELECT    1
                                      FROM      ClientPrograms CP2
                                      WHERE     CP2.ClientId = CP.ClientId
                                                AND CP2.ProgramId = CP.ProgramId
                                                AND ISNULL(CP2.RecordDeleted,
                                                           'N') = 'N'
                                                AND CP2.EnrolledDate > CP.EnrolledDate )
                        )


            DECLARE @validationReturnTable TABLE
                (
                 TableName VARCHAR(200)
                ,ColumnName VARCHAR(200)
                ,ErrorMessage VARCHAR(1000)
                )             
 
            IF @SomethingToCheck = 'Y'
                BEGIN
                    --#############################################################################
                    -- find out if there are future services scheduled
                    --############################################################################# 
                    SELECT  @FutureScheduledServices = SUM(1)
                    FROM    Services S
                    WHERE   Status = 70
                            AND ISNULL(S.RecordDeleted, 'N') = 'N'
                            AND S.ClientId = @ClientId
                            AND S.ProgramId = @ProgramId
                            AND CAST(S.DateOfService AS DATE) > @DischargeDate

                    --#############################################################################
                    -- if there are future services for this program, generate validation error
                    --############################################################################# 
                    IF ISNULL(@FutureScheduledServices, 0) > 0
                        BEGIN
                            INSERT  INTO @validationReturnTable
                                    (TableName
                                    ,ColumnName
                                    ,ErrorMessage
                                    )
                            VALUES  ('ClientPrograms'
                                    ,'ClientProgramId'
                                    ,'Client Cannot be discharged from this program due to '
                                     + CAST(@FutureScheduledServices AS VARCHAR)
                                     + ' future services scheduled using this program.'
                                    )    
                        END
                END             
  
            SELECT  TableName
            ,       ColumnName
            ,       ErrorMessage
            FROM    @validationReturnTable  
            IF EXISTS ( SELECT  *
                        FROM    @validationReturnTable )
                BEGIN             
                    SELECT  1 AS ValidationStatus            
                END            
            ELSE
                BEGIN            
                    SELECT  0 AS ValidationStatus            
                END    
 
        END TRY
        BEGIN CATCH
            IF @@Trancount > 0
                ROLLBACK TRAN
            DECLARE @ThisProcedureName VARCHAR(255) = ISNULL(OBJECT_NAME(@@PROCID),
                                                             'Testing')
            DECLARE @ErrorProc VARCHAR(4000) = CONVERT(VARCHAR(4000), ISNULL(ERROR_PROCEDURE(),
                                                              @ThisProcedureName))
            SET @ErrorMessage = @ThisProcedureName
                + ' Reports Error Thrown by: ' + @ErrorProc --+ CHAR(13)

            SET @ErrorMessage += ISNULL(CONVERT(VARCHAR(4000), ERROR_MESSAGE()),
                                        'Unknown') + CHAR(13)
                + @ThisProcedureName + ' Variable dump:' + CHAR(13)
                --+ '@SourceTableName:' + ISNULL(@SourceTableName, 'Null')
                --+ CHAR(13) + '@LocalKeyValue:'
                --+ ISNULL(CAST(@LocalKeyValue AS VARCHAR(25)), 'Null')
                --+ CHAR(13)

            RAISERROR(@ErrorMessage, -- Message.   
             16, -- Severity.   
             1 -- State.   
             );
        END CATCH
    END

GO


RETURN

SELECT  *
FROM    Screens
WHERE   ScreenName LIKE 'program as%'
 --302



UPDATE  Screens
SET     ValidationStoredProcedureUpdate = 'csp_ValidationClientProgramAssignmentDetails'
WHERE   ScreenId = 302


SELECT  *
FROM    ClientPrograms
WHERE   ClientProgramId = 50951
EXEC csp_ValidationClientProgramAssignmentDetails @CurrentUserId = 13307,
    @ScreenKeyId = 50951


SELECT  *
FROM    Screens
WHERE   ScreenId = 302


    
SELECT  gc.GlobalCodeId
,       gc.CodeName
,       gc.Active
,       gc.Category
,       *
FROM    GlobalCodes gc
        JOIN ( SELECT   Category
               FROM     GlobalCodes
               WHERE    GlobalCodeId = 5761
             ) a ON a.Category = gc.Category
    
    
SELECT TOP 10
        *
FROM    ClientPrograms
ORDER BY 1 DESC
    

    
SELECT  gc.GlobalCodeId
,       gc.CodeName
,       gc.Active
,       gc.Category
,       *
FROM    GlobalCodes gc
        JOIN ( SELECT   Category
               FROM     GlobalCodes
               WHERE    GlobalCodeId = 4
             ) a ON a.Category = gc.Category
    
    
    



SELECT  gc.GlobalCodeId
,       gc.CodeName
,       gc.Active
,       gc.Category
,       *
FROM    GlobalCodes gc
        JOIN ( SELECT   Category
               FROM     GlobalCodes
               WHERE    GlobalCodeId = 72
             ) a ON a.Category = gc.Category


