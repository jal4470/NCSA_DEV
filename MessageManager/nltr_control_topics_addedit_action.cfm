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
<cfif isdefined("form.form_question_choice_id")>
	<cfset form_question_choice_id = form.form_question_choice_id>
<cfelseif isdefined("url.form_question_choice_id")>
	<cfset form_question_choice_id = url.form_question_choice_id>
<cfelse>
	<cfset form_question_choice_id = "">
</cfif>

<cfif isdefined("form.topic_short_desc")>
	<cfset topic_short_desc  = form.topic_short_desc>
<cfelseif isdefined("url.topic_short_desc")>
	<cfset topic_short_desc = url.topic_short_desc>	
<cfelse>
	<cfset topic_short_desc = "">	
</cfif>

<cfif isdefined("form.topic_description")>
	<cfset topic_description  = form.topic_description>
<cfelseif isdefined("url.topic_description")>
	<cfset topic_description = url.topic_description>	
<cfelse>
	<cfset topic_description = "">	
</cfif>

<cfif isdefined("form.topic_status_id")>
	<cfset topic_status_id  = form.topic_status_id>
<cfelseif isdefined("url.topic_status_id")>
	<cfset topic_status_id = url.topic_status_id>	
<cfelse>
	<cfset topic_status_id = "0">	
</cfif>

<!------------------->
<!--- Validations --->
<!------------------->
<cfif topic_short_desc EQ "">
	<cf_error error="Please enter a topic.">
</cfif>

<cfif topic_description EQ "">
	<cf_error error="Please enter a description.">
</cfif>

<cfif len(topic_short_desc) GT 500>
	<cf_error error="Topic cannot exceed 500 characters.">
</cfif>

<cfif len(topic_description) GT 1000>
	<cf_error error="Description cannot exceed 1,000 characters.">
</cfif>

<!------------------------>
<!--- Determine action --->
<!------------------------>
<cfif form_question_choice_id EQ "">
	<cfset action = "add">
<cfelse>
	<cfset action = "edit">
</cfif>

<!-------------->
<!-------------->
<!--- Action --->
<!-------------->
<!-------------->

<!----------->
<!--- Add --->
<!----------->
<cfif action EQ "add">
	<cftry>
		<CFHTTP METHOD="POST" URL="#CRS_API_Path#/CreateNewsletterTopic.cfm" redirect="NO" throwonerror="Yes">
			<CFHTTPPARAM NAME="organization_id" TYPE="FormField" VALUE="#organization_id#">
			<CFHTTPPARAM NAME="topic_short_desc" TYPE="FormField" VALUE="#topic_short_desc#">
			<CFHTTPPARAM NAME="topic_description" TYPE="FormField" VALUE="#topic_description#">
			<CFHTTPPARAM NAME="topic_status_id" TYPE="FormField" VALUE="#topic_status_id#">
			<CFHTTPPARAM NAME="user_id" TYPE="FormField" VALUE="#user_id#">
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
		<cf_error error="An error was returned trying to create topic.">
	</cfif>

<!------------>
<!--- Edit --->
<!------------>
<cfelse>
	<cftry>
		<CFHTTP METHOD="POST" URL="#CRS_API_Path#/UpdateNewsletterTopic.cfm" redirect="NO" throwonerror="Yes">
			<CFHTTPPARAM NAME="form_question_choice_id" TYPE="FormField" VALUE="#form_question_choice_id#">
			<CFHTTPPARAM NAME="topic_short_desc" TYPE="FormField" VALUE="#topic_short_desc#">
			<CFHTTPPARAM NAME="topic_description" TYPE="FormField" VALUE="#topic_description#">
			<CFHTTPPARAM NAME="topic_status_id" TYPE="FormField" VALUE="#topic_status_id#">
			<CFHTTPPARAM NAME="user_id" TYPE="FormField" VALUE="#user_id#">
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
		<cf_error error="An error was returned trying to update topic.">
	</cfif>
</cfif>

<!---------------->
<!--- Redirect --->
<!---------------->
<cfif action EQ "add">
	<cfset msg = "Topic created successfully">
<cfelse>
	<cfset msg = "Topic updated successfully">
</cfif>
<cflocation url="nltr_control_topics.cfm?s=#securestring#&msg=#msg#">
