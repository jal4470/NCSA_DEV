<cfcomponent>

	<cffunction
		name="updatesequence"
		access="public"
		description="resequences misconducts">
		<cfargument name="tree" type="string" required="Yes">
		
		<cfstoredproc datasource="#session.dsn#" procedure="p_resequence_misconducts">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@tree" value="#arguments.tree#">
		</cfstoredproc>
		
	</cffunction>

</cfcomponent>