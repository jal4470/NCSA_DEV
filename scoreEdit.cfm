<!--- 
	FileName:	ScoreEdit.cfm
	Created on: 09/29/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
5/26/2010 B. Cooper
9292-limit list to current season

05/25/2017 A. Pinzone - added missing </form> tag
07/18/2017 J. LECHUGA - Modified fines logic to record fine correctly regardless of score entered
08/29/2017 R. Gonzalez - Replaced form post with AJAX calls
											 - Refactored the form processing section to support a single game at a time
											 - Changed data table to divs
											 - Added unsaved change check to alert user if changes are pending before they leave the page
08/30/2017 A. Pinzone  - Replaced old table classes with new css classes for table-like structure. 
											 - Reformatted table header to be more readable.
08/07/2018 R. Gonzalez - Removed RNS from table
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_checkLogin.cfm">
<cfoutput>

<CFSET listOfRolesEdit = "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,31">
<CFIF listFind(listOfRolesEdit, SESSION.menuRoleID) GT 0>
	<CFSET swEditGame = true>
<CFELSE>
	<CFSET swEditGame = false>
</CFIF>

<CFIF isDefined("FORM.clubID")>
	<CFSET clubID = FORM.clubID>
<CFELSE>
	<CFSET clubID = 0>
</CFIF>
<CFIF isDefined("FORM.selDiv")>
	<CFSET selDiv = FORM.selDiv>
<CFELSE>
	<CFSET selDiv = "">
</CFIF>

<CFIF isDefined("FORM.WeekendList")> 
	<CFSET selWeekEnd = FORM.WeekendList>
<CFELSE>
	<CFSET selWeekEnd = "">
</CFIF>

<cfset swGetGames = false> 


