<!--- 
	FileName:	GameList.cfm
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
1/28/09 - aa - added authorization check
1/30/09 - aa - limited game list to show home games only id club is selected
3/06/09 - aa - ticket:7309 - virtual team changes for state cup and non league games
4/02/09 - aa - tcket:7431 - made sort by Date/Field/Time default - passed sort value to edit page.
5/26/2010 B. Cooper
9292-limit list to current season
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Game List</H1>
<br> <!--- <h2>yyyyyy </h2> --->

<CFIF isDefined("URL.TF") AND URL.TF EQ 1><!--- used to go to a different Edit page --->
	<CFSET swTimeField = true>
<CFELSEIF isDefined("FORM.swTimeField")>
	<CFSET swTimeField = FORM.swTimeField>
<CFELSE>
	<CFSET swTimeField = false>
</CFIF>

<CFIF isDefined("FORM.clubID")>
	<CFSET clubID = FORM.clubID>
<CFELSEIF isDefined("url.cid")>
	<CFSET clubID = url.cid>
<CFELSE>
	<CFSET clubID = 0>
</CFIF>


<cfset swShowClubList = true>
<cfset swEditGame = true>

<!--- If an authorized CLUB is using this page then use their club id --->
<CFIF listFind( SESSION.CONSTANT.CUROLES, trim(SESSION.MENUROLEID) ) GT 0 >
	<!--- we have a club user, check to see if they are authorized,
		  if not auth or function not open, then only VIEW schedule, can't edit game
	 --->
	<cfset swEditGame = false>
	<cfset clubID = SESSION.USER.CLUBID>
	<cfset swShowClubList = false>
	
	<CFIF SESSION.USER.ALLOWSCHEDULEYN EQ "Y">
		<!--- show if option is on --->
		<CFIF isDefined("SESSION.GLOBALVARS.EDITGAMEAUTHCLUB") AND SESSION.GLOBALVARS.EDITGAMEAUTHCLUB EQ "Y">
			<cfset swEditGame = true>
		</CFIF>
	</CFIF>
</CFIF>

<!--- If an authorized CLUB is using this page then use their club id
<CFIF listFind( SESSION.CONSTANT.CUROLES, trim(SESSION.MENUROLEID) ) GT 0 >
	<!--- we have a club user, check to see if they are authorized,
		  if not auth or function not open, then locate to homepage
	 --->
	 <CFSET swAllowAccess = false>
	 <CFIF SESSION.USER.ALLOWSCHEDULEYN EQ "Y">
		<!--- show if option is on --->
		<CFIF isDefined("SESSION.GLOBALVARS.EDITGAMEAUTHCLUB") AND SESSION.GLOBALVARS.EDITGAMEAUTHCLUB EQ "Y">
			<CFSET swAllowAccess = true>
		<CFELSE>
			<CFSET swAllowAccess = false>
		</CFIF>
	<CFELSE>
		<CFSET swAllowAccess = false>
	</CFIF>
	
	<CFIF swAllowAccess>
		<cfset clubID = SESSION.USER.CLUBID>
		<cfset swShowClubList = false>
	<CFELSE>
		<cflocation url="loginhome.cfm?rid=#SESSION.menuroleid#">
	</CFIF>
</CFIF> --->


<CFIF isDefined("FORM.selDiv")>
	<CFSET selDiv = FORM.selDiv>
<CFELSEIF isDefined("URL.div")>
	<CFSET selDiv = URL.div>
<CFELSE>
	<CFSET selDiv = "">
</CFIF>

<CFIF isDefined("FORM.sortBy")>
	<CFSET sortBy = FORM.sortBy>
<CFELSEIF isDefined("URL.sort")>
	<CFSET sortBy = URL.sort>
<CFELSE>
	<CFSET sortBy = "DATEFABBRTIME">
</CFIF>



<CFIF isDefined("URL.gg") AND URL.gg EQ 1>
	<CFSET swGetGames = true>
<cfelse>
	<CFSET swGetGames = false>
</CFIF>


<CFIF isDefined("URL.gidok")>
	<CFSET hiLiteGameid = gidok>
<cfelse>
	<CFSET hiLiteGameid = 0>
</CFIF>


<CFIF isDefined("FORM.WeekendListFROM")>
	<CFSET selWeekEndfrom = dateFormat(FORM.WeekendListFROM,'mm/dd/yyyy')>
<CFELSEIF isDefined("URL.wefrom")>
	<CFSET selWeekEndfrom = dateFormat(URL.wefrom,'mm/dd/yyyy')>
<CFELSE>
	<CFSET selWeekEndfrom = "">
</CFIF>
<CFIF isDefined("FORM.WeekendListTO")>
	<CFSET selWeekEndto = dateFormat(FORM.WeekendListTO,'mm/dd/yyyy')>
