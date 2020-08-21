<!--- 
	FileName:	menu_manage.cfm
	Created on: 10/29/2009
	Created by: bcooper
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
07/31/2017 - apinzone - 22821
-- Fixed sorting by updating plugin and adjusting logic.
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Sequence Menus</H1>
<br> <!--- <h2>yyyyyy </h2> --->


<!--- find super user role in logged in user's role list --->
<cfif structkeyexists(session.user.strole,"61")>
	<cfset su=true>
<cfelse>
	<cfset su=false>
</cfif>
<cfset su=true>

<cfsavecontent variable="customCSS">
<link rel="stylesheet" href="assets/jquery.tree.2017/themes/default/style.min.css">
<style type="text/css">
	.jstree-default .jstree-hovered,
	.jstree-default .jstree-clicked {
	  background: transparent;
	  border-radius: inherit;
	  box-shadow: inherit;
	}
</style>
</cfsavecontent>
<cfhtmlhead text="#customCSS#">

<cfsavecontent variable="cf_footer_scripts">
<script language="JavaScript" type="text/javascript" src="assets/jquery.tree.2017/jstree.min.js"></script>
<script language="JavaScript" type="text/javascript" src="assets/jquery.json.js"></script>
<script language="JavaScript" type="text/javascript">
	$(function(){
		var su = <cfoutput>#su#</cfoutput>;
		$("##treeContainer").jstree({
			"plugins" : [ "dnd", "types" ],
			"types" : {
				"child":{
					"max_children": 0,
					"max_depth": 0,
					"icon" : "fa fa-bars"
				},
				"parent":{
					"max_children" : -1,
					"max_depth" : 1,
					"valid_children" : ["child"],
					"icon" : "fa fa-folder-o"
				}
			},
			"core" : { 
				check_callback : function(op, node, par, pos, more) {
					if( op === "move_node" && node.parent != par.id ) {
						return false;
					}
					else {
						return true;
					}
				}
			}
		});
		
		$("input[name=btnSave]").click(function(e){
			// Get JSON
			var jsonRaw = $("##treeContainer").jstree(true).get_json();
			var jsonString = JSON.stringify(jsonRaw); 
			$('input[name=serialized]').val(jsonString);
		});
		
		$("##expandAll").click(function(){
			$.jstree.reference('##treeContainer').open_all();
			$("##collapseAll").show();
			$(this).hide();
		});
	
		$("##collapseAll").click(function(){
			$.jstree.reference('##treeContainer').close_all();
			$("##expandAll").show();
			$(this).hide();
		});
	});
</script>
</cfsavecontent>


<!--- sequence private menus by role --->
<cfif isdefined("url.role")>
	<cfset role=url.role>
<cfelse>
	<cfset role="">
</cfif>

<cfif role NEQ "">
	<cfquery datasource="#session.dsn#" name="getMenus">
		select b.menu_id, b.menu_name, b.parent_menu_id, a.seq, b.userDefined
		from xref_menu_role a
		inner join tbl_menu b
		on a.menu_id=b.menu_id
		where ispublic=0
		and a.role_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#role#">
		order by a.seq
	</cfquery>
	
	<!--- get chosen role --->
	<cfquery datasource="#session.dsn#" name="getChosenRole">
		select * from tlkp_role
		where role_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#role#">
	</cfquery>
</cfif>

<!--- get role list --->
<cfinvoke
	component="#application.sitevars.cfcpath#.contact"
	method="getRoleList"
	returnvariable="getRoles">

<cfif role EQ "">
	Select a role:
	<form method="get" name="roleForm">
	<select name="role">
		<cfloop query="getRoles">
			<option value="#role_id#">#RoleDisplayName#</option>
		</cfloop>
	</select>
	<input type="Submit" value="Go">
	</form>
<cfelse>
<h2 style="margin-bottom:15px;">
Role: #getChosenRole.roleDisplayName# (<a href="menu_sequence_private.cfm">Switch</a>)
</h2>
</cfif>
<cfif role NEQ "">
	<table>
		<tr>
			<td style="padding-bottom:30px;">
				<a id="expandAll" href="javascript:void(0);">Expand All</a><a style="display:none;" id="collapseAll" href="javascript:void(0);">Collapse All</a>
				<!--- list tree for sorting --->
				<div id="treeContainer">
					<!--- <ul>
						<li id="toplevel" rel="topLevel">
							<a href="##"><ins></ins>Menu</a> --->
						<ul>
							<!--- print root folders --->
							<cfquery dbtype="query" name="getRootMenus">
								select menu_id, menu_name
								from getMenus
								where parent_menu_id is null
								order by seq
							</cfquery>
							<cfloop query="getRootMenus">
								<cfset printNode(getRootMenus.menu_id)>
							</cfloop>
						</ul>
						<!--- </li>
					</ul> --->
				</div>
			</td>
		</tr>
	</table>
	<form name="theForm" action="menu_sequence_private_action.cfm" method="post">
		<input type="Hidden" name="serialized">
		<input type="hidden" name="role_id" value="#role#">
		<input type="Submit" name="btnSave" value="Save">
		<input type="Button" name="btnCancel" value="Cancel" onclick="javascript:history.go(-1);">
	</form>
</cfif>




</cfoutput>
</div>

<cfinclude template="_footer.cfm"> 





<cffunction name="PrintNode" access="private">
	<cfargument name="node_id" type="string" required="Yes">
	<cfset var getInfo="">
	<cfset var getChildren="">
	<cfset var getTemplates="">
	<!--- get menu info --->
	<cfquery dbtype="query" name="getInfo">
		select menu_name, userDefined, parent_menu_id from getMenus
		where menu_id=#node_id#
	</cfquery>
	<!--- get children --->
	<cfquery dbtype="query" name="getChildren">
		select menu_id, menu_name
		from getMenus
		where parent_menu_id=#node_id#
		order by seq
	</cfquery>
	
	<cfif getInfo.userDefined EQ "1">
		<cfset rel="menu">
	<cfelse>
		<cfset rel="parent">
	</cfif>

	<cfif len(trim(getInfo.parent_menu_id))>
		<cfset type = "child">
	<cfelse>
		<cfset type = "parent">
	</cfif>

	<cfoutput>
		<li id="menu-#node_id#" class="tree#rel#" data-jstree='{"type":"#type#"}'>
			<a href="##"><ins>&nbsp;</ins>#getInfo.menu_name#</a>
			<cfif getChildren.recordcount GT 0>
				<ul>
					<cfloop query="getChildren">
						<cfset printNode(getChildren.menu_id)>
					</cfloop>
				</ul>
			</cfif>
		</li>
	</cfoutput>

</cffunction>