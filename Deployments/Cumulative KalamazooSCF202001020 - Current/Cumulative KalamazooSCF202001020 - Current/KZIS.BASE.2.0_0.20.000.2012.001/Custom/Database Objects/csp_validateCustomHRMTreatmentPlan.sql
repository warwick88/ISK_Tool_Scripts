
/****** Object:  StoredProcedure [dbo].[csp_validateCustomHRMTreatmentPlan]    Script Date: 11/27/2013 18:36:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomHRMTreatmentPlan]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomHRMTreatmentPlan]
GO



/****** Object:  StoredProcedure [dbo].[csp_validateCustomHRMTreatmentPlan]    Script Date: 11/27/2013 18:36:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-----*****************

Create PROCEDURE [dbo].[csp_validateCustomHRMTreatmentPlan]          
@documentVersionId Int        
as          
/*********************************************************************/                                                                                                                                            
/* Stored Procedure: dbo.csp_validateCustomHRMTreatmentPlan */                                                                                                                                            
/* Purpose:   To validate Treatment Plan	*/                                                                                                                                            
/* Input Parameters:   @documentVersionId	*/                                                                                                                                            
/* Output Parameters:   None                */                                                                                                                                            
/*  Date		Author              Purpose          */
/*	4 Jan  2012	Sourabh		        Modified to validate effective end date with ref to task#190(SC Web PhaseII) */	
/*	28 May 2012	Rakesh Garg         Modified w.rf to task 161 in General Implementaion For Kalamazoo Comment validation for Assessment is 90 days old */
/*  16June20102 Rakesh Garg         Comment validation message  Treatment Plan Delivered To Client for Kalamazoo Staff*/	
/*  10/oct/2012 Atul Pandey         Effective date must be 60 days from Periodic Review or Update Assessment Effective date for task #23 of project Allegan CMH Development*/			                  
/*  15/oct/2012 Rachna Singh        Change the validation message and logic for  logic should be if Effective date is same day or within 60 days in the future of the Assessment (Annual or Initial type), then the Treatment Plan can be signed
							        with ref to task #257 in 3.x issues */
/*  22/nov/2012 Atul Pandey         Added validation When client coverage plan is associated to payer type medicare/blue cross than Medical Director to be assigned as a co-signer*/	
/*  19/Dec/2012 Rachna Singh        Change the validation message a/c to logic that 'the meeting date has to be the same day or prior to the effective date'as specified in 
							        task #47 in Allegan Customization Issues Tracking.*/
/*  27/March/2013 Robert Caffrey	Modified by Robert Caffrey for Allegan Customizations Issues Tracking #86 - To allow Signature where Assessment effective date is within 90 days */
/*  14/Nov/2013  Manju P            Modified to remove the validation - Effective date must be 90 days from Periodic Review or Update Assessment Effective date with ref to Allegan - Support task#300 */   
/*  22/dec/2020  Puneeth            What :added isnull recorddeleted condition for the TPProcedures 
									Why  :  KCMHSAS - Support #1607    
	22/dec/2020 Puneeth				what :commented the validations as per the task  KCMHSAS 3.5 Implementation Task #100
	                                since the changes was missing in the Azure copy  */						 
/* ********************************************************************	*/           
        
declare @DocumentId int            
select @DocumentId = DocumentId from documentVersions where documentVersionId = @DocumentVersionId            
--exec scsp_SCvalidateDocument 220381, 206253--, 350              
--Load the document data into a temporary table to prevent multiple seeks on the document table              
CREATE TABLE #TPGeneral              
(              
DocumentVersionId int,              
PlanOrAddendum char(1),              
Participants varchar(max),              
HopesAndDreams varchar(max),              
Barriers varchar(max),               
PurposeOfAddendum varchar(max),              
StrengthsAndPreferences varchar(max),              
AreasOfNeed varchar(max),              
DeferredTreatmentIssues varchar(max),               
PersonsNotPresent varchar(max),              
DischargeCriteria varchar(max),              
PeriodicReviewDueDate datetime,              
PlanDeliveryMethod int,              
ClientAcceptedPlan char(1),              
CrisisPlan varchar(max),              
PlanDeliveredDate datetime,              
StaffId1 int,              
StaffId2 int,              
StaffId3 int,              
StaffId4 int,              
NotificationMessage varchar(max),              
MeetingDate datetime,              
CrisisPlanNotNecessary char(1),              
PeriodicReviewFrequencyNumber int,              
PeriodicReviewFrequencyUnitType varchar(20)              
)              
insert into #TPGeneral              
(              
DocumentVersionId,              
PlanOrAddendum,              
Participants,              
HopesAndDreams,              
Barriers,               
PurposeOfAddendum,              
StrengthsAndPreferences,              
AreasOfNeed,              
DeferredTreatmentIssues,               
PersonsNotPresent,              
DischargeCriteria,              
PeriodicReviewDueDate,              
PlanDeliveryMethod,              
ClientAcceptedPlan,              
CrisisPlan,              
PlanDeliveredDate,              
StaffId1,              
StaffId2,              
StaffId3,              
StaffId4,              
NotificationMessage,              
MeetingDate,              
CrisisPlanNotNecessary ,              
PeriodicReviewFrequencyNumber,              
PeriodicReviewFrequencyUnitType               
)              
              
select              
a.DocumentVersionId,              
a.PlanOrAddendum,              
a.Participants,              
a.HopesAndDreams,              
a.Barriers,               
a.PurposeOfAddendum,              
a.StrengthsAndPreferences,              
a.AreasOfNeed,              
a.DeferredTreatmentIssues,               
a.PersonsNotPresent,              
a.DischargeCriteria,              
a.PeriodicReviewDueDate,              
a.PlanDeliveryMethod,              
a.ClientAcceptedPlan,              
a.CrisisPlan,              
a.PlanDeliveredDate,              
a.StaffId1,              
a.StaffId2,              
a.StaffId3,              
a.StaffId4,              
a.NotificationMessage,              
a.MeetingDate,              
a.CrisisPlanNotNecessary ,              
a.PeriodicReviewFrequencyNumber,              
a.PeriodicReviewFrequencyUnitType               
from TPGeneral a              
where a.DocumentVersionId = @DocumentVersionId              
              
              
          
              
-- Determine Last Assessment Date              
 --DECLARE @AssessmentDate datetime,              
 --DECLARE @ObraDel datetime,              
 DECLARE @Datediff int,              
  @ClientId int,              
  @ProgramId int,               
  @ClientPrimaryProgramId int,              
  @AuthorId int,              
  @EffectiveDate datetime,              
  @AssessmentType char(4),              
  @AssessmentDocumentId int,              
  @AssessmentVersion int             
  --@PRDate datetime,            
  --@IntakeAnnualAssessmentDate datetime               
              
 SELECT @ProgramId = s.PrimaryProgramId,           
  @ClientPrimaryProgramId = cp.ProgramId,              
  @AuthorId = d.AuthorId,              
  @EffectiveDate = dbo.RemoveTimestamp(d.EffectiveDate)              
 FROM Documents d              
 Join Staff s on s.Staffid = d.AuthorId              
 join clients c on c.ClientId = d.ClientId              
 left join ClientPrograms cp on cp.ClientId = c.ClientId               
         and cp.PrimaryAssignment = 'Y'              
         and isnull(cp.RecordDeleted, 'N')= 'N'       
 WHERE d.CurrentDocumentVersionId = @DocumentVersionId              
  AND isnull(d.RecordDeleted, 'N') = 'N'              
  AND isnull(s.RecordDeleted, 'N') = 'N'              
         
 -- Added by sourabh to check Effective End Date can not be before document effective date with ref to task#190        
