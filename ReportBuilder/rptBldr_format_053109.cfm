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


<!---------------->
<!--- Get data --->
<!---------------->
<!--- <cftry> --->
<cfquery datasource="#reports_dsn#" name="getReport">
	select report_name,
		report_type_id,
		context_value,
		report_format_id
	from tbl_report
	where report_id = <cfqueryparam value="#report_id#">
</cfquery>

<cfquery datasource="#reports_dsn#" name="getFormats">
	select report_format_id, report_Format_desc
	from tlkp_report_format
	order by report_format_id
</cfquery>




<!--- <cfdump var=#getdynamicCols#> --->
<!--- 	<cfcatch>
<cfinclude template="cfcatch.cfm">
</cfcatch>
</cftry> --->

<!----------------->
<!--- Page body --->
<!----------------->
<html>
	<head>

	</head>
	<body>
		<b>Step 2: Select Report Format</b> <cfinclude template="tpl_rptBldr_save_report.cfm"><br>
	
		<cfoutput query="getReport">#report_name#</cfoutput><hr>
	
		<cfoutput>
			<form method="post" action="rptBldr_format_action.cfm">
			<input type="hidden" name="report_id" value="#report_id#">
		</cfoutput>
	
		<cfoutput>
			<div style="margin-top:15px; margin-bottom:20px;">
				Select Report Format: 
				<select name="report_format_id">
					<option value="">-- Report Format --</option>
					<cfloop query="getFormats">
						<option value="#report_format_id#" <cfif report_format_id EQ getreport.report_format_id>SELECTED="SELECTED"</cfif>>#report_format_desc#</option>
					</cfloop>
				</select>
			</div>
		</cfoutput>
	
		
		<!--- Buttons --->
		<cfoutput>
		
		<input type="submit" name="back" value="Back">
		<cfinclude template="tpl_rptBldr_jump_menu.cfm">
		<input type="submit" name="btnSave" value="Next">
		<input type="submit" name="btnRun" value="Run">
		<input type="button" name="cancel" value="Cancel" onclick="window.location='rptBldr_home.cfm';">
		</cfoutput>
	</body>
</html>

