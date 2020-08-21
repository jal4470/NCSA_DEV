<!--- Author: Joe Lechuga jlechuga@capturepoint.com
Purpose: Page 1 of Distribution List Creation
Changes:
	J.Lechuga 5/26/2010 Initial Revision

 --->
<!----------------------------->
<!--- Application variables --->
<!----------------------------->

<cflock scope="application" type="readonly" timeout="10">
	<cfset reports_dsn = application.reports_dsn>
</cflock>

 <!--- validate login --->
 <cfmodule template="_checkLogin.cfm">
<!----------------------->

	<cfquery datasource="#reports_dsn#" name="getReportTypes">
	select report_type_id,report_type_name from dbo.tbl_report_type 
	</cfquery>

	
	
<cfset mid = 4> 
<cfinclude template="_header.cfm">
<cfhtmlhead text="<title>Distribution List Manager</title>">
<script language="Javascript">
	function validateForm(e)
	{
		var Element = document.getElementById(e).value.trim();
		if (Element.length == 0)
		{
			alert("Please enter a Name for the Distribution List");
			return false;
		}else{return true;}
	}
	//Create Trim Function
	function strtrim()
	{
		return this.replace(/^\s+/,'').replace(/\s+$/,'');
	}
	//Declare as trim()
	String.prototype.trim = strtrim; 
</script>	
<div id="contentText">
	<H1 class="pageheading">Distribution List Manager Step 1</H1>
	<hr>
		<cfoutput>
		<form method="post" action="DistributionListMgr_Step2.cfm" onSubmit="return validateForm('DistributionListName');">
		<table border="0" cellspacing="0" cellpadding="3" width="848">
			<!--- Section label --->
			<!--- Spacer row --->
			<tr>
				<td align="right">Distribution List Name:</td>
				<td><input type="text" name="DistributionListName" id="DistributionListName"></td>
			</tr>
			<tr>
				<td align="right">Select Report To Define Distribution List</td>
				<td><select name="ReportType">
					<cfloop query="getReportTypes">
						<option  value="#report_type_id#">#report_Type_name#</option>
					</cfloop>
				</select></td>
			</tr>
			<tr>
				<td align="right">Allow Criteria Edits:</td><td><input type="checkbox" name="CriteriaEdits"></td>
			</tr>
			<tr>
				<td colspan="2" align="center"><input type="Submit" value="Next"></td>
			</tr>
		</table>
		</form>
		</cfoutput>
</DIV>

<cfinclude template="_footer.cfm">
