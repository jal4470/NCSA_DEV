<!----------------------------->
<!--- Application variables --->
<!----------------------------->
<cflock scope="application" type="readonly" timeout="10">
	<cfset reports_dsn = application.reports_dsn>
</cflock>

<!--- Security --->
<cfinclude template="_secureme.cfm">

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

<cfdump var=#form#>

<!--- convert json --->
<cfif form.row_fields NEQ "">
	<cfinvoke
		component="json"
		method="decode"
		data="#form.row_fields#"
		returnvariable="row_fields">
<cfelse>
	<cfset row_fields=arraynew(1)>
</cfif>

<cfif form.col_fields NEQ "">
	<cfinvoke
		component="json"
		method="decode"
		data="#form.col_fields#"
		returnvariable="col_fields">
<cfelse>
	<cfset col_fields=arraynew(1)>
</cfif>

<cfif form.tot_fields NEQ "">
	<cfinvoke
		component="json"
		method="decode"
		data="#form.tot_fields#"
		returnvariable="tot_fields">
<cfelse>
	<cfset tot_fields=arraynew(1)>
</cfif>
	
<cfdump var=#row_fields#>
<cfdump var=#col_fields#>
<cfdump var=#tot_fields#>


<!--- clear report groups --->
<cfquery datasource="#reports_dsn#" name="clearReportGroups">
	delete from tbl_report_group
	where report_id = <cfqueryparam value="#report_id#">
</cfquery>

<cfloop from="1" to="#arraylen(row_fields)#" index="i">
	<cfif structkeyexists(row_fields[i],"report_group_format_id")>
		<cfset report_group_format_id=row_fields[i].report_group_format_id>
	<cfelse>
		<cfset report_group_format_id="">
	</cfif>
	<cfstoredproc datasource="#reports_dsn#" procedure="p_create_report_group">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@report_id" type="In" value="#report_id#">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@view_col_id" type="In" value="#row_fields[i].view_col_id#">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@view_col_value" type="In" value="#row_fields[i].view_col_value#" null="#yesnoformat(row_fields[i].view_col_value EQ "")#">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@report_group_type_id" type="In" value="1">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@report_group_format_id" type="In" value="#report_group_format_id#" null="#yesnoformat(report_group_format_id EQ "")#">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@seq" type="In" value="#i#">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@report_group_id" type="Out" variable="report_group_id_row#i#">
	</cfstoredproc>
</cfloop>

<cfloop from="1" to="#arraylen(col_fields)#" index="i">
	<cfif structkeyexists(col_fields[i],"report_group_format_id")>
		<cfset report_group_format_id=col_fields[i].report_group_format_id>
	<cfelse>
		<cfset report_group_format_id="">
	</cfif>
	<cfstoredproc datasource="#reports_dsn#" procedure="p_create_report_group">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@report_id" type="In" value="#report_id#">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@view_col_id" type="In" value="#col_fields[i].view_col_id#">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@view_col_value" type="In" value="#col_fields[i].view_col_value#" null="#yesnoformat(col_fields[i].view_col_value EQ "")#">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@report_group_type_id" type="In" value="2">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@report_group_format_id" type="In" value="#report_group_format_id#" null="#yesnoformat(report_group_format_id EQ "")#">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@seq" type="In" value="#i#">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@report_group_id" type="Out" variable="report_group_id_col#i#">
	</cfstoredproc>
</cfloop>

<!--- Remove aggregate columns --->
<CFSTOREDPROC datasource="#reports_dsn#" procedure="p_clear_report_aggregates" returncode="YES" >
	<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#report_id#" DBVARNAME="@report_id">
</CFSTOREDPROC>
<cfloop from="1" to="#arraylen(tot_fields)#" index="i">
	<cfset count_flag="1">
	<cfset sum_flag="0">
	<cfset avg_flag="0">
	<cfset min_flag="0">
	<cfset max_flag="0">
	<cfif structkeyexists(tot_fields[i],"count_flag")>
		<cfset count_flag=tot_fields[i].count_flag>
	</cfif>
	<cfif structkeyexists(tot_fields[i],"sum_flag")>
		<cfset sum_flag=tot_fields[i].sum_flag>
	</cfif>
	<cfif structkeyexists(tot_fields[i],"avg_flag")>
		<cfset avg_flag=tot_fields[i].avg_flag>
	</cfif>
	<cfif structkeyexists(tot_fields[i],"min_flag")>
		<cfset min_flag=tot_fields[i].min_flag>
	</cfif>
	<cfif structkeyexists(tot_fields[i],"max_flag")>
		<cfset max_flag=tot_fields[i].max_flag>
	</cfif>

	<CFSTOREDPROC datasource="#reports_dsn#" procedure="p_create_report_aggregate" returncode="YES" >
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#report_id#" DBVARNAME="@report_id">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#tot_fields[i].view_col_id#" DBVARNAME="@view_col_id">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_BIT" VALUE="#count_flag#" DBVARNAME="@count_flag">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_BIT" VALUE="#sum_flag#" DBVARNAME="@sum_flag">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_BIT" VALUE="#avg_flag#" DBVARNAME="@avg_flag">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_BIT" VALUE="#max_flag#" DBVARNAME="@max_flag">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_BIT" VALUE="#min_flag#" DBVARNAME="@min_flag">
	</CFSTOREDPROC>
</cfloop>


<!---------------->
<!--- Redirect --->
<!---------------->
<cfif isdefined("form.btnback")>
	<cflocation url="rptBldr_cols.cfm?s=#securestring#&report_id=#report_id#" addtoken="No">
<cfelseif isdefined("form.btnRun")>
	<cflocation url="rptBldr_display.cfm?s=#securestring#&report_id=#report_id#" addtoken="No">
<cfelseif isdefined("form.seljumpmenu") AND form.seljumpmenu NEQ "">
	<cflocation url="rptBldr_#form.seljumpmenu#.cfm?s=#securestring#&report_id=#report_id#" addtoken="No">
<cfelse>
	<cflocation url="rptBldr_filters.cfm?s=#securestring#&report_id=#report_id#" addtoken="No">
</cfif>