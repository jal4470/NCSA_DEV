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
		count_flag
	  FROM tbl_report
	 WHERE report_id = <cfqueryparam value="#report_id#">
	</cfquery>
	
	
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
<cfdump var=#qrycolumnlist# expand="No" label="columns">
	
	<!--- get group info --->
	<CFSTOREDPROC datasource="#reports_dsn#" procedure="p_get_report_groups" returncode="YES" >
		<CFPROCRESULT name="qrygroupinfo" RESULTSET="1">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#report_id#" DBVARNAME="@report_id">
	</CFSTOREDPROC>
<cfdump var=#qrygroupinfo# expand="No" label="groups">	

	<!--- generate group nested structure --->
	<cfset stGroups=structnew()>
	<cfset stGroups.label="">
	<cfset stGroups.format="">
	<cfset stGroups.xtype_cat="">
	<cfset stGroups.child=makeGroupStruct(qrygroupinfo)>
<cfdump var=#stGroups# expand="No" label="stgroups">
	
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
			});
		</script>
		
		<style type="text/css">
			#resultTable{
				border-top:1px solid black;
				border-left:1px solid black;
				color:black;
			}
			#resultTable th{
				font-size:12px;
			}
			#resultTable td{
				font-size:11px;
			}
			#resultTable th, #resultTable td{
				padding:5px;
				border-right:1px solid black;
				border-bottom:1px solid black;
			}
			#resultTable .groupHeader0 th{
				background-color:#938EB2;
			}
			#resultTable .groupHeader1 th{
				background-color:#A8A3CC;
			}
			#resultTable .groupHeader2 th{
				background-color:#BDB7E5;
			}
			#resultTable .groupHeader3 th{
				background-color:#D2CCFF;
			}
			#resultTable .tableHeader th{
				background-color:#7E7A99;
			}
			#resultTable .detailRow td{
				
			}
		</style>
		
		
	</head>
	
	
	<body>

		<CFINCLUDE TEMPLATE="header_rptBldr.cfm">
		<div style="height:10px;width:auto;"> </div>
		
		<table border="0" cellspacing="0" cellpadding="4" width="100%">
			<tr>
				<td class="mainhead" width="50%">Report Results<cfoutput query="getReport"><CFIF report_name IS NOT "">: </CFIF>#report_name#</cfoutput></td>
				<td class="mainhead" width="50%" align="right"><cfinclude template="tpl_rptBldr_save_report.cfm"></td>
			</tr>
		</table>
		
		<form action="rptBldr_display_action.cfm" method="post">
		<cfoutput><input type="hidden" name="report_id" value="#report_id#"></cfoutput>
		  
		<!--- BUTTONS --->
		<table border="0" cellspacing="0" cellpadding="4" width="100%">
			<tr>
				<td class="mainsubhead" width="10">&nbsp;</td>
				<td class="mainsubhead">
				<CFOUTPUT>
				<table cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td width="85">
						<input type="button" value="Edit" class="itemformbuttonleft" onclick="window.location='rptBldr_context.cfm?report_id=<cfoutput>#report_id#</cfoutput>';">
						</td>
						<td width="145">
						<cfinclude template="tpl_rptBldr_jump_menu.cfm">
						</td>
						<td width="75">
						<input type="button" value="Home" onclick="window.location='rptBldr_home.cfm';" class="itemformbuttonleft">
						</td>
					</tr>
				</table>
				</CFOUTPUT>
				</td>
			</tr>
		</table>
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
		
		
		
		<a id="hideDetailsLink" href="javascript:void(0);">Hide Details</a><a id="showDetailsLink" href="javascript:void(0);" style="display:none;">Show Details</a>
		
		<table id="resultTable" border="0" cellpadding="0" cellspacing="0">
			<!--- display report headers --->
			<tr class="tableHeader">
			<cfloop query="qryColumnList">
				<th>
					<cfoutput>#label#</cfoutput>
				</th>
			</cfloop>
			</tr>
			
			<cfoutput>#showGroup(getData,stGroups)#</cfoutput>
			
		</table>
		
		
		
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
	<cfset lSelect="">
	<cfloop query="qryColumnList">
		<cfif sum_flag EQ 1>
			<cfset lSelect=listappend(lSelect,"sum(#replace(label," ","_","all")#) as #replace(label," ","_","all")#_sum")>
		</cfif>
		<cfif avg_flag EQ 1>
			<cfset lSelect=listappend(lSelect,"avg(#replace(label," ","_","all")#) as #replace(label," ","_","all")#_avg")>
		</cfif>
		<cfif min_flag EQ 1>
			<cfset lSelect=listappend(lSelect,"min(#replace(label," ","_","all")#) as #replace(label," ","_","all")#_min")>
		</cfif>
		<cfif max_flag EQ 1>
			<cfset lSelect=listappend(lSelect,"max(#replace(label," ","_","all")#) as #replace(label," ","_","all")#_max")>
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
		<tr class="groupHeader<cfoutput>#level#</cfoutput>">
			<th colspan="<cfoutput>#qryColumnList.recordcount#</cfoutput>" style="text-align:left; white-space:nowrap; vertical-align:top;">
				<div style="padding-left:<cfoutput>#level*15#</cfoutput>">
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
		<tr class="groupHeader<cfoutput>#level#</cfoutput> groupHeadRow">
			<cfloop query="qryColumnList">
				<th style="text-align:left;">
					<!--- what column? --->
					<cfset colName=replace(qryColumnList.label," ","_","all")>
					<cfif sum_flag EQ "1">
						<cfset value=qryTotals["#colName#_sum"]>
						<cfif value EQ ""><cfset value="0"></cfif>
						<cfif qryColumnList.xtype EQ "60" AND isnumeric(value)><cfset value=dollarformat(value)></cfif>
						<div>
						<cfoutput>Sum:#value#</cfoutput>
						</div>
					</cfif>
					<cfif avg_flag EQ "1">
						<cfset value=qryTotals["#colName#_avg"]>
						<cfif value EQ ""><cfset value="0"></cfif>
						<cfif qryColumnList.xtype EQ "60" AND isnumeric(value)><cfset value=dollarformat(value)>
						<cfelse><cfset value=symRound(value,4)>
						</cfif>
						<div>
						<cfoutput>Avg:#value#</cfoutput>
						</div>
					</cfif>
					<cfif min_flag EQ "1">
						<cfset value=qryTotals["#colName#_min"]>
						<cfif value EQ ""><cfset value="-"></cfif>
						<cfif qryColumnList.xtype EQ "60" AND isnumeric(value)><cfset value=dollarformat(value)></cfif>
						<div>
						<cfoutput>Min:#value#</cfoutput>
						</div>
					</cfif>
					<cfif max_flag EQ "1">
						<cfset value=qryTotals["#colName#_max"]>
						<cfif value EQ ""><cfset value="-"></cfif>
						<cfif qryColumnList.xtype EQ "60" AND isnumeric(value)><cfset value=dollarformat(value)></cfif>
						<div>
						<cfoutput>Max:#value#</cfoutput>
						</div>
					</cfif>
					&nbsp;
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
				 is null
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
		<tr class="groupHeader<cfoutput>#level#</cfoutput>">
			<th colspan="<cfoutput>#qryColumnList.recordcount#</cfoutput>" style="text-align:left; white-space:nowrap; vertical-align:top;">
				<div style="padding-left:<cfoutput>#level*15#</cfoutput>">
					<cfoutput>
						Grand Totals (#qry.recordcount# record<cfif qry.recordcount NEQ 1>s</cfif>)
						
					</cfoutput>
				</div>
			</th>
		</tr>
		<tr class="groupHeader<cfoutput>#level#</cfoutput> groupHeadRow">
			<cfloop query="qryColumnList">
				<th style="text-align:left;">
					<!--- what column? --->
					<cfset colName=replace(qryColumnList.label," ","_","all")>
					<cfif sum_flag EQ "1">
						<cfset value=qryTotals["#colName#_sum"]>
						<cfif value EQ ""><cfset value="0"></cfif>
						<cfif qryColumnList.xtype EQ "60" AND isnumeric(value)><cfset value=dollarformat(value)></cfif>
						<div>
						<cfoutput>Sum:#value#</cfoutput>
						</div>
					</cfif>
					<cfif avg_flag EQ "1">
						<cfset value=qryTotals["#colName#_avg"]>
						<cfif value EQ ""><cfset value="0"></cfif>
						<cfif qryColumnList.xtype EQ "60" AND isnumeric(value)><cfset value=dollarformat(value)>
						<cfelse><cfset value=symRound(value,4)>
						</cfif>
						<div>
						<cfoutput>Avg:#value#</cfoutput>
						</div>
					</cfif>
					<cfif min_flag EQ "1">
						<cfset value=qryTotals["#colName#_min"]>
						<cfif value EQ ""><cfset value="-"></cfif>
						<cfif qryColumnList.xtype EQ "60" AND isnumeric(value)><cfset value=dollarformat(value)></cfif>
						<div>
						<cfoutput>Min:#value#</cfoutput>
						</div>
					</cfif>
					<cfif max_flag EQ "1">
						<cfset value=qryTotals["#colName#_max"]>
						<cfif value EQ ""><cfset value="-"></cfif>
						<cfif qryColumnList.xtype EQ "60" AND isnumeric(value)><cfset value=dollarformat(value)></cfif>
						<div>
						<cfoutput>Max:#value#</cfoutput>
						</div>
					</cfif>
					&nbsp;
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
	