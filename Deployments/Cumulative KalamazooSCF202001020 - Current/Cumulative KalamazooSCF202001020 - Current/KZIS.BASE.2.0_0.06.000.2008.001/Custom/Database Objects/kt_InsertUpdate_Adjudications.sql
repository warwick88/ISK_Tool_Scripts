 
/****** Object:  Trigger [kt_InsertUpdate_Adjudications]    Script Date: 04/09/2018 11:44:28 ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[kt_InsertUpdate_Adjudications]'))
DROP TRIGGER [dbo].[kt_InsertUpdate_Adjudications]
GO


/****** Object:  Trigger [dbo].[kt_InsertUpdate_Adjudications]    Script Date: 04/09/2018 11:44:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE TRIGGER [dbo].[kt_InsertUpdate_Adjudications]  
ON [dbo].[Adjudications]  
FOR INSERT, UPDATE  
  
/****************************************************\  
 Author: CHernandez  
 Date: 05/22/2018  
 Description: Checks the Status for all  
 adjudications and updates the Claims.CleanClaimDate  
 column.  
 
 -- Updates:         
--  Date         Author       Purpose        
 -- 12.13.2019   Bibhu       What : RaisError ErrorCode added.
 --                           Why :  Engineering Improvement Initiatives- NBL(I) #103012 
\****************************************************/  

AS  
BEGIN  
BEGIN TRY
 SET NOCOUNT ON  
  
 DECLARE  
  @ApprovedStatus INT,  
  @PartiallyApprovedStatus INT  
  
  
 SELECT  
  @ApprovedStatus = GlobalCodeId  
 FROM GlobalCodes  
 WHERE  
  Category = 'CLAIMSTATUS' AND  
  CodeName = 'Approved'  
   
 SELECT  
  @PartiallyApprovedStatus = GlobalCodeId  
 FROM GlobalCodes  
 WHERE  
  Category = 'CLAIMSTATUS' AND  
  CodeName = 'Partially  Approved'  
  
  
 -- Set all claim's CleanClaimDate to current datetime for all adjudications going into Paid status.  
 UPDATE C  
 SET  
  CleanClaimDate = GETDATE(),  
  ModifiedBy = 'CleanClaimDateTrigger',  
  ModifiedDate = GETDATE()  
 FROM inserted I  
 --JOIN deleted D ON I.AdjudicationId = D.AdjudicationId  
 JOIN ClaimLines CL ON I.ClaimLineId = CL.ClaimLineId AND ISNULL(CL.RecordDeleted, 'N') = 'N'  
 JOIN CustomClaimLines CCL ON CL.ClaimLineId = CCL.ClaimLineId AND ISNULL(CCL.RecordDeleted, 'N') = 'N'  
 LEFT JOIN (  
  SELECT ClaimLineHistoryId, ClaimLineId, Status FROM ClaimLineHistory  
  WHERE  
   Status IN(@ApprovedStatus, @PartiallyApprovedStatus) AND  
   ISNULL(RecordDeleted, 'N') = 'N'  
 ) CLH ON CL.ClaimLineId = CLH.ClaimLineId  
 JOIN Claims C ON CL.ClaimId = C.ClaimId  
 WHERE  
  I.Status IN(@ApprovedStatus, @PartiallyApprovedStatus) AND  
  CLH.ClaimLineHistoryId IS NULL  
  --D.Status NOT IN(@ApprovedStatus, @PartiallyApprovedStatus)  
END TRY
BEGIN CATCH
    raiserror ('ERR_kt_InsertUpdate_Adjudications : Please contact your system administrator.',16,1)  
END CATCH
END  