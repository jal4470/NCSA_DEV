<!------------------------------------->
<!---  Capturepoint.com          	--->
<!---  CRS Action Page		   		--->
<!------------------------------------->
<!---  Created:  10.24.2006 by		--->
<!---	         Pat Waters			--->
<!---  Last Modified: 10.26.2006	--->
<!------------------------------------->

<!--- Set Application variables --->
<cfif not isdefined("application.dsn")>
	<cfinclude template="application.cfm">
</cfif>
<cflock scope="application" type="readonly" timeout="10">
	<cfset dsn = application.dsn>
	<cfset site_title = application.site_title>
</cflock>

<!--- Security --->
<cfinclude template="_secureme.cfm">

<!----------------------->
<!--- Local variables --->
<!----------------------->
<cfif isdefined("url.individual_id")>
	<cfset individual_id = url.individual_id>
<cfelseif isdefined("form.individual_id")>
	<cfset individual_id = form.individual_id>
<cfelse>
	<cf_error error="Individual is not defined.">
</cfif>

<cfif isdefined("url.form_question_choice_id")>
	<cfset form_question_choice_id = url.form_question_choice_id>
<cfelseif isdefined("form.form_question_choice_id")>
	<cfset form_question_choice_id = form.form_question_choice_id>
<cfelse>
	<cfset form_question_choice_id = "">
</cfif>

<cfif isdefined("url.searchterm")>
	<cfset searchterm = url.searchterm>
<cfelseif isdefined("form.searchterm")>
	<cfset searchterm = form.searchterm>
<cfelse>
	<cfset searchterm = "">
</cfif>

<cfif isdefined("url.start_record")>
	<cfset start_record = url.start_record>
<cfelseif isdefined("form.start_record")>
	<cfset start_record = form.start_record>
<cfelse>
	<cfset start_record = "">
</cfif>

<cfif isdefined("url.end_record")>
	<cfset end_record = url.end_record>
<cfelseif isdefined("form.end_record")>
	<cfset end_record = form.end_record>
<cfelse>
	<cfset end_record = "">
</cfif>


<!---------------->
<!--- Get data --->
<!---------------->
<CFTRY>
	<!--- Get states --->
	<cfquery datasource="#dsn#" name="getStates">
	SELECT state_desc
	  FROM v_state
	ORDER BY state_desc
	</cfquery>
	
	<CFINVOKE component="#application.CRS_CFC_Path#GetFamily" method="GetIndividual" returnvariable="getInd">
		<cfinvokeargument name="individual_id" value="#individual_id#">
	</CFINVOKE>
	<CFSET family_id = getind.family_id>
	<CFSET topic_form_id = "">
	<CFSET topic_question_id = "">
	<CFSET topic_form_question_id = "">
	<CFSET topic_question = "">

	<!--- Get topic form --->
	<CFINVOKE component="#application.CRS_CFC_Path#GetForm" method="GetTopicForm" returnvariable="TopicForm">
		<cfinvokeargument name="organization_id" value="#organization_id#">
		<cfinvokeargument name="form_type_id" value="#application.newsletter_form_type_id#">
	</CFINVOKE>

	<CFIF TopicForm.recordcount GT 0>
		<CFSET topic_form_id = TopicForm.form_id>
		<CFINVOKE component="#application.CRS_CFC_Path#GetForm" method="GetTopicQuestion" returnvariable="TopicQuestion">
			<cfinvokeargument name="form_id" value="#topic_form_id#">
		</CFINVOKE>
	
		<CFIF TopicQuestion.recordcount GT 0>
			<CFSET topic_question_id = TopicQuestion.question_id>
			<CFSET topic_form_question_id = TopicQuestion.form_question_id>
			<CFSET topic_question = "#TopicQuestion.display_label#">
		</CFIF>
	
		<CFINVOKE component="#application.CRS_CFC_Path#GetForm" method="GetTopicChoices" returnvariable="TopicChoices">
			<cfinvokeargument name="form_id" value="#topic_form_id#">
		</CFINVOKE>

		<cfif NOT isDefined("TopicChoices.RecordCount") OR TopicChoices.RecordCount EQ 0>
			<cf_error error="There are no topics for this organization. Form cannot be displayed.">
		</cfif>

	<CFELSE>
		<cf_error error="There is no topic form set up for this organization. Page cannot be displayed.">
	</CFIF>

	<!-------------------------->
	<!--- Get current values --->
	<!-------------------------->
	<CFSTOREDPROC datasource="#dsn#" procedure="p_get_news_retuser" returncode="YES" >
		<CFPROCRESULT NAME="getFamilyInfo" RESULTSET="1">
		<CFPROCRESULT NAME="getSelectedTopics" RESULTSET="2">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#organization_id#" DBVARNAME="@organization_id">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#family_id#" DBVARNAME="@family_id">
	</CFSTOREDPROC>

	<cfset selected_topics = ValueList(getSelectedTopics.form_question_choice_id)>

	<cfcatch>
		<cfinclude template="cfcatch.cfm">
	</cfcatch>
