<cfsetting enablecfoutputonly="Yes" showdebugoutput="NO">
<!------------------------------------->
<!---  Capturepoint.com          	--->
<!---  CRS Application Layer   		--->
<!------------------------------------->
<!---  Created:  10.10.2007 by		--->
<!---	         Pat Waters			--->
<!---  Last Modified: 				--->
<!------------------------------------->

<!--- Set DSN --->
<cfif not isdefined("application.dsn")>
	<cfinclude template="application.cfm">
</cfif>
<cflock scope="application" type="readonly" timeout="10">
	<cfset dsn = application.dsn>
</cflock>

<!----------------------->
<!--- Local variables --->
<!----------------------->
<cfif isdefined("form.message_id")>
	<cfset message_id = form.message_id>
<cfelseif isdefined("url.message_id")>
	<cfset message_id = url.message_id>	
<cfelse>
	<cfset message_id = "">	
</cfif>

<!------------------->
<!--- Validations --->
<!------------------->
<cfif message_id EQ "">
	<cfoutput>ERROR,Required parameter message_id not supplied.</cfoutput><cfabort>	
</cfif>

<!-------------->
<!--- Action --->
<!-------------->
<cftry>
	<CFSTOREDPROC datasource="#dsn#" procedure="p_remove_message" returncode="YES" >
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#message_id#" DBVARNAME="@message_id">
	</CFSTOREDPROC>

	<cfcatch type="database">
		<cfoutput>ERROR,#cfcatch.message#: #cfcatch.detail#</cfoutput>
		<cfabort>
	</cfcatch>
	<cfcatch type="any">
		<cfoutput>ERROR,Non database error</cfoutput>
		<cfabort>
	</cfcatch>
</cftry>

<!--- Success output --->
<cfoutput>SUCCESS,1</cfoutput>
