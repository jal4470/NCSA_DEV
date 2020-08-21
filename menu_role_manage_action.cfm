
<cfinclude template="_checkLogin.cfm">

<cfset menu_id=form.menu_id>
<cfif isdefined("form.selAssignedRoles")>
	<cfset rolelist=form.selAssignedRoles>
<cfelse>
	<cfset rolelist="">
</cfif>


<!--- get all roles --->
<cfquery datasource="#session.dsn#" name="getRoles">
	select role_id
	from tlkp_role
	where role_id <> 61
	order by roledisplayname
</cfquery>
<cfset lallroles=valuelist(getRoles.role_id)>

<!--- remove other roles for menu_id --->
<cfloop list="#lallroles#" index="i">
	<cfif listfind(rolelist,i) EQ "0">
		<!--- remove role --->
		<cfinvoke
			component="#session.sitevars.cfcpath#.menu"
			method="RemoveMenuRole"
			menu_id="#menu_id#"
			role_id="#i#">
	</cfif>
</cfloop>
	
	
<!--- loop over roles, assign --->
<cfloop list="#rolelist#" index="i">
	<cfinvoke
		component="#session.sitevars.cfcpath#.menu"
		method="AddMenuRole"
		menu_id="#menu_id#"
		role_id="#i#">
</cfloop>
	
<cflocation url="menu_manage.cfm" addtoken="No">
	
