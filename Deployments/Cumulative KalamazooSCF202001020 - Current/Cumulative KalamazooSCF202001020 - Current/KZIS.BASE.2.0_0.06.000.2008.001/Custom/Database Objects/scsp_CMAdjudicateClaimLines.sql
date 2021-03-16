IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[scsp_CMAdjudicateClaimLines]') AND OBJECTPROPERTY(OBJECT_ID, N'IsProcedure') = 1)
	DROP PROCEDURE scsp_CMAdjudicateClaimLines
GO

/****** Object:  StoredProcedure [dbo].[scsp_CMAdjudicateClaimLines]    Script Date: 1/11/2018 1:46:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[scsp_CMAdjudicateClaimLines] 
(
	@ClaimLineId INT,
	@InsurerId INT,
	@BillingCodeId INT,
	@CoveragePlanId INT
)
/***********************************************************************************************************************
	Stored Procedure:	dbo.scsp_CMAdjudicateClaimLines 
	Purpose:			Adds custom logic to the adjudication process
========================================================================================================================
	Modification Log
========================================================================================================================
	Date		Author		Purpose
	----------	----------	--------------------------------------------------------------------
	04.20.2010  SFarber		Created.  
	10.21.2014  SFarber		Added adjudication rules logic.
	01.08.2018	Ting-Yu Mu	What: Added the logic to pull the assigned population from ProviderAuthorizations to CustomClaimLines
							regardless of whether or not it has been adjudicated
							1. When the claim adjudicates, it should pull the population from the authorization
							   Population should be associated to the claim regardless of the adjudication decision 
							   (approved, denied, etc.) 
							2. If the authorization is missing (as in denied for no auth) or ProviderAuhtoirzaitons.AssignedPopulation 
							   is blank, it should pull the population from the CustomFieldsData.Column GlobalCode7.  
							3. If a claim gets readjudicated, it should reassign/repull population to the claim                                                                                                                                      
                            Why: KCMH-Enhancements #542 
	07.10.2018	Ting-Yu Mu	What: Added DESC after ModifiedDate in the ORDER BY clause as we need the most recent
							updated assigned population for the claim line
	07.12.2018	Ting-Yu Mu	What: Added the logic to compare the record modified date of the AssignedPopulation in the 
							Authorizations and ProviderAuthorizations tables, and the most recent updated AssignedPopulation 
							will be used to update the AuthorizationPopulation column of the CustomClaimLines table
							Why: KCMH-Enhancements #542
	10.08.2020  Kavya.N     What: Created an adjudicationrule for Secondary Claims not requiring authorization.
	                        Why: KCMHSAS-Enhancment#83
	11.08.2020  Kavya.N     What: Added @fromdate variable declaration, which I missed in the previous commit.
	                        Why: KCMHSAS-Enhancment#83
	11.08.2020  Kavya.N     What: Added IF Exists condition before dropping the storedprocedure.
	                        Why: KCMHSAS-Enhancment#83
***********************************************************************************************************************/
AS

DECLARE @DenialReason INT

--  
-- All hospital claims with no Medicaid coverage should pend for manual review and approval.  
--  
SET @DenialReason = 12291

IF EXISTS 
(
	SELECT '*'
	FROM #AdjudicationRules ar
	WHERE ar.RuleTypeId = @DenialReason
		AND 
		(
			ar.AllInsurers = 'Y'
			OR ar.InsurerId = @InsurerId
		)
)
BEGIN
	IF EXISTS 
	(
		SELECT *
		FROM BillingCodes bc
		WHERE bc.BillingCodeId = @BillingCodeId
			AND bc.HospitalCode = 'Y'
	)
	AND @CoveragePlanId NOT IN 
	(
		4, 10
	)
	BEGIN
		INSERT INTO #DenialReasons (ReasonId)
		VALUES (@DenialReason)
	END
END

-- ################################################################################################# 
-- KCMHSAS custom Population update process
-- Update the CustomClaimLines.AuthorizationPopulation from ProviderAuthorizations.AssignedPopulation 
-- after the ClaimLines have been adjudicated
-- #################################################################################################
DECLARE @ClientId INT = NULL;
DECLARE @AssignedPopulation INT = NULL;

DECLARE	@AssignedPopFromAuth INT = NULL;
DECLARE	@AuthPopAssignedDate DATETIME;

DECLARE @AssignedPopFromProviderAuth INT = NULL;
DECLARE	@ProviderAuthAssignedDate DATETIME;

