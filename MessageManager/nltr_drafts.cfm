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

<CFIF ISDEFINED("url.view")>
	<CFSET view = "#url.view#">
<CFELSE>
	<CFSET view = "draft">
</CFIF>
<!---------------->
<!--- Get data --->
<!---------------->

<CFIF view IS "draft">
<CFTRY>
	<CFINVOKE component="#application.CRS_CFC_Path#getMessage" method="GetDraftMessages" returnvariable="getdrafts">
		<cfinvokeargument name="organization_id" value="#organization_id#">
	</CFINVOKE>
	<CFCATCH type="any">
		<CF_ERROR error="Cannot get Organization Drafts.">			
	</CFCATCH>			
</CFTRY>
<CFELSE>
<CFTRY>
	<CFINVOKE component="#application.CRS_CFC_Path#getMessage" method="GetSentMessages" returnvariable="getsent">
		<cfinvokeargument name="organization_id" value="#organization_id#">
	</CFINVOKE>
	<CFCATCH type="any">
		<CF_ERROR error="Cannot get Organization Sent.">			
	</CFCATCH>			
</CFTRY>
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
<script type="text/javascript">
function doConfirmation(message_id){
	gostring = "<CFOUTPUT>nltr_cancel_action.cfm?s=#securestring#&nextpage=nltr_drafts.cfm&message_id=</CFOUTPUT>" + message_id;
	
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

<table border="0" cellspacing="0" cellpadding="2" width="100%" bgcolor="#6661A7">
	<tr>
		<td width="50%" align="left" class="whitebold12" style="padding-left: 15px; height: 20px;">Message Management - Messages</td>
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
			<!--- SIGN UP FORM PROPERTIES --->
			<tr>
				<td colspan="6">
				<table border="0" cellspacing="0" cellpadding="1" width="100%">
					<tr>
						<td width="300" class="formhead"><CFOUTPUT><CFIF VIEW IS "draft">Draft<CFELSE>Sent</CFIF></CFOUTPUT> Messages</td>
						<td align="right" class="formhead">
						<form method="POST" name="jump">
						<select name="menu" onChange="location=document.jump.menu.options[document.jump.menu.selectedIndex].value;">
						<CFOUTPUT>
							<option value="nltr_drafts.cfm?s=#securestring#&view=draft"<cfif view IS "draft"> SELECTED</cfif>>View Draft Messages</option>
							<option value="nltr_drafts.cfm?s=#securestring#&view=sent"<cfif view IS "sent"> SELECTED</cfif>>View Sent Messages</option>
						</CFOUTPUT>
						</select>
						</form>
						</td>
					</tr>
				</table>
				</td>
			</tr>
			<CFIF view IS "draft">
			<tr>
				<td class="rowhead">Name</td>
				<td class="rowhead">Create Date</td>
				<td class="rowhead">Owner</td>
				<td class="rowhead">From</td>
				<td class="rowhead"> </td>
				<td class="rowhead"> </td>
			</tr>
			<CFOUTPUT QUERY="getDrafts">
			<tr>
				<td class="rowitem">#message_desc#</td>
				<td class="rowitem">#DATEFORMAT(datecreated,"MM/DD/YYYY")# - #TIMEFORMAT(datecreated,"h:mm tt")#</td>
				<td class="rowitem"></td>
				<td class="rowitem">#from_email_address#</td>
				<td class="rowitem" align="center"><CFIF topic_choice_id_str IS ""><a href="nltr_edition_add_step2.cfm?s=#securestring#&message_id=#message_id#" class="formlink">Edit</a><CFELSE>
				<a href="nltr_edition_add_step3.cfm?s=#securestring#&message_id=#message_id#" class="formlink">Edit</a></CFIF></td>
				<td class="rowitem" align="center"><a href="javascript:void(0)" onclick="doConfirmation(#message_id#)" class="formlink">Remove</a></td>
			</tr>
			</CFOUTPUT>
			<CFELSE>
			<tr>
				<td class="rowhead">Name</td>
				<td class="rowhead">Create Date</td>
				<td class="rowhead">Owner</td>
				<td class="rowhead">From</td>
				<td class="rowhead">Date Sent</td>
				<td class="rowhead">Confirmed</td>
			</tr>
			<CFOUTPUT QUERY="getSent">
			<tr>
				<td class="rowitem">#message_desc#</td>
				<td class="rowitem">#DATEFORMAT(datecreated,"MM/DD/YYYY")# - #TIMEFORMAT(datecreated,"h:mm tt")#</td>
				<td class="rowitem"></td>
				<td class="rowitem">#from_email_address#</td>
				<td class="rowitem" align="center">#DATEFORMAT(sent_date,"MM/DD/YYYY")# - #TIMEFORMAT(sent_date,"h:mm tt")#</td>
				<td class="rowitem" align="center"><CFIF confirmed_date IS NOT "">Y<CFELSE>N</CFIF></td>
			</tr>
			</CFOUTPUT>
			</CFIF>
		</table>
		
		<div style="height:10px;"> </div>
		
		<!--- buttons --->
		<table border="0" cellspacing="2" cellpadding="2">
			<CFOUTPUT>
			<tr>
				<td><a href="nltr_home.cfm?s=#securestring#"><img src="assets/images/but_bg_done.gif" alt="" width="53" height="18" border="0"></a></td>
			</tr>
			</CFOUTPUT>
		</table>
		
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
