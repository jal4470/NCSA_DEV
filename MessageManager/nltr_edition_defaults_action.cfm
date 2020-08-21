<!------------------------------------->
<!---  Capturepoint.com          	--->
<!---  CRS Action Page		   	--->
<!------------------------------------->
<!---  File: activity_add_action.cfm	--->
<!---  Created:  03.24.2003 by	--->
<!---	         Pat Waters		--->
<!---  Last Modified: 03.24.2003	--->
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
<cfif isdefined("form.from_email")>
	<cfset from_email  = form.from_email>
<cfelseif isdefined("url.from_email")>
	<cfset from_email = url.from_email>	
<cfelse>
	<cfset from_email = "">	
</cfif>

<cfif isdefined("form.from_alias")>
	<cfset from_alias  = form.from_alias>
<cfelseif isdefined("url.from_alias")>
	<cfset from_alias = url.from_alias>	
<cfelse>
	<cfset from_alias = "">	
</cfif>

<cfif isdefined("form.reply_to_email")>
	<cfset reply_to_email  = form.reply_to_email>
<cfelseif isdefined("url.reply_to_email")>
	<cfset reply_to_email = url.reply_to_email>	
<cfelse>
	<cfset reply_to_email = "">	
</cfif>

<cfif isdefined("form.reply_to_alias")>
	<cfset reply_to_alias  = form.reply_to_alias>
<cfelseif isdefined("url.reply_to_alias")>
	<cfset reply_to_alias = url.reply_to_alias>	
<cfelse>
	<cfset reply_to_alias = "">	
</cfif>

<cfif isdefined("form.track_opens")>
	<cfset track_opens  = form.track_opens>
<cfelseif isdefined("url.track_opens")>
	<cfset track_opens = url.track_opens>	
<cfelse>
	<cfset track_opens = "">	
</cfif>

<!------------------->
<!--- Validations --->
<!------------------->
<cfinclude template="../UDF_IsValidEmail.cfm">

<cfif from_email NEQ "" AND NOT IsValidEmail(from_email)>
	<cf_error error="'#from_email# is not a valid email format.">
</cfif>

<cfif reply_to_email NEQ "" AND NOT IsValidEmail(reply_to_email)>
	<cf_error error="'#reply_to_email# is not a valid email format.">
</cfif>

<!----------------------------------->
<!----------------------------------->
<!---     update Organization     --->
<!----------------------------------->
<!----------------------------------->
<cftry>
	<CFHTTP METHOD="POST" URL="#CRS_API_Path#/SetOrganizationNewsAttribs.cfm" redirect="NO" throwonerror="Yes">
		<CFHTTPPARAM NAME="organization_id" TYPE="FormField" VALUE="#organization_id#">
		<CFHTTPPARAM NAME="def_news_from_email" TYPE="FormField" VALUE="#from_email#">
		<CFHTTPPARAM NAME="def_news_from_alias" TYPE="FormField" VALUE="#from_alias#">
		<CFHTTPPARAM NAME="def_news_replyto_email" TYPE="FormField" VALUE="#reply_to_email#">
		<CFHTTPPARAM NAME="def_news_replyto_alias" TYPE="FormField" VALUE="#reply_to_alias#">
		<CFHTTPPARAM NAME="def_track_opens" TYPE="FormField" VALUE="#track_opens#">
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
