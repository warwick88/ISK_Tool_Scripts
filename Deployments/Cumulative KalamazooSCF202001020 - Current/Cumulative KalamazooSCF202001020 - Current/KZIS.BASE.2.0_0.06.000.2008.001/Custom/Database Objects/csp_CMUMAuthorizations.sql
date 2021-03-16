
/****** Object:  StoredProcedure [dbo].[csp_CMUMAuthorizations]    Script Date: 11/27/2013 18:56:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CMUMAuthorizations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CMUMAuthorizations]
GO


/****** Object:  StoredProcedure [dbo].[csp_CMUMAuthorizations]    Script Date: 11/27/2013 18:56:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    
CREATE PROCEDURE [dbo].[csp_CMUMAuthorizations]        
@RequestId uniqueidentifier,        
@Population int = NULL     
/*********************************************************************                        
-- Stored Procedure: dbo.csp_CMUMAuthorizations              
-- Copyright: Streamline Healthcare Solutions              
--                                                               
-- Purpose: creates/updates authorizations              
--                                                                                                
-- Modified Date    Modified By  Purpose              
-- 07.15.2011       SFarber      Created.          
-- 02.10.2012  RNoble   Modified insert for ProviderAuthorizations as it was inserting AuthorizationId in the place of AuthorizationProviderBillingCodeId.          
--         Addditionally modified section which sets providerAuthorizationId to null as it was setting ProviderAuthorizationid to null.          
-- 03.07.2012  RNoble   Added Status 304, 305 (Partially Denied, Partially Approved)        
-- 06.18.2012  dharvey   Added reference to Request Status in CustomUMStageAthorizations validations        
-- 06.28.2012  Rakesh Garg  Checking BillingCodeId exists in table BillingCode table while inserting in table ProviderAuthorizations w.rf to task 1729 in Kalamazoo G0-LiveProject        
-- 07.11.2012  Sourabh   Modified to insert FrequencyTypeRequested field in CustomUMStageAthorizations  table wrt#1674 in Kalamazoo Bugs -Go Live        
-- 21 Nov 2012  Vikeshb      Modified ref task #177 in update for AuthorizationNumber        
-- 11/Feb/2013  Mamta Gupta  Task 10 - Kalamazoo Post Go Live Development -         
         What : Authorizations Population added in CustomProviderAuthorizationPopulations table.        
         Why : As per task requirement.        
-- 8/Mar/2013  Mamta Gupta  Task 72 in Allegan Customizations Issues Tracking        
         What : Check added If EventId is null then we need to skip inserting statments for Diagnosis tables        
         Why : To handle Error while creating second document Version of Tx Plan         
-- 15/May/2013  Mamta Gupta  Task 12 in Kalamazoo Post Go Live Development        
         What : Logic changed to insert population in CustomProviderAuthorizationPopulations        
         Why : To update population for multiple authorizations      
-- 20/Mar/2015 :Pradeep Kumar Yadav          
                What-Latest Stored Procedure was missing     
                Why - Task No-226 KCMHSAS 3.5 Implementation      
-- 16/Mar/2017 MJensen    
    What - added default value for parm @Population     
    Why - KCMHSAS - support #542     
-- 26 April 2017    PradeepT     What:Remove Use of Synonym that poits to SC DB. This csp called from csp_SCPostSignatureUpdateAuthorizations and points to CM DB earlier.    
--                               Why: There is no use to point SC DB As we are using single DB for Both CM AND Sc DB.  
---Himmat  26 Feb 2018 What: Modified to Add BillingCodeModifierId, RequestedBillingCodeModifierId in ProviderAuthorizationTable
----                     Why: When signed authorization event and click to go Authorization detail bage, Billingcode field was not poulating in Grid, KCMHSAS - Support-#995 
-- 02/09/2018   Hemant 	      Added logic to initialize Assigned Population from Client Information - Custom Fields tab to ProviderAuthorziation - Assigned Population field w.r.t KMCHSAS - Enhancements #542		
-- 03/11/2018   Hemant 	      Added Distinct keyword to avoid the duplication as select statement returns duplicates intermittently for staging table.Population field w.r.t KCMHSAS - Support #663	
-- 04/09/2018   Rajeshwari S  Added logic to check ''(blank) when Modifiers are null on 'CustomUMStageAthorizations'. w.r.t KCMHSAS - Support #960.211
-- 09/17/2018   MD		      Corrected the logic to status authorization status correctly w.r.t KCMHSAS - Support #1118  
   12/20/2018   MD            Modified insert for ProviderAuthorizations, changed left join to join with BillingCodeModifiers table becuase it was creating provider authorization request for each modifier  
                              Ref: KCMHSAS - Support #1206   	
   08/22/2020   Sunil D       What: Adding a current system date check(current system date should be between the start date and end date of Authorization) to avoid the validation
							  Why:Since we are getting validation for the authorizations are in the future, we have planned to add check condition with the current date to avoid the validation in an sp 'csp_CMUMAuthorizations' used to trigger the validation. 
							  KCMHSAS - Support #1490
****************************************************************************/            
AS             
    DECLARE @Authorizations TABLE            
        (            
          AuthorizationProviderBillingCodeId INT ,            
          ProviderAuthorizationId INT            
        )              
              
    DECLARE @EventId INT              
    DECLARE @ProviderAuthorizationDocumentId INT              
    DECLARE @AuthorizationDocumentId INT              
    DECLARE @RequestorComment VARCHAR(MAX)              
    DECLARE @ReviewerComment VARCHAR(MAX)              
    DECLARE @CreatedBy VARCHAR(30)              
            
