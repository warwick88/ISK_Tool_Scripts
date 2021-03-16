/****** Object:  StoredProcedure [dbo].[csp_validateCustomDocumentDischarges]    Script Date: 5/11/2017 10:32:20 AM ******/

IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[csp_validateCustomDocumentDischarges]')
                    AND type IN ( N'P', N'PC' ) )
Begin
DROP PROCEDURE [dbo].[csp_validateCustomDocumentDischarges] 
END
GO

/****** Object:  StoredProcedure [dbo].[csp_validateCustomDocumentDischarges]    Script Date: 5/11/2017 10:32:20 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[csp_validateCustomDocumentDischarges] 
    @DocumentVersionId INT
AS /******************************************************************************                                          
**  File: [csp_validateCustomDocumentDischarges]                                      
**  Name: [csp_validateCustomDocumentDischarges]                  
**  Desc: For Validation  on Discharges
**  Return values: Resultset having validation messages                                          
**  Called by:                                           
**  Parameters:                      
**  Auth:  Anto                        
**  Date:  FEB 18 2015 
27-08-2015 Pabitra    Added validations for VCPT-44      
**   16-September-2015  jcarlson	 changed validation logic Valley CATI 440  
**  28-Septmeber-2015 jcarlson	 changed validation logic Valley CATI 440        
** 10/19/2015 jcarlson added missing record deleted checks and changed use of recodes to use the dbo.ssf_Recode... function as  well as modified logic for Care Plan validations      
** 12/8/2015  jcarlson added commerical care plan to the following validations, a care plan or commercial care plan must exist
**                         General – Program Actions - Must close all goals and objectives before you can do Agency Discharge
							General – Program Actions – All Care Plans/Treatment Plans need to becompleted prior to Agency Discharge
** 02/29/2016 gsanborn	Task # 260, Valley Support GoLive 
**						Modified the logic for @ClosedSUAdmission to count SUD Discharge on same day as SUD Admission as a Closed SU Episode when 
**						. CustomDocumentSUAdmissions.AdmittedPopulation (via GlobalCodes.Code) in (20, 21) OR
**						. SUD Admission and Discharge documents were migrated from legacy system (CreatedBy = 'StdDataConversion').
** 03/15/2016 gsanborn	Task # 260, Valley Support GoLive
**						Set @ClosedSUAdmission = Y (pass the validation) when the DischargeType is P (program) and the 
**						open SUD Admission ProgramId is not one of the programs being discharged.
** 04/18/2016 gsanborn	Task # 260, Valley Support GoLive
**						. Add RecordDeleted checks in 03/15/16 modifications.
** 04/22/2016 gsanborn	Task # 260, Valley Support GoLive
**						. Add check for DischargeType and Status (do not validate against previously-discharged programs even if they are still listed
**						  in CustomDischargePrograms for discharge under this DocumentVersionId; this may be a bug in the screen.)
** 05/09/2016 Shaik.Irfan Task# 562 Valley Support GoLive
						. Commented the following validations to close the validations on Agency Discharge
						1.  Must close all goals and objectives before you can do an Agency Discharge 
						2.  All Care Plans/Tx plans need to be completed prior to Agency Discharge. 
* 05/12/2016 SuryaBalan  Valley - Support Go Live #401 Added Documentcodes(DSM 5 Diagnosis,Assessment,Med Note,Nurse Note,Care Plan,Commercial Assessment) for "The diagnosis document must be signed and completed before 
						discharging the client from the agency" Validation.
                        Apart from Discharge -Diagnosis, we need to check other document-diagnosis also, that is the requirement mentioned in the task
  8/8/16                jwheeler -- task 401 Check for documentcode.diagnosisdocument='Y' instead of static documentcodeids for Diagnosis Document Validation Check.
  5/11/2017             Robert Caffrey - Valley Support #628 - Added Validations for furure Scheduled Service (Agency and Program)
  7/20/2017             Hemant       Removed select 1 statement.Valley - Support Go Live #1266
  11/10/2020            Mrunali      What : Added new validation Why: KCMHSAS Improvements #19
12/10/2020              Princes      What : Removed validation '"General- Program Actions- Staff Person discharging must be associated with clients primary program"'.KCMHSAS Build Cycle Tasks #126
*******************************************************************************/
    BEGIN
        BEGIN TRY     
                
            --*TABLE CREATE*--                       
            --DECLARE  @CustomDocumentSUAdmissions TABLE(     
            DECLARE @CustomDocumentDischarge TABLE
                (
                 DocumentVersionId INT NOT NULL
                ,RecordDeleted type_YOrN NULL
                ,DeletedBy type_UserId NULL
                ,DeletedDate DATETIME NULL
                ,NewPrimaryClientProgramId INT NULL
                ,DischargeType CHAR(1) NULL
                ,TransitionDischarge type_GlobalCode NULL
                ,DischargeDetails VARCHAR(MAX) NULL
                ,OverallProgress VARCHAR(MAX) NULL
                ,StatusLastContact VARCHAR(MAX) NULL
                ,EducationLevel type_GlobalCode NULL
                ,MaritalStatus type_GlobalCode NULL
                ,EducationStatus type_GlobalCode NULL
                ,EmploymentStatus type_GlobalCode NULL
                ,ForensicCourtOrdered type_GlobalCode NULL
                ,CurrentlyServingMilitary type_GlobalCode NULL
                ,Legal type_GlobalCode NULL
                ,JusticeSystem type_GlobalCode NULL
                ,LivingArrangement type_GlobalCode NULL
                ,Arrests VARCHAR(20) NULL
                ,AdvanceDirective type_GlobalCode NULL
                ,TobaccoUse type_GlobalCode NULL
                ,AgeOfFirstTobaccoUse VARCHAR(20) NULL
                ,CountyResidence type_GlobalCode NULL
                ,CountyFinancialResponsibility type_GlobalCode NULL
                ,NoReferral type_YOrN NULL
                ,SymptomsReoccur VARCHAR(MAX) NULL
                ,ReferredTo VARCHAR(MAX) NULL
                ,Reason VARCHAR(MAX) NULL
                ,DatesTimes VARCHAR(MAX) NULL
                ,ReferralDischarge type_GlobalCode NULL
                ,Treatmentcompletion type_GlobalCode NULL
                );              
              
            --*INSERT LIST*--                
            INSERT  INTO @CustomDocumentDischarge
                    (DocumentVersionId
                    ,RecordDeleted
                    ,DeletedBy
                    ,DeletedDate
                    ,NewPrimaryClientProgramId
                    ,DischargeType
                    ,TransitionDischarge
                    ,DischargeDetails
                    ,OverallProgress
                    ,StatusLastContact
                    ,EducationLevel
                    ,MaritalStatus
                    ,EducationStatus
                    ,EmploymentStatus
                    ,ForensicCourtOrdered
                    ,CurrentlyServingMilitary
                    ,Legal
                    ,JusticeSystem
                    ,LivingArrangement
                    ,Arrests
                    ,AdvanceDirective
                    ,TobaccoUse
                    ,AgeOfFirstTobaccoUse
                    ,CountyResidence
                    ,CountyFinancialResponsibility
                    ,NoReferral
                    ,SymptomsReoccur
                    ,ReferredTo
                    ,Reason
                    ,DatesTimes
                    ,ReferralDischarge
                    ,Treatmentcompletion
                    )
             
                   --*Select LIST*--                  
                    SELECT  DocumentVersionId
                    ,       RecordDeleted
                    ,       DeletedBy
                    ,       DeletedDate
                    ,       NewPrimaryClientProgramId
                    ,       DischargeType
                    ,       TransitionDischarge
                    ,       DischargeDetails
                    ,       OverallProgress
                    ,       StatusLastContact
                    ,       EducationLevel
                    ,       MaritalStatus
                    ,       EducationStatus
                    ,       EmploymentStatus
                    ,       ForensicCourtOrdered
                    ,       CurrentlyServingMilitary
                    ,       Legal
                    ,       JusticeSystem
                    ,       LivingArrangement
                    ,       Arrests
                    ,       AdvanceDirective
                    ,       TobaccoUse
                    ,       AgeOfFirstTobaccoUse
                    ,       CountyResidence
                    ,       CountyFinancialResponsibility
                    ,       NoReferral
                    ,       SymptomsReoccur
                    ,       ReferredTo
                    ,       Reason
                    ,       DatesTimes
                    ,       ReferralDischarge
                    ,       TreatmentCompletion
                    FROM    dbo.CustomDocumentDischarges C
                    WHERE   C.DocumentVersionId = @DocumentVersionId
                            AND ISNULL(C.RecordDeleted, 'N') <> 'Y';
                     
            DECLARE @ClientId INT;
            DECLARE @EffectiveDate DATETIME

            SELECT  @ClientId = ClientId
            ,       @EffectiveDate = EffectiveDate
            FROM    Documents
            WHERE   InProgressDocumentVersionId = @DocumentVersionId
                    AND ISNULL(RecordDeleted, 'N') = 'N';
              
            DECLARE @Programcount INT;
            DECLARE @PrimaryProgramcount INT;
            
            SELECT  @Programcount = COUNT(*)
            FROM    ClientPrograms
            WHERE   ClientId = @ClientId
                    AND [Status] IN ( 4, 1 )
                    AND ISNULL(RecordDeleted, 'N') = 'N';
              
            IF ( @Programcount = 1 )
                BEGIN
                    BEGIN
                        SELECT  @PrimaryProgramcount = COUNT(*)
                        FROM    ClientPrograms
                        WHERE   ClientId = @ClientId
                                AND PrimaryAssignment = 'Y'
                                AND ISNULL(RecordDeleted, 'N') = 'N';
                    END;
                END;
                
            DECLARE @Discharge CHAR(2) = '';
            DECLARE @Count INT;
            
            SELECT  @Count = COUNT(*)
            FROM    CustomDischargePrograms
            WHERE   DocumentVersionId = @DocumentVersionId
                    AND RecordDeleted = 'N';
              
            IF ( @Count >= 1 )
                BEGIN
                    SET @Discharge = 'D';
                END;

                
            DECLARE @SUAdmissionDocumentVersionID INT;
            DECLARE @SUDischargeDocumentVersionId INT;							-- 02/29/16
            DECLARE @ClosedSUAdmission CHAR(1) = 'N';							-- 02/29/16
            DECLARE @SUAdmissionProgramId INT;									-- 03/15/16

			-- 02/29/16 most recent signed SUD Admission doc ...
            SELECT TOP 1
                    @SUAdmissionDocumentVersionID = CurrentDocumentVersionId
            FROM    Documents d
            WHERE   d.ClientId = @ClientId
                    AND d.[Status] = 22 --signed
                    AND d.DocumentCodeId = 46222
                    AND ISNULL(d.RecordDeleted, 'N') = 'N'
                    AND NOT EXISTS ( --needed? looks for most recent document
                    SELECT  1
                    FROM    Documents AS d2
                    WHERE   d2.ClientId = d.ClientId
                            AND d2.DocumentCodeId = d.DocumentCodeId
                            AND d2.[Status] = 22
                            AND ( ( DATEDIFF(DAY, d2.EffectiveDate,
                                             d.EffectiveDate) < 0 )
                                  OR ( DATEDIFF(DAY, d2.EffectiveDate,
                                                d.EffectiveDate) = 0
                                       AND d2.DocumentId > d.DocumentId
                                       AND ISNULL(d2.RecordDeleted, 'N') = 'N'
                                     )
                                ) );

			-- 03/15/16 If no SUD Admission docs exist, set @ClosedSUAdmission = Y (no open SUD episodes)
            IF ISNULL(@SUAdmissionDocumentVersionID, 0) = 0
                BEGIN
                    SELECT  @ClosedSUAdmission = 'Y'
                END
                        
			-- 02/29/16 most recent signed SUD Discharge doc ...
            SELECT TOP 1
                    @SUDischargeDocumentVersionId = CurrentDocumentVersionId
            FROM    Documents d3
            WHERE   d3.ClientId = @ClientId
                    AND d3.[Status] = 22 --signed
                    AND d3.DocumentCodeId = 46221
                    AND ISNULL(d3.RecordDeleted, 'N') = 'N'
                    AND NOT EXISTS ( SELECT 1
                                     FROM   Documents AS d2
                                     WHERE  d2.ClientId = d3.ClientId
                                            AND d2.DocumentCodeId = d3.DocumentCodeId
                                            AND d2.[Status] = 22
                                            AND ( ( DATEDIFF(DAY,
                                                             d2.EffectiveDate,
                                                             d3.EffectiveDate) < 0 )
                                                  OR ( DATEDIFF(DAY,
                                                              d2.EffectiveDate,
                                                              d3.EffectiveDate) = 0
                                                       AND d2.DocumentId > d3.DocumentId
                                                       AND ISNULL(d2.RecordDeleted,
                                                              'N') = 'N'
                                                     )
                                                ) )
                
			-- 02/29/16 Does the most recent signed SUD Discharge doc close the most recent signed SUD Admission?
   --         SELECT  @ClosedSUAdmission = 'Y'
   --         FROM    Documents AS d1
   --                 JOIN CustomDocumentSUAdmissions AS cdsa ON cdsa.DocumentVersionId = d1.CurrentDocumentVersionId
   --                 JOIN GlobalCodes AS gc ON gc.GlobalCodeId = cdsa.AdmittedPopulation
   --                 JOIN Documents AS d2 ON d2.ClientId = d1.ClientId
   --         WHERE   d1.CurrentDocumentVersionId = @SUAdmissionDocumentVersionID
   --                 AND d2.CurrentDocumentVersionId = @SUDischargeDocumentVersionId
   --                 AND ( ( d2.EffectiveDate > d1.EffectiveDate ) 										-- original validation: Discharge after Admission
   --                       OR ( d2.EffectiveDate = d1.EffectiveDate
   --                            AND gc.Code IN ( '20', '21' )
   --                          )				-- Task # 260 
   --                       OR ( d2.EffectiveDate = d1.EffectiveDate
   --                            AND d1.CreatedBy = 'StdDataConversion'
   --                            AND d2.CreatedBy = 'StdDataConversion'
   --                          )	-- Task # 260
   --                     )
   --                 AND ISNULL(cdsa.RecordDeleted, 'N') = 'N'
   --                 AND ISNULL(d1.RecordDeleted, 'N') = 'N'
   --                 AND ISNULL(d2.RecordDeleted, 'N') = 'N'
   --                 AND ISNULL(gc.RecordDeleted, 'N') = 'N' 

			---- end of 02/29/2016 Task # 260 changes ------------------------------------------------
			
			---- 03/15/16 If SUD Admission is still open and DischargeType is P (program), is the open SUD Admission
			---- ProgramId one of the Discharge ProgramIds? Yes = validation message; No = OK to sign.
			
   --         IF @ClosedSUAdmission = 'N'
   --             BEGIN
   --                 SELECT  @SUAdmissionProgramId = ProgramId
   --                 FROM    dbo.CustomDocumentSUAdmissions
   --                 WHERE   DocumentVersionId = @SUAdmissionDocumentVersionID
   --                         AND ISNULL(RecordDeleted, 'N') = 'N'							-- 04/18/16
				 
   --                 IF @SUAdmissionProgramId NOT IN (
   --                     SELECT  ProgramId
   --                     FROM    dbo.ClientPrograms AS cp
   --                             JOIN dbo.CustomDischargePrograms AS cdp ON cdp.ClientProgramId = cp.ClientProgramId
   --                             JOIN dbo.CustomDocumentDischarges AS cdd ON cdd.DocumentVersionId = cdp.DocumentVersionId
   --                     WHERE   cdp.DocumentVersionId = @DocumentVersionId
   --                             AND cp.[Status] <> 5									-- 04/22/16
   --                             AND cdd.DischargeType = 'P'							-- 04/22/16
   --                             AND ISNULL(cp.RecordDeleted, 'N') = 'N'				-- 04/18/16
   --                             AND ISNULL(cdp.RecordDeleted, 'N') = 'N'				-- 04/18/16
   --                             AND ISNULL(cdd.RecordDeleted, 'N') = 'N' -- 04/18/16
			--		)
   --                     BEGIN
   --                         SELECT  @ClosedSUAdmission = 'Y'	-- no open SU Admissiosn for any programs being discharged
   --                     END
   --             END
			
			-- end of 03/15/2016 Task # 260 changes ------------------------------------------------

            DECLARE @DiagnosisCount INT;
            
     
            --#############################################################################
            -- find the episode registration date this document belongs to  401
            --  Discharge "validation error when attempting to sign document" 
            --############################################################################# 
   
            --SELECT  @DiagnosisCount = COUNT(*)
            --FROM    Documents
            --WHERE   DocumentCodeId IN ( 1601, 10018, 21300, 30100, 1620, 60004 )--DSM 5 Diagnosis,Assessment,Med Note,Nurse Note,Care Plan,Commercial Assessment
            --        AND Status = 22
            --        AND ClientId = @ClientId
            --        AND ISNULL(RecordDeleted, 'N') = 'N';

            DECLARE @RelevantEpisodeRegistrationDate DATETIME
            
            SELECT  @RelevantEpisodeRegistrationDate = MAX(CE.RegistrationDate)
            FROM    ClientEpisodes CE
            WHERE   CE.ClientId = @ClientId
                    AND CE.RegistrationDate <= @EffectiveDate
                    
      
            SELECT  @DiagnosisCount = 1
            WHERE   EXISTS ( SELECT 1
                             FROM   Documents d
                                    JOIN DocumentCodes dc ON dc.DocumentCodeId = d.DocumentCodeId
                             WHERE  d.Status = 22
                                    AND d.ClientId = @ClientId
                                    AND ISNULL(d.RecordDeleted, 'N') = 'N'
                                    AND dc.DiagnosisDocument = 'Y'
                                    AND d.EffectiveDate >= @RelevantEpisodeRegistrationDate )
            --#############################################################################
            -- end 401 changes
            --############################################################################# 
              
            DECLARE @BedCensusCount INT;
            DECLARE @BedCensusCheck CHAR(1);
            
            SELECT  @BedCensusCount = COUNT(*)
            FROM    ClientInpatientVisits
            WHERE   [Status] = 4982
                    AND AdmitDate IS NOT NULL
                    AND DischargedDate IS NULL
                    AND ClientId = @ClientId
                    AND ISNULL(RecordDeleted, 'N') = 'N';
              
            IF ( @BedCensusCount >= 1 )
                BEGIN
                    SET @BedCensusCheck = 'Y';
                END;
            ELSE
                BEGIN
                    SET @BedCensusCheck = 'N';
                END;
                

            DECLARE @LatestICD10DocumentVersionID INT;
            DECLARE @ICD10Check CHAR(1);
            DECLARE @AdminCloseGlobalcode INT;
            
            SET @LatestICD10DocumentVersionID = ( SELECT TOP 1
                                                            CurrentDocumentVersionId
                                                  FROM      Documents a
                                                            INNER JOIN DocumentCodes Dc ON Dc.DocumentCodeId = a.DocumentCodeId
                                                  WHERE     a.ClientId = @ClientId
                                                            AND a.EffectiveDate <= CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101))
                                                            AND a.[Status] = 22
                                                            AND Dc.DiagnosisDocument = 'Y'
                                                            AND a.DocumentCodeId = 1601
                                                            AND ISNULL(a.RecordDeleted,
                                                              'N') <> 'Y'
                                                            AND ISNULL(Dc.RecordDeleted,
                                                              'N') <> 'Y'
                                                  ORDER BY  a.EffectiveDate DESC
                                                  ,         a.ModifiedDate DESC
                                                );
            SELECT  @AdminCloseGlobalcode = GlobalCodeId
            FROM    GlobalCodes
            WHERE   Category = 'xPROGDISCHARGEREASON'
                    AND CodeName = 'Administrative Close'
                    AND ISNULL(RecordDeleted, 'N') = 'N';
              
            IF ( @LatestICD10DocumentVersionID IS NULL )
                BEGIN
                    SET @ICD10Check = 'Y';
                END;
            ELSE
                BEGIN
                    SET @ICD10Check = 'N';
                END;
            DECLARE @CountNonPrimaryProgram INT;
            DECLARE @NonPrimaryProgram CHAR(1);
            
            SELECT  @CountNonPrimaryProgram = ClientProgramId
            FROM    CustomDischargePrograms
            WHERE   DocumentVersionId = @DocumentVersionId
                    AND ISNULL(RecordDeleted, 'N') = 'N'
                    AND ClientProgramId NOT IN (
                    SELECT  ClientProgramId
                    FROM    ClientPrograms
                    WHERE   ClientId = @ClientId
                            AND PrimaryAssignment = 'Y'
                            AND [Status] IN ( 1, 4 )
                            AND ISNULL(RecordDeleted, 'N') = 'N' );
                                            
            IF ( @CountNonPrimaryProgram >= 1 )
                BEGIN
                    SET @NonPrimaryProgram = 'Y';
                END;
                
            DECLARE @DiagnosisDocumentVersionID INT;
            DECLARE @DiagnosisDocumentCheck CHAR(1);
            DECLARE @NoDiagnosisCount INT =0
			DECLARE @DiagnosisExitCount INT=0
            
            SELECT TOP 1
                    @DiagnosisDocumentVersionID = CurrentDocumentVersionId
            FROM    DocumentDiagnosis CDSA
                    INNER JOIN Documents Doc ON CDSA.DocumentVersionId = Doc.CurrentDocumentVersionId
            WHERE   Doc.ClientId = @ClientId
                    AND Doc.[Status] = 22
                    AND ISNULL(CDSA.RecordDeleted, 'N') = 'N'
                    AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
            ORDER BY Doc.EffectiveDate DESC
            ,       Doc.ModifiedDate DESC;
            
            SELECT @NoDiagnosisCount= COUNT(*) FROM DocumentDiagnosis Where DocumentVersionId=@DiagnosisDocumentVersionID AND ISNULL(RecordDeleted, 'N') = 'N' AND NoDiagnosis='Y'
			SELECT @DiagnosisExitCount= COUNT(*) FROM DocumentDiagnosisCodes Where DocumentVersionId=@DiagnosisDocumentVersionID AND ISNULL(RecordDeleted, 'N') = 'N'
			                       
            IF ( @NoDiagnosisCount=0 AND @DiagnosisExitCount=0 )
                BEGIN
                    SET @DiagnosisDocumentCheck = 'Y';
                END;
            ELSE
                BEGIN
                    SET @DiagnosisDocumentCheck = 'N';
                END;
            DECLARE @IsAANDDProgramDischarge CHAR(1);
            
            IF EXISTS ( SELECT  1
                        FROM    CustomDischargePrograms CDP
                                INNER JOIN ClientPrograms CP ON CP.ClientProgramId = CDP.ClientProgramId
                                                              AND CP.ClientId = @ClientId
                                                              AND ISNULL(CP.RecordDeleted,
                                                              'N') = 'N'
                                INNER JOIN dbo.ssf_RecodeValuesCurrent('PROGRAMAANDD')
                                AS rel ON rel.IntegerCodeId = CP.ProgramId --jcarlson 10/19/2015
                        WHERE   CDP.DocumentVersionId = @DocumentVersionId
                                AND ISNULL(CDP.RecordDeleted, 'N') = 'N' )
                BEGIN
                    SET @IsAANDDProgramDischarge = 'Y';
                END;
            ELSE
                BEGIN
                    SET @IsAANDDProgramDischarge = 'N';
                END;
                
                
            DECLARE @IsResidentialDischarge CHAR(1);
            IF EXISTS ( SELECT  1
                        FROM    CustomDischargePrograms CDP
                                INNER JOIN ClientPrograms CP ON CP.ClientProgramId = CDP.ClientProgramId
                                                              AND CP.ClientId = @ClientId
                                                              AND ISNULL(CP.RecordDeleted,
                                                              'N') = 'N'
                                INNER JOIN dbo.ssf_RecodeValuesCurrent('XRESIDENTIALPROGRAM')
                                AS rel ON rel.IntegerCodeId = CP.ProgramId --jcarlson 10/19/2015
                            --INNER JOIN Recodes R ON R.IntegerCodeId = CP.ProgramId
                            --                    AND ISNULL(R.RecordDeleted, 'N') = 'N'
                            --INNER JOIN RecodeCategories RC ON R.RecodeCategoryId = RC.RecodeCategoryId
                            --                              AND RC.CategoryCode = 'XRESIDENTIALPROGRAM'
                            --                              AND ISNULL(RC.RecordDeleted, 'N') = 'N'
                        WHERE   CDP.DocumentVersionId = @DocumentVersionId
                                AND ISNULL(CDP.RecordDeleted, 'N') = 'N' )
                BEGIN
                    SET @IsResidentialDischarge = 'Y';
                END;
            ELSE
                BEGIN
                    SET @IsResidentialDischarge = 'N';
                END;





            --DECLARE @FlexcareDocumentVersionID INT
            --DECLARE @FlexcareCheck Char(1)
            --select @FlexcareDocumentVersionID = count(NewPrimaryClientProgramId) from customdocumentdischarges where DocumentVersionId = @DocumentVersionId  
            --and NewPrimaryClientProgramId in (SELECT Integercodeid from recodes where CodeName = 'Flexcare') 
            --IF (@FlexcareDocumentVersionID >= 1)
            --BEGIN
            --set @FlexcareCheck = 'Y'
            --END
            --ELSE
            --BEGIN
            --set @FlexcareCheck = 'N'
            --END


            DECLARE @FlexcareDocumentVersionID INT;
            DECLARE @FlexcareCheck CHAR(1);
            
            SELECT  @FlexcareDocumentVersionID = COUNT(NewPrimaryClientProgramId)
            FROM    CustomDocumentDischarges
            WHERE   DocumentVersionId = @DocumentVersionId
                    AND ISNULL(RecordDeleted, 'N') = 'N'
                    AND NewPrimaryClientProgramId IN (
                    SELECT  cp.ClientProgramId
                    FROM    ClientPrograms cp
                                                --JOIN dbo.ssf_RecodeValuesCurrent('?') AS rel ON rel.IntegerCodeId = cp.ProgramId
                    WHERE   ClientId = @ClientId
                            AND ProgramId IN ( SELECT   IntegerCodeId
                                               FROM     Recodes
                                               WHERE    CodeName = 'Flexcare' )
                            AND ISNULL(cp.RecordDeleted, 'N') = 'N' );
            IF ( @FlexcareDocumentVersionID >= 1 )
                BEGIN
                    SET @FlexcareCheck = 'Y';
                END;
            ELSE
                BEGIN
                    SET @FlexcareCheck = 'N';
                END;
                
            DECLARE @HighlandspringsDocumentVersionID INT;
            DECLARE @HighlandspringsCheck CHAR(1);
            
            SELECT  @HighlandspringsDocumentVersionID = COUNT(NewPrimaryClientProgramId)
            FROM    CustomDocumentDischarges
            WHERE   DocumentVersionId = @DocumentVersionId
                    AND NewPrimaryClientProgramId IN (
                    SELECT  cp.ClientProgramId
                    FROM    ClientPrograms cp
                            JOIN dbo.ssf_RecodeValuesCurrent('Highland Springs')
                            AS rel ON rel.IntegerCodeId = cp.ProgramId --jcarlson 10/19/2015
                    WHERE   cp.ClientId = @ClientId
                            AND ISNULL(cp.RecordDeleted, 'N') = 'N' --AND ProgramId IN(
                                                  --       SELECT Integercodeid
                                                  --       FROM recodes
                                                  --       WHERE CodeName = 'Highland Springs' )
                                                         );
                                                         
            IF ( @HighlandspringsDocumentVersionID >= 1 )
                BEGIN
                    SET @HighlandspringsCheck = 'Y';
                END;
            ELSE
                BEGIN
                    SET @HighlandspringsCheck = 'N';
                END;
                
            DECLARE @TobaccoUsecount INT;
            DECLARE @TobaccoUseCheck CHAR(1);
            
            SELECT  @TobaccoUsecount = COUNT(TobaccoUse)
            FROM    CustomDocumentDischarges
            WHERE   DocumentVersionId = @DocumentVersionId
                    AND TobaccoUse IN (
                    SELECT  GlobalCodeId
                    FROM    GlobalCodes
                    WHERE   Category = 'XCDTOBACCOUSE'
                            AND Code IN ( 'HAVEUSEDNOTCURRENTUSER',
                                          'OCCASIONALUSER', 'REGULARUSER',
                                          'USESMOKELESSTOBACCO' )
                            AND ISNULL(RecordDeleted, 'N') = 'N' )
                    AND ISNULL(RecordDeleted, 'N') = 'N';
                                   
            IF ( @TobaccoUsecount >= 1 )
                BEGIN
                    SET @TobaccoUseCheck = 'Y';
                END;
                
            DECLARE @ReferralCount INT;
            SELECT  @ReferralCount = 1; 

            DECLARE @AgencyDischargeCheck CHAR(1);
            DECLARE @AgencyPrimaryProgram INT;
            DECLARE @AgencyPrimaryProgramCheck CHAR(1);
            DECLARE @StaffId INT;
            
            SELECT  @StaffId = d.AuthorId
            FROM    Documents d
                    JOIN dbo.DocumentVersions dv ON d.DocumentId = dv.DocumentId
                                                    AND ISNULL(dv.RecordDeleted,
                                                              'N') = 'N'
                                                    AND dv.DocumentVersionId = @DocumentVersionId
            WHERE   ISNULL(d.RecordDeleted, 'N') = 'N'
                        
            SELECT  @AgencyDischargeCheck = DischargeType
            FROM    CustomDocumentDischarges
            WHERE   DocumentVersionId = @DocumentVersionId;
            
            IF @AgencyDischargeCheck = 'A'
                BEGIN
                    SELECT  @AgencyPrimaryProgram = ProgramId
                    FROM    StaffPrograms
                    WHERE   StaffId = @StaffId
                            AND ISNULL(RecordDeleted, 'N') = 'N'
                            AND ProgramId IN (
                            SELECT  ProgramId
                            FROM    ClientPrograms
                            WHERE   ClientId = @ClientId
                                    AND PrimaryAssignment = 'Y'
                                    AND ISNULL(RecordDeleted, 'N') = 'N' );
                                          
                                          
                    IF @AgencyPrimaryProgram > 1
                        BEGIN
                            SET @AgencyPrimaryProgramCheck = 'Y';
                        END;
                    ELSE
                        BEGIN
                            SET @AgencyPrimaryProgramCheck = 'N';
                        END;
                END;
                
            DECLARE @RoleId INT;
            DECLARE @RoleIdCheck CHAR(1);
            
            SELECT  @RoleId = LicenseTypeDegree
            FROM    StaffLicenseDegrees
            WHERE   StaffId = @StaffId
                    AND ISNULL(RecordDeleted, 'N') = 'N'
                    AND StartDate <= GETDATE()
                    AND ISNULL(EndDate, GETDATE()) >= GETDATE()
                    AND LicenseTypeDegree IN (
                    SELECT  GlobalCodeId
                    FROM    GlobalCodes
                    WHERE   Category = 'DEGREE'
                            AND Code = 'LMHT'
                            AND ISNULL(RecordDeleted, 'N') = 'N' );
            IF @RoleId > 1
                BEGIN
                    SET @RoleIdCheck = 'Y';
                END;
            ELSE
                BEGIN
                    SET @RoleIdCheck = 'N';
                END;
                
            DECLARE @validationReturnTable TABLE
                (
                 TableName VARCHAR(200)
                ,ColumnName VARCHAR(200)
                ,ErrorMessage VARCHAR(1000)
                ,PageIndex INT
                ,TabOrder INT
                ,ValidationOrder INT
                );

