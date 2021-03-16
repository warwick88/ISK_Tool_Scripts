/*
 What: Corrected the Sort Order of the 'Abnormal/Psychotic Thoughts' section form items for the 'Mental Status Exam' DFA form
 Why:  KCMHSAS - Support #1659
*/


DECLARE @FormSectionGroupId INT, @FormSectionId INT 

SELECT TOP 1 @FormSectionGroupId = G.FormSectionGroupId, @FormSectionId = S.FormSectionId  FROM FormSectionGroups G 
INNER JOIN FormSections S ON G.FormSectionId=S.FormSectionId
INNER JOIN Forms F ON S.FormId = F.FormId
WHERE F.FormGUID = '1ACAF7C6-1084-47D5-BC87-D35D45147228' AND F.Active = 'Y'
AND S.SectionLabel = '<b>Abnormal/Psychotic Thoughts</b>' AND S.Active = 'Y' AND S.SortOrder = 8
AND G.SortOrder = 7 AND G.Active= 'Y'
AND ISNULL(F.RecordDeleted,'N')='N' AND  ISNULL(S.RecordDeleted,'N')='N' AND  ISNULL(G.RecordDeleted,'N')='N'


UPDATE FormItems SET SortOrder = 7, ModifiedBy = 'KCMHSAS-Sup1659', ModifiedDate = GETDATE()
	WHERE FormSectionId= @FormSectionId AND FormSectionGroupId= @FormSectionGroupId
	AND ItemLabel = '<span style="padding-right: 30px;">Means to carry out attempt</span>' AND SortOrder=6 AND Active = 'Y'
	AND ISNULL(RecordDeleted,'N')='N' 

UPDATE FormItems SET SortOrder = 8, ModifiedBy = 'KCMHSAS-Sup1659', ModifiedDate = GETDATE()
	WHERE FormSectionId= @FormSectionId AND FormSectionGroupId= @FormSectionGroupId
	AND GlobalCodeCategory='RADIOYN' AND ItemColumnName='PDMeansToCarry' AND SortOrder=7 AND Active = 'Y'
	AND ISNULL(RecordDeleted,'N')='N' 

UPDATE FormItems SET SortOrder = 9, ModifiedBy = 'KCMHSAS-Sup1659', ModifiedDate = GETDATE()
	WHERE FormSectionId= @FormSectionId AND FormSectionGroupId= @FormSectionGroupId
	AND ItemLabel = '<span style="padding-right: 30px;">Current homicidal ideation</span>' AND SortOrder=8 AND Active = 'Y'
	AND ISNULL(RecordDeleted,'N')='N' 

UPDATE FormItems SET SortOrder = 10, ModifiedBy = 'KCMHSAS-Sup1659', ModifiedDate = GETDATE()
	WHERE FormSectionId= @FormSectionId AND FormSectionGroupId= @FormSectionGroupId
	AND GlobalCodeCategory='RADIOYN' AND ItemColumnName='PDCurrentHomicidalIdeation' AND SortOrder=9 AND Active = 'Y'
	AND ISNULL(RecordDeleted,'N')='N' 

UPDATE FormItems SET SortOrder = 11, ModifiedBy = 'KCMHSAS-Sup1659', ModifiedDate = GETDATE()
	WHERE FormSectionId= @FormSectionId AND FormSectionGroupId= @FormSectionGroupId
	AND ItemLabel = '<span style="padding-right: 30px;">Current homicidal plans</span>' AND SortOrder=10 AND Active = 'Y'
	AND ISNULL(RecordDeleted,'N')='N' 

UPDATE FormItems SET SortOrder = 12, ModifiedBy = 'KCMHSAS-Sup1659', ModifiedDate = GETDATE()
	WHERE FormSectionId= @FormSectionId AND FormSectionGroupId= @FormSectionGroupId
	AND GlobalCodeCategory='RADIOYN' AND ItemColumnName='PDCurrentHomicidalPlans' AND SortOrder=11 AND Active = 'Y'
	AND ISNULL(RecordDeleted,'N')='N' 

UPDATE FormItems SET SortOrder = 13, ModifiedBy = 'KCMHSAS-Sup1659', ModifiedDate = GETDATE()
	WHERE FormSectionId= @FormSectionId AND FormSectionGroupId= @FormSectionGroupId
	AND ItemLabel = '<span style="padding-right: 30px;">Current homicidal intent</span>' AND SortOrder=12 AND Active = 'Y'
	AND ISNULL(RecordDeleted,'N')='N' 

UPDATE FormItems SET SortOrder = 14, ModifiedBy = 'KCMHSAS-Sup1659', ModifiedDate = GETDATE()
	WHERE FormSectionId= @FormSectionId AND FormSectionGroupId= @FormSectionGroupId
	AND GlobalCodeCategory='RADIOYN' AND ItemColumnName='PDCurrentHomicidalIntent' AND SortOrder=13 AND Active = 'Y'
	AND ISNULL(RecordDeleted,'N')='N' 

UPDATE FormItems SET SortOrder = 15, ModifiedBy = 'KCMHSAS-Sup1659', ModifiedDate = GETDATE()
	WHERE FormSectionId= @FormSectionId AND FormSectionGroupId= @FormSectionGroupId
	AND ItemLabel = '<span style="padding-right: 30px;">Means to carry out attempt</span>' AND SortOrder=14 AND Active = 'Y'
	AND ISNULL(RecordDeleted,'N')='N' 


