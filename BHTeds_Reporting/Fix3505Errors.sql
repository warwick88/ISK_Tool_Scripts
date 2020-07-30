declare @ProcessFlag int = 2
/*
  1 - List Records
  2 - Update Records
*/

if @ProcessFlag = 1
begin 
;with cte_BHTEDS_3505 AS (
select *
  from kv_BHTedsEpisodesErrors_ALL
  where errorcode like '___3505'
)

select dd.DocumentVersionId
     , d.DocumentId
	 , bh.ClientId
	 , bh.ErrorCode
	 , dd.NotCollectedService
	 , dd.ModifiedBy
	 , dd.ModifiedDate
  from CustomDocumentBHTEDSDischargeDemographics dd
          join Documents d on dd.DocumentVersionId = d.CurrentDocumentVersionId
		                  AND d.status = 22
                          AND ISNULL(d.recorddeleted, 'N') = 'N'
		  join cte_BHTEDS_3505 bh on d.DocumentId = bh.DocumentId
 WHERE d.documentcodeid = 50002 
   AND d.EffectiveDate > '09-30-2017'
   --AND dd.NotCollectedService IS NOT NULL
   AND ISNULL(dd.recorddeleted, 'N') = 'N'

end

if @ProcessFlag = 2
begin
;with cte_BHTEDS_3505 AS (
select *
  from kv_BHTedsEpisodesErrors_ALL
  where errorcode like '___3505'
)
update dd
   set dd.NotCollectedService = NULL
     , dd.ModifiedBy = '3505ErrorCorrection'
	 , dd.ModifiedDate = getdate()
  from CustomDocumentBHTEDSDischargeDemographics dd
          join Documents d on dd.DocumentVersionId = d.CurrentDocumentVersionId
		                  AND d.status = 22
                          AND ISNULL(d.recorddeleted, 'N') = 'N'
		  join cte_BHTEDS_3505 bh on d.DocumentId = bh.DocumentId
 WHERE d.documentcodeid = 50002 
   AND d.EffectiveDate > '09-30-2017'
   AND dd.NotCollectedService IS NOT NULL
   AND ISNULL(dd.recorddeleted, 'N') = 'N'

 end
