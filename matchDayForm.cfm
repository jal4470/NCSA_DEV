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
<cfset error = "">
<cfif isdefined("url.game_id")>
	<cfset game_id=url.game_id>
</cfif>


<CFIF isDefined("FORM.btnSave")>

	<cfif not len(trim(form.coach1)) and not len(trim(form.coach2)) and not len(trim(form.coach3)) and not len(trim(form.coach4)) >
		<cfset error = "Please provide at least 1 coach.">
	<cfelse>
			<cfinvoke
				component="#application.sitevars.cfcpath#.game"
				method="saveMatchDayForm"
				game_id="#form.game_id#"
				team_id="#form.team_id#"
				coach1="#form.coach1#"
				coach2="#form.coach2#"
				coach3="#form.coach3#"
				coach4="#form.coach4#"
				coach1pass="#form.coach1pass#"
				coach2pass="#form.coach2pass#"
				coach3pass="#form.coach3pass#"
				coach4pass="#form.coach4pass#"
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
						<cfif isdefined("puOther#playUpNum#")>
							<cfset playUpOther=form["puOther#playUpNum#"]>
						<cfelse>
							<cfset playUpOther = "">
						</cfif>
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
								other = "#playUpOther#"
								returnvariable="play_up_id">
						<cfelse>
							<cfthrow message="All Play Up fields are required.  Please go back and try again.">
						</cfif>
					</cfif>
				</cfloop>
			</cfif>
			
			<cflocation url="matchDayForm.cfm?team_id=#form.team_id#&match_day_form_id=#match_day_form_id#" addtoken="No">
	</cfif>
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
		select m.match_day_form_id, g.game_id, game_datetime, score_home, score_visitor, game_code, field_Id, field, visitor_teamname, home_teamname,
		   dbo.f_getTeamRoster(home_team_id) as home_team_roster_id, dbo.f_getTeamRoster(visitor_team_id) as visitor_team_roster_id,
		   dbo.f_get_MDF(home_team_id, g.game_id) as home_team_mdf, dbo.f_get_MDF(visitor_team_id, g.game_id) as visitor_team_mdf 
		from v_games_all g
		left join tbl_match_day_form m
		on g.game_id=m.game_id and m.team_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#team_id#">
		where 
		(visitor=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#team_id#"> or home=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#team_id#">)
		order by game_datetime asc
	</cfquery>
	<!--- <cfdump var="#qGetGames#" abort="true"> --->
</cfif>
<!--- <cftry> --->
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
	
	<cfquery name="getMDFId" datasource="#session.dsn#">
		select match_day_form_id from tbl_match_day_form where
		team_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#team_id#">
	</cfquery>
<!--- 	<cfdump var="#qGetGames#" abort="true"> --->
	<!--- get teams available for play up --->

<!--- 	<cfdump var="#getPlayUpTeams#" abort="true"> --->
	<!--- get team info --->
	<cfquery datasource="#application.dsn#" name="getTeamInfo">
		select t.*, c.firstname as head_firstname, c.lastname as Head_lastname, ac.firstname as asst_firstname, ac.lastname as asst_lastname,ac2.firstname as asst2_firstname, ac2.lastname as asst2_lastname,ac3.firstname as asst3_firstname, ac3.lastname as asst3_lastname,
		c.pass_number as Head_pass_number,ac.pass_number as asst_pass_number,ac2.pass_number as asst2_pass_number,ac3.pass_number as asst3_pass_number
		from tbl_team t
		left join tbl_contact c
		on t.contactidhead=c.contact_id
		left join tbl_contact ac
		on t.contactidasst=ac.contact_id
		left join tbl_contact ac2
		on t.contactidasst2=ac2.contact_id
		left join tbl_contact ac3
		on t.contactidasst3=ac3.contact_id
		where t.team_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#team_id#">
	</cfquery>
<!--- 	<cfdump var="#getTeamInfo#" abort="true"> --->
	<!--- get match day form --->
	<cfquery datasource="#application.dsn#" name="getForm">
		select match_day_form_id, coach1, coach2, coach3, coach4, game_id, team_id, coach1pass, coach2pass, coach3pass, coach4pass from tbl_match_day_Form
		where game_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#game_id#">
		and team_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#team_id#">
	</cfquery>

<!--- 	-- select team_id, name as teamname, other_team
		-- from tbl_play_up where match_day_form_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#getForm.match_day_form_id#">
		-- and team_id = 0
		-- union 

	AND 
		(
		(dbo.f_get_team_age(team_id) < <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#teamAge#">
			AND playlevel <> 'P')
		OR (dbo.f_get_team_age(team_id) = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#teamAge#">
			AND dbo.f_is_level_lesser(<cfqueryparam cfsqltype="CF_SQL_CHAR" value="#getGame.home_playlevel#">,playlevel) = 1)
		OR (dbo.f_get_team_age(team_id) < <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#teamAge#">
			AND dbo.f_is_level_lesser(<cfqueryparam cfsqltype="CF_SQL_CHAR" value="#getGame.home_playlevel#">,playlevel) = 0)
		)
				<cfif getTeamInfo.gender EQ "G">
		AND gender = 'G'
		<cfelseif getTeamInfo.gender EQ "B">
		AND gender = 'B'
		</cfif>
	--->
	<cfquery datasource="#application.dsn#" name="getPlayUpTeams">
	
		select team_id, dbo.getteamname(team_id) as teamname --, null as others_seq
		from tbl_team
		where club_id= <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#getTeamInfo.club_id#">
	
		AND playLevel not in('R','J','X')
		AND team_id <> <cfqueryparam cfsqltype="cf_sql_integer" value="#team_id#">
		AND season_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#getGame.season_id#">
	</cfquery>


	<cfset playingUp=false>
	<cfset playingUpNum=1>

	<cfif getForm.recordcount>
		<cfset coach1=getForm.coach1>
		<cfset coach2=getForm.coach2>
		<cfset coach3=getForm.coach3>
		<cfset coach4=getForm.coach4>
		<cfset coach1pass=iif(getForm.coach1pass neq "",de(getForm.coach1pass), de(""))>
		<cfset coach2pass=iif(getForm.coach2pass neq "",de(getForm.coach2pass), de(""))>
		<cfset coach3pass=iif(getForm.coach3pass neq "",de(getForm.coach3pass), de(""))>
		<cfset coach4pass=iif(getForm.coach4pass neq "",de(getForm.coach4pass), de(""))>
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
		<cfset coach3="#getTeamInfo.asst2_firstname# #getTeamInfo.asst2_lastname#">
		<cfset coach4="#getTeamInfo.asst3_firstname# #getTeamInfo.asst3_lastname#">
		<cfset coach1pass="#getTeamInfo.head_pass_number#">
		<cfset coach2pass="#getTeamInfo.asst_pass_number#">
		<cfset coach3pass="#getTeamInfo.asst2_pass_number#">
		<cfset coach4pass="#getTeamInfo.asst3_pass_number#">
	</cfif>

	
</cfif>
<!--- <cfcatch>
	<cfset error_occured = 1>
	<cfdump var="#cfcatch#">
</cfcatch>
</cftry> --->

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
		<table class="table1" cellpadding="3" cellspacing="0" border="0" style="font-size: .9em;">
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
					<td><!---<a href="matchDayForm.cfm?team_id=#team_id#&game_id=#game_id#">#game_id#</a>  ---><cfif listFind("1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,21",Session.menuroleID) GTE 1 OR datediff("n",game_datetime,now()) LT 1440><a href="matchDayForm.cfm?team_id=#team_id#&game_id=#game_id#">#game_id#</a><cfelse>#game_id#</cfif></td>
					<td>#dateformat(game_datetime, "m/d/yyyy")# #timeformat(game_datetime,"h:mm tt")#</td>
					<td>#home_teamname#</td>
					<td>#visitor_teamname#</td>
					<td style="text-align:center;">#score_home#&nbsp;</td>
					<td style="text-align:center;">#score_visitor#&nbsp;</td>
					<td style="text-align:center;">
						<cfif match_day_form_id NEQ "">
							<div style="border-bottom:solid 1px ##ccc;padding-bottom: 3px;margin: 3px 0 3px 0;">
							
								<a target="_blank" href="matchDayFormView.cfm?match_day_form_id=#match_day_form_id#">View MDF</a>
							
							</div>
						</cfif>
						<div style="margin-top:3px;padding-top:3px;">
							<cfset official_game_date = dateformat(game_datetime,"mm/dd/yyyy") & ' ' & timeformat(game_datetime,"hh:mm:ss t")>
							<cfset timerestricted = "26,27,28,29">
						 		<!---<cfdump var="#datediff('h',official_game_date,now())#"><cfdump var="[#game_datetime#]">  --->
							<cfif datediff('h',official_game_date,now()) lte 24 and datediff('h',official_game_date,now()) gte -24 and listFindNoCase(timerestricted,session.menuroleID)>
								<!--- <a href="GameDayDocuments.cfm?home_team_roster_id=#home_team_roster_id#&visitor_team_roster_id=#visitor_team_roster_id#&home_team_mdf=#home_team_mdf#&visitor_team_mdf=#visitor_team_mdf#&game_id=#game_id#" target="_blank">Game Day Docs</a> --->
								<a href="ViewGameDayDocs.cfm?game_id=#game_id#" target="_blank" class="yellow_btn">Game Day Docs</a>
							<cfelseif not listFindNoCase(timerestricted,session.menuroleID)>
	<!--- 								<cfquery datasource="#application.dsn#" name="getGameDayDoc">
										select game_day_document_id from TBL_GAME_DAY_DOCUMENTS
										where game_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#game_id#">
									</cfquery> --->
									<!--- <cfif getGameDayDoc.RecordCount> --->
								<a href="ViewGameDayDocs.cfm?game_id=#game_id#" target="_blank" class="yellow_btn">Game Day Docs</a>
									<!--- </cfif> --->
							</cfif>
						</div>
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
					source:'async_coach_autocomplete.cfm?clubid=<cfoutput>#session.user.clubid#</cfoutput>',
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
				//link trigger for removing a playup row.  This uses live to make sure it is called for all current and future instances added using the add trigger
				$(document).on('click','.playUpRemove',function(event){
					//remove the row
					$( event.target ).closest(".playUp").remove();
				});
				
				$(".coachClear").click(function(){
					$(this).prev().val('').focus();
					$(this).siblings("input[name^=coach]").val('').focus();
				});
				
				$('input[name=playingUp]').click(showHidePlayUpRow);

				$(document).on("change","select[name^=playUpTeam]",	 function(){
					//console.log($(this).val());
					if($(this).val() == "0" && $(this).siblings("input[name^=PUOther]").hasClass("hidden"))
						$(this).siblings("input[name^=PUOther]").removeClass("hidden");
					else
						$(this).siblings("input[name^=PUOther]").addClass("hidden");
				});
				
				showHidePlayUpRow();
				
			});
			
			/*
			* handles showing/hiding the playup section based on selection of playing up radio button
			*/
			function showHidePlayUpRow()
			{
				if($('input[name=playingUp]:checked').val() == '1')
				{
					$('##playUpRow').show();
					$('.playupverb').show();
				}
				else
				{
					$('##playUpRow').hide();
					$('.playupverb').hide();
				}
					
			}
			
			/*
			* validate the play up rows by checking for required fields
			*/

			function validateAll(){
				var fieldsValid=true;
				

				if($("input[name=coach1]").trim().val().length > 0 && $("input[name=coach1pass]").val().trim().length == 0)
				{
					alert('Pass for Coach 1 is required.');
					fieldsValid=false;
					return false;
				}

				if($("input[name=coach2]").val().trim().length > 0 && $("input[name=coach2pass]").val().trim().length == 0)
				{
					alert('Pass for Coach 2 is required.');
					fieldsValid=false;
					return false;
				}

				if($("input[name=coach3]").trim().val().length > 0 && $("input[name=coach3pass]").val().trim().length == 0)
				{
					alert('Pass for Coach 3 is required.');
					fieldsValid=false;
					return false;
				}

				if($("input[name=coach4]").val().trim().length > 0 && $("input[name=coach4pass]").val().trim().length == 0)
				{
					alert('Pass for Coach 4 is required.');
					fieldsValid=false;
					return false;
				}

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

			// function validatePlayUp(){
			// 	var fieldsValid=true;
				
			// 	if($('input[name=playingUp]:checked').val() == '1'){
			// 		//loop through rows of play ups and see if any are missing values
			// 		$('##playUpRow .playUp').not('.playUptemplate').each(function(){
			// 			if($(this).find('input[name^=playUpUniformNumber]').val() == '' ||
			// 				$(this).find('input[name^=playUpName]').val() == '' ||
			// 				$(this).find('input[name^=playUpPass]').val() == '' ||
			// 				$(this).find('select').val() == '')
			// 			{
			// 				alert('All play up fields are required');
			// 				fieldsValid=false;
			// 				return false;
			// 			}
			// 		});
			// 	}
				
			// 	return fieldsValid;
			// }
		</script>
	</cfsavecontent>
	
	<form action="matchDayForm.cfm" method="post" onSubmit="return validateAll();">
		<input type="hidden" name="game_id" value="#game_id#">
		<input type="hidden" name="team_id" value="#team_id#">
		<!--- get game info --->
		<cfquery datasource="#application.dsn#" name="getGame">
			select game_id, game_code, home_teamname, visitor_teamname, game_datetime, field from v_games_all
			where game_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#game_id#">
		</cfquery>
		<style type="text/css">
			.formTable{
				width:100%;
			}
			.formTable th,.formTable td{
				padding:4px;
			}
			.formTable th{
				padding:2%;
			}
			.hidden{
				display:none;
			}
			.buttonBar>input{
				height:3em;
			}
			.line{
				margin-left:30%;
				margin-top:2%;
				margin-right: 30%;
			}
			@media only screen and (max-width: 600px) {
			  .line{
				margin-top: 2%;
			    width: 100%;
			    margin-left:2px;
			    font-size:1.1em;
			   }
			   .line>input{
					height:1em;
					font-size:1em;
			    }
			}
			    
			.line>input{
				height:30px;
			}
			select{
				height:25px;
				width:30%;
			}
			.formHead{
				margin-top:2%;
				margin-left:-3%;
			}
			.playup{
			    margin-left: 10%;
			    margin-top: 2%;
			    margin-right: 8%;
			}
			.other{
				margin-left: 5px;
			    width: 22%;
			    min-width: 106px;
			}
			.coach>input{
				min-width:230px;
				padding:1%;
				margin:1%;
			}
			.alt{
				background-color: ##eeeeee;
				padding:1%;
				border:1px solid ##eeeeee;
				border-radius: 5px;
				min-width: 244px;
			}


		</style>
		<h3>(#getGame.game_id#) #getGame.home_teamname# VS #getGame.visitor_teamname# on #dateformat(getGame.game_datetime, "m/d/yyyy")# #timeformat(getGame.game_datetime,"h:mm tt")#</h3>
		<h3>Field: #getGame.field#</h3>
		
		<table border="0" cellpadding="0" cellspacing="0" class="formTable">
			<th colspan="2" ><div class="formHead alt"><h1>COACHES</h1></div></th></tr>
			<tr>
				<td colspan="2">
					<cfif len(trim(error))>
						<div class="error">#error#</div>
					</cfif>
					<div class="line coach">Coach 1: <input type="text" name="coach1" value="#coach1#" class="coachAutocomplete" tabindex="1"><br>Pass No.:<input type="text" name="coach1pass" value="#coach1pass#" class="coachAutocomplete" tabindex="1"><br><br><cfif coach1 NEQ ""><a href="javascript:void(0);" class="coachClear">Clear</a></cfif><hr></div>
					<div class="line coach alt">Coach 2: <input type="text" name="coach2" value="#coach2#" class="coachAutocomplete" tabindex="2"><br>Pass No.:<input type="text" name="coach2pass" value="#coach2pass#" class="coachAutocomplete" tabindex="1"><br><br><cfif coach2 NEQ ""><a href="javascript:void(0);" class="coachClear">Clear</a></cfif><hr></div>
					<div class="line coach">Coach 3: <input type="text" name="coach3" value="#coach3#" class="coachAutocomplete" tabindex="3"><br>Pass No.:<input type="text" name="coach3pass" value="#coach3pass#" class="coachAutocomplete" tabindex="1"><br><br><cfif coach3 NEQ ""><a href="javascript:void(0);" class="coachClear">Clear</a></cfif><hr></div>
					<div class="line coach alt">Coach 4: <input type="text" name="coach4" value="#coach4#" class="coachAutocomplete" tabindex="4"><br>Pass No.:<input type="text" name="coach4pass" value="#coach4pass#" class="coachAutocomplete" tabindex="1"><br><br><cfif coach4 NEQ ""><a href="javascript:void(0);" class="coachClear">Clear</a></cfif><hr></div>
				</td>
			</tr>
			<tr>
				<th><div class="playup ">Are there any players playing up?   <input type="radio" name="playingUp" value="1" <cfif playingUp>checked="checked"</cfif>>Yes <input type="radio" name="playingUp" value="0" <cfif NOT playingUp>checked="checked"</cfif>>No </div></th>
			</tr>
			<tr>
				<td colspan="2">
					<div class="notice">
						 If you select "yes" for players playing up, you must insert each player's uniform number, name, pass number and team for such players.
					</div>
			<!--- 	<div class="notice">
					If you select "yes" for players playing up, you must insert each player's uniform number, name, pass number and team for such players.  If team is not listed, select other and type in team name in NCSA team format of club-flight-coach name.  In lieu of signatures on the Match Day Form, the person clicking 'Save and View/Print' below who is using the role of coach or club official to create this MDF, agrees as follows: All coaches and players participating in the game will have valid NCSA passes in the possession of a coach in attendance for the duration of the game; on behalf of all coaches listed, each coach participating in this game acknowledges reading, understanding and agreeing to all parts of the Code of Conduct and the Certification that goals are secured as set forth on the Match Day Form (click here to read full contents).
				</div> --->
				</td>
			</tr>
			
			<tr id="playUpRow" class="line">
				<td colspan="2">
					<!--- <strong>You must enter each player’s uniform number, name and pass number and select the team from which the player is playing up only as permitted by NCSA Rule 4.5.  If a team is not listed in the drop down section, a player is not able to play up from that non-listed team to this team for which the Match Day Form is being created.  The teams listed for eligible players playing up should be consistent with NCSA Rule 4.5.</strong><br /><br> --->
					<cfif isdefined("getPlayUps") AND getPlayUps.recordcount>
						<div class="playUpWrapper">
							<cfset other = "">
							<cfloop query="getPlayUps">
								<cfset playUpTeamID=getPlayUps.team_id>
								<div class="playUp">
									<div class="line alt">Uniform Number: <input type="Text" name="playUpUniformNumber#currentrow#" value="#getPlayUps.Uniform_Number#" style="width:30px;"> </div>   
									<div class="line">Name: <input type="Text" name="playUpName#currentrow#" value="#getPlayUps.name#"> </div> 
									<div class="line alt">Pass Number: <input type="text" name="playUpPass#currentrow#" value="#pass_number#" style="width:50px;"> </div> 
									<div class="line">Team:
									<select name="playUpTeam#currentrow#">
										<option value="">Select Team</option>
										<cfloop query="getPlayupteams">
									<!--- 		<cfif team_id EQ playUpTeamID>
												<cfset other = other_team>
											<cfelseif team_id neq 0> --->
												<option value="#team_id#" <cfif team_id EQ playUpTeamID>selected="selected"</cfif>>#teamname#</option>
											<!--- </cfif> --->
										</cfloop>
									
								<!--- 		<cfif len(trim(other))>
											<option value="0" selected="selected" >other</option>
											<input type="Text" name="PUOther#getPlayUps.currentrow#" value="#other#" style="margin-left:5px;width:22%;" class="other">
										<cfelse>
											<option value="0" >other</option>
											<input type="Text" name="PUOther#getPlayUps.currentrow#" value="" style="margin-left:5px;width:22%;" class="hidden other">
										</cfif> --->
									</select> </div>
									<!--- trigger to remove playup row --->
									<div class="line  alt"><a href="javascript:void(0);" class="playUpRemove">Remove</a> </div>
								</div>
							</cfloop>
						</div>
					<cfelse>
						<div class="playUpWrapper">
							<div class="playUp">
								<div class="line alt">Uniform Number: <input type="Text" name="playUpUniformNumber1" style="width:30px;"> </div> 
								<div class="line">Name: <input type="Text" name="playUpName1"> </div>
								<div class="line alt">Pass Number: <input type="text" name="playUpPass1" style="width:50px;"> </div> 
								<div class="line">Team:
								<select name="playUpTeam1">
									<option value="">Select Team</option>
									<cfloop query="getPlayupteams">
										<option value="#team_id#">#teamname#</option>
									</cfloop>
									<!--- <option value="0">Other</option><input type="Text" name="PUOther1" value=""class="hidden other"> --->
								</select> </div>
								<!--- trigger to remove playup row --->
								<div class="line alt"><a href="javascript:void(0);" class="playUpRemove">Remove</a></div>
							</div>
						</div>
					</cfif>
					
					<!--- trigger to add more playup rows --->
					<div class="line"><a href="javascript:void(0);" id="playUpAddTrigger" style="margin-left:5px;" >Add Another</a></div>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<div class="notice">
						 In lieu of signatures on the Match Day Form, the person clicking 'Save and View/Print' below who is using the role of coach or club official to create this MDF, agrees as follows: All coaches and players participating in the game will have valid NCSA passes in the possession of a coach in attendance for the duration of the game; on behalf of all coaches listed, each coach participating in this game acknowledges reading, understanding and agreeing to all parts of the Code of Conduct and the Certification that goals are secured as set forth on the Match Day Form (click <!--- Prod, change when we go live <a href="formsView.cfm?form_id=357"> ---><a href="formsView.cfm?form_id=68">here</a> to read full contents). 
					</div>
			<!--- 	<div class="notice">
					If you select "yes" for players playing up, you must insert each player's uniform number, name, pass number and team for such players.  If team is not listed, select other and type in team name in NCSA team format of club-flight-coach name.  In lieu of signatures on the Match Day Form, the person clicking 'Save and View/Print' below who is using the role of coach or club official to create this MDF, agrees as follows: All coaches and players participating in the game will have valid NCSA passes in the possession of a coach in attendance for the duration of the game; on behalf of all coaches listed, each coach participating in this game acknowledges reading, understanding and agreeing to all parts of the Code of Conduct and the Certification that goals are secured as set forth on the Match Day Form (click here to read full contents).
				</div> --->
				</td>
			</tr>
			<tr>
				<th>
					<div class="buttonBar">
						<input type="Submit" name="btnSave" value="Save &amp; View/Print">  <input type="Button" name="btnCancel" onclick="javascript:window.location='matchDayForm.cfm?team_id=#team_id#';" value="Cancel">
					</div>
				</th>
				<td>
				</td>
			</tr>
		</table>
		
	</form>

	<!--- This is the template that is duplicated when a user clicks the 'add another' trigger --->
	<div class="playUp playUptemplate" style="display:none;">
		<hr/>
		<div><div class="line alt">Uniform Number: <input type="Text" name="playUpUniformNumber"  style="width:30px;"></div>  
		<div class="line">Name: <input type="Text" name="playUpName"> </div>
		<div class="line alt">Pass Number: <input type="text" name="playUpPass" style="width:50px;"></div>
		<div class="line">Team:
		<select name="playUpTeam" >
			<option value="">Select Team</option>
			<cfloop query="getPlayupteams">
				<option value="#team_id#">#teamname#</option>
			</cfloop>	
			<!--- 		<option value="0">Other</option> --->
		</select><!--- <input type="Text" name="PUOther"  class="hidden other"></div> --->
		<!--- trigger to remove playup row --->
		<div class="line alt"><a href="javascript:void(0);" class="playUpRemove">Remove</a></div>
	</div>

</cfif>

</cfif>
</cfoutput>
</div>
<cfinclude template="_footer.cfm">

