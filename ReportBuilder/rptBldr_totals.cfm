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
		   count_flag
	  from tbl_report
	 where report_id = <cfqueryparam value="#report_id#">
	</cfquery>
	
	<cfquery datasource="#reports_dsn#" name="getColumns">
	select a.view_col_id,
	       view_col_display_label,
		   b.sum_flag, b.avg_flag,b.min_flag, b.max_flag
	  from v_report_columns a
	  	left join 
		(
			select * from
			tbl_report_col
			where report_id=#report_id#
		) as b
		on a.view_col_id=b.view_col_id
	 where report_type_id = <cfqueryparam value="#getReport.report_type_id#">
	   and allow_aggr_flag = 1
	order by a.view_col_id
	</cfquery>
<!--- <cfdump var=#getColumns#> --->

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
		<script language="JavaScript" type="text/javascript" src="assets/jquery-1.3.2.min.js"></script>
		<link  href="_rptBldr_style.css" type="text/css" media="print,screen" rel="stylesheet" >
	</head>
	<body>
<CFINCLUDE TEMPLATE="header_rptBldr.cfm">
<cfhtmlhead text="<title>Report Builder - Select Totals</title>">

<div style="height:10px;width:auto;"> </div>

<cfoutput>
<form method="post" action="rptBldr_totals_action.cfm">
<input type="hidden" name="report_id" value="#report_id#">
</cfoutput>

<cfset stepnum=4>
<cfinclude template="tpl_rptBldr_head.cfm">




<div style="height:10px;"></div>
<table border="0" cellspacing="0" cellpadding="3" align="center" style="border:1px solid #B1B1BC;">
	<!--- Section label --->
	<tr>
		<td align="left" class="generalheadcenter" style="padding-right:20px;">Summary Fields</td>
		<td align="center" width="75" class="generalheadcenter">Sum</td>
		<td align="center" width="75" class="generalheadcenter">Average</td>
		<td align="center" width="75" class="generalheadcenter">Largest Value</td>
		<td align="center" width="75" class="generalheadcenter">Smallest Value</td>
	</tr>

	<!--- Record Count row (special handling) --->
	<tr>
		<td align="left" class="aeformlabel">Record Count</td>
		<td align="center"><input type="checkbox" name="count_flag" value="1" <cfif getReport.count_flag EQ 1>CHECKED</cfif>></td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>

	<!--- Output summary fields --->
	<cfoutput query="getColumns">
	<tr>
		<td align="left" class="aeformlabel">#view_col_display_label#</td>
		<td align="center"><input type="checkbox" name="view_col_id_#view_col_id#_sum" value="1" <cfif sum_flag EQ 1>CHECKED</cfif>></td>
		<td align="center"><input type="checkbox" name="view_col_id_#view_col_id#_avg" value="1" <cfif avg_flag EQ 1>CHECKED</cfif>></td>
		<td align="center"><input type="checkbox" name="view_col_id_#view_col_id#_max" value="1" <cfif max_flag EQ 1>CHECKED</cfif>></td>
		<td align="center"><input type="checkbox" name="view_col_id_#view_col_id#_min" value="1" <cfif min_flag EQ 1>CHECKED</cfif>></td>
	</tr>
	</cfoutput>

</table>
<div style="height:15px;"></div>
<!--- BUTTONS --->

<cfinclude template="tpl_rptBldr_foot.cfm">
</form>
</body>
</html>

