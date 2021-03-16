 IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCValidateCarePlans]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_SCValidateCarePlans] 
GO

CREATE PROCEDURE [dbo].[csp_SCValidateCarePlans] --2014965                   
 (@DocumentVersionId INT)    
   

/************************************************************************/                                                              
/* Stored Procedure: csp_SCValidateCarePlans    */                                                     
/* Creation Date:  23-06-2020           */                                                               
/* Purpose: Get Data for the RDL          */                                                             
/* Input Parameters: DocumentVersionId         */                                                            
/* Purpose: Use For Rdl Report           */                                                                                                         
/* Author: Ankita Sinha            */    
/* Modifications                                                        */    
/* ---------------------------------------------------------------------*/    
--06-19-2020 Ankita Sinha  Task#8:

AS    
BEGIN    
 BEGIN TRY    
  -- Declare Variables            
  DECLARE @DocumentType VARCHAR(10)    
  -- Get Registration Date    
        declare @RegistrationDate datetime;       
        select top 1    
   @RegistrationDate = RegistrationDate    
        from    ClientEpisodes    
        where   ClientId = ( select ClientId    
                             from   Documents    
                             where  InProgressDocumentVersionId = @DocumentVersionId    
                           )    
                and isnull(RecordDeleted, 'N') = 'N'    
        order by ModifiedDate desc;     
                    
  -- Get ClientId            
  DECLARE @ClientId INT    
  DECLARE @EffectiveDate DATETIME    
  DECLARE @StaffId INT    
    
  SELECT @ClientId = d.ClientId    
  FROM Documents d    
  WHERE d.InProgressDocumentVersionId = @DocumentVersionId    
    
  SELECT @StaffId = d.AuthorId    
   ,@EffectiveDate = D.EffectiveDate    
  FROM Documents d    
  WHERE d.InProgressDocumentVersionId = @DocumentVersionId    
        
  -------Start ranjeet changes 03/6/2019    
  DECLARE @RecodeId int    
        Set @RecodeId=(SELECT top 1 integercodeid from Recodes R INNER JOIN RecodeCategories RC on RC.RecodeCategoryId = R.RecodeCategoryId Where  RC.CategoryCode='CarePlanEffectiveDateRange' AND ISNULL(RC.RecordDeleted, 'N') = 'N'    
  AND ISNULL(R.RecordDeleted, 'N') = 'N')    
  -------End    
      
  IF ISNULL(@EffectiveDate, '') = ''    
   SET @EffectiveDate = CONVERT(DATETIME, convert(VARCHAR, getdate(), 101))    
    
  CREATE TABLE #ValidationTable (    
   TableName VARCHAR(500)    
   ,ColumnName VARCHAR(500)    
   ,ErrorMessage VARCHAR(MAX)    
   ,TabOrder INT    
   ,ValidationOrder DECIMAL    
   ,GoalNumber DECIMAL    
   )    
    
  INSERT INTO #ValidationTable      
  SELECT 'DocumentCarePlans'    
   ,'CarePlanType'    
   ,'General - General Section-Care Plan Type is required'    
   ,1    
   ,1    
   ,0    
  FROM DocumentCarePlans    
  WHERE DocumentVersionId = @DocumentVersionId    
   AND ISNULL(CarePlanType, '') = ''    
   AND ISNULL(RecordDeleted, 'N') = 'N'    
      
  UNION    
      
  SELECT 'DocumentCarePlans'    
   ,'NameInGoalDescriptions'    
   ,'General - General Section-Client name to be utilized in goal description on plan is required'    
   ,1    
   ,2    
   ,0    
  FROM DocumentCarePlans    
  WHERE DocumentVersionId = @DocumentVersionId    
   AND ISNULL(NameInGoalDescriptions, '') = ''    
   AND ISNULL(RecordDeleted, 'N') = 'N'    
      
  UNION    
      
  SELECT 'DocumentCarePlans'    
   ,'Strengths'    
   ,'General - Strengths section-textbox is required'    
   ,1    
   ,3    
   ,0    
  FROM DocumentCarePlans    
  WHERE DocumentVersionId = @DocumentVersionId    
   AND ISNULL(Strengths, '') = ''    
   AND ISNULL(RecordDeleted, 'N') = 'N'    
      
  UNION    
      
  SELECT 'DocumentCarePlans'    
   ,'Barriers'    
   ,'General - Barriers section-textbox is required'    
   ,1    
   ,4    
   ,0    
  FROM DocumentCarePlans    
  WHERE DocumentVersionId = @DocumentVersionId    
   AND ISNULL(Barriers, '') = ''    
   AND ISNULL(RecordDeleted, 'N') = 'N'    
      
  UNION    
      
  SELECT 'DocumentCarePlans'    
   ,'Abilities'    
   ,'General - Abilities section-textbox is required'    
   ,1    
   ,5    
   ,0    
  FROM DocumentCarePlans    
  WHERE DocumentVersionId = @DocumentVersionId    
   AND ISNULL(Abilities, '') = ''    
   AND ISNULL(RecordDeleted, 'N') = 'N'    
      
  UNION    
      
  SELECT 'DocumentCarePlans'    
   ,'Preferences'    
   ,'General - Preferences section-textbox is required'    
   ,1    
   ,6    
   ,0    
  FROM DocumentCarePlans    
  WHERE DocumentVersionId = @DocumentVersionId    
   AND ISNULL(Preferences, '') = ''    
   AND ISNULL(RecordDeleted, 'N') = 'N'    
      
  UNION    
      
  SELECT 'DocumentCarePlans'    
   ,'LevelOfCare'    
   ,'General - Level of Care section-Level of care (recommendation and justification) is required'    
   ,1    
   ,7    
   ,0    
  FROM DocumentCarePlans    
  WHERE DocumentVersionId = @DocumentVersionId    
   AND ISNULL(LevelOfCare, '') = ''    
   AND ISNULL(RecordDeleted, 'N') = 'N'    
      
  UNION    
      
  SELECT 'DocumentCarePlans'    
   ,'ReductionInSymptoms'    
   ,'General - Level of Care section-Transition/Level of Care/Discharge at least one checkbox selection is required'    
   ,1    
   ,8    
   ,0    
  FROM DocumentCarePlans    
  WHERE DocumentVersionId = @DocumentVersionId    
   AND (    
    ISNULL(ReductionInSymptoms, 'N') = 'N'    
    AND ISNULL(AttainmentOfHigherFunctioning, 'N') = 'N'    
    AND ISNULL(TreatmentNotNecessary, 'N') = 'N'    
    AND ISNULL(OtherTransitionCriteria, 'N') = 'N'   -- Added on 08-Sep-2017 by Irfan     
    )    
   AND ISNULL(RecordDeleted, 'N') = 'N'    
      
  UNION    
      
  SELECT 'DocumentCarePlans'    
   ,'ReductionInSymptomsDescription'    
   ,'General - Level of Care section-Transition/Level of Care/Discharge text box is required'    
   ,1    
   ,9    
   ,0    
  FROM DocumentCarePlans    
  WHERE DocumentVersionId = @DocumentVersionId    
   AND (    
    ISNULL(ReductionInSymptoms, 'N') = 'Y'    
    AND ISNULL(ReductionInSymptomsDescription, '') = ''    
    )    
   AND ISNULL(RecordDeleted, 'N') = 'N'    
      
  UNION    
      
  SELECT 'DocumentCarePlans'    
   ,'AttainmentOfHigherFunctioningDescription'    
   ,'General - Transition/Level of Care/Discharge text box is required'    
   ,1    
   ,10    
   ,0    
  FROM DocumentCarePlans    
  WHERE DocumentVersionId = @DocumentVersionId    
   AND (    
    ISNULL(AttainmentOfHigherFunctioning, 'N') = 'Y'    
    AND ISNULL(AttainmentOfHigherFunctioningDescription, '') = ''    
    )    
   AND ISNULL(RecordDeleted, 'N') = 'N'    
      
  UNION    
      
  SELECT 'DocumentCarePlans'    
   ,'TreatmentNotNecessaryDescription'    
   ,'General - Transition/Level of Care/Discharge text box is required'    
   ,1    
   ,11    
   ,0    
  FROM DocumentCarePlans    
  WHERE DocumentVersionId = @DocumentVersionId    
   AND (    
    ISNULL(TreatmentNotNecessary, 'N') = 'Y'    
    AND ISNULL(TreatmentNotNecessaryDescription, '') = ''    
    )    
   AND ISNULL(RecordDeleted, 'N') = 'N'    
      
    -- Added on 08-Sep-2017 by Irfan                                 
        UNION                 
        SELECT  'DocumentCarePlans'    
        ,       'OtherTransitionCriteriaDescription'    
        ,       'General - Transition/Level of Care/Discharge text box is required'    
        ,       1    
        ,       12    
        ,       0    
        FROM    DocumentCarePlans    
        WHERE   DocumentVersionId = @DocumentVersionId    
                AND ( ISNULL(OtherTransitionCriteria, 'N') = 'Y'    
                      AND ISNULL(OtherTransitionCriteriaDescription, '') = ''    
                    )    
                AND ISNULL(RecordDeleted, 'N') = 'N'    
  UNION    
      
  SELECT 'DocumentCarePlans'    
   ,'EstimatedDischargeDate'    
   ,'General - Estimated discharge date is required'    
   ,1    
   ,13    
   ,0    
  FROM DocumentCarePlans    
  WHERE DocumentVersionId = @DocumentVersionId    
   AND ISNULL(EstimatedDischargeDate, '') = ''    
   AND ISNULL(RecordDeleted, 'N') = 'N'    
      
  UNION    
      
  SELECT 'DocumentCarePlans'    
   ,'EstimatedDischargeDate'    
   ,'General -Transition/Level of Care/ Discharge Plan – Estimated discharge date must be after documents effective date'    
   ,1    
   ,14    
   ,0    
  FROM DocumentCarePlans    
  WHERE DocumentVersionId = @DocumentVersionId    
   AND ISNULL(EstimatedDischargeDate, '') < @EffectiveDate    
   AND ISNULL(RecordDeleted, 'N') = 'N'    
      
  UNION    
      
  SELECT 'DocumentCarePlans'    
   ,'EstimatedDischargeDate'    
   ,'General – Transition/Level of Care/ Discharge Plan – Estimated Discharge Date cannot be in the past'    
   ,1    
   ,15    
   ,0    
  FROM DocumentCarePlans    
  WHERE DocumentVersionId = @DocumentVersionId    
   AND ISNULL(EstimatedDischargeDate, '') < GETDATE()    
   AND ISNULL(RecordDeleted, 'N') = 'N'    
      
  UNION    
      
  SELECT 'Documents'    
   ,'EffectiveDate'    
   ,'Effective date can only go back ' +CONVERT(VARCHAR(10),ISNULL(@RecodeId,14))+ ' days from current date'    
   ,1    
   ,16    
   ,0    
  FROM DocumentCarePlans    
  WHERE DocumentVersionId = @DocumentVersionId    
   AND DATEDIFF(DAY, GETDATE(), @EffectiveDate) < ISNULL(-@RecodeId,-14)    
   AND ISNULL(RecordDeleted, 'N') = 'N'    
        union      
