<cfsetting enablecfoutputonly="Yes" showdebugoutput="NO">
<!----------------------------------------->
<!---  Capturepoint.com         		--->
<!---  CRS Application Layer   			--->
<!----------------------------------------->
<!---  Created:  11.12.2007 by			--->
<!---	         Pat Waters				--->
<!---  Last Modified: 					--->
<!----------------------------------------->

<!--- Set DSN --->
<cfif not isdefined("application.dsn")>
	<cfinclude template="application.cfm">
</cfif>
<cflock scope="application" type="readonly" timeout="10">
	<cfset dsn = application.dsn>
</cflock>

<!--- Required parameters --->
<cfif isdefined("form.organization_id")>
	<cfset organization_id = form.organization_id>
<cfelseif isdefined("url.organization_id")>
	<cfset organization_id = url.organization_id>	
<cfelse>
	<cfoutput>ERROR,76009,'Required parameter organization_id not supplied.'</cfoutput><cfabort>	
</cfif>

<cfif isdefined("form.topic_short_desc")>
	<cfset topic_short_desc = form.topic_short_desc>
<cfelseif isdefined("url.topic_short_desc")>
	<cfset topic_short_desc = url.topic_short_desc>	
<cfelse>
	<cfoutput>ERROR,76009,'Required parameter topic_short_desc not supplied.'</cfoutput><cfabort>	
</cfif>

<cfif isdefined("form.topic_description")>
	<cfset topic_description = form.topic_description>
<cfelseif isdefined("url.topic_description")>
	<cfset topic_description = url.topic_description>	
<cfelse>
	<cfset topic_description = "">
</cfif>

<cfif isdefined("form.topic_status_id")>
	<cfset topic_status_id = form.topic_status_id>
<cfelseif isdefined("url.topic_status_id")>
	<cfset topic_status_id = url.topic_status_id>	
<cfelse>
	<cfoutput>ERROR,76009,'Required parameter topic_status_id not supplied.'</cfoutput><cfabort>	
</cfif>

<cfif isdefined("form.user_id")>
	<cfset user_id = form.user_id>
<cfelseif isdefined("url.user_id")>
	<cfset user_id = url.user_id>	
<cfelse>
	<cfoutput>ERROR,76009,'Required parameter user_id not supplied.'</cfoutput><cfabort>	
</cfif>

<!--- Execute stored procedure --->
<cftry>
	<CFSTOREDPROC datasource="#dsn#" procedure="p_create_newsletter_topic" returncode="YES" >
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#organization_id#" DBVARNAME="@organization_id">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#topic_short_desc#" DBVARNAME="@topic_short_desc">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#topic_description#" DBVARNAME="@topic_description" NULL="#YesNoFormat(topic_description is "")#">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_BIT" VALUE="#topic_status_id#" DBVARNAME="@topic_status_id">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#user_id#" DBVARNAME="@user_id">
		<CFPROCPARAM TYPE="OUT" CFSQLTYPE="CF_SQL_INTEGER" VARIABLE="topic_id" DBVARNAME="@topic_id">
	</CFSTOREDPROC>

	<cfcatch type="database">
		<cfoutput>ERROR,#cfcatch.nativeErrorCode#,#cfcatch.message#: #cfcatch.detail#</cfoutput>
		<cfabort>
	</cfcatch>

	<cfcatch type="any">
		<cfoutput>ERROR, 76010,'Non database error'</cfoutput>
		<cfabort>
	</cfcatch>
</cftry>

<!--- Success output --->
<cfoutput>SUCCESS,#topic_id#</cfoutput>
