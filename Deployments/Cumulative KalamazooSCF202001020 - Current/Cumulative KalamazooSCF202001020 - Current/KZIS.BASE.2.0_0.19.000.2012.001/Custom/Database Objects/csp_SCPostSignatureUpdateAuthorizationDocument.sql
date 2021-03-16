/****** Object:  StoredProcedure [dbo].[csp_SCPostSignatureUpdateAuthorizationDocument]    Script Date: 06/03/2015 11:44:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCPostSignatureUpdateAuthorizationDocument]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCPostSignatureUpdateAuthorizationDocument]
GO

/****** Object:  StoredProcedure [dbo].[csp_SCPostSignatureUpdateAuthorizationDocument]    Script Date: 06/03/2015 11:44:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO  
  
    
    
      
CREATE procedure [dbo].[csp_SCPostSignatureUpdateAuthorizationDocument]    
@ScreenKeyId int,                                    
@StaffId int,                                    
@CurrentUser varchar(30),                                    
@CustomParameters xml                   
/*********************************************************************                          
-- Stored Procedure: dbo.csp_SCPostSignatureUpdateAuthorizationDocument                
-- Copyright: Streamline Healthcare Solutions                
--                                                                 
-- Purpose: post signature process                
--                                                                                                  
 Modified Date    Modified By   Purpose                
 10.07.2011     Rakesh     Created.  (Create the replica of sp csp_SCPostSignatureUpdateTreatmentPlan        
          and modify necessary changes in this sp to sign the AuthorizationDocuments Ref. to task 285 in SC web phase II bugs/Features)        
 11Nove 2011       As when sign this document In authorization table Review level saves -1& -2  set 6681 by replace -1(LCM) & 6682 for CCM          
 01.05.2012  avoss     corrected PCM refrernces           
 Feb.06.2012 RNoble     Corrected missing entry for TPProcedureBillingCodes.      
 16 March 2012 Sudhir Singh   Added condition for system pended in procedure 'csp_postUpdateAuthorizationStatusToSystemPended'            
 Apr.11.2012 RNoble     Modified logic to call csp_SCLinkClientToCMClient for client linking.      
 06.16.2012  avoss     Do not allow 0 units per saip     
 06.18.2012  dharvey     Added Request Status to Staging and Synonyms    
    
 06.20.2012     SFarber     Modified to use synonyms 'CM_' istead of directly referencing CM objects    
 4/July/2012 Mamta Gupta    Ref Task No. 1780 - Kalamazoo Bugs - - Go Live - To insert requesterComment in AuthorizationDocuments     
 07.11.2012  Sourabh     Modified to insert FrequencyTypeRequested field in CustomUMStageAthorizations  table wrt#1674 in Kalamazoo Bugs -Go Live    
 12/July/2012 Mamta Gupta    Ref Task No. 1780 - Kalamazoo Bugs - - Go Live - @RequestId added to get errormessage related to authorizationdocument    
 11.05.2012     Atul Pandey             Commented  execution of 'csp_postUpdateAuthorizationStatusToSystemPended' to turn off  System Pend status customization for task #33 of project Allegan CMH Develoopment Implementation     
 3/20/2013  Vishant Garg            Commented Capitated='Y'    
 02 April 13 Shikha Arora   for ref task #557 in 3.x issues    
             What/Why:Recode Function is called to fetch CoveragePlanIds that can use  authorization     
             created in Treatment Plan instead of capitated='Y'     
 03 June 2015 Munish Ref Task # 283 KCMHSAS 3.5 Implementation - Added @Population   
 3/13/2017   MD Hussain K  Added logic to initialize Assigned Population from Client Information - Custom Fields tab to Authorziation - Assigned Population field w.r.t KMCHSAS - Support #542  
 -- 26 April 2017    PradeepT     What:Remove Use of Synonym that poits to CM DB and Comented CaremanagementId referance. Comment execution of csp_SCLinkClientToCMClient  
--                                Why: There is no use to point CM DB As we are using single DB for Both CM AND Sc DB.  
 02/09/2018   Hemant 	Added logic to initialize Assigned Population from Client Information - Custom Fields tab to ProviderAuthorziation - Assigned Population field w.r.t KMCHSAS - Enhancements #542		
 15/03/2018   Himmat 	What:-FrequencyTypeRequested,TotalUnitsRequested,FrequencyTypeApproved,TotalUnitsApproved columns are updated with values earlier it is saving as null
       		            Why :-KCMHSAS - Support: #995
  08/02/2019 Kavya     	What: Added startdate, enddate some other columns for authorization insert query, as these values required in Authorization document  
                        Why: Post BC3: Prod/QA: Pended Auths issue_ Kalamazoo SGL#1279
  29/05/2109 Kavya what: changed the join logic in update query of authorizationdocuments table, as this was causing ProviderAuthorizationDocumentId to be set to Null if multiple auths were  
                        on one authorization document in which some auths were "external" (providerId not null) and some were not.
                        Why: SC: Client authorizations status not properly reflecting Client Authorizations page-KCMHSAS-Support#1310
 12/04/2020  Sharanappa What:If the client does not associate with any coverage plans with some setup					  then the system will not insert/update any data in the Authorizations-related table.
						Why: The System is creating Authorization even though CoveragePlanId is null, this is wrong. The system should not insert entries in the Authorization related tables.KCMHSAS Build Cycle Tasks #114.
						
****************************************************************************/                           
as                        
                
