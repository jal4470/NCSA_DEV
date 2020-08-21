
<!--- <cfmodule template="renderCrossTab" attributecollection="CrossTabAttribs">
CrossTabAttribs.Qry -- Main Query Used.
CrossTabAttribs.Header Cols -- list of Header Columns
CrossTabAttribs.RowColumns -- List of RowColumns
CrossTabAttribs.Aggregates -- List of Aggregates.
 --->
<!--- Purpose: To Render a Cross Tabulated Report --->
<!--- Get columns selected --->
<!--- Author: Joe Lechuga jlechuga@capturepoint.com
	   JAL 7/17/2009 -- Initial Revision
	   JAL 9/01/2009 -- Added Export/Print Toolbar
 --->

<CFSETTING REQUESTTIMEOUT="5000" >

<cfif isdefined("attributes.xls") and attributes.xls eq 2 and isdefined('attributes.rs')>

	<cfsavecontent variable="detail">
		<cfoutput>		
			<table>
				<tr>
					<cfloop list="#attributes.rs.columnList#" index="i">
						<!--- <cfif not find('(',i)> --->
						<th>#i#</th>
						<!--- </cfif> --->
					</cfloop>
				</tr>
				<cfloop query="attributes.rs">
					<tr>
						<cfloop list="#attributes.rs.columnList#" index="i">
							<Cfset value = attributes.rs["#i#"]>
							<td>#value#</td>
						</cfloop>
					</tr>
				</cfloop>
			</table>
		</cfoutput> 
	</cfsavecontent>
	<cfset caller.crosstab = detail>

<cfelse>

<CFSET HEADER_COLS = ATTRIBUTES.HEADER_COLS>
<CFSET ROW_COLS = ATTRIBUTES.ROW_COLS>
<CFSET AGGREGATES = ATTRIBUTES.AGGREGATES>
<CFPARAM NAME="head1" DEFAULT="">
<CFPARAM NAME="head2" DEFAULT="">
<CFPARAM NAME="head3" DEFAULT="">
<CFPARAM NAME="row1" DEFAULT="">
<CFPARAM NAME="row2" DEFAULT="">
<CFPARAM NAME="row3" DEFAULT="">


<CFIF ISDEFINED("attributes.Aggregates_format")>
	<CFSET AGGREGATE_FORMAT_PRE = "">
	<CFSET AGGREGATE_FORMAT_POST = "">
	<CFSET CTF = 1>

	<CFLOOP LIST="#attributes.Aggregates_format#" INDEX="i">	
	<CFIF CTF GT 1>
		<CFSET AGGREGATE_FORMAT_PRE = AGGREGATE_FORMAT_PRE & "|">
		<CFSET AGGREGATE_FORMAT_POST = AGGREGATE_FORMAT_POST & "|">
	</CFIF>
		<CFSWITCH EXPRESSION="#i#">
			<CFCASE VALUE="Number">
				<CFSET AGGREGATE_FORMAT_PRE = AGGREGATE_FORMAT_PRE & "lsnumberformat(">
				<CFSET AGGREGATE_FORMAT_POST = AGGREGATE_FORMAT_POST & "#chr(44)#'(___)')">
			</CFCASE>
			<CFCASE VALUE="Money">
				<CFSET AGGREGATE_FORMAT_PRE = AGGREGATE_FORMAT_PRE & "dollarformat(">
				<CFSET AGGREGATE_FORMAT_POST = AGGREGATE_FORMAT_POST & ")">
			</CFCASE>
			<CFCASE VALUE="Percentage">
				<CFSET AGGREGATE_FORMAT_PRE = AGGREGATE_FORMAT_PRE & "lsnumberformat(">
				<CFSET AGGREGATE_FORMAT_POST = AGGREGATE_FORMAT_POST & "#chr(44)#'%(__)')">
			</CFCASE>
			<CFCASE VALUE="Decimal">
				<CFSET AGGREGATE_FORMAT_PRE = AGGREGATE_FORMAT_PRE & "lsnumberformat(">
				<CFSET AGGREGATE_FORMAT_POST = AGGREGATE_FORMAT_POST & "#chr(44)#'(_,___.__)')">
			</CFCASE>
		</CFSWITCH>
		<CFSET CTF = CTF + 1>
	</CFLOOP>

