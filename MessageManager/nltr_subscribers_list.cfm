<!------------------------------------->
<!---  Capturepoint.com          	--->
<!---  CRS Action Page		   		--->
<!------------------------------------->
<!---  Created:  10.24.2006 by		--->
<!---	         Pat Waters			--->
<!---  Last Modified: 10.26.2006	--->
<!------------------------------------->

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

<CFSET totalrecs = #getTopicList.recordcount#>
<CFSET viewrecs = 10>

<CFSET startrec = 1>

<CFIF totalrecs GT viewrecs>
	<CFSET endrec = viewrecs>
<CFELSE>
	<CFSET endrec = totalrecs>
</CFIF>

<CFIF ISDEFINED("url.start_record")>
	<CFSET startrec = #url.start_record#>
</CFIF>
<CFIF ISDEFINED("url.end_record")>
	<CFSET endrec = #url.end_record#>
</CFIF>

<CFIF endrec GT totalrecs>
	<CFSET displayendrec = totalrecs>
<CFELSE>
	<CFSET displayendrec = endrec>
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
	objRef.style.backgroundColor = (1 == state) ? '#D3D8ED' : '#FFFFFF';
	return;
}
</script>
<cfscript> 
rs = structNew(); 
rs.start_record = #startrec#; 
rs.end_record = #endrec#; 
rs.records_per_page = #viewrecs#; 
rs.total_records = #totalrecs#; 
rs.query_str = "s=#securestring#"; 
</cfscript> 
<cfmodule template="assets/modules/pagination.cfm" recordStruct="#rs#">

</head>

<body topmargin="0" leftmargin="0" rightmargin="0" marginheight="0" marginwidth="0" bgcolor="#FFFFFF">

<CFINCLUDE TEMPLATE="assets/js/tooltip.js">


<CFINCLUDE TEMPLATE="header_nltr.cfm">

<!--- BODY --->


<table border="0" cellspacing="0" cellpadding="2" width="100%">
	<tr>
		<td style="padding-left: 15px; padding-top: 10px;" valign="top" width="150">
		
		<!--- LEFT NAVIGATION --->
		<CF_nltr_navigation securestring="#securestring#" location="subscribers" organization_id="#organization_id#" rolelistStr="#rolelistStr#">
		
		</td>
		<td style="padding-top: 10px;padding-right: 10px;" valign="top">
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<td class="controlbar" colspan="2">
				<table border="0" cellspacing="0" cellpadding="0" width="100%">
					<CFOUTPUT>
					<form method="post" action="nltr_subscriber_search_action.cfm?s=#securestring#">
					<input type="hidden" name="nextpage" value="nltr_subscribers.cfm">
					<tr>
						<td width="5" align="left" valign="middle"><img src="assets/images/spcrimg.gif" alt="" width="1" height="3" border="0"></td>
						<td width="100" align="left" valign="middle">
						<input type="text" name="searchterm" class="regularfield">
						</td>
						<td width="50" align="left" valign="middle" style="background-image: url(assets/images/searchbutton.jpg);background-repeat: no-repeat;">
						<input type="submit" name="submit" value="Search" class="searchbut">
						</td>
						<td><img src="assets/images/spcrimg.gif" alt="" width="1" height="3" border="0"></td>
						<td width="50" align="right" valign="middle"><img src="assets/icons/admin.gif" alt="" width="21" height="17" border="0"></td>
						<td width="80" align="left" valign="middle" class="controlbartext" onclick="location.href='nltr_admin.cfm?s=#securestring#'">Administration</td>
						<td width="30" align="left" valign="middle"><img src="assets/icons/ques3.gif" alt="" width="21" height="17" border="0"></td>
					</tr>
					</form>
					</CFOUTPUT>
				</table>
				</td>
			</tr>
			<tr>
				<td class="emailtablebar">
				<table border="0" cellspacing="0" cellpadding="2" width="100%">
					<CFOUTPUT>
					<tr>
						<td width="300" align="left" style="padding-left:4px;"><i>#fqc_desc#: #startrec# - #displayendrec# of #totalrecs# Subscribers</i></td>
						<td align="right" valign="middle">#arrows#</td>
					</tr>
					</CFOUTPUT>
				</table>
				<table border="0" cellspacing="0" cellpadding="2" width="100%">
					<tr>
						<td class="rowhead" width="200">Name</td>
						<td class="rowhead">Email</td>
						<td class="rowheadcenter" width="150">Status</td>
						<td class="rowheadcenter" width="175">Date Created</td>
						<td class="rowheadcenter" width="175">Last Update</td>
					</tr>
					<CFOUTPUT>
					<CFLOOP QUERY="getTopicList" STARTROW="#startrec#" ENDROW="#endrec#">
					<tr onmouseout="scbg(this, 0);" onmouseover="scbg(this, 1);">
						<td class="blankrowitem" onclick="location.href='nltr_subscribers_view.cfm?s=#securestring#&individual_id=#individual_id#&form_question_choice_id=#form_question_choice_id#&start_record=#startrec#&end_record=#endrec#'">#lname#, #fname#</td>
						<td class="blankrowitem" onclick="location.href='nltr_subscribers_view.cfm?s=#securestring#&individual_id=#individual_id#&form_question_choice_id=#form_question_choice_id#&start_record=#startrec#&end_record=#endrec#'">#email#</td>
						<td class="blankrowitem" align="center" onclick="location.href='nltr_subscribers_view.cfm?s=#securestring#&individual_id=#individual_id#&form_question_choice_id=#form_question_choice_id#&start_record=#startrec#&end_record=#endrec#'">#status#</td>
						<td class="blankrowitem" align="center" onclick="location.href='nltr_subscribers_view.cfm?s=#securestring#&individual_id=#individual_id#&form_question_choice_id=#form_question_choice_id#&start_record=#startrec#&end_record=#endrec#'">#DATEFORMAT(datecreated,"MM/DD/YYYY")# - #TIMEFORMAT(datecreated,"h:mm tt")#</td>
						<td class="blankrowitem" align="center" onclick="location.href='nltr_subscribers_view.cfm?s=#securestring#&individual_id=#individual_id#&form_question_choice_id=#form_question_choice_id#&start_record=#startrec#&end_record=#endrec#'">#DATEFORMAT(last_update,"MM/DD/YYYY")# - #TIMEFORMAT(last_update,"h:mm tt")#</td>
					</tr>
					</CFLOOP>
					</CFOUTPUT>
				</table>
				<table border="0" cellspacing="0" cellpadding="2" width="100%">
					<CFOUTPUT>
					<tr>
						<td width="150" align="left" class="tablebasenav">#pages#</td>
						<td align="center" class="tablebasenav">#counter#</td>
						<td width="150" align="right" valign="middle" class="tablebasenav">#arrows#</td>
					</tr>
					</CFOUTPUT>
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
