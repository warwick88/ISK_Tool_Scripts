
/****** Object:  StoredProcedure [dbo].[csp_InitializeSCWebHRMAddendumStandardInitialization]    Script Date: 06/19/2015 12:23:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitializeSCWebHRMAddendumStandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitializeSCWebHRMAddendumStandardInitialization]
GO

/****** Object:  StoredProcedure [dbo].[csp_InitializeSCWebHRMAddendumStandardInitialization]    Script Date: 06/19/2015 12:23:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



Create PROCEDURE [dbo].[csp_InitializeSCWebHRMAddendumStandardInitialization]    -- 8744, 2227, null                                                                                                                          
(                                                                                                                                             
                                                                                                                                                
 @ClientID int,                                                  
 @StaffID int,                                                
 @CustomParameters xml)                                                                                                                                                      
As                                                                                                                                    
/*********************************************************************/                                                                                                                                        
/* Stored Procedure: dbo.csp_InitializeHRMTreatmentPlanStandardInitialization          */                                                                                                                                        
/* Purpose:   To Initialize from previous TreatmentPlan,Addendum,TP*/                                                                                                                                        
/*                                                                   */                                                                                                                                        
/* Input Parameters:   @VarClientID :-Id of the client*/                                                                                                                                        
/*                                                                   */                                                                                                                                        
/* Output Parameters:   None                                         */                                                                                                                                        
/*                                                                   */                                                                                                                                        
/* Return:  0=success, otherwise an error number                 */                                                                                                                                        
/*                                                                   */                                                                                                                                        
/* Called By:                  */                                                                                                                                        
/*                                                                   */                                                                                                                                        
/* Calls:                                                            */                                                                                                                                        
/*                                                                   */                                                                                                                                        
/* Data Modifications:                                               */                                                                                                                                        
/*                                                                   */                      
/* Updates:    */                         
/*   Date      Author      Purpose                       */                                          
/*   Sonia   Created                                            
/*09/April/09 Priya Modified the table Clientneeds to CustomClientNeeds and TPNeedsClientNeeds to CustomTPNeedsClientNeeds */                                     
04 April 2011 Modified By Rakesh Garg  (Remove Columns RowIdentifier from select statement in TPGeneral and TPNeeds table as These columns are no more in new data model)                            
8 APRIL 2011  Modified by Maninder (Added  PlanDeliveryStaff )         
13 Oct  2011  Modified by vineet   ref totask #277 sc web phase II bug /feature for initialize diagnosis box on the General tab of a treatment plan addendum .                     
/*14 Nove 2011 Rename the sp ssp_SCTxPlanGetPreviouslyRequestedUnits to ssp_SCGetPreviouslyRequestedUMCodeUnits*/        
/* 12 Dec 2011 Changes Made w.rf. to task 190 Get TPProcedure Information intialize   */ 
/* 29 Dec 2011 Sourabh Changes to add LocId column with ref to task#222*/	
/* 16 Jan 2012 Maninder Changes made w.r.f to Task#190*/  
/* 07 May 2013  Modified By shikha  w.rf to #39 in Allegan Support
				What:comment this "csp_SCGetTreatmentPlanDeliveryStaffList" and is now called directly from screen
				Why: Plandeliverystaff table makes UnsavedChangesXML heavy*/  
/*29 Oct 2014	Moved this change from csp_InitializeHRMTreatmentPlanStandardInitialization 04.Sept.2013	T.Remisoski	Ensure that only one LOC is returned even if 2 exist without end dates
				for KCMHSAS 3.5 Implementation: #126 SC: 3.5x Train*/
/* 19 June 2015	Munish Sood	Added condition to ensure that only one LOC is returned even if 2 exist without end dates w.r.t task #315 KCMHSAS 3.5 Impl*/ 
   2/25/2015    Hemant      Added "and Isnull(TP.Inactive,'N') = 'N'  and TP.EffectiveEndDate is null" condition to prvent the bad data from TPProcedures table.                                              
/* 02/03/2020   Arul Sonia       What: Modified "DeletedRecord" check to fix pulling bad data in Interventions tab
								 Why:	KCMHSAS - Support #1599                                      */  
