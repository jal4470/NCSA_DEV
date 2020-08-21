<!--- 
	FileName:	logout.cfm
	Created on: 08/21/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: this page will crush the structures created when a user logs in
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<!--- removing USER will force site to make a user log in again --->
<CFSET temp = structDelete(SESSION,"USER")>

<!--- These are deleted because it is possible that the values may have been changed by admin. 
removing them will cause them to be refreshed by _preprocess.cfm  --->
<CFSET temp = structDelete(SESSION,"regSeason")>
<CFSET temp = structDelete(SESSION,"currentSeason")>
<CFSET temp = structDelete(SESSION,"globalVars")>
<CFSET temp = structDelete(SESSION,"menuRoleID")>



<CFLOCATION url="index.cfm">
 