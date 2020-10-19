use ProdSmartCare


BEGIN TRAN
update Authorizations
SET PROVIDERID=S.ProviderId
FROM Authorizations A
LEFT JOIN SITES S ON A.SiteId = S.SiteId
where A.ProviderId is null
and A.SiteId is not null
and A.CreatedDate > '2020-01-01'
ROLLBACK TRAN
COMMIT TRAN

select * from authori