/* 10-26-2018	IMohammed	Copied from Comprehensive */
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_SCServiceNotePostUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_SCServiceNotePostUpdate]
GO
/****** Object:  StoredProcedure [dbo].[scsp_SCServiceNotePostUpdate]    Script Date: 07/20/2015 22:36:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
 CREATE PROC [dbo].[scsp_SCServiceNotePostUpdate]  
    (  
      @ScreenKeyId INT ,  
      @StaffId INT ,  
      @CurrentUser VARCHAR(30) ,
      @CustomParameters XML                                                       
    )  
AS
--Created By Neha on Aug-03-2018
--Comprehensive-Customizations #1122
/***********************************************************************************************        
**  Change History        
************************************************************************************************        
**  Date:        Author:      Description:        
**  -----------  ------------ ------------------------------------------------------------------        
**  10/16/2020	 Veera		  Make an entry into the Appointments table if it is missing (KCMHSAS - Support #1539)
************************************************************************************************/
BEGIN
    DECLARE @Error VARCHAR(MAX)
    BEGIN TRY
	   -- Written by Tom and Ihab on 10/26/2018  
	   -- only do this if the procedure code related to the service is in the recode (XCREATESUMMARYOFCAREPROCCODE) recode
	   IF object_id('dbo.csp_CreateSummaryOfCare', 'P') is not null  
	   BEGIN
			IF EXISTS (
				SELECT *
				FROM Services AS sv
				JOIN Documents AS d ON d.ServiceId = sv.ServiceId
				WHERE d.DocumentId = @ScreenKeyId
				AND isnull(sv.RecordDeleted, 'N') = 'N'
				AND isnull(d.RecordDeleted, 'N') = 'N'
				AND EXISTS (
					SELECT *
					FROM dbo.ssf_RecodeValuesAsOfDate('XCREATESUMMARYOFCAREPROCCODE', sv.DateOfService) AS rc
					WHERE rc.IntegerCodeId = sv.ProcedureCodeId
				)
				AND NOT EXISTS (SElect * 
					From Documents d2
					Where d2.ClientId = sv.ClientId AND
						DATEDIFF(day, d2.EffectiveDate, sv.DateOfService) = 0 AND
						d2.DocumentCodeId = 1611 AND
						ISNULL(d2.RecordDeleted, 'N') = 'N' AND
						d2.Status = 22
				)
			)
			BEGIN
				EXEC csp_CreateSummaryOfCare @ScreenKeyId,@StaffId,@CurrentUser,@CustomParameters
			END
	   END 

    IF EXISTS (SELECT ServiceId
               FROM   Services
               WHERE  ServiceId = @ScreenKeyId
                      AND Status IN ( 70, 71 ))
       AND NOT EXISTS (SELECT AppointmentId
                   FROM   Appointments
                   WHERE  ServiceId = @ScreenKeyId
                          AND ISNULL(RecordDeleted, 'N') = 'N')
      BEGIN
          INSERT INTO Appointments
                      (StaffId,
                       Subject,
                       StartTime,
                       EndTime,
                       AppointmentType,
                       ShowTimeAs,
                       LocationId,
                       ServiceId,
                       CreatedBy,
                       CreatedDate,
                       ModifiedBy,
                       ModifiedDate)
          SELECT S.ClinicianId,
                 'Client: ' + ( CASE
                                  WHEN ISNULL(C.ClientType, 'I') = 'I' THEN RTRIM(ISNULL(C.LastName, '')) + ', '
                                                                            + RTRIM(ISNULL(C.FirstName, ''))
                                  ELSE RTRIM(ISNULL(C.OrganizationName, ''))
                                END ) + ' (#' + CAST(C.ClientId AS VARCHAR) + ')' + ISNULL(' - ' + DisplayAs, '') AS Subject,
                 S.DateOfService,
                 S.EndDateOfService,
                 4761,
                 4342,
                 S.LocationId,
                 S.ServiceId,
                 'scsp_SCServiceNotePostUpdate',
                 GETDATE(),
                 'scsp_SCServiceNotePostUpdate',
                 GETDATE()
          FROM   Services S
                 INNER JOIN Clients C
                         ON C.ClientId = S.ClientId
                 LEFT JOIN ProcedureCodes PC
                        ON PC.ProcedureCodeId = S.ProcedureCodeId
          WHERE  S.ServiceId = @ScreenKeyId
      END

    END TRY
    BEGIN CATCH
	   SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'scsp_SCServiceNotePostUpdate') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

	   RAISERROR (@Error
	   ,16
	   ,-- Severity.                                                                      
	   1 -- State.                                                                      
	   );

	   INSERT INTO ErrorLog (
	   ErrorMessage
	   ,VerboseInfo
	   ,DataSetInfo
	   ,ErrorType
	   ,CreatedBy
	   ,CreatedDate
	   )
	   VALUES (
	   @Error
	   ,NULL
	   ,NULL
	   ,'scsp_SCServiceNotePostUpdate'
	   ,'SmartCare'
	   ,GETDATE()
	   )   
    END CATCH
END