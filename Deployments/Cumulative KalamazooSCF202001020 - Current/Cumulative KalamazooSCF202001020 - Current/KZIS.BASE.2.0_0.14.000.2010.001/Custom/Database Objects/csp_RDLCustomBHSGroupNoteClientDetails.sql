IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomBHSGroupNoteClientDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomBHSGroupNoteClientDetails]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_RDLCustomBHSGroupNoteClientDetails] --12
(@DocumentVersionId INT)
/*************************************************
  Date:			Author:       Description:                            
  
  -------------------------------------------------------------------------            
 18-Oct-2014    Venkatesh MR      What:Get Client  details
                             Why:task #14 WMU-Enhancements 
************************************************/
  AS 
 BEGIN
DECLARE @Homicidal varchar(200)
Set @Homicidal=''
Set @Homicidal= ISNULL((Select Case when isnull(CG.HomicidalSelf,'') = 'Y' then 'Self' end HomicidalSelf from CustomDocumentBHSClientNotes CG where DocumentVersionid=@DocumentVersionId),'')
Set @Homicidal +=ISNULL((Select Case when isnull(CG.HomicidalOthers,'') = 'Y' and @Homicidal='' then 'Others' when isnull(CG.HomicidalOthers,'') = 'Y' and @Homicidal<>'' then ',Others' end HomicidalOthers from CustomDocumentBHSClientNotes CG where DocumentVersionid=@DocumentVersionId),'')
Set @Homicidal +=ISNULL((Select Case when isnull(CG.HomicidalProperty,'') = 'Y' and @Homicidal='' then 'Property' when isnull(CG.HomicidalProperty,'') = 'Y' and @Homicidal<>'' then ',Property' end HomicidalProperty from CustomDocumentBHSClientNotes CG where DocumentVersionid=@DocumentVersionId),'')
Set @Homicidal +=ISNULL((Select Case when isnull(CG.Homicidalideation,'') = 'Y' and @Homicidal='' then 'Ideation' when isnull(CG.Homicidalideation,'') = 'Y' and @Homicidal<>'' then ',Ideation' end Homicidalideation from CustomDocumentBHSClientNotes CG where DocumentVersionid=@DocumentVersionId),'')
Set @Homicidal +=ISNULL((Select Case when isnull(CG.HomicidalPlan,'') = 'Y' and @Homicidal='' then 'Plan' when isnull(CG.HomicidalPlan,'') = 'Y' and @Homicidal<>'' then ',Plan' end HomicidalPlan from CustomDocumentBHSClientNotes CG where DocumentVersionid=@DocumentVersionId),'')
Set @Homicidal +=ISNULL((Select Case when isnull(CG.HomicidalIntent,'') = 'Y' and @Homicidal='' then 'Intent' when isnull(CG.HomicidalIntent,'') = 'Y' and @Homicidal<>'' then ',Intent' end HomicidalIntent from CustomDocumentBHSClientNotes CG where DocumentVersionid=@DocumentVersionId),'')
Set @Homicidal +=ISNULL((Select Case when isnull(CG.HomicidalAttempt,'') = 'Y'  and @Homicidal='' then 'Attempt' when isnull(CG.HomicidalAttempt,'') = 'Y'  and @Homicidal<>'' then ',Attempt' end HomicidalAttempt from CustomDocumentBHSClientNotes CG where DocumentVersionid=@DocumentVersionId),'')
--Set @Homicidal +=ISNULL((Select Case when isnull(CG.HomicidalOther,'') = 'Y' and @Homicidal='' then 'Other' when isnull(CG.HomicidalOther,'') = 'Y' and @Homicidal<>'' then ',Other' end HomicidalOther from CustomDocumentBHSClientNotes CG where DocumentVersionid=@DocumentVersionId),'')