/*      01-09-2015 - Ajay K.Bangar - Task#639:Upon signing the Care Plan check to see if the Care Plan 'Effective Date' is after the 'Registraion Date' of the Episode.   */    
        select  'Documents'    
              , 'EffectiveDate'    
              , 'The Care Plan Effective Date must be after the Episode Registration Date'    
              , 1    
              , 16    
              , 0    
        from    DocumentCarePlans    
        where   DocumentVersionId = @DocumentVersionId    
    and @RegistrationDate > @EffectiveDate    
      
  UNION    
      
  SELECT 'CarePlanNeeds'    
   ,'AddressOnCarePlan'    
   ,'Needs - Domain: '+CPD.DomainName+' – Action Taken is required'    
   ,2    
   ,1    
   ,0    
  FROM CarePlanNeeds CPN    
  LEFT JOIN CarePlanDomainNeeds CPDN ON CPDN.CarePlanDomainNeedId = CPN.CarePlanDomainNeedId    
  LEFT JOIN CarePlanDomains CPD ON CPD.CarePlanDomainId = CPDN.CarePlanDomainId    
  WHERE DocumentVersionId = @DocumentVersionId    
   AND ISNULL(AddressOnCarePlan, '') = ''    
   AND ISNULL(CPN.RecordDeleted, 'N') = 'N'    
   AND ISNULL(CPDN.RecordDeleted, 'N') = 'N'    
   AND ISNULL(CPD.RecordDeleted, 'N') = 'N'    
      
  --UNION    
  --SELECT 'CarePlanNeeds'        
  -- ,'AddressOnCarePlan'        
  -- ,'Needs - Domain: '+CPD.DomainName+' - Deferral Reason is required when Defer is selected as Action Taken'        
  -- ,2        
  -- ,1        
  -- ,0        
  --FROM CarePlanNeeds CPN        
  --LEFT JOIN CarePlanDomainNeeds CPDN ON CPDN.CarePlanDomainNeedId = CPN.CarePlanDomainNeedId        
  --LEFT JOIN CarePlanDomains CPD ON CPD.CarePlanDomainId = CPDN.CarePlanDomainId        
  --WHERE DocumentVersionId = @DocumentVersionId        
  -- AND ISNULL(CPN.DeferralReason, '') = ''        
  -- AND ISNULL(CPN.RecordDeleted, 'N') = 'N'        
  -- AND ISNULL(CPDN.RecordDeleted, 'N') = 'N'        
  -- AND ISNULL(CPD.RecordDeleted, 'N') = 'N'        
  -- AND CPN.AddressOnCarePlan = 'N'      
          
  UNION         



  SELECT 'CarePlanGoals'    
   ,'GoalStartDate'    
   ,'Goals/Objectives - Goal #' + convert(VARCHAR, GoalNumber) + '- Start date is required'    
   ,3    
   ,1    
   ,GoalNumber    
  FROM CarePlanGoals    
  WHERE DocumentVersionId = @DocumentVersionId    
   AND ISNULL(GoalStartDate, '') = ''    
   AND ISNULL(GoalNumber, - 1) <> - 1    
   AND ISNULL(RecordDeleted, 'N') = 'N'    
      
  UNION    
      
  SELECT 'CarePlanGoals'    
   ,'GoalEndDate'    
   ,'Goals/Objectives - Goal #' + convert(VARCHAR, GoalNumber) + '- End date Should be greater than Start date'    
   ,3    
   ,2    
   ,GoalNumber    
  FROM CarePlanGoals    
  WHERE DocumentVersionId = @DocumentVersionId    
   AND ISNULL(GoalStartDate, '') <> ''    
   AND ISNULL(GoalEndDate, '') <> ''    
   AND GoalEndDate < GoalStartDate    
   AND ISNULL(GoalNumber, - 1) <> - 1    
   AND ISNULL(RecordDeleted, 'N') = 'N'    
      
  UNION    
      
  SELECT 'CarePlanGoals'    
   ,'MonitoredByType'    
   ,'Goals/Objectives - Goal #' + convert(VARCHAR, GoalNumber) + '- Staff, Provider or Other is required'    
   ,3    
   ,3    
   ,GoalNumber    
  FROM CarePlanGoals    
  WHERE DocumentVersionId = @DocumentVersionId    
   AND ISNULL(MonitoredByType, '') = ''    
   AND ISNULL(GoalNumber, - 1) <> - 1    
   AND ISNULL(RecordDeleted, 'N') = 'N'    
      
  UNION    
      
  SELECT 'CarePlanGoals'    
   ,'MonitoredByOtherDescription'    
   ,'Goals/Objectives - Goal #' + convert(VARCHAR, GoalNumber) + '- Other textbox is required'    
   ,3    
   ,4    
   ,GoalNumber    
  FROM CarePlanGoals    
  WHERE DocumentVersionId = @DocumentVersionId    
   AND ISNULL(MonitoredByType, '') = 'O'    
   AND ISNULL(MonitoredByOtherDescription, '') = ''    
   AND ISNULL(GoalNumber, - 1) <> - 1    
   AND ISNULL(RecordDeleted, 'N') = 'N'    
      
  UNION    
      
  SELECT 'CarePlanGoals'    
   ,'MonitoredBy'    
   ,'Goals/Objectives - Goal #' + convert(VARCHAR, GoalNumber) + '- Monitored by is required'    
   ,3    
   ,5    
   ,GoalNumber    
  FROM CarePlanGoals    
  WHERE DocumentVersionId = @DocumentVersionId    
   AND ISNULL(MonitoredBy, - 1) = - 1    
   AND ISNULL(GoalNumber, - 1) <> - 1    
   AND ISNULL(RecordDeleted, 'N') = 'N'    
   AND ISNULL(MonitoredByType, '') != 'O'    
      
  UNION    
      
  SELECT 'CarePlanGoals'    
   ,'ClientGoal'    
   ,'Goals/Objectives - Goal #' + convert(VARCHAR, GoalNumber) + '- Client goal (in client’s own words) is required'    
   ,3    
   ,6    
   ,GoalNumber    
  FROM CarePlanGoals    
  WHERE DocumentVersionId = @DocumentVersionId    
   AND ISNULL(ClientGoal, '') = ''    
   AND ISNULL(GoalNumber, - 1) <> - 1    
   AND ISNULL(RecordDeleted, 'N') = 'N'    
      
  UNION    
      
  SELECT 'CarePlanGoalNeeds'    
   ,'CarePlanNeedId'    
   ,'Goals/Objectives - Goal #' + convert(VARCHAR, CG.GoalNumber) + '- Associated Needs is required'    
   ,3    
   ,7    
   ,CG.GoalNumber    
  FROM CarePlanGoals CG    
  WHERE CG.DocumentVersionId = @DocumentVersionId    
   AND (    
    SELECT COUNT(*)    
    FROM CarePlanGoalNeeds CGN    
    WHERE CGN.CarePlanGoalId = CG.CarePlanGoalId    
     --AND ISNULL(CGN.CarePlanNeedId, - 1) = - 1    
     AND ISNULL(CGN.RecordDeleted, 'N') = 'N'    
    ) = 0    
   AND ISNULL(CG.GoalNumber, - 1) <> - 1    
   AND ISNULL(CG.RecordDeleted, 'N') = 'N'    
      
  UNION    
      
  SELECT 'CarePlanGoals'    
   ,'CarePlanDomainGoalId'    
   ,'Goals/Objectives - Goal #' + convert(VARCHAR, CG.GoalNumber) + '- Goals is required'    
   ,3    
   ,8    
   ,CG.GoalNumber    
  FROM CarePlanGoals CG    
  WHERE CG.DocumentVersionId = @DocumentVersionId    
   AND ISNULL(CG.CarePlanDomainGoalId, - 1) = - 1    
   AND ISNULL(CG.GoalNumber, - 1) <> - 1    
   AND ISNULL(CG.RecordDeleted, 'N') = 'N'    
   AND ISNULL(CG.AssociatedGoalDescription,'') = ''    
      
  UNION    
  --Code added by Veena for Care Plan review changes    
      
      
  SELECT 'CarePlanGoals'    
   ,'GoalEndDate'    
   ,'Goals/Objectives - Can not end Goal: Goal  #' + convert(VARCHAR, CG.GoalNumber) + ' as it is newly added'    
   ,3    
   ,13    
   ,CG.GoalNumber    
  FROM CarePlanGoals CG    
  WHERE CG.DocumentVersionId = @DocumentVersionId    
   AND ISNULL(CG.GoalEndDate, '') <> ''    
   AND ISNULL(CG.IsNewGoal,'Y') = 'Y'    
   AND ISNULL(CG.GoalNumber, - 1) <> - 1    
   AND ISNULL(CG.RecordDeleted, 'N') = 'N'    
      
      
  UNION    
      
  SELECT 'CarePlanObjectives'    
   ,'CarePlanGoalId'    
   ,'Goals/Objectives - Goal #' + convert(VARCHAR, CG.GoalNumber) + '- at least one Objective is required'    
   ,3    
   ,9    
   ,CG.GoalNumber    
  FROM CarePlanGoals CG    
  WHERE CG.DocumentVersionId = @DocumentVersionId    
   AND (    
    SELECT COUNT(*)    
    FROM CarePlanObjectives CO    
    WHERE CO.CarePlanGoalId = CG.CarePlanGoalId    
     AND ISNULL(CO.RecordDeleted, 'N') = 'N'    
    ) <= 0    
   AND ISNULL(CG.GoalNumber, - 1) <> - 1    
   AND ISNULL(CG.RecordDeleted, 'N') = 'N'    
       
  UNION    
      
  SELECT 'CarePlanObjectives'    
   ,'ObjectiveStartDate'    
   ,'Goals/Objectives - Objective  #' + convert(VARCHAR, CO.ObjectiveNumber) + '- Objective Text is required'    
   ,3    
   ,10    
   ,CG.GoalNumber    
  FROM CarePlanObjectives CO    
  INNER JOIN CarePlanGoals CG ON CO.CarePlanGoalId = CG.CarePlanGoalId    
  WHERE CG.DocumentVersionId = @DocumentVersionId    
   AND ISNULL(CO.ObjectiveNumber, - 1) <> - 1    
   AND ISNULL(CO.AssociatedObjectiveDescription, '') = ''    
   AND ISNULL(CO.RecordDeleted, 'N') = 'N'    
   AND ISNULL(CG.GoalNumber, - 1) <> - 1    
   AND ISNULL(CG.RecordDeleted, 'N') = 'N'    
   AND CO.CarePlanDomainObjectiveId is null     --Added by Neelima    
      
  UNION    
      
  SELECT 'CarePlanObjectives'    
   ,'ObjectiveStartDate'    
   ,'Goals/Objectives - Objective  #' + convert(VARCHAR, CO.ObjectiveNumber) + '- Start date is required'    
   ,3    
   ,10    
   ,CG.GoalNumber    
  FROM CarePlanObjectives CO    
  INNER JOIN CarePlanGoals CG ON CO.CarePlanGoalId = CG.CarePlanGoalId    
  WHERE CG.DocumentVersionId = @DocumentVersionId    
   AND ISNULL(CO.ObjectiveNumber, - 1) <> - 1    
   AND ISNULL(CO.ObjectiveStartDate, '') = ''    
   AND ISNULL(CO.RecordDeleted, 'N') = 'N'    
   AND ISNULL(CG.GoalNumber, - 1) <> - 1    
   AND ISNULL(CG.RecordDeleted, 'N') = 'N'    
      
  UNION    
      
  SELECT 'CarePlanObjectives'    
   ,'ObjectiveStartDate'    
   ,'Goals/Objectives - Objective  #' + convert(VARCHAR, CO.ObjectiveNumber) + '- Start date should be between Goal start and end date'    
   ,3    
   ,11    
   ,CG.GoalNumber    
  FROM CarePlanObjectives CO    
  INNER JOIN CarePlanGoals CG ON CO.CarePlanGoalId = CG.CarePlanGoalId    
  WHERE CG.DocumentVersionId = @DocumentVersionId    
   AND ISNULL(CO.ObjectiveNumber, - 1) <> - 1    
   AND ISNULL(CO.ObjectiveStartDate, '') <> ''    
   AND (    
    CG.GoalStartDate > CO.ObjectiveStartDate    
    OR (    
     ISNULL(CG.GoalEndDate, '') <> ''    
     AND CO.ObjectiveStartDate > CG.GoalEndDate    
     )    
  )    
   AND ISNULL(CO.RecordDeleted, 'N') = 'N'    
   AND ISNULL(CG.GoalNumber, - 1) <> - 1    
   AND ISNULL(CG.RecordDeleted, 'N') = 'N'    
      
  UNION    
      
  SELECT 'CarePlanObjectives'    
   ,'ObjectiveEndDate'    
   ,'Goals/Objectives - Objective  #' + convert(VARCHAR, CO.ObjectiveNumber) + '- End date is required'    
   ,3    
   ,12    
   ,CG.GoalNumber    
  FROM CarePlanObjectives CO    
  INNER JOIN CarePlanGoals CG ON CO.CarePlanGoalId = CG.CarePlanGoalId    
  WHERE CG.DocumentVersionId = @DocumentVersionId    
   AND ISNULL(CO.ObjectiveNumber, - 1) <> - 1    
   AND ISNULL(CG.GoalEndDate, '') <> ''    
   AND ISNULL(CO.ObjectiveEndDate, '') = ''    
   AND ISNULL(CO.RecordDeleted, 'N') = 'N'    
   AND ISNULL(CG.GoalNumber, - 1) <> - 1    
   AND ISNULL(CG.RecordDeleted, 'N') = 'N'    
      
  UNION    
      
  SELECT 'CarePlanObjectives'    
   ,'ObjectiveEndDate'    
   ,'Goals/Objectives - Objective  #' + convert(VARCHAR, CO.ObjectiveNumber) + '- End date should be greater than start date and less than Goal end date'    
   ,3    
   ,13    
   ,CG.GoalNumber    
  FROM CarePlanObjectives CO    
  INNER JOIN CarePlanGoals CG ON CO.CarePlanGoalId = CG.CarePlanGoalId    
  WHERE CG.DocumentVersionId = @DocumentVersionId    
   AND ISNULL(CO.ObjectiveNumber, - 1) <> - 1    
   AND ISNULL(CO.ObjectiveStartDate, '') <> ''    
   AND ISNULL(CO.ObjectiveEndDate, '') <> ''    
   AND (    
    CO.ObjectiveEndDate < CO.ObjectiveStartDate    
    OR (    
     ISNULL(CG.GoalEndDate, '') <> ''    
     AND CO.ObjectiveEndDate > CG.GoalEndDate    
     )    
    )    
   AND ISNULL(CO.RecordDeleted, 'N') = 'N'    
   AND ISNULL(CG.GoalNumber, - 1) <> - 1    
   AND ISNULL(CG.RecordDeleted, 'N') = 'N'    
      
      
  UNION    
  --code ends for review    
      
  --Code added by Veena for Care Plan review changes    
      
      
  SELECT 'CarePlanObjectives'    
   ,'ObjectiveEndDate'    
   ,'Goals/Objectives - Can not end Objective: Objective  #' + convert(VARCHAR, CO.ObjectiveNumber) + ' as it is newly added'    
   ,3    
   ,13    
   ,CG.GoalNumber    
  FROM CarePlanObjectives CO    
  INNER JOIN CarePlanGoals CG ON CO.CarePlanGoalId = CG.CarePlanGoalId    
  WHERE CG.DocumentVersionId = @DocumentVersionId    
   AND ISNULL(CO.ObjectiveNumber, - 1) <> - 1    
   --AND ISNULL(CO.ObjectiveStartDate, '') <> ''    
   AND ISNULL(CO.ObjectiveEndDate, '') <> ''    
   AND ISNULL(CG.GoalEndDate, '') = ''    
   AND ISNULL(CO.IsNewObjective,'Y') = 'Y'    
   AND ISNULL(CO.RecordDeleted, 'N') = 'N'    
   AND ISNULL(CG.GoalNumber, - 1) <> - 1    
   AND ISNULL(CG.RecordDeleted, 'N') = 'N'    
      
  UNION    
  --code ends for review    
      
  SELECT 'CarePlanObjectives'    
   ,'StaffSupports'    
   ,'Goals/Objectives -  Goal #' + convert(VARCHAR, CG.GoalNumber) + '- Staff Supports/Service Details  is required'    
   ,3    
   ,14    
   ,CG.GoalNumber    
  FROM CarePlanObjectives CO    
  INNER JOIN CarePlanGoals CG ON CO.CarePlanGoalId = CG.CarePlanGoalId    
  WHERE CG.DocumentVersionId = @DocumentVersionId    
   AND ISNULL(CO.ObjectiveNumber, - 1) <> - 1    
   AND ISNULL(CO.StaffSupports, '') = ''    
   AND ISNULL(CO.RecordDeleted, 'N') = 'N'    
   AND ISNULL(CG.GoalNumber, - 1) <> - 1    
   AND ISNULL(CG.RecordDeleted, 'N') = 'N'    
      
  UNION    
      
  SELECT 'CarePlanPrescribedServiceObjectives'    
   ,'CarePlanPrescribedServiceId'    
   ,'Goals/Objectives -  Goal #' + convert(VARCHAR, CG.GoalNumber) + '- Interventions is required'    
   ,3    
   ,15    
   ,CG.GoalNumber    
  FROM CarePlanObjectives CO    
  INNER JOIN CarePlanGoals CG ON CO.CarePlanGoalId = CG.CarePlanGoalId    
  INNER JOIN CarePlanPrescribedServiceObjectives CPO ON CPO.CarePlanObjectiveId = CO.CarePlanObjectiveId    
  WHERE CG.DocumentVersionId = @DocumentVersionId    
   AND ISNULL(CO.ObjectiveNumber, - 1) <> - 1    
   AND ISNULL(CPO.CarePlanPrescribedServiceId, - 1) = - 1    
   AND ISNULL(CO.RecordDeleted, 'N') = 'N'    
   AND ISNULL(CG.GoalNumber, - 1) <> - 1    
   AND ISNULL(CG.RecordDeleted, 'N') = 'N'    
   AND ISNULL(CPO.RecordDeleted, 'N') = 'N'    
      
  UNION    
      
  SELECT 'CarePlanObjectives'    
   ,'MemberActions'    
   ,'Goals/Objectives -  Goal #' + convert(VARCHAR, CG.GoalNumber) + '- Client Action is required'    
   ,3    
   ,16    
   ,CG.GoalNumber    
  FROM CarePlanObjectives CO    
  INNER JOIN CarePlanGoals CG ON CO.CarePlanGoalId = CG.CarePlanGoalId    
  WHERE CG.DocumentVersionId = @DocumentVersionId    
   AND ISNULL(CO.ObjectiveNumber, - 1) <> - 1    
   AND ISNULL(CO.MemberActions, '') = ''    
   AND ISNULL(CO.RecordDeleted, 'N') = 'N'    
   AND ISNULL(CG.GoalNumber, - 1) <> - 1    
   AND ISNULL(CG.RecordDeleted, 'N') = 'N'    
      
  UNION    
      
  SELECT 'CarePlanObjectives'    
   ,'UseOfNaturalSupports'    
   ,'Goals/Objectives -  Goal #' + convert(VARCHAR, CG.GoalNumber) + '- Use of Natural Supports is required'    
   ,3    
   ,17    
   ,CG.GoalNumber    
  FROM CarePlanObjectives CO    
  INNER JOIN CarePlanGoals CG ON CO.CarePlanGoalId = CG.CarePlanGoalId    
  WHERE CG.DocumentVersionId = @DocumentVersionId    
   AND ISNULL(CO.ObjectiveNumber, - 1) <> - 1    
   AND ISNULL(CO.UseOfNaturalSupports, '') = ''    
   AND ISNULL(CO.RecordDeleted, 'N') = 'N'    
   AND ISNULL(CG.GoalNumber, - 1) <> - 1    
   AND ISNULL(CG.RecordDeleted, 'N') = 'N'    
      
  UNION    
      
  SELECT 'CarePlanObjectives'    
   ,'ProgressTowardsObjective'    
   ,'Progress Review -  Objective  #' + convert(VARCHAR, CO.ObjectiveNumber) + '- Rating of progress towards Objective is required'    
   ,3    
   ,18    
   ,CG.GoalNumber    
  FROM CarePlanObjectives CO    
  INNER JOIN CarePlanGoals CG ON CO.CarePlanGoalId = CG.CarePlanGoalId    
  JOIN DocumentCarePlans DP ON CG.DocumentVersionId=DP.DocumentVersionId    
  WHERE CG.DocumentVersionId = @DocumentVersionId    
   AND ISNULL(CO.ObjectiveNumber, - 1) <> - 1    
   AND ISNULL(CO.ProgressTowardsObjective, '') = ''    
   --Added by Veena    
   AND (ISNULL(ObjectiveEndDate, '') <> '' OR (DP.CarePlanType = 'RE' AND ISNULL(dbo.ssf_GetSystemConfigurationKeyValue('SetReviewInCarePlan'),'N') = 'Y'))    
   AND ISNULL(CO.RecordDeleted, 'N') = 'N'    
   AND ISNULL(CG.GoalNumber, - 1) <> - 1    
   AND ISNULL(CG.RecordDeleted, 'N') = 'N'    
      
  UNION    
      
  SELECT 'CarePlanObjectives'    
   ,'ObjectiveReview'    
   ,'Progress Review -  Objective  #' + convert(VARCHAR, CO.ObjectiveNumber) + '- Objective review is required'    
   ,3    
   ,19    
   ,CG.GoalNumber    
  FROM CarePlanObjectives CO    
  INNER JOIN CarePlanGoals CG ON CO.CarePlanGoalId = CG.CarePlanGoalId    
  WHERE CG.DocumentVersionId = @DocumentVersionId    
   AND ISNULL(CO.ObjectiveNumber, - 1) <> - 1    
   AND ISNULL(CO.ObjectiveReview, '') = ''    
   AND ISNULL(ObjectiveEndDate, '') <> ''    
   AND ISNULL(CO.RecordDeleted, 'N') = 'N'    
   AND ISNULL(CG.GoalNumber, - 1) <> - 1    
   AND ISNULL(CG.RecordDeleted, 'N') = 'N'    

   UNION    
  SELECT 'CustomCarePlanPrescribedServices'    
   ,'ProviderId'    
   ,'Interventions - At least one Provider selection is required'    
   ,4    
   ,1    
   ,0 ValidationLogic     
  FROM CustomCarePlanPrescribedServices    
  WHERE DocumentVersionId = @DocumentVersionId    
   AND ISNULL(ProviderId, - 1) = - 1   
   AND ISNULL(Recorddeleted, 'N') = 'N' 
      
  UNION    
  SELECT 'CustomCarePlanPrescribedServices'    
   ,'AuthorizationCodeId'    
   ,'Interventions - At least one Authorization selection is required'    
   ,4    
   ,1    
   ,0 ValidationLogic     
  FROM CustomCarePlanPrescribedServices    
  WHERE DocumentVersionId = @DocumentVersionId    
   AND ISNULL(AuthorizationCodeId, - 1) = - 1   
    AND ISNULL(Recorddeleted, 'N') = 'N' 
   
 UNION    
  SELECT 'CustomCarePlanPrescribedServices'    
   ,'FromDate'    
   ,'Interventions - FromDate is required'    
   ,4    
   ,2    
   ,0 ValidationLogic     
  FROM CustomCarePlanPrescribedServices    
  WHERE DocumentVersionId = @DocumentVersionId    
   AND ISNULL(FromDate, - 1) = -1 
   AND ISNULL(RecordDeleted, 'N') = 'N' 

  UNION    
  SELECT 'CustomCarePlanPrescribedServices'    
   ,'ToDate'    
   ,'Interventions - ToDate is required'    
   ,4    
   ,3    
   ,0 ValidationLogic     
  FROM CustomCarePlanPrescribedServices    
  WHERE DocumentVersionId = @DocumentVersionId    
   AND ISNULL(ToDate, - 1) = -1 
   AND ISNULL(RecordDeleted, 'N') = 'N'

  UNION    
  SELECT 'CustomCarePlanPrescribedServices'    
   ,'Units'    
   ,'Interventions - Units is required'    
   ,4    
   ,4    
   ,0 ValidationLogic     
  FROM CustomCarePlanPrescribedServices    
  WHERE DocumentVersionId = @DocumentVersionId    
   AND ISNULL(Units, - 1) = -1 
   AND ISNULL(RecordDeleted, 'N') = 'N'

   UNION    
  SELECT 'CustomCarePlanPrescribedServices'    
   ,'Frequency'    
   ,'Interventions - Frequency is required'    
   ,4    
   ,5    
   ,0 ValidationLogic     
  FROM CustomCarePlanPrescribedServices    
  WHERE DocumentVersionId = @DocumentVersionId    
   AND ISNULL(Frequency, - 1) = -1 
   AND ISNULL(RecordDeleted, 'N') = 'N'

  --  UNION    
  --SELECT 'CustomCarePlanPrescribedServices'    
  -- ,'PersonResponsible'    
  -- ,'Interventions - PersonResponsible is required'    
  -- ,4    
  -- ,6    
  -- ,0 ValidationLogic     
  --FROM CustomCarePlanPrescribedServices    
  --WHERE DocumentVersionId = @DocumentVersionId    
  -- AND ISNULL(PersonResponsible, - 1) = -1 
  -- AND ISNULL(RecordDeleted, 'N') = 'N'

  -- UNION    
  --SELECT 'CustomCarePlanPrescribedServices'    
  -- ,'Detail'    
  -- ,'Interventions - Detail is required'    
  -- ,4    
  -- ,7    
  -- ,0 ValidationLogic     
  --FROM CustomCarePlanPrescribedServices    
  --WHERE DocumentVersionId = @DocumentVersionId    
  -- AND ISNULL(Detail, '') = ''
  -- AND ISNULL(RecordDeleted, 'N') = 'N'

  --SELECT 'CustomCarePlanPrescribedServices'    
  --  ,'AuthorizationCodeId'    
  --  ,'Interventions - At least one selection is required'    
  --  ,4    
  --  ,1    
  --  ,0 ValidationLogic    
  -- FROM Documents d    
  -- WHERE d.CurrentDocumentVersionId = @DocumentVersionId    
  --  AND NOT EXISTS (    
  --   SELECT 1    
  --   FROM CustomCarePlanPrescribedServices ps    
  --   WHERE ps.DocumentVersionId = @DocumentVersionId AND AuthorizationCodeId IS NULL AND ISNULL(ps.RecordDeleted,'N') = 'N'    
  --   )    
      
  --UNION    
      
  --SELECT 'CarePlanPrescribedServices'    
  -- ,'ObjectiveReview'    
  -- ,'Interventions - How Many sessions for Service Group ' + A.AuthorizationCodeName + ' is required '    
  -- ,4    
  -- ,2    
  -- ,0    
  --FROM CarePlanPrescribedServices CPS    
  --INNER JOIN AuthorizationCodes A ON A.AuthorizationCodeId = CPS.AuthorizationCodeId    
  --WHERE CPS.DocumentVersionId = @DocumentVersionId    
  -- AND A.Active = 'Y'    
  -- AND A.Internal = 'Y'    
  -- AND ISNULL(NumberOfSessions, - 1) = - 1    
  -- AND ISNULL(CPS.AuthorizationCodeId, - 1) <> - 1    
  -- AND ISNULL(CPS.RecordDeleted, 'N') = 'N'    
  -- AND ISNULL(A.RecordDeleted, 'N') = 'N'    
      
  --UNION    
      
  --SELECT 'CarePlanPrescribedServices'    
  -- ,'UnitType'    
  -- ,'Interventions - How Often for Service Group ' + A.AuthorizationCodeName + '  is required '    
  -- ,4    
  -- ,3    
  -- ,0    
  --FROM CarePlanPrescribedServices CPS    
  --INNER JOIN AuthorizationCodes A ON A.AuthorizationCodeId = CPS.AuthorizationCodeId    
  --WHERE CPS.DocumentVersionId = @DocumentVersionId    
  -- AND A.Active = 'Y'    
  -- AND A.Internal = 'Y'      
  -- AND ISNULL(CPS.AuthorizationCodeId, - 1) <> - 1    
  -- AND ISNULL(CPS.UnitType, - 1) = - 1    
  -- AND ISNULL(CPS.RecordDeleted, 'N') = 'N'    
  -- AND ISNULL(A.RecordDeleted, 'N') = 'N'    
         
  --UNION    
        
  --SELECT 'CarePlanPrescribedServices'    
  -- ,'PersonResponsible'    
  -- ,'Interventions - Person Responsible for Service Group ' + A.AuthorizationCodeName + ' is required '    
  -- ,4    
  -- ,4    
  -- ,0    
  --FROM CarePlanPrescribedServices CPS    
  --INNER JOIN AuthorizationCodes A ON A.AuthorizationCodeId = CPS.AuthorizationCodeId    
  --WHERE CPS.DocumentVersionId = @DocumentVersionId    
  -- AND A.Active = 'Y'    
  -- AND A.Internal = 'Y'      
  -- AND ISNULL(CPS.AuthorizationCodeId, - 1) <> - 1    
  -- AND ISNULL(CPS.PersonResponsible, - 1) = - 1    
  -- AND ISNULL(CPS.RecordDeleted, 'N') = 'N'    
  -- AND ISNULL(A.RecordDeleted, 'N') = 'N'      
        
  --UNION    
        
  --SELECT 'CarePlanPrescribedServices'    
  -- ,'Link/Unlink Objectives'    
  -- ,'Interventions - ' + A.AuthorizationCodeName + ' - at least one objective must be associated.'    
  -- ,4    
  -- ,5    
  -- ,0    
  --FROM CarePlanPrescribedServices CPS    
  --INNER JOIN AuthorizationCodes A ON A.AuthorizationCodeId = CPS.AuthorizationCodeId    
  --WHERE CPS.DocumentVersionId = @DocumentVersionId    
  -- AND A.Active = 'Y'    
  -- AND A.Internal = 'Y'      
  -- AND ISNULL(CPS.AuthorizationCodeId, - 1) <> - 1    
  -- AND ISNULL(CPS.RecordDeleted, 'N') = 'N'    
  -- AND ISNULL(A.RecordDeleted, 'N') = 'N'       
  -- AND CarePlanPrescribedServiceId NOT IN(SELECT CarePlanPrescribedServiceId FROM CarePlanPrescribedServiceObjectives CPPSO    
  --                     WHERE CPPSO.CarePlanPrescribedServiceId=CPS.CarePlanPrescribedServiceId AND ISNULL(CPPSO.RecordDeleted,'N')='N')    
           
  --UNION    
        
  --SELECT 'CarePlanPrescribedServices'    
  -- ,'InterventionDetails'    
  -- ,'Interventions - Details for Service Group ' + A.AuthorizationCodeName + ' is required '    
  -- ,4    
  -- ,6    
  -- ,0    
  --FROM CarePlanPrescribedServices CPS    
  --INNER JOIN AuthorizationCodes A ON A.AuthorizationCodeId = CPS.AuthorizationCodeId    
  --WHERE CPS.DocumentVersionId = @DocumentVersionId    
  -- AND A.Active = 'Y'    
  -- AND A.Internal = 'Y'      
  -- AND ISNULL(CPS.AuthorizationCodeId, - 1) <> - 1    
  -- AND ISNULL(CPS.InterventionDetails, '') = ''    
  -- AND ISNULL(CPS.RecordDeleted, 'N') = 'N'    
  -- AND ISNULL(A.RecordDeleted, 'N') = 'N'     
         
  UNION    
      
  SELECT 'DocumentDiagnosisCodes'    
   ,'DocumentDiagnosisCodeId'    
   ,'Diagnosis - Please specify a diagnosis code and description'    
   ,5    
   ,1    
   ,0    
  FROM DocumentDiagnosis DD    
  LEFT JOIN DocumentDiagnosisCodes DDC ON DDC.DocumentVersionId = DD.DocumentVersionId      
  WHERE 0 = (    
    SELECT COUNT(*)    
    FROM DocumentDiagnosis DD    
    JOIN DocumentDiagnosisCodes DDC ON DDC.DocumentVersionId = DD.DocumentVersionId    
    WHERE DD.DocumentVersionId = @DocumentVersionId    
     AND ISNULL(DDC.RecordDeleted, 'N') = 'N'    
     AND ISNULL(DD.RecordDeleted, 'N') = 'N'    
    )    
    AND ISNULL(DD.NoDiagnosis,'N') = 'N' AND DD.DocumentVersionId = @DocumentVersionId    
      
  UNION    
  SELECT 'DocumentDiagnosisCodes'    
   ,'DiagnosisType'    
   ,'Only one primary type should be available'    
   ,5    
   ,2    
   ,0    
  -- FROM CLAUSE NOT REQUIRED    
  WHERE 1 < (    
    SELECT Count(*)    
    FROM DocumentDiagnosisCodes    
    WHERE DocumentVersionId = @DocumentVersionId    
     AND DiagnosisType = 140    
     AND ISNULL(RecordDeleted, 'N') = 'N'    
    )    
   AND NOT EXISTS (    
    SELECT 1    
    FROM DocumentDiagnosis    
    WHERE NoDiagnosis = 'Y'    
     AND DocumentVersionId = @DocumentVersionId    
    )      
  UNION    
  SELECT 'DocumentDiagnosisCodes'    
   ,'DiagnosisType'    
   ,'Primary Diagnosis must have a billing order of 1'    
   ,5    
   ,3    
   ,0    
  -- FROM CLAUSE NOT REQUIRED    
  WHERE EXISTS (    
    SELECT 1    
    FROM DocumentDiagnosisCodes    
    WHERE DocumentVersionId = @DocumentVersionId    
     AND (    
      (    
       DiagnosisOrder <> 1    
       AND DiagnosisType = 140    
       )    
      OR (    
       DiagnosisOrder = 1    
       AND DiagnosisType <> 140    
       )    
      )    
     AND isnull(RecordDeleted, 'N') = 'N'    
     AND NOT EXISTS (    
      SELECT 1    
      FROM DocumentDiagnosis    
      WHERE NoDiagnosis = 'Y'    
       AND DocumentVersionId = @DocumentVersionId    
      )    
    )    
  UNION    
      
  SELECT 'DocumentCarePlans'    
   ,'SupportsInvolvement'    
   ,'Supports/Treatment Program – Supports Involvement is required'    
   ,6    
   ,1    
   ,0    
  FROM DocumentCarePlans    
  WHERE DocumentVersionId = @DocumentVersionId    
   AND ISNULL(SupportsInvolvement, 0) = 0    
   AND ISNULL(RecordDeleted, 'N') = 'N'    
      
  UNION    
      
  SELECT 'DocumentCarePlans'    
   ,'ReviewEntireCarePlanDate'    
   ,'Supports/Treatment Program – Review Entire Care Plan Date must be within 6 months of Effective date'    
   ,6    
   ,2    
   ,0    
  FROM DocumentCarePlans    
  WHERE DocumentVersionId = @DocumentVersionId    
   AND CASE WHEN DATEDIFF(d,@EffectiveDate,ReviewEntireCarePlanDate )>30 THEN DATEDIFF(d,@EffectiveDate,ReviewEntireCarePlanDate)/30.0 ELSE 0 END >=6       
   AND ISNULL(RecordDeleted, 'N') = 'N'    
      
  UNION    
      
  SELECT 'CarePlanPrograms'    
   ,'ProgramId'    
   ,'Treatment Program – Program is required'    
   ,6    
   ,3    
   ,0    
  FROM CarePlanPrograms    
  WHERE DocumentVersionId = @DocumentVersionId    
   AND ISNULL(ProgramId, - 1) = - 1    
   AND ISNULL(RecordDeleted, 'N') = 'N'    
      
  UNION    
      
  SELECT 'CarePlanPrograms'    
   ,'ProgramId'    
   ,'Treatment Program – Staff is required'    
   ,6    
   ,4    
   ,0    
  FROM CarePlanPrograms    
  WHERE DocumentVersionId = @DocumentVersionId    
   AND ISNULL(StaffId, - 1) = - 1    
   AND ISNULL(RecordDeleted, 'N') = 'N'    
      
  UNION    
      
  SELECT 'CarePlanPrograms'    
   ,'ProgramId'    
   ,'Treatment Program – assign for contribution is required'    
   ,6    
   ,5    
   ,0    
  FROM CarePlanPrograms CPP    
  INNER JOIN Staff S ON S.StaffId=CPP.StaffId -- Added Record Deleted check as per task Camino Environment Issue Tracking- 233    
  INNER JOIN Programs P ON CPP.ProgramId = P.ProgramId -- Added on 06/Dec/2016 by Irfan    
  WHERE DocumentVersionId = @DocumentVersionId    
  AND ISNULL(S.RecordDeleted, 'N') = 'N'    
  AND ISNULL(CPP.AssignForContribution, '') = ''    
  AND ISNULL(CPP.RecordDeleted, 'N') = 'N'    
  AND ISNULL(P.RecordDeleted, 'N') = 'N'    
         
  UNION     
      
  SELECT 'DocumentCarePlans'    
   ,'ReviewEntireCareType'    
   ,'Supports/Treatment Program – Review Entire Care Plan is Required'    
   ,6    
   ,6    
   ,0    
  FROM DocumentCarePlans    
  WHERE DocumentVersionId = @DocumentVersionId     
   AND (( ReviewEntireCareType = 'S' AND ISNULl(ReviewEntireCarePlan,'') = '' ) OR  ( ReviewEntireCareType = 'D' AND ISNULl(ReviewEntireCarePlanDate,'') = '' ))    
   AND ISNULL(RecordDeleted, 'N') = 'N'    
    
  UNION     
      
  SELECT 'DocumentCarePlans'    
   ,'ReviewEntireCareType'    
   ,'Supports/Treatment Program – Review Entire Care Plan Date is Required'    
   ,6    
   ,6    
   ,0    
  FROM DocumentCarePlans    
  WHERE DocumentVersionId = @DocumentVersionId     
   AND (( ReviewEntireCareType = 'D'  and CarePlanType = 'RE' AND ISNULl(ReviewEntireCarePlanDate,'') = '' ))    
   AND ISNULL(dbo.ssf_GetSystemConfigurationKeyValue('SetReviewInCarePlan'),'N')='Y' AND ISNULL(RecordDeleted, 'N') = 'N'    
    
  UNION     
      
  SELECT 'DocumentCarePlans'    
   ,'CarePlanReviewComments'    
   ,'Supports/Treatment Program – Review Dates Comments is required for Care Plan Addendum'    
   ,6    
   ,7    
   ,0    
  FROM DocumentCarePlans    
  WHERE DocumentVersionId = @DocumentVersionId    
   AND ISNULL(CarePlanReviewComments, '') = ''    
   AND CarePlanType = 'AD'    
   AND ISNULL(RecordDeleted, 'N') = 'N'    
      
  --IF EXISTS (    
  --  SELECT *    
  --  FROM CarePlanPrescribedServices CPPS    
  --  INNER JOIN DocumentVersions DV ON DV.DocumentVersionId = CPPS.DocumentVersionId    
  --  LEFT JOIN StaffRoles SR ON SR.StaffId = DV.AuthorId    
  --  WHERE CPPS.DocumentVersionId = @DocumentVersionId    
  --   AND ISNULL(CPPS.RecordDeleted, 'N') = 'N'    
  --   AND ISNULL(SR.RecordDeleted, 'N') = 'N'    
  --   AND ISNULL(DV.RecordDeleted, 'N') = 'N'    
  --   AND EXISTS (    
  --    SELECT *    
  --    FROM dbo.ssf_RecodeValuesCurrent('CAREPLAINTERVENTION') AS CD    
  --    WHERE CD.IntegerCodeId = CPPS.AuthorizationCodeId    
  --    )    
  --   AND NOT EXISTS (    
  --    SELECT *    
  --    FROM dbo.ssf_RecodeValuesCurrent('CAREPLAINTERVENTIONROLE') AS CD    
  --    WHERE CD.IntegerCodeId = (SR.RoleId)    
  --    )    
         
  --  )    
        
    
  --BEGIN    
  -- INSERT INTO #ValidationTable    
  -- SELECT 'CarePlanPrescribedServices'    
  --  ,'AutorizationCodeId'    
  --  ,'Intervention – Pharm Management can only be created by Prescriber.'    
  --  ,6    
  --  ,6    
  --  ,0    
  --END    
    
    
    
