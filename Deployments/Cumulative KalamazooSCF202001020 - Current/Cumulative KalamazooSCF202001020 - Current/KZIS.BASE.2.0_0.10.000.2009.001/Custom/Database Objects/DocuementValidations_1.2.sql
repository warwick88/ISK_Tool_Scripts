
/*
Insert script for Assessment - Document - Validation Messgae
Author :Jyothi
Created Date : 28/05/2020
Purpose : What/Why : Substance Abuse Tab validations Task #
*/
-- CustomSUAssessments

 DECLARE @DocumentcodeId VARCHAR(MAX)
 DECLARE @CODE VARCHAR(MAX)
 DECLARE @TableName VARCHAR (MAX)
 DECLARE @Taborder INT 
 DECLARE @TabName  VARCHAR (MAX)


 SET @CODE='69E559DD-1A4D-46D3-B91C-E89DA48E0038'

  SET @TableName='CustomDocumentMHAssessments'
 SET @DocumentcodeId=(Select DocumentCodeId from DocumentCodes 
                      where Code=@CODE And Active='Y' AND
                       ISNULL(Recorddeleted,'N')='N')
SET @Taborder =4
SET @TabName='Substance Abuse'
	
--CustomSubstanceUseAssessments


 --------------------------------  Substance first section -------------------------------------------

-- IF NOT EXISTS (SELECT DocumentCodeId	FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId
--			AND ErrorMessage = 'Substance Use - At least one checkbox selection should be required.')
--BEGIN 
-- INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
-- ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','SubstanceUse'
--		,'FROM #CustomSUAssessments CS inner join CustomDocumentMHAssessments CH ON CS.DocumentVersionId=CH.DocumentVersionId
--			WHERE CS.DocumentVersionId=@DocumentVersionId 
--			 AND  ISNULL(CS.SubstanceAbuseAdmittedOrSuspected,''N'')=''N'' 
--			 AND ISNULL(CS.FamilySAHistory,''N'')=''N'' 
--			 AND ISNULL(CS.ClientSAHistory,''N'')=''N'' 
--			 AND ISNULL(CS.CurrentSubstanceAbuse,''N'')=''N'' 
--			 AND ISNULL(CS.SuspectedSubstanceAbuse,''N'')=''N'' 
--			 AND  isnull(@RunSUAssessmentValidations,''N'')=''Y''
--			 ','',9,N'Substance Use - At least one checkbox selection should be required.',NULL
--		)
--END

IF NOT EXISTS (SELECT DocumentCodeId	FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and columnname='SubstanceAbuseDetail'
			AND TableName = 'CustomSubstanceUseAssessments')
BEGIN 
 INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
 ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','SubstanceAbuseDetail'
		,'FROM #CustomSUAssessments CS inner join CustomDocumentMHAssessments CH ON CS.DocumentVersionId=CH.DocumentVersionId
			WHERE CS.DocumentVersionId=@DocumentVersionId 
			 AND  CS.SubstanceAbuseDetail IS NULL AND ISNULL(@RunSUAssessmentValidations,''N'')=''Y''
 ','Substance Use comment textbox required.',1,N'Substance Use comment textbox required.',NULL
		)
END

 IF NOT EXISTS (SELECT DocumentCodeId	FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId
			AND ErrorMessage = 'Substance Abuse Symptoms/Consequences - At least one checkbox selection should be required.')
BEGIN 
 INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
 ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','SubstanceUse'
		,'FROM #CustomSUAssessments CS inner join CustomDocumentMHAssessments CH ON CS.DocumentVersionId=CH.DocumentVersionId
			WHERE CS.DocumentVersionId=@DocumentVersionId 
			 AND  ISNULL(CS.OdorOfSubstance,''N'')=''N'' 
			 AND ISNULL(CS.SlurredSpeech,''N'')=''N'' 
			 AND ISNULL(CS.WithdrawalSymptoms,''N'')=''N'' 
			 AND ISNULL(CS.IncreasedTolerance,''N'')=''N'' 
			 AND ISNULL(CS.Blackouts,''N'')=''N'' 
			 AND ISNULL(CS.LossOfControl,''N'')=''N'' 
			 AND ISNULL(CS.RelatedArrests,''N'')=''N'' 
			 AND ISNULL(CS.RelatedSocialProblems,''N'')=''N'' 
		     AND ISNULL(CS.FrequentJobSchoolAbsence,''N'')=''N'' 
		    AND ISNULL(CS.NoneSynptomsReportedOrObserved,''N'')=''N'' 
			AND ISNULL(@RunSUAssessmentValidations,''N'')=''Y''
			 ','',2,N'Substance Abuse Symptoms/Consequences - At least one checkbox selection should be required.',NULL
		)
