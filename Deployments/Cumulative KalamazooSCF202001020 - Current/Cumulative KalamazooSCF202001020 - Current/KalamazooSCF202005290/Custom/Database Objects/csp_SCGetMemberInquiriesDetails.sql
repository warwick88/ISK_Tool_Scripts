
/****** Object:  StoredProcedure [dbo].[csp_SCGetMemberInquiriesDetails]    Script Date: 11/13/2013 17:29:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetMemberInquiriesDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetMemberInquiriesDetails]
GO



/****** Object:  StoredProcedure [dbo].[csp_SCGetMemberInquiriesDetails]    Script Date: 11/13/2013 17:29:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].[csp_SCGetMemberInquiriesDetails] 
	@inquiryId int
as
/*********************************************************************/
/* Stored Procedure: dbo.csp_SCGetMemberInquiriesDetails   */      
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC */      
/* Creation Date:    15-Dec-2011     */      
/*       */      
/* Purpose:  Used in getdata() for MemberInquiries Detail Page  */     
/*       */    
/* Input Parameters:     @inquiryId   */    
/*       */      
/* Output Parameters:   None    */      
/*       */      
/* Return:  0=success, otherwise an error number																*/      
/*--------------------------------------------------------------------------------------------------------------*/      
/*  Date			Author					Purpose																*/
/* ------------     -----------------       --------------------------------------------------------------------*/
/* 08/Sep/2011		Minakshi Varma			Created																*/
/* 06/Jan/2012		Sudhir Singh			Updated																*/          
/* April 13, 2012	Pralyankar Kumar Singh	MOdified for Updating Client Information is CustomInquiries table	*/ 
/* 13/Dec/2012		Mamta Gupta				Ref Task No. 301 - 3.x Issues 
											What : and Isnull(A.RecordDeleted,'N')='N' condition added 
											Why : As RecordDeleted condition missing for ClientEpisodes */   