/*********************************************************************/  */                                                              
 Declare @DocumentIDASS as bigint                                                                      
 Declare @VersionASS as bigint                                                  
 Declare @DocumentIDDIAG as bigint                                                                                                         
 Declare @VersionDIAG as bigint                                                                                                      
 Declare @DischargeCriteria as varchar(max)                                                                                     
 Declare @DocumentIDHRMASS as bigint                                                                                           
 Declare @VersionHRMASS as bigint                                                                                                
 Declare @DocumentRecentPlan as bigint                                                                                                                                                
 Declare @VersionRecentPlan as bigint                                               
 Declare @DocumentRecent as bigint --Most recent plan, addendum, or periodic review                                            
 Declare @VersionRecent as bigint                                            
                                            
                                            
 Declare @Participants as varchar(max)                                                                                                           
 Declare @ClientStrengths as varchar(max)                                                   
 Declare @AreasOfNeed as varchar(max)                                                                                      
 Declare @HopesAndDreams  as varchar(max)                                                                       
 Declare @DeferredTreatmentIssues as varchar(max)                                                                    
 Declare @CrisisPlan as varchar(max)                                          
                                       
 -- declared the variables ref #3611                                        
 declare  @varDocumentid int                                                                      
 declare  @varVersion int                                                                    
 declare  @varDocumentIdNotes int                                                
 declare  @varVersionIdNotes int                                                                    
 declare  @VarModifiedDateNotes datetime                                                
 declare  @VarModifiedDateDiagnosis datetime                                              
 declare @Diagnosis varchar(max)        -- added ref #3611                                                                                    
                        
begin try                                            
     
-- GETS THE MAXIMUM DOCUMENTID FOR A SIGNED ASSESSMENT DOCUMENT    and version according to EvvetiveDate                                
select top 1 @DocumentIDASS= a.DocumentId,  @VersionASS=a.CurrentDocumentVersionId                                              
from Documents a                                             
where a.ClientId = @ClientID                                              
and a.EffectiveDate <= convert(datetime, convert(varchar, getdate(),101))                             
and a.Status = 22 and a.DocumentCodeId =101             
and isNull(a.RecordDeleted,'N')<>'Y'                         
order by a.EffectiveDate desc,ModifiedDate desc                                                        
                                            
                                              
--GETS THE MAXIMUM DOCUMENTID FOR A SIGNED HRMASSESSMENT                                                       
select top 1 @DocumentIDHRMASS= a.DocumentId,  @VersionHRMASS=a.CurrentDocumentVersionId                                              
from Documents a                                             
where a.ClientId = @ClientID                                              
and a.EffectiveDate <= convert(datetime, convert(varchar, getdate(),101))                                             
and a.Status = 22 and a.DocumentCodeId =349                         
and isNull(a.RecordDeleted,'N')<>'Y'                                             
order by a.EffectiveDate desc,ModifiedDate desc                                                                                                              
                                                                     
                                            
--Get the DesiredOutcomes from CustomHRMAssessments                                                                      
if(@DocumentIDHRMASS<>0)                                                                                      
begin                                                                                      
     select @HopesAndDreams=CustomHRMAssessments.DesiredOutcomes                                                                                      
     from CustomHRMAssessments where DocumentVersionId  = @VersionHRMASS and  (RecordDeleted is null or RecordDeleted ='N')                                                                                                                                   
  
    
      
        
          
            
               
               
                 
end                                                                                  
                                                                               
                                                                               
--find out Strengths and Preferences from recent HRMAssessment or Old AssessmenT                                                                                    
--Case Signed Assessment exist but signed HRM Assessment does not exist                                                                           
if (@DocumentIDASS<>0 And isnull(@DocumentIDHRMASS,0)=0)                                                                                     
Begin                                                                                    
      select @ClientStrengths=CustomAssessments.ClientStrengths                                                                     
      from CustomAssessments where DocumentVersionId = @VersionASS and  (RecordDeleted is null or RecordDeleted ='N')                                                                                                                                          
  
    
      
        
          
            
end                                                                                    
                                                                      
--Case Signed HRM Assessment exist but signed Assessment does not exist                                                                                    
else if (@DocumentIDHRMASS<>0 And isnull(@DocumentIDASS,0)=0)                                                                                     
Begin                                                                            
    select @ClientStrengths=CustomHRMAssessments.ClientStrengthsNarrative                                                     
    from CustomHRMAssessments where DocumentVersionId  = @VersionHRMASS and  (RecordDeleted is null or RecordDeleted ='N')                                                                                                                   
end                                                                                    
--Case Signed Assessment is recent than HRMAssessment                                                              
else if (@DocumentIDASS<>0 And @DocumentIDHRMASS<>0 And                                                                                                         
   ((select ModifiedDate from Documents where documentid =@DocumentIDASS                                                                                                                                     
and  (RecordDeleted is null or RecordDeleted ='N'))                                                                                 
      >                                                                
    (select ModifiedDate from Documents where documentid =@DocumentIDHRMASS and                                                                                
 (RecordDeleted is null or RecordDeleted ='N')))                                                                               
   )                                                  