END

IF NOT EXISTS (SELECT DocumentCodeId	FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId
			AND ErrorMessage = 'Substance Abuse Symptoms/Consequences - DUI - How Many Times last 30 days required.')
BEGIN 
 INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
 ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DUI30Days'
		,'FROM #CustomSUAssessments CS inner join CustomDocumentMHAssessments CH ON CS.DocumentVersionId=CH.DocumentVersionId
			WHERE CS.DocumentVersionId=@DocumentVersionId 
			 AND  CS.DUI30Days IS NULL AND ISNULL(@RunSUAssessmentValidations,''N'')=''Y''
 ','',3,N'Substance Abuse Symptoms/Consequences - DUI - How Many Times last 30 days required.',NULL
		)
END

IF NOT EXISTS (SELECT DocumentCodeId	FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId
			AND ErrorMessage = 'Substance Abuse Symptoms/Consequences - DUI - How Many Times last 5 days required.')
BEGIN 
 INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
 ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DUI5Years'
		,'FROM #CustomSUAssessments CS inner join CustomDocumentMHAssessments CH ON CS.DocumentVersionId=CH.DocumentVersionId
			WHERE CS.DocumentVersionId=@DocumentVersionId 
			 AND  DUI5Years IS NULL AND ISNULL(@RunSUAssessmentValidations,''N'')=''Y''
 ','',@Taborder,N'Substance Abuse Symptoms/Consequences - DUI - How Many Times last 5 days required.',NULL
		)
END

IF NOT EXISTS (SELECT DocumentCodeId	FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId
			AND ErrorMessage = 'Substance Abuse Symptoms/Consequences - DWI - How Many Times last 30 days required.')
BEGIN 
 INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
 ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DWI30Days'
		,'FROM #CustomSUAssessments CS inner join CustomDocumentMHAssessments CH ON CS.DocumentVersionId=CH.DocumentVersionId
			WHERE CS.DocumentVersionId=@DocumentVersionId 
			 AND  DWI30Days IS NULL AND ISNULL(@RunSUAssessmentValidations,''N'')=''Y''
 ','',5,N'Substance Abuse Symptoms/Consequences - DWI - How Many Times last 30 days required.',NULL
		)
END

IF NOT EXISTS (SELECT DocumentCodeId	FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId
			AND ErrorMessage = 'Substance Abuse Symptoms/Consequences - DWI - How Many Times last 5 days required.')
BEGIN 
 INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
 ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DWI5Years'
		,'FROM #CustomSUAssessments CS inner join CustomDocumentMHAssessments CH ON CS.DocumentVersionId=CH.DocumentVersionId
			WHERE CS.DocumentVersionId=@DocumentVersionId 
			 AND  DWI5Years IS NULL AND ISNULL(@RunSUAssessmentValidations,''N'')=''Y''
 ','',6,N'Substance Abuse Symptoms/Consequences - DWI - How Many Times last 5 days required.',NULL
		)
END



IF NOT EXISTS (SELECT DocumentCodeId	FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId
			AND ErrorMessage = 'Substance Abuse Symptoms/Consequences - Possession - How Many Times last 30 days required.')
BEGIN 
 INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
 ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','Possession30Days'
		,'FROM #CustomSUAssessments CS inner join CustomDocumentMHAssessments CH ON CS.DocumentVersionId=CH.DocumentVersionId
			WHERE CS.DocumentVersionId=@DocumentVersionId 
			 AND  Possession30Days IS NULL AND ISNULL(@RunSUAssessmentValidations,''N'')=''Y''
 ','',7,N'Substance Abuse Symptoms/Consequences - Possession - How Many Times last 30 days required.',NULL
		)
