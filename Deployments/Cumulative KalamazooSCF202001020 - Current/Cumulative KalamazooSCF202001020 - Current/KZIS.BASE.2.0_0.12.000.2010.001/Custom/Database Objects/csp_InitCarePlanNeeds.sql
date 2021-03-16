IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCarePlanNeeds]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_InitCarePlanNeeds] --124593,550,NULL
GO

CREATE PROCEDURE [dbo].[csp_InitCarePlanNeeds] (        
 @ClientID INT        
 ,@CarePlanDocumentVersionID INT        
 ,@EffectiveDateDifference INT -- Difference is in years            
 )        
AS        
-- =============================================          
-- Author:  Pradeep.A          
-- Create date: 01/19/2015          
-- Description: Initializae Needs          
-- jun 04 2015 Pradeep  Added 'S' Source column for Old ASAM Needs      
/*01 July 2016 Vithobha Added @ScreenName to get the screen name dynamically instead of hard code, Bradford - Support Go Live: #134  */      
-- 11 May 2020     Ankita Sinha      Task #8 KCMHSAS Improvements    
-- 07 Jun 2020     Josekutty Varghese      
--                           What : Did changes in procedure to bind need list for recently signed document with dd population    
--                           Why  : Need list have to be displayed in treatment plan for physical assessment tab.    
--                           Portal Task: #12 in  KCMHSAS Improvements      
-- =============================================          
BEGIN TRY        
 BEGIN        
  DECLARE @DocumentCodeID INT    
    
  DECLARE @LatestASAMDocumentVersionID INT        
  DECLARE @ScreenName varchar(100)   
  DECLARE @LatestDocumentVersionIDAsSystemConfigKey  INT  
  DECLARE @DocumentCodeIdAsSystemConfigKey  INT  
  
  SELECT @DocumentCodeIdAsSystemConfigKey= [Value] FROM systemconfigurationkeys where [key]='ASSESSMENTDOCUMENTCODEID'  
     
  SELECT @DocumentCodeID= DocumentcodeID from DocumentCodes where Code='8AF7837B-05A7-4DF8-B2ED-6B852A5BA50A'       
  Select @ScreenName=Screenname From Screens Where DocumentcodeID=@DocumentCodeID         
    
  
  
  SELECT TOP 1 @LatestDocumentVersionIDAsSystemConfigKey
 = ISNULL(CurrentDocumentVersionId, 0)    FROM Documents   WHERE ClientId = @ClientID 
    AND CONVERT(DATE, EffectiveDate) <= CONVERT(DATE, GETDATE(), 101) 
	      AND STATUS = 22    AND DocumentCodeId 
