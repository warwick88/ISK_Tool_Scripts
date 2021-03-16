
/****** Object:  StoredProcedure [dbo].[csp_PostUpdateMHAssessment]    Script Date: 12/08/2014 12:45:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PostUpdateMHAssessment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PostUpdateMHAssessment]
GO

/****** Object:  StoredProcedure [dbo].[csp_PostUpdateMHAssessment]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO  
  
CREATE Procedure [dbo].[csp_PostUpdateMHAssessment]  
(  
     @ScreenKeyId INT ,
      @StaffId INT ,
      @CurrentUser VARCHAR(30) ,
      @CustomParameters XML
)  
 /*********************************************************************/
 /* Stored Procedure: [csp_PostUpdateMHAssessment]   */

 /*       Date              Author                  Purpose                   */ 
 /*       28/May/2020      Jyothi Bellapu          This SP will update the necessary fields once  signed document data part of Kalamazoo - Improvements -#7*/
 /*********************************************************************/  
      
AS  
  BEGIN
BEGIN  TRY
  
  DECLARE @DocumentVersionId INT   
  
  SELECT TOP 1
                    @DocumentVersionId = CurrentDocumentVersionId
            FROM    CustomDocumentMHAssessments CDSA
                    INNER JOIN Documents Doc ON CDSA.DocumentVersionId = Doc.CurrentDocumentVersionId
            WHERE   Doc.DocumentId = @ScreenKeyId
                    --AND Doc.[Status] = 22
                    AND ISNULL(CDSA.RecordDeleted, 'N') = 'N'
                    AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
            ORDER BY Doc.EffectiveDate DESC ,
                    Doc.ModifiedDate DESC
  
 ---- Inquirer fields ----------  
 DECLARE @GuardianFirstName varchar(30)
 DECLARE @GuardianLastName varchar(50)
 DECLARE @GuardianRelation INT  
 DECLARE @GuardianPhoneNumber Varchar(50)  
 DECLARE @GuardianAddress Varchar(100)
 DECLARE @GuardianCity varchar(30)
 DECLARE @GuardianState varchar(2)
 DECLARE @GuardianZipcode  varchar(12)
