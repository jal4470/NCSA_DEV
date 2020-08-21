<!------------------------------------->
<!---  Capturepoint.com          	--->
<!---  CRS Action Page		   		--->
<!------------------------------------->
<!---  Created:  10.24.2006 by		--->
<!---	         Pat Waters			--->
<!---  Last Modified: 10.26.2006	--->
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

<CFSET cur_status_id = 1>

<CFIF ISDEFINED("url.cur_status_id") AND url.cur_status_id IS NOT "">
	<CFSET cur_status_id = url.cur_status_id>
</CFIF>

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
	<script language="JavaScript" type="text/javascript" src="assets/js/jquery-1.3.2.min.js"></script>
	<script language="JavaScript" type="text/javascript">
		$(function(){
			$('#topicHeaderLink').click(function(){
				$('#topicHeaderLabel').hide();
				$('#topicHeaderEdit').show();
			});
			$('input[name=btnSaveTopic]').click(function(){
			
				//save topic question value
				$.ajax({
					data:{
						text:tinyMCE.activeEditor.getContent(),
						form_question_id:'<cfoutput>#topic_form_question_id#</cfoutput>'
					},
					dataType:'json',
					success:function(){
						$('#topicHeaderLabel').find('span:first').html(tinyMCE.activeEditor.getContent()).end().show();
						$('#topicHeaderEdit').hide();
						$('#topicSaveSuccess').css({padding:'',margin:''}).show();
						setTimeout("$('#topicSaveSuccess').animate({paddingTop:'0em',paddingBottom:'0em',height:'hide',opacity:'hide',marginBottom:'0em'}, 1000);",5000);
					},
					error:function(){
						$('#topicSaveError').css({padding:'',margin:''}).show();
						setTimeout("$('#topicSaveError').animate({paddingTop:'0em',paddingBottom:'0em',height:'hide',opacity:'hide',marginBottom:'0em'}, 1000);",5000);
					},
					type:'POST',
					url:'async_nltr_control_topics_save_question.cfm?s=<cfoutput>#jsstringformat(securestring)#</cfoutput>'
				});
			});
		});
	</script>
	
	<script type="text/javascript">
	function doConfirmation(form_question_choice_id){
		gostring = "<CFOUTPUT>nltr_control_topic_remove_action.cfm?s=#securestring#&nextpage=nltr_control_topics.cfm&form_question_choice_id=</CFOUTPUT>" + form_question_choice_id;
		
		var message = "Are you sure you want to enable/disable this topic?";
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
				
				<CFOUTPUT>
				<!--- B.Cooper - 2009-12-10 - why is this here? --->
				<!--- <form method="post" action="nltr_topic_choice_action.cfm?s=#securestring#">
				<input type="hidden" name="form_id" value="#topic_form_id#">
				<input type="hidden" name="question_id" value="#topic_question_id#">
				<input type="hidden" name="form_question_id" value="#topic_form_question_id#">
				<input type="hidden" name="edit_fqc_id" value="#fqc_id#"> --->
				
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
					extended_valid_elements : "a[name|href|target|title|onclick],img[class|src|border=0|alt|title|hspace|vspace|width|height|align|onmouseover|onmouseout|name],hr[class|width|size|noshade],font[face|size|color|style],span[class|align|style]",
					forced_root_block : '',
					force_br_newlines : true,
					remove_redundant_brs : true
				});
				</script>
				<div id="topicSaveSuccess" class="success" style="display:none;">
					Topic Instructions Saved Successfully
				</div>
				<div id="topicSaveError" class="error" style="display:none;">
					Topic Instructions Could Not Be Saved
				</div>
				<div style="margin-left:20px; margin-bottom:25px;">
					<div class="formitemlabelwhfull">Topic Header:</div>
					<div id="topicHeaderLabel"><span>#topic_question#</span><span style="padding-left:10px; font-size:.9em;"><a id="topicHeaderLink" href="javascript:void(0);">edit</a></span></div>
					<div id="topicHeaderEdit" style="display:none;">
						<textarea name="topic_header" class="mceEditor" style="width:700px;height:150px;">#topic_question#</textarea>
						<input width="72" height="17" type="image" src="assets/images/but_email_save.gif" value="Save" name="btnSaveTopic"/>
					</div>
				</div>
				
				
				<table border="0" cellspacing="0" cellpadding="0" width="100%">
					<tr>
						<td width="82" style="padding-left:5px;"><a href="nltr_control_topics_addedit.cfm?s=#securestring#"><img src="assets/images/but_email_add.gif" alt="" width="72" height="17" border="0"></a></td>
						<td width="82" style="padding-left:5px;"><a href="nltr_control_topics_sort.cfm?s=#securestring#"><img src="assets/images/but_email_reorder.gif" alt="" width="72" height="17" border="0"></a></td>
						<td><CFIF cur_status_id EQ 1><a href="nltr_control_topics.cfm?s=#securestring#&cur_status_id=0"><img src="assets/images/but_email_topic_inact.gif" alt="" width="90" height="17" border="0"></a><CFELSE>
						<a href="nltr_control_topics.cfm?s=#securestring#&cur_status_id=1"><img src="assets/images/but_email_topic_act.gif" alt="" width="90" height="17" border="0"></a></CFIF></td>
					</tr>
					<tr>
						<td colspan="3" height="2"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="2"></td>
					</tr>
				</table>
				</CFOUTPUT>
				<div style="width:auto;height:5px;"> </div>
				<table border="0" cellspacing="0" cellpadding="2" width="100%">
					<tr>
						<td class="rowhead">Topic</td>
						<td class="rowhead" width="100">Status</td>
