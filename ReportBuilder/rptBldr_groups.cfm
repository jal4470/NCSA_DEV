<!----------------------------->
<!--- Application variables --->
<!----------------------------->
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
<!--- <cftry> --->
<cfquery datasource="#reports_dsn#" name="getReport">
	select report_name,
		report_type_id,
		context_value,
		report_format_id
	from tbl_report
	where report_id = <cfqueryparam value="#report_id#">
</cfquery>

<!--- redirect if format is matrix report --->
<cfif getReport.report_format_id EQ "3">
	<cflocation url="rptBldr_groups_matrix.cfm?s=#securestring#&report_id=#report_id#" addtoken="No">
</cfif>

<!--- get current group1 --->
<cfquery datasource="#reports_dsn#" name="getGroup1">
	select view_col_id, view_col_value, report_group_format_id
	from tbl_report_group
	where report_id = <cfqueryparam value="#report_id#">
	and seq=1
</cfquery>

<!--- get current group2 --->
<cfquery datasource="#reports_dsn#" name="getGroup2">
	select view_col_id, view_col_value, report_group_format_id
	from tbl_report_group
	where report_id = <cfqueryparam value="#report_id#">
	and seq=2
</cfquery>

<!--- get current group3 --->
<cfquery datasource="#reports_dsn#" name="getGroup3">
	select view_col_id, view_col_value, report_group_format_id
	from tbl_report_group
	where report_id = <cfqueryparam value="#report_id#">
	and seq=3
</cfquery>

<cfquery datasource="#reports_dsn#" name="getColsToGroup">
	select a.view_col_id,
		a.view_col_display_label,
		a.view_col_group_name,
		a.xtype
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

<cfquery datasource="#reports_dsn#" name="getGroupFormats">
	select * from tlkp_report_group_format
</cfquery>


<!--- set maximum characters in dropdown rows --->
<cfset maxRowChars=40>



<!--- <cfdump var=#getdynamicCols#> --->
<!--- 	<cfcatch>
<cfinclude template="cfcatch.cfm">
</cfcatch>
</cftry> --->

