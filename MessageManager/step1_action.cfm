<!----------------------------->
<!--- Application variables --->
<!----------------------------->
	<cfset reports_dsn = application.reports_dsn>
<!----------------------->
<!--- Local variables --->
<!----------------------->
 <!--- validate login --->
 <cfmodule template="../_checkLogin.cfm">
<cfset error = "">
<cfif isdefined("url.report_id")>
	<cfset report_id = url.report_id>
<cfelseif isdefined("form.report_id")>
	<cfset report_id = form.report_id>
<cfelse>
	<cfset report_id = "">
</cfif>

<cfif isdefined("url.distribution_list_id") and len(trim(url.distribution_list_id))>
	<cfset distribution_list_id = url.distribution_list_id>
	<cfquery name="getDistReportType" datasource="#reports_dsn#">
		select report_type_id,allow_edits from tbl_distribution_list where distribution_list_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#distribution_list_id#">
	</cfquery>
	<cfset report_type_id = getDistReportType.report_type_id>
	<cfset allow_edits = getDistReportType.allow_edits>
<cfelseif isdefined("form.distribution_list_id") and len(trim(form.distribution_list_id))>
	<cfset distribution_list_id = form.distribution_list_id>
	<cfquery name="getDistReportType" datasource="#reports_dsn#">
		select report_type_id,allow_edits  from tbl_distribution_list where distribution_list_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#distribution_list_id#">
	</cfquery>
	<cfset report_type_id = getDistReportType.report_type_id>
	<cfset allow_edits = getDistReportType.allow_edits>
<cfelse>
	<cfset error = error & "<li>Please select a distribution list</li>">
	<cfset distribution_list_id = "">
	<cfset report_type_id = "">
	<cfset allow_edits =1>
</cfif>
<cfif isdefined("report_Type_id") and len(trim(report_type_id))>
	<cfquery name="getContextId" datasource="#application.reports_dsn#">
		select context_id from tbl_report_type where report_type_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#report_type_id#">
	</cfquery>
	<cfif getContextId.recordcount and len(trim(getContextId.context_id))>
		<cfset context_value = session.user.clubid>
	<cfelse>
		<cfset context_value = 0>
	</cfif>
</cfif>
<!--- <cfif isdefined("url.context_value")>
	<cfset context_value = url.context_value>
<cfelseif isdefined("form.context_value")>
	<cfset context_value = form.context_value>
<cfelse>
	<cfset context_value = 0>
</cfif> --->

<!------------------->
<!--- Validations --->
<!------------------->

<cfif not len(trim(form.subject))>
	<cfset error = error & "<li>Subject is a required field.</li>">
</cfif>
<cfif not len(trim(FORM.FROM_EMAIL))>
	<cfset error = error & "<li>From Email is a required field.</li>">
</cfif>
<cfif not len(trim(FORM.FROM_NAME))>
	<cfset error = error & "<li>From Name is a required field.</li>">
</cfif>

<!--- <cfif report_name EQ "">
	<cfset error = error & "<li>Report Name is a required field.</li>">
</cfif> --->

<!--- Return errors --->
<cfif error NEQ "">
	<cfmodule template="../ReportBuilder/rptBldr_error.cfm" error="Please correct the following errors before continuing:<ul>#error#</ul>">
</cfif>
<cfquery name="getDefaults" datasource="#application.dsn#">
		select _name, _value from tbl_global_vars where
		_name in ('from_Email_address','from_Email_alias')
		</cfquery>
		<cfset message_desc = "">
		<cfloop query="getDefaults">
			<cfset "#_name#" = "#_value#">
		</cfloop>
