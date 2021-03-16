IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CalculateCurrentDocumentLevelsOfCare]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CalculateCurrentDocumentLevelsOfCare]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- ============================================================================================================================   
-- Author      : Akwinass.D 
-- Date        : 26-MAR-2019
-- Purpose     : To fetch data for "LOC" as per new assessment tool setup
-- Updates:
-- Date			Author    Purpose 
-- 26-MAR-2019  Akwinass  Created.(Task #10 in Multi-Customer Project) */
-- 6/3/2020     Sunil D      Added logic to avoid Child category's for Adult client LOC calculation*/
-- ============================================================================================================================
CREATE PROCEDURE [dbo].[csp_CalculateCurrentDocumentLevelsOfCare] @ClientId INT, @DocumentEffectiveDate VARCHAR(20),@DocumentVersionId INT, @UserCode VARCHAR(50),@RecalculateLOC CHAR(1)
AS
BEGIN
	BEGIN TRY
		DECLARE @Scrore INT = 0
		------------------------SUNIL D---------------------------------------
		IF OBJECT_ID('tempdb..#TempClientLOCCategoryIds') IS NOT NULL
			DROP TABLE #TempClientLOCCategoryIds
		CREATE TABLE #TempClientLOCCategoryIds (ClientLOCCategoryIds INT)
		
		Insert into #TempClientLOCCategoryIds
		select LOCCategoryId from CustomLOCCategories where LOCCategoryName not like '%Child%' 

		 If ((select dbo.GetAge(DOB, Getdate()) from clients where ClientId=@ClientId) < 18) 
		 BEGIN
			 Delete from #TempClientLOCCategoryIds
				Insert into #TempClientLOCCategoryIds
				select LOCCategoryId from CustomLOCCategories where LOCCategoryName not like '%Adult%'
		 END
		 -------------------------------------------------------

		IF OBJECT_ID('tempdb..#LOCResultSource') IS NOT NULL
			DROP TABLE #LOCResultSource
		CREATE TABLE #LOCResultSource (LOCSourceId INT IDENTITY(1,1),LOCCategoryId INT,LOCCategoriesDeterminationId INT,DocumentCodeId INT,LOCCategoryTable VARCHAR(2000),Field VARCHAR(2000),LOCCategorySource VARCHAR(2000),LatestDocumentVersionId INT, Score DECIMAL(18,2), LOCId INT, SourceSQLText VARCHAR(MAX))
				
		IF OBJECT_ID('tempdb..#LOCSource') IS NOT NULL
			DROP TABLE #LOCSource
		CREATE TABLE #LOCSource (LOCSourceId INT IDENTITY(1,1),LOCCategoryId INT,LOCCategoriesDeterminationId INT,DocumentCodeId INT,LOCCategoryTable VARCHAR(2000),Field VARCHAR(2000),LOCCategorySource VARCHAR(2000),LatestDocumentVersionId INT, Score DECIMAL(18,2), LOCId VARCHAR(MAX), SourceSQLText VARCHAR(MAX))

		INSERT INTO #LOCSource (LOCCategoryId,LOCCategoriesDeterminationId,DocumentCodeId,LOCCategoryTable,Field,LOCCategorySource,LatestDocumentVersionId)
		SELECT DISTINCT CLCD.LOCCategoryId,CLCD.LOCCategoriesDeterminationId,CLCD.DocumentCodeId,CLCD.LOCCategoryTable,CLCD.Field,CLCD.LOCCategorySource,CASE WHEN ISNULL(CLCD.DocumentCodeId, 0) > 0 THEN [dbo].[csf_GetLOCLatestDocumentVersionId](@ClientId, @DocumentEffectiveDate, CLCD.DocumentCodeId, CLC.LOCCategoryId) ELSE NULL END
		FROM CustomLOCCategories CLC
		JOIN CustomLOCCategoryDeterminations CLCD ON CLC.LOCCategoryId = CLCD.LOCCategoryId
			AND ISNULL(CLC.RecordDeleted, 'N') = 'N'
			AND ISNULL(CLCD.RecordDeleted, 'N') = 'N'
			AND (
				ISNULL(CLCD.LOCCategorySource, '') <> ''
				OR (
					ISNULL(CLCD.DocumentCodeId, 0) > 0
					AND ISNULL(CLCD.LOCCategoryTable, '') <> ''
					AND ISNULL(CLCD.Field, '') <> ''
					)
				)
			AND (CAST(StartDate AS DATE) <= CAST(@DocumentEffectiveDate AS DATE) OR StartDate IS NULL) 
			AND (CAST(EndDate AS DATE) >= CAST(@DocumentEffectiveDate AS DATE)  OR EndDate IS NULL) 
			AND CLC.LOCCategoryId IN (Select * from #TempClientLOCCategoryIds)
				
		DECLARE @DynamicSQL VARCHAR(MAX) = ''
		;WITH ROWCTE (RowNum,LOCSourceId,LOCCategoryId,LOCCategoriesDeterminationId,DocumentCodeId,LOCCategoryTable,Field,LOCCategorySource,LatestDocumentVersionId,Score,LOCId,SourceSQLText)
		AS (
			SELECT ROW_NUMBER() OVER (PARTITION BY LOCCategoryId,DocumentCodeId,LOCCategoryTable,Field ORDER BY LOCSourceId) AS RowNum
				,LOCSourceId
				,LOCCategoryId
				,LOCCategoriesDeterminationId
				,DocumentCodeId
				,LOCCategoryTable
				,Field
				,LOCCategorySource
				,LatestDocumentVersionId
				,Score
				,LOCId
				,SourceSQLText
			FROM #LOCSource
			WHERE ISNULL(DocumentCodeId,'') > 0 AND ISNULL(LOCCategoryTable,'') <> '' AND ISNULL(Field,'') <> '' AND ISNULL(LatestDocumentVersionId, 0) > 0
			)
		SELECT @DynamicSQL = COALESCE(@DynamicSQL, ' ') + ' IF OBJECT_ID(''' + LOCCategoryTable + ''') IS NOT NULL BEGIN IF COL_LENGTH(''' + LOCCategoryTable + ''', ''' + Field + ''') IS NOT NULL BEGIN IF COL_LENGTH(''' + LOCCategoryTable + ''', ''DocumentVersionId'') IS NOT NULL BEGIN UPDATE #LOCSource SET Score = (SELECT TOP 1 ' + Field + ' FROM ' + LOCCategoryTable + ' WHERE ISNUMERIC('+ Field +') = 1 AND DocumentVersionId = ' + CAST(LatestDocumentVersionId AS VARCHAR(100)) + ' AND ISNULL(RecordDeleted, ''N'') = ''N'') WHERE LOCSourceId = ' + CAST(LOCSourceId AS VARCHAR(100)) + ' END END END'
		FROM ROWCTE
		WHERE RowNum = 1

		EXEC (@DynamicSQL)
				
		UPDATE #LOCSource
		SET LOCId = [dbo].[csf_GetAssessmentToolDeterminationLOCId](LOCCategoryId, LOCCategoriesDeterminationId, @DocumentEffectiveDate,Score)			
		WHERE ISNULL(DocumentCodeId,'') > 0 AND ISNULL(LOCCategoryTable,'') <> '' AND ISNULL(Field,'') <> ''

		DECLARE @LOCSourceId INT
		DECLARE @LOCId VARCHAR(MAX)

		DECLARE db_cursor CURSOR FOR 
		SELECT LOCSourceId,LOCId FROM #LOCSource ORDER BY LOCSourceId ASC

		OPEN db_cursor  
		FETCH NEXT FROM db_cursor INTO @LOCSourceId,@LOCId  

		WHILE @@FETCH_STATUS = 0  
		BEGIN  
			PRINT @LOCId
			IF ISNULL(@LOCId, '') <> ''
			BEGIN
				INSERT INTO #LOCResultSource (LOCCategoryId,LOCCategoriesDeterminationId,DocumentCodeId,LOCCategoryTable,Field,LOCCategorySource,LatestDocumentVersionId,Score,LOCId,SourceSQLText)
				SELECT LS.LOCCategoryId,LS.LOCCategoriesDeterminationId,LS.DocumentCodeId,LS.LOCCategoryTable,LS.Field,LS.LOCCategorySource,LS.LatestDocumentVersionId,LS.Score,CAST(LO.item AS INT),LS.SourceSQLText FROM #LOCSource LS CROSS JOIN (SELECT * FROM [dbo].[fnSplit](@LOCId,',') where ISNULL(item,'') <> '') LO WHERE LS.LOCSourceId = @LOCSourceId				
			END
			ELSE
			BEGIN
				INSERT INTO #LOCResultSource (LOCCategoryId,LOCCategoriesDeterminationId,DocumentCodeId,LOCCategoryTable,Field,LOCCategorySource,LatestDocumentVersionId,Score,LOCId,SourceSQLText)
				SELECT LOCCategoryId,LOCCategoriesDeterminationId,DocumentCodeId,LOCCategoryTable,Field,LOCCategorySource,LatestDocumentVersionId,Score,NULL,SourceSQLText FROM #LOCSource WHERE LOCSourceId = @LOCSourceId
			END

			FETCH NEXT FROM db_cursor INTO @LOCSourceId,@LOCId 
		END 

		CLOSE db_cursor  
		DEALLOCATE db_cursor 
		
		DECLARE @CalculatedLOC VARCHAR(MAX)		
		SELECT @CalculatedLOC = COALESCE(@CalculatedLOC + ',', '') + CAST(LOCCalculatedByAssessmentToolId AS VARCHAR(500))
		FROM   CustomLOCCalculatedByAssessmentTools
		WHERE DocumentVersionId = @DocumentVersionId AND ISNULL(RecordDeleted, 'N') = 'N'

		DECLARE @OverrideLOC VARCHAR(MAX)
		SELECT @OverrideLOC = COALESCE(@OverrideLOC + ',', '') + CAST(ManualOverrideLOCId AS VARCHAR(500))
		FROM   CustomManualOverrideLOCs
		WHERE DocumentVersionId = @DocumentVersionId AND ISNULL(RecordDeleted, 'N') = 'N'

		UPDATE CustomLOCCalculatedByAssessmentTools SET RecordDeleted = 'Y', DeletedBy = 'LOCAssessmentTool', DeletedDate = GETDATE() WHERE DocumentVersionId = @DocumentVersionId AND ISNULL(RecordDeleted, 'N') = 'N'
		UPDATE CustomManualOverrideLOCs SET RecordDeleted = 'Y', DeletedBy = 'LOCAssessmentTool', DeletedDate = GETDATE() WHERE DocumentVersionId = @DocumentVersionId AND ISNULL(RecordDeleted, 'N') = 'N'
		INSERT INTO CustomLOCCalculatedByAssessmentTools (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,DocumentVersionId,LOCId,LOCCategoriesDeterminationId,DocumentCodeId,TableName,FieldName,SourceName,DocumentEffectiveDate,LOCSourceDocumentVersionId)
		SELECT 'LOCAssessmentTool',GETDATE(),@UserCode,GETDATE(),@DocumentVersionId,LOCId,LOCCategoriesDeterminationId,DocumentCodeId,LOCCategoryTable,Field,LOCCategorySource,@DocumentEffectiveDate,LatestDocumentVersionId FROM #LOCResultSource WHERE ISNULL(LOCId,0) > 0

		UPDATE #LOCResultSource
		SET SourceSQLText = [dbo].[csf_GetAssessmentToolSourceParameters](LOCCategoryId,LOCCategoriesDeterminationId,@ClientId,@DocumentEffectiveDate,@DocumentVersionId,@UserCode,LOCCategorySource)
		WHERE ISNULL(LOCCategorySource,'') <> ''

		SET @DynamicSQL = ''
		;WITH ROWCTESource (RowNum,SourceSQLText)
		AS (
			SELECT ROW_NUMBER() OVER (PARTITION BY SourceSQLText ORDER BY LOCSourceId) AS RowNum,SourceSQLText
			FROM #LOCResultSource
			WHERE ISNULL(LOCCategorySource,'') <> ''
			)
		SELECT @DynamicSQL = COALESCE(@DynamicSQL, ' ') + SourceSQLText
		FROM ROWCTESource
		WHERE RowNum = 1

		--SET @DynamicSQL = ''
		--SELECT @DynamicSQL = COALESCE(@DynamicSQL, ' ') + SourceSQLText
		--FROM #LOCResultSource WHERE ISNULL(LOCCategorySource,'') <> ''

		EXEC (@DynamicSQL)

		SELECT @CalculatedLOC AS CalculatedLOC, @OverrideLOC AS OverrideLOC
		EXEC [dbo].[csp_GetCurrentDocumentLevelsOfCare] @ClientId, @DocumentVersionId
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_CalculateCurrentDocumentLevelsOfCare') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.    
				16
				,-- Severity.    
				1 -- State.    
				);
	END CATCH
END

GO