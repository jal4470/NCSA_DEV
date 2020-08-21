<!--- 
	FileName:	gameEdit.cfm
	Created on: 09/29/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
01/21/2009 - aarnone - fixed js issue with table row for fields in ff.
01/28/2009 - aarnone - fixed js issue when changing months
03/06/2009 - aarnone - ticket:7309 - virtual team changes for state cup and non league games
04/02/2009 - aarnone - ticket:7431 - accept sort value and return to calling page
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<script language="JavaScript" src="DatePicker.js"></script>

<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Edit Game </H1>
<!--- Time/PlayField --->
<br><!--- <h2>yyyyyy </h2> --->
<!--- <span class="red">Fields marked with * are required</span>
<CFSET required = "<FONT color=red>*</FONT>"> --->


<cfif isDefined("URL.SORT")>
	<CFSET returnSort = URL.SORT>
<cfelseif isDefined("FORM.returnSort")>
	<CFSET returnSort = FORM.returnSort>
<cfelse>
	<CFSET returnSort = "">
</cfif>


<CFSET msg = "">

<CFIF isDefined("FORM.SAVE")>
	<!--- --------------------
			UPDATE Game
	--------------------- --->
 	<CFIF FORM.GAMEFIELDALL NEQ FORM.ORIGGameFieldID>
		<CFSET newFieldID = FORM.GAMEFIELDALL>
	<CFELSEIF FORM.GAMEFIELDCLUB NEQ FORM.ORIGGameFieldID>
		<CFSET newFieldID = FORM.GAMEFIELDCLUB>
	<CFELSE>
		<CFSET newFieldID = FORM.ORIGGameFieldID>
	</CFIF>
	<CFSET GameTime = FORM.GameHour & ":" & FORM.GameMinute & " " & FORM.GameMeridian>

	<cfinvoke component="#SESSION.SITEVARS.cfcPath#game" method="updateGameScedule">
		<cfinvokeargument name="GameId"			    value="#FORM.GameId#">
		<cfinvokeargument name="GameDate"		    value="#FORM.GameDate#">
		<cfinvokeargument name="GameTime"		    value="#VARIABLES.GameTime#">
		<cfinvokeargument name="GameFieldID"	    value="#VARIABLES.newFieldID#">
		<cfinvokeargument name="Comments"		    value="#FORM.Comments#">
		<cfinvokeargument name="GamesChairComments" value="#FORM.GamesChairComments#">
		<cfinvokeargument name="ORIGHomeTeamID"	    value="#FORM.ORIGHomeTeamID#">
		<cfinvokeargument name="HomeTeamID"		    value="#FORM.HomeTeam#">
		<cfinvokeargument name="ORIGVisitorTeamID"  value="#FORM.ORIGVisitorTeamID#">
		<cfinvokeargument name="VisitorTeamID"	    value="#FORM.VisitorTeam#">
		<cfinvokeargument name="ContactID"		    value="#SESSION.USER.CONTACTID#">
		<cfinvokeargument name="Script_Name"	    value="#CGI.SCRIPT_NAME#">
	</cfinvoke>
		<!--- <cfinvokeargument name="HomeTeamID"		    value="#FORM.HomeTeamID#">
		<cfinvokeargument name="VisitorTeamID"	    value="#FORM.VisitorTeamID#"> --->
	<CFSET msg = "This game has been updated.">

	<!--- <cfdump var="#FORM#">
	<CFABORT> --->
	
	
 	<cflocation url="gameList.cfm?cid=#FORM.cid#&div=#FORM.div#&wefrom=#FORM.wefrom#&weto=#FORM.weto#&gidok=#FORM.GameId#&gg=1&sort=#VARIABLES.returnSort#">
</CFIF>

