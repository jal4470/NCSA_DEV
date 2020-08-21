<!----------------------------->
<!--- Application variables --->
<!----------------------------->
	<cfset reports_dsn = application.reports_dsn>



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
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	<script language="JavaScript" type="text/javascript" src="assets/jquery-1.3.2.min.js"></script>
	<link  href="_rptBldr_style.css" type="text/css" media="print,screen" rel="stylesheet" >
	<script language="JavaScript1.3" type="text/javascript">
	function scbg(objRef, state) {
		objRef.style.backgroundColor = (1 == state) ? '#D3D8ED' : '#FFFFFF';
		return;
	}
	</script>
	<script language="JavaScript1.3" type="text/javascript">
	function scbg2(objRef, state) {
		objRef.style.backgroundColor = (1 == state) ? '#6661A7' : '#848BAF';
		return;
	}
	</script>
	<script language="JavaScript1.3" type="text/javascript">
	function scbg3(objRef, state) {
		objRef.style.backgroundColor = (1 == state) ? '#6661A7' : '#B0B1B3';
		return;
	}
	</script>
	</head>
<body>

<CFINCLUDE TEMPLATE="header_rptBldr.cfm">
<cfhtmlhead text="<title>Report Builder - Select Report Format</title>">
<div style="height:10px;width:auto;"> </div>

<!--- Declare form --->
<cfoutput>
	<form method="post" action="rptBldr_format_action.cfm">
	<input type="hidden" name="report_id" value="#report_id#">
</cfoutput>
		 

<cfset stepnum=2>
<cfinclude template="tpl_rptBldr_head.cfm">

<div style="height: 15px; width: auto;"> </div>


<table border="0" cellspacing="0" cellpadding="4" width="100%">
	<tr>
		<td class="aeformlabel" width="200" valign="top">Select Report Format:</td>
		<td class="aeformfield">
		<CFOUTPUT>
		<select name="report_format_id">
			<option value="">-- Report Format --</option>
			<cfloop query="getFormats">
				<option value="#report_format_id#" <cfif report_format_id EQ getreport.report_format_id>SELECTED="SELECTED"</cfif>>#report_format_desc#</option>
			</cfloop>
		</select>
		</CFOUTPUT>
		</td>
	</tr>
</table>

<div style="height: 15px; width: auto;"> </div>

<!--- BUTTONS --->
<cfinclude template="tpl_rptBldr_foot.cfm">
</form>

</body>
</html>

