

/*Created by : Jyothi
Created Date : 15/06/2020
Purpose : Updating the Tab order for Risk assessment Tab validations*/

  DECLARE @DocumentcodeId VARCHAR(MAX)
  DECLARE @CODE VARCHAR(MAX)
  DECLARE @TableName VARCHAR (MAX) 
  SET @CODE='69E559DD-1A4D-46D3-B91C-E89DA48E0038'
  SET @DocumentcodeId=(Select DocumentCodeId from DocumentCodes where Code=@CODE)
  SET @TableName='CustomDocumentMHAssessments'

 IF  EXISTS  ( SELECT *  FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId  and ErrorMessage = 'Risk Assessment- Advance Directive- Does client have a advance directive is required'   )
 BEGIN
   UPDATE DocumentValidations SET Taborder=12 WHERE DocumentCodeId = @DocumentcodeId  and ErrorMessage = 'Risk Assessment- Advance Directive- Does client have a advance directive is required' 
 END

 IF  EXISTS  ( SELECT *  FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId  and ErrorMessage = 'Risk Assessment- Advance Directive- Does client desire a advance directive plan is required')
 BEGIN
   UPDATE DocumentValidations SET Taborder=12 WHERE DocumentCodeId = @DocumentcodeId  and ErrorMessage ='Risk Assessment- Advance Directive- Does client desire a advance directive plan is required'
 END

  IF  EXISTS  ( SELECT *  FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId  and ErrorMessage = 'Risk Assessment- Advance Directive- Would client like more information about advance directive planning is required'  )
 BEGIN
   UPDATE DocumentValidations SET Taborder=12 WHERE DocumentCodeId = @DocumentcodeId  and ErrorMessage ='Risk Assessment- Advance Directive- Would client like more information about advance directive planning is required'
 END

   IF  EXISTS  ( SELECT *  FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId  and ErrorMessage = 'Risk Assessment- Advance Directive- What information was the client given regarding advance directive is required'  )
 BEGIN
   UPDATE DocumentValidations SET Taborder=12 WHERE DocumentCodeId = @DocumentcodeId  and ErrorMessage ='Risk Assessment- Advance Directive- What information was the client given regarding advance directive is required'
 END


 IF  EXISTS (SELECT 1 FROM DocumentValidations WHERE DocumentCodeId = @DocumentCodeId and ErrorMessage= 'At lease 1 Risk Factor Lookup must be selected or No Known Other Risk Factors should be checked') 
BEGIN 
  UPDATE DocumentValidations SET ValidationLogic='From #CustomDocumentMHAssessments  where isnull(RiskOtherFactorsNone,'''')='''' 
  AND ( NOT EXISTS(select 1 from CustomOtherRiskFactors where DocumentVersionId = @DocumentVersionId
  AND ISNULL(RecordDeleted,''N'') = ''N'' ) ) and DocumentVersionId=@DocumentVersionId' 
  WHERE DocumentCodeId = @DocumentCodeId and ErrorMessage= 'At lease 1 Risk Factor Lookup must be selected or No Known Other Risk Factors should be checked'
END

