<!--- 
	FileName:	gameChangeProcessAccINC.cfm
	Created on: 10/09/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: 	This include is used by: gameChangeProcess.cfm
	
MODS: mm/dd/yyyy - filastname - comments
01/30/09 - aarnone - added amount
03/20/09 - aarnone - ticket:7404 - added flip teams
04/16/09 - aarnone - T:7514 - made the deletion of the referees dependent on the user to select Y/N
05/04/09 - aarnone - T:7403 - included games chairman comments in update of TBL_GAMES
 --->
<cfoutput>
<cfset ChangeError = 0>


<!--- <cfdump var="#FORM#"> --->



<!--- 03/18/09 - AA - took out check to see if team is playing a game on that date if needed in future, create module that can be used everywhere.
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
	<CFIF ChangeRequestId NEQ 0 >

		<!--- log the request --->
		<cfstoredproc procedure="p_LOG_Game_Change_Request" datasource="#SESSION.DSN#">
			<cfprocparam cfsqltype="CF_SQL_NUMERIC" dbvarname="@game_change_request_id" value="#ChangeRequestID#">
			<cfprocparam cfsqltype="CF_SQL_NUMERIC" dbvarname="@contactID" value="#SESSION.USER.CONTACTID#">
		</cfstoredproc>
		
		<!--- <br>-----------TBL_Game_Change_REQUEST
		<br> ApprovedTime	= #dateFormat(now(),"mm/dd/yyyy")# #timeformat(now(),"hh:mm:ss tt")#
		<br>  ApprovedDate	= #dateFormat(now(),"mm/dd/yyyy")#
		<br>  Approved		= #VARIABLES.Status#
		<br>  NewDate		= #dateFormat(NewDate,"mm/dd/yyyy")#
		<br>  NewTime		= #dateFormat(NewDate,"mm/dd/yyyy")# #timeformat(NewTime,"hh:mm:ss tt")#
		<br>  NewField		= #VARIABLES.newFieldID#
		<br>  Comments		= #VARIABLES.Comments#
		<br>  RefComments	= #VARIABLES.RefComments#
		<br>  updateDate	= #dateFormat(now(),"mm/dd/yyyy")# #timeformat(now(),"hh:mm:ss tt")#
		<br>  updatedBY	= #SESSION.USER.CONTACTID#
		<br> GAME_Change_Request_Id = #VARIABLES.ChangeRequestID#
		<br>----------- --->


		<!--- update the game change request --->
		<cfquery name="updateGCR" datasource="#SESSION.DSN#">
			Update TBL_Game_Change_REQUEST
			   set ApprovedTime	= <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#dateFormat(now(),"mm/dd/yyyy")# #timeformat(now(),"hh:mm:ss tt")#"> 
				,  ApprovedDate	= <cfqueryparam cfsqltype="CF_SQL_DATE"    value="#dateFormat(now(),"mm/dd/yyyy")#"> 
				,  Approved		= <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.Status#">
				,  NewDate		= <cfqueryparam cfsqltype="CF_SQL_DATE"    value="#dateFormat(NewDate,"mm/dd/yyyy")#">
				,  NewTime		= <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#dateFormat(NewDate,"mm/dd/yyyy")# #timeformat(NewTime,"hh:mm:ss tt")#"> 
				,  NewField		= <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.newFieldID#">
				,  Comments		= <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.Comments#">
				,  RefComments	= <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.RefComments#">
				,  updateDate	= <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#dateFormat(now(),"mm/dd/yyyy")# #timeformat(now(),"hh:mm:ss tt")#"> 
				,  updatedBY	= <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#SESSION.USER.CONTACTID#">
				Where GAME_Change_Request_Id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.ChangeRequestID#">
		</cfquery>
		<!--- log game info --->
		<cfstoredproc procedure="p_LOG_Game" datasource="#SESSION.DSN#">
			<cfprocparam cfsqltype="CF_SQL_NUMERIC" dbvarname="@game_id"  value="#VARIABLES.GameID#">
			<cfprocparam cfsqltype="CF_SQL_NUMERIC" dbvarname="@username" value="#SESSION.USER.CONTACTID#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@pagename" value="#CGI.Script_Name#">
		</cfstoredproc>


		<CFIF DeleteRefs_YN EQ "Y"> <!--- User chose to NOT keep the referees --->
			<!--- log and delete referee report --->
			<cfstoredproc procedure="p_LOG_RefereeReportHeader" datasource="#SESSION.DSN#">
				<cfprocparam cfsqltype="CF_SQL_NUMERIC" dbvarname="@game_id"  value="#VARIABLES.GameID#">
				<cfprocparam cfsqltype="CF_SQL_NUMERIC" dbvarname="@username" value="#SESSION.USER.CONTACTID#">
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@pagename" value="#CGI.Script_Name#">
			</cfstoredproc>
			
			<cfstoredproc procedure="p_LOG_RefereeReportDetail" datasource="#SESSION.DSN#">
				<cfprocparam cfsqltype="CF_SQL_NUMERIC" dbvarname="@game_id"  value="#VARIABLES.GameID#">
				<cfprocparam cfsqltype="CF_SQL_NUMERIC" dbvarname="@username" value="#SESSION.USER.CONTACTID#">
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@pagename" value="#CGI.Script_Name#">
			</cfstoredproc>
	
			<cfquery name="delRefRptDtl" datasource="#SESSION.DSN#">
				Delete from TBL_REFEREE_RPT_DETAIL
				 Where Game_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameID#">
			</cfquery>
			
			<cfquery name="deleteRefRptHdr" datasource="#SESSION.DSN#">
				Delete from TBL_REFEREE_RPT_HEADER 
				 Where Game_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameID#">
			</cfquery>
			<cfquery name="deleteGameDayDoc" datasource="#SESSION.DSN#">
				Delete from TBL_GAME_DAY_DOCUMENTS 
				 Where Game_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameID#">
			</cfquery>
			<!--- delete officials from the game --->
			<cfquery name="qGetRefs" datasource="#SESSION.DSN#">
				SELECT RefID, AsstRefID1, AsstRefID2 FROM V_GAMES WHERE GAME = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameID#">
			</cfquery>
			<CFIF qGetRefs.RECORDCOUNT>
				<CFIF LEN(trim(qGetRefs.RefID))>
					<cfstoredproc procedure="p_delete_xref_game_official" datasource="#SESSION.DSN#">
						<cfprocparam cfsqltype="CF_SQL_NUMERIC" dbvarname="@officialTypeID" value="1">
						<cfprocparam cfsqltype="CF_SQL_NUMERIC" dbvarname="@OldContactID"	value="#qGetRefs.RefID#">
						<cfprocparam cfsqltype="CF_SQL_NUMERIC" dbvarname="@gameID"			value="#VARIABLES.GameID#">
					</cfstoredproc>
				</CFIF>
				<CFIF LEN(trim(qGetRefs.AsstRefID1))>
					<cfstoredproc procedure="p_delete_xref_game_official" datasource="#SESSION.DSN#">
						<cfprocparam cfsqltype="CF_SQL_NUMERIC" dbvarname="@officialTypeID" value="2">
						<cfprocparam cfsqltype="CF_SQL_NUMERIC" dbvarname="@OldContactID"	value="#qGetRefs.AsstRefID1#">
						<cfprocparam cfsqltype="CF_SQL_NUMERIC" dbvarname="@gameID"			value="#VARIABLES.GameID#">
					</cfstoredproc>
				</CFIF>
				<CFIF LEN(trim(qGetRefs.AsstRefID2))>
					<cfstoredproc procedure="p_delete_xref_game_official" datasource="#SESSION.DSN#">
						<cfprocparam cfsqltype="CF_SQL_NUMERIC" dbvarname="@officialTypeID" value="3">
						<cfprocparam cfsqltype="CF_SQL_NUMERIC" dbvarname="@OldContactID"	value="#qGetRefs.AsstRefID2#">
						<cfprocparam cfsqltype="CF_SQL_NUMERIC" dbvarname="@gameID"			value="#VARIABLES.GameID#">
					</cfstoredproc>
				</CFIF>
			</CFIF>
		</CFIF><!--- END - IF DeleteRefs_YN EQ "Y" --->

			<!--- <br>-------------Update TBL_Game
			<br> game_Date = #dateFormat(NewDate,"mm/dd/yyyy")#
			<br> game_Time = #dateFormat(NewDate,"mm/dd/yyyy")# #timeformat(NewTime,"hh:mm:ss tt")# 
			<br> Field_ID  = #VARIABLES.newFieldID#
			<br> Comments  = #VARIABLES.RefComments#
			<br> Game_ID   = #VARIABLES.GameID#
			<br>------------- --->

		<!--- UPDATE GAME --->
		<cfquery name="updGame" datasource="#SESSION.DSN#">
			Update TBL_Game
			   set game_Date = <cfqueryparam cfsqltype="CF_SQL_DATE"    value="#dateFormat(NewDate,"mm/dd/yyyy")#">
				 , game_Time = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#dateFormat(NewDate,"mm/dd/yyyy")# #timeformat(NewTime,"hh:mm:ss tt")#"> 
				 , Field_ID	 = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.newFieldID#">
				 , Comments	 = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.RefComments#">
				 , gamesChairComments = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.Comments#">
			 Where Game_ID   = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameID#">
		</cfquery>

		<!--- UPDATE teams if they changed --->
		<cfif VARIABLES.HomeTeamID NEQ VARIABLES.ORIGHomeTeamID>
			<cfstoredproc procedure="p_set_game_team" datasource="#SESSION.DSN#">
				<cfprocparam type="In" dbvarname="@orig_team_id" cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.ORIGHomeTeamID#">
				<cfprocparam type="In" dbvarname="@new_team_id"  cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.HomeTeamID#">
				<cfprocparam type="In" dbvarname="@game_id" 	 cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameId#">
				<cfprocparam type="In" dbvarname="@home_yn" 	 cfsqltype="CF_SQL_VARCHAR"	value="Y">
			</cfstoredproc>
		</cfif>
		<cfif VARIABLES.VisitorTeamID NEQ VARIABLES.ORIGVisitorTeamID>
			<cfstoredproc procedure="p_set_game_team" datasource="#SESSION.DSN#">
				<cfprocparam type="In" dbvarname="@orig_team_id" cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.ORIGVisitorTeamID#">
				<cfprocparam type="In" dbvarname="@new_team_id"  cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.VisitorTeamID#">
				<cfprocparam type="In" dbvarname="@game_id" 	 cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameId#">
				<cfprocparam type="In" dbvarname="@home_yn" 	 cfsqltype="CF_SQL_VARCHAR"	value="N">
			</cfstoredproc>
		</cfif>

		<!--- UPDATE GAME CHANGE REQ
			<cfquery name="updGCRstatus" datasource="#SESSION.DSN#">
				Update TBL_Game_Change_REQUEST
				   set Approved = 'D'
				 Where GAME_Change_Request_ID <> <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.ChangeRequestID#">
				   and Game_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameID#">
			</cfquery> --->

		<cfif FineTeam EQ "Y">
			<cfset Amount = 0>
			<cfquery name="getFineAmount" datasource="#SESSION.DSN#">
				Select Amount from TLKP_Fine_Type 
				 Where FINETYPE_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.FineTypeID#">
			</cfquery>
			<cfif getFineAmount.recordCount>
				<cfset Amount = getFineAmount.Amount>
			</cfif>
	
			<!--- Select Id, Club from V_Clubs Where ID  in (Select ClubID from V_CoachesTeams Where ID = RequestedByTeam	)	 --->
			<!--- Select ID, TeamName from V_CoachesTeams Where ID = RequestedByTeam --->
			<cfinvoke component="#SESSION.SITEVARS.cfcPath#TEAM" method="getTeamInfo" returnvariable="teamClubFined">
				<cfinvokeargument name="TeamID" value="#VARIABLES.TeamToBeFined#">
			</cfinvoke>	
			<cfif teamClubFined.RECORDCOUNT>
				<cfset ClubFined		= teamClubFined.CLUB_ID >
				<cfset ClubFinedName	= teamClubFined.CLUB_NAME >
				<cfset TeamFined		= teamClubFined.TEAM_ID >
				<cfset TeamFinedName	= teamClubFined.TEAMNAME >
			<cfelse>
				<cfset ClubFined		= 0 >
				<cfset ClubFinedName	= "" >
				<cfset TeamFined		= 0 >
				<cfset TeamFinedName	= "" >
			</cfif>
	
			<!--- Select Division, Home, Visitor, Field from V_Games Where Game =  GameID
			<cfinvoke component="#SESSION.SITEVARS.cfcPath#GAME" method="getGameSchedule" returnvariable="qGameInfo">
				<cfinvokeargument name="gameID" Value="#VARIABLES.GameID#">
			</cfinvoke>
			<cfif qGameInfo.recordCount>
				<cfset Division	= qGameInfo.Division >
				<cfset Home		= qGameInfo.Home_Team_ID >
				<cfset Visitor	= qGameInfo.Visitor_Team_ID >
				<!--- <cfset Field	= qGameInfo.FIELD_ID > --->
			<cfelse>
				<cfset Division	= "">
				<cfset Home		= 0 >
				<cfset Visitor	= 0 >
				<cfset Field	= "">
			</cfif> --->
			<!--- <cfoutput>	
							<br>SeasonID [#SESSION.CURRENTSEASON.ID#]
							<br>gameID [#VARIABLES.GameID#]
							<br>clubID [#VARIABLES.ClubFined#]
							<br>TeamID [#VARIABLES.TeamFined#]
							<br>fineTypeID [#VARIABLES.FineTypeID#]
							<br>Status [""] 
							<br>Comments [""]
							<br>contactID [#SESSION.USER.CONTACTID#]
							<br>AppealAllowedYN [Y]
			</cfoutput>
			<CFABORT>
			 --->

			<cfinvoke component="#SESSION.SITEVARS.cfcPath#FINEFEES" method="insertFine">
				<cfinvokeargument name="SeasonID" 	 value="#SESSION.CURRENTSEASON.ID#">
				<cfinvokeargument name="gameID"   value="#VARIABLES.GameID#"> 
				<cfinvokeargument name="clubID"   value="#VARIABLES.ClubFined#"> 
				<cfinvokeargument name="TeamID"   value="#VARIABLES.TeamFined#"> 
				<cfinvokeargument name="fineTypeID"   value="#VARIABLES.FineTypeID#"> 
				<cfinvokeargument name="Amount"   value="#VARIABLES.Amount#"> 
				<cfinvokeargument name="Status"   value=""> 
				<cfinvokeargument name="Comments" value=""> 
				<cfinvokeargument name="contactID" value="#SESSION.USER.CONTACTID#"> 
				<cfinvokeargument name="AppealAllowedYN" value="Y"> 
			</cfinvoke>

		</cfif> <!--- end - if FineTeam EQ "Y" --->
	</CFIF> <!--- END - IF ChangeRequestId NEQ 0 --->
</CFIF> <!--- END - IF ChangeError EQ 0 --->
</cfoutput>	
<!--- <CFABORT> --->