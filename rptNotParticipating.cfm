<!--- 
	FileName:	rptPlayingUp.cfm
	Created on: 5/9/2011
	Created by: B.Cooper
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

7/8/2011, J. Oriente (ticket 10596)
- updated "Flight" column from play_up_division to mdf_division
06/16/17 - mgreenberg (TICKET NCSA22821) - report mods: updated datepicker.
07/20/17 - apinzone (27024) - Added club filtering
--->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<script language="JavaScript" src="DatePicker.js"></script>
<cfoutput>
<div id="contentText">

<H1 class="pageheading">NCSA - Players/Coaches Not Participating - Data List Report</H1>


<cfif isDefined("FORM.op")>
	<cfset op = FORM.op > 
<cfelseif isDefined("URL.op")>
	<cfset op = URL.op > 
<cfelse>
	<cfset op = 0 > 
</CFIF>

<cfif isDefined("FORM.Clubselected")>
	<cfset Clubselected = FORM.Clubselected>
<cfelse>
	<cfset Clubselected = "">
</cfif>

<cfset clubRoles = "25,26,27,28">

<cfif isDefined("FORM.WeekendFrom")>
	<cfset WeekendFrom = dateFormat(FORM.WeekendFrom,"mm/dd/yyyy") > 
<cfelse>
	<cfset WeekendFrom = dateFormat(session.currentseason.startdate,"mm/dd/yyyy") > 
</CFIF>

<cfif isDefined("FORM.WeekendTo")>
	<cfset WeekendTo   = dateFormat(FORM.WeekendTo,"mm/dd/yyyy") >
<cfelse>
	<cfset WeekendTo   = dateFormat(now(),"mm/dd/yyyy") >
</CFIF>

<cfif isDefined("FORM.flight")>
	<cfset flight = FORM.flight>
<cfelse>
	<cfset flight = "">
</cfif>

<cfif isDefined("FORM.gameID") AND isNumeric(FORM.gameID)>
	<cfset gameID = FORM.gameID>
<cfelse>
	<cfset gameID = "">
</cfif>
<cfset errMsg = "">

<cfif isDefined("FORM.GO") OR isDefined("FORM.GOSINGLE") >
	<cfquery name="getResults" datasource="#application.dsn#" >
		select game_id,(select game_date from v_games where game_id = x.game_id) as game_date, PlayerName as Participant, ParticipantType,dbo.GetTeamName(teamid) as Team 
		from [dbo].[tbl_referee_RPT_detail] x where eventType = 4
		<cfif isdefined("form.gosingle") AND gameID NEQ "" AND isnumeric(gameID)>
			and game_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#gameID#">
		<cfelse>
			and exists(select 1 from v_games where game_date >= <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#dateformat(weekendFrom,"m/d/yyyy")#">
			AND game_date <= <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#dateformat(weekendTo,"m/d/yyyy")# 23:59">
			AND game_id = x.game_id)
		</cfif>
		<cfif isdefined("Flight") and len(trim(Flight))>
			AND dbo.GetTeamName(teamid) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Flight#%">
		</cfif>
		<cfif ListFind(clubRoles, Session.MenuRoleID) OR Clubselected GT 0>
			and exists(select 1 from tbl_team where team_id = x.teamid and club_id = 
				<cfif ListFind(clubRoles, Session.MenuRoleID)>
	         		<cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.USER.CLUBID#">
				<cfelseif Clubselected GT 0>	
					<cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.Clubselected#">
				</cfif>
				)
		</cfif>
	</cfquery>
</cfif>

<!--- FLIGHTS LIST FOR FILTERING --->
<cfquery name="qAllFlights" datasource="#SESSION.DSN#">
  select distinct dbo.f_get_division(team_id) as playLevel from tbl_team
  where dbo.f_get_division(team_id) <> ''
  order by dbo.f_get_division(team_id)
</cfquery>

<!--- CLUB LIST FOR FILTERING --->
<CFQUERY name="qClubs" datasource="#SESSION.DSN#">
  SELECT distinct cl.club_id, cl.Club_name, cl.ClubAbbr
  FROM   tbl_club cl   
  order by cl.club_name 
</CFQUERY>


<!---
PAGE BODY
------------------------------------------->
<cfsavecontent variable="custom_css">
	<link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css">
</cfsavecontent>
<cfhtmlhead text="#custom_css#">

<FORM name="Games" action="rptNotParticipating.cfm"  method="post">
<input type="hidden" id="op" name="op" value="#op#" />

