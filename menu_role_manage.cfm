<!--- 
	FileName:	menu_manage.cfm
	Created on: 10/29/2009
	Created by: bcooper
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>


<cfif isdefined("url.menu_id")>
	<cfset menu_id=url.menu_id>
<cfelse>
	<cfthrow message="Menu ID must be defined in URL">
</cfif>

<!--- get menu info --->
<cfinvoke
	component="#session.sitevars.cfcpath#.menu"
	method="getMenuInfo"
	menu_id="#menu_id#"
	returnvariable="menuInfo">



<div id="contentText">
<H1 class="pageheading">NCSA - Roles for <i>#menuInfo.menu_name#</i></H1>
<br> <!--- <h2>yyyyyy </h2> --->

	
<!--- get roles for this menu --->
<cfinvoke
	component="#session.sitevars.cfcpath#.menu"
	method="getMenuRoles"
	menu_id="#menu_id#"
	returnvariable="menuRoles">
<cfset menuList=valuelist(menuRoles.role_id)>

<!--- get all roles --->
<cfquery datasource="#session.dsn#" name="getRoles">
	select role_id, roledisplayname
	from tlkp_role
	where role_id <> 61
	order by roledisplayname
</cfquery>



<script language="JavaScript" type="text/javascript" src="assets/jquery-1.3.2.min.js"></script>
<script language="JavaScript" type="text/javascript">
	$(function(){
		$('input[name=btnAdd]').click(function(){
			//move values from left to right
			$('select[name=selAssignedRoles]').append($('select[name=selAllRoles] option:selected'));
		});
		
		$('input[name=btnDel]').click(function(){
			$('select[name=selAllRoles]').append($('select[name=selAssignedRoles] option:selected'));
		});
		
		$('form[name=theForm]').submit(function(){
			$('select[name=selAssignedRoles] option').attr('selected','selected');
		});
	});
</script>

<form name="theForm" action="menu_role_manage_action.cfm" method="post">
<input type="Hidden" name="menu_id" value="#menu_id#">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-bottom:30px;">
		<tr>
			<td style="width:40%;">
				<!--- all roles --->
				<h2>Available Roles</h2>
				<select multiple size="20" name="selAllRoles">
					<cfloop query="getRoles">
						<cfif listfind(menuList,role_id) EQ 0>
							<option value="#role_id#">#roledisplayname#</option>
						</cfif>
					</cfloop>
				</select>
			</td>
			<td style="padding:0 15px 0 15px; vertical-align:middle; text-align:center;">
				<input type="Button" name="btnAdd" value=">>"><br>
				<input type="Button" name="btnDel" value="<<">
			</td>
			<td style="width:40%;">
				<!--- menu roles --->
				<h2>Assigned Roles</h2>
				<select multiple size="20" name="selAssignedRoles">
					<cfloop query="menuRoles">
						<option value="#role_id#">#roledisplayname#</option>
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



