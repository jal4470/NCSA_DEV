
<cfinclude template="_checkLogin.cfm">

<cfset menu_id=url.menu_id>


<!--- remove all roles for menu_id --->
<cfinvoke
	component="#session.sitevars.cfcpath#.menu"
	method="removeMenuRoles"
	menu_id="#menu_id#">
	
<!--- delete menu --->
<cfinvoke
	component="#session.sitevars.cfcpath#.menu"
	method="removeMenu"
	menu_id="#menu_id#">

	
<cflocation url="menu_manage.cfm" addtoken="No">
	
