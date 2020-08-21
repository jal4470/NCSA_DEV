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


<!---------------->
<!--- Get data --->
<!---------------->

<!---------------->
<!--- Get data --->
<!---------------->
<cftry>
	<CFSTOREDPROC datasource="#dsn#" procedure="p_get_nltr_topic_recipient_counts" returncode="YES">
		<CFPROCRESULT NAME="getTopics" RESULTSET="1">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#organization_id#" DBVARNAME="@organization_id">
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
		<td width="50%" align="left" class="whitebold12" style="padding-left: 15px; height: 20px;">Message Management - Recipients</td>
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
				<td colspan="3">
				<table border="0" cellspacing="0" cellpadding="1" width="100%">
					<tr>
						<td class="formhead">Recipient Counts by Topic</td>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td class="rowhead">Topic</td>
				<td class="rowhead" width="15%" align="center"># of Recipients</td>
				<td class="rowhead" width="15%">&nbsp;</td>
			</tr>
			<CFIF getTopics.recordcount GT 0>
			<CFOUTPUT QUERY="getTopics">
			<tr>
				<td class="rowitem">#choice_short_desc#</td>
				<td class="rowitem" align="center">#user_cnt#</td>
				<td class="rowitem" align="center"><a href="nltr_recipients_list.cfm?s=#securestring#&form_question_choice_id=#form_question_choice_id#" class="formlink">View Recipient List</a></td>
			</tr>
			</CFOUTPUT>
			<CFELSE>
			<tr>
				<td class="rowitem" colspan="2">There are no topics.</td>
			</tr>
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