<CFELSEIF isDefined("URL.weto")>
	<CFSET selWeekEndto = dateFormat(URL.weto,'mm/dd/yyyy')>
<CFELSE>
	<CFSET selWeekEndto = "">
</CFIF>
 
<CFIF isDefined("FORM.editGame")>
	<CFIF isDefined("FORM.gameID")>
		<CFIF swTimeField>
	 		<cflocation url="gameEditTimeField.cfm?gid=#FORM.GAMEID#&cid=#variables.clubID#&div=#variables.selDiv#&wefrom=#variables.selWeekEndfrom#&weto=#variables.selWeekEndto#&sort=#sortBy#">	
		<CFELSE>
			<cflocation url="gameEdit.cfm?gid=#FORM.GAMEID#&cid=#variables.clubID#&div=#variables.selDiv#&wefrom=#variables.selWeekEndfrom#&weto=#variables.selWeekEndto#&sort=#sortBy#">	
		</CFIF>
 	</CFIF>
</CFIF>

<CFSET swShowDownLoad = false>

<cfif isdefined("FORM.getGames") OR swGetGames>
	<CFIF clubID EQ "ALL">
		<CFSET getClub = 0>
	<CFELSE>
		<CFSET getClub = clubID>
	</CFIF>		
	<cfif selDiv eq 0>
		<CFSET getDiv = "">
	<cfelse>
		<CFSET getDiv = selDiv>
	</cfif>
	<CFSET getWEfrom = selWeekEndfrom>
	<CFSET getWEto = selWeekEndto>

	<cfinvoke component="#SESSION.sitevars.cfcPath#game" method="getGameSchedule" returnvariable="qGames">
	 	<cfinvokeargument name="clubID"   value="#VARIABLES.getClub#">
		<cfinvokeargument name="swHomeGameOnly" value="true" >
		<cfinvokeargument name="division" value="#VARIABLES.getDiv#">
		<cfinvokeargument name="fromDate" value="#VARIABLES.getWEfrom#">
		<cfinvokeargument name="toDate" value="#VARIABLES.getWEto#">
		<cfinvokeargument name="orderBy" value="#VARIABLES.sortby#">
		<cfinvokeargument name="seasonID" value="#session.currentseason.id#">
	</cfinvoke>  

	<!--- create download file --->	
	<CFIF isDefined("qGames") AND qGames.RECORDCOUNT >
		<CFSET tempfile = "#GetDirectoryFromPath(ExpandPath("*.*"))#downloads\#SESSION.USER.CONTACTID#GamesSched.csv" >
	
		<CFSET output = "">
		<CFSET output = output & "GameID,Num,Div,Date,Time,Field,Visitor,TeamV,Home,TeamH" >
		<cfscript>
           if (FileExists(#tempfile#) )
		   {	FileDelete(#tempfile#);
		   }
        </cfscript>

		<CFFILE ACTION="WRITE"  FILE="#tempfile#" OUTPUT="#output#" nameconflict="OVERWRITE" >
		<CFLOOP query="qGames">
			<CFSET output = "">
			<CFSET output = output & "#game_ID#,#game_CODE#,#Division#,#dateFormat(game_date,"mm/dd/yyyy")#,#timeFormat(game_time,"hh:mm tt")#,#fieldAbbr#,#Visitor_Team_ID#,#Visitor_TeamName#,#Home_Team_ID#,#Home_TeamName#">
			<CFFILE ACTION="APPEND" FILE="#tempfile#" OUTPUT="#output#" >
		</CFLOOP>
		<CFSET swShowDownLoad = true>
	</CFIF>
</cfif>	


<FORM name="gamelist" action="GameList.cfm" method="post" id="formgamelist">
	<input type="Hidden" name="clubID" value="#variables.clubID#">
	<input type="Hidden" name="selDiv" value="#variables.selDiv#">
	<input type="Hidden" name="selWeekEndFROM" value="#variables.selWeekEndfrom#">
	<input type="Hidden" name="selWeekEndTO" value="#variables.selWeekEndto#">
	<input type="Hidden" name="swTimeField" value="#variables.swTimeField#">

	<table cellpadding="1" cellspacing="1" border="0" width="800px" >
		<tr><td valign="middle">
				<CFIF swShowClubList>
					<!--- ---------------------------------------------
					 -----------  Selection by the CLUB ----------	--->
					<cfinvoke component="#SESSION.SITEVARS.cfcPath#club" method="getClubInfo" returnvariable="qClubs">
						<cfinvokeargument name="orderBy" value="clubname">
					</cfinvoke>		<!--- sql = "Select Id, Club from V_Clubs trim(gWhereClause_Clubs) Order by Club, ID" --->
					<b>Select Club: </b><br>
					<SELECT name="ClubsList" onchange="GetClubs()" ID="Select1">  
						<!--- <OPTION value="0"   <cfif clubID EQ 0 >selected</cfif> >Select Club</OPTION> --->
						<OPTION value="ALL" <cfif clubID EQ "ALL" >selected</cfif> >ALL Clubs</OPTION>
						<CFLOOP query="qClubs">
							<OPTION value="#Club_ID#" <cfif clubID EQ CLUB_ID>selected</cfif> >#Club_Name#</OPTION>
						</CFLOOP>
					</SELECT>
				</CFIF>
			</td>
			
			<td valign="middle">
				<!--- --------------------------------------------------
				-----------  Selection by the Division/Weekend	--->
				<cfinvoke component="#SESSION.SITEVARS.cfcPath#game" method="getGameDivisions" returnvariable="qGameDivs">
					<cfinvokeargument name="clubID" value="#VARIABLES.clubID#">
				</cfinvoke>		<!--- sql = "Select distinct Division from V_Games Order By Division" --->
				<b>Division: </b><br>
				<SELECT name="DivisionList" onchange="GetDiv()" ID="Select2"> > 
					<!--- <OPTION value="0"   <cfif selDiv EQ 0>selected</cfif> >Select Division</OPTION> --->
					<OPTION value="ALL" <cfif selDiv EQ "ALL">selected</cfif> >ALL Divisions</OPTION>
					<CFLOOP query="qGameDivs">
						<OPTION value="#Division#" <cfif selDiv EQ Division >selected</cfif> >#Division#</OPTION>
					</CFLOOP>
				</SELECT>
			</td>
			
			<td valign="middle">
				<CFIF selDiv EQ 0>
					<CFSET invokeDiv = "">
				<CFELSEIF selDiv EQ "ALL">
					<CFSET invokeDiv = "">
				<CFELSE>
					<CFSET invokeDiv = selDiv >
				</CFIF>
				<cfinvoke component="#SESSION.SITEVARS.cfcPath#game" method="getGameDates" returnvariable="gGameDates">
					<cfinvokeargument name="division" value="#invokeDiv#">
					<cfinvokeargument name="seasonID" value="#session.currentseason.id#">
				</cfinvoke> <!--- argument name="division" --->
				<b>From: </b><br>
				<SELECT name="WeekendListFROM"> 
					<!--- <OPTION value=""    <CFIF selWeekEnd EQ "">selected</CFIF> >Select Weekend</OPTION> --->
					<!--- <OPTION value="ALL" <CFIF selWeekEndFROM EQ "ALL">selected</CFIF> >Show ALL Weekends</OPTION> --->
					<OPTION value="">From Date </OPTION>
					<CFLOOP query="gGameDates">
						<CFSET showDate = dateFormat(Game_Date,'mm/dd/yyyy')>
						<OPTION value="#showDate#" <CFIF selWeekEndFrom EQ showDate>selected</CFIF> > #showDate# </OPTION>
					</CFLOOP>
				</SELECT>
			</td>
			
			<td valign="middle">
				<b>To: </b><br>
				<SELECT name="WeekendListTO"> 
					<!--- <OPTION value=""    <CFIF selWeekEnd EQ "">selected</CFIF> >Select Weekend</OPTION> --->
					<!--- <OPTION value="ALL" <CFIF selWeekEndTo EQ "ALL">selected</CFIF> >Show ALL Weekends</OPTION> --->
					<OPTION value="">To Date </OPTION>
					<CFLOOP query="gGameDates">
						<CFSET showDate = dateFormat(Game_Date,'mm/dd/yyyy')>
						<OPTION value="#showDate#" <CFIF selWeekEndTo EQ showDate>selected</CFIF> > #showDate# </OPTION>
					</CFLOOP>
				</SELECT>
			</td>
			
			<td valign="middle">
				<b>Sort By: </b><br>
				<select name="sortBy" >
					<option value="DATEFABBRTIME">Date/Field/Time</option>
					<option value="DIVISION" <cfif sortBy EQ "DIVISION">selected</cfif> >Division</option>
					<option value="GAME" <cfif sortBy EQ "GAME">selected</cfif> >Game</option>
					<option value="HOMETEAM" <cfif sortBy EQ "HOMETEAM">selected</cfif> >HomeTeam</option>
					<option value="VISITEAM" <cfif sortBy EQ "VISITEAM">selected</cfif> >VisitingTeam</option>
					<option value="FIELDABBR" <cfif sortBy EQ "FIELDABBR">selected</cfif> >Field</option>
				</select>
			</td>
			<td valign="middle">
				<INPUT type="submit" name="getGames" value="Go">
			</td>
		</tr>
		<cfif swShowDownLoad>
			<tr><td colspan="6" align="right">
					<a href="#SESSION.SITEVARS.HOMEHTTP#/downloads/#SESSION.USER.CONTACTID#GamesSched.csv">Download Schedule</a>
					<br>(IE users, please save the file before opening it.)
				</td>
			</tr>
		</cfif>
	</table>

	<CFIF isDefined("qGames") AND qGames.RECORDCOUNT >
		<cfinvoke component="#SESSION.SITEVARS.cfcPath#globalVars" method="getListX" returnvariable="gameType">
			<cfinvokeargument name="listType" value="GAMETYPE">
		</cfinvoke>	
		<table cellspacing="0" cellpadding="2" align="left" border="0" width="830px" >
			<tr class="tblHeading">
				<TD width="15%" align="center"> Date/Time</TD>
				<TD width="05%" align="center"> Type</TD>
				<TD width="07%"> Game</TD>
				<TD width="07%"> Div </TD>
				<TD width="22%"> Home Team</TD>
				<TD width="22%"> Visiting Team</TD>
				<TD width="22%"> Field Abbr</TD>
			</TR> 
		</table>
		<br><br><br>

		<div class="overflowbox" style="height:450px;">
		<!---<div style="overflow:auto; height:450px; border:1px ##cccccc solid;"> --->
		<table cellspacing="0" cellpadding="2" align="left" border="0" width="800px" >
		<!--- <tr class="tblHeading">
				<TD width="15%" align="center"> Date/Time</TD>
				<TD width="05%" align="center"> Type</TD>
				<TD width="07%"> Game</TD>
				<TD width="07%"> Div </TD>
				<TD width="22%"> Home Team</TD>
				<TD width="22%"> Visiting Team</TD>
				<TD width="22%"> Field Abbr</TD>
			</TR> ---> 
			<CFLOOP query="qGames">
				<cfif GAME_ID eq hiLiteGameid>
					<tr bgcolor="##EAF5FF">
				<CFELSE>
					<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
				</cfif>
					<TD width="15%"  class="tdUnderLine">
						<cfif swEditGame>
							<input type="Radio" name="gameID" value="#Game_ID#">  
						</cfif>
						#UCASE(DATEFORMAT(GAME_DATE,"ddd"))# 
						&nbsp; #DATEFORMAT(GAME_DATE,"mm/dd/yy")# 
						<br> #repeatString("&nbsp;",15)#
						#TIMEFORMAT(GAME_TIME,"hh:mm tt")# 
					</TD>
					<TD width="05%" class="tdUnderLine"> 
						<cfswitch expression="#game_type#">
							<cfcase value="F">Friendly</cfcase>
							<cfcase value="C">State Cup</cfcase>
							<cfcase value="P">Playoff</cfcase>
							<cfcase value="N">Non League</cfcase>
							<cfdefaultcase>&nbsp;</cfdefaultcase>
						</cfswitch>
					</TD>
					<TD width="07%" class="tdUnderLine"> #Game_ID#	</TD>
					<td width="07%" class="tdUnderLine"> &nbsp; #DIVISION#				</td>
					<TD width="22%" class="tdUnderLine"> &nbsp; <cfif len(trim(HOME_TEAMNAME))>   #HOME_TEAMNAME#    </cfif></TD>
					<TD width="22%" class="tdUnderLine"> &nbsp; <cfif len(trim(VISITOR_TEAMNAME))>#VISITOR_TEAMNAME#<CFELSE>#Virtual_TeamName#</cfif></TD>
					<TD width="22%" class="tdUnderLine"> &nbsp; #FIELDABBR#</TD>
				 </TR>
			</CFLOOP>
		</TABLE>
		</div>
		<cfif swEditGame>
			<table cellspacing="0" cellpadding="5" align="left" border="0" width="825px" >
				<tr><td colspan="6" align="center">
						<input type="submit" name="editGame" value="Edit Game">
					</td>
				</tr>
			</TABLE>
		</cfif>
	<CFELSEIF  isDefined("qGames") AND qGames.RECORDCOUNT EQ 0>
		<table cellspacing="0" cellpadding="2" align="left" border="0" width="830px">
			<tr><TD><span class="red">There are no games found.</span></TD></tr>
		</table>	
	</CFIF>
</FORM>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">

	

<script language="javascript">
function GetClubs()
{	self.document.gamelist.clubID.value =	self.document.gamelist.ClubsList.value;
	self.document.gamelist.action = "GameList.cfm";
	self.document.gamelist.submit();
}
function GetDiv()
{	self.document.gamelist.selDiv.value =	self.document.gamelist.DivisionList.value;
	self.document.gamelist.action = "GameList.cfm";
	self.document.gamelist.submit();
}
</script>