<CFIF isDefined("FORM.SAVE")>
<!--- 	<CFQUERY name="getFines" datasource="#SESSION.DSN#">
		Select FINETYPE_ID as id, Amount from TLKP_Fine_Type Where FINETYPE_ID in (1, 2)
	</CFQUERY>
	<CFLOOP query="getFines">
		<CFSWITCH expression="#ID#">
			<cfcase value="1"> <cfset ForfeitFineAmt = Amount> </cfcase> 
			<cfcase value="2"> <cfset DelayedEntryFineAmt = Amount> </cfcase> 
		</CFSWITCH>
	</CFLOOP> --->

	<!--- Initialize return object --->
	<cfset data = {}> 

 	<cftry>
		<!--- Parse Form Values If Exists --->
		<CFIF isDefined("FORM.GameID") and len(trim(form.GameID))> 
			<CFSET gid = FORM.GameID>
		<CFELSE>
			<!--- Return Error Response --->
		</CFIF>

		<!--- <CFLOOP list="#FORM.GAMELIST#" index="gid"> ---> <!--- loop each game id shown --->
			<!--- reset values for next game --->
			<cfset pGameID = gid>
			<cfset pHscore = "">
			<cfset pVscore = "">
			<cfset pHprevScore = "">
			<cfset pVprevScore = "">
			<cfset pHdelayed = "">
			<cfset pVdelayed = "">
			<cfset pRNS = "">
			<cfset pHforfeit = "">
			<cfset pVforfeit = "">
			<cfset pHteamID = 0>
			<cfset pVteamID = 0>

			<cfloop collection="#FORM#" item="iff"> <!--- look for the values for current game id --->
				<cfif listLen(iff,"_") GT 1 AND listLast(iff,"_") EQ pGameID>

					<cfswitch expression="#UCASE(listFirst(iff,"_"))#">
						<cfcase value="HOMETEAMID">			<cfset pHteamID    = trim(FORM[iff]) >	</cfcase>
						<cfcase value="VISITORTEAMID">		<cfset pVteamID	   = trim(FORM[iff]) >	</cfcase>
						<cfcase value="PRVHOMESCORE">		<cfset pHprevScore = trim(FORM[iff]) >	</cfcase>
						<cfcase value="PRVVISITORSCORE">	<cfset pVprevScore = trim(FORM[iff]) >	</cfcase>
						<cfcase value="HOMESCORE">			<cfset pHscore	   = trim(FORM[iff]) >	</cfcase>
						<cfcase value="VISITORSCORE">		<cfset pVscore	   = trim(FORM[iff]) >	</cfcase>
						<cfcase value="DELAYEDHOME">		<cfset pHdelayed   = "Y">	</cfcase>
						<cfcase value="DELAYEDVISITOR">		<cfset pVdelayed   = "Y">	</cfcase>
						<!--- <cfcase value="REFNOSHOW">			<cfset pRNS	       = "Y">	</cfcase> --->
						<cfcase value="HOMEFORFEIT">		<cfset pHforfeit   = "Y">	</cfcase>
						<cfcase value="VISITORFORFEIT">		<cfset pVforfeit   = "Y"> </cfcase>
					</cfswitch> 
				</cfif>
			</cfloop>


			<!--- We have the values for the specific game --->
			<CFIF pHforfeit EQ "Y">
				<cfset pVforfeit = "N">
			</CFIF>
			<CFIF pVforfeit EQ "Y">
				<cfset pHforfeit = "N">
			</CFIF>
			
			<cfif ((pVscore eq "" ) or (pHscore eq "") ) >
				<!--- When current values for the score are null, means reverse entries into the Statistics --->
				<cfif (len(trim(pHprevScore)) and len(trim(pVprevScore)) )>
					<cfinvoke component="#SESSION.SITEVARS.cfcPath#game" method="updateGameScore">
						<cfinvokeargument name="GameID"		 value="#VARIABLES.pGameID#">
						<cfinvokeargument name="ScoreVISITOR" value="">
						<cfinvokeargument name="ScoreHOME"	  value="">
						<cfinvokeargument name="ForfeitHOME"  value="#VARIABLES.pHforfeit#">
						<cfinvokeargument name="ForfeitVISITOR"	value="#VARIABLES.pVforfeit#">
						<cfinvokeargument name="DelEntryHome"	value="#VARIABLES.pHdelayed#">
						<cfinvokeargument name="DelEntryVisitor" value="#VARIABLES.pVdelayed#">
						<cfinvokeargument name="RefNoShow"		value="#VARIABLES.pRNS#">
						<cfinvokeargument name="contactID"  value="#SESSION.USER.CONTACTID#"> 
					</cfinvoke>
				</cfif>
			<cfelse>
				<cfinvoke component="#SESSION.SITEVARS.cfcPath#game" method="updateGameScore">
					<cfinvokeargument name="GameID"		 value="#VARIABLES.pGameID#">
					<cfinvokeargument name="ScoreVISITOR" value="#VARIABLES.pVscore#">
					<cfinvokeargument name="ScoreHOME"	  value="#VARIABLES.pHscore#">
					<cfinvokeargument name="ForfeitHOME"  value="#VARIABLES.pHforfeit#">
					<cfinvokeargument name="ForfeitVISITOR"	value="#VARIABLES.pVforfeit#">
					<cfinvokeargument name="DelEntryHome"	value="#VARIABLES.pHdelayed#">
					<cfinvokeargument name="DelEntryVisitor" value="#VARIABLES.pVdelayed#">
					<cfinvokeargument name="RefNoShow"		value="#VARIABLES.pRNS#">
					<cfinvokeargument name="contactID"  value="#SESSION.USER.CONTACTID#"> 
				</cfinvoke>
				<!--- Apply a Fine when the score was submitted late or the game was forfeited --->
				<!--- <cfif pHprevScore eq "" >	Fines can only be added the first time the score for the game was entered --->
					<cfif (pHforfeit eq "Y" or pVforfeit eq "Y" or pHdelayed eq "Y" or pVdelayed eq "Y")>
						<cfset Status = "">
						<cfset Comments = "AutoGenerated Fine from Game Score Entry, by " & SESSION.USER.UNAME & " on " & dateFormat(now(),"mm/dd/yy") & ".">
						<!---  It is possible that the game was forfeit AND was also reported late. 
								In Such case, two fines will be issued. loop for each fine 
						--->

						<CFLOOP from="1" to="2" index="Idx">
							<CFSET GenerateFineEntry = "">
							<cfif Idx EQ 1 and (pHforfeit EQ "Y" or pVforfeit EQ "Y")>
								<cfset GenerateFineEntry = "Y" >
								<cfset FineType = 1>
								<!--- <cfset Amount = ForfeitFineAmt > --->
								<cfif pHforfeit	EQ "Y" >
									<cfset TeamFined = pHteamID>
								</cfif>
								<cfif pVforfeit EQ "Y">
									<cfset TeamFined = pVteamID> 
								</cfif>
							</cfif> 
		
							<cfif Idx EQ 2 and (pHdelayed EQ "Y" or pVdelayed EQ "Y")>
								<cfset GenerateFineEntry = "Y">
								<cfset FineType = 2>
								<!--- <cfset Amount	= DelayedEntryFineAmt> --->
								<cfif pHdelayed	eq "Y">
									<cfset TeamFined = pHteamID>
								</cfif> 
								<cfif pVdelayed	eq "Y">
									<cfset TeamFined = pVteamID>
								</cfif>
							</cfif>
							
							<cfif GenerateFineEntry eq "Y">
								<!--- <cfif len(trim(Amount)) EQ 0>
									<cfset Amount = 0 >
								</cfif> --->
		
								<cfinvoke component="#SESSION.SITEVARS.cfcPath#TEAM" method="getTeamInfo" returnvariable="qTeamInfo">
									<cfinvokeargument name="TeamID" value="#TeamFined#">
								</cfinvoke>

								<CFIF qTeamInfo.RECORDCOUNT>
									<CFSET ClubFined		= qTeamInfo.CLUB_ID >
									<CFSET ClubFinedName	= qTeamInfo.CLUB_NAME >
									<CFSET TeamFinedName	= qTeamInfo.TEAMNAME >
									<CFSET TeamFinedID		= qTeamInfo.TEAM_ID >
								<CFELSE>
									<CFSET ClubFined		= "">
									<CFSET ClubFinedName	= "">
									<CFSET TeamFinedName	= "">
								</CFIF>
								<cfinvoke component="#SESSION.SITEVARS.cfcPath#FINEFEES" method="insertFine">
									<cfinvokeargument name="SeasonID" 	 value="#SESSION.CURRENTSEASON.ID#">
									<cfinvokeargument name="gameID"  value="#VARIABLES.pGameID#"> 
									<cfinvokeargument name="clubID"  value="#VARIABLES.ClubFined#"> 
									<cfinvokeargument name="TeamID"  value="#VARIABLES.TeamFined#"> 
									<cfinvokeargument name="fineTypeID"  value="#VARIABLES.FineType#"> 
									<cfinvokeargument name="Status"  value="#VARIABLES.Status#"> 
									<cfinvokeargument name="Comments"  value="#VARIABLES.Comments#"> 
									<cfinvokeargument name="contactID"  value="#SESSION.USER.CONTACTID#"> 
								</cfinvoke>
							</cfif> <!--- END -if GenerateFineEntry eq "Y" --->
						</CFLOOP>	
					</cfif> <!--- END - if (pHforfeit eq "Y" or pVforfeit eq "Y" or pHdelayed eq "Y" or pVdelayed eq "Y") --->
				<!--- </cfif> END - if pHprevScore eq "" --->
			</cfif>	 <!--- END - if ((pVscore eq "" ) or (pHscore eq "") ) --->
		<!--- </CFLOOP> --->
		<cfset swGetGames = TRUE>

		<cfset data.status = "success">
		<cfset data.message = "Record saved successfully.">
	<cfcatch>
		<cfset data.status = "failure">
		<cfset data.message = cfcatch.message>
	</cfcatch>
	</cftry>

	<!--- Create JSON Response --->
	<cfset json_response = serializeJSON(data)>

	<!--- Output JSON Response --->
	#json_response#

	<cfabort>
