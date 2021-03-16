
 /*********************************************************************/                                                                   
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                                                                    
/* Creation Date:    12/3/2020                                        */                                                    
 /*  Date           Created By			Purpose                             */                                                                    
 /* 12 Dec , 2020   Sunil Dasari		What: Added logic for the validation 'A signed Adv/Adq. Notice Document is requrired for this date.' to allow if the users has either 'Notice of Adverse Benefit Determination' Or 'Advance/Adequate Notice' document.
										Why:  KCMHSAS - Support #1587
 */                                           
/*********************************************************************/   
--select * from documentvalidations where DocumentCodeId=1469 and ErrorMessage like '%A signed Adv/Adq. Notice Document is requrired for this date.%'
--ValidationLogic
--where not exists ( select 1 from documents d where d.ClientId = @Clientid and isnull(d.RecordDeleted,'N')<>'Y' and d.documentCodeId = 100   and d.EffectiveDate = @EffectiveDate and d.Status=22 )

 
update documentvalidations set ValidationLogic='where not exists ( select 1 from documents d where d.ClientId = @Clientid and isnull(d.RecordDeleted,''N'')<>''Y'' and d.documentCodeId in (60058, 100)   and d.EffectiveDate = @EffectiveDate and d.Status=22 )' where DocumentCodeId=1469 and ErrorMessage like '%A signed Adv/Adq. Notice Document is requrired for this date.%'