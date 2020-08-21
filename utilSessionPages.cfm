<!--- 
	FileName:	utilSessionPages.cfm
	Created on: 05/19/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

05/19/09 - aa - new report Ticket# 7584
05/27/09 - aa - T:7584 - added siteAccessLog_ID, newer page access log records will have a site accessLogID to 
						 tie them to a single logged in session. Older page access records will have a NULL siteAccessLog_ID 
						 and will have to use the session id and a date to find the page access records. This is because the 
						 same session id can get reused for a user/browser even if the user logs out and/or the session expires.
--->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<!--- <cfinclude template="cfudfs.cfm"> ---> 
<!--- <cfinclude template="_header.cfm"> --->
<cfinclude template="_checkLogin.cfm">
<link rel="stylesheet" href="2col_leftNav.css" type="text/css" />
<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Session Pages Accessed </H1>	<!--- <br> <h2>yyyyyy </h2> --->

<cfif isDefined("URL.SID")>
	<cfset sessionID = URL.SID>
<cfelse>
	<cfset sessionID = "">
</cfif>
<cfif isDefined("URL.dt")>
	<cfset date = dateFormat(URL.dt,"mm/dd/yyyy")>
<cfelse>
	<cfset date = "">
</cfif>

<cfif isDefined("URL.lid") and isNumeric(URL.lid)>
	<cfset accessLogID = URL.lid>
<cfelse>
	<cfset accessLogID = 0>
</cfif>

<cfset errMsg = "">

<cfif len(trim(sessionID)) and isDate(date)>
	
	<cfquery name="qPagesAccessed" datasource="#SESSION.DSN#">
		Select p.dt_access_date, p.user_id, p.session_id, p.ip_address, p.url, c.username, p.siteAccessLog_ID
		  FROM cpc_pageAccessLog p INNER JOIN tbl_Contact c ON c.contact_id = p.user_id
		 WHERE p.siteAccessLog_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.accessLogID#">
		 ORDER BY p.dt_access_date, dbo.formatDateTime(p.dt_access_date,'HH:MM 24') 
	</cfquery>

	<cfif qPagesAccessed.recordCount EQ 0>
		<!--- there may not be any page accessed OR they are loder log files where site access log id is null, so use
			the session id and date to find them --->
		<cfquery name="qPagesAccessed" datasource="#SESSION.DSN#">
			Select p.dt_access_date, p.user_id, p.session_id, p.ip_address, p.url, c.username, p.siteAccessLog_ID
			  FROM cpc_pageAccessLog p INNER JOIN tbl_Contact c ON c.contact_id = p.user_id
			 WHERE p.SESSION_ID = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.sessionID#">
			   AND p.dt_access_date >= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.date#">
			 ORDER BY p.dt_access_date, dbo.formatDateTime(p.dt_access_date,'HH:MM 24') 
		</cfquery>
	</cfif>

</cfif>

<cfset ctLoop	= 0>
<CFIF IsDefined("qPagesAccessed")>
	<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
		<tr class="tblHeading">
			<TD width="15%">Access Date</TD>
			<TD width="20%">Session id </TD>
			<TD width="15%">User id </TD>
			<td width="10%">IP address</td>
			<td width="30%">URL</td>
			<td width="10%">Site access log id</td>
		</TR>
	<!--- </table>	
	<div class="overflowbox" style="height:500px;">
	<table cellspacing="0" cellpadding="2" align="left" border="0" width="100%"  > --->
	<cfloop query="qPagesAccessed">
		<cfset ctLoop = ctLoop + 1>
		<cfset classValue = "class='tdUnderLine'">
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctLoop)#">
			<TD width="15%" #classValue# valign="top" > #dateFormat(dt_access_date,"mm/dd/yy")#  #timeFormat(dt_access_date,"hh:mm tt")#	</TD>
			<TD width="20%" #classValue# valign="top" > #session_id#	</TD>
			<TD width="15%" #classValue# valign="top" > #user_id# - #username#		</TD>
			<TD width="10%" #classValue# valign="top" > #ip_address#	</TD>
			<TD width="30%" #classValue# valign="top" > #URL#	</TD>
			<TD width="10%" #classValue# valign="top" > <cfif siteAccessLog_ID GT 0> #siteAccessLog_ID# <cfelse> &nbsp; </cfif> </TD>
		</TR>
	</cfloop>
	</table>
	</DIV>
</CFIF>

</cfoutput>
</div>






