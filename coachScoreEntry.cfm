<!--- 
	FileName:	coachScoreEntry.cfm
	Created on: 2/121/2011
	Created by: bcooper@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

05/22/2017 - apinzone - removed jquery 1.4.2, moved javascript to bottom of page and wrapped in cfsavecontent

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
	<CFQUERY name="getFines" datasource="#SESSION.DSN#">
		Select FINETYPE_ID as id, Amount from TLKP_Fine_Type Where FINETYPE_ID in (1, 2)
	</CFQUERY>
	<CFLOOP query="getFines">
		<CFSWITCH expression="#ID#">
			<cfcase value="1"> <cfset ForfeitFineAmt = Amount> </cfcase> 
			<cfcase value="2"> <cfset DelayedEntryFineAmt = Amount> </cfcase> 
		</CFSWITCH>
	</CFLOOP>
	
	<cfset delEntryHome="N">
	<cfset delEntryVisitor="N">
	<cfif form.delayed EQ "1">
		<cfif isdefined("form.delayedHome")>
			<cfset delEntryHome="Y">
		</cfif>
		<cfif isdefined("form.delayedVisitor")>
			<cfset delEntryVisitor="Y">
		</cfif>
	</cfif>
	
	<cfset refNoShow="N">
	<cfif isdefined("form.refNoShow") AND form.refNoShow EQ "1">
		<cfset refNoShow="Y">
	</cfif>
	
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#game" method="updateGameScore">
		<cfinvokeargument name="GameID"		 value="#form.game_id#">
		<cfinvokeargument name="ScoreHOME"	  value="#form.txtHomeScore#">
		<cfinvokeargument name="ScoreVISITOR" value="#form.txtVisitorScore#">
		<cfinvokeargument name="ForfeitHOME"  value="">
		<cfinvokeargument name="ForfeitVISITOR"	value="">
		<cfinvokeargument name="DelEntryHome"	value="#VARIABLES.delEntryHome#">
		<cfinvokeargument name="DelEntryVisitor" value="#VARIABLES.delEntryVisitor#">
		<cfinvokeargument name="RefNoShow"		value="#VARIABLES.refNoShow#">
		<cfinvokeargument name="contactID"  value="#SESSION.USER.CONTACTID#"> 
		<cfinvokeargument name="gameNotes" value="#form.additionalInfo#">
	</cfinvoke>
	
	<cflocation url="matchEvaluation.cfm?team_id=#form.team_id#&game_id=#form.game_id#" addtoken="No">
</CFIF>