Begin                                                                                    
 select @ClientStrengths=CustomAssessments.ClientStrengths                                         
      from CustomAssessments where  DocumentVersionId  = @VersionASS and  (RecordDeleted is null or RecordDeleted ='N')                                                            
end                                                                                    
--Case Signed HRMAssessment is recent than Assessment                                                                               
else if (@DocumentIDASS<>0 And @DocumentIDHRMASS<>0 And                                                  
   ((select ModifiedDate from Documents where documentid =@DocumentIDASS                                                                                                                                     
and  (RecordDeleted is null or RecordDeleted ='N'))                                                           
     <                                                                                                                                                  
    (select ModifiedDate from Documents where documentid =@DocumentIDHRMASS and                                                                                                                                    
 (RecordDeleted is null or RecordDeleted ='N')))                                                                
   )                                                                                      
Begin                                                                                    
select @ClientStrengths=CustomHRMAssessments.ClientStrengthsNarrative                                                         
   from CustomHRMAssessments where DocumentVersionId  = @VersionHRMASS and  (RecordDeleted is null or RecordDeleted ='N')                                                                                         
end                                                                           
                                                                       
                                                                        
                                                                                    
--Discharge Criteria                  
Select @DischargeCriteria=(Select TPDischargeCriteria from CustomConfigurations)                            
--CrisisPlan                                                                      
set @CrisisPlan='';                                                                    
exec csp_HRMTPCrisisPlan 1 ,@CrisisPlan output                                                                    
                                                                                            
                                            
--DIAGNOSIS                                                             
--GETS THE LATEST DOCUMENTID AND VERSION FOR A SIGNED DIAGNOSIS DOCUMENT                                                                                                                                      
                                                                                                                     
-- modified by vineet ref to task #277                                                                                                                                          
                                                                                                                       
select top 1 @DocumentIDDIAG = a.DocumentId,  @VersionDIAG = a.CurrentDocumentVersionId                                                  
from Documents a          
Inner join DiagnosesIAndII DIandII -- line added by vineet          
on a.CurrentDocumentVersionId=DIandII.DocumentVersionId          
where a.ClientId = @ClientID                                                  
and a.EffectiveDate <= convert(datetime, convert(varchar, getdate(),101))                                                 
and a.Status = 22                                                                                  
and a.DocumentCodeId =5                                                 
and isNull(a.RecordDeleted,'N')<>'Y'                                                 
order by a.EffectiveDate desc,a.ModifiedDate desc            
          
-- End by vineet                                                                                                                                 
                                                                                                                                                                   
       if @VersionDIAG<>0                                                                                                              
       begin                                                                                                  
   select 'Specifier' as TableName,DiagnosesIAndII.Specifier                                  
   from DiagnosesIAndII                                             
   where DocumentVersionId = @VersionDIAG                                             
   and (RecordDeleted is null or RecordDeleted ='N') --table6                                               
                                                             
   select 'Specifier' as TableName,DiagnosesIII.Specification                                             
   from DiagnosesIII where DocumentVersionId = @VersionDIAG                                             
   and (RecordDeleted is null or RecordDeleted ='N')  --table7                                                                                                    
                                                                    
   select 'Specifier' as TableName,DiagnosesIV.Specification                                             
   from DiagnosesIV where DocumentVersionId  = @VersionDIAG                                             
   and (RecordDeleted is null or RecordDeleted ='N') --table8         
    end                                                
   else                                                                                                                                                  
       begin                      
         Select 'Specifier' as TableName,'' as Specifier                                            
         Select 'Specifier' as TableName,''  as Specification                                                             
         Select 'Specifier' as TableName,'' as Specification                       
       end                                                                                          
                                            
                                            
-- Fetch the Recent Signed Document for Treatment Plan HRM - 350 / Addendum -- 503                                                                            
select top 1 @DocumentRecentPlan= a.DocumentId,@VersionRecentPlan=a.CurrentDocumentVersionId                                                  
from Documents a                                                 
where a.ClientId = @ClientID                                              
and a.EffectiveDate <= convert(datetime, convert(varchar, getdate(),101))                                             
and a.Status = 22                                                 
and a.DocumentCodeId in (350,503,2)                                             
and isNull(a.RecordDeleted,'N')<>'Y'                                             
order by a.EffectiveDate desc,ModifiedDate desc                                          
                                                
