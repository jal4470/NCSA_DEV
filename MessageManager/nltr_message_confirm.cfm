<!------------------------------------->
<!---  Capturepoint.com          	--->
<!---  CRS Action Page		   		--->
<!------------------------------------->
<!---  Created:  10.24.2006 by		--->
<!---	         Pat Waters			--->
<!---  Last Modified: 10.26.2006	
1/15/2009 -- J.Lechuga increase timeout to handle large batches

--->
<!------------------------------------->
<cfsetting requesttimeout="600">

 
 <!--- validate login --->
 <cfmodule template="../_checkLogin.cfm">
 
<cflock scope="application" type="readonly" timeout="10">
	<cfset dsn = application.dsn>
</cflock>

<!----------------------->
<!--- Local variables --->
<!----------------------->
<cfif isdefined("form.message_id")>
	<cfset message_id  = form.message_id>
<cfelseif isdefined("url.message_id")>
	<cfset message_id = url.message_id>
<cfelse>
	<CF_ERROR error="Message is not defined.">
</CFIF>


<cfset email_to_string = "">
<cfset email_to_id_string = "">
<cfset email_coded_id_string = "">

<!---------------->
<!--- Get data --->
<!---------------->
<cftry>
		<cfquery name="getMessage" datasource="#dsn#">
		SELECT MESSAGE_DESC,
		       FROM_EMAIL_ADDRESS,
		       FROM_EMAIL_ALIAS,
		       REPLYTO_EMAIL_ADDRESS,
		       REPLYTO_EMAIL_ALIAS,
		       SUBJECT,
		       CC_EMAILS,
		       BCC_EMAILS,
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
		<cfset cc_emails = getMessage.cc_emails>
		<cfset bcc_emails = getMessage.bcc_emails>
		<cfset html_copy = getMessage.html_copy>

	<cfcatch>
		<cfdump var="#cfcatch#"><cfabort>
	</cfcatch>
</cftry>


<cftry>
	<CFSTOREDPROC datasource="#dsn#" procedure="p_get_nltr_edition_add_step3" returncode="YES">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#message_id#" DBVARNAME="@message_id">
	</CFSTOREDPROC>
	<cfcatch>
		<cfoutput>#cfcatch.message#: #cfcatch.detail#</cfoutput><cfabort>
		<cfinclude template="cfcatch.cfm">
	</cfcatch>
</cftry>	

<cfquery name="getRecipientCnt" datasource="#dsn#">
select count(*) as recipient_cnt 
from tbl_message_recipient 
where message_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#message_id#">

</cfquery>


<!----------------->
<!--- Page body --->
<!----------------->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
	<title>Message Manager</title>
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

