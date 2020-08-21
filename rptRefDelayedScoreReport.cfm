<!--- 
	FileName:	rptDelayedScoreReport.cfm
	Created on: 5/10/2011
	Created by: B.Cooper
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

7/8/2011, J. Oriente (ticket 10596)
- changed delay to greater than from less than in getResults query
06/16/17 - mgreenberg (TICKET NCSA22821) - report mods: updated datepicker and sorter.

--->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<script language="JavaScript" src="DatePicker.js"></script>
<cfoutput>
<div id="contentText">

<H1 class="pageheading">NCSA - Delayed Report of Score per Refree Login</H1>


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

<cfif isDefined("FORM.delay")>
	<cfset delay = FORM.delay>
<cfelse>
	<cfset delay = "">
</cfif>

<cfif isDefined("FORM.gameID") AND isNumeric(FORM.gameID)>
	<cfset gameID = FORM.gameID>
<cfelse>
	<cfset gameID = "">
</cfif>
<cfset errMsg = "">

<cfif isDefined("FORM.GO") OR isDefined("FORM.GOSINGLE") >

	<cfquery name="getResults" datasource="#application.dsn#">
	select fta.*, dbo.getTeamName(fta.h_team_id) as team_name, dbo.f_get_division(fta.h_team_id) as division, datediff(n,fta.game_datetime, fta.logcreatedate) as delay 
		from (
		select gl.game_id, g.game_datetime, gl.logcreatedate, gl.h_team_id, gl.v_team_id,
		g.field
		from 
		(
			SELECT 		game_id,
						min(logcreatedate) as logcreatedate,
						createdfrompage,
						logcreatedby,
						home_club_id,
						visitor_club_id,
						home_team_id as h_team_id,
						visitor_team_id as v_team_id
			FROM 		tbl_game_log 
			GROUP BY 	game_id,
						createdfrompage,
						logcreatedby,
						home_club_id,
						visitor_club_id,
						home_team_id,
						visitor_team_id
		) gl
		inner join
		(
			select contact_id as ref_contact_id from v_referees 
		) tc on gl.logcreatedby=tc.ref_contact_id
		inner join v_games_all g
		on gl.game_id=g.game_id
		where gl.createdfrompage like '%updateGameScore%'
		<cfif isdefined("form.gosingle") AND gameID NEQ "" AND isnumeric(gameID)>
			and gl.game_Id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#gameID#">
		<cfelse>
			and g.game_datetime >= <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#dateformat(weekendFrom,"m/d/yyyy")#">
			AND g.game_datetime <= <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#dateformat(weekendTo,"m/d/yyyy")# 23:59">
			<cfif flight NEQ "">
				AND dbo.f_get_division(gl.h_team_id) in (#listQualify(flight,"'")#)
			</cfif>
			<cfif delay NEQ "">
				AND datediff(n,g.game_datetime, gl.logcreatedate) >= <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#delay * 60#">
			</cfif>
		</cfif>
			<cfif Session.MenuRoleID EQ 28 OR Session.MenuRoleID EQ 27 OR Session.MenuRoleID EQ 26 OR Session.MenuRoleID EQ 25>
			and (gl.home_club_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.USER.CLUBID#"> or gl.visitor_club_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.USER.CLUBID#">)
			</cfif>
			group by gl.game_id, g.game_datetime, gl.logcreatedate,
		g.field, gl.h_team_id, gl.v_team_id
			) fta
	</cfquery>
</cfif>

<cfsavecontent variable="custom_css">
  <link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css">
</cfsavecontent>
<cfhtmlhead text="#custom_css#">

<FORM name="Games" action="rptRefDelayedScoreReport.cfm"  method="post">
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
			<b>Score Report Delay (hours)</b>
			<select name="delay">
				<option value="">Select All</option>
				<cfloop from="1" to="24" index="i">
					<option value="#i#" <cfif delay EQ i>selected="selected"</cfif>>#i#</option>
				</cfloop>
			</select>
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
	<input type="radio" id="sortLink1" name="radio" checked="checked" /><label for="sortLink1">Date/Flight/Team</label></label>
	<input type="radio" id="sortLink2" name="radio" /><label for="sortLink2">Team/Date</label>
	<input type="radio" id="sortLink3" name="radio" /><label for="sortLink3">Report Delay</label>
	<input type="radio" id="sortLink4" name="radio" /><label for="sortLink4">Game ##</label>
	<input type="radio" id="sortLink5" name="radio" /><label for="sortLink5">Division</label>
</div>
	<table id="resultTable" cellspacing="0" cellpadding="3" border="0" width="100%" class="table1">
		<thead>
		<tr>
			<th>Game</th>
			<th>Flight</th>
			<th>Date</th>
			<th>Field</th>
			<th>Team</th>
			<th>Delay</th>
		</TR>
		</thead>
		<tbody>
	<cfif getResults.recordCount GT 0> 
		<cfloop query="getResults">
			<tr>
				<td>#game_id#</td>
				<td>#division#</td>
				<td>#dateformat(game_datetime,"m/d/yyyy")# #timeformat(game_datetime,"h:mm tt")#</td>
				<td>#field#</td>
				<td>#team_name#</td>
				<td>
					<!--- get quarter hour increments --->
					<cfset rnd=int((delay mod 60)/60*4)/4>
					#int(delay / 60) + rnd#
				</td>
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
			sortList:[[2,0],[1,0],[4,0]]
		});
		
		//define button set for sort links
		$('##sortLinks').buttonset();
		
		$('##sortLink1').click(function(){
			var sorting = [[2,0],[1,0],[4,0]];
			$('##resultTable').trigger("sorton",[sorting]);
		});
		$('##sortLink2').click(function(){
			var sorting = [[4,0],[2,0]];
			$('##resultTable').trigger("sorton",[sorting]);
		});
		$('##sortLink3').click(function(){
			var sorting = [[5,0]];
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





