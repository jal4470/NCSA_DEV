<!------------------------------------->
<!---  Capturepoint.com          	--->
<!---  CRS UI Page		   			--->
<!------------------------------------->
<!---  Created:  11.14.2007 by		--->
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
	<cfset site_title = application.site_title>
</cflock>

<!--- Security --->
<cfinclude template="_secureme.cfm">

<!----------------------->
<!--- Local variables --->
<!----------------------->

<!------------------------->
<!--- SORTING STUFF --->
<!------------------------->
<script type="text/javascript" language="JavaScript"><!--
function ShowContent(x) 
{	// This toogles the sort options based on the user's selection 	
	//turn off display on all
	document.getElementById('alpha').style.display = "none"
	document.getElementById('rules').style.display = "none"
	document.getElementById('manual').style.display = "none"
	// display selected
	document.getElementById(x).style.display = ""
}
//-->
</script>

<!--- run following only once when the page is first hit --->
<CFSET REFERER 	  = TRIM(listLast(listFirst(CGI.HTTP_REFERER,"?"),"/"))>
<CFSET scriptName = TRIM(listLast(CGI.SCRIPT_NAME,"/"))>

<CFIF isDefined("FORM.DoSort")>
	<!--- Process the sort options selected and resort the list --->
	<CFMODULE template = "program_list_seq_process.cfm" 
				   DSN = "#VARIABLES.DSN#"
			 PrimCatID = "#FORM.PrimaryCategoryID#"
			  SecCatID = "#FORM.SecondaryCategoryID#"
			formValues = "#FORM#"
			 returnVar = "returnVar">
</CFIF>

<!-------------------------->
<!--- END  SORTING STUFF --->
<!-------------------------->

<!---------------->
<!--- Get data --->
<!---------------->
<CFSET topic_form_id = "">
<CFSET topic_question_id = "">
<CFSET topic_form_question_id = "">
<CFSET topic_question = "">
<CFSET fqc_id = "">
<CFSET fqc_desc = "">

<CFTRY>
	<CFINVOKE component="#application.CRS_CFC_Path#GetForm" method="GetTopicForm" returnvariable="TopicForm">
		<cfinvokeargument name="organization_id" value="#organization_id#">
		<cfinvokeargument name="form_type_id" value="#application.newsletter_form_type_id#">
	</CFINVOKE>
	<CFCATCH type="any">
		<CF_ERROR error="Cannot get Newsletter Form.">			
	</CFCATCH>			
</CFTRY>

<CFIF TopicForm.recordcount GT 0>
	<CFSET topic_form_id = TopicForm.form_id>
	<CFTRY>
		<CFINVOKE component="#application.CRS_CFC_Path#GetForm" method="GetTopicQuestion" returnvariable="TopicQuestion">
			<cfinvokeargument name="form_id" value="#topic_form_id#">
		</CFINVOKE>
		<CFCATCH type="any">
			<CF_ERROR error="Cannot get Newsletter Form Question.">			
		</CFCATCH>			
	</CFTRY>
	
	<CFIF TopicQuestion.recordcount GT 0>
		<CFSET topic_question_id = TopicQuestion.question_id>
		<CFSET topic_form_question_id = TopicQuestion.form_question_id>
		<CFSET topic_question = "#TopicQuestion.display_label#">
	</CFIF>
	
	<CFTRY>
		<CFINVOKE component="#application.CRS_CFC_Path#GetForm" method="GetTopicChoices" returnvariable="TopicChoices">
			<cfinvokeargument name="form_id" value="#topic_form_id#">
		</CFINVOKE>
		<CFCATCH type="any">
			<CF_ERROR error="Cannot get Newsletter Form Choices.">			
		</CFCATCH>			
	</CFTRY>
</CFIF>

<CFIF fqc_id IS NOT "">
	<CFTRY>
		<CFINVOKE component="#application.CRS_CFC_Path#GetForm" method="GetChoice" returnvariable="GetChoice">
			<cfinvokeargument name="form_question_choice_id" value="#fqc_id#">
		</CFINVOKE>
		<CFCATCH type="any">
			<CF_ERROR error="Cannot get Choice.">			
		</CFCATCH>			
	</CFTRY>
	<CFIF GetChoice.recordcount GT 0>
		<CFSET fqc_desc = "#GetChoice.choice_short_desc#">
	</CFIF>
</CFIF>

<!----------------->
<!--- Page body --->
<!----------------->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
	<title>Community Pass</title>
	<link rel="stylesheet" type="text/css" href="style.css" media="print,screen">
	<link  href="_newsletter_style.css" type="text/css" media="print,screen" rel="stylesheet" >
	<link  href="_tooltip_style.css" type="text/css" media="print,screen" rel="stylesheet" >
	
	<script type="text/javascript">
	function doConfirmation(form_question_choice_id){
		gostring = "<CFOUTPUT>nltr_control_topic_remove_action.cfm?s=#securestring#&nextpage=nltr_control_topics.cfm&form_question_choice_id=</CFOUTPUT>" + form_question_choice_id;
		
		var message = "Are you sure you want to remove this topic?";
		var wantToContinue = "false";
		
	
		wantToContinue = confirm(message);
		
		
		if (wantToContinue == true) { 
			// put whatever you want to happen if someone clicks OK here
			window.location.href=gostring;
		}else{
			return false;
		}
	}
	
	</script>
	<script language="JavaScript1.3" type="text/javascript">
	function scbg(objRef, state) {
		objRef.style.backgroundColor = (1 == state) ? '#D3D8ED' : '#FFFFFF';
		return;
	}
	</script>	
</head>

<body topmargin="0" leftmargin="0" rightmargin="0" marginheight="0" marginwidth="0" bgcolor="#FFFFFF">

