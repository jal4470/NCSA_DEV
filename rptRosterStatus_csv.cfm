

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
		WHERE T.season_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.currentseason.id#">
			AND T.playLevel <> 'R'
		<cfif showMissingRoster eq 1>
			AND 
			  r.content is null 
		<cfelseif showMissingRoster eq 0 >
			AND 
			  r.content is not null
		</cfif>
		<CFIF LEN(TRIM(VARIABLES.ORDER))>
			order by  <cfoutput>#variables.sort# #variables.order#</cfoutput>
		</CFIF>
	</CFQUERY>	

<!--- create download file --->	
<CFIF isDefined("registeredTeams") AND registeredTeams.RECORDCOUNT >
	<CFSET filename = "#SESSION.USER.CONTACTID#RosterStatus.csv" >
	<CFSET output = "">

	<CFSET output = output & "Team Id,Team Name,Uploaded" & chr(13) & chr(10) >
	<CFLOOP query="registeredTeams">
			<CFSET output = output & """#team_id#"",""#teamName#"",""#RosterStatus#""">
			<cfset output = output & chr(13) & chr(10)>
	</CFLOOP>
</CFIF>

<cfheader name="Content-disposition" value="attachment;filename=#filename#"> 
<cfcontent type="application/vnd.Microsoft Excel Comma Seperated Values 
	File; charset=utf-8" variable="#ToBinary( ToBase64( output ) )#"> <!--- To prevent whitespace in CSV, do a cfcontent workaround --->