<script type="text/javascript">
function doConfirmation(message_id){
	gostring = "<CFOUTPUT>nltr_cancel_action.cfm?nextpage=index.cfm&message_id=</CFOUTPUT>" + message_id;
	
	var message = "Are you sure you want to remove this message?";
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

</head>

<body topmargin="0" leftmargin="0" rightmargin="0" marginheight="0" marginwidth="0" bgcolor="#FFFFFF">

<CFINCLUDE TEMPLATE="assets/js/tooltip.js">

<!--- Header --->
<CFINCLUDE TEMPLATE="header_nltr.cfm">

<!--- BODY --->

<table border="0" cellspacing="0" cellpadding="2" width="100%">
	<tr>
		<td style="padding-left: 15px; padding-top: 10px;" valign="top" width="150">
		
		<!--- LEFT NAVIGATION --->
		<CF_nltr_navigation location="newmessage">
		
		</td>
		<td style="padding-top: 10px;padding-right: 10px;" valign="top" colspan="2">
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<td class="controlbar" colspan="2">
				<table border="0" cellspacing="0" cellpadding="0" width="100%">
					<CFOUTPUT>
					<form method="post" action="nltr_message_confirm_action.cfm">
					<tr>
						<td width="364" align="left" valign="middle" style="background-image: url(assets/images/emailconfirmbuttons.jpg);background-repeat: no-repeat;height:28px;">
						<table border="0" cellspacing="0" cellpadding="0" width="100%">
							<tr>
								<td width="99" align="left" valign="middle"><input type="submit" name="submit" value="Send" class="emailsendbut"></td>
								<td width="95" align="left" valign="middle"><input type="submit" name="submit" value="Save Draft" class="emaildraftsavebut"></td>
								<td width="98" align="left" valign="middle"><input type="submit" name="submit" value="Edit" class="emaileditbut"></td>
								<td width="72" align="left" valign="middle"><input type="reset" name="submit" value="Delete" class="emaildelbut" onclick="doConfirmation(#message_id#)"></td>
							</tr>
						</table>
						</td>
						<td><img src="assets/images/spcrimg.gif" alt="" width="1" height="3" border="0"></td>
						<td width="50" align="right" valign="middle"><img src="assets/icons/admin.gif" alt="" width="21" height="17" border="0"></td>
						<td width="30" align="left" valign="middle"><img src="assets/icons/ques3.gif" alt="" width="21" height="17" border="0"></td>
					</tr>
					</CFOUTPUT>
				</table>
				</td>
			</tr>
			<tr>
				<td valign="top" colspan="2">
				<CFOUTPUT>
				<input type="hidden" name="message_id" value="#message_id#">
				<input type="hidden" name="topic_choice_id_str" value="#email_coded_id_string#">
				<table border="0" cellspacing="2" cellpadding="2" width="100%">
					<tr>
						<td colspan="2"><img src="assets/images/spcrimg.gif" alt="" width="1" height="5" border="0"></td>
					</tr>
					<tr>
						<td colspan="2" class="emailalert"><img src="assets/icons/caution.gif" alt="" width="21" height="17" border="0" style="vertical-align: bottom"> You are about to send this message to #getRecipientCnt.recipient_cnt# recipients.</td>
					</tr>
					<tr>
						<td colspan="2"><img src="assets/images/spcrimg.gif" alt="" width="1" height="5" border="0"></td>
					</tr>
					<tr>
						<td colspan="2">
						<table border="0" cellspacing="2" cellpadding="2" width="100%">
							<tr>
								<td width="10"><img src="assets/images/spcrimg.gif" alt="" width="10" height="5" border="0"></td>
								<td class="sendbox" width="230" valign="top">
								<CFIF getRecipientCnt.recipient_cnt GT 0>
								<table border="0" cellspacing="3" cellpadding="3" width="100%">
									<tr>
										<td class="conf_title">Send:</td>
									</tr>
									<tr>
										<td class="conf_desc">Press this button to send this message immediately.</td>
									</tr>
									<tr>
										<td><!--- <input type="image" name="send" value="Send" src="assets/images/but_conf_send.gif"> --->
										<input type="submit" name="submit" value="Send" class="conf_but_send"></td>
									</tr>
								</table>
								</td>
								<td width="1"><img src="assets/images/spcrimg.gif" alt="" width="1" height="5" border="0"></td>
									</tr>
								</table>
								<CFELSE>
								<table border="0" cellspacing="3" cellpadding="3" width="100%">
									<tr>
										<td class="conf_title">Send:</td>
									</tr>
									<tr>
										<td class="conf_desc">There are no recipients for the selected topics/programs.  Please <a href="nltr_new_message.cfm?message_id=#message_id#">click here</a> to 
										return to the "edit message" page and revise the list of recipients for this message.</td>
									</tr>
								</table>
								</CFIF>
								</td>
								<td width="10"><img src="assets/images/spcrimg.gif" alt="" width="10" height="5" border="0"></td>
							</tr>
						</table>
						</td>
					</tr>
					<tr>
						<td colspan="2"><img src="assets/images/spcrimg.gif" alt="" width="1" height="5" border="0"></td>
					</tr>
					<tr>
						<td class="emailproplabel">Subject:</td>
						<td class="emailpropitem" align="left">#subject#</td>
					</tr>
					<tr>
						<td class="emailproplabel" width="150">From Email:</td>
						<td class="emailpropitem" align="left" width="90%">#from_email_address#</td>
					</tr>
					<tr>
						<td class="emailproplabel">From Name:</td>
						<td class="emailpropitem">#from_email_alias#</td>
					</tr>
					<tr>
						<td class="emailproplabel">Reply Email:</td>
						<td class="emailpropitem">#replyto_email_address#</td>
					</tr>
					<tr>
						<td class="emailproplabel">Reply Name:</td>
						<td class="emailpropitem">#replyto_email_alias#</td>
					</tr>
					<tr>
						<td colspan="2"><img src="assets/images/spcrimg.gif" alt="" width="1" height="25" border="0"></td>
					</tr>
					<tr>
						<td colspan="2" align="left" style="padding-left:5px;padding-right:20px;">
						<div class="emailpreviewbox">#html_copy#</div>
						</td>
					</tr>
				</table>
				</CFOUTPUT>
				</form>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>

<!--- END BODY --->


</form>
</body>
</html>
