/*
	Permission Template tool 2021
*/


Use ProdSmartCare
--Reports
select r.name, t.roleid, g.codename, t.permissiontemplatetype, c.codename, i.PermissionItemId, count(PermissionTemplateItemId) as itemcount
from permissiontemplateitems i
left join permissiontemplates t on i.permissiontemplateid=t.permissiontemplateid
join reports r on r.reportid=i.PermissionItemId
join globalcodes g on g.globalcodeid=t.roleid and g.Active='Y'
join globalcodes c on c.globalcodeid=t.permissiontemplatetype and c.Active = 'Y'
where c.codename in('Reports') and name LIKE '%flag%'
group by r.name, t.roleid, g.codename, t.permissiontemplatetype, c.codename, i.PermissionItemId
order by r.name

--Banners
select b.bannername, t.roleid, g.codename, t.permissiontemplatetype, c.codename, i.PermissionItemId, count(PermissionTemplateItemId) as itemcount
from permissiontemplateitems i
left join permissiontemplates t on i.permissiontemplateid=t.permissiontemplateid
join banners b on b.bannerid=i.PermissionItemId
join globalcodes g on g.globalcodeid=t.roleid and g.Active='Y'
join globalcodes c on c.globalcodeid=t.permissiontemplatetype and c.Active = 'Y'
where c.codename in('Banners')
group by b.bannername, t.roleid, g.codename, t.permissiontemplatetype, c.codename, i.PermissionItemId
order by b.bannername

--Screens
select s.Screenname, t.roleid, g.codename, t.permissiontemplatetype, c.codename, i.PermissionItemId, count(PermissionTemplateItemId) as itemcount
from permissiontemplateitems i
left join permissiontemplates t on i.permissiontemplateid=t.permissiontemplateid
join screens s on s.screenid=i.PermissionItemId
join globalcodes g on g.globalcodeid=t.roleid and g.Active='Y'
join globalcodes c on c.globalcodeid=t.permissiontemplatetype and c.Active = 'Y'
where c.codename like '%Screen%'
group by s.screenname, t.roleid, g.codename, t.permissiontemplatetype, c.codename, i.PermissionItemId
order by s.screenname

--Document Codes
select d.documentname, t.roleid, g.codename, t.permissiontemplatetype, c.codename, i.PermissionItemId, count(PermissionTemplateItemId) as itemcount
from permissiontemplateitems i
left join permissiontemplates t on i.permissiontemplateid=t.permissiontemplateid
join documentcodes d on d.DocumentCodeId=i.PermissionItemId
join globalcodes g on g.globalcodeid=t.roleid and g.Active='Y'
join globalcodes c on c.globalcodeid=t.permissiontemplatetype and c.Active = 'Y'
where c.codename like '%document%'
group by d.documentname, t.roleid, g.codename, t.permissiontemplatetype, c.codename, i.PermissionItemId
order by d.documentname
