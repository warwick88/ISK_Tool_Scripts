IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'csp_RDLSubReportServiceNoteHRMGoalsAddressed')
	BEGIN
		DROP  Procedure csp_RDLSubReportServiceNoteHRMGoalsAddressed
		                 
	END
GO
CREATE PROCEDURE [dbo].[csp_RDLSubReportServiceNoteHRMGoalsAddressed]    
(                                            
           
@DocumentVersionId  int 
)                                            
As                                            
                                                    
                                           
/*********************************************************************/                                                      
/* Stored Procedure: csp_csp_RDLSubReportServiceNoteHRMGoalsAddressed   */                                             
                                            
/* Copyright: 2008 Streamline SmartCare*/                                                      
                                           
/********************************************************************
Modified by		Modified Date	Reason
avoss			10/05/2010		Fix duplicate goals/objectives in service notes
dharvey			04/05/2011		Added left joins on Service/TPObjectives to return
								goal text even if Objective was not selected.
Vignesh         09/02/2020      What: Modified the logic to display the goals and objective in PDF for new treatment plan document
								Why: KCMHSAS Improvements #13

*/                                             

IF EXISTS(Select NeedId from tpNeeds where DocumentVersionId=@DocumentVersionId and isnull(RecordDeleted,'N')='N') -- Vignesh modified on 09/02/2020
BEGIN
select 
	tpn.NeedNumber as Goal, 
	convert(varchar(max),tpn.GoalText) as GoalText, 
	gc.CodeName as StageOfTreatment,	
	convert(varchar(5),tpo.ObjectiveNumber,101) as ObjectiveNumber,
	convert(varchar(max),tpo.ObjectiveText) as ObjectiveText
from documents as d
Join DocumentVersions dv on dv.DocumentId=d.DocumentId and isnull(dv.RecordDeleted,'N')='N'
join services as s on s.ServiceId = d.ServiceId and isnull(s.RecordDeleted, 'N')<>'Y'
join serviceGoals as sg on sg.ServiceId = d.ServiceId and isnull(sg.RecordDeleted, 'N')<>'Y'
--Added Left Join - DJH
left join serviceObjectives as so on so.ServiceId = d.ServiceId and isnull(so.RecordDeleted, 'N')<>'Y'
join tpNeeds as tpn on tpn.NeedId = sg.NeedId and isnull(tpn.RecordDeleted, 'N')<>'Y'
--Added Left Join - DJH
left join TPObjectives as tpo on tpo.ObjectiveId = so.ObjectiveId and tpn.NeedId = tpo.NeedId and isnull(tpo.RecordDeleted, 'N')<>'Y'
left join GlobalCodes gc on gc.GlobalCodeId = sg.StageOfTreatment
left join customHRMServiceNotes  as csn on csn.DocumentVersionId = dv.DocumentVersionId   
	and isnull(csn.RecordDeleted, 'N')<>'Y'
where dv.DocumentVersionId = @DocumentVersionId  
and isnull(d.RecordDeleted, 'N')<>'Y'
group by 
	tpn.NeedNumber, 
	convert(varchar(max),tpn.GoalText), 
	gc.CodeName,	
	convert(varchar(5),tpo.ObjectiveNumber,101),
	convert(varchar(max),tpo.ObjectiveText)
order by tpn.NeedNumber, ObjectiveNumber
END
/*-- Vignesh modified on 09/02/2020*/
ELSE   
BEGIN
     Select CPG.GoalNumber as Goal,
     CPG.ClientGoal as GoalText,
     gc.CodeName as StageOfTreatment,  
     CPO.ObjectiveNumber as ObjectiveNumber,
     CPO.[AssociatedObjectiveDescription] AS  ObjectiveText 
      from documents as d  
     Join DocumentVersions dv on dv.DocumentId=d.DocumentId and isnull(dv.RecordDeleted,'N')='N'  
     join services as s on s.ServiceId = d.ServiceId and isnull(s.RecordDeleted, 'N')<>'Y'  
     join serviceGoals as sg on sg.ServiceId = d.ServiceId and isnull(sg.RecordDeleted, 'N')<>'Y'  
     --Added Left Join - DJH  
     left join serviceObjectives as so on so.ServiceId = d.ServiceId and isnull(so.RecordDeleted, 'N')<>'Y' 
     join [CarePlanGoals] CPG on CPG.CarePlanGoalId=sg.NeedId
     --left JOIN serviceObjectives SO on SO.serviceid=sg.serviceid 
     left JOIN CarePlanObjectives CPO on CPO.CarePlanGoalId=CPG.CarePlanGoalId and ObjectiveId=CarePlanObjectiveId and ISNULL(CPO.RecordDeleted,'N')='N'
     left join GlobalCodes gc on gc.GlobalCodeId = sg.StageOfTreatment 
     --where sg.serviceid=778354
     where dv.DocumentVersionId = @DocumentVersionId   
      AND ISNULL(sg.RecordDeleted,'N')='N'
      group by   
      CPG.GoalNumber,   
      CPG.ClientGoal,   
      gc.CodeName,   
      CPO.ObjectiveNumber,  
      CPO.[AssociatedObjectiveDescription] 
     order by CPG.GoalNumber, CPO.ObjectiveNumber 
END
/*-- Vignesh modified on 09/02/2020*/
              
  If (@@error!=0)                                            
  Begin                                            
      RAISERROR  ('csp_RDLSubReportServiceNoteHRMGoalsAddressed : An Error Occured',16,1)                                        
   Return                                            
   End