</CFIF>



<cfif isdefined("FORM.getGames") or swGetGames>
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#globalVars" method="getListX" returnvariable="gameType">
		<cfinvokeargument name="listType" value="GAMETYPE">
	</cfinvoke>	

	<CFIF FORM.CLUBSLIST EQ "ALL">
		<CFSET getClub = 0>
	<CFELSE>
		<CFSET getClub = FORM.CLUBSLIST>
	</CFIF>
	<CFIF FORM.DIVISIONLIST EQ "ALL">
		<CFSET getDiv = "">
	<CFELSE>
		<CFSET getDiv = FORM.DIVISIONLIST>
	</CFIF>  
	<CFIF FORM.WEEKENDLIST EQ "ALL">
		<CFSET getWE = 0>
	<CFELSE>
		<CFSET getWE = FORM.WEEKENDLIST>
	</CFIF>  
	<cfinvoke component="#SESSION.sitevars.cfcPath#game" method="getGameSchedule" returnvariable="qGames">
	 	<cfinvokeargument name="clubID"   value="#VARIABLES.getClub#">
		<cfinvokeargument name="division" value="#VARIABLES.getDiv#">
		<cfinvokeargument name="fromDate" value="#VARIABLES.getWE#">
		<cfinvokeargument name="toDate"   value="#VARIABLES.getWE#">
		<cfinvokeargument name="seasonID" value="#session.currentseason.id#">
	</cfinvoke> 
	<!--- this QoQ gets games which have no scores 
	<CFQUERY name="qGames" dbtype="query">
		SELECT  game_id, game_code, game_date, game_time, game_type, division_id, Division, 
				FIELD_ID, fieldName, fieldAbbr, 
				Visitor_Team_ID, Visitor_TeamName, Visitor_TeamName_null, Score_visitor, DelayedEntry_Visitor, Forfeit_Visitor,
		        Home_Team_ID,	 Home_TeamName,	   Home_TeamName_null,	  Score_Home,	 DelayedEntry_Home,    Forfeit_Home,
			    RefID, refReportSbm_YN, refNoShow, comments, gamesChairComments 
		  FROM qGames
		 WHERE Score_home is NULL 
		   AND Score_visitor is NULL 
	</CFQUERY> --->
