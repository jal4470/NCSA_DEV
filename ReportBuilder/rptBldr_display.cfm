<cfsetting showdebugoutput="no">
<!----------------------------->
<!--- Application variables --->
<!----------------------------->
<cfsetting requesttimeout="10000">
<cflock scope="application" type="readonly" timeout="10">
	<cfset reports_dsn = application.reports_dsn>
</cflock>


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

	<cfquery datasource="#reports_dsn#" name="getReport">
	SELECT report_name,
		count_flag,
		report_format_id,
		report_type_id,
		date_range_item_val
	  FROM tbl_report
	 WHERE report_id = <cfqueryparam value="#report_id#">
	</cfquery>
	
	
	<!--- update date filter --->
	<cfinvoke
		component="report"
		method="refreshDateFilter"
		report_id="#report_id#">
		
	
	
	
	
	<CFSTOREDPROC datasource="#reports_dsn#" procedure="p_run_report" returncode="YES" >
		<CFPROCRESULT name="getData" RESULTSET="1">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#report_id#" DBVARNAME="@report_id">
	</CFSTOREDPROC>
<!--- <cfdump var=#getdata# expand="No" label="data"> --->


	
	<!--- get column list --->
	<CFSTOREDPROC datasource="#reports_dsn#" procedure="p_get_report_columns" returncode="YES" >
		<CFPROCRESULT name="qrycolumnlist" RESULTSET="1">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#report_id#" DBVARNAME="@report_id">
	</CFSTOREDPROC>
<!--- <cfdump var=#qrycolumnlist# expand="No" label="columns"> --->
	
	<!--- get group info --->
	<CFSTOREDPROC datasource="#reports_dsn#" procedure="p_get_report_groups" returncode="YES" >
		<CFPROCRESULT name="qrygroupinfo" RESULTSET="1">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#report_id#" DBVARNAME="@report_id">
	</CFSTOREDPROC>
<!--- <cfdump var=#qrygroupinfo# expand="No" label="groups"> --->


	<!--- DATE FILTER STUFF --->
	<cfquery datasource="#reports_dsn#" name="getDurations">
		select * from 
		v_date_range_options
		order by group_seq, item_seq
	</cfquery>
	
	<cfquery datasource="#reports_dsn#" name="getDateColumns">
	SELECT VIEW_COL_ID,
	       VIEW_COL_DISPLAY_LABEL
	  FROM v_report_columns
	 WHERE report_type_id = <cfqueryparam value="#getReport.report_type_id#">
	   AND XTYPE IN (61,58)
	</cfquery>
	<!--- get initial date criteria --->
	<cfquery datasource="#reports_dsn#" name="getInitialDateCriteria">
		select * from tbl_report_criteria
		where report_id = <cfqueryparam value="#report_id#">
		and initial_date_criteria = 1
	</cfquery>
	<!--- set date criteria --->
	<cfif getInitialDateCriteria.recordcount GT 0>
		<cfloop query="getInitialDateCriteria">
			<cfif operand_id EQ 6>
				<cfset date_view_col_id=view_col_id>
				<cfset start_date=value>
			<cfelse>
				<cfset end_date=value>
			</cfif>
		</cfloop>
	<cfelse>
		<cfset date_view_col_id="">
		<cfset start_date="">
		<cfset end_date="">
	</cfif>

	<!--- generate group nested structure --->
	<cfset stGroups=structnew()>
	<cfset stGroups.label="">
	<cfset stGroups.format="">
	<cfset stGroups.xtype_cat="">
	<cfset stGroups.child=makeGroupStruct(qrygroupinfo)>
<!--- <cfdump var=#stGroups# expand="No" label="stgroups"> --->
	
	<!--- create aggregate struct --->
	<cfset stAggregate=structnew()>
	<cfloop query="qryColumnList">
		<cfif sum_flag EQ 1>
			<cfset structInsert(stAggregate, "#label#_sum", "")>
		</cfif>
		<cfif avg_flag EQ 1>
			<cfset structInsert(stAggregate, "#label#_avg", "")>
		</cfif>
		<cfif min_flag EQ 1>
			<cfset structInsert(stAggregate, "#label#_min", "")>
		</cfif>
		<cfif max_flag EQ 1>
			<cfset structInsert(stAggregate, "#label#_max", "")>
		</cfif>
	</cfloop>
