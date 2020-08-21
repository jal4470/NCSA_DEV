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

<cfset cols_per_row = 4>
<cfset colWidth=100/cols_per_row>

<!---------------->
<!--- Get data --->
<!---------------->
<!--- <cftry> --->
<cfquery datasource="#reports_dsn#" name="getReport">
	select report_name,
		report_type_id,
		context_value
	from tbl_report
	where report_id = <cfqueryparam value="#report_id#">
</cfquery>

<cfquery datasource="#reports_dsn#" name="getColumns">
	select a.view_col_id,
		a.view_col_display_label,
		a.view_col_group_name
	from v_report_columns a
	where a.report_type_id = <cfqueryparam value="#getReport.report_type_id#">
	  and allow_select_flag = 1
	order by a.view_col_group_name,
		a.view_col_name
</cfquery>

<!--- get dynamic columns --->
<cfquery datasource="#reports_dsn#" name="getDynamicCols">
	select b.view_id, b.view_name, b.view_name_fully_qualified, b.view_display_label, c.view_col_id, c.view_col_display_label
		from xref_report_type_view a
	inner join tbl_view b
		on a.view_id=b.view_id
	inner join tbl_view_column c
		on c.view_id=b.view_id
	where report_type_id=<cfqueryparam value="#getReport.report_type_id#">
		and view_type_id=2
</cfquery>


	
<!--- get selected columns --->
<cfquery datasource="#reports_dsn#" name="getSelectedColumns">
select view_col_id,
       view_col_value
  from tbl_report_col
 where report_id = <cfqueryparam value="#report_id#">
</cfquery>

<!--- get static cols --->
<cfquery dbtype="query" name="getStaticCols">
	select view_col_id
	from getSelectedColumns
	where view_col_value is null
</cfquery>
<cfset lStaticCols = valuelist(getStaticCols.view_col_id)>


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
		<script language="JavaScript" type="text/javascript" src="assets/jquery-1.3.2.min.js"></script>
		<script language="JavaScript" type="text/javascript">
		var context_id;
		$(document).ready(function()
		{
		
			$("input[name=selectAll]").click(function(){
				if($(this).is(":checked"))
				{
					$(this).parent().parent().next().find("input[type=checkbox]").attr('checked','checked');
				}
				else
				{
					$(this).parent().parent().next().find("input[type=checkbox]").attr('checked','');
				}
			});
			
		});
		</script>
	</head>
	<body>
		<b>Step 3: Select Columns</b> <cfinclude template="tpl_rptBldr_save_report.cfm"><br>
	
		<cfoutput query="getReport">#report_name#</cfoutput><hr>
	
		<cfoutput>
			<form method="post" action="rptBldr_cols_action.cfm">
			<input type="hidden" name="report_id" value="#report_id#">
		</cfoutput>
	
	
	<!--- Start outer loop --->
		<cfoutput query="getColumns" group="view_col_group_name">
			<div>
				<b>#view_col_group_name#</b><span style="padding-left:5px;"><input type="Checkbox" name="selectAll"> Select All</span>
			</div>
		
			<table border="0" cellspacing="0" cellpadding="3" width="90%">
				<!--- Reset counter --->
				<cfset cntr = 1>
				
				<!--- Start inner loop --->
				<cfoutput>
					
					<!--- Start new row? --->
					<cfif cntr EQ 1>
					<tr>
					</cfif>
					
					<!--- Display column and checkbox --->
					<td align="right"><input type="checkbox" name="view_col_id" value="#view_col_id#" <cfif listfind(lStaticCols,view_col_id) NEQ 0>CHECKED</cfif>></td>
					<td align="left" width="#colWidth#%">#view_col_display_label#</td>
					
					<!--- End current row? --->
					<cfif cntr EQ cols_per_row>
					</tr>
					</cfif>
					
					<!--- Increment counter --->
					<cfif cntr EQ cols_per_row>
						<cfset cntr = 1>
					<cfelse>
						<cfset cntr = cntr+1>
					</cfif>
					
					<!--- End inner loop --->
				</cfoutput>
				
				<!--- Spacer row --->
				<tr>
					<td colspan="#Evaluate((cols_per_row*2)+1)#">&nbsp;</td>
				</tr>
			</table>
		<!--- End outer loop --->
		</cfoutput>
	
		<!--- dynamic columns --->
		<cfoutput query="getDynamicCols">
			<!--- get values --->
			<cfinvoke
				webservice="#application.crs_api_path#/report.cfc?wsdl"
				method="getDynamicViewData"
				view_Id="#view_id#"
				context_value="#getreport.context_value#"
				returnvariable="dynData">
			
			<cfquery dbtype="query" name="getSelectedDynamic">
				select view_col_value
				from getSelectedColumns
				where view_col_id = #view_col_id#
			</cfquery>
			<cfset lSelected = valuelist(getSelectedDynamic.view_col_value)>
			
			<cfif dyndata.recordcount GT 0>
				<!--- <cfdump var=#dyndata#> --->
				<div>
					<b>#getDynamicCols.view_display_label#</b><span style="padding-left:5px;"><input type="Checkbox" name="selectAll"> Select All</span>
				</div>
				<table border="0" cellspacing="0" cellpadding="3" width="90%">
					<cfset cntr = 1>
					<cfloop query="dyndata">
						<!--- Start new row? --->
						<cfif cntr EQ 1>
						<tr>
						</cfif>
						<!--- Display column and checkbox --->
						<td align="right"><input type="checkbox" name="dynamic_col_#getDynamicCols.view_col_id#" value="#view_col_id#" <cfif listfind(lSelected,view_col_id) NEQ 0>CHECKED</cfif>></td>
						<td align="left" width="#colWidth#%">#view_col_display_label#</td>
						<!--- End current row? --->
						<cfif cntr EQ cols_per_row>
						</tr>
						</cfif>
						
						<!--- Increment counter --->
						<cfif cntr EQ cols_per_row>
							<cfset cntr = 1>
						<cfelse>
							<cfset cntr = cntr+1>
						</cfif>
					</cfloop>
					
					<!--- Spacer row --->
					<tr>
						<td colspan="#Evaluate((cols_per_row*2)+1)#">&nbsp;</td>
					</tr>
				</table>
			</cfif>
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

