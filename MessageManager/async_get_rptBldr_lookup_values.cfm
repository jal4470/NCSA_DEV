<cfsetting showdebugoutput="No" enablecfoutputonly="Yes">

<!--- get lookup values --->

<cftry>
<cfif isdefined("url.context_value")>
	<cfset context_value=url.context_value>
<cfelse>
	<cfthrow message="context value is not defined">
</cfif>

<cfif isdefined("url.view_col_id")>
	<cfset view_col_id=url.view_col_id>
<cfelse>
	<cfthrow message="view_col_id is not defined">
</cfif>

<cfstoredproc datasource="#application.reports_dsn#" procedure="p_get_lookup_values">
	<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@view_col_id" type="In" value="#view_col_id#">
	<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@context_value" type="In" value="#iif(len(trim(context_value)), de(context_value), de(0))#">
	<cfprocresult resultset="1" name="lookup_values">
</cfstoredproc>
<cfoutput>
	<cfloop query="lookup_values">
		<cfif value_label NEQ "">
			<div>
				<input type="Checkbox" name="lookup_value" value="#lookup_values.value_label#"> #lookup_values.value_label#
			</div>
		</cfif>
	</cfloop>
</cfoutput>

<cfcatch>
<!--- <cfheader statuscode="500"> --->
#cfcatch.detail#
</cfcatch>
</cftry>