</cfif>	

<cfinclude template="_header.cfm">

<div id="contentText">
<H1 class="pageheading">NCSA - Game Edit</H1>
<br> <!--- <h2>yyyyyy </h2> --->
<FORM name="gamelist" action="scoreEdit.cfm" method="post" id="formgamelist">
	<input type="Hidden" name="clubID" 		value="#variables.clubID#">
	<input type="Hidden" name="selDiv" 		value="#variables.selDiv#">
	<input type="Hidden" name="selWeekEnd" 	value="#variables.selWeekEnd#">
	
<table cellspacing="0" cellpadding="2" align="center" border="0" width="99%">
<tr><td colspan="14">
		<!--- Selection by the CLUB ------------------ --->
		<cfinvoke component="#SESSION.SITEVARS.cfcPath#club" method="getClubInfo" returnvariable="qClubs">
			<cfinvokeargument name="orderBy" value="clubname">
		</cfinvoke>	
		<SELECT name="ClubsList" onchange="GetClubs()" ID="Select1">  
			<OPTION value="ALL" <cfif clubID EQ "ALL" >selected</cfif> >Show ALL Clubs</OPTION>
			<CFLOOP query="qClubs"><OPTION value="#Club_ID#" <cfif clubID EQ CLUB_ID>selected</cfif> >#Club_Name#</OPTION></CFLOOP>
		</SELECT>
		<!--- Selection by the Division -------------------- --->
		<cfinvoke component="#SESSION.SITEVARS.cfcPath#game" method="getGameDivisions" returnvariable="qGameDivs">
			<cfinvokeargument name="clubID" value="#VARIABLES.clubID#">
		</cfinvoke>	
		<SELECT name="DivisionList" onchange="GetDiv()" ID="Select2">  
			<OPTION value="ALL" <cfif selDiv EQ "ALL">selected</cfif> >Show ALL Divisions</OPTION>
			<CFLOOP query="qGameDivs"><OPTION value="#Division#" <cfif selDiv EQ Division >selected</cfif> >#Division#</OPTION></CFLOOP>
		</SELECT>
		&nbsp; 
		<CFIF selDiv EQ 0>
			<CFSET invokeDiv = "">
		<CFELSEIF selDiv EQ "ALL">
			<CFSET invokeDiv = "">
		<CFELSE>
			<CFSET invokeDiv = selDiv >
		</CFIF>
		<!--- Selection by the Weekend --------------------- --->
		<cfinvoke component="#SESSION.SITEVARS.cfcPath#game" method="getGameDates" returnvariable="gGameDates">
			<cfinvokeargument name="division" value="#invokeDiv#">
			<cfinvokeargument name="seasonID" value="#session.currentseason.id#">
		</cfinvoke> 
		<SELECT name="WeekendList"> 
			<OPTION value="ALL" <CFIF selWeekEnd EQ "ALL">selected</CFIF> >Show ALL Weekends</OPTION>
			<CFLOOP query="gGameDates"><CFSET showDate = dateFormat(Game_Date,'mm/dd/yyyy')>
				<OPTION value="#showDate#" <CFIF selWeekEnd EQ showDate>selected</CFIF> > #showDate# </OPTION>
			</CFLOOP>
		</SELECT>
	
		<INPUT type="submit" name="getGames" value="Get Games">
	</td> 