-- Fetch the most recent document (Treatment Plan, Addendum, Periodic Review)                                            
select top 1 @DocumentRecent= a.DocumentId,@VersionRecent=a.CurrentDocumentVersionId                                                  
from Documents a                                                 
where a.ClientId = @ClientID                                              
and a.EffectiveDate <= convert(datetime, convert(varchar, getdate(),101))                                             
and a.Status = 22                                                 
and a.DocumentCodeId in (350,503,2, 352, 3)                                             
and isNull(a.RecordDeleted,'N')<>'Y'                                             
order by a.EffectiveDate desc,ModifiedDate desc                                                  
                                            
                                            
       --to fetch the values of DiagnosisI-II ref #3611                                                                
declare @DiagnosesI varchar(max)                                                
set @DiagnosesI='AxisI-II'+ char(9) + 'DSM Code'  + char(9) + 'Type' + char(9) + 'Version' + CHAR(13)                                                
                                                
select @DiagnosesI = @DiagnosesI + ISNULL(cast(a.Axis AS varchar),char(9)) + char(9)+ ISNULL(cast(a.DSMCode as varchar),char(9)) + char(9)+ char(9) + ISNULL(cast(b.CodeName as varchar),char(9)) + char(9) + ISNULL(cast(a.DSMVersion as varchar),           
  
    
      
        
                           
' ') + char(13)--,a.DSMNumber                                                 
from DiagnosesIAndII a                                                                      
 Join GlobalCodes b on a.DiagnosisType=b.GlobalCodeid                                                    
--where DiagnosisId in (select DiagnosisId from dbo.DiagnosesIAndII  where DocumentVersionId =@varVersion and isNull(RecordDeleted,'N')<>'Y')  -- commented by vineet used @VersionDIAG instead of varVersion                                                  
  
    
      
                 
 where DiagnosisId in (select DiagnosisId from dbo.DiagnosesIAndII  where DocumentVersionId =@VersionDIAG and isNull(RecordDeleted,'N')<>'Y')                                                             
 and isNull(a.RecordDeleted,'N')<>'Y'  and billable ='Y' order by Axis                                                         
                                       
                                            
      -- to fetch the values of DiagnosisV ref #3611                                              
declare @DiagnosesV varchar(max)                                                
set @DiagnosesV = 'Axis'+char(9)+'AxisV'+char(9)+'Current'+char(9)+'Version ' + char(13)                                                
--Check for documentid , is 0 then select Axis5 from notes otheriwse from DiagnosisV                                                                   
if(isnull(@varDocumentid,0) = 0)                       
 begin                                                                    
   select @DiagnosesV= @DiagnosesV + '1 '+char(9) + ISNULL(cast(AxisV as varchar),'Null')+ char(9) +'Current' + char(13)                                                
   from Notes where DocumentVersionId  = @varVersionIdNotes  and isNull(RecordDeleted,'N')<>'Y'                                                                       
 end                                                                       
else if(isnull(@varDocumentIdNotes,0) = 0)                                                                    
 begin                                                     
   select @DiagnosesV = @DiagnosesV + '1 '+char(9) +ISNULL(cast(AxisV as varchar),'Null')+char(9)+ 'Current'+ char(13)                                                
 from DiagnosesV                                                 
  where DocumentVersionId  = @varVersion and isNull(RecordDeleted,'N')<>'Y'                                                                       
 end                                                                       
else if(@varDocumentid <> 0 and @varDocumentIdNotes<>0)                          
 begin                                                                    
  if(@VarModifiedDateNotes>@VarModifiedDateDiagnosis)                                                                    
   begin                                                          
  select @DiagnosesV= @DiagnosesV + '1 ' +char(9)+ISNULL(cast(AxisV as varchar),'null')+char(9)+ 'Current' + char(13)                                                
   from Notes where DocumentVersionId  = @varVersionIdNotes  and isNull(RecordDeleted,'N')<>'Y'                                                                       
   end                                                                     
 else if(@VarModifiedDateNotes<@VarModifiedDateDiagnosis)                                                                    
   begin                                                                
  select @DiagnosesV = @DiagnosesV + '1 '+char(9)+ISNULL(cast(AxisV as varchar),'null')+char(9)+ 'Current' + char(13)                                                
   from DiagnosesV where DocumentVersionId  = @varVersion  and isNull(RecordDeleted,'N')<>'Y'                                                                       
   end                                                  
 end                                                     
                                              
   -- to concatenate the values fetched for DiagnosisI-II and DiagnosisV  ref #3611                                                
 --set @Diagnosis = @DiagnosesI + char(13) + @DiagnosesV                                                           
                                       
 SET @DeferredTreatmentIssues=''+char(13)                                                