DECLARE @UserStamp VARCHAR(50) = NULL;
DECLARE @TimeStamp DATETIME = GETDATE();
DECLARE @FromDate DATETIME;

SELECT	@UserStamp = ModifiedBy,
		@FromDate=FromDate
FROM	dbo.ClaimLines
WHERE	ClaimLineId = @ClaimLineId

SELECT	@ClientId = C.ClientId
FROM	dbo.ClaimLines CL
JOIN	Claims C ON C.ClaimId = CL.ClaimId
	AND ISNULL(C.RecordDeleted, 'N') = 'N'
JOIN	dbo.Clients CE ON CE.ClientId = C.ClientId
	AND ISNULL(CE.RecordDeleted, 'N') = 'N'
JOIN	dbo.Insurers I ON I.InsurerId = C.InsurerId
	AND ISNULL(I.RecordDeleted, 'N') = 'N'
JOIN	dbo.Sites S ON S.SiteId = C.SiteId
	AND ISNULL(S.RecordDeleted, 'N') = 'N'
JOIN	dbo.Providers P ON P.ProviderId = S.ProviderId
	AND ISNULL(P.RecordDeleted, 'N') = 'N'
WHERE	CL.ClaimLineId = @ClaimLineId

-- =================================================================================================
-- Compare the ModifiedDate between the AssignedPopulation in Authorizations and ProviderAuthorizations
-- whoever is most recent then it will be used as the AssignedPopulation for the corresponding ClaimLine
-- =================================================================================================

-- ==== Gets the AssignedPopulation and ModifiedDate from the Authorizations table
SELECT	@AssignedPopFromAuth = Auth.AssignedPopulation,
		@AuthPopAssignedDate = Auth.ModifiedDate
FROM	
(
	SELECT	TOP 1 A.AssignedPopulation, A.ModifiedDate
	FROM	dbo.Authorizations A
	JOIN	dbo.AuthorizationDocuments AD ON A.AuthorizationDocumentId = AD.AuthorizationDocumentId
		AND ISNULL(AD.RecordDeleted, 'N') = 'N'
	JOIN	dbo.ClientCoveragePlans CCP ON AD.ClientCoveragePlanId = CCP.ClientCoveragePlanId
		AND ISNULL(CCP.RecordDeleted, 'N') = 'N'
	WHERE	ISNULL(A.RecordDeleted, 'N') = 'N'
		AND CCP.ClientId = @ClientId
		AND A.Status <> 4244 -- Denied
		AND A.AssignedPopulation IS NOT NULL
	ORDER BY A.ModifiedDate DESC, A.AuthorizationId DESC
) AS Auth

-- ==== Gets AssignedPopulation and ModifiedDate from the ProviderAuthorizations table
SELECT	@AssignedPopFromProviderAuth = ProviderAuth.AssignedPopulation,
		@ProviderAuthAssignedDate = ProviderAuth.ModifiedDate
FROM	
(
	SELECT	TOP 1 ISNULL(PA.AssignedPopulation, CFD.ColumnGlobalCode7) AS AssignedPopulation,
			ISNULL(PA.ModifiedDate, CFD.ModifiedDate) AS ModifiedDate
	FROM	dbo.ProviderAuthorizations PA
	LEFT JOIN dbo.CustomFieldsData CFD ON CFD.PrimaryKey1 = PA.ClientId
		AND ISNULL(CFD.RecordDeleted, 'N') = 'N'
	WHERE	ISNULL(PA.RecordDeleted, 'N') = 'N'
		AND PA.ClientId = @ClientId
		AND PA.Active = 'Y'
	ORDER BY PA.ModifiedDate DESC, PA.ProviderAuthorizationId DESC,
			 CFD.ModifiedDate DESC, CFD.CustomFieldsDataId DESC
) AS ProviderAuth

-- ====	Gets the AssignedPopulation based on the data availability and the ModifiedDate
IF (@AssignedPopFromAuth IS NULL) AND (@AssignedPopFromProviderAuth IS NOT NULL)
BEGIN
	SET @AssignedPopulation = @AssignedPopFromProviderAuth;
END
ELSE IF (@AssignedPopFromAuth IS NOT NULL) AND (@AssignedPopFromProviderAuth IS NULL)
BEGIN
	SET @AssignedPopulation = @AssignedPopFromAuth;
END
ELSE IF (@AssignedPopFromAuth IS NOT NULL) AND (@AssignedPopFromProviderAuth IS NOT NULL) 
BEGIN
	IF (@AuthPopAssignedDate > @ProviderAuthAssignedDate)
	BEGIN
		SET @AssignedPopulation = @AssignedPopFromAuth;
	END
	ELSE
    BEGIN
		SET @AssignedPopulation = @AssignedPopFromProviderAuth;
	END