IN (@DocumentCodeIdAsSystemConfigKey,@DocumentCodeID)    AND ISNULL(RecordDeleted, 'N') <> 'Y'   ORDER BY EffectiveDate DESC    ,ModifiedDate DESC  
  --print @LatestDocumentVersionIDAsSystemConfigKey  
 -- print @DocumentCodeIdAsSystemConfigKey  
  -- Storing CustomDocumentNeeds into temp table against (CarePlan and MHA) to set "Source" value conditionally            
  DECLARE @CustomDocumentNeeds TABLE (        
   CarePlanNeedId INT --Identity(- 1, - 1)        
   ,TableName VARCHAR(30)        
   ,DocumentVersionId INT        
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
   ,SourceName VARCHAR(500)        
   ,NeedDescription VARCHAR(MAX)        
   )         
  IF (@EffectiveDateDifference > 5)        
   SET @LatestDocumentVersionIDAsSystemConfigKey = 0        
        
  IF ISNULL(@LatestDocumentVersionIDAsSystemConfigKey, 0) > 0      
  BEGIN        
   INSERT INTO @CustomDocumentNeeds (        
     TableName        
    ,CarePlanNeedId      
    ,DocumentVersionId        
    ,CreatedBy        
    ,CreatedDate        
    ,ModifiedBy        
    ,ModifiedDate        
    ,RecordDeleted        
    ,DeletedBy        
    ,DeletedDate        
    ,CarePlanDomainNeedId        
    ,AddressOnCarePlan        
    ,NeedName        
    ,CarePlanDomainId        
    ,Source        
    ,SourceName        
    ,NeedDescription        
    )        
   SELECT 'CarePlanNeeds' AS TableName        
    ,CDN.CarePlanNeedId      
    ,ISNULL(CDN.DocumentVersionId, - 1) AS DocumentVersionId        
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
    ,CASE CDN.Source        
     WHEN 'C'        
      THEN @ScreenName        
     WHEN 'M'        
      THEN 'MHA'        
     WHEN 'A'        
      THEN 'ASAM'        
     WHEN 'O'        
      THEN 'Old MHA'         
     WHEN 'S'      
      THEN 'Old ASAM'      
     END AS SourceName        
    ,CDN.NeedDescription        
   FROM CarePlanNeeds AS CDN        
   LEFT JOIN CarePlanDomainNeeds AS CPDN ON CDN.CarePlanDomainNeedId = CPDN.CarePlanDomainNeedId        
   WHERE ISNULL(CDN.RecordDeleted, 'N') = 'N'        
    AND ISNULL(CPDN.RecordDeleted, 'N') = 'N'        
    AND CDN.DocumentVersionId =ISNULL(@LatestDocumentVersionIDAsSystemConfigKey,-1)      
  END       
      
  DECLARE @DDPopulationEffectiveDate AS DATETIME     
  DECLARE @MHEffectiveDate AS DATETIME     
  DECLARE @MHAssessmentDocumentcodeId VARCHAR(MAX)      
  Declare @ClientInDDPopulationDocumentVersionId as int = 0;    
  DECLARE @CODE VARCHAR(MAX)      
  SET @CODE='69E559DD-1A4D-46D3-B91C-E89DA48E0038'      
  SET @MHAssessmentDocumentcodeId=(Select DocumentCodeId from DocumentCodes where Code=@CODE)     
    
  Select TOP 1 @ClientInDDPopulationDocumentVersionId = d.CurrentDocumentVersionId,@DDPopulationEffectiveDate = EffectiveDate     
  From CustomDocumentMHAssessments CHA     
  join Documents d  on  CHA.DocumentVersionId = d.CurrentDocumentVersionId      
  Where d.ClientId = @ClientID and Isnull(d.RecordDeleted,'N') = 'N' and Isnull(CHA.RecordDeleted,'N') = 'N'        
  and d.DocumentCodeId = @MHAssessmentDocumentcodeId And  IsNull(ClientInDDPopulation,'N') = 'Y' and d.[Status] = 22    
  ORDER BY d.CurrentDocumentVersionId DESC    
       
  Select TOP 1 @MHEffectiveDate = EffectiveDate     
  From CustomDocumentMHAssessments CHA     
  join Documents d  on  CHA.DocumentVersionId = d.CurrentDocumentVersionId      
  Where Isnull(d.RecordDeleted,'N') = 'N' and Isnull(CHA.RecordDeleted,'N') = 'N'      
  And  CHA.DocumentVersionId = @LatestDocumentVersionIDAsSystemConfigKey;    
    
  IF ISNULL(@ClientInDDPopulationDocumentVersionId, 0) > 0     
   Begin    
     if (@DDPopulationEffectiveDate > @MHEffectiveDate)    
       Begin    
        If exists(Select * from @CustomDocumentNeeds Where CarePlanDomainNeedId in (87,88,89,90,91,92,93))    
      Begin    
       Delete from @CustomDocumentNeeds Where CarePlanDomainNeedId in (87,88,89,90,91,92,93);    
       End              
        
      INSERT INTO @CustomDocumentNeeds (          
    TableName          
   ,CarePlanNeedId        
   ,DocumentVersionId          
   ,CreatedBy          
   ,CreatedDate          
   ,ModifiedBy          
   ,ModifiedDate          
   ,RecordDeleted          
   ,DeletedBy          
   ,DeletedDate          
   ,CarePlanDomainNeedId          
   ,AddressOnCarePlan          
   ,NeedName          
   ,CarePlanDomainId          
   ,Source          
   ,SourceName          
   ,NeedDescription          
   )          
     SELECT 'CarePlanNeeds' AS TableName          
   ,CDN.CarePlanNeedId        
   ,ISNULL(CDN.DocumentVersionId, - 1) AS DocumentVersionId          
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
   ,'M' As Source           
   ,'MHA' AS SourceName          
   ,CDN.NeedDescription          
     FROM CarePlanNeeds AS CDN          
     LEFT JOIN CarePlanDomainNeeds AS CPDN ON CDN.CarePlanDomainNeedId = CPDN.CarePlanDomainNeedId          
     WHERE ISNULL(CDN.RecordDeleted, 'N') = 'N' AND ISNULL(CPDN.RecordDeleted, 'N') = 'N'          
     AND CDN.DocumentVersionId =ISNULL(@ClientInDDPopulationDocumentVersionId,-1)    
     And CPDN.CarePlanDomainNeedId in (87,88,89,90,91,92,93);      
       End    
 else    
  begin    