END

IF NOT EXISTS (SELECT DocumentCodeId	FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId
			AND ErrorMessage = 'Substance Abuse Symptoms/Consequences - Possession - How Many Times last 5 days required.')
BEGIN 
 INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
 ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','Possession5Years'
		,'FROM #CustomSUAssessments CS inner join CustomDocumentMHAssessments CH ON CS.DocumentVersionId=CH.DocumentVersionId
			WHERE CS.DocumentVersionId=@DocumentVersionId 
			 AND  Possession5Years IS NULL  AND ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' 
 ','',8,N'Substance Abuse Symptoms/Consequences - Possession - How Many Times last 5 days required.',NULL
		)
END
---------------- SU DRUGS Atleast one checkbox is required-----------
IF NOT EXISTS (SELECT DocumentCodeId	FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId
			AND ErrorMessage = 'History and Current Use of Substances - At least one checkbox selection should be required.')
BEGIN 
 INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
 ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','ModifiedBy'
		,'from #CustomSUAssessments ca  where (
             NOt exists (Select * From CustomSubstanceUseHistory2 suh 
           Where suh.DocumentVersionId = @DocumentVersionId     
            and isnull(suh.recorddeleted, ''N'')=''N'' ))
   AND ca.DocumentVersionId = @DocumentVersionId AND ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' ' 
 ,'',9,N'History and Current Use of Substances - At least one checkbox selection should be required.',NULL
		)
END

--------------------------------  SU DRUGS Section Validations ----------------------------------
--DELETE FROM  DocumentValidations WHERE DocumentCodeId=10018 AND taborder=4 and Tablename='CustomSubstanceUseAssessments'
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Alcohol: Age Of First Use is required') 
BEGIN 
 INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 1     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',104,'Hx and Current Use of Substances –  Alcohol: Age Of First Use is required',NULL)  
END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Alcohol: Frequency is required') 
BEGIN 
 INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 1     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',105,'Hx and Current Use of Substances –  Alcohol: Frequency is required',NULL)  
END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Alcohol: Route is required') 
BEGIN 
 INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 1     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',106,'Hx and Current Use of Substances –  Alcohol: Route is required',NULL)  
END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Alcohol: Last Used is required') 
BEGIN 
 INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 1     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',107,'Hx and Current Use of Substances –  Alcohol: Last Used is required',NULL)  
END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Alcohol: Preference is required') 
BEGIN 
 INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 1     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',109,'Hx and Current Use of Substances –  Alcohol: Preference is required',NULL) 
 END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Heroin: Age Of First Use is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
     ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 2     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',114,'Hx and Current Use of Substances –  Heroin: Age Of First Use is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Heroin: Frequency is required') 

BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
     ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 2     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',115,'Hx and Current Use of Substances –  Heroin: Frequency is required',NULL)  END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Heroin: Route is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
     ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 2     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',116,'Hx and Current Use of Substances –  Heroin: Route is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Heroin: Last Used is required') 
BEGIN
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
     ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 2     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',117,'Hx and Current Use of Substances –  Heroin: Last Used is required',NULL)  END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Heroin: Preference is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 2     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',119,'Hx and Current Use of Substances –  Heroin: Preference is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Methadone (illicit): Age Of First Use is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 3     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',124,'Hx and Current Use of Substances –  Methadone (illicit): Age Of First Use is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Methadone (illicit): Frequency is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 3     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',125,'Hx and Current Use of Substances –  Methadone (illicit): Frequency is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Methadone (illicit): Route is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 3     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',126,'Hx and Current Use of Substances –  Methadone (illicit): Route is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Methadone (illicit): Last Used is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 3     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',127,'Hx and Current Use of Substances –  Methadone (illicit): Last Used is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Methadone (illicit): Preference is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 3     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',129,'Hx and Current Use of Substances –  Methadone (illicit): Preference is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Other Opiates or synthetics: Age Of First Use is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 4     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',134,'Hx and Current Use of Substances –  Other Opiates or synthetics: Age Of First Use is required',NULL)  