declare @DocumentId int                
declare @DocumentVersionId int                
declare @AuthorizationDocumentId int                
declare @ClientId int                
declare @AuthorizationStartDate datetime                
declare @AuthorizationEndDate datetime                
declare @ClientCoveragePlanId int                
declare @EffectiveDate datetime                
declare @CareManagementClientId int                
declare @InsurerId int                
declare @RequestId uniqueidentifier    
declare @Population int                
               
                
declare @AuthorizationStatus table (AuthorizationId int, TPProcedureId int, Status varchar(10))                
declare @LOCCaps table (AuthorizationId int, LOCId int, UMCodeId int, CoveragePlanId int, LOCUMCodeId int)                
                
declare @ValidationErrors table (                                         
TableName       varchar(200),                                            
ColumnName      varchar(200),                                            
ErrorMessage    varchar(200),                                            
PageIndex       int,                
TabOrder       int,                
ValidationOrder int)                
                
select @DocumentId = @ScreenKeyId                

set @RequestId = newid()   
           
select @ClientId = d.ClientId,                
       @DocumentVersionId = d.CurrentDocumentVersionId,                 
       @EffectiveDate = d.EffectiveDate                
  from Documents d                
 where d.DocumentId = @DocumentId                
                   
select @AuthorizationDocumentId = ISNULL(max(ad.AuthorizationDocumentId),-1)                
  from AuthorizationDocuments ad                
 where ad.DocumentId = @DocumentId                
   and isnull(ad.RecordDeleted, 'N') = 'N'   
     
----Get AssignedPopulation from Client Information - Custom Fields tab  
Declare @AssignedPopulation int  
select @AssignedPopulation = ColumnGlobalCode7  
From CustomFieldsData Where PrimaryKey1 = @ClientId and isnull(RecordDeleted, 'N') = 'N'                      
    
-- Try to link the client if it isn't already linked      
--EXEC csp_SCLinkClientToCMClient @ClientId      
                
-- Return if there are no TPProcedures records and no previously created authorization documents                                     
if @AuthorizationDocumentId =-1 and                
   not exists (select *                 
                 from TPProcedures tpp                 
                where tpp.DocumentVersionId = @DocumentVersionId                
                  and isnull(tpp.RecordDeleted, 'N') = 'N')                
  goto final                                              
                
-- Validate new document version                
insert into @ValidationErrors (TableName, ColumnName, ErrorMessage)                
select 'CustomAuthorizationDocuments', 'DeletedBy', 'Cannot change from ' + aca.DisplayAs + ' to ' + act.DisplayAs +                  
       '.  Authorization #' + isnull(a.AuthorizationNumber, 'Unknown') + ' has been already in use.'                
  from TPProcedures tpp                
       join Authorizations a on a.AuthorizationId = tpp.AuthorizationId                
       join AuthorizationCodes act on act.AuthorizationCodeId = tpp.AuthorizationCodeId                
       join AuthorizationCodes aca on aca.AuthorizationCodeId = a.AuthorizationCodeId                
 where tpp.DocumentVersionId = @DocumentVersionId                     
   and tpp.AuthorizationCodeId <> a.AuthorizationCodeId                
   and isnull(a.UnitsUsed, 0) > 0                
   and isnull(tpp.RecordDeleted, 'N') = 'N'                
   and isnull(a.RecordDeleted, 'N') = 'N'                
                
if @@error <> 0 goto error                
                   
