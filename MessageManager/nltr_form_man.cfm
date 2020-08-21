<!------------------------------------->
<!---  Capturepoint.com          	--->
<!---  CRS Action Page		   		--->
<!------------------------------------->
<!---  Created:  10.24.2006 by		--->
<!---	         Pat Waters			--->
<!---
MODIFICATIONS
12/9/2009 P Waters
- Replaced "Newsletter Manager" with "Message Manager"
									--->
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

<CFSET fqc_id = "">
<CFSET fqc_desc = "">
<CFIF ISDEFINED("url.fqc_id")>
	<CFSET fqc_id = url.fqc_id>
</CFIF>

<CFSET signup_header_image = "">
<CFSET signup_footer_copy = "">
<CFSET signup_privacy_policy_link = "">
<CFSET new_sub_login_instructions = "">
<CFSET new_sub_account_add_instructions = "">
<CFSET new_sub_message = "">
<CFSET new_sub_image = "">
<CFSET ret_sub_login_instructions = "">
<CFSET ret_sub_account_add_instructions = "">
<CFSET ret_sub_message = "">
<CFSET ret_sub_image = "">
<CFSET signup_thank_you_image = "">
<CFSET signup_thank_you_copy = "">
<CFSET signup_redirect_url = "">
<CFSET newsletter_status_id = "">


<!---------------->
<!--- Get data --->
<!---------------->

	<CFINVOKE component="#application.CRS_CFC_Path#GetOrgInfo" method="GetOrgSignupInfo" returnvariable="orgsignup">
		<cfinvokeargument name="organization_id" value="#organization_id#">
	</CFINVOKE>
<!---
<CFTRY>
	<CFCATCH type="any">
		<CF_ERROR error="Cannot get Organization Signup.">			
	</CFCATCH>			
</CFTRY>
--->

<CFSET signup_header_image = "#orgsignup.signup_header_image#">
<CFSET signup_footer_copy = "#orgsignup.signup_footer_copy#">
<CFSET signup_privacy_policy_link = "#orgsignup.privacy_policy#">
<CFSET new_sub_login_instructions = "#orgsignup.new_sub_login_instructions#">
<CFSET new_sub_account_add_instructions = "#orgsignup.new_sub_account_add_instructions#">
<CFSET new_sub_message = "#orgsignup.new_sub_message#">
<CFSET new_sub_image = "#orgsignup.new_sub_image#">
<CFSET ret_sub_login_instructions = "#orgsignup.ret_sub_login_instructions#">
<CFSET ret_sub_account_add_instructions = "#orgsignup.ret_sub_account_add_instructions#">
<CFSET ret_sub_message = "#orgsignup.ret_sub_message#">
<CFSET ret_sub_image = "#orgsignup.ret_sub_image#">
<CFSET signup_thank_you_image = "#orgsignup.signup_thank_you_image#">
<CFSET signup_thank_you_copy = "#orgsignup.signup_thank_you_copy#">
<CFSET signup_redirect_url = "#orgsignup.signup_redirect_url#">
<CFSET newsletter_status_id = "#orgsignup.newsletter_status_id#">


<CFSET topic_form_id = "">
<CFSET topic_question_id = "">
<CFSET topic_form_question_id = "">
<CFSET topic_question = "">

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
	
<script language="JavaScript1.3" type="text/javascript">
function scbg(objRef, state) {
	objRef.style.backgroundColor = (1 == state) ? '#D3D8ED' : '#EEEEF0';
	return;
}
</script>
<script language="JavaScript1.3" type="text/javascript">
function scbg2(objRef, state) {
	objRef.style.backgroundColor = (1 == state) ? '#6661A7' : '#848BAF';
	return;
}
</script>
<script language="JavaScript1.3" type="text/javascript">
function scbg3(objRef, state) {
	objRef.style.backgroundColor = (1 == state) ? '#6661A7' : '#B0B1B3';
	return;
}
</script>
<script language="javascript">
<!--
 function popup(item){
 	gostring = "<CFOUTPUT>nltr_view_item.cfm?s=#securestring#&organization_id=#organization_id#&item=</CFOUTPUT>" + item;
 	sciwin= window.open(gostring, 'edit','width=550,height=400,screenX=20,screenY=40,left=20,top=40,scrollbars=auto,status=no,location=no,resizable=no,')
  }
