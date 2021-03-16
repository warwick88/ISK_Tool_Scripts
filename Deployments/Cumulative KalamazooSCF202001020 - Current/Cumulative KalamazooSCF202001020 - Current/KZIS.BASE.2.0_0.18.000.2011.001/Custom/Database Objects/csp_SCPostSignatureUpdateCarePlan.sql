

/****** Object:  StoredProcedure [dbo].[csp_SCPostSignatureUpdateCarePlan]    Script Date: 12/28/2017 17:27:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCPostSignatureUpdateCarePlan]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCPostSignatureUpdateCarePlan]
GO



/****** Object:  StoredProcedure [dbo].[csp_SCPostSignatureUpdateCarePlan]    Script Date: 12/28/2017 17:27:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
 
   
CREATE procedure [dbo].[csp_SCPostSignatureUpdateCarePlan]  
@ScreenKeyId int,                            
@StaffId int,                            
@CurrentUser varchar(30),                            
@CustomParameters xml           
/*********************************************************************                  
-- Stored Procedure: dbo.csp_SCPostSignatureUpdateCarePlan        
-- Copyright: Streamline Healthcare Solutions        
--                                                         
-- Purpose: post signature process        
--                                                                                          
-- Modified Date  Modified By  Purpose        
-- 07.15.2011   SFarber   Created.        
-- 09.12.2011   SFarber   Modified to default TPProcedureBillingCodes        
-- 11.10.2011   Sourabh   Modified to insert um notes w.rf. to task 374       
-- 11.24.2011   Rakesh   Add check while inserting CLientUMNotes table w.rf. to task 374       
-- 12.30.2011   RNoble   Modified 'ReviewLevel' logic for CCM.    
-- 01.05.2012   avoss   changed line 186 from isnull(a.EndDateRequested, '1/1/1970') = isnull(tpp.EndDate, '1/1/1970') to <>  
-- 02.10.2012   RNoble   Added CareManagementClientId matching logic.  
-- 02.10.2012   RNoble   Modified logic for setting ProviderAuthorizationDocumentID returned from CM.  
-- 02.10.2012   RNoble   Modified logic to call csp_SCLinkClientToCMClient for client linking.  
-- 03.12.2012   avoss   dont validate for external auths on addendums that where pulled through to the addendum becaus original request could be  
          different from the approved auth  
-- 03.15.2012   avoss   dont do anything on cosignatures.  
-- 03.16.2012   Sudhir Singh Added condition for system pended in procedure 'csp_postUpdateAuthorizationStatusToSystemPended'      
-- 03.19.2012   dharvey   Added @DocumentId to CoSigner check  
-- 03.27.2012   avoss   added check for authorizationnumber to correct issue in cm  
-- 06.17.2012   SFarber   Modified to use synonyms 'CM_' istead of directly referencing CM objects  
-- 07.11.2012   Sourabh   Modified to insert FrequencyTypeRequested field in CustomUMStageAthorizations  table wrt#1674 in Kalamazoo Bugs -Go Live  
-- 10.18.2012   Atul Pandey  Modified to generate 'Tx plan delivery note' for task #23 of project Allegan   
-- 11.05.2012   Atul Pandey  Commented  execution of 'csp_postUpdateAuthorizationStatusToSystemPended' to turn off  System Pend status customization  
          for task #33 of project Allegan CMH Develoopment Implementation   
 3/20/2013   Vishant Garg Commented Capitated='Y'  
 3/28/2013   Shikha Arora modified for stop exec sp "csp_AutoPopulateTxPlanDelivery" twice for generating delivery note  
 02 April 13   Shikha Arora for ref task #557 in 3.x issues  
          What/Why:Recode Function is called to fetch CoveragePlanIds that can use  authorization   
          created in Treatment Plan instead of capitated='Y'  and check validation if no coverage plan exist  
 24/Apr/2013   Mamta Gupta  Ref task 101 - Allegan Customizations Issues Tracking  
          What : Modified conditions to create delivery notec calling csp_AutoPopulateTxPlanDelivery storedprocedure  
          Why : need to create only one delivery note only with first version while signing by author  
    24/Sept/2013  Malathi Shiva If there was an existing Authorization with "Partially Aproved" Status then after signing a new TP the Authorization status was modified to "Requested" Task# 204 Allegan - Support  
    3/13/2017           MD Hussain K    Added logic to initialize Assigned Population from Client Information - Custom Fields tab to Authorziation - Assigned Population field w.r.t KMCHSAS - Support #542  
-- 26 April 2017    PradeepT     What:Remove Use of Synonym that poits to CM DB and Comented CaremanagementId referance. Comment execution of csp_SCLinkClientToCMClient  
--                               Why: There is no use to point CM DB As we are using single DB for Both CM AND Sc DB.   
    2017-12-27          esova           removed call to csp_AutoPopulateTxPlanDelivery  look for ~esova below for commented out part 
 -- 02/09/2018      Hemant  Added logic to initialize Assigned Population from Client Information - Custom Fields tab to ProviderAuthorziation - Assigned Population field w.r.t KMCHSAS - Enhancements #542    
 -- 03/15/2018      Vijeta  Uncommented the logic for 'If there is any change, authorization need to be reapproved' if TpProcedures are modifying in another version of document. KMCHSAS - Support #1016
 --13/04/2018   Prem     What/Why:Replaced @CareManagementClientId with @ClientId as part of KCMHSAS - Support #1049
 --12/21/2018   MD       Added logic to delete duplicate TPProcedures if exists before creating authorization w.r.t KCMHSAS - Support #1206
 08 Feb 2019  Kavya.N   Added startdate, enddate some other columns for authorization insert query, as these values required in Authorization document 
 Why: Post BC3: Prod/QA: Pended Auths issue_ Kalamazoo SGL#1279
 20 Nov 2020  Sunil D    What:Added logic to write the ProviderID to the TPProcedures and Authorizations tables.
						 Why: Individualized service plan document is not writing authorizations appropriately.KCMHSAS Build Cycle Tasks #110.
****************************************************************************/                   
as                
        
set nocount on        
        
declare @DocumentId int        
declare @DocumentVersionId int        
declare @AuthorizationDocumentId int        
declare @ClientId int        
declare @AuthorizationStartDate datetime        
declare @AuthorizationEndDate datetime        
declare @ClientCoveragePlanId int        
declare @EffectiveDate datetime        
--declare @CareManagementClientId int        
declare @InsurerId int        
declare @RequestId uniqueidentifier         
declare @PlanOrAddendum char(2)         
DECLARE @IsCosigner CHAR(1) = 'N' 
declare @Population int 
        
 DECLARE @DocumentCodeId INT   -- added by shikha    
declare @AuthorizationStatus table (AuthorizationId int, TPProcedureId int, Status varchar(10))        
declare @LOCCaps table (AuthorizationId int, LOCId int, UMCodeId int, CoveragePlanId int, LOCUMCodeId int)        
  
select @DocumentId = @ScreenKeyId   
  
  
  
IF EXISTS ( SELECT 1 FROM dbo.DocumentSignatures ds   
   WHERE ds.DocumentId = @DocumentId   
   and ds.StaffId = @StaffId   
   AND ds.SignatureOrder > 1   
   AND ISNULL(ds.RecordDeleted,'N') <> 'Y'   
   )  
 BEGIN  
  SET @IsCosigner = 'Y'  
 END       
        
declare @ValidationErrors table (                                 
TableName       varchar(200),                                    
ColumnName      varchar(200),                                    
ErrorMessage    varchar(200),                                    
PageIndex       int,        
TabOrder       int,        
ValidationOrder int)        
        
       
        