insert into @ValidationErrors (TableName, ColumnName, ErrorMessage)                
select 'CustomAuthorizationDocuments', 'DeletedBy', 'Cannot modify ' +                 
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
select 'CustomAuthorizationDocuments', 'DeletedBy', 'Cannot decrease Units below Used Units for ' + ac.DisplayAs +                 
       '.  Authorization #' + isnull(a.AuthorizationNumber, 'Unknown') + ' has been already in use.'                
  from TPProcedures tpp                
       join Authorizations a on a.AuthorizationId = tpp.AuthorizationId                
       join AuthorizationCodes ac on ac.AuthorizationCodeId = tpp.AuthorizationCodeId                
 where tpp.DocumentVersionId = @DocumentVersionId                     
   and tpp.AuthorizationCodeId = a.AuthorizationCodeId                
   and isnull(tpp.TotalUnits, 0) < isnull(a.UnitsUsed, 0)                
   and isnull(tpp.RecordDeleted, 'N') = 'N'                
   and isnull(a.RecordDeleted, 'N') = 'N'                
                   
if @@error <> 0 goto error                
                
insert into @ValidationErrors (TableName, ColumnName, ErrorMessage)                
select 'CustomAuthorizationDocuments', 'DeletedBy', 'Cannot delete ' + ac.DisplayAs + '.  Authorization #' + isnull(a.AuthorizationNumber, 'Unknown') + ' has been already in use.'          
  from TPProcedures tpp                
       join Authorizations a on a.AuthorizationId = tpp.AuthorizationId                
       join AuthorizationCodes ac on ac.AuthorizationCodeId = tpp.AuthorizationCodeId                
 where tpp.DocumentVersionId = @DocumentVersionId                     
   and isnull(a.UnitsUsed, 0) > 0                
   and tpp.RecordDeleted = 'Y'                
   and isnull(a.RecordDeleted, 'N') = 'N'                
                   
if @@error <> 0 goto error    
    
--Do not allow 0 units per saip 06.16.2012  avoss    
insert into @ValidationErrors (TableName, ColumnName, ErrorMessage)                
SELECT  'CustomAuthorizationDocuments', 'DeletedBy', 'Units must be greater than zero for : '+ac.AuthorizationCodeName+'.'    
FROM CustomAuthorizationDocuments c    
JOIN documents d ON d.CurrentDocumentVersionId = c.DocumentVersionId    
JOIN dbo.AuthorizationDocuments ad ON ad.DocumentId = d.DocumentId    
JOIN authorizations a ON a.AuthorizationDocumentId = ad.AuthorizationDocumentId AND ISNULL(a.RecordDeleted,'N') <> 'Y'    
JOIN dbo.AuthorizationCodes ac ON ac.AuthorizationCodeId = a.AuthorizationCodeId    
WHERE @DocumentVersionId = c.DocumentVersionId     
and ISNULL(a.TotalUnitsRequested,0.00) < 1.00         
    
if exists(select * from @ValidationErrors)                 
  goto final                

select @AuthorizationStartDate = min(tpp.StartDate),
 @AuthorizationEndDate = max(tpp.EndDate)                                     
  from TPProcedures tpp                                              
 where tpp.DocumentVersionId = @DocumentVersionId                
   and isnull(tpp.RecordDeleted, 'N') = 'N' 

 -- Determine coverage plan
select top 1 @ClientCoveragePlanId = ccp.ClientCoveragePlanId                                       
  from ClientCoveragePlans ccp                                              
       join ClientCoverageHistory cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId            
       join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId         
       join dbo.ssf_RecodeValuesCurrent('RECODECAPCOVERAGEPLANID') CAPCP on cp.CoveragePlanId=CAPCP.IntegerCodeId                  
 where ccp.ClientId = @ClientId      
   and cch.StartDate <= @AuthorizationEndDate                          
   and (cch.EndDate is null or dateadd(dd, 1, cch.EndDate) > @AuthorizationStartDate)               
   and isnull(ccp.RecordDeleted,'N') = 'N'                 
   and isnull(cch.RecordDeleted,'N') = 'N'                 
   and isnull(cp.RecordDeleted,'N') = 'N'                 
 order by cch.StartDate, cch.COBOrder   


If(@ClientCoveragePlanId IS NOT NULL)
 BEGIN                
-- If there is any change, authorizationa need to be reapproved                
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
 where tpp.DocumentVersionId = @DocumentVersionId                                             
   and isnull(a.RecordDeleted, 'N') = 'N'                                              
   and isnull(tpp.RecordDeleted, 'N') = 'N'                                              
   and (a.AuthorizationCodeId <> tpp.AuthorizationCodeId or                 
        isnull(a.UnitsRequested,0) <> isnull(tpp.Units,0) or                                             
        isnull(a.FrequencyRequested, -1) <> isnull(tpp.FrequencyType, -1) or                
        isnull(a.StartDateRequested, '1/1/1970') <> isnull(tpp.StartDate, '1/1/1970') or                
        isnull(a.EndDateRequested, '1/1/1970') = isnull(tpp.EndDate, '1/1/1970') or                                            
        isnull(a.TotalUnitsRequested, -1) <> isnull(tpp.TotalUnits, -1) or                                               
        isnull(a.ProviderId, -1) <> isnull(tpp.ProviderId, -1) or                
        isnull(a.SiteId, -1) <> isnull(tpp.SiteId, -1))                                  
                             
