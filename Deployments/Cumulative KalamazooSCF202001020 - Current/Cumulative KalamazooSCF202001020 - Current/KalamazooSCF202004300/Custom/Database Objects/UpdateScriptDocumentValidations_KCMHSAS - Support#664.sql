
/********************************************************************************
 Script -	

 Date		Author		Purpose
 04/14/2020	Hemant	
						What: Update script to correct the validation messages which has weird symbols.
						Why:  KCMHSAS - Support #664

*********************************************************************************/


Update DocumentValidations Set ErrorMessage = 'Demographic Information - If age is over 26, Currently in Mainstream Special Education Status must be No.' where 
ErrorMessage = 'Demographic Information - If age is over 26, â€˜Currently in Mainstream Special Education Statusâ€™ must be â€˜No.â€™' 
and DocumentCodeID = 35102

Update DocumentValidations Set ErrorMessage = 'Admission Information - Service Start time is required.' where 
ErrorMessage = 'Admission Information â€“ Service Start time is required.' 
and DocumentCodeID = 35102

Update DocumentValidations Set ErrorMessage = 'Treatment Information - Correction Related Status is required' where 
ErrorMessage = 'Treatment Information - â€˜Correction Related Statusâ€™ is required' 
and DocumentCodeID = 35102

Update DocumentValidations Set ErrorMessage = 'Treatment Information - Medication-assisted Opioid Therapy cannot be `Not Applicable` as the client has an opioid substance noted in Substance Use History.' where 
ErrorMessage = 'Treatment Information â€“ â€˜Medication â€“ assisted Opioid Therapy cannot be â€˜Not Applicableâ€™ as the client has an opioid substance noted in Substance Use History.'
and DocumentCodeID = 35102

Update DocumentValidations Set ErrorMessage = 'Substance Use History - BH TEDS Full Record Exception cannot be answered as Secondary and Tertiary Substance Use Information Not collected BH TEDS full record exception' where 
ErrorMessage = 'Substance Use History â€“ â€˜BH TEDS Full Record Exceptionâ€™ cannot be answered as â€˜Secondary and Tertiary Substance Use Information Not collected â€“ BH TEDS full record exceptionâ€™'
and DocumentCodeID = 35102

Update DocumentValidations Set ErrorMessage = 'Substance Use History - BH TEDS Full Record Exception cannot be answered as Tertiary Substance Use Information Not collected BH TEDS full record exception' where 
ErrorMessage = 'Substance Use History â€“ â€˜BH TEDS Full Record Exceptionâ€™ cannot be answered as â€˜Tertiary Substance Use Information Not collected â€“ BH TEDS full record exceptionâ€™'
and DocumentCodeID = 35102

Update DocumentValidations Set ErrorMessage = 'Treatment Information - Integrated Substance Use and Mental Health Treatment Cannot be No & Not Co-occurring if there is at least one SUD diagnosis in the Diagnosis tab.' where 
ErrorMessage = 'Treatment Information â€“ â€˜Integrated Substance Use and Mental Health Treatmentâ€™ â€“ Cannot be â€˜No â€“ Not Co-occurringâ€™ if there is at least one SUD diagnosis in the Diagnosis tab.'
and DocumentCodeID = 35102

Update DocumentValidations Set ErrorMessage = 'Income Information - Work/Task Hours is required.' where 
ErrorMessage = 'Income Information â€“ â€˜Work/Task Hoursâ€™ is required.'
and DocumentCodeID = 35102

Update DocumentValidations Set ErrorMessage = 'Income Information - Earnings per hour is required.' where 
ErrorMessage = 'Income Information â€“ â€˜Earnings per hourâ€™ is required.'
and DocumentCodeID = 35102

Update DocumentValidations Set ErrorMessage = 'Admission Information - Service Start Date cannot be greater than today`s date.' where 
ErrorMessage = 'Admission Information â€“ â€˜Service Start Dateâ€™ cannot be greater than todayâ€™s date.'
and DocumentCodeID = 35102

Update DocumentValidations Set ErrorMessage = 'Admission Information - Effective date cannot be greater than the Service Start Date.' where 
ErrorMessage = 'Admission Information â€“ â€˜Effectiveâ€™ date cannot be greater than the â€˜Service Start Date.â€™'
and DocumentCodeID = 35102

