IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'csp_InitCarePlanNeedsMHAssessments')
	BEGIN
		DROP  Procedure  csp_InitCarePlanNeedsMHAssessments --139,444,0
	END

GO  
CREATE PROCEDURE [dbo].[csp_InitCarePlanNeedsMHAssessments] (  
 @ClientID INT  
 ,@CarePlanDocumentVersionID INT  
 ,@EffectiveDateDifference INT -- Difference is in years    
 )  
AS  
-- ======================================k=======  
-- Author:  Jyothi Bellapu csp_InitCarePlanNeedsMHAssessments 44542,-1 ,0
-- Create date: 28/05/2020  
-- Description: Initializae Needs  
-- =============================================  
BEGIN TRY  
 BEGIN  
  -- Storing CustomDocumentNeeds into temp table against (CarePlan and MHA) to set "Source" value conditionally   
  
   DECLARE @MHAssessmentDocumentcodeId VARCHAR(MAX)  
            DECLARE @CODE VARCHAR(MAX)  
            SET @CODE='69E559DD-1A4D-46D3-B91C-E89DA48E0038'  
            SET @MHAssessmentDocumentcodeId=(Select DocumentCodeId from DocumentCodes where Code=@CODE)  
			 
  DECLARE @CustomDocumentNeeds TABLE (  
   TableName VARCHAR(30)  
   ,DocumentVersionId INT  
   ,CarePlanNeedId INT  
   ,CreatedBy VARCHAR(30)  
   ,CreatedDate DATETIME  
   ,ModifiedBy VARCHAR(30)  
   ,ModifiedDate DATETIME  
   ,RecordDeleted CHAR(1)  
   ,DeletedBy VARCHAR(30)  
   ,DeletedDate DATETIME  
   ,CarePlanDomainNeedId INT  
   ,AddressOnCarePlan CHAR(1)  
   ,NeedName VARCHAR(500)  
   ,CarePlanDomainId INT  
   ,Source CHAR(1)  
   --,SourceName VARCHAR(10)  
   ,NeedDescription VARCHAR(MAX) 
   )  
   DECLARE @LatestASAMDocumentVersionID INT
   SET @LatestASAMDocumentVersionID = (  
    SELECT TOP 1 D.CurrentDocumentVersionId  
    FROM CustomDocumentMHAssessments C  
     ,Documents D  
    WHERE C.DocumentVersionId = D.CurrentDocumentVersionId  
     AND D.ClientId = @ClientID  
     AND D.STATUS = 22  
     AND IsNull(C.RecordDeleted, 'N') = 'N'  
     AND IsNull(D.RecordDeleted, 'N') = 'N'  
     AND DocumentCodeId IN (@MHAssessmentDocumentcodeId)  
    ORDER BY D.EffectiveDate DESC  
     ,D.ModifiedDate DESC  
    )  
  

  
   INSERT INTO @CustomDocumentNeeds  
   SELECT 'CarePlanNeeds' AS TableName  
    ,ISNULL(CDN.DocumentVersionId, - 1) AS DocumentVersionId  
    ,CDN.CarePlanNeedId  
    ,CDN.CreatedBy  
    ,CDN.CreatedDate  
    ,CDN.ModifiedBy  
    ,CDN.ModifiedDate  
    ,CDN.RecordDeleted  
    ,CDN.DeletedBy  
    ,CDN.DeletedDate  
    ,CDN.CarePlanDomainNeedId  
    ,CDN.AddressOnCarePlan  
    ,CPDN.NeedName  
    ,CPDN.CarePlanDomainId  
    ,CDN.Source  
    --,CASE CDN.Source  
    -- WHEN 'C' THEN 'Care Plan'  
    -- WHEN 'M' THEN 'MHA' END AS Source
    ,CDN.NeedDescription  
   FROM CarePlanNeeds AS CDN  
   LEFT JOIN CarePlanDomainNeeds AS CPDN ON CDN.CarePlanDomainNeedId = CPDN.CarePlanDomainNeedId  
   WHERE ISNULL(CDN.RecordDeleted, 'N') = 'N'  
    AND ISNULL(CPDN.RecordDeleted, 'N') = 'N'  
    AND CDN.DocumentVersionId = @CarePlanDocumentVersionID  
  END  
  
  SELECT CDN.*  
  FROM @CustomDocumentNeeds CDN  

END TRY  
  
BEGIN CATCH  
 DECLARE @Error VARCHAR(8000)  
  
 SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_InitCarePlanNeedsMHAssessments') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())  
  
 RAISERROR (  
   @Error  
   ,-- Message text.         
   16  
   ,-- Severity.         
   1 -- State.                                                           
   );  
END CATCH  