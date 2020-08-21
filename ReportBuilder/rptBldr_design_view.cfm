<cfsetting showdebugoutput="no">
<!----------------------------->
<!--- Application variables --->
<!----------------------------->
<cfsetting requesttimeout="10000">
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

<!---------------->
<!--- Get data --->
<!---------------->
<cftry>

	<cfquery datasource="#reports_dsn#" name="getReport">
	SELECT report_name,
		count_flag,
		report_format_id,
		report_type_id,
		date_range_item_val,
		design_id
	  FROM tbl_report
	 WHERE report_id = <cfqueryparam value="#report_id#">
	</cfquery>
	
	
	<CFSTOREDPROC datasource="#reports_dsn#" procedure="p_run_report" returncode="YES" >
		<CFPROCRESULT name="getData" RESULTSET="1">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#report_id#" DBVARNAME="@report_id">
	</CFSTOREDPROC>
	
	
	<!--- get column names for report --->
	<cfquery datasource="#reports_dsn#" name="getDesignCols">
		select a.name, a.view_col_id, b.view_col_name, b.view_col_display_label, c.name as design_name, c.cfr_file
		from xref_design_view_col a
		inner join tbl_view_column b
		on a.view_col_id=b.view_col_id
		inner join tbl_design c
		on a.design_id=c.design_id
		where a.design_id=#getReport.design_id#
	</cfquery>
		
	<cfset fieldlist="">
	<cfloop query="getDesignCols">
		<cfset fieldlist=listappend(fieldlist,"#replace(view_col_display_label," ","_","all")# as #name#",", ")>
	</cfloop>

	<!--- get columns from report data with proper name for cfr --->
	<cfquery dbtype="query" name="rptqry">
	select distinct #fieldlist#
	from getData
	</cfquery>


	<cfreport format="PDF" template="#getDesignCols.cfr_file#" name="rptout" query="#rptqry#"></cfreport>
	
	
	<cfheader name="Content-Disposition" value="filename=#replace(getDesignCols.design_name," ","_","all")#.pdf">
	<cfcontent variable="#rptout#" type="application/pdf">


	<cfcatch>
		<cfinclude template="cfcatch.cfm">
	</cfcatch>
</cftry>	
	
	
	
	
	