//-->
</script>
<script language="javascript">
<!--
 function popupimage(image){
 	gostring = "<CFOUTPUT>nltr_view_image.cfm?s=#securestring#&organization_id=#organization_id#&image=</CFOUTPUT>" + image;
 	sciwin= window.open(gostring, 'edit','width=700,height=400,screenX=20,screenY=40,left=20,top=40,scrollbars=auto,status=no,location=no,resizable=no,')
  }
//-->
</script>
</head>

<body topmargin="0" leftmargin="0" rightmargin="0" marginheight="0" marginwidth="0" bgcolor="#FFFFFF">

<CFINCLUDE TEMPLATE="assets/js/tooltip.js">

<!--- Header --->
<CFINCLUDE TEMPLATE="header_nltr.cfm">

<table border="0" cellspacing="0" cellpadding="2" width="100%" bgcolor="#6661A7">
	<tr>
		<td width="50%" align="left" class="whitebold12" style="padding-left: 15px; height: 20px;">Message Management - Sign Up Form</td>
		<td width="50%" align="right" class="whitebold12" style="padding-right: 10px; height: 20px;"><cfoutput>#organization_desc#</cfoutput></td>
	</tr>
</table>

<!--- BODY --->

<div id="instructions">Welcome to the Message Manager, please choose the appropriate selection below.
</div>