<CFIF isDefined("FORM.DELETE") AND len(trim(FORM.DELETE))>
	<!--- --------------------
			DELETE Game
	--------------------- --->
	<CFSET cpData = "">
	<CFLOOP list="#FORM.FIELDNAMES#" index="IFN">
		<cfset cpData = cpData & IFN & "::" & FORM[IFN] & "||">
	</CFLOOP>

	<CFQUERY name="insertGameDeleteLog" datasource="#SESSION.DSN#">
		Insert into cpc_gameDeleteLog 
			( game_id
			, dt_event_date
			, event_userid
			, event_ip_address
			, event_url
			, event_post_data
			, event_sql) 
		values
			( #FORM.GameId#
			, GETDATE()
			, '#SESSION.USER.CONTACTID#'
			, '#CGI.REMOTE_ADDR#'
			, '#CGI.HTTP_REFERER#?#CGI.QUERY_STRING#'
			, '#cpData#'
			, '')
	</CFQUERY>
	
	<CFINVOKE component="#SESSION.SITEVARS.cfcPath#Game" method="DeleteGame">
		<cfinvokeargument name="GameId"			    value="#FORM.GameId#">
		<cfinvokeargument name="ContactID"		    value="#SESSION.USER.CONTACTID#">
		<cfinvokeargument name="Script_Name"	    value="#CGI.SCRIPT_NAME#">
	</CFINVOKE>

 	<cflocation url="gameList.cfm?cid=#FORM.cid#&div=#FORM.div#&wefrom=#FORM.wefrom#&weto=#FORM.weto#&gg=1&sort=#VARIABLES.returnSort#">
 </CFIF>

<CFIF isDefined("FORM.back")>
 	<cflocation url="gameList.cfm?cid=#FORM.cid#&div=#FORM.div#&wefrom=#FORM.wefrom#&weto=#FORM.weto#&gg=1&sort=#VARIABLES.returnSort#">
 </CFIF>
 

<CFIF isDefined("URL.GID") AND isNumeric(URL.GID)>
	<CFSET gameID = URL.GID>
<CFELSEIF isDefined("FORM.GAMEID") AND isNumeric(FORM.GAMEID)>
	<CFSET gameID = FORM.GAMEID>
<CFELSE>
	<CFSET gameID = 0>
</CFIF>

<CFIF isDefined("URL.cid") AND isNumeric(URL.cid)>
	<CFSET cid = URL.cid>
<CFELSEIF isDefined("FORM.cid")>
	<CFSET cid = FORM.cid>
<CFELSE>
	<CFSET cid = 0>
</CFIF>

<CFIF isDefined("URL.div")>
	<CFSET div = URL.div>
<CFELSEIF isDefined("FORM.div")>
	<CFSET div = FORM.div>
<CFELSE>
	<CFSET div = 0>
</CFIF>

<CFIF isDefined("URL.wefrom") AND isDate(URL.wefrom)>
	<CFSET wefrom = URL.wefrom>
<CFELSEIF isDefined("FORM.wefrom")>
	<CFSET wefrom = FORM.wefrom>
<CFELSE>
	<CFSET wefrom = 0>
</CFIF>

<CFIF isDefined("URL.weto") AND isDate(URL.weto)>
	<CFSET weto = URL.weto>
<CFELSEIF isDefined("FORM.weto")>
	<CFSET weto = FORM.weto>
<CFELSE>
	<CFSET weto = 0>
</CFIF>



<cfset HomeTeamOK = 0>
<cfset VisitorTeamOK = 0>

<cfinvoke component="#SESSION.sitevars.cfcPath#game" method="getGameSchedule" returnvariable="qGameInfo">
	<cfinvokeargument name="gameID"   value="#VARIABLES.gameID#">
</cfinvoke>  <!--- <cfdump var="#qGameInfo#"> --->