</cftry>

<!----------------->
<!--- Page body --->
<!----------------->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
	<title>Community Pass</title>
	<link rel="stylesheet" type="text/css" href="style.css" media="print,screen">
	<link  href="_newsletter_style.css" type="text/css" media="print,screen" rel="stylesheet">
	<link  href="_tooltip_style.css" type="text/css" media="print,screen" rel="stylesheet">
	
</head>

<body topmargin="0" leftmargin="0" rightmargin="0" marginheight="0" marginwidth="0" bgcolor="#FFFFFF">

<CFINCLUDE TEMPLATE="header_nltr.cfm">

<!--- BODY --->
<table border="0" cellspacing="0" cellpadding="2" width="100%">
	<tr>
		<td style="padding-left: 15px; padding-top: 10px;" valign="top" width="150">
		
		<!--- LEFT NAVIGATION --->
		<CF_nltr_navigation securestring="#securestring#" location="subscribers" organization_id="#organization_id#" rolelistStr="#rolelistStr#">
		
		</td>
		<td style="padding-top: 10px;padding-right: 10px;" valign="top">
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<td class="controlbar" colspan="2">
				<table border="0" cellspacing="0" cellpadding="0" width="100%">
					<CFOUTPUT>
					<form method="post" action="nltr_subscriber_search_action.cfm?s=#securestring#">
					<input type="hidden" name="nextpage" value="nltr_subscribers.cfm">
					<tr>
						<td width="5" align="left" valign="middle"><img src="assets/images/spcrimg.gif" alt="" width="1" height="3" border="0"></td>
						<td width="100" align="left" valign="middle">
						<input type="text" name="searchterm" class="regularfield">
						</td>
						<td width="50" align="left" valign="middle" style="background-image: url(assets/images/searchbutton.jpg);background-repeat: no-repeat;">
						<input type="submit" name="submit" value="Search" class="searchbut">
						</td>
						<td><img src="assets/images/spcrimg.gif" alt="" width="1" height="3" border="0"></td>
						<td width="50" align="right" valign="middle"><img src="assets/icons/admin.gif" alt="" width="21" height="17" border="0"></td>
						<td width="80" align="left" valign="middle" class="controlbartext" onclick="location.href='nltr_admin.cfm?s=#securestring#'">Administration</td>
						<td width="30" align="left" valign="middle"><img src="assets/icons/ques3.gif" alt="" width="21" height="17" border="0"></td>
					</tr>
					</form>
					</CFOUTPUT>
				</table>
				</td>
			</tr>
			<tr>
				<td class="emailtablebar">
				<div style="height: 5px;"> </div>
				<CFOUTPUT>
				<form method="post" action="nltr_subscribers_update_action.cfm?s=#securestring#">
				<input type="hidden" name="family_id" value="#family_id#">
				<input type="hidden" name="form_question_choice_id" value="#form_question_choice_id#">
				<input type="hidden" name="searchterm" value="#searchterm#">
				<input type="hidden" name="start_record" value="#start_record#">
				<input type="hidden" name="end_record" value="#end_record#">
				<table cellspacing="2" cellpadding="4" border="0" width="100%">
					<tr>
						<td class="formitemlabelwh"></td>
						<td class="formitemwh"><i class="required">*</i>All fields are required, please note that changing the email and address information below will update
						the corresponding family in the CommunityPass system.</td>
					</tr>
					<tr>
						<td class="formitemlabelwh">Email Address:</td>
						<td class="formitemwh"><input type="text" name="rpg_email" size="15" class="field200" value="#getFamilyInfo.rpg_email#"></td>
					</tr>
					<tr>
						<td class="formitemlabelwh">Address:</td>
						<td class="formitemwh"><input type="text" name="primary_address" size="15" class="field200" value="#getFamilyInfo.primary_address#"></td>
					</tr>
					<tr>
						<td class="formitemlabelwh">City:</td>
						<td class="formitemwh"><input type="text" name="primary_city" size="15" class="field200" value="#getFamilyInfo.primary_city#"></td>
					</tr>
					<tr>
						<td class="formitemlabelwh">State:</td>
						<td class="formitemwh">
						<select name="primary_state">
							<option value="">--Select--</option>
							<cfloop query="getStates">
							<option value="#state_desc#"<cfif getFamilyInfo.primary_state EQ getStates.state_desc> SELECTED</cfif>>#state_desc#</option>
							</cfloop>
						</select>
						</td>
					</tr>
					<tr>
						<td class="formitemlabelwh">Zip:</td>
						<td class="formitemwh"><input type="text" name="primary_zip5" size="15" class="field75" value="#getFamilyInfo.primary_zip5#"></td>
					</tr>
				</table>
				</CFOUTPUT>
				
				<table border="0" cellspacing="2" cellpadding="4" width="100%">
					<CFOUTPUT>
					<form method="post" action="nltr_edition_defaults_action.cfm?s=#securestring#" ENCTYPE="multipart/form-data">
					<tr>
						<td colspan="2"><img src="assets/images/spcrimg.gif" alt="" width="1" height="1" border="0"></td>
					</tr>
					<tr>
						<td class="newsformtopic" colspan="2" style="padding-left: 50px;">#topic_question#</td>
					</tr>
					<CFLOOP QUERY="Topicchoices">
					<tr>
						<td class="newsformboxitem"><input type="checkbox" name="topic_choice_id" value="#form_question_choice_id#"<cfif ListFind(selected_topics,form_question_choice_id) NEQ 0> CHECKED</cfif>></td>
						<td class="newsformboxitemlabel">#choice_short_desc#</td>
					</tr>
					</CFLOOP>
					<tr>
						<td colspan="2"><img src="assets/images/spcrimg.gif" alt="" width="1" height="5" border="0"></td>
					</tr>
					</CFOUTPUT>
				</table>
				
				<table border="0" cellspacing="2" cellpadding="4" width="100%">
					<tr>
						<td class="formitemlabelwh"><img src="assets/images/spcrimg.gif" alt="" width="1" height="1" border="0"></td>
						<td class="formitemwh"><img src="assets/images/but_email_cancel.gif"  width="72" height="17" onclick="location.href='javascript:history.back()'" border="0" style="cursor: pointer;"> 
						<input type="image" name="Submit" value="Submit" src="assets/images/but_email_save.gif"  width="72" height="17"></td>
					</tr>
					</form>
				</table>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>

<!--- END BODY --->

<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr>
		<td height="26" align="right" style="padding-right: 10px;"><IMG SRC="assets/images/cp_powered2.gif" ALT="" WIDTH="213" HEIGHT="26"></td>
	</tr>
</table>

</body>
</html>