if @@error <> 0 goto error                
                
-- Create/update Authorization document                   
                            
if @AuthorizationDocumentId=-1                
begin                
  insert into AuthorizationDocuments (                                             
         DocumentId,                
         ClientCoveragePlanId,                 
         Assigned,                 
         StaffId,                 
         RequesterComment,                 
         CreatedBy,                 
         CreatedDate,                                              
         ModifiedBy,                
         ModifiedDate)            
  select @DocumentId,                 
         @ClientCoveragePlanId,                 
         cad.Assigned,                 
         d.AuthorId,                 
         cad.AuthorizationRequestorComment,                                              
         @CurrentUser,                 
         getdate(),                
         @CurrentUser,                 
         getdate()                                              
    from Documents d                
       --  join TPGeneral tpg on tpg.DocumentVersionId = d.CurrentDocumentVersionId                
          join CustomAuthorizationDocuments cad on cad.DocumentVersionId = d.CurrentDocumentVersionId              
   where d.DocumentId = @DocumentId                                              
  if @@error <> 0 goto error                
              
  set @AuthorizationDocumentId = @@identity             
             
end                
else                
begin                
  update ad                
     set ClientCoveragePlanId = @ClientCoveragePlanId,                 
         Assigned = cad.Assigned,                 
         RequesterComment = cad.AuthorizationRequestorComment,                 
         ModifiedBy = @CurrentUser,                
 ModifiedDate = getdate()                
    from AuthorizationDocuments ad                
         join Documents d on d.DocumentId = ad.DocumentId                
         --join TPGeneral tpg on tpg.DocumentVersionId = d.CurrentDocumentVersionId          
         join CustomAuthorizationDocuments cad on cad.DocumentVersionId = d.CurrentDocumentVersionId                   
   where ad.AuthorizationDocumentId = @AuthorizationDocumentId         
     and (isnull(cad.Assigned, 0) <> isnull(ad.Assigned, 0) or                
          isnull(convert(varchar(max), cad.AuthorizationRequestorComment), '') <> isnull(convert(varchar(max), ad.RequesterComment), '') or                
          isnull(@ClientCoveragePlanId, -1) <> isnull(ad.ClientCoveragePlanId, -1))                
                
  if @@error <> 0 goto error                
end  
   
--Added by Mamta Gupta - Ref Task No. 1780 - Kalamazoo Bugs - 4/July/2012 - Go Live - To insert requesterComment in AuthorizationDocuments               
 Declare @CurrentRequestorComment varchar(max)      
 Set @CurrentRequestorComment=(select top 1 RequesterComment from AuthorizationDocuments  where DocumentId = @DocumentId and Isnull(RecordDeleted,'N') = 'N')                     
     
 IF ((select Count(cad.documentversionid) from  DocumentVersions dv join CustomAuthorizationDocuments cad on dv.DocumentVersionId = cad.DocumentVersionId where dv.DocumentId = @DocumentId and cast(cad.AuthorizationRequestorComment as varchar(max))   
 = @CurrentRequestorComment )=1)               