Update DocumentValidations Set ErrorMessage = 'Admission - BH TEDS Full Record Exception field cannot be `Not applicable` for FY17 record submitted in FY18 Format.' where 
ErrorMessage = 'Admission â€“ BH TEDS Full Record Exception field cannot be â€˜Not applicable for FY17 record submitted in FY18 Format.â€™'
and DocumentCodeID = 35102

Update DocumentValidations Set ErrorMessage = 'Admission - BH TEDS Full Record Exception field must be `Not applicable` for FY17 record submitted in FY18 format.' where 
ErrorMessage = 'Admission â€“ BH TEDS Full Record Exception field must be â€˜Not applicable for FY17 record submitted in FY18 format.â€™'
and DocumentCodeID = 35102

Update DocumentValidations Set ErrorMessage = 'Admission - BH TEDS Full Record Exception field must be `Yes, Crisis Only Service.`' where 
ErrorMessage = 'Admission â€“ BH TEDS Full Record Exception field must be â€˜Yes, Crisis Only Serviceâ€™.'
and DocumentCodeID = 35102

Update DocumentValidations Set ErrorMessage = 'Substance Use History - must have a Substance with a Preference of two.' where 
ErrorMessage = 'Substance Use History â€“ must have a â€˜Substanceâ€™ with a Preference of two.'
and DocumentCodeID = 35102

Update DocumentValidations Set ErrorMessage = 'Substance Use History - Cannot have any Substances with a Preference of three or more.' where 
ErrorMessage = 'Substance Use History â€“ Cannot have any Substances with a â€˜Preferenceâ€™ of three or more.'
and DocumentCodeID = 35102

Update DocumentValidations Set ErrorMessage = 'Substance Use History - Cannot have any Substances with a Preference of two or more.' where 
ErrorMessage = 'Substance Use History â€“ Cannot have any Substances with a â€˜Preferenceâ€™ of two or more.'
and DocumentCodeID = 35102

Update DocumentValidations Set ErrorMessage = 'Substance Use History - There is one substance where Preference = 3, but there is not a substance marked Preference = 2. Please update one substance to Preference = 2' where 
ErrorMessage = 'Substance Use History - There is one substance where â€˜Preferenceâ€™ = 3, but there is not a substance marked â€˜Preferenceâ€™ = 2.  Please update one substance to â€˜Preferenceâ€™ = 2'
and DocumentCodeID = 35102

--Fixed in QA
Update DocumentValidations Set ErrorMessage = 'Demographic Information - If age is over 26, Currently in Mainstream Special Education Status must be Not applicable.' where 
ErrorMessage = 'Demographic Information - If age is over 26, â€˜Currently in Mainstream Special Education Statusâ€™ must be â€˜Not applicable.â€™'
and DocumentCodeID = 35102

--Fixed in QA
Update DocumentValidations Set ErrorMessage = 'LOCUS - Please select a Not Completed reason or complete both Score and Assessment Date fields.'
where ErrorMessage = 'LOCUS - Please select a â€˜Not Completedâ€™ reason or complete both â€˜Scoreâ€™ and â€˜Assessment Dateâ€™ fields.'
and DocumentCodeID = 35102

--Fixed in QA
Update DocumentValidations Set ErrorMessage = 'LOCUS - Score is required.'
where ErrorMessage = 'LOCUS â€“ â€˜Scoreâ€™ is required.'
and DocumentCodeID = 35102

Update DocumentValidations Set ErrorMessage = 'LOCUS - Assessment Date is required.'
where ErrorMessage = 'LOCUS â€“ â€˜Assessment Dateâ€™ is required.'
and DocumentCodeID = 35102

Update DocumentValidations Set ErrorMessage = 'Treatment Information - Pregnant on Service Start Date cannot be answered as Not Collected MH BH-TEDS Full Record Exception'
where ErrorMessage = 'Treatment Information - â€˜Pregnant on Service Start Dateâ€™ cannot be answered as â€˜Not Collected MH BH-TEDS Full Record Exceptionâ€™'
and DocumentCodeID = 35102

Update DocumentValidations Set ErrorMessage = 'Treatment Information - Please review Pregnant on Service Start Date to assure it aligns with client sex.'
where ErrorMessage = 'Treatment Information - Please review â€˜Pregnant on Service Start Dateâ€™ to assure it aligns with client sex.'
and DocumentCodeID = 35102

