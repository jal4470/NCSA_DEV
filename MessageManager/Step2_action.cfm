<!----------------------------->
<!--- Application variables --->
<!----------------------------->
<cflock scope="application" type="readonly" timeout="10">
	<cfset reports_dsn = application.reports_dsn>
</cflock>

 <!--- validate login --->
 <cfmodule template="../_checkLogin.cfm">
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
<!--- <cfinclude template="../UDF_isValidDate.cfm"> --->
<cfset error = "">

<cfif report_id EQ "">
	<cfset error = error & "<li>System error: cannot determine report.</li>">
</cfif>

<cfif view_col_id NEQ "" AND (start_date EQ "" OR end_date EQ "")>
	<cfset error = error & "<li>Please enter a start date and an end date</li>">
</cfif>

<cfif view_col_id NEQ "" AND NOT isValid("date", start_date)>
	<cfset error = error & "<li>'#start_date#' is not a valid start date</li>">
</cfif>

<cfif view_col_id NEQ "" AND NOT isValid("date", end_date)>
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


	<!--- clear current criteria
	<CFSTOREDPROC datasource="#reports_dsn#" procedure="p_clear_report_criteria_edit_only" >
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#report_id#" DBVARNAME="@report_id">
	</CFSTOREDPROC>	 --->
	
<!--- 	<!--- Set date filter --->
	<CFSTOREDPROC datasource="#reports_dsn#" procedure="p_set_date_filter" returncode="YES" >
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#report_id#" DBVARNAME="@report_id">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#view_col_id#" DBVARNAME="@view_col_id" NULL="#YesNoFormat(view_col_id EQ "")#">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#start_date#" DBVARNAME="@start_date" NULL="#YesNoFormat(start_date EQ "")#">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#end_date#" DBVARNAME="@end_date" NULL="#YesNoFormat(end_date EQ "")#">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#duration#" DBVARNAME="@item_val">
	</CFSTOREDPROC> --->
	
	<!--- make cf object from json --->
	<cfinvoke
		component="json"
		method="decode"
		data="#serializedCriteria#"
		returnvariable="arrcriteria">
		
	<cfset CritList = "">
	<cfset DeleteCrit = "">
	<!--- loop over criteria filters --->
	<cfloop index="i" from="1" to="#arraylen(arrcriteria)#">
		<cfif arrcriteria[i].view_col_id NEQ "" >
		<cfquery datasource="#reports_dsn#" name="checkIfEditable">
			select * from tbl_report_criteria where report_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#report_id#">
			and view_col_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arrcriteria[i].view_col_id#">
		</cfquery>
	
		
		
			<CFSTOREDPROC datasource="#reports_dsn#" procedure="p_set_report_criteria" >
				<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#report_id#" DBVARNAME="@report_id">
				<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#arrcriteria[i].view_col_id#" DBVARNAME="@view_col_id">
				<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#arrcriteria[i].operand_id#" DBVARNAME="@operand_id">
				<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#arrcriteria[i].value#" DBVARNAME="@value">
			</CFSTOREDPROC>
			<cfset CritList = ListAppend(CritList,arrcriteria[i].view_col_id)>
		</cfif>
		
		
	</cfloop>
	
	<cfquery name="getDeleteColumns" datasource="#reports_dsn#">
		select * from tbl_report_criteria where report_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#report_id#">
	</cfquery>
	
	<cfloop query="getDeleteColumns">
		<cfif not ListContains(CritList,view_col_id)>
			<cfset DeleteCrit = ListAppend(DeleteCrit,view_col_id)>
		</cfif>
	</cfloop>
	<cfloop list="#DeleteCrit#" index="i" delimiters=",">
		<CFSTOREDPROC datasource="#reports_dsn#" procedure="p_delete_report_col" >
			<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#report_id#" DBVARNAME="@report_id">
			<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#i#" DBVARNAME="@view_col_id">
		</CFSTOREDPROC>
	</cfloop>
	
	<cfcatch>
		<cfdump var="#cfcatch#">
	</cfcatch>
</cftry>

<cfquery datasource="#application.reports_dsn#" name="getreportformat">
	select report_format_id from tbl_report
	where report_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#report_id#">
</cfquery>
<cfset report_format_id=getreportformat.report_format_id>

<cfquery name="getMessageId" datasource="#application.dsn#">
	select message_id from tbl_message where report_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#report_id#">
</cfquery>

<cfset message_id = getMessageId.message_id>

<cfstoredproc datasource="#reports_dsn#" procedure="p_set_message_recipients">
	<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@sql_val" null="Yes" type="In">
	<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@message_id" type="In" value="#message_id#">
</cfstoredproc>

<!---------------->
<!--- Redirect --->
<!---------------->

<cflocation url="Step3.cfm?report_id=#report_id#&message_id=#message_id#" addtoken="No">
