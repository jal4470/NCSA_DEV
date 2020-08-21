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

<CFIF isDefined("FORM.response_id")>
	<CFSET response_id = FORM.response_id>
<cfelseif isdefined("url.response_id")>
	<cfset response_id=url.response_id>
<CFELSE>
	<CFSET response_id = "">
</CFIF>

<!--- get response --->
<cfinvoke
	component="#application.sitevars.cfcpath#.userForm"
	method="getResponse"
	response_id="#response_id#"
	returnvariable="responseInfo">
<cfset user_form_id=responseInfo.user_form_id>

<cfset stResponse=structnew()>
<cfloop query="responseInfo">
	<cfset key="#question_group_form_section_id#-#question_id#-#choice_id#">
	<cfif choice_id EQ "70"> <!--- Team ID --->
	<cfset team_id = value>
	<cfelseif choice_id EQ "69"> <!--- Game ID --->
	<cfset game_id = value>
	</cfif>
	<cfif structkeyexists(stResponse,"#key#")>
		<cfset arrayappend(stResponse["#key#"],value)>
	<cfelse>
		<cfset keyvalue=arraynew(1)>
		<cfset arrayappend(keyvalue,value)>
		<cfset stResponse["#key#"]=keyvalue>
	</cfif>
</cfloop>

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
			<div class="success">
				Thank you for your evaluation.
			</div>
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
	<cfmodule template="forms/renderFormEdit.cfm"
		response_id=#response_id#
		user_form_id="2" 
		label_vars="#label_vars#"
		stResponse=#stResponse#
		return_page="#Application.sitevars.homehttp#/viewMatchEvaluation.cfm?response_id=#response_id#">
</cfif>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">

