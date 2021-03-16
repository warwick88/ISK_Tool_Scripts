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
where ProviderAuthorizationId=374879

select * from Authorizations
where ProviderAuthorizationId=374879

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
where ProviderAuthorizationId=374880
COMMIT TRAN





select * from AuthorizationCodes
where AuthorizationCodeId in (472,473)

--So we lookup the authorizatio in CM authorizations
--You can tell if was it supposed to have 472 modifiers or 473 modifiers
--by tieing it back to auths able and then pulling those values.
/*
	AuthorizationCodeid 472: H0046:U9 Pmt Code Case Mgmt
	AuthorizationCodeId 473: H0046:TG:U9 Pmt Code Case Mgmt

*/


select * from Providerauthorizations
where providerauthorizationid=376243


select * from authorizations
where providerauthorizationid=376243



select * from authorizationcodes
where authorizationcodeid=472



select top 5* from documents
order by createddate desc


select * from AuthorizationCodes
where authorizationcodename like '%H0046%'
ORDER BY CREATEDDATE DESC

update AuthorizationCodes
SET ClinicianMustSpecifyBillingCode='N'
where AuthorizationCodeId IN (472,473)

SELECT * FROM BILLINGCODES
where billingcode like '%H0046%'

update AuthorizationCodes
SET DefaultModifier1='U9',ProcedureCodeGroupName='H0046U9',Internal=NULL
where AuthorizationCodeId=472

update AuthorizationCodes
SET DefaultModifier1='U9',ProcedureCodeGroupName='H0046TGU9',Internal=NULL,DefaultModifier2='TG'
where AuthorizationCodeId=473