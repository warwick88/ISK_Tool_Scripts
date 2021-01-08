use ProdSmartCare


select top 2500* from authorizations
order by createddate desc

select top 250* from authorizations
where SITEID IS NOT NULL
AND PROVIDERID IS NULL
and SITEID IN (
96,
172,99,93,1469,101,1139,157,94,174)
order by createddate desc

SELECT * FROM SITES	
WHERE SITEID IN (
96,
172,99,93,1469,101,1139,157,94,174)

/*
	93: 102 Beacon Services
	94: 103 Family and Children Services
	96: 106 CHC - Elizabeth Upjohn Healing Centers
	99: 111 MRC Industries
	101: 113 Interact of Michigan. Inc
*/

