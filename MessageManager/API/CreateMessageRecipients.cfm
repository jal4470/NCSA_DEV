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

<cfif isdefined("form.topic_choice_id_str")>
	<cfset topic_choice_id_str = form.topic_choice_id_str>
<cfelseif isdefined("url.topic_choice_id_str")>
	<cfset topic_choice_id_str = url.topic_choice_id_str>	
<cfelse>
	<cfset topic_choice_id_str = "">	
</cfif>

<cfif isdefined("form.program_id_str")>
	<cfset program_id_str = form.program_id_str>
<cfelseif isdefined("url.program_id_str")>
	<cfset program_id_str = url.program_id_str>	
<cfelse>
	<cfset program_id_str = "">	
</cfif>

<!------------------->
<!--- Validations --->
<!------------------->
<cfif message_id EQ "">
	<cfoutput>ERROR,Required parameter message_id not supplied.</cfoutput><cfabort>	
</cfif>

<cfif topic_choice_id_str IS "" AND program_id_str IS "">
	<cfoutput>ERROR,Required parameter topic_choice_id_str or program_id_str not supplied.</cfoutput><cfabort>	
</cfif>

<!-------------->
<!--- Action --->
<!-------------->
<cftry>
	<CFSTOREDPROC datasource="#dsn#" procedure="p_create_message_recipients" returncode="YES" >
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#message_id#" DBVARNAME="@message_id">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#topic_choice_id_str#" DBVARNAME="@topic_choice_id_str" NULL="#YesNoFormat(topic_choice_id_str EQ "")#">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#program_id_str#" DBVARNAME="@program_id_str" NULL="#YesNoFormat(program_id_str EQ "")#">
	</CFSTOREDPROC>

	<cfcatch>
		<cfoutput>ERROR,#cfcatch.message#: #cfcatch.detail#</cfoutput><cfabort>
	</cfcatch>
</cftry>

<!--- Success output --->
<cfoutput>SUCCESS,1</cfoutput>
