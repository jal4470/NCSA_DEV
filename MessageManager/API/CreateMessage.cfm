<cfsetting enablecfoutputonly="Yes" showdebugoutput="NO">
<!------------------------------------->
<!---  Capturepoint.com          	--->
<!---  CRS UI Page		   			--->
<!------------------------------------->
<!---  Created:  10.10.2007 by		--->
<!---	         Pat Waters			--->
<!---  Last Modified: 				--->
<!---
MODIFICATIONS
2009-02-19, J. Oriente
- added "topic_choice_id_str" and "program_id_str" to p_create_message call.
12/10/2009 P Waters
- added processing of "Grades" and "Exclude Waitlisted Registrants" checkboxes
									--->
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
<cfif isdefined("form.organization_id")>
	<cfset organization_id = form.organization_id>
<cfelseif isdefined("url.organization_id")>
	<cfset organization_id = url.organization_id>
<cfelse>
	<cfset organization_id = "">
</cfif>

<cfif isdefined("form.message_desc")>
	<cfset message_desc = form.message_desc>
<cfelseif isdefined("url.message_desc")>
	<cfset message_desc = url.message_desc>
<cfelse>
	<cfset message_desc = "">
</cfif>

<cfif isdefined("form.from_email_address")>
	<cfset from_email_address = form.from_email_address>
<cfelseif isdefined("url.from_email_address")>
	<cfset from_email_address = url.from_email_address>
<cfelse>
	<cfset from_email_address = "">
</cfif>

<cfif isdefined("form.from_email_alias")>
	<cfset from_email_alias = form.from_email_alias>
<cfelseif isdefined("url.from_email_alias")>
	<cfset from_email_alias = url.from_email_alias>
<cfelse>
	<cfset from_email_alias = "">
</cfif>

<cfif isdefined("form.replyto_email_address")>
	<cfset replyto_email_address = form.replyto_email_address>
<cfelseif isdefined("url.replyto_email_address")>
	<cfset replyto_email_address = url.replyto_email_address>
<cfelse>
	<cfset replyto_email_address = "">
</cfif>

<cfif isdefined("form.replyto_email_alias")>
	<cfset replyto_email_alias = form.replyto_email_alias>
<cfelseif isdefined("url.replyto_email_alias")>
	<cfset replyto_email_alias = url.replyto_email_alias>
<cfelse>
	<cfset replyto_email_alias = "">
</cfif>

<cfif isdefined("form.subject")>
	<cfset subject = form.subject>
<cfelseif isdefined("url.subject")>
	<cfset subject = url.subject>
<cfelse>
	<cfset subject = "">
</cfif>

<cfif isdefined("form.cc_emails")>
	<cfset cc_emails = form.cc_emails>
<cfelseif isdefined("url.cc_emails")>
	<cfset cc_emails = url.cc_emails>
<cfelse>
	<cfset cc_emails = "">
</cfif>

<cfif isdefined("form.bcc_emails")>
	<cfset bcc_emails = form.bcc_emails>
<cfelseif isdefined("url.bcc_emails")>
	<cfset bcc_emails = url.bcc_emails>
<cfelse>
	<cfset bcc_emails = "">
</cfif>

<cfif isdefined("form.html_copy")>
	<cfset html_copy = form.html_copy>
<cfelseif isdefined("url.html_copy")>
	<cfset html_copy = url.html_copy>
<cfelse>
	<cfset html_copy = "">
</cfif>

<cfif isdefined("form.text_copy")>
	<cfset text_copy = form.text_copy>
<cfelseif isdefined("url.text_copy")>
	<cfset text_copy = url.text_copy>
<cfelse>
	<cfset text_copy = "">
</cfif>

<cfif isdefined("form.track_opens_flag")>
	<cfset track_opens_flag = form.track_opens_flag>
<cfelseif isdefined("url.track_opens_flag")>
	<cfset track_opens_flag = url.track_opens_flag>
<cfelse>
	<cfset track_opens_flag = 0>
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

<cfif isdefined("form.grade_id_str")>
	<cfset grade_id_str = form.grade_id_str>
<cfelseif isdefined("url.grade_id_str")>
	<cfset grade_id_str = url.grade_id_str>
<cfelse>
	<cfset grade_id_str = "">
</cfif>

