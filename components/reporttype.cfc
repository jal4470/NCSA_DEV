

<cfcomponent>


<cffunction
	name="getAllPrivateReportTypes"
	access="public"
	returntype="query">
	<cfargument name="role_id" type="numeric" required="Yes">
	<cfquery datasource="#application.reports_dsn#" name="getReportTypes">
		select report_type_id, report_type_name, report_type_desc
		from tbl_report_type x
		where not exists(select 1 from ncsa2..xref_report_type_role where report_type_id = x.report_type_id and role_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#role_id#">)
	</cfquery>
	
	<cfreturn getReportTypes>
	
</cffunction>




<cffunction
	name="getReportRoles"
	access="public"
	returntype="any">
	<cfargument name="report_type_id" type="string" required="no">
	<cfargument name="role_id" type="string" required="no">
	
	<cfquery datasource="#session.dsn#" name="getRoles">

select r.role_id, rtr.report_type_id, r.roledisplayname, rt.report_type_name from 
tlkp_role r 
inner join dbo.xref_report_type_role rtr on r.role_id = rtr.role_id
inner join ncsa_reports..tbl_report_type rt on rt.report_type_id = rtr.report_type_id
where rtr.role_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#role_id#">

	</cfquery>
	
	<cfreturn getRoles>
	
</cffunction>
<cffunction name="RemoveReportTypeRoles" access="public" returntype="any">
	<cfargument name="role_id" type="string" required="Yes">
	<cfstoredproc datasource="#session.dsn#" procedure="p_delete_role_report_types">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@role_id" value="#arguments.role_id#">
	</cfstoredproc>
</cffunction>
<cffunction
	name="AddReportTypeRole"
	access="public"
	returntype="any">
	<cfargument name="report_type_id" type="string" required="Yes">
	<cfargument name="role_id" type="string" required="Yes">
	<cfstoredproc datasource="#session.dsn#" procedure="p_create_report_type_role">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@report_type_id" value="#arguments.report_type_id#">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@role_id" value="#arguments.role_id#">
	</cfstoredproc>
	
</cffunction>

</cfcomponent>