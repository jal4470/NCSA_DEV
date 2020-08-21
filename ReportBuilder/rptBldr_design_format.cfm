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
		report_format_id,
		design_id
	from tbl_report
	where report_id = <cfqueryparam value="#report_id#">
</cfquery>

<cfquery datasource="#reports_dsn#" name="getDesigns">
	select design_id, name
	from tbl_design
	order by name
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
<cfhtmlhead text="<title>Report Builder - Select Label Format</title>">
<div style="height:10px;width:auto;"> </div>

<!--- Declare form --->
<cfoutput>
	<form method="post" action="rptBldr_design_format_action.cfm?s=#securestring#">
	<input type="hidden" name="report_id" value="#report_id#">
</cfoutput>
		 

<cfset stepnum=10>
<cfinclude template="tpl_rptBldr_head.cfm">

<div style="height: 15px; width: auto;"> </div>


<table border="0" cellspacing="0" cellpadding="4" width="100%">
	<tr>
		<td class="aeformlabel" width="200" valign="top">Select Label Format:</td>
		<td class="aeformfield">
		<CFOUTPUT>
		<select name="design_id">
			<option value="">-- Label Format --</option>
			<cfloop query="getDesigns">
				<option value="#design_id#" <cfif design_id EQ getreport.design_id>SELECTED="SELECTED"</cfif>>#name#</option>
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

