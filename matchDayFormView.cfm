<!--- 
MODIFICATIONS:
7-29-2014	-	J. Danz	-	(TICKET NCSA15480) - updated referee fees and AR fees, updated code of conduct, changed copy under "CODE OF CONDUCT", added copy to code of conduct #1. 
8-18-2014 - J. Danz - (TICKET NCSA15498) - altered the "getPlayUps" query to grab the team name of the players orinal team they played up from.
3-25-2019 - R. Gonzalez (TICKET NCSA33424) - Correct copy 
--->
<cfif isdefined("url.match_day_form_id")>
	<cfset match_day_form_id=url.match_day_form_id>
<cfelseif isdefined("home_match_day_form_id") and len(trim(home_match_day_form_id))>
	<cfset match_day_form_id=home_match_day_form_id>
<cfelseif isdefined("visitor_match_day_form_id")  and len(trim(visitor_match_day_form_id))>
	<cfset match_day_form_id=visitor_match_day_form_id>
</cfif>


<cfif isdefined("match_day_form_id")>
	<!--- generate pdf --->
	
	<!--- get info --->
	<cfquery datasource="#application.dsn#" name="getInfo">
		select g.game_id, m.coach1, m.coach2, m.coach3, m.coach4, 
		dbo.getteamname(t.team_id) as teamname, t.playlevel,
		g.game_code, g.field, g.game_datetime, g.home_teamname, g.visitor_teamname, dbo.f_get_team_age(m.team_id) as teamage,
		refc.firstname + ' ' + refc.lastname as ref_name,
		asst1c.firstname + ' ' + asst1c.lastname as asstref1_name,
		asst2c.firstname + ' ' + asst2c.lastname as asstref2_name,
		dbo.f_get_division(m.team_id) as division,
		m.coach1pass,m.coach2pass,m.coach3pass,m.coach4pass
		from tbl_match_day_form m with(nolock) 
		left join v_games_all g 
		on m.game_id=g.game_id
		left join tbl_team t with (nolock) 
		on m.team_id=t.team_id
		left join tbl_team ht with (nolock) 
		on g.home_team_id=ht.team_id
		left join tbl_team vt with (nolock) 
		on g.visitor_team_id=vt.team_id
		left join tbl_contact refc with (nolock) 
		on g.refid=refc.contact_id
		left join tbl_contact asst1c with (nolock) 
		on g.asstrefid1=asst1c.contact_id
		left join tbl_contact asst2c with (nolock) 
		on g.asstrefid2=asst2c.contact_id
		where m.match_day_form_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#match_day_form_id#">
	</cfquery>

	<!--- get playing ups --->
	<cfquery datasource="#application.dsn#" name="getPlayUps">
		select p.uniform_number, p.name, p.pass_number, dbo.getteamname(t.team_id) as teamname from tbl_play_up p with (nolock) 
		left join tbl_team t with (nolock) 
		on p.team_id=t.team_id
		where match_day_form_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#match_day_form_id#">
	</cfquery>
	
	<cfsavecontent variable="cfdocument_inner">
	
		<html>
			<head>
				<style type="text/css">
					body{
						font-family:arial,sans-serif;
						color:#444;
						font-size:10px;
					}
					table{
						font-size:10px;
					}
					table.border{
						border-top:1px solid black;
						border-left:1px solid black;
					}
					.border td{
						border-right:1px solid black;
						border-bottom:1px solid black;
					}
					.padding td{
						padding:4px;
					}
					.input{
						font-style:italic;
						font-size:1.2em;
						color:#000;
						font-weight:bold;
					}
					.bold{
						font-weight:bold;
					}
					.nowrap{
						white-space:nowrap;
					}
					.highlight td{
						background-color:#ff5;
					}
					.paddingsmall td{
						padding:2px;
					}
				</style>
			</head>
			<body>
				<cfoutput>
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td style="padding-bottom:5px;">
							<img src="assets/images/ncsaLogo.png" style="width:250px;">
						</td>
						<td style="text-align:right; vertical-align:top; font-size:1.2em;">
							<div style="font-size:1.9em;">
								Match Day Form
							</div>
							<div>
								To be completed and presented to referee by EACH Team
							</div>
							<div style="font-size:1.2em;">
								This form is submitted by <span class="input">#getInfo.teamname#</span> team
							</div>
						</td>
					</tr>
				</table>
				<div style="float:left; width:50%;">
				<table width="95%" border="0" cellpadding="0" cellspacing="0" class="border padding">
					<tr>
						<td width="34%">
							Match No:<span class="input">#getInfo.game_id#</span>
						</td>
						<td width="33%">
							Date:<span class="input">#dateformat(getInfo.game_datetime,"m/d/yyyy")#</span>
						</td>
						<td width="33%">
							Time:<span class="input">#timeformat(getInfo.game_datetime,"h:mm tt")#</span>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							Field:<span class="input">#getInfo.field#</span>
						</td>
						<td>
							Flight:<span class="input">#getInfo.division#</span>
						</td>
					</tr>
					<tr>
						<td>Home Team Name</td>
						<td colspan="2"><span class="input">#getInfo.home_teamname#</span></td>
					</tr>
					<tr>
						<td>Visiting Team Name</td>
						<td colspan="2"><span class="input">#getInfo.visitor_teamname#</span></td>
					</tr>
					<tr>
						<td>
							Center Referee Name<br>
							Assistant Ref 1 Name<br>
							Assistant Ref 2 Name
						</td>
						<td colspan="2">
							<span class="input">
								#getInfo.ref_name#<br>
								#getInfo.asstref1_name#<br>
								#getInfo.asstref2_name#<br>
							</span>
						</td>
					</tr>
				</table>
				</div>
				<table width="45%" border="0" cellpadding="0" cellspacing="0" class="border paddingsmall">
					<tr class="bold">
						<td class="nowrap">Div/Age</td>
						<td>Duration (Halves)</td>
						<!--- <td>Overtime (Play off)</td> --->
						<td>Overtime<br />(If Req'd)</td>
						<td>Ball</td>
						<td>Ref Fee</td>
						<td>AR Fee</td>
					</tr>
					<tr <cfif getInfo.teamage GTE 17 AND getInfo.teamage LTE 19>class="highlight"</cfif>>
						<td class="nowrap">1 (U17- U19)</td>
						<td>45 min</td>
						<!--- <td>2-15 min</td> --->
						<td>see Rules</td>
						<td>##5</td>
						<!--- <td>$80</td>
						<td>$46</td> --->
						<td>$90</td>
						<td>$50</td>
					</tr>
					<tr <cfif getInfo.teamage GTE 15 AND getInfo.teamage LTE 17>class="highlight"</cfif>>
						<td class="nowrap">2 (U15- U16)</td>
						<td>40 min</td>
						<!--- <td>2-15 min</td> --->
						<td>see Rules</td>
						<td>##5</td>
						<!--- <td>$80</td>
						<td>$46</td> --->
						<td>$80</td>
						<td>$45</td>
					</tr>
					<tr <cfif getInfo.teamage GTE 13 AND getInfo.teamage LTE 14>class="highlight"</cfif>>
						<td class="nowrap">3 (U13- U14)</td>
						<td>40 min</td>
						<!--- <td>2-10 min</td> --->
						<td>see Rules</td>
						<td>##5</td>
						<!--- <td>$70</td>
						<td>$40</td> --->
						<td>$80</td>
						<td>$45</td>
					</tr>
					<tr <cfif getInfo.teamage GTE 11 AND getInfo.teamage LTE 12>class="highlight"</cfif>>
						<td class="nowrap">4 (U11- U12)</td>
						<td>35 min</td>
						<!--- <td>2-10 min</td> --->
						<td>see Rules</td>
						<td>##4</td>
						<!--- <td>$60</td>
						<td>$36</td> --->
						<td>$70</td>
						<td>$40</td>
					</tr>
					<tr <cfif getInfo.teamage GTE 9 AND getInfo.teamage LTE 10>class="highlight"</cfif>>
						<td class="nowrap">5 (U9- U10)</td>
						<td>30 min</td>
						<!--- <td>2-10 min</td> --->
						<td>see Rules</td>
						<td>##4</td>
						<!--- <td>$50</td>
						<td>$30</td> --->
						<td>$60</td>
						<td>$35</td>
					</tr>
					<tr <cfif getInfo.teamage GTE 8 AND getInfo.teamage LTE 8>class="highlight"</cfif>>
						<td class="nowrap">6 (U8)</td>
						<td>30 min</td>
						<!--- <td>2-10 min</td> --->
						<td>see Rules</td>
						<td>##3</td>
						<!--- <td>$50</td>
						<td>$30</td> --->
						<td>$60</td>
						<td>$35</td>
					</tr>
				</table>
				<div style="border:1px solid black; padding: 15px; margin-top:5px;">
					<div style="color:black;">
						<div style="text-align:center; font-size:1.3em;">CODE OF CONDUCT AND COACHES' CERTIFICATION</div>
						<div style="text-align:center;"><span class="bold">By signing below, each coach participating in this game acknowledges reading, understanding and agreeing to all parts of this section.</span></div>
						<ol>
							<li>I am (We are) the licensed and carded coach(s) responsible today for the above team. References to singular include the plural.</li>
							<li>I have read, am familiar with and understand the rules of NCSA applicable to my team and to this game.  We understand that only carded coaches who have signed the roster may coach or provide direction to the players.</li>
							<li>I promise to treat all players, coaches, spectators and officials with respect that I would want toward my children, family and friends.</li>
							<li>I have discussed at least once this season with my players their responsibilities and proper conduct and behavior towards players, coaches and officials under FIFA and NCSA rules.</li>
							<li>
								I have discussed at least once this season with, and given a copy of this code of conduct to, all parents and team supporters of players participating in this game concerning proper behavior as spectators at a youth sports event, including:
								<ul>
									<li>Encourage your team (but only the coaches coach)</li>
									<li>Treat the opposing team (players, coaches, spectators) with respect as you would treat your own child, your team's coach and fellow spectators</li>
									<li>Treat the officials with respect; FIFA rules prohibit dissent of any type, by word or action, even if you are right.</li>
									<li>No alcohol and no smoking of any type is permitted within view of the players and the field during games.</li>
									<li>As adults and especially as coaches, we must set a good example for the players and other young persons present who will follow our conduct.</li>
								</ul>
							</li>
							<!---<li>I certify that the US Club Roster submitted to the referee contains the correct player information, uniform numbers and is current as of today's date.</li>--->
							<li>I certify that the US Club Roster submitted to the referee is current as of today and contains correct player information, including specifically the correct birth date and uniform number of each player.  I certify that all players are eligible to play on this team.</li>
							<li><span class="bold">I have checked and verified that the goals are secured</span>  (all game day coaches and referee sign below)</li>
							<li>Ref and AR fees are paid equally by the teams.  AR's are rarely assigned for U10 and younger.</li>
						</ol>
					</div>
					
					<table width="100%" border="0" cellpadding="0" cellspacing="0" class="border padding">
						<tr>
							<td colspan="3" width="60%"><span class="bold">Print Coaches Names Participating in this Game</span> (as they appear on your US Club passes) (Max 4 Coaches on sideline)</td>
							<td width="40%" class="bold">Pass Number</td>
						</tr>
						<tr>
							<td colspan="3">Coach: <span class="input">#getInfo.coach1#</span></td>
							<td>#getInfo.coach1pass#</td>
						</tr>
						<tr>
							<td colspan="3">Coach: <span class="input">#getInfo.coach2#</span></td>
							<td>#getInfo.coach2pass#</td>
						</tr>
						<tr>
							<td colspan="3">Coach: <span class="input">#getInfo.coach3#</span></td>
							<td>#getInfo.coach3pass#</td>
						</tr>
						<tr>
							<td colspan="3">Coach: <span class="input">#getInfo.coach4#</span></td>
							<td>#getInfo.coach4pass#</td>
						</tr>
						<tr>
							<!---<td colspan="3" class="bold">PLAYERS PLAYING UP - This section lists players you entered online who are playing up per NCSA Rule 4.5.  If you did not complete this section already online, the form has blank lines to insert information on game day.  NOTE: within 24 hours you MUST enter that information ONLINE by creating a new Match Day Form for this game.</td>--->
							<td colspan="4"><span class="bold">PLAYERS PLAYING UP</span> - This section lists players you entered online who are playing up per NCSA Rule 4.5. If you did not complete this section already online, the form has blank lines to insert information on game day. <span class="bold">NOTE: within 24 hours you MUST enter that information ONLINE by creating a new Match Day Form for this game.  All coaches certify that players listed here are eligible to play up in this game per NCSA Rule 4.5.</span></td>
						</tr>
						<tr class="bold">
							<td width="15%">Uniform Number</td>
							<td>Name</td>
							<td width="15%">Pass ##</td>
							<td>Team Playing From</td>
						</tr>
						<cfloop query="getPlayUps">
							<tr>
								<td><span class="input">#Uniform_Number#</span></td>
								<td><span class="input">#name#</span></td>
								<td><span class="input">#pass_number#</span></td>
								<td><span class="input">#teamname#</span></td>
							</tr>
						</cfloop>
						<!--- <cfset numBlanks=9-getPlayUps.recordcount>
						<cfif numBlanks GT 0>
							<cfloop from="1" to="#numBlanks#" index="i">
							<tr>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</tr>
							</cfloop>
						</cfif> --->
						<tr>
							<td colspan="4">&nbsp;</td>
						</tr>
						<!--- <tr>
							<td colspan="3" class="bold">Referee (Sign to the right to attest to ##7 only - goals are secured):</td>
							<td>&nbsp;</td>
						</tr> --->
						<!--- <tr>
							<td colspan="4">
							<!---Referee:   Attach both teams' Match Day Forms and US Club Rosters to your Referee Report and (a) mail to  <span class="bold">NCSA Referee Office; P.O.Box 26, Ho-Ho-Kus, NJ 07423</span>; (b) fax all to 201-652-9176 OR (c) scan and email to ncsa.admin@verizon.net within 24 hours of game.--->
							Referee: Attach both teams' Match Day Forms and US Club Rosters to your Referee Report and within 24 hours of game (a) preferred method - scan and email to ncsanj@gmail.com; (b) fax all to 201-857-0873; or (c) least preferred -  mail to &nbsp;<span class="bold">NCSA Referee Office; P.O.Box 26, Ho-Ho-Kus, NJ 07423</span>
							</td>
						</tr> --->
					</table>
				</div>
				<!--- <div style="font-size:2.5em; font-weight:bold; text-align:center; color:red;">ENJOY THE BEAUTIFUL GAME</div> --->
				<div style="position:absolute; bottom:0; right:0;">Generated #dateformat(now(),"m/d/yyyy")# #timeformat(now(),"h:mm tt")#</div>
				</cfoutput>
			</body>
		</html>
	</cfsavecontent>
	
	<cfdocument name="voucherPDF2" format="pdf" marginTop="0.1" marginRight=".3" marginBottom=".3" marginLeft=".3" localurl="true">
	<cfoutput>#cfdocument_inner#</cfoutput>
	</cfdocument>

	<cfif isdefined("home_match_day_form_id")>
		<cfset home_mdf = "#toBinary(voucherPDF2)#">
	<cfelseif isdefined("visitor_match_day_form_id")>
		<cfset visitor_mdf = "#toBinary(voucherPDF2)#">
	<cfelse>
		<cfheader name="Content-Disposition" 
		value="inline; filename=match-day-form.pdf">
		<cfcontent type="application/pdf" variable="#toBinary(voucherPDF2)#">
	</cfif>
		
</cfif>