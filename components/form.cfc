<cfcomponent>

	<cffunction
		name="getForms"
		access="public"
		returntype="query"
		description="Gets all forms from db">
		<cfargument name="group_id" type="string">
		
			<cfquery datasource="#session.dsn#" name="getForms">
				select form_id, filename, extension, name, active_flag, seq, datecreated, formType
				from v_form
				where showInUI=1
				<cfif isdefined("arguments.group_id")>
				and group_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.group_id#">
				</cfif>
				order by seq
			</cfquery>
			
			<cfreturn getForms>
		
	</cffunction>
	
	<cffunction
		name="getForm"
		access="public"
		returntype="query"
		description="Gets information about a single form">
		<cfargument name="form_id" type="string" required="Yes">
		
		<cfquery datasource="#session.dsn#" name="getForm">
			select form_id, content, name, filename, extension, active_flag, datecreated, linkURI, group_id, formType,
			dateupdated, createdUserID, updatedUserID, createdFname, createdLname, updatedFname, updatedLname
			from v_form
			where form_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.form_id#">
		</cfquery>
		
		<cfreturn getForm>
		
	</cffunction>
	
	<cffunction	
		name="deleteForm"
		access="public"
		description="Deletes a form from the db">
		<cfargument name="form_id" type="string" required="Yes">
		
		<cfquery datasource="#session.dsn#" name="deleteForm">
			delete from tbl_form
			where form_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.form_id#">
		</cfquery>
		
	</cffunction>
	
	<cffunction
		name="updatesequence"
		access="public"
		description="resequences forms">
		<cfargument name="tree" type="string" required="Yes">
		
		<cfstoredproc datasource="#session.dsn#" procedure="p_resequence_forms">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@tree" value="#arguments.tree#">
		</cfstoredproc>
		
	</cffunction>
	
</cfcomponent>