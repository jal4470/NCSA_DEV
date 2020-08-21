<!------------------------------------->
<!---  Capturepoint.com          	--->
<!---  CRS UI Page		   			--->
<!------------------------------------->
<!---  Created:  10.12.2007 by		--->
<!---	         Pat Waters			--->
<!---  Last Modified: 				--->
<!------------------------------------->

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

<!----------------------->
<!--- Local variables --->
<!----------------------->

<cfif isdefined("form.email")>
	<cfset email  = form.email>
<cfelseif isdefined("url.email")>
	<cfset email = url.email>	
<cfelse>
	<cfset email = "">	
</cfif>

<!------------------->
<!--- Validations --->
<!------------------->

<cfif email EQ "">
	<cf_error error="Please enter an email address.">
</cfif>

<!--- Miscellaneous errors --->
<cfinclude template="../UDF_IsValidEmail.cfm">

<cfif IsValidEmail(email) EQ 0>
	<cf_error error="'#email#' is not a valid email address.">
</cfif>

<!-------------->
<!--- Action --->
<!-------------->
<cftry>
	<CFHTTP METHOD="POST" URL="#CRS_API_Path#/CreateUnsubscribe.cfm" redirect="NO" throwonerror="Yes">
		<CFHTTPPARAM NAME="organization_id" TYPE="FormField" VALUE="#organization_id#">
		<CFHTTPPARAM NAME="email" TYPE="FormField" VALUE="#email#">
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
	<cfset error = trim(getToken(cfhttp.filecontent, 2, ","))>
	<cf_error error="#error#" UI_page="news_unsubscribe_action.cfm">
</cfif>

<!---------------->
<!--- Redirect --->
<!---------------->
<cflocation url="nltr_subscribers_suppression.cfm?s=#securestring#"addtoken="No">
