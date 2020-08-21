<!--- 
	FileName:	rptRefEvalShort.cfm
	Created on: 5/11/2011
	Created by: B.Cooper
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
MODIFICATIONS
7/8/2011, J. Oriente (ticket 10596)
- modified resp.position criteria of getResults where clause to substring(resp.position,1,2) so users can search for both AR1 and AR2 in one query (i.e. AR)
- modified "position" form field to contain options of CR and AR instead of CR, AR1 and AR2
10/29/12 - J. Rab (Ticket NCSA12769)
- Updated form to now include referee drop down to filter results
11/16/2016 - R. Gonzalez (TICKET ???)
- removed comments from cfquery
06/16/17 - mgreenberg (TICKET NCSA22821) - report mods: updated datepicker and sorter.
--->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<script language="JavaScript" src="DatePicker.js"></script>
<cfoutput>
<div id="contentText">

<H1 class="pageheading">NCSA - Short Form Ref Evaluation</H1>


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
		dbo.f_get_division(fta.team_id) as division from (
		select 
		resp.ref_id,
		resp.opinion, 
		resp.position, 
		g.value as game_id,
		t.value as team_id,
		gg.field, 
		gg.game_datetime
		from
		(
			select r.response_id, r.value as ref_id, o.value as opinion, 'CR' as position from 
			dbo.f_get_choice_responses(90,53) r
			inner join dbo.f_get_responses(59,67) o
			on r.response_id=o.response_id
			UNION ALL
			select r.response_id, r.value as ref_id, o.value as opinion, 'AR1' as position from
			dbo.f_get_choice_responses(91,53) r
			inner join dbo.f_get_responses(60,67) o
			on r.response_id=o.response_id
			UNION ALL
			select r.response_id, r.value as ref_id, o.value as opinion, 'AR2' as position from
			dbo.f_get_choice_responses(92,53) r
			inner join dbo.f_get_responses(61,67) o
			on r.response_id=o.response_id
		) resp
		inner join dbo.f_get_choice_responses(69,53) g
		on resp.response_id=g.response_id
		inner join dbo.f_get_choice_responses(70,53) t
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
			<cfif isdefined("form.position") AND form.position NEQ "">
				AND substring(resp.position,1,2) = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.position#">
			</cfif>
			<cfif isdefined("form.resp") AND form.resp NEQ "">
				AND resp.opinion = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.resp#">
			</cfif>
			<cfif isdefined("form.ref") AND form.ref NEQ "">
				AND resp.ref_id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.ref#">
			</cfif>
		</cfif>
		
		group by 
		resp.ref_id,
		resp.opinion, 
		resp.position, 
		g.value,
		t.value,
		gg.field, 
		gg.game_datetime
		
		) fta
	</cfquery>
	
</cfif>

<cfsavecontent variable="custom_css">
<style>
	input.ui-helper-hidden-accessible
	{	
		display: none;
	}
</style>
  <link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css">
</cfsavecontent>
<cfhtmlhead text="#custom_css#">






<FORM name="Games" action="rptRefEvalShort.cfm"  method="post">
<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%" >
	<TR><TD align="left">
			<B>From</B> &nbsp;
				<INPUT name="WeekendFrom" value="#VARIABLES.WeekendFrom#" size="9">
			#repeatString("&nbsp;",3)#
		</TD>
		<td>
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
		<td valign="top">
		<table>
			<tr>
				<td valign="top">
				<b>Flight</b>
				</td>
				<td>
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
				</td>
			</tr>
		</table>
		</td>
		<td valign="top">
		<table>
			<tr>
				<td>
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
			</td>
			<td>
			<b>Response</b>
			<cfquery name="getChoices" datasource="#application.dsn#">
				select choice_id, name
				from tbl_choice
				where question_group_id=28
			</cfquery>
			<select name="resp">
				<option value="">Select All</option>
				<cfloop query="getChoices">
					<option value="#name#" <cfif isdefined("form.resp") AND form.resp EQ name>selected="selected"</cfif>>#name#</option>
				</cfloop>
			</select>
			</td>
			</tr>
			<tr>
			<td>

			<b>Ref Position</b>
			<select name="position">
				<option value="">Select All</option>
				<option value="CR" <cfif isdefined("form.position") AND form.position EQ "CR">selected="selected"</cfif>>CR</option>
				<option value="AR" <cfif isdefined("form.position") AND form.position EQ "AR">selected="selected"</cfif>>AR</option>

			</select>
					</td>
					<td>
			
			<input type="SUBMIT" name="Go"  value="Go" />
					</td>
				</tr>
			</table>
		</td>
		<td align="center" valign="top">
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
	<table id="resultTable" cellspacing="0" cellpadding="3" border="0" width="100%" class="table1">
		<thead>
		<tr>
			<th>Game</th>
			<th>Flight</th>
			<th>Date</th>
			<th>Team Reporting</th>
			<th>Overall Evaluation</th>
			<th>Referee Name</th>
			<th>Position</th>
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
				<td>#opinion#</td>
				<td>#ref_name#</td>
				<td>#position#</td>
			</tr>
		</cfloop>
	<cfelse>
		<td></td><td></td><td></td><td></td><td></td><td></td><td></td>
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
			sortList:[[5,0],[6,0]]
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
			var sorting = [[5,0],[2,0]];
			$('##resultTable').trigger("sorton",[sorting]);
		});
		$('##sortLink5').click(function(){
			var sorting = [[6,0],[5,0]];
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





