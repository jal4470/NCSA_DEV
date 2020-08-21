
<cfinclude template="_checkLogin.cfm">

<cfset role_id=form.role_id>
<cfif isdefined("form.selAssignedMenus")>
	<cfset menulist=form.selAssignedMenus>
<cfelse>
	<cfset menulist="">
</cfif>


<!--- get all menus --->
<cfinvoke
	component="#session.sitevars.cfcpath#.menu"
	method="getAllPrivateMenus"
	returnvariable="getMenus">
<cfquery dbtype="query" name="getChildMenus">
	select * from getMenus
	where parent_menu_id is not null
</cfquery>
<cfset lallMenus=valuelist(getChildMenus.menu_id)>

<!--- remove other menus for role_id --->
<cfloop list="#lallMenus#" index="i">
	<cfif listfind(menulist,i) EQ "0">
		<!--- remove role --->
		<cfinvoke
			component="#session.sitevars.cfcpath#.menu"
			method="RemoveMenuRole"
			menu_id="#i#"
			role_id="#role_id#">
	</cfif>
</cfloop>
	
	
<!--- loop over menus, assign --->
<cfloop list="#menulist#" index="i">
	<cfinvoke
		component="#session.sitevars.cfcpath#.menu"
		method="AddMenuRole"
		menu_id="#i#"
		role_id="#role_id#">
</cfloop>
	
<cflocation url="roles_manage.cfm" addtoken="No">
	
