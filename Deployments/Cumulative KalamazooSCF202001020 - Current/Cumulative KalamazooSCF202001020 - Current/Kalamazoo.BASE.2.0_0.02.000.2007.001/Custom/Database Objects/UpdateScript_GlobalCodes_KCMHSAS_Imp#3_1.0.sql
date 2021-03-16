/*-------------------------------------------------------------------
Author : Vinay K S
Purpose: To update sort order for the values at INQUIRY STATUS dropdown
---------------------------------------------------------------------*/
update globalcodes set SortOrder = 1 where Category = 'XINQUIRYSTATUS' and Code='INPROGRESS'
update globalcodes set SortOrder = 2 where Category = 'XINQUIRYSTATUS' and Code='COMPLETE'