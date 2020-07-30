USE [ProdSmartCare]
GO

/****** Object:  StoredProcedure [dbo].[ksp_Guardianship_Removal]    Script Date: 7/30/2020 10:17:34 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Warwick Barlow
-- Create date: 11.22.2019
-- Description:	Finds individuals turning 18 today. Turns off Guardianship then emails primary clinician.
-- =============================================
CREATE PROCEDURE [dbo].[ksp_Guardianship_Removal]

AS

SET NOCOUNT ON
BEGIN

--This query will select people with a birthday today, it puts current date into it's own column as well

select ClientId, lastname,firstname,DOB, getdate() as CurrentDate into #Temp1 from clients 
where DAY([DOB]) = DAY(GETDATE())
AND MONTH([DOB]) = MONTH(GETDATE())
and Active = 'Y'

--This query will take two previous columns, and do a small caculation to calculate their actual age
--This is then inserted into #temp2

select *, DATEDIFF(year,DOB,CurrentDate) as Age into #Temp2 from #Temp1

/*
	This final query takes the individuals who have birthdays today
	and if they are turning 18 puts them into their own list
*/
select * into #Temp3 from #Temp2
where Age >= 18
and Age < 19

/* 
    List below is all client contacts, where it's not deleted,
    and the guardianship is 'Y'
*/

select CC.*,C.PrimaryClinicianId into #Temp4 from ClientContacts CC
left join Clients C on CC.ClientId = C.ClientId
where CC.ClientId in(
	select ClientId from #Temp3
	where ISNULL(CC.RecordDeleted,'N') = 'N'
	and CC.Guardian = 'Y'
	)


--Now all results from #Temp4 which are Guardians that are not deleted and active.
--Rolled into a transaction to be safe
begin tran
Update ClientContacts
SET ACTIVE = 'N', ModifiedBy='AutoGuardianChg',modifiedDate=getdate()
WHERE CLIENTCONTACTID IN
  (SELECT ClientContactId
     FROM #Temp4
)
commit tran

--This section was added 2.20.20 because clinicians wanted a flag
--for client turning 18 to get turned off at the same time.
begin tran
SELECT * into #Temp10 FROM ClientNotes
where clientid in (select clientid from #Temp4)
AND NoteType=24521
commit tran

--This terminates their "child turns 18 on" flag. It will make the date 1 day
--Before 18 to help with authorizations.
begin tran
update ClientNotes
SET Active='N',EndDate=DATEADD(day, -1, convert(date, GETDATE()))
WHERE clientnoteid in (SELECT ClientNoteId FROM #Temp10)
commit tran


--We need to send messages to all individuals that HAVE a Primary Clinician

select * into #Temp5 from #Temp4
WHERE PrimaryClinicianId is not null



/* 
	Now that we have the ClientContact turned off, we must send an email to the primary clinician
    if they infact have one.
    Created a New User for the Emails: 33562 is staff ID.
*/
begin tran
insert into Messages
(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,FromStaffId,ToStaffId,ClientId,Unread,DateReceived,Subject,Message)
select 'AutoGuardianChg'
	,getdate()
	,'AutoGuardianChg'
	,getdate()
	,33964 --This is a new staff member for this purpose
	,PrimaryClinicianId
	,ClientId
	,'Y'
	,getdate()
	,'Client Turning 18: Removing Guardianship'
	,'Your Client turned 18, all Guardianship was removed. You will need to review their current guardianship information as soon as possible.'
	from #Temp5

commit tran


END

/* 
	END
*/
GO


