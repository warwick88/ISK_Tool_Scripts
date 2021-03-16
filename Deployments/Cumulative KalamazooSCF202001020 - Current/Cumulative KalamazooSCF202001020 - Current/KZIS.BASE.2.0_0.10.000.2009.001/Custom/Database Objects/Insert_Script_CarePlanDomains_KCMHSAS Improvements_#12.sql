

/*Date			Author			Purpose*/ 
/*18/06/2020    Josekutty          
							 -- What       :- Scripts for CarePlanDomains and CarePlanDomainNeeds 
							 -- Why        :- Insert script has to be generated for the tabs Diagnosis-IDD Eligibility and Functional Assessment
							 -- Portal Task:- #12 in KCMHSAS Improvements.  
							 
*/


IF Not Exists(Select * from CarePlanDomains Where CarePlanDomainId = 17)
 Begin
	SET IDENTITY_INSERT CarePlanDomains ON  
	INSERT INTO [CarePlanDomains] ([CarePlanDomainId],[DomainName])VALUES(17,'Self-Care')
	SET IDENTITY_INSERT CarePlanDomains OFF
 End;

IF Not Exists(Select * from CarePlanDomainNeeds Where CarePlanDomainNeedId = 87)
 Begin
   SET IDENTITY_INSERT CarePlanDomainNeeds ON
   INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(87,17,'Self-Care Skills')
   SET IDENTITY_INSERT CarePlanDomainNeeds OFF
 End; 

IF Not Exists(Select * from CarePlanDomainNeeds Where CarePlanDomainNeedId = 88)
Begin
SET IDENTITY_INSERT CarePlanDomainNeeds ON
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(88,8,'Daily Living Skills')
SET IDENTITY_INSERT CarePlanDomainNeeds OFF
end;

IF Not Exists(Select * from CarePlanDomains Where CarePlanDomainId = 18)
Begin
SET IDENTITY_INSERT CarePlanDomains ON  
INSERT INTO [CarePlanDomains] ([CarePlanDomainId],[DomainName])VALUES(18,'Social Emotional Behavioral')
SET IDENTITY_INSERT CarePlanDomains OFF
end;

IF Not Exists(Select * from CarePlanDomainNeeds Where CarePlanDomainNeedId = 89)
begin
SET IDENTITY_INSERT CarePlanDomainNeeds ON
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(89,18,'Social Functioning')
SET IDENTITY_INSERT CarePlanDomainNeeds OFF
end; 

IF Not Exists(Select * from CarePlanDomainNeeds Where CarePlanDomainNeedId = 90)
begin
SET IDENTITY_INSERT CarePlanDomainNeeds ON
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(90,18,'Emotional Functioning')
SET IDENTITY_INSERT CarePlanDomainNeeds OFF
end 

IF Not Exists(Select * from CarePlanDomainNeeds Where CarePlanDomainNeedId = 91)
begin
SET IDENTITY_INSERT CarePlanDomainNeeds ON
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(91,18,'Behavioral Functioning')
SET IDENTITY_INSERT CarePlanDomainNeeds OFF
end;

IF Not Exists(Select * from CarePlanDomains Where CarePlanDomainId = 19)
begin
SET IDENTITY_INSERT CarePlanDomains ON  
INSERT INTO [CarePlanDomains] ([CarePlanDomainId],[DomainName])VALUES(19,' Communication')
SET IDENTITY_INSERT CarePlanDomains OFF
end;

IF Not Exists(Select * from CarePlanDomainNeeds Where CarePlanDomainNeedId = 92)
begin
SET IDENTITY_INSERT CarePlanDomainNeeds ON
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(92,19,'Communication')
SET IDENTITY_INSERT CarePlanDomainNeeds OFF
end;

IF Not Exists(Select * from CarePlanDomains Where CarePlanDomainId = 20)
begin
SET IDENTITY_INSERT CarePlanDomains ON  
INSERT INTO [CarePlanDomains] ([CarePlanDomainId],[DomainName])VALUES(20,' Community')
SET IDENTITY_INSERT CarePlanDomains OFF
end;

IF Not Exists(Select * from CarePlanDomainNeeds Where CarePlanDomainNeedId = 93)
begin
SET IDENTITY_INSERT CarePlanDomainNeeds ON
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(93,20,'Community Living Skills')
SET IDENTITY_INSERT CarePlanDomainNeeds OFF
end;
 