select @DeferredTreatmentIssues = @DeferredTreatmentIssues + cast(NeedName as varchar) +'-'+ cast(NeedDescription as varchar) +CHAR(13)                                                 
from CustomClientNeeds                                        
inner join                   
ClientEpisodes                                                            
on ClientEpisodes.ClientEpisodeId=CustomClientNeeds.ClientEpisodeId                                                            
where ClientEpisodes.ClientId=@ClientID                                                   
and CustomClientNeeds.NeedStatus != 5236       
and IsNUll(ClientEpisodes.RecordDeleted,'N')<>'Y'                                                          
and IsNull(CustomClientNeeds.RecordDeleted,'N')<>'Y'                                                
                                             
                                        
 -- to fetch the value for AreasOfNeed ref #3611                                               
set @AreasOfNeed= 'The clinician has recommended the following areas be addressed in the treatment plan:  '+ Char(13)+char(13)+'NeedName ' + char(13)+char(13)                                                
select @AreasOfNeed =   coalesce(@AreasOfNeed +',','')+  CustomClientNeeds.NeedName                                                        
 from CustomClientNeeds                                                            
inner join                                                             
ClientEpisodes                                                            
on ClientEpisodes.ClientEpisodeId=CustomClientNeeds.ClientEpisodeId                                                            
where ClientEpisodes.ClientId=@ClientID                                                   
and CustomClientNeeds.NeedStatus != 5237                                                           
and IsNUll(ClientEpisodes.RecordDeleted,'N')<>'Y'                                                          
and IsNull(CustomClientNeeds.RecordDeleted,'N')<>'Y'                                                
                                                
 -- to concatenate the values fetched for DiagnosisI-II and DiagnosisV  ref #3611                                                
 set @Diagnosis = @DiagnosesI + char(13) + @DiagnosesV                                      
                                       
                                         
                                                                            
                                                                                
if(@DocumentRecentPlan<>0)                                                     
Begin                                                                                    
                                       
                                        
                                       
 select TOP 1 -1 as DocumentVersionId ,'T' as PlanOrAddendum,                                                                          
 HopesAndDreams,                                                         
 getdate() as MeetingDate,                                                                          
 DischargeCriteria,                                                                          
 StrengthsAndPreferences,                                                                     
 DeferredTreatmentIssues,                                      
 @AreasOfNeed as AreasOfNeed,                                      
 @Diagnosis as Diagnosis,                 
 CrisisPlan,                                                                                                                                                                 
 '' as CreatedBy,                                                  
 getdate() as CreatedDate,                                                                          
 '' as ModifiedBy,                                                                          
 getdate() as ModifiedDate,
 LOCId,                                                                           
 'TPGeneral' as TableName                                             
 from TPGeneral                                          
 where  DocumentVersionId = @VersionRecentPlan                                             
                                            
                                            
--Get the Needs Data corresponding to recent plan                                                                           
Select TPNeeds.*,'TPNeeds' as TableName                                             
from TPNeeds                                             
where DocumentVersionId  = @VersionRecent                                         
and (RecordDeleted is null or RecordDeleted ='N')                                             
and GoalActive='Y'                                                     
                                            
--Get the TPNeedsClientNeeds Data corresponding to recent plan                                      
select                                                         
TC.TPNeedsClientNeedId,TC.NeedId,TC.ClientNeedId,                                                        
CustomClientNeeds.NeedDescription,TC.RowIdentifier,TC.CreatedBy,TC.CreatedDate,TC.ModifiedBy,TC.ModifiedDate,TC.RecordDeleted,TC.DeletedDate,TC.DeletedBy                                                        
,'CustomTPNeedsClientNeeds'  as TableName                                    
from CustomTPNeedsClientNeeds as TC                                                                                
inner join CustomClientNeeds on TC.ClientNeedId=CustomClientNeeds.ClientNeedId                                             
    AND (ISNULL(CustomClientNeeds.RecordDeleted,'N')<>'Y')                                                                                 
where NeedId in (select NeedId from TPNeeds                                                      
    where DocumentVersionId  = @VersionRecent                                            
    and (RecordDeleted is null or RecordDeleted ='N')                                             
    and GoalActive='Y'                                                                                         
    )                                                                                            
