use ProdSmartCare
declare @NewUserCode varchar(30) = 'DCarter' -- usercode for the new staff member or staff member to which you are copying permissins
declare @CopyUserCode varchar(30) = 'MTAnderson'	-- select * from staff where usercode like '%kvan%'
declare @NewStaffId int 
declare @CopyStaffId int 

declare @EditorName varchar(30) = 'Wbarlow'  --your usercode
select @NewStaffId = staffid from staff where UserCode = @NewUserCode
select @CopyStaffId = staffid from staff where UserCode = @CopyUserCode

declare @DeleteRole_StaffID int = 0 /* Pair with @ProcessFlag=5 to mark roles deleted for @NewUserCode */
--select * from staff where usercode like '%rdavis%'

declare @ProcessFlag tinyint =3

/************   Turn sectons On or Off   ************/
-- Y means turn On copy, N means to Turn Off copy 
declare @TurnOnActiveDirectory varchar(10) = 'A'  -- Turn on for internal staff only
declare @TurnOnCareManagmentProvider varchar(10) = 'N'  -- Turn on for external provider staff only
declare @TurnOnMultiSVStaff varchar(10) = 'N' -- Turn on for internal staff only
declare @TurnOnMultiStaffView varchar(10) = 'N' -- Default is off because this is individually staff-defined view.  Unless we know the individuals want the new person in their view, we have it turned off
declare @TurnOnWidgets varchar(10) = 'Y'  -- Default is on.  Turn off if copy will cause duplicate widgets

/************   EXCEPTIONS FOR INSERTS   ************/
declare @LocException varchar(10) = '0'
declare @ProgException varchar(10) = '0'
declare @ProxyException varchar(10) = '1,2337'
declare @ProcedureException varchar(10) = '0'
declare @RoleException varchar(50)= '0'
declare @SupervisorException varchar(10) = '1,2337'
declare @WidgetException varchar(15) = '0'
declare @ReceptionException varchar(10) = '0'
declare @MultiStaffViewExcep varchar(10) = '0'
declare @MultiSVStaffExcep varchar (10) = '0'
declare @RXactionException varchar(10) = '0'

/******************DO NOT EDIT BELOW THIS LINE*************************/
/*
   1 - Shows New user's account
   2 - Shows existing user's account ('Copy From' User)
   3 - Shows what will be copied to New user
   4 - Do Inserts 
*/

if @ProcessFlag = 1 -- NewUser if already exists
begin
	select UserCode, StaffId, FirstName, LastName, Active, LastVisit,(select CodeName from GlobalCodes where GlobalCodeId=DetermineCaseloadBy) as DetermineCaseloadBy,RecordDeleted from Staff where StaffId = @NewStaffId
	select L.LocationName, SL.* from StaffLocations SL left join (Select LocationId, LocationName from Locations) L on SL.LocationId=L.LocationId where StaffId = @NewStaffId and isnull(RecordDeleted,'N')='N' order by L.LocationName
	select P.ProgramName, SP.* from StaffPrograms SP left join (select ProgramId, ProgramName from Programs) P on SP.ProgramId=P.ProgramId where StaffId = @NewStaffId and isnull(RecordDeleted,'N')='N'
	select S.UserCode,SP.* from StaffProxies SP left join (select UserCode, StaffId from Staff) S on SP.ProxyForStaffId=S.StaffId where SP.StaffId = @NewStaffId and isnull(SP.RecordDeleted,'N')='N'
	select PC.ProcedureCodeName,SProc.* from StaffProcedures SProc left join (Select ProcedureCodeId, ProcedureCodeName from ProcedureCodes) PC on SProc.ProcedureCodeId=PC.ProcedureCodeId where StaffId = @NewStaffId and isnull(RecordDeleted,'N')='N'
	select GC.CodeName as Role,SR.* from staffroles SR left join (select CodeName, GlobalCodeId from GlobalCodes) GC on SR.RoleID=GC.GlobalCodeId where StaffId = @NewStaffId and isnull(SR.RecordDeleted,'N')='N'
	select (Select S2.UserCode from Staff S2 where S2.StaffId=SS.SupervisorId) as 'Supervisor', SS.* from StaffSupervisors SS left join (select UserCode, StaffId from Staff) S on SS.StaffId=S.StaffId where SS.StaffId = @NewStaffId and isnull(SS.RecordDeleted,'N')='N'
	select W.WidgetName,SW.* from StaffWidgets SW left join (select WidgetId, WidgetName from Widgets) W on SW.WidgetId=W.WidgetId where StaffId = @NewStaffId and isnull(RecordDeleted,'N')='N' order by W.WidgetId
	select RV.ViewName, RV.AllStaff, COUNT(*) as StaffCount from ReceptionViewStaff RVS join ReceptionViews RV on RVS.ReceptionViewId=RV.ReceptionViewId join Staff S on RVS.StaffId=S.StaffId where RVS.StaffId = @NewStaffId and isnull(RVS.Recorddeleted,'N')='N' and @TurnOnMultiSVStaff='Y' group by RV.ViewName, RV.AllStaff order by RV.ViewName
	select MSV.ViewName,S.Usercode,Count(*) from MultiStaffViewStaff MSVS join MultiStaffViews MSV on MSVS.MultiStaffViewId=MSV.MultiStaffViewId join Staff S on S.StaffId=MSVS.StaffId	where isnull(MSVS.RecordDeleted,'N')='N' and S.StaffId = @NewStaffId and @TurnOnMultiStaffView='Y' group by MSV.ViewName,S.Usercode
	select ViewName, Count(*) from MultiStaffViews MSV join Staff S on MSV.UserStaffID=S.StaffID where UserStaffId = @NewStaffId and isnull(MSV.RecordDeleted,'N')='N' group by ViewName
	select sp.StaffId, sa.ScreenName, sa.Action from staffpermissions sp join staff s on sp.staffid=s.staffid join systemactions sa on sp.actionid=sa.actionid where isnull(SP.RecordDeleted,'N')='N' and s.StaffId=@CopyStaffId
	select CDSP.StaffId,CDSP.Productivity,CDSP.StartDate from CustomDocumentStaffProductivity CDSP where StaffId = @NewStaffId
