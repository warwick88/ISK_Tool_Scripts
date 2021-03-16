

/****** Object:  StoredProcedure [dbo].[csp_InitCustomDiagnosisStandardInitializationNew]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDiagnosisStandardInitializationNew]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomDiagnosisStandardInitializationNew]
GO

/****** Object:  StoredProcedure [dbo].[csp_InitCustomDiagnosisStandardInitializationNew]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[csp_InitCustomDiagnosisStandardInitializationNew]    
    (    
      @ClientId INT ,    
      @StaffID INT ,    
      @CustomParameters XML                                                                        
    )    
AS /*********************************************************************/    
   /*
   CREATED BY  : Jyothi Bellapu
   CREATED DATE : 02/06/2020
   Task Details : KCMHSAS - Improvements -#7
   */                                                                                          
  /*********************************************************************/                                                      
                                                     
    BEGIN                                                                
                            
        BEGIN TRY                                                     
                  
                
            DECLARE @GAF INT = 0    
                 
            DECLARE @varVersion10 INT    
            DECLARE @varVersion10Date DATETIME    
      
            DECLARE @varVersion9 INT    
            DECLARE @varVersion9Date DATETIME    
      
            --SELECT TOP 1    
            --        @varVersion10 = CurrentDocumentVersionId ,    
            --        @varVersion10Date = EffectiveDate    
            --FROM    DocumentDiagnosisCodes DI ,    
           --        Documents Doc    
            --WHERE   DI.DocumentVersionId = Doc.CurrentDocumentVersionId    
            --        AND Doc.ClientId = @ClientId    
            --        AND Doc.Status = 22    
            --        AND ISNULL(DI.RecordDeleted, 'N') = 'N'    
            --        AND ISNULL(Doc.RecordDeleted, 'N') = 'N'    
            --        AND Doc.EffectiveDate <= CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101))    
            --ORDER BY Doc.EffectiveDate DESC ,    
            --        Doc.ModifiedDate DESC      
            SELECT TOP 1    
                    @varVersion10 = CurrentDocumentVersionId ,    
                    @varVersion10Date = EffectiveDate    
            FROM   Documents Doc     
            INNER JOIN DocumentCodes AS Dc ON Dc.DocumentCodeId = Doc.DocumentCodeId     
            LEFT JOIN dbo.DocumentDiagnosis DI ON Doc.CurrentDocumentVersionId = DI.DocumentVersionId    
            WHERE       
                    Doc.ClientId = @ClientId    
                    AND Doc.Status = 22    
                    AND ISNULL(DI.RecordDeleted, 'N') = 'N'    
                    AND ISNULL(Doc.RecordDeleted, 'N') = 'N'    
                    AND Dc.DiagnosisDocument='Y'    
                    AND Doc.EffectiveDate <= CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101))    
            ORDER BY Doc.EffectiveDate DESC ,    
                    Doc.ModifiedDate DESC    
                    
      
            --SELECT TOP 1    
            --        @varVersion9 = CurrentDocumentVersionId ,    
            --        @varVersion9Date = EffectiveDate    
            --FROM    dbo.DiagnosesIAndII DI ,    
            --        Documents Doc    
            --WHERE   DI.DocumentVersionId = Doc.CurrentDocumentVersionId    
            --        AND Doc.ClientId = @ClientId    
            --        AND Doc.Status = 22    
            --        AND ISNULL(DI.RecordDeleted, 'N') = 'N'    
            --        AND ISNULL(Doc.RecordDeleted, 'N') = 'N'    
            --        AND Doc.EffectiveDate <= CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101))    
            --ORDER BY Doc.EffectiveDate DESC ,    
            --        Doc.ModifiedDate DESC     
                
            SELECT TOP 1    
                    @varVersion9 = CurrentDocumentVersionId ,    
                    @varVersion9Date = EffectiveDate    
            FROM   Documents Doc     
            INNER JOIN DocumentCodes AS Dc ON Dc.DocumentCodeId = Doc.DocumentCodeId     
            LEFT JOIN dbo.DiagnosesIAndII DI ON Doc.CurrentDocumentVersionId = DI.DocumentVersionId    
            WHERE       
                    Doc.ClientId = @ClientId    
                    AND Doc.Status = 22    
                    AND ISNULL(DI.RecordDeleted, 'N') = 'N'    
                    AND ISNULL(Doc.RecordDeleted, 'N') = 'N'    
                    AND Dc.DiagnosisDocument='Y'    
                    AND Doc.EffectiveDate <= CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101))    
            ORDER BY Doc.EffectiveDate DESC ,    
                    Doc.ModifiedDate DESC      
    
    
            IF ( CAST(@varVersion9Date AS DATE) < CAST(@varVersion10Date AS DATE) )    
                BEGIN    
       
                    SELECT  @varVersion9 = NULL     
       
                END    
       
       
            IF ( CAST(@varVersion9Date AS DATE) > CAST(@varVersion10Date AS DATE) )    
                BEGIN    
       
                    SELECT  @varVersion10 = NULL     
       
                END    
       
    
            DECLARE @usercode VARCHAR(100);    
            SELECT  @usercode = usercode    
            FROM    Staff    
            WHERE   StaffId = @StaffID                                                                                                                     
     
     
       
            SET @GAF = ( SELECT AxisV    
                         FROM   DiagnosesV    
                         WHERE  DocumentVersionId = @varVersion9    
                       )    
    
                   SELECT  Placeholder.TableName ,    
                    DDC.CreatedBy ,    
                    DDC.CreatedDate ,    
                    DDC.ModifiedBy ,    
                    DDC.ModifiedDate ,    
                    DDC.RecordDeleted ,    
                    DDC.DeletedDate ,    
                    DDC.DeletedBy ,    
                    ISNULL(DDC.DocumentVersionId, -1) AS DocumentVersionId ,    
                    DDC.ICD10CodeId ,    
                    DDC.ICD10Code ,    
                    DDC.ICD9Code ,    
                    DDC.DiagnosisType ,    
                    DDC.RuleOut ,    
                    DDC.Billable ,    
                    DDC.Severity ,    
                    DDC.DiagnosisOrder ,    
                    DDC.Specifier ,    
                    DDC.Remission ,    
                    DDC.[Source] ,    
                    ICD10.ICDDescription AS DSMDescription ,    
                    CASE DDC.RuleOut    
                      WHEN 'Y' THEN 'R/O'    
                      ELSE ''    
                    END AS RuleOutText ,    
                    dbo.csf_GetGlobalCodeNameById(DDC.DiagnosisType) AS 'DiagnosisTypeText' ,    
                    dbo.csf_GetGlobalCodeNameById(DDC.Severity) AS 'SeverityText' ,    
                    DDC.Comments ,    
                    DDC.SNOMEDCODE ,    
                    SNC.SNOMEDCTDescription    
            FROM    ( SELECT    'DocumentDiagnosisCodes' AS TableName    
                    ) AS Placeholder    
                    LEFT JOIN DocumentDiagnosisCodes DDC ON ( DDC.DocumentVersionId = -1 --@varVersion10    
                                                              AND ISNULL(DDC.RecordDeleted, 'N') <> 'Y'    
                                                            )    
                    INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = DDC.ICD10CodeId    
                    LEFT JOIN SNOMEDCTCodes SNC ON SNC.SNOMEDCTCode = DDC.SNOMEDCODE     
                 
       
                       
    
                       
    
            SELECT  'DocumentDiagnosisCodes' AS TableName ,    
                    @usercode AS CreatedBy ,--DIandII.CreatedBy ,    
                    GETDATE() AS CreatedDate , --DIandII.CreatedDate ,    
                    @usercode AS ModifiedBy , --DIandII.ModifiedBy ,    
                    GETDATE() AS ModifiedDate , --DIandII.ModifiedDate ,    
                    DIandII.RecordDeleted ,    
                    DIandII.DeletedDate ,    
                    DIandII.DeletedBy ,    
                    ISNULL(DIandII.DocumentVersionId, -1) AS DocumentVersionId ,    
                    CASE WHEN ( SELECT  COUNT(SubMapping.ICD9Code) AS Rcount    
                                FROM    DiagnosisICD10ICD9Mapping AS SubMapping    
                                        INNER JOIN DiagnosisICD10Codes AS DSMVCodes ON SubMapping.ICD10CodeId = DSMVCodes.ICD10CodeId    
                                        INNER JOIN DiagnosesIAndII ON SubMapping.ICD9Code = DiagnosesIAndII.DSMCode    
                                WHERE   DSMVCodes.ICD10Code IS NOT NULL    
                                        AND SubMapping.ICD9Code = Mapping.ICD9Code    
                                        AND DiagnosesIAndII.DocumentVersionId = @varVersion9    
                                        AND ISNULL(DiagnosesIAndII.RecordDeleted, 'N') <> 'Y'    
                              ) > 1 THEN '<img src="../App_Themes/Includes/Images/Alert2.png" title="Diagnosis ' + Mapping.ICD9Code + ' has been converted to ' + DSMVCodes.ICD10Code + '"/>     ' + DSMVCodes.ICDDescription    
                         ELSE DSMVCodes.ICDDescription    
                    END AS DSMDescription ,    
                    DSMVCodes.ICD10Code ,    
                    Mapping.ICD9Code ,    
                    DSMVCodes.ICD10CodeId ,    
                    DIandII.DiagnosisType ,    
                    DIandII.RuleOut ,    
                    DIandII.Billable ,    
 DIandII.Severity    
      --,DIandII.DSMVersion    
                    ,    
                    ISNULL(DIandII.DiagnosisOrder, 4) AS DiagnosisOrder ,    
                    CONVERT(VARCHAR(MAX), DIandII.Specifier) AS Specifier ,    
                    DIandII.[Source] ,    
                    DIandII.Remission ,    
                    CASE DIandII.RuleOut    
                      WHEN 'Y' THEN 'R/O'    
           ELSE ''    
                    END AS RuleOutText ,    
                    dbo.csf_GetGlobalCodeNameById(DIandII.DiagnosisType) AS 'DiagnosisTypeText' ,    
                    dbo.csf_GetGlobalCodeNameById(DIandII.Severity) AS 'SeverityText' ,    
                    CASE WHEN ( SELECT  COUNT(SubMapping.ICD9Code) AS Rcount    
                                FROM    DiagnosisICD10ICD9Mapping AS SubMapping    
                                        INNER JOIN DiagnosisICD10Codes AS DSMVCodes ON SubMapping.ICD10CodeId = DSMVCodes.ICD10CodeId    
                                        INNER JOIN DiagnosesIAndII ON SubMapping.ICD9Code = DiagnosesIAndII.DSMCode    
                                WHERE   DSMVCodes.ICD10Code IS NOT NULL    
                                        AND SubMapping.ICD9Code = Mapping.ICD9Code    
                                        AND DiagnosesIAndII.DocumentVersionId = @varVersion9    
                                        AND ISNULL(DiagnosesIAndII.RecordDeleted, 'N') <> 'Y'    
                              ) > 1 THEN 'Y'    
                         ELSE 'N'    
                    END AS MultipleDiagnosis ,    
                    @varVersion9 AS ICD9DocumentVersionId,    
                    '' as SNOMEDCODE ,    
                    '' as SNOMEDCTDescription    
            FROM    ( SELECT    'DiagnosesIAndII' AS TableName    
                    ) AS Placeholder    
                    JOIN DiagnosesIAndII DIandII ON ( DIandII.DocumentVersionId = @varVersion9    
                                                      AND ISNULL(DIandII.RecordDeleted, 'N') <> 'Y'    
                                                    )    
                    LEFT OUTER JOIN DiagnosisICD10ICD9Mapping Mapping ON DIandII.DSMCode = Mapping.ICD9Code    
                    INNER JOIN DiagnosisICD10Codes DSMVCodes ON Mapping.ICD10CodeId = DSMVCodes.ICD10CodeId    
            WHERE   DSMVCodes.ICD10Code IS NOT NULL    
            UNION    
            SELECT  'DocumentDiagnosisCodes' AS TableName ,    
                    @usercode AS CreatedBy ,--DIandII.CreatedBy ,    
                    GETDATE() AS CreatedDate , --DIandII.CreatedDate ,    
                    @usercode AS ModifiedBy , --DIandII.ModifiedBy ,    
                    GETDATE() AS ModifiedDate , --DIandII.ModifiedDate ,    
                    DIandII.RecordDeleted ,    
                    DIandII.DeletedDate ,    
                    DIandII.DeletedBy ,    
                    ISNULL(DIandII.DocumentVersionId, -1) AS DocumentVersionId ,    
                    ICD10.ICDDescription AS DSMDescription ,    
                    DIandII.ICD10Code ,    
                    DIandII.ICD9Code ,    
                    DIandII.ICD10CodeId ,    
                    DIandII.DiagnosisType ,    
                    DIandII.RuleOut ,    
                    DIandII.Billable ,    
                    DIandII.Severity    
      --,DIandII.DSMVersion    
                    ,    
                    ISNULL(DIandII.DiagnosisOrder, 4) AS DiagnosisOrder ,    
                    CONVERT(VARCHAR(MAX), DIandII.Specifier) AS Specifier ,    
                    DIandII.[Source] ,    
                    DIandII.Remission ,    
                    CASE DIandII.RuleOut    
                      WHEN 'Y' THEN 'R/O'    
                      ELSE ''    
                    END AS RuleOutText ,    
                    dbo.csf_GetGlobalCodeNameById(DIandII.DiagnosisType) AS 'DiagnosisTypeText' ,    
                    dbo.csf_GetGlobalCodeNameById(DIandII.Severity) AS 'SeverityText' ,    
