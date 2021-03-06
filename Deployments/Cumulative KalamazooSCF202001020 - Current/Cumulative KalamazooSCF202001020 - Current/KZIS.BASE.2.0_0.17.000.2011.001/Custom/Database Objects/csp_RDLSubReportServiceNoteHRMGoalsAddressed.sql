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
/* Stored Procedure: csp_csp_RDLSubReportServiceNoteHRMGoalsAddressed  */                                             
                                            
/* Copyright: 2008 Streamline SmartCare*/                                                      
                                           
/********************************************************************
Modified by		Modified Date	Reason
avoss			10/05/2010		Fix duplicate goals/objectives in service notes
dharvey			04/05/2011		Added left joins on Service/TPObjectives to return
								goal text even if Objective was not selected.
Vignesh         09/02/2020      What: Modified the logic to display the goals and objective in PDF for new treatment plan document
								Why: KCMHSAS Improvements #13
Neelima         11/10/2020      What: Modified the logic to display the goals and objective in PDF based on DocumentCodeId, since goals are not displaying if TP Addendum is signed.
								Why: KCMHSAS - Support #1555
*/       

DECLARE @ServiceId INT, @ClientId INT, @DateOfService DATETIME, @Documentcodeid INT, @IndividualizedServicePlanDocId int 
  
SELECT @ServiceId = ServiceId, @ClientId=clientid, @DateOfService=EffectiveDate  
FROM documents  
WHERE CurrentDocumentVersionId = @DocumentVersionId  
 AND isnull(RecordDeleted, 'N') = 'N'  
 
 SET @IndividualizedServicePlanDocId=(Select DocumentCodeId from documentcodes where code='8AF7837B-05A7-4DF8-B2ED-6B852A5BA50A') 
  select top 1 @Documentcodeid=documentcodeid             
 from documents             
 where documentcodeid in (350,503,2,@IndividualizedServicePlanDocId)                                   
   and ClientId=@ClientId                    
   and status=22             
   and effectivedate<=convert(datetime,convert(varchar,@DateOfService,101))                                   
   and isnull(RecordDeleted,'N')='N'                                  
 order by effectivedate desc,modifieddate desc  

IF @ServiceId = NULL  
 SET @ServiceId = - 1  

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
ELSE IF (
		@IndividualizedServicePlanDocId = @Documentcodeid 
		)
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
ELSE
BEGIN
	SELECT tpn.NeedNumber AS Goal
		,convert(VARCHAR(max), tpn.GoalText) AS GoalText
		,gc.CodeName AS StageOfTreatment
		,convert(VARCHAR(5), tpo.ObjectiveNumber, 101) AS ObjectiveNumber
		,convert(VARCHAR(max), tpo.ObjectiveText) AS ObjectiveText
	FROM documents AS d
	JOIN DocumentVersions dv ON dv.DocumentId = d.DocumentId
		AND isnull(dv.RecordDeleted, 'N') = 'N'
	JOIN services AS s ON s.ServiceId = d.ServiceId
		AND isnull(s.RecordDeleted, 'N') <> 'Y'
	JOIN serviceGoals AS sg ON sg.ServiceId = d.ServiceId
		AND isnull(sg.RecordDeleted, 'N') <> 'Y'
	--Added Left Join - DJH
	LEFT JOIN serviceObjectives AS so ON so.ServiceId = d.ServiceId
		AND isnull(so.RecordDeleted, 'N') <> 'Y'
	JOIN tpNeeds AS tpn ON tpn.NeedId = sg.NeedId
		AND isnull(tpn.RecordDeleted, 'N') <> 'Y'
	--Added Left Join - DJH
	LEFT JOIN TPObjectives AS tpo ON tpo.ObjectiveId = so.ObjectiveId
		AND tpn.NeedId = tpo.NeedId
		AND isnull(tpo.RecordDeleted, 'N') <> 'Y'
	LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = sg.StageOfTreatment
	LEFT JOIN customHRMServiceNotes AS csn ON csn.DocumentVersionId = dv.DocumentVersionId
		AND isnull(csn.RecordDeleted, 'N') <> 'Y'
	WHERE s.serviceid = @ServiceId
		AND isnull(d.RecordDeleted, 'N') <> 'Y'
	GROUP BY tpn.NeedNumber
		,convert(VARCHAR(max), tpn.GoalText)
		,gc.CodeName
		,convert(VARCHAR(5), tpo.ObjectiveNumber, 101)
		,convert(VARCHAR(max), tpo.ObjectiveText)
	ORDER BY tpn.NeedNumber
		,ObjectiveNumber
END

              
  If (@@error!=0)                                            
  Begin                                            
      RAISERROR  ('csp_RDLSubReportServiceNoteHRMGoalsAddressed : An Error Occured',16,1)                                        
   Return                                            
   End
