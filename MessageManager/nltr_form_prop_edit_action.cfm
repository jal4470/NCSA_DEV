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

<cfif isdefined("form.organization_id")>
	<cfset organization_id  = form.organization_id>
<cfelseif isdefined("url.organization_id")>
	<cfset organization_id = url.organization_id>	
<cfelse>
	<cf_error_nltr session_id="#session_id#" error="organization_id not found." UI_page="nltr_form_prop_edit_action.cfm">
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

<cfif isdefined("form.signup_privacy_policy_link")>
	<cfset signup_privacy_policy_link  = form.signup_privacy_policy_link>
<cfelseif isdefined("url.signup_privacy_policy_link")>
	<cfset signup_privacy_policy_link = url.signup_privacy_policy_link>	
<cfelse>
	<cfset signup_privacy_policy_link = "">	
</cfif>

<cfif isdefined("form.new_sub_login_instructions")>
	<cfset new_sub_login_instructions  = form.new_sub_login_instructions>
<cfelseif isdefined("url.new_sub_login_instructions")>
	<cfset new_sub_login_instructions = url.new_sub_login_instructions>	
<cfelse>
	<cfset new_sub_login_instructions = "">	
</cfif>

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

<cfif isdefined("form.ret_sub_login_instructions")>
	<cfset ret_sub_login_instructions  = form.ret_sub_login_instructions>
<cfelseif isdefined("url.ret_sub_login_instructions")>
	<cfset ret_sub_login_instructions = url.ret_sub_login_instructions>	
<cfelse>
	<cfset ret_sub_login_instructions = "">	
</cfif>

<cfif isdefined("form.ret_sub_account_add_instructions")>
	<cfset ret_sub_account_add_instructions  = form.ret_sub_account_add_instructions>
<cfelseif isdefined("url.ret_sub_account_add_instructions")>
	<cfset ret_sub_account_add_instructions = url.ret_sub_account_add_instructions>	
<cfelse>
	<cfset ret_sub_account_add_instructions = "">	
</cfif>

<cfif isdefined("form.ret_sub_message")>
	<cfset ret_sub_message  = form.ret_sub_message>
<cfelseif isdefined("url.ret_sub_message")>
	<cfset ret_sub_message = url.ret_sub_message>	
<cfelse>
	<cfset ret_sub_message = "">	
</cfif>

<cfif isdefined("form.ret_sub_image")>
	<cfset ret_sub_image  = form.ret_sub_image>
<cfelseif isdefined("url.ret_sub_image")>
	<cfset ret_sub_image = url.ret_sub_image>	
<cfelse>
	<cfset ret_sub_image = "">	
</cfif>

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

<cfif isdefined("form.newsletter_status_id")>
	<cfset newsletter_status_id  = form.newsletter_status_id>
<cfelseif isdefined("url.newsletter_status_id")>
	<cfset newsletter_status_id = url.newsletter_status_id>	
<cfelse>
	<cfset newsletter_status_id = 0>	
</cfif>


<!------------------->
<!--- Validations --->
<!------------------->


<!--- Required fields --->
<cfif organization_id EQ "">
	<cf_error session_id="#session_id#" error="organization_id cannot be blank." UI_page="nltr_form_prop_edit_action.cfm">
</cfif>

<cfif signup_privacy_policy_link IS NOT "" AND signup_privacy_policy_link DOES NOT CONTAIN "http">
	<cf_error session_id="#session_id#" error="Links Must start with Http." UI_page="organization_add_action.cfm">
</cfif>

<cfif signup_redirect_url IS NOT "" AND signup_redirect_url DOES NOT CONTAIN "http">
	<cf_error session_id="#session_id#" error="Links Must start with Http." UI_page="organization_add_action.cfm">
</cfif>

<!--------------------------->
<!---    Upload image     --->
<!--------------------------->
<cfif signup_header_image NEQ "">
<cftry>
	<cffile ACTION="Upload"
	        FILEFIELD="signup_header_image" 
	        DESTINATION="#signup_image_path#"
	        NAMECONFLICT="MakeUnique">

	<!--- If uploaded, update header_filename variable --->
	<cfif isdefined("File.ServerFile")>
		<cfset signup_header_image = File.ServerFile>
	<cfelse>
		<cfset signup_header_image = "">
	</cfif>

	<cfcatch type="ANY">
		<cf_error session_id="#session_id#" error="#cfcatch.message#<br>#cfcatch.detail#" UI_page="organization_add_action.cfm">
	</cfcatch>
</cftry>
</cfif>

<cfif new_sub_image NEQ "">
<cftry>
	<cffile ACTION="Upload"
	        FILEFIELD="new_sub_image" 
	        DESTINATION="#signup_image_path#"
	        NAMECONFLICT="MakeUnique">

	<!--- If uploaded, update header_filename variable --->
	<cfif isdefined("File.ServerFile")>
		<cfset new_sub_image = File.ServerFile>
	<cfelse>
		<cfset new_sub_image = "">
	</cfif>

	<cfcatch type="ANY">
		<cf_error session_id="#session_id#" error="#cfcatch.message#<br>#cfcatch.detail#" UI_page="organization_add_action.cfm">
	</cfcatch>
