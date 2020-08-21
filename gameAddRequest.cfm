<!--- 
	FileName:	gameAddRequest.cfm
	Created on: 01/20/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: Request to add a game by a club.
	
MODS: mm/dd/yyyy - filastname - comments

03/06/09 - aarnone - ticket:7309 - virtual team changes for state cup and non league games
01/10/2012 - J. Rab - ticket: NCSA11591 - Added new constraint to playfield drop down to only show fields associated to club logged in

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm"> 
<script language="JavaScript" src="DatePicker.js"></script>
<cfoutput>
<div id="contentText">

<H1 class="pageheading">NCSA - Request to Add a Game</H1>
<br><!--- <h2>yyyyyy </h2> --->

<CFSET msg = "">

<CFSET clubID = SESSION.USER.CLUBID>


<CFIF isDefined("FORM.SelGameType")>
	<cfset SelGameType = FORM.SelGameType>
<CFELSE>
	<cfset SelGameType = "">
</CFIF>
<CFIF isDefined("FORM.SelDivision")>
	<cfset SelDivision = FORM.SelDivision>
<CFELSE>
	<cfset SelDivision = "">
</CFIF>
<CFIF isDefined("FORM.SelVisitDivision")>
	<cfset SelVisitDivision = FORM.SelVisitDivision>
<CFELSE>
	<cfset SelVisitDivision = "">
</CFIF>

<CFIF isDefined("FORM.GameTypeList")>
	<cfset GameType	= Form.GameTypeList>
<CFELSE>
	<cfset GameType	= "">
</CFIF>

<!--- All in same Div --->
	<CFIF isDefined("FORM.DivisionList")>
		<cfset GameDivision	= Form.DivisionList>
	<CFELSE>
		<cfset GameDivision	= "">
	</CFIF>
<!--- more than one DIV --->
	<CFIF isDefined("FORM.VisitDivisionList")>
		<cfset GameVisitDivision	= Form.VisitDivisionList>
	<CFELSE>
		<cfset GameVisitDivision	= "">
	</CFIF>

<!--- DAY - TIME --->	
<CFIF isDefined("FORM.GameDate")>
	<cfset GameDate		= Form.GameDate>
<CFELSE>
	<cfset GameDate		= dateFormat(now(),"mm/dd/yyyy")>
</CFIF>
<CFIF isDefined("FORM.GameHour")>
	<cfset GameHour		= Form.GameHour>
<CFELSE>
	<cfset GameHour		= "">
</CFIF>
<CFIF isDefined("FORM.GameMinute")>
	<cfset GameMinute	= Form.GameMinute>
<CFELSE>
	<cfset GameMinute	= "">
</CFIF>
<CFIF isDefined("FORM.GameMeridian")>
	<cfset GameMeridian	= Form.GameMeridian>
<CFELSE>
	<cfset GameMeridian	= "">
</CFIF>

<!--- TEAMS --->
<CFIF isDefined("FORM.HomeTeam")>
	<cfset HomeTeam		= Form.HomeTeam>
<CFELSE>
	<cfset HomeTeam		= "">
</CFIF>
<CFIF isDefined("FORM.VisitorTeam")>
	<cfset VisitorTeam	= Form.VisitorTeam>
<CFELSE>
	<cfset VisitorTeam	= "">
</CFIF>
<!--- FIELD --->
<CFIF isDefined("FORM.GameField")>
	<cfset GameField	= Form.GameField>
<CFELSE>
	<cfset GameField	= "">
</CFIF>

<CFIF isDefined("FORM.addInfo")>
	<cfset addInfo	= Form.addInfo>
<CFELSE>
	<cfset addInfo	= "">
</CFIF>


