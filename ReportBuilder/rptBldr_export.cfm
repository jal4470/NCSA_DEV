<cfsetting showdebugoutput="Yes">
<!----------------------------->
<!--- Application variables --->
<!----------------------------->
<cfsetting requesttimeout="10000">
<cflock scope="application" type="readonly" timeout="10">
	<cfset reports_dsn = application.reports_dsn>
</cflock>

<!--- Security --->
<cfinclude template="_secureme.cfm">

<!--- import symRound --->
<cfinclude template="symRound.cfm">

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

	
	
	<CFSTOREDPROC datasource="#reports_dsn#" procedure="p_run_report" returncode="YES" >
		<CFPROCRESULT name="getData" RESULTSET="1">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#report_id#" DBVARNAME="@report_id">
	</CFSTOREDPROC>


	
	<!--- get column list --->
	<CFSTOREDPROC datasource="#reports_dsn#" procedure="p_get_report_columns" returncode="YES" >
		<CFPROCRESULT name="qrycolumnlist" RESULTSET="1">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#report_id#" DBVARNAME="@report_id">
	</CFSTOREDPROC>


<cfquery datasource="#reports_dsn#" name="getReport">
	select report_name,
		report_type_id,
		context_value
	from tbl_report
	where report_id = <cfqueryparam value="#report_id#">
</cfquery>



	<cfcatch><cfdump var=#cfcatch#><cfabort>
		<cfinclude template="cfcatch.cfm">
	</cfcatch>
</cftry>
<!----------------->
<!--- Page body --->
<!----------------->
<cfheader name="content-disposition" value="attachment; filename=""#getReport.report_name#_#dateformat(now(),"m-d-yyyy")#.xls""" />
<cfcontent type="application/msexcel">
<html>
	<!--- <cfdump var=#getdata#>
	<cfdump var=#qrycolumnlist#> --->
	<head>
		<style>
			.th{
				font-weight:bold;
				text-decoration:underline;
			}
		</style>
	</head>
	<body>
		
		<table>
			<!--- header --->
			<tr>
				<cfloop query="qryColumnList">
					<cfoutput><th class="th">#label#</th></cfoutput>
				</cfloop>
			</tr>
			<cfloop query="getdata">
				<tr>
					<cfloop query="qryColumnList">
						<!--- get field, output --->
						<cfset value=getdata["#replace(qryColumnList.label," ","_","all")#"]>
						<cfif value EQ "">
							<cfset value="&nbsp;">
						</cfif>
						<!--- format value --->
						<!--- <cfif qryColumnList.xtype_cat EQ "N" AND isnumeric(value)>
							<cfset value=dollarformat(value)>
						</cfif> --->
						<cfif qryColumnlist.xtype_cat EQ "D" and isdate(value)>
							<cfset value=dateformat(value,"mm/dd/yyyy")>
						<cfelseif qryColumnlist.xtype EQ "60" and isNumeric(value)><!--- money --->
							<cfset value=dollarformat(value)>
						</cfif>
						<cfoutput><td>#value#</td></cfoutput>
					</cfloop>
				</tr>
			</cfloop>
		</table>
		
	</body>
</html>
</cfcontent>