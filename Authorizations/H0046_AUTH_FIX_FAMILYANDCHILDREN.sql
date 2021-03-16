use ProdSmartCare

--So we want BILLINGCODEID=583

/*
	So here this client has H0046:TG:U9
	Obviously CM Auths failed to get modifiers over to cm auths
*/
select * from Providerauthorizations
where clientid=97377
AND BillingCodeId=583
order by createddate desc

--BIG QUERY TO ISLOATE THEM THEN RUN EACH ONE THRU PROVIDERAUTHS/AUTHS
--SO THIS IS ALSO ONLY 1 PROVIDER
SELECT * FROM PROVIDERAUTHORIZATIONS
WHERE PROVIDERID=103
AND SITEID=94
AND BILLINGCODEID=583
AND CREATEDDATE > '2020-06-01'
AND MODIFIER1 IS NULL
ORDER BY CREATEDDATE DESC

select * from BillingCodes


--SO Lookup Provider Auth, then tie it to Auths and Confirm 472 or 473
select * from Providerauthorizations
where ProviderAuthorizationId=374807

select * from Authorizations
where ProviderAuthorizationId=374807

--IF AUTHORIZATION IS 472 USE THIS
BEGIN TRAN
UPDATE Providerauthorizations
SET Modifier1='U9'
where ProviderAuthorizationId=
COMMIT TRAN

--OR IF IT'S 473 AUTHORIZATION CODE
BEGIN TRAN
UPDATE Providerauthorizations
SET Modifier1='TG',Modifier2='U9',BillingCodeModifierId=1076
where ProviderAuthorizationId=374807
COMMIT TRAN
