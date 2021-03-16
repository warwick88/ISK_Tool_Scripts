Note: While installing the package if you receive any error, please send the email to Builds and Releases <BRT@streamlinehealthcare.com> with the details. We will review the error and get back to you. 

Deployment Instructions:

------------------
Before Deployment:
------------------
1) No Need to stop the application pools since there is not DLL is available. 

2) Take back_up of database.

3) Copy and Execute the script manually available in below mentioned location
\\nocvm.azure.smartcarenet.com\sftp\kalamazoo\SCRIPTS\
  FirstStep_CreateSetupAndTrigger.sql
  

------------------
During Deployment:
------------------
1) Install the packages available in "Custom" folder in both Build and Database. 
	
	Install the Current Cumulative pack 
	PackageName: Cumulative KalamazooSCF202001020 - Current.zip

NOTE: For applying the Custom web objects in QA environment, please select till parallel to below mentioned location(Destination Folder).
     C:\inetpub\wwwroot\QA\Smartcare


----------------- 
After Deployment:
-----------------
1) Copy and Execute the script manually available in below mentioned location
\\nocvm.azure.smartcarenet.com\sftp\kalamazoo\SCRIPTS\
  LastStep_ScriptToDropTriggerAfterBuildDeployment.sql
 

2) Load the Url
  a) Do the RefreshSharedTable.aspx[https://slnonprod.iskzoo.org/ISKzooSmartCareQA/RefreshSharedTable.aspx]
  b) Login to Application.[https://slnonprod.iskzoo.org/ISKzooSmartCareQA/Login.aspx].

Note: This is only applicable for QA.






