<!--- 
	FileName:	roles_menu_manage.cfm
	Created on: 3/17/2010
	Created by: bcooper
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>


<cfif isdefined("url.role_id")>
	<cfset role_id=url.role_id>
<cfelse>
	<cfthrow message="Role ID must be defined in URL">
</cfif>

<!--- get role info --->
<cfquery datasource="#session.dsn#" name="getRole">
	select role_id, roledisplayname
	from tlkp_role
	where role_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#role_id#">
</cfquery>



<div id="contentText">
<H1 class="pageheading">NCSA - Report Types for <i>#getRole.roledisplayname#</i></H1>
<br> <!--- <h2>yyyyyy </h2> --->

	
<!--- get menus for this role --->
<cfinvoke
	component="#session.sitevars.cfcpath#.reporttype"
	method="getReportRoles"
	role_id="#role_id#"
	returnvariable="reportRoles">
	
<!--- <cfset rtList=valuelist(menuRoles.menu_id)> --->

<!--- get all menus --->
<cfinvoke
	component="#session.sitevars.cfcpath#.reporttype"
	method="getAllPrivateReportTypes"
	role_id="#role_id#"
	returnvariable="getReportTypes">


<script language="JavaScript" type="text/javascript" src="assets/jquery-1.3.2.min.js"></script>
<script language="JavaScript" type="text/javascript">
	$(function(){
		$('input[name=btnAdd]').click(function(){
			//move values from left to right
			$('select[name=selAssignedReports]').append($('select[name=selAllReports] option:selected'));
		});
		
		$('input[name=btnDel]').click(function(){
			$('select[name=selAllReports]').append($('select[name=selAssignedReports] option:selected'));
		});
		
		$('form[name=theForm]').submit(function(){
			$('select[name=selAssignedReports] option').attr('selected','selected');
		});
	});
</script>

<form name="theForm" action="roles_report_manage_action.cfm" method="post">
<input type="Hidden" name="role_id" value="#role_id#">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-bottom:30px;">
		<tr>
			<td style="width:40%;">
				<!--- all roles --->
				<h2>Available Report Types</h2>
				<select multiple size="20" name="selAllReports">
							<cfloop query="getReportTypes">
									<option value="#REPORT_TYPE_ID#">#REPORT_TYPE_NAME#</option>
							</cfloop>
				</select>
			</td>
			<td style="padding:0 15px 0 15px; vertical-align:middle; text-align:center;">
				<input type="Button" name="btnAdd" value=">>"><br>
				<input type="Button" name="btnDel" value="<<">
			</td>
			<td style="width:40%;">
				<!--- menu roles --->
				<h2>Assigned Menus</h2>
				<select multiple size="20" name="selAssignedReports">
							<cfloop query="reportRoles">
									<option value="#report_type_id#">#report_type_name#</option>
							</cfloop>
				</select>
			</td>
		</tr>
	</table>
	<input type="Submit" name="btnSave" value="Save"> <input type="button" name="btnCancel" value="Cancel" onclick="javascript:history.go(-1);">
</form>

</cfoutput>
</div>
<cfinclude template="_footer.cfm"> 