DECLARE @Attention varchar(200)
Set @Attention=''
Set @Attention= ISNULL((Select Case when isnull(CG.AttentionNormal,'') = 'Y' then 'Normal' end AttentionNormal from CustomDocumentBHSClientNotes CG where DocumentVersionid=@DocumentVersionId),'')
Set @Attention += ISNULL((Select Case when isnull(CG.AttentionInattentive,'') = 'Y' and @Attention='' then 'Inattentive' when isnull(CG.AttentionInattentive,'') = 'Y' and @Attention<>'' then ',Inattentive' end AttentionInattentive from CustomDocumentBHSClientNotes CG where DocumentVersionid=@DocumentVersionId),'')
Set @Attention += ISNULL((Select Case when isnull(CG.AttentionDistractible,'') = 'Y' and @Attention='' then 'Distractible' when isnull(CG.AttentionDistractible,'') = 'Y' and @Attention<>'' then ',Distractible' end AttentionDistractible from CustomDocumentBHSClientNotes CG where DocumentVersionid=@DocumentVersionId),'')
Set @Attention += ISNULL((Select Case when isnull(CG.AttentionConfused,'') = 'Y' and @Attention='' then 'Confused' when isnull(CG.AttentionConfused,'') = 'Y' and @Attention<>'' then ',Confused' end AttentionConfused from CustomDocumentBHSClientNotes CG where DocumentVersionid=@DocumentVersionId),'')

DECLARE @Attitude varchar(200)
SET @Attitude=''
Set @Attitude += ISNULL((Select Case when isnull(CG.AttitudeCooperative,'') = 'Y' then 'Cooperative' end AttitudeCooperative from CustomDocumentBHSClientNotes CG where DocumentVersionid=@DocumentVersionId),'')
Set @Attitude += ISNULL((Select Case when isnull(CG.AttitudeUninterested,'') = 'Y' and @Attitude='' then 'Uninterested' when isnull(CG.AttitudeUninterested,'') = 'Y' and @Attitude<>'' then ',Uninterested' end AttitudeUninterested from CustomDocumentBHSClientNotes CG where DocumentVersionid=@DocumentVersionId),'')
Set @Attitude += ISNULL((Select Case when isnull(CG.AttitudeResistance,'') = 'Y' and @Attitude='' then 'Resistant' when isnull(CG.AttitudeResistance,'') = 'Y' and @Attitude<>'' then ',Resistant' end AttitudeResistance from CustomDocumentBHSClientNotes CG where DocumentVersionid=@DocumentVersionId),'')
Set @Attitude += ISNULL((Select Case when isnull(CG.AttitudeHostile,'') = 'Y' and @Attitude='' then 'Hostile' when isnull(CG.AttitudeHostile,'') = 'Y' and @Attitude<>'' then ',Hostile' end AttitudeHostile from CustomDocumentBHSClientNotes CG where DocumentVersionid=@DocumentVersionId),'')
Set @Attitude += ISNULL((Select Case when isnull(CG.AttitudeIUnremarkable,'') = 'Y' and @Attitude='' then 'Unremarkable' when isnull(CG.AttitudeIUnremarkable,'') = 'Y' and @Attitude<>'' then ',Unremarkable' end AttitudeIUnremarkable from CustomDocumentBHSClientNotes CG where DocumentVersionid=@DocumentVersionId),'')

