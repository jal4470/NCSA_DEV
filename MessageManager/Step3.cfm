<!--- 
File: nltr_new_messages.cfm 
Purpose: Creates New Message
Author: Joe Lechuga jlechuga@capturepoint.

Changes:
Joe Lechuga 3/11/2010 Initial Revision

 --->

 
 <!--- validate login --->
 <cfmodule template="../_checkLogin.cfm">
 
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
<cfif isdefined("url.allowedits") and not url.allowedits>
	<cfset stepnum=2>
<cfelse>
	<cfset stepnum=3>
</cfif>
<cfquery name="getmessageRecipients" datasource="#application.dsn#">

	select FROM_EMAIL_ADDRESS,FROM_EMAIL_ALIAS,MESSAGE_DESC,  	M.MESSAGE_ID,count(MESSAGE_RECIPIENT_ID) AS RECIPIENT_COUNT ,REPLYTO_EMAIL_ADDRESS , 	REPLYTO_EMAIL_ALIAS,REPORT_ID,cc_emails,bcc_emails,subject from tbl_message_recipient mr inner join tbl_message m on mr.message_id = m.message_id where m.message_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#message_id#">
group by FROM_EMAIL_ADDRESS,FROM_EMAIL_ALIAS,MESSAGE_DESC,  	M.MESSAGE_ID ,REPLYTO_EMAIL_ADDRESS , 	REPLYTO_EMAIL_ALIAS,REPORT_ID,cc_emails,bcc_emails,subject
</cfquery>

<cfif not getmessageRecipients.recordcount>
	<cfmodule template="error.cfm" error="There are no recipients for this message. Some filters may not apply to the current list of recipients."  linkurl1="Step#(stepnum-1)#.cfm?report_id=#report_id#&message_id=#message_id#">
</cfif>

 <!---<cfdump var="#getmessageRecipients#"><cfabort> --->
<CFIF HTTP_USER_AGENT CONTAINS "Windows">
	<CFSET emaillistheight = "49">
<CFELSE>
	<CFSET emaillistheight = "44">
</CFIF>

<cfset email_to_string = "">
<cfquery name="getRecipients" datasource="#application.dsn#">
	select (select email from tbl_contact where contact_id = xmc.contact_id) + ';' as email from xref_message_contact xmc where message_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#iif(len(trim(message_id)),de(message_id),de(0))#">
</cfquery>

<cfloop query="getRecipients">
<CFSET email_to_string = email_to_string & email>
</cfloop>



<!--- <cfset email_topic_id_string = "">
<cfset email_season_id_string = "">
<cfset email_program_id_string = "">
<cfset email_grade_id_string = "">
<cfset email_coded_id_string = ""> --->
<!--- 		<cfset subject = "">
		<cfset cc_emails = "">
		<cfset bcc_emails = "">
		<cfset html_copy = ""> --->
<!---------------->
<!--- Get data --->
<!---------------->
<!--- <cftry> --->
	<!--- New message --->
	<cfif not len(trim(message_id))>
		<cfquery name="getDefaults" datasource="#application.dsn#">
		select _name, _value from tbl_global_vars where
		_name in ('from_email_address','from_email_alias','replyTo_Email_address','replyTo_Email_alias')
		</cfquery>
		<cfset message_desc = "">
		<cfloop query="getDefaults">
			<cfset "#_name#" = "#_value#">
		</cfloop>
		<cfset track_opens = 0>
		<cfset exclude_waitlisted_flag = "">
		<cfset subject = "">
		<cfset cc_emails = "">
		<cfset bcc_emails = "">
		<cfset html_copy = "">
	<!--- <cfdump var='#variables#'><cfabort> --->
	<!--- Edit message --->
	<cfelse>
		<cfquery name="getMessage" datasource="#application.dsn#">
		SELECT MESSAGE_DESC,
		       FROM_EMAIL_ADDRESS,
		       FROM_EMAIL_ALIAS,
		       REPLYTO_EMAIL_ADDRESS,
		       REPLYTO_EMAIL_ALIAS,
		       SUBJECT,
		       CC_EMAILS,
		       BCC_EMAILS,
		       HTML_COPY,
		       TRACK_OPENS_FLAG,
		       EXCLUDE_WAITLISTED_FLAG
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
		<cfset track_opens = getMessage.track_opens_flag>
		<cfset exclude_waitlisted_flag = getMessage.exclude_waitlisted_flag>
	</cfif>

