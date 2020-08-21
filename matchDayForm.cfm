<!--- 
	FileName:	matchDayForm.cfm
	Created on: 2/121/2011
	Created by: bcooper@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
7-29-2014 - J. Danz - (TICKET NCSA15481) - updated the "get teams for user login" ifstatment to include id 20 and changed the condition to GTE instead of just GT so that Assistant Admins can get access as well.
05/25/2017 - A. Pinzone - Ticket NCSA22821
	-- Moved jQuery & JS to footer
	-- Moved jQuery CSS to the header
	-- Removed reference to older jquery (1.4.2)
 --->
 
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


<CFIF isDefined("FORM.btnSave")>
	<cfinvoke
		component="#application.sitevars.cfcpath#.game"
		method="saveMatchDayForm"
		game_id="#form.game_id#"
		team_id="#form.team_id#"
		coach1="#form.coach1#"
		coach2="#form.coach2#"
		coach3="#form.coach3#"
		coach4="#form.coach4#"
		returnvariable="match_day_form_id">
		
	<!--- remove current play ups --->
	<cfinvoke
		component="#application.sitevars.cfcpath#.game"
		method="removePlayUps"
		match_day_form_id="#match_day_form_id#">
	
	<!--- process playups --->
	<cfif isdefined("form.playingUp") AND form.playingUp EQ "1">
		<cfloop list="#form.fieldnames#" index="i">
			<cfif left(i,10) EQ "playUpName">
				<cfset playUpNum=right(i,len(i)-10)>
				<cfset playUpName=form[i]>
				<cfset playUpPass=form["playUpPass#playUpNum#"]>
				<cfset playUpTeam=form["playUpTeam#playUpNum#"]>
				<cfset playUpUniformNumber=form["playUpUniformNumber#playUpNum#"]>
				<cfif playUpName NEQ "" AND playUpPass NEQ "" AND playUpTeam NEQ "" AND playUpUniformNumber NEQ "">
					<cfinvoke
						component="#application.sitevars.cfcpath#.game"
						method="savePlayUp"
						match_day_form_id="#match_day_form_id#"
						uniform_number="#playUpUniformNumber#"
						name="#playUpName#"
						pass="#playUpPass#"
						team_id="#playUpTeam#"
						returnvariable="play_up_id">
				<cfelse>
					<cfthrow message="All Play Up fields are required.  Please go back and try again.">
				</cfif>
			</cfif>
		</cfloop>
	</cfif>
	
	<cflocation url="matchDayForm.cfm?team_id=#form.team_id#&match_day_form_id=#match_day_form_id#" addtoken="No">
</CFIF>


<cfif team_id EQ "">
	<!--- get teams for user logged in --->
	<cfif listFind("1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21",Session.menuroleID) GTE 1> <!--- if admin/board user --->
		<cfinvoke
			component="#session.sitevars.cfcpath#team"
			method="getClubTeams"
			clubid="0"
			orderBy="CLUB"
			season_id="#session.currentseason.id#"
			excludeNonLeague="yes"
			returnvariable="contactTeams">
	<cfelseif listfind("26,27,28",session.menuroleid) NEQ 0><!--- if user is club rep/alt rep/pres --->
		<cfinvoke
			component="#session.sitevars.cfcpath#team"
			method="getClubTeams"
			clubid="#session.user.clubid#"
			season_id="#session.currentseason.id#"
			excludeNonLeague="yes"
			returnvariable="contactTeams">
	<cfelse>
		<cfinvoke
			component="#session.sitevars.cfcpath#team"
			method="getContactTeams"
			contact_id="#session.user.contactid#"
			season_id="#session.currentseason.id#"
			excludeNonLeague="yes"
			returnvariable="contactTeams">
	</cfif>
	
	<cfif contactTeams.recordcount EQ 1>
		<cfset team_id=contactTeams.team_id>
	</cfif>
</cfif>

