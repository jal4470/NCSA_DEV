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
	
	<cfstoredproc datasource="#reports_dsn#"  procedure="p_get_columns_to_be_ordered" returncode="YES">
		<CFPROCRESULT NAME="getColumns" RESULTSET="1">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#report_id#" DBVARNAME="@report_id">
	</cfstoredproc>	
	
<!--- <cfdump var=#getColumns#> ---><!--- <cfabort> --->	

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
		<script type="text/javascript" src="assets/jquery.json.js"></script>
		<script type="text/javascript" src="assets/jquery.sortable.js"></script>
		<link  href="_rptBldr_style.css" type="text/css" media="print,screen" rel="stylesheet" >
		<link  href="assets/theme/jquery-ui-1.7.2.custom.css" type="text/css" media="print,screen" rel="stylesheet" >
		<style type="text/css">
			.sortable-accept-class{
				font-family: verdana, arial, helvetica, sans-serif;
				background-color: #f8f8f8;
				margin: 5px;
				padding:3px;
				color: #636363;
				font-weight: bold;
				font-size:12px;
			}
			.ui-state-default{
				height:18px;
				width:300px;
				margin:3px;
				padding:0.4em 0.4em 0.4em 1.5em;
				position:relative;
			}
			.ui-state-highlight{
				height:18px;
				width:300px;
				margin:3px;
				padding:0.4em 0.4em 0.4em 1.5em;
			}
		</style>
		<style type="text/css">
		 	#sortable-list-container{
				list-style-type:none;
				list-style-image:none;
			}
		 	#sortable-list-container ul{
				list-style-type:none;
				list-style-image:none;
			}
			.default-sortable-element-class{
				background-color: #f8f8f8;
				margin: 5px;
				padding:3px;
				color:black;
			}
		 	#sortable-list-container .sort-pointer{
				cursor:move;
			}
			.sortable-list-page-list{
				display:block;
				list-style-image:none;
				list-style-position:outside;
				list-style-type:none;
				margin:0pt;
				padding:0pt;
			}
			.sortable-list-placeholder{
				background-color:#aaaaaa;
				margin: 5px;
				padding:3px;
			}
		</style>
		
		<script language="JavaScript">
			$(document).ready(function(){
				$('#sortable-list-container').sortable(
				  {
				    accept: '.ui-state-default',
					opacity: .5,
					revert:false,
					forcePlaceholderSize:true,
					forceHelperSize:true,
					placeholder:'ui-state-highlight ui-corner-all',
					update : function(e,ui) {
				      // Do something with serialized here
				      // such as sending it to the server via an AJAX call
				      // or storing it in a JS variable that you can
				      // send to the server once the user presses a button.
					  //alert(serialized[0].hash);
					  //document.myform.tree.value=serialized[0].hash;
					  
					  
					  document.sortableListForm.tree.value=$.toJSON($('#sortable-list-container').sortable('toArray'));
					 // document.sortableListForm.listID.value=serialized[0].id;
				    }
				  }
				);
			});
		</script>
	</head>
<body>

<CFINCLUDE TEMPLATE="header_rptBldr.cfm">
<cfhtmlhead text="<title>Report Builder - Order Columns</title>">
<div style="height:10px;width:auto;"> </div>

<cfoutput>
	<form name="sortableListForm" action="rptBldr_order_action.cfm" method="post">
		<input type="Hidden" name="tree" value="">
		<input type="Hidden" name="report_id" value="#report_id#">
		<cfset stepnum=5>
		<cfinclude template="tpl_rptBldr_head.cfm">
	
		<div style="height:10px;"></div>
		
		<cfquery dbtype="query" name="sortedQuery">
			select * from getColumns
			order by seq
		</cfquery>
		<cfset buildLinearList(sortedQuery)>
		
		
		
	<div style="height:10px;width:auto;"> </div>
		<cfinclude template="tpl_rptBldr_foot.cfm">
		
	</form>
</cfoutput>







<!--- use sortable module --->
<!--- <cf_sortableTree
	acceptClass="ui-state-default"
	helperClass="ui-state-highlight ui-corner-all"
	currentNestingClass="currentNesting"
	queryToSort=#getColumns#
	idFieldName="report_col_id"
	displayFieldName="view_col_display_label"
	sequenceFieldName="seq"
	componentName="report"
	methodName="reorderColumns"
	redirectURL="rptBldr_filters.cfm?s=#securestring#&report_id=#report_id#"
	backURL="rptBldr_totals.cfm?s=#securestring#&report_id=#report_id#"
	runURL="rptBldr_display.cfm?s=#securestring#&report_id=#report_id#"
	report_id="#report_id#"
	noNesting=true> --->

</body>
</html>



<cffunction access="private" name="buildLinearList">
	<cfargument name="list" type="query" required="Yes">

	<cfoutput>
		<span class="sortable-list-page-list" id="sortable-list-container">

			<cfloop query="arguments.list">

				<cfset idvalue = #arguments.list["report_col_id"]#>
				<cfset displayname = #arguments.list["view_col_display_label"]#>
				<cfset displayname = #htmleditformat(displayname)#>
				<div class="ui-state-default sort-pointer ui-corner-all" id="sortable-list-element-#idvalue#">
					<span class="ui-icon ui-icon-arrowthick-2-n-s" style="position:absolute; margin-left:-16px;"></span>#displayname#
				</div>
			</cfloop>
		</span>
	</cfoutput>

</cffunction>