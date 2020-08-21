<!------------------------------------->
<!---  Capturepoint.com          	--->
<!---  CRS Action Page		   		--->
<!------------------------------------->
<!---  Created:  11.12.2007 by		--->
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
	<cfset signup_image_path = application.signup_image_path>
</cflock>

<!--- Security --->
<cfinclude template="_secureme.cfm">

<!--------------------------->
<!--- Set local variables --->
<!--------------------------->
<cfif isdefined("form.new_sub_login_instructions")>
	<cfset new_sub_login_instructions  = form.new_sub_login_instructions>
<cfelseif isdefined("url.new_sub_login_instructions")>
	<cfset new_sub_login_instructions = url.new_sub_login_instructions>	
<cfelse>
	<cfset new_sub_login_instructions = "">	
</cfif>

<cfif isdefined("form.ret_sub_login_instructions")>
	<cfset ret_sub_login_instructions  = form.ret_sub_login_instructions>
<cfelseif isdefined("url.ret_sub_login_instructions")>
	<cfset ret_sub_login_instructions = url.ret_sub_login_instructions>	
<cfelse>
	<cfset ret_sub_login_instructions = "">	
</cfif>

<!------------------->
<!--- Validations --->
<!------------------->

<!-------------->
<!--- Action --->
<!-------------->
<cftry>
	<CFHTTP METHOD="POST" URL="#CRS_API_Path#/SetNewsletterCtlLogin.cfm" redirect="NO" throwonerror="Yes">
		<CFHTTPPARAM NAME="organization_id" TYPE="FormField" VALUE="#organization_id#">
		<CFHTTPPARAM NAME="new_sub_login_instructions" TYPE="FormField" VALUE="#new_sub_login_instructions#">
		<CFHTTPPARAM NAME="ret_sub_login_instructions" TYPE="FormField" VALUE="#ret_sub_login_instructions#">
	</CFHTTP>
	
	<cfif cfhttp.filecontent CONTAINS "HTTP/1.0 404 Object Not Found">
		<cfthrow message="Error page not found">
	</cfif>

	<cfcatch>
		<cfinclude template="cfcatch.cfm">
	</cfcatch>
</cftry>

<!--- Set variables based on API output --->
<cfset status = getToken(cfhttp.filecontent, 1, ",")>

<cfif trim(status) NEQ "SUCCESS">
	<cf_error error="An error was returned trying to update settings.">
</cfif>

<!---------------->
<!--- Redirect --->
<!---------------->
<cfset msg = "Changes applied successfully">
<cflocation url="nltr_admin.cfm?s=#securestring#&msg=#msg#">