end

if @ProcessFlag = 2 --CopyUser results
begin
	select StaffId, UserCode, FirstName, LastName, Active, LastVisit,(select CodeName from GlobalCodes where GlobalCodeId=DetermineCaseloadBy) as DetermineCaseloadBy, RecordDeleted from Staff where UserCode = @CopyUserCode
	
	--StaffLocations
	select L.LocationName, * from StaffLocations SL left join (Select LocationId, LocationName from Locations) L on SL.LocationId=L.LocationId where StaffId = @CopyStaffId and isnull(RecordDeleted,'N')='N' order by L.LocationName

	--StaffPrograms
	select P.ProgramName, SP.* from StaffPrograms SP left join (select ProgramId, ProgramName from Programs) P on SP.ProgramId=P.ProgramId where StaffId = @CopyStaffId and isnull(RecordDeleted,'N')='N'

	--StaffProxies
	select S.UserCode,SP.* from StaffProxies SP left join (select UserCode, StaffId from Staff) S on SP.ProxyForStaffId=S.StaffId where SP.StaffId = @CopyStaffId and isnull(SP.RecordDeleted,'N')='N'
	
	--StaffProcedures
	select PC.ProcedureCodeName,SProc.* from StaffProcedures SProc left join (Select ProcedureCodeId, ProcedureCodeName from ProcedureCodes) PC on SProc.ProcedureCodeId=PC.ProcedureCodeId where StaffId = @CopyStaffId and isnull(RecordDeleted,'N')='N'
	
	--StaffRoles
	select GC.CodeName as Role,SR.* from staffroles SR left join (select CodeName, GlobalCodeId from GlobalCodes) GC on SR.RoleID=GC.GlobalCodeId where StaffId = @CopyStaffId and isnull(SR.RecordDeleted,'N')='N'

	--StaffSupervisors
	select (Select S2.UserCode from Staff S2 where S2.StaffId=SS.SupervisorId) as 'Supervisor', SS.* from StaffSupervisors SS left join (select UserCode, StaffId from Staff) S on SS.StaffId=S.StaffId where SS.StaffId = @CopyStaffId and isnull(SS.RecordDeleted,'N')='N'

	--StaffWidgets (Dashboards)
	select W.WidgetName,SW.* from StaffWidgets SW left join (select WidgetId, WidgetName from Widgets) W on SW.WidgetId=W.WidgetId where StaffId = @CopyStaffId and isnull(RecordDeleted,'N')='N' order by W.WidgetId

	--ReceptionViewStaff
	select RV.ViewName, RV.AllStaff, COUNT(*) as StaffCount 
	from ReceptionViewStaff RVS 
	join ReceptionViews RV on RVS.ReceptionViewId=RV.ReceptionViewId 
	join Staff S on RVS.StaffId=S.StaffId 
	where RVS.StaffId = @CopyStaffId and isnull(RVS.Recorddeleted,'N')='N'
	group by RV.ViewName, RV.AllStaff order by RV.ViewName
	
	--MultiStaffViewStaff
	select MSV.ViewName,S.Usercode,Count(*) 
	from MultiStaffViewStaff MSVS 
	join MultiStaffViews MSV on MSVS.MultiStaffViewId=MSV.MultiStaffViewId 
	join Staff S on S.StaffId=MSVS.StaffId	
	where isnull(MSVS.RecordDeleted,'N')='N' and S.StaffId = @CopyStaffId and @TurnOnMultiSVStaff='Y'
	group by MSV.ViewName,S.Usercode
	order by MSV.ViewName
	
	--MultiStaffViews
	select ViewName, Count(*) 
	from MultiStaffViews MSV 
	join Staff S on MSV.UserStaffID=S.StaffID 
	where UserStaffId = @CopyStaffId and isnull(MSV.RecordDeleted,'N')='N' and @TurnOnMultiStaffView='Y'
	group by ViewName
	
	--Rx
	select sp.StaffId, sa.ScreenName, sa.Action
		from staffpermissions sp join staff s on sp.staffid=s.staffid
			join systemactions sa on sp.actionid=sa.actionid
		where isnull(SP.RecordDeleted,'N')='N' and s.StaffId=@CopyStaffId	

	select CDSP.StaffId,CDSP.Productivity from CustomDocumentStaffProductivity CDSP where StaffId = @CopyStaffId

