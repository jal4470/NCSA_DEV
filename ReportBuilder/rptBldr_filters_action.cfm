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

<cfif isdefined("url.serializedCriteria")>
	<cfset serializedCriteria = url.serializedCriteria>
<cfelseif isdefined("form.serializedCriteria")>
	<cfset serializedCriteria = form.serializedCriteria>
<cfelse>
	<cfset serializedCriteria = "[]">
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





<!-------------->
<!--- Action --->
<!-------------->
<cftry>


	<!--- clear current criteria --->	
	<CFSTOREDPROC datasource="#reports_dsn#" procedure="p_clear_report_criteria" >
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#report_id#" DBVARNAME="@report_id">
	</CFSTOREDPROC>
	
	
	<!--- Set date filter --->
	<CFSTOREDPROC datasource="#reports_dsn#" procedure="p_set_date_filter" returncode="YES" >
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#report_id#" DBVARNAME="@report_id">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#view_col_id#" DBVARNAME="@view_col_id" NULL="#YesNoFormat(view_col_id EQ "")#">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#start_date#" DBVARNAME="@start_date" NULL="#YesNoFormat(start_date EQ "")#">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#end_date#" DBVARNAME="@end_date" NULL="#YesNoFormat(end_date EQ "")#">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#duration#" DBVARNAME="@item_val">
	</CFSTOREDPROC>
	
	<!--- make cf object from json --->
	<cfinvoke
		component="json"
		method="decode"
		data="#serializedCriteria#"
		returnvariable="arrcriteria">
		
	
	<!--- loop over criteria filters --->
	<cfloop index="i" from="1" to="#arraylen(arrcriteria)#">
		<cfdump var=#arrcriteria[i]#>
		
		<cfif <!--- arrcriteria[i].value NEQ "" AND  --->arrcriteria[i].view_col_id NEQ "">
			<CFSTOREDPROC datasource="#reports_dsn#" procedure="p_set_report_criteria" >
				<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#report_id#" DBVARNAME="@report_id">
				<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#arrcriteria[i].view_col_id#" DBVARNAME="@view_col_id">
				<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#arrcriteria[i].operand_id#" DBVARNAME="@operand_id">
				<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#arrcriteria[i].value#" DBVARNAME="@value">
				<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#arrcriteria[i].view_col_value#" DBVARNAME="@view_col_value" null="#yesnoformat(arrcriteria[i].view_col_value EQ "")#">
			</CFSTOREDPROC>
		</cfif>
		
		
	</cfloop>
	
	<cfcatch>
		<cfinclude template="cfcatch.cfm">
	</cfcatch>
</cftry>

<cfquery datasource="#application.reports_dsn#" name="getreportformat">
	select report_format_id from tbl_report
	where report_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#report_id#">
</cfquery>
<cfset report_format_id=getreportformat.report_format_id>
<!---------------->
<!--- Redirect --->
<!---------------->
<cfif isdefined("form.btnBack")>
	<cfif report_format_id EQ 3>
		<cflocation url="rptBldr_groups.cfm?report_id=#report_id#" addtoken="No">
	<cfelseif report_format_id EQ 4>
		<cflocation url="rptBldr_design_format.cfm?report_id=#report_id#" addtoken="No">
	<cfelse>
		<cflocation url="rptBldr_order.cfm?report_id=#report_id#" addtoken="No">
	</cfif>
<cfelseif isdefined("form.btnRun")>
	<cflocation url="rptBldr_display.cfm?report_id=#report_id#" addtoken="No">
<cfelseif isdefined("form.seljumpmenu") AND form.seljumpmenu NEQ "">
	<cflocation url="rptBldr_#form.seljumpmenu#.cfm?report_id=#report_id#" addtoken="No">
<cfelse>
	<cfif report_format_id EQ 2>
		<cflocation url="rptBldr_groups.cfm?report_id=#report_id#" addtoken="No">
	<cfelse>
		<cflocation url="rptBldr_display.cfm?report_id=#report_id#" addtoken="No">
	</cfif>
</cfif>