<!--- <cfdump var=#stAggregate# expand="No"> --->	

	<!--- process groups into array --->
	<cfset arrGroups=arraynew(1)>
	<cfloop query="qrygroupinfo">
		<cfset stGroup=structnew()>
		<cfset stGroup.label=qrygroupinfo.label>
		<cfset arrGroups[currentrow]=stGroup>
	</cfloop>
	
	
	<!--- header colors --->
	<cfset stColors=structnew()>
	<cfset stColors.level0="##CCCCEE">
	<cfset stColors.level1="##DDDDEE">
	<cfset stColors.level2="##F3F3EC">

	
	<cfif getReport.report_format_id EQ 4>
		<cfquery dbtype="query" name="getData">
			select distinct * from getData
		</cfquery>
	</cfif>



	<cfcatch><cfdump var=#cfcatch#><cfabort>
		<cfinclude template="cfcatch.cfm">
	</cfcatch>
</cftry>
<!----------------->
<!--- Page body --->
<!----------------->
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">
<html>
	
	<head>
		<link  href="_rptBldr_style.css" type="text/css" media="print,screen" rel="stylesheet" >
		<link type="text/css" rel="stylesheet" href="assets/theme/jquery-ui-1.7.2.custom.css" />
		<script language="JavaScript" type="text/javascript" src="assets/jquery-1.3.2.min.js"></script>
		<script language="JavaScript" type="text/javascript" src="assets/jquery.datepicker.min.js"></script>
		<script language="JavaScript" type="text/javascript">
			jQuery(function(){
				$("#showDetailsLink").hide();
				
				$("#showDetailsLink").click(function(){
					$("#showDetailsLink").hide();
					$("#hideDetailsLink").show();
					
					$("#resultTable tr").show();
					
				});
				
				$("#hideDetailsLink").click(function(){
					$("#hideDetailsLink").hide();
					$("#showDetailsLink").show();
					
					$("#resultTable tr.detailRow").hide();
					
				});
				
				$(".groupHeadRow").click(function(){
					var s=$("x");
					var n=$(this).next();
					var t=new Date().getTime();
					while($(n).is(".detailRow"))
					{
						s=$(s).add(n);
						//$(n).toggle();
						n=$(n).next();
					}
					$(s).toggle();
					//console.log(new Date().getTime()-t);
				});
				
				
				//DATE FILTER JS
				$("select[name=duration]").change(function(){
					//get start and end dates
					$("input[name=start_date]").val($(this).find("option:selected").attr('startdate'));
					$("input[name=end_date]").val($(this).find("option:selected").attr('enddate'));
				});
				
				$("input[name=start_date], input[name=end_date]").change(function(){
					//select custom duration
					$("select[name=duration] option:first").attr('selected','selected');
				});
				
				$("input[name=start_date], input[name=end_date]").datepicker();
				});
		</script>
		
		<style type="text/css">
			#resultTable{
				border-top:1px solid #838282;
				border-left:1px solid #838282;
				border-right:1px solid #838282;
				color:black;
			}
			#resultTable th, #resultTable td{
				padding:5px;
				/*border-right:1px solid #838282;*/
				border-bottom:1px solid #838282;
			}
			#resultTable th{
				font-size:11px;
				white-space: nowrap;
			}
			#resultTable td{
				font-size:11px;
				white-space: nowrap;  
				border-left:1px solid #838282;
			}
			#resultTable td:first-child{
				border-left:none;
			}
			#resultTable tr.groupLabel th{/*remove bottom border from colspanned group label row*/
				border-bottom:none;
			}
			
			/*colors for different level groups*/
			#resultTable .tableHeader th{
				background-color:#C9C9C9;
				white-space: nowrap;
			}
			#resultTable .groupHeader0 th{
				background-color:#C9C9C9;
				white-space: nowrap;
			}
			#resultTable .groupHeader1 th{
				background-color:#D7D8D9;
				white-space: nowrap;
				color:#4A4949;
			}
			#resultTable .groupHeader2 th{
				background-color:#E3E4E5;
				white-space: nowrap;
				color:#4A4949;
			}
			#resultTable .groupHeader3 th{
				background-color:#F0F1F2;
				white-space: nowrap;
				color:#4A4949;
			}
			
			#resultTable .detailRow td{
				white-space: nowrap;
			}
			.detaillink {
				color: #8C8A8A;
				text-decoration: none;
			}
			.detaillink:hover {
				color: #F6844C;
				text-decoration: none;
			}
			
			
			
			<!--- matrix styles --->
			#matrixTable{
				border-top:1px solid #838282;
				border-right:1px solid #838282;
				color:black;
			}
			#matrixTable th{
				padding:5px;
				border-bottom:1px solid black;
				border-left:1px solid black;
			}
			#matrixTable td{
				border-left:1px solid black;
				border-bottom:1px solid black;
				text-align:center;
				padding:3px;
			}
			#matrixTable th.groupHeader0{
				background-color:#C9C9C9;
				white-space: nowrap;
			}
			#matrixTable th.groupHeader1{
				background-color:#D7D8D9;
				white-space: nowrap;
				color:#4A4949;
			}
			#matrixTable th.groupHeader2{
				background-color:#E3E4E5;
				white-space: nowrap;
				color:#4A4949;
			}
			#matrixTable th.groupHeader3{
				background-color:#F0F1F2;
				white-space: nowrap;
				color:#4A4949;
			}
			#matrixTable th.aggHeader{
				background-color:#C9C9C9;
				color:#4A4949;
				font-weight:normal;
				font-style:italic;
			}
		</style>
		
		
	</head>
	
	
	<body>

		<CFINCLUDE TEMPLATE="header_rptBldr.cfm">
	<cfhtmlhead text="<title>Report Builder - Report Results</title>">
		<div style="height:10px;width:auto;"> </div>
		
		<form action="rptBldr_display_action.cfm" method="post">
		<cfoutput><input type="hidden" name="report_id" value="#report_id#"></cfoutput>
		
		<cfset stepnum=9>
		<cfinclude template="tpl_rptBldr_head.cfm">
	
		</form>
		
		
		<!--- <a href="https://d-reports.capturepoint.com/rptBldr_step1.cfm">New Report</a> --->
		
		<!--- <cfform>
		   <cfgrid name = "FirstGrid" format="HTML" font="Tahoma" fontsize="12" query = "getData">
		   </cfgrid>
		</cfform> --->
		
		
		
		<!--- CODE TO TABELIZE REPORT QUERY --->
		<!--- get list of columns --->
		<cfset mycolumnList=valuelist(qrycolumnlist.label)>
		
		
		<cfset tmpmycolumnlist=mycolumnlist>
		<!--- get rid of columns that aren't in query --->
		<cfloop list="#mycolumnlist#" index="i">
		
			<cfif listfindnocase(getdata.columnlist,i) EQ 0>
				<cfset tmpmycolumnlist = listdeleteat(tmpmycolumnlist,listfind(tmpmycolumnlist,i))>
			</cfif>
		</cfloop>
		<cfset mycolumnlist=tmpmycolumnlist>
		
		
		<!--- DATE FILTER --->
		
		
		<form action="rptBldr_setDates_action.cfm" method="post">
			<cfoutput><input type="Hidden" name="report_id" value="#report_id#"></cfoutput>
			<table border="0" cellspacing="0" cellpadding="3" width="848">
				<!--- Section label --->
				<tr>
					<td colspan="3"><b>Date Filters</b></td>
				</tr>
			
				<!--- Form label row --->
				<tr>
					<td>Columns</td>
					<td colspan="2">Duration</td>
				</tr>
			
				<!--- Form fields --->
				<tr>
					<td>
					<select name="date_view_col_id">
					<option value="">--Please Select--
					<cfoutput query="getDateColumns">
					<option value="#view_col_id#" <cfif date_view_col_id EQ view_col_id>selected="selected"</cfif>>#view_col_display_label#
					</cfoutput>
					</select>
					</td>
					<td colspan="2">
						<select name="duration">
							<option value="">Custom</option>
							<cfoutput query="getDurations" group="group_seq">
								<optgroup label="#group_label#">
								<cfoutput>
									<option value="#item_val#" startdate="#dateformat(start_date,"mm/dd/yyyy")#" enddate="#dateformat(end_date,"mm/dd/yyyy")#" <cfif getReport.date_range_item_val EQ item_val>selected="selected"</cfif>>#item_label#</option>
								</cfoutput>
								</optgroup>
							</cfoutput>
						</select>
					</td>
				</tr>
				<tr>
					<td>
						&nbsp;
					</td>
					<td>
						Start Date
					</td>
					<td>
						End Date
					</td>
				</tr>
				<cfoutput>
				<tr>
					<td>
						&nbsp;
					</td>
					<td><input type="text" name="start_date" value="#dateformat(start_date,"mm/dd/yyyy")#"></td>
					<td><input type="text" name="end_date" value="#dateformat(end_date,"mm/dd/yyyy")#"><input type="Submit" name="btnSave" value="Rerun"></td>
				</tr>
				</cfoutput>
			</table>
		</form>
		
		<div style="height:10px;width:auto;"> </div>
		
		<cfif getReport.report_format_id NEQ 3><!--- summary report --->
			<a id="hideDetailsLink" href="javascript:void(0);" class="detaillink">[ - Hide Details ]</a><a id="showDetailsLink" href="javascript:void(0);" style="display:none;" class="detaillink">[ + Show Details ]</a>
			
			<div style="height:10px;width:auto;"> </div>
			
			<table id="resultTable" border="0" cellpadding="0" cellspacing="0" width="100%">
				<!--- display report headers --->
				<tr class="tableHeader">
				<!--- <th>&nbsp;</th> --->
				<cfloop query="qryColumnList">
					<th align="left">
						<cfoutput>#label#</cfoutput>
					</th>
				</cfloop>
				</tr>
				
				<cfoutput>#showGroup(getData,stGroups)#</cfoutput>
				
			</table>
		<cfelse><!--- matrix report --->
		
			<cfinclude template="rptBldr_tpl_matrix.cfm">
		
		</cfif>
		
	</body>
