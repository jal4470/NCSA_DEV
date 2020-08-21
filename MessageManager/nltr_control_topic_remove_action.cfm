<!------------------------------------->
<!---  Capturepoint.com          	--->
<!---  CRS Action Page		   	--->
<!------------------------------------->
<!---  File: act_form_create_action.cfm	--->
<!---  Created:  04.02.2003 by	--->
<!---	         Pat Waters		--->
<!---  Last Modified: 04.02.2003	--->
<!------------------------------------->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">

 
 <!--- validate login --->
 <cfmodule template="../_checkLogin.cfm">
 
<!--- Set Application variables --->
<cfif not isdefined("application.dsn")>
	<cfinclude template="application.cfm">
</cfif>
<cflock scope="application" type="readonly" timeout="10">
	<cfset dsn = application.dsn>
	<cfset CRS_API_Path = application.CRS_API_Path>
	<cfset site_title = application.site_title>
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

<cfif isdefined("form.nextpage")>
 <cfset nextpage = form.nextpage>
<cfelseif isdefined("url.nextpage")>
 <cfset nextpage = url.nextpage>
<cfelse>
 <cfset nextpage = "nltr_control_topics.cfm">
</cfif>

<!------------------>
<!--- Validation --->
<!------------------>
<cfif form_question_choice_id EQ "">
 <cf_error error="System error - form_question_choice_id is blank." Code="76020" UI_page="nltr_control_topic_remove_action.cfm">
</cfif>

<!---------------->
<!--- Get data --->
<!---------------->
<cftry>
	<cfquery name="getStatus" datasource="#dsn#">
	SELECT STATUS_ID
	  FROM V_NEWSLETTER_TOPICS
	 WHERE FORM_QUESTION_CHOICE_ID = <CFQUERYPARAM VALUE="#FORM_QUESTION_CHOICE_ID#">
	</cfquery>
	
	<cfif getStatus.status_id EQ 1>
		<cfset new_status_id = 0>
	<cfelse>
		<cfset new_status_id = 1>
	</cfif>

	<cfcatch>
		<cfinclude template="cfcatch.cfm">
	</cfcatch>
</cftry>

<!-------------->
<!-------------->
<!--- Action --->
<!-------------->
<!-------------->

<!---------------->
<!--- Call API --->
<!---------------->
<cftry>
	<CFHTTP METHOD="POST" URL="#CRS_API_Path#/UpdateFormQuestionChoiceStatus.cfm" redirect="NO" throwonerror="Yes">
		<CFHTTPPARAM NAME="form_question_choice_id" TYPE="FormField" VALUE="#form_question_choice_id#">
		<CFHTTPPARAM NAME="status_id" TYPE="FormField" VALUE="#new_status_id#">
	</CFHTTP>

	<cfif cfhttp.filecontent CONTAINS "HTTP/1.0 404 Object Not Found">
		<cfthrow message="Error page not found">
	</cfif>
	<cfcatch>
		<cf_error session_id="#session_id#" error="An error occurred trying to update choice status." Code="76018" UI_page="nltr_topic_choice_action.cfm">
	</cfcatch>
</cftry>

<!--- Set variables based on API output --->
<cfset status = getToken(cfhttp.filecontent, 1, ",")>
<cfif trim(status) NEQ "SUCCESS">
	<cfset returncode = trim(getToken(cfhttp.filecontent, 2, ","))>
	<cfset error = trim(getToken(cfhttp.filecontent, 3, ","))>
	<cf_error session_id="#session_id#" error="#error#" code="#returncode#" UI_page="nltr_topic_choice_action.cfm">
</cfif>

<!---------------->
<!--- Redirect --->
<!---------------->
<cflocation url="#nextpage#?s=#securestring#">
