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

<cfif isdefined("form.signup_thank_you_image")>
	<cfset signup_thank_you_image  = form.signup_thank_you_image>
<cfelseif isdefined("url.signup_thank_you_image")>
	<cfset signup_thank_you_image = url.signup_thank_you_image>	
<cfelse>
	<cfset signup_thank_you_image = "">	
</cfif>

<cfif isdefined("form.signup_thank_you_copy")>
	<cfset signup_thank_you_copy  = form.signup_thank_you_copy>
<cfelseif isdefined("url.signup_thank_you_copy")>
	<cfset signup_thank_you_copy = url.signup_thank_you_copy>	
<cfelse>
	<cfset signup_thank_you_copy = "">	
</cfif>

<cfif isdefined("form.signup_redirect_url")>
	<cfset signup_redirect_url  = form.signup_redirect_url>
<cfelseif isdefined("url.signup_redirect_url")>
	<cfset signup_redirect_url = url.signup_redirect_url>	
<cfelse>
	<cfset signup_redirect_url = "">	
</cfif>

<cfif isdefined("form.signup_thank_you_image_remove")>
	<cfset signup_thank_you_image_remove  = form.signup_thank_you_image_remove>
<cfelseif isdefined("url.signup_thank_you_image_remove")>
	<cfset signup_thank_you_image_remove = url.signup_thank_you_image_remove>	
<cfelse>
	<cfset signup_thank_you_image_remove = "">	
</cfif>

<!------------------->
<!--- Validations --->
<!------------------->
<cfif signup_redirect_url NEQ "" AND lcase(left(signup_redirect_url,4)) NEQ "http">
	<cf_error error="Thank you URL must start with 'http://' or 'https://'">
</cfif>

<!-------------------->
<!--- Upload image --->
<!-------------------->
<cfif signup_thank_you_image NEQ "">
	<cftry>
		<cffile ACTION="Upload"
		        FILEFIELD="signup_thank_you_image" 
		        DESTINATION="#application.temp_file_path#"
		        NAMECONFLICT="MakeUnique">
	
		<cfset signup_thank_you_image = File.ServerFile>
		
		<!--- move file to asset table --->
		<cfinvoke
			component="#application.crs_cfc_path#.asset"
			method="addAsset"
			asset_name="nltr_#signup_thank_you_image#"
			file_path="#application.temp_file_path##file.serverfile#"
			file_name="#file.serverfile#"
			extension="#file.serverfileext#"
			returnvariable="signup_thank_you_asset_id">
	
		<cfcatch type="ANY">
			<cf_error session_id="#session_id#" error="#cfcatch.message#<br>#cfcatch.detail#">
		</cfcatch>
	</cftry>
<cfelse>
	<cfset signup_thank_you_asset_id="">
</cfif>

<!-------------->
<!--- Action --->
<!-------------->
<cftry>
	<CFHTTP METHOD="POST" URL="#CRS_API_Path#/SetNewsletterCtlThankyou.cfm" redirect="NO" throwonerror="Yes">
		<CFHTTPPARAM NAME="organization_id" TYPE="FormField" VALUE="#organization_id#">
		<CFHTTPPARAM NAME="signup_thank_you_asset_id" TYPE="FormField" VALUE="#signup_thank_you_asset_id#">
		<CFHTTPPARAM NAME="signup_thank_you_copy" TYPE="FormField" VALUE="#signup_thank_you_copy#">
		<CFHTTPPARAM NAME="signup_redirect_url" TYPE="FormField" VALUE="#signup_redirect_url#">
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

<!--- REMOVE CURRENT IMAGE IF SPECIFIED --->
<CFIF signup_thank_you_image_remove EQ 1>
<cftry>

	<CFQUERY NAME="remove" DATASOURCE="#application.dsn#">
	EXECUTE p_set_organization_attrib #organization_id#,20,NULL
	</CFQUERY>

	<cfif cfhttp.filecontent CONTAINS "HTTP/1.0 404 Object Not Found">
		<cfthrow message="Error page not found">
	</cfif>

	<cfcatch>
		<cfinclude template="cfcatch.cfm">
	</cfcatch>
</cftry>
</CFIF>


<!---------------->
<!--- Redirect --->
<!---------------->
<cfset msg = "Changes applied successfully">
<cflocation url="#assigned_server#reg_adm/nltr_admin.cfm?s=#securestring#&msg=#msg#">
