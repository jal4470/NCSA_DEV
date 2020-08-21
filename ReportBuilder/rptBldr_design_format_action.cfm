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

<cfif isdefined("url.design_id")>
	<cfset design_id = url.design_id>
<cfelseif isdefined("form.design_id")>
	<cfset design_id = form.design_id>
<cfelse>
	<cfset design_id = "">
</cfif>


<!------------------->
<!--- Validations --->
<!------------------->
<cfset error = "">

<cfif report_id EQ "">
	<cfset error = error & "<li>System error: cannot determine report.</li>">
</cfif>

<cfif design_id EQ "">
	<cfset error = error & "<li>Please select a report label format.</li>">
</cfif>

<!--- Return errors --->
<cfif error NEQ "">
	<cf_rptBldr_error error="Please correct the following errors before continuing:<ul>#error#</ul>">
</cfif>



<!--- update report format id --->
<cfquery datasource="#reports_dsn#" name="updateReportFormat">
	update tbl_report
	set design_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#design_id#">
	where report_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#report_id#">
</cfquery>

<!--- set report columns to columns necessary for this design --->
<cfquery datasource="#reports_dsn#" name="getDesignCols">
	select view_col_id
	from xref_design_view_col
	where design_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#design_id#">
</cfquery>

<CFSTOREDPROC datasource="#reports_dsn#" procedure="p_set_report_cols" returncode="YES" >
	<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#report_id#" DBVARNAME="@report_id">
	<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#valuelist(getDesignCols.view_col_id,",")#" DBVARNAME="@view_col_id">
</CFSTOREDPROC>



<!---------------->
<!--- Redirect --->
<!---------------->
<cfif isdefined("form.btnback")>
	<cflocation url="rptBldr_format.cfm?s=#securestring#&report_id=#report_id#" addtoken="No">
<cfelseif isdefined("form.btnRun")>
	<cflocation url="rptBldr_display.cfm?s=#securestring#&report_id=#report_id#" addtoken="No">
<cfelseif isdefined("form.seljumpmenu") AND form.seljumpmenu NEQ "">
	<cflocation url="rptBldr_#form.seljumpmenu#.cfm?s=#securestring#&report_id=#report_id#" addtoken="No">
<cfelse>
	<cflocation url="rptBldr_filters.cfm?s=#securestring#&report_id=#report_id#" addtoken="No">
</cfif>
