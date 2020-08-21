<!--- save dates --->
<cfsetting showdebugoutput="Yes">
<!----------------------------->
<!--- Application variables --->
<!----------------------------->
<cfsetting requesttimeout="10000">
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


<cfif isdefined("url.date_view_col_id")>
	<cfset view_col_id = url.date_view_col_id>
<cfelseif isdefined("form.date_view_col_id")>
	<cfset view_col_id = form.date_view_col_id>
<cfelse>
	<cfset view_col_id = "">
</cfif>

<cfif isdefined("url.start_date")>
	<cfset start_date = url.start_date>
<cfelseif isdefined("form.start_date")>
	<cfset start_date = form.start_date>
<cfelse>
	<cfset start_date = "">
</cfif>

<cfif isdefined("url.end_date")>
	<cfset end_date = url.end_date>
<cfelseif isdefined("form.end_date")>
	<cfset end_date = form.end_date>
<cfelse>
	<cfset end_date = "">
</cfif>

<cfif isdefined("url.duration")>
	<cfset duration = url.duration>
<cfelseif isdefined("form.duration")>
	<cfset duration = form.duration>
<cfelse>
	<cfset duration = "">
</cfif>

<!------------------->
<!--- Validations --->
<!------------------->
<cfinclude template="../UDF_isValidDate.cfm">
<cfset error = "">

<cfif report_id EQ "">
	<cfset error = error & "<li>System error: cannot determine report.</li>">
</cfif>

<cfif view_col_id NEQ "" AND (start_date EQ "" OR end_date EQ "")>
	<cfset error = error & "<li>Please enter a start date and an end date</li>">
</cfif>

<cfif view_col_id NEQ "" AND NOT isValidDate(start_date)>
	<cfset error = error & "<li>'#start_date#' is not a valid start date</li>">
</cfif>

<cfif view_col_id NEQ "" AND NOT isValidDate(end_date)>
	<cfset error = error & "<li>'#start_date#' is not a valid end date</li>">
</cfif>

<!--- Return errors --->
<cfif error NEQ "">
	<cf_rptBldr_error error="Please correct the following errors before continuing:<ul>#error#</ul>">
</cfif>


<!--- Set date filter --->
<CFSTOREDPROC datasource="#reports_dsn#" procedure="p_set_date_filter" returncode="YES" >
	<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#report_id#" DBVARNAME="@report_id">
	<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#view_col_id#" DBVARNAME="@view_col_id" NULL="#YesNoFormat(view_col_id EQ "")#">
	<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#start_date#" DBVARNAME="@start_date" NULL="#YesNoFormat(start_date EQ "")#">
	<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#end_date#" DBVARNAME="@end_date" NULL="#YesNoFormat(end_date EQ "")#">
	<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#duration#" DBVARNAME="@item_val">
</CFSTOREDPROC>


<!--- redirect back to report --->
<cflocation url="rptBldr_display.cfm?report_id=#report_id#" addtoken="No">