-- Check to see if anything came over from SC            
    IF EXISTS ( SELECT  *            
                FROM    dbo.CustomUMStageAthorizations            
                WHERE   RequestId = @RequestId )             
        BEGIN            
              
-- Validate authorizations              
            UPDATE  s            
            SET     ErrorMessage = 'Cannot create/modify external authorization.  Missing '            
                    + SUBSTRING(CASE WHEN s.InsurerId IS NULL THEN ', Insurer'            
                                     ELSE ''            
                                END            
                                + CASE WHEN s.ClientId IS NULL THEN ', Client'            
                                       ELSE ''            
                                  END            
                                + CASE WHEN s.ProviderId IS NULL            
                                       THEN ', Provider'            
                                       ELSE ''            
                                  END            
                                + CASE WHEN s.BillingCodeId IS NULL            
                                       THEN ', Billing Code'                                               ELSE ''            
                                  END, 3, 100) + ' information.'            
     FROM    CustomUMStageAthorizations s            
            WHERE   s.RequestId = @RequestId            
     AND s.RequestStatus not in ('MODIFIED')         
                    AND ISNULL(s.RecordDeleted, 'N') = 'N'            
                    AND ( s.InsurerId IS NULL            
                          OR s.ClientId IS NULL            
                          OR s.ProviderId IS NULL            
                          OR s.BillingCodeId IS NULL            
                        )              
                      
            IF @@error <> 0             
                GOTO error              
              
            UPDATE  s            
            SET     ErrorMessage = 'Cannot modify '            
                    + SUBSTRING(CASE WHEN pa.InsurerId <> s.InsurerId            
                                     THEN ', Insurer'            
                                     ELSE ''            
                                END            
                                + CASE WHEN pa.ClientId <> s.ClientId            
                                       THEN ', Client'            
                                       ELSE ''            
                                  END            
                                + CASE WHEN pa.ProviderId <> s.ProviderId            
                                       THEN ', Provider'            
                                       ELSE ''            
                                  END            
                                + CASE WHEN pa.BillingCodeId <> s.BillingCodeId            
                                       THEN ', Billing Code'            
                                       ELSE ''            
                                  END            
                                + CASE WHEN ISNULL(pa.Modifier1, '') <> ISNULL(s.Modifier1,            
                                                              '')            
                                       THEN ', Modifier 1'            
                                       ELSE ''            
                                  END            
                                + CASE WHEN ISNULL(pa.Modifier2, '') <> ISNULL(s.Modifier2,            
                                                       '')            
                                       THEN ', Modifier 2'            
                                       ELSE ''            
                                  END            
                                + CASE WHEN ISNULL(pa.Modifier3, '') <> ISNULL(s.Modifier3,            
                                                              '')            
                                       THEN ', Modifier 3'            
                                       ELSE ''            
                                  END            
                                + CASE WHEN ISNULL(pa.Modifier4, '') <> ISNULL(s.Modifier4,            
                                                              '')            
                THEN ', Modifier 4'            
                                       ELSE ''            
                                  END            
                                + CASE WHEN ISNULL(pa.StartDate, '1/1/1900') <> ISNULL(s.StartDate,            
                                                              '1/1/1900')            
                                       THEN ', Start Date'            
                                       ELSE ''            
                                  END            
                                + CASE WHEN ISNULL(pa.EndDate, '1/1/1900') <> ISNULL(s.EndDate,            
                                                              '1/1/1900')            
                                       THEN ', End Date'            
                                       ELSE ''            
                                  END            
                                + CASE WHEN ISNULL(pa.SiteId, -1) <> ISNULL(s.SiteId,            
                                                              -1)            
      THEN ', Site'            
                                       ELSE ''            
                                  END, 3, 100)            
                    + ' information. External authorization #'            
                    + ISNULL(pa.AuthorizationNumber, 'Unknown')            
                    + ' has been already in use.'            
            FROM    CustomUMStageAthorizations s            
                    JOIN ProviderAuthorizations pa ON pa.ProviderAuthorizationId = s.ProviderAuthorizationId            
            WHERE   s.RequestId = @RequestId         
     AND s.RequestStatus not in ('MODIFIED')         
                    AND s.ErrorMessage IS NULL            
                    AND ISNULL(pa.UnitsUsed, 0) > 0            
                    AND ISNULL(s.RecordDeleted, 'N') = 'N'            
                    AND ISNULL(pa.RecordDeleted, 'N') = 'N'            
                    AND ( pa.InsurerId <> s.InsurerId            
                          OR pa.ClientId <> s.ClientId            
                          OR pa.ProviderId <> s.ProviderId            
                          --OR pa.BillingCodeId <> s.BillingCodeId            
                          --OR ISNULL(pa.Modifier1, '') <> ISNULL(s.Modifier1,            
                          --                                    '')            
                          --OR ISNULL(pa.Modifier2, '') <> ISNULL(s.Modifier2,            
                          --                                    '')            
                          --OR ISNULL(pa.Modifier3, '') <> ISNULL(s.Modifier3,            
                          --                                    '')            
                          --OR ISNULL(pa.Modifier4, '') <> ISNULL(s.Modifier4,            
                          --                                    '')            
                          OR ISNULL(pa.SiteId, -1) <> ISNULL(s.SiteId, -1)            
                          OR ISNULL(pa.StartDate, '1/1/1900') <> ISNULL(s.StartDate,            
                                                              '1/1/1900')            
                   OR ISNULL(pa.EndDate, '1/1/1900') <> ISNULL(s.EndDate,            
                                                              '1/1/1900')            
                        )              
                      
            IF @@error <> 0             
                GOTO error              
                                 
            UPDATE  s            
            SET     ErrorMessage = 'Cannot decrease Approved Units below Used Units.  Authorization #'            
                    + ISNULL(pa.AuthorizationNumber, 'Unknown')            
                    + ' has been already in use.'            
            FROM    CustomUMStageAthorizations s            
                 JOIN ProviderAuthorizations pa ON pa.ProviderAuthorizationId = s.ProviderAuthorizationId            
           WHERE   s.RequestId = @RequestId            
     AND s.RequestStatus not in ('MODIFIED')        
                    AND ISNULL(pa.UnitsUsed, 0) > ISNULL(s.UnitsApproved, 0)            
                    AND s.ErrorMessage IS NULL            
                    AND ISNULL(s.RecordDeleted, 'N') = 'N'            
                    AND ISNULL(pa.RecordDeleted, 'N') = 'N'              
                      
            IF @@error <> 0             
                GOTO error              
              
            UPDATE  s            
            SET     ErrorMessage = 'Cannot delete authorization. External authorization #'            
                    + ISNULL(pa.AuthorizationNumber, 'Unknown')            
                    + ' has been already in use.'            
            FROM    CustomUMStageAthorizations s            
                    JOIN ProviderAuthorizations pa ON pa.ProviderAuthorizationId = s.ProviderAuthorizationId            
            WHERE   s.RequestId = @RequestId            
     AND s.RequestStatus not in ('MODIFIED')        
                    AND ISNULL(pa.UnitsUsed, 0) > 0            
                    AND s.RecordDeleted = 'Y'            
                    AND ISNULL(pa.RecordDeleted, 'N') = 'N'              
                      
            IF @@error <> 0             
              GOTO error          
                        
             ----Below Code Added By Rakesh for Checking BillingCodeId exists in table BillingCode table w.rf to task 1729 in Kalamazoo G0-LiveProject        
                If Exists (Select s.SearchingId From  (        
  SELECT  CustomUMStageAthorizations.BillingCodeId, BillingCodes.BillingCodeId AS SearchingId        
  FROM    dbo.CustomUMStageAthorizations Left Join BillingCodes on BillingCodes.BillingCodeId = CustomUMStageAthorizations.BillingCodeId        
  WHERE   RequestId = @RequestId        
  ) As s        
  Where SearchingId is null)        
   Begin        
        
    Update s SET ErrorMessage = 'Cannot Update Record As Billing Code Id does not exists in CM database.'           
     FROM    CustomUMStageAthorizations s               
     Where UMStageAthorizationId IN(        
     Select s.UMStageAthorizationId From        
     (        
     SELECT  CustomUMStageAthorizations.BillingCodeId, BillingCodes.BillingCodeId AS SearchingId, CustomUMStageAthorizations.UMStageAthorizationId         
     FROM    dbo.CustomUMStageAthorizations Left Join BillingCodes on BillingCodes.BillingCodeId = CustomUMStageAthorizations.BillingCodeId        
     WHERE   RequestId = @RequestId        
     ) As s        
     Where SearchingId is null        
    )        
    AND   s.RequestId = @RequestId            
     --AND s.RequestStatus not in ('MODIFIED')         
                    AND ISNULL(s.RecordDeleted, 'N') = 'N'          
      End        
                             
            IF @@error <> 0             
                GOTO error              
                     
             --Changes Ends here made w.rf to task 1729 in w.rf to task 1729 in Kalamazoo G0-LiveProject        
           
            IF EXISTS ( SELECT  *            
                        FROM    CustomUMStageAthorizations            
                        WHERE   RequestId = @RequestId            
                                AND ErrorMessage IS NOT NULL         
                                )             
                GOTO finish              
              
            SELECT TOP 1            
                    @AuthorizationDocumentId = s.AuthorizationDocumentId ,            
                    @ProviderAuthorizationDocumentId = s.ProviderAuthorizationDocumentId ,            
                    @RequestorComment = s.RequestorComment ,            
                    @ReviewerComment = s.ReviewerComment ,            
                    @CreatedBy = s.CreatedBy            
            FROM    CustomUMStageAthorizations s            
            WHERE   s.RequestId = @RequestId              
      
