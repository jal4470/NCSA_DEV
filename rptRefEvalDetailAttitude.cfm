<!--- 
	FileName:	rptrefEvalDetailAttitude.cfm
	Created on: 5/11/2011
	Created by: B.Cooper
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
MODIFICATIONS
7/8/2011, J. Oriente (ticket 10596)
- added active_yn='Y' to getRefs query
11/16/2016 - R. Gonzalez (ticket ???)
- removed comments from cfquery
06/16/17 - mgreenberg (TICKET NCSA22821) - report mods: updated datepicker and sorter.
--->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<script language="JavaScript" src="DatePicker.js"></script>
<cfoutput>
<div id="contentText">

<H1 class="pageheading">NCSA - Detailed Ref Evaluation - Attitude</H1>


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

	<cfquery name="getResults" datasource="#application.dsn#">
	select fta.*,
	
		dbo.f_get_contact_fullname(fta.ref_id) as ref_name,
		dbo.getTeamName(fta.team_id) as team_name, 
		dbo.f_get_division(fta.team_id) as division from
		(
		select 
		resp.ref_id, 
		resp.position, 
		resp.home_team_players, 
		resp.home_team_coaches,
		resp.home_team_spectators,
		resp.away_team_players,
		resp.away_team_coaches,
		resp.away_team_spectators,
		resp.officials,
		g.value as game_id,
		t.value as team_id, 
		gg.field, 
		gg.game_datetime
		from
		(
			select r.response_id, r.value as ref_id, q1.value as home_team_players, q2.value as home_team_coaches, 
			q3.value as home_team_spectators, q4.value as away_team_players, q5.value as away_team_coaches, 
			q6.value as away_team_spectators, q7.value as officials, 'CR' as position from
			dbo.f_get_choice_responses(90,82) r
			left join dbo.f_get_responses(31,76) q1
			on r.response_id=q1.response_id
			left join dbo.f_get_responses(32,76) q2
			on r.response_id=q2.response_id
			left join dbo.f_get_responses(33,76) q3
			on r.response_id=q3.response_id
			left join dbo.f_get_responses(34,76) q4
			on r.response_id=q4.response_id
			left join dbo.f_get_responses(35,76) q5
			on r.response_id=q5.response_id
			left join dbo.f_get_responses(36,76) q6
			on r.response_id=q6.response_id
			left join dbo.f_get_responses(37,76) q7
			on r.response_id=q7.response_id
			UNION ALL
			select r.response_id, r.value as ref_id, q1.value as home_team_players, q2.value as home_team_coaches, 
			q3.value as home_team_spectators, q4.value as away_team_players, q5.value as away_team_coaches, 
			q6.value as away_team_spectators, q7.value as officials, 'CR' as position from
			dbo.f_get_choice_responses(90,81) r
			left join dbo.f_get_responses(31,15) q1
			on r.response_id=q1.response_id
			left join dbo.f_get_responses(32,15) q2
			on r.response_id=q2.response_id
			left join dbo.f_get_responses(33,15) q3
			on r.response_id=q3.response_id
			left join dbo.f_get_responses(34,15) q4
			on r.response_id=q4.response_id
			left join dbo.f_get_responses(35,15) q5
			on r.response_id=q5.response_id
			left join dbo.f_get_responses(36,15) q6
			on r.response_id=q6.response_id
			left join dbo.f_get_responses(37,15) q7
			on r.response_id=q7.response_id
			UNION ALL
			select r.response_id, r.value as ref_id, q1.value as home_team_players, q2.value as home_team_coaches, 
			q3.value as home_team_spectators, q4.value as away_team_players, q5.value as away_team_coaches, 
			q6.value as away_team_spectators, q7.value as officials, 'AR1' as position from
			dbo.f_get_choice_responses(91,81) r
			left join dbo.f_get_responses(31,34) q1
			on r.response_id=q1.response_id
			left join dbo.f_get_responses(32,34) q2
			on r.response_id=q2.response_id
			left join dbo.f_get_responses(33,34) q3
			on r.response_id=q3.response_id
			left join dbo.f_get_responses(34,34) q4
			on r.response_id=q4.response_id
			left join dbo.f_get_responses(35,34) q5
			on r.response_id=q5.response_id
			left join dbo.f_get_responses(36,34) q6
			on r.response_id=q6.response_id
			left join dbo.f_get_responses(37,34) q7
			on r.response_id=q7.response_id
			UNION ALL
			select r.response_id, r.value as ref_id, q1.value as home_team_players, q2.value as home_team_coaches, 
			q3.value as home_team_spectators, q4.value as away_team_players, q5.value as away_team_coaches, 
			q6.value as away_team_spectators, q7.value as officials, 'AR2' as position from
			dbo.f_get_choice_responses(92,81) r
			left join dbo.f_get_responses(31,43) q1
			on r.response_id=q1.response_id
			left join dbo.f_get_responses(32,43) q2
			on r.response_id=q2.response_id
			left join dbo.f_get_responses(33,43) q3
			on r.response_id=q3.response_id
			left join dbo.f_get_responses(34,43) q4
			on r.response_id=q4.response_id
			left join dbo.f_get_responses(35,43) q5
			on r.response_id=q5.response_id
			left join dbo.f_get_responses(36,43) q6
			on r.response_id=q6.response_id
			left join dbo.f_get_responses(37,43) q7
			on r.response_id=q7.response_id
		) resp
		inner join dbo.f_get_choice_responses(69,null) g
		on resp.response_id=g.response_id
		inner join dbo.f_get_choice_responses(70,null) t
		on g.response_id=t.response_id
		inner join v_games_all gg
		on g.value=gg.game_id
		<cfif isdefined("form.gosingle") AND gameID NEQ "" AND isnumeric(gameID)>
			where g.value = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#gameID#">
		<cfelse>
			where gg.game_datetime >= <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#dateformat(weekendFrom,"m/d/yyyy")#">
			AND gg.game_datetime <= <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#dateformat(weekendTo,"m/d/yyyy")# 23:59">
			<cfif flight NEQ "">
				AND gg.division in (#listQualify(flight,"'")#)
			</cfif>
			<cfif isdefined("form.ref") AND form.ref NEQ "">
				AND resp.ref_id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.ref#">
			</cfif>
			<cfif isdefined("form.position") AND form.position NEQ "">
				AND resp.position = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.position#">
			</cfif>
			<cfif isdefined("form.q1") AND form.q1 NEQ "">
				AND resp.home_team_players = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.q1#">
			</cfif>
			<cfif isdefined("form.q2") AND form.q2 NEQ "">
				AND resp.home_team_coaches = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.q2#">
			</cfif>
			<cfif isdefined("form.q3") AND form.q3 NEQ "">
				AND resp.home_team_spectators = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.q3#">
			</cfif>
			<cfif isdefined("form.q4") AND form.q4 NEQ "">
				AND resp.away_team_players = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.q4#">
			</cfif>
			<cfif isdefined("form.q5") AND form.q5 NEQ "">
				AND resp.away_team_coaches = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.q5#">
			</cfif>
			<cfif isdefined("form.q6") AND form.q6 NEQ "">
				AND resp.away_team_spectators = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.q6#">
			</cfif>
			<cfif isdefined("form.q7") AND form.q7 NEQ "">
				AND resp.officials = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.q7#">
			</cfif>
		</cfif>
		group by
		
		resp.ref_id, 
		resp.position, 
		resp.home_team_players, 
		resp.home_team_coaches,
		resp.home_team_spectators,
		resp.away_team_players,
		resp.away_team_coaches,
		resp.away_team_spectators,
		resp.officials,
		g.value,
		t.value, 
		gg.field, 
		gg.game_datetime
		
		) fta
	</cfquery>
	
</cfif>

<cfsavecontent variable="custom_css">
  <link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css">
</cfsavecontent>
<cfhtmlhead text="#custom_css#">

<FORM name="Games" action="rptRefEvalDetailAttitude.cfm"  method="post">
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
	<tr>
		<td>
			<div style="float:left; margin-right:10px;">
				<b>Flight</b>
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
			</div>
			<b>Ref Position</b>
			<select name="position">
				<option value="">Select All</option>
				<option value="CR" <cfif isdefined("form.position") AND form.position EQ "CR">selected="selected"</cfif>>CR</option>
				<option value="AR1" <cfif isdefined("form.position") AND form.position EQ "AR1">selected="selected"</cfif>>AR1</option>
				<option value="AR2" <cfif isdefined("form.position") AND form.position EQ "AR2">selected="selected"</cfif>>AR2</option>
			</select>
			<br>
			<cfquery name="getChoices" datasource="#application.dsn#">
				select choice_id, name
				from tbl_choice
				where question_group_id=15
			</cfquery>
			<b>Home Team Players</b>
			<select name="q1">
				<option value="">Select All</option>
				<cfloop query="getChoices">
					<option value="#name#" <cfif isdefined("form.q1") AND form.q1 EQ name>selected="selected"</cfif>>#name#</option>
				</cfloop>
			</select>
			<br>
			<b>Home Team Coaches</b>
			<select name="q2">
				<option value="">Select All</option>
				<cfloop query="getChoices">
					<option value="#name#" <cfif isdefined("form.q2") AND form.q2 EQ name>selected="selected"</cfif>>#name#</option>
				</cfloop>
			</select>
			<br>
			<b>Home Team Spectators</b>
			<select name="q3">
				<option value="">Select All</option>
				<cfloop query="getChoices">
					<option value="#name#" <cfif isdefined("form.q3") AND form.q3 EQ name>selected="selected"</cfif>>#name#</option>
				</cfloop>
			</select>
			<br>
			<b>Away Team Players</b>
			<select name="q4">
				<option value="">Select All</option>
				<cfloop query="getChoices">
					<option value="#name#" <cfif isdefined("form.q4") AND form.q4 EQ name>selected="selected"</cfif>>#name#</option>
				</cfloop>
			</select>
			<br>
			<b>Away Team Coaches</b>
			<select name="q5">
				<option value="">Select All</option>
				<cfloop query="getChoices">
					<option value="#name#" <cfif isdefined("form.q5") AND form.q5 EQ name>selected="selected"</cfif>>#name#</option>
				</cfloop>
			</select>
			<br>
			<b>Away Team Spectators</b>
			<select name="q6">
				<option value="">Select All</option>
				<cfloop query="getChoices">
					<option value="#name#" <cfif isdefined("form.q6") AND form.q6 EQ name>selected="selected"</cfif>>#name#</option>
				</cfloop>
			</select>
			<br>
			<b>Officials</b>
			<select name="q7">
				<option value="">Select All</option>
				<cfloop query="getChoices">
					<option value="#name#" <cfif isdefined("form.q7") AND form.q7 EQ name>selected="selected"</cfif>>#name#</option>
				</cfloop>
			</select>
			<br>
			<b>Referee</b>
			<cfquery name="getRefs" datasource="#application.dsn#">
				select distinct c.contact_id, lastname + ', ' + firstname as fullname, lastname, firstname
				from tbl_contact c
				inner join xref_contact_role cr
				on c.contact_id=cr.contact_id
				where cr.role_id=25 and c.active_yn = 'Y'
				order by lastname, firstname
			</cfquery>
				<select name="ref">
					<option value="">Select All</option>
					<cfloop query="getRefs">
						<option value="#contact_id#" <cfif isdefined("form.ref") AND form.ref EQ contact_id>selected="selected"</cfif>>#fullname#</option>
					</cfloop>
				</select>
			
			<input type="SUBMIT" name="Go"  value="Go">  
	
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
	<input type="radio" id="sortLink1" name="radio" /><label for="sortLink1">Date</label></label>
	<input type="radio" id="sortLink2" name="radio" /><label for="sortLink2">Game ##</label></label>
	<input type="radio" id="sortLink3" name="radio" /><label for="sortLink3">Flights</label></label>
	<input type="radio" id="sortLink4" name="radio" /><label for="sortLink4">Referee Name/Date</label>
	<input type="radio" id="sortLink5" name="radio" /><label for="sortLink5">Position/Referee Name</label>
	<input type="radio" id="sortLink6" name="radio" /><label for="sortLink6">Team Reporting</label>
</div>
<div class="table-container">
	<table id="resultTable" cellspacing="0" cellpadding="3" border="0" width="100%" class="table1">
		<thead>
		<tr>
			<th>Game</th>
			<th>Flight</th>
			<th>Date</th>
			<th>Team Reporting</th>
			<th>Referee</th>
			<th>Position</th>
			<th>Home Team Players</th>
			<th>Home Team Coaches</th>
			<th>Home Team Spectators</th>
			<th>Away Team Players</th>
			<th>Away Team Coaches</th>
			<th>Away Team Spectators</th>
			<th>Officials</th>
		</TR>
		</thead>
		<tbody>
	<cfif getResults.recordCount GT 0>
		<cfloop query="getResults">
			<tr>
				<td><a target="_blank" href="gameRefReportPrint.cfm?gid=#game_id#">#game_id#</a></td>
				<td>#division#</td>
				<td>#dateformat(game_datetime,"m/d/yyyy")# #timeformat(game_datetime,"h:mm tt")#</td>
				<td>#team_name#</td>
				<td>#ref_name#</td>
				<td>#position#</td>
				<td>#home_team_players#</td>
				<td>#home_team_coaches#</td>
				<td>#home_team_spectators#</td>
				<td>#away_team_players#</td>
				<td>#away_team_coaches#</td>
				<td>#away_team_spectators#</td>
				<td>#officials#</td>
			</tr>
		</cfloop>
	<cfelse>
		<td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
	</cfif>
		</tbody>
	</table>	
</div>
	
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
			sortList:[[4,0]]
		});
		
		//define button set for sort links
		$('##sortLinks').buttonset();
		
		$('##sortLink1').click(function(){
			var sorting = [[2,0]];
			$('##resultTable').trigger("sorton",[sorting]);
		});
		$('##sortLink2').click(function(){
			var sorting = [[0,0]];
			$('##resultTable').trigger("sorton",[sorting]);
		});
		$('##sortLink3').click(function(){
			var sorting = [[1,0]];
			$('##resultTable').trigger("sorton",[sorting]);
		});
		$('##sortLink4').click(function(){
			var sorting = [[4,0],[2,0]];
			$('##resultTable').trigger("sorton",[sorting]);
		});
		$('##sortLink5').click(function(){
			var sorting = [[5,0],[4,0]];
			$('##resultTable').trigger("sorton",[sorting]);
		});
		$('##sortLink6').click(function(){
			var sorting = [[3,0]];
			$('##resultTable').trigger("sorton",[sorting]);
		});
		
	});
</script>
</cfoutput>
</cfsavecontent>

<cfinclude template="_footer.cfm">