end

if @ProcessFlag = 3
begin
	-- View what will be inserted
	select UserCode, StaffId, FirstName, LastName, Active, LastVisit,(select CodeName from GlobalCodes where GlobalCodeId=DetermineCaseloadBy) as DetermineCaseloadBy, RecordDeleted
from Staff where StaffId = @CopyStaffId or StaffId = @NewStaffId

	--StaffLocations
	select L.LocationName, SL.* 
	from StaffLocations SL left join (Select LocationId, LocationName from Locations) L on SL.LocationId=L.LocationId 
	where StaffId = @CopyStaffId and isnull(RecordDeleted,'N')='N'	
	and SL.LocationId not in (select LocationId from StaffLocations where isnull(RecordDeleted,'N')='N' and StaffId = @NewStaffId)
	and SL.LocationId not in (select LocationId from Locations where Active='N' or ISNULL(recordDeleted,'N')='Y')
	and L.LocationId not in (select * from fnsplit(@LocException,','))
	order by L.LocationName
	
	--StaffPrograms
	select P.ProgramName, SP.* 
	from StaffPrograms SP left join (select ProgramId, ProgramName from Programs) P on SP.ProgramId=P.ProgramId 
	where StaffId = @CopyStaffId and isnull(RecordDeleted,'N')='N'
		and SP.ProgramId not in (select ProgramId from StaffPrograms where isnull(RecordDeleted,'N')='N' and StaffId = @NewStaffId)
		and SP.ProgramId not in (select ProgramId from Programs where ISNULL(recorddeleted,'N')='Y' or Active='N')
		and P.ProgramId not in (select * from fnsplit(@ProgException,','))
		
	--StaffProxies
	select S.UserCode,SP.* 
	from StaffProxies SP left join (select UserCode, StaffId from Staff) S on SP.ProxyForStaffId=S.StaffId 
	where SP.StaffId = @CopyStaffId and isnull(SP.RecordDeleted,'N')='N'
		and ProxyForStaffId NOT in (select ProxyForStaffId from StaffProxies where isnull(RecordDeleted,'N')='N' and StaffId = @NewStaffId)
		and ProxyForStaffId not in (select StaffId from Staff where Active='N' or RecordDeleted='Y')
      	and S.StaffId not in (select * from fnsplit(@ProxyException,','))
      	and S.StaffId in (select StaffId from Staff where Active='Y' and ISNULL(RecordDeleted,'N')='N')
      	
	--StaffProcedures
	select PC.ProcedureCodeName,SProc.* 
	from StaffProcedures SProc left join (Select ProcedureCodeId, ProcedureCodeName from ProcedureCodes) PC on SProc.ProcedureCodeId=PC.ProcedureCodeId 
	where StaffId = @CopyStaffId and isnull(RecordDeleted,'N')='N'
		and SProc.ProcedureCodeId not in (select ProcedureCodeId from StaffProcedures where isnull(RecordDeleted,'N')='N' and StaffId = @NewStaffId)
		and SProc.ProcedureCodeId not in (select ProcedureCodeId from ProcedureCodes where Active='N' or ISNULL(recorddeleted,'N')='Y')
      	and PC.ProcedureCodeId not in (select * from fnsplit(@ProcedureException,','))
      	
	--StaffRoles
	select GC.CodeName as Role,SR.* 
	from staffroles SR left join (select CodeName, GlobalCodeId from GlobalCodes) GC on SR.RoleID=GC.GlobalCodeId 
	where StaffId = @CopyStaffId and isnull(SR.RecordDeleted,'N')='N'
		and RoleId not in (select RoleId from StaffRoles where isnull(RecordDeleted,'N')='N' and StaffId = @NewStaffId)
		and RoleId not in (select GlobalCodeId from GlobalCodes where Category like 'STAFFROLE' and (Active='N' or ISNULL(recorddeleted,'N')='Y'))
		and GC.GlobalCodeId not in (select * from fnsplit(@RoleException,','))
		
	--StaffSupervisors
	select (Select S2.UserCode from Staff S2 where S2.StaffId=SS.SupervisorId) as 'Supervisor', SS.* 
		from StaffSupervisors SS left join (select UserCode, StaffId from Staff) S on SS.StaffId=S.StaffId 
		where SS.StaffId = @CopyStaffId and isnull(SS.RecordDeleted,'N')='N'
		and SupervisorId not in (select SupervisorId from StaffSupervisors where isnull(RecordDeleted,'N')='N' and StaffId = @NewStaffId)
		and SupervisorId not in (select StaffId from Staff where Active='N' or ISNULL(RecordDeleted,'N')='Y')
		and SS.SupervisorId not in (select * from fnsplit(@SupervisorException,','))
		and SS.SupervisorId in (select StaffId from Staff where Active='Y' and ISNULL(RecordDeleted,'N')='N')
		
	--StaffWidgets (Dashboards)
	select W.WidgetName, W.WidgetId, SW.* 
	from StaffWidgets SW left join (select WidgetId, WidgetName from Widgets) W on SW.WidgetId=W.WidgetId 
	where StaffId = @CopyStaffId and isnull(RecordDeleted,'N')='N'
		and SW.WidgetId NOT in (select WidgetId from StaffWidgets where isnull(RecordDeleted,'N')='N' and StaffId = @NewStaffId)
		and SW.WidgetId not in (select WidgetId from Widgets where Active='N' or ISNULL(recorddeleted,'N')='Y')	
		and W.WidgetId not in (select * from fnsplit(@WidgetException,','))
		order by W.WidgetId

	--ReceptionViewStaff
	select RV.ViewName as ReceptionViewName, RV.ReceptionViewId, RV.AllStaff, COUNT(*) as StaffCount 
		from ReceptionViewStaff RVS 
			join ReceptionViews RV on RVS.ReceptionViewId=RV.ReceptionViewId 
			join Staff S on RVS.StaffId=S.StaffId 
		where RVS.StaffId = @CopyStaffId and isnull(RVS.Recorddeleted,'N')='N'
			and RVS.ReceptionViewId NOT in (select ReceptionViewId from ReceptionViewStaff where isnull(RecordDeleted,'N')='N' and StaffId = @NewStaffId)
			and RVS.ReceptionViewId not in (select * from fnsplit(@ReceptionException,','))
	group by RV.ViewName, RV.ReceptionViewId, RV.AllStaff order by RV.ViewName
		    
	--MultiStaffViewStaff
	select MSV.ViewName as MultiStaffView, MSVS.MultiStaffViewId, S2.Usercode as [Staff], S2.StaffId
		from MultiStaffViewStaff MSVS 
			join MultiStaffViews MSV on MSVS.MultiStaffViewId=MSV.MultiStaffViewId 
			left join Staff S on S.StaffId=MSVS.StaffId
			left join (select staffid,usercode from Staff where Active='Y' and ISNULL(recorddeleted,'N')='N') S2 on S2.StaffId=MSV.UserStaffId
		where isnull(MSVS.RecordDeleted,'N')='N' and S.StaffId = @CopyStaffId and @TurnOnMultiSVStaff = 'Y'
			and MSVS.MultiStaffViewId not in (select MultiStaffViewId from MultiStaffViewStaff where isnull(RecordDeleted,'N')='N' and StaffId = @NewStaffId)
			and MSVS.MultiStaffViewId not in (select * from fnsplit(@MultiSVStaffExcep,','))
	--group by MSV.ViewName,MSVS.MultiStaffViewId,S2.Usercode,S2.StaffId
	order by MSV.ViewName

	--MultiStaffViews
	select ViewName as PersonalMultiViews, MultiStaffViewId, AllStaff, Count(*) 
		from MultiStaffViews MSV 
			join Staff S on MSV.UserStaffID=S.StaffID 
		where UserStaffId = @CopyStaffId and isnull(MSV.RecordDeleted,'N')='N' and @TurnOnMultiStaffView='Y'
			and MSV.ViewName not in (select ViewName from MultiStaffViews where isnull(RecordDeleted,'N')='N' and UserStaffId = @NewStaffId)
			and MSV.MultiStaffViewId not in (select * from fnsplit(@MultiStaffViewExcep,','))
	group by ViewName, MultiStaffViewId, AllStaff

	--RX Permissions
	select sa.Action as RxAction, sa.ScreenName, sp.actionid, sp.*
		from StaffPermissions SP join staff src on sp.staffid=src.staffid
			join systemactions sa on sp.actionid=sa.actionid
		where isnull(SP.RecordDeleted,'N')='N' and src.StaffId=@CopyStaffId
			and sp.ActionId not in (select actionid from staffpermissions where isnull(RecordDeleted,'N')='N' and StaffId = @NewStaffId)
			and sp.ActionId not in (select ActionId from SystemActions where /*Active='N' or*/ ISNULL(recorddeleted,'N')='Y')
			and SA.ActionId not in (select * from fnsplit(@RXactionException,','))

	--Staff Productivity: Added 8.4.20
	select CDSP.StaffId,CDSP.Productivity 
	from CustomDocumentStaffProductivity CDSP 
	where StaffId = @CopyStaffId

	--Productivity Start Date
	SELECT * FROM CustomDocumentStaffProductivityPayPeriods SPPP
	WHERE (StartDate <= GETDATE() AND EndDate >= GETDATE())