----------------------------------------------------------------------------------------------------------------------
DECLARE @ProgramIDList VARCHAR(max) = ''
DECLARE @ServiceCount1 int
SET @ProgramIDList = (
					SELECT distinct  ltrim(STUFF((SELECT ', ' + CAST(cp.ProgramId AS VARCHAR(100)) 
						FROM ClientPrograms CP
						INNER JOIN Programs P ON cp.ProgramId = P.ProgramId
						INNER JOIN Clients C ON C.ClientId = CP.ClientId
						WHERE c.ClientId = @ClientId
							--AND CP.[Status] IN (4)
							AND IsNull(CP.RecordDeleted, 'N') = 'N'
							AND IsNull(P.RecordDeleted, 'N') = 'N'
							AND IsNull(C.RecordDeleted, 'N') = 'N'
							AND CP.ClientProgramId IN (
								SELECT ClientProgramId
								FROM CustomDischargePrograms
								WHERE DocumentVersionId = @DocumentVersionId
									AND IsNull(RecordDeleted, 'N') = 'N'
								)
						FOR XML PATH(''), TYPE)
					   .value('.','NVARCHAR(MAX)'),1,2,' ')) List_Output
					FROM Clients t )
		
	EXEC csp_PMServicesForDischargeDocument @StaffId,@ClientId,@ProgramIDList,@ServiceCount =@ServiceCount1 output

