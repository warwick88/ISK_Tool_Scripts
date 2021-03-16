/****** Object:  StoredProcedure [dbo].[csp_PostUpdateInquiry]    Script Date: 02/12/2018 10:00:28 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PostUpdateInquiry]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PostUpdateInquiry]
GO


/****** Object:  StoredProcedure [dbo].[csp_PostUpdateInquiry]    Script Date: 02/12/2018 10:00:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
    
    
    
CREATE PROCEDURE [dbo].[csp_PostUpdateInquiry] 
 @ScreenKeyId INT,    
 @StaffId INT,    
 @CurrentUser VARCHAR(30),    
 @CustomParameters XML    
    
/************************************************************************************************                            
**  File:                                               
**  Name: csp_PostUpdateInquiry                                              
**  Desc: This storeProcedure will executed on post update of Inquiry     
**    
**  Parameters:     
**  Input   @ScreenKeyId INT,    
 @StaffId INT,    
 @CurrentUser VARCHAR(30),    
 @CustomParameters XML     
**  Output     ----------       -----------     
**      
**  Auth:  Pralyankar Kumar Singh    
**  Date:  Jan 4, 2012    
*************************************************************************************************    
**  Change History      
*************************************************************************************************     
**  Date:   Author:   Description:     
**  --------  --------  -------------------------------------------------------------    
** Jan 4, 2012  Pralyankar  Created.    
**  23 Jan 2012  Sudhir Singh updated for column [SSNUnknown]    
**  3 FEB 2012  Sudhir Singh    UPDATE THE GLOBALCODES IN PCM    
** March 18, 2012 Pralyankar  Modified to call sp for updating Client Contacts for inquiry.    
** March 21, 2012 Pralyankar  Modified messages for inquiry.    
** April 4, 2012 Pralyankar  Modified for Getting UserCode from CM Database.    
** April 20, 2012 Pralyankar  Modified for pulling staff ID from StaffDatabaseAccess table.  
** July  01, 2015 Pradeep Kumar Yadav  The Logic populates the Custom Field (Assigned Population ) from Inquiry (Presenting Population) turned off in 3x  
                                       For task KCMHSAS-Support #318(06-Sep-2013) I merged same 3x logic in our 3.5 Environment for KCMHSAS-Support #308  
** February 12, 2018 Mraymond  Removed validation for finding staff in CM database per MCO upgrade. KCMHSAS - Support Task 971                                            
*************************************************************************************************/    
AS    
    
BEGIN    
    
 ------ Get ID of System Database ------    
 DECLARE @CurrentDatabaseDatabaseId INT    
 SELECT @CurrentDatabaseDatabaseId = SystemDatabaseId    
 FROM  SystemConfigurations    
 ----------------------------------------    
    
 DECLARE @ClientID INT, @CareManagementId INT, @InquiryEventId INT, @InProgressStatusClientID INT    
  , @FirstName VARCHAR(50),@LastName VARCHAR(50), @DOB datetime, @SSN VARCHAR(15) ,@AssignedPopulation INT    
  , @PreviousCareManagementId INT, @MasterStaffId INT, @MasterStaffUserCode Varchar(100)    
  , @GatheredBy INT, @RecordedBy INT, @AssignedToStaffId INT    
      
 DECLARE @DynamicQuery  NVARCHAR(4000)    
 DECLARE @UpdateClientContacts CHAR(1)    
    
 DECLARE @ValidationErrors table (    
  TableName       varchar(200),    
  ColumnName      varchar(200),    
  ErrorMessage    varchar(2000),    
  PageIndex       int,            
  TabOrder       int,            
  ValidationOrder int    
 )      
    
