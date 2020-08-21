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
<cfif isdefined("form.message_id")>
	<cfset message_id  = form.message_id>
<cfelseif isdefined("url.message_id")>
	<cfset message_id = url.message_id>
<cfelse>
	<cfset message_id = "">	
</cfif>

<!---------------->
<!--- Get data --->
<!---------------->
<cftry>
	<!--- New message --->
	<cfif message_id EQ "">
		<cfquery name="getOrgDefaults" datasource="#dsn#">
		SELECT DEF_NEWS_FROM_EMAIL,
		       DEF_NEWS_FROM_ALIAS,
		       DEF_NEWS_REPLYTO_EMAIL,
		       DEF_NEWS_REPLYTO_ALIAS
		  FROM V_ORGANIZATION
		 WHERE ORGANIZATION_ID = <CFQUERYPARAM VALUE="#ORGANIZATION_ID#">
		</cfquery>
	
		<cfset message_desc = "">
		<cfset from_email_address = getOrgDefaults.def_news_from_email>
		<cfset from_email_alias = getOrgDefaults.def_news_from_alias>
		<cfset replyto_email_address = getOrgDefaults.def_news_replyto_email>
		<cfset replyto_email_alias = getOrgDefaults.def_news_replyto_alias>
		<cfset subject = "">
		<cfset cc_bcc_emails = "">
		<cfset html_copy = "">

	<!--- Edit message --->
	<cfelse>
		<cfquery name="getMessage" datasource="#dsn#">
		SELECT MESSAGE_DESC,
		       FROM_EMAIL_ADDRESS,
		       FROM_EMAIL_ALIAS,
		       REPLYTO_EMAIL_ADDRESS,
		       REPLYTO_EMAIL_ALIAS,
		       SUBJECT,
		       CC_BCC_EMAILS,
		       HTML_COPY
		  FROM V_MESSAGE
		 WHERE MESSAGE_ID = <CFQUERYPARAM VALUE="#MESSAGE_ID#">
		 </cfquery>

		<cfset message_desc = getMessage.message_desc>
		<cfset from_email_address = getMessage.from_email_address>
		<cfset from_email_alias = getMessage.from_email_alias>
		<cfset replyto_email_address = getMessage.replyto_email_address>
		<cfset replyto_email_alias = getMessage.replyto_email_alias>
		<cfset subject = getMessage.subject>
		<cfset cc_bcc_emails = getMessage.cc_bcc_emails>
		<cfset html_copy = getMessage.html_copy>
	</cfif>

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
	<link  href="_newsletter_style.css" type="text/css" media="print,screen" rel="stylesheet" >
	<link  href="_tooltip_style.css" type="text/css" media="print,screen" rel="stylesheet" >
	<!-- tinyMCE -->
	<script language="javascript" type="text/javascript" src="assets/jscripts/tiny_mce/tiny_mce.js"></script>
	<script language="javascript" type="text/javascript">
	tinyMCE.init({
		mode : "textareas",
		theme : "advanced",
		plugins : "style,layer,table,save,advhr,advimage,advlink,emotions,iespell,insertdatetime,preview,zoom,media,searchreplace,print,contextmenu,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking,xhtmlxtras,template",
		theme_advanced_buttons1 : "bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,|,styleselect,formatselect,fontselect,fontsizeselect",
		theme_advanced_buttons2 : "cut,copy,paste,pastetext,pasteword,|,search,replace,|,bullist,numlist,|,outdent,indent,|,undo,redo,|,link,unlink,anchor,cleanup,help,|,insertdate,inserttime,preview,|,forecolor,backcolor",
		theme_advanced_buttons3 : "tablecontrols,|,hr,removeformat,visualaid,|,sub,sup,|,charmap,iespell,advhr,|,ltr,rtl",
		theme_advanced_buttons4 : "styleprops,|,cite,abbr,acronym,del,ins,attribs,|,visualchars,nonbreaking",
		theme_advanced_toolbar_location : "top",
		theme_advanced_toolbar_align : "left",
		theme_advanced_path_location : "bottom",
		extended_valid_elements : "a[name|href|target|title|onclick],img[class|src|border=0|alt|title|hspace|vspace|width|height|align|onmouseover|onmouseout|name],hr[class|width|size|noshade],font[face|size|color|style],span[class|align|style]",
		template_external_list_url : "example_template_list.js"
	});
	</script>
	<!-- /tinyMCE -->

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
</head>

