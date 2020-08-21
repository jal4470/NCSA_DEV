<!--- Purpose: To Render a Cross Tabulated Report --->
<!--- Get columns selected --->

<cfsilent>


	<cfset aggregates = "">
	<cfset aggregate_type = "">
	<cfset aggregate_format = "">
	<cfquery dbtype="query" name="getSumAggregates">
	select label from qrycolumnlist where sum_flag = 1
	</cfquery>
	<cfloop query="getSumAggregates">
		<cfset aggregates = aggregates & rereplace(label," ","_","ALL")>
		<cfset aggregate_type = aggregate_type & 'Sum'>
		<cfset aggregate_format = aggregate_format & 'Money'>
		<cfif getSumAggregates.currentrow neq getSumAggregates.recordcount>
			<cfset aggregates = aggregates & ",">
			<cfset aggregate_type = aggregate_type & ','>
			<cfset aggregate_format = aggregate_format & ','>
		</cfif>
	</cfloop>
	
	<cfquery dbtype="query" name="getCountAggregates">
	select label from qrycolumnlist where count_flag = 1
	</cfquery>
	<cfloop query="getCountAggregates">
		<cfif len(trim(aggregates))>
			<cfset aggregates = aggregates & ",">
			<cfset aggregate_type = aggregate_type & ','>
			<cfset aggregate_format = aggregate_format & ','>
		</cfif>
		<cfset aggregates = aggregates & rereplace(label," ","_","ALL")>
		<cfset aggregate_type = aggregate_type & 'Count'>
		<cfset aggregate_format = aggregate_format & 'Number'>
	
	</cfloop>
	
	<cfquery dbtype="query" name="getAvgAggregates">
	select label from qrycolumnlist where avg_flag = 1
	</cfquery>
	<cfloop query="getAvgAggregates">
		<cfif len(trim(aggregates))>
			<cfset aggregates = aggregates & ",">
			<cfset aggregate_type = aggregate_type & ','>
			<cfset aggregate_format = aggregate_format & ','>
		</cfif>
		<cfset aggregates = aggregates & rereplace(label," ","_","ALL")>
		<cfset aggregate_type = aggregate_type & 'Avg'>
		<cfset aggregate_format = aggregate_format & 'Number'>
	
	</cfloop>
	
	<cfquery dbtype="query" name="getMinAggregates">
	select label from qrycolumnlist where min_flag = 1
	</cfquery>
	<cfloop query="getMinAggregates">
		<cfif len(trim(aggregates))>
			<cfset aggregates = aggregates & ",">
			<cfset aggregate_type = aggregate_type & ','>
			<cfset aggregate_format = aggregate_format & ','>
		</cfif>
		<cfset aggregates = aggregates & rereplace(label," ","_","ALL")>
		<cfset aggregate_type = aggregate_type & 'Min'>
		<cfset aggregate_format = aggregate_format & 'Decimal'>
	
	</cfloop>
	
	
	<cfquery dbtype="query" name="getMaxAggregates">
	select label from qrycolumnlist where max_flag = 1
	</cfquery>
	<cfloop query="getMaxAggregates">
		<cfif len(trim(aggregates))>
			<cfset aggregates = aggregates & ",">
			<cfset aggregate_type = aggregate_type & ','>
			<cfset aggregate_format = aggregate_format & ','>
		</cfif>
		<cfset aggregates = aggregates & rereplace(label," ","_","ALL")>
		<cfset aggregate_type = aggregate_type & 'Max'>
		<cfset aggregate_format = aggregate_format & 'Decimal'>
	
	</cfloop>
	
	
	
	
	
	<cfset header_cols = "">
	<cfquery dbtype="query" name="getHeaderCols">
	select label from qrygroupinfo where report_group_type_id = 2 order by seq
	</cfquery>
	<cfloop query="getHeaderCols">
		<cfset header_cols = header_cols & rereplace(label," ","_","ALL")>
		<cfif getHeaderCols.currentrow neq getHeaderCols.recordcount>
			<cfset header_cols = header_cols & ",">
		</cfif>
	</cfloop>
	
	<cfset row_cols = "">
	<cfquery dbtype="query" name="getRowCols">
	select label from qrygroupinfo where report_group_type_id = 1 order by seq
	</cfquery>
	<cfloop query="getRowCols">
		<cfset row_cols = row_cols & rereplace(label," ","_","ALL")>
		<cfif getRowCols.currentrow neq getRowCols.recordcount>
			<cfset row_cols = row_cols & ",">
		</cfif>
	</cfloop>
	
	<!--- 1) Set the attributes --->
	<cfscript>
		CrossTabAttribs = StructNew();
		CrossTabAttribs.RS = getData;
		//CrossTabAttribs.Qry = "select distinct  top 20 user_id, convert(varchar,month(datecreated))  as month1, convert(varchar,year(datecreated)) as year1, count(user_access_id) as access_count, count(status_id) as status_count
	//from tbl_user_access
	//where datediff(d,datecreated,'1/1/2009') < 0
	//group by user_id, datecreated";
		CrossTabAttribs.Header_cols = "#header_cols#";
		CrossTabAttribs.Header_col_format = "";
		CrossTabAttribs.Row_cols = "#row_cols#";
		CrossTabAttribs.Row_col_format = "";
		CrossTabAttribs.Aggregates = "#aggregates#";
		CrossTabAttribs.Aggregates_format = "#aggregate_format#"; //valid types are Money, Number, Decimal and Percentage
		CrossTabAttribs.Aggregate_type = "#aggregate_type#"; // valid types are SUM, COUNT, AVG
		CrossTabAttribs.DSN = '#reports_dsn#';
		if (isdefined('url.xls'))
			{CrossTabAttribs.Disposition = 'XLS';
			CrossTabAttribs.XLS = url.xls;}
		else if (isdefined('url.pdf'))
			{CrossTabAttribs.Disposition = 'PDF';}
		else
			{CrossTabAttribs.Disposition = 'Screen';}
		CrossTabAttribs.Report_id = "#report_id#";
	</cfscript>
	
	<!--- 2) Call the module --->
	<cfmodule template="rptBldr_renderCrossTab.cfm" attributecollection="#CrossTabAttribs#" >
	</cfsilent>
	<!--- 3) Render Cross Tab --->
	<cfif isdefined('url.xls')>
		<cfif xls EQ 1>
		<cfheader name="Content-Disposition" value="inline; filename=""#getReport.report_name#_#dateformat(now(),"m-d-yyyy")#_summary.xls""">
		<cfelse>
		<cfheader name="Content-Disposition" value="inline; filename=""#getReport.report_name#_#dateformat(now(),"m-d-yyyy")#.xls""">
		</cfif>
		<cfcontent type="application/msexcel">
		<cfoutput>#crossTab#</cfoutput>
	<cfelseif isdefined('url.pdf')>
		<cfheader name="Content-Disposition" value="inline; filename=""#getReport.report_name#_#dateformat(now(),"m-d-yyyy")#.pdf""">
		<cfdocument format="PDF" pageheight="8.5" orientation="LANDSCAPE"  fontembed="Yes" scale="80" >
			<cfoutput>#crossTab#</cfoutput>
		</cfdocument>
	<cfelse><cfoutput>#crossTab#</cfoutput>
	</cfif>