-- DECLARE @CurrentUser  varchar(50)
 DECLARE  @GuardianDisplay  Varchar(150)
 DECLARE @ClientId INT
 DECLARE @ListAs  VARCHAR(300)
 DECLARE @CurrentLiving INT
 DECLARE @EmploymentStatus INT

 SET  @Clientid = ( Select top 1 Clientid from documents where CurrentDocumentVersionId=@DocumentVersionId)

  -- Guardian Information ----- 
 SELECT 
  @GuardianFirstName = GuardianFirstName , @GuardianLastName = GuardianLastName  
  , @GuardianRelation = RelationWithGuardian,@GuardianAddress=GuardianAddress
  , @GuardianPhoneNumber = GuardianPhone, @GuardianCity=GuardianCity
  ,@GuardianState=GuardianState,@GuardianZipcode=GuardianZipcode,@CurrentLiving=CurrentLivingArrangement,@EmploymentStatus=EmploymentStatus
  --,@CurrentUser=ModifiedBy
 FROM CustomDocumentMHAssessments WHERE DocumentVersionId = @DocumentVersionId  
 
 SET @GuardianDisplay = @GuardianAddress +' ' +@GuardianCity+ ' '+@GuardianState+' ' +@GuardianZipcode
 SET @ListAs  =@GuardianLastName +', '+ @GuardianFirstName

  DECLARE @CONTACTEXIST CHAR(1)
  DECLARE @ClientContactId INT
  SET @ClientContactId=(Select Top 1 ClientContactId from ClientContacts where firstname=@GuardianFirstName and Lastname=@GuardianLastName
  AND ACTIVE='Y' AND ISNULL(Recorddeleted,'N')='N' and Clientid=@Clientid
  )

  IF ( @ClientContactId >0  )
  BEGIN
  SET @CONTACTEXIST ='Y'
  END
  ELSE
  BEGIN
  SET @CONTACTEXIST ='N'
  END
   
 DECLARE @Guardian CHAR(1 )
 SET @Guardian = (SELECT ISNULL(Guardian,'N') from ClientContacts where  ClientContactId= @ClientContactId  )
  
 
 
 IF ( @CONTACTEXIST ='Y'  )
 BEGIN
      Update CC   
      SET CC.Relationship =@GuardianRelation
      , CC.ModifiedDate = getdate()  
      , CC.ModifiedBy = @CurrentUser  
      FROM clientcontacts    CC
      WHERE CC.ClientContactId = @ClientContactId

			------ Update Client Address ------------------  
	  Update CA   
	  SET CA.Address = @GuardianAddress  
	   , CA.City = @GuardianCity
	   , CA.State = @GuardianState  
	   , CA.Zip = @GuardianZipcode
	   ,CA.Display =@GuardianDisplay
	   , CA.ModifiedDate = getdate()   
	   , CA.ModifiedBy = @CurrentUser  
	  FROM ClientContactAddresses CA 
	 WHERE CA.ClientContactId = @ClientContactId AND CA.AddressType = 90 -- 90 = Home 

 END
 -- ClientContactAddresses
 ELSE
 BEGIN
  IF (isnull(@GuardianFirstName,'') <> '' AND isnull(@GuardianLastName,'') <> '' AND isnull(@GuardianRelation,'') <> '')
   BEGIN
      INSERT INTO ClientContacts ([CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],firstname,lastname,[Relationship],clientid,ListAs,Guardian,Active)
      VALUES (@CurrentUser, GetDate(), @CurrentUser, GetDate(),@GuardianFirstName,@GuardianLastName, @GuardianRelation,@Clientid,@ListAs,'Y','Y')

      SET @ClientContactId=(Select Top 1 ClientContactId from ClientContacts where firstname=@GuardianFirstName and Lastname=@GuardianLastName AND Relationship=@GuardianRelation AND Guardian='Y'
                            AND ACTIVE='Y' AND ISNULL(Recorddeleted,'N')='N' and Clientid=@Clientid
                           )
     INSERT INTO ClientContactAddresses ([CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],ClientContactId,[Address],[City],[State],[Zip],AddressType ,Display)
     VALUES (@CurrentUser, GetDate(), @CurrentUser, GetDate(),@ClientContactId,@GuardianAddress,@GuardianCity,@GuardianState,@GuardianZipcode,90,@GuardianDisplay)
   SET    @CONTACTEXIST ='Y' 
   END
  END
 
  IF ( @CONTACTEXIST ='Y' AND @Guardian='N'  )
  BEGIN
    UPDATE  CC
    SET CC.Guardian ='Y'
    FROM clientcontacts    CC
    WHERE CC.ClientContactId = @ClientContactId
  END


  

  ------------- Home Phone ---------------
  IF ( isnull(@GuardianPhoneNumber,'') <> '' AND  @CONTACTEXIST ='Y' )  
  BEGIN  
                  ---- Update Home Phone -----  
   IF EXISTS (SELECT 1  FROM ClientContactPhones Where ClientContactId =  @ClientContactId AND PhoneType = 30)  
   BEGIN  
    Update ClientContactPhones   
    SET PhoneNumber = @GuardianPhoneNumber   
     , PhoneNumberText = dbo.[csf_PhoneNumberStripped](@GuardianPhoneNumber)  
     , ModifiedBy =  @CurrentUser  
     , ModifiedDate = getdate()       
    Where ClientContactId =  @ClientContactId AND PhoneType = 30  
   END  
   ELSE  
   BEGIN  
    INSERT INTO ClientContactPhones  
     ([CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate], ClientContactId, PhoneNumber, PhoneNumberText, PhoneType )  
    VALUES (@CurrentUser, GetDate(), @CurrentUser, GetDate(), @ClientContactId , @GuardianPhoneNumber, dbo.[csf_PhoneNumberStripped](@GuardianPhoneNumber), 30)  
   END     
   END

 -- CurrentLivingArrangement
 IF(isnull(@CurrentLiving,'') <> '')
 BEGIN
     UPDATE  CLIENTS SET livingArrangement=@CurrentLiving where Clientid=@Clientid
 END
 
  -- Employment status
 IF(isnull(@EmploymentStatus,'') <> '')
 BEGIN
     UPDATE  CLIENTS SET EmploymentStatus=@EmploymentStatus where Clientid=@Clientid
 END

 END TRY
	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_PostUpdateMHAssessment') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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

