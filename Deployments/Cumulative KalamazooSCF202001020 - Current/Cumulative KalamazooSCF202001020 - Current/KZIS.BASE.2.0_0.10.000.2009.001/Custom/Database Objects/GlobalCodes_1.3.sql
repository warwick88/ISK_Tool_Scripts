/*Date				Authour				Prupose                 */
/*06/09/2020		Jyothi Bellapu		Scripts for Care plan Domains and Needs KCMHSAS Improvements #7*/

---INSERT SCRIPT FOR CAREPLANDOMAINS AS PER ASSESSMENT REQUIRMENT

------------CarePlanDomains-------------------------
SET IDENTITY_INSERT CarePlanDomains ON 
IF NOT EXISTS (SELECT * from CarePlanDomains WHERE DomainName='Mental Health')
BEGIN  
INSERT INTO [CarePlanDomains] ([CarePlanDomainId],[DomainName])VALUES(1,'Mental Health')
END
IF NOT EXISTS (SELECT * from CarePlanDomains WHERE DomainName='Substance Use')
BEGIN
INSERT INTO [CarePlanDomains] ([CarePlanDomainId],[DomainName])VALUES(2,'Substance Use')
END
IF NOT EXISTS (SELECT * from CarePlanDomains WHERE DomainName='Physical Health')
BEGIN
INSERT INTO [CarePlanDomains] ([CarePlanDomainId],[DomainName])VALUES(3,'Physical Health')
END
IF NOT EXISTS (SELECT * from CarePlanDomains WHERE DomainName='Social/Interpersonal')
BEGIN
INSERT INTO [CarePlanDomains] ([CarePlanDomainId],[DomainName])VALUES(4,'Social/Interpersonal')
END
IF NOT EXISTS (SELECT * from CarePlanDomains WHERE DomainName='Traumatic Events')
BEGIN
INSERT INTO [CarePlanDomains] ([CarePlanDomainId],[DomainName])VALUES(5,'Traumatic Events')
END
IF NOT EXISTS (SELECT * from CarePlanDomains WHERE DomainName='Housing')
BEGIN
INSERT INTO [CarePlanDomains] ([CarePlanDomainId],[DomainName])VALUES(6,'Housing')
END
IF NOT EXISTS (SELECT * from CarePlanDomains WHERE DomainName='Medication')
BEGIN
INSERT INTO [CarePlanDomains] ([CarePlanDomainId],[DomainName])VALUES(7,'Medication')
END
IF NOT EXISTS (SELECT * from CarePlanDomains WHERE DomainName='Daily Living')
BEGIN
INSERT INTO [CarePlanDomains] ([CarePlanDomainId],[DomainName])VALUES(8,'Daily Living')
END
IF NOT EXISTS (SELECT * from CarePlanDomains WHERE DomainName='Advance Directive')
BEGIN
INSERT INTO [CarePlanDomains] ([CarePlanDomainId],[DomainName])VALUES(9,'Advance Directive')
END
IF NOT EXISTS (SELECT * from CarePlanDomains WHERE DomainName='Risk Behaviors')
BEGIN
INSERT INTO [CarePlanDomains] ([CarePlanDomainId],[DomainName])VALUES(10,'Risk Behaviors')
END
IF NOT EXISTS (SELECT * from CarePlanDomains WHERE DomainName='Employment/Training')
BEGIN
INSERT INTO [CarePlanDomains] ([CarePlanDomainId],[DomainName])VALUES(11,'Employment/Training')
END
IF NOT EXISTS (SELECT * from CarePlanDomains WHERE DomainName='Education')
BEGIN
INSERT INTO [CarePlanDomains] ([CarePlanDomainId],[DomainName])VALUES(12,'Education')
END
IF NOT EXISTS (SELECT * from CarePlanDomains WHERE DomainName='ASAM')
BEGIN
INSERT INTO [CarePlanDomains] ([CarePlanDomainId],[DomainName])VALUES(13,'ASAM')
END
IF NOT EXISTS (SELECT * from CarePlanDomains WHERE DomainName='Developmental')
BEGIN
INSERT INTO [CarePlanDomains] ([CarePlanDomainId],[DomainName])VALUES(14,'Developmental')
END
IF NOT EXISTS (SELECT * from CarePlanDomains WHERE DomainName='Family/Parenting')
BEGIN
INSERT INTO [CarePlanDomains] ([CarePlanDomainId],[DomainName])VALUES(15,'Family/Parenting')
END
IF NOT EXISTS (SELECT * from CarePlanDomains WHERE DomainName='Financial')
BEGIN
INSERT INTO [CarePlanDomains] ([CarePlanDomainId],[DomainName])VALUES(16,'Financial')
END
SET IDENTITY_INSERT CarePlanDomains OFF