--#############################################Future Scheduled Services for Program - Program Discharge##################################################
DECLARE @FutureScheduledServices INT
DECLARE @FutureScheduledServices2 INT

IF @AgencyDischargeCheck = 'P'
	Begin
	SELECT @FutureScheduledServices = SUM(1) 
	FROM Services s
	JOIN clientprograms cp ON cp.ProgramId = s.ProgramId AND cp.ClientId = s.ClientId
	JOIN dbo.CustomDischargePrograms cdp ON cdp.ClientProgramId = cp.ClientProgramId
	WHERE cdp.DocumentVersionId = @DocumentVersionId
	AND s.Status = 70
	AND CAST(s.DateOfService AS DATE) > @EffectiveDate
	AND ISNULL(s.RecordDeleted, 'N') <> 'Y'
	AND ISNULL(cdp.RecordDeleted, 'N') <> 'Y'
	AND ISNULL(cp.RecordDeleted, 'N') <> 'Y'
			        --#############################################################################
                    -- if there are future services for this program, generate validation error
                    --############################################################################# 
                    IF ISNULL(@FutureScheduledServices, 0) > 0
                        BEGIN
                            INSERT  INTO @validationReturnTable
                                    (TableName
                                    ,ColumnName
                                    ,ErrorMessage
                                    )
                            VALUES  ('ClientPrograms'
                                    ,'ClientProgramId'
                                    ,'Client Cannot be discharged from this program due to '
                                     + CAST(@FutureScheduledServices AS VARCHAR)
                                     + ' future service'+case when @FutureScheduledServices <> 1 then 's' else '' end +' scheduled using this program.'
                                    )    
                        END
						END
