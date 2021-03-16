/****** Object:  Trigger [TriggerInsert_Clients]     ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TriggerInsert_Clients]'))
DROP TRIGGER [dbo].[TriggerInsert_Clients]
GO

/****** Object:  Trigger [dbo].[TriggerInsert_Clients]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO  
  
CREATE trigger [dbo].[TriggerInsert_Clients] on [dbo].[Clients] for insert       
/*********************************************************************      
-- Trigger: dbo.TriggerInsert_Clients      
-- Copyright: Streamline Healthcare Solutions      
--    
-- Updates:       
--  Date         Author   Purpose      
-- 01.18.2011    SFarber  Created. 

 -- 12.13.2019   Bibhu       What : RaisError ErrorCode added.
 --                           Why :  Engineering Improvement Initiatives- NBL(I) #103012    
   
**********************************************************************/                       
as      
    
declare @ErrorNumber           int      
declare @ErrorMessage          varchar(255)      
      
--    
-- Make new clients visible to all staff members    
--      
insert into StaffClients(StaffId, ClientId)    
select s.StaffId, i.ClientId    
  from Staff s    
       cross join inserted i    
 where datediff(dd, s.LastVisit, getdate()) = 0    
   and not exists(select * from StaffClients sc where sc.StaffId = s.StaffId and sc.ClientId = i.ClientId)    
    
if @@error <> 0    
begin      
  select @ErrorNumber  = 50010,      
         @ErrorMessage = 'ERR_TriggerInsert_Clients : Failed to insert into StaffClients. Please contact your system administrator.'      
  goto error      
end       
      
        
return      
      
error:      
set @ErrorMessage = @ErrorMessage + ', Error Number: %d'
raiserror(@ErrorMessage, 16, 1, @ErrorNumber )
rollback transaction
  