DECLARE @InterPersonal varchar(200)
set @InterPersonal=''
Set @InterPersonal= ISNULL((Select Case when isnull(CG.InterPersonalShowedEmpathy,'') = 'Y' then 'Showed empathy' end InterPersonalShowedEmpathy from CustomDocumentBHSClientNotes CG where DocumentVersionid=@DocumentVersionId),'')
Set @InterPersonal += ISNULL((Select Case when isnull(CG.InterPersonalEngaged,'') = 'Y' and @InterPersonal='' then 'Engaged in meaningful discussion' when isnull(CG.InterPersonalEngaged,'') = 'Y' and @InterPersonal<>'' then ',Engaged in meaningful discussion' end InterPersonalEngaged from CustomDocumentBHSClientNotes CG where DocumentVersionid=@DocumentVersionId),'')
Set @InterPersonal += ISNULL((Select Case when isnull(CG.InterPersonalProvideHelpfulFeedback,'') = 'Y' and @InterPersonal='' then 'Provided helpful feedback' when isnull(CG.InterPersonalProvideHelpfulFeedback,'') = 'Y' and @InterPersonal<>'' then ',Provided helpful feedback' end InterPersonalProvideHelpfulFeedback from CustomDocumentBHSClientNotes CG where DocumentVersionid=@DocumentVersionId),'')
Set @InterPersonal += ISNULL((Select Case when isnull(CG.InterPersonalAttentionSeeking,'') = 'Y' and @InterPersonal='' then 'Attention seeking' when isnull(CG.InterPersonalAttentionSeeking,'') = 'Y' and @InterPersonal<>'' then ',Attention seeking' end InterPersonalAttentionSeeking from CustomDocumentBHSClientNotes CG where DocumentVersionid=@DocumentVersionId),'')
Set @InterPersonal += ISNULL((Select Case when isnull(CG.InterPersonalDisruptive,'') = 'Y' and @InterPersonal='' then 'Disruptive' when isnull(CG.InterPersonalDisruptive,'') = 'Y' and @InterPersonal<>'' then ',Disruptive' end InterPersonalDisruptive from CustomDocumentBHSClientNotes CG where DocumentVersionid=@DocumentVersionId),'')
Set @InterPersonal += ISNULL((Select Case when isnull(CG.InterPersonalNotRespectiveToOthers,'') = 'Y' and @InterPersonal='' then 'Not respectful to others' when isnull(CG.InterPersonalNotRespectiveToOthers,'') = 'Y' and @InterPersonal<>'' then ',Not respectful to others' end InterPersonalNotRespectiveToOthers from CustomDocumentBHSClientNotes CG where DocumentVersionid=@DocumentVersionId),'')
Set @InterPersonal += ISNULL((Select Case when isnull(CG.InterPersonalNotinvolved,'') = 'Y' and @InterPersonal='' then 'Not involved' when isnull(CG.InterPersonalNotinvolved,'') = 'Y' and @InterPersonal<>'' then ',Not involved' end InterPersonalNotinvolved from CustomDocumentBHSClientNotes CG where DocumentVersionid=@DocumentVersionId),'')
Set @InterPersonal += ISNULL((Select Case when isnull(CG.InterPersonalUnremarkable,'') = 'Y' and @InterPersonal='' then 'Unremarkable' when isnull(CG.InterPersonalUnremarkable,'') = 'Y' and @InterPersonal<>'' then ',Unremarkable' end InterPersonalUnremarkable from CustomDocumentBHSClientNotes CG where DocumentVersionid=@DocumentVersionId),'')

