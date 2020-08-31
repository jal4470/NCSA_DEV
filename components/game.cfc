<!--- 
Changes:
2009-10-19 - B. Cooper - changed v_games to v_games_all in getGameSchedule query.
 --->

<cfcomponent>
<CFSET DSN = SESSION.DSN>

<!--- =================================================================== --->
<cffunction name="getGameSchedule" access="public" returntype="query">
	<!--- --------
		08/13/08 - AArnone - New function: retruns a list of Games
			<cfinvoke component="#SESSION.SITEVARS.cfcPath#GAME" method="getGameSchedule" returnvariable="qGames">
				<cfinvokeargument name="gameID"		value="#VARIABLES.#"> optional
				<cfinvokeargument name="clubID"		value="#VARIABLES.#"> optional
				<cfinvokeargument name="teamID"		value="#VARIABLES.#"> optional
				<cfinvokeargument name="fieldID"	value="#VARIABLES.#"> optional
				<cfinvokeargument name="division"	value="#VARIABLES.#"> optional
				<cfinvokeargument name="fromdate"	value="#VARIABLES.#"> optional
				<cfinvokeargument name="todate"		value="#VARIABLES.#"> optional
				<cfinvokeargument name="orderBy"	value="#VARIABLES.#"> optional
				<cfinvokeargument name="notLeague" 	value="Y/N/ ">		  optional
			</cfinvoke>

		03/06/09 - aarnone - ticket:7309 - virtual team changes for state cup and non league games
		04/02/09 - aarnone - sort bt time changed to use dbo.formatDateTime(GAME_TIME,'HH:MM 24')
		04/06/2009 - AARNONE - T:7491 with (nolock) added to v_games (perf issue)
		10/19/2009 - bcooper - added seasonID argument
	----- --->
	<cfargument name="gameID"	type="numeric" required="no" default=0  >
	<cfargument name="clubID"	type="numeric" required="no" default=0  >
	<cfargument name="teamID"	type="numeric" required="no" default=0  >
	<cfargument name="swHomeGameOnly" type="string" required="no" default="false" >
	<cfargument name="fieldID"	type="numeric" required="no" default=0  >
	<cfargument name="division" type="string"  required="no" default="" >
	<cfargument name="fromdate" type="string"  required="no" default="" >
	<cfargument name="todate"	type="string"  required="no" default="" >
	<cfargument name="orderBy"	type="string"  required="no" default="" >
	<cfargument name="notLeague" type="string" required="no" default="" >  <!--- Y=F,C,N,P  N=L, ''=ALL GAMES  --->
	<cfargument name="seasonID"  type="string" required="no" default="" >
	
	<CFSET useOrderBy = "">
	<CFSET useGame = "">
	<CFSET useClub = "">
	<CFSET useTeam = "">
	<CFSET useField = "">
	<CFSET useDiv  = "">
	<CFSET StartDate = 0>
	<CFSET EndDate = 0>

	<!--- <cfswitch expression="#ucase(ARGUMENTS.orderBy)#"> 
		<cfcase value="TEAMNAME">  <CFSET useOrderBy = " order by Home_TeamName, game_date, game_time, Division">	 </cfcase>
		<cfcase value="HOMETEAM">  <CFSET useOrderBy = " order by Home_TeamName, game_date, game_time, Division">	 </cfcase>
		<cfcase value="VISITEAM">  <CFSET useOrderBy = " order by Visitor_TeamName, game_date, game_time, Division"> </cfcase>
		<cfcase value="FIELDABBR"> <CFSET useOrderBy = " order by fieldAbbr, game_date, game_time, Division">		 </cfcase>
		<cfcase value="FIELDNAME"> <CFSET useOrderBy = " order by fieldName, game_date, game_time, Division">		 </cfcase>
		<cfcase value="DIVISION">  <CFSET useOrderBy = " order by Division, game_date, game_time ">					 </cfcase>
		<cfcase value="GAME">	   <CFSET useOrderBy = " order by game_id ">										 </cfcase>
		<cfcase value="DATEFABBRTIME"><CFSET useOrderBy = " order by game_date, fieldAbbr, game_time">				 </cfcase>
		<cfdefaultcase>			   <CFSET useOrderBy = " order by game_date, game_time, Division">					 </cfdefaultcase>
	</cfswitch> --->
	<cfswitch expression="#ucase(ARGUMENTS.orderBy)#">
		<cfcase value="TEAMNAME">  <CFSET useOrderBy = " order by Home_TeamName, game_date, dbo.formatDateTime(GAME_TIME,'HH:MM 24'), Division">	 </cfcase>
		<cfcase value="HOMETEAM">  <CFSET useOrderBy = " order by Home_TeamName, game_date, dbo.formatDateTime(GAME_TIME,'HH:MM 24'), Division">	 </cfcase>
		<cfcase value="VISITEAM">  <CFSET useOrderBy = " order by Visitor_TeamName, game_date, dbo.formatDateTime(GAME_TIME,'HH:MM 24'), Division"> </cfcase>
		<cfcase value="FIELDABBR"> <CFSET useOrderBy = " order by fieldAbbr, game_date, dbo.formatDateTime(GAME_TIME,'HH:MM 24'), Division">		 </cfcase>
		<cfcase value="FIELDNAME"> <CFSET useOrderBy = " order by fieldName, game_date, dbo.formatDateTime(GAME_TIME,'HH:MM 24'), Division">		 </cfcase>
		<cfcase value="DIVISION">  <CFSET useOrderBy = " order by Division, game_date, dbo.formatDateTime(GAME_TIME,'HH:MM 24') ">					 </cfcase>
		<cfcase value="GAME">	   <CFSET useOrderBy = " order by game_id ">										 </cfcase>
		<cfcase value="DATEFABBRTIME"><CFSET useOrderBy = " order by game_date, fieldAbbr, dbo.formatDateTime(GAME_TIME,'HH:MM 24')">				 </cfcase>
		<cfdefaultcase>			   <CFSET useOrderBy = " order by game_date, dbo.formatDateTime(GAME_TIME,'HH:MM 24'), Division">					 </cfdefaultcase>
	</cfswitch>

	<CFIF isDefined("ARGUMENTS.swHomeGameOnly")>
		<cfset swHomeGameOnly = ARGUMENTS.swHomeGameOnly>
	<CFELSE>
		<cfset swHomeGameOnly = false>
	</CFIF>
	
	
	<!--- 
	V_GAMES: 
		game_id	game_code	game_date	game_time	original_GameDate	
					original_GameTime 		fieldStatus	game_type
		field_id	fieldName	fieldAbbr
		season_id	
		Visitor_Team_ID	Visitor_TeamName	Visitor_CLUB_ID	
		Home_Team_ID	Home_TeamName		Home_CLUB_ID	
		division_id		Division
		Score_visitor	Forfeit_Visitor		DelayedEntry_Visitor
		Score_Home		Forfeit_Home		DelayedEntry_Home
		scoreOverRide, 
		comments		gamesChairComments	
		RefNoShow		refReportSbm_yn		RefPaid_YN 
		RefID			xref_game_official_id		Ref_accept_Date
		AsstRefID1		AsstRef1_game_official_id	ARef1AcptDate
		AsstRefID2		AsstRef2_game_official_id	ARef2AcptDate
		createdby		createDate			updatedBy		updateDate
		--->



	<CFIF isDefined("ARGUMENTS.todate") AND isDate(ARGUMENTS.todate) >
		<CFSET EndDate = ARGUMENTS.todate >
	</CFIF> 
	<CFIF isDefined("ARGUMENTS.fromdate") AND isDate(ARGUMENTS.fromdate) >
		<CFSET StartDate = ARGUMENTS.fromdate >
	</CFIF> 
	


	<CFQUERY name="qGameSched" datasource="#VARIABLES.DSN#">
		SELECT  game_id, game_code, game_date, game_time, game_type, FIELD_ID, fieldName, fieldAbbr, 
				division_id, Division, season_id,
				Virtual_TeamName,
				Visitor_CLUB_ID, Visitor_Team_ID, Visitor_TeamName, Visitor_TeamName_null, 
						Score_visitor, DelayedEntry_Visitor, Forfeit_Visitor,
		        Home_CLUB_ID,    Home_Team_ID,	  Home_TeamName,	Home_TeamName_null,	   
						Score_Home,	  DelayedEntry_Home,    Forfeit_Home,
				RefID,      Ref_accept_YN,  Ref_accept_Date, refReportSbm_YN, refNoShow,
				AsstRefID1, ARef1Acpt_YN,   ARef1AcptDate,
				AsstRefID2, ARef2Acpt_YN,   ARef2AcptDate,
				comments, gamesChairComments 
		  FROM  V_GAMES_ALL with (nolock) 
		WHERE 1=1
			<CFIF ARGUMENTS.clubID GT 0>
				<CFIF swHomeGameOnly>
					and ( Home_CLUB_ID = #ARGUMENTS.clubID# )
				<CFELSE>
					and ( Home_CLUB_ID = #ARGUMENTS.clubID# OR Visitor_CLUB_ID = #ARGUMENTS.clubID#) 
				</CFIF>
			</CFIF> 
		
			<CFIF ARGUMENTS.teamID GT 0>
				and ( Home_Team_ID = #ARGUMENTS.TEAMID# OR Visitor_Team_ID = #ARGUMENTS.TEAMID# )
			</CFIF> 
			<CFIF ARGUMENTS.fieldID GT 0>
				and FIELD_ID = #ARGUMENTS.FIELDID#
			</CFIF> 
			<CFIF len(trim(ARGUMENTS.division)) AND compareNoCase(ARGUMENTS.DIVISION,"ALL") NEQ 0 >
				and Division = '#trim(ARGUMENTS.DIVISION)#'
			</CFIF> 
			<CFIF ARGUMENTS.gameID GT 0>
				and GAME_ID = '#trim(ARGUMENTS.gameID)#'
			</CFIF> 
			
			<CFIF EndDate NEQ 0 AND StartDate NEQ 0>
				<CFIF EndDate GT StartDate>
					and (game_date >= '#StartDate#' AND game_date <= '#EndDate#' )
				<CFELSE>
					and (game_date = '#StartDate#' )
				</CFIF>
			<CFELSEIF  StartDate NEQ 0>
				and (game_date = '#StartDate#' )
			<CFELSEIF EndDate NEQ 0>
				and (game_date = '#EndDate#' )
			</CFIF> 

			<CFIF isDefined("ARGUMENTS.notLeague") AND ARGUMENTS.notLeague EQ "Y">
				and GAME_TYPE IN ('F','C','N','P') <!--- ALL but League --->
			<CFELSEIF isDefined("ARGUMENTS.notLeague") AND ARGUMENTS.notLeague EQ "N">
				and ( GAME_TYPE IS NULL OR GAME_TYPE = 'L') <!--- LEAGUE only --->
			</CFIF>
			
			<cfif arguments.seasonID NEQ "">
				and season_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.seasonID#">
			</cfif>
			
		#preserveSingleQuotes(useOrderBy)#
	</CFQUERY><!--- #useOrderBy# --->
	
	<cfreturn qGameSched>
</cffunction>
	

<!--- =================================================================== --->
<cffunction name="getGameDivisions" access="public" returntype="query">
	<!--- --------
		08/13/08 - AArnone - New function: retruns a list of Divisions found in the Games
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#GAME" method="getGameDivisions" returnvariable="qGetDivisions">
		<cfinvokeargument name="clubID" value="#.#">
	</cfinvoke>
	
	----- --->
	<cfargument name="clubID" type="string"  required="no" default="" >
	
	<CFIF isDefined("ARGUMENTS.clubID") AND isNumeric(ARGUMENTS.clubID) AND ARGUMENTS.clubID GT 0>
		<CFSET whereClub = " AND visitor_CLUB_ID = " & ARGUMENTS.clubID & " OR home_CLUB_ID = " & ARGUMENTS.clubID >
	<CFELSE>
		<CFSET whereClub = "">
	</CFIF>
	
	<CFQUERY name="qGameDivisions" datasource="#VARIABLES.DSN#">
		Select Distinct DIVISION 
		  from V_Games
		 where DIVISION IS NOT NULL 
		 #whereClub#
		 order by Division
	</CFQUERY>
	
	<cfreturn qGameDivisions>
</cffunction>
	
<!--- =================================================================== --->
<cffunction name="getGameFields" access="public" returntype="query">
	<!--- --------
		08/13/08 - AArnone - New function: retruns a list of Divisions found in the Games
		04/06/2009 - AARNONE - T:7491 with (nolock) added to v_games (perf issue)
	----- --->
	<CFQUERY name="qGameFields" datasource="#VARIABLES.DSN#">
		Select DISTINCT FIELD_ID, FIELDABBR 
		  from V_Games 
		 order by FIELDABBR
	</CFQUERY>
	
	<cfreturn qGameFields>
</cffunction>
	

<!--- =================================================================== --->
<cffunction name="getGameDates" access="public" returntype="query">
	<!--- --------
		08/13/08 - AArnone - New function: retruns a list of dates found in the Games
		04/06/2009 - AARNONE - T:7491 with (nolock) added to v_games (perf issue)
	----- --->
	<cfargument name="division" type="string"  required="no" default="" >
	<cfargument name="seasonID" type="string"  required="no">

	<CFIF LEN(TRIM(ARGUMENTS.division))>
		<CFSET whereclause = "WHERE DIVISION = '" & ARGUMENTS.division & "'">
	</CFIF>
	
	<CFQUERY name="qGameDates" datasource="#VARIABLES.DSN#">
		Select Distinct game_date 
		  from V_Games 
		  where 1=1
		  <cfif len(trim(arguments.division))>
		  	and division = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.division#">
		  </cfif>
		  <cfif isdefined("arguments.season")>
		  	and season_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.season_id#">
		  </cfif>
		 order by game_date ASC
	</CFQUERY>
	
	<cfreturn qGameDates>
</cffunction>
	


<!--- =================================================================== --->
<cffunction name="updateGameScedule" access="public">
	<!--- --------
		09/30/08 - AArnone - updates TBL_GAME, used in gameEdit
	----- --->
	<cfargument name="GameId"			 type="numeric" required="Yes" >
	<cfargument name="GameDate"			 type="date" 	required="Yes" >
	<cfargument name="GameTime"			 type="string"	required="Yes" >
	<cfargument name="GameFieldID"		 type="numeric" required="Yes" >
	<cfargument name="Comments"			 type="string"	required="Yes" >
	<cfargument name="GamesChairComments" type="string" required="Yes" >
	<cfargument name="ORIGHomeTeamID"	 type="numeric" required="Yes" > 
	<cfargument name="HomeTeamID"		 type="numeric" required="Yes" >
	<cfargument name="ORIGVisitorTeamID" type="numeric" required="Yes" >
	<cfargument name="VisitorTeamID"	 type="numeric" required="Yes" >
	<cfargument name="ContactID"		 type="numeric" required="Yes" >
	<cfargument name="Script_Name"		 type="string"  required="Yes" >

	<!--- Create the record in the log before changing the games information --->
	<cfinvoke component="site" method="WriteGameLogRecord">
		<cfinvokeargument name="GameID" 	 value="#ARGUMENTS.GameId#">
		<cfinvokeargument name="ContactID" 	 value="#ARGUMENTS.ContactID#">
		<cfinvokeargument name="Script_Name" value="#ARGUMENTS.Script_Name#">
	</cfinvoke> 

	<CFQUERY name="updateGAME" datasource="#VARIABLES.DSN#">
		UPDATE TBL_GAME
		   SET game_date = <cfqueryparam cfsqltype="CF_SQL_DATE" value="#ARGUMENTS.GameDate#">
			 , game_time = <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#ARGUMENTS.GameDate# #ARGUMENTS.GameTime#">
			 , field_id  = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.GameFieldID#">
			 , Comments	 = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.Comments#">
			 , GamesChairComments	= <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.GamesChairComments#">
		 Where Game_ID   = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.GameId#">
	</CFQUERY>
		
	<cfif ARGUMENTS.HomeTeamID NEQ ARGUMENTS.ORIGHomeTeamID>
		<cfstoredproc procedure="p_set_game_team" datasource="#VARIABLES.DSN#">
			<cfprocparam type="In" dbvarname="@orig_team_id" cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.ORIGHomeTeamID#">
			<cfprocparam type="In" dbvarname="@new_team_id"  cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.HomeTeamID#">
			<cfprocparam type="In" dbvarname="@game_id" 	 cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.GameId#">
			<cfprocparam type="In" dbvarname="@home_yn" 	 cfsqltype="CF_SQL_VARCHAR"	value="Y">
		</cfstoredproc>
	</cfif>
	<cfif ARGUMENTS.VisitorTeamID NEQ ARGUMENTS.ORIGVisitorTeamID>
		<cfstoredproc procedure="p_set_game_team" datasource="#VARIABLES.DSN#">
			<cfprocparam type="In" dbvarname="@orig_team_id" cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.ORIGVisitorTeamID#">
			<cfprocparam type="In" dbvarname="@new_team_id"  cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.VisitorTeamID#">
			<cfprocparam type="In" dbvarname="@game_id" 	 cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.GameId#">
			<cfprocparam type="In" dbvarname="@home_yn" 	 cfsqltype="CF_SQL_VARCHAR"	value="N">
		</cfstoredproc>
	</cfif>
</cffunction>


<!--- =================================================================== --->
<cffunction name="DeleteGame" access="public">
	<!--- --------
		09/30/08 - AArnone - deletes a game from TBL_GAME and all dependant tables and logs game
	----- --->
	<cfargument name="GameId"			 type="numeric" required="Yes" >
	<cfargument name="ContactID"		 type="numeric" required="Yes" >
	<cfargument name="Script_Name"		 type="string"  required="Yes" >

	<cfstoredproc procedure="P_DELETE_GAME_EXT" datasource="#VARIABLES.DSN#">
		<cfprocparam type="In" dbvarname="@game_id"  cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.GameId#">
		<cfprocparam type="In" dbvarname="@username" cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ContactID#">
		<cfprocparam type="In" dbvarname="@pagename" cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.Script_Name#">
	</cfstoredproc>

</cffunction>


<!--- =================================================================== --->
<cffunction name="insertGame" access="public" returntype="numeric">
	<!--- --------
		10/01/08 - AArnone - inserts a game
	----- --->
	<cfargument name="HomeTeamID"	 type="numeric" required="Yes" >
	<cfargument name="VisitorTeamID" type="numeric" required="Yes" >
	<cfargument name="seasonID"		 type="numeric" required="Yes" >
	<cfargument name="contactID"	 type="numeric" required="Yes" >
	<cfargument name="GameDate"		 type="date"    required="Yes" >
	<cfargument name="GameTime"		 type="string"  required="Yes" >
	<cfargument name="FieldID"		 type="numeric" required="Yes" >
	<cfargument name="GameType"		 type="string"  required="Yes" >
	<cfargument name="Comments"		 type="string"  required="Yes" >
	<cfargument name="GamesChairComments" type="string"  required="Yes" >
	<cfargument name="GameCode"		      type="string"  required="no" default="" >
	<cfargument name="VirtualTeamName"    type="string"  required="no" default="" >
 	
	<cfset newGameID = 0>
	
	<cfstoredproc procedure="P_INSERT_GAME" datasource="#VARIABLES.DSN#">
		<cfprocparam type="In" dbvarname="@HomeTeamID" 	cfsqltype="CF_SQL_NUMERIC"    value="#ARGUMENTS.HomeTeamID#">
		<cfprocparam type="In" dbvarname="@VisitorTeamID" cfsqltype="CF_SQL_NUMERIC"  value="#ARGUMENTS.VisitorTeamID#">
		<cfprocparam type="In" dbvarname="@seasonID"	cfsqltype="CF_SQL_NUMERIC"    value="#ARGUMENTS.seasonID#">
		<cfprocparam type="In" dbvarname="@contactID"	cfsqltype="CF_SQL_NUMERIC"    value="#ARGUMENTS.contactID#">
		<cfprocparam type="In" dbvarname="@GameDate"	cfsqltype="CF_SQL_DATE"       value="#ARGUMENTS.GameDate#">
		<cfprocparam type="In" dbvarname="@GameTime"	cfsqltype="CF_SQL_TIME"       value="#ARGUMENTS.GameTime#">
		<cfprocparam type="In" dbvarname="@FieldID"		cfsqltype="CF_SQL_NUMERIC"    value="#ARGUMENTS.FieldID#">
		<cfprocparam type="In" dbvarname="@GameType"	cfsqltype="CF_SQL_VARCHAR"    value="#ARGUMENTS.GameType#">
		<cfprocparam type="In" dbvarname="@Comments"	cfsqltype="CF_SQL_VARCHAR"    value="#ARGUMENTS.Comments#">
		<cfprocparam type="In" dbvarname="@GamesChairComments" cfsqltype="CF_SQL_VARCHAR"  value="#ARGUMENTS.GamesChairComments#">
		<cfprocparam type="In" dbvarname="@GameCode"	cfsqltype="CF_SQL_VARCHAR"    value="#ARGUMENTS.GameCode#" null="#yesNoFormat(NOT len(trim(ARGUMENTS.GameCode)))#">
		<cfprocparam type="OUT" dbvarname="@game_id" cfsqltype="CF_SQL_NUMERIC" variable="newGameID">
	</cfstoredproc>
 
	<cfreturn newGameID>
</cffunction>








<!--- =================================================================== --->
<cffunction name="updateGameScore" access="public" >
	<!--- --------
		10/02/08 - AArnone - game score updates
		04/03/09 - aarnone - changed to accept null values for home and visitor scores
	----- --->
	<cfargument name="GameID"		type="numeric" required="Yes" >
	<cfargument name="ScoreVISITOR"	type="string" required="no" default="" >
	<cfargument name="ScoreHOME"	type="string" required="no" default="" >
	<cfargument name="ForfeitHOME"	type="string"  required="Yes" >
	<cfargument name="ForfeitVISITOR"	type="string"  required="Yes" >
	<cfargument name="DelEntryHome"		type="string"  required="Yes" >
	<cfargument name="DelEntryVisitor"	type="string"  required="Yes" >
	<cfargument name="RefNoShow"		type="string"  required="Yes" >
	<cfargument name="contactID"		type="numeric" required="Yes" > 
	<cfargument name="gameNotes"		type="string" required="No" default="" > 

	<cfif isDefined("ARGUMENTS.ScoreHOME") AND isNumeric(ARGUMENTS.ScoreHOME)>
		<cfset VARIABLES.ScoreHOME = ARGUMENTS.ScoreHOME >
	<cfelse>
		<cfset VARIABLES.ScoreHOME = "" >
	</cfif>
	
	<cfif isDefined("ARGUMENTS.ScoreVISITOR") AND isNumeric(ARGUMENTS.ScoreVISITOR)>
		<cfset VARIABLES.ScoreVISITOR = ARGUMENTS.ScoreVISITOR >
	<cfelse>
		<cfset VARIABLES.ScoreVISITOR = "" >
	</cfif>
	
	<!--- Create the record in the log before changing the games information --->
	<cfinvoke component="site" method="WriteGameLogRecord">
		<cfinvokeargument name="GameID" 	 value="#ARGUMENTS.GameId#">
		<cfinvokeargument name="ContactID" 	 value="#ARGUMENTS.ContactID#">
		<cfinvokeargument name="Script_Name" value="game.cfc updateGameScore">
	</cfinvoke> 
	
	<CFQUERY name="updScore" datasource="#VARIABLES.DSN#">
		Update TBL_GAME
		   set  Score_VISITOR		 = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.ScoreVISITOR#" 	null="#yesNoFormat(NOT len(trim(VARIABLES.ScoreVISITOR)))#">
			 ,  Score_HOME			 = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.ScoreHOME#" 		null="#yesNoFormat(NOT len(trim(VARIABLES.ScoreHOME)))#">
			 ,  Forfeit_HOME		 = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ForfeitHOME#"		null="#yesNoFormat(NOT len(trim(ARGUMENTS.ForfeitHOME)))#">
			 ,  Forfeit_VISITOR		 = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ForfeitVISITOR#"	null="#yesNoFormat(NOT len(trim(ARGUMENTS.ForfeitVISITOR)))#">
			 ,  DelayedEntry_Home	 = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.DelEntryHome#" 	null="#yesNoFormat(NOT len(trim(ARGUMENTS.DelEntryHome)))#">
			 ,  DelayedEntry_Visitor = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.DelEntryVisitor#" null="#yesNoFormat(NOT len(trim(ARGUMENTS.DelEntryVisitor)))#">
			 ,  RefNoShow			 = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.RefNoShow#" 		null="#yesNoFormat(NOT len(trim(ARGUMENTS.RefNoShow)))#">
			 ,  game_notes           = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.gameNotes#">
		 Where  Game_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.GameID#">
	</CFQUERY>

	 
</cffunction>


<!--- =================================================================== --->
<cffunction name="GetGameOfficial" access="public" returntype="query" >
	<!--- --------
		10/28/08 - AArnone - get the oggicials for a specific game
	----- --->
	<cfargument name="GameID"		type="numeric" required="Yes" >

	<CFQUERY name="qGetOfficials" datasource="#VARIABLES.DSN#">
		SELECT	xgo.xref_game_official_id,	xgo.game_official_type_id, 
				xgo.Ref_accept_YN,			xgo.Ref_accept_Date,
				xgo.refReportSbm_yn,		xgo.RefPaid_YN,		xgo.RefPaid_AMT,
				G.game_id,					
				CO.contact_id, 	CO.FirstName,	CO.LastName
		FROM	xref_Game_Official xgo 
							INNER JOIN tbl_contact CO	ON CO.contact_id = xgo.Contact_id 
							INNER JOIN tbl_game G		ON G.game_id = xgo.game_id 
		WHERE	G.game_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.GameID#">
		ORDER BY  xgo.game_official_type_id
	</CFQUERY>
	<cfreturn qGetOfficials>
	 
</cffunction>



<!--- ====================================================================== --->
<cffunction name="uploadGames" access="public" returntype="string">
	<!--- --------
		01/06/09 - AArnone - Load TBL_GAME and XREF_GAME_TEAM with data from TBL_GAME_UPLOAD
	----- --->
	<cfset loadNewGameText = "">
	
	<!--- Get current season id --->
	<CFQUERY name="qSeasonID" datasource="#VARIABLES.DSN#">
		SELECT SEASON_ID FROM TBL_SEASON WHERE CURRENTSEASON_YN = 'Y'
	</CFQUERY>
	<cfset currentSeasonID = qSeasonID.season_id >


	<CFQUERY name="qCheckForOfficials" datasource="#VARIABLES.DSN#">
		Select Count(*) as OffCount
		  FROM XREF_GAME_OFFICIAL
		 WHERE GAME_ID IN (Select game_id from TBL_GAME WHERE SEASON_ID = #VARIABLES.currentSeasonID#)
	</CFQUERY>

	<CFIF qCheckForOfficials.OffCount EQ 0>
		<!--- Then proceed, no refs --->
					<!--- Joe Lechuga - 8/15/2011 - Added delete statement to remove any match day forms that were created during game scheduling --->	
			<CFQUERY name="qDeleteTeamXref" datasource="#VARIABLES.DSN#">
				DELETE FROM tbl_match_day_form WHERE game_id in(select game_id from tbl_game where SEASON_ID = #VARIABLES.currentSeasonID#)
			</CFQUERY>
			<!--- delete any game/team references for the season --->	
			<CFQUERY name="qDeleteTeamXref" datasource="#VARIABLES.DSN#">
				DELETE FROM XREF_GAME_TEAM WHERE SEASON_ID = #VARIABLES.currentSeasonID#
			</CFQUERY>
			<!--- delete games for the season --->	
			<CFQUERY name="qDeleteTeamXref" datasource="#VARIABLES.DSN#">
				DELETE FROM TBL_GAME WHERE SEASON_ID = #VARIABLES.currentSeasonID#
			</CFQUERY>
		
			<!--- get games to load --->	
			<CFQUERY name="qNewGames" datasource="#VARIABLES.DSN#">
				SELECT gu.gameCode, gu.division, gu.field, 	gu.gameDate, gu.gameTime
				  FROM TBL_GAME_UPLOAD gu  
			</CFQUERY>
			<!--- SELECT gameCode, division, field, gameDate, gameTime, HomeTeamID, VisitorTeamID FROM TBL_GAME_UPLOAD --->
			
			<!--- INSERT NEW GAMES into TBL_GAME First --->
			<CFLOOP query="qNewGames">
				<!--- check field --->	
				<cfset fieldID = 0>
				<CFQUERY name="qGetField" datasource="#VARIABLES.DSN#">
					SELECT field_id FROM tbl_field WHERE fieldAbbr = '#field#'
				</CFQUERY>
				<CFIF qGetField.recordCount>
					<cfset fieldID = qGetField.field_id>
				</CFIF>
		
				<CFQUERY name="qInsertNewGame" datasource="#VARIABLES.DSN#">
					INSERT into TBL_GAME
						(game_code, season_id, game_date, game_time, division_id, field_id, createdby, createDate)
					VALUES
						( <cfqueryparam cfsqltype="CF_SQL_VARCHAR"   value="#gameCode#" >
						, <cfqueryparam cfsqltype="CF_SQL_NUMERIC"   value="#VARIABLES.currentSeasonID#" >
						, <cfqueryparam cfsqltype="CF_SQL_DATE" 	 value="#gameDate#">
						, <cfqueryparam cfsqltype="CF_SQL_TIME"		 value="#gameTime#">
						, <cfqueryparam cfsqltype="CF_SQL_VARCHAR"   value="#division#" >
						, <cfqueryparam cfsqltype="CF_SQL_NUMERIC"   value="#VARIABLES.fieldID#" >
						, 0
						, getDate()
						)
				</CFQUERY>
			</CFLOOP>
		
			<!--- get games to load for teams --->	
			<CFQUERY name="qNewGameTeams" datasource="#VARIABLES.DSN#">
				SELECT (SELECT game_id FROM TBL_GAME WHERE game_code = gu.gameCode AND season_id = #VARIABLES.currentSeasonID#) AS GAME_ID
					   ,gu.HomeTeamID    ,(SELECT CLUB_ID FROM TBL_TEAM WHERE TEAM_ID = gu.HomeTeamID)    AS HomeTeamClubID
					   ,gu.VisitorTeamID ,(SELECT CLUB_ID FROM TBL_TEAM WHERE TEAM_ID = gu.VisitorTeamID) AS VisitorTeamClubID
				  FROM TBL_GAME_UPLOAD gu  
			</CFQUERY>
			<!--- INSERT TEAMS into XREF_GAME_TEAM --->
			<CFLOOP query="qNewGameTeams">
					<!--- Do HOME team --->
					<CFQUERY name="qInsertNewGame" datasource="#VARIABLES.DSN#">
						INSERT into XREF_GAME_TEAM
							(season_id, game_id, club_id, Team_ID, IsHomeTeam)
						VALUES
							( <cfqueryparam cfsqltype="CF_SQL_NUMERIC"   value="#VARIABLES.currentSeasonID#" >
							, <cfqueryparam cfsqltype="CF_SQL_NUMERIC"   value="#GAME_ID#" >
							, <cfqueryparam cfsqltype="CF_SQL_NUMERIC"   value="#HomeTeamClubID#" >	
							, <cfqueryparam cfsqltype="CF_SQL_NUMERIC"   value="#HomeTeamID#" >
							, 1
							)
					</CFQUERY><!--- VARIABLES.clubID VARIABLES.GameId--->
		
					<!--- Do VISITING team --->
					<CFQUERY name="qInsertNewGame" datasource="#VARIABLES.DSN#">
						INSERT into XREF_GAME_TEAM
							(season_id, game_id, club_id, Team_ID, IsHomeTeam)
						VALUES
							( <cfqueryparam cfsqltype="CF_SQL_NUMERIC"   value="#VARIABLES.currentSeasonID#" >
							, <cfqueryparam cfsqltype="CF_SQL_NUMERIC"   value="#GAME_ID#" >
							, <cfqueryparam cfsqltype="CF_SQL_NUMERIC"   value="#VisitorTeamClubID#" >
							, <cfqueryparam cfsqltype="CF_SQL_NUMERIC"   value="#VisitorTeamID#" >
							, 0
							)
					</CFQUERY><!--- VARIABLES.clubID VARIABLES.GameId--->
			</CFLOOP>
			<cfset loadNewGameText = "Games Upload Completed!">
	<CFELSE>
		<!--- return refcount --->
		<cfset loadNewGameText = "Nothing Uploaded. There are " & qCheckForOfficials.OffCount & " referee(s) mapped to these games.">
	</CFIF>
 
	<cfreturn loadNewGameText>
	 
</cffunction>

<cffunction
	name="saveMatchDayForm"
	access="public"
	returntype="numeric">
	<cfargument name="game_id" type="string" required="Yes">
	<cfargument name="team_id" type="string" required="Yes">
	<cfargument name="coach1" type="string" required="Yes">
	<cfargument name="coach2" type="string" required="Yes">
	<cfargument name="coach3" type="string" required="Yes" default="">
	<cfargument name="coach4" type="string" required="Yes" default="">
	<cfargument name="coach1pass" type="string" required="Yes">
	<cfargument name="coach2pass" type="string" required="Yes">
	<cfargument name="coach3pass" type="string" required="Yes" default="">
	<cfargument name="coach4pass" type="string" required="Yes" default="">
	
	<cfstoredproc datasource="#application.dsn#" procedure="p_save_match_day_form">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@game_id" type="In" value="#arguments.game_id#">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@team_id" type="In" value="#arguments.team_id#">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@coach1" type="In" value="#arguments.coach1#">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@coach2" type="In" value="#arguments.coach2#">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@coach3" type="In" value="#arguments.coach3#" null="#yesnoformat(arguments.coach3 EQ "")#">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@coach4" type="In" value="#arguments.coach4#" null="#yesnoformat(arguments.coach4 EQ "")#">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@coach1pass" type="In" value="#arguments.coach1pass#">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@coach2pass" type="In" value="#arguments.coach2pass#">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@coach3pass" type="In" value="#arguments.coach3pass#" null="#yesnoformat(arguments.coach3pass EQ "")#">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@coach4pass" type="In" value="#arguments.coach4pass#" null="#yesnoformat(arguments.coach4pass EQ "")#">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@contact_id" type="In" value="#session.user.contactid#">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@match_day_form_id" type="Out" variable="match_day_form_id">
	</cfstoredproc>
	
	<cfreturn match_day_form_id>
	
</cffunction>

<cffunction
	name="savePlayUp"
	access="public"
	returntype="numeric">
	<cfargument name="match_day_form_id" type="string" required="Yes">
	<cfargument name="uniform_number" type="string" required="Yes">
	<cfargument name="name" type="string" required="Yes">
	<cfargument name="pass" type="string" required="Yes">
	<cfargument name="team_id" type="string" required="Yes">
	<cfargument name="other" type="string" required="No">

	<cfstoredproc datasource="#application.dsn#" procedure="p_save_play_up">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@match_day_form_id" type="In" value="#arguments.match_day_form_id#">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@uniform_number" type="In" value="#arguments.uniform_number#">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@name" type="In" value="#arguments.name#">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@pass_number" type="In" value="#arguments.pass#">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@team_id" type="In" value="#arguments.team_id#">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@other" type="In" value="#arguments.other#" null="#YesNoFormat(not len(trim(other)))#">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@contact_id" type="In" value="#session.user.contactid#">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@play_up_id" type="Out" variable="play_up_id">
	</cfstoredproc>
	
	<cfreturn play_up_id>
	
</cffunction>

<cffunction
	name="removePlayUps"
	access="public"
	returntype="any">
	<cfargument name="match_day_form_id" type="string" required="Yes">
	
	<cfstoredproc datasource="#application.dsn#" procedure="p_remove_play_ups">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@match_day_form_id" type="In" value="#arguments.match_day_form_id#">
	</cfstoredproc>
	
</cffunction>


<!--- ------------------ --->
<!--- End component GAME --->
<!--- ------------------ --->
</cfcomponent>