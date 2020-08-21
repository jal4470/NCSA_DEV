<!------------------------------------->
<!---  Capturepoint.com          	--->
<!---  CRS Action Page		   		--->
<!------------------------------------->
<!---  Created:  10.24.2006 by		--->
<!---	         Pat Waters			--->
<!---  Last Modified: 10.26.2006	--->
<!------------------------------------->

<!--------------------------------------
-- MODIFICATIONS --
----------------------------------------

05/22/2017 A.PINZONE (TICKET NCSA22821)
-- Added an ID to the page body for scroll.js to work.

--------------------------------------->

 
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

<CFIF HTTP_USER_AGENT CONTAINS "Windows">
	<CFSET emaillistheight = "49">
<CFELSE>
	<CFSET emaillistheight = "44">
</CFIF>

<cfset email_to_string = "">
<cfset email_to_id_string = "">
<cfset email_coded_id_string = "">

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
		<cfset cc_emails = "">
		<cfset bcc_emails = "">
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
		       CC_EMAILS,
		       BCC_EMAILS,
		       HTML_COPY,
		       text_copy
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
		<cfset text_copy = getMessage.text_copy>
	</cfif>

	<cfcatch>
		<cfinclude template="cfcatch.cfm">
	</cfcatch>
</cftry>

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
		<CFINVOKE component="#application.CRS_CFC_Path#GetForm" method="GetTopicChoices" returnvariable="TopicChoices">
			<cfinvokeargument name="form_id" value="#topic_form_id#">
		</CFINVOKE>
		<CFCATCH type="any">
			<CF_ERROR error="Cannot get Newsletter Form Choices.">			
		</CFCATCH>			
	</CFTRY>
<CFELSE>
	<CF_ERROR error="There are no topics.">		
</CFIF>

<CFIF message_id IS NOT "">
	<cftry>
		<CFSTOREDPROC datasource="#dsn#" procedure="p_get_nltr_selected_topics" returncode="YES">
			<CFPROCRESULT NAME="getSelectedTopics" RESULTSET="1">
			<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#organization_id#" DBVARNAME="@organization_id">
			<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#message_id#" DBVARNAME="@message_id">
		</CFSTOREDPROC>
	
		<cfcatch>
			<cfinclude template="cfcatch.cfm">
		</cfcatch>
	</cftry>
	
	<cfset email_to_id_string = getSelectedTopics.topic_choice_id_str>
	
</CFIF>