select @ClientId = d.ClientId,  @DocumentCodeId = d.DocumentCodeId,  -- added by shikha    
       @DocumentVersionId = d.CurrentDocumentVersionId,         
       @EffectiveDate = d.EffectiveDate        
  from Documents d        
 where d.DocumentId = @DocumentId        


 DECLARE @EnableAutoAuthorizationCreation VARCHAR(10)
 SET @EnableAutoAuthorizationCreation=(SELECT [Value] FROM SystemConfigurationKeys WHERE [Key]='EnableAutoAuthorizationCreationFromISPIntervention')
 IF @EnableAutoAuthorizationCreation='No'
	 BEGIN
		GOTO final;
	 END

  IF EXISTS(SELECT 1 FROM CustomCarePlanPrescribedServices WHERE DocumentVersionId=@DocumentVersionId AND AuthorizationCodeId IS NOT NULL
			AND ProviderId IS NOT NULL AND FromDate IS NOT NULL AND ToDate IS NOT NULL AND Units IS NOT NULL AND Frequency IS NOT NULL 
			AND TotalUnits IS NOT NULL AND ISNULL(RecordDeleted, 'N') = 'N' AND ProviderId NOT IN (-1,-2) AND IsInitializedFrom IS NULL)
	BEGIN
		INSERT INTO TPProcedures(DocumentVersionId,AuthorizationCodeId,Units,FrequencyType,ProviderId,SiteId,StartDate,EndDate,TotalUnits)
		SELECT CPS.DocumentVersionId,CPS.AuthorizationCodeId,CPS.Units,CPS.Frequency,S.ProviderId,CPS.ProviderId,CPS.FromDate,CPS.ToDate,CPS.TotalUnits
		FROM CustomCarePlanPrescribedServices CPS
		join Sites S on CPS.ProviderId=S.SiteId
		WHERE CPS.DocumentVersionId=@DocumentVersionId AND CPS.AuthorizationCodeId IS NOT NULL
			AND CPS.ProviderId IS NOT NULL AND CPS.FromDate IS NOT NULL AND CPS.ToDate IS NOT NULL AND CPS.Units IS NOT NULL AND CPS.Frequency IS NOT NULL 
			AND CPS.TotalUnits IS NOT NULL AND ISNULL(CPS.RecordDeleted, 'N') = 'N' AND CPS.ProviderId NOT IN (-1,-2) AND CPS.IsInitializedFrom IS NULL

	END

           
select @AuthorizationDocumentId = max(ad.AuthorizationDocumentId)        
  from AuthorizationDocuments ad        
 where ad.DocumentId = @DocumentId        
   and isnull(ad.RecordDeleted, 'N') = 'N'             
        
select @PlanOrAddendum = tp.CarePlanType         
  from DocumentCarePlans tp        
 where tp.DocumentVersionId = @DocumentVersionId        
  
----Get AssignedPopulation from Client Information - Custom Fields tab  
Declare @AssignedPopulation int  
select @AssignedPopulation = ColumnGlobalCode7  
From CustomFieldsData Where PrimaryKey1 = @ClientId and isnull(RecordDeleted, 'N') = 'N'  
  
---- Check and delete duplicate TP Procedures if exists in TPProcedures table ---------------
---- This is a temporary fix added after analysing the existing data in system due to urgent task - KCMHSAS - Support #1206

;with DuplicateTPProcedureData as(
select TPProcedureId,DocumentVersionId,AuthorizationCodeId,Units,FrequencyType,ProviderId,SiteId,StartDate,EndDate,TotalUnits
 ,ROW_NUMBER() OVER (  
    PARTITION BY DocumentVersionId,AuthorizationCodeId,Units,FrequencyType,ProviderId,SiteId,StartDate,EndDate,TotalUnits
    ORDER BY DocumentVersionId  
    )  as RRank
from TPProcedures 
where isnull(recordDeleted,'N')='N' and AuthorizationId is null and DocumentVersionId = @DocumentVersionId
group by TPProcedureId,DocumentVersionId,AuthorizationCodeId,Units,FrequencyType,ProviderId,SiteId,StartDate,EndDate,TotalUnits 
)

Update tp
set RecordDeleted='Y', DeletedDate=getdate(), DeletedBy='DuplicateData'
from TPProcedures tp 
join DuplicateTPProcedureData dt on tp.TPProcedureId = dt.TPProcedureId
where ISNULL(tp.RecordDeleted,'N')='N' and dt.RRank>=2

Update DocumentVersions Set RefreshView='Y' Where DocumentVersionId = @DocumentVersionId
-------------------------------------------------------------------------------------------------
  
IF EXISTS ( SELECT  1  
            FROM    Authorizations a  
            WHERE   a.AuthorizationNumber IS NULL  
                    AND a.AuthorizationDocumentId = @AuthorizationDocumentId  
                    AND ISNULL(a.RecordDeleted, 'N') <> 'Y'  
                    AND a.ProviderId IS NOT NULL )   
    BEGIN  
   
        UPDATE  a  
        SET     AuthorizationNumber = 'UM-' + CONVERT(VARCHAR(4), DATEPART(YY,  
                                                              GETDATE()), 101)  
                + CASE WHEN DATEPART(MONTH, GETDATE()) < 10  
                       THEN '0' + CONVERT(VARCHAR(2), DATEPART(MONTH,  
                                                              GETDATE()))  
                       ELSE CONVERT(VARCHAR(2), DATEPART(MONTH, GETDATE()))  
                  END + CASE WHEN DATEPART(DAY, GETDATE()) < 10  
                             THEN '0' + CONVERT(VARCHAR(2), DATEPART(DAY,  
                                                              GETDATE()))  
                             ELSE CONVERT(VARCHAR(2), DATEPART(DAY, GETDATE()))  
                        END + '-'  
                + CASE WHEN a.TPProcedureId IS NULL  
                       THEN CONVERT(VARCHAR(12), a.AuthorizationId)  
                       ELSE CONVERT(VARCHAR(12), a.TPProcedureId)  
                  END  
        FROM    Authorizations a  
        WHERE   a.AuthorizationNumber IS NULL  
                AND a.AuthorizationDocumentId = @AuthorizationDocumentId  
                AND ISNULL(a.RecordDeleted, 'N') <> 'Y'  
                AND a.ProviderId IS NOT NULL  
   
    END  
         
-- Return if there are no TPProcedures records and no previously created authorization documents                             
if @AuthorizationDocumentId is null and        
   not exists (select *         
                 from TPProcedures tpp         
                where tpp.DocumentVersionId = @DocumentVersionId        
                  and isnull(tpp.RecordDeleted, 'N') = 'N')        
  goto final                                      
  
IF @IsCosigner = 'Y'  
 GOTO final  
   
-- Try to link the client if it isn't already linked  
--EXEC csp_SCLinkClientToCMClient @ClientId  
      
-- Validate new document version        
insert into @ValidationErrors (TableName, ColumnName, ErrorMessage)        
select 'TPProcedures', 'DeletedBy', 'Cannot change from ' + aca.DisplayAs + ' to ' + act.DisplayAs +          
       '.  Authorization #' + isnull(a.AuthorizationNumber, 'Unknown') + ' has been already in use.'        
  from TPProcedures tpp        
       join Authorizations a on a.AuthorizationId = tpp.AuthorizationId        
       join AuthorizationCodes act on act.AuthorizationCodeId = tpp.AuthorizationCodeId        
       join AuthorizationCodes aca on aca.AuthorizationCodeId = a.AuthorizationCodeId        
 where tpp.DocumentVersionId = @DocumentVersionId   
   /* AVOSS Added logic to exclude addedum procedures 03.13.2012 as the authorization could have changed from the original request on the tp */  
   AND ( ( @PlanOrAddendum = 'AD' AND OriginalTPProcedureId IS NULL ) OR @PlanOrAddendum = 'AN' )           
   and tpp.AuthorizationCodeId <> a.AuthorizationCodeId        
   and isnull(a.UnitsUsed, 0) > 0        
   and isnull(tpp.RecordDeleted, 'N') = 'N'        
   and isnull(a.RecordDeleted, 'N') = 'N'        
        
