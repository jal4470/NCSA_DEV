<!--- 
	FileName:	gameAdd.cfm
	Created on: 10/01/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: add a game
	
MODS: mm/dd/yyyy - filastname - comments
01/28/2009 - aarnone - fixed js issue when changing months
03/06/09 - aarnone - ticket:7309 - virtual team changes for state cup and non league games

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm"> 
<script language="JavaScript" src="DatePicker.js"></script>
<cfoutput>
<div id="contentText">

<H1 class="pageheading">NCSA - Add Game</H1>
<br><!--- <h2>yyyyyy </h2> --->

<CFSET msg = "">

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

<!--- <CFIF isDefined("FORM.GameCode")>
	<cfset GameCode		= Form.GameCode>
<CFELSE>
	<cfset GameCode		= "">
</CFIF> --->
<CFIF isDefined("FORM.GameTypeList")>
	<cfset GameType		= Form.GameTypeList>
<CFELSE>
	<cfset GameType		= "">
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

<CFIF isDefined("FORM.GameDate")>
	<cfset GameDate		= Form.GameDate>
<CFELSE>
	<cfset GameDate		= "">
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
<CFIF isDefined("FORM.GameField")>
	<cfset GameField	= Form.GameField>
<CFELSE>
	<cfset GameField	= "">
</CFIF>
<CFIF isDefined("FORM.Comments")>
	<cfset Comments		= Form.Comments>
<CFELSE>
	<cfset Comments		= "">
</CFIF>
<CFIF isDefined("FORM.GamesChairComments")>
	<cfset GamesChairComments	= Form.GamesChairComments>
<CFELSE>
	<cfset GamesChairComments	= "">
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

	<cfif swDoSave>
		<!--- GameTime = GameHour & ":" & GameMinute & " " & GameMeridian --->
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
	
		<!--- <CFIF Trim(GameType) EQ "C" OR Trim(GameType) EQ "N" > <!---  State Cup and Non league, where the Visiting Team might not belong to the NCSA --->
			<CFQUERY name="club1Abbr" datasource="#SESSION.DSN#">
				Select ClubAbbr from TBL_CLUB where CLUB_ID = 1
			</CFQUERY>
			<CFIF club1abbr.recordCount>
				<CFSET ClubAbbr = club1Abbr.ClubAbbr>
			</CFIF>
			<cfif listLen(VisitorTeam," ") GT 1>
				<cfset TeamName = Trim(ClubAbbr) & "-" & ListFirst(VisitorTeam," ")>
			<cfelse>
				<cfset TeamName = Trim(ClubAbbr) & "-" & VisitorTeam>
			</cfif>
	
			<cfstoredproc procedure="p_create_new_state_cup_team" datasource="#SESSION.DSN#">
				<cfprocparam type="In"  cfsqltype="CF_SQL_NUMERIC" dbvarname="@club_id"	  value="1">
				<cfprocparam type="In"  cfsqltype="CF_SQL_NUMERIC" dbvarname="@season_id" value="#SESSION.CURRENTSEASON.ID#">
				<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@division"  value="#VARIABLES.teamDiv#">
				<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@teamName"  value="#VARIABLES.TeamName#">
				<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@TeamAge"	  value="#VARIABLES.TeamAge#">
				<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@PlayLevel" value="#VARIABLES.PlayLevel#">
				<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@Gender"	  value="#VARIABLES.Gender#">
				<cfprocparam type="In"  cfsqltype="CF_SQL_NUMERIC" dbvarname="@CreatedBy" value="#SESSION.USER.CONTACTID#">
				<cfprocparam type="Out" cfsqltype="CF_SQL_NUMERIC" dbvarname="@new_team_id" variable="newTeamID">
			</cfstoredproc>
			
			<cfset VisitorTeam = newTeamID>

		</CFIF> --->
		<CFIF Trim(GameType) EQ "C" OR Trim(GameType) EQ "N" > 
			<!---  State Cup and Non league, where the Visiting Team is not part of NCSA League --->
			<!--- save write in name --->
			<cfset virt_team_name = VARIABLES.VisitorTeam>
			<!--- replace name entered with virtual team's ID --->
			<cfquery name="qGetVirtTeamID" datasource="#SESSION.DSN#">
				SELECT team_id FROM TBL_TEAM where club_id = 2 and teamName = 'virtual team'
			</cfquery>
			<cfset VisitorTeam = qGetVirtTeamID.team_id>
		<cfelse>
			<cfset virt_team_name = "">
		</CFIF> 
	
		<cfinvoke component="#SESSION.SITEVARS.cfcPath#GAME" method="insertGame" returnvariable="NEW_GAME_ID">
			<cfinvokeargument name="HomeTeamID"	value="#VARIABLES.HomeTeam#">
			<cfinvokeargument name="VisitorTeamID" value="#VARIABLES.VisitorTeam#">
			<cfinvokeargument name="seasonID"	value="#SESSION.CURRENTSEASON.ID#">
			<cfinvokeargument name="contactID"	value="#SESSION.USER.CONTACTID#">
			<cfinvokeargument name="GameDate"	value="#VARIABLES.GameDate#">
			<cfinvokeargument name="GameTime"	value="#VARIABLES.GameTime#">
			<cfinvokeargument name="FieldID"	value="#VARIABLES.GameField#">
			<cfinvokeargument name="GameType"	value="#VARIABLES.GameType#">
			<cfinvokeargument name="Comments"	value="#VARIABLES.Comments#">
			<cfinvokeargument name="GameCode"	value="">
			<cfinvokeargument name="GamesChairComments" value="#VARIABLES.GamesChairComments#">
		</cfinvoke>
		
		<CFSET Gameid = NEW_GAME_ID>
		
		<CFIF GameID GT 0>
			<cfif GameType EQ "C" OR GameType EQ "N">
			<!--- for state cup and non-league games put in virtual team name --->
				<CFQUERY name="qUpdateVirtTeamName" datasource="#SESSION.DSN#">
					UPDATE XREF_GAME_TEAM
					   SET Virtual_TeamName = '#VARIABLES.virt_team_name#'
					 WHERE GAME_ID = #VARIABLES.GameID#
					   AND TEAM_ID = #VARIABLES.VisitorTeam#
					   AND isHomeTeam = 0
				</CFQUERY>
			</cfif>
		
			<CFSET msg = msg & "<BR>Game has been added. Game ID is " & GameID >
		<CFELSE>
			<CFSET msg = msg & "<BR>Game was not added." >
		</CFIF>
	</cfif>
