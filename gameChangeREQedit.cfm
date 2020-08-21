<!--- 
	FileName:	gameChangeREQedit.cfm
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
01/19/09 - aa - removed "inline" from the display for fields because it was shifting the 3 cells into 1 column.
02/02/09 - AA - redirect to list instead of staying on same page after submitting changes
03/06/09 - aarnone - ticket:7309 - virtual team changes for state cup and non league games
05/26/09 - aarnone - ticket:7663 - limit the comments to 500 chars.
09/16/2014 - jdanz - NCSA14432 - moved the checking of the game request change to after we process the submit button to pull correct data and populate the fields accordingly.
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm"> 
<script language="JavaScript" src="DatePicker.js"></script>
<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Game Change Request</H1>
<br><!--- <h2>yyyyyy </h2> --->

<cfset msg = "">
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="stTimeParams">
	<cfinvokeargument name="listType" value="DDHHMMTT"> 
</cfinvoke> 




<!--- moved up here from below--->
<CFIF isDefined("URL.GID") AND isNumeric(URL.GID)>
	<CFSET gameID = URL.GID>
<CFELSEIF isDefined("FORM.GAMEID") AND isNumeric(FORM.GAMEID)> 
	<CFSET gameID = FORM.GAMEID>
<CFELSE> 
	<CFSET gameID = 0>
</CFIF>

<CFIF isDefined("URL.TID") AND isNumeric(URL.TID)>
	<CFSET teamID = URL.TID>
<CFELSEIF isDefined("FORM.TEAMID") AND isNumeric(FORM.TEAMID)> 
	<CFSET teamID = FORM.TEAMID>
<CFELSE> 
	<CFSET teamID = 0>
</CFIF>

<!--- get game info --->
<cfinvoke component="#SESSION.SITEVARS.cfcPath#GAME" method="getGameSchedule" returnvariable="qGameInfo">
	<cfinvokeargument name="gameID"		value="#VARIABLES.gameID#">
</cfinvoke>

<cfset GameDate		 = DateFormat(qGameInfo.game_date,"mm/dd/yyyy") >
<cfset GameTime		 = TimeFormat(qGameInfo.game_time,"hh:mm tt") >
<cfset GameType		 = qGameInfo.Game_Type >
<cfset GameField	 = qGameInfo.fieldName >
<cfset GameFieldID	 = qGameInfo.FIELD_ID >
<cfset GameFieldAbbr = qGameInfo.fieldAbbr >
<cfset Division		 = qGameInfo.Division >
<cfset HomeTeamId	 = qGameInfo.Home_Team_ID >
<cfset VisitorTeamId = qGameInfo.Visitor_Team_ID >
<cfset HomeTeam		 = qGameInfo.Home_TeamName >
<cfset VisitorTeam	 = qGameInfo.Visitor_TeamName >
<cfset VirtualTeamName = qGameInfo.Virtual_TeamName >

<cfset ChangeRequestId	= 0>
<cfset NewGameDate		= DateFormat(qGameInfo.Game_Date,"mm/dd/yyyy") >
<cfset NewGameTime		= DateFormat(qGameInfo.Game_Date,"mm/dd/yyyy") & " " & TimeFormat(qGameInfo.Game_Time,"hh:mm tt") >
<cfset NewGameField		= qGameInfo.FieldName>
<cfset NewGameFieldAbbr	= qGameInfo.FieldAbbr>
<cfset Comments			= "">

<cfset timePart      = timeFormat(NewGameTime,"hh:mm tt")>
<cfset GameNewHour	 = listFirst(timePart,":")>
<cfset GameNewMinute = listLast(listFirst(timePart," "),":")>
<cfset GameNewMeridian	= ListLast(timePart," ")>

<CFIF isDefined("FORM.BACK")>
	<cflocation url="gameRequestList.cfm?tid=#FORM.teamID#">
</CFIF>