--Fixed in QA
Update DocumentValidations Set ErrorMessage = 'Income Information - Minimum wage is required.If Minimum Wage is unknown, select Not Collected - BH TEDS full record exception'
where ErrorMessage = 'Income Information â€“ â€˜Minimum wageâ€™ is required.  If â€˜Minimum Wageâ€™ is unknown, select â€˜Not Collected â€“ BH TEDS full record exceptionâ€™'
and DocumentCodeID = 35102

Update DocumentValidations Set ErrorMessage =  'Demographic Information - `Minimum Wage` cannot be `Not Collected MH BH-TEDS Full Record Exception.`'
where ErrorMessage = 'Demographic Information - â€˜Minimum Wageâ€™ cannot be â€˜Not Collected MH BH-TEDS Full Record Exception.â€™'
and DocumentCodeID = 35102

--Fixed in QA
Update DocumentValidations Set ErrorMessage =  'Income Information - Minimum wage is required.'
where ErrorMessage = 'Income Information â€“ â€˜Minimum wageâ€™ is required.' 
and DocumentCodeID = 35102

--Fixed in QA
Update DocumentValidations Set ErrorMessage =  'Treatment Information - Type of Treatment Service Settings is State Psychiatric Hospital so Legal Status at Admission to State Hospital cannot be Not Applicable or blank.'
where ErrorMessage = 'Treatment Information - â€˜Type of Treatment Service Settingsâ€™ is â€˜State Psychiatric Hospitalâ€™ so â€˜Legal Status at Admission to State Hospitalâ€™ cannot be â€˜Not Applicableâ€™ or blank.' 
and DocumentCodeID = 35102

--Fixed in QA
Update DocumentValidations Set ErrorMessage =  'Client - Please choose any one from Gender.'
where ErrorMessage = 'Client - Please choose any one from â€˜Gender.â€™' 
and DocumentCodeID = 35102

Update DocumentValidations Set ErrorMessage =  'Demographic Information - Client/Family enrolled in/connected to VA/Veteran resources/supports is required'
where ErrorMessage = 'Demographic Information â€“ Client/Family enrolled in/connected to VA/Veteran resources/supports is required'  
and DocumentCodeID = 35102

Update DocumentValidations Set ErrorMessage =  'Demographic - Demographic Information - Currently in Mainstream Special Education status cannot be Not Applicable for an FY17 record.'
where ErrorMessage = 'Demographic â€“ Demographic Information - Currently in Mainstream Special Education status cannot be Not Applicable for an FY17 record.' 
and DocumentCodeID = 35102

Update DocumentValidations Set ErrorMessage =  'Demographic - Demographic Information: Minimum Wage cannot be Not Collected MH BH-TEDS Full Record Exception.'
where ErrorMessage = 'Demographic â€“ Demographic Information: Minimum Wage cannot be Not Collected MH BH-TEDS Full Record Exception.' 
and DocumentCodeID = 35102

Update DocumentValidations Set ErrorMessage =  'Demographic - Demographic Information: Client/Family enrolled in/connected to VA/Veteran cannot be Not applicable for FY17 record submitted in FY18 format.'
where ErrorMessage = 'Demographic â€“ Demographic Information: Client/Family enrolled in/connected to VA/Veteranâ€¦ cannot be Not applicable for FY17 record submitted in FY18 format.' 
and DocumentCodeID = 35102

Update DocumentValidations Set ErrorMessage =  'Demographic - Demographic Information: Client/Family enrolled in/connected to VA/Veteran must be Not applicable for FY17 record submitted in FY18 format.'
where ErrorMessage = 'Demographic â€“ Demographic Information: Client/Family enrolled in/connected to VA/Veteranâ€¦ must be Not applicable for FY17 record submitted in FY18 format.' 
and DocumentCodeID = 35102

Update DocumentValidations Set ErrorMessage =  'Demographic - Demographic Information: Most Recent Military Service Era cannot be Not applicable for FY17 record submitted in FY18 format.'
where ErrorMessage = 'Demographic â€“ Demographic Information: Most Recent Military Service Era cannot be Not applicable for FY17 record submitted in FY18 format.'  
and DocumentCodeID = 35102

