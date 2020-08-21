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
	<CFSTOREDPROC datasource="#dsn#" procedure="p_get_nltr_edition_add_step2" returncode="YES">
		<CFPROCRESULT NAME="getTopics" RESULTSET="1">
		<CFPROCRESULT NAME="getSelectedTopics" RESULTSET="2">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#organization_id#" DBVARNAME="@organization_id">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#message_id#" DBVARNAME="@message_id">
	</CFSTOREDPROC>

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
		<td width="50%" align="left" class="whitebold12" style="padding-left: 15px; height: 20px;">Message Management - Edition Add Step 2</td>
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
			<!--- Declare form --->
			<cfoutput>
			<form method="post" action="nltr_edition_add_step2_action.cfm?s=#securestring#">
			<input type="hidden" name="message_id" value="#message_id#">
			</cfoutput>	

			<!--- Header row --->
			<tr>
				<td colspan="2">
				<table border="0" cellspacing="0" cellpadding="1" width="100%">
					<tr>
						<td width="300" class="formhead">Edition Recipients</td>
						<td align="right" class="formhead"><img src="assets/images/spcrimg.gif" alt="" width="1" height="1" border="0"></td>
					</tr>
				</table>
				</td>
			</tr>

			<!--- Loop topics --->
			<cfoutput query="getTopics">
			<tr>
				<td class="formitemfield"><input type="Checkbox" name="topic_choice_id_str" value="#form_question_choice_id#"<cfif ListFind(getSelectedTopics.topic_choice_id_str,form_question_choice_id)> CHECKED</cfif>></td>
				<td class="formitem">#choice_short_desc#<i> (#user_cnt# users)</i></td>
			</tr>
			</cfoutput>

<!--- Commented out for now
			<!--- Calculate button --->
			<tr>
				<td colspan="2"><img src="assets/images/but_bg_calculate.gif" alt="" width="79" height="18" border="0"></td>
			</tr>
			<tr>
				<td colspan="2" class="buttonholder"><div style="height:10px;"> </div></td>
			</tr>
--->

			<!--- Other buttons --->
			<cfoutput>
			<tr>
				<td colspan="2"><a href="nltr_edition_cancel_confirm.cfm?s=#securestring#&message_id=#message_id#"><img src="assets/images/but_bg_cancel.gif" alt="" width="63" height="18" border="0"></a>&nbsp;
				<a href="nltr_edition_add_step1.cfm?s=#securestring#&message_id=#message_id#"><img src="assets/images/but_bg_back.gif" alt="" width="53" height="18" border="0"></a>&nbsp;
				<input type="image" name="submit" value="submit" src="assets/images/but_bg_continue.gif"></td>
			</tr>
			</cfoutput>
		</table>
		</form>
		
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