</CFIF>

<CFIF ISDEFINED('attributes.qry')>
	<CFQUERY NAME="getAllData" DATASOURCE="#attributes.dsn#">
	#preservesinglequotes(attributes.qry)#
	</CFQUERY>
</CFIF>

<CFIF ISDEFINED('attributes.rs')>
	<CFSET CTA = 1>
	<CFSET AGGREGATE_TYPE = "">
	<CFSET VARIABLES.AGGREGATES = "">
	<CFLOOP LIST="#attributes.Aggregates#" INDEX="i">
		<CFIF CTA GT 1>
			<CFSET AGGREGATE_TYPE = AGGREGATE_TYPE & " , ">
			<CFSET VARIABLES.AGGREGATES = VARIABLES.AGGREGATES & ",">
		</CFIF>
		<CFSET AGGREGATE_TYPE = AGGREGATE_TYPE & LISTGETAT(ATTRIBUTES.AGGREGATE_TYPE,CTA) & "(" & I & ") as " & I & '_' & LISTGETAT(ATTRIBUTES.AGGREGATE_TYPE,CTA)>
		<CFSET VARIABLES.AGGREGATES = VARIABLES.AGGREGATES & I & '_' & LISTGETAT(ATTRIBUTES.AGGREGATE_TYPE,CTA)>
		<CFSET CTA = CTA + 1>
	</CFLOOP>
	
	<CFSET SELECTION = HEADER_COLS & ',' & ROW_COLS & ',' & AGGREGATE_TYPE>
	<CFSET GROUP_BY = HEADER_COLS & ',' & ROW_COLS >

	<!--- <cfoutput>select 
			#selection#
		from 
			attributes.rs
		group by 
			#group_by#</cfoutput><cfabort> --->
	<CFQUERY NAME="getAllData" DBTYPE="query">
		select 
			#selection#
		from 
			attributes.rs
		group by 
			#group_by#
	</CFQUERY>
<!--- <cfdump var="#getAllData#"> --->
</CFIF>

<CFQUERY NAME="getHeader" DBTYPE="query">
	select distinct 
		#attributes.header_cols#
 	from 
		getAllData
</CFQUERY>

<!--- Get Header Columns --->


<!--- Clear the Screen --->
<CFSET ARRAYCOUNT = 0>
<CFLOOP LIST="#attributes.header_cols#" INDEX="i">
<CFSET ARRAYCOUNT = ARRAYCOUNT + 1>
<CFSET "head#arrayCount#" =  "#i#">
</CFLOOP>
<CFLOOP LIST="#Aggregates#" INDEX="i">
	<CFPARAM NAME="#i#rowtotal" TYPE="numeric"  DEFAULT="0">
	<CFLOOP FROM="1" TO="#arrayCount#" INDEX="k">
		<CFPARAM NAME="#i#columnTotal#k#" TYPE="numeric" DEFAULT= "0">

	</CFLOOP>
			<CFPARAM NAME="#i#columnTotal" TYPE="numeric" DEFAULT= "0">
</CFLOOP>
<CFSAVECONTENT VARIABLE="crossTab">
<CFOUTPUT>

<cfif attributes.DISPOSITION eq 'PDF'>
<STYLE TYPE="text/css">
table.main {
  border-collapse: collapse;
  border-spacing: 2;  
    border:solid black 0px;
}
table {
 
  font-family:arial;font-size:9pt;
  border:solid black 0px;
}
td{border: solid silver .5px;}

td.detail{  border-collapse: inherit;
  border-spacing: 2;  
  float:right;}