if @@error <> 0 goto error        
           
insert into @ValidationErrors (TableName, ColumnName, ErrorMessage)        
select 'TPProcedures', 'DeletedBy', 'Cannot modify ' +         
       substring(case when isnull(a.UnitsRequested,0) <> isnull(tpp.Units,0) then ', Units' else '' end +        
                 case when isnull(a.FrequencyRequested, -1) <> isnull(tpp.FrequencyType, -1) then ', Frequency' else '' end +         
case when isnull(a.StartDateRequested, '1/1/1900') <> isnull(tpp.StartDate, '1/1/1900') then ', Start Date' else '' end +         
                 case when isnull(a.EndDateRequested, '1/1/1900') <> isnull(tpp.EndDate, '1/1/1900') then ', End Date' else '' end +        
                 case when isnull(a.TotalUnitsRequested, -1) <> isnull(tpp.TotalUnits, -1) then ', Total Units' else '' end +        
                 case when isnull(a.ProviderId, -1) <> isnull(tpp.ProviderId, -1) then ', Provider' else '' end +        
                 case when isnull(a.SiteId, -1) <> isnull(tpp.SiteId, -1) then ', Site' else '' end, 3, 100) +            
                 ' information for ' + ac.DisplayAs +         
                 '.  Authorization #' + isnull(a.AuthorizationNumber, 'Unknown') + ' has been already in use.'        
  from TPProcedures tpp        
       join Authorizations a on a.AuthorizationId = tpp.AuthorizationId        
       join AuthorizationCodes ac on ac.AuthorizationCodeId = tpp.AuthorizationCodeId        
 where tpp.DocumentVersionId = @DocumentVersionId   
   and tpp.AuthorizationCodeId = a.AuthorizationCodeId        
   /* AVOSS Added logic to exclude addedum procedures 03.13.2012 as the authorization could have changed from the original request on the tp */  
   AND ( ( @PlanOrAddendum = 'AD' AND OriginalTPProcedureId IS NULL ) OR @PlanOrAddendum = 'AN' )  
   and isnull(a.UnitsUsed, 0) > 0        
   and isnull(tpp.RecordDeleted, 'N') = 'N'        
   and isnull(a.RecordDeleted, 'N') = 'N'        
   and (isnull(a.UnitsRequested,0) <> isnull(tpp.Units,0) or                                     
        isnull(a.FrequencyRequested, -1) <> isnull(tpp.FrequencyType, -1) or        
        isnull(a.StartDateRequested, '1/1/1900') <> isnull(tpp.StartDate, '1/1/1900') or        
        isnull(a.EndDateRequested, '1/1/1900') <> isnull(tpp.EndDate, '1/1/1900') or                                    
        isnull(a.TotalUnitsRequested, -1) <> isnull(tpp.TotalUnits, -1) or                                       
        isnull(a.ProviderId, -1) <> isnull(tpp.ProviderId, -1) or        
        isnull(a.SiteId, -1) <> isnull(tpp.SiteId, -1))                          
           
if @@error <> 0 goto error        
        
insert into @ValidationErrors (TableName, ColumnName, ErrorMessage)        
select 'TPProcedures', 'DeletedBy', 'Cannot decrease Units below Used Units for ' + ac.DisplayAs +         
       '.  Authorization #' + isnull(a.AuthorizationNumber, 'Unknown') + ' has been already in use.'        
  from TPProcedures tpp        
       join Authorizations a on a.AuthorizationId = tpp.AuthorizationId        
       join AuthorizationCodes ac on ac.AuthorizationCodeId = tpp.AuthorizationCodeId        
 where tpp.DocumentVersionId = @DocumentVersionId        
    /* AVOSS Added logic to exclude addedum procedures 03.13.2012 as the authorization could have changed from the original request on the tp */  
   AND ( ( @PlanOrAddendum = 'AD' AND OriginalTPProcedureId IS NULL ) OR @PlanOrAddendum = 'AN' )                
   and tpp.AuthorizationCodeId = a.AuthorizationCodeId        
   and isnull(tpp.TotalUnits, 0) < isnull(a.UnitsUsed, 0)        
   and isnull(tpp.RecordDeleted, 'N') = 'N'        
   and isnull(a.RecordDeleted, 'N') = 'N'        
           
if @@error <> 0 goto error        
        
insert into @ValidationErrors (TableName, ColumnName, ErrorMessage)        
select 'TPProcedures', 'DeletedBy', 'Cannot delete ' + ac.DisplayAs + '.  Authorization #' + isnull(a.AuthorizationNumber, 'Unknown') + ' has been already in use.'        
  from TPProcedures tpp        
       join Authorizations a on a.AuthorizationId = tpp.AuthorizationId        
       join AuthorizationCodes ac on ac.AuthorizationCodeId = tpp.AuthorizationCodeId        
 where tpp.DocumentVersionId = @DocumentVersionId    
   and isnull(a.UnitsUsed, 0) > 0        
   and tpp.RecordDeleted = 'Y'        
   and isnull(a.RecordDeleted, 'N') = 'N'        
           
if @@error <> 0 goto error   
       
  -- Determine coverage plan  (copied from below )  
select @AuthorizationStartDate = min(tpp.StartDate), @AuthorizationEndDate = max(tpp.EndDate)                                      
  from TPProcedures tpp                                      
 where tpp.DocumentVersionId = @DocumentVersionId        
   and isnull(tpp.RecordDeleted, 'N') = 'N'        
           