<CFIF email_to_id_string IS NOT "">
	<CFSET cur_id = "">
	<CFSET cur_desc = "">
	<CFLOOP QUERY="TopicChoices">
		<CFSET cur_id = #form_question_choice_id#>
		<CFSET cur_desc = #choice_short_desc#>
		<CFIF ListFind(email_to_id_string,cur_id,",") GT 0>
			<CFSET email_to_string = email_to_string & "#cur_desc#; ">
			<CFSET email_coded_id_string = email_coded_id_string & "~#cur_id#|">
		</CFIF>
	</CFLOOP>
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
	<link rel="stylesheet" type="text/css" href="assets/stylesheets/_mailto.css" media="print,screen">
	<CFIF http_user_agent CONTAINS "Firefox">
	<link rel="stylesheet" type="text/css" href="assets/stylesheets/_mailto_firefox.css" media="print,screen">
	</CFIF>
	<script type="text/javascript" src="assets/js/hide.js"></script>
	<script type="text/javascript" src="assets/js/scroll.js"></script>
	<!-- tinyMCE -->
	<script language="javascript" type="text/javascript" src="assets/jscripts/tiny_mce/tiny_mce.js"></script>
	<script language="javascript" type="text/javascript">
	tinyMCE.init({
		mode : "textareas",
		editor_selector : "mceEditor",
		theme : "advanced",
		plugins : "preview",
		theme_advanced_buttons1 : ",fontselect,fontsizeselect,bold,italic,underline,separator,strikethrough,justifyleft,justifycenter,justifyright,justifyfull,bullist,numlist,|,outdent,indent,|,preview,|,forecolor,backcolor,|,undo,redo,link,unlink",
		theme_advanced_buttons2 : "",
		theme_advanced_buttons3 : "",
		theme_advanced_toolbar_location : "top",
		theme_advanced_toolbar_align : "left",
		theme_advanced_path_location : "bottom",
		extended_valid_elements : "a[name|href|target|title|onclick],img[class|src|border=0|alt|title|hspace|vspace|width|height|align|onmouseover|onmouseout|name],hr[class|width|size|noshade],font[face|size|color|style],span[class|align|style]"
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

<script type="text/javascript">
function populateaddremove(item){
var intext = item.options[item.selectedIndex].value
var clipplace = intext.indexOf("~")
var stringone = intext.slice(0,clipplace)
var stringtwo = intext.slice(clipplace)
var oldtext = item.form.emailto.value
var oldid = item.form.topic_choice_id_str.value
if (oldtext.indexOf(stringone)!=-1) {
		item.form.emailto.value= oldtext.replace(stringone,'');
		item.form.topic_choice_id_str.value= oldid.replace(stringtwo,'');
	}
	else {
		item.form.emailto.value= item.form.emailto.value +
		stringone;
		item.form.topic_choice_id_str.value= item.form.topic_choice_id_str.value +
		stringtwo;
	}
}
</script>

<script type="text/javascript">
function populateaddremovelink(topic){
var intext = topic
var clipplace = intext.indexOf("~")
var stringone = intext.slice(0,clipplace)
var stringtwo = intext.slice(clipplace)
var oldtext = document.forms[0].emailto.value
var oldid = document.forms[0].topic_choice_id_str.value
if (oldtext.indexOf(stringone)!=-1) {
		document.forms[0].emailto.value= oldtext.replace(stringone,'');
		document.forms[0].topic_choice_id_str.value= oldid.replace(stringtwo,'');
	}
	else {
		document.forms[0].emailto.value= document.forms[0].emailto.value +
		stringone;
		document.forms[0].topic_choice_id_str.value= document.forms[0].topic_choice_id_str.value +
		stringtwo;
	}
}
</script>


<SCRIPT LANGUAGE="JavaScript">

function expandTextArea(textarealabel, e){

if ((textarealabel.textLength % 45 == 0) && (textarealabel.textLength > 1 ))
if (e.which == 8)
textarealabel.rows = textarealabel.rows-1;
else
textarealabel.rows = textarealabel.rows+1;
}
</SCRIPT>


<script language="javascript">
  function toggleDiv(divid){
    if(document.getElementById(divid).style.display == 'none'){
      document.getElementById(divid).style.display = 'block';
    }else{
      document.getElementById(divid).style.display = 'none';
    }
  }
</script>

<script language="javascript">
  function toggleDiv2(divid){
  var splitplace = divid.indexOf("|")
  var div1 =  divid.slice(0,splitplace)
  var splitplaceplus = splitplace + 1
  var div2 = divid.slice(splitplaceplus)
    if(document.getElementById(div1).style.display == 'none'){
      document.getElementById(div1).style.display = 'block';
      document.getElementById(div2).style.display = 'none';
    }else{
      document.getElementById(div1).style.display = 'none';
      document.getElementById(div2).style.display = 'block';
    }
  }
</script>


</head>

<body id="pageBody" topmargin="0" leftmargin="0" rightmargin="0" marginheight="0" marginwidth="0" bgcolor="#FFFFFF" onLoad="prepLyr(); vis('hidden');">

<CFINCLUDE TEMPLATE="assets/js/tooltip.js">

<!--- Header --->
<CFINCLUDE TEMPLATE="header_nltr.cfm">
<!---
<table border="0" cellspacing="0" cellpadding="2" width="100%" bgcolor="#6661A7">
	<tr>
		<td width="50%" align="left" class="whitebold12" style="padding-left: 15px; height: 20px;">Newsletter Management - New Message</td>
		<td width="50%" align="right" class="whitebold12" style="padding-right: 10px; height: 20px;"><cfoutput>#organization_desc#</cfoutput></td>
	</tr>
</table>
--->
<!--- BODY --->

<table border="0" cellspacing="0" cellpadding="2" width="100%">
	<tr>
		<td style="padding-left: 15px; padding-top: 10px;" valign="top" width="150">
		
		<table cellpadding="3" border="0" cellspacing="0" width="148">
			<CFOUTPUT>
			<tr>
				<td class="emailnavtopleftact"><img src="assets/icons/newmes.gif" alt="" width="21" height="17" border="0"></td>
				<td class="emailnavtoprightact">New</td>
			</tr>
			<tr>
				<td class="emailnavbotleft"><img src="assets/icons/draft2.gif" alt="" width="21" height="17" border="0"></td>
				<td class="emailnavbotright" onclick="location.href='nltr_view_drafts.cfm?s=#securestring#'">Drafts (13)</td>
			</tr>
			<tr>
				<td class="emailnavbotleft"><img src="assets/icons/sched2.gif" alt="" width="21" height="17" border="0"></td>
				<td class="emailnavbotright">Scheduled</td>
			</tr>
			<tr>
				<td class="emailnavbotleft"><img src="assets/icons/sent2.gif" alt="" width="21" height="17" border="0"></td>
				<td class="emailnavbotright" onclick="location.href='nltr_view_sent.cfm?s=#securestring#'">Sent (13)</td>
			</tr>
			<tr>
				<td height="3" colspan="2"><img src="assets/images/spcrimg.gif" alt="" width="1" height="3" border="0"></td>
			</tr>
			<tr>
				<td class="emailnavtopleftact"><img src="assets/icons/messages.gif" alt="" width="21" height="17" border="0"></td>
				<td class="emailnavtoprightact">Messages</td>
			</tr>
			<tr>
				<td class="emailnavbotleft"><img src="assets/icons/subs.gif" alt="" width="21" height="17" border="0"></td>
				<td class="emailnavbotright" onclick="location.href='nltr_recipients.cfm?s=#securestring#'">Subscribers</td>
			</tr>
			<tr>
				<td class="emailnavbotleft"><img src="assets/icons/report.gif" alt="" width="21" height="17" border="0"></td>
				<td class="emailnavbotright">Reports</td>
			</tr>
			</CFOUTPUT>
		</table>
		
		</td>
		<td style="padding-top: 10px;padding-right: 10px;" valign="top">
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<td class="controlbar">
				<table border="0" cellspacing="0" cellpadding="0" width="100%">
					<CFOUTPUT>
					<form method="post" action="nltr_save_message_action.cfm?s=#securestring#">
					<tr>
						<td width="402" align="left" valign="middle" style="background-image: url(assets/images/emailbuttons.jpg);background-repeat: no-repeat;height:28px;">
						<table border="0" cellspacing="0" cellpadding="0" width="100%">
							<tr>
								<td width="99" align="left" valign="middle"><input type="submit" name="submit" value="Send" class="emailsendbut"></td>
								<td width="113" align="left" valign="middle"><input type="submit" name="submit" value="Save Draft" class="emaildraftsavebut"></td>
								<td width="118" align="left" valign="middle"><input type="submit" name="submit" value="Spell Check" class="emailspellbut"></td>
								<td width="72" align="left" valign="middle"><input type="reset" name="submit" value="Preview" class="emailprevbut" onclick="prevmessage()"></td>
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
				<td class="emailpropbar" valign="top">
				<div id="top" style="display:block;padding:2px;margin:2px;width:100%;">
				<table border="0" cellspacing="0" cellpadding="0" width="100%">
					<tr>
						<td colspan="2"><img src="assets/images/spcrimg.gif" alt="" width="1" height="1" border="0"></td>
					</tr>
					<tr>
						<td class="emailproplabel" width="100"><img src="assets/images/spcrimg.gif" alt="" width="1" height="5" border="0"></td>
						<td class="emailpropitem" align="left" width="90%" style="padding-top:4px;padding-left:4px;padding-bottom:4px;"><a href="javascript:;" onmousedown="toggleDiv2('mydiv|mydiv1'); toggleBox('demodiv',0); vis('hidden');"><img src="assets/images/but_tofrom.gif" alt="" width="72" height="17" border="0"></a></td>
					</tr>
				</table>
				</div>
				<CFOUTPUT>
				<div id="mydiv" style="display:none;padding:0px;margin:2px;width:100%;">
				<table border="0" cellspacing="2" cellpadding="2" width="100%">
					<tr>
						<td class="emailproplabel" width="150">From Email:</td>
						<td class="emailpropitem" align="left" width="90%"><input type="text" name="from_email_address" size="40" maxlength="100" class="emailpropfield" value="#from_email_address#"></td>
					</tr>
					<tr>
						<td class="emailproplabel">From Name:</td>
						<td class="emailpropitem"><input type="text" name="from_email_alias" size="40" maxlength="100" class="emailpropfield" value="#from_email_alias#"></td>
					</tr>
					<tr>
						<td class="emailproplabel">Reply Email:</td>
						<td class="emailpropitem"><input type="text" name="replyto_email_address" size="40" maxlength="100" class="emailpropfield" value="#replyto_email_address#"></td>
					</tr>
					<tr>
						<td class="emailproplabel">Reply Name:</td>
						<td class="emailpropitem"><input type="text" name="replyto_email_alias" size="40" maxlength="100" class="emailpropfield" value="#replyto_email_alias#"></td>
					</tr>
					<tr>
						<td colspan="2"><img src="assets/images/spcrimg.gif" alt="" width="1" height="5" border="0"></td>
					</tr>
				</table>
				</div>
				</CFOUTPUT>
				<CFOUTPUT>
				<input type="hidden" name="message_id" value="#message_id#">
				<input type="hidden" name="topic_choice_id_str" value="#email_coded_id_string#">
				<div id="mydiv1" style="display:block;padding:0px;margin:2px;width:100%;">
				<table border="0" cellspacing="2" cellpadding="2" width="100%">
					<tr>
						<td class="emailtolabel" valign="top" width="150">
						<A HREF="javascript:void(0)" onClick="toggleBox('demodiv',1); vis('visible');"><img src="assets/icons/address_book.gif" alt="" width="21" height="16" border="0" style="vertical-align: bottom"></a> To:</td>
						<td class="emailpropitem" align="left" width="90%"><TEXTAREA ID="Text1" COLS="" ROWS="1" style="overflow: visible" ONKEYDOWN="expandTextArea(this, event);" class="emailtofield" name="emailto" ReadOnly="True" onClick="toggleBox('demodiv',1); vis('visible');">#email_to_string#</TEXTAREA></td>
					</tr>
					<tr>
						<td class="emailproplabel">Cc:</td>
						<td class="emailpropitem" align="left"><input type="text" name="cc_emails" size="40" maxlength="100" class="emailpropfield" value="#cc_emails#"></td>
					</tr>
					<tr>
						<td class="emailproplabel">Bcc:</td>
						<td class="emailpropitem" align="left"><input type="text" name="bcc_emails" size="40" maxlength="100" class="emailpropfield" value="#bcc_emails#"></td>
					</tr>
					<tr>
						<td class="emailproplabel">Subject:</td>
						<td class="emailpropitem" align="left"><input type="text" name="subject" size="40" maxlength="100" class="emailpropfield" value="#subject#"></td>
					</tr>
					<tr>
						<td colspan="2"><img src="assets/images/spcrimg.gif" alt="" width="1" height="5" border="0"></td>
					</tr>
				</table>
				</div>
				<div id="bottom" style="display:block;padding:0px;margin:2px;width:100%;">
				<table border="0" cellspacing="2" cellpadding="2" width="100%">
					<tr>
						<td class="emailpropitem" colspan="2" align="center"><div><textarea name="html_copy" cols="80" rows="30" class="mceEditor" style="width:100%;">#html_copy#</textarea></div></td>
					</tr>
					<tr>
						<td class="emailpropitem" colspan="2"><img src="assets/images/spcrimg.gif" alt="" width="1" height="15" border="0"></td>
					</tr>
				</table>
				<table border="0" cellspacing="2" cellpadding="2" width="100%">
					<tr>
						<td class="emailpropitem" colspan="2" align="center"><div><textarea name="text_copy" cols="80" rows="30" style="width:100%;">#text_copy#</textarea></div></td>
					</tr>
					<tr>
						<td class="emailpropitem" colspan="2"><img src="assets/images/spcrimg.gif" alt="" width="1" height="15" border="0"></td>
					</tr>
				</table>
				</div>
				</CFOUTPUT>
				</td>
				<!---
				<td width="155" valign="top" style="background-image: url(assets/images/listbarback.jpg);background-repeat: repeat-y;border-bottom: 1px Solid #A1A1A1;">
				<table cellpadding="0" cellspacing="0" border="0" width="100%">
					<tr>
						<td width="15" valign="top" align="right">
						<table cellpadding="0" cellspacing="0" border="0" width="100%">
							<tr>
								<td height="55" width="15"><img src="assets/images/spcrimg.gif" alt="" width="15" height="55" border="0"></td>
							</tr>
						</table>
						<div id="arrow" style="display:block;padding:0px;margin:0px;width:100%;">
						<table cellpadding="0" cellspacing="0" border="0" width="100%">
							<tr>
								<td valign="top" height="19" align="right"><img src="assets/images/boxarrow.gif" alt="" width="10" height="19" border="0"></td>
							</tr>
						</table>
						</div>
						</td>
						<td valign="top" width="140">
						<CFOUTPUT>
						<select name="emaillists" MULITPLE size="#emaillistheight#" class="emaillistbox" onchange="populateaddremove(this)">
						<CFSET curlabel = "">
						<CFLOOP QUERY="TopicChoices">
						<CFSET curlabel = "#choice_short_desc#">
						<CFIF LEN(curlabel) GT 20>
							<CFSET curlabel = LEFT(curlabel,17) & "...">
						</CFIF>
						<option value="#choice_short_desc#; ~#form_question_choice_id#|">#curlabel#
						</CFLOOP>
						</CFOUTPUT>
						</select>
						</td>
					</tr>
				</table>
				</td>
				--->
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

<!--- to window hidden --->

<div ID="demodiv" class="demo">

<DIV ID="scrollclose"><A HREF="javascript:void(0)" onClick="toggleBox('demodiv',0); vis('hidden');"><img src="assets/images/but_scroll_close_sm.gif" alt="" width="51" height="11" border="0"></div>

<DIV ID="up"><A HREF="javascript:void(0)" onMouseOver="scrollayer('example',-10,100)"
	onMouseOut="stopScroll()"><img src="assets/images/but_scroll_up_sm.gif" alt="" width="11" height="11" border="0"></A></div>
    
    
<DIV ID="down"><A HREF="javascript:void(0)" onMouseOver="scrollayer('example',10,100)"
	onMouseOut="stopScroll()"><img src="assets/images/but_scroll_down_sm.gif" alt="" width="11" height="11" border="0"></A></div>

<DIV ID="example">
<table width="415" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td colspan="2" class="popformtitle">Topics</td>
	</tr>
	<CFOUTPUT QUERY="TopicChoices">
	<tr>
		<td class="popformbox"><input type="checkbox" value="" name="name" onclick="populateaddremovelink('#choice_short_desc#; ~#form_question_choice_id#|')"<CFIF ListFind(email_to_id_string,form_question_choice_id,",") GT 0> CHECKED</CFIF>></td>
		<td class="popformlabel">#choice_short_desc#</td>
	</tr>
	</CFOUTPUT>
	<tr>
		<td colspan="2" class="popformtitle">Lists</td>
	</tr>
	<tr>
		<td class="popformbox"><input type="checkbox" value="This is the long description; ~33333|" name="name" onclick="populateaddremovelink('This is the long description; ~33333|')"></td>
		<td class="popformlabel">This is a list</td>
	</tr>
	<tr>
		<td class="popformbox"><input type="checkbox" value="This is the description; ~9999|" name="name" onclick="populateaddremovelink('This is the description; ~9999|')"></td>
		<td class="popformlabel">This is a list</td>
	</tr>
	<tr>
		<td class="popformbox"><input type="checkbox" value="999; ~aaa|" name="name" onclick="populateaddremovelink('999; ~aaa|')"></td>
		<td class="popformlabel">This is a list</td>
	</tr>
	<tr>
		<td class="popformbox"><input type="checkbox" value="999; ~aaa|" name="name" onclick="populateaddremovelink('999; ~aaa|')"></td>
		<td class="popformlabel">This is a list</td>
	</tr>
	<tr>
		<td colspan="2" class="popformtitle">Programs</td>
	</tr>
	<tr>
		<td class="popformbox"><input type="checkbox" value="999; ~aaa|" name="name" onclick="populateaddremovelink('999; ~aaa|')"></td>
		<td class="popformlabel">This is a list</td>
	</tr>
	<tr>
		<td class="popformbox"><input type="checkbox" value="999; ~aaa|" name="name" onclick="populateaddremovelink('999; ~aaa|')"></td>
		<td class="popformlabel">This is a list</td>
	</tr>
	<tr>
		<td class="popformbox"><input type="checkbox" value="999; ~aaa|" name="name" onclick="populateaddremovelink('999; ~aaa|')"></td>
		<td class="popformlabel">This is a list</td>
	</tr>
	<tr>
		<td class="popformbox"><input type="checkbox" value="999; ~aaa|" name="name" onclick="populateaddremovelink('999; ~aaa|')"></td>
		<td class="popformlabel">This is a list</td>
	</tr>
</table>
</div>
</div>
</form>
</body>
</html>
