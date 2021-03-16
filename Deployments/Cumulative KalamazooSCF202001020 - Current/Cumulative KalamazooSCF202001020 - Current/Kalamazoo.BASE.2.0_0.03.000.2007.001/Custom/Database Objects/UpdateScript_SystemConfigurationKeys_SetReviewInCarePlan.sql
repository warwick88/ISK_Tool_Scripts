--Author - Ankita Sinha
-- Task KCMHSAS #8 
IF EXISTS(Select 1 from SystemConfigurationKeys where [Key]='SetReviewInCarePlan')
BEGIN

UPDATE SystemConfigurationKeys Set [Value]='Y' WHERE  [Key]='SetReviewInCarePlan'
END