-- If the authorization document no longer exists, it will be recreated                 
            IF NOT EXISTS ( SELECT  *            
                            FROM    ProviderAuthorizationDocuments pad            
                            WHERE   pad.ProviderAuthorizationDocumentId = @ProviderAuthorizationDocumentId            
                                    AND ISNULL(pad.RecordDeleted, 'N') = 'N' )             
                BEGIN              
                    SET @ProviderAuthorizationDocumentId = NULL              
                
                    UPDATE  s            
                    SET     ProviderAuthorizationDocumentId = NULL            
                    FROM    CustomUMStageAthorizations s            
                    WHERE   s.RequestId = @RequestId            
                            AND ISNULL(s.RecordDeleted, 'N') = 'N'              
                END                                  
                 
-- If an authorization no longer exists, it will be recreated                 
            UPDATE  s            
            SET     ProviderAuthorizationId = NULL            
            FROM    CustomUMStageAthorizations s            
            WHERE   s.RequestId = @RequestId            
                    AND ISNULL(s.RecordDeleted, 'N') = 'N'            
                    AND NOT EXISTS ( SELECT *            
                                     FROM   ProviderAuthorizationDocuments pad            
                                            JOIN ProviderAuthorizations pa ON pa.ProviderAuthorizationDocumentId = pad.ProviderAuthorizationDocumentId            
           WHERE  pad.ProviderAuthorizationDocumentId = @ProviderAuthorizationDocumentId            
                                            AND pa.ProviderAuthorizationId = s.ProviderAuthorizationId            
                                            AND ISNULL(pa.RecordDeleted, 'N') = 'N' )              
            