<cfset GameDate				= dateFormat(qGameInfo.GAME_DATE,"mm/dd/yyyy") >
<cfset GameTime				= timeFormat(qGameInfo.GAME_TIME,"hh:mm tt") >
<cfset GameField			= qGameInfo.FIELDNAME >
<cfset GameFieldID			= qGameInfo.FIELD_ID >
<cfset ORIGGameFieldID		= qGameInfo.FIELD_ID >
<cfset HomeTeamId			= qGameInfo.HOME_TEAM_ID >
<cfset ORIGHomeTeamId		= qGameInfo.HOME_TEAM_ID >
<cfset VisitorTeamId		= qGameInfo.VISITOR_TEAM_ID >
<cfset ORIGVisitorTeamId	= qGameInfo.VISITOR_TEAM_ID >
<cfset virtualTeamName		= qGameInfo.virtual_teamName >
<cfset TeamNameVisitor		= qGameInfo.Visitor_TeamName >
<cfset GameType				= qGameInfo.game_type >
<cfset GameDivision			= qGameInfo.DIVISION >
<cfset FieldAbbr			= qGameInfo.FIELDABBR >
<cfset Comments				= qGameInfo.Comments >
<cfset GamesChairComments	= qGameInfo.GamesChairComments >

<cfset Gender	 = Left(GameDivision, 1)>
<cfset PlayLevel = mid(GameDivision, 4, 1)>
<cfset TeamAge	 = "U" & mid(GameDivision, 2, 2)>
<cfset PlayGroup = Right(Gamedivision, 1)>

<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="stTimeParams">
	<cfinvokeargument name="listType" value="DDHHMMTT"> 
</cfinvoke> 
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="AgameType">
	<cfinvokeargument name="listType" value="GAMETYPE"> 
</cfinvoke> 


<cfquery name="qDivTeams" datasource="#SESSION.DSN#">
	Select ID, TEAMNAMEderived from V_CoachesTeams
	 Where Gender    = '#Gender#' 
	   and PlayLevel = '#PlayLevel#' 
	   and TeamAge   = '#TeamAge#' 
--	   and approved  = 'Y'
	ORDER BY TEAMNAMEderived
</cfquery> <!--- qDivTeams --->