END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Other Opiates or synthetics: Frequency is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 4     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',135,'Hx and Current Use of Substances –  Other Opiates or synthetics: Frequency is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Other Opiates or synthetics: Route is required') 
BEGIN 
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 4     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',136,'Hx and Current Use of Substances –  Other Opiates or synthetics: Route is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Other Opiates or synthetics: Last Used is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 4     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',137,'Hx and Current Use of Substances –  Other Opiates or synthetics: Last Used is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Other Opiates or synthetics: Preference is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 4     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',139,'Hx and Current Use of Substances –  Other Opiates or synthetics: Preference is required',NULL)  END
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Other tranquilizers: Age Of First Use is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 7     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',164,'Hx and Current Use of Substances –  Other tranquilizers: Age Of First Use is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Other tranquilizers: Frequency is required')
 BEGIN 
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
     ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 7     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',165,'Hx and Current Use of Substances –  Other tranquilizers: Frequency is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Other tranquilizers: Route is required')
 BEGIN insert into DocumentValidations (                          Active,                          DocumentCodeId,                          DocumentType,                          TabName,                          TabOrder,                          TableName,                          ColumnName,                          ValidationLogic,                          ValidationDescription,                          ValidationOrder,                          ErrorMessage,                          RecordDeleted                                                  ) values
 ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 7     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',166,'Hx and Current Use of Substances –  Other tranquilizers: Route is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Other tranquilizers: Last Used is required')
 BEGIN 
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
     ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 7     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',167,'Hx and Current Use of Substances –  Other tranquilizers: Last Used is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Other tranquilizers: Preference is required')
 BEGIN 
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
     ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 7     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',169,'Hx and Current Use of Substances –  Other tranquilizers: Preference is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Benzodiazepines: Age Of First Use is required')
 BEGIN 
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
      ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 8     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',174,'Hx and Current Use of Substances –  Benzodiazepines: Age Of First Use is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Benzodiazepines: Frequency is required')
 BEGIN 
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
      ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 8     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',175,'Hx and Current Use of Substances –  Benzodiazepines: Frequency is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Benzodiazepines: Route is required')
 BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 8     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',176,'Hx and Current Use of Substances –  Benzodiazepines: Route is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Benzodiazepines: Last Used is required') 
BEGIN insert into DocumentValidations (  Active,  DocumentCodeId, DocumentType,  TabName, TabOrder,  TableName,  ColumnName,  ValidationLogic, ValidationDescription, ValidationOrder,  ErrorMessage, RecordDeleted  ) values
('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 8     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',177,'Hx and Current Use of Substances –  Benzodiazepines: Last Used is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Benzodiazepines: Preference is required')
 BEGIN 
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
       ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 8     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',179,'Hx and Current Use of Substances –  Benzodiazepines: Preference is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  GHB,GBL: Age Of First Use is required')
 BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 9     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',184,'Hx and Current Use of Substances –  GHB,GBL: Age Of First Use is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  GHB,GBL: Frequency is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 9     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',185,'Hx and Current Use of Substances –  GHB,GBL: Frequency is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  GHB,GBL: Route is required')
 BEGIN
       INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
       ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 9     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',186,'Hx and Current Use of Substances –  GHB,GBL: Route is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  GHB,GBL: Last Used is required')
 BEGIN 
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
      ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 9     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',187,'Hx and Current Use of Substances –  GHB,GBL: Last Used is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  GHB,GBL: Preference is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
     ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 9     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',189,'Hx and Current Use of Substances –  GHB,GBL: Preference is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Cocaine: Age Of First Use is required')
 BEGIN 
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
       ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 10     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',194,'Hx and Current Use of Substances –  Cocaine: Age Of First Use is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Cocaine: Frequency is required') 
BEGIN 
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
      ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 10     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',195,'Hx and Current Use of Substances –  Cocaine: Frequency is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Cocaine: Route is required')
 BEGIN 
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 10     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',196,'Hx and Current Use of Substances –  Cocaine: Route is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Cocaine: Last Used is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 10     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',197,'Hx and Current Use of Substances –  Cocaine: Last Used is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Cocaine: Preference is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
     ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 10     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',199,'Hx and Current Use of Substances –  Cocaine: Preference is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Crack Cocaine: Age Of First Use is required')
 BEGIN 
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
      ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 11     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',204,'Hx and Current Use of Substances –  Crack Cocaine: Age Of First Use is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Crack Cocaine: Frequency is required')
 BEGIN 
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
      ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 11     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',205,'Hx and Current Use of Substances –  Crack Cocaine: Frequency is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Crack Cocaine: Route is required') 
