<!--- 
	FileName:	fineEdit.cfm
	Created on: 10/13/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
03/25/09 - aarnone - added distinct on select from V_clubs
 --->
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm"> 
<script language="JavaScript" src="DatePicker.js"></script>
<cfoutput>
<div id="contentText">




<cfif isDefined("FORM.PRINT") >		
	<cflocation url="fineDisplay.cfm?fnid=#FORM.FineId#">
</cfif>


<CFIF isDefined("FORM.FINE_ID")>
	<cfset FineId	= FORM.FINE_ID>
<cfelseif isDefined("FORM.FineId")>
	<cfset FineId	= Form.FineId>
<cfelse>
	<cfset FineId	= "">
</CFIF>

<CFIF isDefined("FORM.addFine") >
	<CFSET mode = "ADD">
<CFELSEIF isDefined("FORM.Mode")>
	<cfset Mode	= Form.Mode>
<CFELSE>
	<cfset Mode	= "">
</CFIF>

<CFIF isDefined("FORM.SubMode")>
	<cfset SubMode	= Form.SubMode>
<cfelseif isDefined("FORM.GetGame")>
	<cfset SubMode	= "GETGAME">
<cfelse>
	<cfset SubMode	= "">
</CFIF>

<CFIF isDefined("FORM.GameID")>
	<cfset GameID	= Form.GameID>
<cfelse>
	<cfset GameID	= "">
</CFIF>

<CFIF isDefined("FORM.WhereClause_Clubs")>
	<cfset WhereClause_Clubs	= Form.WhereClause_Clubs>
<cfelse>
	<cfset WhereClause_Clubs	= "">
</CFIF>
<CFIF isDefined("FORM.WhereClause_Teams")>
	<cfset WhereClause_Teams	= Form.WhereClause_Teams>
<cfelse>
	<cfset WhereClause_Teams	= "">
</CFIF>
<CFIF isDefined("FORM.ClubFined")>
	<cfset ClubFined			= Form.ClubFined>
<cfelse>
	<cfset ClubFined			= "">
</CFIF>
<CFIF isDefined("FORM.season_select")>
	<cfset Season_Select			= Form.season_select>
<cfelse>
	<cfset Season_Select			= "">
</CFIF>
<CFIF isDefined("FORM.TeamFined")>
	<cfset TeamFined			= Form.TeamFined>
<cfelse>
	<cfset TeamFined			= "">
</CFIF>
<CFIF isDefined("FORM.Amount")>
	<cfset Amount				= Form.Amount>
<cfelse>
	<cfset Amount				= "">
</CFIF>
<CFIF isDefined("FORM.Status")>
	<cfset Status				= FORM.Status>
<cfelse>
	<cfset Status				= "">
</CFIF>
<CFIF isDefined("FORM.FineType")>
	<cfset FineType			= Form.FineType>
<cfelse>
	<cfset FineType			= "">
</CFIF>
<CFIF isDefined("FORM.Comments")>
	<cfset Comments				= Form.Comments>
<cfelse>
	<cfset Comments				= "">
</CFIF>
<CFIF isDefined("FORM.CheckNo")>
	<cfset CheckNo				= Form.CheckNo>
<cfelse>
	<cfset CheckNo				= "">
</CFIF>
<CFIF isDefined("FORM.ClubFinedName")>
	<cfset ClubFinedName		= Form.ClubFinedName>
<cfelse>
	<cfset ClubFinedName		= "">
</CFIF>
<CFIF isDefined("FORM.ChkRcvdDate")>
	<cfset ChkRcvdDate			= Form.ChkRcvdDate>
<cfelse>
	<cfset ChkRcvdDate			= "">
</CFIF>
<CFIF isDefined("FORM.DivId")>
	<cfset DivId				= Form.DivId>
<cfelse>
	<cfset DivId				= "">
</CFIF>
<CFIF isDefined("FORM.Weekend")>
	<cfset Weekend				= Form.Weekend>
<cfelse>
	<cfset Weekend				= "">
</CFIF>
<CFIF isDefined("FORM.pageURL")>
	<cfset RefererPage			= Form.pageURL>
<cfelse>
	<cfset RefererPage			= "">
</CFIF>
<CFIF isDefined("FORM.AppealAllowed")>
	<cfset AppealAllowed		= Form.AppealAllowed>
