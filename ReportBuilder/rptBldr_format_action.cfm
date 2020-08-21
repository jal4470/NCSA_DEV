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

<cfif isdefined("url.report_format_id")>
	<cfset report_format_id = url.report_format_id>
<cfelseif isdefined("form.report_format_id")>
	<cfset report_format_id = form.report_format_id>
<cfelse>
	<cfset report_format_id = "">
</cfif>


<!------------------->
<!--- Validations --->
<!------------------->
<cfset error = "">

<cfif report_id EQ "">
	<cfset error = error & "<li>System error: cannot determine report.</li>">
</cfif>

<cfif report_format_id EQ "">
	<cfset error = error & "<li>Please select a report format.</li>">
</cfif>

<!--- Return errors --->
<cfif error NEQ "">
	<cf_rptBldr_error error="Please correct the following errors before continuing:<ul>#error#</ul>">
</cfif>



<!--- update report format id --->
<cfquery datasource="#reports_dsn#" name="updateReportFormat">
	update tbl_report
	set report_format_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#report_format_id#">
	where report_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#report_id#">
</cfquery>


<!---------------->
<!--- Redirect --->
<!---------------->
<cfif isdefined("form.btnback")>
	<cflocation url="rptBldr_context.cfm?report_id=#report_id#" addtoken="No">
<cfelseif isdefined("form.btnRun")>
	<cflocation url="rptBldr_display.cfm?report_id=#report_id#" addtoken="No">
<cfelseif isdefined("form.seljumpmenu") AND form.seljumpmenu NEQ "">
	<cflocation url="rptBldr_#form.seljumpmenu#.cfm?report_id=#report_id#" addtoken="No">
<cfelse>
	<cfif report_format_id EQ 4><!--- labels --->
		<cflocation url="rptBldr_design_format.cfm?report_id=#report_id#" addtoken="No">
	<cfelse>
		<cflocation url="rptBldr_cols.cfm?report_id=#report_id#" addtoken="No">
	</cfif>
</cfif>