<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr>
		<td style="padding-left: 15px; padding-right: 15px;">
		<table border="0" cellspacing="2" cellpadding="2" width="100%">
			<CFOUTPUT>
			<!--- SIGN UP FORM PROPERTIES --->
			<tr>
				<td colspan="2">
				<table border="0" cellspacing="0" cellpadding="1" width="100%">
					<tr>
						<td width="300" class="formhead">Sign Up Form Properties</td>
						<td align="right" class="formhead"><a href="nltr_form_prop_edit.cfm?s=#securestring#" class="formlink"><img src="assets/images/but_hd_edit.gif" alt="" width="53" height="16" border="0"></a></td>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td class="formsubhead" colspan="2">General</td>
			</tr>
			<tr>
				<td class="formitemlabel">Sign Up Url:</td>
				<td class="formitem">http://newsletter.communitypass.net/index.cfm?o=#organization_id#</td>
			</tr>
			<tr>
				<td class="formitemlabel">Status:</td>
				<td class="formitem"><CFIF newsletter_status_id EQ 1>Active<CFELSE>Inactive</CFIF></td>
			</tr>
			<tr>
				<td class="formitemlabel">Header Image:</td>
				<td class="formitem"><CFIF signup_header_image IS NOT ""><a href="javascript:popupimage('#signup_header_image#')" class="formlink">View</a><CFELSE>None</CFIF></td>
			</tr>
			<tr>
				<td class="formitemlabel">Footer Copy:</td>
				<td class="formitem"><CFIF signup_footer_copy IS NOT ""><a href="javascript:popup('signup_footer_copy')" class="formlink">View</a><CFELSE>None</CFIF></td>
			</tr>
			<!---
			<tr>
				<td class="formitemlabel">Privacy Policy:</td>
				<td class="formitem"><CFIF signup_privacy_policy_link IS NOT ""><a href="#signup_privacy_policy_link#" class="formlink" target="_new">#signup_privacy_policy_link#</a><CFELSE>None</CFIF></td>
			</tr>
			--->
			<tr>
				<td class="formsubhead" colspan="2">New Subscriber</td>
			</tr>
			<tr>
				<td class="formitemlabel">Login Page Inst.:</td>
				<td class="formitem"><CFIF new_sub_login_instructions IS NOT ""><a href="javascript:popup('new_sub_login_instructions')" class="formlink">View</a><CFELSE>None</CFIF></td>
			</tr>
			<tr>
				<td class="formitemlabel">Account Add Inst:</td>
				<td class="formitem"><CFIF new_sub_account_add_instructions IS NOT ""><a href="javascript:popup('new_sub_account_add_instructions')" class="formlink">View</a><CFELSE>None</CFIF></td>
			</tr>
			<tr>
				<td class="formitemlabel">Newsletter Message:</td>
				<td class="formitem"><CFIF new_sub_message IS NOT ""><a href="javascript:popup('new_sub_message')" class="formlink">View</a><CFELSE>None</CFIF></td>
			</tr>
			<tr>
				<td class="formitemlabel">Newsletter Image:</td>
				<td class="formitem"><CFIF new_sub_image IS NOT ""><a href="javascript:popupimage('#new_sub_image#')" class="formlink">View</a><CFELSE>None</CFIF></td>
			</tr>
			<tr>
				<td class="formsubhead" colspan="2">Returning Subscriber</td>
			</tr>
			<tr>
				<td class="formitemlabel">Login Page Inst.:</td>
				<td class="formitem"><CFIF ret_sub_login_instructions IS NOT ""><a href="javascript:popup('ret_sub_login_instructions')" class="formlink">View</a><CFELSE>None</CFIF></td>
			</tr>
			<tr>
				<td class="formitemlabel">Account Add Inst:</td>
				<td class="formitem"><CFIF ret_sub_account_add_instructions IS NOT ""><a href="javascript:popup('ret_sub_account_add_instructions')" class="formlink">View</a><CFELSE>None</CFIF></td>
			</tr>
			<tr>
				<td class="formitemlabel">Newsletter Message:</td>
				<td class="formitem"><CFIF ret_sub_message IS NOT ""><a href="javascript:popup('ret_sub_message')" class="formlink">View</a><CFELSE>None</CFIF></td>
			</tr>
			<tr>
				<td class="formitemlabel">Newsletter Image:</td>
				<td class="formitem"><CFIF ret_sub_image IS NOT ""><a href="javascript:popupimage('#ret_sub_image#')" class="formlink">View</a><CFELSE>None</CFIF></td>
			</tr>
			<tr>
				<td class="formsubhead" colspan="2">Thank You Page</td>
			</tr>
			<tr>
				<td class="formitemlabel">Body Image:</td>
				<td class="formitem"><CFIF signup_thank_you_image IS NOT ""><a href="javascript:popupimage('#signup_thank_you_image#')" class="formlink">View</a><CFELSE>None</CFIF></td>
			</tr>
			<tr>
				<td class="formitemlabel">Thank You Copy:</td>
				<td class="formitem"><CFIF signup_thank_you_copy IS NOT ""><a href="javascript:popup('signup_thank_you_copy')" class="formlink">View</a><CFELSE>None</CFIF></td>
			</tr>
			<tr>
				<td class="formitemlabel">Redirect Url:</td>
				<td class="formitem"><CFIF signup_redirect_url IS NOT ""><a href="#signup_redirect_url#" class="formlink" target="_new">#signup_redirect_url#</a><CFELSE>None</CFIF></td>
			</tr>
		</table>
		</CFOUTPUT>
		<!---
		<div style="height:5px;"> </div>
		
		<!--- SIGN UP FORM QUESTIONS --->
		<table border="0" cellspacing="2" cellpadding="2" width="100%">
			<tr>
				<td colspan="3">
				<table border="0" cellspacing="0" cellpadding="1" width="100%">
					<tr>
						<td width="300" class="formhead">Sign Up Form Fields</td>
						<td align="right" class="formhead"><img src="assets/images/spcrimg.gif" alt="" width="1" height="1" border="0"></td>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td colspan="3">
				
				<!-------------------->
				<!--- Declare form --->
				<!-------------------->
				<cfoutput>
				<form method="post" action="?s=#securestring#">
				
				</cfoutput>

				<!--- Submit buttons --->
				<table border="0" cellspacing="0" cellpadding="0" width="100%">
					<tr>
						<td width="53"><input type="image" name="edit" value="submit" src="assets/images/but_edit_w.gif"></td>
						<td width="43"><input type="image" name="seq_up" value="submit" src="assets/images/but_up_w.gif"></td>
						<td width="43"><input type="image" name="seq_down" value="submit" src="assets/images/but_down_w.gif"></td>

						<td width="75"><input type="image" name="remove" value="submit" src="assets/images/but_remove_w.gif"></td>

						<cfoutput>
						<td align="right"><a href=""><IMG SRC="assets/images/but_bg_addques.gif" ALT="" WIDTH="95" HEIGHT="18" BORDER="0"></a></td>
						</cfoutput>
					</tr>
					<tr>
						<td colspan="5" height="2"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="2"></td>
					</tr>
				</table>
				
				</td>
			</tr>
			<tr>
				<td class="formsubhead" width="15"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="2"></td>
				<td class="formsubhead" width="100%">Question</td>
				<td class="formsubhead" width="75"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="2"></td>
			</tr>
			<tr>
				<td class="formitem" width="15"><input type="radio" name="ques" value="1"></td>
				<td class="formitem">Address</td>
				<td class="formitem" width="75" NOWRAP>Not-Required</td>
			</tr>
			<tr>
				<td class="formitem"><input type="radio" name="ques" value="1"></td>
				<td class="formitem">Cell Phone</td>
				<td class="formitem" NOWRAP>Not-Required</td>
			</tr>
			<tr>
				<td class="formitem"><input type="radio" name="ques" value="1"></td>
				<td class="formitem">Email</td>
				<td class="formitem" NOWRAP>Not-Required</td>
			</tr>
			<tr>
				<td class="formitem"><input type="radio" name="ques" value="1"></td>
				<td class="formitem">Can You Swim?</td>
				<td class="formitem" NOWRAP>Not-Required</td>
			</tr>
		</table>
		--->
		<div style="height:5px;"> </div>
		
		<!--- TOPICS --->
		<CFIF topic_form_id IS NOT "" and topic_form_question_id IS NOT "">
		<table border="0" cellspacing="2" cellpadding="2" width="100%">
			<tr>
				<td colspan="2">
				<table border="0" cellspacing="0" cellpadding="1" width="100%">
					<tr>
						<td width="300" class="formhead">Topics</td>
						<td align="right" class="formhead"><img src="assets/images/spcrimg.gif" alt="" width="1" height="1" border="0"></td>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td colspan="2">
				
				<!-------------------->
				<!--- Declare form --->
				<!-------------------->
				<cfoutput>
				<form method="post" action="nltr_topic_choice_action.cfm?s=#securestring#">
				<input type="hidden" name="form_id" value="#topic_form_id#">
				<input type="hidden" name="question_id" value="#topic_question_id#">
				<input type="hidden" name="form_question_id" value="#topic_form_question_id#">
				<input type="hidden" name="edit_fqc_id" value="#fqc_id#">
				</cfoutput>

				<!--- Submit buttons --->
				<table border="0" cellspacing="0" cellpadding="0" width="100%">
					<tr>
						<td width="53"><input type="image" name="edit" value="submit" src="assets/images/but_edit_w.gif"></td>
						<!---
						<td width="43"><input type="image" name="seq_up" value="submit" src="assets/images/but_up_w.gif"></td>
						<td width="43"><input type="image" name="seq_down" value="submit" src="assets/images/but_down_w.gif"></td>
						--->
						<td width="75"><input type="image" name="remove" value="submit" src="assets/images/but_remove_w.gif"></td>
						<cfoutput>
						<td align="right"><input type="text" name="topic_description" size="30" maxlength="100" class="regularfield" value="#fqc_desc#"></td>
						<td align="right" width="105"><input type="image" name="save_topic" value="submit" src="assets/images/but_bg_addsavetopic.gif"></td>
						<td align="right" width="61"><input type="image" name="clear" value="submit" src="assets/images/but_clear.gif"></td>
						</cfoutput>
					</tr>
					<tr>
						<td colspan="5" height="2"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="2"></td>
					</tr>
				</table>
				
				</td>
			</tr>
			<tr>
				<td class="formsubhead" width="15"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="2"></td>
				<td class="formsubhead" width="100%">Topic</td>
			</tr>
			<CFOUTPUT>
			<tr>
				<td class="formitem" width="15"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="2"></td>
				<td class="formitem"><b>#topic_question#</b></td>
			</tr>
			</CFOUTPUT>
			<CFIF TopicChoices.recordcount GT 0>
			<CFOUTPUT QUERY="Topicchoices">
			<tr>
				<td class="formitem" width="15"><input type="radio" name="form_question_choice_id" value="#form_question_choice_id#"<CFIF form_question_choice_id EQ fqc_id> CHECKED</CFIF>></td>
				<td class="formitem">#choice_short_desc#</td>
			</tr>
			</CFOUTPUT>
			<CFELSE>
			<tr>
				<td class="formitem" width="15"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="2"></td>
				<td class="formitem">No Choices Set</td>
			</tr>
			</CFIF>
		</table>
		</CFIF>
		<div style="height:25px;"> </div>
		<CFOUTPUT>
		<!--- buttons --->
		<table border="0" cellspacing="2" cellpadding="2">
			<tr>
				<td><a href="nltr_home.cfm?s=#securestring#"><img src="assets/images/but_bg_done.gif" alt="" width="53" height="18" border="0"></a></td>
				<td><img src="assets/images/but_bg_prevform.gif" alt="" width="95" height="18" border="0"></td>
			</tr>
		</table>
		</CFOUTPUT>
		
		<div style="height:25px;"> </div>
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
