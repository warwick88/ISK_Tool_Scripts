use ProdSmartCare

insert into GlobalCodes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('Wbarlow',getdate(),'Wbarlow',getdate(),'XFormABDServices','inSHAPE','Y','N',25)

insert into GlobalCodes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('Wbarlow',getdate(),'Wbarlow',getdate(),'XFormABDServices','Nutrition','Y','N',26)

select * from globalcodes
where category like '%XFormABDServices'
order by CodeName asc







begin transaction

	SELECT 
		 GlobalCodeId
		,ROW_NUMBER() OVER (order by LTRIM(RTRIM(CodeName)) asc) AS 'RowNum'
		,LTRIM(RTRIM(CodeName)) AS 'CodeName'
	INTO #CodeNameOrder
	FROM GlobalCodes
	WHERE Category like '%XFormABDServices'

	select * from #CodeNameOrder

begin tran

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