<!-------------->
<!--- Action --->
<!-------------->
<cftry>
	<!--- Create report --->
	<cfif report_id EQ "">
	<CFSTOREDPROC datasource="#application.dsn#" procedure="p_create_message_header" returncode="YES">
			<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#report_type_id#" DBVARNAME="@report_type_id">
			<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#context_value#" DBVARNAME="@context_value">
			<CFPROCPARAM TYPE="IN" cfsqltype="CF_SQL_VARCHAR" VALUE="#SUBJECT#" DBVARNAME="@message_desc">	
			<CFPROCPARAM TYPE="IN" cfsqltype="CF_SQL_VARCHAR" VALUE="#from_Email_address#" DBVARNAME="@from_email_address">	
			<CFPROCPARAM TYPE="IN" cfsqltype="CF_SQL_VARCHAR" VALUE="#from_Email_alias#" DBVARNAME="@from_email_alias">	
			<CFPROCPARAM TYPE="IN" cfsqltype="CF_SQL_VARCHAR" VALUE="#FORM.FROM_EMAIL#" DBVARNAME="@replyto_email_address">	
			<CFPROCPARAM TYPE="IN" cfsqltype="CF_SQL_VARCHAR" VALUE="#FORM.FROM_NAME#" DBVARNAME="@replyto_email_alias">	
			<CFPROCPARAM TYPE="IN" cfsqltype="CF_SQL_VARCHAR" VALUE="#SUBJECT#" DBVARNAME="@subject">	
			<cfprocparam type="in" cfsqltype="CF_SQL_VARCHAR" dbvarname="@cc_emails" null="Yes">
			<cfprocparam type="in" cfsqltype="CF_SQL_VARCHAR" dbvarname="@bcc_emails" null="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_BIT" value="1" dbvarname="@created_via_message_manager_flag">
			<cfprocparam type="in" cfsqltype="CF_SQL_INTEGER" value="#form.contactid#" dbvarname="@contactid">
			<cfprocparam type="in" cfsqltype="CF_SQL_INTEGER" value="#form.clubid#" dbvarname="@clubid">
			<cfprocparam type="in" cfsqltype="CF_SQL_INTEGER" value="#distribution_list_id#" dbvarname="@distribution_list_id"><!--- Add Distribution List --->
			<CFPROCPARAM TYPE="OUT" CFSQLTYPE="CF_SQL_INTEGER" VARIABLE="message_id" DBVARNAME="@message_id">
		</CFSTOREDPROC>
		<cfquery name="getReportId" datasource="#application.dsn#">
			select report_id from tbl_message where message_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#message_id#">
		</cfquery>
		<cfset report_id = getReportId.report_id>
		
	<!--- Update report --->
	<cfelse>
		<cfquery name="checkDistList" datasource="#reports_dsn#">
			select distinct distribution_list_id from tbl_report where report_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#report_id#">
		</cfquery>
		<cfset existing_dist_list_id = checkDistList.distribution_list_id>
		<cfif existing_dist_list_id neq distribution_list_id><!--- Check if user changed the Distribution List Selection  --->
		<!--- If selection was changed remove the existing Distribution List values --->
			<cfstoredproc datasource="#reports_dsn#" procedure="p_clear_report_criteria_dist_only">
				<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#report_id#" DBVARNAME="@report_id">
				<cfprocparam type="in" cfsqltype="CF_SQL_INTEGER" value="#distribution_list_id#" dbvarname="@distribution_list_id">
				<cfprocparam type="in" cfsqltype="CF_SQL_INTEGER" value="#distribution_list_id#" dbvarname="@existing_dist_list_id">
			</cfstoredproc> 
		</cfif>
		<CFSTOREDPROC datasource="#reports_dsn#" procedure="p_update_report" returncode="YES">
			<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#report_id#" DBVARNAME="@report_id">
			<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#report_type_id#" DBVARNAME="@report_type_id">
			<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#context_value#" DBVARNAME="@context_value">
			<cfprocparam type="in" cfsqltype="CF_SQL_INTEGER" value="#distribution_list_id#" dbvarname="@distribution_list_id"><!--- Add Distribution List --->
		</CFSTOREDPROC>
			<cfquery name="getMessageId" datasource="#application.dsn#">
			select message_id from tbl_message where report_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#report_id#">
		</cfquery>

		<cfset message_id = getMessageId.message_id>
	</cfif>
 
   
 
	<cfcatch>
		<cfdump var=#cfcatch#><cfabort>
	</cfcatch>
</cftry>
<cfquery datasource="#reports_dsn#" name="updateReportFormat">
	update tbl_report
	set report_format_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="5"><!--- Default to Message Manager --->
	where report_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#report_id#">
</cfquery>
<!--- Replicate Predifined Report Criteria --->


<cfstoredproc datasource="#reports_dsn#" procedure="p_set_distribution_list_report_criteria">
	<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#report_id#" DBVARNAME="@report_id">
	<cfprocparam type="in" cfsqltype="CF_SQL_INTEGER" value="#distribution_list_id#" dbvarname="@distribution_list_id">
</cfstoredproc>
<cftry>
<cfstoredproc datasource="#reports_dsn#" procedure="p_set_message_recipients">
	<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@sql_val" null="Yes" type="In">
	<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@message_id" type="In" value="#message_id#">
</cfstoredproc>
<cfcatch>	<cfmodule template="../ReportBuilder/rptBldr_error.cfm" error="There was an error trying to process this distribution list. Please select a different distribution list or navigate to the distribution list maintenance to fix the issue"></cfcatch>
</cftry>
<!---------------->
<!--- Redirect --->
<!---------------->


<!--- <cfif isdefined("form.btnRun")>
	<cflocation url="rptBldr_display.cfm?report_id=#report_id#" addtoken="No">
<cfelseif isdefined("form.seljumpmenu") AND form.seljumpmenu NEQ "">
	<cflocation url="rptBldr_#form.seljumpmenu#.cfm?report_id=#report_id#" addtoken="No">
<cfelse> --->

<cfif not allow_edits>
	<cflocation url="Step3.cfm?report_id=#report_id#&message_id=#message_id#&allowedits=0" addtoken="No">
<cfelse>
	<cflocation url="Step2.cfm?report_id=#report_id#" addtoken="No">
</cfif>
<!--- </cfif> --->