BEGIN
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
      ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 11     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',206,'Hx and Current Use of Substances –  Crack Cocaine: Route is required',NULL)  END


IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Crack Cocaine: Last Used is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 11     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',207,'Hx and Current Use of Substances –  Crack Cocaine: Last Used is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Crack Cocaine: Preference is required')
 BEGIN 
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
      ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 11     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',209,'Hx and Current Use of Substances –  Crack Cocaine: Preference is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Methamphetamines: Age Of First Use is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
      ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 12     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',214,'Hx and Current Use of Substances –  Methamphetamines: Age Of First Use is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Methamphetamines: Frequency is required')
 BEGIN 
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
      ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 12     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',215,'Hx and Current Use of Substances –  Methamphetamines: Frequency is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Methamphetamines: Route is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
     ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 12     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',216,'Hx and Current Use of Substances –  Methamphetamines: Route is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Methamphetamines: Last Used is required')
 BEGIN 
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
     ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 12     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',217,'Hx and Current Use of Substances –  Methamphetamines: Last Used is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Methamphetamines: Preference is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
     ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 12     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',219,'Hx and Current Use of Substances –  Methamphetamines: Preference is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Other Amphetamines: Age Of First Use is required')
 BEGIN 
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
      ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 13     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',224,'Hx and Current Use of Substances –  Other Amphetamines: Age Of First Use is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Other Amphetamines: Frequency is required')
 BEGIN 
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 13     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',225,'Hx and Current Use of Substances –  Other Amphetamines: Frequency is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Other Amphetamines: Route is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 13     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',226,'Hx and Current Use of Substances –  Other Amphetamines: Route is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Other Amphetamines: Last Used is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 13     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',227,'Hx and Current Use of Substances –  Other Amphetamines: Last Used is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Other Amphetamines: Preference is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 13     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) )','',229,'Hx and Current Use of Substances –  Other Amphetamines: Preference is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Methcathinone: Age Of First Use is required')
 BEGIN 
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 14     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',234,'Hx and Current Use of Substances –  Methcathinone: Age Of First Use is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Methcathinone: Frequency is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 14     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',235,'Hx and Current Use of Substances –  Methcathinone: Frequency is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Methcathinone: Route is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 14     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) )','',236,'Hx and Current Use of Substances –  Methcathinone: Route is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Methcathinone: Last Used is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 14     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',237,'Hx and Current Use of Substances –  Methcathinone: Last Used is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Methcathinone: Preference is required')
 BEGIN 
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 14     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) )','',239,'Hx and Current Use of Substances –  Methcathinone: Preference is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Hallucinogens: Age Of First Use is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 15     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',244,'Hx and Current Use of Substances –  Hallucinogens: Age Of First Use is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Hallucinogens: Frequency is required')
 BEGIN 
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
     ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 15     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',245,'Hx and Current Use of Substances –  Hallucinogens: Frequency is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Hallucinogens: Route is required')
 BEGIN 
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
     ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 15     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',246,'Hx and Current Use of Substances –  Hallucinogens: Route is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Hallucinogens: Last Used is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 15     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',247,'Hx and Current Use of Substances –  Hallucinogens: Last Used is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Hallucinogens: Preference is required')
 BEGIN 
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
     ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 15     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',249,'Hx and Current Use of Substances –  Hallucinogens: Preference is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  PCP: Age Of First Use is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 16     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',254,'Hx and Current Use of Substances –  PCP: Age Of First Use is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  PCP: Frequency is required')
 BEGIN 
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
     ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 16     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',255,'Hx and Current Use of Substances –  PCP: Frequency is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  PCP: Route is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 16     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',256,'Hx and Current Use of Substances –  PCP: Route is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  PCP: Last Used is required')
 BEGIN 
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 16     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',257,'Hx and Current Use of Substances –  PCP: Last Used is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  PCP: Preference is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 16     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) )','',259,'Hx and Current Use of Substances –  PCP: Preference is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Marijuana/hashish: Age Of First Use is required')
 BEGIN 
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 17     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',264,'Hx and Current Use of Substances –  Marijuana/hashish: Age Of First Use is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Marijuana/hashish: Frequency is required')
 BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
     ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 17     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',265,'Hx and Current Use of Substances –  Marijuana/hashish: Frequency is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Marijuana/hashish: Route is required')
 BEGIN 
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 17     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',266,'Hx and Current Use of Substances –  Marijuana/hashish: Route is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Marijuana/hashish: Last Used is required')
 BEGIN 
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 17     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',267,'Hx and Current Use of Substances –  Marijuana/hashish: Last Used is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Marijuana/hashish: Preference is required')
 BEGIN
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 17     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) )','',269,'Hx and Current Use of Substances –  Marijuana/hashish: Preference is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Ecstasy (MDMA,MDA): Age Of First Use is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 18     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',274,'Hx and Current Use of Substances –  Ecstasy (MDMA,MDA): Age Of First Use is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Ecstasy (MDMA,MDA): Frequency is required')
 BEGIN 
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 18     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',275,'Hx and Current Use of Substances –  Ecstasy (MDMA,MDA): Frequency is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Ecstasy (MDMA,MDA): Route is required')
 BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
     ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 18     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',276,'Hx and Current Use of Substances –  Ecstasy (MDMA,MDA): Route is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Ecstasy (MDMA,MDA): Last Used is required')
 BEGIN 
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 18     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',277,'Hx and Current Use of Substances –  Ecstasy (MDMA,MDA): Last Used is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Ecstasy (MDMA,MDA): Preference is required')
 BEGIN 
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
     ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 18     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',279,'Hx and Current Use of Substances –  Ecstasy (MDMA,MDA): Preference is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Ketamine: Age Of First Use is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 19     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',284,'Hx and Current Use of Substances –  Ketamine: Age Of First Use is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Ketamine: Frequency is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 19     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',285,'Hx and Current Use of Substances –  Ketamine: Frequency is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Ketamine: Route is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 19     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',286,'Hx and Current Use of Substances –  Ketamine: Route is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Ketamine: Last Used is required') 
