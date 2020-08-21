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

<cfif isdefined("form.new_sub_account_add_instructions")>
	<cfset new_sub_account_add_instructions  = form.new_sub_account_add_instructions>
<cfelseif isdefined("url.new_sub_account_add_instructions")>
	<cfset new_sub_account_add_instructions = url.new_sub_account_add_instructions>	
<cfelse>
	<cfset new_sub_account_add_instructions = "">	
</cfif>

<cfif isdefined("form.new_sub_message")>
	<cfset new_sub_message  = form.new_sub_message>
<cfelseif isdefined("url.new_sub_message")>
	<cfset new_sub_message = url.new_sub_message>	
<cfelse>
	<cfset new_sub_message = "">	
</cfif>

<cfif isdefined("form.new_sub_image")>
	<cfset new_sub_image  = form.new_sub_image>
<cfelseif isdefined("url.new_sub_image")>
	<cfset new_sub_image = url.new_sub_image>	
<cfelse>
	<cfset new_sub_image = "">	
</cfif>

<cfif isdefined("form.new_sub_image_remove")>
	<cfset new_sub_image_remove  = form.new_sub_image_remove>
<cfelseif isdefined("url.new_sub_image_remove")>
	<cfset new_sub_image_remove = url.new_sub_image_remove>	
<cfelse>
	<cfset new_sub_image_remove = "">	
</cfif>

<!------------------->
<!--- Validations --->
<!------------------->

<!-------------------->
<!--- Upload image --->
<!-------------------->
<cfif new_sub_image NEQ "">
	<cftry>
		<cffile ACTION="Upload"
		        FILEFIELD="new_sub_image" 
		        DESTINATION="#application.temp_file_path#"
		        NAMECONFLICT="MakeUnique">
	
		<cfset new_sub_image = File.ServerFile>
			
		<!--- move file to asset table --->
		<cfinvoke
			component="#application.crs_cfc_path#.asset"
			method="addAsset"
			asset_name="nltr_#new_sub_image#"
			file_path="#application.temp_file_path##file.serverfile#"
			file_name="#file.serverfile#"
			extension="#file.serverfileext#"
			returnvariable="new_sub_asset_id">
	
		<cfcatch type="ANY">
			<cf_error session_id="#session_id#" error="#cfcatch.message#<br>#cfcatch.detail#">
		</cfcatch>
	</cftry>
<cfelse>
	<cfset new_sub_asset_id="">
</cfif>

<!-------------->
<!--- Action --->
<!-------------->
<cftry>
	<CFHTTP METHOD="POST" URL="#CRS_API_Path#/SetNewsletterCtlSignup.cfm" redirect="NO" throwonerror="Yes">
		<CFHTTPPARAM NAME="organization_id" TYPE="FormField" VALUE="#organization_id#">
		<CFHTTPPARAM NAME="new_sub_account_add_instructions" TYPE="FormField" VALUE="#new_sub_account_add_instructions#">
		<CFHTTPPARAM NAME="new_sub_message" TYPE="FormField" VALUE="#new_sub_message#">
		<CFHTTPPARAM NAME="new_sub_asset_id" TYPE="FormField" VALUE="#new_sub_asset_id#">
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
<CFIF new_sub_image_remove EQ 1>
<cftry>

	<CFQUERY NAME="remove" DATASOURCE="#application.dsn#">
	EXECUTE p_set_organization_attrib #organization_id#,15,NULL
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