<body topmargin="0" leftmargin="0" rightmargin="0" marginheight="0" marginwidth="0" bgcolor="#FFFFFF">

<CFINCLUDE TEMPLATE="assets/js/tooltip.js">

<!--- Header --->
<CFINCLUDE TEMPLATE="header_nltr.cfm">

<table border="0" cellspacing="0" cellpadding="2" width="100%" bgcolor="#6661A7">
	<tr>
		<td width="50%" align="left" class="whitebold12" style="padding-left: 15px; height: 20px;">Message Management - Edition Add Step 1</td>
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
			<form method="post" action="nltr_edition_add_step1_action.cfm?s=#securestring#">
			<input type="hidden" name="message_id" value="#message_id#">

			<!--- SIGN UP FORM PROPERTIES --->
			<tr>
				<td colspan="2">
				<table border="0" cellspacing="0" cellpadding="1" width="100%">
					<tr>
						<td width="300" class="formhead">Message Properties</td>
						<td align="right" class="formhead"><img src="assets/images/spcrimg.gif" alt="" width="1" height="1" border="0"></td>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td class="formitemlabel">Edition Name:</td>
				<td class="formitem"><input type="text" name="message_desc" size="40" maxlength="100" class="regularfield" value="#message_desc#"></td>
			</tr>
			<tr>
				<td class="formitemlabel">From Email:</td>
				<td class="formitem"><input type="text" name="from_email_address" size="40" maxlength="100" class="regularfield" value="#from_email_address#"></td>
			</tr>
			<tr>
				<td class="formitemlabel">From Alias:</td>
				<td class="formitem"><input type="text" name="from_email_alias" size="40" maxlength="100" class="regularfield" value="#from_email_alias#"></td>
			</tr>
			<tr>
				<td class="formitemlabel">Reply-To Email:</td>
				<td class="formitem"><input type="text" name="replyto_email_address" size="40" maxlength="100" class="regularfield" value="#replyto_email_address#"></td>
			</tr>
			<tr>
				<td class="formitemlabel">Reply-To Alias:</td>
				<td class="formitem"><input type="text" name="replyto_email_alias" size="40" maxlength="100" class="regularfield" value="#replyto_email_alias#"></td>
			</tr>
			<tr>
				<td class="formitemlabel">Subject:</td>
				<td class="formitem"><input type="text" name="subject" size="40" maxlength="100" class="regularfield" value="#subject#"></td>
			</tr>
			<tr>
				<td class="formitemlabel">CC/BCC:</td>
				<td class="formitem"><input type="text" name="cc_bcc_emails" size="40" maxlength="100" class="regularfield" value="#cc_bcc_emails#"></td>
			</tr>
			<tr>
				<td colspan="2" class="buttonholder"><div style="height:10px;"> </div></td>
			</tr>
			<tr>
				<td colspan="2">
				<table border="0" cellspacing="0" cellpadding="1" width="100%">
					<tr>
						<td width="300" class="formhead">Message Body</td>
						<td align="right" class="formhead"><img src="assets/images/spcrimg.gif" alt="" width="1" height="1" border="0"></td>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td class="formitem" colspan="2"><textarea name="html_copy" cols="100" rows="30">#html_copy#</textarea></td>
			</tr>
			<tr>
				<td colspan="2" class="buttonholder"><div style="height:10px;"> </div></td>
			</tr>
			<tr>
				<td colspan="2"><a href="nltr_cancel_action.cfm?s=#securestring#&message_id=#message_id#"><img src="assets/images/but_bg_cancel.gif" alt="" width="63" height="18" border="0"></a>&nbsp;
				<input type="image" name="submit" value="submit" src="assets/images/but_bg_continue.gif"></td>
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