BEGIN 
 INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
   ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 19     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',287,'Hx and Current Use of Substances –  Ketamine: Last Used is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Ketamine: Preference is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 19     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',289,'Hx and Current Use of Substances –  Ketamine: Preference is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Inhalants: Age Of First Use is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 20     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',294,'Hx and Current Use of Substances –  Inhalants: Age Of First Use is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Inhalants: Frequency is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 20     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',295,'Hx and Current Use of Substances –  Inhalants: Frequency is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Inhalants: Route is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 20     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',296,'Hx and Current Use of Substances –  Inhalants: Route is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Inhalants: Last Used is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 20     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',297,'Hx and Current Use of Substances –  Inhalants: Last Used is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Inhalants: Preference is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 20     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) )','',299,'Hx and Current Use of Substances –  Inhalants: Preference is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Antidepressants: Age Of First Use is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 21     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'') ) ','',304,'Hx and Current Use of Substances –  Antidepressants: Age Of First Use is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Antidepressants: Frequency is required')
 BEGIN 
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 21     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',305,'Hx and Current Use of Substances –  Antidepressants: Frequency is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Antidepressants: Route is required')
 BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
     ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 21     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',306,'Hx and Current Use of Substances –  Antidepressants: Route is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Antidepressants: Last Used is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 21     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' ) )','',307,'Hx and Current Use of Substances –  Antidepressants: Last Used is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Antidepressants: Preference is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 21     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',309,'Hx and Current Use of Substances –  Antidepressants: Preference is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Over-the-counter: Age Of First Use is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 22     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',314,'Hx and Current Use of Substances –  Over-the-counter: Age Of First Use is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Over-the-counter: Frequency is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 22     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',315,'Hx and Current Use of Substances –  Over-the-counter: Frequency is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Over-the-counter: Route is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 22     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',316,'Hx and Current Use of Substances –  Over-the-counter: Route is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Over-the-counter: Last Used is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 22     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',317,'Hx and Current Use of Substances –  Over-the-counter: Last Used is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Over-the-counter: Preference is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 22     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',319,'Hx and Current Use of Substances –  Over-the-counter: Preference is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Steroids: Age Of First Use is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 23     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',324,'Hx and Current Use of Substances –  Steroids: Age Of First Use is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Steroids: Frequency is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 23     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',325,'Hx and Current Use of Substances –  Steroids: Frequency is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Steroids: Route is required')
 BEGIN
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 23     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) )','',326,'Hx and Current Use of Substances –  Steroids: Route is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Steroids: Last Used is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 23     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',327,'Hx and Current Use of Substances –  Steroids: Last Used is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Steroids: Preference is required') 
BEGIN
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 23     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',329,'Hx and Current Use of Substances –  Steroids: Preference is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Talwin and PBZ: Age Of First Use is required') 
BEGIN 
insert into DocumentValidations (                          Active,                          DocumentCodeId,                          DocumentType,                          TabName,                          TabOrder,                          TableName,                          ColumnName,                          ValidationLogic,                          ValidationDescription,                          ValidationOrder,                          ErrorMessage,                          RecordDeleted                                                  ) values
('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 24     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',334,'Hx and Current Use of Substances –  Talwin and PBZ: Age Of First Use is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Talwin and PBZ: Frequency is required') 
BEGIN
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 24     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',335,'Hx and Current Use of Substances –  Talwin and PBZ: Frequency is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Talwin and PBZ: Route is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 24     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',336,'Hx and Current Use of Substances –  Talwin and PBZ: Route is required',NULL)  END
	---------------------------------------------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Talwin and PBZ: Last Used is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 24     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' ) )','',337,'Hx and Current Use of Substances –  Talwin and PBZ: Last Used is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Talwin and PBZ: Preference is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 24     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',339,'Hx and Current Use of Substances –  Talwin and PBZ: Preference is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Bath Salts: Age Of First Use is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 25     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',344,'Hx and Current Use of Substances –  Bath Salts: Age Of First Use is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Bath Salts: Frequency is required') 
