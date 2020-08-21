<!---
MODIFICATIONS
								--->
<!--------------------------------->

<!----------------------->
<!--- Local variables --->
<!----------------------->

<!--- URL --->
<cfif isDefined("cgi.http_host") AND len(trim(cgi.http_host)) AND isDefined("cgi.http_url") AND len(trim(cgi.http_url))>
	<cfset fullUrl = cgi.http_host & cgi.http_url>
<cfelse>
	<cfset fullUrl = "">
</cfif>

<!--- FILE NAME --->
<cfset file_name = Exception.cause.tagcontext[1].template>
<cfif NOT len(trim(file_name))>
	<cfset file_name = "">
</cfif>

<!--- ERROR MSG --->
<cfif isDefined("Exception.cause.message") AND len(trim(Exception.cause.message))>
	<cfset error_msg = Exception.cause.message>
<cfelse>
	<cfset error_msg = "">
</cfif>

<!--- ERROR DETAIL --->
<cfif isDefined("Exception.cause.detail") AND len(trim(Exception.cause.detail))>
	<cfset error_detail = Exception.cause.detail>
<cfelse>
	<cfset error_detail = "">
</cfif>

<!--- LINE NUMBER --->
<cfset line_number = Exception.cause.tagcontext[1].line>
<cfif NOT len(trim(line_number))>
	<cfset line_number = "">
</cfif>

<!--- SESSION ID --->
<cfif isDefined("SESSION.SESSIONID") AND len(trim(SESSION.SESSIONID))>
	<cfset session_id = SESSION.SESSIONID>
<cfelse>
	<cfset session_id = "">
</cfif>

<!--- USERNAME --->
<cfif isDefined("SESSION.USER.UNAME") AND len(trim(SESSION.USER.UNAME))>
	<cfset username = SESSION.USER.UNAME>
<cfelse>
	<cfset username = "">
</cfif>

<!--- CONTACT ID --->
<cfif isDefined("SESSION.USER.CONTACTID") AND len(trim(SESSION.USER.CONTACTID))>
	<cfset contact_id = SESSION.USER.CONTACTID>
<cfelse>
	<cfset contact_id = "">
</cfif>

<!--- BROWSER --->
<cfif isDefined("cgi.http_user_agent") AND len(trim(cgi.http_user_agent))>
	<cfset browser = cgi.http_user_agent>
<cfelse>
	<cfset browser = "">
</cfif>

<!------------------->
<!--- Write error --->
<!------------------->
<CFSTOREDPROC datasource="#SESSION.DSN#" procedure="p_create_app_error_log" returncode="YES">
	<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#fullUrl#" DBVARNAME="@url" NULL="#YesNoFormat(fullUrl EQ "")#">
	<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#file_name#" DBVARNAME="@file_name" NULL="#YesNoFormat(file_name EQ "")#">
	<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#error_msg#" DBVARNAME="@error_msg" NULL="#YesNoFormat(error_msg EQ "")#">
	<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#error_detail#" DBVARNAME="@error_detail" NULL="#YesNoFormat(error_detail EQ "")#">
	<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#line_number#" DBVARNAME="@line_number" NULL="#YesNoFormat(line_number EQ "")#">
	<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#session_id#" DBVARNAME="@session_id" NULL="#YesNoFormat(session_id EQ "")#">
	<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#username#" DBVARNAME="@username" NULL="#YesNoFormat(username EQ "")#">
	<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#contact_id#" DBVARNAME="@contact_id" NULL="#YesNoFormat(contact_id EQ "")#">
	<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#browser#" DBVARNAME="@browser" NULL="#YesNoFormat(browser EQ "")#">
	<CFPROCPARAM TYPE="OUT" CFSQLTYPE="CF_SQL_INTEGER" VARIABLE="error_log_id" DBVARNAME="@error_log_id">
</CFSTOREDPROC>

