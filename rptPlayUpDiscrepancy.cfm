<!--- 
	FileName:	rptPlayUpDiscrepancy.cfm
	Created on: 5/9/2011
	Created by: B.Cooper
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

7/8/2011, J. Oriente (ticket 10596)
- removed abs() from "difference" column output to allow negative numbers to display
7/12/2011, J. Oriente (ticket 10596)
- reversed "Difference" calculation from #mdf_play_up_cnt-play_up_cnt# to #play_up_cnt-mdf_play_up_cnt#
7/22/2011 - J. Lechuga - Modified query to include games without a mdf playup count.
06/16/17 - mgreenberg (TICKET NCSA22821) - report mods: updated datepicker and sorter.
--->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<script language="JavaScript" src="DatePicker.js"></script>
<cfoutput>
<div id="contentText">

<H1 class="pageheading">NCSA - Players Playing Up Compared to Referee Report Discrepancy</H1>


<cfif isDefined("FORM.op")>
	<cfset op = FORM.op > 
<cfelseif isDefined("URL.op")>
	<cfset op = URL.op > 
<cfelse>
	<cfset op = 0 > 
</CFIF>


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
<!--- Joe Lechuga 7/22/2011 - Added additional Union to select games that did not have a match_day_form --->
	<cfquery name="getResults" datasource="#application.dsn#">
	
		select game_id,t.team_id,team_name,t.division,game_datetime,play_up_cnt,match_day_form_id,mdf_play_up_cnt 
	from (
		select 
			r.game_id, 
			g.home as team_id, 
			g.home_teamname as team_name, 
			dbo.f_get_division(g.home) as division,
			g.game_datetime, 
			r.homeTeamPlayUpCnt as play_up_cnt, 
			mdf.match_day_form_id, 
			count(pu.play_up_id) as mdf_play_up_cnt
		from 
			tbl_referee_rpt_header r
				inner join v_games_all g
			on r.game_id=g.game_id
				inner join tbl_match_day_form mdf
			on g.game_id=mdf.game_id and g.home=mdf.team_id
				inner join tbl_play_up pu
			on mdf.match_day_form_id=pu.match_day_form_id
			<cfif Session.MenuRoleID EQ 28 OR Session.MenuRoleID EQ 27 OR Session.MenuRoleID EQ 26 OR Session.MenuRoleID EQ 25>
			where (g.home_club_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.USER.CLUBID#"> or g.visitor_club_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.USER.CLUBID#">)
			</cfif>
		group by 
			r.game_id, g.home, g.home_teamname, dbo.f_get_division(g.home),
		g.game_datetime, r.homeTeamPlayUpCnt, mdf.match_day_form_id
		UNION ALL
		select 
			r.game_id, 
			g.visitor as team_id, 
			g.visitor_teamname as team_name, 
			dbo.f_get_division(g.visitor) as division,
			g.game_datetime, 
			r.visitorTeamPlayUpCnt as play_up_cnt, 
			mdf.match_day_form_id, 
			count(pu.play_up_id) as mdf_play_up_cnt
		from 
			tbl_referee_rpt_header r
				inner join v_games_all g
			on r.game_id=g.game_id
				inner join tbl_match_day_form mdf
			on g.game_id=mdf.game_id and g.visitor=mdf.team_id
				inner join tbl_play_up pu
			on mdf.match_day_form_id=pu.match_day_form_id
			<cfif Session.MenuRoleID EQ 28 OR Session.MenuRoleID EQ 27 OR Session.MenuRoleID EQ 26 OR Session.MenuRoleID EQ 25>
			where (g.home_club_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.USER.CLUBID#"> or g.visitor_club_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.USER.CLUBID#">)
			</cfif>
		group by r.game_id, g.visitor, g.visitor_teamname, dbo.f_get_division(g.home),
		g.game_datetime, r.visitorTeamPlayUpCnt, mdf.match_day_form_id
		UNION
			select 
			r.game_id, 
			g.visitor as team_id, 
			g.visitor_teamname as team_name, 
			dbo.f_get_division(g.visitor) as division,
			g.game_datetime, 
			r.visitorTeamPlayUpCnt as play_up_cnt, 
			mdf.match_day_form_id, 
			0 as mdf_play_up_cnt
		from 
			tbl_referee_rpt_header r
				inner join v_games_all g
			on r.game_id=g.game_id
				inner join tbl_match_day_form mdf
			on g.game_id=mdf.game_id and g.visitor=mdf.team_id
			where not exists(select 1 from tbl_play_up where mdf.match_day_form_id=match_day_form_id)
			<cfif Session.MenuRoleID EQ 28 OR Session.MenuRoleID EQ 27 OR Session.MenuRoleID EQ 26 OR Session.MenuRoleID EQ 25>
			and (g.home_club_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.USER.CLUBID#"> or g.visitor_club_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.USER.CLUBID#">)
			</cfif>
		group by r.game_id, g.visitor, g.visitor_teamname, dbo.f_get_division(g.home),
		g.game_datetime, r.visitorTeamPlayUpCnt, mdf.match_day_form_id
		) t
		<cfif Session.MenuRoleID EQ 28 OR Session.MenuRoleID EQ 27 OR Session.MenuRoleID EQ 26 OR Session.MenuRoleID EQ 25>
		inner join tbl_team tm on (t.team_id = tm.team_id)
		</cfif>
		<cfif isdefined("form.gosingle") AND gameID NEQ "" AND isnumeric(gameID)>
			Where game_Id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#gameID#">
		<cfelse>
			where ((play_up_cnt <> mdf_play_up_cnt)  or (mdf_play_up_cnt = 0 and play_up_cnt <> 0 ))
			and game_datetime >= <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#dateformat(weekendFrom,"m/d/yyyy")#">
			AND game_datetime <= <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#dateformat(weekendTo,"m/d/yyyy")# 23:59">
			<cfif flight NEQ "">
				AND division in (#listQualify(flight,"'")#)
			</cfif>
			<cfif Session.MenuRoleID EQ 28 OR Session.MenuRoleID EQ 27 OR Session.MenuRoleID EQ 26 OR Session.MenuRoleID EQ 25>
			and tm.club_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.USER.CLUBID#">
			</cfif>
		</cfif>
	</cfquery>
</cfif>

<cfsavecontent variable="custom_css">
  <link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css">
</cfsavecontent>
<cfhtmlhead text="#custom_css#">

<FORM name="Games" action="rptPlayUpDiscrepancy.cfm"  method="post">
<input type="hidden" id="op" name="op" value="#op#" />
<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%" >
	<TR><TD align="left">
			<B>From</B> &nbsp;
				<INPUT name="WeekendFrom" value="#VARIABLES.WeekendFrom#" size="9">
			#repeatString("&nbsp;",3)#
			<B>To</B> &nbsp;
				<INPUT name="WeekendTo" value="#VARIABLES.WeekendTo#" size="9">
		</td>
		<td align="center">
			<B>Game Number </B> &nbsp;
				<input type="Text" name="gameID" value="#VARIABLES.gameID#" size="5">
				<br>(overrides all filters)
	
	 	</td>
	</tr>
	<tr><td><b>Flight</b>
				<cfquery name="qAllFlights" datasource="#SESSION.DSN#">
					select distinct dbo.f_get_division(team_id) as playLevel from tbl_team
					where dbo.f_get_division(team_id) <> ''
					order by dbo.f_get_division(team_id)
				</cfquery>
				<SELECT name="flight" multiple size="5"> 
					<OPTION value="" >Select All</OPTION>
					<CFLOOP query="qAllFlights">
						<OPTION value="#playLevel#" <cfif listfindnocase(flight,playLevel)>selected</cfif> >#playLevel#</OPTION>
					</CFLOOP>
				</SELECT>
			<input type="SUBMIT" name="Go"  value="Go" >  
	
		</td>
		<td align="center">
			<input type="SUBMIT" name="GoSingle"  value="Get Single Game" >  
		</td>
	</tr>

</table>	
</FORM>

<CFIF IsDefined("getResults")>
<h3>Sort by:</h3>
<div id="sortLinks" style="font-size:10px; margin:0 0 10px;">
	<input type="radio" id="sortLink1" name="radio" checked="checked" /><label for="sortLink1">Date/Team Name</label></label>
	<input type="radio" id="sortLink2" name="radio" /><label for="sortLink2">Team Name/Date</label>
	<input type="radio" id="sortLink3" name="radio" /><label for="sortLink3">Game ##</label>
	<input type="radio" id="sortLink4" name="radio" /><label for="sortLink4">Division</label>
</div>
	<table id="resultTable" cellspacing="0" cellpadding="3" border="0" width="100%" class="table1">
		<thead>
		<tr>
			<th>Game</th>
			<th>Flight</th>
			<th>Date</th>
			<th>Team</th>
			<th>Ref Report Total</th>
			<th>MDF Total</th>
			<th>Difference</th>
		</TR>
		</thead>
		<tbody>
	<cfif getResults.recordCount GT 0>
		<cfloop query="getResults">
			<tr>
				<td>
			<cfif op EQ "1">
			#game_id#
			<cfelse><a target="_blank" href="gameRefReportPrint.cfm?gid=#game_id#">#game_id#</a>
			</cfif>
			</td>
				<td>#division#</td>
				<td>#dateformat(game_datetime,"m/d/yyyy")#</td>
				<td><a target="_blank" href="matchDayFormView.cfm?match_day_form_id=#match_day_form_id#">#team_name#</a></td>
				<td>#play_up_cnt#</td>
				<td>#mdf_play_up_cnt#</td>
				<td>#play_up_cnt-mdf_play_up_cnt#</td>
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

<script language="JavaScript" type="text/javascript" src="assets/jquery-ui-1.12.1.min.js"></script>
<script language="JavaScript" type="text/javascript" src="assets/jquery.tablesorter.min.js"></script>

<script language="JavaScript" type="text/javascript">
	$(function(){
		$('input[name=WeekendFrom],input[name=WeekendTo]').datepicker();
		
		$('##resultTable').tablesorter({
			/*headers:{
				3:{
					sorter:false
				}
			},*/
			sortList:[[2,0],[3,0]]
		});
		
		//define button set for sort links
		$('##sortLinks').buttonset();
		
		$('##sortLink1').click(function(){
			var sorting = [[2,0],[3,0]];
			$('##resultTable').trigger("sorton",[sorting]);
		});
		$('##sortLink2').click(function(){
			var sorting = [[3,0],[2,0]];
			$('##resultTable').trigger("sorton",[sorting]);
		});
		$('##sortLink3').click(function(){
			var sorting = [[0,0]];
			$('##resultTable').trigger("sorton",[sorting]);
		});
		$('##sortLink4').click(function(){
			var sorting = [[1,0]];
			$('##resultTable').trigger("sorton",[sorting]);
		});
		
	});
</script>
</cfoutput>
</cfsavecontent>

<cfinclude template="_footer.cfm">