--#############################################Future Scheduled Services for Agency Discharge##################################################

IF @AgencyDischargeCheck = 'A'
	                BEGIN
                    --#############################################################################
                    -- find out if there are future services scheduled
                    --############################################################################# 
                    SELECT  @FutureScheduledServices2 = SUM(1)
                    FROM    Services S
                    WHERE   Status = 70
                            AND ISNULL(S.RecordDeleted, 'N') = 'N'
                            AND S.ClientId = @ClientId
                            AND CAST(S.DateOfService AS DATE) > @EffectiveDate

                    --#############################################################################
                    -- if there are future services for this program, generate validation error
                    --############################################################################# 
                    IF ISNULL(@FutureScheduledServices2, 0) > 0
                        BEGIN
                            INSERT  INTO @validationReturnTable
                                    (TableName
                                    ,ColumnName
                                    ,ErrorMessage
                                    )
                            VALUES  ('ClientPrograms'
                                    ,'ClientProgramId'
                                    ,'Client Cannot be discharged from the Agency due to '
                                     + CAST(@FutureScheduledServices2 AS VARCHAR)
                                     + ' future service'+case when @FutureScheduledServices2 <> 1 then 's' else '' end +' s scheduled.'
                                    )    
                        END
                END    
   --##################End Future Scheduled Services Check#####################                     

            INSERT  INTO @validationReturnTable
                    (TableName
                    ,ColumnName
                    ,ErrorMessage
                    ,ValidationOrder
                    )              
                   --This validation returns three fields              
                   --Field1 = TableName              
                   --Field2 = ColumnName              
                   --Field3 = ErrorMessage 
                    SELECT  'CustomDocumentDischarges'
                    ,       'DischargeType'
                    ,       'General - Program Actions - Please specify Program Discharge or Agency Discharge'
                    ,       1
                    FROM    @CustomDocumentDischarge
                    WHERE   DischargeType IS NULL
                    UNION
                    SELECT  'CustomDocumentDischarge'
                    ,       'TransitionDischarge'
                    ,       'General - Transition/Discharge - Please specify Transition/Discharge Reason'
                    ,       1
                    FROM    @CustomDocumentDischarge
                    WHERE   ISNULL(TransitionDischarge, '') = ''
                    UNION
                    SELECT  'CustomDocumentDischarge'
                    ,       'DischargeDetails'
                    ,       'General – Transition/Discharge - Please specify Transition/Discharge Details'
                    ,       2
                    FROM    @CustomDocumentDischarge
                    WHERE   ISNULL(DischargeDetails, '') = ''
                    UNION
                    SELECT  'CustomDocumentDischarge'
                    ,       'OverallProgress'
                    ,       'Progress Review – Overall Progress - Please specify Overall Progress and movement toward recovery '
                    ,       3
                    FROM    @CustomDocumentDischarge
                    WHERE   ISNULL(OverallProgress, '') = ''
                            AND @Discharge = 'D'
                            AND @FlexcareCheck = 'N'
                    UNION
                    SELECT  'CustomDocumentDischarge'
                    ,       'StatusLastContact'
                    ,       'Progress Review – Overall Progress - Please specify Status at last contact'
                    ,       4
                    FROM    @CustomDocumentDischarge
                    WHERE   ISNULL(StatusLastContact, '') = ''
                            AND @Discharge = 'D'
                            AND @FlexcareCheck = 'N'
                    UNION
                    SELECT  'CustomDocumentDischarge'
                    ,       'Treatmentcompletion'
                    ,       'Progress Review – Treatment Completion is required'
                    ,       5
                    FROM    @CustomDocumentDischarge
                    WHERE   ISNULL(Treatmentcompletion, 0) <= 0
                            AND @Discharge = 'D'
                    UNION
                    SELECT  'CustomDocumentDischarge'
                    ,       'SymptomsReoccur'
                    ,       'Referrals/Disposition Plan – Disposition Plan - If symptoms reoccur or additional services are needed is required '
                    ,       6
                    FROM    @CustomDocumentDischarge
                    WHERE   ISNULL(SymptomsReoccur, '') = ''
                            AND @Discharge = 'D'
                            AND @FlexcareCheck = 'N'
                            AND @HighlandspringsCheck = 'N'
                    UNION
                    SELECT  'CustomDocumentDischarge'
                    ,       'DischargeType'
                    ,       'General – Program Actions – Primary Program must be transferred to another Program before you can discharge'
                    ,       7
                    FROM    @CustomDocumentDischarge
                    WHERE   ISNULL(DischargeType, '') = 'P'
                            AND @PrimaryProgramcount = 1
                    UNION
                    SELECT  'CustomDocumentDischarge'
                    ,       'DischargeType'
                    ,       'General – Program Actions - Client cannot be discharged until the client has been discharged from the residential bed'
                    ,       8
                    FROM    @CustomDocumentDischarge
                    WHERE   ISNULL(DischargeType, '') = 'A'
                            AND @BedCensusCheck = 'Y'
                    UNION
                    SELECT  'CustomDocumentDischarge'
                    ,       'NoReferral'
                    ,       'Referrals/Disposition Plan – Stabilization Plan – Referral is required'
                    ,       9
                    FROM    @CustomDocumentDischarge
                    WHERE   ISNULL(NoReferral, '') <> 'Y'
                            AND @ReferralCount = 0
                            AND @Discharge = 'D'
                            AND @FlexcareCheck = 'N'
                            AND @HighlandspringsCheck = 'N'
                    --UNION
                    --SELECT  'CustomDocumentDischarge'
                    --,       'DischargeType'
                    --,       'General - Program Actions - Staff Person discharging must be associated with clients primary program '
                    --,       10
                    --FROM    @CustomDocumentDischarge
                    --WHERE   ISNULL(DischargeType, '') = 'A'
                    --        AND @AgencyPrimaryProgramCheck = 'N'
                    UNION
                 
                    SELECT  'CustomDocumentDischarge'
                    ,       'TransitionDischarge'
                    ,       'The diagnosis document must be signed and completed before discharging the client from the agency'
                    ,       11
                    FROM    @CustomDocumentDischarge
                    WHERE   @DiagnosisCount = 0
                            AND ISNULL(DischargeType, '') = 'A'
                    UNION
                    SELECT  'CustomDocumentDischarge'
                    ,       'DischargeType'
                    ,       'Client cannot be discharged  until the client has been discharged from SUD'
                    ,       12
                    FROM    @CustomDocumentDischarge
                    WHERE   @IsAANDDProgramDischarge = 'Y'
                            AND @ClosedSUAdmission = 'N'
                    UNION
                    SELECT  'CustomDocumentDischarge'
                    ,       'DischargeType'
                    ,       'Client cannot be discharged until the client has been diagnosed either with a valid diagnosis or as having No Diagnosis'
                    ,       13
                    FROM    @CustomDocumentDischarge
                    WHERE   ISNULL(DischargeType, '') = 'A'
                            AND @DiagnosisDocumentCheck = 'Y'
                    UNION
                    SELECT  'CustomDocumentDischarge'
                    ,       'DischargeType'
                    ,       'Client cannot be discharged  until the client has been discharged from SUD'
                    ,       14
                    FROM    @CustomDocumentDischarge
                    WHERE   @ClosedSUAdmission = 'N'
                            AND @AgencyDischargeCheck = 'A'
                    UNION
                    SELECT  'CustomDocumentDischarge'
                    ,       'DischargeType'
                    ,       'Client cannot be discharged until the client has been discharged from the residential bed'
                    ,       15
                    FROM    @CustomDocumentDischarge
                    WHERE   @IsResidentialDischarge = 'Y'
                            AND @BedCensusCheck = 'Y'
                            AND ISNULL(DischargeType, '') = 'P'
					UNION
                    SELECT  'CustomDocumentDischarge'
                    ,       'DischargeType'
                    ,       'Client cannot be discharged until the open services for Programs with Discharge Action'
                    ,       16
                    FROM    @CustomDocumentDischarge
                    WHERE   @ServiceCount1 > 0;
		IF @AgencyDischargeCheck = 'A'
        BEGIN
			DECLARE @BHEffectiveDate datetime
			DECLARE @BHupdateEffectiveDate datetime
			DECLARE @AdequateffectiveDate datetime
			DECLARE @AdequateScanEffectiveDate datetime
			DECLARE @DocEffectiveDate datetime
			DECLARE @DeceasedOn datetime 

			set @DeceasedOn = (select DeceasedOn from clients where clientid=@ClientId)

			set @BHEffectiveDate = (select top 1 EffectiveDate from documents where documentcodeid=35102 
			and clientid=@ClientID and [Status] = 22 
			and isnull(RecordDeleted,'N')='N' order by EffectiveDate desc)

			set @BHupdateEffectiveDate = (select top 1 EffectiveDate from documents where documentcodeid=50002 
			and clientid=@ClientID and [Status] = 22 
			and isnull(RecordDeleted,'N')='N' order by EffectiveDate desc)

			SET @DocEffectiveDate = (select top 1 EffectiveDate from documents where CurrentDocumentVersionId=@DocumentVersionId
			and isnull(RecordDeleted,'N')='N')

			set @AdequateffectiveDate = (select top 1 EffectiveDate from documents where documentcodeid=100 
			and clientid=@ClientID and [Status] = 22 
			and isnull(RecordDeleted,'N')='N'
			and (EffectiveDate >= DATEADD(DAY, -14, @DocEffectiveDate)) order by EffectiveDate desc)

			set @AdequateScanEffectiveDate = (select top 1 EffectiveDate from documents where documentcodeid=60025 
			and clientid=@ClientID and [Status] = 22 
			and isnull(RecordDeleted,'N')='N'
			and (EffectiveDate >= DATEADD(DAY, -14, @DocEffectiveDate)) order by EffectiveDate desc)

			if (@BHEffectiveDate is not null and @BHupdateEffectiveDate is not null)
			begin
			If not Exists (select top 1 EffectiveDate from documents where documentcodeid=50002 
			and clientid=@ClientID and [Status] = 22  and EffectiveDate <= @DocEffectiveDate
			and isnull(RecordDeleted,'N')='N')
			BEGIN
				INSERT  INTO @validationReturnTable
												(TableName
												,ColumnName
												,ErrorMessage
												,ValidationOrder
												)
										VALUES  ('CustomDischargeDocument'
												,'BH TEDS Update/Discharge Document'
												,'BH TEDS Update/Discharge Document need to be signed '
												,17
												) 
			END
			END
			ELSE
			BEGIN
				INSERT  INTO @validationReturnTable
												(TableName
												,ColumnName
												,ErrorMessage
												,ValidationOrder
												)
										VALUES  ('CustomDischargeDocument'
												,'BH TEDS Update/Discharge Document'
												,'BH TEDS Update/Discharge Document need to be signed '
												,18
												) 
			END
		   DECLARE @categoryId INT;
		   SET @categoryId = (SELECT TOP 1 RecodeCategoryId FROM RecodeCategories WHERE CategoryCode = 'XISKZOOEmerSvcsPrograms' AND isnull(RecordDeleted, 'N') = 'N')
		   IF EXISTS(SELECT  1  
                    FROM    ClientPrograms cp  
                    WHERE   cp.ClientId = @ClientID  
                            AND cp.[Status] IN ( 1, 4 )  
                            AND ISNULL(RecordDeleted, 'N') = 'N' 
							and NOT Exists (select IntegerCodeId  FROM dbo.Recodes WHERE  RecodeCategoryId = @categoryId AND isnull(RecordDeleted, 'N') = 'N' and integercodeid=cp.programid and cast (getdate() as date)BETWEEN cast(FromDate as date) and cast(ISNULL(ToDate,getdate()) as date)  )

           )
		   BEGIN
			if(@DeceasedOn is null)
			Begin
			IF(@AdequateffectiveDate is  null and @AdequateScanEffectiveDate is  null)
			BEGIN
			INSERT  INTO @validationReturnTable
												(TableName
												,ColumnName
												,ErrorMessage
												,ValidationOrder
												)
										VALUES  ('CustomDischargeDocument'
												,'Advance/Adequate Notice Document'
												,'Either Advance/Adequate Notice scanned or Advance/Adequate Notice document need to be signed '
												,18
												) 
			END
		END
		   END
End
            SELECT  TableName
            ,       ColumnName
            ,       ErrorMessage
            ,       PageIndex
            ,       TabOrder
            ,       ValidationOrder
            FROM    @validationReturnTable
            ORDER BY ValidationOrder ASC;
            
        END TRY
        BEGIN CATCH
            DECLARE @Error VARCHAR(8000);
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
                + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                         '[csp_validateCustomDocumentDischarges]') + '*****'
                + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
                + CONVERT(VARCHAR, ERROR_STATE());
            RAISERROR( @Error, -- Message text.                                                                                          
            16, -- Severity.                                                                                          
            1 -- State.                                                                                          
            );
        END CATCH;
    END;




GO