DECLARE @Topicrecovery varchar(200)
set @Topicrecovery=''
Set @Topicrecovery= ISNULL((Select Case when isnull(CG.TopicRecoveryExcellent,'') = 'Y' then 'Excellent' end TopicRecoveryExcellent from CustomDocumentBHSClientNotes CG where DocumentVersionid=@DocumentVersionId),'')
Set @Topicrecovery += ISNULL((Select Case when isnull(CG.TopicRecoveryGood,'') = 'Y' and @Topicrecovery='' then 'Good' when isnull(CG.TopicRecoveryGood,'') = 'Y' and @Topicrecovery<>'' then ',Good' end TopicRecoveryGood from CustomDocumentBHSClientNotes CG where DocumentVersionid=@DocumentVersionId),'')
Set @Topicrecovery += ISNULL((Select Case when isnull(CG.TopicRecoverySatisfactory,'') = 'Y' and @Topicrecovery='' then 'Satisfactory' when isnull(CG.TopicRecoverySatisfactory,'') = 'Y' and @Topicrecovery<>'' then ',Satisfactory' end InterPersonalProvideHelpfulFeedback from CustomDocumentBHSClientNotes CG where DocumentVersionid=@DocumentVersionId),'')
Set @Topicrecovery += ISNULL((Select Case when isnull(CG.TopicRecoveryMarginal,'') = 'Y' and @Topicrecovery='' then 'Marginal' when isnull(CG.TopicRecoveryMarginal,'') = 'Y' and @Topicrecovery<>'' then ',Marginal' end TopicRecoveryMarginal from CustomDocumentBHSClientNotes CG where DocumentVersionid=@DocumentVersionId),'')
Set @Topicrecovery += ISNULL((Select Case when isnull(CG.TopicRecoveryPoor,'') = 'Y' then ',Poor' end TopicRecoveryPoor from CustomDocumentBHSClientNotes CG where DocumentVersionid=@DocumentVersionId),'')

	Begin Try 				
		SELECT  Distinct 
		C.ClientId 
		,C.LastName + ', ' + C.FirstName as ClientName
		,CONVERT(VARCHAR(10), Dv.EffectiveDate, 101)  as EffectiveDate					
		,CONVERT(VARCHAR(10), C.DOB, 101) as DOB		
		,CG.DocumentVersionId
			,CG.CreatedBy
			,CG.CreatedDate
			,CG.ModifiedBy
			,CG.ModifiedDate
			,CG.RecordDeleted
			,CG.DeletedBy
			,CG.DeletedDate
			,CG.BHSGroupNoteId
			--,Case when isnull(CDR.[ClientDeaf],'') = 'Y' then 'ClientDeaf' when isnull(CDR.[ClientDeaf],'') = 'N' then '' else '' end ClientDeaf  
			,Case when isnull(CG.MoodOrAffect,'') = 'Y' then 'Remarkable' when isnull(CG.MoodOrAffect,'') = 'N' then 'Unremarkable' else '' end MoodOrAffect
			,CG.MoodOrAffectComments
			,Case when isnull(CG.ThoughtProcess,'') = 'Y' then 'Remarkable' when isnull(CG.ThoughtProcess,'') = 'N' then 'Unremarkable' else '' end ThoughtProcess
			,CG.ThoughtProcessComments
			,Case when isnull(CG.Behavior,'') = 'Y' then 'Remarkable' when isnull(CG.Behavior,'') = 'N' then 'Unremarkable' else '' end Behavior
			,CG.BehaviorComments
			,Case when isnull(CG.MedicalCondition,'') = 'Y' then 'Remarkable' when isnull(CG.MedicalCondition,'') = 'N' then 'Unremarkable' else '' end MedicalCondition
			,CG.MedicalConditionComments
			,Case when isnull(CG.SubstanceUse,'') = 'Y' then 'Remarkable' when isnull(CG.SubstanceUse,'') = 'N' then 'Unremarkable' else '' end SubstanceUse
			,CG.SubstanceUseComments
			,Case when isnull(CG.HomicidalNoneReportedorDangerTo,'') = 'Y' then 'None Reported' else '' end HomicidalNoneReportedorDangerTo
			,@Homicidal as Homicidal	
			,CG.HomicidalOther		
			,CG.HomicidalOtherComments
			,CG.DocumentResponse
			,Case when isnull(CG.CurrentMedications,'') = 'Y' then 'Yes' when isnull(CG.CurrentMedications,'') = 'N' then 'No' else '' end CurrentMedications
			,CG.CurrentMedicationsComments
			,CG.NumberOfClientsInSession
			,@Attention as 'Attention'
			,@Attitude as 'Attitude' 
			,@InterPersonal as 'InterPersonal'
			,@Topicrecovery as 'Topicrecovery'			
			,CG.GroupDescription
		,SC.OrganizationName
		,DC.DocumentName
		FROM CustomDocumentBHSClientNotes CG	
		Inner Join DocumentS Dv On Dv.CurrentDocumentVersionId = CG.DocumentVersionId 
		Inner Join Clients C on C.ClientId = Dv.ClientId
		Inner join DocumentCodes DC ON DC.DocumentCodeid= Dv.DocumentCodeId  
		cross join SystemConfigurations SC   
		WHERE 				
		ISNULL(CG.RecordDeleted,'N')<>'Y'
		AND ISNULL(Dv.RecordDeleted,'N')<>'Y'
		AND ISNULL(C.RecordDeleted,'N')<>'Y'		
		AND CG.DocumentVersionId = @DocumentVersionId
	End Try
 
  BEGIN CATCH          
   DECLARE @Error varchar(8000)                                                 
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                        
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RDLCustomBHSGroupNoteClientDetails')                                                                               
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                
   + '*****' + Convert(varchar,ERROR_STATE())                                           
   RAISERROR ( @Error, /* Message text.*/16, /* Severity.*/ 1 /*State.*/ );             
 END CATCH          
END

