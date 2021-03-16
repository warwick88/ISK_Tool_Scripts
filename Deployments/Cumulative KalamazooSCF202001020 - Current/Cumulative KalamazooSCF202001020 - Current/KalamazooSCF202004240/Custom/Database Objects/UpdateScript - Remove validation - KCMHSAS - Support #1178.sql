/*What: Remove the validation 'If a Substance is checked on the Substance Use History tab, then Route is required for that substance and cannot be a€˜Not Applicable.a€™"'
Why: KCMHSAS - Support #1178 */

IF EXISTS(Select 1 from DocumentValidations Where DocumentCodeId=50002 AND TabName ='Substance Use History'
AND TableName ='CustomBHTEDSDischargeSUHistory' AND ColumnName ='Route' 
AND ErrorMessage Like '%If a Substance is checked on the Substance Use History tab, then Route is required for that substance and cannot be%'
AND ISNULL(RecordDeleted,'N')='N')
BEGIN
 UPDATE DocumentValidations SET RecordDeleted='Y', DeletedBy='KCMHSAS-Sup#1178', DeletedDate=Getdate()
 Where DocumentCodeId=50002 AND TabName ='Substance Use History'
AND TableName ='CustomBHTEDSDischargeSUHistory' AND ColumnName ='Route' 
AND ErrorMessage Like '%If a Substance is checked on the Substance Use History tab, then Route is required for that substance and cannot be%'
END 