<!------------------------------------->
<!---  Capturepoint.com          	--->
<!---  CRS UI Page		   			--->
<!------------------------------------->
<!---  Created:  10.10.2007 by		--->
<!---	         Pat Waters			--->
<!---  Last Modified: 				--->
<!------------------------------------->

 
 <!--- validate login --->
 <cfmodule template="../_checkLogin.cfm">
 
<!--- Set Application variables --->
<cfif not isdefined("application.dsn")>
	<cfinclude template="application.cfm">
</cfif>
<cflock scope="application" type="readonly" timeout="10">
	<cfset dsn = application.dsn>
	<cfset CRS_API_Path = application.CRS_API_Path>
</cflock>

<!--- Security --->
<cfinclude template="_secureme.cfm">

<!----------------------->
<!--- Local variables --->
<!----------------------->
<cfif isdefined("form.message_id")>
	<cfset message_id  = form.message_id>
<cfelseif isdefined("url.message_id")>
	<cfset message_id = url.message_id>
<cfelse>
	<cfset message_id = "">	
</cfif>

<cfif isdefined("form.topic_choice_id_str")>
	<cfset topic_choice_id_str  = form.topic_choice_id_str>
<cfelseif isdefined("url.topic_choice_id_str")>
	<cfset topic_choice_id_str = url.topic_choice_id_str>
<cfelse>
	<cfset topic_choice_id_str = "">	
</cfif>

<!------------------->
<!--- Validations --->
<!------------------->
<cfif message_id EQ "">
	<cf_error error="System error: cannot determine message.">
</cfif>

<cfif topic_choice_id_str EQ "">
	<cf_error error="Please select at least one topic.">
</cfif>

<!-------------->
<!-------------->
<!--- Action --->
<!-------------->
<!-------------->
<cftry>
	<CFHTTP METHOD="POST" URL="#CRS_API_Path#/CreateMessageRecipients.cfm" redirect="NO" throwonerror="Yes">
		<CFHTTPPARAM NAME="message_id" TYPE="FormField" VALUE="#message_id#">
		<CFHTTPPARAM NAME="topic_choice_id_str" TYPE="FormField" VALUE="#topic_choice_id_str#">
	</CFHTTP>
	
	<cfif cfhttp.filecontent CONTAINS "HTTP/1.0 404 Object Not Found">
		<cfthrow message="Error page not found">
	</cfif>

	<cfcatch>
		<cfinclude template="cfcatch.cfm">
	</cfcatch>
</cftry>
	
<cfset status = getToken(cfhttp.filecontent, 1, ",")>
<cfif trim(status) NEQ "SUCCESS">
	<cf_error session_id="#session_id#" error="An error was returned trying to create message recipients." UI_page="nltr_edition_add_step2_action.cfm">
</cfif>

<!---------------->
<!--- Redirect --->
<!---------------->
<cflocation url="nltr_edition_add_step3.cfm?s=#securestring#&message_id=#message_id#" addtoken="no">