CREATE TABLE #TPEffectiveEndDate            
(              
 TPProcedureId int,              
 TPInterventionProcedureIdCount int        
)      
       
Insert into  #TPEffectiveEndDate      
  SELECT TPp.TPProcedureId,COUNT(TPI.TPInterventionProcedureId)            
   FROM #TPGeneral t              
   Join TPNeeds TPN on tpn.DocumentVersionId = t.DocumentVersionId              
   LEFT JOIN TPInterventionProcedures TPI on  isnull(TPn.NeedId, 0) = isnull(TPi.NeedId, 0)              
      AND isnull(TPi.RecordDeleted, 'N') = 'N'          
   join TPProcedures TPp on TPp.TPProcedureId= TPI.TPProcedureId                     
  WHERE           
   isnull(tpi.SiteId, -1) not in (-2)              
   AND isnull(TPN.RecordDeleted, 'N') = 'N'              
   AND isnull(tpn.GoalActive, 'N')= 'Y'        
   AND TPp.EffectiveEndDate is not null      
   AND TPp.Inactive='Y' 
   AND ISNULL(TPp.RecordDeleted,'N')='N'     
   AND dbo.Removetimestamp(TPp.EffectiveEndDate) < dbo.Removetimestamp(@EffectiveDate)      
  GROUP BY TPp.TPProcedureId      
--End Here         
            
 SELECT @ClientId = d.ClientId              
 FROM Documents d               
 WHERE d.documentId = @DocumentId              
 AND isnull(d.RecordDeleted, 'N') = 'N'    
 
 --Added by Atul Pandey w.rf.t task #23 (Allegan CMH development) for Assessment is 60 days old
 DECLARE @assessmentDate datetime
 Declare @periodicreview datetime
 declare @AssessmentAnnualInitialDate datetime
  SELECT top 1 @assessmentDate = D.EffectiveDate              
 FROM Documents d   
 inner join CustomHRMAssessments CHA on d.CurrentDocumentVersionId=cha.DocumentVersionId                   
 WHERE d.ClientId = @ClientId  
  AND CHA.AssessmentType='U'            
  AND d.DocumentCodeId in (101,349,1469)        AND d.Status = 22              
  AND isnull(d.RecordDeleted, 'N') = 'N'              
  AND NOT EXISTS (Select 1 FROM Documents d2              
    WHERE d2.ClientId = d.ClientID              
    AND d2.DocumentCodeId in (101, 349,1469)              
    AND d2.Status = 22              
    and ( d2.EffectiveDate > d.EffectiveDate              
     or ( d2.EffectiveDate = d.EffectiveDate and d2.CurrentDocumentVersionId > d.CurrentDocumentVersionId )              
     )              
    AND isnull(d2.RecordDeleted, 'N') = 'N'              
    ) 
    order by d.EffectiveDate desc
    
    
     SELECT top 1 @AssessmentAnnualInitialDate = D.EffectiveDate              
 FROM Documents d   
 inner join CustomHRMAssessments CHA on d.CurrentDocumentVersionId=cha.DocumentVersionId                   
 WHERE d.ClientId = @ClientId  
  AND CHA.AssessmentType in ('A','I')             
  AND d.DocumentCodeId in (101,349,1469)        AND d.Status = 22              
  AND isnull(d.RecordDeleted, 'N') = 'N'              
  AND NOT EXISTS (Select 1 FROM Documents d2              
    WHERE d2.ClientId = d.ClientID              
    AND d2.DocumentCodeId in (101, 349,1469)              
    AND d2.Status = 22              
    and ( d2.EffectiveDate > d.EffectiveDate              
     or ( d2.EffectiveDate = d.EffectiveDate and d2.CurrentDocumentVersionId > d.CurrentDocumentVersionId )              
     )              
    AND isnull(d2.RecordDeleted, 'N') = 'N'              
    ) 
    order by d.EffectiveDate desc
    
    
    
    
    SELECT top 1 @periodicreview = D.EffectiveDate              
 FROM Documents d              
 WHERE d.ClientId = @ClientId              
  AND d.DocumentCodeId =352         AND d.Status = 22              
  AND isnull(d.RecordDeleted, 'N') = 'N'              
  AND NOT EXISTS (Select 1 FROM Documents d2              
    WHERE d2.ClientId = d.ClientID              
    AND d2.DocumentCodeId=352              
    AND d2.Status = 22              
    and ( d2.EffectiveDate > d.EffectiveDate              
     or ( d2.EffectiveDate = d.EffectiveDate and d2.CurrentDocumentVersionId > d.CurrentDocumentVersionId )              
     )              
    AND isnull(d2.RecordDeleted, 'N') = 'N'              
    ) 
    order by d.EffectiveDate desc
    
--------------till here
declare @prDate datetime
 select @prDate = D.EffectiveDate              
 from Documents d              
 where d.ClientId = @ClientId              
 and d.DocumentCodeId in (3,352)            
 and d.Status = 22              
 and isnull(d.RecordDeleted, 'N') = 'N'              
 and not exists (              
  Select 1 from Documents d2              
  where d2.ClientId = d.ClientID              
  and d2.DocumentCodeId in (3, 352)              
  and d2.Status = 22              
  and ( d2.EffectiveDate > d.EffectiveDate              
    or ( d2.EffectiveDate = d.EffectiveDate and d2.CurrentDocumentVersionId > d.CurrentDocumentVersionId )              
   )              
  and isnull(d2.RecordDeleted, 'N') = 'N'              
  )     
 --till here          