'N' MultipleDiagnosis ,    
                    @varVersion9 AS ICD9DocumentVersionId,    
                    DIandII.SNOMEDCODE ,    
                    SNC.SNOMEDCTDescription    
            FROM    ( SELECT    'DiagnosesIAndII' AS TableName    
                    ) AS Placeholder    
                    JOIN dbo.DocumentDiagnosisCodes DIandII ON ( DIandII.DocumentVersionId = @varVersion10    
                                                                 AND ISNULL(DIandII.RecordDeleted, 'N') = 'N'    
                                     )    
                    LEFT JOIN dbo.DiagnosisICDCodes ICD9 ON ICd9.ICDCode = DIandII.ICD9Code    
                    Left JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = DIandII.ICD10CodeId    
                    LEFT JOIN SNOMEDCTCodes SNC ON SNC.SNOMEDCTCode = DIandII.SNOMEDCODE     
            WHERE   DIandII.ICD10CodeId IS NOT NULL                                                                    
                        
                  
                    
    
            SELECT  Placeholder.TableName ,    
                    @usercode AS [CreatedBy] ,    
                    GETDATE() AS [CreatedDate] ,    
                    @usercode AS [ModifiedBy] ,    
                    GETDATE() AS [ModifiedDate] ,    
                    ISNULL(DD.DocumentVersionId, -1) AS DocumentVersionId ,    
                    DD.ScreeeningTool ,    
                    DD.OtherMedicalCondition ,    
                    DD.FactorComments ,    
                    CASE @GAF    
                      WHEN 0 THEN DD.GAFScore    
                      ELSE @GAF    
                    END AS GAFScore ,    
                    DD.WHODASScore ,    
                    DD.CAFASScore    
            FROM    ( SELECT    'DocumentDiagnosis' AS TableName    
                    ) AS Placeholder    
                    LEFT JOIN DocumentDiagnosis DD ON ( DD.DocumentVersionId = @varVersion10    
                                                        AND ISNULL(DD.RecordDeleted, 'N') <> 'Y'    
                                                      )    
          
        END TRY                                                                      
                                                                                                               
        BEGIN CATCH                          
            DECLARE @Error VARCHAR(8000)                                                                       
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_InitCustomDiagnosisStandardInitializationNew') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())                                                  
            RAISERROR                                                                                                     
 (                                           
  @Error, -- Message text.                                                                                                    
  16, -- Severity.                                                                                                    
  1 -- State.                                                                               
 );                                                                                                  
        END CATCH                                                 
    END 