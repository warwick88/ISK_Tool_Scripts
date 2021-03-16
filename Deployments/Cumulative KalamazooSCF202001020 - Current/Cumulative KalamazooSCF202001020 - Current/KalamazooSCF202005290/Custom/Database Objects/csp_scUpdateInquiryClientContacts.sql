

/****** Object:  StoredProcedure [dbo].[csp_scUpdateInquiryClientContacts]    Script Date: 11/13/2013 17:33:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_scUpdateInquiryClientContacts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_scUpdateInquiryClientContacts]
GO


/****** Object:  StoredProcedure [dbo].[csp_scUpdateInquiryClientContacts]    Script Date: 11/13/2013 17:33:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[csp_scUpdateInquiryClientContacts]
(
	@InquiryId INT,
	@ClientId INT,
	@CurrentUser VARCHAR(50)
)
/******************************************************************************
**  File: 
**  Name: csp_scUpdateInquiryClientContacts 
**  Desc: Create event for the Inquire after completing the status of the inquiry. 
**  Parameters:
**  Input
	@InquiryId INT,
	@ClientId INT,
	@CurrentUser VARCHAR(50)
**  Output     ----------       -----------
** 
**  Auth:  Pralyankar Kumar Singh
**  Date:  March 18, 2012
*******************************************************************************
**  Change History 
*******************************************************************************
**  Date:  Author:    Description:
**  --------  --------    -------------------------------------------
**
*******************************************************************************/  
AS

