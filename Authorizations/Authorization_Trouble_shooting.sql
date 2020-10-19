use ProdSmartCare

--So Auths can be confusing under "Client Authorizations" ID is AuthorizationDocumentId value.
--Authorization Number is Auth# usually 'UM-2020 ....ETC'
DECLARE @AuthorizationDocumentId INT;
SET @AuthorizationId = 

select * from providerauthorizations
where clientid=129112
order by createddate desc

select top 100* from authorizations
order by createddate desc

SELECT * FROM Authorizations
WHERE AuthorizationNumber='UM-20200917-313043'

select * from authorizations
WHERE AuthorizationDocumentId='127241'