/*********************************************************************/           
BEGIN   
	BEGIN TRY
	
		-- If Inquiry status is InProgress and clientId >0 then Update CustomInquiries Table with vaues of CustomInquiries
		IF EXISTS(SELECT 1 FROM CustomInquiries Where InquiryId = @inquiryId AND ClientId >0 AND InquiryStatus = 24324 )
		BEGIN
			---- Update Client Information -----
			Update CI 
			SET Ci.MemberFirstName = C.FirstName 
				, CI.MemberLastName = C.LastName 
				, CI.MemberMiddleName = C.MiddleName 
				, CI.SSN = C.SSN 
				, CI.DateOfBirth = C.DOB 
				, CI.MemberEmail = C.Email 
				, CI.Living = C.LivingArrangement 
				, CI.NoOfBeds = C.NumberOfBeds 
				, CI.CountyOfResidence = C.CountyOfResidence 
				, CI.CorrectionStatus = C.CorrectionStatus 
				, CI.EducationalStatus = C.EducationalStatus 
				, CI.EmploymentStatus = C.EmploymentStatus 
				, CI.EmployerName = C.EmploymentInformation 
				, CI.MinimumWage = CASE WHEN rtrim(ltrim(C.MinimumWage)) = 'YES' THEN 'Y' ELSE 'N' END 
				, CI.Sex = C.Sex 
				--, CI.ModifiedDate = getdate()
			FROM CustomInquiries CI Inner JOIN Clients C ON CI.ClientId = C.ClientId 
			WHERE CI.InquiryId = @inquiryId
			------------------------------------------------------------------------

			------ Update Client Address ------------------
			Update CI 
			SET Ci.Address1 = CA.Address
				, CI.City = CA.City 
				, CI.State = CA.State 
				, CI.ZipCode = CA.Zip 
			FROM CustomInquiries CI Inner JOIN ClientAddresses CA ON CI.ClientId = CA.ClientId And CA.AddressType = 90 -- 90 = Home
			WHERE CI.InquiryId = @inquiryId
			-----------------------------------------------

			-- Update Client Episod Informations ----------
			UPDATE CI 
			SET CI.ReferralDate = CE.ReferralDate 
				, CI.ReferralType = CE.ReferralType 
				, CI.ReferralSubtype = CE.ReferralSubtype 
				, CI.ReferralName = CE.ReferralName 
				, CI.ReferralAdditionalInformation = CE.ReferralAdditionalInformation 
			FROM CustomInquiries CI INNER JOIN Clients C ON CI.ClientId = C.ClientId 
				INNER JOIN ClientEpisodes CE ON CE.ClientId = C.ClientId AND C.CurrentEpisodeNumber = CE.EpisodeNumber 
			WHERE CI.InquiryId = @inquiryId
			-----------------------------------------------

			-------- Update Client Contacts ---------------
			--Pending to DO
			-----------------------------------------------

			-------- Update Client Phone Numbers ----------
			--Pending to DO
			-----------------------------------------------

			 /*
			,  '' AS COFR
			 CP.PhoneNumberText as PhoneNumber,
			 --ClientContect.FirstName    AS EmergencyContactFirstName ,     
			 --ClientContect.MiddleName   AS EmergencyContactMiddleName,       
			 --ClientContect.LastName     AS EmergencyContactLastName,     
			 --ClientContect.Relationship AS EmergencyContactRelationToClient ,       
			 --ClientContect.HomePhone    AS EmergencyContactHomePhone,     
			 --ClientContect.CellPhone    AS EmergencyContactCellPhone,     
			 --ClientContect.WorkPhone    AS EmergencyContactWorkPhone     
			, '' As 'DHSAbuseNeglect', '' As 'AreyouVeteran'
			*/
			-- Update CustomInquiries
		END
		-------------------------------------------------------------------------------
		
		
		SELECT CustomInquiries.[InquiryId]          
			, CustomInquiries.[CreatedBy]          
			, CustomInquiries.[CreatedDate]          
			, CustomInquiries.[ModifiedBy]          
			, CustomInquiries.[ModifiedDate]          
			, CustomInquiries.[RecordDeleted]          
			, CustomInquiries.[DeletedBy]          
			, CustomInquiries.[DeletedDate]          
			, CustomInquiries.[ClientId]          
			, CustomInquiries.[InquirerFirstName]          
			, CustomInquiries.[InquirerMiddleName]          
			, CustomInquiries.[InquirerLastName]          
			, CustomInquiries.[InquirerRelationToMember]          
			, CustomInquiries.[InquirerPhone]          
			, CustomInquiries.[InquirerPhoneExtension]          
			, CustomInquiries.[InquirerEmail]          
			, convert(varchar(10),CustomInquiries.[InquiryStartDateTime],101) as InquiryStartDate      
			,/*convert(varchar(5),CustomInquiries.[InquiryStartDateTime],114)*/
			/*right(convert(VARCHAR(20),CustomInquiries.[InquiryStartDateTime],0),7) as InquiryStartTime */
			ltrim(substring(rtrim(right(CONVERT(VARCHAR(26), CustomInquiries.[InquiryStartDateTime], 100),7)),0,6)+ ' '+right(CONVERT(VARCHAR(26), CustomInquiries.[InquiryStartDateTime], 109),2))  as InquiryStartTime     
			, CustomInquiries.[InquiryStartDateTime]     
			, InquiryEventId -- This field added By pralyankar On Jan 11, 2012   
			, CustomInquiries.[MemberFirstName]          
			, CustomInquiries.[MemberMiddleName]          
			, CustomInquiries.[MemberLastName]          
			, CustomInquiries.[SSN]    
			, CustomInquiries.Sex 
			, CustomInquiries.[DateOfBirth]          
			, CustomInquiries.[MemberPhone]          
			, CustomInquiries.[MemberCell]          
			, CustomInquiries.[MemberEmail]          
			, CustomInquiries.[MaritalStatus]          
			, CustomInquiries.[Address1]          
			, CustomInquiries.[Address2]          
			, CustomInquiries.[City]          
			, CustomInquiries.[State]          
			,CustomInquiries.[Race]          
			, CustomInquiries.[ZipCode]          
			---- Below Line written By Pralyankar On Jan 12, 2012 ---
			---[dbo].[GetMedicaidId](CustomInquiries.[clientid]) -- CustomInquiries.[MedicaidId]   This column will be removed from the Datamodel. 
			, CustomInquiries.[MedicaidId] ---added by Sudhir Singh
			------------------------------------------------------------  
			,Clients.CareManagementId as [MasterId]         
			,CustomInquiries.[PresentingProblem]          
			,CustomInquiries.[UrgencyLevel]          
			,CustomInquiries.[InquiryType]          
			,CustomInquiries.[ContactType]          
			,CustomInquiries.[Location]          
			,CustomInquiries.[ClientCanLegalySign]          
			,CustomInquiries.[EmergencyContactFirstName]          
			,CustomInquiries.[EmergencyContactMiddleName]          
			,CustomInquiries.[EmergencyContactLastName]          
			,CustomInquiries.[EmergencyContactRelationToClient]          
			,CustomInquiries.[EmergencyContactHomePhone]       
			,CustomInquiries.[EmergencyContactCellPhone]          
			,CustomInquiries.[EmergencyContactWorkPhone]          
			,CustomInquiries.[PopulationDD]          
			,CustomInquiries.[PopulationMI]          
			,CustomInquiries.[PopulationSA]          
			,CustomInquiries.[SAType]          
			,CustomInquiries.[PrimarySpokenLanguage]          
			,CustomInquiries.[LimitedEnglishProficiency]          
			,CustomInquiries.[SchoolName]          
			,CustomInquiries.[AccomodationNeeded]          
			,CustomInquiries.[Pregnant]          
			,CustomInquiries.[PresentingPopulation]          
			,CustomInquiries.[InjectingDrugs]          
			,CustomInquiries.[RecordedBy]          
			,CustomInquiries.[GatheredBy]          
			,CustomInquiries.[ProgramId]          
			,CustomInquiries.[GatheredByOther]          
			,CustomInquiries.[DispositionComment]          
			,CustomInquiries.[InquiryDetails]          
			,convert(varchar(10),CustomInquiries.[InquiryEndDateTime],101) as InquiryEndDate      
			/*convert(varchar(5),CustomInquiries.[InquiryEndDateTime],114) as InquiryEndTime */
			/*right(convert(VARCHAR(20),CustomInquiries.[InquiryEndDateTime],0),7) as InquiryEndTime  */
			,ltrim(substring(rtrim(right(CONVERT(VARCHAR(26), CustomInquiries.[InquiryEndDateTime], 100),7)),0,6)+ ' '+right(CONVERT(VARCHAR(26), CustomInquiries.[InquiryEndDateTime], 109),2)) as  InquiryEndTime         
			,CustomInquiries.[InquiryEndDateTime]          
			,CustomInquiries.[InquiryStatus]          
			,CustomInquiries.[ReferralDate]          
			,CustomInquiries.[ReferralType]          
			,CustomInquiries.[ReferralSubtype]          
			,CustomInquiries.[ReferralName]
			,CustomInquiries.[ReferralAdditionalInformation]
			,CustomInquiries.[Living]
			,CustomInquiries.[NoOfBeds]
			,CustomInquiries.[CountyOfResidence]
			,CustomInquiries.[COFR]
			,CustomInquiries.[CorrectionStatus]
			,CustomInquiries.[EducationalStatus]          
			,CustomInquiries.[VeteranStatus]          
			,CustomInquiries.[EmploymentStatus]          
			,CustomInquiries.[EmployerName]          
			,CustomInquiries.[MinimumWage]          
			,CustomInquiries.[DHSStatus]          
			,CustomInquiries.[AssignedToStaffId]          
			,CustomInquiries.[GuardianSameAsCaller]          
			,CustomInquiries.[GuardianFirstName]          
			,CustomInquiries.[GuardianLastName]          
			,CustomInquiries.[GuardianPhoneNumber]          
			,CustomInquiries.[GuardianPhoneType]          
			,CustomInquiries.[GuardianDOB]          
			,CustomInquiries.[GuardianRelation]          
			,CustomInquiries.[EmergencyContactSameAsCaller]  
			,CustomInquiries.[MemberCell]  
			,CustomInquiries.[GurdianDPOAStatus]  
			,CustomInquiries.[GardianComment]
			,CustomInquiries.[SSNUnknown]
			,CustomInquiries.[InquiryStatus] AS DefaultInquiryStatus
			,CustomInquiries.[CoverageInformation]
			,CustomInquiries.[ReceivingPrenatalCare]
			, A.RegistrationDate, A.EpisodeNumber,  A.Status as 'EpisodeStatus', A.DischargeDate
			
		FROM CustomInquiries  
			LEFT JOIN Clients ON  CustomInquiries.[ClientId] = Clients.ClientId  
			Left JOIN clientepisodes A ON A.ClientId = Clients.ClientId And A.EpisodeNumber = Clients.CurrentEpisodeNumber 
			--Added By Mamta Gupta - Ref Task No. 301 - 3.x Issues - As RecordDeleted condition missing for ClientEpisodes 
			and Isnull(A.RecordDeleted,'N')='N'
		WHERE InquiryId = @inquiryId  
  
  
		SELECT [CustomDispositionId]
			,[CreatedBy]
			,[CreatedDate]
			,[ModifiedBy]
			,[ModifiedDate]
			,[RecordDeleted]
			,[DeletedBy]
			,[DeletedDate]
			,[InquiryId]
			,[Disposition]
		FROM [CustomDispositions]
		WHERE InquiryId=@inquiryId
		AND ISNULL([CustomDispositions].RecordDeleted,'N')<>'Y'
  
		SELECT [CustomServiceDispositionId]
			,[CustomServiceDispositions].[CreatedBy]
			,[CustomServiceDispositions].[CreatedDate]
			,[CustomServiceDispositions].[ModifiedBy]
			,[CustomServiceDispositions].[ModifiedDate]
			,[CustomServiceDispositions].[RecordDeleted]
			,[CustomServiceDispositions].[DeletedBy]
			,[CustomServiceDispositions].[DeletedDate]
			,[CustomServiceDispositions].[ServiceType]
			,[CustomServiceDispositions].[CustomDispositionId]
		FROM [CustomServiceDispositions]
			inner join [CustomDispositions]
			on [CustomServiceDispositions].[CustomDispositionId]=[CustomDispositions].CustomDispositionId
		where [CustomDispositions].InquiryId=@inquiryId
			AND ISNULL([CustomServiceDispositions].RecordDeleted,'N')<>'Y'
			AND ISNULL([CustomDispositions].RecordDeleted,'N')<>'Y'

		SELECT [CustomProviderServiceId]
			,[CustomProviderServices].[CreatedBy]
			,[CustomProviderServices].[CreatedDate]
			,[CustomProviderServices].[ModifiedBy]
			,[CustomProviderServices].[ModifiedDate]
			,[CustomProviderServices].[RecordDeleted]
			,[CustomProviderServices].[DeletedBy]
			,[CustomProviderServices].[DeletedDate]
			,[CustomProviderServices].[ProgramId]
			,[CustomProviderServices].[CustomServiceDispositionId]
		FROM [CustomProviderServices]
			inner join [CustomServiceDispositions] on [CustomProviderServices].CustomServiceDispositionId=[CustomServiceDispositions].CustomServiceDispositionId
			inner join [CustomDispositions]on [CustomServiceDispositions].[CustomDispositionId]=[CustomDispositions].CustomDispositionId
		where [CustomDispositions].InquiryId=@inquiryId
			AND ISNULL([CustomProviderServices].RecordDeleted,'N')<>'Y'
			AND ISNULL([CustomServiceDispositions].RecordDeleted,'N')<>'Y'
			AND ISNULL([CustomDispositions].RecordDeleted,'N')<>'Y' 

			Select InquiryCoverageInformationId                          
		  ,CreatedBy                                 
		  ,CreatedDate                                 
		  ,ModifiedBy                                 
		  ,ModifiedDate                                
		  ,RecordDeleted                              
		  ,DeletedBy                                 
		  ,DeletedDate                                 
		  ,InquiryId                                 
		  ,CoveragePlanId                                  
		  ,InsuredId                                 
		  ,GroupId                                  
		  ,Comment                           
		  ,NewlyAddedplan                                 
    FROM CustomInquiryCoverageInformations WHERE InquiryId=@inquiryId  AND ISNULL(RecordDeleted,'N')<>'Y'                        
                              
    Select CoveragePlanId,DisplayAs FROM CoveragePlans       
        
   END TRY  
 BEGIN CATCH       
 DECLARE @Error varchar(8000)        
    SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())         
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_SCGetMemberInquiriesDetails')           
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())          
    + '*****' + Convert(varchar,ERROR_STATE())        
       
    RAISERROR         
    (          
  @Error, -- Message text.        
  16, -- Severity.        
  1 -- State.        
    );     
 End CATCH           
End     

GO


