/****** Object:  Trigger [TriggerInsertUpdate_Programs]     ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TriggerInsertUpdate_Programs]'))
DROP TRIGGER [dbo].[TriggerInsertUpdate_Programs]
GO

/****** Object:  Trigger [dbo].[TriggerInsertUpdate_Programs]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
      
create trigger [dbo].[TriggerInsertUpdate_Programs] on [dbo].[Programs] for insert, update    
/*********************************************************************    
-- Trigger: TriggerInsertUpdate_ClientCoverageHistory    
--    
-- Copyright: Streamline Healthcare Solutions    
--    
-- Updates:     
--  Date         Author       Purpose    
--  6.01.2012    SFarber      Created.  
  
 -- 12.13.2019   Bibhu       What : RaisError ErrorCode added.
 --                           Why :  Engineering Improvement Initiatives- NBL(I) #103012    
**********************************************************************/              
as    
  
create table #identity (id int identity not null, data bit null)  
  
declare @idenity_seed int  
declare @ErrorNumber int    
declare @ErrorMessage varchar(255)    
declare @ProgramType int  
  
declare @Providers table (ProviderId int, ProgramId int)  
declare @Sites table (SiteId int, ProviderId int)  
  
set @idenity_seed = @@identity  
  
select @ProgramType = ExternalServicesProgramType  
  from CustomConfigurations    
  
-- Create new providers in CM  
insert into Providers (  
       ProviderType,  
       Active,  
       DataEntryComplete,  
       ProviderName,  
       SubstanceUseProvider,  
       CreatedBy,  
       CreatedDate,  
       ModifiedBy,  
       ModifiedDate,  
       DeletedBy)  
output inserted.ProviderId, inserted.DeletedBy into @Providers(ProviderId, ProgramId)  
select 'F',  
       'Y',  
       'N',  
       p.ProgramName,  
       case when p.ServiceAreaId = 2 then 'Y' else 'N' end,  
       p.CreatedBy,  
       getdate(),  
       p.ModifiedBy,  
       getdate(),  
       p.ProgramId  
  from inserted i   
       join Programs p on p.ProgramId = i.ProgramId  
 where p.ProgramType = @ProgramType  
   and p.Active = 'Y'  
   and isnull(p.RecordDeleted, 'N') = 'N'  
   and not exists(select *  
                    from CustomExternalServicesSiteMaps sm  
                   where sm.ProgramId = p.ProgramId)  
                     
if @@error <> 0  
begin  
  select @ErrorNumber  = 50010,    
         @ErrorMessage = 'ERR_TriggerInsertUpdate_Programs : Failed to insert into CM_Providers. Please contact your system administrator.'    
  goto error    
end                     
  
if exists(select * from @Providers)  
begin         
  update p  
     set DeletedBy = null  
    from Providers p  
         join @Providers pm on pm.ProviderId = p.ProviderId  
  
  if @@error <> 0  
  begin  
    select @ErrorNumber  = 50020,    
           @ErrorMessage = 'ERR_TriggerInsertUpdate_Programs : Failed to update CM_Providers. Please contact your system administrator.'    
    goto error    
  end       
  
    
  
  -- Create new sites in CM  
  insert into Sites (  
         ProviderId,  
         SiteName,  
         SiteType,  
         Active,  
         HandicapAccess,  
         EveningHours,  
         WeekendHours,  
         Adults,  
         DDPopulation,  
         MIPopulation,  
         Children,  
         TaxIDType,  
         TaxID,  
         NationalProviderId,  
         CreatedBy,  
         CreatedDate,  
         ModifiedBy,  
         ModifiedDate)  
  output inserted.SiteId, inserted.ProviderId into @Sites (SiteId, ProviderId)  
  select p.ProviderId,  
         p.ProviderName,  
         2241, -- Clinic  
         'Y',  
         'Y',  
         'Y',  
         'Y',  
         'Y',  
         'Y',  
         'Y',  
         'Y',  
         'E',  
         '',  
         pg.NationalProviderId,  
         p.CreatedBy,  
         getdate() ,  
         p.CreatedBy,  
         getdate()  
    from @Providers pm  
         join Providers p on p.ProviderId = pm.ProviderId  
         join Programs pg on pg.ProgramId = pm.ProgramId  
                      
  if @@error <> 0  
  begin  
    select @ErrorNumber  = 50030,    
           @ErrorMessage = 'ERR_TriggerInsertUpdate_Programs : Failed to insert into CM_Sites. Please contact your system administrator.'    
    goto error    
  end            
  
  update p  
     set PrimarySiteId = sm.SiteId  
    from @Providers pm  
         join Providers p on p.ProviderId = pm.ProviderId  
         join @Sites sm on sm.ProviderId = pm.ProviderId  
         
  if @@error <> 0  
  begin  
    select @ErrorNumber  = 50040,    
           @ErrorMessage = 'ERR_TriggerInsertUpdate_Programs : Failed to update CM_Providers. Please contact your system administrator.'    
    goto error    
  end       
  
    
