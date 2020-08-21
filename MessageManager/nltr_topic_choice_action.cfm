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

<!------------------------>
<!--- Determine action --->
<!------------------------>
<cfif isdefined("form.edit.x")>
 <cfset action="edit">
<cfelseif isdefined("form.seq_up.x")>
 <cfset action="seq_up">
<cfelseif isdefined("form.seq_down.x")>
 <cfset action="seq_down">
<cfelseif isdefined("form.remove.x")>
 <cfset action="remove">
<cfelseif isdefined("form.save_topic.x")>
 <cfset action="save">
<cfelseif isdefined("form.clear.x")>
 <cfset action="clear">
<cfelse>
 <cf_error error="System error - action cannot be determined." Code="76020" UI_page="activity_change_action.cfm">
</cfif>

<!--------------------------->
<!--- Set local variables --->
<!--------------------------->
<cfif isdefined("form.form_id")>
 <cfset form_id = form.form_id>
<cfelseif isdefined("url.form_id")>
 <cfset form_id = url.form_id>
<cfelse>
 <cf_error error="Form_id not defined." Code="76020" UI_page="activity_change_action.cfm">
</cfif>

<cfif isdefined("form.form_question_id")>
 <cfset form_question_id = form.form_question_id>
<cfelseif isdefined("url.form_question_id")>
 <cfset form_question_id = url.form_question_id>
<cfelse>
 <cf_error error="You must select a form question." Code="76020" UI_page="activity_change_action.cfm">
</cfif>

<cfif isdefined("form.question_id")>
 <cfset question_id = form.question_id>
<cfelseif isdefined("url.question_id")>
 <cfset question_id = url.question_id>
<cfelse>
 <cf_error error="You must select a question." Code="76020" UI_page="activity_change_action.cfm">
</cfif>

<cfif isdefined("form.form_question_choice_id")>
 <cfset form_question_choice_id = form.form_question_choice_id>
<cfelseif isdefined("url.form_question_choice_id")>
 <cfset form_question_choice_id = url.form_question_choice_id>
<cfelse>
 <cfset form_question_choice_id = "">
</cfif>

<cfif isdefined("form.edit_fqc_id")>
 <cfset edit_fqc_id = form.edit_fqc_id>
<cfelseif isdefined("url.edit_fqc_id")>
 <cfset edit_fqc_id = url.edit_fqc_id>
<cfelse>
 <cfset edit_fqc_id = "">
</cfif>

<cfif isdefined("form.topic_description")>
 <cfset topic_description = form.topic_description>
<cfelseif isdefined("url.topic_description")>
 <cfset topic_description = url.topic_description>
<cfelse>
 <cfset topic_description = "">
</cfif>


<!------------------>
<!--- Validation --->
<!------------------>
<cfif form_id EQ "">
 <cf_error error="System error - form_id is blank." Code="76020" UI_page="activity_change_action.cfm">
</cfif>

<cfif form_question_id EQ "">
 <cf_error error="System error - form_question_id is blank." Code="76020" UI_page="activity_change_action.cfm">
</cfif>

<!------------>
<!------------>
<!------------>
<!------------>
<!--- Edit --->
<!------------>
<!------------>
<!------------>
<!------------>
<cfif action EQ "edit">
 <cflocation url="nltr_form_man.cfm?s=#securestring#&fqc_id=#form_question_choice_id#">
</cfif>

<cfif action EQ "clear">
 <cflocation url="nltr_form_man.cfm?s=#securestring#">
</cfif>

