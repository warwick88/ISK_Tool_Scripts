/*
Task : Kalamazoo Improvement -7*/
IF NOT EXISTS (SELECT [KEY] FROM SystemConfigurationKeys WHERE [KEY] = 'ASSESSMENTDOCUMENTCODEID' AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
 DECLARE @MHAssessmentDocumentcodeId VARCHAR(20) 
  SET @MHAssessmentDocumentcodeId = 
        (SELECT documentcodeid 
         FROM   documentcodes 
          WHERE  code = '69E559DD-1A4D-46D3-B91C-E89DA48E0038' 
              AND Isnull(recorddeleted, 'N') = 'N' 
              AND active = 'Y') 
  INSERT INTO SystemConfigurationKeys ([Key], Value)
    VALUES ('ASSESSMENTDOCUMENTCODEID', @MHAssessmentDocumentcodeId)
END
