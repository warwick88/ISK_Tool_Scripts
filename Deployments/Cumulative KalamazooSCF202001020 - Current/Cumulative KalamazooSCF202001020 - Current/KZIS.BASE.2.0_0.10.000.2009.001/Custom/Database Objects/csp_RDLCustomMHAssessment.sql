
/****** Object:  StoredProcedure [dbo].[csp_RDLCustomMHAssessment]    Script Date: 11/27/2013 16:30:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomMHAssessment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomMHAssessment] --1670
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLCustomMHAssessment]    Script Date: 11/27/2013 16:30:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[csp_RDLCustomMHAssessment] 
(                                                                                                                                                                                        
  @DocumentVersionId int                                                                                                                                                        
)                                                     
As                                                                                                                                    
                                                                                                                                  
/*********************************************************************/                                                                                                                                      
/* Stored Procedure: [csp_RDLCustomMHAssessment]   */  
/* Copyright: 2020 Streamline SmartCare            */  
/* Purpose: RDL Main SP for MH Assessment Documents        */  
/* Author : Jyothi Bellapu */                                                                                                        
/*********************************************************************/                                                                                                                                 
                                                                                                                                
                                                                                                   
BEGIN TRY                     
BEGIN                   
  
 DECLARE @CSSRSAdultOrChild VARCHAR(1)
	--,@SuicideCurrent VARCHAR(1)
	,@CSSRSAdultScreeners VARCHAR(1) 
	,@CSSRSChildAdolescentSinceLastVisit VARCHAR(1)
	,@CSSRSAdultsinceLastvisit VARCHAR(1)
	,@CDOB DATETIME

SET @CSSRSAdultOrChild = (
		SELECT AdultOrChild
		FROM CustomDocumentMHAssessments
		WHERE Documentversionid = @DocumentVersionId
		)

declare @DocumentId int  
select @DocumentId = DocumentId from DocumentVersions with (nolock) where 
DocumentVersionId = @DocumentVersionId  
 
 DECLARE @InitialRequestDate DATETIME    
   DECLARE @ClientId INT    
    
  SELECT @ClientId = clientid    
  FROM Documents    
  WHERE Documents.CurrentDocumentVersionId = @DocumentVersionId 
    SET @InitialRequestDate = (    
    SELECT TOP 1 InitialRequestDate    
    FROM ClientEpisodes CP    
    WHERE CP.ClientId = @ClientID    
     AND IsNull(Cp.RecordDeleted, 'N') = 'N'    
     AND IsNull(CP.RecordDeleted, 'N') = 'N'    
    ORDER BY CP.InitialRequestDate DESC    
    )    
    
  DECLARE @DocumentCodeId INT    
    
  SELECT @DocumentCodeId = DocumentCodeId    
  FROM Documents    
  WHERE Documents.CurrentDocumentVersionId = @DocumentVersionId
declare @StatusDate varchar(50)  
select @StatusDate = CONVERT(varchar(12),d.EffectiveDate,101)  
from Documents d with (nolock)   
where d.DocumentId = @DocumentId  
  
Declare @ClientInDDPopulation Char(1), @ClientInMHPopulation Char(1),
 @ClientInSAPopulation Char(1), @AssessmentType char(1), @AdultOrChild char(10)  
          
  
SELECT   
 @ClientInDDPopulation = ClientInDDPopulation  
,@ClientInMHPopulation = ClientInMHPopulation  
,@ClientInSAPopulation = ClientInSAPopulation  
,@AssessmentType = AssessmentType   
,@AdultOrChild = AdultOrChild  
,@CDOB=ClientDOB
from CustomDocumentMHAssessments                        
where DocumentVersionId = @DocumentVersionId  
 
IF (
		@AssessmentType = 'I'
		AND @AdultOrChild = 'A'		
		)
BEGIN
	set @CSSRSAdultScreeners ='Y'
END
ELSE IF (
		(
			@AssessmentType = 'U'
			OR @AssessmentType = 'A'
			)
		AND @AdultOrChild = 'A')
BEGIN
	set @CSSRSAdultsinceLastvisit = 'Y'
END
ELSE IF (
		(
			@AssessmentType ='U'
			OR @AssessmentType = 'A'
			)
		AND @AdultOrChild = 'C')
BEGIN
	set @CSSRSChildAdolescentSinceLastVisit = 'Y'
END

 DECLARE @totalPHQ9 int;    
select     
   @totalPHQ9=CAST( ISNULL(SUBSTRING(dbo.csf_GetGlobalCodeNameById(PleasureInDoingThings),1,1),0) as int)    
     +CAST(  ISNULL(SUBSTRING(dbo.csf_GetGlobalCodeNameById(DepressedHopelessFeeling),1,1),0) as int)    
     +CAST(ISNULL(SUBSTRING(dbo.csf_GetGlobalCodeNameById(AsleepSleepingFalling),1,1),0)as int)    
     +CAST(ISNULL(SUBSTRING(dbo.csf_GetGlobalCodeNameById(TiredFeeling ),1,1),0)as int)    
     +CAST(ISNULL(SUBSTRING(dbo.csf_GetGlobalCodeNameById(OverEating ),1,1),0)as int)    
     +CAST(ISNULL(SUBSTRING(dbo.csf_GetGlobalCodeNameById(BadAboutYourselfFeeling ),1,1),0)as int)    
     +CAST(ISNULL(SUBSTRING(dbo.csf_GetGlobalCodeNameById(TroubleConcentratingOnThings ),1,1),0)as int)    
     +CAST(ISNULL(SUBSTRING(dbo.csf_GetGlobalCodeNameById(SpeakingSlowlyOrOpposite ),1,1),0)as int)    
     +CAST(ISNULL(SUBSTRING(dbo.csf_GetGlobalCodeNameById(BetterOffDeadThought   ),1,1),0)as int)    
  From CustomDocumentMHAssessments    
 Where ISNULL(RecordDeleted,'N')='N'         
 AND DocumentVersionId=@DocumentVersionId   ;   

create table #Verify (  
 DocumentId int  
,PopulationCategory varchar(10)  
,TabName varchar(128)  
,TableName varchar(128)   
,ColumnName varchar(128)  
,GroupName varchar(128)  
,FieldName varchar(128)  
,StatusData varchar(128)  
)  
  
insert into #Verify   
(DocumentId, PopulationCategory, TabName, TableName, ColumnName, GroupName, FieldName)  
   

Select Distinct   
 @DocumentId  
, c.Diagnosis  as PopulationCategory  
, c.TabName  
, c.TableName as TableName  
, c.ColumnName as ColumnName  
, null as GroupName  
, isnull(c.FieldName,'') as FieldName  
From Cstm_Conv_Map_DocumentInitializationLog c with (nolock)   

Where isnull(c.FieldName,'') <> ''  

and c.TableName not in ('CustomDailyLivingActivityScores','CustomDocumentMHAssessmentCAFASs')  
union all  
select distinct   
 @DocumentId  
, c.Diagnosis  as PopulationCategory  
, c.TabName  
, c.TableName as TableName  
, null as ColumnName 
, c.GroupName as GroupName  
, isnull(c.FieldName,'') as FieldName  
From Cstm_Conv_Map_DocumentInitializationLog c with (nolock)   
Where isnull(c.FieldName,'')=''  
and c.TableName not in ('CustomDailyLivingActivityScores','CustomDocumentMHAssessmentCAFASs')  
and c.ColumnName not in ( 'SuicideBehaviorsPastHistory','HomicideBehaviorsPastHistory', 'PsVisualFunctioning')   
union all  
--Risk Fields  
select distinct   
 @DocumentId  
, null  as PopulationCategory  
, 'Risk Assessment' as TabName  
, 'CustomDocumentMHAssessments' as TableName  
, 'SuicideBehaviorsPastHistory' as ColumnName 
, null as GroupName  
, 'SuicideBehaviorsPastHistory' as FieldName  
union all   
select distinct   
 @DocumentId  
, null  as PopulationCategory  
, 'Risk Assessment' as TabName  
, 'CustomDocumentMHAssessments' as TableName  
, 'HomicideBehaviorsPastHistory' as ColumnName  
, null as GroupName  
, 'HomicideBehaviorsPastHistory' as FieldName  
  
--Psychosocial Adult Labels   
union all   
select distinct   
 @DocumentId  
, null  as PopulationCategory  
, 'Psychosocial Adult' as TabName  
, 'CustomDocumentMHAssessments' as TableName  
, 'PsClientAbuseIssues' as ColumnName 
, null as GroupName  
, 'PsClientAbuseIssues' as FieldName  
union all   
select distinct   
 @DocumentId  
, null  as PopulationCategory  
, 'Psychosocial Adult' as TabName  
, 'CustomDocumentMHAssessments' as TableName  
, 'PsEducationComment' as ColumnName   
, null as GroupName  
, 'PsEducationComment' as FieldName  
union all   
select distinct   
 @DocumentId  
, null  as PopulationCategory  
, 'Psychosocial Child' as TabName  
, 'CustomDocumentMHAssessments' as TableName  
, 'PsVisualFunctioning' as ColumnName    
, null as GroupName  
, 'PsVisualFunctioning' as FieldName  
  
  
  
  
-------------------FOR CAFAS  ------------------------------
union all  
select distinct   
 @DocumentId  
,'C'  
,'CAFAS'  
,o.name as TableName  
,c.name as ColumnName  
,Null as GroupName  
,c.name as FieldName  
from SYS.Objects as o  
join SYS.Columns as c on c.Object_Id = o.Object_Id  
where o.Name = 'CustomDocumentMHAssessmentCAFASs'  
and c.Name like '%Comment%'  

  
order by 4, 3, 2, 6, 5  
  
update v  
set ColumnName = c.ColumnName  
from #Verify v  
join Cstm_Conv_Map_DocumentInitializationLog c with (nolock) on c.GroupName=v.GroupName   
Where isnull(c.FieldName,'')=''  
and v.ColumnName is null  
and v.GroupName is not null  
and c.TableName not in ('CustomDailyLivingActivityScores','CustomDocumentMHAssessmentCAFASs')  
  
 
update v  
set StatusData = case di.InitializationStatus   
 when 5871 then 'To Verify' --To Validate  
 when 5872 then 'Reviewed and Verified ' + @StatusDate  
 when 5873 then 'Reviewed and Updated ' + @StatusDate  
 when 5874 then 'Reviewed and Cleared ' + @StatusDate  
 else '*Error '  end  
from #Verify v  
join DocumentInitializationLog di with (nolock) on v.DocumentId = di.DocumentId   
 and di.ColumnName = v.ColumnName  
join GlobalCodes gc with (nolock) on gc.GlobalCodeId = di.InitializationStatus  
where di.DocumentId=v.DocumentId  
and di.TableName = v.TableName  
  
--end verifiy changes logic  
 
  
--CustomDocumentMHAssessments                    
SELECT CHA.DocumentVersionId                    
  ,sc.OrganizationName                        
  ,'Italic' as QuestionFontStyle                        
  ,'500' as QuestionFontWeight           
  
 --CAFAS  
