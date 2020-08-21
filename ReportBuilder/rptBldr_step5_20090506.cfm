<!----------------------------->
<!--- Application variables --->
<!----------------------------->
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
		count_flag
	  FROM tbl_report
	 WHERE report_id = <cfqueryparam value="#report_id#">
	</cfquery>
	
	
	<CFSTOREDPROC datasource="#reports_dsn#" procedure="p_run_report" returncode="YES" >
		<CFPROCRESULT name="getData" RESULTSET="1">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#report_id#" DBVARNAME="@report_id">
	</CFSTOREDPROC>
<!--- <cfdump var=#getdata# expand="No"> --->
	
	<!--- get column list --->
	<cfquery datasource="#reports_dsn#" name="qrycolumnList">
		select a.view_col_id, b.view_col_display_label as label, a.seq, a.sum_flag, a.avg_flag, a.min_flag, a.max_flag
		from tbl_report_col a
			inner join tbl_view_column b
			on a.view_col_id=b.view_col_id
		where report_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#report_id#">
		order by a.seq
	</cfquery>
<cfdump var=#qrycolumnlist# expand="No">
	
	<!--- get group info --->
	<cfquery datasource="#reports_dsn#" name="getGroupInfo">
		select a.view_col_id, a.view_col_value, b.view_col_display_label
		from tbl_report_group a
		inner join tbl_view_column b
		on a.view_col_id=b.view_col_id
		where a.report_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#report_id#">
		and a.report_group_type_id=1
		order by a.seq
	</cfquery>
<cfdump var=#getgroupinfo# expand="No">	
	
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



	<cfcatch>
		<cfinclude template="cfcatch.cfm">
	</cfcatch>
</cftry>
<!----------------->
<!--- Page body --->
<!----------------->
<html>
	
	<head>
		<script language="JavaScript" type="text/javascript" src="assets/jquery-1.3.2.min.js"></script>
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
					
					$("#resultTable tr").not(":first").not(":last").not(":last").hide();
					
				});
			});
		</script>
		
		<style type="text/css">
			#resultTable{
				border-top:1px solid black;
				border-left:1px solid black;
			}
			#resultTable th, #resultTable td{
				padding:5px;
				border-right:1px solid black;
				border-bottom:1px solid black;
			}
		</style>
		
		
	</head>
	
	
	<body>
		<form action="rptBldr_step5_action.cfm" method="post">
		<cfoutput><input type="hidden" name="report_id" value="#report_id#"></cfoutput>
		<b>Report Results</b> <cfinclude template="tpl_rptBldr_save_report.cfm"> <input type="button" value="Edit" onclick="window.location='rptBldr_step1.cfm?report_id=<cfoutput>#report_id#</cfoutput>';"> <input type="button" value="Home" onclick="window.location='rptBldr_home.cfm';"> <cfinclude template="tpl_rptBldr_jump_menu.cfm"><br>
		</form>
		<cfoutput query="getReport">#report_name#</cfoutput><hr>
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
		
		
		
		<a id="hideDetailsLink" href="javascript:void(0);">Hide Details</a><a id="showDetailsLink" href="javascript:void(0);" style="display:none;">Show Details</a>
		
		<cfoutput>
			<table border="0" id="resultTable" cellpadding="0" cellspacing="0">
				<tr>
					<th>
						Row
					</th>
					<cfloop list="#mycolumnList#" index="i">
						<th>
							#i#
						</th>
					</cfloop>
				</tr>
				<cfloop query="getdata">
					<tr>
						<td>
							#currentRow#
						</td>
						<cfloop list="#mycolumnList#" index="i">
							<td>
								<cfset output=#getdata[i]#><!--- why can't I just output it! --->
								<cfif isdate(output)>
									#dateformat(output,"mm/dd/yyyy")#
								<cfelse>
									#output#
								</cfif>
								
								<!--- aggregate work --->
								<cfif currentRow EQ 1>
									<cfif structkeyexists(stAggregate,"#i#_sum") AND isnumeric(output)>
										<cfset stAggregate["#i#_sum"] = output>
									</cfif>
									<cfif structkeyexists(stAggregate,"#i#_avg") AND isnumeric(output)>
										<cfset stAggregate["#i#_avg"] = output>
									</cfif>
									<cfif structkeyexists(stAggregate,"#i#_min") AND isnumeric(output)>
										<cfset stAggregate["#i#_min"] = output>
									</cfif>
									<cfif structkeyexists(stAggregate,"#i#_max") AND isnumeric(output)>
										<cfset stAggregate["#i#_max"] = output>
									</cfif>
								<cfelse>
									<cfif structkeyexists(stAggregate,"#i#_sum") AND isnumeric(output)>
										<cfif isnumeric(stAggregate["#i#_sum"])>
											<cfset stAggregate["#i#_sum"] = stAggregate["#i#_sum"] + output>
										<cfelse>
											<cfset stAggregate["#i#_sum"] = output>
										</cfif>
									</cfif>
									<cfif structkeyexists(stAggregate,"#i#_avg") AND isnumeric(output)>
										<cfif isnumeric(stAggregate["#i#_avg"])>
											<cfset stAggregate["#i#_avg"] = stAggregate["#i#_avg"] + output>
										<cfelse>
											<cfset stAggregate["#i#_avg"] = output>
										</cfif>
									</cfif>
									<cfif structkeyexists(stAggregate,"#i#_min") AND isnumeric(output)>
										<cfif not isnumeric(stAggregate["#i#_min"]) OR output LT stAggregate["#i#_min"]>
											<cfset stAggregate["#i#_min"] = output>
										</cfif>
									</cfif>
									<cfif structkeyexists(stAggregate,"#i#_max") AND isnumeric(output)>
										<cfif not isnumeric(stAggregate["#i#_max"]) OR output GT stAggregate["#i#_max"]>
											<cfset stAggregate["#i#_max"] = output>
										</cfif>
									</cfif>
								</cfif>
								<cfif output EQ "">
									&nbsp;
								</cfif>
							</td>
						</cfloop>
					</tr>
				</cfloop>
				
				<tr>
					<td colspan="#listlen(mycolumnlist)+1#" style="background-color:##eeeeee; font-weight:bold; border:none;">
						Grand Totals <cfif getReport.count_flag EQ 1>(#getdata.recordCount# Records)</cfif>
					</td>
				</tr>
				<tr>
					<td style="background-color:##eeeeee; border:none;">
						&nbsp;
					</td>
				
					<!--- aggregate row --->
					<cfloop list="#mycolumnList#" index="i">
						<td style="background-color:##eeeeee; white-space:nowrap; vertical-align:top; border:none;">
							<cfif structkeyexists(stAggregate,"#i#_sum") AND isnumeric(stAggregate["#i#_sum"])>
								<div>
									Sum #stAggregate["#i#_sum"]#
								</div>
							</cfif>
							<cfif structkeyexists(stAggregate,"#i#_avg") AND isnumeric(stAggregate["#i#_avg"])>
								<div>
									Avg #symRound(stAggregate["#i#_avg"]/getdata.recordcount,4)#
								</div>
							</cfif>
							<cfif structkeyexists(stAggregate,"#i#_min") AND isnumeric(stAggregate["#i#_min"])>
								<div>
									Min #stAggregate["#i#_min"]#
								</div>
							</cfif>
							<cfif structkeyexists(stAggregate,"#i#_max") AND isnumeric(stAggregate["#i#_max"])>
								<div>
									Max #stAggregate["#i#_max"]#
								</div>
							</cfif>
						</td>
					</cfloop>
				</tr>
			</table>
		</cfoutput>
		
		
		
		
		
		</table>
	</body>
</html>