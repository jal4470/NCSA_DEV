<!--- 
	FileName:	fineDisplay.cfm
	Created on: 10/13/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfinclude template="_checkLogin.cfm">
<cfoutput>
<cfif isDefined("URL.fnid") AND isNumeric(URL.fnid)>
	<CFSET fineID = URL.fnid>
<CFELSE>
	<cflocation url="finesListAll.cfm">
</cfif>

<cfinclude template="fineDisplayinclude.cfm">

</cfoutput>