<cfif team_id NEQ "">
	<!--- get games --->
	<cfquery datasource="#application.dsn#" name="qGetGames">
		select m.match_day_form_id, g.game_id, game_datetime, score_home, score_visitor, game_code, field_Id, field, visitor_teamname, home_teamname 
		from v_games_all g
		left join tbl_match_day_form m
		on g.game_id=m.game_id and m.team_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#team_id#">
		where 
		(visitor=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#team_id#"> or home=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#team_id#">)
		order by game_datetime asc
	</cfquery>
</cfif>
<cftry>
<cfif isdefined("game_Id")>
	<cfquery datasource="#application.dsn#" name="getGame">
		select g.*, 
		dbo.f_get_team_age(ht.team_id) as home_team_age, 
		dbo.f_get_team_age(vt.team_id) as visitor_team_age,
		ascii(ht.playlevel) as home_flight,
		ascii(vt.playlevel) as visitor_flight,
		ht.playlevel as home_playlevel
		from v_games_all g
		inner join tbl_team ht
		on g.home_team_id=ht.team_id
		inner join tbl_team vt
		on g.visitor_team_id=vt.team_id
		where game_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#game_id#">
	</cfquery>
	<cfset teamAge=max(getGame.home_team_age,getGame.visitor_team_age)>
	<cfset flight=max(getGame.home_flight, getGAme.visitor_flight)>
	
	<!--- get team info --->
	<cfquery datasource="#application.dsn#" name="getTeamInfo">
		select club_id, gender from tbl_team
		where team_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#team_id#">
	</cfquery>
	
	<!--- get teams available for play up --->
	<cfquery datasource="#application.dsn#" name="getPlayUpTeams">
		select team_id, dbo.getteamname(team_id) as teamname
		from tbl_team
		where club_id= <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#getTeamInfo.club_id#">
		AND 
		(
		(dbo.f_get_team_age(team_id) < <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#teamAge#">
			AND playlevel <> 'P')
		OR (dbo.f_get_team_age(team_id) = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#teamAge#">
			AND dbo.f_is_level_lesser(<cfqueryparam cfsqltype="CF_SQL_CHAR" value="#getGame.home_playlevel#">,playlevel) = 1)
		OR (dbo.f_get_team_age(team_id) < <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#teamAge#">
			AND dbo.f_is_level_lesser(<cfqueryparam cfsqltype="CF_SQL_CHAR" value="#getGame.home_playlevel#">,playlevel) = 0)
		)
		AND playLevel <> 'R'
		AND season_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#getGame.season_id#">
		<cfif getTeamInfo.gender EQ "G">
		AND gender = 'G'
		<cfelseif getTeamInfo.gender EQ "G">
		AND gender = 'B'
		</cfif>
		order by teamname
	</cfquery>
	
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
	
	<!--- get match day form --->
	<cfquery datasource="#application.dsn#" name="getForm">
		select * from tbl_match_day_Form
		where game_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#game_id#">
		and team_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#team_id#">
	</cfquery>
	
	<cfset playingUp=false>
	<cfset playingUpNum=1>
	<cfif getForm.recordcount>
		<cfset coach1=getForm.coach1>
		<cfset coach2=getForm.coach2>
		<cfset coach3=getForm.coach3>
		<cfset coach4=getForm.coach4>
		<!--- get play ups --->
		<cfquery datasource="#application.dsn#" name="getPlayUps">
			select 	match_day_form_id,
					UNIFORM_NUMBER, 
					name, 
					pass_number, 
					team_id, 
					datecreated, 
					createdBy_contactID 
			from 	tbl_play_up
			where 	match_day_form_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#getForm.match_Day_form_id#">
		</cfquery>
		<cfif getPlayUps.recordcount>
			<cfset playingUp=true>
			<cfset playingUpNum=getPlayUps.recordcount>
		</cfif>
	<cfelse>
		<cfset coach1="#getTeamInfo.head_firstname# #getTeamInfo.head_lastname#">
		<cfset coach2="#getTeamInfo.asst_firstname# #getTeamInfo.asst_lastname#">
		<cfset coach3="">
		<cfset coach4="">
	</cfif>
	
</cfif>
<cfcatch>
	<cfset error_occured = 1>
</cfcatch>
</cftry>

<div id="contentText">
<H1 class="pageheading">NCSA - Match Day Form</H1>
<br> <!--- <h2>yyyyyy </h2> --->


<cfif isDefined("error_occured") and error_occured EQ 1>
<h2 style="margin: 20px 0; color: black;" >Match day forms apply to NCSA league games only.</h2>
<div><input type="button" onclick="history.go(-1);" value="&laquo; Go Back" /></div>

<cfelse>
<cfif not isdefined("game_id")>
	<cfif team_id EQ "">
	<FORM action="matchDayForm.cfm" method="post">
		
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
	</form>
	</cfif>
	<CFIF isDefined("qGetGames") AND qGetGames.RECORDCOUNT>
		
		<cfif isdefined("url.match_day_form_id")>
			<script language="JavaScript" type="text/javascript">
				window.open('matchDayFormView.cfm?match_day_form_id=#match_day_form_id#');
			</script>
		</cfif>
		<div class="notice">
			To create or revise a Match Day Form, please click game number.  Verify listed coaches and add any others.  Add required info for players playing up.  Once the form is completed, click the "save" button.  To PRINT a Match Day Form, click "VIEW" next to the game and print the PDF version of the form.
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
				<th style="text-align:center;">View Form</th>
			</TR>
			</thead>
			<tbody>
			
			<cfloop query="qGetGames">
				<tr>
					<td><cfif listFind("1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,21",Session.menuroleID) GTE 1 OR datediff("n",game_datetime,now()) LT 1440><a href="matchDayForm.cfm?team_id=#team_id#&game_id=#game_id#">#game_id#</a><cfelse>#game_id#</cfif></td>
					<td>#dateformat(game_datetime, "m/d/yyyy")# #timeformat(game_datetime,"h:mm tt")#</td>
					<td>#home_teamname#</td>
					<td>#visitor_teamname#</td>
					<td style="text-align:center;">#score_home#&nbsp;</td>
					<td style="text-align:center;">#score_visitor#&nbsp;</td>
					<td style="text-align:center;">
						<cfif match_day_form_id NEQ "">
							<a target="_blank" href="matchDayFormView.cfm?match_day_form_id=#match_day_form_id#">View</a>
						</cfif>&nbsp;
					</td>
				</tr>
			</cfloop>
			</tbody>
		</TABLE>
	</CFIF>
<cfelse>
	<cfsavecontent variable="jq_css">
		<link rel="stylesheet" href="assets/jQuery-ui-1.8.9/css/ui-lightness/jquery-ui-1.8.9.custom.css">
		<style type="text/css">
			.ui-autocomplete{
				font-size:.9em;
				max-height:150px;
				overflow-y:auto;
				overflow-x: hidden;
				padding-right: 20px;
			}
		</style>
	</cfsavecontent>
	<cfhtmlhead text="#jq_css#">
	<cfsavecontent variable="cf_footer_scripts">
		<script language="JavaScript" type="text/javascript" src="assets/jquery-ui-1.12.1.min.js"></script>
		<script language="JavaScript" type="text/javascript">
			var playUpNum=#playingUpNum#;
			$(function(){
			
				//Attach autocomplete js to 4 coach input boxes.  Entering characters triggers autocomplete to fetch existing coaches via ajax
				$('.coachAutocomplete').autocomplete({
					source:'async_coach_autocomplete.cfm',
					minLength:0
				});
				
				//link trigger for adding new rows for playups
				$('##playUpAddTrigger').click(function(){
					playUpNum++;
					var newdiv=$('<div/>',{
						"class":"playUp"
					});
					$(newdiv).append( $('.playUptemplate').html() );
					$(newdiv).find('input,select').each(function(){
						$(this).prop('name',$(this).prop('name') + playUpNum);
					});

					$('.playUpWrapper').append(newdiv);
					
				});
				console.log('WOrking!');
				//link trigger for removing a playup row.  This uses live to make sure it is called for all current and future instances added using the add trigger
				$(document).on('click','.playUpRemove',function(){
					//remove the row
					console.log('Removing');
					$(this).parent().remove();
				});
				
				$(".coachClear").click(function(){
					$(this).prev().val('').focus();
				});
				
				$('input[name=playingUp]').click(showHidePlayUpRow);
				
				showHidePlayUpRow();
				
			});
			
			/*
			* handles showing/hiding the playup section based on selection of playing up radio button
			*/
			function showHidePlayUpRow()
			{
				if($('input[name=playingUp]:checked').val() == '1')
					$('##playUpRow').show();
				else
					$('##playUpRow').hide();
					
			}
			
			/*
			* validate the play up rows by checking for required fields
			*/
			function validatePlayUp(){
				var fieldsValid=true;
				
				if($('input[name=playingUp]:checked').val() == '1'){
					//loop through rows of play ups and see if any are missing values
					$('##playUpRow .playUp').not('.playUptemplate').each(function(){
						if($(this).find('input[name^=playUpUniformNumber]').val() == '' ||
							$(this).find('input[name^=playUpName]').val() == '' ||
							$(this).find('input[name^=playUpPass]').val() == '' ||
							$(this).find('select').val() == '')
						{
							alert('All play up fields are required');
							fieldsValid=false;
							return false;
						}
					});
				}
				
				return fieldsValid;
			}
		</script>
	</cfsavecontent>
	
	<form action="matchDayForm.cfm" method="post" onSubmit="return validatePlayUp();">
		<input type="hidden" name="game_id" value="#game_id#">
		<input type="hidden" name="team_id" value="#team_id#">
		<!--- get game info --->
		<cfquery datasource="#application.dsn#" name="getGame">
			select game_id, game_code, home_teamname, visitor_teamname, game_datetime, field from v_games_all
			where game_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#game_id#">
		</cfquery>
		<style type="text/css">
			.formTable{
				width:90%;
			}
			.formTable th,.formTable td{
				padding:4px;
			}
			.formTable th{
				width:45%;
				text-align:right;
			}
		</style>
		<h3>(#getGame.game_id#) #getGame.home_teamname# VS #getGame.visitor_teamname# on #dateformat(getGame.game_datetime, "m/d/yyyy")# #timeformat(getGame.game_datetime,"h:mm tt")#</h3>
		<h3>Field: #getGame.field#</h3>
		
		<table border="0" cellpadding="0" cellspacing="0" class="formTable">
			<tr>
				<th>Coaches</th>
				<td>
					Coach 1: <input type="text" name="coach1" value="#coach1#" class="coachAutocomplete" tabindex="1"> <cfif coach1 NEQ ""><a href="javascript:void(0);" class="coachClear">Clear</a></cfif><br>
					Coach 2: <input type="text" name="coach2" value="#coach2#" class="coachAutocomplete" tabindex="2"> <cfif coach2 NEQ ""><a href="javascript:void(0);" class="coachClear">Clear</a></cfif><br>
					Coach 3: <input type="text" name="coach3" value="#coach3#" class="coachAutocomplete" tabindex="3"> <cfif coach3 NEQ ""><a href="javascript:void(0);" class="coachClear">Clear</a></cfif><br>
					Coach 4: <input type="text" name="coach4" value="#coach4#" class="coachAutocomplete" tabindex="4"> <cfif coach4 NEQ ""><a href="javascript:void(0);" class="coachClear">Clear</a></cfif>
				</td>
			</tr>
			<tr>
				<th>Are there any players playing up?</th>
				<td><input type="radio" name="playingUp" value="1" <cfif playingUp>checked="checked"</cfif>>Yes <input type="radio" name="playingUp" value="0" <cfif NOT playingUp>checked="checked"</cfif>>No</td>
			</tr>
			<tr>
				<td colspan="2">
				<div class="notice">
					If you select "no", the form will still print blank lines for insertion of player info manually on game day - 
					you MUST return within 24 hours of game time to insert all handwritten names, pass numbers and teams of such players.  
					If you select "yes", you must insert each player’s uniform number, name, pass number and team for such players.  Do not select yes just to create 
					blank lines as the form already does that for you.
				</div>
				</td>
			</tr>
			<tr id="playUpRow">
				<td colspan="2">
					<strong>You must enter each player’s uniform number, name and pass number and select the team from which the player is playing up only as permitted by NCSA Rule 4.5.  If a team is not listed in the drop down section, a player is not able to play up from that non-listed team to this team for which the Match Day Form is being created.  The teams listed for eligible players playing up should be consistent with NCSA Rule 4.5.</strong><br /><br>
					<cfif isdefined("getPlayUps") AND getPlayUps.recordcount>
						<div class="playUpWrapper">
							<cfloop query="getPlayUps">
								<cfset playUpTeamID=getPlayUps.team_id>
								<div class="playUp">
									Uniform Number: <input type="Text" name="playUpUniformNumber#currentrow#" value="#getPlayUps.Uniform_Number#" style="width:30px;">  Name: <input type="Text" name="playUpName#currentrow#" value="#getPlayUps.name#"> Pass Number: <input type="text" name="playUpPass#currentrow#" value="#pass_number#" style="width:50px;"> Team:
									<select name="playUpTeam#currentrow#">
										<option value="">Select Team</option>
										<cfloop query="getPlayupteams">
											<option value="#team_id#" <cfif team_id EQ playUpTeamID>selected="selected"</cfif>>#teamname#</option>
										</cfloop>
									</select>
									<!--- trigger to remove playup row --->
									<a href="javascript:void(0);" class="playUpRemove">Remove</a>
								</div>
							</cfloop>
						</div>
					<cfelse>
						<div class="playUpWrapper">
							<div class="playUp">
								Uniform Number: <input type="Text" name="playUpUniformNumber1" style="width:30px;">  Name: <input type="Text" name="playUpName1"> Pass Number: <input type="text" name="playUpPass1" style="width:50px;"> Team:
								<select name="playUpTeam1">
									<option value="">Select Team</option>
									<cfloop query="getPlayupteams">
										<option value="#team_id#">#teamname#</option>
									</cfloop>
								</select>
								<!--- trigger to remove playup row --->
								<a href="javascript:void(0);" class="playUpRemove">Remove</a>
							</div>
						</div>
					</cfif>
					
					<!--- trigger to add more playup rows --->
					<a href="javascript:void(0);" id="playUpAddTrigger">Add Another</a>
				</td>
			</tr>
			<tr>
				<th>
					<input type="Button" name="btnCancel" onclick="javascript:history.go(-1);" value="Cancel"><input type="Submit" name="btnSave" value="Save &amp; View/Print">
				</th>
				<td>
				</td>
			</tr>
		</table>
		
	</form>

	<!--- This is the template that is duplicated when a user clicks the 'add another' trigger --->
	<div class="playUp playUptemplate" style="display:none;">
		Uniform Number: <input type="Text" name="playUpUniformNumber"  style="width:30px;">  Name: <input type="Text" name="playUpName"> Pass Number: <input type="text" name="playUpPass" style="width:50px;"> Team:
		<select name="playUpTeam" >
			<option value="">Select Team</option>
			<cfloop query="getPlayupteams">
				<option value="#team_id#">#teamname#</option>
			</cfloop>
		</select>
		<!--- trigger to remove playup row --->
		<a href="javascript:void(0);" class="playUpRemove">Remove</a>
	</div>

</cfif>

</cfif>
</cfoutput>
</div>
<cfinclude template="_footer.cfm">