--Modified w.rf to task 161 in General Implementaion For Kalamazoo Comment validation for Assessment is 90 days old            
--Find last assessment date of any type              
 ----SELECT @AssessmentDate = D.EffectiveDate              
 ----FROM Documents d              
 ----WHERE d.ClientId = @ClientId              
 ---- AND d.DocumentCodeId in (101,349,1469)        AND d.Status = 22              
 ---- AND isnull(d.RecordDeleted, 'N') = 'N'              
 ---- AND NOT EXISTS (Select 1 FROM Documents d2              
 ----   WHERE d2.ClientId = d.ClientID              
 ----   AND d2.DocumentCodeId in (101, 349,1469)              
 ----   AND d2.Status = 22              
 ----   and ( d2.EffectiveDate > d.EffectiveDate              
 ----    or ( d2.EffectiveDate = d.EffectiveDate and d2.CurrentDocumentVersionId > d.CurrentDocumentVersionId )              
 ----    )              
 ----   AND isnull(d2.RecordDeleted, 'N') = 'N'              
 ----   )   
 --Changes End here           
              
------Find last intake, annual assessment type              
---- SELECT @IntakeAnnualAssessmentDate = D.EffectiveDate              
---- FROM Documents d              
---- Left Join CustomHRMAssessments a on a.DocumentVersionId = d.CurrentDocumentVersionId and isnull(a.RecordDeleted, 'N')= 'N'              
---- WHERE d.ClientId = @ClientId              
----  AND d.DocumentCodeId in (101,349,1469)              
----  AND (d.documentCodeId = 101 or (d.DocumentCodeId in( 349,1469) and a.AssessmentType in ('I', 'A')))   --Only inlclude initial, annual              
----  AND d.Status = 22              
----  AND isnull(d.RecordDeleted, 'N') = 'N'              
----  AND NOT EXISTS (Select 1 FROM Documents d2              
----    Left Join CustomHRMAssessments a2 on a2.DocumentVersionId = d2.CurrentDocumentVersionId and isnull(a2.RecordDeleted, 'N')= 'N'              
----    WHERE d2.ClientId = d.ClientID              
----    AND d2.DocumentCodeId in (101, 349,1469)              
----    AND (d2.documentCodeId = 101 or (d2.DocumentCodeId in( 349,1469) and a2.AssessmentType in ('I', 'A')))   --Only inlclude initial, annual              
----    AND d2.Status = 22              
----    and ( d2.EffectiveDate > d.EffectiveDate              
----or ( d2.EffectiveDate = d.EffectiveDate and d2.CurrentDocumentVersionId > d.CurrentDocumentVersionId )              
----     )              
----    AND isnull(d2.RecordDeleted, 'N') = 'N'              
----    )              
              
 ----Comment the below code as @PRDate used that code is commented.             
 ----select @PRDate = D.EffectiveDate              
 ----from Documents d              
 ----where d.ClientId = @ClientId              
 ----and d.DocumentCodeId in (3,352)            
 ----and d.Status = 22              
 ----and isnull(d.RecordDeleted, 'N') = 'N'              
 ----and not exists (              
 ---- Select 1 from Documents d2              
 ---- where d2.ClientId = d.ClientID              
 ---- and d2.DocumentCodeId in (3, 352)              
 ---- and d2.Status = 22              
 ---- and ( d2.EffectiveDate > d.EffectiveDate              
 ----   or ( d2.EffectiveDate = d.EffectiveDate and d2.CurrentDocumentVersionId > d.CurrentDocumentVersionId )              
 ----  )              
 ---- and isnull(d2.RecordDeleted, 'N') = 'N'              
 ---- )              
 
--------- Changes End here..            
   
                   
Insert into #validationReturnTable              
(TableName,              
ColumnName,              
ErrorMessage              
)              
--This validation returns three fields           
--Field1 = TableName              
--Field2 = ColumnName              
--Field3 = ErrorMessage              
              
SELECT 'TPGeneral', 'PlanOrAddendum', 'General - Plan Or Addendum must be specified.'              
 FROM #TPGeneral              
 WHERE isnull(PlanOrAddendum,'') not in ('A','T')              
              
--moved to standard SAIP approved section              
--union               
--select 'TPGeneral', 'DeletedBy', 'General - Meeting date must be prior to effective date.'              
--FROM #TPGeneral a              
--join documents b on a.DocumentVersionId = b.CurrentDocumentVersionId              
--WHERE dbo.Removetimestamp(a.MeetingDate) > dbo.Removetimestamp(b.EffectiveDate)  --              
              
--    Effective and Meeting Date Validations -- Approved by SAIP (standard for all affiliates)  CHECK!!!            
--UNION              
--select 'TPGeneral', 'DeletedBy', 'General - Meeting date must be prior to or same day as Effective date.'              
--FROM #TPGeneral a             
--join documents b on a.documentId = b.documentId and a.Version = b.CurrentVersion              
--WHERE dbo.Removetimestamp(a.MeetingDate) > dbo.Removetimestamp(b.EffectiveDate)  --              
--union               
--select 'TPGeneral', 'DeletedBy', 'General - Meeting date cannot be in the future.'              
--FROM #TPGeneral a              
--WHERE dbo.Removetimestamp(a.MeetingDate) > dbo.Removetimestamp(getdate())                   
   
  --Commented by Atul Pandey w.rf.t task #23 (Allegan CMH Development.)
              
--UNION              
--select 'TPGeneral', 'MeetingDate', 'General - Meeting date must be specified.'            
-- FROM #TPGeneral              
-- WHERE isnull(MeetingDate,'')=''   

--till here             
union              
SELECT 'TPGeneral', 'Participants', 'General - Participants must be specified.'              
 FROM #TPGeneral              
 WHERE isnull(Participants,'')=''              
UNION              
SELECT 'TPGeneral', 'HopesAndDreams', 'General - Desired Outcomes (Hopes And Dreams) must be specified.'              
 FROM #TPGeneral              
 WHERE isnull(HopesAndDreams,'')=''              
UNION              
SELECT 'TPGeneral', 'PurposeOfAddendum', 'General - Purpose Of Addendum must be specified.'              
 FROM #TPGeneral              
 WHERE PlanOrAddendum = 'A'              
 and isnull(PurposeOfAddendum,'')=''              
