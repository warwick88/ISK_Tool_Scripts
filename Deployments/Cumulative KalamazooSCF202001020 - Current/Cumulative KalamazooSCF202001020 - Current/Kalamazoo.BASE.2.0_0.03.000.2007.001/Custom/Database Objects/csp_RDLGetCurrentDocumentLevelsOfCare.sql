  
  
-- ============================================================================================================================     
-- Author      : Ankita Sinha   
-- Date        : 26-MAR-2019  
-- Purpose     : To fetch data for "LOC" as per new assessment tool setup  
-- Updates:  
-- Date   Author    Purpose   
-- 21-June-2020  Ankita  Created.(Task #8 in KCMHS) */  
-- ============================================================================================================================  
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLGetCurrentDocumentLevelsOfCare]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_RDLGetCurrentDocumentLevelsOfCare] 
GO

CREATE PROCEDURE [dbo].[csp_RDLGetCurrentDocumentLevelsOfCare]--3,2013787
  @DocumentVersionId INT  
AS  
BEGIN  
 BEGIN TRY  
 DECLARE @CurrentDate DATETIME = GETDATE()  
 DECLARE @ClientId INT
 select @ClientId=ClientId from Documents where CurrentDocumentVersionid=@DocumentVersionId
  
 IF NOT EXISTS(SELECT 1 FROM CustomLOCCalculatedByAssessmentTools WHERE DocumentVersionId = @DocumentVersionId AND ISNULL(RecordDeleted, 'N') = 'N')  
 BEGIN  
  IF EXISTS(SELECT 1 FROM CustomManualOverrideLOCs WHERE DocumentVersionId = @DocumentVersionId AND ISNULL(RecordDeleted, 'N') = 'N')  
  BEGIN  
   SELECT CASE   
    WHEN ISNULL(CLOCC.LOCCategoryName, '') = ''  
     THEN ''  
    ELSE CLOCC.LOCCategoryName + ': '  
    END + CASE   
    WHEN ISNULL(CLOC.LOCName, '') = ''  
     THEN CAST(CLOC.LOCId AS VARCHAR(100)) + ', '  
    ELSE CLOC.LOCName + ', '  
    END + ' Manually Determined' + ', ' + CONVERT(VARCHAR(10), MO.CreatedDate, 101) AS LOCRow  
    ,CLOC.LOCId  
    ,(Isnull(CLOCC.LOCCategoryName,'') + '/' + ISNull(CLOC.LOCName,'')) AS CategoryNameLOCName  
   FROM CustomManualOverrideLOCs MO  
   JOIN CustomLOCs CLOC ON MO.LOCId = CLOC.LOCId AND ISNULL(CLOC.RecordDeleted, 'N') = 'N'  
   JOIN CustomLOCCategories CLOCC ON CLOC.LOCCategoryId = CLOCC.LOCCategoryId AND ISNULL(CLOCC.RecordDeleted, 'N') = 'N'     
   WHERE MO.DocumentVersionId = @DocumentVersionId  
    AND ISNULL(MO.RecordDeleted, 'N') = 'N'  
  END  
  ELSE IF NOT EXISTS (  
    SELECT TOP 1 CCL.ClientLOCId  
    FROM CustomClientLOCs CCL  
    JOIN CustomClientLOCTrackings CCLT ON CCL.ClientLOCId = CCLT.ClientLOCId  
    WHERE ISNULL(CCL.RecordDeleted, 'N') = 'N'  
     AND ISNULL(CCLT.RecordDeleted, 'N') = 'N'  
     AND CCL.ClientId = @ClientId  
    )  
  BEGIN        
   ;WITH ROWCTESource (RowNum,ClientLOCId,LOCCategoryId,LOCId,CreatedDate,LOCPopulation,LOCCategoryName,LOCName)  
   AS (  
    SELECT ROW_NUMBER() OVER (PARTITION BY CLC.LOCCategoryId ORDER BY CCL.ClientLOCId DESC,ISNULL(CCL.LOCEndDate,@CurrentDate) DESC) AS RowNum  
     ,CCL.ClientLOCId  
     ,CLC.LOCCategoryId  
     ,CCL.LOCId  
     ,CCL.CreatedDate  
     ,CLC.LOCPopulation  
     ,CLC.LOCCategoryName  
     ,CL.LOCName  
    FROM CustomClientLOCs CCL  
    JOIN CustomLOCs CL ON CCL.LOCId = CL.LOCId  
    JOIN CustomLOCCategories CLC ON CL.LOCCategoryId = CLC.LOCCategoryId  
    WHERE ISNULL(CCL.RecordDeleted, 'N') = 'N'  
     AND ISNULL(CL.RecordDeleted, 'N') = 'N'  
     AND ISNULL(CLC.RecordDeleted, 'N') = 'N'  
     AND CCL.LOCEndDate IS NULL  
     AND CCL.ClientId = @ClientId  
    )  
    SELECT CASE   
      WHEN ISNULL(RC.LOCCategoryName, '') = ''  
       THEN ''  
      ELSE RC.LOCCategoryName + ': '  
      END + CASE   
      WHEN ISNULL(RC.LOCName, '') = ''  
       THEN CAST(RC.LOCId AS VARCHAR(100)) + ', '  
      ELSE RC.LOCName + ', '  
      END + 'Created On ' + CONVERT(VARCHAR(10), RC.CreatedDate, 101) AS LOCRow  
      ,RC.LOCId  
      ,(Isnull(RC.LOCCategoryName,'') + '/' + ISNull(RC.LOCName,'')) AS CategoryNameLOCName  
    FROM ROWCTESource RC      
    WHERE RowNum = 1  
  END  
  ELSE IF EXISTS (  
    SELECT TOP 1 CCL.ClientLOCId  
    FROM CustomClientLOCs CCL  
    JOIN CustomClientLOCTrackings CCLT ON CCL.ClientLOCId = CCLT.ClientLOCId  
    WHERE ISNULL(CCL.RecordDeleted, 'N') = 'N'  
     AND ISNULL(CCLT.RecordDeleted, 'N') = 'N'  
     AND CCL.ClientId = @ClientId  
    )  
  BEGIN        
   DECLARE @LOCCalculatedDocumentVersionId INT  
   DECLARE @LOCSourceDocumentVersionId INT  
   SELECT TOP 1 @LOCCalculatedDocumentVersionId = CCLT.LOCCalculatedDocumentVersionId,@LOCSourceDocumentVersionId = CCLT.LOCSourceDocumentVersionId  
   FROM CustomClientLOCs CCL  
   JOIN CustomClientLOCTrackings CCLT ON CCL.ClientLOCId = CCLT.ClientLOCId  
   WHERE ISNULL(CCL.RecordDeleted, 'N') = 'N'  
    AND ISNULL(CCLT.RecordDeleted, 'N') = 'N'  
    AND CCL.ClientId = @ClientId  
   ORDER BY CCLT.ClientLOCTrackingId DESC  
     
   IF ISNULL(@LOCSourceDocumentVersionId,0) > 0  
   BEGIN     
    SELECT CASE   
     WHEN ISNULL(CLC.LOCCategoryName, '') = ''  
      THEN ''  
     ELSE CLC.LOCCategoryName + ': '  
     END + CASE   
     WHEN ISNULL(CL.LOCName, '') = ''  
      THEN CAST(CL.LOCId AS VARCHAR(100)) + ', '  
     ELSE CL.LOCName + ', '  
     END + dbo.csf_GetLOCDocumentCodeName(CCLT.LOCSourceDocumentVersionId, CONVERT(VARCHAR(10), CCL.CreatedDate, 101)) AS LOCRow  
     ,CL.LOCId  
     ,(Isnull(CLC.LOCCategoryName,'') + '/' + ISNull(CL.LOCName,'')) AS CategoryNameLOCName  
    FROM CustomClientLOCs CCL  
    JOIN CustomClientLOCTrackings CCLT ON CCL.ClientLOCId = CCLT.ClientLOCId  
    JOIN CustomLOCs CL ON CCL.LOCId = CL.LOCId  
    JOIN CustomLOCCategories CLC ON CL.LOCCategoryId = CLC.LOCCategoryId      
    WHERE ISNULL(CCL.RecordDeleted, 'N') = 'N'  
     AND ISNULL(CL.RecordDeleted, 'N') = 'N'  
     AND ISNULL(CLC.RecordDeleted, 'N') = 'N'  
     AND ISNULL(CCLT.RecordDeleted, 'N') = 'N'  
     AND CCL.ClientId = @ClientId  
     AND CCLT.LOCCalculatedDocumentVersionId = @LOCCalculatedDocumentVersionId  
     AND ISNULL(CCLT.LOCSourceDocumentVersionId, 0) > 0  
    ORDER BY CCLT.ClientLOCTrackingId ASC  
   END  
   ELSE   
   BEGIN  
    SELECT CASE   
     WHEN ISNULL(CLC.LOCCategoryName, '') = ''  
      THEN ''  
     ELSE CLC.LOCCategoryName + ': '  
     END + CASE   
     WHEN ISNULL(CL.LOCName, '') = ''  
      THEN CAST(CL.LOCId AS VARCHAR(100)) + ', '  
     ELSE CL.LOCName + ', '  
     END + dbo.csf_GetLOCDocumentCodeName(CCLT.LOCSourceDocumentVersionId, CONVERT(VARCHAR(10), CCL.CreatedDate, 101)) AS LOCRow  
     ,CL.LOCId  
     ,(Isnull(CLC.LOCCategoryName,'') + '/' + ISNull(CL.LOCName,'')) AS CategoryNameLOCName  
    FROM CustomClientLOCs CCL  
    JOIN CustomClientLOCTrackings CCLT ON CCL.ClientLOCId = CCLT.ClientLOCId  
    JOIN CustomLOCs CL ON CCL.LOCId = CL.LOCId  
    JOIN CustomLOCCategories CLC ON CL.LOCCategoryId = CLC.LOCCategoryId      
    WHERE ISNULL(CCL.RecordDeleted, 'N') = 'N'  
     AND ISNULL(CL.RecordDeleted, 'N') = 'N'  
     AND ISNULL(CLC.RecordDeleted, 'N') = 'N'  
     AND ISNULL(CCLT.RecordDeleted, 'N') = 'N'  
     AND CCL.ClientId = @ClientId  
     AND CCLT.LOCCalculatedDocumentVersionId = @LOCCalculatedDocumentVersionId  
     AND ISNULL(CCLT.LOCSourceDocumentVersionId, 0) <= 0  
    ORDER BY CCLT.ClientLOCTrackingId ASC  
   END  
  END  
 END  
 ELSE     
 BEGIN  
  SELECT CASE   
    WHEN ISNULL(CLOCC.LOCCategoryName, '') = ''  
     THEN ''  
    ELSE CLOCC.LOCCategoryName + ': '  
    END + CASE   
    WHEN ISNULL(CLOC.LOCName, '') = ''  
     THEN CAST(CLOC.LOCId AS VARCHAR(100)) + ', '  
    ELSE CLOC.LOCName + ', '  
    END + CASE   
    WHEN ISNULL(DC.DocumentName, '') = ''  
     THEN ''  
    ELSE dbo.csf_GetLOCDocumentCodeName(LOCS.LOCSourceDocumentVersionId, CONVERT(VARCHAR(10), LOCS.CreatedDate, 101))  
    END AS LOCRow  
    ,CLOC.LOCId  
    ,(Isnull(CLOCC.LOCCategoryName,'') + '/' + ISNull(CLOC.LOCName,'')) AS CategoryNameLOCName  
  FROM CustomLOCCalculatedByAssessmentTools LOCS  
  JOIN CustomLOCCategoryDeterminations LOCD ON LOCS.LOCCategoriesDeterminationId = LOCD.LOCCategoriesDeterminationId AND ISNULL(LOCD.RecordDeleted, 'N') = 'N'  
  JOIN CustomLOCs CLOC ON LOCS.LOCId = CLOC.LOCId AND ISNULL(CLOC.RecordDeleted, 'N') = 'N'  
  JOIN CustomLOCCategories CLOCC ON LOCD.LOCCategoryId = CLOCC.LOCCategoryId AND ISNULL(CLOCC.RecordDeleted, 'N') = 'N'  
  LEFT JOIN DocumentCodes DC ON LOCS.DocumentCodeId = DC.DocumentCodeId AND ISNULL(DC.RecordDeleted, 'N') = 'N'    
  WHERE LOCS.DocumentVersionId = @DocumentVersionId AND ISNULL(LOCS.RecordDeleted, 'N') = 'N'  
 END  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLGetCurrentDocumentLevelsOfCare') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.      
    16  
    ,-- Severity.      
    1 -- State.      
    );  
 END CATCH  
END  
  