select top 1 @ClientCoveragePlanId = ccp.ClientCoveragePlanId                                      
  from ClientCoveragePlans ccp                                      
       join ClientCoverageHistory cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId        
       join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId    
         
       -- (by Shikha for ref task #557 in 3.x issues  
       -- What/Why:Recode Function is called to fetch CoveragePlanIds that can use  authorization   
       -- created in Treatment Plan instead of capitated='Y'  
       join dbo.ssf_RecodeValuesCurrent('RECODECAPCOVERAGEPLANID') CAPCP on cp.CoveragePlanId=CAPCP.IntegerCodeId   
      
 where ccp.ClientId = @ClientId    
 /*Commented By Vishant Garg  
  When a user signs and Authorization Document or Treatment Plan, the signed document is creating authorizations but in the authorizations table  
  the Coverage Plan = Null.  So users are not able to see the authorizations in the Auth Documents list page or the client Authorizations list page.   
  In postupdatesignature sp we have a logic that if CoveragePlan.Capitated='Y' then it will assign clientcoverageplanid to that authorization.  
  And on authorization list page sp we have the same logic to get the data.'  
  However, Interact, Allegan, and Kalamazoo all require authorizations to be generated and reviewed.  In task 517 for Allegan in 3.x issues  
 */                                    
  -- and cp.Capitated = 'Y'                                      
   and cch.StartDate <= @AuthorizationEndDate                                      
   and (cch.EndDate is null or dateadd(dd, 1, cch.EndDate) > @AuthorizationStartDate)                                      
   and isnull(ccp.RecordDeleted,'N') = 'N'         
   and isnull(cch.RecordDeleted,'N') = 'N'         
   and isnull(cp.RecordDeleted,'N') = 'N'         
 order by cch.StartDate, cch.COBOrder   
          
  if(isnull(@ClientCoveragePlanId,0)=0)  
  begin  
   insert into @ValidationErrors (TableName, ColumnName, ErrorMessage)   
   Select 'TPProcedures', 'DeletedBy','Client does not have a coverage plan that uses authorizations. Please contact administrator'  
  end  
    
  if @@error <> 0 goto error     
         
if exists(select * from @ValidationErrors)         
  goto final        
          
-- If there is any change, authorization need to be reapproved        
update a        
   set AuthorizationCodeId = tpp.AuthorizationCodeId,        
       Status = 4242, -- Requested        
       ReviewLevel = 6681, -- LCM        
       ReviewerId = null,        
    ReviewerOther = null,        
       ReviewedOn = null,        
       UnitsRequested = tpp.Units,         
       FrequencyRequested = tpp.FrequencyType,         
       StartDateRequested = convert(datetime, convert(varchar, tpp.StartDate, 101)),        
       EndDateRequested = convert(datetime, convert(varchar, tpp.EndDate, 101)),         
       TotalUnitsRequested = tpp.TotalUnits,           
       Units = null,        
       Frequency = null,        
       StartDate = null,        
       EndDate = null,        
       ProviderId = tpp.ProviderId,         
       SiteId = tpp.SiteId,        
       DateRequested = convert(date, getdate()),         
       DateReceived = convert(date, getdate()),         
       Urgent = tpp.Urgent,        
       ModifiedBy = tpp.ModifiedBy,         
       ModifiedDate = getdate()        
output inserted.AuthorizationId, inserted.TPProcedureId, 'MODIFIED' into @AuthorizationStatus        
  from Authorizations a                                      
       join TPProcedures tpp on tpp.AuthorizationId = a.AuthorizationId    
       Join DocumentVersions dv on dv.DocumentVersionId = tpp.DocumentVersionId           
 where tpp.DocumentVersionId = @DocumentVersionId                                     
   and isnull(a.RecordDeleted, 'N') = 'N'                                      
   and isnull(tpp.RecordDeleted, 'N') = 'N' 
   and isnull(dv.RecordDeleted, 'N') = 'N'
   and dv.Version > 1
   and (a.AuthorizationCodeId <> tpp.AuthorizationCodeId or         
        isnull(a.UnitsRequested,0) <> isnull(tpp.Units,0) or                                     
        isnull(a.FrequencyRequested, -1) <> isnull(tpp.FrequencyType, -1) or        
        isnull(a.StartDateRequested, '1/1/1970') <> isnull(tpp.StartDate, '1/1/1970') or        
        isnull(a.EndDateRequested, '1/1/1970') <> isnull(tpp.EndDate, '1/1/1970') or                                    
        isnull(a.TotalUnitsRequested, -1) <> isnull(tpp.TotalUnits, -1) or                                       
        isnull(a.ProviderId, -1) <> isnull(tpp.ProviderId, -1) or        
        isnull(a.SiteId, -1) <> isnull(tpp.SiteId, -1))                          
                     
if @@error <> 0 goto error        
        
-- Create/update Authorization document           
        
-- Determine coverage plan        
 -- Region is moved from here to above for making validations  
        
if @AuthorizationDocumentId is null        
begin        
  insert into AuthorizationDocuments (                                     
         DocumentId,        
         ClientCoveragePlanId,         
         Assigned,         
         StaffId,         
         --RequesterComment,         
         CreatedBy,         
         CreatedDate,                   
         ModifiedBy,        
         ModifiedDate)                                      
  select @DocumentId,         
         @ClientCoveragePlanId,         
         tpg.UMArea,         
         d.AuthorId,         
         --tpg.AuthorizationRequestorComment,                                      
         @CurrentUser,         
         getdate(),        
         @CurrentUser,         
         getdate()                                      
    from Documents d        
         join CustomDocumentCarePlans tpg on tpg.DocumentVersionId = d.CurrentDocumentVersionId        
   where d.DocumentId = @DocumentId                                      
        
  if @@error <> 0 goto error        
        
  set @AuthorizationDocumentId = @@identity        
end        
else        
begin        
  update ad        
     set ClientCoveragePlanId = @ClientCoveragePlanId,         
         Assigned = tpg.UMArea,         
		 --RequesterComment = tpg.AuthorizationRequestorComment,         
         ModifiedBy = @CurrentUser,        
         ModifiedDate = getdate()        
    from AuthorizationDocuments ad        
         join Documents d on d.DocumentId = ad.DocumentId        
         join CustomDocumentCarePlans tpg on tpg.DocumentVersionId = d.CurrentDocumentVersionId        
   where ad.AuthorizationDocumentId = @AuthorizationDocumentId                                     
     and (isnull(tpg.UMArea, 0) <> isnull(tpg.UMArea, 0) or        
          --isnull(convert(varchar(max), tpg.AuthorizationRequestorComment), '') <> isnull(convert(varchar(max), ad.RequesterComment), '') or        
          isnull(@ClientCoveragePlanId, -1) <> isnull(ad.ClientCoveragePlanId, -1))        
        
  if @@error <> 0 goto error        
end        
        
        
-- New authorizations        
insert into Authorizations (                                      
       AuthorizationDocumentId,         
       AuthorizationNumber,        
       AuthorizationCodeId,         
       Status,         
       ReviewLevel,        
       TPProcedureId,                                      
       UnitsRequested,         
       FrequencyRequested,         
       StartDateRequested,         
       EndDateRequested,                                       
       TotalUnitsRequested,        
       ProviderId,        
       SiteId,        
       DateRequested,        
       DateReceived,        
       Urgent,        
       CreatedBy,         
       CreatedDate,                                      
       ModifiedBy,         
       ModifiedDate,  
       AssignedPopulation,
       units,
       startdate,
       enddate,
       frequency,
       Totalunits
     )                                      
output inserted.AuthorizationId, inserted.TPProcedureId, 'NEW' into @AuthorizationStatus        
select @AuthorizationDocumentId,         
       'UM-' + convert(char(8), getdate(), 112) + '-' + convert(varchar, tpp.TPProcedureId),        
       tpp.AuthorizationCodeId,         
       4242, -- Requested        
       6681, -- LCM        
       tpp.TPProcedureId,                   
       tpp.Units,         
       tpp.FrequencyType,         
       convert(datetime, convert(varchar, tpp.StartDate, 101)),        
       convert(datetime, convert(varchar, tpp.EndDate, 101)),         
       tpp.TotalUnits,                                 
       tpp.ProviderId,         
       tpp.SiteId,        
       convert(date, getdate()),        
       convert(date, getdate()),         
       tpp.Urgent,        
       'PostUpdateTreatmentPlan',         
       getdate(),                                       
       'PostUpdateTreatmentPlan',         
       getdate(),  
       @AssignedPopulation  ,
       tpp.units,
       convert(datetime, convert(varchar, tpp.StartDate, 101)),        
       convert(datetime, convert(varchar, tpp.EndDate, 101)),
       tpp.FrequencyType,
       tpp.TotalUnits
                                           
  from TPProcedures tpp                    
 where tpp.DocumentVersionId = @DocumentVersionId        
   and tpp.AuthorizationId is null        
   and isnull(tpp.RecordDeleted, 'N') = 'N'                    
        
if @@error <> 0 goto error        
        
-- Map procedures to new authorizations        
update tp        
   set AuthorizationId = s.AuthorizationId        
  from TPProcedures tp        
       join @AuthorizationStatus s on s.TPProcedureId = tp.TPProcedureId        
 where s.Status = 'NEW'        
        
if @@error <> 0 goto error        
        
-- Delete never used atuhorizations for no longer needed procedures         
update a        
   set RecordDeleted = 'Y',        
       DeletedBy = @CurrentUser,        
       DeletedDate = getdate()        
output inserted.AuthorizationId, inserted.TPProcedureId, 'DELETED' into @AuthorizationStatus        
  from Authorizations a        
       join TPProcedures tpp on tpp.AuthorizationId = a.AuthorizationId        
 where tpp.DocumentVersionId = @DocumentVersionId        
   and tpp.RecordDeleted = 'Y'        
   and isnull(a.RecordDeleted, 'N') = 'N'        
        
if @@error <> 0 goto error        
         
-- Remap existing authorizations to procedures        
update a        
   set TPProcedureId = tpp.TPProcedureId        
  from Authorizations a        
       join TPProcedures tpp on tpp.AuthorizationId = a.AuthorizationId        
 where tpp.DocumentVersionId = @DocumentVersionId         
   and not exists(select * from @AuthorizationStatus s where s.AuthorizationId = a.AuthorizationId and s.Status = 'NEW')        
        
if @@error <> 0 goto error        
        
-- Calculate review level and set authorization status according to the following logic:        
-- If Units Requested <= LCM and CCM caps and AuthorizationCodes.UMMustSpecifyBillingCode = 'N' then set status = 'Approved'.        
-- If Units Requested <= LCM and CCM caps and AuthorizationCodes.UMMustSpecifyBillingCode = 'Y' then set status = 'Requested' and ReviewLevel = 'LCM'.        
-- If Units Requested >= LCM Cap set status = 'Requested' and ReviewLevel = 'LCM'.        
-- If LCM cap is null, set status = 'Requested' and ReviewLevel = 'CCM'.         
        
insert into @LOCCaps (AuthorizationId, UMCodeId, CoveragePlanId)        
select a.AuthorizationId, um.UMCodeId, ccp.CoveragePlanId        
  from AuthorizationDocuments ad        
       join Authorizations a on a.AuthorizationDocumentId = ad.AuthorizationDocumentId        
       join @AuthorizationStatus s on s.AuthorizationId = a.AuthorizationId and s.Status in ('NEW', 'MODIFIED')        
       join CustomUMCodeAuthorizationCodes um on um.AuthorizationCodeId = a.AuthorizationCodeId        
       left join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = ad.ClientCoveragePlanId        
 where ad.AuthorizationDocumentId = @AuthorizationDocumentId             
   and isnull(a.RecordDeleted, 'N') = 'N'        
   and isnull(um.RecordDeleted, 'N') = 'N'        
        
if @@error <> 0 goto error        
        
update c        
   set LOCId = cl.LOCId        
  from @LOCCaps c         
       join Authorizations a on a.Authorizationid = c.AuthorizationId        
       join dbo.CustomClientLOCs cl on cl.ClientId = @ClientId         
 where cl.LOCStartDate <= a.StartDateRequested               
   and (dateadd(dd, 1, cl.LOCEndDate) > a.StartDateRequested or cl.LOCEndDate is null)        
   and isnull(cl.RecordDeleted, 'N') = 'N'        
        
if @@error <> 0 goto error        
           
update c        
   set LOCUMCodeId = um.LOCUMCodeID        
  from @LOCCaps c         
       join CustomLOCUMCodes um on um.LOCId = c.LOCId and um.UMCodeId = c.UMCodeId and um.CoveragePlanId = c.CoveragePlanId        
 where isnull(um.RecordDeleted, 'N') = 'N'        
        
if @@error <> 0 goto error        
         
update c        
   set LOCUMCodeId = um.LOCUMCodeID        
  from @LOCCaps c         
       join CustomLOCUMCodes um on um.LOCId = c.LOCId and um.UMCodeId = c.UMCodeId        
 where c.LOCUMCodeId is null        
   and um.CoveragePlanId is null        
   and isnull(um.RecordDeleted, 'N') = 'N'        
        
if @@error <> 0 goto error        
                
update a        
   set Status = 4243, -- Approved        
       Units = a.UnitsRequested,        
       TotalUnits = a.TotalUnitsRequested,        
       StartDate = a.StartDateRequested,        
       EndDate = a.EndDateRequested,        
       Frequency = a.Frequency,        
       ReviewLevel = null        
  from Authorizations a         
       join @LOCCaps c on c.AuthorizationId = a.AuthorizationId        
       join CustomLOCUMCodes um on um.LOCUMCodeID = c.LOCUMCodeId        
       join AuthorizationCodes ac on ac.AuthorizationCodeId = a.AuthorizationCodeId        
 where a.TotalUnitsRequested <= um.CCM12MonthUnitCao    
   and a.TotalUnitsRequested <= ISNULL(um.LCM12MonthUnitCap, a.TotalUnitsRequested)  
   and isnull(ac.UMMustSpecifyBillingCode, 'N') = 'N'    
   AND EXISTS (
				SELECT 1
				FROM CustomLOCCategories CLC
				JOIN CustomLOCs CL ON CLC.LOCCategoryId = CL.LOCCategoryId
				WHERE CL.LOCId = c.LOCId
					AND ISNULL(CLC.RecordDeleted, 'N') = 'N'
					AND ISNULL(CL.RecordDeleted, 'N') = 'N'
					AND CLC.LOCPopulation = ac.Category3
				)
					     
if @@error <> 0 goto error        
        
update a        
   set Status = 4242, -- Requested        
       ReviewLevel = 6681 -- LCM        
  from Authorizations a         
       join @LOCCaps c on c.AuthorizationId = a.AuthorizationId        
       join CustomLOCUMCodes um on um.LOCUMCodeID = c.LOCUMCodeId        
       join AuthorizationCodes ac on ac.AuthorizationCodeId = a.AuthorizationCodeId        
 where a.TotalUnitsRequested <= isnull(um.CCM12MonthUnitCao, a.TotalUnitsRequested)        
   and a.TotalUnitsRequested <= isnull(um.LCM12MonthUnitCap, a.TotalUnitsRequested)        
   and ac.UMMustSpecifyBillingCode = 'Y'
   AND EXISTS (
				SELECT 1
				FROM CustomLOCCategories CLC
				JOIN CustomLOCs CL ON CLC.LOCCategoryId = CL.LOCCategoryId
				WHERE CL.LOCId = c.LOCId
					AND ISNULL(CLC.RecordDeleted, 'N') = 'N'
					AND ISNULL(CL.RecordDeleted, 'N') = 'N'
					AND CLC.LOCPopulation = ac.Category3
				)      
        
if @@error <> 0 goto error        
    
update a        
  set Status = 4242, -- Requested        
      ReviewLevel = 6681 -- LCM        
 from Authorizations a         
      join @LOCCaps c on c.AuthorizationId = a.AuthorizationId        
      join CustomLOCUMCodes um on um.LOCUMCodeID = c.LOCUMCodeId        
where a.TotalUnitsRequested >= um.LCM12MonthUnitCap    
        
if @@error <> 0 goto error        
update a        
  set Status = 4242, -- Requested        
      ReviewLevel = 6682 -- CCM        
 from Authorizations a         
      join @LOCCaps c on c.AuthorizationId = a.AuthorizationId        
      join CustomLOCUMCodes um on um.LOCUMCodeID = c.LOCUMCodeId        
where um.LCM12MonthUnitCap IS NULL  
    and a.TotalUnitsRequested >= um.CCM12MonthUnitCao  
        
if @@error <> 0 goto error        
        
-- Create history record          
insert into dbo.AuthorizationHistory  (        
       CreatedBy,        
       CreatedDate,        
       ModifiedBy,        
       ModifiedDate,        
       AuthorizationId,        
       AuthorizationNumber,        
       Status,        
       Units,        
       Frequency,        
       StartDate,        
       EndDate,        
       TotalUnits,        
       UnitsRequested,        
       FrequencyRequested,        
       StartDateRequested,        
       EndDateRequested,        
       TotalUnitsRequested,        
       ProviderAuthorizationId,        
       Urgent,        
       ReviewLevel)        
select @CurrentUser,        
       getdate(),        
       @CurrentUser,        
       getdate(),        
       a.AuthorizationId,        
       a.AuthorizationNumber,        
       a.Status,        
       a.Units,        
       a.Frequency,        
       a.StartDate,        
       a.EndDate,        
       a.TotalUnits,        
       a.UnitsRequested,        
       a.FrequencyRequested,        
       a.StartDateRequested,        
       a.EndDateRequested,        
       a.TotalUnitsRequested,        
       a.ProviderAuthorizationId,        
       a.Urgent,        
       a.ReviewLevel               
  from Authorizations a        
       join @AuthorizationStatus s on s.AuthorizationId = a.AuthorizationId and s.Status in ('NEW', 'MODIFIED')           
        
if @@error <> 0 goto error        
        
---- For insertation of um notes(created by sourabh with ref to task#374(SCWeb)) Modfied by Rakesh w.rf. to task 374 so that duplicate rows not inserted in clientUMNotes while editing versions.        
-- Declare @CurrentRequestorComment varchar(max)        
-- Set @CurrentRequestorComment=(select top 1 RequesterComment from AuthorizationDocuments  where DocumentId = @DocumentId and Isnull(RecordDeleted,'N') = 'N')             
--IF ((select Count(tp.AuthorizationRequestorComment) from  DocumentVersions dv join TPGeneral tp on dv.DocumentVersionId = tp.DocumentVersionId where dv.DocumentId = @DocumentId and tp.AuthorizationRequestorComment = @CurrentRequestorComment      
-- )=1)        
--BEGIN          
--insert into CLientUMNOtes(ClientId,AuthorId,Note,CreatedBy,CreatedDate)          
-- select @ClientId,                         
--         d.AuthorId,                         
--         tpg.AuthorizationRequestorComment,          
--         @CurrentUser,                                                     
--         getdate()             
--    from Documents d                        
--         join TPGeneral tpg on tpg.DocumentVersionId = d.CurrentDocumentVersionId                        
--   where d.DocumentId = @DocumentId             
-- END          
         
--if @@error <> 0 goto error       
-- Logic end here              
       
-- For external authorizations default TPProcedureBillingCodes if it is empty        
insert into TPProcedureBillingCodes (        
       CreatedBy,        
       CreatedDate,        
       ModifiedBy,        
       ModifiedDate,        
       TPProcedureId,        
       BillingCodeId,        
       Modifier1,        
       Modifier2,        
       Modifier3,        
       Modifier4,        
       Units,        
       SystemGenerated)        
select a.CreatedBy,        
       getdate(),        
       a.CreatedBy,        
       getdate(),        
       a.TPProcedureId,        
       ac.DefaultBillingCodeId,        
       ac.DefaultModifier1,        
       ac.DefaultModifier2,        
       ac.DefaultModifier3,        
       ac.DefaultModifier4,        
       tpp.TotalUnits,        
       'Y'        
  from Authorizations a        
       join @AuthorizationStatus s on s.AuthorizationId = a.AuthorizationId        
       join AuthorizationCodes ac on ac.AuthorizationCodeId = a.AuthorizationCodeId        
       join TPProcedures tpp on tpp.TPProcedureId = a.TPProcedureId        
 where s.Status in ('NEW', 'MODIFIED')              
   and a.ProviderId is not null        
   and ac.DefaultBillingCodeId is not null        
   and not exists(select * from TPProcedureBillingCodes tppbc where tppbc.TPProcedureId = a.TPProcedureId and isnull(tppbc.RecordDeleted, 'N') = 'N')             
        
if @@error <> 0 goto error        
        
-- For external authorizations populate AuthorizationProviderBilingCodes        
delete apbc        
  from AuthorizationProviderBilingCodes apbc        
       join Authorizations a on a.AuthorizationId = apbc.AuthorizationId        
       join @AuthorizationStatus s on s.AuthorizationId = a.AuthorizationId        
       join TPProcedures tpp on tpp.AuthorizationId = a.AuthorizationId        
 where tpp.DocumentVersionId = @DocumentVersionId                    
        
if @@error <> 0 goto error        
             
insert into AuthorizationProviderBilingCodes (        
       CreatedBy,        
       CreatedDate,        
       ModifiedBy,        
       ModifiedDate,        
       AuthorizationId,        
       TPProcedureBillingCodeId,        
       ProviderAuthorizationId,        
       Modifier1,        
       Modifier2,        
       Modifier3,        
       Modifier4,        
       UnitsRequested,        
       UnitsApproved)        
select a.CreatedBy,        
       getdate(),        
       a.CreatedBy,        
       getdate(),        
       a.AuthorizationId,        
       tppbc.TPProcedureBillingCodeId,        
       null,        
       tppbc.Modifier1,        
       tppbc.Modifier2,        
       tppbc.Modifier3,        
       tppbc.Modifier4,        
       a.TotalUnitsRequested,        
       a.TotalUnits        
  from Authorizations a        
       join @AuthorizationStatus s on s.AuthorizationId = a.AuthorizationId        
       join TPProcedureBillingCodes tppbc on tppbc.TPProcedureId = a.TPProcedureId        
 where s.Status in ('NEW', 'MODIFIED')              
   and a.ProviderId is not null        
   and isnull(tppbc.RecordDeleted, 'N') = 'N'        
        
if @@error <> 0 goto error        
        
--          
-- Update Care Management         
--        
        
       
select @InsurerId = CareManagementInsurerId from SystemConfigurations        
set @RequestId = newid()        
         
set xact_abort on        
        
-- Populate staging table        
insert into CustomUMStageAthorizations (      
       RequestId,      
       InsurerId,      
       ProviderId,      
       SiteId,       
       ClientId,      
       BillingCodeId,      
       Modifier1,      
       Modifier2,      
       Modifier3,      
       Modifier4,      
       AuthorizationNumber,      
       AuthorizationId,      
       AuthorizationDocumentId,      
       Status,           
       StartDateRequested,      
       EndDateRequested,      
       StartDate,      
       EndDate,      
       EffectiveDate,      
       ProviderAuthorizationId,      
       ProviderAuthorizationDocumentId,      
       AuthorizationProviderBillingCodeId,      
       RequestorComment,      
       ReviewerComment,      
       CreatedBy,      
       CreateDate,      
       RecordDeleted,
       RequestStatus,
       UnitsRequested,
       FrequencyTypeRequested,
       TotalUnitsRequested,        
       UnitsApproved,               
       FrequencyTypeApproved,
       TotalUnitsApproved,
       AssignedPopulation)      
select @RequestId,      
       @InsurerId,      
       a.ProviderId,      
       a.SiteId,      
       @ClientId,      
       tppbc.BillingCodeId,      
       apbc.Modifier1,       
       apbc.Modifier2,       
       apbc.Modifier3,       
       apbc.Modifier4,      
       a.AuthorizationNumber,      
       a.AuthorizationId,      
       a.AuthorizationDocumentId,      
       a.Status,           
       a.StartDateRequested,      
       a.EndDateRequested,      
       a.StartDate,      
       a.EndDate,      
       @EffectiveDate,      
       a.ProviderAuthorizationId,      
       ad.ProviderAuthorizationDocumentId,      
       apbc.AuthorizationProviderBilingCodeId,      
       ad.RequesterComment,      
       ad.ReviewerComment,      
       a.ModifiedBy,      
       getdate(),      
       a.RecordDeleted ,
       s.Status,
       a.UnitsRequested,
	   a.FrequencyRequested,
	   a.TotalUnitsRequested,
	   a.Units,
	   a.Frequency,
	   a.TotalUnits,
	   a.AssignedPopulation 
  from Authorizations a      
       join @AuthorizationStatus s on s.AuthorizationId = a.AuthorizationId           
       join AuthorizationDocuments ad on ad.AuthorizationDocumentId = a.AuthorizationDocumentId      
       left join AuthorizationProviderBilingCodes apbc on apbc.AuthorizationId = a.AuthorizationId and isnull(apbc.RecordDeleted, 'N') = 'N'      
       left join TPProcedureBillingCodes tppbc on tppbc.TPProcedureBillingCodeId = apbc.TPProcedureBillingCodeId and isnull(tppbc.RecordDeleted, 'N') = 'N'      
 where a.ProviderId is not null            
           
if @@error <> 0 goto error        
        
-- Send deletes for authorizations that were external, but changed to internal        
insert into CustomUMStageAthorizations (      
       RequestId,      
       InsurerId,      
       ProviderId,      
       SiteId,       
       ClientId,      
       AuthorizationNumber,      
       AuthorizationId,      
       AuthorizationDocumentId,      
       Status,            
       StartDateRequested,      
       EndDateRequested,      
       StartDate,      
       EndDate,      
       EffectiveDate,      
       ProviderAuthorizationId,      
       CreatedBy,      
       CreateDate,      
       RecordDeleted,
       RequestStatus,
       UnitsRequested,
       FrequencyTypeRequested,
       TotalUnitsRequested,        
       UnitsApproved,               
       FrequencyTypeApproved,
       TotalUnitsApproved)      
select @RequestId,      
       @InsurerId,      
       a.ProviderId,      
       a.SiteId,      
       @ClientId,      
       a.AuthorizationNumber,      
       a.AuthorizationId,      
       a.AuthorizationDocumentId,      
       a.Status,           
       a.StartDateRequested,      
       a.EndDateRequested,      
       a.StartDate,      
       a.EndDate,      
       @EffectiveDate,      
       a.ProviderAuthorizationId,      
       a.ModifiedBy,      
       getdate(),      
       'Y' ,
       s.Status,
       a.UnitsRequested,
	   a.FrequencyRequested,
	   a.TotalUnitsRequested,
	   a.Units,
	   a.Frequency,
	   a.TotalUnits      
  from Authorizations a      
       join @AuthorizationStatus s on s.AuthorizationId = a.AuthorizationId           
 where a.ProviderId is null      
   and a.ProviderAuthorizationId is not null            
           
if @@error <> 0 goto error        
           
if not exists(select * from CustomUMStageAthorizations where RequestId = @RequestId)        
  goto old        
           
-- Get the lates diagnosis document and send it to Care Management           
declare @DiagnosisDocumentVersionId int        
        
select @DiagnosisDocumentVersionId = d.CurrentDocumentVersionId           
  from Documents d         
 where d.ClientId = @ClientId        
   and d.DocumentCodeId = 5        
   and d.Status = 22        
   and isnull(d.RecordDeleted, 'N') = 'N'        
   and not exists (select *        
                     from Documents d2         
                   where d2.ClientId = d.ClientId         
                     and d2.DocumentCodeId = d.DocumentCodeId        
                      and d2.Status = d.Status        
        and d2.EffectiveDate > d.EffectiveDate        
   and isnull(d2.RecordDeleted, 'N') = 'N')           
           
insert into CustomUMStageEventDiagnosesIAndII(        
       RequestId,        
       Axis,        
       DSMCode,        
       DSMNumber,        
       DiagnosisType,        
       RuleOut,        
       Billable,        
       Severity,        
       DSMVersion,        
       DiagnosisOrder,        
       Specifier)        
select @RequestId,        
       d.Axis,        
       d.DSMCode,        
       d.DSMNumber,        
       d.DiagnosisType,        
       d.RuleOut,        
       d.Billable,        
       d.Severity,        
       d.DSMVersion,        
       d.DiagnosisOrder,        
       d.Specifier        
  from DiagnosesIAndII d        
 where d.DocumentVersionId = @DiagnosisDocumentVersionId        
   and isnull(d.RecordDeleted, 'N') = 'N'        
        
if @@error <> 0 goto error        
                  
insert into CustomUMStageEventDiagnosesIII(        
       RequestId,        
       Specification,        
       ICDCode,        
       Billable)        
select @RequestId,        
       d.Specification,        
       dc.ICDCode,        
       dc.Billable               
  from DiagnosesIII d        
       join DiagnosesIIICodes dc on dc.DocumentVersionId = d.DocumentVersionId        
 where d.DocumentVersionId = @DiagnosisDocumentVersionId        
   and isnull(d.RecordDeleted, 'N') = 'N'        
   and isnull(dc.RecordDeleted, 'N') = 'N'        
        
if @@error <> 0 goto error        
        
insert into CustomUMStageEventDiagnosesIV(        
       RequestId,        
       PrimarySupport,        
       SocialEnvironment,        
       Educational,        
       Occupational,        
       Housing,        
       Economic,        
       HealthcareServices,        
       Legal,        
       Other,        
       Specification)        
select @RequestId,        
       d.PrimarySupport,        
       d.SocialEnvironment,        
       d.Educational,        
       d.Occupational,        
       d.Housing,        
       d.Economic,        
       d.HealthcareServices,        
       d.Legal,        
       d.Other,        
       d.Specification        
  from DiagnosesIV d        
 where d.DocumentVersionId = @DiagnosisDocumentVersionId        
   and isnull(d.RecordDeleted, 'N') = 'N'        
        
if @@error <> 0 goto error        
        
insert into CustomUMStageEventDiagnosesV(        
       RequestId,        
       AxisV)        
select @RequestId,        
       d.AxisV               
  from DiagnosesV d        
 where d.DocumentVersionId = @DiagnosisDocumentVersionId        
   and isnull(d.RecordDeleted, 'N') = 'N'        
        
if @@error <> 0 goto error        
          
exec csp_CMUMAuthorizations @RequestId = @RequestId,  @Population =   @AssignedPopulation        
        
if @@error <> 0 goto error        
        
update a         
   set ProviderAuthorizationId = case when a.ProviderId is null then null else s.ProviderAuthorizationId end,        
       UnitsUsed = s.UnitsUsed        
  from Authorizations a        
       join CustomUMStageAthorizations s on s.AuthorizationId = a.AuthorizationId        
 where s.RequestId = @RequestId               
        
if @@error <> 0 goto error        
        
update ad     
   set ProviderAuthorizationDocumentId = s.ProviderAuthorizationDocumentId  
  from AuthorizationDocuments ad    
       join CustomUMStageAthorizations s on s.AuthorizationDocumentId = ad.AuthorizationDocumentId    
       --join Authorizations a on a.AuthorizationDocumentId = ad.AuthorizationDocumentId    
       -- RNoble changed above join to exists as this was causing ProviderAuthorizationDocumentId to be set to Null if multiple auths were  
       -- on one authorization document in which some auths were "external" (providerId not null) and some were not.  
       WHERE s.RequestId = @RequestId  
       AND EXISTS(SELECT * FROM Authorizations a  
     WHERE a.AuthorizationId = s.AuthorizationId  
     AND a.ProviderId IS NOT NULL  
     AND ISNULL(a.RecordDeleted,'N') <> 'Y')  
        
if @@error <> 0 goto error        
         
update apbc        
   set ProviderAuthorizationId = s.ProviderAuthorizationId          
  from AuthorizationProviderBilingCodes apbc        
       join CustomUMStageAthorizations s on s.AuthorizationProviderBillingCodeId = apbc.AuthorizationProviderBilingCodeId        
 where s.RequestId = @RequestId             
        
if @@error <> 0 goto error        
        
insert into @ValidationErrors (        
       TableName,        
       ColumnName,        
       ErrorMessage)        
select 'TPProcedures',        
       'DeletedBy',        
       ErrorMessage        
  from CustomUMStageAthorizations               
 where RequestId = @RequestId        
   and ErrorMessage is not null        
        
if @@error <> 0 goto error        
        
delete from CustomUMStageAthorizations where RequestId = @RequestId        
        
if @@error <> 0 goto error        
        
old:        
        
--        
-- Close all athorization associated with the previous TPs if this plan is not an addendum        
--        
if @PlanOrAddendum <> 'AD'        
begin        
  delete from @AuthorizationStatus        
          
  insert into @AuthorizationStatus (AuthorizationId, TPProcedureId, Status)        
  select a.AuthorizationId, a.TPProcedureId, 'MODIFIED'        
    from Documents d         
         join DocumentCarePlans tp on tp.DocumentVersionId = d.CurrentDocumentVersionId        
         join TPProcedures tpp on tpp.DocumentVersionId = tp.DocumentVersionId        
         join Authorizations a on a.AuthorizationId = tpp.AuthorizationId        
   where d.ClientId = @ClientId        
     and d.EffectiveDate < @EffectiveDate        
     and ((a.Status = 4242 and a.EndDateRequested >= @EffectiveDate) or (a.Status = 4243 and a.EndDate >= @EffectiveDate))        
     and d.Status = 22        
     and a.Status in (4242, 4243)        
     and isnull(d.RecordDeleted, 'N') = 'N'        
     and isnull(a.RecordDeleted, 'N') = 'N'        
             
  if @@error <> 0 goto error        
          
  update a        
     set EndDateRequested = case when a.Status = 4242 then dateadd(dd, -1, @EffectiveDate) else a.EndDateRequested end,        
         EndDate = case when a.Status = 4243 then dateadd(dd, -1, @EffectiveDate) else a.EndDate end        
    from Authorizations a        
         join @AuthorizationStatus s on s.AuthorizationId = a.AuthorizationId        
             
  if @@error <> 0 goto error        
        
  declare curAuthorizations cursor for        
  select distinct a.AuthorizationDocumentId        
    from Authorizations a        
         join @AuthorizationStatus s on s.AuthorizationId = a.AuthorizationId        
   where a.ProviderId is not null        
           
  open curAuthorizations        
  fetch from curAuthorizations into @AuthorizationDocumentId        
           
  while @@fetch_status = 0        
  begin        
    set @RequestId = newid()        
        
    -- Populate staging table        
     insert into CustomUMStageAthorizations (      
           RequestId,      
           InsurerId,      
           ProviderId,      
           SiteId,       
           ClientId,      
           BillingCodeId,      
           Modifier1,      
           Modifier2,      
           Modifier3,      
           Modifier4,      
           AuthorizationNumber,      
           AuthorizationId,      
           AuthorizationDocumentId,      
           Status,            
           StartDateRequested,      
           EndDateRequested,      
           StartDate,      
           EndDate,      
           EffectiveDate,      
           ProviderAuthorizationId,      
           ProviderAuthorizationDocumentId,      
           AuthorizationProviderBillingCodeId,      
           RequestorComment,      
           ReviewerComment,      
           CreatedBy,      
           CreateDate,      
           RecordDeleted,
           RequestStatus,
           UnitsRequested,
		   FrequencyTypeRequested,
		   TotalUnitsRequested,        
		   UnitsApproved,               
		   FrequencyTypeApproved,
		   TotalUnitsApproved,
		   AssignedPopulation)      
    select @RequestId,      
           @InsurerId,      
           a.ProviderId,      
           a.SiteId,      
           @ClientId,      
           tppbc.BillingCodeId,      
           apbc.Modifier1,       
           apbc.Modifier2,       
           apbc.Modifier3,       
           apbc.Modifier4,      
           a.AuthorizationNumber,      
           a.AuthorizationId,      
           a.AuthorizationDocumentId,      
           a.Status,          
           a.StartDateRequested,      
           a.EndDateRequested,      
           a.StartDate,      
           a.EndDate,      
           @EffectiveDate,      
           a.ProviderAuthorizationId,      
           ad.ProviderAuthorizationDocumentId,      
           apbc.AuthorizationProviderBilingCodeId,      
           ad.RequesterComment,      
           ad.ReviewerComment,      
           a.ModifiedBy,      
           getdate(),      
           a.RecordDeleted,
           s.Status,
           a.UnitsRequested,
		   a.FrequencyRequested,
		   a.TotalUnitsRequested,
		   a.Units,
		   a.Frequency,
		   a.TotalUnits,
		   a.AssignedPopulation    
      from Authorizations a      
           join @AuthorizationStatus s on s.AuthorizationId = a.AuthorizationId           
           join AuthorizationDocuments ad on ad.AuthorizationDocumentId = a.AuthorizationDocumentId      
           join AuthorizationProviderBilingCodes apbc on apbc.AuthorizationId = a.AuthorizationId and isnull(apbc.RecordDeleted, 'N') = 'N'      
           join TPProcedureBillingCodes tppbc on tppbc.TPProcedureBillingCodeId = apbc.TPProcedureBillingCodeId and isnull(tppbc.RecordDeleted, 'N') = 'N'      
     where a.AuthorizationDocumentId = @AuthorizationDocumentId      
       and a.ProviderId is not null      
       and apbc.ProviderAuthorizationId is not null              
            
    if @@error <> 0 goto error        
        
    if exists(select * from CustomUMStageAthorizations where RequestId = @RequestId)        
    begin          
      exec csp_CMUMAuthorizations @RequestId = @RequestId,  @Population =   @AssignedPopulation         
        
      if @@error <> 0 goto error        
          
      insert into @ValidationErrors (        
             TableName,        
             ColumnName,        
             ErrorMessage)        
      select 'TPProcedures',        
             'DeletedBy',        
             ErrorMessage        
        from CustomUMStageAthorizations               
       where RequestId = @RequestId        
         and ErrorMessage is not null            
      if @@error <> 0 goto error        
        
      delete from CustomUMStageAthorizations where RequestId = @RequestId        
        
      if @@error <> 0 goto error        
    end        
            
    fetch from curAuthorizations into @AuthorizationDocumentId        
  end        
        
  close curAuthorizations        
  deallocate curAuthorizations        
          
end        
        
if @@error <> 0 goto error        
--Commented by Atul Pandey for task #33 of project Allegan CMH Develoopment Implementation   
--exec csp_postUpdateAuthorizationStatusToSystemPended @AuthorizationDocumentId         
  
if @@error <> 0 goto error          
        
final:        
        
if exists(select * from @ValidationErrors)        
  select * from @ValidationErrors        
        
return        
        
error:        
        
--raiserror 50010 'Failed to execute csp_SCPostSignatureUpdateCarePlan.'        
        
  
  
  