.total{background:##ccccff;color:black;font-weight:bold;}
.SUBHEAD{FONT-SIZE:7PT;FONT-FAMILY:ARIAL;}
</STYLE>
<cfelse>
<!--- <STYLE TYPE="text/css">
table.main {
  border-collapse: collapse;
  border-spacing: 0;  
}
table {
 
  font-family:arial;font-size:9pt;
}
td{border: solid black .5px;}

td.detail{  border-collapse: inherit;
  border-spacing: 2;  
  border: solid black .5px;}
.total{background:##ccccff;color:black;font-weight:bold;}
.SUBHEAD{FONT-SIZE:7PT;FONT-FAMILY:ARIAL;}
</STYLE> --->
</cfif>
<!--- Render Header Columns ---><!--- 
<cfdump var="#attributes#"><cfabort> --->
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" id="matrixTable">
	<TR>
	<!--- Set Span based on the levels of Row Headers --->
		<th colspan="#listlen(row_cols)#" rowspan="#listlen(header_cols)#" align="center" valign="middle">
			
			<cfif attributes.DISPOSITION eq 'XLS' or attributes.DISPOSITION eq 'PDF'>
				&nbsp;&nbsp;#dateformat(now(),'mmm-dd-yyyy')#
			<cfelse>
				<a href="rptBldr_display.cfm?s=#caller.securestring#&xls=1&report_id=#attributes.report_id#" title="Export to Excel"><!--- <img src="assets\images\excelicon.gif" border="0"  height="15px" align="top"> --->Summary</a>&nbsp;&nbsp;&nbsp;
				<a href="rptBldr_display.cfm?s=#caller.securestring#&xls=2&report_id=#attributes.report_id#" title="Export to Excel"><!--- <img src="assets\images\excelicon.gif" border="0"  height="15px" align="top"> --->Detail</a>&nbsp;&nbsp;&nbsp;
				<a href="javascript:print();" title="Print"><img src="assets\images\printericon.gif" border="0" height="15px" ></a>
			</cfif>
		</th>
		
		<CFSET HEADERARRAY = ARRAYNEW(2)>
		<!--- guild headerArray --->
		<cfloop query="getHeader">
			<cfloop from="1" to="#listlen(attributes.header_cols)#" index="i">
				<CFSET HEADERARRAY[#GETHEADER.CURRENTROW#][#i#] = #evaluate(evaluate("head#i#"))#>
			</cfloop>
		</cfloop>
		
		<!--- loop header array to create headers --->
		<cfloop from="1" to="#arraylen(headerarray[1])#" index="i">
			<cfloop query="getHeader">
				<th colspan="#listlen(variables.aggregates)#" class="groupHeader#i#">
					#evaluate(evaluate("head#i#"))#
				</th>
			</cfloop>
			<cfif i EQ 1>
				<th colspan="#listlen(row_cols)#" rowspan="#listlen(header_cols)#">
					Row Totals
				</th>
			</cfif>
			<cfif i NEQ arraylen(headerarray[1])>
				</tr><tr>
			</cfif>
		</cfloop>
		
		
	</tr>
	<tr>
		<cfset headCt=1>
		<CFLOOP LIST="#row_cols#" INDEX="i">
			<TH CLASS="groupHeader#headCt#">#i#</TH>
			<cfset headCt=headCt+1>
		</CFLOOP>
		
		<!--- loop to create aggregate headers --->
		<CFLOOP QUERY="getHeader">
				<cfset headCt=0>
				<CFLOOP  LIST="#variables.aggregates#" INDEX="i">
					<TH class="aggHeader">#rereplace(i,'_',' ','all')#</TH>
					<cfset headCt=headCt+1>
				</CFLOOP>
		</CFLOOP>
		
		<!--- row total aggregate labels --->
		<CFLOOP  LIST="#variables.aggregates#" INDEX="i">
			<TH class="aggHeader">#rereplace(i,'_',' ','ALL')#</TH>
		</CFLOOP>
	
	</tr>

<!--- <cfdump var="#MonthYear1#"> --->

<!--- Retrieve Row Detail --->
<CFQUERY NAME="getRowdata" DBTYPE="query" >
	select distinct #attributes.row_cols# 
	from getAllData
	order by #attributes.row_cols#
</CFQUERY>
<!--- <cfdump var="#getRowdata#"> --->
<CFSET ROWS = 0>

<CFLOOP QUERY="getRowdata">
<tr>
	<!--- Render Rowheader when it's on the first row --->
	<CFIF GETROWDATA.CURRENTROW MOD 1 EQ 0>
		<CFSET CT = 1>
		<CFLOOP LIST="#attributes.row_cols#" INDEX="i">
			<CFOUTPUT><TD width="#(100/(listLen(attributes.row_cols)+getHeader.recordcount+1))#%" >#evaluate("getRowdata."& i)#</TD></CFOUTPUT>
			<CFSET "row#CT#" = #DE('getRowdata.'& I)#>
			<CFSET CT= CT+1>
		</CFLOOP>
	<CFSET ROWS = CT>
	</CFIF>
	
	<!--- Loop thru array --->
	
	
	<CFLOOP INDEX="intI" FROM="1" TO="#ArrayLen( HeaderArray )#" STEP="1">
		<!--- Retrieve record for given array value --->
		
		<CFSET HEADQRYSTRING ="">
		<CFSET ALLMETADATA=GETMETADATA(GETALLDATA)>
		<CFIF ARRAYCOUNT GT 1>
			 <CFLOOP FROM="1" TO="#arrayCount#" STEP="1" INDEX="i">
			 		<CFLOOP INDEX="j" FROM="1" TO="#arrayLen(allmetadata)#">
						<CFIF ALLMETADATA[J].NAME EQ EVALUATE("Head"& I) >
							<CFSET METATYPE = ALLMETADATA[J].TYPENAME>
						</CFIF>
							
					</CFLOOP>

					
					<CFIF METATYPE EQ 'varchar' OR METATYPE EQ 'timestamp'>
						<CFSET QUALIFIER = "'">
					<CFELSE>
						<CFSET QUALIFIER = "">
					</CFIF>
					<CFSET HEADQRYSTRING = HEADQRYSTRING &  EVALUATE("Head"& I) & " = " & QUALIFIER & rereplace(HEADERARRAY[INTI][I],"'","''","ALL") & QUALIFIER & IIF(I NEQ ARRAYCOUNT AND ARRAYCOUNT GT 1,DE(" And "),DE(" "))>
			</CFLOOP>
		<CFELSE>
			<CFLOOP INDEX="i" FROM="1" TO="#arrayLen(allmetadata)#">
						<CFIF ALLMETADATA[I].NAME EQ EVALUATE("Head"& 1) >
							<CFSET METATYPE = ALLMETADATA[I].TYPENAME>
						</CFIF>
							
			</CFLOOP>
			<CFIF METATYPE EQ 'varchar' OR METATYPE EQ 'timestamp'>
						<CFSET QUALIFIER = "'">
					<CFELSE>
						<CFSET QUALIFIER = "">
					</CFIF>
			<CFSET HEADQRYSTRING = HEADQRYSTRING &   EVALUATE("Head"& 1) & " = " & QUALIFIER & rereplace(HEADERARRAY[INTI][1],"'","''","ALL") & QUALIFIER>


		</CFIF>

		
	
		<CFQUERY NAME="getAggregates" DBTYPE="query">
			select #variables.aggregates# from getAllData 
			where 
			<CFLOOP FROM=1 TO="#ListLen(Row_Cols)#" INDEX="i" >
					<CFLOOP INDEX="j" FROM="1" TO="#arrayLen(allmetadata)#">
						<CFIF ALLMETADATA[J].NAME EQ #LISTGETAT(ROW_COLS,I)# >
							<CFSET METATYPE = ALLMETADATA[J].TYPENAME>
						</CFIF>		
					</CFLOOP>
					<CFIF METATYPE EQ 'VARCHAR' OR METATYPE EQ 'TIMESTAMP'>
						<CFSET QUALIFIER = "#chr(39)#">
					<CFELSE>
						<CFSET QUALIFIER = "">
					</CFIF>
						#ListGetAt(Row_Cols,i)# = #preservesinglequotes(qualifier)##rereplace(evaluate(chr(35) & rereplace(rereplace(evaluate('row' & i ),"""","","ALL"),"'","''","ALL") & chr(35)),"'","''","ALL")##preservesinglequotes(qualifier)#
					and 	
					</CFLOOP>
					#preservesinglequotes(headQryString)# 
					
		</CFQUERY>	
		
		
			<CFSET CT = 0>
			<CFLOOP LIST="#variables.aggregates#" INDEX="i">
			<CFSET CT = CT + 1>
			<CFSET AGGRVALUE =  EVALUATE("getAggregates." & I) >
			<CFIF EVALUATE("getAggregates."& I ) LT 0 AND LEN(TRIM(EVALUATE("getAggregates."& I )))>
				<CFSET DETSTYLE= "color:red;">
			<CFELSEIF NOT LEN(TRIM(EVALUATE("getAggregates."& I )))>
				<CFSET DETSTYLE= "color:silver;">
				<CFSET AGGRVALUE = 0>
			<CFELSE>
				<CFSET DETSTYLE= "color:blue;">	
			</CFIF>
			
			
			<CFSET AGGRTODISPLAY = LISTGETAT(AGGREGATE_FORMAT_PRE,CT,'|') & AGGRVALUE & LISTGETAT(AGGREGATE_FORMAT_POST,CT,'|')>

			
			<TD>
#evaluate(aggrToDisplay)#&nbsp;&nbsp;</TD>
					
					<CFSCRIPT>
						if (not isdefined("#i#columntotal#intI#"))
							"#i#columntotal#intI#" = 0;
						if (evaluate("getAggregates."& i ) neq "")
						{
						"#i#rowtotal" = #evaluate(i&'rowtotal')# + evaluate("getAggregates."& i );
						"#i#columntotal" = #evaluate(i&'columntotal')# + evaluate("getAggregates."& i );
						"#i#columntotal#IntI#" = #evaluate(i&'columntotal'&IntI)# + evaluate("getAggregates."& i );
						}
					</CFSCRIPT>
		
			</CFLOOP>
	</CFLOOP>
		
			<CFSET CT = 1>
			<CFLOOP LIST="#Aggregates#" INDEX="i">
				<CFIF EVALUATE(I&'rowtotal') LT 0 >
					<CFSET ROWSUMSTYLE= "color:red;">
				<CFELSE>
					<CFSET ROWSUMSTYLE= "color:black;">
				</CFIF>
				<CFSET RTOTTODISPLAY = LISTGETAT(AGGREGATE_FORMAT_PRE,CT,'|') & I &'rowtotal' & LISTGETAT(AGGREGATE_FORMAT_POST,CT,'|')>
					<TD><SPAN STYLE="#RowSumStyle#">#evaluate(rTotToDisplay)#&nbsp;&nbsp;</SPAN></TD>
					<CFSET "#i#rowtotal" = 0>
				<CFSET CT = CT +1>
			</CFLOOP>
	<!--- Begin Outputing Data --->
	</TR>
</CFLOOP>

<!--- TOTALS ROW --->
	<TR>
		<Th COLSPAN="#listLen(row_cols)#" ALIGN="right" class="groupHeader0">Totals:</ThD>
		<CFLOOP FROM="1" TO="#ArrayLen( HeaderArray )#" INDEX="k">
		
			<CFSET CT = 1>
			<CFLOOP LIST="#Aggregates#" INDEX="i">	
				<CFIF EVALUATE(I & 'columnTotal' & K) LT 0 >
					<CFSET COLSUMSTYLE= "color:red;">
				<CFELSE>
					<CFSET COLSUMSTYLE= "color:black;">
				</CFIF>
				<CFSET CTOTTODISPLAY = LISTGETAT(AGGREGATE_FORMAT_PRE,CT,'|') & I &'columnTotal' & K & LISTGETAT(AGGREGATE_FORMAT_POST,CT,'|')>
				<Th class="groupHeader0"><SPAN STYLE="#ColSumStyle#" >#evaluate(cTotToDisplay)#&nbsp;&nbsp;</SPAN></Th>
				<CFSET CT = CT +1>
			</CFLOOP>
		</CFLOOP>
	
		<!--- TOTAL TOTALS --->
		<CFSET CT = 1>
		<CFLOOP LIST="#Aggregates#" INDEX="i">
			<CFIF EVALUATE(I & 'columnTotal' ) LTE 0 >
				<CFSET TOTSUMSTYLE= "color:red;">
			<CFELSE>
				<CFSET TOTSUMSTYLE= "color:black;">
			</CFIF>
			<CFSET TOTTODISPLAY = LISTGETAT(AGGREGATE_FORMAT_PRE,CT,'|') & I &'columnTotal' & LISTGETAT(AGGREGATE_FORMAT_POST,CT,'|')>
			<th class="groupHeader0"><SPAN STYLE="#TotSumStyle#">#evaluate(TotToDisplay)#&nbsp;&nbsp;</SPAN></th>
			<CFSET CT = CT +1>
		</CFLOOP>
	</TR>
</TABLE>
</CFOUTPUT>
</CFSAVECONTENT>
<CFSET CALLER.CROSSTAB = CROSSTAB>
</cfif>