</html>





<cffunction name="showGroup" access="private" returntype="any" description="display a group by showing the header and then recursing through subgroups and displaying the rows">
	<cfargument name="qry" type="query" required="Yes">
	<cfargument name="group" type="struct" required="Yes">
	<cfargument name="item" type="string" required="Yes" default="">
	<cfargument name="level" type="numeric" required="Yes" default="0">
	<!--- var variables --->
	<cfset var lSelect = "">
	<cfset var qryTotals = "">
	<cfset var qryGroupItems = "">
	<cfset var qryChild = "">

	<!--- build select list --->
	<!--- add +0 here for avg, min, max so nulls are set to 0.
	the downside is that nulls are counted in the aggregates as 0.  oh well, at least it doesn't break --->
	<cfset lSelect="">
	<cfloop query="qryColumnList">
		<cfif sum_flag EQ 1>
			<cfset lSelect=listappend(lSelect,"sum(#replace(label," ","_","all")#) as #replace(label," ","_","all")#_sum")>
		</cfif>
		<cfif avg_flag EQ 1>
			<cfset lSelect=listappend(lSelect,"avg(#replace(label," ","_","all")#+0) as #replace(label," ","_","all")#_avg")>
		</cfif>
		<cfif min_flag EQ 1>
			<cfset lSelect=listappend(lSelect,"min(#replace(label," ","_","all")#+0) as #replace(label," ","_","all")#_min")>
		</cfif>
		<cfif max_flag EQ 1>
			<cfset lSelect=listappend(lSelect,"max(#replace(label," ","_","all")#+0) as #replace(label," ","_","all")#_max")>
		</cfif>
	</cfloop>
	<!--- display group header --->
	<!--- get totals query --->
	<cfif lSelect NEQ "">
		<cfquery dbtype="query" name="qryTotals">
			select #lSelect#
			from qry
		</cfquery>
	</cfif>