<cfif isdefined("form.created_via_message_manager_flag")>
	<cfset created_via_message_manager_flag = form.created_via_message_manager_flag>
<cfelseif isdefined("url.created_via_message_manager_flag")>
	<cfset created_via_message_manager_flag = url.created_via_message_manager_flag>
<cfelse>
	<cfset created_via_message_manager_flag = "0">
</cfif>

<cfif isdefined("form.exclude_waitlisted_flag")>
	<cfset exclude_waitlisted_flag = form.exclude_waitlisted_flag>
<cfelseif isdefined("url.exclude_waitlisted_flag")>
	<cfset exclude_waitlisted_flag = url.exclude_waitlisted_flag>
<cfelse>
	<cfset exclude_waitlisted_flag = "0">
</cfif>

<!------------------->
<!--- Validations --->
<!------------------->
<cfif organization_id EQ "">
	<cfoutput>ERROR,Required parameter organization_id not supplied.</cfoutput><cfabort>	
</cfif>

<cfif from_email_address EQ "">
	<cfoutput>ERROR,Required parameter from_email_address not supplied.</cfoutput><cfabort>	
</cfif>

<cfif from_email_alias EQ "">
	<cfoutput>ERROR,Required parameter from_email_alias not supplied.</cfoutput><cfabort>	
</cfif>

<cfif subject EQ "">
	<cfoutput>ERROR,Required parameter subject not supplied.</cfoutput><cfabort>	
</cfif>

<cfif html_copy EQ "" AND text_copy EQ "">
	<cfoutput>ERROR,Required parameter html_copy or text-copy not supplied.</cfoutput><cfabort>	
</cfif>

<!-------------------------------->
<!--- Execute stored procedure --->
<!-------------------------------->
<cftry>
	<CFSTOREDPROC datasource="#dsn#" procedure="p_create_message" returncode="YES" >
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#organization_id#" DBVARNAME="@organization_id">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#message_desc#" DBVARNAME="@message_desc">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#from_email_address#" DBVARNAME="@from_email_address">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#from_email_alias#" DBVARNAME="@from_email_alias">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#replyto_email_address#" DBVARNAME="@replyto_email_address" NULL="#YesNoFormat(replyto_email_address EQ "")#">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#replyto_email_alias#" DBVARNAME="@replyto_email_alias" NULL="#YesNoFormat(replyto_email_alias EQ "")#">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#subject#" DBVARNAME="@subject">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#cc_emails#" DBVARNAME="@cc_emails" NULL="#YesNoFormat(cc_emails EQ "")#">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#bcc_emails#" DBVARNAME="@bcc_emails" NULL="#YesNoFormat(bcc_emails EQ "")#">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#html_copy#" DBVARNAME="@html_copy" NULL="#YesNoFormat(html_copy EQ "")#">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#text_copy#" DBVARNAME="@text_copy" NULL="#YesNoFormat(text_copy EQ "")#">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_BIT" VALUE="#track_opens_flag#" DBVARNAME="@track_opens_flag">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#topic_choice_id_str#" DBVARNAME="@topic_choice_id_str" NULL="#YesNoFormat(topic_choice_id_str EQ "")#">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#program_id_str#" DBVARNAME="@program_id_str" NULL="#YesNoFormat(program_id_str EQ "")#">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#grade_id_str#" DBVARNAME="@grade_id_str" NULL="#YesNoFormat(grade_id_str EQ "")#">
		<cfprocparam type="IN" cfsqltype="CF_SQL_BIT" VALUE="#created_via_message_manager_flag#" DBVARNAME="@created_via_message_manager_flag">
		<cfprocparam type="IN" cfsqltype="CF_SQL_BIT" VALUE="#exclude_waitlisted_flag#" DBVARNAME="@exclude_waitlisted_flag">
		<CFPROCPARAM TYPE="OUT" CFSQLTYPE="CF_SQL_INTEGER" VARIABLE="message_id" DBVARNAME="@message_id">
	</CFSTOREDPROC>

	<cfcatch>
		<cfoutput>ERROR,#cfcatch.message#: #cfcatch.detail#</cfoutput><cfabort>
	</cfcatch>
</cftry>

<!---------------------->
<!--- Success output --->
<!---------------------->
<cfoutput>SUCCESS,#message_id#</cfoutput>
