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
<H1 class="pageheading">NCSA - Menus for <i>#getRole.roledisplayname#</i></H1>
<br> <!--- <h2>yyyyyy </h2> --->

	
<!--- get menus for this role --->
<cfinvoke
	component="#session.sitevars.cfcpath#.menu"
	method="getMenuRoles"
	role_id="#role_id#"
	returnvariable="menuRoles">
<cfset menuList=valuelist(menuRoles.menu_id)>

<!--- get all menus --->
<cfinvoke
	component="#session.sitevars.cfcpath#.menu"
	method="getAllPrivateMenus"
	returnvariable="getMenus">



<script language="JavaScript" type="text/javascript" src="assets/jquery-1.3.2.min.js"></script>
<script language="JavaScript" type="text/javascript">
	$(function(){
		$('input[name=btnAdd]').click(function(){
			//move values from left to right
			$('select[name=selAssignedMenus]').append($('select[name=selAllMenus] option:selected'));
		});
		
		$('input[name=btnDel]').click(function(){
			$('select[name=selAllMenus]').append($('select[name=selAssignedMenus] option:selected'));
		});
		
		$('form[name=theForm]').submit(function(){
			$('select[name=selAssignedMenus] option').attr('selected','selected');
		});
	});
</script>

<form name="theForm" action="roles_menu_manage_action.cfm" method="post">
<input type="Hidden" name="role_id" value="#role_id#">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-bottom:30px;">
		<tr>
			<td style="width:40%;">
				<!--- all roles --->
				<h2>Available Menus</h2>
				<select multiple size="20" name="selAllMenus">
					<!--- get top menus --->
					<cfquery dbtype="query" name="getTopMenus">
						select * from getMenus
						where parent_menu_id is null
						order by menu_name
					</cfquery>
					<cfloop query="getTopMenus">
						<!--- get child menus --->
						<cfquery dbtype="query" name="getChildMenus">
							select * from getMenus
							where parent_menu_id=#getTopMenus.menu_id#
							order by menu_name
						</cfquery>
						<optgroup label="#getTopMenus.menu_name#">
							<cfloop query="getChildMenus">
								<cfif listfind(menuList,menu_id) EQ 0>
									<option value="#menu_id#">#menu_name#</option>
								</cfif>
							</cfloop>
						</optgroup>
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
				<select multiple size="20" name="selAssignedMenus">
					<cfquery dbtype="query" name="getTopMenus">
						select * from menuRoles
						where parent_menu_id is null
						order by menu_name
					</cfquery>
					<cfloop query="getTopMenus">
						<optgroup label="#getTopMenus.menu_name#">
							<cfquery dbtype="query" name="getChildMenus">
								select * from menuRoles
								where parent_menu_id=#getTopMenus.menu_id#
								order by menu_name
							</cfquery>
							<cfloop query="getChildMenus">
									<option value="#menu_id#">#menu_name#</option>
							</cfloop>
						</optgroup>
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