/* RJN 09/27/2011 - Removed Strengths and Preferences as this has been removed from the front-end      
UNION              
SELECT 'TPGeneral', 'StrengthsAndPreferences', 'General - Strengths And Preferences must be specified.'              
 FROM #TPGeneral              
 WHERE isnull(StrengthsAndPreferences,'')=''        */      
UNION              
SELECT 'TPGeneral', 'AreasOfNeed', 'General - Areas Of Need must be specified.'              
 FROM #TPGeneral              
 WHERE isnull(AreasOfNeed,'')=''              
UNION              
SELECT 'TPGeneral', 'DeferredTreatmentIssues', 'Summary - Deferred Treatment Issues must be specified.'              
 FROM #TPGeneral              
 WHERE isnull(DeferredTreatmentIssues,'')=''              
UNION              
--SELECT 'TPGeneral', 'PersonsNotPresent', 'PersonsNotPresent must be specified.'              
--UNION              
SELECT 'TPGeneral', 'DischargeCriteria', 'Summary - Discharge / Transition Criteria must be specified.'              
 FROM #TPGeneral              
 WHERE isnull(DischargeCriteria,'')=''              
UNION              
SELECT 'TPGeneral', 'DeletedBy', 'Summary - Periodic Review Frequency must be specified.'              
From #TPGeneral              
where (isnull(PeriodicReviewFrequencyNumber, '')= ''or isnull(PeriodicReviewFrequencyUnitType, '')= '')              
and PlanOrAddendum = 'T'              
              
UNION              
SELECT 'TPGeneral', 'ClientAcceptedPlan', 'Summary - Client Accepted Plan must be specified.'              
from #TPGeneral              
where isnull(ClientAcceptedPlan, '') = ''              
UNION              
SELECT 'TPGeneral', 'CrisisPlan', 'Summary - Crisis Plan must be specified.'              
from #TPGeneral              
where isnull(CrisisPlanNotNecessary, 'N') = 'N'              
 and isnull(CrisisPlan,'')=''              
UNION              
SELECT 'TPGeneral', 'NotificationMessage', 'Notification - Notification Messgage must be specified.'              
 FROM #TPGeneral              
 WHERE (isnull(StaffId1, 0) <> 0 or isnull(StaffId2, 0) <> 0 or isnull(StaffId3, 0) <> 0 or isnull(StaffId4, 0) <> 0)              
 AND isnull(convert(varchar(8000), NotificationMessage), '') = ''              
              
              
              
-- Validate Need Exists              
UNION              
SELECT 'TPGeneral', 'DeletedBy', 'Tx Plan Main - Please specify at least 1 active Goal/Objective/Intervention.'              
 FROM #TPGeneral t              
 WHERE NOT Exists (Select 1 from TPNeeds TPN               
     where TPN.DocumentVersionId = t.DocumentVersionId              
     and isnull(tpn.GoalActive, 'N')= 'Y'              
     AND isnull(TPN.RecordDeleted, 'N') = 'N')              
              
-- Validate Goal Exists for Need              
UNION              
SELECT 'TPGeneral', 'DeletedBy', 'Tx Plan Main - Please specify goal for goal ' + convert(varchar(10), isnull(tpn.NeedNumber, ''))              
 FROM #TPGeneral t              
 Join TPNeeds TPN on tpn.DocumentVersionId = t.DocumentVersionId              
     where NeedNumber is not null              
     AND isnull(convert(varchar(8000), GoalText), '') = ''        
    and isnull(tpn.GoalActive, 'N')= 'Y'              
     AND isnull(TPN.RecordDeleted, 'N') = 'N'              
              
-- Validate target date exists for goal              
UNION              
SELECT 'TPGeneral', 'DeletedBy', 'Tx Plan Main - Please specify target date for goal ' + convert(varchar(10), isnull(tpn.NeedNumber, ''))              
 FROM #TPGeneral t              
 Join TPNeeds TPN on tpn.DocumentVersionId = t.DocumentVersionId              
     where NeedNumber is not null              
     AND GoalTargetDate is null              
     AND isnull(TPN.RecordDeleted, 'N') = 'N'              
   and isnull(tpn.GoalActive, 'N')= 'Y'              
              
              
-- Validate target is greater than the effective date of the document              
--CHECK THIS            
UNION              
SELECT 'TPGeneral', 'DeletedBy', 'Tx Plan Main - Goal ' + convert(varchar(10), isnull(tpn.NeedNumber, '')) + ' target date must be in the future.'              
 FROM #TPGeneral t              
 Join TPNeeds TPN on tpn.DocumentVersionId = t.DocumentVersionId              
     where NeedNumber is not null              
     AND GoalTargetDate <= @EffectiveDate              
     AND isnull(TPN.RecordDeleted, 'N') = 'N'              
   and isnull(tpn.GoalActive, 'N')= 'Y'              
  --CHECK THIS            
UNION              
SELECT 'TPGeneral', 'DeletedBy', 'Tx Plan Main - Goal ' + convert(varchar(10), isnull(tpn.NeedNumber, '')) + ' target date must be within 1 year from effective date.'              
 FROM #TPGeneral t              
 Join TPNeeds TPN on tpn.DocumentVersionId = t.DocumentVersionId              
     where NeedNumber is not null              
     AND dbo.RemoveTimestamp(GoalTargetDate) > dateAdd(yy, 1, @EffectiveDate)              
     AND isnull(TPN.RecordDeleted, 'N') = 'N'              
   and isnull(tpn.GoalActive, 'N')= 'Y'              
              
-- Validate strengths pertinent to goal              
UNION              
SELECT 'TPGeneral', 'DeletedBy', 'Tx Plan Main - Please specify strengths pertinent to goal ' + convert(varchar(10), isnull(tpn.NeedNumber, ''))              
 FROM #TPGeneral t              
 Join TPNeeds TPN on tpn.DocumentVersionId = t.DocumentVersionId              
     where NeedNumber is not null              
     AND isnull(GoalStrengths, '') = ''              
     AND isnull(TPN.RecordDeleted, 'N') = 'N'              
   and isnull(tpn.GoalActive, 'N')= 'Y'              
              
              
/*  */             
-- Validate stage of treatement              
UNION              
SELECT 'TPGeneral', 'DeletedBy', 'Tx Plan Main - Please specify stage of treatment for goal ' + convert(varchar(10), isnull(tpn.NeedNumber, ''))              
 FROM #TPGeneral t              
 Join TPNeeds TPN on tpn.DocumentVersionId = t.DocumentVersionId              
     where NeedNumber is not null              
     AND StageOfTreatment is null              
     AND isnull(TPN.RecordDeleted, 'N') = 'N'              
  and isnull(tpn.GoalActive, 'N')= 'Y'              
             
              
              