</tr> 
</TABLE>
</FORM>
	
<CFIF isDefined("qGames") AND qGames.RECORDCOUNT >
		<table cellspacing="0" cellpadding="2" align="center" border="0" width="99%">
		<tr><td colspan="14">
				<span class="red">
				<ul><li>For forfeited games (FFT), click checkbox against the team which forfeited <b>(FFT)</b></li>
					<li>Click on the checkbox against the score, if the scores are posted past due date by Home Team <b>(H)</b></li>
					<li>Click on the checkbox against the score, if the scores are posted past due date by Visitor Team <b>(V)</b></li>
					<li>Click to specify Referee No-show <b>(RNS)</b></li>
					<cfif swEditGame>
						<li>Game## in red indicates referee report exists. Click to display the report</li>
					</cfif>
					<li>ALL CHANGES TO EACH GAME MUST BE SAVED FOR EACH GAME.  WHEN THE "SAVE" SYMBOL APPEARS IN THE RIGHT MARGIN, CLICK IT TO SAVE - A <span style="color:green;">GREEN</span> CHECK MARK WILL APPEAR TO CONFIRM THE SAVE.</li>
				</span>
			</td>
		</tr>

		</table>
		<cfset divHold = qGames.DIVISION >

<!--- Restructure using DIVs --->
<div class="table-container">

	<div class="cssRow">
		<div class="cssCellHead noBackground" style="width:235px;">&nbsp;</div>
		<div class="cssCellHead cssCellHeadGroup" style="width:211.5px;">Home Team</div>
		<div class="cssCellHead cssCellHeadGroup" style="width:211.5px;">Visiting Team</div>
		<div class="cssCellHead cssCellHeadGroup" style="width:70px;">Scores</div>
		<div class="cssCellHead cssCellHeadGroup" style="width:60px;">Delayed</div>
		<div class="cssCellHead noBackground" style="width:60px;">&nbsp;</div>
	</div><!--- cssRow --->

	<div class="cssRow">
		<div class="cssCellHead" style="width:90px;">Date/Time</div>
		<div class="cssCellHead" style="width:45px;">Type</div>
		<div class="cssCellHead" style="width:50px;">Game</div>
		<div class="cssCellHead" style="width:50px;">Div</div>
		<div class="cssCellHead" style="width:30px;">FFT</div>
		<div class="cssCellHead" style="width:181.5px;">Name</div>
		<div class="cssCellHead" style="width:30px;">FFT</div>
		<div class="cssCellHead" style="width:181.5px;">Name</div>
		<div class="cssCellHead" style="width:35px;">Home</div>
		<div class="cssCellHead" style="width:35px;">Vstr</div>
		<div class="cssCellHead" style="width:30px;">(H)</div>
		<div class="cssCellHead" style="width:30px;">(V)</div>
		<!--- <div class="cssCellHead" style="width:30px;">RNS</div> --->
		<div class="cssCellHead" style="width:30px;">&nbsp;</div>
	</div><!--- cssRow --->


	<cfloop query="qGames">
		<FORM name="game_#GAME_ID#" action="scoreEdit.cfm" method="post" id="game_#GAME_ID#" class="game_form">