<CFIF isDefined("FORM.SubmitChanges")>
	<!--- START - SubmitChanges --->
	<CFIF isDefined("FORM.NewGameDate") AND isDate(FORM.NewGameDate)>
		<cfset newDate = FORM.NewGameDate>
	<cfelse>
		<cfset msg = "Date is missing or is not valid.">
	</CFIF>
	<CFIF isDefined("FORM.GameNewHour") AND isNumeric(FORM.GameNewHour)>
		<cfset newHour = FORM.GameNewHour>
	</CFIF>
	<CFIF isDefined("FORM.GameNewMinute") AND isNumeric(FORM.GameNewMinute)>
		<cfset newMinute = FORM.GameNewMinute>
	</CFIF> 
	<CFIF isDefined("FORM.GameNewMeridian")>
		<cfset newMeridian =  FORM.GameNewMeridian>
	</CFIF>
	<cfset NewTime = NewHour & ":" & NewMinute & " " & NewMeridian>

	<CFIF isDefined("FORM.GameFieldClub") AND isNumeric(FORM.GameFieldClub)>
		<cfset newFieldID = FORM.GameFieldClub> 
	<cfelse>
		<cfset msg = msg & "<br>field is required.">
	</CFIF> 

	<CFIF isDefined("Form.Comments") AND LEN(TRIM(Form.Comments)) GT 0>
		<cfset Comments = left(Form.Comments,500)>
	<cfelse>
		<cfset msg = msg & "<br>Reason for change is required.">
	</CFIF>
	<CFIF isDefined("Form.ChangeRequestId")>
		<cfset ChangeRequestId = FORM.ChangeRequestId>
	</CFIF>
	<CFIF isDefined("Form.GameId")>
		<cfset GameId = FORM.GameId>
	</CFIF>
	<CFIF isDefined("Form.HomeTeamID")>
		<cfset HomeTeamID = FORM.HomeTeamID>
	</CFIF>
	<CFIF isDefined("Form.VisitorTeamID")>
		<cfset VisitorTeamID = FORM.VisitorTeamID>
	</CFIF>
	
	<CFQUERY name="getRequestingTeam" datasource="#SESSION.DSN#">
		SELECT TEAM_ID, TEAMNAME from tbl_team where 
		team_Id in(#VisitorTeamId#,#HomeTeamID#) and
		club_id = #SESSION.USER.CLUBID#
	</CFQUERY>
	<cfset requestByTeam = getRequestingTeam.team_id>
	<CFIF NOT Len(Trim(msg))>
		<cfset ChangeError = 0>
		<!---  03/18/09 - AA - took out check to see if team is playing a game on that date if needed in future, create module that can be used everywhere.
		<!--- Does Team Already have a Game the same date --->
		<CFQUERY name="findAnotherGame" datasource="#SESSION.DSN#">
			Select Game_id from V_Games
			 where Game_id <> #GameID#
			   and Game_Date = <cfqueryparam cfsqltype="CF_SQL_DATE" value="#newDate#">
			   and (   HOME_TEAM_ID    =  <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#HomeTeamID#">
					or VISITOR_TEAM_ID =  <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VisitorTeamID#">
					)
		</CFQUERY>
		

		<CFIF findAnotherGame.RECORDCOUNT>
			<CFSET ChangeError = 1>
			<CFSET GameIDScheduled = findAnotherGame.GAME_ID>
			<CFSET msg = msg & "Home/Visitor side already has a game <u>" & GameIDScheduled & "</u> on new date <u>" & NewGameDate & "</u>.">
		</CFIF>
		
		<!--- Does GameTime Overlaps an scheduled game --->
		<cfif (Hour(NewTime) - 2) LT 0 >
			<cfset GameTimeLL = "00"  & ":" & NewMinute>
		<cfelse>
			<cfset GameTimeLL = (Hour(NewTime) - 2) & ":" & NewMinute>
		</cfif>

		<cfif (Hour(NewTime) + 2) GT 23 >
			<CFSET GameTimeUL = "23"  & ":" & NewMinute >
		<cfelse>
			<CFSET GameTimeUL = (Hour(NewTime) + 2) & ":" & NewMinute >
		</cfif>

		<CFQUERY name="findOverlapGame" datasource="#SESSION.DSN#">
			Select GAME_ID from V_Games
			 where GAME_ID  <> #GameID#
			   and GAME_DATE = <cfqueryparam cfsqltype="CF_SQL_DATE" value="#newDate#">
			   and FIELD_ID  = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#newFieldID#">
		 	   and gTime between '#GameTimeLL#' and '#GameTimeUL#'
		</CFQUERY>

		<CFIF findOverlapGame.RECORDCOUNT>
			<cfset ChangeError = 2>
			<cfset GameIDScheduled = findOverlapGame.GAME_ID>
			<cfset msg = msg & "New Time overlaps already scheduled time for game " & GameIDScheduled & ". "> 
		</CFIF> --->
		
		<CFIF ChangeError EQ 0>
			<CFIF ChangeRequestId EQ 0 >
				<cfstoredproc procedure="p_insert_game_change_request" datasource="#SESSION.DSN#">
					<cfprocparam dbvarname="@game_ID"		  cfsqltype="CF_SQL_INTEGER" value="#VARIABLES.GameId#">
					<cfprocparam dbvarname="@newDate"		  cfsqltype="CF_SQL_DATE"	 value="#dateFormat(VARIABLES.NewDate,"mm/dd/yyyy")#">
					<cfprocparam dbvarname="@newTime"		  cfsqltype="CF_SQL_VARCHAR" value="#timeformat(VARIABLES.NewTime,"hh:mm:ss tt")#"> 
					<cfprocparam dbvarname="@newField"		  cfsqltype="CF_SQL_INTEGER" value="#VARIABLES.NewFieldID#">
					<cfprocparam dbvarname="@requestDate"	  cfsqltype="CF_SQL_DATE"	   value="#dateFormat(now(),"mm/dd/yyyy")#">
					<cfprocparam dbvarname="@requestTime"	  cfsqltype="CF_SQL_VARCHAR"  value="#timeformat(now(),"hh:mm:ss tt")#"> 
					<cfprocparam dbvarname="@AcceptedByVisitor" cfsqltype="CF_SQL_VARCHAR"   value="N">
					<cfprocparam dbvarname="@comments"		  cfsqltype="CF_SQL_LONGVARCHAR" value="#VARIABLES.Comments#">
				<!---	<cfprocparam dbvarname="@requestedByTeam" cfsqltype="CF_SQL_INTEGER" value="#SESSION.USER.CLUBID#"> --->
					<cfprocparam dbvarname="@requestedByTeam" cfsqltype="CF_SQL_INTEGER" value="#requestByTeam#">
					<cfprocparam dbvarname="@createdBy"		  cfsqltype="CF_SQL_INTEGER" value="#SESSION.USER.CONTACTID#">
					<cfprocparam dbvarname="@game_change_request_id_val" cfsqltype="CF_SQL_INTEGER" variable="game_change_Request_id" type="Out">
				</cfstoredproc> 
				
			<CFELSE>
				<!---  log record before change --->
				<cfstoredproc procedure="p_LOG_Game_Change_Request" datasource="#SESSION.DSN#">
					<cfprocparam dbvarname="@game_change_request_id"  cfsqltype="CF_SQL_INTEGER" value="#VARIABLES.ChangeRequestID#">
					<cfprocparam dbvarname="@contactID"				  cfsqltype="CF_SQL_INTEGER" value="#SESSION.USER.CONTACTID#">
				</cfstoredproc>
				
				<CFQUERY name="qUpdateGameRequest" datasource="#SESSION.DSN#">
					Update  TBL_GAME_CHANGE_REQUEST
					   set  NewTime	 = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#dateFormat(VARIABLES.NewDate,"mm/dd/yyyy")# #timeformat(VARIABLES.NewTime,"hh:mm:ss tt")#"> 
						 ,  NewDate	 = <cfqueryparam cfsqltype="CF_SQL_DATE" value="#dateFormat(VARIABLES.NewDate,"mm/dd/yyyy")#">
						 ,  NewField = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#VARIABLES.NewFieldID#">
						 ,  Comments = <cfqueryparam cfsqltype="CF_SQL_LONGVARCHAR" value="#VARIABLES.Comments#">
						 ,  RequestDate = getDate()
						 ,  RequestTime = getDate()
					 Where  game_Change_Request_Id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#VARIABLES.ChangeRequestID#">
				</CFQUERY>
			</CFIF>
			<CFSET msg = msg & "<br>This game request has been submitted.">
			<!--- <CFlocation url="gameRequestList.cfm?tid=#FORM.teamID#" addtoken="No"> --->
			
			
			
			
		</CFIF>
	<CFELSE>
			save values...
			<cfset GameFieldID = newFieldID>
			<cfset NewGameDate = newDate>
			<cfset GameNewHour = newHour>
			<cfset GameNewMinute = newMinute>
			<cfset GameNewMeridian = newMeridian>


	
	</CFIF>
	<!--- END - SubmitChanges --->
</CFIF>

<cfquery name="qGameRequest" datasource="#SESSION.DSN#">
	SELECT GAME_CHANGE_REQUEST_ID, NEWDATE, NEWTIME, NEWFIELD, COMMENTS
	  FROM TBL_GAME_CHANGE_REQUEST
	 WHERE GAME_ID = #VARIABLES.gameID#
	   AND APPROVED IS NULL
	 ORDER BY REQUESTDATE DESC
</cfquery>

<CFIF qGameRequest.RECORDCOUNT>
	<cfset ChangeRequestID	= qGameRequest.GAME_CHANGE_REQUEST_ID>
	<cfset NewGameDate		= DateFormat(qGameRequest.NewDate,"mm/dd/yyyy") >
	<cfset NewGameTime		= DateFormat(qGameRequest.NewDate,"mm/dd/yyyy") & " " & TimeFormat(qGameRequest.NewTime,"hh:mm tt") >
	<cfset NewGameField		= qGameRequest.NewField>
	<cfset Comments			= qGameRequest.Comments>
	<cfset GameFieldID	 	= qGameRequest.NewField>
	
	<cfset timePart      = timeFormat(NewGameTime,"hh:mm tt")>
	<cfset GameNewHour	 = listFirst(timePart,":")>
	<cfset GameNewMinute = listLast(listFirst(timePart," "),":")>
	<cfset GameNewMeridian	= ListLast(timePart," ")>
</CFIF>

<!---
<CFIF isDefined("URL.GID") AND isNumeric(URL.GID)>
	<CFSET gameID = URL.GID>
<CFELSEIF isDefined("FORM.GAMEID") AND isNumeric(FORM.GAMEID)> 
	<CFSET gameID = FORM.GAMEID>
<CFELSE> 
	<CFSET gameID = 0>
</CFIF>

<CFIF isDefined("URL.TID") AND isNumeric(URL.TID)>
	<CFSET teamID = URL.TID>
<CFELSEIF isDefined("FORM.TEAMID") AND isNumeric(FORM.TEAMID)> 
	<CFSET teamID = FORM.TEAMID>
<CFELSE> 
	<CFSET teamID = 0>
</CFIF>

<!--- get game info --->
<cfinvoke component="#SESSION.SITEVARS.cfcPath#GAME" method="getGameSchedule" returnvariable="qGameInfo">
	<cfinvokeargument name="gameID"		value="#VARIABLES.gameID#">
</cfinvoke>

<cfset GameDate		 = DateFormat(qGameInfo.game_date,"mm/dd/yyyy") >
<cfset GameTime		 = TimeFormat(qGameInfo.game_time,"hh:mm tt") >
<cfset GameType		 = qGameInfo.Game_Type >
<cfset GameField	 = qGameInfo.fieldName >
<cfset GameFieldID	 = qGameInfo.FIELD_ID >
<cfset GameFieldAbbr = qGameInfo.fieldAbbr >
<cfset Division		 = qGameInfo.Division >
<cfset HomeTeamId	 = qGameInfo.Home_Team_ID >
<cfset VisitorTeamId = qGameInfo.Visitor_Team_ID >
<cfset HomeTeam		 = qGameInfo.Home_TeamName >
<cfset VisitorTeam	 = qGameInfo.Visitor_TeamName >
<cfset VirtualTeamName = qGameInfo.Virtual_TeamName >

<!--- is ther an existing Game Request? --->
<cfquery name="qGameRequest" datasource="#SESSION.DSN#">
	SELECT GAME_CHANGE_REQUEST_ID, NEWDATE, NEWTIME, NEWFIELD, COMMENTS
	  FROM TBL_GAME_CHANGE_REQUEST
	 WHERE GAME_ID = #VARIABLES.gameID#
	   AND APPROVED IS NULL
	 ORDER BY REQUESTDATE DESC
</cfquery>

<CFIF qGameRequest.RECORDCOUNT>
	<cfset ChangeRequestID	= qGameRequest.GAME_CHANGE_REQUEST_ID>
	<cfset NewGameDate		= DateFormat(qGameRequest.NewDate,"mm/dd/yyyy") >
	<cfset NewGameTime		= DateFormat(qGameRequest.NewDate,"mm/dd/yyyy") & " " & TimeFormat(qGameRequest.NewTime,"hh:mm tt") >
	<cfset NewGameField		= qGameRequest.NewField>
	<cfset Comments			= qGameRequest.Comments>
	<cfset GameFieldID	 	= qGameRequest.NewField>
<CFELSE>
	<cfset ChangeRequestId	= 0>
	<cfset NewGameDate		= DateFormat(qGameInfo.Game_Date,"mm/dd/yyyy") >
	<cfset NewGameTime		= DateFormat(qGameInfo.Game_Date,"mm/dd/yyyy") & " " & TimeFormat(qGameInfo.Game_Time,"hh:mm tt") >
	<cfset NewGameField		= qGameInfo.FieldName>
	<cfset NewGameFieldAbbr	= qGameInfo.FieldAbbr>
	<cfset Comments			= "">
</CFIF>

<cfset timePart      = timeFormat(NewGameTime,"hh:mm tt")>
<cfset GameNewHour	 = listFirst(timePart,":")>
<cfset GameNewMinute = listLast(listFirst(timePart," "),":")>
<cfset GameNewMeridian	= ListLast(timePart," ")>

--->


<FORM name="Games" action="gameChangeREQedit.cfm"  method="post">
<input type="hidden" name="GameId"			value="#GameId#">
<input type="hidden" name="TeamID"			value="#TeamID#">
<input type="hidden" name="ChangeRequestId" value="#ChangeRequestId#">
<input type="hidden" name="NewGameField"	value="#NewGameField#">
<input type="hidden" name="HomeTeamID"		value="#HomeTeamID#">
<input type="hidden" name="VisitorTeamID"	value="#VisitorTeamID#">

<span class="red">Fields marked with * are required</span>
<CFSET required = "<FONT color=red>*</FONT>">
<table cellspacing="0" cellpadding="5" align="left" border="0" width="80%">
	<tr class="tblHeading">
		<TD width="25%"> &nbsp; </TD>
		<TD width="35%"> &nbsp; </TD>
		<TD width="40%"> &nbsp; </TD>
	</tr>
	<CFIF len(trim(msg))>
		<TR><TD colspan="3" align="center">
				<span class="red"><b>#msg#</b></span>
			</TD>
		</TR>
	</CFIF>
	<TR><TD align="right"><B>Game<B></TD>
		<TD>#VARIABLES.GameId#</TD>
		<TD><FONT color="maroon">Existing Values</FONT></TD>
	</TR>
	<TR><TD align="right"><B>Game Type<B></TD>
		<TD><cfswitch expression="#ucase(VARIABLES.GameType)#">
				<cfcase value="N">Non League </cfcase>
				<cfcase value="C">State Cup </cfcase>
				<cfcase value="F">Friendly  </cfcase>
				<cfdefaultcase> League </cfdefaultcase>
			</cfswitch>
		</TD>
		<TD> &nbsp; </TD>
	</TR>
	<TR><TD align="right"><b>Division</b></TD>
		<TD>#VARIABLES.Division#</TD>
		<TD>&nbsp; </TD>
	</TR>
	<TR><TD align="right">#required#<b>Game Date</b></TD>
		<TD><input size="9" name="NewGameDate" value="#VARIABLES.NewGameDate#" readonly >
			<input size="3" name="DOW"  value="#DateFormat(VARIABLES.NewGameDate,"ddd")#" disabled>
			&nbsp;  <cfset dpMM = datePart("m",VARIABLES.NewGameDate)-1>
					<cfset dpYYYY = datePart("yyyy",VARIABLES.NewGameDate)>
			<a href="javascript:show_calendar('Games.NewGameDate','Games.DOW','#dpMM#','#dpYYYY#' );" 
					onmouseover="window.status='Date Picker';return true;" 
					onmouseout="window.status='';return true;"> 
				<img src="#SESSION.siteVars.imagePath#cal.gif" width="20" height="18" alt="" border="0">
			</a>
		</TD>
		<TD><FONT color="maroon">#GameDate# &nbsp; (#DateFormat(VARIABLES.GameDate,"ddd")# )</FONT></TD>
	</TR>
	<TR><TD align="right">#required#<b>Game Time</b></TD>
		<TD><SELECT name="GameNewHour"> 
				<!--- <OPTION value="" selected>HR</OPTION> --->
			    <CFLOOP list="#stTimeParams.hour#" index="iHr">
					<OPTION value="#iHr#" <cfif VARIABLES.GameNewHour EQ iHr>selected</cfif> >#iHr#</OPTION>
				</CFLOOP>
			</SELECT>
			<SELECT name="GameNewMinute"> 
				<!--- <OPTION value="" selected>MN</OPTION> --->
				<CFLOOP list="#stTimeParams.min#" index="iMn">
					<OPTION value="#iMn#" <cfif VARIABLES.GameNewMinute EQ iMn>selected</cfif>  >#iMn#</OPTION>
				</CFLOOP>
			</SELECT>
			<SELECT name="GameNewMeridian">
				<CFLOOP list="#stTimeParams.tt#" index="iTT">
					<OPTION value="#iTT#" <cfif VARIABLES.GameNewMeridian EQ iTT>selected</cfif>  >#iTT#</OPTION>
				</CFLOOP>
			</SELECT>  
		</TD>
		<TD><FONT color="maroon">#GameTime#</FONT></TD>
	</TR>
	<TR><TD align="right"><b>Home Team</b></TD>
		<TD>#HomeTeam#</TD>
		<TD>&nbsp; </TD>
	</tr>
	<TR><TD align="right"><b>Visitor Team</b></TD>
		<TD><cfif len(trim(VisitorTeam))>
				#VisitorTeam#
			<cfelseif len(trim(VirtualTeamName))>
				#VirtualTeamName#
			<cfelse>
				&nbsp; 
			</cfif>
		</TD>
		<TD>&nbsp; </TD>
	</tr>
	<TR id="ClubFields"  style="DISPLAY:" ><!--- aa-01/19/09 inline --->
		<TD align="right"><b>PlayField</b> </TD>
		<TD><cfset FieldFound = 0>
			<CFQUERY name="HomeTeamFields" datasource="#SESSION.DSN#">
				SELECT F.FIELD_ID, F.FIELDABBR, F.FIELDNAME
				  FROM TBL_FIELD F	INNER JOIN XREF_CLUB_FIELD xcf ON xcf.field_id = F.field_id
									INNER JOIN V_GAMES	   vg  ON vg.Home_CLUB_ID = xcf.CLUB_ID
				 WHERE vg.GAME = #GameID#
				   and f.Active_YN = 'Y'
			</CFQUERY>
			<SELECT name="GameFieldClub"> 
				<OPTION value="0" selected>&nbsp;</OPTION>
				<CFLOOP query="HomeTeamFields">
					<cfif GameFieldID EQ FIELD_ID>
					 	<cfset FieldFound = 1>
						<OPTION value="#FIELD_ID#" selected>#FIELDABBR#</OPTION>
					<cfelse>
						<OPTION value="#FIELD_ID#"		   >#FIELDABBR#</OPTION>
					</cfif>
				</CFLOOP>
				<cfif FieldFound EQ 0>
					<cfif Len(trim(GameField)) >
						<OPTION value="#VARIABLES.GameFieldID#" selected>#GameFieldAbbr#</OPTION>
					</cfif>
				</cfif>
				<cfif (SESSION.MENUROLEID EQ 19 OR SESSION.MENUROLEID EQ 1) > <!---  19="GAMESCHAIR" 1="ASSTADMIN" --->
					<cfquery name="otherFieldValues" datasource="#SESSION.DSN#">
							SELECT F.FIELD_ID, F.FIELDABBR, F.FIELDNAME
							  FROM TBL_FIELD F  INNER JOIN XREF_CLUB_FIELD xcf ON xcf.field_id = F.field_id
							 WHERE XCF.CLUB_ID = 1 
							   and f.Active_YN = 'Y'
					</cfquery>
					<CFLOOP query="otherFieldValues">
						<OPTION value="#FIELD_ID#" <cfif GameFieldID EQ FIELD_ID >selected</cfif> >#FIELDABBR#</OPTION>
					</CFLOOP>
				</cfif>
			</SELECT>
			<cfif (SESSION.MENUROLEID EQ 19 OR SESSION.MENUROLEID EQ 1) > <!---  19="GAMESCHAIR" 1="ASSTADMIN" --->
				<input type=button name="DispAllFields" onclick="DisplayAllFields()" value="Display ALL Fields">
			</cfif>
		</TD>
		<TD><FONT color="maroon">#Trim(GameFieldAbbr)#</FONT>		</TD>
	</TR>
	<cfif (SESSION.MENUROLEID EQ 19 OR SESSION.MENUROLEID EQ 1) > <!---  19="GAMESCHAIR" 1="ASSTADMIN" --->
		<TR id="AllFields" style="DISPLAY: none">
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
			</TD>
			<TD><FONT color="maroon">#Trim(GameFieldAbbr)#</FONT>	</TD>
		</TR>
	</cfif>
	<TR><TD align="right">#required#<b>Reason for change</FONT> <br>(500 chars max)</TD>
		<TD colspan="2"><TEXTAREA name="Comments"  rows=5 cols=50>#Trim(Comments)#</TEXTAREA>
		</TD>
	</TR>
	<tr><td colspan="3" align=center>
			<span class="red">
			<b>By clicking submit I certify that the opposing team has agreed to the change in writing</b>
			</span>
		</td>
	</tr>
	<TR><TD>&nbsp;</TD>
		<TD align="center">
			<INPUT type="Submit" name="SubmitChanges" value="Submit Changes">
			<INPUT type="Submit" name="BACK" value="Back">
		</TD>
		<TD>&nbsp;</TD>
	</TR>
</TABLE>
</FORM>

<script language="javascript">
var cForm = document.Games.all;

function DisplayAllFields()
{	cForm("ClubFields").style.display = "none";
	cForm("AllFields").style.display  = "inline";
}
function DisplayClubFields()
{	cForm("ClubFields").style.display = "inline";
	cForm("AllFields").style.display  = "none";
}
</script>



</cfoutput>
</div>
<cfinclude template="_footer.cfm">