<!--- 	<cfcatch>
		<cfdump var="#cfcatch#">
	</cfcatch>
</cftry>
 --->




<CFTRY>
	<CFINVOKE component="#application.mm_api_path#GetMessage" method="GetPerFields" returnvariable="perfields">
		<cfinvokeargument name="message_id" value="#message_id#">
	</CFINVOKE>
	<CFCATCH type="any">
		<cfdump var="#cfcatch#">
	</CFCATCH>
</CFTRY>

<!--- prepopulate jscript fields for display --->
<CFSET activitylist = "">
<CFSET seasonlist = "">
<CFSET curactivity = "">
<CFSET curseason = "">
<CFSET curprogram = "">
<!--- <CFOUTPUT QUERY="activitytoprogram">
	<CFSET curprogram = program_id>
	<CFIF listFind(email_program_id_string,curprogram,",") GT 0>
		<CFSET activitylist = activitylist & "#activity_id#,">
		<CFSET seasonlist = seasonlist & "#season_id#,">
	</CFIF>
</CFOUTPUT> --->
<!--- end prepopulate jscript fields for display --->


<!----------------->
<!--- Page body --->
<!----------------->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
	<link  href="../ReportBuilder/_rptBldr_style.css" type="text/css" media="print,screen" rel="stylesheet" >
	<link rel="stylesheet" type="text/css" href="style.css" media="print,screen">
	<link  href="_newsletter_style.css" type="text/css" media="print,screen" rel="stylesheet" >
	<link  href="_tooltip_style.css" type="text/css" media="print,screen" rel="stylesheet" >
	<link rel="stylesheet" type="text/css" href="assets/stylesheets/_mailto.css" media="print,screen">
	<CFIF http_user_agent CONTAINS "Firefox">
	<link rel="stylesheet" type="text/css" href="assets/stylesheets/_mailto_firefox.css" media="print,screen">
	</CFIF>
	<script type="text/javascript" src="assets/js/hide.js"></script>
	<!--- J Query added 2/18/09 --->
	<script type="text/javascript" src="assets/js/jquery-1.2.6.min.js"></script>
	<script type="text/javascript" language="JavaScript">
		$(document).ready(function(){

			//set up click event for select all
			$("input[name=seasonAll]").click(function(){

				if($(this).is(":checked"))
				{
					$("input[class="+$(this).attr("id")+"]").attr("checked",true);
				}
				else
				{
					$("input[class="+$(this).attr("id")+"]").attr("checked",false);
				}

				onCheck();
				checkBold(this);
			});

			//set up click event for programs and topics
			$('input[name=topic],input[name=program]').click(checkProgramClicked);


			//run onCheck method on load to set initial values
			onCheck();
			checkBold();
		});

		//callback
		function checkProgramClicked()
		{
			onCheck();
			checkBold(this);
			checkSelectAll(this);
		}

		//perform functions related to checking a program checkbox
		//set topic and program hidden fields
		//set to: address field
		function onCheck()
		{
			//get all checked topics
			var topicList='';
			var topicStr='';
			$('input[name=topic]:checked').each(function(){
				topicList=topicList+$(this).val()+',';
				topicStr=topicStr+$(this).parent().next().text()+'; ';
			});

			//set topic hidden field to list
			$('input[name=topic_choice_id_str]').val(topicList);

			//get all checked programs
			var programList='';
			var programStr='';
			$('input[name=program]:checked').each(function(){
				programList=programList+$(this).val()+',';
				programStr=programStr+$(this).parent().parent().prev().val()+$(this).parent().find('.programdesc').text()+'; ';
			});

			//set program hidden field to list
			$('input[name=program_id_str]').val(programList);

			//set to: field
			//$('textarea[name=emailto]').html(topicStr+programStr);
			//document.forms[0].emailto.value=topicStr+programStr;

			//retest for bold highlighting
			//checkBold();
		}

		//runs through each activity and season and sets to bold if child boxes are checked
		function checkBold(e)
		{
			var actGroup=$('.popformlabelgroupa');
			var seaGroup=$('.popformlabelgroupb');
			if(e)
			{
				if( $(e).is('input[name=program]') || $(e).is('input[name=seasonAll]') )
				{
					actGroup=$(e).parents().filter('.popformlabelgroupa');
					seaGroup=$(e).parents().filter('.popformlabelgroupb');
				}
			}
			//check activities
			$(actGroup).each(function(){
				if($(this).find('input[name=program]:checked').length > 0)
					$(this).addClass('popformlabelbold');
				else
					$(this).removeClass('popformlabelbold');
			});

			//check seasons
			$(seaGroup).each(function(){
				if($(this).find('input[name=program]:checked').length > 0)
					$(this).addClass('popformlabelbold');
				else
					$(this).removeClass('popformlabelbold');
			});
		}

		//check or uncheck 'select all' based on selections of children
		function checkSelectAll(e)
		{
			var checked=true;
			var seasonbox=$(e).parents().filter('.popformlabelgroupb').find('input[name=seasonAll]');
			$(e).parent().parent().find('input[name=program]').each(function(){
				if(!$(this).is(':checked'))
					checked=false;
			});

			if(checked)
				$(seasonbox).attr('checked',true);
			else
				$(seasonbox).attr('checked',false);

		}
	</script>

	<!--- <script type="text/javascript" src="assets/js/scroll.js"></script> --->
	<!-- tinyMCE -->
	<script language="javascript" type="text/javascript" src="assets/jscripts/tiny_mce/tiny_mce.js"></script>
	<script language="javascript" type="text/javascript">
	tinyMCE.init({
		mode : "textareas",
		editor_selector : "mceEditor",
		theme : "advanced",
		plugins : "preview, paste, advhr,spellchecker",
		theme_advanced_buttons1 : ",fontselect,fontsizeselect,bold,italic,underline,separator,strikethrough,justifyleft,justifycenter,justifyright,justifyfull,bullist,numlist,|,outdent,indent,|,preview,|,forecolor,backcolor,|,undo,redo,link,unlink",
		theme_advanced_buttons2 : "advhr,|,sup,sub,|,charmap,|,pastetext, pasteword,|,spellchecker",
		theme_advanced_buttons3 : "",
		theme_advanced_toolbar_location : "top",
		theme_advanced_toolbar_align : "left",
		theme_advanced_path_location : "bottom",
		extended_valid_elements : "a[name|href|target|title|onclick],img[class|src|border=0|alt|title|hspace|vspace|width|height|align|onmouseover|onmouseout|name],hr[class|width|size|noshade],font[face|size|color|style],span[class|align|style]",
		relative_urls : false
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


<script type="text/javascript">
function populateper(item){
item.form.displayper.value= item.options[item.selectedIndex].value;
}
</script>

<script language="JavaScript1.3" type="text/javascript">
function swap(listIdPrefix,imageid) {
    currentList = document.getElementById(listIdPrefix);
    currentImage = document.getElementById(imageid);
    if (currentList.style.display == "block") {
        currentList.style.display = "none";
        currentImage.src = "assets/images/list_plus.gif";
    } else {
        currentList.style.display = "block";
        currentImage.src = "assets/images/list_minus.gif";
    }

}
</script>

<script language="JavaScript1.3" type="text/javascript">
function choicecnt(objRef,activity,season) {
    currentActivity = document.getElementById(activity);
    currentSeason = document.getElementById(season);
    if (objRef.checked) {
	currentActivity.value++;
	currentSeason.value++;
	} else {
	currentActivity.value--;
	currentSeason.value--;
	}

}
</script>

<script language="JavaScript1.3" type="text/javascript">
function actcolor(activitycnt,activitytext) {
    currentCnt = document.getElementById(activitycnt);
    currentText = document.getElementById(activitytext);
    if (currentCnt.value!=0) {
	currentText.style.color = "#000000";
	} else {
	currentText.style.color = "#7D7D7D";
	}

}
</script>
<script language="JavaScript1.3" type="text/javascript">
function seacolor(seasoncnt,seasontext) {
    currentCnt = document.getElementById(seasoncnt);
    currentText = document.getElementById(seasontext);
    if (currentCnt.value!=0) {
	currentText.style.color = "#000000";
	} else {
	currentText.style.color = "#7D7D7D";
	}

}
</script>



</head>

<body topmargin="0" leftmargin="0" rightmargin="0" marginheight="0" marginwidth="0" bgcolor="#FFFFFF">
<cfhtmlhead text="<title>Message Manager Step 3</title>">
<CFINCLUDE TEMPLATE="assets/js/tooltip.js">

<!--- Header --->
<CFINCLUDE TEMPLATE="header_nltr.cfm">

<!--- BODY --->

<table border="0" cellspacing="0" cellpadding="2" width="100%">
	<form method="post" action="Step3_action.cfm?report_id=<cfoutput>#report_id#</cfoutput>">

<cfinclude template="tpl_rptBldr_head.cfm">
			<tr>
				<td class="emailpropbar" valign="top">

				<CFOUTPUT>
				<input type="hidden" name="message_id" value="#getmessageRecipients.message_id#">
				<input type="hidden" name="cc_emails" value="#getmessageRecipients.cc_emails#">
				<input type="hidden" name="bcc_emails" value="#getmessageRecipients.bcc_emails#">
				<input type="hidden" name="replyto_email_address" value="#getmessageRecipients.replyto_email_address#">
				<input type="hidden" name="replyto_email_alias" value="#getmessageRecipients.replyto_email_alias#">
				<div id="mydiv1" style="display:block;padding:0px;margin:2px;width:100%;">
				<table border="0" cellspacing="2" cellpadding="2" width="100%">
					<tr>
						<td colspan="2"><img src="assets/images/spcrimg.gif" alt="" width="1" height="1" border="0"></td>
					</tr>
					<tr>
						<td class="emailtolabel" valign="top" width="150">## of Recipients:</td>
						<td class="emailpropitem" align="left" width="90%">
						#getmessageRecipients.RECIPIENT_COUNT#
		
</td>
					</tr>
					<tr>
						<td class="emailproplabel">From Email:</td>
						<td class="emailpropitem"><input type="hidden" name="from_email_address" size="40" maxlength="100" class="emailpropfield" value="#getmessageRecipients.from_email_address#">#getmessageRecipients.from_email_address#</td>
					</tr>
					<tr>
						<td class="emailproplabel">From Name:</td>
						<td class="emailpropitem"><input type="hidden" name="from_email_alias" size="40" maxlength="100" class="emailpropfield" value="#getmessageRecipients.from_email_alias#">#getmessageRecipients.from_email_alias#</td>
					</tr>
					<tr>
						<td class="emailproplabel">Subject:</td>
						<td class="emailpropitem" align="left"><input type="hidden" name="subject" size="40" maxlength="100" class="emailpropfield" value="#getmessageRecipients.subject#">#getmessageRecipients.subject#</td>
					</tr>

					<tr>
						<td colspan="2">Enter the message body for your message.</td>
					</tr>

					<tr>
						<td colspan="2"><img src="assets/images/spcrimg.gif" alt="" width="1" height="1" border="0"></td>
					</tr>
				</table>
				</div>

				<!--- PERSONALIZATION BOX --->

				<div id="mydiv3" style="display:block;padding:0px;margin:2px;width:100%;">
				<table border="0" cellspacing="2" cellpadding="2" width="100%">
					<tr>
						<!---
						<td class="emailpropitem" align="right" valign="top" width="78"><!--- <a href="javascript:;" onmousedown="toggleDiv2('mydiv2|mydiv3'); toggleBox('demodiv',0); vis('hidden');"><img src="assets/images/but_email_p_act.gif" alt="" width="18" height="17" border="0"></a> --->
						<img src="assets/images/spcrimg.gif" alt="" width="18" height="17" border="0"></td>
						--->
						<td class="email_instructions" align="left" valign="top">
						<table border="0" cellspacing="0" cellpadding="0" width="100%">
							<tr>
								<td><b>Personalization:</b>  To personalize your message, please select the field you would like to add to your message from the dropdown below, text will appear in the field to the right, copy that text entirely and paste it in your message where you would like that value to appear. <i>Please be sure to not include the following characters in your message: </i><b><  > { } & </b><i>as these characters are reserved for system use.</i>
								</td>
							</tr>
							<tr>
								<td>
								<table border="0" cellspacing="2" cellpadding="2" width="100%">
									<tr>
										<td align="left" width="100">
										<select name="personfields" onchange="populateper(this)">
										<option value="">-- Select --</option>
										<CFLOOP QUERY="perfields">
										<option value="#code#">#display_name#</option>
										</CFLOOP>
										</select>
										</td>
										<td align="left"><input type="text" name="displayper" value="" class="perfield"></td>
									</tr>
								</table>
								</td>
							</tr>
						</table>
						</td>
					</tr>
				</table>
				</div>

				<!--- END PERSONALIZATION BOX --->


				<div id="bottom" style="display:block;padding:0px;margin:2px;width:100%;">
				<table border="0" cellspacing="2" cellpadding="2" width="100%">
					<tr>
						<td class="emailpropitem" colspan="2" align="center"><div><textarea name="html_copy" id="mceEditorArea" cols="80" rows="30" class="mceEditor" style="width:100%;">#html_copy#</textarea></div></td>
					</tr>
					<tr>
						<td class="emailpropitem" colspan="2"><img src="assets/images/spcrimg.gif" alt="" width="1" height="15" border="0"></td>
					</tr>
				</table>
				</div>
				</CFOUTPUT>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>

<!--- END BODY --->


<!--- to window hidden --->

<!--- <div ID="demodiv" class="demo">

<DIV ID="scrollclose"><A HREF="javascript:void(0)" onClick="toggleBox('demodiv',0); vis('hidden');"><img src="assets/images/but_scroll_close_sm.gif" alt="" width="51" height="11" border="0"></a></div>

<div style="padding-left:15px;">
<table width="415" cellpadding="0" cellspacing="0" border="0">
	<!------------------>
	<!--- Recipients --->
	<!------------------>
	<!--- Spacer --->
	<tr>
		<td colspan="3" height="10" width="1"><img src="assets/images/spcrimg.gif" alt="" height="10" width="1" border="0"></td>
	</tr>

	<!--- Recipient Instructions --->
	<tr>
		<td colspan="6"><b>Recipients.</b> Select from the items below to build a recipient list. The message will be sent to the account primary contact of the individual that registered for the selected items.<br><br></td>
	</tr>


	<cfinclude template="getRefs.cfm">



</table>

</div>
<div style="height:20px;width:auto;"> </div>
</div>
 ---><cfinclude template="tpl_rptBldr_foot.cfm">
</form>
</body>
</html>