</CFIF>


<CFINVOKE component="#SESSION.SITEVARS.cfcPath#TEAM" method="getDivisions" returnvariable="qDivisions">
</CFINVOKE>

<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="gameType">
	<cfinvokeargument name="listType" value="GAMETYPE"> 
</cfinvoke> 

<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="stTimeParams">
	<cfinvokeargument name="listType" value="DDHHMMTT"> 
</cfinvoke> 

			
<!--- ----------------------------------------------------------------
	LEAGUE     - one DIV, both teams in SAME div
	FRIENDLY   - TWO DIVS, each team can be in a different DIV
	STATE CUP  - one DIV for HOME team, VISITOR is typed in
	NON LEAGUE - one Div - SAME AS STATE CUP
	PLAY OFF   - one DIV, both teams in SAME div - SAME AS LEAGUE
------------------------------------------------------------------ --->
<FORM name="Games" action="gameAdd.cfm"  method="post">
<input type="hidden" name="SelGameType" value="#SelGameType#" >
<input type="hidden" name="SelDivision" value="#SelDivision#" >
<input type="hidden" name="SelVisitDivision" value="#SelVisitDivision#" >

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
					<cfloop from="1" to="#arrayLen(gameType)#" index="iGT">
						<OPTION value="#gameType[iGT][1]#" <cfif SelGameType EQ gameType[iGT][1]>selected</cfif>  > #gameType[iGT][2]# </OPTION>
					</cfloop>
				</select>					
			</td>
		</TR>
		<!--- <TR><TD align="right"><B>Game Code</B></TD>
			<TD><INPUT name="GameCode" value="" type="Text"></TD>
		</TR> --->

		<!--- 1/28/09 - replaced w/code below to fix js error when changing months
		<TR><TD align="right">#required# <B>Game Date</B></TD>
			<td><input size="9" name="GameDate" value="#VARIABLES.GameDate#" readonly  > 
				&nbsp;
				<a href="javascript:show_calendar('Games.GameDate');" 
					onmouseover="window.status='Date Picker';return true;" 
					onmouseout="window.status='';return true;"> 
						<img src="#SESSION.siteVars.imagePath#cal.gif" width="20" height="18" alt="" border="0">
				</a>
			</td>
		</TR> --->


		<TR><TD align="right">#required# <B>Game Date</B></TD>
			<td><input name="GameDate" value="#VARIABLES.GameDate#" size="9" readonly  >
				<input size="3" name="DOW"  value="#DateFormat(VARIABLES.GameDate,"ddd")#" disabled>
				&nbsp;  
					<CFIF isDate(VARIABLES.GameDate)>
						<cfset dpMM   = datePart("m",VARIABLES.GameDate)-1>
						<cfset dpYYYY = datePart("yyyy",VARIABLES.GameDate)>
					<CFELSE>	
						<cfset dpMM   = datePart("m",NOW() )-1>
						<cfset dpYYYY = datePart("yyyy",NOW() )>
					</CFIF>	
				<a href="javascript:show_calendar('Games.GameDate','Games.DOW','#dpMM#','#dpYYYY#');" 
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
					<!--- <SELECT name="DivisionList" style="WIDTH: 144px" onchange="GetTeams()"> 	
							<OPTION value="" >Select Division</OPTION>
							<cfloop query="qDivisions">
								<OPTION value="#Division#" <cfif selDivision EQ Division>selected</cfif> >#Division#</OPTION>
							</cfloop>
						</select> --->
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
							<OPTION value="#Team_ID#" <CFIF VARIABLES.HomeTeam EQ TEAM_ID>selected</CFIF> >#TeamNamederived#</OPTION>
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
						<input maxlength="50" name="VisitorTeam" style="WIDTH: 300px;" value="#VARIABLES.showTeam#"> 
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
								<OPTION value="#Team_ID#" <CFIF VARIABLES.VisitorTeam EQ TEAM_ID>selected</CFIF> >#TeamNamederived#</OPTION>
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
			<cfif SESSION.MENUROLEID EQ 19 OR SESSION.MENUROLEID EQ 1 > <!---  19="GAMESCHAIR" 1="ASSTADMIN" --->
				<cfinvoke component="#SESSION.SITEVARS.cfcPath#FIELD" method="getAllFieldDropDown" returnvariable="stFields">
				</cfinvoke>
				<TD align="right"><B>PlayField</B> </TD>
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
			</cfif>
		</TR>
		<TR><TD align="right"><B>Comments for Ref Assignor</B></TD>
			<TD><TEXTAREA name="Comments"  rows=3 cols=40>#Trim(VARIABLES.Comments)#</TEXTAREA></TD>
		</TR>

		<TR><TD align="right"><B>Games Chairman Notes</B></TD>
			<TD><TEXTAREA name="GamesChairComments"  rows=3 cols=40>#Trim(VARIABLES.GamesChairComments)#</TEXTAREA></TD>
		</TR>
		<TR><TD>&nbsp;</TD>
			<TD align="left" colspan="2">
				<INPUT type="submit" name="SAVE" value="Save" >
			</TD>
		</TR>
	</TABLE>
</FORM>

<script language="javascript">
var cForm = document.Games.all;
function GetDivs()
{	self.document.Games.SelGameType.value =	self.document.Games.GameTypeList.value;
	self.document.Games.action = "gameAdd.cfm";
	self.document.Games.submit();
}
function GetTeams()
{	self.document.Games.SelGameType.value =	self.document.Games.GameTypeList.value;
	self.document.Games.SelDivision.value =	self.document.Games.DivisionList.value;
	self.document.Games.action = "gameAdd.cfm";
	self.document.Games.submit();
}
function GetOtherTeam()
{	self.document.Games.SelGameType.value =	self.document.Games.GameTypeList.value;
	self.document.Games.SelVisitDivision.value =	self.document.Games.VisitDivisionList.value;
	self.document.Games.action = "gameAdd.cfm";
	self.document.Games.submit();
}
</script>	
	
	

</cfoutput>
</div>
<cfinclude template="_footer.cfm">
