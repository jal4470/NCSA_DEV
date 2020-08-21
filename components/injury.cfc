<cfcomponent>

	<cffunction
		name="addInjury"
		access="public"
		returntype="numeric">
		<cfargument name="injuryDescription" type="string" required="Yes">
		
		<cfstoredproc datasource="#application.dsn#" procedure="p_insert_injury">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@injury_desc" type="In" value="#arguments.injuryDescription#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@injury_id" type="Out" variable="injury_id">
		</cfstoredproc>
		
		<cfreturn injury_id>
		
	</cffunction>

	<cffunction
		name="EditInjury"
		access="public">
		<cfargument name="injury_id" type="string" required="Yes">
		<cfargument name="injuryDescription" type="string" required="Yes">
		
		<cfstoredproc datasource="#application.dsn#" procedure="p_update_injury">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@injury_id" type="In" value="#arguments.injury_id#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@injury_desc" type="In" value="#arguments.injuryDescription#">
		</cfstoredproc>
		
	</cffunction>

	<cffunction
		name="DeleteInjury"
		access="public">
		<cfargument name="injury_id" type="string" required="Yes">
		
		<cfstoredproc datasource="#application.dsn#" procedure="p_delete_injury">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@injury_id" type="In" value="#arguments.injury_id#">
		</cfstoredproc>
		
	</cffunction>
	
	<cffunction
		name="getInjuries"
		access="public"
		returntype="query">
		
		<cfquery datasource="#application.dsn#" name="getInjuries">
			select injury_id, injury_desc, seq
			from tlkp_injury
			order by seq asc
		</cfquery>
		
		<cfreturn getInjuries>
		
	</cffunction>
	
	<cffunction
		name="updatesequence"
		access="public"
		description="resequences injuries">
		<cfargument name="tree" type="string" required="Yes">
		
		<cfstoredproc datasource="#session.dsn#" procedure="p_resequence_injuries">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@tree" value="#arguments.tree#">
		</cfstoredproc>
		
	</cffunction>

</cfcomponent>