<!----------------->
<!--- Page body --->
<!----------------->
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<link  href="_rptBldr_style.css" type="text/css" media="print,screen" rel="stylesheet" >
		<script language="JavaScript" type="text/javascript" src="assets/jquery-1.3.2.min.js"></script>
		<script language="JavaScript" type="text/javascript">
			$(function(){
				$("select[name^=view_col_id]").change(function(){
					showHideFormat(this);
				});
				
				$("select[name^=view_col_id]").each(function(){
					showHideFormat(this);
				});
			});
			
			//enable/disable the format dropdown given the select box that was changed
			function showHideFormat(obj)
			{
				var xtype=$(obj).find("option:selected").attr("xtype");
				if(xtype == "58")
				{
					$(obj).parent().next().find("select").attr("disabled","");
				}
				else
				{
					$(obj).parent().next().find("select").attr("disabled","disabled");
				}
			}
		</script>

	</head>
	<body>
	
	<CFINCLUDE TEMPLATE="header_rptBldr.cfm">
	<cfhtmlhead text="<title>Report Builder - Select Report Groups</title>">
	<div style="height:10px;width:auto;"> </div>
	
		<cfoutput>
			<form method="post" action="rptBldr_groups_action.cfm?s=#securestring#">
			<input type="hidden" name="report_id" value="#report_id#">
		</cfoutput>
	
		<cfset stepnum=7>
		<cfinclude template="tpl_rptBldr_head.cfm">
	
	
			<div>
				<table border="0" cellpadding="0">
					<tr>
						<td>
							Summarize information by:<br>
							<select name="view_col_id_1">
								<option value="">-- None --</option>
								<cfoutput query="getColsToGroup" group="view_col_group_name">
									<optgroup label="#view_col_group_name#">
										<cfoutput>
											<option value="#view_col_id#" xtype="#xtype#" <cfif getGroup1.view_col_id EQ view_col_id>selected="selected"</cfif>>#view_col_display_label#</option>
										</cfoutput>
									</optgroup>
								</cfoutput>
								<cfoutput>
									<cfloop query="getDynamicCols">
										<cfinvoke
											<!--- webservice="#application.crs_api_path#/report.cfc?wsdl" --->
											component="#application.crs_cfc_path#.report"
											method="getDynamicViewData"
											view_Id="#view_id#"
											context_value="#getreport.context_value#"
											returnvariable="dynData"><!--- <cfdump var=#dyndata#> --->
										<optgroup label="#view_display_label#">
											<cfloop query="dyndata">
												<option value="#getDynamicCols.view_col_id#-#view_col_id#" <cfif getGroup1.view_col_id EQ getDynamicCols.view_col_id AND getGroup1.view_col_value EQ view_col_id>selected="selected"</cfif>>
													<cfif len(view_col_display_label) GT maxRowChars>
														#left(view_col_display_label,maxRowChars/2)#...#right(view_col_display_label,maxRowChars/2)#
													<cfelse>
														#view_col_display_label#
													</cfif>
												</option>
											</cfloop>
										</optgroup>
									</cfloop>
								</cfoutput>
							</select>
						</td>
						<td style="padding-left:10px;">
							Group dates by<br>
							<select name="report_group_format_id_1">
								<cfoutput query="getGroupFormats">
									<option value="#report_group_format_id#" <cfif getGroup1.report_group_format_id EQ report_group_format_id>SELECTED="selected"</cfif>>#report_group_format_desc#</option>
								</cfoutput>
							</select>
						</td>
					</tr>
				</table>
			</div>
			<div style="margin-left:50px;">
			
				<table border="0" cellpadding="0">
					<tr>
						<td>
							and then by:<br>
							<select name="view_col_id_2">
								<option value="">-- None --</option>
								<cfoutput query="getColsToGroup" group="view_col_group_name">
									<optgroup label="#view_col_group_name#">
										<cfoutput>
											<option value="#view_col_id#" xtype="#xtype#" <cfif getGroup2.view_col_id EQ view_col_id>selected="selected"</cfif>>#view_col_display_label#</option>
										</cfoutput>
									</optgroup>
								</cfoutput>
								<cfoutput>
									<cfloop query="getDynamicCols">
										<cfinvoke
											<!--- webservice="#application.crs_api_path#/report.cfc?wsdl" --->
											component="#application.crs_cfc_path#.report"
											method="getDynamicViewData"
											view_Id="#view_id#"
											context_value="#getreport.context_value#"
											returnvariable="dynData"><!--- <cfdump var=#dyndata#> --->
										<optgroup label="#view_display_label#">
											<cfloop query="dyndata">
												<option value="#getDynamicCols.view_col_id#-#view_col_id#" <cfif getGroup2.view_col_id EQ getDynamicCols.view_col_id AND getGroup2.view_col_value EQ view_col_id>selected="selected"</cfif>>
													<cfif len(view_col_display_label) GT maxRowChars>
														#left(view_col_display_label,maxRowChars/2)#...#right(view_col_display_label,maxRowChars/2)#
													<cfelse>
														#view_col_display_label#
													</cfif>
												</option>
											</cfloop>
										</optgroup>
									</cfloop>
								</cfoutput>
							</select>
						</td>
						<td style="padding-left:10px;">
							Group dates by<br>
							<select name="report_group_format_id_2">
								<cfoutput query="getGroupFormats">
									<option value="#report_group_format_id#" <cfif getGroup2.report_group_format_id EQ report_group_format_id>SELECTED="selected"</cfif>>#report_group_format_desc#</option>
								</cfoutput>
							</select>
						</td>
					</tr>
				</table>
			</div>
			<div style="margin-left:100px; margin-bottom:50px;">
			
				<table border="0" cellpadding="0">
					<tr>
						<td>
							and then by:<br>
							<select name="view_col_id_3">
								<option value="">-- None --</option>
								<cfoutput query="getColsToGroup" group="view_col_group_name">
									<optgroup label="#view_col_group_name#">
										<cfoutput>
											<option value="#view_col_id#" xtype="#xtype#" <cfif getGroup3.view_col_id EQ view_col_id>selected="selected"</cfif>>#view_col_display_label#</option>
										</cfoutput>
									</optgroup>
								</cfoutput>
								<cfoutput>
									<cfloop query="getDynamicCols">
										<cfinvoke
											<!--- webservice="#application.crs_api_path#/report.cfc?wsdl" --->
											component="#application.crs_cfc_path#.report"
											method="getDynamicViewData"
											view_Id="#view_id#"
											context_value="#getreport.context_value#"
											returnvariable="dynData"><!--- <cfdump var=#dyndata#> --->
										<optgroup label="#view_display_label#">
											<cfloop query="dyndata">
												<option value="#getDynamicCols.view_col_id#-#view_col_id#" <cfif getGroup3.view_col_id EQ getDynamicCols.view_col_id AND getGroup3.view_col_value EQ view_col_id>selected="selected"</cfif>>
													<cfif len(view_col_display_label) GT maxRowChars>
														#left(view_col_display_label,maxRowChars/2)#...#right(view_col_display_label,maxRowChars/2)#
													<cfelse>
														#view_col_display_label#
													</cfif>
												</option>
											</cfloop>
										</optgroup>
									</cfloop>
								</cfoutput>
							</select>
						</td>
						<td style="padding-left:10px;">
							Group dates by<br>
							<select name="report_group_format_id_3">
								<cfoutput query="getGroupFormats">
									<option value="#report_group_format_id#" <cfif getGroup3.report_group_format_id EQ report_group_format_id>SELECTED="selected"</cfif>>#report_group_format_desc#</option>
								</cfoutput>
							</select>
						</td>
					</tr>
				</table>
			</div>
	
		<!--- BUTTONS --->
		
		<cfinclude template="tpl_rptBldr_foot.cfm">
	</body>
</html>