<!------------------>
<!------------------>
<!------------------>
<!------------------>
<!--- Resequence --->
<!------------------>
<!------------------>
<!------------------>
<!------------------>
<cfif action EQ "seq_up" OR action EQ "seq_down">
 <cftry>
	<cfquery name="getQuestion" datasource="#dsn#">
	SELECT QUESTION_ID
	  FROM V_FORM_QUESTION
	 WHERE FORM_QUESTION_ID = #FORM_QUESTION_ID#
	</cfquery>

	<cfcatch>
		<cf_error error="An error occurred trying to retrieve data." Code="76020" UI_page="act_form_ques.cfm">
	</cfcatch>
 </cftry>

 <!------------------------------>
 <!--- Set sequence direction --->
 <!------------------------------>
 <cfif action EQ "seq_up">
  <cfset seq_dir = "up">
 <cfelseif action EQ "seq_down">
  <cfset seq_dir = "down">
 <cfelse>
  <cfset seq_dir = "down">
 </cfif>

 <!---------------->
 <!--- Call API --->
 <!---------------->
 <cftry>
	<CFHTTP METHOD="POST" URL="#CRS_API_Path#/ResequenceFormQuestion.cfm" redirect="NO" throwonerror="Yes">
		<CFHTTPPARAM NAME="action" TYPE="FormField" VALUE="#seq_dir#">
		<CFHTTPPARAM NAME="form_id" TYPE="FormField" VALUE="#form_id#">
		<CFHTTPPARAM NAME="question_id" TYPE="FormField" VALUE="#getQuestion.question_id#">
	</CFHTTP>

	<cfif cfhttp.filecontent CONTAINS "HTTP/1.0 404 Object Not Found">
		<cfthrow message="Error page not found">
	</cfif>
	<cfcatch>
		<cf_error session_id="#session_id#" error="An error occurred trying to create form." Code="76018" UI_page="activity_change_action.cfm">
	</cfcatch>
 </cftry>

 <!--- Set variables based on API output --->
 <cfset status = getToken(cfhttp.filecontent, 1, ",")>
 <cfoutput>
	<cfif trim(status) NEQ "SUCCESS">
		<cfset returncode = trim(getToken(cfhttp.filecontent, 2, ","))>
		<cfset error = trim(getToken(cfhttp.filecontent, 3, ","))>
		<cf_error session_id="#session_id#" error="#error#" code="#returncode#" UI_page="activity_change_action.cfm">
	</cfif>
 </cfoutput>

</cfif>

<!-------------->
<!-------------->
<!-------------->
<!-------------->
<!--- Remove --->
<!-------------->
<!-------------->
<!-------------->
<!-------------->
<cfif action EQ "remove">

 <!---------------->
 <!--- Call API --->
 <!---------------->
 <cftry>
	<CFHTTP METHOD="POST" URL="#CRS_API_Path#/UpdateFormQuestionChoiceStatus.cfm" redirect="NO" throwonerror="Yes">
		<CFHTTPPARAM NAME="form_question_choice_id" TYPE="FormField" VALUE="#form_question_choice_id#">
		<CFHTTPPARAM NAME="status_id" TYPE="FormField" VALUE="0">
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
 <cfoutput>
	<cfif trim(status) NEQ "SUCCESS">
		<cfset returncode = trim(getToken(cfhttp.filecontent, 2, ","))>
		<cfset error = trim(getToken(cfhttp.filecontent, 3, ","))>
		<cf_error session_id="#session_id#" error="#error#" code="#returncode#" UI_page="nltr_topic_choice_action.cfm">
	</cfif>
 </cfoutput>

</cfif>