-- Create new authorization event and document                 
            IF @ProviderAuthorizationDocumentId IS NULL             
                BEGIN              
                    INSERT  INTO Events            
            ( StaffId ,            
                              ClientId ,            
                              EventTypeId ,            
                              EventDateTime ,            
                              Status ,            
                              ProviderId ,            
                              InsurerId ,            
                              CreatedBy ,            
                              CreatedDate ,            
                              ModifiedBy ,            
                              ModifiedDate            
                            )            
                            SELECT TOP 1            
                                    1 ,            
                                    s.ClientId ,            
                                    105 ,            
                                    s.EffectiveDate ,            
                                    2063 ,            
                                    s.ProviderId ,            
                                    s.InsurerId ,            
                                    s.CreatedBy ,            
                                    GETDATE() ,            
                                    s.CreatedBy ,            
                                    GETDATE()            
                            FROM    CustomUMStageAthorizations s            
                            WHERE   s.RequestId = @RequestId            
                                    AND ISNULL(s.RecordDeleted, 'N') = 'N'              
              
                    IF @@error <> 0             
                        GOTO error              
                       
                    SET @EventId = @@identity              
     --Task# 72        
     if(@EventId is null)          
     begin          
     UPDATE  s              
     SET     ErrorMessage = ISNULL(pa.AuthorizationNumber, 'Unknown') + ' has been already in use. You cannot create second version of Tx Plan.'              
     FROM    CustomUMStageAthorizations s              
       JOIN ProviderAuthorizations pa ON pa.ProviderAuthorizationId = s.ProviderAuthorizationId              
     WHERE   s.RequestId = @RequestId   
	 AND ISNULL(CONVERT(DATE, s.StartDate), CONVERT(DATE,s.StartDateRequested)) <= CONVERT(DATE, GETDATE())   
	 AND ISNULL(CONVERT(DATE, s.EndDate), CONVERT(DATE,s.EndDateRequested)) >= CONVERT(DATE, GETDATE())           
       AND ISNULL(pa.RecordDeleted, 'N') = 'N'                
                          
     IF @@error <> 0               
      GOTO error             
                            
       GOTO finish                
     end          
     --End#72          
  INSERT  INTO ProviderAuthorizationDocuments            
                            ( InsurerId ,            
                              ClientId ,            
                              EventId ,            
                              RequestorComment ,            
                              ReviewerComment ,            
                              AuthorizationDocumentId ,            
                              CreatedBy ,            
                              CreatedDate ,            
                              ModifiedBy ,            
                              ModifiedDate            
                            )            
                            SELECT  e.InsurerId ,            
                                    e.ClientId ,            
                                    e.Eventid ,            
                                    @RequestorComment ,            
                                    @ReviewerComment ,            
                                    @AuthorizationDocumentId ,            
                                    e.CreatedBy ,            
                                    GETDATE() ,            
                                    e.CreatedBy ,            