Update DocumentValidations Set ErrorMessage =  'Demographic - Demographic Information: Most Recent Military Service Era cannot be Not Collected MH BH-TEDS Full Record Exception.'
where ErrorMessage = 'Demographic â€“ Demographic Information: Most Recent Military Service Era cannot be Not Collected MH BH-TEDS Full Record Exception.'  
and DocumentCodeID = 35102

Update DocumentValidations Set ErrorMessage =  'Demographic - Demographic Information: Most Recent Military Service Era must be Not applicable for FY17 record submitted in FY18 format.'
where ErrorMessage = 'Demographic â€“ Demographic Information: Most Recent Military Service Era must be Not applicable for FY17 record submitted in FY18 format.'  
and DocumentCodeID = 35102

Update DocumentValidations Set ErrorMessage =  'Demographic - Demographic Information: Branch Served In cannot be Not applicable for FY17 record submitted in FY18 format.'
where ErrorMessage = 'Demographic â€“ Demographic Information: Branch Served In cannot be Not applicable for FY17 record submitted in FY18 format.'  
and DocumentCodeID = 35102

Update DocumentValidations Set ErrorMessage =  'Demographic - Demographic Information: Branch Served In cannot be Not Collected MH BH-TEDS Full Record Exception.'
where ErrorMessage = 'Demographic â€“ Demographic Information: Branch Served In cannot be Not Collected MH BH-TEDS Full Record Exception.' 
and DocumentCodeID = 35102

Update DocumentValidations Set ErrorMessage =  'Demographic - Demographic Information: Branch Served In must be Not applicable for FY17 record submitted in FY18 format.'
where ErrorMessage = 'Demographic â€“ Demographic Information: Branch Served In must be Not applicable for FY17 record submitted in FY18 format.'  
and DocumentCodeID = 35102

Update DocumentValidations Set ErrorMessage =  'Demographic - Demographic Information: Have you or your family ever served in the military? cannot be Not applicable for FY17 record submitted in FY18 format.'
where ErrorMessage = 'Demographic â€“ Demographic Information: Have you or your family ever served in the military? cannot be Not applicable for FY17 record submitted in FY18 format.' 
and DocumentCodeID = 35102

Update DocumentValidations Set ErrorMessage =  'Demographic - Demographic Information: Have you or your family ever served in the military? cannot be Not Collected MH BH-TEDS Full Record Exception.'
where ErrorMessage = 'Demographic â€“ Demographic Information: Have you or your family ever served in the military? cannot be Not Collected MH BH-TEDS Full Record Exception.' 
and DocumentCodeID = 35102

Update DocumentValidations Set ErrorMessage =  'Demographic - Demographic Information: Have you or your family ever served in the military? must be Not applicable for FY17 record submitted in FY18 format.'
where 
ErrorMessage = 'Demographic â€“ Demographic Information: Have you or your family ever served in the military? must be Not applicable for FY17 record submitted in FY18 format.' 
and DocumentCodeID = 35102

Update DocumentValidations Set ErrorMessage =  'Demographic - Demographic Information: School attendance status cannot be Not Collected MH BH-TEDS Full Record Exception.'
where 
ErrorMessage = 'Demographic â€“ Demographic Information: School attendance status cannot be Not Collected MH BH-TEDS Full Record Exception.'  
and DocumentCodeID = 35102

Update DocumentValidations Set ErrorMessage =  'Demographic - Demographic Information: Currently in Mainstream Special Education status cannot be Not Collected MH BH-TEDS Full Record Exception.'
where 
ErrorMessage = 'Demographic â€“ Demographic Information: Currently in Mainstream Special Education status cannot be Not Collected MH BH-TEDS Full Record Exception.' 
and DocumentCodeID = 35102

--Fixed in QA
Update DocumentValidations Set ErrorMessage =  'Demographic - Demographic Information: Education cannot be Not Collected MH BH-TEDS Full Record Exception.'
where 
ErrorMessage = 'Demographic â€“ Demographic Information: Education cannot be Not Collected MH BH-TEDS Full Record Exception.'  
and DocumentCodeID = 35102
--Fixed in QA
Update DocumentValidations Set ErrorMessage =  'Demographic - Demographic Information: Veteran Status cannot be Not Collected MH BH-TEDS Full Record Exception.'
where 
ErrorMessage = 'Demographic â€“ Demographic Information: Veteran Status cannot be Not Collected MH BH-TEDS Full Record Exception.' 
 and DocumentCodeID = 35102
