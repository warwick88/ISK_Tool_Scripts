--Date: 09/01/2020
--Puropose: Reverting the changes done as part of KCMHSAS Improvements #12 as it was giving Error in Assessment document. KCMHSAS Support #1511

IF EXISTS (SELECT 1 FROM DocumentValidations where DocumentcodeId=1469 AND TabName='Functional Assessment')
BEGIN
UPDATE DocumentValidations SET RecordDeleted='Y' where DocumentcodeId=1469 AND TabName='Functional Assessment'
END

IF EXISTS (SELECT 1 FROM DocumentValidations where DocumentcodeId=1469 AND TabName='Diagnosis-IDD Eligibility')
BEGIN
UPDATE DocumentValidations SET RecordDeleted='Y' where DocumentcodeId=1469 AND TabName='Diagnosis-IDD Eligibility'
END