and (ISNULL(TC.RecordDeleted,'N')<>'Y')                                                                                 
and CustomClientNeeds.NeedStatus not in (5236,5237)                                           
                                                                                                       
                                            
--Get the TPObjectives Data corresponding to recent plan                                                              
Select TPObjectives.*,'TPObjectives' as TableName                                             
from TPObjectives                                             
where DocumentVersionId  = @VersionRecent                                            
and (RecordDeleted is null or RecordDeleted ='N')                                             
and ObjectiveStatus in(191,193)                                             
and NeedID In(Select NeedID from TPNeeds                                             
    where DocumentVersionId= @VersionRecent                             
    and (RecordDeleted is null or RecordDeleted ='N')                                             
    and GoalActive='Y'                                            
    )                                                                                                         
ORDER BY ObjectiveNumber                                              
     
  Declare @SiteName as  varchar(100)                                  
 set @SiteName = ( select AgencyName from Agency)     
                                            
--Get the TPInterventionProcedures Data corresponding to recent plan                                                                                           
Select TIP.TPInterventionProcedureId,TIP.CreatedBy,TIP.CreatedDate,                        
TIP.ModifiedBy,TIP.ModifiedDate,TIP.RecordDeleted,TIP.DeletedDate,                        
TIP.DeletedBy,TIP.NeedId,TIP.InterventionNumber,TIP.InterventionText,                        
TIP.AuthorizationCodeId,TIP.Units,                        
TIP.FrequencyType,TIP.ProviderId,TIP.SiteId,                        
TIP.StaffName,TIP.StartDate,TIP.EndDate,TIP.TotalUnits,                        
TIP.TPProcedureId,'Y' as InitializedFromPreviousPlan,    
Auth.AuthorizationCodeName,    
Isnull(S.SiteName,@SiteName) as SiteName,                          
'TPInterventionProcedures' as TableName,TP.DocumentVersionId as TPProcedureSourceDocumentId                                                                                               
from TPInterventionProcedures   TIP                 
left join TPProcedures TP on  TIP.TPProcedureId=TP.TPProcedureId    
left join AuthorizationCodes Auth on TP.AuthorizationCodeID = Auth.AuthorizationCodeID and Isnull(Auth.RecordDeleted,'N') = 'N'    
left join Sites S on TIP.SiteId = S.SiteId                                                                                              
where NeedId In(Select NeedID from TPNeeds                                             
    where DocumentVersionId = @VersionRecent                                             
    and (RecordDeleted is null or RecordDeleted ='N')                                         
    and GoalActive='Y'                                            
    )  and ISNULL(TP.RecordDeleted,'N')='N' and Isnull(TP.Inactive,'N') = 'N'  and TP.EffectiveEndDate is null                         
and (TIP.RecordDeleted is null or TIP.RecordDeleted ='N')                                                 
       
 --Get the TPProcedures Information for task 190        
select Distinct TP.TPProcedureId,TP.DocumentVersionId,TP.AuthorizationCodeId ,TP.Units ,TP.FrequencyType,TP.ProviderId,        
 TP.SiteId,TP.StartDate,TP.EndDate,TP.TotalUnits,TP.AuthorizationId,TP.UMMessage,TP.Urgent,TP.Inactive,TP.EffectiveEndDate,        
 TP.RowIdentifier,TP.CreatedBy,TP.CreatedDate,TP.ModifiedBy,TP.ModifiedDate,TP.RecordDeleted,TP.DeletedDate,TP.DeletedBy,        
 case when TP.OriginalTPProcedureId is null then TP.TPProcedureId else TP.OriginalTPProcedureId end as OriginalTPProcedureId ,TP.DocumentVersionId as TPProcedureDocumentVersionId,           
 'Y' as TPProcedurePreviousPlan,    
 'TPProcedures' as TableName        
from TPProcedures TP left join TPInterventionProcedures TIP        
 on  TIP.TPProcedureId=TP.TPProcedureId  and ISNULL(TP.RecordDeleted,'N')='N'     
    
 where TIP.NeedId in (Select NeedID from TPNeeds                                               
    where DocumentVersionId = @VersionRecent                                               
    and (RecordDeleted is null or RecordDeleted ='N')                                               
    and GoalActive='Y' ) 
    and Isnull(TP.Inactive,'N') = 'N'  and TP.EffectiveEndDate is null               
 --Changes end here        
       
       
       
                                                               
---  TPInterventionProcedureObjectives                                                                                      
Select TIPO.*,'TPInterventionProcedureObjectives' as TableName                                         
from TPInterventionProcedureObjectives  TIPO                                            
join TPObjectives TOJ on  TIPO.ObjectiveId=TOJ.ObjectiveId                                             
      and (TOJ.RecordDeleted is null or TOJ.RecordDeleted ='N')                                             
      and ObjectiveStatus in(191,193)                                                              