BEGIN                  
insert into CLientUMNOtes(ClientId,AuthorId,Note,CreatedBy,CreatedDate)                  
 select @ClientId,                                 
         d.AuthorId,                                 
         cad.AuthorizationRequestorComment,                  
         @CurrentUser,                                                             
         getdate()                     
    from Documents d                                
         join CustomAuthorizationDocuments cad on cad.DocumentVersionId = d.CurrentDocumentVersionId                                
   where d.DocumentId = @DocumentId                     
 END                  
                
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
       Totalunits)                                              
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
       tpp.ModifiedBy,                 
       getdate(),                                               
       tpp.ModifiedBy,                 
       getdate(),  
       @AssignedPopulation,
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
-- If Units Requested <= LCM and CCM caps then set status = 'Approved'.                
-- If Units Requested > LCM Cap set status = 'Requested' and ReviewLevel = 'LCM'.                
-- If Units Requested <= LCM cap and > CCM cap, set status = 'Requested' and ReviewLevel = 'CCM'.                 
                
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
  set Status = 4242, -- Requested                
      ReviewLevel = 6681 -- LCM                
 from Authorizations a                 
      join @LOCCaps c on c.AuthorizationId = a.AuthorizationId                
      join CustomLOCUMCodes um on um.LOCUMCodeID = c.LOCUMCodeId                
                
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
	   AssignedPopulation,
       UnitsRequested,
       FrequencyTypeRequested,
       TotalUnitsRequested,        
       UnitsApproved,               
       FrequencyTypeApproved,
       TotalUnitsApproved
       )        
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
       a.AssignedPopulation,
       a.UnitsRequested,
	   a.FrequencyRequested,
	   a.TotalUnitsRequested,
	   a.Units,
	   a.Frequency,
	   a.TotalUnits                
  from Authorizations a                
       join @AuthorizationStatus s on s.AuthorizationId = a.AuthorizationId                     
       join AuthorizationDocuments ad on ad.AuthorizationDocumentId = a.AuthorizationDocumentId                
       left join AuthorizationProviderBilingCodes apbc on apbc.AuthorizationId = a.AuthorizationId and isnull(apbc.RecordDeleted, 'N') = 'N'                
       left join TPProcedureBillingCodes tppbc on tppbc.TPProcedureBillingCodeId = apbc.TPProcedureBillingCodeId and isnull(tppbc.RecordDeleted, 'N') = 'N'                
 where a.ProviderId is not null                
                   
if @@error <> 0 goto error                
                
-- Send deletes for authorizations that were external, but changed to internal                
insert into  CustomUMStageAthorizations (                
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
       EffectiveDate,                
       ProviderAuthorizationId,                
       CreatedBy,                
       CreateDate,                
       RecordDeleted,    
       RequestStatus,    
	   AssignedPopulation,
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
       @EffectiveDate,                
       a.ProviderAuthorizationId,                
       a.ModifiedBy,                
       getdate(),                
       'Y' ,    
       s.Status,    
	   a.AssignedPopulation,
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
 END                  
if @@error <> 0 goto error                
                   
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
                   
insert into  CustomUMStageEventDiagnosesIAndII(                
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
            
insert into  CustomUMStageEventDiagnosesIII(                
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
                
insert into  CustomUMStageEventDiagnosesIV(                
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
                
insert into  CustomUMStageEventDiagnosesV(                
       RequestId,                
       AxisV)                
select @RequestId,                
       d.AxisV                       
  from DiagnosesV d                
 where d.DocumentVersionId = @DiagnosisDocumentVersionId                
   and isnull(d.RecordDeleted, 'N') = 'N'                
                
if @@error <> 0 goto error                
 
If(@ClientCoveragePlanId IS NOT NULL)
 BEGIN 
           
exec  csp_CMUMAuthorizations @RequestId = @RequestId ,  @Population =   @AssignedPopulation                
                
if @@error <> 0 goto error                
                
update a                 
   set ProviderAuthorizationId = case when a.ProviderId is null then null else s.ProviderAuthorizationId end,                
       UnitsUsed = s.UnitsUsed                
  from Authorizations a                
       join  CustomUMStageAthorizations s on s.AuthorizationId = a.AuthorizationId                
 where s.RequestId = @RequestId                       
                
if @@error <> 0 goto error                
                
update ad     
   set ProviderAuthorizationDocumentId = s.ProviderAuthorizationDocumentId  
  from AuthorizationDocuments ad    
       join CustomUMStageAthorizations s on s.AuthorizationDocumentId = ad.AuthorizationDocumentId  
       WHERE s.RequestId = @RequestId AND EXISTS(SELECT * FROM Authorizations a  
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
select 'CustomAuthorizationDocuments',                
       'DeletedBy',                
       ErrorMessage                
  from CustomUMStageAthorizations      
  --12/July/2012-Mamta Gupta-Ref Task No. 1780 - Kalamazoo Bugs-Go Live - @RequestId added to get errormessage related to authorizationdocument                     
 where RequestId = @RequestId          
 and ErrorMessage is not null                
    
if @@error <> 0 goto error            
            
delete from CustomUMStageAthorizations where RequestId = @RequestId         
END           
if @@error <> 0 goto error                
--Commented by Atul Pandey for task #33 of project Allegan CMH Develoopment Implementation     
--exec csp_postUpdateAuthorizationStatusToSystemPended @AuthorizationDocumentId    
    
if @@error <> 0 goto error    
                
final:                
                
if exists(select * from @ValidationErrors)                
  select * from @ValidationErrors                
                
return                
                
error:                          
--raiserror 50010 'Failed to execute csp_SCPostSignatureUpdateAuthorizationDocument.'         
        
    
    
  