<!--- 			<CFIF divHold NEQ DIVISION >
				<div background-color="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
					<div class="tdUnderLine" style="display:inline;">&nbsp; </div>
				</div>
				<cfset divHold = DIVISION >
			</CFIF> --->

			<div id="div_game_#GAME_ID#" class="game_record cssRow" background-color="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
				
				<!--- Date/Time --->
				<div class="cssCell" style="width:90px;"> 
					<input type="hidden" name="PrvHomeScore_#GAME_ID#"		value="#Score_Home#" >
					<input type="hidden" name="PrvVisitorScore_#GAME_ID#"	value="#Score_visitor#" >
					<input type="hidden" name="HomeTeamId_#GAME_ID#"		value="#Home_Team_ID#" >
					<input type="hidden" name="VisitorTeamID_#GAME_ID#"		value="#Visitor_Team_ID#" >
					<input type="hidden" name="Save" value="Save" >
					<input type="hidden" name="GameID" value="#GAME_ID#" >

						#UCASE(DATEFORMAT(GAME_DATE,"ddd"))# #DATEFORMAT(GAME_DATE,"mm/dd/yy")# 
						<br>#TIMEFORMAT(GAME_TIME,"hh:mm tt")# 

				</div>

				<!--- Type --->
				<div class="cssCell" style="width:45px;"> 
						<cfswitch expression="#game_type#">
							<cfcase value="F">Friendly</cfcase>
							<cfcase value="C">State Cup</cfcase>
							<cfcase value="P">Playoff</cfcase>
							<cfcase value="N">Non League</cfcase>
							<cfdefaultcase>&nbsp;</cfdefaultcase>
						</cfswitch>
				</div>

				<!--- Game ID --->
				<div class="cssCell" style="width:50px;"> 
					<CFIF swEditGame AND refReportSbm_YN EQ "Y">
						<a href="gameRefReportPrint.cfm?gid=#GAME_ID#" target="_blank"><span class="red">#Game_ID#</span></a> <!--- gameRefRpt.cfm?gid=#GAME_ID# --->
					<CFELSE>	
						#Game_ID#	
					</CFIF>
				</div>

				<!--- Division --->
				<div class="cssCell" style="width:50px;"> 
					#DIVISION#				
				</div>

				<!--- Forfeit Checkbox // Home Team --->
				<div class="cssCell" style="width:30px;text-align:center;">
					<input type="checkbox" maxlength="1" name="HomeForfeit_#GAME_ID#" id="HomeForfeit_#GAME_ID#" <cfif Forfeit_Home EQ "Y">checked</cfif> size=1  onclick="ValidateForfeit('HomeForfeit_#GAME_ID#','VisitorForfeit_#GAME_ID#','HomeScore_#GAME_ID#','VisitorScore_#GAME_ID#')"   >
				</div>

				<!--- Home Team Name --->
				<div class="cssCell" style="width:181.5px;"> 
					<cfif len(trim(HOME_TEAMNAME))>   #HOME_TEAMNAME#   <CFELSE>#HOME_TEAMNAME_NULL#   </cfif>
				</div>

				<!--- Forfeit Checkbox // Visitor Team --->
				<div class="cssCell" style="width:30px;text-align:center;">
					<input type="checkbox" maxlength="1" name="VisitorForfeit_#GAME_ID#" id="VisitorForfeit_#GAME_ID#" <cfif Forfeit_Visitor EQ "Y">checked</cfif> size=1 onclick="ValidateForfeit('VisitorForfeit_#GAME_ID#','HomeForfeit_#GAME_ID#','VisitorScore_#GAME_ID#','HomeScore_#GAME_ID#')">
				</div>

				<!--- Visitor Team Name --->
				<div class="cssCell" style="width:181.5px;"> 
					<cfif len(trim(VISITOR_TEAMNAME))>#VISITOR_TEAMNAME#<CFELSE>#VISITOR_TEAMNAME_NULL#</cfif>
				</div>

				<!--- Home Score --->
				<div class="cssCell" style="width:35px;text-align:center;">
					<input maxlength="2" name="HomeScore_#GAME_ID#"  id="HomeScore_#GAME_ID#" value="#Score_home#" style="WIDTH:24px; HEIGHT: 18px"  size=2 >
				</div>

				<!--- Visitor Score --->
				<div class="cssCell" style="width:35px;text-align:center;">
					<input maxlength="2" name="VisitorScore_#GAME_ID#" id="VisitorScore_#GAME_ID#" value="#Score_visitor#" style="WIDTH: 24px; HEIGHT: 18px" size=2 >
				</div>

				<!--- Delayed Home --->
				<div class="cssCell" style="width:30px;text-align:center;">
					<input type="checkbox" maxlength="1" name="DelayedHome_#GAME_ID#"  <cfif DelayedEntry_Home	   EQ "Y">checked</cfif>		size=1>
				</div>

				<!--- Delayed Visitor --->
				<div class="cssCell" style="width:30px;text-align:center;">
					<input type="checkbox" maxlength="1" name="DelayedVisitor_#GAME_ID#" <cfif DelayedEntry_Visitor EQ "Y">checked</cfif>   size=1>
				</div>

				<!--- Ref No Show --->
				<!--- <div class="cssCell" style="width:30px;text-align:center;">
					<input type="checkbox" maxlength="1" name="RefNoShow_#GAME_ID#" <cfif RefNoShow	EQ "Y">checked</cfif> size=1>
				</div> --->

				<!--- Save Action --->
				<div class="cssCell" style="width:30px;text-align:center;">
					<span class="save_button" id="save_game_#GAME_ID#">
						<i id="icon_game_#GAME_ID#" class="fa fa-floppy-o" aria-hidden="true"></i>
					</span>
				</div>
			</div>
		</FORM>
	</cfloop>
