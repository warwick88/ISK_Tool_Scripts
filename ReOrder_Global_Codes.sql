begin transaction

	SELECT 
		 GlobalCodeId
		,ROW_NUMBER() OVER (order by LTRIM(RTRIM(CodeName)) asc) AS 'RowNum'
		,LTRIM(RTRIM(CodeName)) AS 'CodeName'
	INTO #CodeNameOrder
	FROM GlobalCodes
	WHERE Category like '%XFormABDServices'

	UPDATE GlobalCodes
	SET SortOrder = cno.RowNum
	FROM GlobalCodes gc
	INNER JOIN #CodeNameOrder cno
	on gc.GlobalCodeId = cno.GlobalCodeId
	WHERE gc.Category like '%XFormABDServices'

if @@ROWCOUNT = 27
	commit transaction
else
	rollback transaction

select GlobalCodeId, SortOrder, CodeName
from GlobalCodes
where Category like '%XFormABDServices'
order by SortOrder