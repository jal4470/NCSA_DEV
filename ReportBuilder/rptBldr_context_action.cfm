<!----------------------------->
<!--- Application variables --->
<!----------------------------->
	<cfset reports_dsn = application.reports_dsn>
<!----------------------->
<!--- Local variables --->
<!----------------------->
<cfif isdefined("url.report_id")>
	<cfset report_id = url.report_id>
<cfelseif isdefined("form.report_id")>
	<cfset report_id = form.report_id>
<cfelse>
	<cfset report_id = "">
</cfif>

<cfif isdefined("url.report_type_id")>
	<cfset report_type_id = url.report_type_id>
<cfelseif isdefined("form.report_type_id")>
	<cfset report_type_id = form.report_type_id>
<cfelse>
	<cfset report_type_id = "">
</cfif>

<cfif isdefined("url.context_value")>
	<cfset context_value = url.context_value>
<cfelseif isdefined("form.context_value")>
	<cfset context_value = form.context_value>
<cfelse>
	<cfset context_value = 0>
</cfif>

<!------------------->
<!--- Validations --->
<!------------------->
<cfset error = "">

<cfif report_type_id EQ "">
	<cfset error = error & "<li>Report Type is a required field.</li>">
</cfif>
<!--- <cfif report_name EQ "">
	<cfset error = error & "<li>Report Name is a required field.</li>">
</cfif> --->

<!--- Return errors --->
<cfif error NEQ "">
	<cf_rptBldr_error error="Please correct the following errors before continuing:<ul>#error#</ul>">
</cfif>

<!-------------->
<!--- Action --->
<!-------------->
<cftry>
	<!--- Create report --->
	<cfif report_id EQ "">
		<CFSTOREDPROC datasource="#reports_dsn#" procedure="p_create_report" returncode="YES">
		<!--- 	<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#organization_id#" DBVARNAME="@organization_id"> --->
			<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#report_type_id#" DBVARNAME="@report_type_id">
			<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#context_value#" DBVARNAME="@context_value">
			<CFPROCPARAM TYPE="OUT" CFSQLTYPE="CF_SQL_INTEGER" VARIABLE="report_id" DBVARNAME="@report_id">
		</CFSTOREDPROC>

	<!--- Update report --->
	<cfelse>
		<CFSTOREDPROC datasource="#reports_dsn#" procedure="p_update_report" returncode="YES">
			<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#report_id#" DBVARNAME="@report_id">
			<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#report_type_id#" DBVARNAME="@report_type_id">
			<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#context_value#" DBVARNAME="@context_value">
		</CFSTOREDPROC>
	</cfif>

	<cfcatch>
		<cfdump var=#cfcatch#><cfabort>
	</cfcatch>
</cftry>

<!---------------->
<!--- Redirect --->
<!---------------->


<cfif isdefined("form.btnRun")>
	<cflocation url="rptBldr_display.cfm?report_id=#report_id#" addtoken="No">
<cfelseif isdefined("form.seljumpmenu") AND form.seljumpmenu NEQ "">
	<cflocation url="rptBldr_#form.seljumpmenu#.cfm?report_id=#report_id#" addtoken="No">
<cfelse>
	<cflocation url="rptBldr_format.cfm?report_id=#report_id#" addtoken="No">
</cfif>