-- Validate Need Exists              
UNION              
SELECT 'TPGeneral', 'DeletedBy', 'Tx Plan Main - Please associate at least 1 need for goal ' + convert(varchar(10), isnull(tp.NeedNumber, ''))              
 FROM #TPGeneral t              
 join Documents d on d.CurrentDocumentVersionId = t.DocumentVersionId              
 Join TPNeeds TP on tp.DocumentVersionId = t.DocumentVersionId              
 WHERE NOT Exists (Select 1 from TPNeeds TPN              
     join CustomTPNeedsClientNeeds TPNC on TPNC.NeedId = TPN.NeedID              
     where TPN.DocumentVersionId = t.DocumentVersionId              
    AND TPN.NeedId = TP.NeedId              
     AND isnull(TPN.RecordDeleted, 'N') = 'N'              
     AND isnull(TPNC.Recorddeleted, 'N')= 'N')              
  and exists (select 1 from Documents d2              
     Where d2.ClientId = d.ClientId              
     and d2.DocumentCodeId in (349,1469) --HRM Assessment              
     and d2.EffectiveDate <= d.EffectiveDate              
     and d2.status in (21, 22)              
     and isnull(d2.RecordDeleted, 'N')= 'N')              
and isnull(tp.RecordDeleted,'N')= 'N'              
and isnull(tp.GoalActive, 'N')= 'Y'              
              
              
-- Validate Objective Exists for Need              
UNION              
SELECT 'TPGeneral', 'DeletedBy', 'Tx Plan Main - Please specify objective text for ' + case when  isnull(convert(varchar(10), tpo.ObjectiveNumber), '') <> '' then 'objective ' + convert(varchar(10), isnull(convert(varchar(10), tpo.ObjectiveNumber), '')) 
  
    
       
       
else 'goal ' + convert(varchar(10), isnull(tpn.NeedNumber, '')) end              
 FROM #TPGeneral t              
 Join TPNeeds TPN on tpn.DocumentVersionId = t.DocumentVersionId              
 LEFT JOIN TPObjectives TPO on tpo.DocumentVersionId = t.DocumentVersionId              
     AND isnull(TPN.NeedId, 0) = isnull(TPO.NeedId, 0)              
     AND isnull(TPO.RecordDeleted, 'N') = 'N'              
 WHERE isnull(convert(varchar(8000), ObjectiveText), '') = ''              
 AND isnull(TPN.RecordDeleted, 'N') = 'N'              
and isnull(tpn.GoalActive, 'N')= 'Y'              
              
UNION              
SELECT 'TPGeneral', 'DeletedBy', 'Tx Plan Main - Please specify target date for objective ' + convert(varchar(10), isnull(convert(varchar(10), tpo.ObjectiveNumber), ''))              
 FROM #TPGeneral t              
 Join TPNeeds TPN on tpn.DocumentVersionId = t.DocumentVersionId              
 JOIN TPObjectives TPO on tpo.DocumentVersionId = t.DocumentVersionId              
     AND isnull(TPN.NeedId, 0) = isnull(TPO.NeedId, 0)              
     AND isnull(TPO.RecordDeleted, 'N') = 'N'              
     AND isnull(TPO.ObjectiveStatus, 0) = 191  --Active              
 WHERE tpo.targetdate is null              
 AND isnull(TPN.RecordDeleted, 'N') = 'N'              
 and isnull(tpn.GoalActive, 'N')= 'Y'              
              
UNION              
SELECT 'TPGeneral', 'DeletedBy', 'Tx Plan Main - Objective ' + convert(varchar(10), isnull(convert(varchar(10), tpo.ObjectiveNumber), '')) + ' target date must be in the future.'              
 FROM #TPGeneral t              
 Join TPNeeds TPN on tpn.DocumentVersionId = t.DocumentVersionId             
 JOIN TPObjectives TPO on tpo.DocumentVersionId = t.DocumentVersionId             
     AND isnull(TPN.NeedId, 0) = isnull(TPO.NeedId, 0)              
     AND isnull(TPO.RecordDeleted, 'N') = 'N'              
 AND isnull(TPO.ObjectiveStatus, 0) = 191  --Active              
 WHERE tpo.TargetDate is not null              
 and isnull(tpo.targetdate,'1/1/1900') <= @EffectiveDate              
 AND isnull(TPN.RecordDeleted, 'N') = 'N'              
 and isnull(tpn.GoalActive, 'N')= 'Y'              
              
UNION              
SELECT 'TPGeneral', 'DeletedBy', 'Tx Plan Main - Objective ' + convert(varchar(10), isnull(convert(varchar(10), tpo.ObjectiveNumber), '')) + ' target date must be within 1 year from effective date.'              
 FROM #TPGeneral t              
 Join TPNeeds TPN on tpn.DocumentVersionId = t.DocumentVersionId             
 JOIN TPObjectives TPO on tpo.DocumentVersionId = t.DocumentVersionId             
     AND isnull(TPN.NeedId, 0) = isnull(TPO.NeedId, 0)              
     AND isnull(TPO.RecordDeleted, 'N') = 'N'              
     AND isnull(TPO.ObjectiveStatus, 0) = 191  --Active              
 WHERE tpo.TargetDate is not null              
 and dbo.RemoveTimestamp(tpo.targetdate) > dateAdd(year, 1, @EffectiveDate)              
 AND isnull(TPN.RecordDeleted, 'N') = 'N'              
 and isnull(tpn.GoalActive, 'N')= 'Y'              
              
/**/              
--must have an active objective              
UNION              
SELECT 'TPGeneral', 'DeletedBy', 'Tx Plan Main - Please specify an active objective for goal ' + convert(varchar(10), isnull(convert(varchar(10), tpn.NeedNumber), ''))              
 FROM #TPGeneral t              
 Join TPNeeds TPN on tpn.DocumentVersionId = t.DocumentVersionId             
 WHERE isnull(TPN.RecordDeleted, 'N') = 'N'              
 and isnull(tpn.GoalActive, 'N')= 'Y'              
 and not exists ( select *               
  from TPObjectives TPO               
  where tpo.DocumentVersionId = t.DocumentVersionId               
  AND TPN.NeedId = TPO.NeedId              
  AND isnull(TPO.RecordDeleted,'N')<>'Y'              
  AND isnull(TPO.ObjectiveStatus,0) = 191  --Active              
  )              
