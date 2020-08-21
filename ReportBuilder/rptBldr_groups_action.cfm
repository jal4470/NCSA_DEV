<!----------------------------->
<!--- Application variables --->
<!----------------------------->
<cflock scope="application" type="readonly" timeout="10">
	<cfset reports_dsn = application.reports_dsn>
</cflock>

<!--- Security --->
<cfinclude template="_secureme.cfm">

<!--- <cfdump var=#form#><cfabort> --->
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


<!-------------->
<!--- Action --->
<!-------------->

	<cfif not isdefined("form.report_group_format_id_1")>
		<cfset form.report_group_format_id_1="">
	</cfif>

	<cfif not isdefined("form.report_group_format_id_2")>
		<cfset form.report_group_format_id_2="">
	</cfif>

	<cfif not isdefined("form.report_group_format_id_3")>
		<cfset form.report_group_format_id_3="">
	</cfif>


	<cftry>
	<!--- clear report groups --->
	<cfquery datasource="#reports_dsn#" name="clearReportGroups">
		delete from tbl_report_group
		where report_id = <cfqueryparam value="#report_id#">
	</cfquery>
	
	<cfif isdefined("form.view_col_id_1") AND form.view_col_id_1 NEQ "">
		<cfif find("-",form.view_col_id_1) NEQ 0>
			<cfset view_col_id=gettoken(form.view_col_id_1,1,"-")>
			<cfset view_col_value=gettoken(form.view_col_id_1,2,"-")>
		<cfelse>
			<cfset view_col_id=form.view_col_id_1>
			<cfset view_col_value="">
		</cfif>
		<cfstoredproc datasource="#reports_dsn#" procedure="p_create_report_group">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@report_id" type="In" value="#report_id#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@view_col_id" type="In" value="#view_col_id#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@view_col_value" type="In" value="#view_col_value#" null="#yesnoformat(view_col_value EQ "")#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@report_group_type_id" type="In" value="1">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@report_group_format_id" type="In" value="#form.report_group_format_id_1#" null="#yesnoformat(report_group_format_id_1 EQ "")#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@seq" type="In" value="1">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@report_group_id" type="Out" variable="report_group_id1">
		</cfstoredproc>
		
		<cfif isdefined("form.view_col_id_2") AND form.view_col_id_2 NEQ "">
			<cfif find("-",form.view_col_id_2) NEQ 0>
				<cfset view_col_id=gettoken(form.view_col_id_2,1,"-")>
				<cfset view_col_value=gettoken(form.view_col_id_2,2,"-")>
			<cfelse>
				<cfset view_col_id=form.view_col_id_2>
			</cfif>
			<cfstoredproc datasource="#reports_dsn#" procedure="p_create_report_group">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@report_id" type="In" value="#report_id#">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@view_col_id" type="In" value="#view_col_id#">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@view_col_value" type="In" value="#view_col_value#" null="#yesnoformat(view_col_value EQ "")#">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@report_group_type_id" type="In" value="1">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@report_group_format_id" type="In" value="#form.report_group_format_id_2#" null="#yesnoformat(report_group_format_id_2 EQ "")#">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@seq" type="In" value="2">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@report_group_id" type="Out" variable="report_group_id2">
			</cfstoredproc>
			<cfif isdefined("form.view_col_id_3") AND form.view_col_id_3 NEQ "">
				<cfif find("-",form.view_col_id_3) NEQ 0>
					<cfset view_col_id=gettoken(form.view_col_id_3,1,"-")>
					<cfset view_col_value=gettoken(form.view_col_id_3,2,"-")>
				<cfelse>
					<cfset view_col_id=form.view_col_id_3>
				</cfif>
				<cfstoredproc datasource="#reports_dsn#" procedure="p_create_report_group">
					<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@report_id" type="In" value="#report_id#">
					<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@view_col_id" type="In" value="#view_col_id#">
					<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@view_col_value" type="In" value="#view_col_value#" null="#yesnoformat(view_col_value EQ "")#">
					<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@report_group_type_id" type="In" value="1">
					<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@report_group_format_id" type="In" value="#form.report_group_format_id_3#" null="#yesnoformat(report_group_format_id_3 EQ "")#">
					<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@seq" type="In" value="3">
					<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@report_group_id" type="Out" variable="report_group_id3">
				</cfstoredproc>
			</cfif>
		</cfif>
	</cfif>
	
	<cfcatch>
		<cfdump var=#cfcatcH#>
		<cfabort>
	</cfcatch>
	
	</cftry>
<!---------------->
<!--- Redirect --->
<!---------------->
<cfif isdefined("form.btnback")>
	<cflocation url="rptBldr_filters.cfm?s=#securestring#&report_id=#report_id#" addtoken="No">
<cfelseif isdefined("form.btnRun")>
	<cflocation url="rptBldr_display.cfm?s=#securestring#&report_id=#report_id#" addtoken="No">
<cfelseif isdefined("form.seljumpmenu") AND form.seljumpmenu NEQ "">
	<cflocation url="rptBldr_#form.seljumpmenu#.cfm?s=#securestring#&report_id=#report_id#" addtoken="No">
<cfelse>
	<cflocation url="rptBldr_display.cfm?s=#securestring#&report_id=#report_id#" addtoken="No">
</cfif>
