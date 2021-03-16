--Date: 07/22/2020
--Purpose: Update script to add maximumlength to the Column in Pre-plan DFA. KCMHSAS Improvements #7      
DECLARE @Code varchar(100) = '2C489D56-66EF-4C48-939C-501A5449D387'  
DECLARE @FormId int, @FormSectionId int
SET @FormId= (SELECT  FormId FROM Forms where FormGUID =@Code)
SET @FormSectionId = (SELECT  FormSectionId FROM FormSections where FormId= @FormId and SortOrder=1)
IF EXISTS (SELECT 1 FROM FormItems where ItemcolumnName='CaseNumber' and FormSectionId= @FormSectionId)
BEGIN
UPDATE FormItems SET MaximumLength=10 where ItemcolumnName='CaseNumber' and FormSectionId= @FormSectionId
END