<FORM name="Games" action="gameEdit.cfm"  method="post">
	<input type="hidden" name="GameId"			  value="#GameId#">
	<input type="hidden" name="GameDivision" 	  value="#GameDivision#">
	<input type="hidden" name="HomeTeamID"		  value="#HomeTeamID#">
	<input type="hidden" name="VisitorTeamID"	  value="#VisitorTeamID#">
	<input type="hidden" name="ORIGHomeTeamID"	  value="#ORIGHomeTeamID#">
	<input type="hidden" name="ORIGVisitorTeamID" value="#ORIGVisitorTeamID#">
	<input type="hidden" name="ORIGGameFieldID"	  value="#ORIGGameFieldID#">
	<input type="Hidden" name="cid"    value="#VARIABLES.cid#">
	<input type="Hidden" name="div"    value="#VARIABLES.div#">
	<input type="Hidden" name="wefrom" value="#VARIABLES.wefrom#">
	<input type="Hidden" name="weto"   value="#VARIABLES.weto#">
	<input type="Hidden" name="returnSort"		  value="#returnSort#">

	<input type="Hidden" name="gameDay"   value="">
	
	<table cellspacing="0" cellpadding="5" align="left" border="0" width="95%">
		<tr class="tblHeading">
			<TD colspan="2">&nbsp;</TD>
		</tr>
		<CFIF len(trim(msg))>
			<tr><td colspan="2">
					<span class="red"><b>#msg#</b></span> 
				</td>
			</tr>
		</CFIF>
		<TR><TD width="15%" align="right"><b>Game ID</b></TD>
			<TD align="left" class="sizetext12">#GameId#</TD>
		</TR>
		<TR><TD width="15%" align="right"><b>Game Type</b></TD>
			<TD align="left" class="sizetext12">
				<cfloop from="1" to="#arrayLen(AgameType)#" index="iGT">
					<CFIF VARIABLES.GameType EQ AgameType[iGT][1]>
						#AgameType[iGT][2]#
					</cfif>
				</cfloop>
			</TD>
		</TR>
		<TR><TD align="right"><b>Division</b></TD>
			<TD align="left" class="sizetext12">#GameDivision#</TD>
		</TR>
		<TR><TD align="right"><b>Game Date</b></TD>
			<td align="left">
				<CFIF isDefined("FORM.GAMEDATE") AND isDate(FORM.GAMEDATE)>
					<CFSET gameDay = UCASE(DateFormat(FORM.GameDate,"ddd"))>
				<CFELSE>
					<CFSET gameDay = UCASE(DateFormat(VARIABLES.GameDate,"ddd"))>
				</CFIF>
				<cfif SESSION.MENUROLEID EQ 19 OR SESSION.MENUROLEID EQ 1> <!---  19="GAMESCHAIR" 1="ASSTADMIN" --->
					<!--- <input size="9" name="GameDate" value="#VARIABLES.GameDate#" readonly 
							onclick="javascript:show_calendar('Games.GameDate');">
					<a href="javascript:show_calendar('Games.GameDate');" 
							onmouseover="window.status='Date Picker';return true;" 
							onmouseout="window.status='';return true;"><font size=2>mm/dd/yyyy</font>
					</a> --->
					<input size="9" name="GameDate" value="#VARIABLES.GameDate#" readonly  > 
					&nbsp;
					<input size="3" name="GameDay" value="#gameDay#" readonly> 
					&nbsp;
					<!--- 1/28/09 - replaced w/code below to fix js error when changing months
					<a href="javascript:show_calendar('Games.GameDate');" 
						onmouseover="window.status='Date Picker';return true;" 
						onmouseout="window.status='';return true;"> 
						<img src="#SESSION.siteVars.imagePath#cal.gif" width="20" height="18" alt="" border="0">
					</a> --->

					<CFIF isDate(VARIABLES.GameDate)>
						<cfset dpMM   = datePart("m",VARIABLES.GameDate)-1>
						<cfset dpYYYY = datePart("yyyy",VARIABLES.GameDate)>
					<CFELSE>	
						<cfset dpMM   = datePart("m",NOW() )-1>
						<cfset dpYYYY = datePart("yyyy",NOW() )>
					</CFIF>	
					<a href="javascript:show_calendar('Games.GameDate','Games.GameDay','#dpMM#','#dpYYYY#');" 
						onmouseover="window.status='Date Picker';return true;" 
						onmouseout="window.status='';return true;"> 
						<img src="#SESSION.siteVars.imagePath#cal.gif" width="20" height="18" alt="" border="0">
					</a>

				<cfelse>
					<input type="hidden" size="9" name="GameDate" value="#VARIABLES.GameDate#" >
					&nbsp;
					<input size="3" name="GameDay" value="#gameDay#" readonly> 
				</cfif>
			</td>
		</TR>
		<TR><TD align="right"><b>Game Time</b></TD>
			<TD align="left">
				<cfset HH = listfirst(VARIABLES.GameTime,":")>
				<cfset MM = listlast( listfirst(VARIABLES.GameTime," ") ,":")>
				<cfset TT = listlast(VARIABLES.GameTime," ")>
				<SELECT name="GameHour"> 
					<OPTION value="0" selected>HR</OPTION>
				    <CFLOOP list="#stTimeParams.hour#" index="iHr">
						<OPTION value="#iHr#" <CFIF HH EQ iHr>selected</CFIF> >#iHr#</OPTION>
					</CFLOOP>
				</SELECT>
				<SELECT name="GameMinute"> 
					<OPTION value="0" selected>MN</OPTION>
					<CFLOOP list="#stTimeParams.min#" index="iMn">
						<OPTION value="#iMn#" <CFIF MM EQ iMn>selected</CFIF> >#iMn#</OPTION>
					</CFLOOP>
				</SELECT>
				<SELECT name="GameMeridian">
					<CFLOOP list="#stTimeParams.tt#" index="iTT">
						<OPTION value="#iTT#" <CFIF TT EQ iTT>selected</CFIF> >#iTT#</OPTION>
					</CFLOOP>
				</SELECT>  
			<TD>
		</TR>
		<TR>
			<TD align="right"><b>Home Team</b></TD>
			<TD align="left">
				<select name="HomeTeam">
					<option value="0">Select Home Team</option>
					<CFLOOP query="qDivTeams">
						<option value="#ID#" <cfif HomeTeamID EQ ID>selected</cfif> >#TEAMNAMEderived#</option>
						<cfif HomeTeamID EQ ID>
							<!--- <input type=text name="HomeTeam" Disabled size="25"  value="#TEAMNAMEderived#"> --->
							<cfset HomeTeamOK = 1 >
						</cfif>
					</CFLOOP>
				</select>
			</td>
		</TR>
		<TR><TD align="right"><b>Visitor Team</b></TD>
			<TD align="left">
			<CFIF GameType EQ "C" OR GameType EQ "N">
				<!--- non league or state cup Game --->
				<input type="Hidden" name="VisitorTeam"  value="#VARIABLES.VisitorTeamId#"> 
				<input type="text"   name="VisitorTeam" Disabled size="25"  value="#VARIABLES.virtualTeamName#"> 
			
			<CFELSEIF GameType EQ "F">
				<!--- Friendly Game --->
				<input type="Hidden" name="VisitorTeam"  value="#VARIABLES.VisitorTeamId#"> 
				<input type="text"   name="VisitorTeam" Disabled size="35"  value="#VARIABLES.TeamNameVisitor#"> 
			<CFELSE>
				<!--- all else --->
				<select name="VisitorTeam">
					<option value="0">Select Visiting Team</option>
					<CFLOOP query="qDivTeams">
						<option value="#ID#" <cfif VisitorTeamID EQ ID>selected</cfif> >#TEAMNAMEderived#</option>
						<cfif VisitorTeamID EQ ID>
							<!--- <input type=text name="VisitorTeam" Disabled size="25"  value="#TEAMNAMEderived#"> --->
							<cfset VisitorTeamOK = 1 >
						</cfif>
					</CFLOOP>
				</select>
				<!--- <CFLOOP query="qDivTeams">
					<cfif VisitorTeamID eq ID>
						<input type=text name="VisitorTeam" Disabled size="25" value="#TEAMNAMEderived#">
						<cfset VisitorTeamOK = 1 >
					</cfif>
				</CFLOOP> --->

				<cfif (HomeTeamOK + VisitorTeamOK) EQ 2 AND
					  (SESSION.MENUROLEID EQ 19 OR SESSION.MENUROLEID EQ 1) > <!---  19="GAMESCHAIR" 1="ASSTADMIN" --->
					<input type=button value="Flip Teams" onclick="FlipTeams()" id=button1 name=button1>
				</cfif>

			</CFIF>

			</td>
		</TR>
		<TR id="ClubFields" style="Display:">
			<TD align="right"><b>PlayField</b> <br> <span class="red">(Club's list)</span> </TD>
			<TD align="left">
				<cfset FieldFound = 0>
				<CFQUERY name="HomeTeamFields" datasource="#SESSION.DSN#">
					SELECT F.FIELD_ID, F.FIELDABBR, F.FIELDNAME
					  FROM TBL_FIELD F	INNER JOIN XREF_CLUB_FIELD xcf ON xcf.field_id = F.field_id
										INNER JOIN V_GAMES	   vg  ON vg.Home_CLUB_ID = xcf.CLUB_ID
					 WHERE vg.GAME = #GameID#
					   and f.Active_YN = 'Y'
					 ORDER BY F.FIELDABBR
				</CFQUERY>
				<cfquery name="otherFieldValues" datasource="#SESSION.DSN#">
						SELECT F.FIELD_ID, F.FIELDABBR, F.FIELDNAME
						  FROM TBL_FIELD F  INNER JOIN XREF_CLUB_FIELD xcf ON xcf.field_id = F.field_id
						 WHERE XCF.CLUB_ID = 1 
						   and f.Active_YN = 'Y'
						 ORDER BY F.FIELDABBR
				</cfquery>
				<SELECT name="GameFieldClub"> 
					<OPTION value="0" selected>Select a Field</OPTION>
					<CFLOOP query="HomeTeamFields">
						<cfif GameFieldID EQ FIELD_ID>
						 	<cfset FieldFound = 1>
							<OPTION value="#FIELD_ID#" selected>#FIELDABBR#</OPTION>
						<cfelse>
							<OPTION value="#FIELD_ID#"		   >#FIELDABBR#</OPTION>
						</cfif>
					</CFLOOP>
					<CFLOOP query="otherFieldValues">
						<cfif GameFieldID EQ FIELD_ID>
						 	<cfset FieldFound = 1>
							<OPTION value="#FIELD_ID#" selected>#FIELDABBR#</OPTION>
						<cfelse>
							<OPTION value="#FIELD_ID#"		   >#FIELDABBR#</OPTION>
						</cfif>
						<!--- <OPTION value="#FIELD_ID#" <cfif GameFieldID EQ FIELD_ID >selected</cfif> >#FIELDABBR#</OPTION> --->
					</CFLOOP>
					<cfif FieldFound EQ 0>
						<cfif Len(trim(GameField)) >
							<OPTION value="#VARIABLES.GameFieldID#" selected>#VARIABLES.FieldAbbr#</OPTION>
						</cfif>
					</cfif>
				</SELECT>
				<cfif (HomeTeamOK + VisitorTeamOK) EQ 2 AND
					  (SESSION.MENUROLEID EQ 19 OR SESSION.MENUROLEID EQ 1) > <!---  19="GAMESCHAIR" 1="ASSTADMIN" --->
					<input type=button name="DispAllFields" onclick="DisplayAllFields()" value="Display ALL Fields">
				</cfif>
			</TD>
		</TR>
		<!--- % if( (uCase(Session("UserID")) = "GAMESCHAIRMAN" or Session("ProfileType") = "SU") ) then % --->
		<cfif (SESSION.MENUROLEID EQ 19 OR SESSION.MENUROLEID EQ 1) > <!---  19="GAMESCHAIR" 1="ASSTADMIN" --->
			<TR id="AllFields" style="Display:none">
				<TD align="right"><b>PlayField</b> <br> <span class="red">(All fields listed)</span> </TD>
				<TD align="left">
					<cfquery name="qAllFields" datasource="#SESSION.DSN#">
						SELECT F.FIELD_ID, F.FIELDABBR, F.FIELDNAME AS FIELD
						  FROM TBL_FIELD F
						 Where FieldAbbr is not NULL 
						   and (Active_YN = 'Y')
						 Order by FieldAbbr
					</cfquery>
					<SELECT name="GameFieldAll"> 
						<OPTION value="0" selected>&nbsp;</OPTION>
							<CFLOOP query="qAllFields">
								<OPTION value="#FIELD_ID#" <cfif GameFieldID EQ FIELD_ID >selected</cfif> >#FIELDABBR#</OPTION>
							</CFLOOP>
							<!--- If ( ucase(trim(Session("RoleCode"))) = "GAMESCHAIR" ) _
								  OR ( ucase(trim(Session("RoleCode"))) = "ASSTADMIN"  ) then --->
							<cfif (SESSION.MENUROLEID EQ 19 OR SESSION.MENUROLEID EQ 1) > <!---  19="GAMESCHAIR" 1="ASSTADMIN" --->
								<cfquery name="otherFieldValues" datasource="#SESSION.DSN#">
									SELECT F.FIELD_ID, F.FIELDABBR, F.FIELDNAME
									  FROM TBL_FIELD F  INNER JOIN XREF_CLUB_FIELD xcf ON xcf.field_id = F.field_id
									 WHERE XCF.CLUB_ID = 1 
									   and f.Active_YN = 'Y'
								</cfquery>
								<CFLOOP query="otherFieldValues">
									<OPTION value="#FIELD_ID#" <cfif GameFieldID EQ FIELD_ID>selected</cfif> >#FIELDABBR#</OPTION>
								</CFLOOP>
							</cfif>
					</SELECT>
				<input type=button name="DispClubFields" onclick="DisplayClubFields()" value="Display CLUB Fields">
				</td>
			</TR>
		</cfif>
		<!---  If ( ucase(trim(Session("RoleCode"))) = "GAMESCHAIR" ) OR ( ucase(trim(Session("RoleCode"))) = "ASSTADMIN"  ) --->
		<cfif (SESSION.MENUROLEID EQ 19 OR SESSION.MENUROLEID EQ 1) > <!---  19="GAMESCHAIR" 1="ASSTADMIN" --->
			<TR><TD align="right"><b>Comments for Referee Assignor</b></TD>
				<TD align="left"><TEXTAREA name="Comments"  rows=3 cols=50>#Trim(Comments)#</TEXTAREA>			</TD>
			</TR>
			<TR><TD align="right"><b>Games Chairman Notes</b></TD>
				<TD align="left"><TEXTAREA name="GamesChairComments" rows=3 cols=50>#Trim(GamesChairComments)#</TEXTAREA>	</TD>
			</TR>
		</cfif>
		<TR><TD>&nbsp;</TD>
			<TD align="left">
				<INPUT type="submit" name="Save"  value="Save & Return to List">
				<!--- If ( ucase(trim(Session("RoleCode"))) = "GAMESCHAIR" ) OR ( ucase(trim(Session("RoleCode"))) = "ASSTADMIN"  ) --->
				<cfif (SESSION.MENUROLEID EQ 19 OR SESSION.MENUROLEID EQ 1) > <!---  19="GAMESCHAIR" 1="ASSTADMIN" --->
					<INPUT type="Submit" name="Delete" value="Delete This Game" >
				</cfif>
				<INPUT type="Submit" name="Back"  value="Cancel" >
			</TD>
		</TR>
	</TABLE>
</FORM>


<script language="javascript">
var cForm = document.Games.all;
//function changeGameDay()
//{   self.document.Games.GameDay.value =	gDOW(DatePart("w", self.document.Games.GameDate.value));
//}
function FlipTeams()
{	var HT, VT;
	var HTID, VTID;
	HT = self.document.Games.HomeTeam.value;
	VT = self.document.Games.VisitorTeam.value;
	self.document.Games.HomeTeam.value		= VT;
	self.document.Games.VisitorTeam.value	= HT;
	HTID = self.document.Games.HomeTeamID.value;
	VTID = self.document.Games.VisitorTeamID.value;
	self.document.Games.HomeTeamID.value	= VTID;
	self.document.Games.VisitorTeamID.value	= HTID;
}

function DisplayAllFields()
{	document.getElementById("ClubFields").style.display = "none";
	document.getElementById("AllFields").style.display = "";
	//cForm("ClubFields").style.display = "none";
	//cForm("AllFields").style.display  = "inline";
//	cForm("GameField").value = cForm("GameFieldAll").value
//	self.document.Games.ClubFields.style.display = "none";
//	self.document.Games.AllFields.style.display  = "inline";
}
function DisplayClubFields()
{	document.getElementById("ClubFields").style.display = "";
	document.getElementById("AllFields").style.display = "none";
	//cForm("ClubFields").style.display = "inline";
	//cForm("AllFields").style.display  = "none";
//	cForm("GameField").value = cForm("GameFieldClub").value
//	self.document.Games.ClubFields.style.display = "inline";
//	self.document.Games.AllFields.style.display  = "none";
}
</script>	
	

</cfoutput>
</div>
<cfinclude template="_footer.cfm">
