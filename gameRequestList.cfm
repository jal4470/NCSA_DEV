<!--- 
	FileName:	gameRequestList.cfm
	Created on: 10/07/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
03/06/09 - aarnone - ticket:7309 - virtual team changes for state cup and non league games

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Game Change Request</H1>
<br>
<!--- <h2>yyyyyy </h2> --->

<cfset ClubId	= SESSION.USER.CLUBID>

<cfif isDefined("URL.TID")>
	<cfset selTeamID = URL.TID>
<cfelseif isDefined("FORM.TeamsList")>
	<cfset selTeamID = FORM.TeamsList>
<cfelseif isDefined("FORM.selTeamID")>
	<cfset selTeamID = FORM.selTeamID>
<cfelse>
	<cfset selTeamID = 0>
</cfif>

<cfif ClubId EQ 0 or ClubId EQ 1 or SESSION.MENUROLEID EQ 19>  <!--- (ucase(trim(Session("RoleCode"))) = "GAMESCHAIR") then --->
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#TEAM" method="getClubTeams" returnvariable="qTeams">
		<cfinvokeargument name="orderBy" value="TEAMNAME">
	</cfinvoke>
<cfelse>
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#TEAM" method="getClubTeams" returnvariable="qTeams">
		<cfinvokeargument name="clubID"	 value="#VARIABLES.ClubId#">
		<cfinvokeargument name="orderBy" value="TEAMNAME">
	</cfinvoke>
</cfif>

<FORM name="Games" action="GameRequestList.cfm "  method="post">
<input type="hidden" name="selTeamID" value="#VARIABLES.selTeamID#">
	<table cellspacing="0" cellpadding="5" align="left" border="0" width="99%">
		<TR><TD colspan="4">
				<b>Select a Team:</b> &nbsp; 
				<SELECT name="TeamsList"> 
					<OPTION value="" selected>Select Team</OPTION>
					<cfloop query="qTeams">
						<OPTION value="#TEAM_ID#" <cfif TEAM_ID EQ selTeamID>selected</cfif> >#TEAMNAMEderived#</OPTION>
					</cfloop>
				</SELECT>
				<input type="Submit" name="GO" value="Get Team's Games">
		    </TD>
		</TR>

		<CFIF selTeamID LT 1 >
			<tr class="tblHeading">
				<TD colspan="4">&nbsp;</TD>
			</tr>
		<CFELSE>
			<tr><TD colspan="4"> <span class="red">Click on a game to submit a Game Change Request</span> </TD>
			</tr>
			<tr class="tblHeading">
				<TD width="10%"><b>Game ##</b></TD>
				<TD width="20%"><b>Date/Time</b></TD>
				<TD width="35%"><b>Home Team</b></TD>
				<TD width="35%"><b>Visitor Team</b></TD>
			</tr>
			<cfinvoke component="#SESSION.SITEVARS.cfcPath#GAME" method="getGameSchedule" returnvariable="qGames">
				<cfinvokeargument name="teamID"	value="#VARIABLES.selTeamID#">
				<cfinvokeargument name="seasonID" value="#session.currentseason.id#">
			</cfinvoke>
			
			<CFIF qGames.RECORDCOUNT>
				<CFLOOP query="qGames">
					<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
						<TD class="tdUnderLine" align="center" >
							<a href="gameChangeREQedit.cfm?gid=#GAME_ID#&tid=#VARIABLES.selTeamID#">
								#GAME_ID#
							</a>
							<span class="red">
								<cfswitch expression="#ucase(game_Type)#">
									<cfcase value="N">NL </cfcase>
									<cfcase value="C">SC </cfcase>
									<cfcase value="F">FR </cfcase>
									<cfdefaultcase>&nbsp;</cfdefaultcase>
								</cfswitch>
							</span>
						</TD>
						<TD class="tdUnderLine" >
							<a href="gameChangeREQedit.cfm?gid=#GAME_ID#&tid=#VARIABLES.selTeamID#">
								#DATEFORMAT(GAME_DATE,"mm/dd/yy")# @ #TimeFormat(GAME_TIME,"hh:mm tt")#
							</a>
						</TD>
						<TD class="tdUnderLine" >
								<CFIF HOME_TEAM_ID EQ selTeamID>
									<b>#HOME_TeamName#</b>
								<cfelse>
									#HOME_TeamName#
								</CFIF> 
						</TD>
						<TD class="tdUnderLine" >
								<!--- <CFIF VISITOR_TEAM_ID EQ selTeamID>
									<b>#Visitor_TeamName#</b>
								<cfelse>
									#Visitor_TeamName#
								</CFIF> --->
							<CFIF len(trim(Visitor_TeamName))>
								#Visitor_TeamName#
							<CFELSEIF len(trim(Virtual_TeamName))>
								#Virtual_TeamName#
							<CFELSE>
								&nbsp;
							</CFIF>
						</TD>
					</TR>
				</CFLOOP>
			<CFELSE>
				<tr><TD colspan="4"><span class="red"><b>There are no games scheduled for this team.</b></span></TD></tr>
			</CFIF>

		</CFIF>

	</table>	
</FORM>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">
