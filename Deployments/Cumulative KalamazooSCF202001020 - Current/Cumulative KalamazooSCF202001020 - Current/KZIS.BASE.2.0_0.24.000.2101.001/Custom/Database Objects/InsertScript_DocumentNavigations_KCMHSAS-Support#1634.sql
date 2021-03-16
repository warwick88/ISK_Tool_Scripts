/********************************************************************************                                                    
-- Copyright: Streamline Healthcare Solutions    
--    
-- Purpose: Adding DocumentNavigations items for "Psychiatric Note"(i.e Screenid: 61246, Documentcodeid=60069).
-- Author:  Himmat Jamdade
-- Date:    12 Jan 2021
*********************************************************************************/ 
DECLARE @ScreenId INT
select @ScreenId = Screenid from screens where Code = 'PsychiatricEMNote2021'
IF NOT EXISTS (select DocumentNavigationId from DocumentNavigations where NavigationName='Psychiatric Note'
and DisplayAs='Psychiatric Note' and ParentDocumentNavigationId=29 and ScreenId = @ScreenId
) 
  BEGIN 

      INSERT INTO [DocumentNavigations] 
                  (NavigationName, 
                   DisplayAs, 
                   ParentDocumentNavigationId, 
                   [Active], 
                   ScreenId,
                   CreatedBy,
                   ModifiedBy

                  ) 
      VALUES      (
                    'Psychiatric Note', 
                    'Psychiatric Note', 
                    29, 
                    'Y',
                    @ScreenId,
                    'KCMHSAS-Support#1634',
				    'KCMHSAS-Support#1634'
                   ) 
  END 