join TPInterventionProcedures TIP on TIP.TPInterventionProcedureId=TIPO.TPInterventionProcedureId                                             
      and (TIP.RecordDeleted is null or TIP.RecordDeleted ='N')                                             
inner join TPNeeds TN on TN.NeedId=TOJ.NeedId                                             
      and  TN.NeedId=TIP.NeedId                                             
      and (TN.RecordDeleted is null or TN.RecordDeleted ='N')                                             
      and  TN.DocumentVersionId = @VersionRecent                                            
    and GoalActive='Y'                                            
where isnull(TIPO.RecordDeleted,'N')<>'Y'                                             
                                            
-- This code is added by Rakesh Garg for getting LOCID from CustomClientloc USED IN TPGeneral-Main Tab For Dropdown LOC                                 
if exists (SELECT ClientLOCId from CustomClientLOCs where ClientId = @ClientID and LOCEndDate IS NULL and Isnull(RecordDeleted,'N') = 'N')                           
 Begin                                         
 select  top 1 ClientLOCId,ClientId, CreatedBy, CreatedDate, ModifiedBy,                                     
 ModifiedDate, RecordDeleted, DeletedDate, DeletedBy, LOCId, LOCStartDate, LOCEndDate, LOCBy , 'CustomClientLOCs' as TableName,'N' as IsInitialize                                           
 FROM CustomClientLOCs CCLoc
			WHERE ClientId = @ClientID
				AND ISNULL(RecordDeleted, 'N') = 'N'
				AND (
					LOCEndDate IS NULL
					OR LOCEndDate > GETDATE()
					)
			AND NOT EXISTS ( SELECT *
                                         FROM   CustomClientLOCs AS b
                                         WHERE  b.ClientId = CCLoc.ClientId
                                                AND b.LOCEndDate IS NULL
                                                AND ISNULL(b.RecordDeleted, 'N') = 'N'
                                                AND ( ( b.LOCStartDate > CCLoc.LOCStartDate )
                                                      OR ( b.LOCStartDate = CCLoc.LOCStartDate
                                                           AND b.ClientLOCId > CCLoc.ClientLOCId
                                                         )
                                                    ) )                                                                  
 End                                      
 else                                        
 Begin                                      
  select  -1 as ClientLOCId,@ClientID as ClientId, -1 as LOCId  , '' as CreatedBy,                                           
  getdate() as CreatedDate, '' as ModifiedBy, getdate() as ModifiedDate, 'CustomClientLOCs' as TableName                                          
  End                                   
                                            
exec ssp_SCWebGetHRMTPClientNeeds @ClientID ,0,'Y',@VersionRecent                                                               
                                                                                    
 -- PlanDeliveryStaff      
 -- commented by shikha as this sp is now called directly from code behind                                           
--exec csp_SCGetTreatmentPlanDeliveryStaffList              
              
-- PreviouslyRequested              
exec ssp_SCGetPreviouslyRequestedUMCodeUnits @ClientId,@VersionRecent             
            
-- AddendumNotifications            
exec csp_NewTxPlanAddendumNotifications  @ClientID              
                                                                                   
end                                                                     
else                                                                                    
Begin                                                                                  
select -1 as DocumentVersionId,                                        
 'T' as PlanOrAddendum,                                            
 @HopesAndDreams as HopesAndDreams,                                            
 getdate() as MeetingDate,                                            
 @DischargeCriteria as DischargeCriteria,                                    
 @ClientStrengths  as StrengthsAndPreferences,                                            
 @DeferredTreatmentIssues as DeferredTreatmentIssues,                                            
 @CrisisPlan as CrisisPlan,                                      
  @AreasOfNeed as AreasOfNeed,                                      
 @Diagnosis as Diagnosis,                                               
                                            
 '' as CreatedBy,                                            
 getdate() as CreatedDate,                                            
 '' as ModifiedBy,                                            
 getdate() as ModifiedDate, 
 NULL as LOCId,                                          
 'TPGeneral' as TableName                                            
                                            
SET FMTONLY ON                                            
                                            
select NeedId,DocumentVersionId,  NeedNumber, NeedText, NeedTextRTF, NeedCreatedDate, NeedModifiedDate, GoalText, GoalTextRTF, GoalActive, GoalNaturalSupports,                                             
 GoalLivingArrangement, GoalEmployment, GoalHealthSafety, GoalStrengths, GoalBarriers, GoalMonitoredStaffOther,GoalMonitoredStaffOtherCheckbox,GoalMonitoredStaff, GoalTargetDate, StageOfTreatment, SourceNeedId,                                            
 
 CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy,'TPNeeds' as TableName                                             