end


if @ProcessFlag = 4
begin

--update staff table with Access Rights
update new
set new.Active = 'Y', new.PrimaryRoleId = copy.PrimaryRoleId, new.PrimaryProgramId = copy.PrimaryProgramId, new.Clinician = copy.Clinician, new.Attending = copy.Attending, new.ProgramManager = copy.ProgramManager, new.IntakeStaff = copy.IntakeStaff, new.AppointmentSearch = copy.AppointmentSearch, new.CoSigner = copy.CoSigner, new.AdminStaff = copy.AdminStaff, new.Prescriber = copy.Prescriber, new.AllowedPrinting = copy.AllowedPrinting, new.DisplayPrimaryClients = copy.DisplayPrimaryClients, new.AccessSmartCare = copy.AccessSmartCare, new.Administrator = copy.Administrator, new.SystemAdministrator = copy.SystemAdministrator, new.CanViewStaffProductivity = copy.CanViewStaffProductivity, new.CanCreateManageStaff = copy.CanCreateManageStaff, new.DefaultReceptionViewId = copy.DefaultReceptionViewId, new.DefaultCalenderViewType = copy.DefaultCalenderViewType, new.DefaultCalendarStaffId = copy.DefaultCalendarStaffId, new.DefaultMultiStaffViewId = copy.DefaultMultiStaffViewId, new.DefaultProgramViewId = copy.DefaultProgramViewId, new.DefaultCalendarIncrement = copy.DefaultCalendarIncrement, new.UsePrimaryProgramForCaseload = copy.UsePrimaryProgramForCaseload, new.EHRUser = copy.EHRUser, new.DefaultReceptionStatus = copy.DefaultReceptionStatus, new.ViewDocumentsBanner = copy.ViewDocumentsBanner, new.Supervisor = copy.Supervisor, new.DefaultPrescribingLocation = copy.DefaultPrescribingLocation, new.DefaultImageServerId = copy.DefaultImageServerId, new.AllowRemoteAccess = copy.AllowRemoteAccess, new.CanSignUsingSignaturePad = copy.CanSignUsingSignaturePad, new.AllowEmergencyAccess = copy.AllowEmergencyAccess, new.EmergencyAccessRoleId = copy.EmergencyAccessRoleId, new.AccessProviderAccess = copy.AccessProviderAccess, new.HomePageScreenId=1, new.DetermineCaseloadBy=copy.DetermineCaseloadBy, new.All837Senders=copy.All837Senders, new.AllProviders=copy.AllProviders
from Staff copy join Staff new ON copy.StaffId = @CopyStaffId and new.StaffId = @NewStaffId

