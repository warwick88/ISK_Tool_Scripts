use ProdSmartCare

SELECT * FROM COVERAGEPLANS
WHERE COVERAGEPLANID=404

--so we need Medicare coverage plan and if IT has 99214:GT codes soo
SELECT * FROM ProcedureRates
WHERE Procedurecodeid=652
and coverageplanid=404
and fromdate > '2018-01-01'

--sO pROCEDURErATES DOES HAVE COVERAGEPLANID FK!
SELECT * FROM ProcedureRates
WHERE Procedurecodeid=652

SELECT * FROM ProcedureRates
WHERE procedurerateid=3058


select * from coverageplans
where coverageplanid=404



--2nd
SELECT * FROM ProcedureCodes
WHERE ProcedureCodeId=652

--first
SELECT * FROM ProcedureCodes
WHERE DisplayAs like '%99214:GT Telepsych%'

SELECT * FROM ProcedureCodes
WHERE ProcedureCodeId=652

/*
	So start by finding the procedurecode you need
	for GT
	then drill that into procedurerates and up to the contract
	find which termned and then next like david did.
*/





select * from ProcedureCodes
where ProcedureCodeId=652

select * from ProcedureCodes
where DisplayAs like '%99214:GT%'

select * from ProcedureCodes
where ProcedureCodeId in (
652