<cfif action EQ "save">

	<CFIF edit_fqc_id IS NOT "">
	
		<!--- UPDATE EXISTING CHOICE --->
		<CFTRY>
			<CFINVOKE component="#application.CRS_CFC_Path#GetForm" method="GetChoice" returnvariable="GetChoice">
				<cfinvokeargument name="form_question_choice_id" value="#edit_fqc_id#">
			</CFINVOKE>
			<CFCATCH type="any">
				<CF_ERROR error="Cannot get Choice.">			
			</CFCATCH>			
		</CFTRY>
		<CFIF GetChoice.recordcount GT 0>
			<CFSET choice_id = "#GetChoice.choice_id#">
			<CFSET choice_short_desc = "#GetChoice.choice_short_desc#">
			<CFSET description = "#GetChoice.choice_description#">
			<CFSET open_ended_flag = "#GetChoice.open_ended_flag#">
			<CFSET closed_ended_flag = "#GetChoice.closed_ended_flag#">
		<CFELSE>
			<CF_ERROR error="Cannot get Choice.">	
		</CFIF>
		<CFIF topic_description IS "">
			<CF_ERROR error="Description Cannot Be Empty.">	
		</CFIF>
		
		
		<cftry>
			<CFHTTP METHOD="POST" URL="#CRS_API_Path#/UpdateChoice.cfm" redirect="NO" throwonerror="Yes">
				<CFHTTPPARAM NAME="choice_id" TYPE="FormField" VALUE="#choice_id#">
				<CFHTTPPARAM NAME="short_desc" TYPE="FormField" VALUE="#topic_description#">
				<CFHTTPPARAM NAME="description" TYPE="FormField" VALUE="#description#">
				<CFHTTPPARAM NAME="open_ended_flag" TYPE="FormField" VALUE="#open_ended_flag#">
				<CFHTTPPARAM NAME="closed_ended_flag" TYPE="FormField" VALUE="#closed_ended_flag#">
			</CFHTTP>
		
			<cfif cfhttp.filecontent CONTAINS "HTTP/1.0 404 Object Not Found">
				<cfthrow message="Error page not found">
			</cfif>
			<cfcatch>
				<cf_error session_id="#session_id#" error="An error occurred trying to update choice status." Code="76018" UI_page="nltr_topic_choice_action.cfm">
			</cfcatch>
		 </cftry>
		
		<!--- <CFOUTPUT>MADE IT HERE:#cfhttp.filecontent#</CFOUTPUT><CFABORT> --->
		
		 <!--- Set variables based on API output --->
		 <cfset status = getToken(cfhttp.filecontent, 1, ",")>
		 <cfoutput>
			<cfif trim(status) NEQ "SUCCESS">
				<cfset returncode = trim(getToken(cfhttp.filecontent, 2, ","))>
				<cfset error = trim(getToken(cfhttp.filecontent, 3, ","))>
				<cf_error session_id="#session_id#" error="#error#" code="#returncode#" UI_page="nltr_topic_choice_action.cfm">
			</cfif>
		 </cfoutput>
		
	<CFELSE>

		<!--- CREATE NEW CHOICE --->
		
		<CFIF topic_description IS "">
			<CF_ERROR error="Description Cannot Be Empty.">	
		</CFIF>

		 <!---------------->
		 <!--- new choice --->
		 <!---------------->
		 <cftry>
			<CFHTTP METHOD="POST" URL="#CRS_API_Path#/CreateChoice.cfm" redirect="NO" throwonerror="Yes">
				<CFHTTPPARAM NAME="short_desc" TYPE="FormField" VALUE="#topic_description#">
				<CFHTTPPARAM NAME="description" TYPE="FormField" VALUE="">
				<CFHTTPPARAM NAME="open_ended_flag" TYPE="FormField" VALUE="0">
				<CFHTTPPARAM NAME="closed_ended_flag" TYPE="FormField" VALUE="1">
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
		 <cfoutput>
			<cfif trim(status) NEQ "SUCCESS">
				<cfset returncode = trim(getToken(cfhttp.filecontent, 2, ","))>
				<cfset error = trim(getToken(cfhttp.filecontent, 3, ","))>
				<cf_error session_id="#session_id#" error="#error#" code="#returncode#" UI_page="nltr_topic_choice_action.cfm">
			<cfelse>
				<cfset choice_id = trim(getToken(cfhttp.filecontent, 2, ","))>
			</cfif>
		 </cfoutput>
		 
		 <!---------------->
		 <!--- add choice to question --->
		 <!---------------->
		 <cftry>
			<CFHTTP METHOD="POST" URL="#CRS_API_Path#/AddChoiceToQuestion.cfm" redirect="NO" throwonerror="Yes">
				<CFHTTPPARAM NAME="question_id" TYPE="FormField" VALUE="#question_id#">
				<CFHTTPPARAM NAME="choice_id" TYPE="FormField" VALUE="#choice_id#">
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
		 <cfoutput>
			<cfif trim(status) NEQ "SUCCESS">
				<cfset returncode = trim(getToken(cfhttp.filecontent, 2, ","))>
				<cfset error = trim(getToken(cfhttp.filecontent, 3, ","))>
				<cf_error session_id="#session_id#" error="#error#" code="#returncode#" UI_page="nltr_topic_choice_action.cfm">
			<cfelse>
				<cfset question_choice_id = trim(getToken(cfhttp.filecontent, 2, ","))>
			</cfif>
		 </cfoutput>
		 
		 <!---------------->
		 <!--- add question choice to form question --->
		 <!---------------->
		 <cftry>
			<CFHTTP METHOD="POST" URL="#CRS_API_Path#/AddChoiceToFormQuestion.cfm" redirect="NO" throwonerror="Yes">
				<CFHTTPPARAM NAME="form_question_id" TYPE="FormField" VALUE="#form_question_id#">
				<CFHTTPPARAM NAME="question_choice_id" TYPE="FormField" VALUE="#question_choice_id#">
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
		 <cfoutput>
			<cfif trim(status) NEQ "SUCCESS">
				<cfset returncode = trim(getToken(cfhttp.filecontent, 2, ","))>
				<cfset error = trim(getToken(cfhttp.filecontent, 3, ","))>
				<cf_error session_id="#session_id#" error="#error#" code="#returncode#" UI_page="nltr_topic_choice_action.cfm">
			<cfelse>
				<cfset form_question_choice_id = trim(getToken(cfhttp.filecontent, 2, ","))>
			</cfif>
		 </cfoutput>
	</CFIF>
</cfif>


<!---------------->
<!--- Redirect --->
<!---------------->
<cflocation url="nltr_form_man.cfm?s=#securestring#">
