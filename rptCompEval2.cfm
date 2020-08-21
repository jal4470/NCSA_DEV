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

	<cfstoredproc procedure="P_REP_COMPETITION_EVAL" datasource="#application.dsn#">
		<cfprocparam type="in" cfsqltype="CF_SQL_INT" dbvarname="@GAME_ID" value="#gameID#" null="#YesNoFormat(gameID EQ '')#">
		<cfprocparam type="in" cfsqltype="CF_SQL_VARCHAR" dbvarname="@FLIGHT" value="#FLIGHT#" null="#YesNoFormat(FLIGHT EQ '')#">
		<cfprocparam type="in" cfsqltype="CF_SQL_INT" dbvarname="@WEEKEND_FROM" value="#WeekendFrom#" null="#YesNoFormat(WeekendFrom EQ '')#">
		<cfprocparam type="in" cfsqltype="CF_SQL_INT" dbvarname="@WEEKEND_TO" value="#WeekendTo#" null="#YesNoFormat(WeekendTo EQ '')#">
		<cfprocparam type="in" cfsqltype="CF_SQL_VARCHAR" dbvarname="@Q1" value="#Q1#" null="#YesNoFormat(Q1 EQ '')#">
		<cfprocparam type="in" cfsqltype="CF_SQL_VARCHAR" dbvarname="@Q2" value="#Q2#" null="#YesNoFormat(Q2 EQ '')#">
		<cfprocparam type="in" cfsqltype="CF_SQL_VARCHAR" dbvarname="@Q3" value="#Q3#" null="#YesNoFormat(Q3 EQ '')#">
		<cfprocparam type="in" cfsqltype="CF_SQL_VARCHAR" dbvarname="@Q4" value="#Q4#" null="#YesNoFormat(Q4 EQ '')#">
		<cfprocparam type="in" cfsqltype="CF_SQL_VARCHAR" dbvarname="@Q5" value="#Q5#" null="#YesNoFormat(Q5 EQ '')#">
		<cfprocresult resultset="1" name="getResults">
	</cfstoredproc>
	
</cfif>

<cfsavecontent variable="custom_css">
  <link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css">
</cfsavecontent>
<cfhtmlhead text="#custom_css#">

<FORM name="Games" action="rptCompEval2.cfm"  method="post">
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
				where question_group_id=6
			</cfquery>
			<b>Opponent Sportsmanship</b>
			<select name="q1">
				<option value="">Select All</option>
				<cfloop query="getChoices">
					<option value="#name#" <cfif isdefined("form.q1") AND form.q1 EQ name>selected="selected"</cfif>>#name#</option>
				</cfloop>
			</select>
			<cfquery name="getChoices" datasource="#application.dsn#">
				select choice_id, name
				from tbl_choice
				where question_group_id=30
			</cfquery>
			<b>Opponent Coach Behavior</b>
			<select name="q2">
				<option value="">Select All</option>
				<cfloop query="getChoices">
					<option value="#name#" <cfif isdefined("form.q2") AND form.q2 EQ name>selected="selected"</cfif>>#name#</option>
				</cfloop>
			</select>
			<cfquery name="getChoices" datasource="#application.dsn#">
				select choice_id, name
				from tbl_choice
				where question_group_id=31
			</cfquery>
			<br>
			<b>Opponent Spectator Behavior</b>
			<select name="q3">
				<option value="">Select All</option>
				<cfloop query="getChoices">
					<option value="#name#" <cfif isdefined("form.q3") AND form.q3 EQ name>selected="selected"</cfif>>#name#</option>
				</cfloop>
			</select>
			<cfquery name="getChoices" datasource="#application.dsn#">
				select choice_id, name
				from tbl_choice
				where question_group_id=7
			</cfquery>
			<br>
			<b>Physical Nature</b>
			<select name="q4">
				<option value="">Select All</option>
				<cfloop query="getChoices">
					<option value="#name#" <cfif isdefined("form.q4") AND form.q4 EQ name>selected="selected"</cfif>>#name#</option>
				</cfloop>
			</select>
			<cfquery name="getChoices" datasource="#application.dsn#">
				select choice_id, name
				from tbl_choice
				where question_group_id=8
			</cfquery>
			<br>
			<b>Level of Competition</b>
			<select name="q5">
				<option value="">Select All</option>
				<cfloop query="getChoices">
					<option value="#name#" <cfif isdefined("form.q5") AND form.q5 EQ name>selected="selected"</cfif>>#name#</option>
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
			<th>Opponent Sportsmanship</th>
			<th>Opponent Coach Behavior</th>
			<th>Opponent Spectator Behavior</th>
			<th>Physical Nature</th>
			<th>Level of Competition</th>
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
				<td>#opponent_sportsmanship#</td>
				<td>#opponent_coach_behavior#</td>
				<td>#opponent_spectator_behavior#</td>
				<td>#physical_nature#</td>
				<td>#level_comp#</td>
			</tr>
		</cfloop>
	<cfelse>
		<td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
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





