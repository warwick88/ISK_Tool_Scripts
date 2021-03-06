 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportDischargedProgramsList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportDischargedProgramsList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
 
CREATE Procedure [dbo].[csp_RDLSubReportDischargedProgramsList]
@DocumentVersionId INT
AS
/*********************************************************************/
/* Stored Procedure: [csp_RDLSubReportDischargedProgramsList]   */
/*       Date              Author                  Purpose                   */
/*      10-08-2014     Dhanil Manuel               To Retrieve Data  for RDL   */
/*********************************************************************/
BEGIN                            
BEGIN TRY 
DECLARE @ClientId INT
		SELECT @ClientId = d.ClientId  
		FROM Documents d  
		WHERE d.InProgressDocumentVersionId = @DocumentVersionId 

		SELECT P.ProgramCode
			,CASE 
				WHEN CP.[Status] = 5
					THEN 'Discharge'
				ELSE 'Remain Open'
				END ActionTaken
			,case when CP.PrimaryAssignment = 'Y' then 'Yes' else 'No' end as  PrimaryAssignment
			,CP.ClientProgramId
			,CASE CP.Status
				WHEN '1'
					THEN NULL
				ELSE CONVERT(VARCHAR(10), CP.EnrolledDate, 101)
				END AS EnrolledDate
		FROM ClientPrograms CP
		INNER JOIN Programs P ON cp.ProgramId = P.ProgramId
		INNER JOIN Clients C ON C.ClientId = CP.ClientId
		WHERE c.ClientId = @ClientId
			AND CP.[Status] IN (1,4)
			AND IsNull(CP.RecordDeleted, 'N') = 'N'
			AND IsNull(P.RecordDeleted, 'N') = 'N'
			AND IsNull(C.RecordDeleted, 'N') = 'N'
			OR CP.ClientProgramId IN (
				SELECT ClientProgramId
				FROM CustomDischargePrograms
				WHERE DocumentVersionId = @DocumentVersionId
					AND IsNull(RecordDeleted, 'N') = 'N'
				)
		ORDER BY CP.ClientProgramId ASC     

END TRY                                                                        
BEGIN CATCH                            
DECLARE @Error varchar(8000)                                                                      
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                   
+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RDLSubReportDischargedProgramsList')                                                                                                       
+ '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                        
+ '*****' + Convert(varchar,ERROR_STATE())                                                    
RAISERROR                                                                                                       
(                                                                         
@Error, -- Message text.     
16, -- Severity.     
1 -- State.                                                       
);                                                                                                    
END CATCH                                                   
END 