GETDATE()            
                            FROM    Events e            
                            WHERE   e.EventId = @EventId                      
                
                    IF @@error <> 0             
                        GOTO error              
                     
                    SET @ProviderAuthorizationDocumentId = @@identity                
                
                    INSERT  INTO dbo.EventDiagnosesIAndII            
                            ( EventId ,            
                              Axis ,            
                              DSMCode ,            
                              DSMNumber ,            
                              DiagnosisType ,            
                              RuleOut ,            
                              Billable ,            
                              Severity ,            
                              DSMVersion ,            
                              DiagnosisOrder ,            
                              Specifier ,            
                              CreatedBy ,            
                              CreatedDate ,            
                              ModifiedBy ,            
                              ModifiedDate            
                            )            
                            SELECT  @EventId ,            
                                    s.Axis ,            
                                    s.DSMCode ,            
                                    s.DSMNumber ,            
                                    s.DiagnosisType ,            
                                    ISNULL(s.RuleOut, 'N') ,            
                                    ISNULL(s.Billable, 'N') ,            
                                    s.Severity ,            
                                    s.DSMVersion ,            
                                    ISNULL(s.DiagnosisOrder, 1) ,            
                                    s.Specifier ,            
                                    @CreatedBy ,            
                                    GETDATE() ,            
         @CreatedBy ,            
                                    GETDATE()            
                            FROM    CustomUMStageEventDiagnosesIAndII s            
                            WHERE   s.RequestId = @RequestId                 
                 
                    IF @@error <> 0             
                        GOTO error              
                 
                    INSERT  INTO EventDiagnosesIII            
                            ( EventId ,            
                              Specification ,            
                              ICDCode1 ,            
                              ICDCode2 ,            
                              ICDCode3 ,            
                              ICDCode4 ,            
                              ICDCode5 ,            
                              ICDCode6 ,            
                              ICDCode7 ,            
                              ICDCode8 ,            
                              ICDCode9 ,            
                              ICDCode10 ,            
                              ICDCode11 ,            
                              ICDCode12 ,            
                              CreatedBy ,            
                              CreatedDate ,            
                              ModifiedBy ,            
                              ModifiedDate            
                            )            
                            SELECT  s.EventId ,            
                                    MAX(s.Specification) ,            
                                    MAX(CASE s.RowNumber            
                                          WHEN 1 THEN s.ICDCode            
                                          ELSE NULL            
                                        END) ,            
                                    MAX(CASE s.RowNumber            
                                          WHEN 2 THEN s.ICDCode            
                                          ELSE NULL            
                                        END) ,            
                                    MAX(CASE s.RowNumber            
       WHEN 3 THEN s.ICDCode            
                                          ELSE NULL            
                                        END) ,            
                                    MAX(CASE s.RowNumber            
                                          WHEN 4 THEN s.ICDCode            
                                          ELSE NULL            
                                        END) ,            
                                    MAX(CASE s.RowNumber            
                                          WHEN 5 THEN s.ICDCode            
                                          ELSE NULL            
                                        END) ,            
                                    MAX(CASE s.RowNumber            
                                          WHEN 6 THEN s.ICDCode            
                                          ELSE NULL            
                              END) ,            
                                    MAX(CASE s.RowNumber            
                                          WHEN 7 THEN s.ICDCode            
                                          ELSE NULL            
                                        END) ,            
                                    MAX(CASE s.RowNumber            
                                          WHEN 8 THEN s.ICDCode            
            ELSE NULL            
                                        END) ,            
                                    MAX(CASE s.RowNumber            
                                          WHEN 9 THEN s.ICDCode            
                                          ELSE NULL            
                                        END) ,            
                                    MAX(CASE s.RowNumber            
                                          WHEN 10 THEN s.ICDCode            
                                    ELSE NULL            
                                        END) ,            
                                    MAX(CASE s.RowNumber            
                                          WHEN 11 THEN s.ICDCode            
                                          ELSE NULL            
                                        END) ,            
                                    MAX(CASE s.RowNumber            
                                          WHEN 12 THEN s.ICDCode            
                                          ELSE NULL            
                                        END) ,            
                                    @CreatedBy ,            
                                    GETDATE() ,            
                                    @CreatedBy ,            
                                    GETDATE()            
                            FROM    ( SELECT  @EventId AS EventId ,            
                                                Specification ,            
                                                ICDCode ,            
                                                row_number() OVER ( ORDER BY UMStageDiagnosisId ) AS RowNumber            
                                      FROM      CustomUMStageEventDiagnosesIII            
                                      WHERE     RequestId = @RequestId            
                                    ) AS s            
                            GROUP BY s.EventId                          
                        
                    IF @@error <> 0             
                        GOTO error              
                
                    INSERT  INTO EventDiagnosesIV            
                            ( EventId ,            
                              PrimarySupport ,            
                              SocialEnvironment ,            
                              Educational ,            
                              Occupational ,            
                              Housing ,            
                              Economic ,            
                              HealthcareServices ,            
                              Legal ,            
                              Other ,            
                              Specification ,            
                              CreatedBy ,            
                              CreatedDate ,            
                              ModifiedBy ,            
                              ModifiedDate            
                            )            
                            SELECT  @EventId ,            
                                    s.PrimarySupport ,            
                                    s.SocialEnvironment ,            
                                    s.Educational ,            
                                    s.Occupational ,            
                                    s.Housing ,            
                                    s.Economic ,            
                                    s.HealthcareServices ,            
                                    s.Legal ,            
                                    s.Other ,            
                                    s.Specification ,            
                                    @CreatedBy ,            
                                    GETDATE() ,            
                                    @CreatedBy ,            
            GETDATE()            
                            FROM    CustomUMStageEventDiagnosesIV s            
                            WHERE   s.RequestId = @RequestId              
              
                    IF @@error <> 0             
                        GOTO error              
                
                    INSERT  INTO EventDiagnosesV            
                            ( EventId ,            
                              AxisV ,            
                              CreatedBy ,            
 CreatedDate ,            
                              ModifiedBy ,            
                 ModifiedDate            
                            )            
                            SELECT  @EventId ,            
                                    s.AxisV ,            
                                    @CreatedBy ,            
                                    GETDATE() ,            
                                    @CreatedBy ,            
                                    GETDATE()            
                            FROM    CustomUMStageEventDiagnosesV s            
                            WHERE   s.RequestId = @RequestId              
              
                    IF @@error <> 0             
                        GOTO error              
                       
                END              
              
