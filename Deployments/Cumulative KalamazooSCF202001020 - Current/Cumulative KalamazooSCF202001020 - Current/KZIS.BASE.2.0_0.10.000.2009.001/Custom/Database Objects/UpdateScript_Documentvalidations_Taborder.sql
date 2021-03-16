
 DECLARE @DocumentcodeId VARCHAR(MAX)
 DECLARE @CODE VARCHAR(MAX)
 DECLARE @TableName VARCHAR (MAX) 
 DECLARE @Taborder INT
 SET @CODE='69E559DD-1A4D-46D3-B91C-E89DA48E0038'

 SET @DocumentcodeId=(Select DocumentCodeId from DocumentCodes 
                      where Code=@CODE And Active='Y' AND
                       ISNULL(Recorddeleted,'N')='N')

IF EXISTS (SELECT  top 1 * FROM DocumentValidations WHERE @DocumentcodeId=DocumentcodeId AND 
          TableName='CustomDocumentMHAssessments' AND ErrorMessage like 'Summary/LOC%')
BEGIN
 UPDATE Documentvalidations set Taborder=18 where  @DocumentcodeId=DocumentcodeId AND 
          TableName='CustomDocumentMHAssessments' AND ErrorMessage like 'Summary/LOC%'
END

IF EXISTS (SELECT top 1 * FROM  DocumentValidations WHERE @DocumentcodeId=DocumentcodeId AND Tablename='customdispositions')
BEGIN
UPDATE Documentvalidations set Taborder=20  WHERE @DocumentcodeId=DocumentcodeId AND Tablename='customdispositions'
END