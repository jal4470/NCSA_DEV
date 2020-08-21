<!----------------------------->
<!--- Application variables --->
<!----------------------------->
<cflock scope="application" type="readonly" timeout="10">
	<cfset reports_dsn = application.reports_dsn>
</cflock>


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

<cfif isdefined("url.count_flag")>
	<cfset count_flag = url.count_flag>
<cfelseif isdefined("form.count_flag")>
	<cfset count_flag = form.count_flag>
<cfelse>
	<cfset count_flag = "0">
</cfif>

<!------------------->
<!--- Validations --->
<!------------------->
<cfset error = "">

<cfif report_id EQ "">
	<cfset error = error & "<li>System error: cannot determine report.</li>">
</cfif>

<!--- Return errors --->
<cfif error NEQ "">
	<cf_rptBldr_error error="Please correct the following errors before continuing:<ul>#error#</ul>">
</cfif>

<!---------------->
<!--- Get data --->
<!---------------->
<!--- <cftry> --->
	<cfquery datasource="#reports_dsn#" name="getReport">
	select report_name,
	       report_type_id
	  from tbl_report
	 where report_id = <cfqueryparam value="#report_id#">
	</cfquery>
	
	<cfquery datasource="#reports_dsn#" name="getColumns">
	select view_col_id
	  from v_report_columns
	 where report_type_id = <cfqueryparam value="#getReport.report_type_id#">
	   and allow_aggr_flag = 1
	order by view_col_id
	</cfquery>

<!--- 	<cfcatch>
		<cfinclude template="cfcatch.cfm">
	</cfcatch>
</cftry> --->

<!-------------->
<!--- Action --->
<!-------------->
<!--- <cftry> --->
	<!--- Remove aggregate columns --->
	<CFSTOREDPROC datasource="#reports_dsn#" procedure="p_clear_report_aggregates" returncode="YES" >
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#report_id#" DBVARNAME="@report_id">
	</CFSTOREDPROC>

	<!--- Set report count_flag --->
	<CFSTOREDPROC datasource="#reports_dsn#" procedure="p_set_report_count_flag" returncode="YES" >
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#report_id#" DBVARNAME="@report_id">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_BIT" VALUE="#count_flag#" DBVARNAME="@count_flag">
	</CFSTOREDPROC>

	<!--- Loop through aggregate fields from view --->
	<cfoutput query="getColumns">
		<cfif isdefined("form.view_col_id_#view_col_id#_sum")>
			<cfset sum_flag = 1>
		<cfelse>
			<cfset sum_flag = 0>
		</cfif>
		<cfif isdefined("form.view_col_id_#view_col_id#_avg")>
			<cfset avg_flag = 1>
		<cfelse>
			<cfset avg_flag = 0>
		</cfif>
		<cfif isdefined("form.view_col_id_#view_col_id#_max")>
			<cfset max_flag = 1>
		<cfelse>
			<cfset max_flag = 0>
		</cfif>
		<cfif isdefined("form.view_col_id_#view_col_id#_min")>
			<cfset min_flag = 1>
		<cfelse>
			<cfset min_flag = 0>
		</cfif>
		
		<cfif sum_flag OR avg_flag OR max_flag OR min_flag><!--- only call proc if at least one value is 1 --->
			<!--- Create or update aggregate record --->
			<CFSTOREDPROC datasource="#reports_dsn#" procedure="p_create_report_aggregate" returncode="YES" >
				<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#report_id#" DBVARNAME="@report_id">
				<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#view_col_id#" DBVARNAME="@view_col_id">
				<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_BIT" VALUE="0" DBVARNAME="@count_flag">
				<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_BIT" VALUE="#sum_flag#" DBVARNAME="@sum_flag">
				<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_BIT" VALUE="#avg_flag#" DBVARNAME="@avg_flag">
				<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_BIT" VALUE="#max_flag#" DBVARNAME="@max_flag">
				<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_BIT" VALUE="#min_flag#" DBVARNAME="@min_flag">
			</CFSTOREDPROC>
		</cfif>
	</cfoutput>

<!--- 	<cfcatch>
		<cfinclude template="cfcatch.cfm">
	</cfcatch>
</cftry> --->

<!---------------->
<!--- Redirect --->
<!---------------->
<cfif isdefined("form.btnback")>
	<cflocation url="rptBldr_cols.cfm?report_id=#report_id#" addtoken="No">
<cfelseif isdefined("form.btnRun")>
	<cflocation url="rptBldr_display.cfm?report_id=#report_id#" addtoken="No">
<cfelseif isdefined("form.seljumpmenu") AND form.seljumpmenu NEQ "">
	<cflocation url="rptBldr_#form.seljumpmenu#.cfm?report_id=#report_id#" addtoken="No">
<cfelse>
	<cflocation url="rptBldr_order.cfm?report_id=#report_id#" addtoken="No">
</cfif>