If not exists(Select * from @CustomDocumentNeeds Where CarePlanDomainNeedId = 87)    
      Begin    
     INSERT INTO @CustomDocumentNeeds (          
    TableName          
   ,CarePlanNeedId        
   ,DocumentVersionId          
   ,CreatedBy          
   ,CreatedDate          
   ,ModifiedBy          
   ,ModifiedDate          
   ,RecordDeleted          
   ,DeletedBy          
   ,DeletedDate          
   ,CarePlanDomainNeedId          
   ,AddressOnCarePlan          
   ,NeedName          
   ,CarePlanDomainId          
   ,Source          
   ,SourceName          
   ,NeedDescription          
   )          
     SELECT 'CarePlanNeeds' AS TableName          
   ,CDN.CarePlanNeedId        
   ,ISNULL(CDN.DocumentVersionId, - 1) AS DocumentVersionId          
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
   ,'M' As Source           
   ,'MHA' AS SourceName              
   ,CDN.NeedDescription          
     FROM CarePlanNeeds AS CDN          
     LEFT JOIN CarePlanDomainNeeds AS CPDN ON CDN.CarePlanDomainNeedId = CPDN.CarePlanDomainNeedId          
     WHERE ISNULL(CDN.RecordDeleted, 'N') = 'N' AND ISNULL(CPDN.RecordDeleted, 'N') = 'N'          
     AND CDN.DocumentVersionId =ISNULL(@ClientInDDPopulationDocumentVersionId,-1)    
     And CPDN.CarePlanDomainNeedId = 87;       
   end      
    
   If not exists(Select * from @CustomDocumentNeeds Where CarePlanDomainNeedId = 88)    
      Begin    
     INSERT INTO @CustomDocumentNeeds (          
    TableName          
   ,CarePlanNeedId        
   ,DocumentVersionId          
   ,CreatedBy          
   ,CreatedDate          
   ,ModifiedBy          
   ,ModifiedDate          
   ,RecordDeleted          
   ,DeletedBy          
   ,DeletedDate          
   ,CarePlanDomainNeedId          
   ,AddressOnCarePlan          
   ,NeedName          
   ,CarePlanDomainId          
   ,Source          
   ,SourceName          
   ,NeedDescription          
   )          
     SELECT 'CarePlanNeeds' AS TableName          
   ,CDN.CarePlanNeedId        
   ,ISNULL(CDN.DocumentVersionId, - 1) AS DocumentVersionId          
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
   ,'M' As Source           
   ,'MHA' AS SourceName              
   ,CDN.NeedDescription          
     FROM CarePlanNeeds AS CDN          
     LEFT JOIN CarePlanDomainNeeds AS CPDN ON CDN.CarePlanDomainNeedId = CPDN.CarePlanDomainNeedId          
     WHERE ISNULL(CDN.RecordDeleted, 'N') = 'N' AND ISNULL(CPDN.RecordDeleted, 'N') = 'N'          
     AND CDN.DocumentVersionId =ISNULL(@ClientInDDPopulationDocumentVersionId,-1)    
     And CPDN.CarePlanDomainNeedId = 88;       
   end      
    
   If not exists(Select * from @CustomDocumentNeeds Where CarePlanDomainNeedId = 89)    
      Begin    
     INSERT INTO @CustomDocumentNeeds (          
    TableName          
   ,CarePlanNeedId        
   ,DocumentVersionId          
   ,CreatedBy          
   ,CreatedDate          
   ,ModifiedBy          
   ,ModifiedDate          
   ,RecordDeleted          
   ,DeletedBy          
   ,DeletedDate          
   ,CarePlanDomainNeedId          
   ,AddressOnCarePlan          
   ,NeedName          
   ,CarePlanDomainId          
   ,Source          
   ,SourceName          
   ,NeedDescription          
   )          
     SELECT 'CarePlanNeeds' AS TableName          
   ,CDN.CarePlanNeedId        
   ,ISNULL(CDN.DocumentVersionId, - 1) AS DocumentVersionId          
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
   ,'M' As Source           
   ,'MHA' AS SourceName         
   ,CDN.NeedDescription          
     FROM CarePlanNeeds AS CDN          
     LEFT JOIN CarePlanDomainNeeds AS CPDN ON CDN.CarePlanDomainNeedId = CPDN.CarePlanDomainNeedId          
     WHERE ISNULL(CDN.RecordDeleted, 'N') = 'N' AND ISNULL(CPDN.RecordDeleted, 'N') = 'N'          
     AND CDN.DocumentVersionId =ISNULL(@ClientInDDPopulationDocumentVersionId,-1)    
     And CPDN.CarePlanDomainNeedId = 89;       
   end      
    
   If not exists(Select * from @CustomDocumentNeeds Where CarePlanDomainNeedId = 90)    
      Begin    
     INSERT INTO @CustomDocumentNeeds (          
    TableName          
   ,CarePlanNeedId        
   ,DocumentVersionId          
   ,CreatedBy          
   ,CreatedDate          
   ,ModifiedBy          
   ,ModifiedDate          
   ,RecordDeleted          
   ,DeletedBy          
   ,DeletedDate          
   ,CarePlanDomainNeedId          
   ,AddressOnCarePlan          
   ,NeedName          
   ,CarePlanDomainId          
   ,Source          
   ,SourceName          
   ,NeedDescription          
   )          
     SELECT 'CarePlanNeeds' AS TableName          
   ,CDN.CarePlanNeedId        
   ,ISNULL(CDN.DocumentVersionId, - 1) AS DocumentVersionId          
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
   ,'M' As Source           
   ,'MHA' AS SourceName             
   ,CDN.NeedDescription          
     FROM CarePlanNeeds AS CDN          
     LEFT JOIN CarePlanDomainNeeds AS CPDN ON CDN.CarePlanDomainNeedId = CPDN.CarePlanDomainNeedId          
     WHERE ISNULL(CDN.RecordDeleted, 'N') = 'N' AND ISNULL(CPDN.RecordDeleted, 'N') = 'N'          
     AND CDN.DocumentVersionId =ISNULL(@ClientInDDPopulationDocumentVersionId,-1)    
     And CPDN.CarePlanDomainNeedId = 90;       
   end      
    
   If not exists(Select * from @CustomDocumentNeeds Where CarePlanDomainNeedId = 91)    
      Begin    
     INSERT INTO @CustomDocumentNeeds (          
    TableName          
   ,CarePlanNeedId        
   ,DocumentVersionId          
   ,CreatedBy          
   ,CreatedDate          
   ,ModifiedBy          
   ,ModifiedDate          
   ,RecordDeleted          
   ,DeletedBy          
   ,DeletedDate          
   ,CarePlanDomainNeedId          
   ,AddressOnCarePlan          
   ,NeedName          
   ,CarePlanDomainId          
   ,Source          
   ,SourceName          
   ,NeedDescription          
   )          
     SELECT 'CarePlanNeeds' AS TableName          
   ,CDN.CarePlanNeedId        
   ,ISNULL(CDN.DocumentVersionId, - 1) AS DocumentVersionId          
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
   ,'M' As Source           
   ,'MHA' AS SourceName              
   ,CDN.NeedDescription          
     FROM CarePlanNeeds AS CDN          
     LEFT JOIN CarePlanDomainNeeds AS CPDN ON CDN.CarePlanDomainNeedId = CPDN.CarePlanDomainNeedId          
     WHERE ISNULL(CDN.RecordDeleted, 'N') = 'N' AND ISNULL(CPDN.RecordDeleted, 'N') = 'N'          
     AND CDN.DocumentVersionId =ISNULL(@ClientInDDPopulationDocumentVersionId,-1)    
     And CPDN.CarePlanDomainNeedId = 91;       
   end      
    
   If not exists(Select * from @CustomDocumentNeeds Where CarePlanDomainNeedId = 92)    
      Begin    
     INSERT INTO @CustomDocumentNeeds (          
    TableName          
   ,CarePlanNeedId        
   ,DocumentVersionId          
   ,CreatedBy          
   ,CreatedDate          
   ,ModifiedBy          
   ,ModifiedDate          
   ,RecordDeleted          
   ,DeletedBy          
   ,DeletedDate          
   ,CarePlanDomainNeedId          
   ,AddressOnCarePlan          
   ,NeedName          
   ,CarePlanDomainId          
   ,Source          
   ,SourceName          
   ,NeedDescription          
   )          
     SELECT 'CarePlanNeeds' AS TableName          
   ,CDN.CarePlanNeedId        
   ,ISNULL(CDN.DocumentVersionId, - 1) AS DocumentVersionId          
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
   ,'M' As Source           
   ,'MHA' AS SourceName              
   ,CDN.NeedDescription          
     FROM CarePlanNeeds AS CDN          
     LEFT JOIN CarePlanDomainNeeds AS CPDN ON CDN.CarePlanDomainNeedId = CPDN.CarePlanDomainNeedId          
     WHERE ISNULL(CDN.RecordDeleted, 'N') = 'N' AND ISNULL(CPDN.RecordDeleted, 'N') = 'N'          
     AND CDN.DocumentVersionId =ISNULL(@ClientInDDPopulationDocumentVersionId,-1)    
     And CPDN.CarePlanDomainNeedId = 92;       
   end      
    
   If not exists(Select * from @CustomDocumentNeeds Where CarePlanDomainNeedId = 93)    
      Begin    
     INSERT INTO @CustomDocumentNeeds (          
    TableName          
   ,CarePlanNeedId        
   ,DocumentVersionId          
   ,CreatedBy          
   ,CreatedDate          
   ,ModifiedBy          
   ,ModifiedDate          
   ,RecordDeleted          
   ,DeletedBy          
   ,DeletedDate          
   ,CarePlanDomainNeedId          
   ,AddressOnCarePlan          
   ,NeedName          
   ,CarePlanDomainId          
   ,Source          
   ,SourceName          
   ,NeedDescription          
   )          
     SELECT 'CarePlanNeeds' AS TableName          
   ,CDN.CarePlanNeedId        
   ,ISNULL(CDN.DocumentVersionId, - 1) AS DocumentVersionId          
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
   ,'M' As Source           
   ,'MHA' AS SourceName              
   ,CDN.NeedDescription          
     FROM CarePlanNeeds AS CDN          
     LEFT JOIN CarePlanDomainNeeds AS CPDN ON CDN.CarePlanDomainNeedId = CPDN.CarePlanDomainNeedId          
     WHERE ISNULL(CDN.RecordDeleted, 'N') = 'N' AND ISNULL(CPDN.RecordDeleted, 'N') = 'N'          
     AND CDN.DocumentVersionId =ISNULL(@ClientInDDPopulationDocumentVersionId,-1)    
     And CPDN.CarePlanDomainNeedId = 93;       
   end      
    
  end      
   End    
        
 SELECT CDN.* FROM @CustomDocumentNeeds CDN        
 END      
END TRY        
        
BEGIN CATCH        
 DECLARE @Error VARCHAR(8000)        
        
 SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_InitCarePlanNeeds') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' +       
 Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())        
        
 RAISERROR (        
   @Error        
   ,-- Message text.                 
   16        
   ,-- Severity.                 
   1 -- State.                                                                   
   );        
END CATCH 