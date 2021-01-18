<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<cfif isdefined("url.showMissingRoster")>
	<cfset showMissingRoster = url.showMissingRoster>
<cfelse>
	<cfset showMissingRoster = "">
</cfif>

<cfif isdefined("url.sort")>
	<cfset sort = url.sort>
<cfelse>
	<cfset sort = "team_id">
</cfif>

<cfif isdefined("url.order")>
	<cfset order = url.order>
<cfelse>
	<cfset order = "asc">
</cfif>

<CFQUERY name="registeredTeams" datasource="#SESSION.DSN#">
		SELECT 
			   T.team_id, T.teamName, CASE WHEN r.team_id is not null then 'Y' else 'N' end as RosterStatus,roster_id
		FROM    tbl_team T  LEFT JOIN tbl_roster r on r.team_id = t.team_id
		WHERE T.season_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.regseason.id#">
			AND T.playLevel <> 'R'
		<cfif showMissingRoster eq 1>
			AND 
			  r.content is null 
		<cfelseif showMissingRoster eq 0 >
			AND 
			  r.content is not null
		</cfif>
		<CFIF LEN(TRIM(VARIABLES.SORT))>
			order by <cfoutput>#variables.sort# #variables.order#</cfoutput>
		</CFIF>
	</CFQUERY>

<!--------------------------- 
	START PDF PAGE 
----------------------------->
<cfdocument 
	format="pdf" 
	marginBottom=".4"
	marginLeft=".3"
	marginRight=".3"
	marginTop=".75"  
	orientation="landscape" localurl="true"
	name="output">
<html>
	<head>
		<title>NCSA - Status of Roster Uploaded(Registration Season)</title>
		<style type="text/css">
			#teamResultsTable {
				border-width: 1px 0 0 1px;
				border-style: solid;
				border-color: #ccc;
			}
			#teamResultsTable th,
			#teamResultsTable td {
				border-width: 0 1px 1px 0;
				border-style: solid;
				border-color: #ccc;
			}
		</style>
	</head>
<body>
<H1 class="pageheading">NCSA - Status of Roster Uploaded(Registration Season)</H1>

<div id="teamRegInfoResults">
	<table width="1700" border="0" cellspacing="0" cellpadding="3" align="center" border="0" width="100%" id="teamResultsTable" class="tablesorter" style="table-layout:fixed;">
		<thead>
			<tr class="tblHeading">
				<th width="75" data-sort="prior_team_id" data-order="asc" align="center">Team Id</th>
				<th width="75" data-sort="prior_team_name" data-order="asc" align="center">Team Name</th>
				<th width="75" data-sort="team_id" data-order="asc" align="center">Uploaded</th>
			</tr>
		</thead>
		<tbody>
			<cfoutput query="registeredTeams">	
				<tr>
					<td width="75" align="center">#team_id#</td>
					<td width="75" align="center">#teamName#</td>
					<td width="250" align="center">#RosterStatus#</td>
				</tr>
			</cfoutput>
		</tbody>
	</table>
</div>
</body>
</html>
</cfdocument>
<CFSET filename = "#SESSION.USER.CONTACTID#RosterStatus.PDF" >
<cfheader name="Content-disposition" value="attachment;filename=#filename#"> 
<cfcontent type="application/vnd.Microsoft Excel Comma Seperated Values 
	File; charset=utf-8" variable="#ToBinary( ToBase64( output ) )#">