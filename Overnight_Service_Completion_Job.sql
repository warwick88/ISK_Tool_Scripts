use SmartCarePreProd

exec ssp_PMCompleteShowServices 'SERVICECOMPLETE'

exec csp_job_ServiceErrorsScheduledServices

exec ssp_SetChargeReadyToBill 'READYTOBILL'

exec csp_autoPaymentPosting