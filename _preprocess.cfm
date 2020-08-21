<!--- 
	FileName:	prepocess.cfm
	Created on: 08/05/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: use to process URL.resetappl. It will reset application and session variables only to be used by developers
			 used mainly in DEV. Is sometimes used in PROD after promoting code to reset values.
		is ALSO used to:
			check for missing SESSION vars after someone has logged out
			log pages that were accessed
	
MODS: mm/dd/yyyy - flastname - comments
05/27/2009 - aarnone - T:7584 - added siteAccessLogID to WritePageAccessLogRecord so it will tie 
								page access rows to a single login session
10/9/2017 - rgonzalez - Ticket NCSA27025   - switch CGI.PATH_INFO with CGI.SCRIPT_NAME 											for recording the URL value into the 												database
 --->

 
<!--- reset application vars manually via URL param --->
<CFIF isDefined("URL.resetappl")>
	<CFINVOKE component="Application" method="setApplVals">
	</CFINVOKE> 
	<CFINVOKE component="Application" method="onSessionStart">
	</CFINVOKE> 

	<CFSET temp = structDelete(SESSION,"FOOTERMENU")>
	<CFSET temp = structDelete(SESSION,"PUBLICMENU")>
</CFIF>


<!--- The following forces the SESSION vars deleted by logout to be recreated.
	deleted vars:	SESSION.currentSeason
					SESSION.globalVars
 --->
<CFIF (NOT isDefined("SESSION.globalVars")) OR (NOT isDefined("SESSION.currentSeason"))>
	<CFINVOKE component="Application" method="onSessionStart">
	</CFINVOKE> 
</CFIF>


<!--- check if current season has changed
<cfinvoke component="#SESSION.SITEVARS.cfcPath#season" method="getCurrentSeason" returnvariable="qCurrSeas">
</cfinvoke>
<CFIF qCurrSeas.SEASON_ID NEQ SESSION.currentSeason.ID>
	<!--- the season has changed --->
	<CFINVOKE component="Application" method="onSessionStart">
	</CFINVOKE> 
</CFIF>
 --->

<!--- PAGEACCESS LOGGING --->
<CFIF isDefined("SESSION.USER")>
	<!--- we are logged in as someone --->
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#site" method="WritePageAccessLogRecord" >
		<cfinvokeargument name="userID" 		 value="#SESSION.USER.CONTACTID#">
		<cfinvokeargument name="siteAccessLogID" value="#SESSION.USER.SITEACCESSLOGID#">
		<cfinvokeargument name="sessionID" 		 value="#SESSION.SESSIONID#">
		<cfinvokeargument name="IPaddress" 		 value="#CGI.REMOTE_ADDR#">
		<!--- PATH_INFO is now null due to CF2016?? --->
		<!--- <cfinvokeargument name="URL" 			 value="#CGI.PATH_INFO#"> --->
		<cfinvokeargument name="URL" 			 value="#CGI.SCRIPT_NAME#">
	</cfinvoke>
</CFIF>