Update staff set Authenticationtype='A'
where staffid=@NewStaffId  and @TurnOnActiveDirectory = 'Y'

--HomePageScreenId

	--StaffLocations
	insert into StaffLocations (StaffId,LocationId,PrescriptionPrinterLocationId,ChartCopyPrinterDeviceLocationId)
	select @NewStaffId as StaffId /*destination staffid*/
      ,LocationId,PrescriptionPrinterLocationId,ChartCopyPrinterDeviceLocationId
	from StaffLocations where isnull(RecordDeleted,'N')='N' and StaffId = @CopyStaffId
		and LocationID not in (select LocationId from StaffLocations where isnull(RecordDeleted,'N')='N' and StaffId = @NewStaffId)
		and LocationId not in (select LocationId from Locations where Active='N' or ISNULL(recordDeleted,'N')='Y')
		and LocationId not in (select * from fnsplit(@LocException,','))

	--StaffPrograms
	insert into StaffPrograms (StaffId,ProgramId)
	select @NewStaffId as StaffId /*destination staffid*/
     ,ProgramId
	from StaffPrograms where isnull(RecordDeleted,'N')='N' and StaffId = @CopyStaffId
		and ProgramID not in (select ProgramId from StaffPrograms where isnull(RecordDeleted,'N')='N' and StaffId = @NewStaffId)
		and ProgramId not in (select ProgramId from Programs where ISNULL(recorddeleted,'N')='Y' or Active='N')
		and ProgramId not in (select * from fnsplit(@ProgException,','))

	--StaffProxies
	insert into StaffProxies (StaffId,ProxyForStaffId)
	select @NewStaffId as StaffId /*destination staffid*/
		 ,ProxyForStaffId
	from StaffProxies where isnull(RecordDeleted,'N')='N' and StaffId = @CopyStaffId
		and ProxyForStaffId NOT in (select ProxyForStaffId from StaffProxies where isnull(RecordDeleted,'N')='N' and StaffId = @NewStaffId)
		and ProxyForStaffId not in (select StaffId from Staff where Active='N' or RecordDeleted='Y')
      	and StaffId not in (select * from fnsplit(@ProxyException,','))
      	and ProxyForStaffId in (select StaffId from Staff where Active='Y' and ISNULL(RecordDeleted,'N')='N')
      	
	--StaffProcedures
	insert into StaffProcedures (StaffId,ProcedureCodeId)
	select @NewStaffId as StaffId /*destination staffid*/
      ,ProcedureCodeId
	from StaffProcedures where isnull(RecordDeleted,'N')='N' and StaffId = @CopyStaffId
		and ProcedureCodeId not in (select ProcedureCodeId from StaffProcedures where isnull(RecordDeleted,'N')='N' and StaffId = @NewStaffId)
		and ProcedureCodeId not in (select ProcedureCodeId from ProcedureCodes where Active='N' or ISNULL(recorddeleted,'N')='Y')
      	and ProcedureCodeId not in (select * from fnsplit(@ProcedureException,','))
      	
	--StaffRoles
	insert into StaffRoles (StaffId,RoleId)	
	select @NewStaffId as StaffId /*destination staffid*/
      ,RoleId
	from StaffRoles where isnull(RecordDeleted,'N')='N' and StaffId = @CopyStaffId
	and RoleID not in (select RoleId from StaffRoles where isnull(RecordDeleted,'N')='N' and StaffId = @NewStaffId)
	and RoleId not in (select GlobalCodeId from GlobalCodes where Category='STAFFROLE' and (Active='N' or ISNULL(recorddeleted,'N')='Y'))
	and RoleID not in (select * from fnsplit(@RoleException,','))

	--StaffSupervisors
	insert into StaffSupervisors (StaffId,SupervisorId)
	select @NewStaffId as StaffId /*destination staffid*/
      ,SupervisorId
	from StaffSupervisors where isnull(RecordDeleted,'N')='N' and StaffId = @CopyStaffId and SupervisorId<>1
		and SupervisorId not in (select SupervisorId from StaffSupervisors where isnull(RecordDeleted,'N')='N' and StaffId = @NewStaffId)
		and SupervisorId not in (select StaffId from Staff where Active='N' or ISNULL(RecordDeleted,'N')='Y')
		and SupervisorId not in (select * from fnsplit(@SupervisorException,','))
		and SupervisorId in (select StaffId from Staff where Active='Y' and ISNULL(RecordDeleted,'N')='N')
		
	--StaffWidgets (Dashboards)
	insert into StaffWidgets (StaffId,WidgetId,ScreenId,WidgetOrder,OpenInMinimumSize,OpenInMaximumSize)
	select @NewStaffId as StaffId /*destination staffid*/
     ,WidgetId,ScreenId,WidgetOrder,OpenInMinimumSize,OpenInMaximumSize
	from StaffWidgets where isnull(RecordDeleted,'N')='N' and StaffId = @CopyStaffId and @TurnOnWidgets='Y'
		and WidgetId NOT in (select WidgetId from StaffWidgets where isnull(RecordDeleted,'N')='N' and StaffId = @NewStaffId)
		and WidgetId not in (select WidgetId from Widgets where Active='N' or ISNULL(recorddeleted,'N')='Y')	
		and WidgetId not in (select * from fnsplit(@WidgetException,','))

	--ReceptionViewStaff
	insert into ReceptionViewStaff (StaffId,ReceptionViewId)
	select @NewStaffId as StaffId /*destination staffid*/
      ,ReceptionViewId
	from ReceptionViewStaff where isnull(RecordDeleted,'N')='N' and StaffId = @CopyStaffId
		and ReceptionViewId NOT in (select ReceptionViewId from ReceptionViewStaff where isnull(RecordDeleted,'N')='N' and StaffId = @NewStaffId)
		and ReceptionViewId not in (select * from fnsplit(@ReceptionException,','))

	--MultiStaffViewStaff
	insert into MultiStaffViewStaff (StaffId,MultiStaffViewId)
	select @NewStaffId as StaffId /*destination staffid*/
	  ,MultiStaffViewId
	from MultiStaffViewStaff where isnull(RecordDeleted,'N')='N' and StaffId = @CopyStaffId and @TurnOnMultiSVStaff= 'Y'
		and MultiStaffViewId not in (select MultiStaffViewId from MultiStaffViewStaff where isnull(RecordDeleted,'N')='N' and StaffId = @NewStaffId)
		and MultiStaffViewId not in (select * from fnsplit(@MultiSVStaffExcep,','))

	--MultiStaffViews
	insert into MultiStaffViews (UserStaffId ,ViewName,AllStaff)
	select @NewStaffId as UserStaffId /*destination staffid*/
      ,ViewName,AllStaff 
      from MultiStaffViews where isnull(RecordDeleted,'N')='N' and UserStaffId = @CopyStaffId and @TurnOnMultiStaffView = 'Y'
		and MultiStaffViewID not in (select MultiStaffViewId from MultiStaffViews where isnull(RecordDeleted,'N')='N' and UserStaffId = @NewStaffId)	
		and MultiStaffViewId not in (select * from fnsplit(@MultiStaffViewExcep,','))

	--RX Permissions
	insert into staffpermissions(staffid, actionid, rowidentifier, createdby, createddate, modifiedby, modifieddate)
	select dest.staffid, sp.actionid, newid(), @EditorName, GETDATE(), @EditorName, GETDATE()
		from staff dest, staffpermissions sp join staff src on sp.staffid=src.staffid
			join systemactions sa on sp.actionid=sa.actionid
		where isnull(SP.RecordDeleted,'N')='N' and src.StaffId=@CopyStaffId and dest.StaffId=@NewStaffId
			and sp.ActionId not in (select actionid from staffpermissions where isnull(RecordDeleted,'N')='N' and StaffId = @NewStaffId)
			and sp.ActionId not in (select ActionId from SystemActions where /*Active='N' or*/ ISNULL(recorddeleted,'N')='Y')
			and SA.ActionId not in (select * from fnsplit(@RXactionException,','))

