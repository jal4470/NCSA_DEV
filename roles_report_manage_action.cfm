
<cfinclude template="_checkLogin.cfm">

<cfset role_id=form.role_id>
<cfif isdefined("form.selAssignedReports")>
	<cfset reporttypelist=form.selAssignedReports>
<cfelse>
	<cfset reporttypelist="">
</cfif>

	<cfinvoke
		component="#session.sitevars.cfcpath#.reporttype"
		method="RemoveReportTypeRoles"
		role_id="#role_id#">
	
<!--- loop over menus, assign --->
<cfloop list="#reporttypelist#" index="i">
	<cfinvoke
		component="#session.sitevars.cfcpath#.reporttype"
		method="AddReportTypeRole"
		report_type_id="#i#"
		role_id="#role_id#">
</cfloop>
	
<cflocation url="roles_manage.cfm" addtoken="No">
	