end  
  
-- Update existing providers    
if update(Active)  
begin  
  update p  
     set Active = i.Active,  
         ModifiedBy = i.ModifiedBy,  
         ModifiedDate = i.ModifiedDate  
    from Providers p  
         join Sites s on s.ProviderId = p.ProviderId  
         join CustomExternalServicesSiteMaps sm on sm.SiteId = s.SiteId      
         join inserted i on i.ProgramId = sm.ProgramId  
         join deleted d on d.ProgramId = sm.ProgramId  
   where isnull(i.Active, 'N') <> isnull(d.Active, 'N')  
     
  if @@error <> 0  
  begin  
    select @ErrorNumber  = 50050,    
           @ErrorMessage = 'ERR_TriggerInsertUpdate_Programs : Failed to update CM_Providers. Please contact your system administrator.'    
    goto error    
  end       
end  
  
if update(RecordDeleted)  
begin     
  update p  
     set Active = 'N',  
         ModifiedBy = i.ModifiedBy,  
         ModifiedDate = i.ModifiedDate  
    from Providers p  
         join Sites s on s.ProviderId = p.ProviderId  
         join CustomExternalServicesSiteMaps sm on sm.SiteId = s.SiteId      
         join inserted i on i.ProgramId = sm.ProgramId  
         join deleted d on d.ProgramId = sm.ProgramId  
   where i.RecordDeleted = 'Y'  
     and isnull(d.RecordDeleted, 'N') = 'N'  
  
  if @@error <> 0  
  begin  
    select @ErrorNumber  = 50060,    
           @ErrorMessage = 'ERR_TriggerInsertUpdate_Programs : Failed to update CM_Providers. Please contact your system administrator.'    
    goto error    
  end       
end 
  
if update(NationalProviderId)  
begin  
  update s  
     set NationalProviderId = i.NationalProviderId,  
         ModifiedBy = i.ModifiedBy,  
         ModifiedDate = i.ModifiedDate  
    from Sites s  
         join CustomExternalServicesSiteMaps sm on sm.SiteId = s.SiteId      
         join inserted i on i.ProgramId = sm.ProgramId  
         join deleted d on d.ProgramId = sm.ProgramId  
   where isnull(i.NationalProviderId, '') <> isnull(d.NationalProviderId, '')  
     and isnull(i.NationalProviderId, '') <> ''  
  
  if @@error <> 0  
  begin  
    select @ErrorNumber  = 50070,    
           @ErrorMessage = 'ERR_TriggerInsertUpdate_Programs : Failed to update CM_Sites. Please contact your system administrator.'    
    goto error    
  end       
end  
  
-- Build mapping table         
insert into CustomExternalServicesSiteMaps (SiteId, ProgramId)  
select s.SiteId, p.ProgramId  
  from @Providers p  
       join @Sites s on s.ProviderId = p.ProviderId  
    
if @@error <> 0  
begin  
  select @ErrorNumber  = 50080,    
         @ErrorMessage = 'ERR_TriggerInsertUpdate_Programs : Failed to insert itno CustomExternalServicesSiteMaps. Please contact your system administrator.'    
  goto error    
end       
  
-- Create new site addressess   
insert into SiteAddressess (  
       SiteId,  
       AddressType,  
       Address,  
       City,  
       State,  
       Zip,  
       Display,  
       Billing,  
       For1099,  
       CreatedBy,  
       CreatedDate,  
       ModifiedBy,  
       ModifiedDate)  
select sm.SiteId,  
       2282, --Office  
       p.Address,  
       p.City,  
       p.State,  
       p.ZipCode,  
       p.AddressDisplay,  
       'Y',  
       'Y',  
       P.ModifiedBy,  
       getdate(),  
       p.ModifiedBy,  
       getdate()         
  from inserted i   
       join Programs p on p.ProgramId = i.ProgramId  
       join CustomExternalServicesSiteMaps sm on sm.ProgramId = p.ProgramId  
 where len(p.AddressDisplay) > 0  
   and not exists(select *  
                    from SiteAddressess sa  
                   where sa.SiteId = sm.SiteId  
                     and isnull(sa.RecordDeleted, 'N') = 'N')  
  
if @@error <> 0  
begin  
  select @ErrorNumber  = 50090,    
         @ErrorMessage = 'ERR_TriggerInsertUpdate_Programs : Failed to insert itno SiteAddressess. Please contact your system administrator.'    
  goto error    
end     
  
-- PM does a select @@Identity after insert.  To handle this, we need to restore @@Identity within scope  
if @idenity_seed > 0  
begin  
  dbcc checkident('#identity', reseed, @idenity_seed) with no_infomsgs  
  insert into #identity(data) values(1)  
end  
        
return    
    
error:    
  --raiserror @ErrorNumber @ErrorMessage    
set @ErrorMessage = @ErrorMessage + ', Error Number: %d'
raiserror(@ErrorMessage, 16, 1, @ErrorNumber )
rollback transaction
    
  
  