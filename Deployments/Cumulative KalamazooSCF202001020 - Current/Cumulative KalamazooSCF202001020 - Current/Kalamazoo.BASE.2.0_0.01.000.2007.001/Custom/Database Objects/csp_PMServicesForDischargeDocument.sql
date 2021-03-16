 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PMServicesForDischargeDocument]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PMServicesForDischargeDocument]
GO
  
   
 CREATE PROCEDURE dbo.csp_PMServicesForDischargeDocument   
/******************************************************************************                    
** Name: csp_PMServicesForDischargeDocument            
** Desc: Get Services for Open Activities tab             
** ---------- -----------             
** N/A   Dropdown values            
** Auth: Alok Kumar            
** Date: 30/10/2018            
*******************************************************************************             
** Change History             
*******************************************************************************             
 Date:   Author:   Description:             
 30/10/2018  Alok Kumar  Created.            
   
*******************************************************************************/    
  
  @StaffId int,  
  @ClientId int,  
  @OrganizationProgramIds varchar(max),  
  @ServiceCount int output  
as  
BEGIN  
BEGIN TRY  
  
--12 May 2018  Vithobha  
 IF OBJECT_ID('tempdb..#TempOrganizationPrograms') IS NULL  
 BEGIN  
  CREATE TABLE #TempOrganizationPrograms (ProgramId INT)  
 END  
  
   
  create table #ServiceFilter (ServiceId int null)  
  
  create table #ServiceErrors (ServiceId int,  
                               ServiceErrorId int,  
                               ErrorMessage varchar(500))  
  
  
  declare @CustomFilters table (ServiceId int)  
  declare @ApplyFilterClicked char(1)  
  declare @CustomFiltersApplied char(1)         
  declare @ShowAllClientsServices char(1)     
  create table #StaffPrograms (ProgramId int)  
    
    
   IF (ISNULL(@OrganizationProgramIds,'') <> '')  
 BEGIN  
  INSERT INTO #TempOrganizationPrograms (ProgramId)  
  SELECT Distinct CONVERT(INT, item) --Distinct Keyword Added by Prem  
  FROM dbo.fnSplitWithIndex(@OrganizationProgramIds, ',')  
    
  
  set @ShowAllClientsServices = 'N'  
  insert  into #StaffPrograms  
     select  ProgramId  
     from    StaffPrograms  
     where   StaffId = @StaffId  
       and isnull(RecordDeleted, 'N') <> 'Y'  
 END  
 ELSE  
 BEGIN  
  set @ShowAllClientsServices = 'Y'  
 END  
   if isnull(@ShowAllClientsServices, 'Y') = 'N'  
  begin  
    if exists ( select  1  
       from    ViewStaffPermissions  
       where   StaffId = @StaffId  
         and PermissionTemplateType = 5705  
         and PermissionItemId = 5744 ) --5744 (Clinician in Program Which Shares Clients) 5741(All clients)  
   and not exists ( select 1  
        from   ViewStaffPermissions  
        where  StaffId = @StaffId  
         and PermissionTemplateType = 5705  
         and PermissionItemId = 5741 )  
   begin                            
     insert  into #StaffPrograms  
     select  ProgramId  
     from    StaffPrograms  
     where   StaffId = @StaffId  
       and isnull(RecordDeleted, 'N') <> 'Y'  
   end  
    else  
   begin  
     set @ShowAllClientsServices = 'Y'  
   end  
  end   
   else  
  begin  
    set @ShowAllClientsServices = 'Y'  
  end  
    
   
   
        
  
  --          
  --  Find only billable procedure codes for the corresponding coverage plan          
  --          
  
            insert  into #ServiceFilter  
                    (ServiceId)  
            select distinct  
                    s.ServiceId  
            from    services s  
                    inner join StaffClients sc on sc.ClientId = s.ClientId  
                    left join Programs p on p.ProgramId = s.ProgramId AND ISNULL(p.RecordDeleted,'N')='N'  --12 May 2018  Vithobha    
                    left join ServiceAreas sa on p.ServiceAreaId = sa.ServiceAreaId    
                    left join #TempOrganizationPrograms T on T.ProgramId = s.ProgramId   
            where   isnull(s.OverrideError, 'N') = 'N'  
                    and((@OrganizationProgramIds='')or EXISTS ( SELECT 1 FROM  #TempOrganizationPrograms TP WHERE TP.ProgramId = p.ProgramId))        --12 May 2018  Vithobha  
                    and sc.StaffId = @StaffId  
                    --jcarlson 3/8/2016  
                    --and exists ( select 1  
                    --             from   dbo.ServiceErrors se  
                    --             where  se.ServiceId = s.ServiceId  
                    --                    and isnull(se.RecordDeleted, 'N') = 'N' )  
                    and isnull(s.RecordDeleted, 'N') = 'N'  
  
  
  
               
    select  @ServiceCount = COUNT(DISTINCT s.ServiceId)  
    from    #ServiceFilter sf  
            inner join services s on sf.ServiceId = s.ServiceId  
            inner join Clients c on s.ClientId = c.ClientId  
            inner join ProcedureCodes pc on s.ProcedureCodeId = pc.ProcedureCodeId  
            inner join Programs p on s.ProgramId = p.ProgramId  
            left join Documents D on s.ServiceId = d.ServiceId  
            left join Staff st on s.ClinicianId = st.StaffId  
            left join Locations l on s.LocationId = l.LocationId  
            left join GlobalCodes gc on s.STATUS = gc.GlobalCodeId  
            left join GlobalCodes gc1 on s.CancelReason = gc1.GlobalCodeId --Added by Priya to concat Cncel Reason in lieu of #1143              
    where c.ClientId = @ClientId   
    and s.Status in (70,71)  
    and D.Status = 21  
    and  (@ShowAllClientsServices = 'Y'  
       or (@ShowAllClientsServices = 'N'  
        and exists ( select  *  
            from    #StaffPrograms SP  
            where   SP.ProgramId = s.ProgramId )))  
                       
    --order by s.DateOfService DESC  
      
  
      
    Delete from #TempOrganizationPrograms  
      
  
END TRY  
BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_PMServicesForDischargeDocument') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.                                                                     
    16  
    ,-- Severity.                                                            
    1 -- State.                                                         
    );  
 END CATCH  
END  