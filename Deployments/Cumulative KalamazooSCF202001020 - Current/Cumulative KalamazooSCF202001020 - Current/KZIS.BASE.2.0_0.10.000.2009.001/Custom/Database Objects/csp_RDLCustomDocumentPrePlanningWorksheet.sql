
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'csp_RDLCustomDocumentPrePlanningWorksheet')
BEGIN
	DROP  PROCEDURE csp_RDLCustomDocumentPrePlanningWorksheet
END

GO
CREATE PROCEDURE  [dbo].[csp_RDLCustomDocumentPrePlanningWorksheet] --733272             
(                                                    
	 @DocumentVersionId  INT                                                
)                                                                            
AS  
/*********************************************************************/ 

/* Stored Procedure: [csp_RDLCustomDocumentPrePlanningWorksheet] 2012606			   */                                                                                                                                             
/* Creation Date:   21-05-2020										   */                                                                                                                                                                                                                                                                                                         
/* Input Parameters: @DocumentVersionId									   */                                                                                                                                                                                                                                                                                                                                

/* 21-05-2020    Jyothi Bellapu     What/Why: RDL Sp for Preplan Tab                                */
  /*********************************************************************/ 
 
 BEGIN                          
	BEGIN TRY 
	
    DECLARE @ClientId int 
                               

	SELECT
		--@ClientId AS ClientId,
		DocumentVersionId
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedBy
		,DeletedDate
		, CONVERT(varchar(12),DOB,101) AS  DOB
		,IndividualName
		,CaseNumber
		, CONVERT(varchar(12),DateOfPrePlan,101) AS DateOfPrePlan 
		,DreamsAndDesires
		,HowServicesCanHelp
		,LivingArrangements
		,LivingArragementsComment
		,MyRelationships
		,RelationshipsComment
		,CommunityInvolvment
		,CommunityComment
		,Wellness
		,WellnessComment
		,Education
		,EducationComment
		,Employment
		,EmploymentComment
		,Legal
		,LegalComment
		,Other
		,OtherComment
		,AdditionalComments1
		,PrePlanProcessExplained
		,SelfDExplained
		,WantToExploreSelfD
		,CommentsPCPOrSD
		,ImportantToTalkAbout
		,ImportantToNotTalkAbout
		,WHSIssuesToTalkAbout
		,ServicesToDiscussAtMeeting
		,ServiceProviderOptions
		,PeopleInvitedToMeeting
		,PeopleNotInivtedToMeeting
		,MeetingLocation
		,CONVERT(varchar(12),MeetingDate,101) AS MeetingDate
		,CONVERT(varchar(15),CAST(MeetingTime AS TIME),100) AS MeetingTime
		,UnderstandPersonOfChoice
		,OIFExplained
		,HelpRunMeeting
		,TakeNotesMeeting
		,ChoseNotToParticipate
		,AlternativeManner
		,AdditionalComments2
		,SeparateDocumentRequired
	FROM CustomDocumentPrePlanningWorksheet CDPW 
	Where CDPW.DocumentVersionId=@DocumentVersionId  
		AND ISNULL(CDPW.RecordDeleted,'N') <> 'Y'  
 	
				
	END TRY
  BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)    
    
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLCustomDocumentPrePlanningWorksheet') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())    
    
  RAISERROR (    
    @Error    
    ,-- Message text.    
    16    
    ,-- Severity.    
    1 -- State.    
    );    
 END CATCH    
END  