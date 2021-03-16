/******************************************************************************** 
-- 
-- Copyright:   Streamline Healthcare Solutions 
-- Author:     Jyothi 
-- CreatedDate: 07/04/2019 
-- Purpose:     Updating the systemconfiguration value 
-- Why:         AS per task 	KCMHSAS Improvements-# 7

*********************************************************************************/ 
IF EXISTS (SELECT value 
           FROM   systemconfigurationkeys 
           WHERE  [key] = 'ASSESSMENTDOCUMENTCODEID' 
                  AND Isnull(recorddeleted, 'N') = 'N') 
  BEGIN 
      DECLARE @MHAssessmentDocumentcodeId VARCHAR(20) 
      DECLARE @CurrentDocumentCodeID VARCHAR(100) 
      DECLARE @ListOfAssessmentDocumentCodeID VARCHAR(100) 

      SET @MHAssessmentDocumentcodeId = 
      (SELECT documentcodeid 
       FROM   documentcodes 
       WHERE  code = '69E559DD-1A4D-46D3-B91C-E89DA48E0038' 
              AND Isnull(recorddeleted, 'N') = 'N' 
              AND active = 'Y') 
      SET @CurrentDocumentCodeID =(SELECT value 
                                   FROM   systemconfigurationkeys 
                                   WHERE  [key] = 'ASSESSMENTDOCUMENTCODEID' 
                                          AND Isnull(recorddeleted, 'N') = 'N') 

      IF NOT EXISTS(SELECT value 
                    FROM   systemconfigurationkeys 
                    WHERE  [key] = 'ASSESSMENTDOCUMENTCODEID' 
                           AND value LIKE '%' + @MHAssessmentDocumentcodeId + 
                                          '%') 
        BEGIN 
            SET @ListOfAssessmentDocumentCodeID = 
            ( @CurrentDocumentCodeID ) + ',' +  ( @MHAssessmentDocumentcodeId ) 

            IF NOT EXISTS(SELECT value 
                          FROM   systemconfigurationkeys 
                          WHERE  [key] = 'ASSESSMENTDOCUMENTCODEID' 
                                 AND value LIKE '%' + 
                                     @ListOfAssessmentDocumentCodeID 
                                                + 
                                                '%') 
              BEGIN 
                  UPDATE systemconfigurationkeys 
                  SET    value = @ListOfAssessmentDocumentCodeID,Description='Updated DocumentCodeid along with existing Documentcodes as part KCMHSAS Improvements-# 7' 
                  WHERE  [key] = 'ASSESSMENTDOCUMENTCODEID' 
                         AND Isnull(recorddeleted, 'N') = 'N' 
              END 
        END 
  END 