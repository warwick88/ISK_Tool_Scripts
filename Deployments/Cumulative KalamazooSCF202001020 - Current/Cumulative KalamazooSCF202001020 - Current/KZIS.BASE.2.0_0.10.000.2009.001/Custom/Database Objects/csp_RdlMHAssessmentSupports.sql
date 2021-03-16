

/****** Object:  StoredProcedure [dbo].[csp_RdlMHAssessmentSupports]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlMHAssessmentSupports]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlMHAssessmentSupports]
GO



/****** Object:  StoredProcedure [dbo].[csp_RdlMHAssessmentSupports]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROCEDURE [dbo].[csp_RdlMHAssessmentSupports]    --827658                    
@DocumentVersionId  int                 
 AS                       
Begin           
 /*********************************************************************/
 /* Stored Procedure: [csp_RdlMHAssessmentSupports]   */

 /*       Date              Author                  Purpose                   */ 
 /*       28/May/2020      Jyothi Bellapu         RDL SP for Support Tab as part of Kalamazoo - Improvements -#7*/
 /*********************************************************************/  
           
  
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
, 'Substnace Use History' as TabName  
, 'CustomSubstanceUseHistory2' as TableName  
, di.ColumnName as ColumnName  
, null as GroupName  
, di.ChildRecordId  as FieldName  
, case di.InitializationStatus   
 when 5871 then ' (To Verify)' --To Validate  
 when 5872 then ' (Reviewed and Verified ' + @StatusDate + ')'  
 when 5873 then ' (Reviewed and Updated ' + @StatusDate + ')'  
 when 5874 then ' (Reviewed and Cleared ' + @StatusDate + ')'  
 else '*Error '  end  
From DocumentInitializationLog di with (nolock)   
join CustomMHAssessmentSupports c with (nolock) on c.MHAssessmentSupportId = di.ChildRecordId and ISNULL(c.RecordDeleted,'N')<>'Y'  
join GlobalCodes gc with (nolock) on gc.GlobalCodeId = di.InitializationStatus   
Where di.TableName = 'CustomMHAssessmentSupports'  
and di.DocumentId = @DocumentId  
and ISNULL(Di.RecordDeleted,'N')<>'Y'  
  
order by 4, 3, 2, 6, 5, 7  
  
 ---CustomMHAssessmentSupports---                                                                    
SELECT   
  c.[MHAssessmentSupportId]                                                                       
 ,c.[DocumentVersionId]                                                                              
 ,c.[SupportDescription]                                                                              
 ,c.[Current]                                                                              
 ,c.[PaidSupport]                                                                              
 ,c.[UnpaidSupport]                                                                              
 ,c.[ClinicallyRecommended]                                     
 ,c.[CustomerDesired]          
 ,row_number() over ( partition by c.DocumentVersionId  order by c.MHAssessmentSupportId ) as RowNum  
 ,v.StatusData as StatusData                                                                               
FROM CustomMHAssessmentSupports c with (nolock)   
left join #Verify v on ltrim(rtrim(v.FieldName)) = c.[MHAssessmentSupportId]  
WHERE c.DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,'N')='N'         
order by c.MHAssessmentSupportId                
               
            
    --Checking For Errors                        
  If (@@error!=0)                        
  Begin                        

   RAISERROR ('csp_RdlMHAssessmentSupports failed.  Please contact your system administrator. We apologize for the inconvenience.',16,1)                  
                         
   Return                        
   End                        
                 
                      
            
End  
GO


