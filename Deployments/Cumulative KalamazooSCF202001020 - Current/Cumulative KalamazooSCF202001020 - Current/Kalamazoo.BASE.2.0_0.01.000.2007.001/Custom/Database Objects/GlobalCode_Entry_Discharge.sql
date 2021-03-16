/********************************************************************************                                                   
--  
-- Copyright: Streamline Healthcare Solutions  
-- "Discharge"
-- Purpose: Global Code Entries to Bind Drop Down for for Task #929 - Valley - Customizations.
--  
-- Author:  Anto
-- Date:    17-FEB-2015

*********************************************************************************/
-- Transition/Discharge -- 
IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xPROGDISCHARGEREASON' AND Category = 'xPROGDISCHARGEREASON')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xPROGDISCHARGEREASON','xPROGDISCHARGEREASON','Y','Y','Y','Y','Valley - Customizations #929','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xPROGDISCHARGEREASON' ,CategoryName = 'xPROGDISCHARGEREASON',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'Valley - Customizations #929',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xPROGDISCHARGEREASON' AND Category = 'xPROGDISCHARGEREASON'
END


DELETE FROM GlobalSubCodes WHERE GlobalCodeId  IN (SELECT GlobalCodeId from GlobalCodes WHERE Category = 'xPROGDISCHARGEREASON')

DELETE FROM GlobalCodes WHERE Category = 'xPROGDISCHARGEREASON'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES 
('xPROGDISCHARGEREASON','Deceased/Natural','Valley - Customizations #929','Y','N',1),
('xPROGDISCHARGEREASON','Deceased/Suicide','Valley - Customizations #929','Y','N',2),

('xPROGDISCHARGEREASON','Deceased/Other','Valley - Customizations #929','Y','N',3),
('xPROGDISCHARGEREASON','Involuntary Discharge','Valley - Customizations #929','Y','N',4),

('xPROGDISCHARGEREASON','Long term leave-hospitalization','Valley - Customizations #929','Y','N',5),
('xPROGDISCHARGEREASON','Long term leave – incarceration','Valley - Customizations #929','Y','N',6),

('xPROGDISCHARGEREASON','Long term leave – nursing facility','Valley - Customizations #929','Y','N',7),
('xPROGDISCHARGEREASON','Member moved-out of geographic area','Valley - Customizations #929','Y','N',8),

('xPROGDISCHARGEREASON','Member moved-out of state','Valley - Customizations #929','Y','N',9),
('xPROGDISCHARGEREASON','Never engaged in services','Valley - Customizations #929','Y','N',10),

('xPROGDISCHARGEREASON','Services no longer needed-goals met','Valley - Customizations #929','Y','N',11),
('xPROGDISCHARGEREASON','Services not offered','Valley - Customizations #929','Y','N',12),

('xPROGDISCHARGEREASON','Service requested ended-against clinical advice','Valley - Customizations #929','Y','N',13),
('xPROGDISCHARGEREASON','Service requested ended – unable to locate','Valley - Customizations #929','Y','N',14),


('xPROGDISCHARGEREASON','Service request ended-w/clinical agreement','Valley - Customizations #929','Y','N',15),
('xPROGDISCHARGEREASON','Successful EBP completion','Valley - Customizations #929','Y','N',16),

('xPROGDISCHARGEREASON','Client not appropriate for treatment','Valley - Customizations #929','Y','N',17),
('xPROGDISCHARGEREASON','Evaluation only','Valley - Customizations #929','Y','N',18),

('xPROGDISCHARGEREASON','Administrative Close','Valley - Customizations #929','Y','N',19),
('xPROGDISCHARGEREASON','Crisis only','Valley - Customizations #929','Y','N',20),

('xPROGDISCHARGEREASON','Transition closure??','Valley - Customizations #929','Y','N',21),
('xPROGDISCHARGEREASON','Service requested ended - Client hasn’t received treatment in X number of days (add comment) ??','Valley - Customizations #929','Y','N',22)



-- Referral --

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xReferralOut' AND Category = 'xReferralOut')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xReferralOut','xReferralOut','Y','Y','Y','Y','Valley - Customizations #929','N','Y','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xReferralOut' ,CategoryName = 'xReferralOut',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'Valley - Customizations #929',UserDefinedCategory = 'N',HasSubcodes = 'Y',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xReferralOut' AND Category = 'xReferralOut'
END


DELETE FROM GlobalSubCodes WHERE GlobalCodeId  IN (SELECT GlobalCodeId from GlobalCodes WHERE Category = 'xReferralOut')