from TPNeeds                                            
                                            
Select TPNeedsClientNeedId, NeedId, ClientNeedId, NeedDescription, RowIdentifier, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy,                                            
 'CustomTPNeedsClientNeeds' as TableName                                         
from CustomTPNeedsClientNeeds                                            
                                            
Select ObjectiveId, DocumentVersionId , NeedId, ObjectiveNumber, ObjectiveText, ObjectiveTextRTF, ObjectiveStatus, TargetDate, RowIdentifier, CreatedBy, CreatedDate,                                             
 ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy,'TPObjectives' as TableName                                            
from TPObjectives                                            
                                            
Select TPInterventionProcedureId, NeedId, InterventionText, AuthorizationCodeId, Units, frequencyType, ProviderId, SiteId, StartDate, EndDate, TotalUnits, TPProcedureId,                                             
 --RowIdentifier, -- Modified By Rakesh as Column removed now 22 Dec 2010                                 
 CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy, 'N' as InitializedFromPreviousPlan,                         
 'TPInterventionProcedures' as TableName                                             
from TPInterventionProcedures                                            
            
Select TPInterventionProcedureObjectiveId, TPInterventionProcedureId, ObjectiveId,                                 
--RowIdentifier, Modified By Rakesh as Column removed now 22 Dec 2010                                 
CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted,                                             
 DeletedDate, DeletedBy,'TPInterventionProcedureObjectives' as TableName                                            
from TPInterventionProcedureObjectives                                            
                                            
Select TPProcedureId, DocumentVersionId, AuthorizationCodeId, Units, FrequencyType, ProviderId, SiteId, StartDate, EndDate, TotalUnits, AuthorizationId, RowIdentifier,                                             
 CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy,OriginalTPProcedureId,'TPProcedures' as TableName              from TPProcedures                                            
                                            
SET FMTONLY OFF                                
                              
if exists (SELECT ClientLOCId from CustomClientLOCs where ClientId = @ClientID and LOCEndDate IS NULL and Isnull(RecordDeleted,'N') = 'N')                                      
 Begin                                         
 select TOP 1 ClientLOCId,ClientId, CreatedBy, CreatedDate, ModifiedBy,                                     
 ModifiedDate, RecordDeleted, DeletedDate, DeletedBy, LOCId, LOCStartDate, LOCEndDate, LOCBy , 'CustomClientLOCs' as TableName,'N' as IsInitialize                                           
 FROM CustomClientLOCs CCLoc
			WHERE ClientId = @ClientID
				AND ISNULL(RecordDeleted, 'N') = 'N'
				AND (
					LOCEndDate IS NULL
					OR LOCEndDate > GETDATE()
					)
			AND NOT EXISTS ( SELECT *
                                         FROM   CustomClientLOCs AS b
                                         WHERE  b.ClientId = CCLoc.ClientId
                                                AND b.LOCEndDate IS NULL
                                                AND ISNULL(b.RecordDeleted, 'N') = 'N'
                                                AND ( ( b.LOCStartDate > CCLoc.LOCStartDate )
                                                      OR ( b.LOCStartDate = CCLoc.LOCStartDate
                                                           AND b.ClientLOCId > CCLoc.ClientLOCId
                                                         )
                                                    ) )             
 End                                      
 else                        
 Begin                                      
  select  -1 as ClientLOCId,@ClientID as ClientId, -1 as LOCId  , '' as CreatedBy,                                           
  getdate() as CreatedDate, '' as ModifiedBy, getdate() as ModifiedDate, 'CustomClientLOCs' as TableName                                          
  End                              
                                            
exec ssp_SCWebGetHRMTPClientNeeds @ClientID,0,'Y',-1                                            
                                            
-- PlanDeliveryStaff 
-- commented by shikha as this sp is now called directly from code behind                                                 
--exec csp_SCGetTreatmentPlanDeliveryStaffList                
              
-- PreviouslyRequested              
exec ssp_SCGetPreviouslyRequestedUMCodeUnits @ClientId,@VersionRecent              
            
-- AddendumNotifications            
exec csp_NewTxPlanAddendumNotifications  @ClientID          
                                                
end                                            
                                            
RETURN(0)                                            
                                         
end try                                            
begin catch                                            
                                            
declare @emsg nvarchar(4000)                                            
                                            
set fmtonly off                                            
                                            
set @emsg = error_message()                                            
raiserror(@emsg, 16, 1)                                            
return 1                         
                                            
                                            
end catch   



GO


