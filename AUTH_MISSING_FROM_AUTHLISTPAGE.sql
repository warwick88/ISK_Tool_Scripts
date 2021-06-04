use ProdSmartCare

--So we need documentversionID
select * from documents
where documentid=2856906

--We need to find the TPProcedures to find auth ID
select * from documentversions
where documentid=2856906


--Now we can find auths with the tpprocedures
select * from tpprocedures
where documentversionid=2969355

select * from authorizations
where authorizationid in (
315938,
315939
)

--We need to get AuthorizationDocumentID so we can
--check the authorizationdocuments table
--This table shows which funding source was used
--likely the funding is removed causing display issue.
select top 1000* from authorizationdocuments
where AuthorizationDocumentId in (
134544,
134544)

select * from Clientcoverageplans
where clientcoverageplanid=296461

update clientcoverageplans
SET DeletedBy=NULL,RECORDDELETED=NULL,DeletedDate=NULL
where clientcoverageplanid=296461
