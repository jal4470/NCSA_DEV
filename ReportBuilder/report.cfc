<cfcomponent>
	<cffunction
		name="reorderColumns"
		access="public"
		returntype="any">
		<cfargument name="tree" type="string" required="Yes">
		
		<cfstoredproc datasource="#application.reports_dsn#" procedure="p_resequence_columns">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@tree" value="#arguments.tree#" type="In">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@resultCode" variable="resultCode" type="Out">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@resultString" variable="resultString" type="Out">
		</cfstoredproc>
		
	</cffunction>
	
	<cffunction
		name="refreshDateFilter"
		access="public"
		returntype="any">
		<cfargument name="report_id" type="string" required="Yes">
		
			<cfstoredproc datasource="#application.reports_dsn#" procedure="p_refresh_report_dates">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@report_id" value="#arguments.report_id#" type="In">
			</cfstoredproc>
		
	</cffunction>
	
</cfcomponent>