-- Remap PM authorization status to CM              
            UPDATE  s            
            SET     Status = CASE s.Status            
                               WHEN 4243 THEN 2042 -- Approved              
             WHEN 4242 THEN 2041 -- Requested              
                               WHEN 4245 THEN 2045 -- Pended              
                               WHEN 4244 THEN 2043 -- Denied              
                               WHEN 304  THEN 2042 -- Approved (From Partially Denied)        
                               WHEN 305  THEN 2042 -- Approved (From Partially Approved)        
                               ELSE s.Status            
                             END            
            FROM    CustomUMStageAthorizations s            
            WHERE   s.RequestId = @RequestId            
                    AND ISNULL(s.RecordDeleted, 'N') = 'N'              
              
            IF @@error <> 0             
                GOTO error              
                   
-- Update already existing authorizations, and create history before updating them              
            INSERT  INTO ProviderAuthorizationsHistory    
                    ( ProviderAuthorizationId ,    
                      InsurerId ,    
                      ClientId ,    
                      ProviderId ,    
                      SiteId ,    
                      BillingCodeId ,    
                      Modifier1 ,    
                      Modifier2 ,    
                      Modifier3 ,    
                      Modifier4 ,    
                      AuthorizationNumber ,    
                      Status ,    
                      StartDateRequested ,    
                      EndDateRequested ,       
                      StartDate ,    
                      EndDate ,       
                      UnitsUsed ,    
                      CreatedBy ,    
                      CreatedDate ,    
                      ModifiedBy ,    
                      ModifiedDate,
                      UnitsRequested,
					  FrequencyTypeRequested,
					  TotalUnitsRequested,
					  UnitsApproved,
					  FrequencyTypeApproved,
					  TotalUnitsApproved     
                    )    
                    SELECT  pa.ProviderAuthorizationId ,    
                            pa.InsurerId ,    
                            pa.ClientId ,    
                            pa.ProviderId ,    
                            pa.SiteId ,    
                            pa.BillingCodeId ,    
                            pa.Modifier1 ,    
                            pa.Modifier2 ,    
                            pa.Modifier3 ,    
                            pa.Modifier4 ,    
                            pa.AuthorizationNumber ,    
                            pa.Status ,    
                            pa.StartDateRequested ,    
                            pa.EndDateRequested ,       
                            pa.StartDate ,    
                            pa.EndDate ,    
                            pa.UnitsUsed ,    
                            s.CreatedBy ,    
                            GETDATE() ,    
                            s.CreatedBy ,    
                            GETDATE(),
                            s.UnitsRequested,
						    s.FrequencyTypeRequested,
						    s.TotalUnitsRequested,        
						    s.UnitsApproved,               
						    s.FrequencyTypeApproved,
						    s.TotalUnitsApproved    
                    FROM    ProviderAuthorizations pa    
                            JOIN CustomUMStageAthorizations s ON s.ProviderAuthorizationId = pa.ProviderAuthorizationId    
                    WHERE   s.RequestId = @RequestId    
                            AND ISNULL(s.RecordDeleted, 'N') = 'N'                    
              
            IF @@error <> 0             
                GOTO error              
                 
             UPDATE  pa    
            SET     InsurerId = s.InsurerId ,    
                    ClientId = s.ClientId ,    
                    ProviderId = s.ProviderId ,    
                    SiteId = s.SiteId ,    
                    BillingCodeId = s.BillingCodeId ,    
                    Modifier1 = s.Modifier1 ,    
                    Modifier2 = s.Modifier2 ,    
                    Modifier3 = s.Modifier3 ,    
                    Modifier4 = s.Modifier4 ,    
                    Status = CASE WHEN s.Status = 2042    
                                       AND ISNULL(s.TotalUnitsApproved, 0) = ISNULL(pa.UnitsUsed,    
                                                              0) THEN 2044    
                                  ELSE s.Status    
                             END ,    
                    StartDateRequested = s.StartDateRequested ,    
                    EndDateRequested = s.EndDateRequested ,    
                    StartDate = s.StartDate ,    
                    EndDate = s.EndDate ,
                    AuthorizationNumber=s.AuthorizationNumber,  --task#177  modified by vikesh       
                    AuthorizationProviderBillingCodeId = s.AuthorizationProviderBillingCodeId ,    
                    Modified = 'Y' ,    
                    ModifiedBy = s.CreatedBy ,    
                    ModifiedDate = GETDATE(), 
                    UnitsRequested= s.UnitsRequested,
					FrequencyTypeRequested= s.FrequencyTypeRequested,
					TotalUnitsRequested=s.TotalUnitsRequested,   
				    UnitsApproved=s.UnitsApproved,
					FrequencyTypeApproved=s.FrequencyTypeApproved,
					TotalUnitsApproved=s.TotalUnitsApproved,
                    AssignedPopulation = s.AssignedPopulation    
            FROM    ProviderAuthorizations pa    
                    JOIN CustomUMStageAthorizations s ON s.ProviderAuthorizationId = pa.ProviderAuthorizationId    
            WHERE   s.RequestId = @RequestId    
                    AND ISNULL(s.RecordDeleted, 'N') = 'N'                   
                 
            IF @@error <> 0             
                GOTO error                   
                                
