<cfsetting enablecfoutputonly="Yes" showdebugoutput="NO">
<!----------------------------------------->
<!---  Capturepoint.com          		--->
<!---  CP_FORMS Application Layer   	--->
<!----------------------------------------->
<!---  Procedure: ?? UpdateChoice		--->
<!---  File: UpdateChoice.cfm	 		--->
<!---  Created:  07.19.2002 by			--->
<!---	         James Aldorisio		--->
<!---  Last Modified: 11.15.2002 PW		--->
<!----------------------------------------->

<cfif not isdefined("application.dsn")>
	<cfinclude template="application.cfm">
</cfif>
<cflock scope="application" type="readonly" timeout="10">
	<cfset dsn = application.dsn>
</cflock>

<!--------------------------->
<!--- required parameters --->
<!--------------------------->
<cfif isdefined("form.message_id")>
	<cfset message_id = form.message_id>
<cfelseif isdefined("url.message_id")>
	<cfset message_id = url.message_id>	
<cfelse>
	<cfoutput>ERROR,74522</cfoutput><cfabort>	
</cfif>
<cfif isdefined("form.scheduled_date")>
	<cfset scheduled_date = form.scheduled_date>
<cfelseif isdefined("url.scheduled_date")>
	<cfset scheduled_date = url.scheduled_date>	
<cfelse>
	<cfoutput>ERROR,74523</cfoutput><cfabort>	
</cfif>


<cftry>
	<CFSTOREDPROC datasource="#dsn#" procedure="p_update_message_scheduled_date" returncode="YES">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#message_id#" DBVARNAME="@choice_id">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_TIMESTAMP" VALUE="#scheduled_date#" DBVARNAME="@scheduled_date">
	</CFSTOREDPROC>
	
	<cfcatch type="database">		
		<cfoutput>ERROR, #cfcatch.nativeErrorCode#,#cfcatch.detail#,#cfcatch.message#</cfoutput>
		<cfabort>
	</cfcatch>
	<cfcatch type="any">
		<cfoutput>ERROR, 74524</cfoutput>
		<cfabort>
	</cfcatch>
</cftry>

<cfoutput>SUCCESS,0</cfoutput>

