<!--- 
	FileName:	rptCompletionAnalysis.cfm
	Created on: 5/11/2011
	Created by: B.Cooper
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
7/8/2011, J. Oriente (ticket 10596)
- added (g.hscore is not null or g.vscore is not null) to where clause of getResults query ... filters out games where no score was recorded

01/30/2012 - J. Rab - NCSA10596 - Added new logic to identify the amount of matches a team has evaluated
02/25/2012 - J. Rab - NCSA10596 - Added new logic to identify the amount of matches a team has evaluated
06/16/17 - mgreenberg (TICKET NCSA22821) - report mods: updated datepicker and sorter.

--->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<script language="JavaScript" src="DatePicker.js"></script>
<cfoutput>
<div id="contentText">

<H1 class="pageheading">NCSA - Completion/Result Evaluation Submission Analysis</H1>


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
		SELECT gt.team_id, 
		       dbo.getteamname(gt.team_id) as team_name, 
		       dbo.f_get_division(gt.team_id) as division,
		       count(distinct gt.game_id) as num_games,
		       count(distinct gr.game_id) as num_match_eval,
		       count(distinct gr1.game_id) + count(distinct gr2.game_id) as num_ref_eval
		  FROM xref_game_team gt inner join 
		       v_games_all g on gt.game_id=g.game_Id left join 
			   (select a.value as game_id, b.value as team_id from dbo.f_get_choice_responses(69,53) a 
				inner join dbo.f_get_choice_responses(70,53) b on a.response_id = b.response_id
				group by a.value, b.value) gr on (gr.team_id = gt.team_id and gr.game_id = gt.game_id) left join

			   (select a.value as game_id, b.value as team_id from dbo.f_get_choice_responses(69,81) a 
				inner join dbo.f_get_choice_responses(70,81) b on a.response_id = b.response_id
				group by a.value, b.value) gr1 on (gr1.team_id = gt.team_id and gt.game_id=gr1.game_id) left join 
				
			   (select a.value as game_id, b.value as team_id from dbo.f_get_choice_responses(69,82) a 
				inner join dbo.f_get_choice_responses(70,82) b on a.response_id = b.response_id
				group by a.value, b.value) gr2 on (gr2.team_id = gt.team_id and gt.game_id=gr2.game_id)
				

		<cfif isdefined("form.gosingle") AND gameID NEQ "" AND isnumeric(gameID)>
			WHERE gt.game_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#gameID#">
			  and (g.hscore is not null or g.vscore is not null) 
		<cfelse>
			WHERE gt.team_id <> 830
			  and (g.hscore is not null or g.vscore is not null) 
			  and g.game_datetime >= <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#dateformat(weekendFrom,"m/d/yyyy")#">
			  and g.game_datetime <= <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#dateformat(weekendTo,"m/d/yyyy")# 23:59">
			<cfif flight NEQ "">
			  and g.division in (#listQualify(flight,"'")#)
			</cfif>
			<cfif isdefined("form.result") AND form.result NEQ "">
			  and dbo.f_get_game_outcome(gt.game_id, gt.team_id) = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#form.result#">
			</cfif>
		</cfif>
		group by gt.team_id
	</cfquery>	
</cfif>

<cfsavecontent variable="custom_css">
  <link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css">
</cfsavecontent>
<cfhtmlhead text="#custom_css#">

<FORM name="Games" action="rptCompletionAnalysis.cfm"  method="post">
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
			<b>Result</b>
			<select name="result">
				<option value="">Select All</option>
				<option value="1" <cfif isdefined("form.result") AND form.result EQ "1">selected="selected"</cfif>>Won</option>
				<option value="-1" <cfif isdefined("form.result") AND form.result EQ "-1">selected="selected"</cfif>>Lost</option>
				<option value="0" <cfif isdefined("form.result") AND form.result EQ "0">selected="selected"</cfif>>Tied</option>
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
	<input type="radio" id="sortLink1" name="radio" /><label for="sortLink1">Flights</label></label>
	<input type="radio" id="sortLink2" name="radio" /><label for="sortLink2">Team</label>
</div>
<style type="text/css">
	.table1 tfoot td{
		font-weight:bold;
	}
</style>
	<table id="resultTable" cellspacing="0" cellpadding="3" border="0" width="100%" class="table1">
		<thead>
		<tr>
			<th>Flight</th>
			<th>Team Reporting</th>
			<th>Number of Games</th>
			<th>% Match Evaluation Completed</th>
			<th>% Ref Evaluation Completed</th>
		</TR>
		</thead>
		<tbody>
		<cfset num_games=0>
		<cfset num_match_eval=0>
		<cfset num_ref_eval=0>
	<cfif getResults.recordCount GT 0>
		<cfloop query="getResults">
			<cfset variables.num_games += getResults.num_games>
			<cfset variables.num_match_eval += getResults.num_match_eval>
			<cfset variables.num_ref_eval += getResults.num_ref_eval>
			<tr>
				<td>#division#</td>
				<td>#team_name#</td>
				<td>#getResults.num_games#</td>
				<td>#round(getResults.num_match_eval/getResults.num_games*1000)/10#%</td>
				<td>#round(getResults.num_ref_eval/getResults.num_games*1000)/10#%</td>
			</tr>
		</cfloop>
	<cfelse>
		<td></td><td></td><td></td><td></td><td></td><td></td>
	</cfif>
		</tbody>
		<tfoot>
		<tr>
			<td>&nbsp;</td>
			<td>Total:</td>
			<td>#variables.num_games#</td>
			<td>#round(variables.num_match_eval/variables.num_games*1000)/10#%</td>
			<td>#round(variables.num_ref_eval/variables.num_games*1000)/10#%</td>
		</tr>
		
		</tfoot>
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
			sortList:[[0,0],[1,0]]
		});
		
		//define button set for sort links
		$('##sortLinks').buttonset();
		
		$('##sortLink1').click(function(){
			var sorting = [[0,0]];
			$('##resultTable').trigger("sorton",[sorting]);
		});
		$('##sortLink2').click(function(){
			var sorting = [[1,0]];
			$('##resultTable').trigger("sorton",[sorting]);
		});
		
	});
</script>
</cfoutput>
</cfsavecontent>

<cfinclude template="_footer.cfm">