BEGIN
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 25     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',345,'Hx and Current Use of Substances –  Bath Salts: Frequency is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Bath Salts: Route is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 25     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',346,'Hx and Current Use of Substances –  Bath Salts: Route is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Bath Salts: Last Used is required') 
BEGIN
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 25     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' ) )','',347,'Hx and Current Use of Substances –  Bath Salts: Last Used is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Bath Salts: Preference is required') 
BEGIN
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 25     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',349,'Hx and Current Use of Substances –  Bath Salts: Preference is required',NULL)  END
/* *****************************************************************************************************************************************8 */
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Spice: Age Of First Use is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 26     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',344,'Hx and Current Use of Substances –  Spice: Age Of First Use is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Spice: Frequency is required')
 BEGIN 
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
     ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 26     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',345,'Hx and Current Use of Substances –  Spice: Frequency is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Spice: Route is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 26     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',346,'Hx and Current Use of Substances –  Spice: Route is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Spice: Last Used is required') 
BEGIN
      INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 26     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',347,'Hx and Current Use of Substances –  Spice: Last Used is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Spice: Preference is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 26     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',349,'Hx and Current Use of Substances –  Spice: Preference is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Other: Age Of First Use is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 27     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) )','',344,'Hx and Current Use of Substances –  Other: Age Of First Use is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Other: Frequency is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 27     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',345,'Hx and Current Use of Substances –  Other: Frequency is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Other: Route is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 27     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) )','',346,'Hx and Current Use of Substances –  Other: Route is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Other: Last Used is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 27     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',347,'Hx and Current Use of Substances –  Other: Last Used is required',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= 'Hx and Current Use of Substances –  Other: Preference is required') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments ca    where (ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' AND  exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 27     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' )) ','',349,'Hx and Current Use of Substances –  Other: Preference is required',NULL)  END

---- Su drugs end 

----------------Periods of Abstinence  Section -----------------------

IF NOT EXISTS (SELECT DocumentCodeId	FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId
			AND ErrorMessage = 'Periods of Abstinence - How long did the abstinence last? Was the abstinence voluntary or involuntary? When was the last period of abstinence required.')