BEGIN

	-- Query 
	-- 1. In Client contacts table we habe no filed for phone numbers so do you want to skip these fields.
	-- 2. Whatever information we will insert in client contact table that should be updated in PCM database as well. Please confirm.
	-- 3. 

	---- Inquirer fields ----------
	DECLARE @InquirerFirstName Varchar(50), @InquirerLastName Varchar(50), @InquirerMiddleName Varchar(50), @InquirerRelationToMember INT
		, @InquirerPhone varchar(100), @InquirerEmail Varchar(100)
		-- Emergency access Fields -----
		, @EmergencyContactRelationToClient INT, @EmergencyContactFirstName Varchar(50), @EmergencyContactLastName Varchar(50)
		, @EmergencyContactHomePhone varchar(100), @EmergencyContactCellPhone varchar(100)
		, @EmergencyContactSameAsCaller Char(1)
		, @ClientCanLegalySign char(1)
		, @GuardianFirstName varchar(50), @GuardianLastName varchar(50), @GuardianRelation INT
		, @GuardianDOB varchar(20), @GardianComment varchar(Max), @GuardianPhoneNumber Varchar(128)
		, @GuardianSameAsCaller char(1)
	--------------------------------
	DECLARE @ClientContactId INT, @EmergencyClientContactId INT


	SELECT @InquirerFirstName =InquirerFirstName, @InquirerLastName =InquirerLastName, @InquirerMiddleName = InquirerMiddleName
		, @InquirerRelationToMember = InquirerRelationToMember , @InquirerPhone = InquirerPhone, @InquirerEmail = InquirerEmail
		-- Emergency access Fields -----
		, @EmergencyContactSameAsCaller = EmergencyContactSameAsCaller
		, @EmergencyContactRelationToClient = EmergencyContactRelationToClient, @EmergencyContactFirstName = EmergencyContactFirstName
		, @EmergencyContactLastName = EmergencyContactLastName
		, @EmergencyContactHomePhone = EmergencyContactHomePhone, @EmergencyContactCellPhone = EmergencyContactCellPhone
		-- Guardian Information -----
		, @ClientCanLegalySign = ClientCanLegalySign
		, @GuardianFirstName = GuardianFirstName , @GuardianLastName = GuardianLastName
		, @GuardianRelation = GuardianRelation, @GuardianDOB = GuardianDOB, @GardianComment = GardianComment
		, @GuardianPhoneNumber = GuardianPhoneNumber, @GuardianSameAsCaller = isnull(GuardianSameAsCaller,'N')
	FROM CustomInquiries WHERE InquiryId = @InquiryId

		---- Update Client Information -----
		Update C 
		SET C.FirstName = CI.MemberFirstName   
			, C.LastName = CI.MemberLastName 
			, C.MiddleName = CI.MemberMiddleName 
			, C.SSN = CI.SSN  
			, C.DOB = CI.DateOfBirth  
			, C.Email = CI.MemberEmail   
			, C.LivingArrangement = CI.Living  
			, C.NumberOfBeds = CI.NoOfBeds  
			, C.CountyOfResidence = CI.CountyOfResidence 
			, C.CorrectionStatus = CI.CorrectionStatus  
			, C.EducationalStatus = CI.EducationalStatus 
			, C.EmploymentStatus = CI.EmploymentStatus  
			, C.EmploymentInformation = CI.EmployerName  
			, C.MinimumWage = CASE WHEN rtrim(ltrim(CI.MinimumWage)) = 'Y' THEN 'Yes' ELSE 'No' END 
			, C.Sex = CI.Sex 
			, C.ModifiedDate = getdate()
			, C.ModifiedBy = @CurrentUser
		FROM Clients C Inner JOIN CustomInquiries CI ON CI.ClientId = C.ClientId 
		WHERE CI.InquiryId = @inquiryId
		------------------------------------------------------------------------

		------ Update Client Address ------------------
		Update CA 
		SET CA.Address = CI.Address1 
			, CA.City = CI.City 
			, CA.State = CI.State 
			, CA.Zip = CI.ZipCode 
			, CA.ModifiedDate = getdate() 
			, CA.ModifiedBy = @CurrentUser
		FROM ClientAddresses CA Inner JOIN CustomInquiries CI ON CI.ClientId = CA.ClientId And CA.AddressType = 90 -- 90 = Home
		WHERE CI.InquiryId = @inquiryId
		-----------------------------------------------

		-- Update Client Episod Informations ----------
		UPDATE CE 
		SET CE.ReferralDate = CI.ReferralDate  
			, CE.ReferralType = CI.ReferralType   
			, CE.ReferralSubtype = CI.ReferralSubtype  
			, CE.ReferralName = CI.ReferralName  
			, CE.ReferralAdditionalInformation = CI.ReferralAdditionalInformation 
			, CE.ModifiedDate = getdate() 
			, CE.ModifiedBy = @CurrentUser 
		FROM ClientEpisodes CE INNER JOIN Clients C ON CE.ClientId = C.ClientId AND C.CurrentEpisodeNumber = CE.EpisodeNumber
			INNER JOIN CustomInquiries CI ON CI.ClientId = C.ClientId 
		WHERE CI.InquiryId = @inquiryId
		-----------------------------------------------

	/* 1. Insert Row in ClientContract for Inquirer
	   2. Insert Row in Client Contract for Emergency contract.
	   3. If Client CustomInquiries.ClientCanLegalySign = 'N' then enter row in client contracts for Guardian 
			Whether user has selected any other relaship in the popup dropdown
	*/

	-- 1. Insert Row in ClientContract for Inquirer
	SELECT @ClientContactId = ClientContactId
	FROM ClientContacts WHERE ClientId = @ClientId AND isnull(RecordDeleted,'N') = 'N' 
		AND (
				([FirstName] = @InquirerFirstName And LastName = @InquirerLastName)  
			OR 
				([FirstName] = @InquirerFirstName And Relationship = @InquirerRelationToMember)  
			OR
				([LastName] = @InquirerLastName And Relationship = @InquirerRelationToMember)  
			OR 
				Relationship = @InquirerRelationToMember
		)

	IF ISNULL(@ClientContactId,0) >0 AND isnull(@InquirerRelationToMember,0) <> 6781 and @InquirerRelationToMember >0
		BEGIN -- Update Existing record
			UPDATE ClientContacts 
				SET ListAs = isnull(@InquirerLastName,'') + ', ' + isnull(@InquirerFirstName,'')
				, FirstName = isnull(@InquirerFirstName,'')
				, LastName = Isnull(@InquirerLastName,'')
				, Email = @InquirerEmail
				, Guardian = @GuardianSameAsCaller
				, Relationship = @InquirerRelationToMember
				, [LastNameSoundex] = SOUNDEX(@InquirerLastName)
				, [FirstNameSoundex] = SOUNDEX(@InquirerFirstName)	
				, ModifiedBy = 	@CurrentUser
				, ModifiedDate = getdate()
				, [EmergencyContact] = isnull(@EmergencyContactSameAsCaller,'N') 
			WHERE ClientContactId = @ClientContactId
		END
	ELSE IF ISNULL(@InquirerRelationToMember,0) <> 6781 and @InquirerRelationToMember >0 -- Insert new record
		BEGIN
			INSERT INTO [ClientContacts]
			(	[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate]
				,[ListAs]
				,[ClientId]
				,[Relationship]
				,[FirstName]
				,[LastName]
				,[FinanciallyResponsible]
				,[Guardian]
				,[EmergencyContact]
				,[LastNameSoundex]
				,[FirstNameSoundex]
				,Email 
			)
			Values(
				@CurrentUser, GetDate(), @CurrentUser, GetDate()
				, isnull(@InquirerLastName,'') + ', ' + isnull(@InquirerFirstName,'')
				, @ClientId
				, @InquirerRelationToMember
				, isnull(@InquirerFirstName,'')
				, Isnull(@InquirerLastName,'') 
				, 'N' 
				, @GuardianSameAsCaller
				, ISNULL(@EmergencyContactSameAsCaller,'N') 
				, SOUNDEX(@InquirerLastName)  
				, SOUNDEX(@InquirerFirstName) 
				, @InquirerEmail
			)
			SELECT @ClientContactId = @@identity 
		END

				-- 30 = Home Phone
				-- 31 = Business
				-- 34 = Mobile
				-- 38 = Other
	IF ( isnull(@InquirerPhone,'') <> '' and @ClientContactId >0 )--isnull(@EmergencyContactSameAsCaller,'N')  = 'Y')
		BEGIN
			IF EXISTS (SELECT 1  FROM ClientContactPhones Where ClientContactId =  @ClientContactId AND PhoneType = 30)
			BEGIN
				Update ClientContactPhones 
				SET PhoneNumber = @InquirerPhone 
					, PhoneNumberText = dbo.[csf_PhoneNumberStripped](@InquirerPhone)
					, ModifiedBy = 	@CurrentUser
					, ModifiedDate = getdate()					
				Where ClientContactId =  @ClientContactId AND PhoneType = 30
			END
			ELSE
			BEGIN
				INSERT INTO ClientContactPhones
					([CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate], ClientContactId, PhoneNumber, PhoneNumberText, PhoneType )
				VALUES (@CurrentUser, GetDate(), @CurrentUser, GetDate() , @ClientContactId, @InquirerPhone, dbo.[csf_PhoneNumberStripped](@InquirerPhone), 30)
			END
		END
	/*******************************************************************************************************/

	
	-- 2. Insert Row in Client Contract for Emergency contract.
	IF ISNULL(@EmergencyContactSameAsCaller,'N') = 'N'
	BEGIN
		--print 'in For Emergency'
		SET @EmergencyClientContactId = NULL
		SELECT @EmergencyClientContactId = ClientContactId
		FROM ClientContacts WHERE ClientId = @ClientId AND isnull(RecordDeleted,'N') = 'N' 
			AND (
					([FirstName] = @EmergencyContactFirstName And LastName = @EmergencyContactLastName)  
				OR 
					([FirstName] = @EmergencyContactFirstName And Relationship = @EmergencyContactRelationToClient)  
				OR
					([LastName] = @EmergencyContactLastName And Relationship = @EmergencyContactRelationToClient)  
				OR 
					Relationship = @EmergencyContactRelationToClient
			)

		IF ISNULL(@EmergencyClientContactId,0) >0 and @EmergencyContactRelationToClient >0
			BEGIN -- Update Existing record
				UPDATE ClientContacts 
				SET ListAs = isnull(@EmergencyContactLastName,'') + ', ' + isnull(@EmergencyContactFirstName,'')
					, FirstName = isnull(@EmergencyContactFirstName,'')
					, LastName = Isnull(@EmergencyContactLastName,'')
					, Relationship = @EmergencyContactRelationToClient 
					, [LastNameSoundex] = SOUNDEX(@EmergencyContactLastName)
					, [FirstNameSoundex] = SOUNDEX(@EmergencyContactFirstName)	
					, [EmergencyContact] = 'Y'
					, ModifiedBy = 	@CurrentUser
					, ModifiedDate = getdate()
				WHERE ClientContactId = @EmergencyClientContactId
			END
		ELSE IF @EmergencyContactRelationToClient >0 -- Insert new record
			BEGIN
				INSERT INTO [ClientContacts]
					([CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate]
					,[ListAs],[ClientId],[Relationship],[FirstName],[LastName],[FinanciallyResponsible]
					,[Guardian],[EmergencyContact],[LastNameSoundex],[FirstNameSoundex]
				)
				VALUES(
					@CurrentUser, GetDate(), @CurrentUser, GetDate()
					, isnull(@EmergencyContactLastName,'') + ', ' + isnull(@EmergencyContactFirstName,'')
					, @ClientId , @EmergencyContactRelationToClient 
					, isnull(@EmergencyContactFirstName,''), Isnull(@EmergencyContactLastName,'') 
					, 'N' , 'N' , 'Y' --@EmergencyContactSameAsCaller 
					, SOUNDEX(@EmergencyContactLastName) , SOUNDEX(@EmergencyContactFirstName) 
				)
				SELECT @EmergencyClientContactId = @@identity 
			END	
	END --IF @EmergencyContactSameAsCaller = 'N'
	
	-- If Emergency Contact is same caller then 
	IF ISNULL(@EmergencyContactSameAsCaller,'N') = 'Y'
	BEGIN
		SET @EmergencyClientContactId = @ClientContactId
	END
	
	IF @EmergencyClientContactId > 0 AND (isnull(@EmergencyContactHomePhone,'') <> '' or isnull(@EmergencyContactCellPhone,'') <> '')
		BEGIN
			
			---- Update Home Phone -----
			IF isnull(@EmergencyContactHomePhone,'') <> ''
				BEGIN
					IF EXISTS (SELECT 1  FROM ClientContactPhones Where ClientContactId =  @EmergencyClientContactId AND PhoneType = 30)
					BEGIN
						Update ClientContactPhones 
						SET PhoneNumber = isnull(@EmergencyContactHomePhone,'') 
							, PhoneNumberText = dbo.[csf_PhoneNumberStripped](isnull(@EmergencyContactHomePhone,'') )
							, ModifiedBy = 	@CurrentUser
							, ModifiedDate = getdate()							
						Where ClientContactId =  @EmergencyClientContactId AND PhoneType = 30
					END
					ELSE
					BEGIN
						INSERT INTO ClientContactPhones
							([CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate], ClientContactId, PhoneNumber, PhoneNumberText, PhoneType )
						VALUES (@CurrentUser, GetDate(), @CurrentUser, GetDate() ,@EmergencyClientContactId, isnull(@EmergencyContactHomePhone,'') , dbo.[csf_PhoneNumberStripped](isnull(@EmergencyContactHomePhone,'') ), 30)
					END	
				END

			IF (isnull(@EmergencyContactCellPhone,'') <> '') 
				BEGIN
					---- Update Cell Phone ---------------
					IF EXISTS (SELECT 1  FROM ClientContactPhones Where ClientContactId =  @EmergencyClientContactId AND PhoneType = 34)
					BEGIN
						Update ClientContactPhones 
						SET PhoneNumber = @EmergencyContactCellPhone 
							, PhoneNumberText = dbo.[csf_PhoneNumberStripped](@EmergencyContactCellPhone)
							, ModifiedBy = 	@CurrentUser
							, ModifiedDate = getdate()							
						Where ClientContactId =  @EmergencyClientContactId AND PhoneType = 34
					END
					ELSE
					BEGIN
						INSERT INTO ClientContactPhones
							([CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],ClientContactId, PhoneNumber, PhoneNumberText, PhoneType )
						VALUES (@CurrentUser, GetDate(), @CurrentUser, GetDate() ,@EmergencyClientContactId
							, @EmergencyContactCellPhone, dbo.[csf_PhoneNumberStripped](@EmergencyContactCellPhone), 34)
					END	
				END
			-- 34
		END
	---- End of  "2. Insert Row in Client Contract for Emergency contract" --------
	
	DECLARE @ClientContactIdNew INT
	Set @ClientContactIdNew = (select ClientContactId FROM ClientContacts Where ClientId = @ClientId AND [Guardian] = 'N' AND Isnull(RecordDeleted,'N') = 'N' and FirstName = isnull(@GuardianFirstName,'') and LastName = Isnull(@GuardianLastName,''))
	SET @ClientContactId = 0	
	Select @ClientContactId = ClientContactId FROM ClientContacts Where ClientId = @ClientId AND [Guardian] = 'Y' AND Isnull(RecordDeleted,'N') = 'N'
	-- 3. If Client CustomInquiries.ClientCanLegalySign = 'N' then enter row in client contracts for Guardian 
	--		Whether user has selected any other relaship in the popup dropdown
	IF @GuardianSameAsCaller = 'N'  
  AND EXISTS (  
   SELECT 1  
   FROM CustomInquiries  
   WHERE ClientID = @ClientId  
    AND InquiryId = @InquiryId  
    AND ClientCanLegalySign = 'N'  
   )  
  AND (  
   @GuardianFirstName <> ''  
   OR @GuardianLastName <> ''  
   )  
 BEGIN  
  SELECT @ClientContactId = ClientContactId  
  FROM ClientContacts  
  WHERE ClientId = @ClientId  
   AND isnull([Guardian],'N') = 'N'  
   AND Isnull(RecordDeleted, 'N') = 'N'  
   AND FirstName = @GuardianFirstName  
   AND LastName = @GuardianLastName  
  IF @GuardianRelation > 0  
   AND EXISTS (  
    SELECT 1  
    FROM ClientContacts  
    WHERE FirstName = @GuardianFirstName  
     AND LastName = @GuardianLastName 
	 AND isnull([Guardian],'N') = 'N' 
     AND Isnull(RecordDeleted, 'N') = 'N'  
     AND ClientId = @ClientId  
    )  
  BEGIN  
  UPDATE [ClientContacts]  
   SET 
   Relationship =@GuardianRelation
    ,[Guardian] = 'Y'  
    ,ModifiedBy = @CurrentUser  
    ,ModifiedDate = getdate()  
   WHERE ClientContactId = @ClientContactId 
  END 
  ELSE 
   --print 'Insert Guardian'  
   INSERT INTO [ClientContacts] (  
    [CreatedBy]  
    ,[CreatedDate]  
    ,[ModifiedBy]  
    ,[ModifiedDate]  
    ,[ListAs]  
    ,[ClientId]  
    ,[Relationship]  
    ,[FirstName]  
    ,[LastName]  
    ,[FinanciallyResponsible]  
    ,[DOB]  
    ,[Guardian]  
    ,[EmergencyContact]  
    ,[Comment]  
    ,[LastNameSoundex]  
    ,[FirstNameSoundex]  
    )  
   VALUES (  
    @CurrentUser  
    ,GetDate()  
    ,@CurrentUser  
    ,GetDate()  
    ,isnull(@GuardianLastName, '') + ', ' + isnull(@GuardianFirstName, '')  
    ,@ClientId  
    ,@GuardianRelation  
    -- As Discussed with David on March 19, The Guardian Information should be updated with Guardian = 'Y' in Client contacts table.  
    ,isnull(@GuardianFirstName, '')  
    ,Isnull(@GuardianLastName, '')  
    ,'N'  
    ,@GuardianDOB  
    ,'Y' --CASE WHEN @GuardianRelation = 10060 THEN 'Y' ELSE 'N' END   
    ,'N' -- As this is guardian information so this field will have 'N' value.  --ISNULL(EmergencyContactSameAsCaller,'N')   
    ,@GardianComment  
    ,SOUNDEX(@GuardianLastName)  
    ,SOUNDEX(@GuardianFirstName)  
    )  
  
   SET @ClientContactId = @@identity  
  END   
 END  
  
 IF isnull(@GuardianPhoneNumber, '') <> ''  
  AND @ClientContactId > 0  
 BEGIN  
  ---- Update Home Phone -----  
  IF EXISTS (  
    SELECT 1  
    FROM ClientContactPhones  
    WHERE ClientContactId = @ClientContactId  
     AND PhoneType = 30  
    )  
  BEGIN  
   UPDATE ClientContactPhones  
   SET PhoneNumber = @GuardianPhoneNumber  
    ,PhoneNumberText = dbo.[csf_PhoneNumberStripped](@GuardianPhoneNumber)  
    ,ModifiedBy = @CurrentUser  
    ,ModifiedDate = getdate()  
   WHERE ClientContactId = @ClientContactId  
    AND PhoneType = 30  
  END  
  ELSE  
  BEGIN  
   INSERT INTO ClientContactPhones (  
    [CreatedBy]  
    ,[CreatedDate]  
    ,[ModifiedBy]  
    ,[ModifiedDate]  
    ,ClientContactId  
    ,PhoneNumber  
    ,PhoneNumberText  
    ,PhoneType  
    )  
   VALUES (  
    @CurrentUser  
    ,GetDate()  
    ,@CurrentUser  
    ,GetDate()  
    ,@ClientContactId  
    ,@GuardianPhoneNumber  
    ,dbo.[csf_PhoneNumberStripped](@GuardianPhoneNumber)  
    ,30  
    )  
  END  
 END
GO


