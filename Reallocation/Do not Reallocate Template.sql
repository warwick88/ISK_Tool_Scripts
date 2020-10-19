use Prodsmartcare
update x set DoNotReallocate='Y', ModifiedDate=GETDATE(),
 ModifiedBy='[UserCode]'  -- [UserCode] = SmartCare UserCode of staff person running query
      from CustomFieldServiceNotes x join Services S on S.ServiceId=x.ServiceId
            where DoNotReallocate is null and x.ServiceId in (
[serviceID1]	,
[serviceID2]	,
[serviceID3]	,
etc	
)

--[ServiceID] = ServiceIDs from column1 (separated by commas) of the first tab in the spreadsheet file provided by 
--billing/reimbursement