----Associate All Objectives            
---CHECK        
      
      
--Commented by Mamta Gupta - Ref Task 433 - 12/Dec/2011 - To add objective has not been assoicated with an intervention in warning message      
            
------union              
------SELECT 'TPGeneral', 'DeletedBy', 'Tx Plan Main - Objective ' + convert(varchar(10), isnull(convert(varchar(10), tpo.ObjectiveNumber), '')) + ' has not been assoicated with an intervention.'              
------ FROM #TPGeneral t              
------ Join TPNeeds TPN on tpn.DocumentVersionId = t.DocumentVersionId             
------ ----adding            
------ --JOIN TPInterventionProcedures TPI on  isnull(TPn.NeedId, 0) = isnull(TPi.NeedId, 0)              
------ --             AND isnull(TPi.RecordDeleted, 'N') = 'N'              
------ --        --end                 
------ JOIN TPObjectives TPO on tpo.DocumentVersionId = t.DocumentVersionId             
------     AND isnull(TPN.NeedId, 0) = isnull(TPO.NeedId, 0)              
------     AND isnull(TPO.RecordDeleted, 'N') = 'N'              
------     AND isnull(TPO.ObjectiveStatus, 0) = 191  --Active             
------ --    --added             
------ --AND isnull(TPi.NeedId, 0) = isnull(TPO.NeedId, 0)             
------ ----end            
------ WHERE tpo.TargetDate is not null              
------ AND isnull(TPN.RecordDeleted, 'N') = 'N'              
------ and isnull(tpn.GoalActive, 'N')= 'Y'              
------ and not exists ( select *               
------  from TPInterventionProcedureObjectives tpiPo              
------  where tpipo.ObjectiveId = tpo.ObjectiveId              
------  and isnull(tpipo.RecordDeleted,'N')<>'Y'              
------  --and tpipo.TPInterventionProcedureId = tpi.TPInterventionProcedureId            
------  )        
      
      
      
      
            
  /*            
select top 100 * from TPInterventionProcedureObjectives order by createddate desc              
  select top 100 * from tpObjectives order by createddate desc            
  */            
--Goal must be active for active objectives              
/**/              
UNION              
SELECT 'TPGeneral', 'DeletedBy', 'Tx Plan Main - Objective ' + convert(varchar(10), isnull(convert(varchar(10), tpo.ObjectiveNumber), '')) + ', Goal ' + convert(varchar(10), isnull(convert(varchar(10), tpn.NeedNumber), ''))+ ' must be active for active objective.'              
 FROM #TPGeneral t              
 Join TPNeeds TPN on tpn.DocumentVersionId = t.DocumentVersionId             
 JOIN TPObjectives TPO on tpo.DocumentVersionId = t.DocumentVersionId             
     AND isnull(TPN.NeedId, 0) = isnull(TPO.NeedId, 0)              
     AND isnull(TPO.RecordDeleted, 'N') = 'N'              
     AND isnull(TPO.ObjectiveStatus, 0) = 191  --Active              
 WHERE isnull(TPN.RecordDeleted, 'N') = 'N'              
 and isnull(tpn.GoalActive, 'N')= 'N'              
              
-- Validate Intervention Exists for Need              
UNION              
SELECT 'TPGeneral', 'DeletedBy', 'Tx Plan Main - Please specify text for intervention ' + isnull(convert(varchar(10), tpi.InterventionNumber), '')     
 FROM #TPGeneral t              
 Join TPNeeds TPN on tpn.DocumentVersionId = t.DocumentVersionId              
 LEFT JOIN TPInterventionProcedures TPI on isnull(TPn.NeedId, 0) = isnull(TPi.NeedId, 0)              
              AND isnull(TPi.RecordDeleted, 'N') = 'N'              
 WHERE isnull(convert(varchar(8000), InterventionText), '') = ''              
 AND isnull(TPN.RecordDeleted, 'N') = 'N'              
 and isnull(tpn.GoalActive, 'N')= 'Y'              
              
UNION              
SELECT 'TPGeneral', 'DeletedBy', 'Tx Plan Main - Please specify provider/procedure for intervention ' + isnull(convert(varchar(10), tpi.InterventionNumber), '')              
 FROM #TPGeneral t              
 Join TPNeeds TPN on tpn.DocumentVersionId = t.DocumentVersionId              
 LEFT JOIN TPInterventionProcedures TPI on  isnull(TPn.NeedId, 0) = isnull(TPi.NeedId, 0)              
              AND isnull(TPi.RecordDeleted, 'N') = 'N'              
 WHERE tpi.authorizationcodeid is null              
 AND isnull(tpi.SiteId, -1) not in (-2)              
 AND isnull(TPN.RecordDeleted, 'N') = 'N'              
 and isnull(tpn.GoalActive, 'N')= 'Y'              
              
-- Added by sourabh to check Effective End Date with ref to task#190      
UNION            
 SELECT 'TPGeneral', 'EffectiveEndDate', 'Tx Plan Main - The date entered for “Inactive” intervention cannot be before the document effective date.'       
 FROM #TPEffectiveEndDate t          
  where t.TPInterventionProcedureIdCount>0        
      
-- End Here       
UNION      
-- Added by sourabh to check Effective End date if InActive is checked with ref to task#190      
 SELECT 'TPGeneral', 'EffectiveEndDate', 'Tx Plan Main - If the “Inactive” checkbox is checked, a date must be entered in the box. '                
   FROM #TPGeneral t              
   Join TPNeeds TPN on tpn.DocumentVersionId = t.DocumentVersionId              
   LEFT JOIN TPInterventionProcedures TPI on  isnull(TPn.NeedId, 0) = isnull(TPi.NeedId, 0)              
      AND isnull(TPi.RecordDeleted, 'N') = 'N'          
   join TPProcedures TPp on TPp.TPProcedureId= TPI.TPProcedureId                     
  WHERE           
   isnull(tpi.SiteId, -1) not in (-2)              
   AND isnull(TPN.RecordDeleted, 'N') = 'N'              
   AND isnull(tpn.GoalActive, 'N')= 'Y'        
   AND TPp.Inactive='Y'      
   AND TPp.EffectiveEndDate is null      