DELETE FROM GlobalCodes WHERE Category = 'xReferralOut'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES 
('xReferralOut','Probation/Parole','Valley - Customizations #929','Y','N',1),
('xReferralOut','Court','Valley - Customizations #929','Y','N',2),
('xReferralOut','Attorney','Valley - Customizations #929','Y','N',3),
('xReferralOut','Jail/Police','Valley - Customizations #929','Y','N',4),
('xReferralOut','School District/School','Valley - Customizations #929','Y','N',5),
('xReferralOut','Social Service Agency','Valley - Customizations #929','Y','N',6),
('xReferralOut','Nursing Home Ext Care','Valley - Customizations #929','Y','N',7),
('xReferralOut','Emergency Room','Valley - Customizations #929','Y','N',8),
('xReferralOut','Other Physician','Valley - Customizations #929','Y','N',9),
('xReferralOut','Psychiatric Hospital','Valley - Customizations #929','Y','N',10),
('xReferralOut','Output Psych Clinic','Valley - Customizations #929','Y','N',11),
('xReferralOut','Private Psychiatrist','Valley - Customizations #929','Y','N',12),
('xReferralOut','Other Private MH Practitioner','Valley - Customizations #929','Y','N',13),
('xReferralOut','Other CMHC','Valley - Customizations #929','Y','N',14),
('xReferralOut','Community Residential','Valley - Customizations #929','Y','N',15),
('xReferralOut','Other Input Residential','Valley - Customizations #929','Y','N',16),
('xReferralOut','Substance Use Input Tx','Valley - Customizations #929','Y','N',17),
('xReferralOut','Substance Use Output Tx','Valley - Customizations #929','Y','N',18),
('xReferralOut','Assisted Living','Valley - Customizations #929','Y','N',19),
('xReferralOut','Nursing Facility','Valley - Customizations #929','Y','N',20)










-- Treatment Completion --

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XTreatmentCompletion' AND Category = 'XTreatmentCompletion')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XTreatmentCompletion','XTreatmentCompletion','Y','Y','Y','Y','Valley - Customizations #929','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XTreatmentCompletion' ,CategoryName = 'XTreatmentCompletion',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'Valley - Customizations #929',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XTreatmentCompletion' AND Category = 'XTreatmentCompletion'
END

DELETE FROM GlobalSubCodes WHERE GlobalCodeId  IN (SELECT GlobalCodeId from GlobalCodes WHERE Category = 'XTreatmentCompletion')

DELETE FROM GlobalCodes WHERE Category = 'XTreatmentCompletion'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES 
('XTreatmentCompletion','Completed/substantially completed','Valley - Customizations #929','Y','N',1),
('XTreatmentCompletion','Mostly Completed','Valley - Customizations #929','Y','N',2),
('XTreatmentCompletion','Only partially completed','Valley - Customizations #929','Y','N',3),
('XTreatmentCompletion','Mostly not completed','Valley - Customizations #929','Y','N',4),
('XTreatmentCompletion','Does not apply (Evaluations Only)','Valley - Customizations #929','Y','N',5)



-- Referral at Discharge  --

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XReferralDischarge ' AND Category = 'XReferralDischarge')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XReferralDischarge','XReferralDischarge','Y','Y','Y','Y','Valley - Customizations #929','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XReferralDischarge' ,CategoryName = 'XReferralDischarge',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'Valley - Customizations #929',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XReferralDischarge' AND Category = 'XReferralDischarge'
END

DELETE FROM GlobalSubCodes WHERE GlobalCodeId  IN (SELECT GlobalCodeId from GlobalCodes WHERE Category = 'XReferralDischarge')


DELETE FROM GlobalCodes WHERE Category = 'XReferralDischarge'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES 
('XReferralDischarge','Not yet discharged/discontinued','Valley - Customizations #929','Y','N',1),
('XReferralDischarge','Self (Coded as 14-not referred)','Valley - Customizations #929','Y','N',2),
('XReferralDischarge','Family or Friend (Coded as 14-not referred)','Valley - Customizations #929','Y','N',3),
('XReferralDischarge','Physician, medical facility','Valley - Customizations #929','Y','N',4),
('XReferralDischarge','Social or community agency','Valley - Customizations #929','Y','N',5),
('XReferralDischarge','Educational system','Valley - Customizations #929','Y','N',6),
('XReferralDischarge','Courts, law enforcement, correctional agency','Valley - Customizations #929','Y','N',7),
('XReferralDischarge','Private psychiatric or private mental health program','Valley - Customizations #929','Y','N',8),
('XReferralDischarge','Public psychiatric or public mental health program','Valley - Customizations #929','Y','N',9),
('XReferralDischarge','Clergy','Valley - Customizations #929','Y','N',10),
('XReferralDischarge','Private practice mental health professional','Valley - Customizations #929','Y','N',11),
('XReferralDischarge','Other person or organization','Valley - Customizations #929','Y','N',12),
('XReferralDischarge','Deceased','Valley - Customizations #929','Y','N',13),
('XReferralDischarge','Dropped out of treatment/administrative discharge','Valley - Customizations #929','Y','N',14),
('XReferralDischarge','Not referred (see notes to 1 and 2)','Valley - Customizations #929','Y','N',15),
('XReferralDischarge','Unknown ','Valley - Customizations #929','Y','N',16)