<!---						<td class="rowhead" width="100">Type</td>--->
						<td class="rowhead" width="110">Created</td>
						<td class="rowhead" width="110">Owner</td>
						<td class="rowhead" width="90"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="2"></td>
					</tr>
					<CFIF TopicChoices.recordcount GT 0>
					<CFOUTPUT QUERY="Topicchoices">
					<CFIF status_id EQ #cur_status_id#>
					<tr onmouseout="scbg(this, 0);" onmouseover="scbg(this, 1);">
						<td class="blankrowitem" onclick="location.href='nltr_control_topics_addedit.cfm?s=#securestring#&form_question_choice_id=#form_question_choice_id#'">#choice_short_desc#</td>
						<td class="blankrowitem" onclick="location.href='nltr_control_topics_addedit.cfm?s=#securestring#&form_question_choice_id=#form_question_choice_id#'"><cfif status_id EQ 1>Active<cfelse>Inactive</cfif></td>
<!---						<td class="blankrowitem" onclick="location.href='nltr_control_topics_addedit.cfm?s=#securestring#&form_question_choice_id=#form_question_choice_id#'"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="2"></td>--->
						<td class="blankrowitem" onclick="location.href='nltr_control_topics_addedit.cfm?s=#securestring#&form_question_choice_id=#form_question_choice_id#'">#DateFormat(choice_datecreated,'mm/dd/yyyy')#</td>
						<cfif createdby_fname EQ "" OR createdby_lname EQ "">
						<td class="blankrowitem" onclick="location.href='nltr_control_topics_addedit.cfm?s=#securestring#&form_question_choice_id=#form_question_choice_id#'">&nbsp;</td>
						<cfelse>
						<td class="blankrowitem" onclick="location.href='nltr_control_topics_addedit.cfm?s=#securestring#&form_question_choice_id=#form_question_choice_id#'">#createdby_lname#, #createdby_fname#</td>
						</cfif>
						<td class="blankrowitem" align="center" onclick="doConfirmation(#form_question_choice_id#)"><a href="javascript:void(0)" class="formlink"><cfif status_id EQ 1>Disable<cfelse>Enable</cfif></a></td>
					</tr>
					</CFIF>
					</CFOUTPUT>
					<CFELSE>
					<tr>
						<td class="blankrowitem" colspan="6">No Choices Set</td>
					</tr>
					</CFIF>
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