--end here      
                   
              
UNION              
SELECT 'TPGeneral', 'DeletedBy', 'Procedure - Intervention ' + isnull(convert(varchar(10), tpi2.InterventionNumber), '') + ' has not been requested on the Procedure pop up.'               
 FROM #TPGeneral t              
 Join TPNeeds TPN on tpn.DocumentVersionId = t.DocumentVersionId              
 LEFT JOIN TPInterventionProcedures TPI2 on  isnull(TPn.NeedId, 0) = isnull(TPi2.NeedId, 0)              
              AND isnull(TPi2.RecordDeleted, 'N') = 'N'              
  AND isnull(tpi2.SiteId, -1) not in (-2)              
 WHERE exists (select 1 from TPInterventionProcedures TPI               
    where isnull(TPn.NeedId, 0) = isnull(TPi.NeedId, 0)              
            AND isnull(TPi.RecordDeleted, 'N') = 'N'              
    AND StartDate is null              
    AND tpi.TPInterventionProcedureId = tpi2.TPInterventionProcedureId              
    and isnull(tpi.SiteId, -1) not in (-2) --Community/Natural Supports              
     )              
 AND isnull(TPN.RecordDeleted, 'N') = 'N'              
 and isnull(tpn.GoalActive, 'N')= 'Y'     
 
 --Added by Atul Pandey
 /*
  --Commented by Manju P on 14 Nov, 2013 -with ref. to Allegan - Support Task #300
 UNION              
SELECT 'TPGeneral', 'DeletedBy', 'Effective date must be 90 days from Periodic Review or Update Assessment Effective date.'              
 FROM #TPGeneral t              
 JOIN Documents d on t.documentVersionId = D.CurrentdocumentVersionId  
 --Modified by Robert Caffrey for Allegan Customizations Issues Tracking #86 - To allow Signature where Assessment effective date is within 90 days            
 WHERE (DATEDIFF(day, isnull(@AssessmentDate, '01/01/1900'), d.EffectiveDate) < 90   and DATEDIFF(day, isnull(@periodicreview, '01/01/1900'), d.EffectiveDate) < 90   )         
AND isnull(t.planoraddendum, 'X') = 'A'              
 AND isnull(d.RecordDeleted, 'N') <> 'Y'              
 AND d.documentid not in ( select DocumentId from CustomExceptionsAssessmentOverXDaysForTxPlan ) 
 */
 --------
-- union              
--select 'TPGeneral', 'DeletedBy', 'Effective Date must be 90 days from the Annual/Initial Assessment Effective date.'              
--from #TPGeneral t              
--join Documents d on d.CurrentDocumentVersionId = t.DocumentVersionId and isnull(d.RecordDeleted, 'N') = 'N'              
--where 
--isnull(t.planoraddendum, 'X') = 'T'  
----Commented by Rachna Singh
----and DATEDIFF(day, isnull(@AssessmentAnnualInitialDate, '01/01/1900'), d.EffectiveDate) <= 60   
----Added by Rachna Singh
-- --Modified by Robert Caffrey for Allegan Customizations Issues Tracking #86 - To allow Signature where Assessment effective date is within 90 days 
--and DATEDIFF(day, isnull(@AssessmentAnnualInitialDate, '01/01/1900'), d.EffectiveDate) > 90 OR
--DATEDIFF(day, isnull(@AssessmentAnnualInitialDate, '01/01/1900'), d.EffectiveDate) < 0  
----till here  

--Added by Atul Pandey on 22/nov/2012 for task #23 of project Allegan County CMH Development Implementation
union
select 'TPGeneral', 'DeletedBy', 'Client has coverage plan that requires Medical Director be assigned as a co-signer to the plan.'              
where exists
(select 1 from clientcoverageplans ccp
join coverageplans cp on ccp.CoveragePlanId=cp.CoveragePlanId
join payers p on cp.PayerId=p.PayerId
join GlobalCodes gc on gc.GlobalCodeId=p.PayerType 
where ccp.ClientId=@ClientId and  
 gc.GlobalCodeId in ((SELECT GlobalCodeId FROM GlobalCodes WHERE Code='PAYERTYPEBLUECROSSBLUESHIELD' AND Category='PAYERTYPE'),(SELECT GlobalCodeId FROM GlobalCodes WHERE Code='PAYERTYPEMEDICARE' AND Category='PAYERTYPE'))
 )
 and
 not exists (Select 1  
      from Documents d2    
      Join DocumentSignatures ds on ds.DocumentId = d2.DocumentId    
      Join Staff s on s.StaffId = ds.StaffId  
      inner join ClientPrograms  cp
      on    cp.ClientId=@ClientId  
       Where d2.DocumentId = @DocumentId    
      and ds.SignatureOrder > 1 
      and Exists(select 1 from globalcodes where Code in ('DEGREEPHD','DEGREEMD') and Category='DEGREE' and globalcodeid = s.Degree)
      
      )
   --End here   
        
            
--Commented By Rachna Singh w.rf to task #47 in Allegan Customization Issues Tracking  
--union               
--select 'TPGeneral', 'DeletedBy', 'General -Effective Date must be the same date as Meeting Date.'              
--FROM #TPGeneral a              
--join documents b on a.DocumentVersionId = b.CurrentDocumentVersionId              
--WHERE dbo.Removetimestamp(a.MeetingDate) != dbo.Removetimestamp(b.EffectiveDate) 
--Commented By Rachna Singh Till Here              
  
 
 
 --till here         
              
  --ThERE IS NOTHING For associating alll objectives on the popup            
----Below Validation Commented w.rf to task 161 in General Implementaion For Kalamazoo Comment validation for Assessment is 90 days old. As Kalamazoo does n't require this validation               
--UNION              
--SELECT 'TPGeneral', 'DeletedBy', 'Last Assessment document was created more than 90 days ago.  Please create a new Assessment before signing Treatment Plan.'              
-- FROM #TPGeneral t              
-- JOIN Documents d on t.documentVersionId = D.CurrentdocumentVersionId              
-- WHERE DATEDIFF(day, isnull(@AssessmentDate, '01/01/1900'), d.EffectiveDate) > 90              
---- AND @ProgramId in (4) --PD              
-- AND planoraddendum = 'T'              
-- AND isnull(d.RecordDeleted, 'N') <> 'Y'              
-- AND d.documentid not in ( select DocumentId from CustomExceptionsAssessmentOverXDaysForTxPlan ) 
----Changes End here 
                                     
