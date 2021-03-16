
/****** Object:  StoredProcedure [dbo].[csp_CreateMemberRecord]    Script Date: 11/13/2013 17:13:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CreateMemberRecord]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CreateMemberRecord]
GO



/****** Object:  StoredProcedure [dbo].[csp_CreateMemberRecord]    Script Date: 11/13/2013 17:13:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


  
CREATE proc [dbo].[csp_CreateMemberRecord]          
@Active char(1),  
@LastName varchar(50),  
@FirstName varchar(30),  
@SSN varchar(25),  
@DOB datetime,  
@FinanciallyResponsible char(1),  
@DoesNotSpeakEnglish char(1),  
@StaffId int,
@inquiryId int
as          
/*********************************************************************/                                                                    
/* Stored Procedure: dbo.csp_CreateMemberRecord               */                                                                    
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                                                                    
/* Creation Date:    22/Sep/2011                                         */                                                                    
/*                                                                   */                                                                    
/* Purpose:  Used in creating new Member Record for Member Inquiry Detail Page  */                                                                   
/*                                                                   */                                                                  
/* Input Parameters:  @Active   */                                                                  
/*       @LastName */  
/*       @FirstName */  
/*       @SSN  */  
/*       @DOB  */  
/*       @FinanciallyResponsible */  
/*       @DoesNotSpeakEnglish */         
/*                                                      */                                                                    
/* Output Parameters:   Dataset of Newly added Member's Details                */                                                                    
/*                                                                   */                                                                   
/*                                                                   */                                                                    
/*  Date         Author				Purpose                             */                                                                    
/*  22/Sep/2011  Minakshi Varma		Created							*/    
 /* 03/May/2012  Sonia				Modified to create Active client as in Kalamazoo this is requirment       */ 
 /* 04-07-2012   Rakesh Garg		Comment the code for Insert in StaffClients table as values in this table will be inserted through trigger TriggerInsert_Clients w.rf to task 1663 in Kalamazoo Go Live Project*/    
 /* 02-07-2014   Md Hussain Khusro 	Added If not exists check to avoid duplicate clients not being created and inserting @LoggedInUserCode in Clients Table to know which user created Client*/ 
 /*									w.r.t task #297 KCMHSAS - Enhancements  */  
 /*25 Nov 2015 Vichee Humane  Added MasterRecord in Clients table as 'Y' for insertion CEI - Support Go Live #46 */                                        
/************3*********************************************************/                                                                         
BEGIN                                                     
 BEGIN TRY  
   
 DECLARE @ClientId int  
 DECLARE @LoggedInUserCode varchar(30)
 set @LoggedInUserCode = (select UserCode from Staff where StaffId=@StaffId)
 
 IF NOT EXISTS (SELECT 1 FROM Clients WHERE  [LastName] =  @LastName and FirstName = @FirstName and SSN = @SSN and DOB =  @DOB and ISNULL(RecordDeleted,'N') = 'N')  
 BEGIN               
 INSERT INTO [Clients]    
           ([Active]    
           ,[LastName]    
           ,[FirstName]    
           ,[SSN]    
           ,[DOB]    
           ,[FinanciallyResponsible]    
           ,[DoesNotSpeakEnglish]
           ,CreatedBy  
           ,CreatedDate  
		   ,ModifiedBy  
           ,ModifiedDate
           ,[MasterRecord])    
     VALUES    
           ('Y'    
           ,@LastName    
           ,@FirstName    
           ,@SSN    
           ,@DOB    
           ,@FinanciallyResponsible    
           ,@DoesNotSpeakEnglish
           ,@LoggedInUserCode  
           ,GETDATE()  
           ,@LoggedInUserCode  
           ,GETDATE() 
           ,'Y') 
             
 set @ClientId=@@IDENTITY  
   
--INSERT INTO [StaffClients]  
--           ([StaffId]  
--           ,[ClientId])  
--     VALUES  
--           (@StaffId  
--           ,@ClientId)  

 END    
ELSE   
 BEGIN  
   SET @ClientId = (SELECT ClientId  FROM Clients WHERE  [LastName] =  @LastName and FirstName = @FirstName and SSN = @SSN and DOB =  @DOB and ISNULL(RecordDeleted,'N') = 'N')  
 END  

 DECLARE @address varchar(50)

 set @address = (select Address1 from CustomInquiries where InquiryId= @inquiryId)
 If @address is not null 
 Begin 
 INSERT INTO ClientAddresses (ClientId,[Address],City,[State],Zip,ModifiedDate,ModifiedBy,AddressType)
 select @ClientId,Address1,City,State,ZipCode,getdate(),@LoggedInUserCode,90
 from CustomInquiries where InquiryId= @inquiryId
 End
 
 DECLARE @phone varchar(50)
 set @phone = (select MemberPhone from CustomInquiries where InquiryId= @inquiryId)
 If @phone is not null 
 Begin 
 INSERT INTO ClientPhones (ClientId,PhoneType,PhoneNumber,PhoneNumberText,IsPrimary,DoNotContact,DoNotLeaveMessage)
 select @ClientId,30,@phone,dbo.[csf_PhoneNumberStripped](@phone),'Y',null,null
 from CustomInquiries where InquiryId= @inquiryId
 End

  DECLARE @mobile varchar(50)
 set @mobile = (select MemberCell from CustomInquiries where InquiryId= @inquiryId)
 If @mobile is not null 
 Begin 
 INSERT INTO ClientPhones (ClientId,PhoneType,PhoneNumber,PhoneNumberText,IsPrimary,DoNotContact,DoNotLeaveMessage)
 select @ClientId,34,@mobile,dbo.[csf_PhoneNumberStripped](@mobile),'N',null,null
 from CustomInquiries where InquiryId= @inquiryId
 End
              
 SELECT  
  ClientId,  
  LastName,  
  FirstName,  
  SSN,  
  DOB  
 FROM Clients  
 WHERE ClientId=@ClientId    
           
   END TRY                                        
 BEGIN CATCH                     
 DECLARE @Error varchar(8000)                                                                      
    SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                       
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_CreateMemberRecord')                                            
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