BEGIN TRY    
 set nocount on      
    
 /*  >>--------> Get PCM Master DB Name <--------<<   */    
 DECLARE  @DBName VARCHAR(50)     
 SET @DBName = [dbo].[fn_GetPCMMasterDBName]()    
 -- >>>>>>>------------------------------------------------------->    
 SET @UpdateClientContacts = 'N'    
    
 ---- Get Custom Globalcode ID for Inquiry Status Completed ----    
 DECLARE @CompletedGlobalCodeId INT    
 SELECT @CompletedGlobalCodeId = GlobalCodeId     
 FROM GlobalCodes     
 WHERE Category = 'XINQUIRYSTATUS' AND Code = 'COMPLETE'      
 ---------------------------------------------------------------    
    
 SELECT @InProgressStatusClientID = ClientId, @AssignedPopulation = PresentingPopulation     
  , @GatheredBy = GatheredBy, @RecordedBy = RecordedBy, @AssignedToStaffId = AssignedToStaffId    
 FROM custominquiries    
 WHERE InquiryId = @ScreenKeyId  AND isnull(RecordDeleted,'N') = 'N'    
    
    
 ---- IF Status is Not Complete then do not create Event --------    
 IF EXISTS(SELECT 1 FROM custominquiries WHERE InquiryId = @ScreenKeyId  and isnull(RecordDeleted,'N') = 'N' AND InquiryStatus = @CompletedGlobalCodeId )-- Inquiry Status Completed    
 BEGIN    
  SELECT @ClientID = ClientId, @InquiryEventId = InquiryEventId, @AssignedPopulation = PresentingPopulation    
  FROM custominquiries     
  WHERE InquiryId = @ScreenKeyId  and isnull(RecordDeleted,'N') = 'N'    
 END-- IF EXISTS(SELECT 1 FROM custominquiries WHERE InquiryId = @ScreenKeyId  and isnull(RecordDeleted,'N') = 'N' AND InquiryStatus = @CompletedGlobalCodeId )    
 -- If Client ID is greater than zero then update Client Infromation In Clients(Clients, ClientContact, ClientContactPhones, clientepisodes) table    
 -- Update Client Contacts only if Inquiry is not completed. Here "isnull(@InquiryEventId,0) = 0" is used for checking this condition.    
 PRINT ISNULL(@inquiryEventId,0)    
 IF isnull(@InProgressStatusClientID,0) >0 AND isnull(@InquiryEventId,0) = 0    
 BEGIN    
  EXEC csp_scUpdateInquiryClientContacts @ScreenKeyId, @InProgressStatusClientID, @CurrentUser    
  SET @UpdateClientContacts = 'Y'    
 END    
 -----------------------------------------------------------    
  SELECT @ClientID = ClientId   
  FROM custominquiries     
  WHERE InquiryId = @ScreenKeyId  and isnull(RecordDeleted,'N') = 'N' 
    DECLARE @address varchar(50)
	set @address = (select Address1 from CustomInquiries where InquiryId= @ScreenKeyId)
 If @address is not null 
 Begin 
 if not exists(select 1 from ClientAddresses where clientid=@ClientId and AddressType=90)
 Begin
 INSERT INTO ClientAddresses (ClientId,[Address],City,[State],Zip,ModifiedDate,ModifiedBy,AddressType)
 select @ClientId,Address1,City,State,ZipCode,getdate(),@StaffId,90
 from CustomInquiries where InquiryId= @ScreenKeyId
 End
 END
 DECLARE @phone varchar(50)
 set @phone = (select MemberPhone from CustomInquiries where InquiryId= @ScreenKeyId)
 If @phone is not null 
 Begin 
 if not exists(select 1 from ClientPhones where clientid=@ClientId and PhoneType=30)
 Begin
 INSERT INTO ClientPhones (ClientId,PhoneType,PhoneNumber,PhoneNumberText,IsPrimary,DoNotContact,DoNotLeaveMessage)
 select @ClientId,30,@phone,dbo.[csf_PhoneNumberStripped](@phone),'Y',null,null
 from CustomInquiries where InquiryId= @ScreenKeyId
 End
 ELSE BEGIN
    update ClientPhones set PhoneNumber=@phone,PhoneNumberText=dbo.[csf_PhoneNumberStripped](@phone),RecordDeleted='N'
	where clientid=@ClientId and PhoneType=30
 END
 END

  DECLARE @mobile varchar(50)
 set @mobile = (select MemberCell from CustomInquiries where InquiryId= @ScreenKeyId)
 If @mobile is not null 
 Begin 
 if not exists(select 1 from ClientPhones where clientid=@ClientId and PhoneType=34)
 Begin
 INSERT INTO ClientPhones (ClientId,PhoneType,PhoneNumber,PhoneNumberText,IsPrimary,DoNotContact,DoNotLeaveMessage)
 select @ClientId,34,@mobile,dbo.[csf_PhoneNumberStripped](@mobile),'N',null,null
 from CustomInquiries where InquiryId= @ScreenKeyId
 End
 ELSE BEGIN
    update ClientPhones set PhoneNumber=@mobile,PhoneNumberText=dbo.[csf_PhoneNumberStripped](@mobile) ,RecordDeleted='N'
	where clientid=@ClientId and PhoneType=34
 END
 END     
 --------------------------------------------ClientCoveragePlans---------------------------------
 DECLARE @InquiryStartDate DATETIME  
  UPDATE  CCP          
            SET     CCP.GroupNumber = CI.GroupId ,          
                    CCP.InsuredId = CI.InsuredId ,
					CCP.Comment = CI.Comment         
            FROM    ClientCoveragePlans CCP          
                    INNER JOIN CustomInquiryCoverageInformations CI ON CI.CoveragePlanId = CCP.CoveragePlanId          
                                                                         AND CI.InquiryId = @ScreenKeyId          
                    JOIN dbo.CustomInquiries inq ON inq.InquiryId = CI.InquiryId          
                                                    AND inq.ClientId = CCP.ClientId          
                                                                                          
            IF EXISTS ( SELECT  *          
                        FROM    CustomInquiryCoverageInformations          
                        WHERE   InquiryId = @ScreenKeyId )          
                BEGIN          
                    SELECT  @ClientID = ClientId ,          
                            @InquiryStartDate = InquiryStartDateTime          
                    FROM    CustomInquiries          
                    WHERE   InquiryId = @ScreenKeyId          
                            AND ISNULL(RecordDeleted, 'N') = 'N'          
                                              
                    INSERT  INTO ClientCoveragePlans          
                            ( ClientId ,          
                              CoveragePlanId ,          
                              InsuredId ,          
                              GroupNumber ,          
                              ClientIsSubscriber ,          
                              ClientHasMonthlyDeductible ,          
                              ModifiedDate ,
							  Comment         
                            )          
                            SELECT  @ClientID AS ClientId ,          
                                    CoveragePlanId ,          
                                    InsuredId ,          
                                    GroupId AS GroupNumber,          
                                    'N' AS ClientIsSubscriber,          
                                    'N' AS ClientHasMonthlyDeductible,          
                                    ModifiedDate  ,
									Comment        
                            FROM    CustomInquiryCoverageInformations CI          
                            WHERE   CI.InquiryId = @ScreenKeyId  AND ISNULL(CI.RecordDeleted, 'N') = 'N'         
                                    AND NOT EXISTS ( SELECT *          
                                                     FROM   ClientCoveragePlans CC          
                                                     WHERE  cc.ClientId = @ClientID          
                                                            AND CC.CoveragePlanId = CI.CoveragePlanId          
                                                            AND CC.InsuredId = CI.InsuredId 
                                                            AND ISNULL(CC.RecordDeleted, 'N') = 'N')          
                END          
            --DECLARE @InsuranceComment VARCHAR(100)          
            SET @ClientID = ( SELECT    ClientId          
                              FROM      CustomInquiries          
                              WHERE     InquiryId = @ScreenKeyId          
                            )             
  
	  IF EXISTS ( SELECT  1 FROM ClientCoveragePlanNotes CC          
							JOIN CustomInquiries CI ON CC.ClientId = CI.ClientId AND CI.InquiryId = @ScreenKeyId 
							Where ISNULL(CC.RecordDeleted, 'N') = 'N' And ISNULL(CI.RecordDeleted, 'N') = 'N')
							
			BEGIN
					UPDATE  CC SET CC.CoverageInformation = CI.CoverageInformation
							FROM ClientCoveragePlanNotes CC          
							JOIN CustomInquiries CI ON CC.ClientId = CI.ClientId AND CI.InquiryId = @ScreenKeyId
							Where ISNULL(CC.RecordDeleted, 'N') = 'N' And ISNULL(CI.RecordDeleted, 'N') = 'N'
			END
		ELSE
			BEGIN
					INSERT  INTO ClientCoveragePlanNotes          
								( ClientId ,          
								  CoverageInformation    
								)          
							SELECT  ClientId ,          
									CoverageInformation       
							FROM    CustomInquiries           
							WHERE   InquiryId = @ScreenKeyId And ISNULL(RecordDeleted, 'N') = 'N'
			END
			
			
	-- Inserting Flag details
		DECLARE @FlagTypeId int 
		SET @FlagTypeId = (SELECT Top 1 FlagTypeId FROM dbo.FlagTypes WHERE FlagType = 'Client Plan Coverage Information')

		IF NOT EXISTS(SELECT 1 FROM dbo.ClientNotes b
									Inner Join dbo.CustomInquiries a on b.ClientId = a.ClientId AND  b.StartDate = a.InquiryStartDateTime
									AND a.InquiryId = @ScreenKeyId --AND a.CoverageInformation IS NOT NULL
									WHERE b.NoteType = @FlagTypeId
									  AND ISNULL(b.RecordDeleted, 'N') = 'N')
		BEGIN
		
			INSERT INTO ClientNotes (ClientId,
									NoteType,
									NoteLevel,
									Note,
									Active,
									StartDate,
									CreatedBy,
									ModifiedBy)
							SELECT
								a.ClientId,
								@FlagTypeId,
								4501,
								SUBSTRING(a.CoverageInformation,1,100),
								'Y',
								a.InquiryStartDateTime,
								@CurrentUser,
								@CurrentUser
							  FROM dbo.CustomInquiries a
							  WHERE a.InquiryId = @ScreenKeyId AND a.CoverageInformation IS NOT NULL
		END
		ELSE
		BEGIN
		
				DECLARE @ModifiedDate datetime
				DECLARE @Note varchar(100)
				--DECLARE @ClientId int
				DECLARE @ClientNoteStartDate datetime
				
				SET @ModifiedDate = GetDate();
				
				Select top 1 @Note = SUBSTRING(a.CoverageInformation,1,100), @ClientId = a.ClientId, @ClientNoteStartDate = b.StartDate
					FROM dbo.ClientNotes b
					Inner Join dbo.CustomInquiries a on b.ClientId = a.ClientId AND  b.StartDate = a.InquiryStartDateTime
					AND a.InquiryId = @ScreenKeyId --AND a.CoverageInformation IS NOT NULL
					WHERE b.NoteType = @FlagTypeId AND ISNULL(b.RecordDeleted, 'N') = 'N'
		

			    Update  ClientNotes  
				Set  ModifiedDate = GetDate(), ModifiedBy = @CurrentUser, Note = @Note
				Where  ClientId = @ClientId AND  StartDate = @ClientNoteStartDate
				AND NoteType = @FlagTypeId
		END
			

 ---------------------------------------------------------------------------------------------------


 -- Check If @InquiryEventId >0 then Delete the InquiryEvent From CM/PA Database    
 IF (ISNULL(@InProgressStatusClientID,0) = 0 AND @InquiryEventId >0)    
  BEGIN    
   EXEC csp_scRemoveInquiryClient @ScreenKeyId, @StaffId, @CurrentUser    
   Return ---- If Client ID is null in CustomInquiries table then return from the SP    
  END    
 ELSE IF (ISNULL(@ClientID,0) = 0 AND isnull(@InquiryEventId,0) = 0)    
  BEGIN    
   Return ---- If Client ID is null in CustomInquiries table then return from the SP    
  END    
    
 ELSE IF (ISNULL(@ClientID,0) > 0 AND isnull(@InquiryEventId,0) > 0)    
  BEGIN    
   ---------------- Get Previous CareManagementId  ------------    
   SET @DynamicQuery = 'SELECT @PreviousCareManagementId = ClientId FROM [' + @DBName + '].[dbo].[Events] WHERE EventId = ' + cast(@InquiryEventId as VARCHAR(10))    
   EXEC sp_executesql @DynamicQuery, N'@PreviousCareManagementId INT OUTPUT', @PreviousCareManagementId output    
   ------------------------------------------------------------    
  END    
    
 ------- Get User Code of Staff from CM/PA Database -------------->    commented out by mraymond, 2/12/2018 KCMHSAS Support Task 971
 --SET @DynamicQuery = 'SELECT @MasterStaffId = AccessStaffId FROM [' + @DBName + '].[dbo].[StaffDatabaseAccess] WHERE AccessfunctionalArea=5793 AND SystemDatabaseId = ' + cast(@CurrentDatabaseDatabaseId AS VARCHAR) + '  AND SystemStaffId = '
 -- + cast(@StaffId as VARCHAR(10))    
 --EXEC sp_executesql @DynamicQuery, N'@MasterStaffId INT OUTPUT', @MasterStaffId output    
    
 --SET @DynamicQuery = 'SELECT @MasterStaffUserCode = UserCode FROM [' + @DBName + '].[dbo].[Staff] WHERE StaffId = ' + cast(@MasterStaffId as VARCHAR(10))    
 --EXEC sp_executesql @DynamicQuery, N'@MasterStaffUserCode VARCHAR(100) OUTPUT', @MasterStaffUserCode output    
    
 --IF (isnull(@MasterStaffUserCode,'') = '')    
 --BEGIN    
 -- ---- Delete existing record and insert new row for expected error----    
 -- Delete FROM @ValidationErrors    
 -- insert into @ValidationErrors (TableName, ColumnName, ErrorMessage)            
 -- select 'StaffDatabaseAccess', 'StaffId', 'This inquiry is unable to be completed because the information needed for Staff does not exist in the CareManagement system.  Please contact Technical Support to correct this problem.  Thank you'      
 -- -------------------------------------------------------------    
 -- GOTO error    
 --END    
 ------------------------------------------------------------------<    
    
 IF LTRIM(RTRIM(ISNULL(@InProgressStatusClientID,''))) <> ''   
 --Commented By Pradeep Kumar Yadav 01-July-2015 KCMHSAS-Support #308   
 --BEGIN    
 -- --- Added by sudhir to update customfieldsdata->ColumnGlobalCode7 with 'PresentingPopulation' field for the client     
 -- IF EXISTS(SELECT 'x' FROM CustomFieldsData WHERE PrimaryKey1 = @InProgressStatusClientID AND DocumentType = 4941)      
 --  BEGIN    
 --   update CustomFieldsData set ColumnGlobalCode7 = @AssignedPopulation    
 --   WHERE PrimaryKey1 = @InProgressStatusClientID AND DocumentType = 4941    
 --  END     
 -- ELSE    
 --  BEGIN    
 --   INSERT INTO CustomFieldsData(DocumentType, PrimaryKey1, PrimaryKey2, ColumnGlobalCode7)    
 --   VALUES(4941,@InProgressStatusClientID, 0, @AssignedPopulation)    
 --  END     
 --END    
    
 ---- Delete existing record and insert new row for expected error----      commented out by mraymond, 2/12/2018 KCMHSAS Support Task 971 
 --Delete FROM @ValidationErrors    
 --insert into @ValidationErrors (TableName, ColumnName, ErrorMessage)            
 --select 'Clients', 'Unknown', 'This inquiry is unable to be completed because the information needed for client does not exist in the CareManagement system.  Please contact Technical Support to correct this problem.  Thank you'      
 ---------------------------------------------------------------------    
    
 --- Create master client -----    
 EXEC ssp_CreateMasterClient @MasterStaffUserCode, @ClientId, @CareManagementId OUTPUT    
 ------------------------------------------    
 ----------- Update CamemanagementId --------------------    
 IF (@CareManagementId >0)    
  BEGIN    
   Update Clients Set CareManagementId = @CareManagementId     
   Where CLientId = @ClientId    
  END    
 --------------------------------------------------------    
    
     
 -- If User has Chnages the Client from the page then remove the Previous Document/Event And create new .    
 IF (@CareManagementId <> @PreviousCareManagementId AND isnull(@InquiryEventId,0) > 0)    
  BEGIN    
   EXEC csp_scRemoveInquiryClient  @ScreenKeyId, @StaffId, @MasterStaffUserCode    
  END    
 -------------------------------------------------------------------------------------------    
    
    
 ---- Execute dynamic query for creating InquiryEvent ----    
 DECLARE @CurrentDBName VARCHAR(50), @NewEventId INT, @NewDocumentVersionID INT    
 SELECT @CurrentDBName = DB_NAME()    
    
 IF @CareManagementId >0    
  BEGIN    
   ---- As Out Parameter is not working in Dynamic Query so we have used Temp table for getting return valued from the caling procedure. ----    
   Create Table #ReturnValues    
   (    
    EventId INT,    
    DocumentVersionId INT    
   )    
   ---- Delete existing record and insert new row for expected error----    commented out by mraymond, 2/12/2018 KCMHSAS Support Task 971
   --Delete FROM @ValidationErrors    
   --insert into @ValidationErrors (TableName, ColumnName, ErrorMessage)            
   --select 'Events', 'Unknown', 'This inquiry is unable to be completed because the information needed for event document does not exist in the CareManagement system.  Please contact Technical Support to correct this problem.  Thank you'      
   -----------------------------------------------------------------     
   SET @DynamicQuery = ' [' + @DBName + '].[dbo].csp_scCreateEvent '    
    + cast(@MasterStaffId as varchar(10)) + ','''    
    + @MasterStaffUserCode + ''','    
    + cast(isnull(@CareManagementId,0) as varchar(10)) + ','     
    + cast(isnull(@InquiryEventId,0) as varchar(10))     
    + ', 10350, 22'--, @NewEventId OUTPUT, @NewDocumentVersionID OUTPUT ' --   22= Document Status Completed    
    
   INSERT INTO #ReturnValues    
   EXEC sp_executesql @DynamicQuery    
    
   SELECT @NewEventId = EventId, @NewDocumentVersionID = DocumentVersionID FROM #ReturnValues    
   ---- Update EventID in CustomInquiries table -----    
   UPDATE [custominquiries] SET InquiryEventId = @NewEventId  Where InquiryId = @ScreenKeyId     
   ----------------------------------------------------------------    
  END    
 -----------------------------    
    
 ---------- Get global codes from pcm ----------------------    
 DECLARE @UrgencyLevelCategory VARCHAR(20)  ,@UrgencyLevelCode VARCHAR(100)   , @UrgencyLevel INT    
  , @InquiryTypeCategory VARCHAR(20)   ,@InquiryTypeCode VARCHAR(100)   , @InquiryType INT    
  , @ContactTypeCategory VARCHAR(20)   ,@ContactTypeCode VARCHAR(100)   , @ContactType INT    
  , @SATypeCategory VARCHAR(20)    ,@SATypeCode VARCHAR(100)    , @SAType INT    
  , @PresentingPopulationCategory VARCHAR(20) ,@PresentingPopulationCode VARCHAR(100)  , @PresentingPopulation INT    
  , @ReferralTypeCategory VARCHAR(20)   ,@ReferralTypeCode VARCHAR(100)   , @ReferralType INT    
  , @ReferralSubtypeCategory VARCHAR(20)  ,@ReferralSubtypeCode VARCHAR(100)  , @ReferralSubtype INT    
  , @LivingCategory VARCHAR(20)    ,@LivingCode VARCHAR(100)     , @Living INT    
  , @NoOfBedsCategory VARCHAR(20)    ,@NoOfBedsCode VARCHAR(100)     , @NoOfBeds INT    
  , @CorrectionStatusCategory VARCHAR(20)  ,@CorrectionStatusCode VARCHAR(100)   , @CorrectionStatus INT    
  , @EducationalStatusCategory VARCHAR(20) ,@EducationalStatusCode VARCHAR(100)  , @EducationalStatus INT    
  , @EmploymentStatusCategory VARCHAR(20)  ,@EmploymentStatusCode VARCHAR(100)   , @EmploymentStatus INT    
      
  , @GuardianRelationCategory VARCHAR(20)  ,@GuardianRelationCode VARCHAR(100)   , @GuardianRelation INT    
  , @InquirerRelationToMemberCategory VARCHAR(20) ,@InquirerRelationToMemberCode VARCHAR(100) , @InquirerRelationToMember INT    
  , @EmergencyContactRelationToClientCategory VARCHAR(20) ,@EmergencyContactRelationToClientCode VARCHAR(100) , @EmergencyContactRelationToClient INT    
    
 SELECT @UrgencyLevelCategory = ISNULL(ULC.Category,''), @UrgencyLevelCode =  ISNULL(ULC.Code,'')     
  , @InquiryTypeCategory = ISNULL(ITC.Category,''), @InquiryTypeCode =  ISNULL(ITC.Code,'')     
  , @ContactTypeCategory = ISNULL(CTC.Category,''), @ContactTypeCode  = ISNULL(CTC.Code,'')     
  , @SATypeCategory = ISNULL(SATC.Category,''), @SATypeCode = ISNULL(SATC.Code,'')     
  , @PresentingPopulationCategory = ISNULL(PPC.Category,''), @PresentingPopulationCode = ISNULL(PPC.Code,'')     
  , @ReferralTypeCategory = ISNULL(RTC.Category,''), @ReferralTypeCode = ISNULL(RTC.Code,'')     
  , @ReferralSubtypeCategory = ISNULL(RSTC.Category,''), @ReferralSubtypeCode = ISNULL(RSTC.Code,'')     
  , @LivingCategory = ISNULL(LC.Category,''), @LivingCode = ISNULL(LC.Code,'')     
  , @NoOfBedsCategory = ISNULL(NOBC.Category,''), @NoOfBedsCode = ISNULL(NOBC.Code,'')     
  , @CorrectionStatusCategory = ISNULL(CSC.Category,''), @CorrectionStatusCode = ISNULL(CSC.Code,'')     
  , @EducationalStatusCategory = ISNULL(EdSC.Category,''), @EducationalStatusCode =ISNULL(EdSC.Code,'')     
  , @EmploymentStatusCategory = ISNULL(EpSC.Category,''), @EmploymentStatusCode = ISNULL(EpSC.Code ,'')    
    
  , @GuardianRelationCategory = ISNULL(GurdRelation.Category,''), @GuardianRelationCode = ISNULL(GurdRelation.Code ,'')    
  , @InquirerRelationToMemberCategory = ISNULL(InqRelation.Category,''), @InquirerRelationToMemberCode = ISNULL(InqRelation.Code ,'')    
  , @EmergencyContactRelationToClientCategory = ISNULL(EmrngContactRel.Category,''), @EmergencyContactRelationToClientCode = ISNULL(EmrngContactRel.Code ,'')    
    
 FROM CustomInquiries CIE    
  LEFT OUTER JOIN [dbo].[GlobalCodes] ULC ON CIE.UrgencyLevel = ULC.GlobalCodeId    
  LEFT OUTER JOIN [dbo].[GlobalCodes] ITC ON CIE.InquiryType = ITC.GlobalCodeId    
  LEFT OUTER JOIN [dbo].[GlobalCodes] CTC ON CIE.ContactType = CTC.GlobalCodeId    
  LEFT OUTER JOIN [dbo].[GlobalCodes] SATC ON CIE.SAType = SATC.GlobalCodeId    
  LEFT OUTER JOIN [dbo].[GlobalCodes] PPC ON CIE.PresentingPopulation = PPC.GlobalCodeId    
  LEFT OUTER JOIN [dbo].[GlobalCodes] RTC ON CIE.ReferralType = RTC.GlobalCodeId    
  LEFT OUTER JOIN [dbo].[GlobalCodes] RSTC ON CIE.ReferralSubtype = RSTC.GlobalCodeId    
  LEFT OUTER JOIN [dbo].[GlobalCodes] LC ON CIE.Living = LC.GlobalCodeId    
  LEFT OUTER JOIN [dbo].[GlobalCodes] NOBC ON CIE.NoOfBeds = NOBC.GlobalCodeId    
  LEFT OUTER JOIN [dbo].[GlobalCodes] CSC ON CIE.CorrectionStatus = CSC.GlobalCodeId    
  LEFT OUTER JOIN [dbo].[GlobalCodes] EdSC ON CIE.EducationalStatus = EdSC.GlobalCodeId    
  LEFT OUTER JOIN [dbo].[GlobalCodes] EpSC ON CIE.EmploymentStatus = EpSC.GlobalCodeId    
      
  LEFT OUTER JOIN [dbo].[GlobalCodes] GurdRelation ON CIE.GuardianRelation = GurdRelation.GlobalCodeId    
  LEFT OUTER JOIN [dbo].[GlobalCodes] InqRelation ON CIE.InquirerRelationToMember = InqRelation.GlobalCodeId    
  LEFT OUTER JOIN [dbo].[GlobalCodes] EmrngContactRel ON CIE.EmergencyContactRelationToClient = EmrngContactRel.GlobalCodeId    
      
  --GuardianRelation    
 WHERE CIE.InquiryId = cast(@ScreenKeyId as varchar)     
    
    
 ---- Delete existing record and insert new row for expected error----    commented out by mraymond, 2/12/2018 KCMHSAS Support Task 971
 --DELETE FROM @ValidationErrors    
 --INSERT INTO @ValidationErrors (TableName, ColumnName, ErrorMessage)            
 --SELECT 'GlobalCode', 'GlobalCodeId', 'This inquiry is unable to be completed because the information needed for Inquiry does not exist in the CareManagement system.  Please contact Technical Support to correct this problem.  Thank you'      
 -----------------------------------------------------------------     
    
 SET @DynamicQuery = 'select @UrgencyLevel = ['+@DBName+'].[dbo].[fn_GetGlobalCode]('''+@UrgencyLevelCategory+''', '''+@UrgencyLevelCode+''')'    
 EXEC sp_executesql @DynamicQuery, N'@UrgencyLevel INT output', @UrgencyLevel output    
 SET @DynamicQuery = 'select @InquiryType = ['+@DBName+'].[dbo].[fn_GetGlobalCode]('''+@InquiryTypeCategory+''', '''+@InquiryTypeCode+''')'    
 EXEC sp_executesql @DynamicQuery, N'@InquiryType INT output', @InquiryType output    
 SET @DynamicQuery = 'SELECT @ContactType = [' + @DBName + '].[dbo].[fn_GetGlobalCode](''' + @ContactTypeCategory + ''', '''+@ContactTypeCode+''')'    
 EXEC sp_executesql @DynamicQuery, N'@ContactType INT output', @ContactType output    
 SET @DynamicQuery = 'SELECT @SAType = ['+@DBName+'].[dbo].[fn_GetGlobalCode]('''+@SATypeCategory+''', '''+@SATypeCode+''')'    
 EXEC sp_executesql @DynamicQuery, N'@SAType INT output', @SAType output     
 SET @DynamicQuery = 'select @PresentingPopulation = ['+@DBName+'].[dbo].[fn_GetGlobalCode]('''+@PresentingPopulationCategory+''', '''+@PresentingPopulationCode+''')'    
 EXEC sp_executesql @DynamicQuery, N'@PresentingPopulation INT output', @PresentingPopulation output    
 SET @DynamicQuery = 'select @ReferralType = ['+@DBName+'].[dbo].[fn_GetGlobalCode]('''+@ReferralTypeCategory+''', '''+@ReferralTypeCode+''')'    
 EXEC sp_executesql @DynamicQuery, N'@ReferralType INT output', @ReferralType output    
 SET @DynamicQuery = 'select @ReferralSubtype = ['+@DBName+'].[dbo].[fn_GetGlobalCode]('''+@ReferralSubtypeCategory+''', '''+@ReferralSubtypeCode+''')'    
 EXEC sp_executesql @DynamicQuery, N'@ReferralSubtype INT output', @ReferralSubtype output    
 SET @DynamicQuery = 'select @Living = ['+@DBName+'].[dbo].[fn_GetGlobalCode]('''+@LivingCategory+''', '''+@LivingCode+''')'    
 EXEC sp_executesql @DynamicQuery, N'@Living INT output', @Living output    
 SET @DynamicQuery = 'select @NoOfBeds = ['+@DBName+'].[dbo].[fn_GetGlobalCode]('''+@NoOfBedsCategory+''', '''+@NoOfBedsCode+''')'    
 EXEC sp_executesql @DynamicQuery, N'@NoOfBeds INT output', @NoOfBeds output     
 SET @DynamicQuery = 'select @CorrectionStatus = ['+@DBName+'].[dbo].[fn_GetGlobalCode]('''+@CorrectionStatusCategory+''', '''+@CorrectionStatusCode+''')'    
 EXEC sp_executesql @DynamicQuery, N'@CorrectionStatus INT output', @CorrectionStatus output    
 SET @DynamicQuery = 'select @EducationalStatus = ['+@DBName+'].[dbo].[fn_GetGlobalCode]('''+@EducationalStatusCategory+''', '''+@EducationalStatusCode+''')'    
 EXEC sp_executesql @DynamicQuery, N'@EducationalStatus INT output', @EducationalStatus output     
 SET @DynamicQuery = 'select @EmploymentStatus = ['+@DBName+'].[dbo].[fn_GetGlobalCode]('''+@EmploymentStatusCategory+''', '''+@EmploymentStatusCode+''')'    
 EXEC sp_executesql @DynamicQuery, N'@EmploymentStatus INT OUTPUT', @EmploymentStatus output    
    
 SET @DynamicQuery = 'select @GuardianRelation = ['+@DBName+'].[dbo].[fn_GetGlobalCode]('''+@GuardianRelationCategory+''', '''+@GuardianRelationCode+''')'    
 EXEC sp_executesql @DynamicQuery, N'@GuardianRelation INT OUTPUT', @GuardianRelation output    
 SET @DynamicQuery = 'select @InquirerRelationToMember = ['+@DBName+'].[dbo].[fn_GetGlobalCode]('''+@InquirerRelationToMemberCategory+''', '''+@InquirerRelationToMemberCode+''')'    
 EXEC sp_executesql @DynamicQuery, N'@InquirerRelationToMember INT OUTPUT', @InquirerRelationToMember output    
 SET @DynamicQuery = 'select @EmergencyContactRelationToClient = ['+@DBName+'].[dbo].[fn_GetGlobalCode]('''+@EmergencyContactRelationToClientCategory+''', '''+@EmergencyContactRelationToClientCode+''')'    
 EXEC sp_executesql @DynamicQuery, N'@EmergencyContactRelationToClient INT OUTPUT', @EmergencyContactRelationToClient output    
    
    
 DECLARE @PCMProgramId INT, @ProgramId INT    
    
 SELECT @ProgramId = ProgramId FROM CustomInquiries Where inquiryId = @ScreenKeyId    
    
 ---- Delete existing record and insert new row for expected error----    commented out by mraymond, 2/12/2018 KCMHSAS Support Task 971
 --DELETE FROM @ValidationErrors    
 --INSERT INTO @ValidationErrors (TableName, ColumnName, ErrorMessage)            
 --SELECT 'Programs', 'ProgramId', 'This inquiry is unable to be completed because the information needed for program does not exist in the CareManagement system.  Please contact Technical Support to correct this problem.  Thank you'      
 -----------------------------------------------------------------     
     
 ---- Check for existance fromProgram In CM/PA Database ----------    commented out by mraymond, 2/12/2018 KCMHSAS Support Task 971
 --SET @DynamicQuery = 'SELECT @PCMProgramId = ProgramId FROM ['+@DBName+'].[dbo].[Programs] WHERE ProgramId= ' + cast(@ProgramId as VARCHAR(10))    
 --EXEC sp_executesql @DynamicQuery, N'@PCMProgramId varchar(10) output', @PCMProgramId output    
 --IF (@PCMProgramId <=0 and @ProgramId >0)    
 --BEGIN    
 -- ---- Delete existing record and insert new row for expected error----    
 -- Delete FROM @ValidationErrors    
 -- insert into @ValidationErrors (TableName, ColumnName, ErrorMessage)            
 -- select 'Programs', 'ProgramId', 'This inquiry is unable to be completed because the information needed for program does not exist in the CareManagement system.  Please contact Technical Support to correct this problem.  Thank you'      
 -- -------------------------------------------------------------    
 -- GOTO error    
 --END    
 -----------------------------------------------------------------    
    
    
 ----- Get Mapping StaffId From StaffDatabaseAccess table for Field 'GatheredBy', 'RecordDedBy' and 'AssignedToStaffId' ------    
 DECLARE @PCMGatheredBy INT, @PCMRecordedBy INT, @PCMAssignedToStaffId INT    
    
 If isnull(@GatheredBy,0) >0     
  BEGIN    
   SET @DynamicQuery = 'SELECT @PCMGatheredBy = AccessStaffId FROM [' + @DBName + '].[dbo].[StaffDatabaseAccess] WHERE AccessfunctionalArea=5793 AND SystemDatabaseId = ' + cast(@CurrentDatabaseDatabaseId AS VARCHAR) + '  AND SystemStaffId = '
    + cast(@GatheredBy as VARCHAR(10))    
   EXEC sp_executesql @DynamicQuery, N'@PCMGatheredBy INT OUTPUT', @PCMGatheredBy output    
  END    
    
 If isnull(@RecordedBy,0) >0     
  BEGIN    
   SET @DynamicQuery = 'SELECT @PCMRecordedBy = AccessStaffId FROM [' + @DBName + '].[dbo].[StaffDatabaseAccess] WHERE AccessfunctionalArea=5793 AND SystemDatabaseId = ' + cast(@CurrentDatabaseDatabaseId AS VARCHAR) + '  AND SystemStaffId = ' 
   + cast(@RecordedBy as VARCHAR(10))    
   EXEC sp_executesql @DynamicQuery, N'@PCMRecordedBy INT OUTPUT', @PCMRecordedBy output    
  END    
 If isnull(@AssignedToStaffId,0) >0    
  BEGIN    
   SET @DynamicQuery = 'SELECT @PCMAssignedToStaffId = AccessStaffId FROM [' + @DBName + '].[dbo].[StaffDatabaseAccess] 
   WHERE AccessfunctionalArea=5793 AND SystemDatabaseId = ' + cast(@CurrentDatabaseDatabaseId AS VARCHAR) + '  AND SystemStaffId = ' + 
   cast(@AssignedToStaffId as VARCHAR(10))    
   EXEC sp_executesql @DynamicQuery, N'@PCMAssignedToStaffId INT OUTPUT', @PCMAssignedToStaffId output    
  END    
    ----																	  commented out by mraymond, 2/12/2018 KCMHSAS Support Task 971
 --IF ((isnull(@GatheredBy,0) >0 and isnull(@PCMGatheredBy,0) = 0)     
 -- OR (isnull(@RecordedBy,0) >0 and isnull(@PCMRecordedBy,0) = 0)    
 -- OR (isnull(@AssignedToStaffId,0) >0 and isnull(@PCMAssignedToStaffId,0) = 0) )    
 --BEGIN    
 -- ---- Delete existing record and insert new row for expected error ----    commented out by mraymond, 2/12/2018 KCMHSAS Support Task 971
 ---- Delete FROM @ValidationErrors    
 ---- insert into @ValidationErrors (TableName, ColumnName, ErrorMessage)            
 ---- select 'StaffDatabaseAccess', 'StaffId', 'This inquiry is unable to be completed because the information needed for Staff(GatheredBy,RecordedBy,AssignedToStaffId)  does not exist in the CareManagement system.  Please contact Technical Support to correct
  
 ----this problem.  Thank you'    
 ---- -- + cast(isnull(@PCMGatheredBy,0) as VARCHAR) + ' ' + cast(isnull(@RecordedBy,0) as VARCHAR) + ' ' + cast(isnull(@PCMAssignedToStaffId,0) as VARCHAR) + ' -- ' + cast(isnull(@AssignedToStaffId,0) as VARCHAR)    
 ---- -------------------------------------------------------------    
 ---- GOTO error    
 --END    
 ----------------------------------------------------------------------------------------------------------------    
    
 --- Delete existing record ----    commented out by mraymond, 2/12/2018 KCMHSAS Support Task 971
 --Delete FROM @ValidationErrors    
 ---- Now insert row for expected error ---    
 --insert into @ValidationErrors (TableName, ColumnName, ErrorMessage)            
 --select 'CustomInquiryEvents', 'GlobalCodes', 'This inquiry is unable to be completed because the information needed for global codes does not exist in the CareManagement system.  Please contact Technical Support to correct this problem.  Thank you'      
 -----------------------------------------------------------------     
    
 /*******************************************************************************************************/    
 ---- If Care ManagementId > 0 And InquiryEventID isnull then insert row into CustomInquiryEvents table ----     
 IF (@CareManagementId >0 AND isnull(@NewDocumentVersionID,0) > 0)    
  BEGIN --- Add Condition for not EXISTS ----    
   SET @DynamicQuery = 'INSERT INTO ['+ @DBName +'].[dbo].[CustomInquiryEvents] ' +    
    '([CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [ClientId], [InquirerFirstName], [InquirerMiddleName]    
    ,[InquirerLastName],[InquirerRelationToMember],[InquirerPhone],[InquirerPhoneExtension],[InquirerEmail]    
    ,[InquiryStartDateTime],[MemberFirstName],[MemberMiddleName],[MemberLastName],[SSN],[SSNUnknown],[Sex]    
    ,[DateOfBirth],[MemberPhone],[MemberEmail],[MaritalStatus],[Address1],[Address2],[City]    
    ,[State],[Race],[ZipCode],[MedicaidId],[PresentingProblem],[UrgencyLevel],[InquiryType],[ContactType]    
    ,[Location],[ClientCanLegalySign],[EmergencyContactFirstName],[EmergencyContactMiddleName],[EmergencyContactLastName]    
    ,[EmergencyContactRelationToClient],[EmergencyContactHomePhone],[EmergencyContactCellPhone],[EmergencyContactWorkPhone]    
    ,[PopulationDD],[PopulationMI],[PopulationSA],[SAType],[PrimarySpokenLanguage],[LimitedEnglishProficiency]    
    ,[SchoolName],[AccomodationNeeded],[Pregnant],[PresentingPopulation],[InjectingDrugs],[RecordedBy]    
    ,[GatheredBy],[ProgramId],[GatheredByOther],[DispositionComment],[InquiryDetails],[InquiryEndDateTime]    
    ,[InquiryStatus],[ReferralDate],[ReferralType],[ReferralSubtype],[ReferralName],[ReferralAdditionalInformation]    
    ,[Living],[NoOfBeds],[CountyOfResidence],[COFR],[CorrectionStatus],[EducationalStatus],[VeteranStatus]    
    ,[EmploymentStatus],[EmployerName],[MinimumWage],[DHSStatus],[AssignedToStaffId],[GuardianSameAsCaller]    
    ,[GuardianFirstName],[GuardianLastName],[GuardianPhoneNumber],[GuardianPhoneType],[GuardianDOB]    
    ,[GuardianRelation],[EmergencyContactSameAsCaller], [MemberCell], [GurdianDPOAStatus], [GardianComment], DocumentVersionId) ' +    
    
    ' SELECT Top 1 ''' + @MasterStaffUserCode + ''',''' + cast(Getdate() as varchar(20)) + ''','''     
    +  @MasterStaffUserCode + ''',''' + cast(Getdate() as varchar(20))     
    + ''',' + cast(@CareManagementId as varchar(10)) + ',[InquirerFirstName], [InquirerMiddleName], [InquirerLastName]       
    ,' + cast(@InquirerRelationToMember AS VARCHAR) + ', [InquirerPhone], [InquirerPhoneExtension], [InquirerEmail]    
    , [InquiryStartDateTime], [MemberFirstName], [MemberMiddleName], [MemberLastName], [SSN], [SSNUnknown], [Sex]    
    , [DateOfBirth], [MemberPhone],[MemberEmail], [MaritalStatus], [Address1], [Address2], [City], [State]    
    , [Race], [ZipCode], [MedicaidId], [PresentingProblem]' +    
    ',' + CASE WHEN @UrgencyLevel > 0 THEN CAST(@UrgencyLevel AS VARCHAR) ELSE 'NULL' END +    
    ',' + CASE WHEN @InquiryType > 0 THEN CAST(@InquiryType AS VARCHAR) ELSE 'NULL' END +    
    ',' + CASE WHEN @ContactType > 0 THEN CAST(@ContactType AS VARCHAR) ELSE 'NULL' END +    
    ', [Location],[ClientCanLegalySign], [EmergencyContactFirstName], [EmergencyContactMiddleName], [EmergencyContactLastName]    
    ,' + cast(@EmergencyContactRelationToClient as varchar) +    
    ', [EmergencyContactHomePhone], [EmergencyContactCellPhone], [EmergencyContactWorkPhone]    
    ,[PopulationDD],[PopulationMI],[PopulationSA]'+    
    ',' + CASE WHEN @SAType > 0 THEN CAST(@SAType AS VARCHAR) ELSE 'NULL' END +    
    ', [PrimarySpokenLanguage], [LimitedEnglishProficiency], [SchoolName],[AccomodationNeeded],[Pregnant]' +    
    ',' + CASE WHEN @PresentingPopulation > 0 THEN CAST(@PresentingPopulation AS VARCHAR) ELSE 'NULL' END +    
    ',[InjectingDrugs]'+    
    ',' + CASE WHEN @PCMRecordedBy > 0 THEN CAST(@PCMRecordedBy As VARCHAR) ELSE 'NULL' END + -- ',[RecordedBy]' +    
    ',' + CASE WHEN @PCMGatheredBy > 0 THEN CAST(@PCMGatheredBy As VARCHAR) ELSE 'NULL' END + --',[GatheredBy]' +    
    ',' + CASE WHEN @PCMProgramId > 0 then cast(@PCMProgramId as VARCHAR(10)) else 'NULL' END +     
    ', [GatheredByOther],[DispositionComment],[InquiryDetails],[InquiryEndDateTime],[InquiryStatus],[ReferralDate]' +    
    ',' + CASE WHEN @ReferralType > 0 THEN CAST(@ReferralType AS VARCHAR) ELSE 'NULL' END +     
    ',' + CASE WHEN @ReferralSubtype > 0 THEN CAST(@ReferralSubtype AS VARCHAR) ELSE 'NULL' END +     
    ',[ReferralName],[ReferralAdditionalInformation]' +     
    ',' + CASE WHEN @Living > 0 THEN CAST(@Living As VARCHAR) ELSE 'NULL' END +     
    ',' + CASE WHEN @NoOfBeds > 0 THEN CAST(@NoOfBeds As VARCHAR) ELSE 'NULL' END +     
    ',[CountyOfResidence],[COFR]' +    
    ',' + CASE WHEN @CorrectionStatus > 0 THEN CAST(@CorrectionStatus AS VARCHAR) ELSE 'NULL' END +     
    ',' + CASE WHEN @EducationalStatus > 0 THEN CAST(@EducationalStatus As VARCHAR) ELSE 'NULL' END + ',[VeteranStatus]' +    
    ',' + CASE WHEN @EmploymentStatus > 0 THEN CAST(@EmploymentStatus AS VARCHAR) ELSE 'NULL' END +     
    ', [EmployerName],[MinimumWage],[DHSStatus]'+    
    ',' + CASE WHEN @PCMAssignedToStaffId > 0 THEN CAST(@PCMAssignedToStaffId As VARCHAR) ELSE 'NULL' END + --',[AssignedToStaffId]' +    
    ',[GuardianSameAsCaller]    
    ,[GuardianFirstName],[GuardianLastName],[GuardianPhoneNumber],[GuardianPhoneType],[GuardianDOB],'     
    + cast(@GuardianRelation as varchar) +    
    ',[EmergencyContactSameAsCaller],[MemberCell],[GurdianDPOAStatus],[GardianComment], ' + cast(@NewDocumentVersionID  as varchar(10) )+    
   ' FROM [CustomInquiries] Where InquiryId = ' + cast(@ScreenKeyId as varchar)     
    
   EXEC sp_executesql @DynamicQuery    
    
    
   IF @UpdateClientContacts = 'Y'    
    BEGIN    
     ---- Delete existing record and insert new row for expected error----    
     Delete FROM @ValidationErrors    
     insert into @ValidationErrors (TableName, ColumnName, ErrorMessage)            
     select 'ClientContacts', 'ClientContactId', 'System not able to create Client Contact in CM/PA Database.'      
     ---------------------------------------------------------------------    
    
     ---- Update clientContacts table -------    
     SET @DynamicQuery = ' EXEC [' + @DBName + '].[dbo].csp_scUpdateClientContacts '    
      + CAST(ISNULL(@NewDocumentVersionID,0) AS VARCHAR(10)) + ','     
      + CAST(ISNULL(@CareManagementId,0) AS VARCHAR(10)) + ','''    
      + @MasterStaffUserCode + ''''    
     EXEC sp_executesql @DynamicQuery    
    
     insert into @ValidationErrors (TableName, ColumnName, ErrorMessage)            
     select 'ClientContacts', 'ClientContactId', @DynamicQuery      
     ---------------------------------------------------------------------    
    
         
         
    END    
       
   ---- Delete existing record and insert new row for expected error----    commented out by mraymond, 2/12/2018 KCMHSAS Support Task 971
   --Delete FROM @ValidationErrors    
   --insert into @ValidationErrors (TableName, ColumnName, ErrorMessage)            
   --select 'GlobalCodes', 'GlobalCodes', 'This inquiry is unable to be completed because the information needed for disposition does not exist in the CareManagement system.  Please contact Technical Support to correct this problem.  Thank you'      
   ---------------------------------------------------------------------        

   ---- Update Dispositions in PCM Master Database ---------    
   SET @DynamicQuery = ' EXEC [' + @DBName + '].[dbo].csp_scCreateInquiryDisposition ''' + @CurrentDBName + ''','     
    + CAST(@ScreenKeyId AS VARCHAR(10)) + ','     
    + CAST(ISNULL(@NewDocumentVersionID,0) AS VARCHAR(10)) + ','''    
    + @MasterStaffUserCode + ''''    
    
   EXEC sp_executesql @DynamicQuery    
   ---------------------------------------------------------    
  END     
    
  /*NOTE -  As Per our discussion with David On Jan 13m 2012, We need not to create client with details filled by user on Inquiry Page ----    
  If user will link any client with Inquiry then we need to check its Care Management Id and if it not exist then we need to create this. */    
    
 ---- If No Error found in Execution of above scrip then Delete Rows from Validation Error, otherwise it will show wrong validation message in Post update message window ----     
 Delete FROM @ValidationErrors    
 ----------------------------------------    
    
    
 ----NOTE: Delete below line of code    
 -------- For testing the record ------    
 --INSERT INTO @ValidationErrors (TableName, ColumnName, ErrorMessage)     
 --VALUES('My Testing', 'At Final Stag', 'Record Saved Correctly')    
 -----------------------------------------------    
    
error:    
 IF (SELECT count(*) FROM @ValidationErrors) > 0    
 BEGIN    
  SELECT * FROM @ValidationErrors         
 END    
END TRY    
    
BEGIN CATCH    
    
 DECLARE @ErrorMessage NVARCHAR(4000);    
    DECLARE @ErrorSeverity INT;    
    DECLARE @ErrorState INT;    
    
    SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();    
    
 --INSERT INTO @ValidationErrors (TableName, ColumnName, ErrorMessage)     
 --select 'Testing', 'Temp Value', @ErrorMessage      
    
    
 IF (SELECT count(*) FROM @ValidationErrors) >0    
 BEGIN         
  select * from @ValidationErrors         
 END    
     
    
    -- Use RAISERROR inside the CATCH block to return     
    -- error information about the original error that     
    -- caused execution to jump to the CATCH block.    
    --RAISERROR (@ErrorMessage, -- Message text.    
    --           @ErrorSeverity, -- Severity.    
    --           @ErrorState -- State.    
    --           );     
END CATCH    
    
END-- END of the SP    
    

GO