-- Create new authorizations              
            INSERT  INTO ProviderAuthorizations    
                    ( ProviderAuthorizationDocumentId ,    
                      AuthorizationProviderBillingCodeId ,    
                      InsurerId ,    
                      ClientId ,    
                      ProviderId ,    
                      SiteId ,    
                      BillingCodeId ,    
                      Modifier1 ,    
                      Modifier2 ,    
                      Modifier3 ,    
                      Modifier4 ,    
                      AuthorizationNumber ,    
                      Active ,    
                      Status ,    
                      StartDateRequested ,    
                      EndDateRequested ,    
                      StartDate,  
                      EndDate,     
                      CreatedBy ,    
                      CreatedDate ,    
                      ModifiedBy ,    
                      ModifiedDate,
                      UnitsRequested,
					  FrequencyTypeRequested,
					  TotalUnitsRequested,
					  UnitsApproved,
					  FrequencyTypeApproved,
					  TotalUnitsApproved,
					  RequestedBillingCodeID,
					  BillingCodeModifierID,
					  RequestedBillingCodeModifierId,
					  AssignedPopulation    
                    )    
            OUTPUT  inserted.AuthorizationProviderBillingCodeId ,    
                    inserted.ProviderAuthorizationId    
                    INTO @Authorizations    
                    SELECT  @ProviderAuthorizationDocumentId ,    
                            s.AuthorizationProviderBillingCodeId ,    
                            s.InsurerId ,    
                            s.ClientId ,    
                            s.ProviderId ,    
                            s.SiteId ,    
                            s.BillingCodeId ,    
                            s.Modifier1 ,    
                            s.Modifier2 ,    
                            s.Modifier3 ,    
                            s.Modifier4 ,    
                            s.AuthorizationNumber ,    
                            'Y' ,    
                            s.Status ,    
                            s.StartDateRequested ,    
                            s.EndDateRequested ,     
                            s.StartDate,  
                            s.EndDate,  
                            s.CreatedBy ,    
                            GETDATE() ,    
                            s.CreatedBy ,    
							GETDATE(),
						    s.UnitsRequested,
						    s.FrequencyTypeRequested,
						    s.TotalUnitsRequested,        
						    s.UnitsApproved,               
						    s.FrequencyTypeApproved,
						    s.TotalUnitsApproved,
						    s.BillingCodeId,
							bm.BillingCodeModifierId,
							bm.BillingCodeModifierId,
							@Population
                    FROM    CustomUMStageAthorizations s 
                    --Himmat Added This code----- 
                   JOIN  BillingCodeModifiers bm on s.BillingCodeId=bm.BillingCodeId 
                   AND((isnull(s.Modifier1,'')=isnull(bm.Modifier1,'')) 
                   AND(isnull(s.Modifier2,'')=isnull(bm.Modifier2,''))
                   AND(isnull(s.Modifier3,'')=isnull(bm.Modifier3,''))
                   AND(isnull(s.Modifier4,'')=isnull(bm.Modifier4,'')))  
                    WHERE   s.RequestId = @RequestId    
                            AND s.ProviderAuthorizationId IS NULL    
                            AND ISNULL(s.RecordDeleted, 'N') = 'N'                
						    AND ISNULL(bm.RecordDeleted, 'N') = 'N' 
				 --ENd	    
                    
                                   
                        
                        
                        
    -- if(@Population is not null)          
    -- Begin          
    --  if exists (select 1 from @Authorizations)        
    --  Begin        
    -- insert into CustomProviderAuthorizationPopulations          
    -- (          
    --   ProviderAuthorizationId,          
    --   Population,          
    --   CreatedBy,          
    --   CreatedDate,          
    --   ModifiedBy,          
    --   ModifiedDate          
    -- )          
    -- Select           
    --   pa.ProviderAuthorizationId,          
    --   @Population,          
    --   pa.CreatedBy,          
    --   GETDATE(),          
    --   pa.ModifiedBy,          
    --   GETDATE()          
    -- from ProviderAuthorizations pa          
    -- inner join @Authorizations a on a.ProviderAuthorizationId=pa.ProviderAuthorizationId        
    --End        
    -- End             
        
     IF @@error <> 0               
                GOTO error             
                            
              
