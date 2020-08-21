<!--- 
	FileName:	matchEvaluation.cfm
	Created on: 2/23/2011
	Created by: bcooper@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 <cfsetting showdebugoutput="No">
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>


<CFIF isDefined("FORM.team_id")>
	<CFSET team_id = FORM.team_id>
<cfelseif isdefined("url.team_id")>
	<cfset team_id=url.team_id>
<CFELSE>
	<CFSET team_id = "">
</CFIF>

<cfif isdefined("url.game_id")>
	<cfset game_id=url.game_id>
</cfif>




<cfif team_id EQ "">
	<!--- get teams for user logged in --->
	<cfif session.menuroleid EQ "1">
		<cfinvoke
			component="#session.sitevars.cfcpath#team"
			method="getClubTeams"
			clubid="0"
			orderBy="CLUB"
			season_id="#session.currentseason.id#"
			returnvariable="contactTeams">
	<cfelseif listfind("26,27,28",session.menuroleid) NEQ 0><!--- if user is club rep/alt rep/pres --->
		<cfinvoke
			component="#session.sitevars.cfcpath#team"
			method="getClubTeams"
			clubid="#session.user.clubid#"
			season_id="#session.currentseason.id#"
			returnvariable="contactTeams">
	<cfelse>
		<cfinvoke
			component="#session.sitevars.cfcpath#team"
			method="getContactTeams"
			contact_id="#session.user.contactid#"
			season_id="#session.currentseason.id#"
			returnvariable="contactTeams">
	</cfif>
	
	<cfif contactTeams.recordcount EQ 1>
		<cfset team_id=contactTeams.team_id>
	</cfif>
</cfif>