-- 2015.09.25 gsanborn - Additional codes    
  if object_id('DiagnosisICD10CodeAdditionalCodes', 'U') is not null    
  begin    
   IF EXISTS (    
     SELECT *    
     FROM DiagnosisICD10CodeAdditionalCodes    
     )    
    
   BEGIN    
    INSERT INTO #ValidationTable    
    SELECT 'DiagnosisDocumentCodes'    
     ,'ICD10Code'    
     ,ErrorMessage    
     ,5    
     ,4    
     ,0    
    from dbo.ssf_ValidateICD10AdditionalCodes(@DocumentVersionId)    
   END    
  end    
    
-- 2015.09.25 gsanborn - Exclude codes    
  if object_id('DiagnosisICD10CodeExcludeCodes', 'U') is not null     
  begin    
   IF EXISTS (    
     SELECT *    
     FROM DiagnosisICD10CodeExcludeCodes    
     )    
    
   BEGIN    
    INSERT INTO #ValidationTable    
    SELECT 'DiagnosisDocumentCodes'    
     ,'ICD10Code'    
     ,ErrorMessage    
     ,5    
     ,5    
     ,0    
    from dbo.ssf_ValidateICD10ExcludeCodes(@DocumentVersionId)    
   END    
  end    
      
  -- Added by Neelima    
      
  --IF EXISTS (    
  --SELECT *    
  --FROM sys.objects    
  --WHERE object_id = OBJECT_ID(N'[dbo].[scsp_SCValidationCarePlan]')    
  -- AND type IN (    
  --  N'P'    
  --  ,N'PC'    
  --  )    
  --)    
  -- BEGIN    
  --  exec scsp_SCValidationCarePlan @DocumentVersionId         
  -- END    
  ----    
      
  SELECT TableName    
   ,ColumnName    
   ,ErrorMessage    
   ,TabOrder    
   ,ValidationOrder    
   ,GoalNumber    
  FROM #ValidationTable    
  ORDER BY TabOrder    
   ,ValidationOrder    
             
 END TRY    
    
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)    
    
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_SCValidateCarePlans') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, 
 
 ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())    
    
  RAISERROR (    
    @Error    
    ,-- Message text.                                                                                                              
    16    
    ,-- Severity.                                                                                      
    1 -- State.                                                                                                              
    );    
 END CATCH    
END 