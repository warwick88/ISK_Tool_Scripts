 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetClientProgramsList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetClientProgramsList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[csp_GetClientProgramsList]     
@ClientID int               
AS                                      
                                      
/*********************************************************************/                                        
/* Stored Procedure: dbo.csp_GetClientProgramsList					 */                                        
/* Copyright: 2011 Streamline Healthcare Solutions,  LLC             */                                        
/* Purpose:  Return Client Programs List where Status <> Discharge.  */                                       
/* Input Parameters: @ClientID                                       */                                      
/* Output Parameters:   None                                         */                                        
/*                                                                   */                                        
/* Called By:  Discharge Document.Gernal                             */                                        
/* Calls:                                                            */                                        
/* Data Modifications:                                               */                                        
/* Updates:                                                          */                                        
/*  Date            Author          Purpose                          */                                                       
/* 16/Sep/2014      Akwinass         Create                           */ 
/*********************************************************************/                                             
BEGIN                         
BEGIN TRY   
    
select P.ProgramCode,CP.PrimaryAssignment,CP.ClientProgramId,
case CP.Status when '1' then Null else CONVERT(VARCHAR(10),CP.EnrolledDate,101) end as EnrolledDate 
from ClientPrograms CP
inner join Programs P on cp.ProgramId=P.ProgramId
inner join Clients C on C.ClientId=CP.ClientId
where c.ClientId= @ClientID
AND CP.[Status] IN(4,1) /*Program Status 'Enrolled' */ 
AND IsNull(CP.RecordDeleted,'N')='N'
AND IsNull(P.RecordDeleted,'N')='N'
AND IsNull(C.RecordDeleted,'N')='N'   
--AND P.ProgramType=(select GlobalCodeId from globalcodes where  CodeName='TEAM' and category='PROGRAMTYPE')     
              
END TRY              
BEGIN CATCH                        
DECLARE @Error varchar(8000)                                          
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                           
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_GetClientProgramsList ')                  
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                            
   + '*****' + Convert(varchar,ERROR_STATE())                                          
                                        
   RAISERROR                                           
   (                                          
    @Error, -- Message text.                                          
    16, -- Severity.                                          
    1 -- State.                                          
   );                           
End CATCH                                                                 
                    
End    


