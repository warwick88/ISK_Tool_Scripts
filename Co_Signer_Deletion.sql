use ProdSmartCare



/*
	Script for fixing co signature issue.
*/

---Just feed it a list of the document ID's----And it takes care of the rest
begin tran
update DOCUMENTSIGNATURES
SET RecordDeleted='Y',DeletedBy='WBARLOW',DeletedDate=GETDATE()
WHERE SignedDocumentVersionId IS NULL
AND DocumentId in (
2865690,
2863035,
2857174,
2857177,
2851173,
2835276,
2834067,
2834064,
2805170,
2800395,
2800005,
2799984,
2793717,
2793708,
2770545,
2770548,
2763354,
2763353,
2742574,
2730091,
2693111,
2687396,
2687431,
2685957,
2281307,
1816869,
1272496,
1177685,
2860796,
2857038,
2836876,
2834621,
2830713,
2830709,
2829501,
2825597,
2825482,
2824302,
2819282,
2819330,
2797215,
2797209,
2783866,
2772110,
2772216,
2762109,
2732283,
2699841,
2685831
)

commit tran
rollback tran


select * from documents
where documentid=2665197

--Kalicia Good doc
select * from documents
where documentid=2675794

update documents
SET DocumentShared='Y'
where documentid=2675794

select * from documentversions
where documentid=2675794






select * from DocumentSignatures
where documentid in (1225956,
1921306)




DECLARE @documentid INT;
SET @documentid = 2488616

select * from documents
where documentid=@documentid

select * from documentversions
where documentid=@documentid

select * from DocumentSignatures
where documentid=@documentid
AND SignedDocumentVersionId IS NULL

select * from documentsignatures
where signatureid in (2735507,2859028)








select * from documents
where documentid=2831723

select * from documentsignatures
where documentid=2831723

update documentsignatures
SET RecordDeleted='Y',DeletedBy='WBARLOW',DeletedDate=GETDATE()
where SIGNEDDOCUMENTVERSIONID IS NULL
and documentid in (
2831723
)

SELECT * FROM DocumentSignatures
WHERE SignatureId IN(

2865690,
2863035,
2857174,
2857177,
2851173,
2835276,
2834067,
2834064,
2805170,
2800395,
2800005,
2799984,
2793717,
2793708,
2770545,
2770548,
2763354,
2763353,
2742574,
2730091,
2693111,
2687396,
2687431,
2685957,
2281307,
1816869,
1272496,
1177685,
2860796,
2857038,
2836876,
2834621,
2830713,
2830709,
2829501,
2825597,
2825482,
2824302,
2819282,
2819330,
2797215,
2797209,
2783866,
2772110,
2772216,
2762109,
2732283,
2699841,
2685831
)


BEGIN TRAN
UPDATE DocumentSignatures
SET RecordDeleted='Y',DeletedBy='WBARLOW',DeletedDate=GETDATE()
WHERE SignatureId IN(

2865690,
2863035,
2857174,
2857177,
2851173,
2835276,
2834067,
2834064,
2805170,
2800395,
2800005,
2799984,
2793717,
2793708,
2770545,
2770548,
2763354,
2763353,
2742574,
2730091,
2693111,
2687396,
2687431,
2685957,
2281307,
1816869,
1272496,
1177685,
2860796,
2857038,
2836876,
2834621,
2830713,
2830709,
2829501,
2825597,
2825482,
2824302,
2819282,
2819330,
2797215,
2797209,
2783866,
2772110,
2772216,
2762109,
2732283,
2699841,
2685831
)
COMMIT TRAN
rollback tran



DECLARE @documentid INT;
SET @documentid = 2395836

select * from documents
where documentid=@documentid

select * from documentversions
where documentid=@documentid

select * from DocumentSignatures
where documentid=@documentid
AND SignedDocumentVersionId IS NULL

BEGIN TRAN
UPDATE DocumentSignatures
SET RecordDeleted='Y',DeletedBy='WBARLOW',DeletedDate=GETDATE()
WHERE SignatureId IN(2626932,2861273)
COMMIT TRAN
rollback tran


select * into #temp1 FROM Documents
where documentid in (2395836,2406535)

select * from DocumentSignatures
where DOCUMENTID IN (2395836,2406535)
AND SignedDocumentVersionId IS NULL
