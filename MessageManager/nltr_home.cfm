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

<!----------------------->
<!--- Local variables --->
<!----------------------->

<CFSET message = "">
<CFIF ISDEFINED("url.msg")>
	<CFSET message = "#url.msg#">
</CFIF>

<!---------------->
<!--- Get data --->
<!---------------->


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
		<td width="50%" align="left" class="whitebold12" style="padding-left: 15px; height: 20px;">Message Management - Home</td>
		<td width="50%" align="right" class="whitebold12" style="padding-right: 10px; height: 20px;"><cfoutput>#organization_desc#</cfoutput></td>
	</tr>
</table>

<!--- BODY --->

<div id="instructions">Welcome to the Message Manager, please choose the appropriate selection below.
</div>

<CFIF message IS NOT "">
<CFOUTPUT>
<div id="message">#message#</div>
</CFOUTPUT>
</CFIF>

<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr>
		<td style="padding-left: 15px; padding-right: 15px;">
		<table border="0" cellspacing="1" cellpadding="2" width="100%">
			<CFOUTPUT>
			<tr>
				<td class="homerow" onmouseout="scbg(this, 0);" onmouseover="scbg(this, 1);" onclick="location.href='nltr_form_man.cfm?s=#securestring#'">Sign up Form</td>
			</tr>
			<tr>
				<td class="homerow" onmouseout="scbg(this, 0);" onmouseover="scbg(this, 1);" onclick="location.href='nltr_edition_defaults.cfm?s=#securestring#'">Edition Defaults</td>
			</tr>
			<tr>
				<td class="homerow" onmouseout="scbg(this, 0);" onmouseover="scbg(this, 1);" onclick="location.href='nltr_new_message.cfm?s=#securestring#'">New Edition</td>
			</tr>
			<tr>
				<td class="homerow" onmouseout="scbg(this, 0);" onmouseover="scbg(this, 1);" onclick="location.href='nltr_view_drafts.cfm?s=#securestring#'">Draft Messages</td>
			</tr>
			<tr>
				<td class="homerow" onmouseout="scbg(this, 0);" onmouseover="scbg(this, 1);" onclick="location.href='nltr_report.cfm?s=#securestring#'">Reports</td>
			</tr>
			<tr>
				<td class="homerow" onmouseout="scbg(this, 0);" onmouseover="scbg(this, 1);" onclick="location.href='nltr_recipients.cfm?s=#securestring#'">Recipients</td>
			</tr>
			</CFOUTPUT>
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