<!--- <Cfdump var=#qryTotals#> --->
	
	<!--- AGGREGATES --->
	<cfif level NEQ 0><!--- display grand totals(level 0) after report, not as header --->
		<tr class="groupHeader<cfoutput>#level#</cfoutput> groupLabel">
			<th colspan="<cfoutput>#qryColumnList.recordcount#</cfoutput>" style="text-align:left; white-space:nowrap; vertical-align:top;">
				<div style="padding-left:<cfoutput>#(level-1)*15#</cfoutput>px">
					<cfoutput>
						<cfif group.label NEQ "">
							<cfif item EQ "">
								<cfset item="-">
							</cfif>
							<!--- dates are now formatted in the query from DB --->
							<!--- <cfif group.xtype_cat EQ "D" AND isdate(item)>
								<cfif group.format EQ 1>
									<cfset item=dateformat(item,"mm/dd/yyyy")>
								<cfelseif group.format EQ 2>
									<cfset item="#week(item)#-#dateformat(item,"yyyy")#">
								<cfelseif group.format EQ 3>
									<cfset item=dateformat(item,"m/yyyy")>
								<cfelseif group.format EQ 4>
									<cfset item="#quarter(item)#-#dateformat(item,"yyyy")#">
								<cfelseif group.format EQ 5>
									<cfset item=dateformat(item,"yyyy")>
								</cfif>
							</cfif> --->
							#group.label#: #item#
						</cfif>
						(#qry.recordcount# record<cfif qry.recordcount NEQ 1>s</cfif>)
						
					</cfoutput>
				</div>
			</th>
		</tr>
		<tr class="groupHeader<cfoutput>#level#</cfoutput>">
			
		<!---</tr>
		<tr class="groupHeader<cfoutput>#level#</cfoutput> groupHeadRow">--->
			<cfloop query="qryColumnList">
				<th style="text-align:left;">
					<!--- what column? --->
					<cfset colName=replace(qryColumnList.label," ","_","all")>
					<cfif sum_flag EQ "1">
						<cfset value=qryTotals["#colName#_sum"]>
						<cfif value EQ ""><cfset value="0"></cfif>
						<cfif qryColumnList.xtype EQ "60" AND isnumeric(value)><cfset value=dollarformat(value)></cfif>
						<div>
						<cfoutput>Sum: #value#</cfoutput>
						</div>
					</cfif>
					<cfif avg_flag EQ "1">
						<cfset value=qryTotals["#colName#_avg"]>
						<cfif value EQ ""><cfset value="0"></cfif>
						<cfif qryColumnList.xtype EQ "60" AND isnumeric(value)><cfset value=dollarformat(value)>
						<cfelse><cfset value=symRound(value,4)>
						</cfif>
						<div>
						<cfoutput>Avg: #value#</cfoutput>
						</div>
					</cfif>
					<cfif min_flag EQ "1">
						<cfset value=qryTotals["#colName#_min"]>
						<cfif value EQ ""><cfset value="-"></cfif>
						<cfif qryColumnList.xtype EQ "60" AND isnumeric(value)><cfset value=dollarformat(value)></cfif>
						<div>
						<cfoutput>Min: #value#</cfoutput>
						</div>
					</cfif>
					<cfif max_flag EQ "1">
						<cfset value=qryTotals["#colName#_max"]>
						<cfif value EQ ""><cfset value="-"></cfif>
						<cfif qryColumnList.xtype EQ "60" AND isnumeric(value)><cfset value=dollarformat(value)></cfif>
						<div>
						<cfoutput>Max: #value#</cfoutput>
						</div>
					</cfif>
					<img src="assets/images/spcrimg.gif" height="1" width="1">
				</th>
			</cfloop>
		</tr>
	</cfif>
	<!--- END AGGREGATES --->
	
	
	<cfif NOT structisempty(group.child)>
		
		<!--- BEGIN GROUP LOOP --->
		<!--- get group items --->
		<cfquery dbtype="query" name="qryGroupItems">
			select distinct UPPER(#replace(group.child.label," ","_","all")#) as label
			from qry
		</cfquery>
		<!--- group items:
		<cfdump var=#qryGroupItems#> --->
		<cfloop query="qryGroupItems">
			<!--- get item query --->
			<cfquery dbtype="query" name="qryChild">
				select * from qry
				where 
				<cfif group.child.xtype_cat EQ "T">
				UPPER(#replace(group.child.label," ","_","all")#)
				<cfelseif group.child.xtype_cat EQ "D">
				UPPER(#replace(group.child.label," ","_","all")#)
				<cfelse>
				#replace(group.child.label," ","_","all")#
				</cfif>
				<cfif qryGroupItems.label EQ "">
					<cfif group.child.xtype_cat EQ "N">
					 is null 
					<cfelse>
					  = '' 
					</cfif>
				<cfelse>
					<cfif group.child.xtype_cat EQ "N">
					= #qryGroupItems.label#
					<cfelseif group.child.xtype_cat EQ "T">
					= '#UCase(qryGroupItems.label)#'
					<cfelse>
					= '#qryGroupItems.label#'
					</cfif>
				</cfif>
			</cfquery>
			<!--- child query for <cfoutput>#qryGroupItems.label#</cfoutput>:
			<cfdump var=#qryChild#> --->
			<cfset showGroup(qryChild,group.child,qryGroupItems.label,level+1)>
		</cfloop>
		<!--- END GROUP LOOP --->
		
	<cfelse>
		<!--- DISPLAY ROWS --->
		<cfloop query="qry">
			<tr class="detailRow">
				<!--- <td>&nbsp;</td> --->
				<!--- loop over displayed columns --->
				<cfloop query="qryColumnList">
					<td>
						<cfset value=qry["#replace(qryColumnList.label," ","_","all")#"]>
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
						<cfoutput>#value#</cfoutput>
					</td>
				</cfloop>
			</tr>
		</cfloop>
		<!--- END DISPLAY ROWS --->
	</cfif>
	
	<!--- GRAND TOTALS ROW --->
	<cfif level EQ 0>
		<tr class="groupHeader<cfoutput>#level#</cfoutput> groupLabel">
			<th colspan="<cfoutput>#qryColumnList.recordcount#</cfoutput>" style="text-align:left; white-space:nowrap; vertical-align:top;">
				<cfoutput>
					Grand Totals (#qry.recordcount# record<cfif qry.recordcount NEQ 1>s</cfif>)
				</cfoutput>
			</th>
		</tr>
		<tr class="groupHeader<cfoutput>#level#</cfoutput> groupHeadRow">
			<!--- <th>
				<div style="padding-left:<cfoutput>#level*15#</cfoutput>">
					<cfoutput>
						Grand Totals (#qry.recordcount# record<cfif qry.recordcount NEQ 1>s</cfif>)
					</cfoutput>
				</div>
			</th> --->
			<cfloop query="qryColumnList">
				<th style="text-align:left;">
					<!--- what column? --->
					<cfset colName=replace(qryColumnList.label," ","_","all")>
					<cfif sum_flag EQ "1">
						<cfset value=qryTotals["#colName#_sum"]>
						<cfif value IS ""><cfset value="0"></cfif>
						<cfif qryColumnList.xtype EQ "60" AND isnumeric(value)><cfset value=dollarformat(value)></cfif>
						<div>
						<cfoutput>Sum: #value#</cfoutput>
						</div>
					</cfif>
					<cfif avg_flag EQ "1">
						<cfset value=qryTotals["#colName#_avg"]>
						<cfif value IS ""><cfset value="0"></cfif>
						<cfif qryColumnList.xtype EQ "60" AND isnumeric(value)><cfset value=dollarformat(value)>
						<cfelse><cfset value=symRound(value,4)>
						</cfif>
						<div>
						<cfoutput>Avg: #value#</cfoutput>
						</div>
					</cfif>
					<cfif min_flag EQ "1">
						<cfset value=qryTotals["#colName#_min"]>
						<cfif value IS ""><cfset value="-"></cfif>
						<cfif qryColumnList.xtype EQ "60" AND isnumeric(value)><cfset value=dollarformat(value)></cfif>
						<div>
						<cfoutput>Min: #value#</cfoutput>
						</div>
					</cfif>
					<cfif max_flag EQ "1">
						<cfset value=qryTotals["#colName#_max"]>
						<cfif value IS ""><cfset value="-"></cfif>
						<cfif qryColumnList.xtype EQ "60" AND isnumeric(value)><cfset value=dollarformat(value)></cfif>
						<div>
						<cfoutput>Max: #value#</cfoutput>
						</div>
					</cfif>
				<img src="assets/images/spcrimg.gif" height="1" width="1">
				</th>
			</cfloop>
		</tr>
	</cfif>

</cffunction>

<cffunction name="makeGroupStruct" access="public" returntype="struct" description="Make group structure, taking group query as input">
	<cfargument name="qry" type="query" required="Yes">
	<cfset var childQry = "">
	<cfset var st = "">
	
	<cfset st=structnew()>
	<cfif arguments.qry.recordcount EQ 0>
		<cfreturn st>
	<cfelse>
		<cfset st.label=arguments.qry.label>
		<cfset st.format=arguments.qry.report_group_format_id>
		<cfset st.xtype_cat=arguments.qry.xtype_cat>
		<cfquery dbtype="query" name="childQry">
			select * from qry
			where label <> '#arguments.qry.label#'
			order by seq
		</cfquery>
		<cfset st.child=makeGroupStruct(childQry)>
	</cfif>
	<cfreturn st>
</cffunction>
	