<cfif team_id EQ "">
	<!--- get teams for user logged in --->
	<cfif session.menuroleid EQ "1">
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
		select game_id, game_datetime, score_home, score_visitor, game_code, field_Id, field, visitor_teamname, home_teamname 
		from v_games_all
		where 
		(visitor=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#team_id#"> or home=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#team_id#">)
		and datediff(mi, game_datetime, getdate()) > 0 -- game in past
		--and datediff(mi, game_datetime, getdate()) < 1440 -- game less than 24 hrs ago
		--and score_home is null and score_visitor is null
		order by game_datetime asc
	</cfquery>
</cfif>

<cfsavecontent variable="cfhtmlhead_sce">
<style>
	th.unbold { font-weight: normal; }
</style>
</cfsavecontent>
<cfhtmlhead text="#cfhtmlhead_sce#">



<div id="contentText">
<H1 class="pageheading">NCSA - Score Entry</H1>
<br> <!--- <h2>yyyyyy </h2> --->

<cfif not isdefined("game_id")>
	<cfif team_id EQ "">
	<FORM action="coachScoreEntry.cfm" method="post">
		
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
	<cfif isdefined("qGetGames")>
		<div class="notice">
			A coach may submit a score only for games for which a score has not been submitted by any team/coach 
			and only within 24 hours of game time.  Only those games which have already been played (date and time has passed) 
			will be displayed.
		</div>
	</cfif>
	<CFIF isDefined("qGetGames") AND qGetGames.RECORDCOUNT >
		<table class="table1" cellpadding="3" cellspacing="0" border="0">
			<thead>
			<tr>
				<th>Game Number</th>
				<th>Game Time</th>
				<th>Home Team</th>
				<th>Visiting Team</th>
				<th style="text-align:center;">Home Score</th>
				<th style="text-align:center;">Visitor Score</th>
			</TR>
			</thead>
			<tbody>
			<cfloop query="qGetGames">
				<tr>
					<td><a href="coachScoreEntry.cfm?team_id=#team_id#&game_id=#game_id#">#game_id#</a><cfif session.menuroleid EQ "1" OR (datediff("n",game_datetime,now()) LT 1440 AND score_home EQ "" AND score_visitor EQ "")><a href="coachScoreEntry.cfm?team_id=#team_id#&game_id=#game_id#">#game_id#</a><cfelse>#game_id#</cfif></td>
					<td>#dateformat(game_datetime, "m/d/yyyy")# #timeformat(game_datetime,"h:mm tt")#</td>
					<td>#home_teamname#</td>
					<td>#visitor_teamname#</td>
					<td style="text-align:center;">#score_home#</td>
					<td style="text-align:center;">#score_visitor#</td>
				</tr>
			</cfloop>
			</tbody>
		</TABLE>
	</CFIF>
<cfelse>
	<form action="coachScoreEntry.cfm" method="post">
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
				<th>Home Score (#getGame.home_teamname#)</th>
				<td><input type="Text" name="txtHomeScore" maxlength="2"></td>
			</tr>
			<tr>
				<th>Visitor Score (#getGame.visitor_teamname#)</th>
				<td><input type="text" name="txtVisitorScore" maxlength="2"></td>
			</tr>
			<tr>
				<th class="unbold"><!---Did one team not appear for the game with minimum number of players within 15 minutes of game time?<br>(If yes, check which team was late.)--->Was one team <strong><u>late</u></strong> (did not have minimum number of players within 15 minutes of game time)?
(If yes, check which team was late.)</th>
				<td>
					Yes<input type="Radio" name="Delayed" value="1"> No<input type="Radio" name="Delayed" value="0" checked="checked">
					<div id="delayDetail" style="visibility:hidden;">
					<input type="Checkbox" name="delayedHome" value="1">#getGame.home_teamname#
					<br>
					<input type="Checkbox" name="delayedVisitor" value="1">#getGame.visitor_teamname#
					</div>
				</td>
			</tr>
			<tr>
				<th class="unbold"><!---Did one or more officials not appear for the game?--->Was one or more of the assigned officials as listed on the Match Day Form <strong><u>NOT</u></strong> present at the field for the game?</th>
				<td>
					Yes<input type="Radio" name="refNoShow" value="1"> No<input type="Radio" name="refNoShow" value="0" checked="checked">
				</td>
			</tr>
			<tr>
				<th>Additional Info</th>
				<td>
					<div class="notice">
						Include here a SHORT message if necessary for your division commissioner -- use Match Evaluation and Referee Evaluation form for complete Match Evaluation.
					</div>
					<textarea name="additionalInfo" style="width:100%; height:95px;"></textarea>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<div class="notice">
						A score may be submitted only once -- you may not edit it later so be certain it is correctly listed above
						 -- if you need to report a change after submission, please email your division commissioner.
						 <br><br>Please also complete a Match Evaluation and Referee Evaluation form.
					</div>
				</td>
			</tr>
			<tr>
				<th>
					<input type="Button" name="btnCancel" onclick="javascript:history.go(-1);" value="Cancel"><input type="Submit" name="btnSave" value="Save">
				</th>
				<td>
				</td>
			</tr>
		</table>
		
	</form>
</cfif>

</cfoutput>
</div>

<cfsavecontent variable="cf_footer_scripts">
	<script language="JavaScript" type="text/javascript" src="assets/jquery-ui-1.12.1.min.js"></script>
	<script language="JavaScript" type="text/javascript" src="assets/jquery.maxlength-min.js"></script>
	<script language="JavaScript" type="text/javascript">
		$(function(){
		
			//trigger show/hide of team checkboxes for delayed arrival
			$('input[name=Delayed]').click(showHideDelay);
			
			//attach maxlength plugin to additional info textarea
			$('textarea[name=additionalInfo]').maxlength({
				maxCharacters:250,
				status:true,
				slider:true
			});
		
			//initially run show/hide delay
			showHideDelay();
		});
		/*
		* show/hide team checkboxes for delayed arrival
		* checks the value of checked radio button to determine if to show or hide elements
		*/
		function showHideDelay(){
			if($('input[name=Delayed]:checked').val() == '1')
				$('#delayDetail').css('visibility','visible');
			else
				$('#delayDetail').css('visibility','hidden');
		}
	</script>
</cfsavecontent>

<cfinclude template="_footer.cfm">
