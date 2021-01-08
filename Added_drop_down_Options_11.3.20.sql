use SmartCarePreProd

select * from banners
order by ModifiedDate desc



select * from globalcodes
where category like '%contactnotedetail%' 
and Active = 'Y'

--1
begin tran
insert into globalcodes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category,CodeName,Active,CannotModifyNameOrDelete)
VALUES ('Wbarlow',getdate(),'Wbarlow',getdate(),'CONTACTNOTEDETAIL','CHW-OPT','Y','Y')
commit tran

--2
begin tran
insert into globalcodes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category,CodeName,Active,CannotModifyNameOrDelete)
VALUES ('Wbarlow',getdate(),'Wbarlow',getdate(),'CONTACTNOTEDETAIL','CHW-Psych Services','Y','Y')
commit tran


--3
begin tran
insert into globalcodes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category,CodeName,Active,CannotModifyNameOrDelete)
VALUES ('Wbarlow',getdate(),'Wbarlow',getdate(),'CONTACTNOTEDETAIL','CHW-Youth and Family','Y','Y')
commit tran


--4
begin tran
insert into globalcodes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category,CodeName,Active,CannotModifyNameOrDelete)
VALUES ('Wbarlow',getdate(),'Wbarlow',getdate(),'CONTACTNOTEDETAIL','CHW-Suicide Prevention','Y','Y')
commit tran








select * from globalcodes
where category like '%contactnotedetail%' and codename like '%Voicemail Box Full%'

select * from globalcodes
where Category like '%AppointmentType%'
and Active='Y'
order by CodeName asc


SELECT * FROM GlobalCodes
WHERE CODENAME LIKE '%EMH APPOINTMENTS%'



SELECT * FROM SCHEDULEREVENTS

begin tran
insert into globalcodes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category,CodeName,Active,CannotModifyNameOrDelete)
VALUES ('Wbarlow',getdate(),'Wbarlow',getdate(),'AppointmentType','CHW-OPT','Y','N')
commit tran

--2
begin tran
insert into globalcodes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category,CodeName,Active,CannotModifyNameOrDelete)
VALUES ('Wbarlow',getdate(),'Wbarlow',getdate(),'AppointmentType','CHW-Psych Services','Y','N')
commit tran


--3
begin tran
insert into globalcodes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category,CodeName,Active,CannotModifyNameOrDelete)
VALUES ('Wbarlow',getdate(),'Wbarlow',getdate(),'AppointmentType','CHW-Youth and Family','Y','N')
commit tran


--4
begin tran
insert into globalcodes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category,CodeName,Active,CannotModifyNameOrDelete)
VALUES ('Wbarlow',getdate(),'Wbarlow',getdate(),'AppointmentType','CHW-Suicide Prevention','Y','N')
commit tran


select top 4* from GlobalCodes
order by CreatedDate desc

update GlobalCodes
SET Color = 'ffff0000'
where GlobalCodeId in (77473,77472,77471,77470)

select * from ProviderAuthorizations
where ProviderAuthorizationId=345665