</CFIF>
</div><!--- table-container--->
<!--- </TABLE>
</FORM> --->
	

<script language="javascript">
function GetClubs()
{	self.document.gamelist.clubID.value =	self.document.gamelist.ClubsList.value;
	self.document.gamelist.action = "scoreEdit.cfm";
	self.document.gamelist.submit();
}
function GetDiv()
{	self.document.gamelist.selDiv.value =	self.document.gamelist.DivisionList.value;
	self.document.gamelist.action = "scoreEdit.cfm";
	self.document.gamelist.submit();
}

//function GetDiv(DivSel)
//{	//self.document.gamelist.selDiv.value =	self.document.gamelist.DivisionList.value;
//	self.document.gamelist.selDiv.value = document.getElementById(DivSel).value;
//	self.document.gamelist.action = "scoreEdit.cfm";
//	self.document.gamelist.submit();
//}

function ValidateForfeit(isFor,NOTfor,scoreZero,scoreONE)
{	// FOR HOME Forfeit ('HomeForfeit_0000','VisitorForfeit_0000','HomeScore_0000','VisitorScore_0000')
	// For Visitor Forf ('VisitorForfeit_0000','HomeForfeit_0000','VisitorScore_0000','HomeScore_0000')
	if (document.getElementById(isFor).checked)
	{	document.getElementById(NOTfor).checked	= false
		document.getElementById(scoreZero).value		= 0
		document.getElementById(scoreONE).value		= 1
		document.getElementById(scoreONE).readOnly	= true
		document.getElementById(scoreZero).readOnly	= true
	}
	if  ((! document.getElementById(isFor).checked) &&
		(!  document.getElementById(NOTfor).checked))
	{	document.getElementById(scoreONE).readOnly	= false
		document.getElementById(scoreZero).readOnly	= false
		document.getElementById(scoreZero).value	= ""
		document.getElementById(scoreONE).value		= ""
	}
}

//function ValidateVisitorForfeit(index)
//{	//self.document.Games.GameForfeitedBy[index].value = " "
//	if (self.document.Games.VisitorForfeit[index].checked)
//	{	self.document.Games.HomeForfeit[index].checked		= false
//		self.document.Games.VisitorScore[index].value		= 0
//		self.document.Games.HomeScore[index].value			= 1
//		self.document.Games.VisitorScore[index].readOnly	= true
//		self.document.Games.HomeScore[index].readOnly		= true
//	//	self.document.Games.GameForfeitedBy[index].value = "V"
//	}
//	if  ((! self.document.Games.HomeForfeit[index].checked) &&
//		(! self.document.Games.VisitorForfeit[index].checked))
//	{
//		self.document.Games.VisitorScore[index].readOnly	= false
//		self.document.Games.HomeScore[index].readOnly		= false
//	}
//}

</script>