<!--- FORM ELEMENT STRUCTURE --->
<section id="formElements">
	<div class="multi_game">
		<div class="container">

			<div class="date_range">
				<div class="date">
					<label>From</label>
					<INPUT type="text" name="WeekendFrom" value="#VARIABLES.WeekendFrom#" size="9">
				</div>
				<div class="date">
					<label>To</label>
					<INPUT type="text" name="WeekendTo" value="#VARIABLES.WeekendTo#" size="9">
				</div>
			</div>

			<div class="flight_select">
				<label>Flight</label>
				<SELECT name="flight" multiple size="5"> 
					<OPTION value="" >Select All</OPTION>
					<CFLOOP query="qAllFlights">
						<OPTION value="#playLevel#" <cfif listfindnocase(flight,playLevel)>selected</cfif> >#playLevel#</OPTION>
					</CFLOOP>
				</SELECT>
			</div>

			<div class="club_select">
				<cfif ListFind(clubRoles, Session.MenuRoleID)>
					<input type="hidden" value="#SESSION.USER.CLUBID#" name="Clubselected" />
				<cfelse>
					<label>Club</label>
					<select name="Clubselected">
						<option value="0">All Clubs</option>
						<CFLOOP query="qClubs">
							<option value="#CLUB_ID#" <CFIF CLUB_ID EQ VARIABLES.Clubselected>selected</CFIF> >#CLUB_NAME#</option>
						</CFLOOP>
					</select>
				</cfif>
			</div>

			<div class="filter_submit">
				<input type="SUBMIT" name="Go"  value="Go" >  
			</div>

		</div>
	</div>

	<div class="single_game">
		<div class="container">
			<label>Game Number</label>
			<input type="text" name="gameID" value="#VARIABLES.gameID#">
			<span class="input_info">(overrides all filters)</span>
			<input class="single_submit" type="SUBMIT" name="GoSingle"  value="Get Single Game" >
		</div>
	</div>

</section>
</FORM>

<CFIF IsDefined("getResults")>
<!--- <h3>Sort by:</h3>
<div id="sortLinks" style="font-size:10px; margin:0 0 10px;">
	<input type="radio" id="sortLink1" name="radio" checked="checked" /><label for="sortLink1">Date/Flight/Team with MDF</label>
	<input type="radio" id="sortLink2" name="radio" /><label for="sortLink2">Team with MDF/Date</label>
	<input type="radio" id="sortLink3" name="radio" /><label for="sortLink3">Team Playing Up From/Date</label>
	<input type="radio" id="sortLink4" name="radio" /><label for="sortLink4">Game ##</label>
	<input type="radio" id="sortLink5" name="radio" /><label for="sortLink5">Division</label>
</div> --->
	<table id="resultTable" cellspacing="0" cellpadding="3" border="0" width="100%" class="table1">
		<thead>
		<tr>
			<th>Game</th>
			<th>Flight</th>
			<th>Date</th>
			<th>Team</th>
			<th>Participant</th>
			<th>Participant Type</th>
		</TR>
		</thead>
		<tbody>
	<cfif getResults.recordCount GT 0>
		<cfloop query="getResults">
			<tr>
				<td>
			<cfif op EQ "1">
			#game_id#
			<cfelse>
			<a target="_blank" href="gameRefReportPrint.cfm?gid=#game_id#">#game_id#</a>
			</cfif>
			</td>
				<td>#GetToken(getResults.team, 2, '-')#</td>
				<td>#dateformat(game_date,"m/d/yyyy")#</td>
				<td>#Team#</td>
				<td>#Participant#</td>
				<td>#ParticipantType#</td>
			</tr>
		</cfloop>
	<cfelse>
		<td></td><td></td><td></td><td></td><td></td><td></td>
	</cfif>
		</tbody>
	</table>	
	
	
</CFIF>

</cfoutput>
</div>

<cfsavecontent variable="cf_footer_scripts">
<cfoutput>
<script language="JavaScript" type="text/javascript" src="assets/jquery.tablesorter.min.js"></script>
<script language="JavaScript" type="text/javascript" src="assets/jquery-ui-1.12.1.min.js"></script>
<script language="JavaScript" type="text/javascript">
	$(function(){
		$('input[name=WeekendFrom],input[name=WeekendTo]').datepicker();
		
		$('##resultTable').tablesorter({
			/*headers:{
				3:{
					sorter:false
				}
			},*/
			sortList:[[2,0],[1,0],[3,0]]
		});
		
		//define button set for sort links
		$('##sortLinks').buttonset();
		
		$('##sortLink1').click(function(){
			var sorting = [[2,0],[1,0],[3,0]];
			$('##resultTable').trigger("sorton",[sorting]);
		});
		$('##sortLink2').click(function(){
			var sorting = [[3,0],[2,0]];
			$('##resultTable').trigger("sorton",[sorting]);
		});
		$('##sortLink3').click(function(){
			var sorting = [[6,0],[2,0]];
			$('##resultTable').trigger("sorton",[sorting]);
		});
		$('##sortLink4').click(function(){
			var sorting = [[0,0]];
			$('##resultTable').trigger("sorton",[sorting]);
		});
		$('##sortLink5').click(function(){
			var sorting = [[1,0]];
			$('##resultTable').trigger("sorton",[sorting]);
		});
		
	});
</script>
</cfoutput>
</cfsavecontent>

<cfinclude template="_footer.cfm">




