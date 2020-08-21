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

<cfif isdefined("form.message_desc")>
	<cfset message_desc  = form.message_desc>
<cfelseif isdefined("url.message_desc")>
	<cfset message_desc = url.message_desc>
<cfelse>
	<cfset message_desc = "">	
</cfif>

<cfif isdefined("form.from_email_address")>
	<cfset from_email_address  = form.from_email_address>
<cfelseif isdefined("url.from_email_address")>
	<cfset from_email_address = url.from_email_address>
<cfelse>
	<cfset from_email_address = "">	
</cfif>

<cfif isdefined("form.from_email_alias")>
	<cfset from_email_alias  = form.from_email_alias>
<cfelseif isdefined("url.from_email_alias")>
	<cfset from_email_alias = url.from_email_alias>
<cfelse>
	<cfset from_email_alias = "">	
</cfif>

<cfif isdefined("form.replyto_email_address")>
	<cfset replyto_email_address  = form.replyto_email_address>
<cfelseif isdefined("url.replyto_email_address")>
	<cfset replyto_email_address = url.replyto_email_address>
<cfelse>
	<cfset replyto_email_address = "">	
</cfif>

<cfif isdefined("form.replyto_email_alias")>
	<cfset replyto_email_alias  = form.replyto_email_alias>
<cfelseif isdefined("url.replyto_email_alias")>
	<cfset replyto_email_alias = url.replyto_email_alias>
<cfelse>
	<cfset replyto_email_alias = "">	
</cfif>

<cfif isdefined("form.subject")>
	<cfset subject  = form.subject>
<cfelseif isdefined("url.subject")>
	<cfset subject = url.subject>
<cfelse>
	<cfset subject = "">	
</cfif>

<cfif isdefined("form.cc_bcc_emails")>
	<cfset cc_bcc_emails  = replace(form.cc_bcc_emails," ","","ALL")>
<cfelseif isdefined("url.cc_bcc_emails")>
	<cfset cc_bcc_emails = replace(url.cc_bcc_emails," ","","ALL")>
<cfelse>
	<cfset cc_bcc_emails = "">	
</cfif>

<cfif isdefined("form.html_copy")>
	<cfset html_copy  = form.html_copy>
<cfelseif isdefined("url.html_copy")>
	<cfset html_copy = url.html_copy>
<cfelse>
	<cfset html_copy = "">	
</cfif>

<cfif isdefined("form.text_copy")>
	<cfset text_copy  = form.text_copy>
<cfelseif isdefined("url.text_copy")>
	<cfset text_copy = url.text_copy>
<cfelse>
	<cfset text_copy = "">	
</cfif>

<!------------------->
<!--- Validations --->
<!------------------->
<cfset error = "">

<!--- Required fields --->
<cfif message_desc EQ "">
	<cfset error = error & "<li>Please enter an Edition Name.</li>">
</cfif>

<cfif from_email_address EQ "">
	<cfset error = error & "<li>Please enter a From Email.</li>">
</cfif>

<cfif from_email_alias EQ "">
	<cfset error = error & "<li>Please enter From Alias.</li>">
</cfif>

<cfif replyto_email_address EQ "">
	<cfset error = error & "<li>Please enter a Reply-To Email.</li>">
</cfif>

<cfif replyto_email_alias EQ "">
	<cfset error = error & "<li>Please enter a Reply-To Alias.</li>">
</cfif>

<cfif subject EQ "">
	<cfset error = error & "<li>Please enter a Subject.</li>">
</cfif>

<cfif html_copy EQ "" AND text_copy EQ "">
	<cfset error = error & "<li>Please enter the Message Body.</li>">
</cfif>

<!--- Type conversion --->
<cfinclude template="../UDF_isValidEmail.cfm">

<cfif NOT isValidEmail(from_email_address)>
	<cfset error = error & "<li>'#from_email_address#' is not a valid email address.</li>">
</cfif>

<cfif NOT isValidEmail(replyto_email_address)>
	<cfset error = error & "<li>'#replyto_email_address#' is not a valid email address.</li>">
</cfif>

<cfif cc_bcc_emails NEQ "">
	<cfloop from="1" to="#ListLen(cc_bcc_emails,';')#" index="i">
		<cfset curr_email = Trim(ListGetAt(cc_bcc_emails,i,';'))>
		<cfif NOT isValidEmail(curr_email)>
			<cfset error = error & "<li>'#curr_email#' is not a valid email address.</li>">
		</cfif>
	</cfloop>
</cfif>

