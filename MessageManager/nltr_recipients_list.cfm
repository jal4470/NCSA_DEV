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

<cfif isdefined("form.form_question_choice_id")>
	<cfset form_question_choice_id = form.form_question_choice_id>
<cfelseif isdefined("url.form_question_choice_id")>
	<cfset form_question_choice_id = url.form_question_choice_id>
<cfelse>
	<cfset form_question_choice_id = "">
</cfif>


<!---------------->
<!--- Get data --->
<!---------------->
<cftry>
	<CFSTOREDPROC datasource="#dsn#" procedure="p_get_nltr_topic_recipient_list" returncode="YES">
		<CFPROCRESULT NAME="getTopicList" RESULTSET="1">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#organization_id#" DBVARNAME="@organization_id">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#form_question_choice_id#" DBVARNAME="@form_question_choice_id">
	</CFSTOREDPROC>

	<cfcatch>
		<cfinclude template="cfcatch.cfm">
	</cfcatch>
</cftry>

<CFTRY>
	<CFINVOKE component="#application.CRS_CFC_Path#GetForm" method="GetChoice" returnvariable="GetChoice">
		<cfinvokeargument name="form_question_choice_id" value="#form_question_choice_id#">
	</CFINVOKE>
	<CFCATCH type="any">
		<CF_ERROR error="Cannot get Choice.">			
	</CFCATCH>			
</CFTRY>
<CFIF GetChoice.recordcount GT 0>
	<CFSET fqc_desc = "#GetChoice.choice_short_desc#">
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
</head>

<body topmargin="0" leftmargin="0" rightmargin="0" marginheight="0" marginwidth="0" bgcolor="#FFFFFF">

<CFINCLUDE TEMPLATE="assets/js/tooltip.js">

<!--- Header --->
<CFINCLUDE TEMPLATE="header_nltr.cfm">

<table border="0" cellspacing="0" cellpadding="2" width="100%" bgcolor="#6661A7">
	<tr>
		<td width="50%" align="left" class="whitebold12" style="padding-left: 15px; height: 20px;">Message Management - Recipient List</td>
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
						<td class="formhead">Recipient List by Topic - <CFOUTPUT>#fqc_desc#</CFOUTPUT></td>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td class="rowhead">ID</td>
				<td class="rowhead">Last Name</td>
				<td class="rowhead">First Name</td>
				<td class="rowhead">Email</td>
				<td class="rowhead">Subscribe Date</td>
				<td class="rowhead">Family Name</td>
			</tr>
			<CFIF getTopicList.recordcount GT 0>
			<CFOUTPUT QUERY="getTopicList">
			<tr>
				<td class="rowitem">#individual_id#</td>
				<td class="rowitem">#lname#</td>
				<td class="rowitem">#fname#</td>
				<td class="rowitem">#email#</td>
				<td class="rowitem">#DATEFORMAT(datecreated,"MM/DD/YYYY")# - #TIMEFORMAT(datecreated,"h:mm tt")#</td>
				<td class="rowitem">#family_name#</td>
			</tr>
			</CFOUTPUT>
			<CFELSE>
			<tr>
				<td class="rowitem" colspan="6">There are no recipients.</td>
			</tr>
			</CFIF>
		</table>
		
		<div style="height:10px;"> </div>
		
		<!--- buttons --->
		<table border="0" cellspacing="2" cellpadding="2">
			<CFOUTPUT>
			<tr>
				<td><a href="nltr_home.cfm?s=#securestring#"><img src="assets/images/but_bg_done.gif" alt="" width="53" height="18" border="0"></a>&nbsp;
				<a href="nltr_recipients.cfm?s=#securestring#"><img src="assets/images/but_bg_back.gif" alt="" width="53" height="18" border="0"></a></td>
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
