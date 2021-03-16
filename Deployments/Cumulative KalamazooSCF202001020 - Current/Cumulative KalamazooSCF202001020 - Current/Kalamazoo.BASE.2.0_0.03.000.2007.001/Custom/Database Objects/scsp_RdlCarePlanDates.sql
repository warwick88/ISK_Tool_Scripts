/****** Object:  StoredProcedure [dbo].[scsp_RdlCarePlanDates]    Script Date: 03/13/2020 10:23:17 AM ******/
IF EXISTS
(
    SELECT *
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[scsp_RdlCarePlanDates]')
          AND type IN(N'P', N'PC')
)
    DROP PROCEDURE [dbo].[scsp_RdlCarePlanDates];
GO

/****** Object:  StoredProcedure [dbo].[scsp_RdlCarePlanDates]    Script Date: 03/13/2020 10:23:17 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[scsp_RdlCarePlanDates]--2013767,'',''
 (@DocumentVersionId INT,@ScreenName VARCHAR(100),@Enddate DATETIME OUT  )
AS
/*****************************************************************************************/
--  Copyright: Streamline Healthcate Solutions 
-- Purpose: To Calcualte end date of careplan document
-- This  scsp_RdlCarePlanDates is called from ssp_RdlCarePlanDates
-- Updates:
-- Date                   Author            Purpose
-- 03/13/2020             Anto              Modified the logic to calculate the enddate of the careplan in RDL - High Plains-Support Go Live #214
/*******************************************************************************************/

BEGIN
	BEGIN TRY
declare @ReviewEntireCareType varchar(100)
Select @ReviewEntireCareType=ReviewEntireCareType from DocumentCarePlans where DocumentVersionId= @DocumentVersionId  AND ISNULL(RecordDeleted, 'N') = 'N' 

declare @ReviewEntireCarePlan int
Select @ReviewEntireCarePlan=ReviewEntireCarePlan from DocumentCarePlans where DocumentVersionId= @DocumentVersionId  AND ISNULL(RecordDeleted, 'N') = 'N' 


declare @numberofdays int
--declare @Enddate datetime=NULL
Declare @Effectivedate Datetime 

SELECT @Effectivedate=d.EffectiveDate  
FROM DocumentVersions dv  
JOIN Documents d ON d.DocumentId = dv.DocumentId  
WHERE dv.DocumentVersionId = @DocumentVersionId  
 

IF(@ReviewEntireCareType='S')
BEGIN


SELECT @numberofdays=CAST(SUBSTRING(CodeName,
PATINDEX('%[0-9]%', CodeName),
(CASE WHEN PATINDEX('%[^0-9]%', STUFF(CodeName, 1, (PATINDEX('%[0-9]%', CodeName) - 1), '')) = 0
THEN LEN(CodeName) ELSE (PATINDEX('%[^0-9]%', STUFF(CodeName, 1, (PATINDEX('%[0-9]%', CodeName) - 1), ''))) - 1
END )
) AS INT)  FROM globalcodes WHERE GlobalCodeId=@ReviewEntireCarePlan
AND ISNULL(RecordDeleted, 'N') = 'N' 

SELECT @Enddate=DATEADD(dd,@numberofdays,@Effectivedate)
END
ELSE
IF(@ReviewEntireCareType='D')

BEGIN
SELECT @Enddate=ReviewEntireCarePlanDate FROM DocumentCarePlans WHERE DocumentVersionId= @DocumentVersionId
AND ISNULL(RecordDeleted, 'N') = 'N' 
END

	
 SELECT               
 CSLD.[DocumentVersionId],    
 CONVERT(VARCHAR,DC.EffectiveDate,101) AS BeginDate,              
 CASE CSLD.[CarePlanType]                       
 WHEN 'AD' THEN 'Addendum'      
--Added by Veena on 05/11/16 for CarePlan Review changes Valley Support Go live #390    
 WHEN 'RE' THEN 'Review'    
 ELSE @ScreenName      
 END AS [CarePlanType],     
 CONVERT(VARCHAR,@EndDate,101) AS [EndDate],  
 @ScreenName AS ScreenName    
 FROM [DocumentCarePlans] CSLD   
 JOIN dbo.DocumentVersions dv ON dv.DocumentVersionId = CSLD.DocumentVersionId  
 INNER JOIN Documents DC ON DC.DocumentId=dv.[DocumentId]                  
 WHERE ISNULL(CSLD.RecordDeleted,'N')='N'    
 AND  ISNULL(DC.RecordDeleted,'N')='N'    
 AND CSLD.DocumentVersionId=@DocumentVersionId  



	END TRY
	BEGIN CATCH
	DECLARE @ERROR VARCHAR(8000)
	SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())
	+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'scsp_RdlCarePlanDates')
	+ '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())
	+ '*****' + CONVERT(VARCHAR,ERROR_STATE())
	RAISERROR
	(
	@Error, -- Message text.
	16, -- Severity.
	1 -- State.
	);
	END CATCH
END

GO