<!---------------------------->
<!--- Check for duplicates --->
<!---------------------------->
<cftry>
	<!--- Add --->
	<cfif message_id EQ "">
		<cfquery name="chkDup" datasource="#dsn#">
		SELECT COUNT(*) AS CNT
		  FROM V_MESSAGE
		 WHERE ORGANIZATION_ID = <CFQUERYPARAM VALUE="#ORGANIZATION_ID#">
		   AND MESSAGE_DESC = <CFQUERYPARAM VALUE="#MESSAGE_DESC#">
		</cfquery>

	<!--- Edit --->
	<cfelse>	
		<cfquery name="chkDup" datasource="#dsn#">
		SELECT COUNT(*) AS CNT
		  FROM V_MESSAGE
		 WHERE ORGANIZATION_ID = <CFQUERYPARAM VALUE="#ORGANIZATION_ID#">
		   AND MESSAGE_DESC = <CFQUERYPARAM VALUE="#MESSAGE_DESC#">
		   AND MESSAGE_ID <> <CFQUERYPARAM VALUE="#MESSAGE_ID#">
		</cfquery>

	</cfif>
	
	<cfif chkDup.cnt GT 0>
		<cfset error = error & "<li>A message named '#message_desc#' already exists for your organization.</li>">
	</cfif>

	<cfcatch>
		<cfinclude template="cfcatch.cfm">
	</cfcatch>
</cftry>

<!--------------------->
<!--- Return errors --->
<!--------------------->
<cfif error NEQ "">
	<cf_error error="Please fix the following errors:<ul>#error#</ul>">
</cfif>

<!-------------->
<!-------------->
<!--- Action --->
<!-------------->
<!-------------->

<!------------------------>
<!--- Determine action --->
<!------------------------>
<cfif message_id EQ "">
	<cfset action="add">
<cfelse>
	<cfset action="edit">
</cfif>

<!----------->
<!--- Add --->
<!----------->
<cfif action EQ "add">
	<cftry>
		<CFHTTP METHOD="POST" URL="#CRS_API_Path#/CreateMessage.cfm" redirect="NO" throwonerror="Yes">
			<CFHTTPPARAM NAME="organization_id" TYPE="FormField" VALUE="#organization_id#">
			<CFHTTPPARAM NAME="message_desc" TYPE="FormField" VALUE="#message_desc#">
			<CFHTTPPARAM NAME="from_email_address" TYPE="FormField" VALUE="#from_email_address#">
			<CFHTTPPARAM NAME="from_email_alias" TYPE="FormField" VALUE="#from_email_alias#">
			<CFHTTPPARAM NAME="replyto_email_address" TYPE="FormField" VALUE="#replyto_email_address#">
			<CFHTTPPARAM NAME="replyto_email_alias" TYPE="FormField" VALUE="#replyto_email_alias#">
			<CFHTTPPARAM NAME="subject" TYPE="FormField" VALUE="#subject#">
			<CFHTTPPARAM NAME="cc_bcc_emails" TYPE="FormField" VALUE="#cc_bcc_emails#">
			<CFHTTPPARAM NAME="html_copy" TYPE="FormField" VALUE="#html_copy#">
			<CFHTTPPARAM NAME="text_copy" TYPE="FormField" VALUE="#text_copy#">
			<CFHTTPPARAM NAME="created_via_message_manager_flag" TYPE="FormField" VALUE="1">
		</CFHTTP>
	
		<cfif cfhttp.filecontent CONTAINS "HTTP/1.0 404 Object Not Found">
			<cfthrow message="Error page not found">
		</cfif>

		<cfcatch>
			<cfinclude template="cfcatch.cfm">
		</cfcatch>
	</cftry>
	
	<cfset status = getToken(cfhttp.filecontent, 1, ",")>
	<cfif trim(status) EQ "SUCCESS">
		<cfset message_id = trim(getToken(cfhttp.filecontent, 2, ","))>
	<cfelse>
		<cf_error session_id="#session_id#" error="An error was returned trying to create message." UI_page="nltr_edition_add_step1_action.cfm">
	</cfif>
</cfif>

<!------------>
<!--- Edit --->
<!------------>
<cfif action EQ "edit">
	<cftry>
		<CFHTTP METHOD="POST" URL="#CRS_API_Path#/UpdateMessage.cfm" redirect="NO" throwonerror="Yes">
			<CFHTTPPARAM NAME="message_id" TYPE="FormField" VALUE="#message_id#">
			<CFHTTPPARAM NAME="message_desc" TYPE="FormField" VALUE="#message_desc#">
			<CFHTTPPARAM NAME="from_email_address" TYPE="FormField" VALUE="#from_email_address#">
			<CFHTTPPARAM NAME="from_email_alias" TYPE="FormField" VALUE="#from_email_alias#">
			<CFHTTPPARAM NAME="replyto_email_address" TYPE="FormField" VALUE="#replyto_email_address#">
			<CFHTTPPARAM NAME="replyto_email_alias" TYPE="FormField" VALUE="#replyto_email_alias#">
			<CFHTTPPARAM NAME="subject" TYPE="FormField" VALUE="#subject#">
			<CFHTTPPARAM NAME="cc_bcc_emails" TYPE="FormField" VALUE="#cc_bcc_emails#">
			<CFHTTPPARAM NAME="html_copy" TYPE="FormField" VALUE="#html_copy#">
			<CFHTTPPARAM NAME="text_copy" TYPE="FormField" VALUE="#text_copy#">
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
		<cf_error session_id="#session_id#" error="An error was returned trying to update message." UI_page="nltr_edition_add_step1_action.cfm">
	</cfif>
</cfif>

<!---------------->
<!--- Redirect --->
<!---------------->
<cflocation url="nltr_edition_add_step2.cfm?s=#securestring#&message_id=#message_id#" addtoken="no">