-- Active Directory
insert into ActiveDirectoryStaff(StaffId,ActiveDirectoryDomainId,ActiveDirectoryGUID,createdby,createddate,modifiedby,modifieddate)
select sf.staffid,1,newid(), @EditorName, GETDATE(), @EditorName, GETDATE()
from Staff sf 
where sf.staffid=@NewStaffId  and @TurnOnActiveDirectory = 'Y'

-- Care Management Staff Providers Insurers
insert into StaffProviders (staffid, ProviderId, createdby, createddate, modifiedby, modifieddate)
select dest.staffid, sv.Providerid, @EditorName, GETDATE(), @EditorName, GETDATE()
from staff dest, StaffProviders sv join staff src on sv.staffid=src.staffid
Where isnull(sv.RecordDeleted,'N')='N' and src.StaffId=@CopyStaffId and dest.StaffId=@NewStaffId and @TurnOnCareManagmentProvider  = 'Y'

--Care Management Staff Insurers
	insert into StaffInsurers (staffid, InsurerId, createdby, createddate, modifiedby, modifieddate)
	select @NewStaffId as StaffId /*destination staffid*/
		 ,InsurerID, @EditorName, GETDATE(), @EditorName, GETDATE()
	from StaffInsurers where isnull(RecordDeleted,'N')='N' and StaffId = @CopyStaffId
		and StaffID NOT in (select InsurerID from StaffInsurers where isnull(RecordDeleted,'N')='N' and StaffId = @NewStaffId)


	---Added 8.5.20 to populate productivity. This will select the employees productivity % and copy to new staff member
	update CustomDocumentStaffProductivity
	SET Productivity=(SELECT PRODUCTIVITY FROM CustomDocumentStaffProductivity WHERE STAFFID=@CopyStaffId)
	WHERE STAFFID=@NewStaffId

	--This updates the STARTDATE on the productivity to match the current getdate. 
	update CustomDocumentStaffProductivity
	SET StartDate = (SELECT PayPeriodId FROM CustomDocumentStaffProductivityPayPeriods SPPP
	WHERE (StartDate <= GETDATE() AND EndDate >= GETDATE()))
	WHERE STAFFID=@NewStaffId
	