--Fixed in QA
Update DocumentValidations Set ErrorMessage =  'Demographic - Demographic Information: Marital Status cannot be Not Collected MH BH-TEDS Full Record Exception.'
where 
ErrorMessage = 'Demographic â€“ Demographic Information: Marital Status cannot be Not Collected MH BH-TEDS Full Record Exception.' 
and DocumentCodeID = 35102
--Fixed in QA
Update DocumentValidations Set ErrorMessage =  'If a Substance is checked on the Substance Use History tab, then Route is required for that substance and cannot be Not Applicable.'
where 
ErrorMessage = 'If a Substance is checked on the Substance Use History tab, then Route is required for that substance and cannot be â€˜Not Applicable.â€™'  
and DocumentCodeID = 35102
--Fixed in QA
Update DocumentValidations Set ErrorMessage =  'If a Substance is checked on the Substance Use History tab, then Frequency is required for that substance and cannot be Not Applicable.'
where 
ErrorMessage = 'If a Substance is checked on the Substance Use History tab, then Frequency is required for that substance and cannot be â€˜Not Applicable.â€™'  
and DocumentCodeID = 35102
--Fixed in QA
Update DocumentValidations Set ErrorMessage =  'Substance Use History: Integrated Substance Use and Mental Health Treatment is not No, so one substance must be marked as Preference = 1'
where 
ErrorMessage = 'Substance Use History: â€˜Integrated Substance Use and Mental Health Treatmentâ€™ is not No, so one substance must be marked as â€˜Preferenceâ€™ = 1'  
and DocumentCodeID = 35102
--Fixed in QA
Update DocumentValidations Set ErrorMessage =  'Demographic - School Attendance Status: Client is between ages of 3 and 17, so Not applicable is not an allowed answer.'
where 
ErrorMessage = 'Demographic â€“ School Attendance Status: Client is between ages of 3 and 17, so â€˜Not applicableâ€™ is not an allowed answer.'  
and DocumentCodeID = 35102
--Fixed in QA
Update DocumentValidations Set ErrorMessage =  'Demographics: Not in Competitive Integrated Labor Force cannot be Not Applicable or N/A - Individual is under 16 years of age due to Employment status being Not in competitive, integrated labor force'
where 
ErrorMessage = 'Demographics: Not in Competitive Integrated Labor Force cannot be â€˜Not Applicableâ€™ or â€˜N/A â€“ Individual is under 16 years of ageâ€™ due to Employment status being â€˜Not in competitive, integrated labor force'  
and DocumentCodeID = 35102
--Fixed in QA
Update DocumentValidations Set ErrorMessage =  'Demographic - Client is under the age of 16, so Detailed Not in Competitive Integrated Labor Force must be N/A - Individual is under 16 years of age'
where 
ErrorMessage = 'Demographic - Client is under the age of 16, so â€˜Detailed Not in Competitive Integrated Labor Forceâ€™ must be â€˜N/A â€“ Individual is under 16 years of age' 
and DocumentCodeID = 35102
--Fixed in QA
Update DocumentValidations Set ErrorMessage =  'Demographics - If the client is under 16 years of age, then Employment Status must be entered as N/A. Individual is under 16 years of age.'
where 
ErrorMessage = 'Demographics - If the client is under 16 years of age, then â€˜Employment Status must be entered as â€˜N/A â€“ Individual is under 16 years of age.'  
and DocumentCodeID = 35102
--Fixed in QA
Update DocumentValidations Set ErrorMessage =  'Treatment Information - Medication Assisted Opioid Therapy must be Not Applicable as the client does not have opioid substance noted in Substance Use History with a preference of 1, 2, or 3.'
where 
ErrorMessage = 'Treatment Information â€“ Medication Assisted Opioid Therapy must be â€˜Not Applicableâ€™ as the client does not have opioid substance noted in Substance Use History with a preference of 1, 2, or 3.' 
and DocumentCodeID = 35102


Update DocumentValidations set ErrorMessage = 'Demographic – Demographic Information: Client/Family enrolled in/connected to VA/Veteran… cannot be Not applicable for FY17 record submitted in FY18 format.'
Where ErrorMessage = 'Demographic - Demographic Information: Client/Family enrolled in/connected to VA/Veteranâ€¦ cannot be Not applicable for FY17 record submitted in FY18 format.'
and DocumentCodeID = 35102



