,case when @AssessmentType='A' 
and exists ( select * 
from #Verify v 
where isnull(v.StatusData,'')<>'' and 
v.TableName = 'CustomDocumentMHAssessmentCAFASs' and v.ColumnName = 'BehaviorTowardsOtherComment' )   
then '('+ (select distinct v.StatusData from #Verify v where v.TableName = 'CustomDocumentMHAssessmentCAFASs' 
and v.ColumnName = 'BehaviorTowardsOtherComment' ) + '): '  
 else null end as BehaviorTowardsOtherCommentLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessmentCAFASs' and v.ColumnName = 'CommunityPerformanceComment' )   then '('+ (select distinct v.StatusData from #Verify v where v.TableName = 'CustomDocumentMHAssessmentCAFASs' and v.ColumnName = 'CommunityPerformanceComment' ) + '): '   else null end as CommunityPerformanceCommentLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessmentCAFASs' and v.ColumnName = 'HomePerfomanceComment' )   then '('+ (select distinct v.StatusData from #Verify v where v.TableName 
= 'CustomDocumentMHAssessmentCAFASs' and v.ColumnName = 'HomePerfomanceComment' ) + '): '   else null end as HomePerfomanceCommentLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessmentCAFASs' and v.ColumnName = 'MoodsEmotionComment' )   then '('+ (select distinct v.StatusData from #Verify v where v.TableName = 
'CustomDocumentMHAssessmentCAFASs' and v.ColumnName = 'MoodsEmotionComment' ) + '): '   else null end as MoodsEmotionCommentLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessmentCAFASs' and v.ColumnName = 'NonCustodialMaterialNeedsComment' )   then '('+ (select distinct v.StatusData from #Verify v where 
v.TableName = 'CustomDocumentMHAssessmentCAFASs' and v.ColumnName = 'NonCustodialMaterialNeedsComment' ) + '): '   else null end as NonCustodialMaterialNeedsCommentLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessmentCAFASs' and v.ColumnName = 'NonCustodialSocialSupportComment' )   then '('+ (select distinct v.StatusData from #Verify v where 
v.TableName = 'CustomDocumentMHAssessmentCAFASs' and v.ColumnName = 'NonCustodialSocialSupportComment' ) + '): '   else null end as NonCustodialSocialSupportCommentLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessmentCAFASs' and v.ColumnName = 'PrimaryFamilyMaterialNeedsComment' )   then '('+ (select distinct v.StatusData from #Verify v where 
v.TableName = 'CustomDocumentMHAssessmentCAFASs' and v.ColumnName = 'PrimaryFamilyMaterialNeedsComment' ) + '): '   else null end as PrimaryFamilyMaterialNeedsCommentLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessmentCAFASs' and v.ColumnName = 'PrimaryFamilySocialSupportComment' )   then '('+ (select distinct v.StatusData from #Verify v where 
v.TableName = 'CustomDocumentMHAssessmentCAFASs' and v.ColumnName = 'PrimaryFamilySocialSupportComment' ) + '): '   else null end as PrimaryFamilySocialSupportCommentLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessmentCAFASs' and v.ColumnName = 'SchoolPerformanceComment' )   then '('+ (select distinct v.StatusData from #Verify v where v.TableName = 'CustomDocumentMHAssessmentCAFASs' and v.ColumnName = 'SchoolPerformanceComment' ) + '): '   else null end as SchoolPerformanceCommentLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessmentCAFASs' and v.ColumnName = 'SelfHarmfulBehaviorComment' )   then '('+ (select distinct v.StatusData from #Verify v where 
v.TableName = 'CustomDocumentMHAssessmentCAFASs' and v.ColumnName = 'SelfHarmfulBehaviorComment' ) + '): '   else null end as SelfHarmfulBehaviorCommentLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessmentCAFASs' and v.ColumnName = 'SubstanceUseComment' )   then '('+ (select distinct v.StatusData from #Verify v where v.TableName = 
'CustomDocumentMHAssessmentCAFASs' and v.ColumnName = 'SubstanceUseComment' ) + '): '   else null end as SubstanceUseCommentLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessmentCAFASs' and v.ColumnName = 'SurrogateMaterialNeedsComment' )   then '('+ (select distinct v.StatusData from #Verify v where v.TableName = 'CustomDocumentMHAssessmentCAFASs' and v.ColumnName = 'SurrogateMaterialNeedsComment' ) + '): '   else null end as SurrogateMaterialNeedsCommentLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessmentCAFASs' and v.ColumnName = 'SurrogateSocialSupportComment' )   then '('+ (select distinct v.StatusData from #Verify v where v.TableName = 'CustomDocumentMHAssessmentCAFASs' and v.ColumnName = 'SurrogateSocialSupportComment' ) + '): '   else null end as SurrogateSocialSupportCommentLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessmentCAFASs' and v.ColumnName = 'ThinkngComment' )   then '('+ (select distinct v.StatusData from #Verify v where v.TableName = 'CustomDocumentMHAssessmentCAFASs' and v.ColumnName = 'ThinkngComment' ) + '): '   else null end as ThinkngCommentLabel  
--End CAFAS Labels  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'AdvanceDirectiveClientHasDirective' )   then '('+ (select distinct v.StatusData from #Verify
 v where v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'AdvanceDirectiveClientHasDirective' ) + ') '   else null end as AdvanceDirectiveClientHasDirectiveLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'AssessmentAddtionalInformation' )   then '('+ (select distinct v.StatusData from #Verify v where 
v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'AssessmentAddtionalInformation' ) + ') '   else null end as AssessmentAddtionalInformationLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'ClinicalSummary' )   then 'Clinical Summary ('+ (select distinct v.StatusData from #Verify v where v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'ClinicalSummary' ) + '): '   else 'Clinical Summary: ' end as ClinicalSummaryLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'CrisisPlanningClientHasPlan' )   then '('+ (select distinct v.StatusData from #Verify v where
 v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'CrisisPlanningClientHasPlan' ) + ') '   else null end as CrisisPlanningClientHasPlanLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'CurrentLivingArrangement' )   then 'Current Living Arrangement ('+ (select distinct v.StatusData from #Verify v where v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'CurrentLivingArrangement' ) + '): '   else 'Current Living Arrangement: ' end as CurrentLivingArrangementLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'CurrentPrimaryCarePhysician' )   then 'Current Primary Care Physician ('+ (select distinct v.StatusData from #Verify v where v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'CurrentPrimaryCarePhysician' ) + '): '   else 'Current Primary Care Physician: ' end as CurrentPrimaryCarePhysicianLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'DDAttributableMentalPhysicalLimitation' )   then 'Developmental Disabilities Eligibility Criteria ('+ (select distinct v.StatusData from #Verify v where v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'DDAttributableMentalPhysicalLimitation' ) + ') '   else 'Developmental Disabilities Eligibility Criteria ' end as DDAttributableMentalPhysicalLimitationLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'DesiredOutcomes' )   then 'Desired Outcomes ('+ (select distinct v.StatusData from #Verify v
 where v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'DesiredOutcomes' ) + '): '   else 'Desired Outcomes: ' end as DesiredOutcomesLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'DischargeCriteria' )   then 'Discharge Criteria ('+ (select distinct v.StatusData from #Verify v where v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'DischargeCriteria' ) + '): '   else 'Discharge Criteria: ' end as DischargeCriteriaLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'HistMentalHealthTx' )   then '('+ (select distinct v.StatusData from #Verify v where v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'HistMentalHealthTx' ) + ')'   else null end as HistMentalHealthTxLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'PresentingProblem' )   then 'Presenting Problem ('+ (select distinct v.StatusData from #Verify v where v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'PresentingProblem' ) + '): '   else 'Presenting Problem: ' end as PresentingProblemLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'PsVisualFunctioning' )   then '('+ (select distinct v.StatusData from #Verify v where v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'PsVisualFunctioning' ) + ') '   else null end as PsChildFunctioningSectionLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'PsChildHousingIssues' )   then '('+ (select distinct v.StatusData from #Verify v where v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'PsChildHousingIssues' ) + ') '   else null end as PsChildHousingIssuesLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'PsClientAbuesIssuesComment' )   then ' ('+ (select distinct v.StatusData from #Verify v where v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'PsClientAbuesIssuesComment' ) + ')'   else null end as PsClientAbuesIssuesCommentLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'PsCulturalEthnicIssues' )   then ' ('+ (select distinct v.StatusData from #Verify v where v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'PsCulturalEthnicIssues' ) + ')'   else null end as PsCulturalEthnicIssuesLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'PsCurrentHealthIssues' )   then '('+ (select distinct v.StatusData from #Verify v where v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'PsCurrentHealthIssues' ) + ') '   else null end as PsCurrentHealthIssuesLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'PsCurrentHealthIssuesComment' )   then '('+ (select distinct v.StatusData from #Verify v where v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'PsCurrentHealthIssuesComment' ) + ') '   else null end as PsCurrentHealthIssuesCommentLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'PsEducation' )   then '('+ (select distinct v.StatusData from #Verify v where v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'PsEducation' ) + ') '   else null  end as 'PsEducationLabel'  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'PsClientAbuseIssues' )   then '('+ (select distinct v.StatusData from #Verify v where v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'PsClientAbuseIssues' ) + ') '   else null end as 'PsClientAbuseIssuesLabel'  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'PsEducationComment' )   then '('+ (select distinct v.StatusData from #Verify v where v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'PsEducationComment' ) + ') '   else null end as 'PsEducationCommentLabel'  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'PsFunctioningConcernComment' )   then '('+ (select distinct v.StatusData from #Verify v where v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'PsFunctioningConcernComment' ) + '): '   else null end as PsFunctioningConcernCommentLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'PsRiskCriminalJusticeSystem' )   then '('+ (select distinct v.StatusData from #Verify v where v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'PsRiskCriminalJusticeSystem' ) + ')'   else null end as PsRiskCriminalJusticeSystemLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'PsSpiritualityIssues' )   then '('+ (select distinct v.StatusData from #Verify v where v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'PsSpiritualityIssues' ) + ')'   else null end as PsSpiritualityIssuesLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'RapCaDomainComment' )   then '('+ (select distinct v.StatusData from #Verify v where v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'RapCaDomainComment' ) + ') '   else null end as RapCaDomainCommentLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'RapCbDomainComment' )   then '('+ (select distinct v.StatusData from #Verify v where v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'RapCbDomainComment' ) + ') '   else null end as RapCbDomainCommentLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'RapCiDomainComment' )   then '('+ (select distinct v.StatusData from #Verify v where v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'RapCiDomainComment' ) + ') '   else null end as RapCiDomainCommentLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'ReferralType' )   then 'Referral Type ('+ (select distinct v.StatusData from #Verify v where
 v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'ReferralType' ) + '): '   else 'Referral Type: ' end as ReferralTypeLabel  
  