<cfif team_id NEQ "" AND NOT isdefined("game_id")>
	<!--- get games --->
	<!--- Joe Lechuga - 6/1/2012 - Replaced Table Valued Function  f_get_choice_responses with a select statement to optimize the query--->
	<cfquery datasource="#application.dsn#" name="qGetGames">
		select r.response_id, g.game_id, game_datetime, score_home, score_visitor, game_code, field_Id, field, visitor_teamname, home_teamname
		from v_games_all g
		left join 
		(
		select a.response_id, a.value as game_id, b.value as team_id from
		(select response_id, value
	from tbl_response_choice
	where choice_id=69
	and question_group_form_section_id = 53) a  
		inner join 
		(select response_id, value
	from tbl_response_choice
	where choice_id=70
	and question_group_form_section_id = 53) b 
		on a.response_id=b.response_id
		where b.value=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#team_id#">
		) r
		on g.game_id=r.game_id
		where 
		(visitor=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#team_id#"> or home=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#team_id#">)
		order by game_datetime asc
	</cfquery>
</cfif>

<cfif isdefined("game_Id")>
	<cfquery datasource="#application.dsn#" name="getGame">
		select g.game_id, g.game_notes, 
		dbo.f_get_team_age(ht.team_id) as home_team_age, 
		dbo.f_get_team_age(vt.team_id) as visitor_team_age,
		ascii(ht.playlevel) as home_flight,
		ascii(vt.playlevel) as visitor_flight,
		refc.firstname + ' ' + refc.lastname as refname,
		asst1c.firstname + ' ' + asst1c.lastname as asst1name,
		asst2c.firstname + ' ' + asst2c.lastname as asst2name,
		g.game_code,
		g.home_teamname,
		g.visitor_teamname,
		g.game_datetime,
		g.field,
		g.score_home,
		g.score_visitor,
		g.home_team_id,
		g.visitor_team_id,
		g.refid,
		g.asstrefid1,
		g.asstrefid2
		from v_games_all g
		inner join tbl_team ht
		on g.home_team_id=ht.team_id
		inner join tbl_team vt
		on g.visitor_team_id=vt.team_id
		left join tbl_contact refc
		on g.refid=refc.contact_id
		left join tbl_contact asst1c
		on g.asstrefid1=asst1c.contact_id
		left join tbl_contact asst2c
		on g.asstrefid2=asst2c.contact_id
		where game_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#game_id#">
	</cfquery>
	<cfset teamAge=max(getGame.home_team_age,getGame.visitor_team_age)>
	<cfset flight=max(getGame.home_flight, getGAme.visitor_flight)>
	
	
	<!--- get team info --->
	<cfquery datasource="#application.dsn#" name="getTeamInfo">
		select t.*, c.firstname as head_firstname, c.lastname as Head_lastname, ac.firstname as asst_firstname, ac.lastname as asst_lastname
		from tbl_team t
		left join tbl_contact c
		on t.contactidhead=c.contact_id
		left join tbl_contact ac
		on t.contactidasst=ac.contact_id
		where t.team_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#team_id#">
	</cfquery>
	
</cfif>




<div id="contentText">
<H1 class="pageheading">NCSA - Match Evaluation</H1>
<br> <!--- <h2>yyyyyy </h2> --->
<cfif not isdefined("game_id")>
	<cfif team_id EQ "">
	<FORM action="matchEvaluation.cfm" method="post">
		
	<table cellspacing="0" cellpadding="2" align="center" border="0" width="99%">
	<tr>
		<td>
			
			<select name="team_id">
				<cfloop query="contactTeams">
					<option value="#team_id#">#teamname#</option>
				</cfloop>
			</select>
		
			<INPUT type="submit" value="Get Games">
		</td> 
	</tr> 
	</table>
	</cfif>
	<CFIF isDefined("qGetGames") >
		
	<cfif isdefined("url.formSave")>
		<cfswitch expression="#url.formSave#">
			<cfcase value="1">
				<div class="success">
					Thank you for your evaluation.
				</div>
			</cfcase>
			<cfcase value="2">
				<div class="error">
					Evaluation deleted successfully.
				</div>
			</cfcase>
		<cfdefaultcase>
		
		</cfdefaultcase>
		</cfswitch>
	</cfif>
		<div class="notice">
			<h3>Instructions for coaches:</h3>
			<ol>
				<li>If you believe a score posted for a game is incorrect, do not report that here - please email your division commissioner.</li>
				<li>A team may submit only 1 evaluation per game.  Both coaches (if two are listed in NCSA's online team registration) have access to submit an evaluation, so decide between yourselves who will submit the evaluation.</li>
				<li>NCSA takes these evaluations seriously - please take appropriate time to complete the evaluation fairly and objectively - for example, immediately following a tough loss or a game in which a coach or player was cautioned or sent off might not be the best time to submit the evaluation.   Nevertheless, be aware that there is a 7 day limit for submission of evaluations.</li>
				<li>When comment sections are provided, there is a 100 word limit to each such section so be concise.</li>
				<li>An evaluation does NOT act as a protest - only submissions strictly according to NCSA Rule 6.13 will be considered protests.</li>
			</ol>
		</div>
		<table class="table1" cellpadding="3" cellspacing="0" border="0">
			<thead>
			<tr>
				<th>Game Number</th>
				<th>Game Time</th>
				<th>Home Team</th>
				<th>Visiting Team</th>
				<th style="text-align:center;">Home Score</th>
				<th style="text-align:center;">Visitor Score</th>
				<th style="text-align:center;">View Evaluation</th>
			</TR>
			</thead>
			<tbody>
			<cfloop query="qGetGames">
				<tr>
					<td><cfif (session.menuroleid EQ "1" OR datediff("n",game_datetime,now()) LT 10080) AND response_id EQ ""><a href="matchEvaluation.cfm?team_id=#team_id#&game_id=#game_id#">#game_id#</a><cfelse>#game_id#</cfif></td>
					<td>#dateformat(game_datetime, "m/d/yyyy")# #timeformat(game_datetime,"h:mm tt")#</td>
					<td>#home_teamname#</td>
					<td>#visitor_teamname#</td>
					<td style="text-align:center;">#score_home#</td>
					<td style="text-align:center;">#score_visitor#</td>
					<td style="text-align:center;"><cfif response_id NEQ ""><a href="viewMatchEvaluation.cfm?response_id=#response_id#">View</a></cfif></td>
				</tr>
			</cfloop>
			</tbody>
		</TABLE>
	</CFIF>
<cfelse>

	<h3>(#getGame.game_id#) #getGame.home_teamname# VS #getGame.visitor_teamname# on #dateformat(getGame.game_datetime, "m/d/yyyy")# #timeformat(getGame.game_datetime,"h:mm tt")#</h3>
	<h3>Field: #getGame.field#</h3>
	<h3>
		Score:<br>
		#getGame.home_teamname#: #getGame.score_home#<br>
		#getGame.visitor_teamname#: #getGame.score_visitor#
	</h3>
	<br>
	<h3>This form is being filled out by the <u><i>#iif("#team_id EQ getGame.home_team_id#","#de("Home")#","#de("Visitor")#")#</i></u> team.</h3>
	


	<!--- construct list of labels that the form expects --->
	<cfset label_vars=structnew()>
	<cfset label_vars.game_id="#game_id#">
	<cfset label_vars.team_id="#team_id#">
	<cfset label_vars.ref_name="#getGame.refname#">
	<cfset label_vars.asst1ref_name="#getGame.asst1name#">
	<cfset label_vars.asst2ref_name="#getGame.asst2name#">
	<cfset label_vars.ref_id="#getGame.refid#">
	<cfset label_vars.asst1ref_id="#getGame.asstrefid1#">
	<cfset label_vars.asst2ref_id="#getGame.asstrefid2#">
	
	<!--- call module to render the form for user input --->
	<cfmodule template="forms/renderForm.cfm"
		user_form_id="2" 
		label_vars="#label_vars#"
		return_page="#Application.sitevars.homehttp#/matchEvaluation.cfm?team_id=#team_id#">
</cfif>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">

