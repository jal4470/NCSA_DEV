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
	<CFSTOREDPROC datasource="#dsn#" procedure="p_get_nltr_edition_add_step3" returncode="YES">
		<CFPROCRESULT NAME="getTopics" RESULTSET="1">
		<CFPROCRESULT NAME="getRecipientCnt" RESULTSET="2">
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
		<td width="50%" align="left" class="whitebold12" style="padding-left: 15px; height: 20px;">Message Management - Message Cancel Confirm</td>
		<td width="50%" align="right" class="whitebold12" style="padding-right: 10px; height: 20px;"><cfoutput>#organization_desc#</cfoutput></td>
	</tr>
</table>

<!--- BODY --->

<div id="instructions">Cancelling this message will remove it from the system.  If you would like to save the message as a draft for sending at 
a later date, please choose the appropriate option below.<br /><br >
<CFOUTPUT>
<a href="nltr_cancel_action.cfm?s=#securestring#&message_id=#message_id#" class="formlink">Cancel Message</a><br /><br >
<a href="nltr_home.cfm?s=#securestring#" class="formlink">Save Draft Message</a>
</CFOUTPUT>
</div>


<div style="height:25px;"> </div>
<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr>
		<td height="26" align="right" style="padding-right: 10px;"><IMG SRC="assets/images/cp_powered2.gif" ALT="" WIDTH="213" HEIGHT="26"></td>
	</tr>
</table>

</body>
</html>