<CFINCLUDE TEMPLATE="header_nltr.cfm">
<!--- BODY --->


<table border="0" cellspacing="0" cellpadding="2" width="100%">
	<tr>
		<td style="padding-left: 15px; padding-top: 10px;" valign="top" width="150">
		
		<!--- LEFT NAVIGATION --->
		<CF_nltr_navigation securestring="#securestring#" location="admin" organization_id="#organization_id#" rolelistStr="#rolelistStr#">
		
		</td>
		<td style="padding-top: 10px;padding-right: 10px;" valign="top">
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<td class="controlbar" colspan="2">
				<table border="0" cellspacing="0" cellpadding="0" width="100%">
					<CFOUTPUT>
					<tr>
						<td width="250" align="left" valign="middle" style="background-image: url(assets/images/emailbarback.jpg);background-repeat:repeat-x;height:28px;">
						<table border="0" cellspacing="0" cellpadding="0" width="100%">
							<tr>
								<td width="250" align="left" valign="middle" class="bartitle">Administration - Topics</td>
							</tr>
						</table>
						</td>
						<td><img src="assets/images/spcrimg.gif" alt="" width="1" height="3" border="0"></td>
						<td width="50" align="right" valign="middle"><img src="assets/icons/admin.gif" alt="" width="21" height="17" border="0"></td>
						<td width="80" align="left" valign="middle" class="controlbartext" onclick="location.href='nltr_admin.cfm?s=#securestring#'">Administration</td>
						<td width="30" align="left" valign="middle"><img src="assets/icons/ques3.gif" alt="" width="21" height="17" border="0"></td>
					</tr>
					</CFOUTPUT>
				</table>
				</td>
			</tr>
			<tr>
				<td class="emailtablebar">
				
				
				<div style="width:auto;height:5px;"> </div>
				
				<cfoutput>
				<form method="post" action="nltr_control_topics_sort_action.cfm?s=#securestring#">
				<input type="hidden" name="form_question_id" value="#topic_form_question_id#">
				</cfoutput>

				<div style="width:auto;height:5px;"> </div>
				<table border="0" cellspacing="0" cellpadding="2" width="442">
					<tr>
						<td style="padding-left:15px;" width="415">
						<SCRIPT src="assets/js/tmt_core.js" type=text/javascript></SCRIPT>
							<SCRIPT src="assets/js/tmt_spry_select.js" type=text/javascript></SCRIPT>
							<SCRIPT type=text/javascript>
								function selectAll(selectBox,selectAll) 
								{	if (typeof selectBox == "string") 
									{
										selectBox = document.getElementById(selectBox);
									}
									// is the select box a multiple select box?
									if (selectBox.type == "select-multiple") 
									{	for (var i = 0; i < selectBox.options.length; i++) 
										{	selectBox.options[i].selected = selectAll;
										}
									}
								}
							</SCRIPT>
						<DIV id="manual" style="display: block;">
						
						<select id="destination" name="NewAttrSeq" tmt:spryselect="true" multiple class="sortbox">
						<CFIF TopicChoices.recordcount GT 0>
						<CFOUTPUT>
<!---						<CFSET listSeq = "">--->
						<CFLOOP QUERY="TopicChoices">
						<option value="#question_choice_id#">#choice_short_desc#</option>
<!---						<CFSET listSeq = listAppend(listSeq, form_question_choice_sequence)>--->
						</CFLOOP>
						</CFOUTPUT>
						<CFELSE>
						<option value="">No Choices Set</option>
						</CFIF>
						</select>
						</td>
						<td valign="top" style="padding-left:10px;" width="27">
						<table border="0" cellspacing="0" cellpadding="3">
							<tr>
								<td><!--- <INPUT onclick="tmt.spry.select.util.moveOptionUp('destination')" type=button value="Move up">
								<INPUT onclick="tmt.spry.select.util.moveOptionUp('destination')" type="image" value="Move up" src="assets/images/but_email_up.gif"> --->
								<img src="assets/images/but_email_up.gif" alt="" width="19" height="17" border="0" onclick="tmt.spry.select.util.moveOptionUp('destination')" style="cursor:pointer;">
								</td>
							</tr>
							<tr>
								<td><!--- <INPUT onclick="tmt.spry.select.util.moveOptionDown('destination')" type=button value="Move down">
								<INPUT onclick="tmt.spry.select.util.moveOptionDown('destination')" type="image" value="Move down" src="assets/images/but_email_down.gif">--->
								<img src="assets/images/but_email_down.gif" alt="" width="19" height="17" border="0" onclick="tmt.spry.select.util.moveOptionDown('destination')" style="cursor:pointer;">
								</td>
							</tr>
						</table>
						</td>
					</tr>
				</table>
				<div style="width:auto;height:5px;"> </div>
				<CFOUTPUT>
				<table border="0" cellspacing="0" cellpadding="0" width="100%">
					<tr>
						<td width="82" style="padding-left:15px;"><a href="nltr_admin.cfm?s=#securestring#""><img src="assets/images/but_email_cancel.gif" alt="" width="72" height="17" border="0"></a></td>
						<td>
						<!--- <input onclick="selectAll(destination,selectAll)" type="Submit" name="DoSort" value="Re-Sort"> --->
						<input type="image" name="DoSort" value="Re-Sort" src="assets/images/but_email_save.gif"  width="72" height="17" onclick="selectAll(destination,selectAll)">
<!---						<input type="Hidden" name="listSeq" value="#listSeq#">--->
						</td>
					</tr>
					<tr>
						<td colspan="2" height="2"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="2"></td>
					</tr>
				</table>
				</CFOUTPUT>

				</form>

				<div style="width:auto;height:20px;"> </div>
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
