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

<cfif isdefined("form.newsletter_status_id")>
	<cfset newsletter_status_id  = form.newsletter_status_id>
<cfelseif isdefined("url.newsletter_status_id")>
	<cfset newsletter_status_id = url.newsletter_status_id>	
<cfelse>
	<cfset newsletter_status_id = "">	
</cfif>

<cfif isdefined("form.signup_header_image")>
	<cfset signup_header_image  = form.signup_header_image>
<cfelseif isdefined("url.signup_header_image")>
	<cfset signup_header_image = url.signup_header_image>	
<cfelse>
	<cfset signup_header_image = "">	
</cfif>

<cfif isdefined("form.signup_footer_copy")>
	<cfset signup_footer_copy  = form.signup_footer_copy>
<cfelseif isdefined("url.signup_footer_copy")>
	<cfset signup_footer_copy = url.signup_footer_copy>	
<cfelse>
	<cfset signup_footer_copy = "">	
</cfif>

<!------------------->
<!--- Validations --->
<!------------------->

<!-------------------->
<!--- Upload image --->
<!-------------------->
<cfif signup_header_image NEQ "">
	<cftry>
		<cffile ACTION="Upload"
		        FILEFIELD="signup_header_image" 
		        DESTINATION="#application.temp_file_path#"
		        NAMECONFLICT="MakeUnique">

		<cfset signup_header_image = File.ServerFile>
		
		
		<!--- move file to asset table --->
		<cfinvoke
			component="#application.crs_cfc_path#.asset"
			method="addAsset"
			asset_name="nltr_#signup_header_image#"
			file_path="#application.temp_file_path##file.serverfile#"
			file_name="#file.serverfile#"
			extension="#file.serverfileext#"
			returnvariable="signup_header_asset_id">
	
		<cfcatch type="ANY">
			<cf_error session_id="#session_id#" error="#cfcatch.message#<br>#cfcatch.detail#">
		</cfcatch>
	</cftry>
<cfelse>
	<cfset signup_header_asset_id="">
</cfif>

<!-------------->
<!--- Action --->
<!-------------->
<cftry>
	<CFHTTP METHOD="POST" URL="#CRS_API_Path#/SetNewsletterCtlGen.cfm" redirect="NO" throwonerror="Yes">
		<CFHTTPPARAM NAME="organization_id" TYPE="FormField" VALUE="#organization_id#">
		<CFHTTPPARAM NAME="newsletter_status_id" TYPE="FormField" VALUE="#newsletter_status_id#">
		<CFHTTPPARAM NAME="signup_header_asset_id" TYPE="FormField" VALUE="#signup_header_asset_id#">
		<CFHTTPPARAM NAME="signup_footer_copy" TYPE="FormField" VALUE="#signup_footer_copy#">
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
<cflocation url="#assigned_server#reg_adm/nltr_admin.cfm?s=#securestring#&msg=#msg#">