end

if @ProcessFlag = 5  /* Use this delete if user has a job/role change */
begin

use prodSmartCare
	update StaffLocations set RecordDeleted='Y',DeletedDate=GETDATE(),DeletedBy=@EditorName from StaffLocations where StaffId = @DeleteRole_StaffID
	update StaffPrograms set RecordDeleted='Y',DeletedDate=GETDATE(),DeletedBy=@EditorName from StaffPrograms where StaffId = @DeleteRole_StaffID
	update StaffProxies set RecordDeleted='Y',DeletedDate=GETDATE(),DeletedBy=@EditorName from StaffProxies where StaffId = @DeleteRole_StaffID
	update StaffProcedures set RecordDeleted='Y',DeletedDate=GETDATE(),DeletedBy=@EditorName from StaffProcedures where StaffId = @DeleteRole_StaffID
	update StaffRoles set RecordDeleted='Y',DeletedDate=GETDATE(),DeletedBy=@EditorName from StaffRoles where StaffId = @DeleteRole_StaffID
	update StaffSupervisors set RecordDeleted='Y',DeletedDate=GETDATE(),DeletedBy=@EditorName from StaffSupervisors where StaffId = @DeleteRole_StaffID
	update StaffWidgets set RecordDeleted='Y',DeletedDate=GETDATE(),DeletedBy=@EditorName from StaffWidgets where StaffId = @DeleteRole_StaffID
	update ReceptionViewStaff set RecordDeleted='Y',DeletedDate=GETDATE(),DeletedBy=@EditorName from ReceptionViewStaff where StaffId = @DeleteRole_StaffID
	update MultiStaffViewStaff set RecordDeleted='Y',DeletedDate=GETDATE(),DeletedBy=@EditorName from MultiStaffViewStaff where StaffId = @DeleteRole_StaffID
	update MultiStaffViews set RecordDeleted='Y',DeletedDate=GETDATE(),DeletedBy=@EditorName from MultiStaffViews where UserStaffId = @DeleteRole_StaffID
	update StaffPermissions set RecordDeleted='Y',DeletedDate=GETDATE(),DeletedBy=@EditorName from StaffPermissions where StaffId = @DeleteRole_StaffID
	
	/***
	delete from StaffRoles where StaffRoleId in (4678,4679,4680) and StaffId = 1684 and CreatedBy = 'KCMHSAS\asthompson'
	***/
end