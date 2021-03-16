--Date: 06/24/2020
--Purpose : Modified the Validation logic as per the requirement of KCMHSAS Improvements #7

DECLARE @DocumentCodeId int
SET @DocumentCodeId =(SELECT DocumentCodeId FROM DocumentCodes where Code='69E559DD-1A4D-46D3-B91C-E89DA48E0038' )


IF EXISTS (SELECT 1 FROM DocumentValidations where  TabName='UNCOPE' and DocumentCodeId=@DocumentCodeId AND ColumnName='BriefCounseling')
BEGIN
UPDATE DocumentValidations SET ValidationLogic =  'FROM #CustomDocumentAssessmentSubstanceUses CS JOIN #CustomDocumentMHAssessments CM   ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE  
CM.AdultOrChild = ''A''    and ((@ClientSex =''M'' and @Age >= 65 and CS.DrinksPerWeek >=7 ) OR     (@ClientSex =''F''  and CS.DrinksPerWeek >=7) OR  
  (@ClientSex =''M'' and @Age between 0 and 64 and CS.DrinksPerWeek >= 14 ) OR     (DATEDIFF(dd, CS.LastTimeDrinkDate, GETDATE()) <= 90) OR   
     (CS.IllegalDrugs =''Y'' )) AND ISNULL(CS.BriefCounseling,''N'') = ''N''    
      AND ISNULL(CS.FeedBackOnAlcoholUse,''N'') = ''N'' AND ISNULL(CS.Harms,''N'') = ''N''  AND ISNULL(CS.DevelopmentOfPlans,''N'') = ''N''    
  AND ISNULL(CS.Refferal,''N'') = ''N''    and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
  where  TabName='UNCOPE' and DocumentCodeId=@DocumentCodeId AND ColumnName='BriefCounseling'
END

IF EXISTS (SELECT * FROM DocumentValidations where  TabName='CRAFFT' and DocumentCodeId=@DocumentCodeId AND ColumnName='BriefCounseling')
BEGIN
UPDATE DocumentValidations SET ValidationLogic =  'FROM #CustomDocumentAssessmentSubstanceUses CS JOIN #CustomDocumentMHAssessments CM  
 ON CS.DocumentVersionId = CM.DocumentVersionId  WHERE  CM.AdultOrChild = ''C''   
  and ((@ClientSex =''M'' and @Age > 65 and CS.DrinksPerWeek >=7 ) OR     (@ClientSex =''F''  and CS.DrinksPerWeek >=7) OR  
    (@ClientSex =''M'' and @Age between 0 and 64 and CS.DrinksPerWeek >= 14 ) OR     (DATEDIFF(dd, CS.LastTimeDrinkDate, GETDATE()) <= 90) OR   
       (CS.IllegalDrugs =''Y'' )) AND ISNULL(CS.BriefCounseling,''N'') = ''N''   
         AND ISNULL(CS.FeedBackOnAlcoholUse,''N'') = ''N'' AND ISNULL(CS.Harms,''N'') = ''N''  AND ISNULL(CS.DevelopmentOfPlans,''N'') = ''N''    
           AND ISNULL(CS.Refferal,''N'') = ''N''    and CS.DocumentVersionId=@DocumentVersionId and ISNULL(CS.RecordDeleted,''N'') = ''N'' '
  where  TabName='CRAFFT' and DocumentCodeId=@DocumentCodeId AND ColumnName='BriefCounseling'
END



IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND ErrorMessage =  'Client experienced or witnessed abuse or neglect - Textbox is required'	)
BEGIN
UPDATE DocumentValidations SET ErrorMessage= 'Client experienced or witnessed abuse or neglect - Textbox is required',
ValidationLogic='FROM CustomDocumentMHAssessments WHERE DocumentVersionId=@DocumentVersionId AND PsClientAbuseIssues = ''Y''  AND ISNULL(PsClientAbuesIssuesComment,'''')='''' '	
WHERE DocumentCodeId = @DocumentCodeId AND ErrorMessage =  'Client experienced or witnessed abuse or neglect - Textbox is required'
END



-- Risk Assessment Tab
IF  EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND ErrorMessage ='Risk Assessment- Advance Directive- Does client desire a advance directive plan is required'		)
BEGIN
UPDATE DocumentValidations SET ValidationLogic='From #CustomDocumentMHAssessments   where isnull(AdvanceDirectiveDesired,'''')='''' and AdultOrChild=''A'' AND AdvanceDirectiveClientHasDirective=''N'' '
		WHERE DocumentCodeId = @DocumentCodeId AND ErrorMessage ='Risk Assessment- Advance Directive- Does client desire a advance directive plan is required'
END


IF  EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND ErrorMessage = 'Risk Assessment- Advance Directive- Would client like more information about advance directive planning is required'		)
BEGIN
UPDATE DocumentValidations SET ValidationLogic='From #CustomDocumentMHAssessments   where isnull(AdvanceDirectiveMoreInfo,'''')='''' and AdultOrChild=''A'' AND AdvanceDirectiveClientHasDirective=''N'' '
		WHERE DocumentCodeId = @DocumentCodeId AND ErrorMessage = 'Risk Assessment- Advance Directive- Would client like more information about advance directive planning is required'
END

IF  EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = @DocumentCodeId
		AND ErrorMessage = 'Risk Assessment- Advance Directive- What information was the client given regarding advance directive is required'		)
BEGIN
UPDATE DocumentValidations SET ValidationLogic='From #CustomDocumentMHAssessments   where isnull(AdvanceDirectiveNarrative,'''')='''' and AdultOrChild=''A'' AND AdvanceDirectiveClientHasDirective=''N'' '
		WHERE DocumentCodeId = @DocumentCodeId AND ErrorMessage = 'Risk Assessment- Advance Directive- What information was the client given regarding advance directive is required'
END