<cfelse>
	<cfset AppealAllowed		= "">
</CFIF>


<cfif isDefined("FORM.Paid")    OR  isDefined("FORM.Unpaid")    OR  isDefined("FORM.Invoiced") 
   OR isDefined("FORM.Waived")  OR  isDefined("FORM.Update")    OR isDefined("FORM.Appealed") 
   OR isDefined("FORM.Delete") >  <!--- delete is status="D" --->
	<!--- 
	<cfdump var="#FORM#">
	<br>[#VARIABLES.AMOUNT#] [#FORM.AMOUNT#]
	<br>[#VARIABLES.APPEALALLOWED#] [#FORM.APPEALALLOWED#]
	<br>[#VARIABLES.CHECKNO#] [#form.CHECKNO#]
	<br>[#VARIABLES.CHKRCVDDATE#] [#form.CHKRCVDDATE#]
	<br>[#VARIABLES.CLUBFINED#] [#form.CLUBFINED#]
	<br>[#VARIABLES.CLUBFINEDNAME#] [#form.CLUBFINEDNAME#]
	<br>[#VARIABLES.COMMENTS#] [#form.COMMENTS#]
	<br>[#VARIABLES.DIVID#] [#form.DIVID#]
	<br>[#VARIABLES.FINEID#] [#form.FINEID#]
	<br>[#VARIABLES.FineType#] [#form.FINETYPE#]
	<br>[#VARIABLES.GAMEID#] [#form.GAMEID#]
	<br>[#VARIABLES.MODE#] [#form.MODE#]
	<br>[#VARIABLES.REFERERPAGE#] [#form.REFERERPAGE#]
	<br>[#VARIABLES.STATUS#] [#form.STATUS#]
	<br>[#VARIABLES.SUBMODE#] [#form.SUBMODE#]
	<br>[#VARIABLES.TEAMFINED#] [#form.TEAMFINED#]
	<br>[#VARIABLES.WEEKEND#] [#form.WEEKEND#]
	<br>[#VARIABLES.WHERECLAUSE_CLUBS#] [#form.WHERECLAUSE_CLUBS#]
	<br>[#VARIABLES.WHERECLAUSE_TEAMS#]  [#form.WHERECLAUSE_TEAMS#] 
	--->
	<cfif isDefined("FORM.Delete")>		<!---	do Delete		--->
		<CFSET STATUS = "D"> 
	</cfif>
	<cfif isDefined("FORM.Paid")>		<!---	do PAID		--->
		<CFSET STATUS = "P"> 
	</cfif>
	<cfif isDefined("FORM.Unpaid")>		<!---	do UNPAID   --->
		<CFSET STATUS = "U"> 
	</cfif>
	<cfif isDefined("FORM.Invoiced")>	<!---	do INVOICED --->
		<CFSET STATUS = "I"> 
		</cfif> 
	<cfif isDefined("FORM.Waived")>		<!---	do WAIVED   --->
		<CFSET STATUS = "W"> 
	</cfif>
	<cfif isDefined("FORM.Update")>		<!---	do UPDATE   --->
		<CFSET STATUS = status> 
	</cfif>
	<cfif isDefined("FORM.Appealed")>	<!---	do APPEALED --->
		<CFSET STATUS = "E"> 
	</cfif>
	<!--- <br>STATUS WILL BE CHANGED TO: [#STATUS#]	 --->
	<cfif len(trim(GAMEID)) EQ 0 OR NOT isNumeric(GAMEID)>
		<CFSET GAMEID = 0>
	</cfif>

 	<cfinvoke component="#SESSION.SITEVARS.cfcPath#FINEFEES" method="updateFine">
		<cfinvokeargument name="fineID" 	   value="#VARIABLES.FINEID#"> 
		<cfinvokeargument name="gameID" 	   value="#VARIABLES.GAMEID#"> 
		<cfinvokeargument name="clubID" 	   value="#VARIABLES.CLUBFINED#"> 
		<cfinvokeargument name="TeamID" 	   value="#VARIABLES.TEAMFINED#"> 
		<cfinvokeargument name="fineTypeID"    value="#VARIABLES.FineType#"> 
		<cfinvokeargument name="Amount" 	   value="#VARIABLES.AMOUNT#"> 
		<cfinvokeargument name="Status" 	   value="#VARIABLES.STATUS#"> 
		<cfinvokeargument name="CheckNo" 	   value="#VARIABLES.CHECKNO#"> 
		<cfinvokeargument name="Comments"  	   value="#VARIABLES.COMMENTS#"> 
		<cfinvokeargument name="CheckRcvdDate" value="#VARIABLES.CHKRCVDDATE#"> 
		<cfinvokeargument name="contactID" 	   value="#SESSION.USER.CONTACTID#"> 
		<cfinvokeargument name="AppealAllowedYN" value="#VARIABLES.APPEALALLOWED#"> 
	</cfinvoke>
	
	<cflocation url="finesListAll.cfm?season_select=#season_select#">
</cfif>


<cfif isDefined("FORM.ADD") > 
	<!--- 
	<cfdump var="#FORM#">
	<br>AMOUNT [#VARIABLES.AMOUNT#] [#FORM.AMOUNT#]
	<br>APPEAL [#VARIABLES.APPEALALLOWED#] [#FORM.APPEALALLOWED#]
	<br>CHECKN [#VARIABLES.CHECKNO#] [#form.CHECKNO#]
	<br>CHKRCDT[#VARIABLES.CHKRCVDDATE#] [#form.CHKRCVDDATE#]
	<br>CLUBFN [#VARIABLES.CLUBFINED#] [#form.CLUBFINED#]
	<br>CLUBNAM[#VARIABLES.CLUBFINEDNAME#] [#form.CLUBFINEDNAME#]
	<br>COMMENT[#VARIABLES.COMMENTS#] [#form.COMMENTS#]
	<br>DIVISIO[#VARIABLES.DIVID#] [#form.DIVID#]
	<br>FINEID [#VARIABLES.FINEID#] [#form.FINEID#]
	<br>FINETYP[#VARIABLES.FineType#] [#form.FINETYPE#]
	<br>GAMEID [#VARIABLES.GAMEID#] [#form.GAMEID#]
	<br>MODE [#VARIABLES.MODE#] [#form.MODE#]
	<br>REFPAGE[#VARIABLES.REFERERPAGE#] [#form.REFERERPAGE#]
	<br>STATUS[#VARIABLES.STATUS#] [#form.STATUS#]
	<br>SUBMODE[#VARIABLES.SUBMODE#] [#form.SUBMODE#]
	<br>TEAMFINE[#VARIABLES.TEAMFINED#] [#form.TEAMFINED#]
	<br>WEEKEND[#VARIABLES.WEEKEND#] [#form.WEEKEND#]
	<br>[#VARIABLES.WHERECLAUSE_CLUBS#] [#form.WHERECLAUSE_CLUBS#]
	<br>[#VARIABLES.WHERECLAUSE_TEAMS#]  [#form.WHERECLAUSE_TEAMS#] 
	--->
	
	<cfif len(trim(GAMEID)) EQ 0 OR NOT isNumeric(GAMEID)>
		<CFSET GAMEID = 0>
	</cfif>

	<!--- --->
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#FINEFEES" method="createNewFine">
		<cfinvokeargument name="SeasonID" 	 value="#SESSION.CURRENTSEASON.ID#">
		<cfinvokeargument name="gameID" 	 value="#VARIABLES.GAMEID#">
		<cfinvokeargument name="clubID" 	 value="#VARIABLES.CLUBFINED#">
		<cfinvokeargument name="TeamID" 	 value="#VARIABLES.TEAMFINED#">
		<cfinvokeargument name="fineTypeID"  value="#VARIABLES.FineType#">
		<cfinvokeargument name="Status" 	 value="#VARIABLES.STATUS#">
		<cfinvokeargument name="Amount" 	 value="#VARIABLES.AMOUNT#">
		<cfinvokeargument name="Comments"  	 value="#VARIABLES.COMMENTS#">
		<cfinvokeargument name="contactID" 	 value="#SESSION.USER.CONTACTID#">
		<cfinvokeargument name="AppealAllowedYN" value="#VARIABLES.APPEALALLOWED#">
		<cfinvokeargument name="CheckNo" 	  value="#VARIABLES.CHECKNO#">
		<cfinvokeargument name="CheckRcvDate" value="#VARIABLES.CHKRCVDDATE#">
	</cfinvoke>

	<cflocation url="finesListAll.cfm">	 
</cfif>




<!--- 
StrPos = InstrRev(RefererPage, "/" )
RefererPage = right(RefererPage, len(RefererPage) - StrPos)

if ucase(RefererPage) = "GAMES_REFREPORT.ASP" then
	Game = Trim(Request.Form("GameID"))
End if

' ----------------------------------------------------------------------------------------
' ----   On CLUB Selection, Teams belonging to the CLUB needs to be displayed.
' ----      For this sake, the Page is re-submitted while setting the SubMode to EDIT
' ----      This prevents from fetching FINE information from the Table and instead
' ----      the Fine information stays the same, but the teams are displayed.
' ----------------------------------------------------------------------------------------
 --->
<cfset Mode		= ucase(Mode) >
<cfset SubMode	= ucase(SubMode) >
<cfset btnMode	= "" >
<cfset GameErrMsg = "" >
<cfset DoGetGame  = "" >

<cfswitch expression="#UCASE(Mode)#">
	<cfcase value="ADD">
		<cfset btnVal	 = "Add" >
		<cfset pageTitle = "Add Fine" >
		<cfset FineID	 = 0 >
		<cfset statusDesc = "">
		<cfif SubMode EQ "GETGAME">
			<!--- PAGE Sub-Mode GETGAME: Get the Game Info and Fill the form Default to the HOMETEAM being fined --->
			<cfset DoGetGame = "Y">
		</cfif>
	</cfcase>
	<!--- --------------------------------------------------------------- --->
	<cfcase value="EDIT">
		<cfset btnVal  = "Update" >
		<cfset pageTitle = "Edit Fine" >

		<cfswitch expression="#ucase(SubMode)#">
			<!--- PAGE Sub-Mode GETGAME: Get the Game Info and Fill the form - Default to the HOMETEAM being fined --->
			<cfcase value="GETGAME"> <!--- PAGE Sub-Mode GETTEAMS ---> 
				<cfset DoGetGame = "Y">
			</cfcase>
			<cfcase value="GETTEAMS">
				<CFSET SubMode="GETTEAMS">
			</cfcase>
			<cfdefaultcase> <!---  PAGE Sub-Mode ELSE (DEFAULT) --->
				<cfquery name="getFineDtails" datasource="#SESSION.DSN#">
					SELECT FineType_ID, Amount, status, comments, checkNo, game_id, Club_fined_id, Team_fined_id, 
						   checkRcvDate, appealAllowed_YN, Club_name, teamName, season_id
					  FROM V_FINES
					 WHERE FINE_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.fineID#">
				</cfquery> <!--- <cfdump var="#getFineDtails#"> --->

				<cfif getFineDtails.RECORDCOUNT>
					<cfset GameID		 = getFineDtails.game_id>
					<cfset ClubFined	 = getFineDtails.Club_fined_id>
					<cfset TeamFined	 = getFineDtails.Team_fined_id>
					<cfset Amount		 = getFineDtails.Amount>
					<cfset Status		 = getFineDtails.Status>
					<cfset FineType	 = getFineDtails.FineType_ID>
					<cfset Comments		 = getFineDtails.Comments>
					<cfset CheckNo		 = getFineDtails.CheckNo>
					<cfset ClubFinedName = getFineDtails.Club_name>
					<cfset ChkRcvdDate	 = DateFormat(getFineDtails.checkRcvDate,"mm/dd/yyyy")>
					<cfset AppealAllowed = getFineDtails.appealAllowed_YN>
					<cfset season_select = getFineDtails.season_id>
				<cfelse>
					<cfset GameID		= 0>
					<cfset ClubFined	= "">
					<cfset TeamFined	= "">
					<cfset Amount		= "">
					<cfset Status		= "">
					<cfset Comments		= "">
					<cfset CheckNo		= "">
					<cfset ClubFinedName= "">
					<cfset ChkRcvdDate	= "">
					<cfset AppealAllowed= "">
				</cfif>
				<cfif GameID GT 0>
					<cfset DoGetGame = "Y">
				<cfelse>
					<cfset DoGetGame = "">
				</cfif>

				<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="gFineStatus">
					<cfinvokeargument name="listType" value="FINESTATUS"> 
				</cfinvoke> 

				<CFSWITCH expression="#ucase(status)#">
					<cfcase value="P"> <!--- P = Paid	 --->  <cfset statusDesc = gFineStatus[1][2]> </cfcase>
					<cfcase value="I"> <!--- I = Invoiced ---> <cfset StatusDesc = gFineStatus[2][2]> </cfcase>
					<cfcase value="W"> <!--- W = Waived	--->   <cfset StatusDesc = gFineStatus[3][2]> </cfcase>
					<cfcase value="D"> <!--- D = Deleted --->  <cfset StatusDesc = gFineStatus[4][2]> </cfcase>
					<cfcase value="">  <!---			 --->  <cfset StatusDesc = gFineStatus[5][2]> </cfcase>
					<cfcase value="E"> <!--- E = Appealed ---> <cfset StatusDesc = gFineStatus[6][2]> </cfcase>
					<cfcase value="U"> <!--- U = Unpaid	--->   <cfset StatusDesc = gFineStatus[7][2]> </cfcase>
					<cfdefaultcase>							   <cfset StatusDesc = Status> </cfdefaultcase>
				</CFSWITCH>

				<cfif len(trim(Status)) EQ 0>
					<cfset StatusDesc = gFineStatus[7][2]> <!--- not Paid   was [2][2] --->
				</cfif>

				<cfif len(trim(AMOUNT)) EQ 0 >
					<cfquery name="getFineAmt" datasource="#SESSION.DSN#">
						SELECT DESCRIPTION, Amount 
						  from TLKP_Fine_Type
						 Where FINETYPE_ID = #VARIABLES.FineType#
					</cfquery>
					<cfset FineDesc = getFineAmt.DESCRIPTION & " : $" & getFineAmt.AMOUNT >
					<cfif len(trim(getFineAmt.Amount)) EQ 0>
						<CFSET Amount = getFineAmt.Amount>
					</cfif>
				
				</cfif>
			</cfdefaultcase>
		</cfswitch>
	</cfcase>
</cfswitch>

<cfif DoGetGame EQ "Y">
	<cfif len(trim(gameID)) EQ 0>
		<cfset GameID			= 0 >
		<cfset TeamFined		= "" >
		<cfset ClubFined		= "" >
		<cfset WhereClause_Clubs	= "" >
		<cfset WhereClause_Teams	= "" >
	<cfelse>
		<cfquery name="getGameInfo" datasource="#SESSION.DSN#">
			SELECT Game_ID, GAME_Date,	GAME_Time,   Division, 
				   HOME_TEAM_ID,	HOME_TEAMNAME,	  HOME_CLUB_ID,
				   VISITOR_TEAM_ID, VISITOR_TEAMNAME, Visitor_CLUB_ID
			  FROM V_Games_All
			 WHERE GAME_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.gameID#">
		</cfquery> <!--- <cfdump var="#getGameInfo#"> --->

		<cfif getGameInfo.RECORDCOUNT EQ 0>
			<cfif GameID NEQ 0 >
				<cfset GameErrMsg = "<font color=red>Game " & GameID & " is invalid</font> ">
			</cfif>
			<cfset GameID			    	= 0>
<!---			<cfset TeamFined			= "">
			<cfset ClubFined			= "">
			<cfset WhereClause_Clubs	= "">
			<cfset WhereClause_Teams	= "">--->
		<cfelse>
			<cfset GameID		= getGameInfo.Game_ID>
			<cfset GameDate		= dateFormat(getGameInfo.GAME_Date,"mm/dd/yyyy")>
			<cfset GameTime		= getGameInfo.GAME_Time>
			<cfset Division		= getGameInfo.Division>
			<cfset Home			= getGameInfo.HOME_TEAM_ID>
			<cfset Visitor		= getGameInfo.VISITOR_TEAM_ID>
			<cfset HomeTeam		= getGameInfo.HOME_TEAMNAME>
			<cfset VisitorTeam	= getGameInfo.VISITOR_TEAMNAME>
			<cfset HomeClubID	= getGameInfo.HOME_CLUB_ID>
			<cfset VisitorClubId = getGameInfo.Visitor_CLUB_ID>

			<cfif trim(ClubFined) EQ "">
				<cfset ClubFined = HomeClubID>
				<cfset TeamFined = Home>
			</cfif>
			<!---  When Fine is based on the Game Number then the selection is restricted to the Teams Playing the Game and their Clubs --->
			<cfset WhereClause_Clubs = " Where CLUB_ID in ( " & HomeClubID & ", " & VisitorClubID & ")" >
			<cfset WhereClause_Teams = " Where TEAM_ID in ( " & Home		 & ", " & Visitor		& ")" >
		</cfif>
	</cfif>
</cfif>
 
<H1 class="pageheading">NCSA - #pageTitle#</H1>
<br><!--- <h2>yyyyyy </h2> --->

<FORM name="Fines" action="fineEdit.cfm"  method="post" >
<input type="hidden" name="FineID"				value="#FineId#">
<input type="hidden" name="Mode"				value="#Mode#">
<input type="hidden" name="SubMode"				value="" >
<input type="hidden" name="Status" 				value="" >
<input type="hidden" name="WhereClause_Clubs"	value="#WhereClause_Clubs#">
<input type="hidden" name="WhereClause_Teams"	value="#WhereClause_Teams#">
<input type="hidden" name="RefererPage"			value="#RefererPage#">
<input type="hidden" name="DivId"				value="#DivId#">
<input type="hidden" name="Weekend"				value="#weekend#">

<span class="red">Fields marked with * are required</span>
<CFSET required = "<FONT color=red>*</FONT>">
<table cellspacing="0" cellpadding="2" align="left" border="0" width="100%">
	<tr class="tblHeading">
		<TD colspan="3">Fine ID: #VARIABLES.fineID#		</TD>
	</tr>
	<tr><td width="20%" align="right">	<B>FineID:<B> </TD>
		<td width="05%" >&nbsp;</td>
		<TD width="75%" align="left"> 	#FineId#</font></TD>
	</TR>
	<tr><td colspan="3" align="center"><hr size="1" width="90%"></td>
	</tr>
	<tr><TD align="right">		<b>Game:</B></TD>
		<td >&nbsp;</td>
		<td align="left">
							<input type=text     name="GameID"     value="#GameID#" size="6">
							<cfif ucase(Mode) NEQ "EDIT"><INPUT type="button" name="GetGame1" value="Get Game" onClick="GetGame()" ></cfif>
							#GameErrMsg#
		</td>
	</tr>
	<tr><td>&nbsp;</td>
		<td align="center"><span class="red"> OR </span></td>
		<td>&nbsp;</td>
	</tr>
	<tr><td>&nbsp;</td>
		<td>&nbsp;</td>
		<td><span class="red">
				Select the Club/Team Pair from the list or type ClubName
			</span>
		</td>
	</tr>
	<TR><TD align="right"><b>Club Fined:</B></TD>
		<td >&nbsp;</td>
		<TD align="left">
			<CFQUERY name="qclub" datasource="#SESSION.DSN#">
				SELECT DISTINCT club_id, club_name 
				  from V_Clubs
						#whereClause_Clubs#
						<cfif Mode EQ "EDIT" and whereClause_Clubs NEQ "">
						and club_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ClubFined#">
						</cfif>
				 Order by Club_name
			</CFQUERY> 
			
			<cfif Mode NEQ "EDIT" OR qclub.RecordCount GT 1>
			<SELECT name="ClubFined" onChange="GetTeams()">
				<option value="0" selected>&nbsp;</option>
					<cfloop query="qclub"><option value="#club_id#" <cfif ClubFined EQ club_id>selected</cfif> > #club_name# </option></cfloop> 
			</select>
			<cfelse>
			<input type="text" readonly="readonly" value="#qclub.club_name#" />
			<input type="hidden" value="#qclub.club_id#" name="ClubFined" />
			</cfif>
			
		</TD>
	</TR>
	<TR><TD align="right"><b>Team Fined:</b></TD>
		<td>&nbsp;</td>
		<TD align="left"> 
			<cfif ClubFined GT 0>
				<cfinvoke component="#SESSION.SITEVARS.cfcPath#TEAM" method="getClubTeams" returnvariable="qTeams">
					<cfinvokeargument name="clubID"	 value="#VARIABLES.ClubFined#">
					<cfif season_select NEQ "">
					<cfinvokeargument name="season_id"	 value="#VARIABLES.Season_Select#">
					</cfif>
				</cfinvoke>
				<cfquery name="qGetTeam" dbtype="query">
					SELECT TEAM_ID, TEAMNAMEderived, DIVISION
					  FROM qTeams
					  #WhereClause_Teams#
					  <cfif Mode EQ "EDIT" and WhereClause_Teams NEQ "">
					  and TEAM_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#TeamFined#">
					  </cfif>
					 Order by DIVISION, TEAMNAMEderived
				</cfquery> 		
				
			<cfif Mode NEQ "EDIT" OR qGetTeam.RecordCount GT 1>
				<SELECT name="TeamFined" style="WIDTH: 350px">
					<option value="0" selected>&nbsp;</option>
					<cfloop query="qGetTeam"> 
						<option value="#TEAM_ID#" <cfif TeamFined EQ TEAM_ID>selected</cfif>  >#TEAMNAMEderived# </option> 
					</cfloop>
				</select>
				<cfelse>
					<input type="text" readonly="readonly" value="#qGetTeam.TEAMNAMEderived#" />
					<input type="hidden" value="#qGetTeam.TEAM_ID#" name="TeamFined" />
				</cfif>
			</cfif>
		</TD>
	</TR>
	<tr><td>&nbsp;</td>
		<td align="center"><span class="red"> OR </span></td>
		<td>&nbsp;</td>
	</tr>
	<TR><TD align="right"><b>Club Name:</B></TD>
		<td >&nbsp;</td>
		<TD ><input type=text name="ClubFinedName" value="#ClubFinedName#" size="20" <cfif Mode EQ "EDIT" AND qclub.RecordCount EQ 1> readonly="readonly" </cfif> >	</TD>
	</TR>
	<tr><td colspan="3" align="center"><hr size="1" width="90%"></td>
	</tr>
	<TR><TD align="right"><b>Fine Desc:</b></TD>
		<td >&nbsp;</td>
		<TD align="left">
			<cfquery name="getFineTypes" datasource="#SESSION.DSN#">
				Select FINETYPE_ID, DESCRIPTION, AMOUNT   from TLKP_Fine_Type order by description
			</cfquery>
			<SELECT name="FineType" id="FineType"> 
					<option value="0" data-amount="">--------------Select A Fine--------------</option>
				<cfloop query="getFineTypes"> 
					<option value="#FINETYPE_ID#" data-amount="#Amount#" <cfif FINETYPE_ID EQ FineType>selected</cfif> > #DESCRIPTION# : $#Amount# </option> 
				</cfloop>
			</select>		
		</TD>
	</TR>
	<TR><TD align="right"><B>Fine Amount:</B></TD>
		<td >&nbsp;</td>
		<TD align="left">$ <input type=text name="Amount"  value="#Amount#" size="20"> </TD>
	</TR>
	<TR><TD align="right"><b>Check No</b></TD>
		<td>&nbsp;</td>
		<TD align="left"> <input type=text name="CheckNo"  value="#CheckNo#" size="20"> </TD>
	</TR>
	<TR><TD align="right"><b>Check Rcvd.Date</b></TD>
		<td >&nbsp;</td>
		<!--- <TD align="left">
			<input size="9" name="ChkRcvdDate" value="#ChkRcvdDate#" readonly onclick="javascript:show_calendar('Fines.ChkRcvdDate');"> 
			<a href="javascript:show_calendar('Fines.ChkRcvdDate');" 
					onmouseover="window.status='Date Picker';return true;" 
					onmouseout="window.status='';return true;"><font size=2>mm/dd/yyyy</font>
		</TD> --->
		<TD><input size="9" name="ChkRcvdDate" value="#VARIABLES.ChkRcvdDate#" readonly >
			<input size="3" name="DOW"  value="#DateFormat(VARIABLES.ChkRcvdDate,"ddd")#" disabled>
			&nbsp;
			<cfif isDate(VARIABLES.ChkRcvdDate)>
				<cfset dpMM = datePart("m",VARIABLES.ChkRcvdDate)-1>
				<cfset dpYYYY = datePart("yyyy",VARIABLES.ChkRcvdDate)>
			<cfelse>
				<cfset dpMM = datePart("m",now())-1>
				<cfset dpYYYY = datePart("yyyy",now())>
			</cfif>
			<a href="javascript:show_calendar('Fines.ChkRcvdDate','Fines.DOW','#dpMM#','#dpYYYY#' );" 
					onmouseover="window.status='Date Picker';return true;" 
					onmouseout="window.status='';return true;"> 
				<img src="#SESSION.siteVars.imagePath#cal.gif" width="20" height="18" alt="" border="0">
			</a>
		</TD>
	</TR>
	<TR><TD align="right" valign=top><b>Comments</B></TD>
		<td >&nbsp;</td>
		<TD  align="left"> <TEXTAREA name="Comments"  rows=8 cols=60>#Trim(Comments)#</TEXTAREA> </TD>
	</TR>
	<TR><TD align="right"><b>Status</b></TD>
		<td >&nbsp;</td>
		<TD  align="left"><b> #Trim(StatusDesc)# </TD>
	</TR>
	<TR><TD align="right"><b>Appeal Allowed:</B></TD>
		<td>&nbsp;</td>
		<TD align="left">
			<SELECT name="AppealAllowed">
				<OPTION value="Y" <cfif AppealAllowed EQ "Y">selected</cfif> >YES</OPTION>
				<OPTION value="N" <cfif AppealAllowed EQ "N">selected</cfif> >NO</OPTION>
			</select>
		</TD>
	</TR>
	<tr><td colspan="3" align="center"><hr size="1" width="90%"></td>
	</tr>
	<TR><TD colspan="3" align="center">
	<input type="hidden" name="season_select" value="#season_select#" />
			<INPUT type="submit" name="Paid"	 value="Paid"	  >
			<INPUT type="submit" name="Unpaid"	 value="Unpaid"	  >
			<INPUT type="submit" name="Invoiced" value="Invoiced" >
			<INPUT type="submit" name="Waived"	 value="Waived"	  >
			<CFIF BtnVal EQ "Add">
				<INPUT type="submit" name="Add"	 value="Add" >
			</CFIF>
			<CFIF BtnVal EQ "Update">
				<INPUT type="submit" name="Update"	 value="Update" >
			</CFIF>
			<INPUT type="submit" name="Delete"	 value="Delete"	  >
			<INPUT type="submit" name="Appealed" value="Appealed" <cfif AppealAllowed EQ "Y">disabled</cfif>     >
			<INPUT type="submit" name="Print"	 value="Print"	  >
			<INPUT type="submit" name="Back"	 value="Back"	  onclick="GoBack()">
			<!--- 
			<INPUT type="button" name="Paid"	 value="Paid"	  onClick="GoSubmit('P')" #btnMode#>
			<INPUT type="button" name="Unpaid"	 value="Unpaid"	  onClick="GoSubmit('U')" #btnMode#>
			<INPUT type="button" name="Invoiced" value="Invoiced" onClick="GoSubmit('I')" #btnMode#>
			<INPUT type="button" name="Waived"	 value="Waived"	  onClick="GoSubmit('W')" #btnMode#>
			<INPUT type="button" name="Update"	 value="#BtnVal#" onClick="GoSubmit('')"  #btnMode#>
			<INPUT type="button" name="Delete"	 value="Delete"	  onClick="GoSubmit('D')" #btnMode#>
			<INPUT type="button" name="Appealed" value="Appealed" onClick="GoSubmit('E')" #btnMode# <cfif AppealAllowed EQ "Y">disabled</cfif>     >
			<INPUT type="button" name="Print"	 value="Print"	  onClick="GoPrint()"	 #btnMode#>
			<INPUT type="button" name="Back"	 value="Back"	  onclick="GoBack()">
			 --->
		</TD>
	</TR>
</TABLE>
</FORM>

<script language="javascript">

var cForm = document.Fines.all;

function GoSubmit(param)
{	self.document.Fines.Status.value = param;
	self.document.Fines.submit();
}
function GetGame()
{	self.document.Fines.action		= "fineEdit.cfm";
	self.document.Fines.SubMode.value	= "GETGAME";
	self.document.Fines.submit();
}
function GetTeams()
{	self.document.Fines.action		= "fineEdit.cfm";
	self.document.Fines.SubMode.value	= "GETTEAMS";
	self.document.Fines.submit();
}
function GoPrint()
{	self.document.Fines.action		= "cfmcfmcfm.cfm";
	self.document.Fines.submit();
}
function GoBack()
{	self.document.Fines.action = "finesListAll.cfm";
	self.document.Fines.submit();
}



</script>

<!--- ============================================================================ --->
	
	
	
	
</cfoutput>
</div>
<cfinclude template="_footer.cfm">
<script>
$(function(){
	 $("#FineType").change(function(){
       var selected = $(this).find('option:selected');
       var amount = selected.data('amount'); 
       $('input[name=Amount]').val(amount);
    });
});
</script>
