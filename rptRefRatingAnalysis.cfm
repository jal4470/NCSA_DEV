<!--- 
	FileName:	rptRefRatingAnalysis.cfm
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

<H1 class="pageheading">NCSA - Referee Rating Analysis</H1>


<cfif isDefined("FORM.WeekendFrom") AND FORM.WeekendFrom NEQ "">
	<cfset WeekendFrom = dateFormat(FORM.WeekendFrom,"mm/dd/yyyy") > 
<cfelse>
	<cfset WeekendFrom = dateFormat(session.currentseason.startdate,"mm/dd/yyyy") > 
</CFIF>

<cfif isDefined("FORM.WeekendTo") AND FORM.WeekendTo NEQ "">
	<cfset WeekendTo   = dateFormat(FORM.WeekendTo,"mm/dd/yyyy") >
<cfelse>
	<cfset WeekendTo   = dateFormat(now(),"mm/dd/yyyy") >
</CFIF>

<cfif isDefined("FORM.flight") AND FORM.flight NEQ "">
	<cfset flight = listQualify(form.flight,"'")>
<cfelse>
	<cfset flight = "">
</cfif>

<cfif isDefined("FORM.gameID") AND isNumeric(TRIM(FORM.gameID)) AND isDefined("FORM.GOSINGLE")>
	<cfset gameID = TRIM(FORM.gameID)>
<cfelse>
	<cfset gameID = "">
</cfif>
<cfset errMsg = "">

<cfif isDefined("FORM.GO") OR isDefined("FORM.GOSINGLE") >

<!---	<cfquery name="getResults" datasource="#application.dsn#">
		select t.value as team_id, 
		dbo.f_get_division(t.value) as division,
		dbo.getteamname(t.value) as team_name, 
		count(t.value) as num_reports,
		count(a1.value) as num_a1,
		count(a2.value) as num_a2,
		count(a3.value) as num_a3,
		count(a4.value) as num_a4,
		count(a5.value) as num_a5,
		count(a6.value) as num_a6
		from dbo.f_get_choice_responses(70,53) t
		inner join dbo.f_get_choice_responses(69,53) g
		on t.response_id=g.response_id
		left join dbo.f_get_question_choice_responses(59,71,67) a1
		on t.response_id=a1.response_id
		left join dbo.f_get_question_choice_responses(59,72,67) a2
		on t.response_id=a2.response_id
		left join dbo.f_get_question_choice_responses(59,73,67) a3
		on t.response_id=a3.response_id
		left join dbo.f_get_question_choice_responses(59,74,67) a4
		on t.response_id=a4.response_id
		left join dbo.f_get_question_choice_responses(59,75,67) a5
		on t.response_id=a5.response_id
		left join dbo.f_get_question_choice_responses(59,76,67) a6
		on t.response_id=a6.response_id
		inner join v_games_all gg
		on g.value=gg.game_id
		<cfif isdefined("form.gosingle") AND gameID NEQ "" AND isnumeric(gameID)>
			where g.value = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#gameID#">
		<cfelse>
			where 
			t.value <> 830
			AND gg.game_datetime >= <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#dateformat(weekendFrom,"m/d/yyyy")#">
			AND gg.game_datetime <= <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#dateformat(weekendTo,"m/d/yyyy")# 23:59">
			<cfif flight NEQ "">
				AND gg.division in (#listQualify(flight,"'")#)
			</cfif>
			<cfif isdefined("form.result") AND form.result NEQ "">
				AND dbo.f_get_game_outcome(g.value, t.value) = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#form.result#">
			</cfif>
		</cfif>
		group by t.value
	</cfquery>
--->	

	<cfstoredproc procedure="P_REP_REF_RATING_ANALYSIS" datasource="#application.dsn#">
		<cfprocparam cfsqltype="cf_sql_integer" value="#gameID#" dbvarname="@GAME_ID" null="#YesNoFormat(gameID EQ '')#">
		<cfprocparam cfsqltype="cf_sql_date" value="#WEEKENDFROM#" dbvarname="@WEEKEND_FROM" null="#YesNoFormat(WEEKENDFROM EQ '')#">
		<cfprocparam cfsqltype="cf_sql_date" value="#WEEKENDTO#" dbvarname="@WEEKEND_TO" null="#YesNoFormat(WEEKENDTO EQ '')#">
		<cfprocparam cfsqltype="cf_sql_varchar" value="#flight#" dbvarname="@FLIGHT" null="#YesNoFormat(FLIGHT EQ '')#">
		<cfprocparam cfsqltype="cf_sql_varchar" value="#FORM.RESULT#" dbvarname="@GAME_RESULT" null="#YesNoFormat(FORM.RESULT EQ '')#">
		<cfprocresult name="getResults" resultset="1">
	</cfstoredproc>

</cfif>

<cfsavecontent variable="custom_css">
  <link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css">
</cfsavecontent>
<cfhtmlhead text="#custom_css#">

<FORM name="Games" action="rptRefRatingAnalysis.cfm"  method="post">
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
						<OPTION value="#playLevel#" <cfif listfindnocase(flight,"'#playLevel#'")>selected</cfif> >#playLevel#</OPTION>
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

<CFIF IsDefined("getResults") AND getResults.recordcount GT 0>
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
			<th>Number of Reports</th>
			<th>% Excellent</th>
			<th>% Good</th>
			<th>% Average</th>
			<th>% Fair</th>
			<th>% Poor</th>
			<th>% No Opinion</th>
		</TR>
		</thead>
		<tbody>
		<cfset num_reports=0>
		<cfset num_excellent=0>
		<cfset num_good=0>
		<cfset num_average=0>
		<cfset num_fair=0>
		<cfset num_poor=0>
		<cfset num_noop=0>
	<cfif getResults.recordCount GT 0> 
		<cfloop query="getResults">
			<cfset variables.num_reports += getResults.num_reports>
			<cfset variables.num_excellent += getResults.num_a1>
			<cfset variables.num_good += getResults.num_a2>
			<cfset variables.num_average += getResults.num_a3>
			<cfset variables.num_fair += getResults.num_a4>
			<cfset variables.num_poor += getResults.num_a5>
			<cfset variables.num_noop += getResults.num_a6>
			<tr>
				<td>#division#</td>
				<td>#team_name#</td>
				<td>#getResults.num_reports#</td>
				<td>#round(getResults.num_a1/getResults.num_reports*1000)/10#%</td>
				<td>#round(getResults.num_a2/getResults.num_reports*1000)/10#%</td>
				<td>#round(getResults.num_a3/getResults.num_reports*1000)/10#%</td>
				<td>#round(getResults.num_a4/getResults.num_reports*1000)/10#%</td>
				<td>#round(getResults.num_a5/getResults.num_reports*1000)/10#%</td>
				<td>#round(getResults.num_a6/getResults.num_reports*1000)/10#%</td>
			</tr>
		</cfloop>
	<cfelse>
		<td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
	</cfif>
		</tbody>
		<tfoot>
		<tr>
			<td>&nbsp;</td>
			<td>Total:</td>
			<td>#variables.num_reports#</td>
			<td>#round(variables.num_excellent/variables.num_reports*1000)/10#%</td>
			<td>#round(variables.num_good/variables.num_reports*1000)/10#%</td>
			<td>#round(variables.num_average/variables.num_reports*1000)/10#%</td>
			<td>#round(variables.num_fair/variables.num_reports*1000)/10#%</td>
			<td>#round(variables.num_poor/variables.num_reports*1000)/10#%</td>
			<td>#round(variables.num_noop/variables.num_reports*1000)/10#%</td>
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





