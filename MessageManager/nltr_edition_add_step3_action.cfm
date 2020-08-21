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

<!------------------->
<!--- Validations --->
<!------------------->
<cfif message_id EQ "">
	<cf_error error="System error: cannot determine message.">
</cfif>

<!-------------->
<!-------------->
<!--- Action --->
<!-------------->
<!-------------->
<cftry>
	<CFHTTP METHOD="POST" URL="#CRS_API_Path#/SendMessage.cfm" redirect="NO" throwonerror="Yes">
		<CFHTTPPARAM NAME="organization_id" TYPE="FormField" VALUE="#organization_id#">
		<CFHTTPPARAM NAME="message_id" TYPE="FormField" VALUE="#message_id#">
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
	<cf_error session_id="#session_id#" error="An error was returned trying to send message." UI_page="nltr_edition_add_step3_action.cfm">
</cfif>

<!---------------->
<!--- Redirect --->
<!---------------->
<cflocation url="nltr_edition_add_complete.cfm?s=#securestring#&message_id=#message_id#" addtoken="no">
