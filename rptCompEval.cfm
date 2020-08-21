<!--- 
	FileName:	rptCompEval.cfm
	Created on: 5/11/2011
	Created by: B.Cooper
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
06/16/17 - mgreenberg (TICKET NCSA22821) - report mods: updated datepicker and sorter.

--->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<script language="JavaScript" src="DatePicker.js"></script>
<cfoutput>
<div id="contentText">

<H1 class="pageheading">NCSA - Competition Evaluation</H1>


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
		dbo.getTeamName(fta.team_id) as team_name, 
		dbo.f_get_division(fta.team_id) as division,
		dbo.getTeamName(fta.opp_team_id) as opponent from (
		select 
		g.value as game_id, 
		q1.value as level_expected,
		q2.value as team_correct_flight,
		q3.value as opponent_correct_flight,
		gg.field, 
		gg.game_datetime, 
		t.value as team_id,
		gt.team_id as opp_team_id
		from dbo.f_get_choice_responses(69,53) g
		left join dbo.f_get_responses(15,4) q1
		on g.response_id=q1.response_id
		left join dbo.f_get_responses(16,5) q2
		on g.response_id=q2.response_id
		left join dbo.f_get_responses(55,51) q3
		on g.response_id=q3.response_id
		inner join dbo.f_get_choice_responses(70,53) t
		on g.response_id=t.response_id
		inner join v_games_all gg
		on g.value=gg.game_id
		inner join xref_game_team gt 
		on t.value <> gt.team_id and g.value = gt.game_id
		<cfif isdefined("form.gosingle") AND gameID NEQ "" AND isnumeric(gameID)>
			where g.value = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#gameID#">
		<cfelse>
			where gg.game_datetime >= <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#dateformat(weekendFrom,"m/d/yyyy")#">
			AND gg.game_datetime <= <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#dateformat(weekendTo,"m/d/yyyy")# 23:59">
			<cfif flight NEQ "">
				AND gg.division in (#listQualify(flight,"'")#)
			</cfif>
			<cfif isdefined("form.q1") AND form.q1 NEQ "">
				AND q1.value = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.q1#">
			</cfif>
			<cfif isdefined("form.q2") AND form.q2 NEQ "">
				AND q2.value = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.q2#">
			</cfif>
			<cfif isdefined("form.q3") AND form.q3 NEQ "">
				AND q3.value = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.q3#">
			</cfif>
		</cfif>
		
		group by g.value, 
		q1.value,
		q2.value,
		q3.value,
		gg.field, 
		gg.game_datetime, 
		t.value,
		gt.team_id
		) fta
	</cfquery>
	
</cfif>

<cfsavecontent variable="custom_css">
  <link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css">
</cfsavecontent>
<cfhtmlhead text="#custom_css#">

<FORM name="Games" action="rptCompEval.cfm"  method="post">
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
			<cfquery name="getChoices" datasource="#application.dsn#">
				select choice_id, name
				from tbl_choice
				where question_group_id=4
			</cfquery>
			<b>Level as Expected</b>
			<select name="q1">
				<option value="">Select All</option>
				<cfloop query="getChoices">
					<option value="#name#" <cfif isdefined("form.q1") AND form.q1 EQ name>selected="selected"</cfif>>#name#</option>
				</cfloop>
			</select>
			<cfquery name="getChoices" datasource="#application.dsn#">
				select choice_id, name
				from tbl_choice
				where question_group_id=5
			</cfquery>
			<b>Team Correct Flight</b>
			<select name="q2">
				<option value="">Select All</option>
				<cfloop query="getChoices">
					<option value="#name#" <cfif isdefined("form.q2") AND form.q2 EQ name>selected="selected"</cfif>>#name#</option>
				</cfloop>
			</select>
			<cfquery name="getChoices" datasource="#application.dsn#">
				select choice_id, name
				from tbl_choice
				where question_group_id=24
			</cfquery>
			<b>Opponent Correct Flight</b>
			<select name="q3">
				<option value="">Select All</option>
				<cfloop query="getChoices">
					<option value="#name#" <cfif isdefined("form.q3") AND form.q3 EQ name>selected="selected"</cfif>>#name#</option>
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
	<input type="radio" id="sortLink1" name="radio" /><label for="sortLink1">Date</label></label>
	<input type="radio" id="sortLink2" name="radio" /><label for="sortLink2">Game ##</label></label>
	<input type="radio" id="sortLink3" name="radio" /><label for="sortLink3">Flights</label></label>
	<input type="radio" id="sortLink4" name="radio" /><label for="sortLink4">Team Reporting</label>
	<input type="radio" id="sortLink5" name="radio" /><label for="sortLink5">Opponent</label>
</div>
	<table id="resultTable" cellspacing="0" cellpadding="3" border="0" width="100%" class="table1">
		<thead>
		<tr>
			<th>Game</th>
			<th>Flight</th>
			<th>Date</th>
			<th>Team Reporting</th>
			<th>Opponent</th>
			<th>Level as Expected</th>
			<th>Team Correct Flight</th>
			<th>Opponent Correct Flight</th>
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
				<td>#opponent#</td>
				<td>#level_expected#</td>
				<td>#team_correct_flight#</td>
				<td>#opponent_correct_flight#</td>
			</tr>
		</cfloop>
	<cfelse>
		<td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
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
			sortList:[[1,0],[3,0],[2,0]]
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
			var sorting = [[3,0]];
			$('##resultTable').trigger("sorton",[sorting]);
		});
		$('##sortLink5').click(function(){
			var sorting = [[4,0]];
			$('##resultTable').trigger("sorton",[sorting]);
		});
		
	});
</script>
</cfoutput>
</cfsavecontent>

<cfinclude template="_footer.cfm">