</cftry>
</cfif>

<cfif ret_sub_image NEQ "">
<cftry>
	<cffile ACTION="Upload"
	        FILEFIELD="ret_sub_image" 
	        DESTINATION="#signup_image_path#"
	        NAMECONFLICT="MakeUnique">

	<!--- If uploaded, update header_filename variable --->
	<cfif isdefined("File.ServerFile")>
		<cfset ret_sub_image = File.ServerFile>
	<cfelse>
		<cfset ret_sub_image = "">
	</cfif>

	<cfcatch type="ANY">
		<cf_error session_id="#session_id#" error="#cfcatch.message#<br>#cfcatch.detail#" UI_page="organization_add_action.cfm">
	</cfcatch>
</cftry>
</cfif>

<cfif signup_thank_you_image NEQ "">
<cftry>
	<cffile ACTION="Upload"
	        FILEFIELD="signup_thank_you_image" 
	        DESTINATION="#signup_image_path#"
	        NAMECONFLICT="MakeUnique">

	<!--- If uploaded, update header_filename variable --->
	<cfif isdefined("File.ServerFile")>
		<cfset signup_thank_you_image = File.ServerFile>
	<cfelse>
		<cfset signup_thank_you_image = "">
	</cfif>

	<cfcatch type="ANY">
		<cf_error session_id="#session_id#" error="#cfcatch.message#<br>#cfcatch.detail#" UI_page="organization_add_action.cfm">
	</cfcatch>
</cftry>
</cfif>



<!----------------------------------->
<!----------------------------------->
<!---     update Organization     --->
<!----------------------------------->
<!----------------------------------->
<cftry>
	<CFHTTP METHOD="POST" URL="#CRS_API_Path#/UpdateOrganizationSignup.cfm" redirect="NO" throwonerror="Yes">
		<CFHTTPPARAM NAME="organization_id" TYPE="FormField" VALUE="#organization_id#">
		<CFHTTPPARAM NAME="signup_header_image" TYPE="FormField" VALUE="#signup_header_image#">
		<CFHTTPPARAM NAME="signup_footer_copy" TYPE="FormField" VALUE="#signup_footer_copy#">
		<!--- <CFHTTPPARAM NAME="signup_privacy_policy_link" TYPE="FormField" VALUE="#signup_privacy_policy_link#"> --->
		<CFHTTPPARAM NAME="new_sub_login_instructions" TYPE="FormField" VALUE="#new_sub_login_instructions#">
		<CFHTTPPARAM NAME="new_sub_account_add_instructions" TYPE="FormField" VALUE="#new_sub_account_add_instructions#">
		<CFHTTPPARAM NAME="new_sub_message" TYPE="FormField" VALUE="#new_sub_message#">
		<CFHTTPPARAM NAME="new_sub_image" TYPE="FormField" VALUE="#new_sub_image#">
		<CFHTTPPARAM NAME="ret_sub_login_instructions" TYPE="FormField" VALUE="#ret_sub_login_instructions#">
		<CFHTTPPARAM NAME="ret_sub_account_add_instructions" TYPE="FormField" VALUE="#ret_sub_account_add_instructions#">
		<CFHTTPPARAM NAME="ret_sub_message" TYPE="FormField" VALUE="#ret_sub_message#">
		<CFHTTPPARAM NAME="ret_sub_image" TYPE="FormField" VALUE="#ret_sub_image#">
		<CFHTTPPARAM NAME="signup_thank_you_image" TYPE="FormField" VALUE="#signup_thank_you_image#">
		<CFHTTPPARAM NAME="signup_thank_you_copy" TYPE="FormField" VALUE="#signup_thank_you_copy#">
		<CFHTTPPARAM NAME="signup_redirect_url" TYPE="FormField" VALUE="#signup_redirect_url#">
		<CFHTTPPARAM NAME="newsletter_status_id" TYPE="FormField" VALUE="#newsletter_status_id#">
	</CFHTTP>

	<cfif cfhttp.filecontent CONTAINS "HTTP/1.0 404 Object Not Found">
		<cfthrow message="Error page not found">
	</cfif>
	<cfcatch>
		<cf_error session_id="#session_id#" error="#cfcatch.message#<br>#cfcatch.detail#" UI_page="organization_edit_action.cfm">
	</cfcatch>
</cftry>

<!--- Set variables based on API output --->
<cfset status = getToken(cfhttp.filecontent, 1, ",")>

<cfif trim(status) NEQ "SUCCESS">
	<cfset returncode = trim(getToken(cfhttp.filecontent, 2, ","))>
	<cf_error session_id="#session_id#" error="#returncode#" UI_page="organization_edit_action.cfm">
</cfif>

<!---------------->
<!--- Redirect --->
<!---------------->
<cfset msg = "Organization created successfully">
<cflocation url="nltr_form_man.cfm?s=#securestring#&msg=#msg#">
