 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetSummaryServicesProvided]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetSummaryServicesProvided]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_SCGetSummaryServicesProvided]
    @ClientId INT ,
    @ProgramIdCSV VARCHAR(MAX) ,
    @SummaryOfService VARCHAR(MAX) OUT
AS ------------------------------------------------------------------------
--Stored Procedure: csp_SCGetSummaryServicesProvided                                                                                         
--Creation Date:  04/Feb/2012
--Input Parameters: @ClientId,@ProgramIdCSV 
--Output Parameters:
--Return:    SummaryOfService
--Called By:Stored Procedure  csp_InitCustomDischarges  
--Calls:

--Data Modifications:
--Updates:
--Date              Author                  Purpose    
--4 Feb 2012	    Devi Dayal				get SummaryOfService 
------------------------------------------------------------------------
    BEGIN                        
        BEGIN TRY 

            DECLARE @ProgramStrings TABLE
                (
                  RowId INT NOT NULL ,
                  Value VARCHAR(200)
                )

            DECLARE @ClientPrograms TABLE
                (
                  ClientProgramId INT NOT NULL
                )

			-- Parse the comma separated String
            INSERT  INTO @ProgramStrings
                    SELECT  *
                    FROM    fn_CommaSeparatedStringToTable(@ProgramIdCSV, 'N')

            INSERT  INTO @ClientPrograms
                    ( ClientProgramId
                    )
                    SELECT  CONVERT(INT, Value)
                    FROM    @ProgramStrings ;
            WITH    ProcedureCodeNames
                      AS ( SELECT DISTINCT
                                    d.ProcedureCodeName
                           FROM     @ClientPrograms a
                                    JOIN ClientPrograms b ON ( a.ClientProgramId = b.ClientProgramId )
                                    JOIN Services c ON ( c.ClientId = @ClientId
                                                         AND c.ProgramId = b.ProgramId
                                                       )
                                    JOIN ProcedureCodes d ON ( c.ProcedureCodeId = d.ProcedureCodeId )
                           WHERE    c.Status IN ( 71, 75 ) -- Show and Complete
                                    AND ISNULL(c.RecordDeleted, 'N') = 'N'
                                    AND (b.RequestedDate <= c.DateOfService or b.EnrolledDate <= c.DateOfService)
                                    AND (DATEADD(dd, 1, b.DischargedDate) > c.DateOfService or b.DischargedDate is null)
                         )
                SELECT  @SummaryOfService = STUFF(( SELECT  ', '
                                                            + ProcedureCodeName
                                                    FROM    ProcedureCodeNames
                                                    ORDER BY ProcedureCodeName
                                                  FOR
                                                    XML PATH('')
                                                  ), 1, 1, '') 

            IF ISNULL(@SummaryOfService, '') = '' 
                SET @SummaryOfService = 'No Services have been provided'


        END TRY                                                                    
        BEGIN CATCH                        
            DECLARE @Error VARCHAR(8000)                                                                     
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
                + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                         'csp_SCGetSummaryServicesProvided') + '*****'
                + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
                + CONVERT(VARCHAR, ERROR_STATE())                                                
            RAISERROR                                                                                                   
 (                                                                     
  @Error, -- Message text.                                                                                                  
  16, -- Severity.                                                                                                  
  1 -- State.                                                                                                  
 ) ;                                                                                                
        END CATCH                                               
    END  



