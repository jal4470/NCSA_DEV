<!--- Author: Joe Lechuga jlechuga@capturepoint.com
Purpose: Distribution List Manager
Changes:
	J.Lechuga 5/27/2010 Initial Revision
    J.Lechuga 7/23/2010 Added Update date/Create Date and By Whom
 --->
<!----------------------------->
<!--- Application variables --->
<!----------------------------->
<cflock scope="application" type="readonly" timeout="10">
	<cfset reports_dsn = application.reports_dsn>
</cflock>

 <!--- validate login --->
 <cfmodule template="_checkLogin.cfm">
 <cfquery name="getDistributionLists" datasource="#reports_dsn#">
 	select distribution_list_id, distribution_list_name, allow_edits, report_type_id,dbo.f_get_Report_Type(report_type_id) as report_Type_name, datecreated, dateupdated, updated_by,dbo.f_get_UserName(updated_by) as updated_by_name from tbl_distribution_list
 </cfquery>

<cfset mid = 4> 
<cfinclude template="_header.cfm">
<script language="javascript">
function confirmation(url,msg) {
	var answer = confirm(msg)
	if (answer){
		window.location = url;
	}
}
</script>
<cfhtmlhead text="<title>Distribution List Manager</title>">
<div id="contentText">
	<H1 class="pageheading">Distribution List Management</H1>
	<hr>
	<table width="100%">
		<tr><th align="right" style="border-bottom: 1px solid black;" colspan="5"><a href="DistributionListMgr_Step1.cfm">Create New</a></th></tr>
		<tr>
			<th style="border: 1px solid black;">Action</th><th style="border: 1px solid black;">Distribution List Name</th><th style="border: 1px solid black;">Report Type</th><th style="border: 1px solid black;">Updated On</th><th style="border: 1px solid black;">Updated By</th>
		</tr>
		<cfoutput query="getDistributionLists">
		<tr>
			<td><a href="DistributionListView.cfm?dli=#distribution_list_id#">View List</a>&nbsp;|&nbsp;<a href="DistributionListMgr_Edit.cfm?distlistid=#distribution_list_id#">Edit</a>&nbsp;|&nbsp;<a href="##" onclick="confirmation('DistributionListDelAction.cfm?distlistid=#distribution_list_id#','Are You sure you want to remove this Distribution List?')">Delete</a></td>
		<td align="center"><a href="DistributionListView.cfm?dli=#distribution_list_id#">#distribution_list_name#</a></td>
		<td align="center">#report_type_name#</td>
		<td align="center">#dateformat(dateupdated,"mm/dd/yyyy")#&nbsp;&nbsp;#timeformat(dateupdated,"hh:mm:ss tt")#</td>
		<td align="center">#updated_by_name#</td>
		</tr>
		</cfoutput>
	</table>
</DIV>
<cfinclude template="_footer.cfm">