--Risk Not used  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'HomicideOtherRiskOthersComment' )   then '('+ (select distinct v.StatusData from #Verify v where v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'HomicideOtherRiskOthersComment' ) + ') '   else Null end as HomicideOtherRiskOthersCommentLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'SuicideOtherRiskSelfComment' )   then '('+ (select distinct v.StatusData from #Verify v where v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'SuicideOtherRiskSelfComment' ) + ') '   else null end as SuicideOtherRiskSelfCommentLabel  
  
--Risk Used  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'HomicideBehaviorsPastHistory' )   then '('+ (select distinct v.StatusData from #Verify v where v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'HomicideBehaviorsPastHistory' ) + ') '   else Null end as HomicideBehaviorsPastHistoryLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'SuicideBehaviorsPastHistory' )   then '('+ (select distinct v.StatusData from #Verify v where v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'SuicideBehaviorsPastHistory' ) + ') '   else null end as SuicideBehaviorsPastHistoryLabel  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'RiskOtherFactors' )   then '('+ (select distinct v.StatusData from #Verify v where v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'RiskOtherFactors' ) + ') '   else null end as RiskOtherFactorsLabel  
  
  
,case when @AssessmentType='A' and exists ( select * from #Verify v where isnull(v.StatusData,'')<>'' and v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'TreatmentAccomodation' )   then '('+ (select distinct v.StatusData from #Verify v where v.TableName = 'CustomDocumentMHAssessments' and v.ColumnName = 'TreatmentAccomodation' ) + ') '   else null end as TreatmentAccomodationLabel  
  
  --End Add Lables  
  ,Documents.ClientId                        
  ,Clients.LastName + ', ' + Clients.FirstName as ClientName                        
  ,Staff2.LastName + ', ' + Staff2.FirstName as ClinicianName                        
  ,Documents.EffectiveDate 
  ,CHA.AssessmentType                    
                       
  ,Case CHA.[AdultOrChild]                        
   When 'A' then 'Adult'                        
   When 'C' then 'Child'                        
   Else ''     
   End as AdultOrChild                  
  ,CHA.[ClientDOB]                        
  ,CHA.[ChildHasNoParentalConsent]                        
  ,CHA.[ClientHasGuardian]                        
  ,CHA.[GuardianFirstName]  
  ,CHA.[GuardianLastName]                      
  ,CHA.[GuardianAddress]  
  ,CHA.[GuardianCity]
  ,sta.StateName As GuardianState --CHA.[GuardianState]                      
  ,CHA.[GuardianPhone] 
  ,CHA.[GuardianZipcode] 
  ,dbo.csf_GetGlobalCodeNameById(CHA.RelationWithGuardian)  as RelationWithGuardian                     
  --,dbo.csf_GetGlobalCodeNameById(CHA.GuardianType) as GuardianType                        
  ,CHA.[ClientInDDPopulation]                        
  ,CHA.[ClientInSAPopulation]                        
  ,CHA.[ClientINMHPopulation]                        
  ,CHA.[PreviousDiagnosisText]                        
  ,dbo.csf_GetGlobalCodeNameById(CHA.ReferralType) as ReferralType  
  ,dbo.csf_GetGlobalCodeNameById(CHA.CurrentLivingArrangement) as CurrentLivingArrangement             
  ,dbo.csf_GetGlobalCOdeNameById(cha.EmploymentStatus) as EmploymentStatus    
  ,CHA.CurrentPrimaryCarePhysician as CurrentPrimaryCarePhysician          
  ,CHA.[PresentingProblem] as PresentingProblem                        
  ,CHA.ReasonForUpdate                        
  ,CHA.DesiredOutcomes as DesiredOutcomes   
                          
--------- CAFAS          
,CHA.[CAFASDate] as CustomHRMAssessmentsCAFASDate      --Conflicting columns                     
  ,Staff1.FirstName + ' ' + Staff1.LastName as CustomHRMAssessmentsRaterClinician                        
  ,dbo.csf_GetGlobalCodeNameById(CHA.CAFASInterval) as CustomHRMAssessmentsCAFASInterval                        
  ,CHA.[SchoolPerformance] as CustomHRMAssessmentsSchoolPerformance                     
  ,CHA.[SchoolPerformanceComment]  as CustomHRMAssessmentsSchoolPerformanceComment                      
  ,CHA.[HomePerformance]  as CustomHRMAssessmentsHomePerformance                      
  ,CHA.[HomePerfomanceComment] as CustomHRMAssessmentsHomePerfomanceComment                       
  ,CHA.[CommunityPerformance]  as CustomHRMAssessmentsCommunityPerformance                      
  ,CHA.[CommunityPerformanceComment]  as CustomHRMAssessmentsCommunityPerformanceComment                      
,CHA.[BehaviorTowardsOther]  as CustomHRMAssessmentsBehaviorTowardsOther                      
  ,CHA.[BehaviorTowardsOtherComment]  as CustomHRMAssessmentsBehaviorTowardsOtherComment                      
  ,CHA.[MoodsEmotion]  as CustomHRMAssessmentsMoodsEmotion                      
  ,CHA.[MoodsEmotionComment] as CustomHRMAssessmentsMoodsEmotionComment                       
  ,CHA.[SelfHarmfulBehavior] as CustomHRMAssessmentsSelfHarmfulBehavior                       
  ,CHA.[SelfHarmfulBehaviorComment] as CustomHRMAssessmentsSelfHarmfulBehaviorComment                       
  ,CHA.[SubstanceUse]  as CustomHRMAssessmentsSubstanceUse                      
  ,CHA.[SubstanceUseComment]  as CustomHRMAssessmentsSubstanceUseComment                      
  ,CHA.[Thinkng] as CustomHRMAssessmentsThinkng                       
  ,CHA.[ThinkngComment]  as CustomHRMAssessmentsThinkngComment                      
  --,SubScaleScore1                   
  ,CHA.[PrimaryFamilyMaterialNeeds]   as CustomHRMAssessmentsPrimaryFamilyMaterialNeeds                       
  ,CHA.[PrimaryFamilyMaterialNeedsComment]   as CustomHRMAssessmentsPrimaryFamilyMaterialNeedsComment                       
  ,CHA.[SurrogateMaterialNeeds]   as CustomHRMAssessmentsSurrogateMaterialNeeds                       
  ,CHA.[SurrogateMaterialNeedsComment]   as CustomHRMAssessmentsSurrogateMaterialNeedsComment                       
  ,CHA.[PrimaryFamilySocialSupport]  as CustomHRMAssessmentsPrimaryFamilySocialSupport                      
  ,CHA.[PrimaryFamilySocialSupportComment]  as CustomHRMAssessmentsPrimaryFamilySocialSupportComment                        
  ,CHA.[NonCustodialMaterialNeeds]   as CustomHRMAssessmentsNonCustodialMaterialNeeds                       
  ,CHA.[NonCustodialMaterialNeedsComment]   as CustomHRMAssessmentsNonCustodialMaterialNeedsComment                       
  ,CHA.[SurrogateSocialSupport]   as CustomHRMAssessmentsSurrogateSocialSupport                       
  ,CHA.[SurrogateSocialSupportComment]   as CustomHRMAssessmentsSurrogateSocialSupportComment                       
  ,CHA.[NonCustodialSocialSupport]    as CustomHRMAssessmentsNonCustodialSocialSupport                      
  ,CHA.[NonCustodialSocialSupportComment]   as CustomHRMAssessmentsNonCustodialSocialSupportComment                        
                    
                          
----------- Developmental Disabilities Eligibility Criteria                        
  ,DDEPreviouslyMet                        
  ,DDAttributableMentalPhysicalLimitation                        
  ,DDDxAxisI                        
  ,DDDxAxisII                        
  ,DDDxAxisIII                        
  ,DDDxAxisIV                        
  ,DDDxAxisV                        
  ,DDDxSource                        
  ,DDManifestBeforeAge22                        
  ,DDContinueIndefinitely                        
  ,DDLimitSelfCare                        
  ,DDLimitLanguage                        
  ,DDLimitLearning                        
  ,DDLimitMobility                        
  ,DDLimitSelfDirection                        
  ,DDLimitEconomic                        
  ,DDLimitIndependentLiving                        
  ,DDNeedMulitpleSupports                        
                        
---------------UNCOPE                        
  ,UncopeApplicable                        
  ,UncopeApplicableReason                        
  ,UncopeQuestionU                        
  ,UncopeQuestionN                        
  ,UncopeQuestionC                        
  ,UncopeQuestionO                        
  ,UncopeQuestionP                        
  ,UncopeQuestionE                        
  ,SubstanceUseNeedsList      
  ,UncopeCompleteFullSUAssessment                    
                        
----------- Psychosocial Adult                        
  ,PsCurrentHealthIssues                        
  ,PsCurrentHealthIssuesComment                        
  ,PsCurrentHealthIssuesNeedsList                        
                          
  ,PsClientAbuseIssues                        
  ,PsClientAbuesIssuesComment                        
  ,PsClientAbuseIssuesNeedsList        
  ,PsFamilyConcernsComment        
  ,PsRiskLossOfPlacement        
  ,dbo.csf_GetGlobalCodeNameById(CHA.PsRiskLossOfPlacementDueTo) as PsRiskLossOfPlacementDueTo          
  ,PsRiskSensoryMotorFunction        
  ,dbo.csf_GetGlobalCodeNameById(CHA.PsRiskSensoryMotorFunctionDueTo) as PsRiskSensoryMotorFunctionDueTo          
  ,PsRiskSafety        
  ,dbo.csf_GetGlobalCodeNameById(CHA.PsRiskSafetyDueTo) as PsRiskSafetyDueTo          
  ,PsRiskLossOfSupport        
  ,dbo.csf_GetGlobalCodeNameById(CHA.PsRiskLossOfSupportDueTo) as PsRiskLossOfSupportDueTo           
  ,PsRiskExpulsionFromSchool         
  ,dbo.csf_GetGlobalCodeNameById(CHA.PsRiskExpulsionFromSchoolDueTo) as PsRiskExpulsionFromSchoolDueTo           
  ,PsRiskHospitalization         
  ,dbo.csf_GetGlobalCodeNameById(CHA.PsRiskHospitalizationDueTo) as PsRiskHospitalizationDueTo           
  ,PsRiskCriminalJusticeSystem         
  ,dbo.csf_GetGlobalCodeNameById(CHA.PsRiskCriminalJusticeSystemDueTo) as PsRiskCriminalJusticeSystemDueTo           
  ,PsRiskElopementFromHome         
  ,dbo.csf_GetGlobalCodeNameById(CHA.PsRiskElopementFromHomeDueTo) as PsRiskElopementFromHomeDueTo           
  ,PsRiskLossOfFinancialStatus        
  ,dbo.csf_GetGlobalCodeNameById(CHA.PsRiskLossOfFinancialStatusDueTo) as PsRiskLossOfFinancialStatusDueTo            
  ,RapCiDomainIntensity        
  ,RapCiDomainComment        
  ,RapCiDomainNeedsList        
  ,RapCbDomainIntensity        
  ,RapCbDomainComment        
  ,RapCbDomainNeedsList        
  ,RapCaDomainIntensity        
,RapCaDomainComment        
  ,RapCaDomainNeedsList        
  ,RapHhcDomainIntensity        
                        
  ,PsLegalIssues                        
  ,PsLegalIssuesComment                        
  ,PsLegalIssuesNeedsList                        
                        
  ,PsCulturalEthnicIssues                        
  ,PsCulturalEthnicIssuesComment                        
  ,PsCulturalEthnicIssuesNeedsList                        
                        
  ,PsSpiritualityIssues                        
  ,PsSpiritualityIssuesComment                        
  ,PsSpiritualityIssuesNeedsList                        
                        
  ,HistMentalHealthTx                        
  ,HistMentalHealthTxComment        
  ,HistMentalHealthTxNeedsList                       
                        
  ,HistFamilyMentalHealthTx                        
  ,HistFamilyMentalHealthTxComment        
  ,HistFamilyMentalHealthTxNeedsList                                    
                        
  ,HistPreviousDx                        
  ,HistPreviousDxComment                        
                        
  ,PsTraumaticIncident                        
  ,PsTraumaticIncidentComment                        
  ,PsTraumaticIncidentNeedsList
                          
                        
  ,PsDevelopmentalMilestones                        
  ,PsDevelopmentalMilestonesComment                        
  ,PsDevelopmentalMilestonesNeedsList                        
                        
  ,PsPrenatalExposure                        
  ,PsPrenatalExposureComment                        
  ,PsPrenatalExposureNeedsList                        
                        
  ,PsChildMentalHealthHistory                        
  ,PsChildMentalHealthHistoryComment                        
  ,PsChildMentalHealthHistoryNeedsList                        
                        
  ,PsChildEnvironmentalFactors                        
  ,PsChildEnvironmentalFactorsComment                        
  ,PsChildEnvironmentalFactorsNeedsList                        
                        
  ,PsImmunizations                
  ,PsImmunizationsComment                        
  ,PsImmunizationsNeedsList                        
                        
  ,PsLanguageFunctioning                        
  ,PsLanguageFunctioningComment                        
  ,PsLanguageFunctioningNeedsList                        
                        
  ,PsVisualFunctioning                     
  ,PsVisualFunctioningComment                        
  ,PsVisualFunctioningNeedsList                        
                        
  ,PsIntellectualFunctioning                        
  ,PsIntellectualFunctioningComment                        
  ,PsIntellectualFunctioningNeedsList                        
                        
  ,PsLearningAbility                        
  ,PsLearningAbilityComment                        
  ,PsLearningAbilityNeedsList        
  ,PsFunctioningConcernComment                  
                        
  ,PsPeerInteraction                        
  ,PsPeerInteractionComment                        
  ,PsPeerInteractionNeedsList                        
                        
  ,PsChildHousingIssues                        
  ,PsChildHousingIssuesComment                        
  ,PsChildHousingIssuesNeedsList                        
                        
                   
  ,PsSexuality                        
  ,PsSexualityComment                        
  ,PsSexualityNeedsList                        
                        
  ,PsFamilyFunctioning                        
  ,PsFamilyFunctioningComment                        
  ,PsFamilyFunctioningNeedsList                        
                        
                        
  ,PsParentalParticipation                        
  ,PsParentalParticipationComment                        
  ,PsParentalParticipationNeedsList                        
                        
                     
                        
  ,PsSchoolHistory                        
  ,PsSchoolHistoryComment                        
  ,PsSchoolHistoryNeedsList                        

                       
                        
  ,HistDevelopmental                        
  ,HistDevelopmentalComment                        
                        
  ,HistResidential                        
  ,HistResidentialComment                        
                        
  ,HistOccupational                        
  ,HistOccupationalComment                        
                        
  ,HistLegalFinancial                        
  ,HistLegalFinancialComment                        
                        
-------                         
  ,PsGrossFineMotor                        
  ,PsGrossFineMotorComment                        
  ,PsGrossFineMotorNeedsList                        
                        
  ,PsSensoryPerceptual                       
  ,PsSensoryPerceptualComment              
  ,PsSensoryPerceptualNeedsList                        
                        
  ,PsCognitiveFunction                        
  ,PsCognitiveFunctionComment                        
  ,PsCognitiveFunctionNeedsList                   
                        
  ,PsCommunicativeFunction                        
  ,PsCommunicativeFunctionComment                        
  ,PsCommunicativeFunctionNeedsList                        
                        
  ,PsCurrentPsychoSocialFunctiion                        
  ,PsCurrentPsychoSocialFunctiionComment                        
  ,PsCurrentPsychoSocialFunctiionNeedsList                        
                        
  ,PsAdaptiveEquipment                        
  ,PsAdaptiveEquipmentComment                        
 ,PsAdaptiveEquipmentNeedsList                        
                        
  ,PsSafetyMobilityHome                        
  ,PsSafetyMobilityHomeComment                        
  ,PsSafetyMobilityHomeNeedsList                        
  ,LTRIM(RTRIM(PsHealthSafetyChecklistComplete)) AS PsHealthSafetyChecklistComplete                        
  ,PsAccessibilityIssues                        
  ,PsAccessibilityIssuesComment                        
  ,PsAccessibilityIssuesNeedsList                        
                        
  ,PsEvacuationTraining                        
  ,PsEvacuationTrainingComment                        
  ,PsEvacuationTrainingNeedsList                        
                        
  ,Ps24HourSetting                        
  ,Ps24HourSettingComment                        
  ,Ps24HourSettingNeedsList                        
                        
                        
  ,RTRIM(LTRIM(Ps24HourNeedsAwakeSupervision)) AS Ps24HourNeedsAwakeSupervision                        
                        
  ,PsSpecialEdEligibility                        
  ,PsSpecialEdEligibilityComment                        
  ,PsSpecialEdEligibilityNeedsList                        
                          
  ,PsSpecialEdEnrolled                        
  ,PsSpecialEdEnrolledComment                        
  ,PsSpecialEdEnrolledNeedsList                        
                        
  ,PsEmployer                        
  ,PsEmployerComment                        
  ,PsEmployerNeedsList                        
                        
  ,PsEmploymentIssues                        
  ,PsEmploymentIssuesComment                        
  ,PsEmploymentIssuesNeedsList                        
                        
                        
  ,PsRestrictionsOccupational                        
  ,PsRestrictionsOccupationalComment                        
  ,PsRestrictionsOccupationalNeedsList                        
                          
  ,PsFunctionalAssessmentNeeded                        
  ,PsPlanDevelopmentNeeded                        
  ,PsAdvocacyNeeded                        
  ,PsLinkingNeeded                        
                        
  ,PsDDInformationProvidedBy                        
                        
                        
  ,PsMedicationsComment,                                                        
  PsEducationComment,                        
  PsEducation,                        
  PsEducationNeedsList,                        
  PsMedications,                        
  PsMedicationsNeedsList,          
  PsMedicationsListToBeModified  
                        
                        
  ,ClientStrengthsNarrative                        
  ,CHA.NaturalSupportSufficiency                        
  ,NaturalSupportNeedsList                        
  ,CHA.CommunityActivitiesCurrentDesired                        
  ,CHA.CrisisPlanningClientHasPlan                  
  ,CHA.CrisisPlanningDesired                     
  ,CHA.CrisisPlanningMoreInfo                        
  ,CHA.CrisisPlanningNarrative                       
  ,CHA.CrisisPlanningNeedsList                        
                        
  ,CHA.AdvanceDirectiveClientHasDirective                        
  ,CHA.AdvanceDirectiveDesired                        
  ,CHA.AdvanceDirectiveMoreInfo                        
  ,CHA.AdvanceDirectiveNarrative                        
  ,CHA.AdvanceDirectiveNeedsList                        
                        
  ,CHA.SuicideActive                        
  ,CHA.SuicideIdeation                        
  ,CHA.SuicideMeans                     
  ,CHA.SuicideOtherRiskSelf                        
  ,CHA.SuicideOtherRiskSelfComment                        
  ,CHA.SuicidePassive                        
  ,CHA.SuicidePlan                   
                        
  ,CHA.HomicideActive                     
  ,CHA.HomicideIdeation                      
  ,CHA.HomicdeOtherRiskOthers                        
  ,CHA.HomicideOtherRiskOthersComment                        
  ,CHA.HomicidePassive                        
  ,CHA.HomicidePlan                          
                        
  ,CHA.PhysicalAgressionNotPresent                        
  ,CHA.PhysicalAgressionSelf                        
  ,CHA.PhysicalAgressionOthers                        
  ,CHA.PhysicalAgressionCurrentIssue                        
  ,CHA.PhysicalAgressionNeedsList                        
  ,CHA.PhysicalAgressionBehaviorsPastHistory                        
  ,CHA.RiskAccessToWeapons                        
  ,CHA.RiskAppropriateForAdditionalScreening                        
  ,CHA.RiskClinicalIntervention                        
  ,CHA.RiskOtherFactors        
  ,CHA.RiskOtherFactorsNone         
  ,CHA.RiskOtherFactorsNeedsList                       
                        
  -- Summary                        
  ,CHA.ClinicalSummary                        
  ,CHA.DischargeCriteria                        
                        
  -- Pre-plan                        
  ,CHA.Participants                        
  ,CHA.TimeLocation                        
  ,CHA.IssuesToAvoid                        
  ,CHA.IssuesToDiscuss                        
  ,CHA.PrePlanIndependentFacilitatorDiscussed                        
  ,CHA.PrePlanIndependentFacilitatorDesired                        
  ,CHA.Facilitator                        
  ,CHA.CommunicationAccomodations                        
  ,CHA.SelfDeterminationDesired                        
  ,CHA.FiscalIntermediaryDesired                        
  ,CHA.PrePlanFiscalIntermediaryComment                       
  ,dbo.csf_GetGlobalCodeNameById(CHA.StageOfChange) as StageOfChange         
  ,dbo.csf_GetGlobalCodeNameById(CDC.CrafftStageOfChange) AS StageOfChangeForCrafft    
  ,CHA.PrePlanGuardianContacted                        
  ,CHA.SourceOfPrePlanningInfo                        
  ,CHA.PamphletGiven                        
  ,CHA.PamphletDiscussed   
  ,CHA.AssessmentAddtionalInformation                        
  ,CHA.ClientIsAppropriateForTreatment                        
  ,CHA.SecondOpinionNoticeProvided                        
  ,CHA.TreatmentNarrative  
  ,CHA.OutsideReferralsGiven                        
  ,CHA.ReferralsNarrative   
  ,CHA.AssessmentsNeeded            
  ,CHA.TreatmentAccomodation    
  ,dbo.GetAge(Clients.DOB, getdate() ) as ClientAge    
  ,CASE 
  WHEN DateDiff (year,Clients.DOB, getdate() )>=7 AND DateDiff (year,Clients.DOB, getdate() )<=17 THEN  'EnableCAFAS'
  WHEN DateDiff (year,Clients.DOB, getdate() )>=0 AND DateDiff (year,Clients.DOB, getdate() )<=6 THEN 'DiableCAFAS'
  ELSE  'DisableTabs'--DateDiff (year,Clients.DOB, getdate() )>=4 AND DateDiff (year,Clients.DOB, getdate() )<=6 THEN 2--'DiableCAFAS'
  END as enabletab       
  ,cc.HRMAssessmentHealthAssesmentLabel                        
  ,StaffAxisV                        
  ,StaffAxisVReason                
                  
  ,PhysicalConditionQuadriplegic                
  ,PhysicalConditionMultipleSclerosis                
  ,PhysicalConditionBlindness                
  ,PhysicalConditionDeafness                
  ,PhysicalConditionParaplegic                
  ,PhysicalConditionCerebral                
  ,PhysicalConditionMuteness                
  ,PhysicalConditionOtherHearingImpairment                 
                  
  ,TestingReportsReviewed                
  ,CHA.LOCId                
  ,PreplanSeparateDocument    
  ,SevereProfoundDisability  
  ,SevereProfoundDisabilityComment                              
    ,PsMedicationsSideEffects  
  ,AutisticallyImpaired  
  ,CognitivelyImpaired  
  ,EmotionallyImpaired  
  ,BehavioralConcern  
  ,LearningDisabilities  
  ,PhysicalImpaired  
  ,IEP  
  ,ChallengesBarrier  
  ,UnProtectedSexualRelationMoreThenOnePartner  
  ,SexualRelationWithHIVInfected  
  ,SexualRelationWithDrugInject  
  ,InjectsDrugsSharedNeedle  
  ,ReceivedAnyFavorsForSexualRelation  
  ,FamilyFriendFeelingsCausedDistress  
  ,FeltNervousAnxious  
  ,NotAbleToStopWorrying  
  ,StressPeoblemForHandlingThing  
  ,SocialAndEmotionalNeed  
  ,DepressionAnxietyRecommendation  
  ,CommunicableDiseaseRecommendation  
  ,DepressionPHQToNeedList
  ,PleasureInDoingThings  
  ,DepressedHopelessFeeling  
  ,AsleepSleepingFalling  
  ,TiredFeeling  
  ,OverEating  
  ,BadAboutYourselfFeeling  
  ,TroubleConcentratingOnThings  
  ,SpeakingSlowlyOrOpposite  
  ,BetterOffDeadThought  
  ,DifficultProblem  
  ,SexualityComment  
  ,ReceivePrenatalCare  
  ,ReceivePrenatalCareNeedsList  
  ,ProblemInPregnancy  
  ,ProblemInPregnancyNeedsList 
  ,DevelopmentalAttachmentComments  
  ,PrenatalExposer  
  ,PrenatalExposerNeedsList  
  ,WhereMedicationUsed  
  ,WhereMedicationUsedNeedsList  
  ,IssueWithDelivery  
  ,IssueWithDeliveryNeedsList      
  ,ChildDevelopmentalMilestones  
,ChildDevelopmentalMilestonesNeedsList  
,TalkBeforeNeedsList  
,ParentChildRelationshipIssue  
,ParentChildRelationshipNeedsList  
,FamilyRelationshipIssues  
,FamilyRelationshipNeedsList 
,AddSexualitytoNeedList  
,WhenTheyWalkUnknown  
,WhenTheyTalkUnknown  
,WhenTheyTalkSentenceUnknown
,LegalIssues
,CSSRSAdultOrChild
,Strengths
,TransitionLevelOfCare
,ReductionInSymptoms
,AttainmentOfHigherFunctioning
,TreatmentNotNecessary
,OtherTransitionCriteria
,CONVERT(varchar(12),EstimatedDischargeDate,101) as EstimatedDischargeDate
,ReductionInSymptomsDescription
,AttainmentOfHigherFunctioningDescription
,TreatmentNotNecessaryDescription
,OtherTransitionCriteriaDescription

into #CustomDocumentMHAssessments                      
From Documents  with (nolock)    
Join Clients with (nolock)  on Clients.ClientId = Documents.ClientId    
join DocumentVersions as dv with (nolock) on dv.DocumentId = documents.DOcumentId                       
Left Join CustomDocumentMHAssessments as CHA with (nolock) on cha.DocumentVersionId = dv.DocumentVersionId                         
LEFT JOIN CustomDocumentMHCRAFFTs AS CDC WITH (NOLOCK) ON CDC.DocumentVersionId = dv.DocumentVersionId                              
Left Join Staff as Staff1 with (nolock) on Staff1.StaffId = CHA.RaterClinician                        
Left Join Staff as Staff2 with (nolock) on Staff2.StaffId = Documents.AuthorId 
Left Join States as sta on sta.StateAbbreviation=GuardianState                              
cross Join CustomConfigurations cc   with (nolock)   
cross join SystemConfigurations sc with (nolock)                    
                     
Where dv.DocumentVersionId =@DocumentVersionId                   
and ISNULL(Documents.RecordDeleted,'N')='N'                     
and ISNULL(CHA.RecordDeleted,'N')='N'                     
and ISNULL(Staff1.RecordDeleted,'N')='N'                     
and ISNULL(Clients.RecordDeleted,'N')='N'                     
                            
                    
                    
select                      
CCAFAS2.DocumentVersionId                    
,CCAFAS2.CAFASDate           
  ,Staff1.FirstName + ' ' + Staff1.LastName as RaterClinician                        
  ,dbo.csf_GetGlobalCodeNameById(CCAFAS2.CAFASInterval) as CAFASInterval              
                     
, CCAFAS2.SchoolPerformance                      
, CCAFAS2.SchoolPerformanceComment                      
, CCAFAS2.HomePerformance                      
, CCAFAS2.HomePerfomanceComment                      
, CCAFAS2.CommunityPerformance                      
, CCAFAS2.CommunityPerformanceComment                      
, CCAFAS2.BehaviorTowardsOther                      
, CCAFAS2.BehaviorTowardsOtherComment                      
, CCAFAS2.MoodsEmotion                      
, CCAFAS2.MoodsEmotionComment                      
, CCAFAS2.SelfHarmfulBehavior                      
, CCAFAS2.SelfHarmfulBehaviorComment                      
, CCAFAS2.SubstanceUse                      
, CCAFAS2.SubstanceUseComment                      
, CCAFAS2.Thinkng                      
, CCAFAS2.ThinkngComment                      
, CCAFAS2.YouthTotalScore                      
, CCAFAS2.PrimaryFamilyMaterialNeeds                      
, CCAFAS2.PrimaryFamilyMaterialNeedsComment                      
, CCAFAS2.PrimaryFamilySocialSupport                      , CCAFAS2.PrimaryFamilySocialSupportComment                      
, CCAFAS2.NonCustodialMaterialNeeds                      
, CCAFAS2.NonCustodialMaterialNeedsComment                      
, CCAFAS2.NonCustodialSocialSupport                      
, CCAFAS2.NonCustodialSocialSupportComment                      
, CCAFAS2.SurrogateMaterialNeeds                      
, CCAFAS2.SurrogateMaterialNeedsComment                      
, CCAFAS2.SurrogateSocialSupport                      
, CCAFAS2.SurrogateSocialSupportComment                     
                    
into #CustomDocumentMHAssessmentCAFASs                    
                    
from CustomDocumentMHAssessmentCAFASs CCAFAS2 with (nolock)     
Left Join Staff as Staff1 with (nolock) on Staff1.StaffId = CCAFAS2.RaterClinician                        
                 
Where CCAFAS2.DocumentVersionId = @DocumentVersionId and ISNULL(CCAFAS2.RecordDeleted,'N')='N'                     
                              
                     
 --- CustomSubstanceUseAssessments ----     NOT USED                                                                                                                            
    select  [DocumentVersionId]                                                                         
      ,[VoluntaryAbstinenceTrial]                                                                                            
      ,[Comment]                                                                                               
      ,[HistoryOrCurrentDUI]                                                                                              
      ,[NumberOfTimesDUI]                                                                                              
      ,[HistoryOrCurrentDWI]                                                                                              
      ,[NumberOfTimesDWI]           
      ,[HistoryOrCurrentMIP]                                                                                              
      ,[NumberOfTimeMIP]                                                                  
      ,[HistoryOrCurrentBlackOuts]                                            
      ,[NumberOfTimesBlackOut]                                                              
      ,[HistoryOrCurrentDomesticAbuse]                                                                                             
      ,[NumberOfTimesDomesticAbuse]                                                                                              
      ,[LossOfControl]                                                                                             
      ,[IncreasedTolerance]                                                                                            
      ,[OtherConsequence]                                                                                
      ,[OtherConsequenceDescription]                                                                                              
      ,[RiskOfRelapse]                                                                  
      ,[PreviousTreatment]                          
      ,[CurrentSubstanceAbuseTreatment]          
      ,[CurrentTreatmentProvider]                                
      ,[CurrentSubstanceAbuseReferralToSAorTx]                                                                                              
      ,[CurrentSubstanceAbuseRefferedReason]                   
      ,[ToxicologyResults]         
      ,SubstanceAbuseAdmittedOrSuspected                                                                                             
      ,[ClientSAHistory]                          
      ,[FamilySAHistory]                                                          
      ,[NoSubstanceAbuseSuspected]                                                                                              
      ,[CurrentSubstanceAbuse]                                    
      ,[SuspectedSubstanceAbuse]                                                                                      
      ,[SubstanceAbuseDetail]                                                                                              
      ,[SubstanceAbuseTxPlan]                                                                                              
      ,[OdorOfSubstance]                            
      ,[SlurredSpeech]                                                                                           
      ,[WithdrawalSymptoms]                                                                                            
      ,[DTOther]                                                                                              
      ,[DTOtherText]                                                           
      ,[Blackouts]             
      ,[RelatedArrests]                                                                                       
      ,[RelatedSocialProblems]                                                                                           
      ,[FrequentJobSchoolAbsence]                                                   
      ,[NoneSynptomsReportedOrObserved]         
      ,DUI30Days        
      ,DUI5Years        
      ,DWI30Days        
      ,DWI5Years        
      ,Possession30Days        
      ,Possession5Years                                                                                          
      ,PreviousMedication  
      ,CurrentSubstanceAbuseMedication   
      ,MedicationAssistedTreatmentRefferedReason
      ,MedicationAssistedTreatment                 
  into  #CustomSubstanceUseAssessments                                                                                                                         
  FROM CustomSubstanceUseAssessments    with (nolock)                                                                                                                               
  WHERE DocumentVersionId = @DocumentVersionId and ISNULL(RecordDeleted, 'N') = 'N'         
                     
                   
                     
 --- CustomMentalStatuses2 ---                                      
  -- SELECT  [DocumentVersionId]                                   
  --    ,[AppearanceAddToNeedsList]                                    
  --    ,[AppearanceNeatClean]                                    
  --    ,[AppearancePoorHygiene]                                    
  --    ,[AppearanceWellGroomed]                                    
  --    ,[AppearanceAppropriatelyDressed]                                    
  --    ,[AppearanceYoungerThanStatedAge]                                    
  --    ,[AppearanceOlderThanStatedAge]                                    
  --    ,[AppearanceOverweight]                                    
  --    ,[AppearanceUnderweight]                                    
  --    ,[AppearanceEccentric]                                    
  --    ,[AppearanceSeductive]                                    
  --    ,[AppearanceUnkemptDisheveled]                                    
  --    ,[AppearanceOther]                                    
  --    ,[AppearanceComment]                                    
  --    ,[IntellectualAddToNeedsList]                                    
  --    ,[IntellectualAboveAverage]                                    
  --    ,[IntellectualAverage]                                    
  --    ,[IntellectualBelowAverage]                                    
  --    ,[IntellectualPossibleMR]                                    
  --    ,[IntellectualDocumentedMR]                                    
  --    ,[IntellectualOther]                                    
  --    ,[IntellectualComment]                                    
  --    ,[CommunicationAddToNeedsList]                                    
  --    ,[CommunicationNormal]                                    
  --    ,[CommunicationUsesSignLanguage]                                    
  --    ,[CommunicationUnableToRead]                                    
  --    ,[CommunicationNeedForBraille]                                    
  --    ,[CommunicationHearingImpaired]                                    
  --    ,[CommunicationDoesLipReading]                                    
  --    ,[CommunicationEnglishIsSecondLanguage]                                    
  --    ,[CommunicationTranslatorNeeded]                                    
  --    ,[CommunicationOther]                                    
  --    ,[CommunicationComment]                                    
  --    ,[MoodAddToNeedsList]                                    
  --    ,[MoodUnremarkable]                                    
  --    ,[MoodCooperative]                                    
  --    ,[MoodAnxious]                                    
  --    ,[MoodTearful]                                    
  --    ,[MoodCalm]                                    
  --    ,[MoodLabile]                                    
  --    ,[MoodPessimistic]                                    
  --    ,[MoodCheerful]                                    
  --    ,[MoodGuilty]                
  --    ,[MoodEuphoric]                                    
  --    ,[MoodDepressed]                                    
  --    ,[MoodHostile]                                    
  --    ,[MoodIrritable]                                    
  --    ,[MoodDramatized]                                    
  --    ,[MoodFearful]                                    
  --    ,[MoodSupicious]                                    
  --    ,[MoodOther]                                    
  --    ,[MoodComment]                                    
  --    ,[AffectAddToNeedsList]                                    
  --    ,[AffectPrimarilyAppropriate]                                    
  --    ,[AffectRestricted]                                    
  --    ,[AffectBlunted]                       
  --    ,[AffectFlattened]                                    
  --    ,[AffectDetached]                                    
  --    ,[AffectPrimarilyInappropriate]                                    
  --    ,[AffectOther]                                    
  --    ,[AffectComment]                                    
  --    ,[SpeechAddToNeedsList]                                    
  --    ,[SpeechNormal]                                    
  --    ,[SpeechLogicalCoherent]        
  --    ,[SpeechTangential]                                    
  --    ,[SpeechSparseSlow]                                    
  --    ,[SpeechRapidPressured]                                    
  --    ,[SpeechSoft]                                    
  --    ,[SpeechCircumstantial]                                    
  --    ,[SpeechLoud]                                    
  --    ,[SpeechRambling]                                    
  --    ,[SpeechOther]                                
  --    ,[SpeechComment]                                    
  --    ,[ThoughtAddToNeedsList]                                    
  --    ,[ThoughtUnremarkable]                                    
  --    ,[ThoughtParanoid]                                    
  --    ,[ThoughtGrandiose]                                    
  --    ,[ThoughtObsessive]                                    
  --    ,[ThoughtBizarre]                                    
  --    ,[ThoughtFlightOfIdeas]                                    
  --    ,[ThoughtDisorganized]                                    
  --    ,[ThoughtAuditoryHallucinations]                                    
  --    ,[ThoughtVisualHallucinations]                                    
  --    ,[ThoughtTactileHallucinations]                                    
  --    ,[ThoughtOther]                                    
  --    ,[ThoughtComment]                                    
  --    ,[BehaviorAddToNeedsList]                                    
  --    ,[BehaviorNormal]                                    
  --    ,[BehaviorRestless]                                    
  --    ,[BehaviorTremors]                                    
  --    ,[BehaviorPoorEyeContact]                                    
  --    ,[BehaviorAgitated]                                    
  --    ,[BehaviorPeculiar]                                    
  --    ,[BehaviorSelfDestructive]                                    
  --    ,[BehaviorSlowed]                                    
  --    ,[BehaviorDestructiveToOthers]                                    
  --    ,[BehaviorCompulsive]                                    
  --    ,[BehaviorOther]                                    
  --    ,[BehaviorComment]                                    
  --    ,[OrientationAddToNeedsList]                                    
  --    ,[OrientationToPersonPlaceTime]                                    
  --    ,[OrientationNotToPerson]                                    
  --    ,[OrientationNotToPlace]                                    
  --    ,[OrientationNotToTime]                                    
  --    ,[OrientationOther]                               
  --    ,[OrientationComment]                                    
  --    ,[InsightAddToNeedsList]                                    
  --,[InsightGood]                                    
  --    ,[InsightFair]                                    
  --    ,[InsightPoor]                                    
  --    ,[InsightLacking]                               
  --    ,[InsightOther]                                    
  --    ,[InsightComment]                                    
  --    ,[MemoryAddToNeedsList]                                    
  --    ,[MemoryGoodNormal]                                    
  --    ,[MemoryImpairedShortTerm]                                    
  --    ,[MemoryImpairedLongTerm]                                    
  --    ,[MemoryOther]                                    
  --    ,[MemoryComment]                                    
  --    ,[RealityOrientationAddToNeedsList]                                    
  --    ,[RealityOrientationIntact]                                    
  --    ,[RealityOrientationTenuous]                                    
  --    ,[RealityOrientationPoor]                                    
  --    ,[RealityOrientationOther]                                    
  --    ,[RealityOrientationComment]                                    
                      
  --into #CustomMentalStatuses2                         
  --FROM CustomMentalStatuses2   with (nolock)                                                             
  --WHERE DocumentVersionId = @DocumentVersionId and ISNULL(RecordDeleted, 'N') = 'N'                      
                     
                     
                     
  --CustomDocumentMHCRAFFTs  
  SELECT DocumentVersionId    
   ,CrafftApplicable    
   ,CrafftApplicableReason    
   ,CrafftQuestionC    
   ,CrafftQuestionR    
   ,CrafftQuestionA    
   ,CrafftQuestionF    
   ,CrafftQuestionFR    
   ,CrafftQuestionT    
   ,CrafftCompleteFullSUAssessment    
   ,CrafftStageOfChange    
  INTO #CustomDocumentMHCRAFFTs    
  FROM CustomDocumentMHCRAFFTs    
  WHERE (ISNULL(RecordDeleted, 'N') = 'N')    
   AND (DocumentVersionId = @DocumentVersionId)    
                   
                      
  SELECT                     
  CHA.DocumentVersionId,                
  OrganizationName                        
  ,QuestionFontStyle                        
  ,QuestionFontWeight                        
  ,ClientId                        
  ,ClientName                        
  ,ClinicianName                        
  ,EffectiveDate                        
  --,CHA.[CurrentAssessmentDate]                        
 -- ,CHA.[PreviousAssessmentDate]              
  ,CHA.[AssessmentType]                 
  ,CHA.[AdultOrChild]                       
  ,CHA.[ClientDOB]                        
  ,CHA.[ChildHasNoParentalConsent]                        
  ,CHA.[ClientHasGuardian]                        
  ,CHA.[GuardianFirstName]  
  ,CHA.[GuardianLastName]                      
  ,CHA.[GuardianAddress]  
  ,CHA.[GuardianCity]
  ,CHA.[GuardianState]                      
  ,CHA.[GuardianPhone] 
  ,CHA.[GuardianZipcode] 
  ,CHA.[RelationWithGuardian]                      
  --,CHA.GuardianType                        
  ,CHA.[ClientInDDPopulation]                        
  ,CHA.[ClientInSAPopulation]                        
  ,CHA.[ClientINMHPopulation]                        
  ,CHA.[PreviousDiagnosisText]                        
  ,CHA.ReferralType                        
  ,CHA.CurrentLivingArrangement         
  ,cha.EmploymentStatus              
  ,CHA.CurrentPrimaryCarePhysician                      
  ,CHA.[PresentingProblem]                        
  ,CHA.ReasonForUpdate                        
  ,CHA.DesiredOutcomes              
--------- CAFAS                        
  ,CustomHRMAssessmentsCAFASDate                        
  ,CustomHRMAssessmentsRaterClinician                        
  ,CustomHRMAssessmentsCAFASInterval                        
  ,CustomHRMAssessmentsSchoolPerformance                     
  ,CustomHRMAssessmentsSchoolPerformanceComment                      
  ,CustomHRMAssessmentsHomePerformance                      
  ,CustomHRMAssessmentsHomePerfomanceComment                       
  ,CustomHRMAssessmentsCommunityPerformance                      
  ,CustomHRMAssessmentsCommunityPerformanceComment                      
  ,CustomHRMAssessmentsBehaviorTowardsOther                      
  ,CustomHRMAssessmentsBehaviorTowardsOtherComment                      
  ,CustomHRMAssessmentsMoodsEmotion                      
  ,CustomHRMAssessmentsMoodsEmotionComment                       
  ,CustomHRMAssessmentsSelfHarmfulBehavior                       
  ,CustomHRMAssessmentsSelfHarmfulBehaviorComment                       
  ,CustomHRMAssessmentsSubstanceUse                      
  ,CustomHRMAssessmentsSubstanceUseComment                      
  ,CustomHRMAssessmentsThinkng                       
  ,CustomHRMAssessmentsThinkngComment                      
  --,SubScaleScore1                   
  ,CustomHRMAssessmentsPrimaryFamilyMaterialNeeds                       
  ,CustomHRMAssessmentsPrimaryFamilyMaterialNeedsComment                       
  ,CustomHRMAssessmentsSurrogateMaterialNeeds                     
  ,CustomHRMAssessmentsSurrogateMaterialNeedsComment                       
  ,CustomHRMAssessmentsPrimaryFamilySocialSupport                      
  ,CustomHRMAssessmentsPrimaryFamilySocialSupportComment                        
  ,CustomHRMAssessmentsNonCustodialMaterialNeeds                       
  ,CustomHRMAssessmentsNonCustodialMaterialNeedsComment                       
  ,CustomHRMAssessmentsSurrogateSocialSupport                       
  ,CustomHRMAssessmentsSurrogateSocialSupportComment                       
  ,CustomHRMAssessmentsNonCustodialSocialSupport                      
  ,CustomHRMAssessmentsNonCustodialSocialSupportComment                        
  --,SubScaleScore2                  
                                     
                          
----------- Developmental Disabilities Eligibility Criteria                        
  ,DDEPreviouslyMet                        
  ,DDAttributableMentalPhysicalLimitation                        
  ,DDDxAxisI                        
  ,DDDxAxisII                        
  ,DDDxAxisIII                        
  ,DDDxAxisIV                        
  ,DDDxAxisV                        
  ,DDDxSource        
  ,DDManifestBeforeAge22                        
  ,DDContinueIndefinitely                        
  ,DDLimitSelfCare                        
  ,DDLimitLanguage                        
  ,DDLimitLearning                        
  ,DDLimitMobility                        
  ,DDLimitSelfDirection                        
  ,DDLimitEconomic                        
  ,DDLimitIndependentLiving                    
  ,DDNeedMulitpleSupports                        
                        
---------------UNCOPE                        
  ,CHA.UncopeApplicable                        
  ,CHA.UncopeApplicableReason                        
  ,CHA.UncopeQuestionU                        
  ,CHA.UncopeQuestionN                        
  ,CHA.UncopeQuestionC                        
  ,CHA.UncopeQuestionO                        
  ,CHA.UncopeQuestionP                        
  ,CHA.UncopeQuestionE              
  ,SubstanceUseNeedsList     
  ,UncopeCompleteFullSUAssessment                     
                        
----------- Psychosocial Adult                        
  ,PsCurrentHealthIssues                        
  ,PsCurrentHealthIssuesComment                        
  ,PsCurrentHealthIssuesNeedsList                        
                          
  ,PsClientAbuseIssues                        
  ,PsClientAbuesIssuesComment                        
  ,PsClientAbuseIssuesNeedsList        
  ,PsFamilyConcernsComment  --Added by Jitender Kumar Kamboj on 09 August 2010        
  ,PsRiskLossOfPlacement        
  ,PsRiskLossOfPlacementDueTo        
  ,PsRiskSensoryMotorFunction        
  ,PsRiskSensoryMotorFunctionDueTo        
  ,PsRiskSafety        
  ,PsRiskSafetyDueTo        
  ,PsRiskLossOfSupport        
  ,PsRiskLossOfSupportDueTo         
  ,PsRiskExpulsionFromSchool         
  ,PsRiskExpulsionFromSchoolDueTo        
  ,PsRiskHospitalization         
  ,PsRiskHospitalizationDueTo        
  ,PsRiskCriminalJusticeSystem         
  ,PsRiskCriminalJusticeSystemDueTo        
  ,PsRiskElopementFromHome         
  ,PsRiskElopementFromHomeDueTo        
  ,PsRiskLossOfFinancialStatus        
  ,PsRiskLossOfFinancialStatusDueTo         
  ,RapCiDomainIntensity        
  ,RapCiDomainComment        
  ,RapCiDomainNeedsList        
  ,RapCbDomainIntensity        
  ,RapCbDomainComment        
  ,RapCbDomainNeedsList        
  ,RapCaDomainIntensity        
  ,RapCaDomainComment        
  ,RapCaDomainNeedsList        
  ,RapHhcDomainIntensity        
                            
                        
  ,PsLegalIssues                        
  ,PsLegalIssuesComment                        
  ,PsLegalIssuesNeedsList                        
                        
  ,PsSpiritualityIssues                        
  ,PsSpiritualityIssuesComment                        
  ,PsSpiritualityIssuesNeedsList                        
                        
  ,HistMentalHealthTx                        
                        
  ,PsCulturalEthnicIssues                        
  ,PsCulturalEthnicIssuesComment                        
  ,PsCulturalEthnicIssuesNeedsList                        
  ,HistMentalHealthTxComment          
  ,HistMentalHealthTxNeedsList           
                        
                        
  ,HistFamilyMentalHealthTx                        
  ,HistFamilyMentalHealthTxComment        
  ,HistFamilyMentalHealthTxNeedsList  -- Added by Jitender Kumar Kamboj on 09 August 2010                           
                        
  ,HistPreviousDx                        
  ,HistPreviousDxComment                        
                        
  ,PsTraumaticIncident                        
  ,PsTraumaticIncidentComment                        
  ,PsTraumaticIncidentNeedsList                        
                        
                 
  ,PsDevelopmentalMilestones                        
  ,PsDevelopmentalMilestonesComment                        
  ,PsDevelopmentalMilestonesNeedsList                        
                        
  ,PsPrenatalExposure                        
  ,PsPrenatalExposureComment                        
  ,PsPrenatalExposureNeedsList                        
                        
  ,PsChildMentalHealthHistory                        
  ,PsChildMentalHealthHistoryComment                        
  ,PsChildMentalHealthHistoryNeedsList                        
                        
  ,PsChildEnvironmentalFactors                        
  ,PsChildEnvironmentalFactorsComment                        
  ,PsChildEnvironmentalFactorsNeedsList                        
                        
  ,PsImmunizations                        
  ,PsImmunizationsComment                        
  ,PsImmunizationsNeedsList                        
                        
  ,PsLanguageFunctioning                        
  ,PsLanguageFunctioningComment                        
  ,PsLanguageFunctioningNeedsList                        
                        
  ,PsVisualFunctioning                        
  ,PsVisualFunctioningComment                        
  ,PsVisualFunctioningNeedsList                        
                        
  ,PsIntellectualFunctioning                        
  ,PsIntellectualFunctioningComment               
  ,PsIntellectualFunctioningNeedsList                        
                        
  ,PsLearningAbility                        
  ,PsLearningAbilityComment                        
  ,PsLearningAbilityNeedsList        
  ,PsFunctioningConcernComment                      
                        
  ,PsPeerInteraction  
  ,PsPeerInteractionComment                        
  ,PsPeerInteractionNeedsList                        
                        
  ,PsChildHousingIssues                        
  ,PsChildHousingIssuesComment                        
  ,PsChildHousingIssuesNeedsList                        
                        
                        
  ,PsSexuality                        
  ,PsSexualityComment                        
  ,PsSexualityNeedsList                        
                        
  ,PsFamilyFunctioning                        
  ,PsFamilyFunctioningComment                        
  ,PsFamilyFunctioningNeedsList                        
                     
                        
  ,PsParentalParticipation                        
  ,PsParentalParticipationComment                        
  ,PsParentalParticipationNeedsList                        
                      
                        
  ,PsSchoolHistory                        
  ,PsSchoolHistoryComment                        
  ,PsSchoolHistoryNeedsList                        
                       
                        
  ,HistDevelopmental                        
  ,HistDevelopmentalComment                        
                        
  ,HistResidential               
  ,HistResidentialComment                        
                        
  ,HistOccupational                        
  ,HistOccupationalComment                        
                        
  ,HistLegalFinancial                        
  ,HistLegalFinancialComment                        
                        
-------                         
  ,PsGrossFineMotor                        
  ,PsGrossFineMotorComment                        
  ,PsGrossFineMotorNeedsList                        
                        
  ,PsSensoryPerceptual                        
  ,PsSensoryPerceptualComment                        
  ,PsSensoryPerceptualNeedsList                        
                        
  ,PsCognitiveFunction                        
  ,PsCognitiveFunctionComment                        
  ,PsCognitiveFunctionNeedsList                        
                        
  ,PsCommunicativeFunction                        
  ,PsCommunicativeFunctionComment                        
  ,PsCommunicativeFunctionNeedsList                        
            
  ,PsCurrentPsychoSocialFunctiion                        
  ,PsCurrentPsychoSocialFunctiionComment                        
  ,PsCurrentPsychoSocialFunctiionNeedsList                        
                        
  ,PsAdaptiveEquipment                        
  ,PsAdaptiveEquipmentComment                        
  ,PsAdaptiveEquipmentNeedsList                        
                        
  ,PsSafetyMobilityHome                        
  ,PsSafetyMobilityHomeComment                        
  ,PsSafetyMobilityHomeNeedsList                        
  ,PsHealthSafetyChecklistComplete                        
  ,PsAccessibilityIssues                        
  ,PsAccessibilityIssuesComment                        
  ,PsAccessibilityIssuesNeedsList                        
                        
  ,PsEvacuationTraining                        
  ,PsEvacuationTrainingComment                        
  ,PsEvacuationTrainingNeedsList                        
                        
  ,Ps24HourSetting                        
  ,Ps24HourSettingComment                        
  ,Ps24HourSettingNeedsList                        
                        
                        
  ,Ps24HourNeedsAwakeSupervision                        
                        
  ,PsSpecialEdEligibility                        
  ,PsSpecialEdEligibilityComment                        
  ,PsSpecialEdEligibilityNeedsList                        
                          
  ,PsSpecialEdEnrolled                  
  ,PsSpecialEdEnrolledComment                        
  ,PsSpecialEdEnrolledNeedsList                        
                        
  ,PsEmployer                        
  ,PsEmployerComment                        
  ,PsEmployerNeedsList                        
                        
  ,PsEmploymentIssues                        
  ,PsEmploymentIssuesComment                        
  ,PsEmploymentIssuesNeedsList                        
                        
                        
  ,PsRestrictionsOccupational                        
  ,PsRestrictionsOccupationalComment                        
  ,PsRestrictionsOccupationalNeedsList             
                          
  ,PsFunctionalAssessmentNeeded                        
  ,PsPlanDevelopmentNeeded                        
  ,PsAdvocacyNeeded                        
  ,PsLinkingNeeded                        
                        
  ,PsDDInformationProvidedBy                        
                        
                        
  ,PsMedicationsComment                                                        
  ,PsEducationComment                        
  ,PsEducation                        
  ,PsEducationNeedsList                        
  ,PsMedications                        
  ,PsMedicationsNeedsList        
  ,PsMedicationsListToBeModified                        
                        
  ,ClientStrengthsNarrative                        
  ,CHA.NaturalSupportSufficiency                        
  ,NaturalSupportNeedsList                        
  ,CHA.CommunityActivitiesCurrentDesired                        
  ,CHA.CrisisPlanningClientHasPlan                        
  ,CHA.CrisisPlanningDesired                        
  ,CHA.CrisisPlanningMoreInfo                        
  ,CHA.CrisisPlanningNarrative                        
  ,CHA.CrisisPlanningNeedsList                        
                        
  ,CHA.AdvanceDirectiveClientHasDirective                        
  ,CHA.AdvanceDirectiveDesired                        
  ,CHA.AdvanceDirectiveMoreInfo                        
  ,CHA.AdvanceDirectiveNarrative                        
  ,CHA.AdvanceDirectiveNeedsList                        
                        
  ,CHA.SuicideActive                        
 -- ,CHA.SuicideBehaviorsPastHistory                        
  ,CHA.SuicideIdeation                        
  ,CHA.SuicideMeans                        
 -- ,CHA.SuicideNeedsList                        
 -- ,CHA.SuicideNotPresent                        
  ,CHA.SuicideOtherRiskSelf                        
  ,CHA.SuicideOtherRiskSelfComment                        
  ,CHA.SuicidePassive                
  ,CHA.SuicidePlan                        
--,CHA.SuicidePriorAttempt        
 -- ,CHA.SuicideCurrent    -- Added by Jitender Kumar Kamboj on 09 August 2010         
 -- ,CHA.HomicideCurrent                                   
                        
  ,CHA.HomicideActive                        
 -- ,CHA.HomicideBehaviorsPastHistory                        
  ,CHA.HomicideIdeation                        
 -- ,CHA.HomicideMeans                        
--  ,CHA.HomicideNeedsList                        
--  ,CHA.HomicideNotPresent                        
  ,CHA.HomicdeOtherRiskOthers                        
  ,CHA.HomicideOtherRiskOthersComment                        
  ,CHA.HomicidePassive                        
  ,CHA.HomicidePlan                        
 -- ,CHA.HomicidePriorAttempt                        
                        
  ,CHA.PhysicalAgressionNotPresent                        
  ,CHA.PhysicalAgressionSelf                        
  ,CHA.PhysicalAgressionOthers                        
  ,CHA.PhysicalAgressionCurrentIssue                        
  ,CHA.PhysicalAgressionNeedsList                        
  ,CHA.PhysicalAgressionBehaviorsPastHistory                        
  ,CHA.RiskAccessToWeapons                        
  ,CHA.RiskAppropriateForAdditionalScreening                        
  ,CHA.RiskClinicalIntervention                        
  ,CHA.RiskOtherFactors        
  ,CHA.RiskOtherFactorsNone          
  ,CHA.RiskOtherFactorsNeedsList                          
                        
  -- Summary                        
  ,CHA.ClinicalSummary                        
  ,CHA.DischargeCriteria                        
                        
  -- Pre-plan                        
  ,CHA.Participants                      
  ,CHA.TimeLocation                        
  ,CHA.IssuesToAvoid                        
  ,CHA.IssuesToDiscuss                        
  ,CHA.PrePlanIndependentFacilitatorDiscussed                        
  ,CHA.PrePlanIndependentFacilitatorDesired                        
  ,CHA.Facilitator                        
  ,CHA.CommunicationAccomodations                        
  ,CHA.SelfDeterminationDesired                        
  ,CHA.FiscalIntermediaryDesired                        
  ,CHA.PrePlanFiscalIntermediaryComment                       
  ,CHA.StageOfChange                      
  ,CHA.StageOfChangeForCrafft
  ,CHA.PrePlanGuardianContacted                        
  ,CHA.SourceOfPrePlanningInfo                        
  ,CHA.PamphletGiven                        
  ,CHA.PamphletDiscussed                        
                        
  ,CHA.AssessmentAddtionalInformation                        
  ,CHA.ClientIsAppropriateForTreatment                        
  ,CHA.SecondOpinionNoticeProvided                        
  ,CHA.TreatmentNarrative                        
                        
  ,CHA.OutsideReferralsGiven                        
  ,CHA.ReferralsNarrative                                        
  ,CHA.AssessmentsNeeded                        
  ,CHA.TreatmentAccomodation                        
  ,ClientAge    
  ,enabletab                 
  ,HRMAssessmentHealthAssesmentLabel                        
  ,StaffAxisV                        
  ,StaffAxisVReason                        
  ,PhysicalConditionQuadriplegic                
  ,PhysicalConditionMultipleSclerosis                
  ,PhysicalConditionBlindness                
  ,PhysicalConditionDeafness                
  ,PhysicalConditionParaplegic                
  ,PhysicalConditionCerebral                
  ,PhysicalConditionMuteness                
  ,PhysicalConditionOtherHearingImpairment                 
                  
  ,TestingReportsReviewed                
  ,CHA.LOCId             
  ,PreplanSeparateDocument                                  
                   
                    
 --#CustomDocumentMHAssessmentCAFASs                    
                  
,CCAFAS2.CAFASDate                      
, CCAFAS2.RaterClinician                      
, CCAFAS2.CAFASInterval                      
, CCAFAS2.SchoolPerformance                      
, CCAFAS2.SchoolPerformanceComment                      
, CCAFAS2.HomePerformance                      
, CCAFAS2.HomePerfomanceComment                      
, CCAFAS2.CommunityPerformance                      
, CCAFAS2.CommunityPerformanceComment                      
, CCAFAS2.BehaviorTowardsOther                      
, CCAFAS2.BehaviorTowardsOtherComment                      
, CCAFAS2.MoodsEmotion                      
, CCAFAS2.MoodsEmotionComment                      
, CCAFAS2.SelfHarmfulBehavior                      
, CCAFAS2.SelfHarmfulBehaviorComment                      
, CCAFAS2.SubstanceUse                      
, CCAFAS2.SubstanceUseComment                      
, CCAFAS2.Thinkng                      
, CCAFAS2.ThinkngComment                      
, CCAFAS2.YouthTotalScore                      
, CCAFAS2.PrimaryFamilyMaterialNeeds             
, CCAFAS2.PrimaryFamilyMaterialNeedsComment                      
, CCAFAS2.PrimaryFamilySocialSupport                      
, CCAFAS2.PrimaryFamilySocialSupportComment                      
, CCAFAS2.NonCustodialMaterialNeeds                      
, CCAFAS2.NonCustodialMaterialNeedsComment                      
, CCAFAS2.NonCustodialSocialSupport                      
, CCAFAS2.NonCustodialSocialSupportComment                      
, CCAFAS2.SurrogateMaterialNeeds                      
, CCAFAS2.SurrogateMaterialNeedsComment                      
, CCAFAS2.SurrogateSocialSupport                      
, CCAFAS2.SurrogateSocialSupportComment                     
                    
                 
                
--#CustomSubstanceUseAssessments                                                                               
      ,VoluntaryAbstinenceTrial               
      ,Comment       
      ,HistoryOrCurrentDUI                                                                                              
      ,NumberOfTimesDUI                                                                                              
      ,HistoryOrCurrentDWI                                                                                              
      ,NumberOfTimesDWI                                                                                              
      ,HistoryOrCurrentMIP                                                                                              
    ,NumberOfTimeMIP                                                                  
      ,HistoryOrCurrentBlackOuts                                              
      ,NumberOfTimesBlackOut                                                              
      ,HistoryOrCurrentDomesticAbuse                                                                                             
      ,NumberOfTimesDomesticAbuse                                                                                              
      ,LossOfControl                                                                                              
      ,IncreasedTolerance                                                                                              
      ,OtherConsequence                                                                                
      ,OtherConsequenceDescription                 
      ,RiskOfRelapse                                                                                              
      ,PreviousTreatment                          
      ,CurrentSubstanceAbuseTreatment                                                                                              
      ,CurrentTreatmentProvider                                                                                              
      ,CurrentSubstanceAbuseReferralToSAorTx                                                                                              
      ,CurrentSubstanceAbuseRefferedReason                                                                                      
      ,ToxicologyResults        
      ,SubstanceAbuseAdmittedOrSuspected        
                                                                                                    
      ,ClientSAHistory                                                                                              
      ,FamilySAHistory                                                            
      ,NoSubstanceAbuseSuspected                                                                                              
      ,CurrentSubstanceAbuse                                                                                              
      ,SuspectedSubstanceAbuse                                                                                      
      ,SubstanceAbuseDetail                                                                                              
      ,SubstanceAbuseTxPlan                                                                                              
      ,OdorOfSubstance                                                                                        
      ,SlurredSpeech                                                                                              
      ,WithdrawalSymptoms                                                                                              
      ,DTOther                                                                                              
   ,DTOtherText                               
      ,Blackouts                                        
      ,RelatedArrests                   
      ,RelatedSocialProblems                                                                                              
      ,FrequentJobSchoolAbsence                                                            
      ,NoneSynptomsReportedOrObserved         
      ,DUI30Days         
      ,DUI5Years        
      ,DWI30Days        
      ,DWI5Years        
      ,Possession30Days        
      ,Possession5Years                      
      ,PreviousMedication  
      ,CurrentSubstanceAbuseMedication             
	  ,MedicationAssistedTreatmentRefferedReason
      ,MedicationAssistedTreatment                  
                    
--#CustomMentalStatuses2                    
  
   ,[SevereProfoundDisability]  
   ,[SevereProfoundDisabilityComment]                                  
    --  ,[AppearanceAddToNeedsList]                                    
    --  ,[AppearanceNeatClean]                                    
    --  ,[AppearancePoorHygiene]                                    
    --  ,[AppearanceWellGroomed]                                    
    --  ,[AppearanceAppropriatelyDressed]                                
    --  ,[AppearanceYoungerThanStatedAge]                                    
    --  ,[AppearanceOlderThanStatedAge]                                    
    --  ,[AppearanceOverweight]                                    
    --  ,[AppearanceUnderweight]                                    
    --  ,[AppearanceEccentric]                                    
    --  ,[AppearanceSeductive]                                    
    --  ,[AppearanceUnkemptDisheveled]                                    
    --  ,[AppearanceOther]                                    
    --  ,[AppearanceComment]                                    
    --  ,[IntellectualAddToNeedsList]                                    
    --  ,[IntellectualAboveAverage]                                    
    --  ,[IntellectualAverage]                          
    --  ,[IntellectualBelowAverage]                                    
    --  ,[IntellectualPossibleMR]                                    
    --  ,[IntellectualDocumentedMR]                                    
    --  ,[IntellectualOther]                                    
    --  ,[IntellectualComment]                                    
    --  ,[CommunicationAddToNeedsList]                                    
    --  ,[CommunicationNormal]                                    
    --  ,[CommunicationUsesSignLanguage]                                    
    --  ,[CommunicationUnableToRead]                                    
    --  ,[CommunicationNeedForBraille]                                    
    --  ,[CommunicationHearingImpaired]                                    
    --  ,[CommunicationDoesLipReading]                                    
    --  ,[CommunicationEnglishIsSecondLanguage]                                    
    --  ,[CommunicationTranslatorNeeded]                                    
    --  ,[CommunicationOther]                                    
    --  ,[CommunicationComment]                                    
    --  ,[MoodAddToNeedsList]                                    
    --,[MoodUnremarkable]                                    
    --  ,[MoodCooperative]                                    
    --  ,[MoodAnxious]                                    
    --  ,[MoodTearful]                                    
    --  ,[MoodCalm]                                    
    --  ,[MoodLabile]                                    
    --  ,[MoodPessimistic]                                    
    --  ,[MoodCheerful]                                    
    --  ,[MoodGuilty]                                    
    --  ,[MoodEuphoric]                                    
    --  ,[MoodDepressed]                                    
    --  ,[MoodHostile]                                    
    --  ,[MoodIrritable]                                    
    --  ,[MoodDramatized]                                    
    --  ,[MoodFearful]                                    
    --  ,[MoodSupicious]                                    
    --  ,[MoodOther]                                    
    --  ,[MoodComment]                                    
    --  ,[AffectAddToNeedsList]                                    
    --  ,[AffectPrimarilyAppropriate]                            
    --  ,[AffectRestricted]                                    
    --  ,[AffectBlunted]                                    
    --  ,[AffectFlattened]                                    
    --  ,[AffectDetached]                                    
    --  ,[AffectPrimarilyInappropriate]                                    
    --  ,[AffectOther]                                    
    --  ,[AffectComment]                                    
    --  ,[SpeechAddToNeedsList]                                    
    --  ,[SpeechNormal]                                    
    --  ,[SpeechLogicalCoherent]                                    
    --  ,[SpeechTangential]                                    
    --  ,[SpeechSparseSlow]                                    
    -- ,[SpeechRapidPressured]                                    
    --  ,[SpeechSoft]                                    
    --  ,[SpeechCircumstantial]                                    
    --  ,[SpeechLoud]                                    
    --  ,[SpeechRambling]                                    
    --  ,[SpeechOther]                                    
    --  ,[SpeechComment]                                   
    --  ,[ThoughtAddToNeedsList]                                    
    --  ,[ThoughtUnremarkable]                                    
    --  ,[ThoughtParanoid]                                    
    --  ,[ThoughtGrandiose]                                    
    --  ,[ThoughtObsessive]                                    
    --  ,[ThoughtBizarre]                                    
    --  ,[ThoughtFlightOfIdeas]                                    
    --  ,[ThoughtDisorganized]                                    
    --  ,[ThoughtAuditoryHallucinations]                                    
    --  ,[ThoughtVisualHallucinations]                                    
    --  ,[ThoughtTactileHallucinations]                                    
    --  ,[ThoughtOther]                                    
    --  ,[ThoughtComment]                                    
    --  ,[BehaviorAddToNeedsList]                                    
    --  ,[BehaviorNormal]                                    
    --  ,[BehaviorRestless]                                    
    --  ,[BehaviorTremors]                                    
    --  ,[BehaviorPoorEyeContact]                                    
    --  ,[BehaviorAgitated]                                    
    --  ,[BehaviorPeculiar]                                    
    --  ,[BehaviorSelfDestructive]                                    
    --  ,[BehaviorSlowed]                                    
    --  ,[BehaviorDestructiveToOthers]                                    
    --  ,[BehaviorCompulsive]                                    
    --  ,[BehaviorOther]                                    
    --  ,[BehaviorComment]                                    
    --  ,[OrientationAddToNeedsList]                                    
    --  ,[OrientationToPersonPlaceTime]                                    
    --  ,[OrientationNotToPerson]                                    
    --  ,[OrientationNotToPlace]                                    
    --  ,[OrientationNotToTime]                                    
    --  ,[OrientationOther]                     
    --  ,[OrientationComment]                       
    --  ,[InsightAddToNeedsList]                                    
    --  ,[InsightGood]                                    
    --  ,[InsightFair]                                    
    --  ,[InsightPoor]                                    
    --  ,[InsightLacking]                                    
    --  ,[InsightOther]                                    
    --  ,[InsightComment]                                    
    --  ,[MemoryAddToNeedsList]                                    
    --  ,[MemoryGoodNormal]                
    --  ,[MemoryImpairedShortTerm]                           
    --  ,[MemoryImpairedLongTerm]                                    
    --  ,[MemoryOther]                                    
    --  ,[MemoryComment]                 
    --  ,[RealityOrientationAddToNeedsList]                                    
    --  ,[RealityOrientationIntact]                                     
    --  ,[RealityOrientationTenuous]                                    
    --  ,[RealityOrientationPoor]                                    
    --  ,[RealityOrientationOther]                                    
    --  ,[RealityOrientationComment]  
   --Crafft tab    
   ,[CrafftApplicable]    
   ,[CrafftApplicableReason]    
   ,[CrafftQuestionC]    
   ,[CrafftQuestionR]    
   ,[CrafftQuestionA]    
   ,[CrafftQuestionF]    
   ,[CrafftQuestionFR]    
   ,[CrafftQuestionT]    
   ,[CrafftCompleteFullSUAssessment]    
   ,[CrafftStageOfChange] 
      --Labels  
,BehaviorTowardsOtherCommentLabel  
,CommunityPerformanceCommentLabel  
,HomePerfomanceCommentLabel  
,MoodsEmotionCommentLabel  
,NonCustodialMaterialNeedsCommentLabel  
,NonCustodialSocialSupportCommentLabel  
,PrimaryFamilyMaterialNeedsCommentLabel  
,PrimaryFamilySocialSupportCommentLabel  
,SchoolPerformanceCommentLabel  
,SelfHarmfulBehaviorCommentLabel  
,SubstanceUseCommentLabel  
,SurrogateMaterialNeedsCommentLabel  
,SurrogateSocialSupportCommentLabel  
,ThinkngCommentLabel  
,AdvanceDirectiveClientHasDirectiveLabel  
,AssessmentAddtionalInformationLabel  
,ClinicalSummaryLabel  
,CrisisPlanningClientHasPlanLabel  
,CurrentLivingArrangementLabel  
,CurrentPrimaryCarePhysicianLabel  
,DDAttributableMentalPhysicalLimitationLabel  
,DesiredOutcomesLabel  
,DischargeCriteriaLabel  
  
,HistMentalHealthTxLabel  
,PsClientAbuseIssuesLabel  
,PsEducationCommentLabel  
  
,PresentingProblemLabel  
  
,PsChildFunctioningSectionLabel  
,PsChildHousingIssuesLabel  
,PsClientAbuesIssuesCommentLabel  
,PsCulturalEthnicIssuesLabel  
,PsCurrentHealthIssuesLabel  
,PsCurrentHealthIssuesCommentLabel  
,PsEducationLabel  
,PsFunctioningConcernCommentLabel  
,PsRiskCriminalJusticeSystemLabel  
,PsSpiritualityIssuesLabel  
,RapCaDomainCommentLabel  
,RapCbDomainCommentLabel  
,RapCiDomainCommentLabel  
,ReferralTypeLabel  
,RiskOtherFactorsLabel  
,SuicideBehaviorsPastHistoryLabel  
,HomicideBehaviorsPastHistoryLabel  
,SuicideOtherRiskSelfCommentLabel --Not Used  
,HomicideOtherRiskOthersCommentLabel --Not Used  
 
  
,TreatmentAccomodationLabel  
  
,locat.LOCCategoryName + ' / ' + loc.LOCName as LevelOfCare  
 ,PsMedicationsSideEffects  
  ,AutisticallyImpaired  
  ,CognitivelyImpaired  
  ,EmotionallyImpaired  
  ,BehavioralConcern  
  ,LearningDisabilities  
  ,PhysicalImpaired  
  ,IEP  
  ,ChallengesBarrier  
  ,UnProtectedSexualRelationMoreThenOnePartner  
  ,SexualRelationWithHIVInfected  
  ,SexualRelationWithDrugInject  
  ,InjectsDrugsSharedNeedle  
  ,ReceivedAnyFavorsForSexualRelation  
  ,FamilyFriendFeelingsCausedDistress  
  ,dbo.csf_GetGlobalCodeNameById(FeltNervousAnxious) as FeltNervousAnxious  
  ,dbo.csf_GetGlobalCodeNameById(NotAbleToStopWorrying) as NotAbleToStopWorrying  
  ,dbo.csf_GetGlobalCodeNameById(StressPeoblemForHandlingThing) as StressPeoblemForHandlingThing  
  ,dbo.csf_GetGlobalCodeNameById(SocialAndEmotionalNeed) as SocialAndEmotionalNeed  
  ,DepressionAnxietyRecommendation  
  ,CommunicableDiseaseRecommendation 
  ,DepressionPHQToNeedList 
  ,dbo.csf_GetGlobalCodeNameById(PleasureInDoingThings) as PleasureInDoingThings  
  ,dbo.csf_GetGlobalCodeNameById(DepressedHopelessFeeling) as DepressedHopelessFeeling  
  ,dbo.csf_GetGlobalCodeNameById(AsleepSleepingFalling) as AsleepSleepingFalling  
  ,dbo.csf_GetGlobalCodeNameById(TiredFeeling) as TiredFeeling  
  ,dbo.csf_GetGlobalCodeNameById(OverEating) as OverEating  
  ,dbo.csf_GetGlobalCodeNameById(BadAboutYourselfFeeling) as BadAboutYourselfFeeling  
  ,dbo.csf_GetGlobalCodeNameById(TroubleConcentratingOnThings) as TroubleConcentratingOnThings  
  ,dbo.csf_GetGlobalCodeNameById(SpeakingSlowlyOrOpposite) as SpeakingSlowlyOrOpposite  
  ,dbo.csf_GetGlobalCodeNameById(BetterOffDeadThought) as BetterOffDeadThought  
  ,dbo.csf_GetGlobalCodeNameById(DifficultProblem) as DifficultProblem  
  ,SexualityComment  
  ,ReceivePrenatalCare  
  ,ReceivePrenatalCareNeedsList  
  ,ProblemInPregnancy  
  ,ProblemInPregnancyNeedsList  
  --,WhenTheyTalk  
  ,DevelopmentalAttachmentComments  
  ,PrenatalExposer  
  ,PrenatalExposerNeedsList  
  ,WhereMedicationUsed  
  ,WhereMedicationUsedNeedsList  
  ,IssueWithDelivery  
  ,IssueWithDeliveryNeedsList  
  ,ChildDevelopmentalMilestones  
,ChildDevelopmentalMilestonesNeedsList  
--,TalkBefore  
--,TalkBeforeNeedsList  
,ParentChildRelationshipIssue  
,ParentChildRelationshipNeedsList  
,FamilyRelationshipIssues  
,FamilyRelationshipNeedsList  
--,WhenTheyTalkSentences   
--,WhenTheyWalk  
,AddSexualitytoNeedList  
,WhenTheyWalkUnknown  
,WhenTheyTalkUnknown  
,WhenTheyTalkSentenceUnknown  
,@totalPHQ9 as totalPHQ9                
 --,ClientInAutsimPopulation
,LegalIssues
,CSSRSAdultOrChild
,Strengths
,TransitionLevelOfCare
,ReductionInSymptoms
,AttainmentOfHigherFunctioning
,TreatmentNotNecessary
,OtherTransitionCriteria
,EstimatedDischargeDate
,ReductionInSymptomsDescription
,AttainmentOfHigherFunctioningDescription
,TreatmentNotNecessaryDescription
,OtherTransitionCriteriaDescription 
,@CSSRSAdultScreeners as CSSRSAdultScreeners
,@CSSRSAdultsinceLastvisit as CSSRSAdultsinceLastvisit 
,@CSSRSChildAdolescentSinceLastVisit as CSSRSChildAdolescentSinceLastVisit 


from #CustomDocumentMHAssessments CHA                    
left join #CustomDocumentMHAssessmentCAFASs CCAFAS2 on CHA.DocumentVersionId = CCAFAS2.DocumentVersionId                              
left join #CustomSubstanceUseAssessments CSUA on CHA.DocumentVersionId = CSUA.DocumentVersionId      
left join  CustomLOCs loc on loc.LOCId = CHA.LOCId       
left outer join CustomLOCCategories locat on locat.LOCCategoryId = loc.LOCCategoryId  
--left join #CustomMentalStatuses2 CMS2 on CHA.DocumentVersionId = CMS2.DocumentVersionId 
LEFT JOIN #CustomDocumentMHCRAFFTs CDC ON CHA.DocumentVersionId = CDC.DocumentVersionId                       
  
          
                 
                    
drop table #CustomDocumentMHAssessments                       
drop table #CustomDocumentMHAssessmentCAFASs                           
drop table #CustomSubstanceUseAssessments                    
--drop table #CustomMentalStatuses2     
  DROP TABLE #CustomDocumentMHCRAFFTs 
drop table #Verify                             
                    
                                                  
 end                                                                        
 END TRY                                                                                 
                     
                    
                                                                       
 BEGIN CATCH                                   
   DECLARE @Error varchar(8000)                                                                                                                 
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                      
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RDLCustomMHAssessment')                                                                                                              
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                                                                                     
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                                            
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                     
                                                                                                                
 END CATCH   
  
  GO