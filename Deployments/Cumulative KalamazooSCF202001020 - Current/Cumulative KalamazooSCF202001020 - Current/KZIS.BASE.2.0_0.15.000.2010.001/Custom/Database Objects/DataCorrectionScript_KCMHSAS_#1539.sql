/*
Project Name    : KCMHSAS - Support
Task#           : 1539
Creation Date   : 16 Oct 2020
What/Why        : Inserting an Appointment into Appointments table	*/

BEGIN
    DECLARE @ServiceId INT;

    SET @ServiceId = 874418;

    IF EXISTS (SELECT ServiceId
               FROM   Services
               WHERE  ServiceId = @ServiceId
                      AND Status IN ( 70, 71 ))
       AND NOT EXISTS (SELECT AppointmentId
                       FROM   Appointments
                       WHERE  ServiceId = @ServiceId
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
                 'KCMHSASSupport#1539',
                 GETDATE(),
                 'KCMHSASSupport#1539',
                 GETDATE()
          FROM   Services S
                 INNER JOIN Clients C
                         ON C.ClientId = S.ClientId
                 LEFT JOIN ProcedureCodes PC
                        ON PC.ProcedureCodeId = S.ProcedureCodeId
          WHERE  S.ServiceId = @ServiceId
      END
END 