<CFIF isDefined("FORM.SAVE")>
	<cfset swDoSave = true>
	<CFSET Gameid = 0>

	<CFIF len(trim(GameType)) EQ 0>
		<cfset msg = msg & "<br> Game Type is required.">
		<cfset swDoSave = false>
	</CFIF>
	<CFIF len(trim(GameDivision)) EQ 0>
		<cfset msg = msg & "<br> Division is required.">
		<cfset swDoSave = false>
	</CFIF>
	<CFIF len(trim(GameDate)) EQ 0>
		<cfset msg = msg & "<br> Game Date is required.">
		<cfset swDoSave = false>
	</CFIF>
	<CFIF len(trim(GameHour)) EQ 0>
		<cfset msg = msg & "<br> Game Time is required.">
		<cfset swDoSave = false>
	</CFIF>
	<CFIF len(trim(GameMinute)) EQ 0>
		<cfset msg = msg & "<br> Game Time is required.">
		<cfset swDoSave = false>
	</CFIF>
	<CFIF len(trim(GameMeridian)) EQ 0>
		<cfset msg = msg & "<br> Game Time is required.">
		<cfset swDoSave = false>
	</CFIF>
	<CFIF len(trim(HomeTeam)) EQ 0 OR TRIM(HomeTeam) EQ 0>
		<cfset msg = msg & "<br> Home Team is required.">
		<cfset swDoSave = false>
	</CFIF>
	<CFIF len(trim(VisitorTeam)) EQ 0 OR trim(VisitorTeam) EQ 0 >
		<cfset msg = msg & "<br> Visiting Team is required.">
		<cfset swDoSave = false>
	</CFIF>
	<CFIF len(trim(GameField)) EQ 0 OR trim(GameField) EQ 0 >
		<cfset msg = msg & "<br> Game Field is required.">
		<cfset swDoSave = false>
	</CFIF>
	<CFIF len(trim(addInfo)) EQ 0 OR trim(addInfo) EQ 0 >
		<cfset msg = msg & "<br> Additional Information is required.">
		<cfset swDoSave = false>
	</CFIF>


	<!--- 03/18/09 - AA - took out check to see if team is playing a game on that date if needed in future, create module that can be used everywhere.
	<cfif swDoSave>
		<!--- Does Team Already have a Game the same date --->
		<!--- Check HOME team --->
		<CFQUERY name="findAnotherGame" datasource="#SESSION.DSN#">
			Select Game_id from V_Games
			 where Game_Date = <cfqueryparam cfsqltype="CF_SQL_DATE" value="#GameDate#">
			   and (   HOME_TEAM_ID    =  <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#HomeTeam#">
					or VISITOR_TEAM_ID =  <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#HomeTeam#">
					)
		</CFQUERY>
		<CFIF findAnotherGame.RECORDCOUNT>
			<cfset swDoSave = false>
			<CFSET msg = msg & " Home team already has a game <u>" & findAnotherGame.GAME_ID & "</u> on <u>" & GameDate & "</u>.">
		</CFIF>
		
		<!--- Check VISITOR team, skip check if state cup or non league --->
		<cfif listFindNoCase("C:N",Trim(GameType),":") EQ 0>
		<!--- <CFIF Trim(GameType) NEQ "C" AND Trim(GameType) EQ "N" > --->
			<CFQUERY name="findAnotherGame" datasource="#SESSION.DSN#">
				Select Game_id from V_Games
				 where Game_Date = <cfqueryparam cfsqltype="CF_SQL_DATE" value="#GameDate#">
				   and (   HOME_TEAM_ID    =  <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VisitorTeam#">
						or VISITOR_TEAM_ID =  <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VisitorTeam#">
						)
			</CFQUERY>
			<CFIF findAnotherGame.RECORDCOUNT>
				<cfset swDoSave = false>
				<CFSET msg = msg & " Visiting team already has a game <u>" & findAnotherGame.GAME_ID & "</u> on <u>" & GameDate & "</u>.">
			</CFIF>
		</CFIF>
	</cfif> --->
	
	<cfif swDoSave>
		<CFIF isNumeric(GameHour)>
			<cfset GameTime = GameHour & ":">
		<CFELSE>
			<cfset GameTime = "01:" >
		</CFIF>
		<CFIF isNumeric(GameMinute) >
			<cfset GameTime = GameTime & GameMinute & " " & GameMeridian>
		<CFELSE>
			<cfset GameTime = GameTime & "00 AM">
		</CFIF>
		<cfset Gender	 = Trim(Left(GameDivision, 1)) >
		<cfset TeamAge	 = "U" & Trim( mid(GameDivision, 2, 2)) >
		<cfset PlayLevel = Trim( mid(GameDivision, 4, 1)) >
		<cfset Group	 = Trim( mid(GameDivision, 5, 1)) >
		<cfset teamDiv   = gender & teamAge>


		<CFIF Trim(GameType) EQ "C" OR Trim(GameType) EQ "N" > 
			<!---  State Cup and Non league, where the Visiting Team is not part of NCSA League --->
			<!--- save write in name --->
			<cfset virt_team_name = VARIABLES.VisitorTeam>
			<CFIF Trim(GameType) EQ "C">
				<cfset virt_team_name = "SC:" & VARIABLES.virt_team_name>
			<CFELSEIF Trim(GameType) EQ "N">
				<cfset virt_team_name = "NL:" & VARIABLES.virt_team_name>
			</CFIF> 
			
			<!--- replace name entered with virtual team's ID --->
			<cfquery name="qGetVirtTeamID" datasource="#SESSION.DSN#">
				SELECT team_id FROM TBL_TEAM where club_id = 2 and teamName = 'virtual team'
			</cfquery>
			<cfset VisitorTeam = qGetVirtTeamID.team_id>
		<cfelse>
			<cfset virt_team_name = "">
		</CFIF> 
			<!---  
			<br>HomeTeamID	[#VARIABLES.HomeTeam#]			
			<br>VisitorTeamID[#VARIABLES.VisitorTeam#]
			<br>virtTeamName [#VARIABLES.virt_team_name#]
			<br>seasonID	[#SESSION.CURRENTSEASON.ID#]	
			<br>contactID	[#SESSION.USER.CONTACTID#]
			<br>GameDate	[#VARIABLES.GameDate#]			
			<br>GameTime	[#VARIABLES.GameTime#]
			<br>FieldID		[#VARIABLES.GameField#]			
			<br>GameType	[#VARIABLES.GameType#]
			<br>GameDiv		[#VARIABLES.GameDivision#]
			 --->
		<CFQUERY name="qInsertGameReq" datasource="#SESSION.DSN#">
			INSERT into TBL_GAME_NEW_REQUEST
					(season_ID, gameDate,     gameTime,    FieldID,     
					 HomeTeam_ID, VisitorTeam_ID, virtual_VisitorTeamName,
					 GameType,  GameDivision, new_game_comments,
					 requestDate, requestTime, createdBy,   createdDate)
			VALUES 
					( <cfqueryparam cfsqltype="CF_SQL_NUMERIC"   value="#SESSION.CURRENTSEASON.ID#">
					, <cfqueryparam cfsqltype="CF_SQL_DATE"      value="#VARIABLES.GameDate#">
					, <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#VARIABLES.GameDate# #VARIABLES.GameTime#">
					, <cfqueryparam cfsqltype="CF_SQL_NUMERIC"   value="#VARIABLES.GameField#">
					, <cfqueryparam cfsqltype="CF_SQL_NUMERIC"   value="#VARIABLES.HomeTeam#">
					, <cfqueryparam cfsqltype="CF_SQL_NUMERIC"   value="#VARIABLES.VisitorTeam#">
					, <cfqueryparam cfsqltype="CF_SQL_VARCHAR"	 value="#VARIABLES.virt_team_name#">
					, <cfqueryparam cfsqltype="CF_SQL_VARCHAR"	 value="#VARIABLES.GameType#">
					, <cfqueryparam cfsqltype="CF_SQL_VARCHAR"	 value="#VARIABLES.GameDivision#">
					, <cfqueryparam cfsqltype="CF_SQL_VARCHAR"	 value="#VARIABLES.addInfo#">
					, <cfqueryparam cfsqltype="CF_SQL_DATE"      value="#dateFormat(now(),"mm/dd/yyyy")#">
					, <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#dateFormat(now(),"mm/dd/yyyy")# #timeFormat(now(),"hh:mm:ss tt")#">
					, <cfqueryparam cfsqltype="CF_SQL_NUMERIC"   value="#SESSION.USER.CONTACTID#">
					, <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#dateFormat(now(),"mm/dd/yyyy")# #timeFormat(now(),"hh:mm:ss tt")#">
					)
		</CFQUERY>

		<cflocation url="gameAddReqLog.cfm">  
	</cfif>
</CFIF>


<!--- 
<CFINVOKE component="#SESSION.SITEVARS.cfcPath#TEAM" method="getDivisions" returnvariable="qClubDivisions">
	<cfinvokeargument name="clubID" value="#VARIABLES.clubID#">
</CFINVOKE>
 --->
<CFINVOKE component="#SESSION.SITEVARS.cfcPath#TEAM" method="getDivisions" returnvariable="qDivisions">
</CFINVOKE>

<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="gameType">
	<cfinvokeargument name="listType" value="GAMETYPE"> 
</cfinvoke> 

<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="stTimeParams">
	<cfinvokeargument name="listType" value="DDHHMMTT"> 
</cfinvoke> 

<!--- ----------------------------------------------------------------
	FRIENDLY   - TWO DIVS, each team can be in a different DIV
	STATE CUP  - one DIV for HOME team, VISITOR is typed in
	NON LEAGUE - one Div - SAME AS STATE CUP
			PLAY OFF** - one DIV, both teams in SAME div - SAME AS LEAGUE  **OMITTED **OMMITED **OMMITED
			LEAGUE**   - one DIV, both teams in SAME div - **OMITTED **OMMITED **OMMITED
------------------------------------------------------------------ --->
<FORM id="GameReq" name="GameReq" action="gameAddRequest.cfm"  method="post">
	<input type="hidden" name="SelGameType"		   value="#SelGameType#" >
	<input type="hidden" name="SelDivision"		   value="#SelDivision#" >
	<input type="hidden" name="SelVisitDivision"   value="#SelVisitDivision#" >
	<input type="hidden" name="Comments" 		   value="">
	<input type="hidden" name="GamesChairComments" value="">

	<span class="red">Fields marked with * are required</span>
	<CFSET required = "<FONT color=red>*</FONT>">
	<table cellspacing="0" cellpadding="5" align="left" border="0" width="98%">
		<tr class="tblHeading">
			<TD colspan="2">&nbsp;</TD>
		</tr>
		<cfif len(trim(msg))>
			<tr><TD colspan="2"><span class="red"><b>#msg#</b></span></TD>
			</tr>
		</cfif>
		</TR><TD width="15%" align="right">#required# <B>Game Type</B> </TD>
			<td><SELECT name="GameTypeList" onchange="GetDivs()">
					<OPTION value="">Select Type</OPTION>
					<cfset omitGameTypeList = "L,P"><!--- omit "LEAGUE" and "PLAY OFF" from selection --->
					<cfloop from="1" to="#arrayLen(gameType)#" index="iGT">
						<CFIF listFindnoCase(omitGameTypeList,gameType[iGT][1]) EQ 0> <!--- omit options from selection --->
							<OPTION value="#gameType[iGT][1]#" <cfif SelGameType EQ gameType[iGT][1]>selected</cfif>  > #gameType[iGT][2]# </OPTION>
						</CFIF>
					</cfloop>
				</select>					
			</td>
		</TR>
		
		<TR><TD align="right">#required# <B>Game Date</B></TD>
			<td><input name="GameDate" value="#VARIABLES.GameDate#" size="9" readonly  >
				<input size="3" name="DOW"  value="#DateFormat(VARIABLES.GameDate,"ddd")#" disabled>
				&nbsp;  <cfset dpMM = datePart("m",VARIABLES.GameDate)-1>
						<cfset dpYYYY = datePart("yyyy",VARIABLES.GameDate)>
				<a href="javascript:show_calendar('GameReq.GameDate','GameReq.DOW','#dpMM#','#dpYYYY#');" 
					onmouseover="window.status='Date Picker';return true;" 
					onmouseout="window.status='';return true;"> 
						<img src="#SESSION.siteVars.imagePath#cal.gif" width="20" height="18" alt="" border="0">
				</a>
			</td>
		</TR>

		<TR><TD align="right">#required# <B>Game Time</B></TD>
			<TD><SELECT name="GameHour"> 
					<OPTION value="" selected>HR</OPTION>
				    <CFLOOP list="#stTimeParams.hour#" index="iHr">
						<OPTION value="#iHr#" <cfif VARIABLES.gameHour EQ iHr>selected</cfif> >#iHr#</OPTION>
					</CFLOOP>
				</SELECT>
				<SELECT name="GameMinute"> 
					<OPTION value="" selected>MN</OPTION>
					<CFLOOP list="#stTimeParams.min#" index="iMn">
						<OPTION value="#iMn#" <cfif VARIABLES.gameMinute EQ iMn>selected</cfif>  >#iMn#</OPTION>
					</CFLOOP>
				</SELECT>
				<SELECT name="GameMeridian">
					<CFLOOP list="#stTimeParams.tt#" index="iTT">
						<OPTION value="#iTT#" <cfif VARIABLES.gameMeridian EQ iTT>selected</cfif>  >#iTT#</OPTION>
					</CFLOOP>
				</SELECT>  
			<TD>
		</TR>
		<!--- ============================================== --->
		<TR><TD align="right" valign="middle">
					#required# 
						<cfif SelGameType EQ "F"><!--- Friendly Games Span Divisions, show Home Div and Visitor Div --->
							<B>Home:</B>
						</cfif>
					<B>Division</B>
			</TD>
			<TD align="left" valign="middle">
				<SELECT name="DivisionList" onchange="GetTeams()" style="WIDTH: 110px" ><!--- used for Both and Home ---> 
					<OPTION value="" >Select Division</OPTION>
					<cfloop query="qDivisions">
						<OPTION value="#Division#" <cfif selDivision EQ Division>selected</cfif> >#Division#</OPTION>
					</cfloop>
				</select>
			</TD>
		</TR>
		<!--- ============================================== --->
		<TR><TD align="right">#required# <B>Home</B></TD>
			<TD><cfif len(Trim(SelDivision))> 
					<cfinvoke component="#SESSION.SITEVARS.cfcPath#TEAM" method="getDivisionTeams" returnvariable="qTeams">
						<cfinvokeargument name="division" value="#SelDivision#">
					</cfinvoke>
					<SELECT name="HomeTeam" > 
						<OPTION value="0">Select #selDivision# HomeTeam</OPTION>
						<cfloop query="qTeams">
							<CFIF CLUB_ID eq clubID ><!--- AND APPROVED_YN EQ "Y" --->
								<OPTION value="#Team_ID#" <CFIF VARIABLES.HomeTeam EQ TEAM_ID>selected</CFIF> >#TeamNamederived#</OPTION>
							</CFIF>
						</cfloop>
					</select>
				<cfelse>
					<input value="Please Select GameType and Division"  disabled >
				</cfif>
			</td>
		</TR>
		<!--- ============================================== --->
		<cfif SelGameType EQ "F">
			<TR><TD align="right" valign="middle">
					#required# </B><B>Visitor Division</B> <!--- used for Visitor when doing FRIENDLY game type --->
			</TD>
			<TD align="left" valign="middle">
					<SELECT name="VisitDivisionList" onchange="GetOtherTeam()"  style="WIDTH: 110px" >  
						<OPTION value="" >Select Division</OPTION>
						<cfloop query="qDivisions">
							<OPTION value="#Division#" <cfif SelVisitDivision EQ Division>selected</cfif> >#Division#</OPTION>
						</cfloop>
					</select>
				</TD>
			</TR>
		</cfif>
		<TR><TD align="right">#required# <B>Visitor</B></TD>
			<TD>
				<cfif len(Trim(SelDivision))>
					<cfif SelGameType EQ "C" OR  SelGameType EQ "N">
						<cfset showTeam = "">
						<CFIF len(trim(VARIABLES.VisitorTeam)) and isNumeric(VARIABLES.VisitorTeam)>
							<CFIF isDefined("VARIABLES.TeamName")>
								<cfset showTeam = VARIABLES.TeamName>
							</CFIF>
						<cfelse>
							<cfset showTeam = VARIABLES.VisitorTeam>
						</CFIF>
						<input maxlength="25" name="VisitorTeam" style="WIDTH: 300px;" value="#VARIABLES.showTeam#"> 
					<cfelse>
						<cfif SelGameType EQ "F">
							<cfset useDiv = SelVisitDivision>
						<CFELSE>
							<cfset useDiv = SelDivision>
						</cfif> 
						<cfinvoke component="#SESSION.SITEVARS.cfcPath#TEAM" method="getDivisionTeams" returnvariable="qTeams">
							<cfinvokeargument name="division" value="#useDiv#">
						</cfinvoke>
						<SELECT name="VisitorTeam" > 
							<OPTION value="0" >Select #useDiv# VisitorTeam</OPTION>
							<cfloop query="qTeams">
								<CFIF APPROVED_YN EQ "Y">
									<OPTION value="#Team_ID#" <CFIF VARIABLES.VisitorTeam EQ TEAM_ID>selected</CFIF> >#TeamNamederived#</OPTION>
								</CFIF>
							</cfloop>
						</select>
					</cfif>
				<cfelse>
					<input value="Please Select GameType and Division"  disabled >
				</cfif>
			</td>
		</TR>
		<!--- ============================================== --->
		<TR id="AllFields">
			<!--- <cfif ( (ucase(trim(Session("RoleCode"))) = "GAMESCHAIR" or Session("ProfileType") = "SU") ) then #--->
			<!--- <cfif SESSION.MENUROLEID EQ 19 OR SESSION.MENUROLEID EQ 1 >  ---><!---  19="GAMESCHAIR" 1="ASSTADMIN" --->
				<cfinvoke component="#SESSION.SITEVARS.cfcPath#FIELD" method="getAllFieldDropDownPerClub" returnvariable="stFields">
							<cfinvokeargument name="clubID" value="#clubID#">
				</cfinvoke>
				<TD align="right">#required# <B>PlayField</B> </TD>
				<TD><SELECT name="GameField"> 
						<CFLOOP query="stFields.regFields">
							<cfif len(trim(FieldAbbr))>
								<OPTION  value="#Field_ID#" <CFIF VARIABLES.GameField EQ Field_ID>selected</CFIF> >#FieldAbbr#</OPTION>
							</cfif>
						</CFLOOP>
						<cfif SESSION.MENUROLEID EQ 19 OR SESSION.MENUROLEID EQ 1 > <!---  19="GAMESCHAIR" 1="ASSTADMIN" --->
							<CFLOOP query="stFields.tbsFields">
								<OPTION value="#Field_ID#" <CFIF VARIABLES.GameField EQ Field_ID>selected</CFIF> >#FieldAbbr#</OPTION>
							</CFLOOP>
						</cfif>
					</SELECT>
				</td>
			<!--- </cfif> --->
		</TR>
		<TR><TD align="right">#required# <B>Additional Info:</B></TD>
			<TD><TEXTAREA name="addInfo" rows=3 cols=40>#Trim(VARIABLES.addInfo)#</TEXTAREA></TD>
		</TR>
		<!--- 
		<TR><TD align="right"><B>Games Chairman Notes</B></TD><TD><TEXTAREA name="GamesChairComments"  rows=3 cols=40>#Trim(VARIABLES.GamesChairComments)#</TEXTAREA></TD></TR> 
		--->
		<TR><TD>&nbsp;</TD>
			<TD align="left" colspan="2">
				<INPUT type="submit" name="SAVE" value="Save" >
			</TD>
		</TR>
	</TABLE>
</FORM>

<script language="javascript">
var cForm = document.GameReq.all;
function GetDivs()
{	self.document.GameReq.SelGameType.value = self.document.GameReq.GameTypeList.value;
	self.document.GameReq.action = "gameAddRequest.cfm";
	self.document.GameReq.submit();
}
function GetTeams()
{	self.document.GameReq.SelGameType.value = self.document.GameReq.GameTypeList.value;
	self.document.GameReq.SelDivision.value = self.document.GameReq.DivisionList.value;
	self.document.GameReq.action = "gameAddRequest.cfm";
	self.document.GameReq.submit();
}
function GetOtherTeam()
{	self.document.GameReq.SelGameType.value 	 = self.document.GameReq.GameTypeList.value;
	self.document.GameReq.SelVisitDivision.value = self.document.GameReq.VisitDivisionList.value;
	self.document.GameReq.action = "gameAddRequest.cfm";
	self.document.GameReq.submit();
}
</script>	
	
	

</cfoutput>
</div>
<cfinclude template="_footer.cfm">
