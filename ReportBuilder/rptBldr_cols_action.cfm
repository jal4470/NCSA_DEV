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

<cfif isdefined("url.view_col_id")>
	<cfset view_col_id = url.view_col_id>
<cfelseif isdefined("form.view_col_id")>
	<cfset view_col_id = form.view_col_id>
<cfelse>
	<cfset view_col_id = "">
</cfif>

<!------------------->
<!--- Validations --->
<!------------------->
<cfset error = "">

<cfif report_id EQ "">
	<cfset error = error & "<li>System error: cannot determine report.</li>">
</cfif>

<cfif view_col_id EQ "">
	<cfset error = error & "<li>Please select at least one column.</li>">
</cfif>

<!--- Return errors --->
<cfif error NEQ "">
	<cf_rptBldr_error error="Please correct the following errors before continuing:<ul>#error#</ul>">
</cfif>


<!-------------->
<!--- Action --->
<!-------------->
<!--- <cftry> --->
	<CFSTOREDPROC datasource="#reports_dsn#" procedure="p_set_report_cols" returncode="YES" >
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#report_id#" DBVARNAME="@report_id">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#view_col_id#" DBVARNAME="@view_col_id">
	</CFSTOREDPROC>
	
	<!--- save dynamic fields --->
	<cfloop list="#form.fieldnames#" index="i">
		<cfif findnocase("dynamic_col_",i) NEQ 0>
			<cfset fieldList=form[i]>
			<cfset view_col_id=replacenocase(i,"dynamic_col_","")>
			
			<CFSTOREDPROC datasource="#reports_dsn#" procedure="p_set_dynamic_report_cols" returncode="YES" >
				<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#report_id#" DBVARNAME="@report_id">
				<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#view_col_id#" DBVARNAME="@view_col_id">
				<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#fieldList#" DBVARNAME="@id_list">
			</CFSTOREDPROC>
			
		</cfif>
	</cfloop>

<!--- 	<cfcatch>
		<cfinclude template="cfcatch.cfm">
	</cfcatch>
</cftry> --->

<cfquery datasource="#application.reports_dsn#" name="getreportformat">
	select report_format_id from tbl_report
	where report_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#report_id#">
</cfquery>
<cfset report_format_id=getreportformat.report_format_id>
<!---------------->
<!--- Redirect --->
<!---------------->
<cfif isdefined("form.btnback")>
	<cflocation url="rptBldr_format.cfm?report_id=#report_id#" addtoken="No">
<cfelseif isdefined("form.btnRun")>
	<cflocation url="rptBldr_display.cfm?report_id=#report_id#" addtoken="No">
<cfelseif isdefined("form.seljumpmenu") AND form.seljumpmenu NEQ "">
	<cflocation url="rptBldr_#form.seljumpmenu#.cfm?report_id=#report_id#" addtoken="No">
<cfelse>
	<cfif report_format_id EQ 3>
		<cflocation url="rptBldr_groups.cfm?report_id=#report_id#" addtoken="No">
	<cfelse>
		<cflocation url="rptBldr_totals.cfm?report_id=#report_id#" addtoken="No">
	</cfif>
</cfif>