BEGIN 
 INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
 ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','VoluntaryAbstinenceTrial'
		,'FROM #CustomSUAssessments CS inner join CustomDocumentMHAssessments CH ON CS.DocumentVersionId=CH.DocumentVersionId
			WHERE CS.DocumentVersionId=@DocumentVersionId 
			 AND  CS.VoluntaryAbstinenceTrial IS NULL AND ISNULL(@RunSUAssessmentValidations,''N'')=''Y''
 ','',350,N'Periods of Abstinence - How long did the abstinence last? Was the abstinence voluntary or involuntary? When was the last period of abstinence required.',NULL
		)
END
------------  Previous/Current Treatment
IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= ' Previous/Current Treatment- Previous substance use treatment is required.') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments   where isnull(PreviousTreatment,'''')='''' and ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' ','',351,' Previous/Current Treatment- Previous substance use treatment is required.',NULL)  END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= ' Previous/Current Treatment- Current substance use treatment is required.') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments   where isnull(CurrentSubstanceAbuseTreatment,'''') ='''' and ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' ','',352,' Previous/Current Treatment- Current substance use treatment is required.',NULL) 
 END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= ' Previous/Current Treatment- Previous medication assisted treatment is required.') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments   where isnull(PreviousMedication,'''') not in (''N'',''Y'')  and ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' ','',353,' Previous/Current Treatment- Previous medication assisted treatment is required.',NULL) 
 END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= ' Previous/Current Treatment- Current medication assisted treatment is required.') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments   where isnull(CurrentSubstanceAbuseMedication,'''') not in (''N'',''Y'') and ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' ','',354,' Previous/Current Treatment- Current medication assisted treatment is required.',NULL)  
END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= ' Previous/Current Treatment- If current substance use symptoms, referral to SU or co-occurring Tx is required.') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments   where isnull(CurrentSubstanceAbuseReferralToSAorTX,'''') not in (''N'',''Y'') and ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' ','',355,' Previous/Current Treatment- If current substance use symptoms, referral to SU or co-occurring Tx is required.',NULL)  
END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= ' Previous/Current Treatment- If yes, where referred. If no, provide reasons.') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments    where isnull(Convert(varchar(max), CurrentSubstanceAbuseRefferedReason),'''')='''' and ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' ','',356,' Previous/Current Treatment- If yes, where referred. If no, provide reasons.',NULL)  
END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= ' Previous/Current Treatment- Is the client interested in medication assisted treatment? Is required.') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','DeletedBy','from #CustomSUAssessments where isnull(MedicationAssistedTreatment,'''')=''''  and ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' ','',357,' Previous/Current Treatment- Is the client interested in medication assisted treatment? Is required.',NULL)  
END

IF NOT EXISTS (SELECT * FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId and ErrorMessage= ' Previous/Current Treatment- If yes, where referred. If no, provide reasons.' and ColumnName = 'MedicationAssistedTreatmentRefferedReason') 
BEGIN 
     INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
    ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','MedicationAssistedTreatmentRefferedReason','from #CustomSUAssessments where isnull(MedicationAssistedTreatmentRefferedReason,'''') = '''' and ISNULL(@RunSUAssessmentValidations,''N'')=''Y'' ','',358,' Previous/Current Treatment- If yes, where referred. If no, provide reasons.',NULL)  
END




----------------Risk of Relapse  Section -----------------------

IF NOT EXISTS (SELECT DocumentCodeId	FROM DocumentValidations WHERE DocumentCodeId = @DocumentcodeId
			AND ErrorMessage = 'Risk of Relapse - Indicate factors which would contribute to relapse required.')
BEGIN 
 INSERT INTO DocumentValidations ( Active,  DocumentCodeId,  DocumentType, TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder, ErrorMessage, RecordDeleted) values
 ('Y',@DocumentcodeId,NULL,@TabName,@Taborder,'CustomSubstanceUseAssessments','VoluntaryAbstinenceTrial'
		,'FROM #CustomSUAssessments CS inner join CustomDocumentMHAssessments CH ON CS.DocumentVersionId=CH.DocumentVersionId
			WHERE CS.DocumentVersionId=@DocumentVersionId 
			 AND  CS.RiskOfRelapse IS NULL AND ISNULL(@RunSUAssessmentValidations,''N'')=''Y''
 ','',359,N'Risk of Relapse - Indicate factors which would contribute to relapse required.',NULL
		)
END