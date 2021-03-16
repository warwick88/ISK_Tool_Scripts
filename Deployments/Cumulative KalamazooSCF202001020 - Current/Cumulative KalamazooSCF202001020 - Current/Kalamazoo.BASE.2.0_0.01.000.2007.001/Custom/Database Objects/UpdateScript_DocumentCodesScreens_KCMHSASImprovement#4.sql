/***************************************************************************************
Author : Vinay K S
Purpose:For the task KCMHSAS-Improvement #4
***************************************************************************************/
If exists(select 1 from DocumentCodes where code='BDE62873-41E5-4842-AB04-C7E4D6D32C8D')
BEGIN
update DocumentCodes set ViewDocumentURL='RDLReportCustomRegistraionMain' 
						,ViewDocumentRDL = 'RDLReportCustomRegistraionMain'
						,InitializationStoredProcedure = 'csp_InitDocumentRegistrations'
where code='BDE62873-41E5-4842-AB04-C7E4D6D32C8D'
END

If exists(select 1 from screens where code='BDE62873-41E5-4842-AB04-C7E4D6D32C8D')
BEGIN
update screens set PostUpdateStoredProcedure ='csp_SCPostSignatureUpdateRegistrationDocument'
				   ,InitializationStoredProcedure='csp_InitDocumentRegistrations'
				   ,ValidationStoredProcedureComplete='csp_ValidateDocumentRegistrations'
where code='BDE62873-41E5-4842-AB04-C7E4D6D32C8D'
END