<cfsavecontent variable = "cf_footer_scripts">
	<script>
		<!--- Global Change Variable --->
		var unSavedChanges = 0;
	
		<!--- Unsaved changes check --->
		$(window).bind('beforeunload', function(){
			if ( unSavedChanges == 1 ){
				// return 'Are you sure you want to leave?';
				return '"Data on the page has changed and has not been saved.  Click "stay" to go back and save changes. Click "leave" to discard changes."'
			}
		});

		<!--- On Change event --->
		$("input, select").on('change keyup',function(){

			<!--- Ensure that the global variable is only changed for changes in the game forms not the search forms --->
			if ( !$(this).closest('form').hasClass('game_form') )
			{
				return false;
			}

			<!--- Get Form ID for changed element --->
			var id = $(this).closest('form').attr('id');

			<!--- Set Global change variable to 1 --->
			unSavedChanges = 1;
			
			<!--- Set floopy icon, show Save button, and highlight div to represent an unsaved change --->
			$('##icon_' + id).removeClass();
			$('##icon_' + id).addClass('fa fa-floppy-o');
			$("##save_" + id).show();
			$("##div_" + id).addClass('div_highlight');
		});

		<!--- Save changes --->
		$('.save_button').click(function(){
				<!--- Get Form ID for clicked icon --->
				var id = $(this).closest('form').attr('id');

				<!--- Disable submit functionality to protect against multiclicks --->
				if ($('##icon_' + id).hasClass('fa fa-circle-o-notch fa-spin fa-fw') || $('##icon_' + id).hasClass('fa fa-check'))
				{
					return false;
				}

				<!--- Set loading icon --->
				$('##icon_' + id).removeClass();
				$('##icon_' + id).addClass('fa fa-circle-o-notch fa-spin fa-fw');

				<!--- Make Ajax Call --->
				$.ajax({
					url: 'scoreEdit.cfm',
					method: 'POST',
					data: $('##' + id ).serialize(),
					dataType: 'JSON',
					success: function(data){
						<!--- Interrogate status value --->
						if (data.status == 'success')
						{
							<!--- Set checkmark to show success --->
							$('##icon_' + id).removeClass();
							$('##icon_' + id).addClass('fa fa-check');

							<!--- Remove yellow background --->
							$("##div_" + id).removeClass('div_highlight');

							<!--- Update global change variable --->
							$(".game_record").each(function(){
								if ( $(this).hasClass('game_record cssRow div_highlight') )
								{
									unSavedChanges = 1;
									return false;
								} 
								else
								{
									unSavedChanges = 0;
								}
							});
						} else {
							<!--- Set Error icon to show failure --->
							$('##icon_' + id).removeClass();
							$('##icon_' + id).addClass('fa fa-exclamation-circle red_text');
						}
					},
					error: function(data){
						console.log(data);
						alert('Error occurred.');
					}
				});
		});
	</script>
</cfsavecontent>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">



	
		<!---	LinkRefRpt = ""
				<% if HomeForfeit = "Y" then %>
					<input type="checkbox" maxlength="1" name="HomeForfeit" checked    onclick="ValidateHomeForfeit(<%=Index%>)" style="WIDTH: 20px; HEIGHT: 20px" size=1 >
				<% else %>
					<input type="checkbox" maxlength="1" name="HomeForfeit"  onclick="ValidateHomeForfeit(<%=Index%>)" style="WIDTH: 20px; HEIGHT: 20px" size=1 >
				<% End if%>
				</td>
				<TD><%=HomeTeam%></TD>
				<td>
				<% if VisitorForfeit = "Y" then %>
					<input type="checkbox" maxlength="1" name="VisitorForfeit"  checked onclick="ValidateVisitorForfeit(<%=Index%>)" style="WIDTH: 20px; HEIGHT: 20px" size=1>
				<% else %>
					<input type="checkbox" maxlength="1" name="VisitorForfeit"  onclick="ValidateVisitorForfeit(<%=Index%>)" style="WIDTH: 20px; HEIGHT: 20px" size=1>
				<% end if %>
				</td>
				<TD><%=VisitorTeam%></TD>

						<TD><input maxlength="2" name="HomeScore" value="<%=HomeScore%>"    onchange="return ValidateField(this)" style="WIDTH: 24px; HEIGHT: 25px" size=2 ></TD>
						<TD><input maxlength="2" name="VisitorScore" value="<%=VisitorScore%>" onchange="return ValidateField(this)" style="WIDTH: 24px; HEIGHT: 25px" size=2 ></TD>

				<td align=center><input type="checkbox" maxlength="1" name="DE"   <%=CheckedMark%>		  onclick="setDelayedEntry(<%=Index%>)"  style="WIDTH: 15px; HEIGHT: 15px" size=1></td>
				<td align=center><input type="checkbox" maxlength="1" name="DEV"  <%=CheckedMarkVisitor%> onclick="setDelayedEntryVisitor(<%=Index%>)"  style="WIDTH: 15px; HEIGHT: 15px" size=1></td>
				<td align=center><input type="checkbox" maxlength="1" name="RNS" <%=ChkMarkRNS%>  onclick="setRefNoShow(<%=Index%>)" style="WIDTH: 15px; HEIGHT: 15px" size=1></td>
			</TR>
		
		End if
 --->