----------------------CarePlanDomainNeeds-------------------------------
SET IDENTITY_INSERT CarePlanDomainNeeds ON
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=1 AND NeedName='MH History')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(1,1,'MH History')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=2 AND NeedName='Substance Use')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(2,2,'Substance Use')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=3 AND NeedName='Physical Health')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(3,3,'Physical Health')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=4 AND NeedName='Cultural/Ethnic')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(4,4,'Cultural/Ethnic')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=5 AND NeedName='Abuse/Neglect/Trauma')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(5,5,'Abuse/Neglect/Trauma')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=4 AND NeedName='Sexual Behaviors')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(6,4,'Sexual Behaviors')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=7 AND NeedName='Medication')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(7,7,'Medication')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=3 AND NeedName='Immunity')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(8,3,'Immunity')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=15 AND NeedName='Family Functioning')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(9,15,'Family Functioning')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=4 AND NeedName='Sexual Preference/Orientation')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(10,4,'Sexual Preference/Orientation')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=11 AND NeedName='Education/Training')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(11,11,'Education/Training')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=11 AND NeedName='Personal Career Planning')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(12,11,'Personal Career Planning')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=11 AND NeedName='Employment Opportunities')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(13,11,'Employment Opportunities')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=11 AND NeedName='Support Employment and Work Practices')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(14,11,'Support Employment and Work Practices')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=11 AND NeedName='Work History')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(15,11,'Work History')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=11 AND NeedName='Gainful Employment')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(41,11,'Gainful Employment')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=12 AND NeedName='Education Challenges/Barriers')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(42,12,'Education Challenges/Barriers')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=3 AND NeedName='Communicable Disease Risk')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(43,3,'Communicable Disease Risk')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=1 AND NeedName='Anxiety')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(16,1,'Anxiety')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=1 AND NeedName='Depression')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(17,1,'Depression')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=14 AND NeedName='Language')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(18,14,'Language')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=14 AND NeedName='Visual')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(19,14,'Visual')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=14 AND NeedName='Intellectual')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(20,14,'Intellectual')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=14 AND NeedName='Learning')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(21,14,'Learning')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=14 AND NeedName='Prenatal Care')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(22,14,'Prenatal Care')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=14 AND NeedName='Pregnancy')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(23,14,'Pregnancy')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=14 AND NeedName='Prenatal Exposures')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(24,14,'Prenatal Exposures')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=14 AND NeedName='Medication during Pregnancy')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(25,14,'Medication during Pregnancy')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=14 AND NeedName='Issue with delivery')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(26,14,'Issue with delivery')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=14 AND NeedName='Milestones')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(27,14,'Milestones')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=14 AND NeedName='Talk before walk')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(28,14,'Talk before walk')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=8 AND NeedName='General Appearance')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(29,8,'General Appearance')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=14 AND NeedName='Intellectual Assessment')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(30,14,'Intellectual Assessment')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=1 AND NeedName='Communication')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(31,1,'Communication')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=1 AND NeedName='Mood')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(32,1,'Mood')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=1 AND NeedName='Affect')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(33,1,'Affect')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=1 AND NeedName='Speech')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(34,1,'Speech')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=1 AND NeedName='Thought')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(35,1,'Thought')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=1 AND NeedName='Behavior')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(36,1,'Behavior')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=1 AND NeedName='Orientation')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(37,1,'Orientation')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=1 AND NeedName='Insight')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(38,1,'Insight')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=1 AND NeedName='Memory')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(39,1,'Memory')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=1 AND NeedName='Reality Orientation')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(40,1,'Reality Orientation')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=10 AND NeedName='Sucidiality')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(44,10,'Sucidiality')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=10 AND NeedName='Physical Aggression')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(45,10,'Physical Aggression')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=10 AND NeedName='Other Risk Factor')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(46,10,'Other Risk Factor')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=9 AND NeedName='Advance Directive')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(47,9,'Advance Directive')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=12 AND NeedName='School/Work Role Performance')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(48,12,'School/Work Role Performance')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=15 AND NeedName='Home Role Performance')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(49,15,'Home Role Performance')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=4 AND NeedName='Community Role Performance')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(50,4,'Community Role Performance')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=4 AND NeedName='Behavior Toward Others')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(51,4,'Behavior Toward Others')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=1 AND NeedName='Moods/Emotions')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(52,1,'Moods/Emotions')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=10 AND NeedName='Self-Harmful Behavior')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(53,10,'Self-Harmful Behavior')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=1 AND NeedName='Thinking')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(54,1,'Thinking')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=15 AND NeedName='Primary Material')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(55,15,'Primary Material')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=15 AND NeedName='Primary Support')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(56,15,'Primary Support')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=15 AND NeedName='Non-Custodial Material')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(57,15,'Non-Custodial Material')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=15 AND NeedName='Non-Custodial Support')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(58,15,'Non-Custodial Support')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=15 AND NeedName='Surrogate Material')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(59,15,'Surrogate Material')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=15 AND NeedName='Surrogate Support')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(60,15,'Surrogate Support')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=8 AND NeedName='Health Practices')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(61,8,'Health Practices')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=6 AND NeedName='Housing Stability Maintenance')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(62,6,'Housing Stability Maintenance')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=8 AND NeedName='Communication')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(63,8,'Communication')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=10 AND NeedName='Safety')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(64,10,'Safety')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=8 AND NeedName='Managing Time')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(65,8,'Managing Time')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=16 AND NeedName='Managing Money')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(66,16,'Managing Money')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=8 AND NeedName='Nutrition')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(67,8,'Nutrition')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=8 AND NeedName='Problem Solving')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(68,8,'Problem Solving')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=15 AND NeedName='Family Relationships')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(69,15,'Family Relationships')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=2 AND NeedName='Alcohol/Drug Use')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(70,2,'Alcohol/Drug Use')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=8 AND NeedName='Leisure')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(71,8,'Leisure')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=4 AND NeedName='Community Resources')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(72,4,'Community Resources')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=4 AND NeedName='Social Network')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(73,4,'Social Network')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=4 AND NeedName='Sexuality')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(74,4,'Sexuality')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=8 AND NeedName='Productivity')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(75,8,'Productivity')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=8 AND NeedName='Coping Skills')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(76,8,'Coping Skills')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=4 AND NeedName='Behavior Norms')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(77,4,'Behavior Norms')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=8 AND NeedName='Personal Hygiene')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(78,8,'Personal Hygiene')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=8 AND NeedName='Grooming')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(79,8,'Grooming')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=8 AND NeedName='Dress')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(80,8,'Dress')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=13 AND NeedName='Dimension 1')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(81,13,'Dimension 1')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=13 AND NeedName='Dimension 2')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(82,13,'Dimension 2')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=13 AND NeedName='Dimension 3')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(83,13,'Dimension 3')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=13 AND NeedName='Dimension 4')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(84,13,'Dimension 4')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=13 AND NeedName='Dimension 5')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(85,13,'Dimension 5')
END
IF NOT EXISTS(SELECT CarePlanDomainId from CarePlanDomainNeeds WHERE CarePlanDomainId=13 AND NeedName='Dimension 6')
BEGIN
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(86,13,'Dimension 6')
END

SET IDENTITY_INSERT CarePlanDomainNeeds OFF