/*            
union              
select 'TPGeneral', 'DeletedBy', 'Last Assessment/Per. Review was created more than 30 days ago.  Please do an Assessment Update or the Per. Review before signing Treatment Plan Addendum.'              
from #TPGeneral t              
join Documents d on d.CurrentDocumentVersionId = t.DocumentVersionId and isnull(d.RecordDeleted, 'N') = 'N'              
where               
----Rule for OBRA              
-- isnull(@ClientPrimaryProgramId, -1) not in ( 16, -- OBRA              
--            46 -- OBRA Screen Only              
--    )               
--and             
isnull(t.planoraddendum, 'X') = 'A'              
and                 
((              
 (select 1 from documents d2              
 where d2.CurrentDocumentVersionId = d.CurrentDocumentVersionId              
 and DATEDIFF(day, isnull(@AssessmentDate, '01/01/1900'), d2.EffectiveDate) > 30              
 and not exists ( select 1 from documents d3              
     where d3.CurrentDocumentVersionId = d.CurrentDocumentVersionId              
     and DATEDIFF(day, isnull(@PRDate, '01/01/1900'), d2.EffectiveDate) < 30 )              
 ) = 1              
or               
 (select 1 from documents d4              
 where d4.CurrentDocumentVersionId = d.CurrentDocumentVersionId              
 and DATEDIFF(day, isnull(@PRDate, '01/01/1900'), d4.EffectiveDate) > 30              
 and not exists ( select 1 from documents d5              
     where d5.CurrentDocumentVersionId = d.CurrentDocumentVersionId              
     and DATEDIFF(day, isnull(@AssessmentDate, '01/01/1900'), d5.EffectiveDate) < 30 )              
 ) = 1              
))              
--and d.DocumentId not in (1136364,1098080,1076139)             
)              
*/            
              
/*            
-- Validate Author is Primary Clinician              
UNION              
SELECT 'TPGeneral', 'DeletedBy', 'Must be primary clinician to sign this document.'              
 FROM #TPGeneral t              
 Join Documents d on d.CurrentDocumentVersionId = t.DocumentVersionId              
 Join Clients c on c.ClientId = d.ClientId              
 Left Join Staff s on s.StaffId = c.PrimaryClinicianId and isnull(s.RecordDeleted, 'N') = 'N'              
 Where d.CurrentDocumentVersionId = @DocumentVersionId               
 and ((isnull(s.PrimaryProgramId, 0) not in (1, 38) and  d.AuthorId <> isnull(s.StaffId, 0) )              
   OR              
  (isnull(s.PrimaryProgramId, 0) = 1 and  d.AuthorId not in (Select s2.staffid from staff s2 where s2.PrimaryProgramId = 1 and isnull(s2.Recorddeleted, 'N') = 'N'))              
   OR              
   (isnull(s.PrimaryProgramId, 0) = 38 and  d.AuthorId not in (Select s3.staffid from staff s3 where s3.PrimaryProgramId = 38 and isnull(s3.Recorddeleted, 'N') = 'N'))              
   )              
 and planoraddendum = 'T'                
 and isnull(d.RecordDeleted, 'N') = 'N'              
 and isnull(c.RecordDeleted, 'N') = 'N'              
*/             

--Commented By Rachna Singh w.rf to task #47 in Allegan Customization Issues Tracking               
--    Effective and Meeting Date Validations -- Approved by SAIP (standard for all affiliates)              
--union               
--select 'TPGeneral', 'DeletedBy', 'General - Meeting date must be prior to effective date.'              
--FROM #TPGeneral a              
--join documents b on a.DocumentVersionId = b.CurrentDocumentVersionId              
--WHERE dbo.Removetimestamp(a.MeetingDate) > dbo.Removetimestamp(b.EffectiveDate)
--Till Here 

--Added By Rachna Singh w.rf to task #47 in Allegan Customization Issues Tracking       
union                 
select 'TPGeneral', 'DeletedBy', 'General -Effective date must be same date or later than Meeting Date.'                
FROM #TPGeneral a                
join documents b on a.DocumentVersionId = b.CurrentDocumentVersionId                
WHERE dbo.Removetimestamp(a.MeetingDate)> dbo.Removetimestamp(b.EffectiveDate) 
--Till Here            
union               
select 'TPGeneral', 'DeletedBy', 'General - Meeting date cannot be in the future.'              
FROM #TPGeneral a              
WHERE dbo.Removetimestamp(a.MeetingDate) > dbo.Removetimestamp(getdate())       
      
--Changes made by Mamta - Ref Task No. 488 - Validation added to check MeetingDate=PlanDeliveredDate      
--union      
--SELECT 'TPGeneral', 'PlanDeliveredDate', 'Summary - Treatment Plan Delivered To Client On must be the same date as Treatment Plan meeting date.'                  
-- FROM #TPGeneral                  
-- WHERE MeetingDate is not null and PlanDeliveredDate is not null and MeetingDate!=PlanDeliveredDate         
            
if @@error <> 0 goto error              
              
--              
--Check to make sure the authorization code on TPInterventionProcedures and TPProcedures match              
--              
If  exists (select * --p.TPProcedureId, d.CurrentDocumentVersionId, d.ModifiedDate, d.CreatedDate, *               
   from TPInterventionProcedures p with(nolock)              
   join TPNeeds n with(nolock)on n.NeedId = p.NeedId              
   Join Documents d with(nolock)on d.CurrentDocumentVersionId = n.DocumentVersionId              
   Where  exists (select * from TPProcedures pr with(nolock)              
                     
       Where pr.TPProcedureId = p.TPProcedureId              
       and pr.DocumentVersionId = d.CurrentDocumentVersionId              
       and pr.AuthorizationCodeId <> p.AuthorizationCodeId              
       and ISNULL(pr.RecordDeleted, 'N')= 'N'              
       )              
              
   and d.CurrentDocumentVersionId = @DocumentVersionId              
   and ISNULL(p.RecordDeleted, 'N')='N'              
   and ISNULL(n.RecordDeleted, 'N')= 'N'              
   and ISNULL(d.Recorddeleted, 'N')= 'N'              
   )              
begin               
              
Insert into CustomBugTracking              
(DocumentVersionId, Description, CreatedDate)              
Values              
(@DocumentVersionId, 'TP intervention procedure associated with incorrect authorization code.', GETDATE())              
              
Insert into #validationReturnTable              
(TableName,              
ColumnName,              
ErrorMessage              
)              
              
Select 'TPGeneral', 'DeletedBy', 'Error occurred. Please contact your system administrator. TP intervention procedure is associated with an incorrect authorization code.'              
              
end              
              
if @@error <> 0 goto error              
return   
              
error:              
RAISERROR ('csp_validateCustomTreatmentPlan failed.  Contact your system administrator.',16,1)  



GO