-- Map SC to CM authorizations                 
            UPDATE  s            
            SET     ProviderAuthorizationId = a.ProviderAuthorizationId ,            
                    ProviderAuthorizationDocumentId = @ProviderAuthorizationDocumentId ,            
                    UnitsUsed = ISNULL(pa.UnitsUsed,0)          
            FROM    CustomUMStageAthorizations s            
                    JOIN @Authorizations a ON a.AuthorizationProviderBillingCodeId = s.AuthorizationProviderBillingCodeId            
                    LEFT JOIN ProviderAuthorizations pa ON pa.ProviderAuthorizationId = s.ProviderAuthorizationId            
            WHERE   s.RequestId = @RequestId            
                    AND ISNULL(s.RecordDeleted, 'N') = 'N'              
              
            IF @@error <> 0             
                GOTO error           
                        
                Update cpap        
                set cpap.Population=gc.GlobalCodeId        
                from CustomProviderAuthorizationPopulations cpap        
     join CustomUMStageAthorizations ca on ca.ProviderAuthorizationId=cpap.ProviderAuthorizationId        
     join CustomAuthorizationPopulations sa on sa.AuthorizationId=ca.AuthorizationId        
     join GlobalCodes sgc on sgc.GlobalCodeId=sa.Population        
     join GlobalCodes gc on gc.Code=sgc.Code and gc.Category='XPRESENTINGPOP'                    
                where ca.RequestId=@RequestId        
                        
                insert into CustomProviderAuthorizationPopulations          
    (          
      ProviderAuthorizationId,          
      Population,          
      CreatedBy,          
      CreatedDate,          
      ModifiedBy,          
      ModifiedDate          
    )          
                        
                select Distinct ca.ProviderAuthorizationId,        
      gc.GlobalCodeId,         
      ca.CreatedBy,        
      ca.CreateDate,        
      ca.CreatedBy,        
      getdate()        
    from CustomUMStageAthorizations ca         
     join CustomAuthorizationPopulations sa on sa.AuthorizationId=ca.AuthorizationId        
     join GlobalCodes sgc on sgc.GlobalCodeId=sa.Population        
     join GlobalCodes gc on gc.Code=sgc.Code and gc.Category='XPRESENTINGPOP'                       
                where ca.RequestId=@RequestId and         
                Not exists(        
                select 'X' from CustomProviderAuthorizationPopulations cpap where cpap.ProviderAuthorizationId=ca.ProviderAuthorizationId)        
                        
                        
                IF @@error <> 0             
                GOTO error               
          
-- Delete authorizations              
            UPDATE  pa            
            SET     RecordDeleted = 'Y' ,            
                    DeletedBy = @CreatedBy ,            
                    DeletedDate = GETDATE()            
            FROM    CustomUMStageAthorizations s            
                    JOIN ProviderAuthorizations pa ON pa.ProviderAuthorizationId = s.ProviderAuthorizationId            
            WHERE   s.RequestId = @RequestId            
                    AND s.RecordDeleted = 'Y'              
              
            IF @@error <> 0             
                GOTO error              
                 
-- Delete authorization document, event and diagnoses if there is no authorization left                 
        DECLARE @DeleteEvent TABLE ( EventId INT )              
                 
            UPDATE  pad            
            SET     RecordDeleted = 'Y' ,            
                    DeletedBy = @CreatedBy ,            
                    DeletedDate = GETDATE()            
            OUTPUT  inserted.EventId            
                    INTO @DeleteEvent ( EventId )            
            FROM    ProviderAuthorizationDocuments pad            
            WHERE   pad.AuthorizationDocumentId = @ProviderAuthorizationDocumentId            
                    AND NOT EXISTS ( SELECT *            
                                     FROM   ProviderAuthorizations pa            
                                     WHERE  pa.ProviderAuthorizationDocumentId = pad.AuthorizationDocumentId            
                                            AND ISNULL(pa.RecordDeleted, 'N') = 'N' )                                  
                    
            IF @@error <> 0             
                GOTO error        
              
            UPDATE  e            
            SET     RecordDeleted = 'Y' ,            
                    DeletedBy = @CreatedBy ,            
                    DeletedDate = GETDATE()            
            FROM    EventDiagnosesIAndII e            
                    JOIN @DeleteEvent d ON d.EventId = e.EventId              
              
            IF @@error <> 0             
                GOTO error              
              
            UPDATE  e            
            SET     RecordDeleted = 'Y' ,            
                    DeletedBy = @CreatedBy ,            
                    DeletedDate = GETDATE()            
            FROM    EventDiagnosesIII e            
                    JOIN @DeleteEvent d ON d.EventId = e.EventId              
              
            IF @@error <> 0             
                GOTO error              
              
            UPDATE  e            
            SET     RecordDeleted = 'Y' ,            
                    DeletedBy = @CreatedBy ,            
                    DeletedDate = GETDATE()            
            FROM    EventDiagnosesIV e            
                    JOIN @DeleteEvent d ON d.EventId = e.EventId              
              
            IF @@error <> 0             
                GOTO error              
              
            UPDATE  e            
            SET     RecordDeleted = 'Y' ,            
                    DeletedBy = @CreatedBy ,            
                    DeletedDate = GETDATE()            
            FROM    EventDiagnosesV e            
                    JOIN @DeleteEvent d ON d.EventId = e.EventId              
              
           IF @@error <> 0             
                GOTO error              
        END            
    finish:              
              
    RETURN              
              
  error:              
    --RAISERROR 50010 'Failed to execute csp_CMUMAuthorizations'              
    


