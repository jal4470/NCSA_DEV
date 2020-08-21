<!--- 
	FileName:	rptTeamsMisMatchedDiv.cfm
	Created on: 02/20/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
	
MODS: mm/dd/yyyy - filastname - comments
5/26/2010 B. Cooper
9292-limit list to current season

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<cfoutput>
<div id="contentText">


<H1 class="pageheading">NCSA - Teams With Mismatched Divisions</H1>
<!--- <br><h2>yyyyyy </h2> 
<span class="red">Fields marked with * are required</span>
<CFSET required = "<FONT color=red>*</FONT>">--->


<CFQUERY name="qTeams" datasource="#SESSION.DSN#">
	SELECT g.game_code, g.game_id, g.game_id, g.game_date, g.game_time, g.division_id AS GAME_DIVISION,
		  t.TEAM_ID, ISNULL(T.gender, '') + RIGHT(T.teamAge, 2) + ISNULL(T.playLevel, '') + ISNULL(T.playgroup, '') AS TEAM_DIVISION
		  , dbo.GetTeamName(T.team_id) AS TEAMNAME
		  , xgt.IsHomeTeam
	  FROM xref_Game_Team XGT
			INNER JOIN tbl_game G ON g.GAME_ID = XGT.GAME_ID
			INNER JOIN TBL_TEAM T ON t.TEAM_ID = XGT.TEAM_ID
	WHERE XGT.SEASON_ID = #SESSION.CurrentSeason.ID#
	AND g.division_id <> ISNULL(T.gender, '') + RIGHT(T.teamAge, 2) + ISNULL(T.playLevel, '') + ISNULL(T.playgroup, '')
	and g.season_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#SESSION.CurrentSeason.ID#">
	ORDER BY g.division_id, G.GAME_ID
</CFQUERY>
<table cellspacing="0" cellpadding="4" align="center" border="0" width="100%">
	<tr class="tblHeading">
		<TD width="15%">Game ID</TD>
		<TD width="15%">Game Div</TD>
		<TD width="15%">Team Div</TD>
		<TD width="15%">Team ID</TD>
		<TD width="25%">Team Name</TD>
		<TD width="15%">H/V</TD>
	</tr>
</table>

<div style="overflow:auto;height:300px;border:1px ##cccccc solid;">
	<table cellspacing="0" cellpadding="3" align="center" border="0" width="98%">
	<CFLOOP query="qTeams">
		<tr  bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> <!--- currentRow or counter --->
			<TD class="tdUnderLine" width="15%" valign="top"> #game_id#</TD>
			<TD class="tdUnderLine" width="15%" valign="top"> #GAME_DIVISION# </TD>
			<TD class="tdUnderLine" width="15%" valign="top"> #TEAM_DIVISION# </TD>
			<TD class="tdUnderLine" width="15%" valign="top"> #TEAM_ID# </TD>
			<TD class="tdUnderLine" width="25%" valign="top"> #TEAMNAME# </TD>
			<TD class="tdUnderLine" width="15%" valign="top"> 
					<cfif IsHomeTeam>
						Home
					<cfelse>
						Visitor
					</cfif> 
			
			</TD>
		</tr>
	</CFLOOP>
	</table>
</div>


</cfoutput>
</div>
<cfinclude template="_footer.cfm">