END
ELSE
BEGIN
	SET @AssignedPopulation = NULL;
END

IF EXISTS
(
	SELECT	1
	FROM	CustomClaimLines
	WHERE	ClaimLineId = @ClaimLineId
)
BEGIN
	-- Update the associated CustomClaimLines record
	UPDATE	CCL
	SET		CCL.AuthorizationPopulation = @AssignedPopulation,
			ModifiedBy = @UserStamp,
			ModifiedDate = @TimeStamp
	FROM	CustomClaimLines CCL
	WHERE	CCL.ClaimLineId = @ClaimLineId
END
ELSE
BEGIN
	-- Insert new records into CustomClaimLines table
	INSERT INTO CustomClaimLines
	(
		ClaimLineId,
		CreatedBy,
		CreatedDate,
		ModifiedBy,
		ModifiedDate,
		AuthorizationPopulation
	)
	VALUES
	(
		@ClaimLineId,
		@UserStamp,
		@TimeStamp,
		@UserStamp,
		@TimeStamp,
		@AssignedPopulation
	)
END
-- #### End of KCMH custom population update process ###############################################

-- Secondary claim does not require authorization  
SELECT @DenialReason = GlobalCodeId  
	   FROM  dbo.GlobalCodes  
			 WHERE  Category = 'DENIALREASON'  
			 AND	Code     = 'AUTHREQUIREDOVERRIDE'  
			 AND ISNULL(RecordDeleted, 'N') = 'N';  
  
IF EXISTS ( SELECT '*'  
					FROM   #AdjudicationRules AR  
					WHERE  AR.RuleTypeId = @DenialReason  
					AND ( AR.AllInsurers = 'Y' OR AR.InsurerId = @InsurerId))  
BEGIN  
  -- If a claim line is being denied for the 'Billing code requires Authorization but one does not exist' reason,  
  -- remove this denial reason for claim lines that meet the following criteria:  
  -- Plans that have adjustment reason code of 1, 2 or 3 for outpatient billing codes  
  -- For example, provider is billing 90834 for client with charge of $100.  Medicare paid $75 so provider is billing $25 and enters into third party screen reason code 1.  
  -- The claim would approve without an authorization being present assuming all other adjudication edits were met.    
	 IF EXISTS ( SELECT 1  
						FROM   #DenialReasons  
						WHERE  ReasonId = 2526)  
	 BEGIN  
		  IF EXISTS ( SELECT 1  
                         FROM   ClaimLineCOBPaymentAdjustments COB  
                         JOIN CoveragePlans CP on CP.CoveragePlanId = COB.PayerId
                         JOIN dbo.ssf_RecodeValuesAsOfDate('XSECONDARYCLAIMADJPLANS', @FromDate) x ON x.IntegerCodeId = CP.CoveragePlanId   
                         JOIN GlobalSubCodes GSCR on GSCR.GlobalSubCodeId = COB.AdjustmentReason and GSCR.ExternalCode1 IN ( '1', '2', '3' ) 
                         WHERE  COB.ClaimLineId = @ClaimLineId  
                         AND ISNULL(COB.RecordDeleted, 'N') = 'N' AND ISNULL(CP.RecordDeleted, 'N') = 'N' AND ISNULL(GSCR.RecordDeleted, 'N') = 'N')  
						 AND EXISTS ( SELECT 1  
									         FROM   BillingCodes BC  
									         WHERE  BC.BillingCodeId = @BillingCodeId AND ISNULL(BC.HospitalCode, 'N') = 'N')  
           BEGIN  
				DELETE FROM #DenialReasons  
				       WHERE ReasonId = 2526;  
  
      -- Reset authorization required flag  
				UPDATE #AuthorizationsRates  
				     SET    AuthorizationRequired = 'N';  
  
      -- Recalculate contract approved amount  
				UPDATE CAA  
						  SET ContractApprovedAmount = AR.ContractApprovedAmount,  
			                  UnitsApproved = AR.UnitsApproved,  
                              RecalculateApprovedAmount = 'Y'  
							  FROM   #ContractApprovedAmount CAA  
							  CROSS JOIN ( SELECT ContractApprovedAmount = SUM(ClaimLineUnits * ContractRate),  
                                                  UnitsApproved = SUM(ClaimLineUnits)  
                                                  FROM   #AuthorizationsRates) as AR;  
			END;  
  
      END; 
END; 
RETURN
GO


