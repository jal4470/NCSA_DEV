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
<CFTRY>
	<CFINVOKE component="#application.CRS_CFC_Path#GetOrgInfo" method="GetOrgSignupInfo" returnvariable="orgsignup">
		<cfinvokeargument name="organization_id" value="#organization_id#">
	</CFINVOKE>
	<CFCATCH type="any">
		<CF_ERROR error="Cannot get Organization Signup.">			
	</CFCATCH>			
</CFTRY>

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
			<form method="post" action="nltr_form_prop_edit_action.cfm?s=#securestring#" ENCTYPE="multipart/form-data">
			<input type="hidden" name="organization_id" value="#organization_id#">
			<!--- SIGN UP FORM PROPERTIES --->
			<tr>
				<td colspan="2">
				<table border="0" cellspacing="0" cellpadding="1" width="100%">
					<tr>
						<td width="300" class="formhead">Edit Sign Up Form Properties</td>
						<td align="right" class="formhead"><img src="assets/images/spcrimg.gif" alt="" width="1" height="1" border="0"></td>
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
				<td class="formitem">
				<select name="newsletter_status_id" class="regularfield">
					<option value="1"<CFIF newsletter_status_id EQ 1> SELECTED</CFIF>>Active
					<option value="0"<CFIF newsletter_status_id NEQ 1> SELECTED</CFIF>>Inactive
				</select>
				</td>
			</tr>
			<tr>
				<td class="formitemlabel">Header Image:</td>
				<td class="formitem"><input type="file" name="signup_header_image" class="imagefield"> <CFIF signup_header_image IS NOT ""><a href="javascript:popupimage('#signup_header_image#')" class="formlink">View Current</a></CFIF></td>
			</tr>
			<tr>
				<td class="formitemlabel" valign="top">Footer Copy:</td>
				<td class="formitem"><textarea name="signup_footer_copy" rows="3" cols="40" class="textarea">#signup_footer_copy#</textarea></td>
			</tr>
			<!---
			<tr>
				<td class="formitemlabel">Privacy Policy:</td>
				<td class="formitem"><input type="text" name="signup_privacy_policy_link" size="40" maxlength="100" class="widefield" value="#signup_privacy_policy_link#"> <CFIF signup_privacy_policy_link IS NOT ""><a href="#signup_privacy_policy_link#" class="formlink" target="_new">View Current</a></CFIF></td>
			</tr>
			--->
			<tr>
				<td class="formsubhead" colspan="2">New Subscriber</td>
			</tr>
			<tr>
				<td class="formitemlabel" valign="top">Login Page Inst.:</td>
				<td class="formitem"><textarea name="new_sub_login_instructions" rows="3" cols="40" class="textarea">#new_sub_login_instructions#</textarea></td>
			</tr>
			<tr>
				<td class="formitemlabel" valign="top">Account Add Inst:</td>
				<td class="formitem"><textarea name="new_sub_account_add_instructions" rows="3" cols="40" class="textarea">#new_sub_account_add_instructions#</textarea></td>
			</tr>
			<tr>
				<td class="formitemlabel" valign="top">Newsletter Message:</td>
				<td class="formitem"><textarea name="new_sub_message" rows="3" cols="40" class="textarea">#new_sub_message#</textarea></td>
			</tr>
			<tr>
				<td class="formitemlabel">Newsletter Image:</td>
				<td class="formitem"><input type="file" name="new_sub_image" class="imagefield" value="#new_sub_image#"> <CFIF new_sub_image IS NOT ""><a href="javascript:popupimage('#new_sub_image#')" class="formlink">View Current</a></CFIF></td>
			</tr>
			<tr>
				<td class="formsubhead" colspan="2">Returning Subscriber</td>
			</tr>
			<tr>
				<td class="formitemlabel" valign="top">Login Page Inst.:</td>
				<td class="formitem"><textarea name="ret_sub_login_instructions" rows="3" cols="40" class="textarea">#ret_sub_login_instructions#</textarea></td>
			</tr>
			<tr>
				<td class="formitemlabel" valign="top">Account Add Inst:</td>
				<td class="formitem"><textarea name="ret_sub_account_add_instructions" rows="3" cols="40" class="textarea">#ret_sub_account_add_instructions#</textarea></td>
			</tr>
			<tr>
				<td class="formitemlabel" valign="top">Newsletter Message:</td>
				<td class="formitem"><textarea name="ret_sub_message" rows="3" cols="40" class="textarea">#ret_sub_message#</textarea></td>
			</tr>
			<tr>
				<td class="formitemlabel">Newsletter Image:</td>
				<td class="formitem"><input type="file" name="ret_sub_image" class="imagefield" value"#ret_sub_image#"> <CFIF ret_sub_image IS NOT ""><a href="javascript:popupimage('#ret_sub_image#')" class="formlink">View Current</a></CFIF></td>
			</tr>
			<tr>
				<td class="formsubhead" colspan="2">Thank You Page</td>
			</tr>
			<tr>
				<td class="formitemlabel">Body Image:</td>
				<td class="formitem"><input type="file" name="signup_thank_you_image" class="imagefield" value="#signup_thank_you_image#"> <CFIF signup_thank_you_image IS NOT ""><a href="javascript:popupimage('#signup_thank_you_image#')" class="formlink">View Current</a></CFIF></td>
			</tr>
			<tr>
				<td class="formitemlabel" valign="top">Thank You Copy:</td>
				<td class="formitem"><textarea name="signup_thank_you_copy" rows="3" cols="40" class="textarea">#signup_thank_you_copy#</textarea></td>
			</tr>
			<tr>
				<td class="formitemlabel">Redirect Url:</td>
				<td class="formitem"><input type="text" name="signup_redirect_url" size="40" maxlength="100" class="widefield" value="#signup_redirect_url#"> <CFIF signup_redirect_url IS NOT ""><a href="#signup_redirect_url#" class="formlink" target="_new">View Current</a></CFIF></td>
			</tr>
			<tr>
				<td colspan="2" class="buttonholder"><div style="height:10px;"> </div></td>
			</tr>
			<tr>
				<td align="right"><a href="nltr_form_man.cfm?s=#securestring#"><img src="assets/images/but_bg_cancel.gif" alt="" width="63" height="18" border="0"></a></td>
				<td align="left"><input type="image" name="submit" value="submit" src="assets/images/but_save_update.gif"></td>
			</tr>
		</table>
		</form>
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
