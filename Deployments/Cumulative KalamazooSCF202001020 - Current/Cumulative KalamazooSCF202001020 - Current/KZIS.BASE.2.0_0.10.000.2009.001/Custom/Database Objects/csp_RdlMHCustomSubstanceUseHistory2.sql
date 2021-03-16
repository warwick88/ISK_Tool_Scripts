
/****** Object:  StoredProcedure [dbo].[csp_RdlMHCustomSubstanceUseHistory2]   ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlMHCustomSubstanceUseHistory2]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlMHCustomSubstanceUseHistory2]
GO

/****** Object:  StoredProcedure [dbo].[csp_RdlMHCustomSubstanceUseHistory2]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
create PROCEDURE [dbo].[csp_RdlMHCustomSubstanceUseHistory2]   
           
@DocumentVersionId  int             
 AS               
Begin        
/*              
 
 exec dbo.csp_RdlCustomSubstanceUseHistory2 1200006     
*/          
  
declare @DocumentId int  
select @DocumentId = DocumentId from DocumentVersions where DocumentVersionId = @DocumentVersionId  
  
declare @StatusDate varchar(50)  
select @StatusDate = CONVERT(varchar(12),d.EffectiveDate,101)  
from Documents d   
where d.DocumentId = @DocumentId  
  
Declare @ClientInDDPopulation Char(1), @ClientInMHPopulation Char(1), @ClientInSAPopulation Char(1), @AssessmentType char(1), @AdultOrChild char(10)  
          
  
select   
 @ClientInDDPopulation = ClientInDDPopulation  
,@ClientInMHPopulation = ClientInMHPopulation  
,@ClientInSAPopulation = ClientInSAPopulation  
,@AssessmentType = AssessmentType   
,@AdultOrChild = AdultOrChild  
from CustomHRMAssessments                        
where DocumentVersionId = @DocumentVersionId  
  
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
(DocumentId, PopulationCategory, TabName, TableName, ColumnName, GroupName, FieldName,StatusData)  
   
--Document Initialization Individual Fields  
Select Distinct   
@DocumentId  
, null  as PopulationCategory  
, 'Substanace Use History' as TabName  
, 'CustomSubstanceUseHistory2' as TableName  
, di.ColumnName as ColumnName  
, csud.DrugName as GroupName  
, c.SUDrugId  as FieldName  
, case di.InitializationStatus   
 when 5871 then ' (To Verify)' --To Validate  
 when 5872 then ' (Reviewed and Verified ' + @StatusDate + ')'  
 when 5873 then ' (Reviewed and Updated ' + @StatusDate + ')'  
 when 5874 then ' (Reviewed and Cleared ' + @StatusDate + ')'  
 else '*Error '  end  
From DocumentInitializationLog di with (nolock)   
join CustomSubstanceUseHistory2 c with (nolock) on c.SubstanceUseHistoryId = di.ChildRecordId and ISNULL(c.RecordDeleted,'N')<>'Y'  
join CustomSUDrugs csud with (nolock) on csud.SUDrugId = c.SUDrugId and IsNull(csud.RecordDeleted,'N')='N'  
join GlobalCodes gc with (nolock) on gc.GlobalCodeId = di.InitializationStatus   
Where di.TableName = 'CustomSubstanceUseHistory2'  
and di.DocumentId = @DocumentId  
and ISNULL(Di.RecordDeleted,'N')<>'Y'  
  
order by 4, 3, 2, 6, 5  
  
  
Select   
CSUH.SubstanceUseHistoryId,   
csud.DrugName,  
CSUH.AgeOfFirstUse,   
fr.CodeName as Frequency,    
ro.CodeName as Route,  
CSUH.LastUsed,  
CSUH.InitiallyPrescribed,    
CSUH.Preference,  
CSUH.FamilyHistory,  
v.StatusData as Status  
from  CustomSubstanceUseHistory2 CSUH with (nolock)   
left join CustomSUDrugs csud with (nolock) on csud.SUDrugId = csuh.SUDrugId and IsNull(csud.RecordDeleted,'N')='N'     
left join GlobalCodes fr with (nolock) on fr.GlobalCodeId = csuh.Frequency  
left join GlobalCodes ro with (nolock) on ro.GlobalCodeId = csuh.Route   
left join #Verify v on LTRIM(rtrim(v.FieldName)) = csud.SUDrugId  
where DocumentVersionId=@DocumentVersionId        
and ISNULL(CSUH.RecordDeleted,'N')='N'      
order by 2  
    
    --Checking For Errors                
  If (@@error!=0)                
  Begin                
  
   RAISERROR ('csp_RdlMHCustomSubstanceUseHistory2 failed.  Please contact your system administrator. We apologize for the inconvenience.',16,1)                 
   Return                
End                
         
              
    
End  
  
  
  
GO


