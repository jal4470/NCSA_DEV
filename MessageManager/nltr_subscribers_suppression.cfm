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

<!----------------------->
<!--- Local variables --->
<!----------------------->

<!---------------->
<!--- Get data --->
<!---------------->

<cftry>
	<CFSTOREDPROC datasource="#dsn#" procedure="p_get_nltr_unsubscribes" returncode="YES">
		<CFPROCRESULT NAME="getUnsubs" RESULTSET="1">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#organization_id#" DBVARNAME="@organization_id">
	</CFSTOREDPROC>

	<cfcatch>
		<cfinclude template="cfcatch.cfm">
	</cfcatch>
</cftry>

<CFSET totalrecs = #getUnsubs.recordcount#>
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
<!--- Header
<table border="0" cellspacing="0" cellpadding="2" width="100%" bgcolor="#6661A7">
	<tr>
		<td width="50%" align="left" class="whitebold12" style="padding-left: 15px; height: 20px;">Newsletter Management - Messages</td>
		<td width="50%" align="right" class="whitebold12" style="padding-right: 10px; height: 20px;"><cfoutput>#organization_desc#</cfoutput></td>
	</tr>
</table>
 --->
<!--- BODY --->


<table border="0" cellspacing="0" cellpadding="2" width="100%">
	<tr>
		<td style="padding-left: 15px; padding-top: 10px;" valign="top" width="150">
		
		<!--- LEFT NAVIGATION --->
		<CF_nltr_navigation securestring="#securestring#" location="suppression" organization_id="#organization_id#" rolelistStr="#rolelistStr#">
		
		</td>
		<td style="padding-top: 10px;padding-right: 10px;" valign="top">
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<td class="controlbar" colspan="2">
				<table border="0" cellspacing="0" cellpadding="0" width="100%">
					<CFOUTPUT>
					<tr>
						<form method="post" action="nltr_subscribers_unsubscribe.cfm?s=#securestring#">
						<td width="70" align="left" valign="middle" style="background-image: url(assets/images/suppnewbutton.jpg);background-repeat: no-repeat;height:28px;">
						<table border="0" cellspacing="0" cellpadding="0" width="100%">
							<tr>
								<td width="99" align="left" valign="middle"><input type="submit" name="submit" value="New" class="emailnewbut"></td>
							</tr>
						</table>
						</td>
						</form>
						<td width="20" align="left" valign="middle"><img src="assets/images/spcrimg.gif" alt="" width="1" height="3" border="0"></td>
						<form method="post" action="nltr_subscriber_search_action.cfm?s=#securestring#">
						<input type="hidden" name="nextpage" value="nltr_subscribers.cfm">
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
						</form>
					</tr>
					</CFOUTPUT>
				</table>
				</td>
			</tr>
			<tr>
				<td class="emailtablebar">
				<table border="0" cellspacing="0" cellpadding="2" width="100%">
					<CFOUTPUT>
					<tr>
						<td width="200" align="left" style="padding-left:4px;"><i>Suppression Records #startrec# - #displayendrec# of #totalrecs#</i></td>
						<td align="right" valign="middle">#arrows#</td>
					</tr>
					</CFOUTPUT>
				</table>
				<table border="0" cellspacing="0" cellpadding="2" width="100%">
					<tr>
						<td class="rowhead" width="300">Name</td>
						<td class="rowhead">Email</td>
						<td class="rowheadcenter" width="200">Last Update</td>
					</tr>
					<CFOUTPUT>
					<CFLOOP QUERY="getUnsubs" STARTROW="#startrec#" ENDROW="#endrec#">
					<tr onmouseout="scbg(this, 0);" onmouseover="scbg(this, 1);">
						<td class="blankrowitem">#lname#, #fname#</td>
						<td class="blankrowitem">#email#</td>
						<td class="blankrowitem" align="center">#DATEFORMAT(last_update,"MM/DD/YYYY")# - #TIMEFORMAT(last_update,"h:mm tt")#</td>
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
