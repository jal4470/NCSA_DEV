

<cfcomponent>
<CFSET DSN = SESSION.DSN>

<!--- =================================================================== --->
<cffunction name="getDivisions" access="public" returntype="query">
	<!--- --------
		10/01/08 - AArnone - RETURNS all divisions for the current season
		12/11/08 - aa - got rid of joins
	----- --->
		<!--- SELECT distinct IsNull(T.Gender,'') + right(T.TeamAge,2) + IsNull(T.PlayLevel,'') + IsNull(T.PlayGroup,'') AS DIVISION   
		  FROM tbl_team T
		  			LEFT JOIN  tbl_contact HC ON HC.contact_id = T.ContactIDHead 
					LEFT JOIN  tbl_contact AC ON AC.contact_id = T.ContactIDAsst 
					INNER JOIN tbl_club    CL ON CL.club_id    = T.club_id
		 Where (T.TeamStatus is NULL or T.TeamStatus = '')
		   AND T.TeamAge is not null		
		   AND CL.club_ID <> 1
		   AND T.season_id = (select season_id from tbl_season where currentSeason_YN = 'Y')
		 order by IsNull(Gender,'') + right(TeamAge, 2) + IsNull(PlayLevel,'') + IsNull(PlayGroup,'')  --->

	<CFQUERY name="qDivs" datasource="#VARIABLES.DSN#">
		SELECT distinct IsNull(T.Gender,'') + right(T.TeamAge,2) + IsNull(T.PlayLevel,'') + IsNull(T.PlayGroup,'') AS DIVISION   
		  FROM tbl_team T
		 Where (T.TeamStatus is NULL or T.TeamStatus = '')
		   AND T.TeamAge is not null		
		   AND T.season_id = (select season_id from tbl_season where currentSeason_YN = 'Y')
		 order by IsNull(Gender,'') + right(TeamAge, 2) + IsNull(PlayLevel,'') + IsNull(PlayGroup,'') 
	</CFQUERY>
	
	<cfreturn qDivs>
</cffunction>

<!--- =================================================================== --->
<cffunction name="getPreviousSeasonDivisions" access="public" returntype="query">
	<!--- --------
		06/24/16 - R. Gonzalez - Returns all divisions from the previous season
		12/21/16 - R. Gonzalez - Updated query to check against open registration values to get the proper previous season
	----- --->
	<CFQUERY name="qDivs" datasource="#VARIABLES.DSN#">
		SELECT distinct IsNull(T.Gender,'') + right(T.TeamAge,2) + IsNull(T.PlayLevel,'') + IsNull(T.PlayGroup,'') AS DIVISION   
		FROM tbl_team T
		Where (T.TeamStatus is NULL or T.TeamStatus = '')
		AND T.TeamAge is not null		
		AND T.season_id = ((select max(season_id) from tbl_season where registrationOpen_YN = 'Y' or tempRegOpen_YN = 'Y' or currentSeason_YN = 'Y') - 1)
		order by IsNull(Gender,'') + right(TeamAge, 2) + IsNull(PlayLevel,'') + IsNull(PlayGroup,'')
	</CFQUERY>
	
	<cfreturn qDivs>
</cffunction>
	



<!--- =================================================================== --->
<cffunction name="getClubTeams" access="public" returntype="query">
	<!--- --------
		08/11/08 - AArnone - New function: retruns a list of teams for a club id
		12/10/08 - aa - added cell phone
		
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#TEAM" method="getClubTeams" returnvariable="qTeams">
		<cfinvokeargument name="clubID"	 value="#VARIABLES.xxxxxx#"> optional
		<cfinvokeargument name="orderBy" value="TEAMNAME>	optional, by division if excluded
	</cfinvoke>
	----- --->

	<cfargument name="clubID"	type="numeric" required="no" default=0 >
	<cfargument name="orderBy"	type="string"  required="no" default="division">
	<cfargument name="season_id" type="string"  required="no">
	<cfargument name="excludeNonLeague" type="boolean" default="No">
	
	<cfswitch expression="#ucase(ARGUMENTS.orderBy)#">
		<cfcase value="TEAMNAME">
			<CFSET orderBy = "order by TEAMNAMEderived">
		</cfcase>
		<cfcase value="CLUB">
			<cfset orderBy = "order by cl.club_name, t.teamname">
		</cfcase>
		<cfdefaultcase>
			<CFSET orderBy = "order by DIVISION">
		</cfdefaultcase>
	</cfswitch>

	<CFIF ARGUMENTS.clubID GT 0>
		<CFSET useClub = " CL.CLUB_ID = " & ARGUMENTS.clubID>
	<CFELSE>
		<CFSET useClub = " 1 = 1 "	>
	</CFIF>

	<CFQUERY name="qClubTeams" datasource="#VARIABLES.DSN#">
		SELECT IsNull(T.Gender,'') + right(T.TeamAge,2) + IsNull(T.PlayLevel,'') + IsNull(T.PlayGroup,'') AS DIVISION,  
			   T.team_id,
			   T.ContactIDHead, T.ContactIDAsst, 
			   T.club_id AS clubid, dbo.getteamname(t.team_id) as teamName, 
			   T.Comments,
			   T.Registered_YN,
			   CL.ClubAbbr + '-' + IsNull(T.Gender,'') + right(T.TeamAge,2) + IsNull(T.PlayLevel,'') + IsNull(T.PlayGroup,'')+ '-' + HC.LastName AS TEAMNAMEderived, 
			   T.teamAge, T.playLevel, T.gender, 
			   T.USSFDiv, T.season_id, T.suffix, T.teamstatus, 
			   HC.FirstName AS coachFirstName,  HC.LastName AS coachLastName, 
			   HC.PhoneHome AS coachHomePhone,  HC.PhoneCell AS coachCellPhone, HC.EMAIL AS coachEmail,
			   AC.FirstName AS asstCoachFirstNAme,  AC.LastName AS asstCoachLastName, 
			   AC.PhoneHome AS asstHomePhone,	AC.PhoneCell AS asstCellPhone,	AC.EMAIL AS asstEmail,
			   AC2.FirstName AS asst2CoachFirstNAme,  AC2.LastName AS asst2CoachLastName, 
			   AC2.PhoneHome AS asst2HomePhone,	AC2.PhoneCell AS asst2CellPhone,	AC2.EMAIL AS asst2Email,
			   AC3.FirstName AS asst3CoachFirstNAme,  AC3.LastName AS asst3CoachLastName, 
			   AC3.PhoneHome AS asst3HomePhone,	AC3.PhoneCell AS asst3CellPhone,	AC3.EMAIL AS asst3Email,
			   CL.ClubAbbr, CL.club_id, CL.Club_name
		  FROM tbl_team T	
				INNER JOIN tbl_club    CL ON CL.club_id    = T.club_id
		  		LEFT JOIN  tbl_contact HC ON HC.contact_id = T.ContactIDHead 
				LEFT JOIN  tbl_contact AC ON AC.contact_id = T.ContactIDAsst 
				LEFT JOIN  tbl_contact AC2 ON AC2.contact_id = T.ContactIDAsst2 
				LEFT JOIN  tbl_contact AC3 ON AC3.contact_id = T.ContactIDAsst3 
		 WHERE #useClub#
		 	<cfif isdefined("arguments.season_id")>
			AND T.season_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.season_id#">
			<cfelse>
		    AND T.season_id = (select season_id from tbl_season where currentSeason_YN = 'Y')
			</cfif>
			<cfif arguments.excludeNonLeague>
			AND T.playLevel <> 'R'
			</cfif>
		  #orderBy#
	</CFQUERY>
	
	<cfreturn qClubTeams>
</cffunction>

<!--- =================================================================== --->
<cffunction name="getDivisionTeams" access="public" returntype="query">
	<!--- --------
		10/01/08 - AArnone - selects all the teams in a division
		03/06/09 - aarnone - ticket:7309 - virtual team changes for state cup and non league games

	----- --->
	<cfargument name="division"	type="string" required="yes">

	<cfquery name="qDivTeams" datasource="#VARIABLES.DSN#">
		SELECT T.team_id,  T.teamName, CL.ClubAbbr, CL.club_id, CL.Club_name,
			   CL.ClubAbbr + '-' + IsNull(T.Gender,'') + right(T.TeamAge,2) + IsNull(T.PlayLevel,'') + IsNull(T.PlayGroup,'')+ '-' + HC.LastName AS TEAMNAMEderived, 
			   T.teamAge, T.playLevel, T.gender, T.approved_yn,
			   T.USSFDiv, T.season_id, T.suffix, T.teamstatus
		  FROM tbl_team T	LEFT JOIN  tbl_contact HC ON HC.contact_id = T.ContactIDHead 
							INNER JOIN tbl_club    CL ON CL.club_id    = T.club_id
		 Where (T.teamStatus is NULL or T.teamStatus = '') 
		   and IsNull(T.Gender,'') + right(T.TeamAge, 2) + IsNull(T.PlayLevel,'') + IsNull(T.PlayGroup,'') = '#ARGUMENTS.division#'
		   and CL.Club_Id <> 1 
		   AND T.season_id = (select season_id from tbl_season where currentSeason_YN = 'Y')
		 Order by TEAMNAMEderived
	</cfquery>	
	<cfreturn qDivTeams>
</cffunction>
	

<!--- =================================================================== --->
<cffunction name="getTeamInfo" access="public" returntype="query">
	<!--- --------
		09/19/08 - AArnone - 
	----- --->
	<cfargument name="TeamID"	type="numeric" required="no" default=0 >
	
	<CFQUERY name="qGetTeam" datasource="#VARIABLES.DSN#">
		SELECT IsNull(T.Gender,'') + right(T.TeamAge,2) + IsNull(T.PlayLevel,'') + IsNull(T.PlayGroup,'') AS DIVISION,   -- 
			   T.team_id, T.teamName, 
			   T.ContactIDHead, T.ContactIDAsst, 
			   T.ContactIDAsst2, T.ContactIDAsst3,
			   T.club_id, T.Comments, T.Registered_YN,
			   --CL.ClubAbbr + '-' + HC.LastName + '-' + T.division + IsNull(T.PlayGroup,'') AS TEAMNAMEderived, 
			   CL.ClubAbbr + '-' + IsNull(T.Gender,'') + right(T.TeamAge,2) + IsNull(T.PlayLevel,'') + IsNull(T.PlayGroup,'')+ '-' + HC.LastName AS TEAMNAMEderived, 
			   T.gender, T.teamAge, T.playLevel, 
			   T.USSFDiv, T.season_id, T.suffix, T.teamstatus, T.nonSundayPlay,
			   HC.FirstName AS coachFirstName,  HC.LastName AS coachLastName, 
			   HC.PhoneHome AS coachHomePhone,  HC.EMAIL    AS coachEmail,
			   AC.FirstName AS asstCoachFirstNAme,  AC.LastName AS asstCoachLastName, 
			   AC.PhoneHome AS asstHomePhone,  		AC.EMAIL    AS asstEmail,
			   AC2.FirstName AS asstCoach2FirstNAme,  AC2.LastName AS asstCoach2LastName, 
			   AC2.PhoneHome AS asst2HomePhone,  		AC2.EMAIL    AS asst2Email,
			   AC3.FirstName AS asstCoach3FirstNAme,  AC3.LastName AS asstCoach3LastName, 
			   AC3.PhoneHome AS asst3HomePhone,  		AC3.EMAIL    AS asst3Email,
			   CL.ClubAbbr, CL.Club_name,
			   T.roster, T.prevPlayLevel, T.reasonForPlayLevel, T.teamFormed, T.teamAvailability, T.soccerID
		  FROM tbl_team T	LEFT JOIN  tbl_contact HC ON HC.contact_id = T.ContactIDHead 
							LEFT JOIN  tbl_contact AC ON AC.contact_id = T.ContactIDAsst 
							LEFT JOIN  tbl_contact AC2 ON AC2.contact_id = T.ContactIDAsst2 
							LEFT JOIN  tbl_contact AC3 ON AC3.contact_id = T.ContactIDAsst3 
							INNER JOIN tbl_club    CL ON CL.club_id    = T.club_id
		 WHERE T.team_id = #ARGUMENTS.teamID#
	</CFQUERY>
	
	<cfreturn qGetTeam>
</cffunction>
	

<!--- =================================================================== --->
<cffunction name="deleteTeam" access="public">
	<!--- --------
		09/10/08 - AArnone - deletes a team
	----- --->
	<cfargument name="teamID"	type="numeric" required="Yes">
	
			<!--- <CFQUERY name="deleteTeam" datasource="#VARIABLES.DSN#">
				DELETE FROM TBL_TEAM
				 Where TEAM_ID 	 = #ARGUMENTS.teamID#
				   AND Season_id = #ARGUMENTS.seasonID#
			</CFQUERY> --->
			
			<cfstoredproc datasource="#dsn#" procedure="p_delete_team">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@team_id" type="In" value="#arguments.teamID#">
			</cfstoredproc>
			
</cffunction>



<!--- =================================================================== --->
<cffunction name="updateRegTeam" access="public">
	<!--- --------
		09/10/08 - AArnone - updates a registered team
		01/16/09 - AArnone - RequestDiv
	----- --->
	<cfargument name="updContactID"	type="numeric" required="Yes">
	<cfargument name="TeamAge"      type="string" required="Yes">
	<cfargument name="USSFDiv"      type="string" required="Yes">
	<cfargument name="PlayLevel"    type="string" required="Yes">
	<cfargument name="Gender"       type="string" required="Yes">
	<cfargument name="HeadCoachID"	type="numeric" required="Yes">
	<cfargument name="AsstCoachID"	type="numeric" required="Yes">
	<cfargument name="Asst2CoachID"	type="numeric" required="Yes">
	<cfargument name="Asst3CoachID"	type="numeric" required="Yes">
	<cfargument name="nonSundayPlay" type="string" required="Yes">
	<cfargument name="TeamID"       type="string" required="Yes">
	<cfargument name="ReqDiv"       type="string" required="Yes">

	<CFQUERY name="updateTeamReg" datasource="#SESSION.DSN#">
		Update TBL_TEAM
		   set Approved_YN	 = 'Y'
		     , updateDate 	 = getdate()
			 , upDatedBy	 =  #ARGUMENTS.updContactID#
			 , teamAge		 = '#ARGUMENTS.TeamAge#'
			 , USSFDiv		 = '#ARGUMENTS.USSFDiv#'
			 , RequestDiv	 = '#ARGUMENTS.ReqDiv#'
			 , playLevel	 = '#ARGUMENTS.PlayLevel#'
			 , gender		 = '#ARGUMENTS.Gender#'
			 , ContactIDHead =  #ARGUMENTS.HeadCoachID#
			 , ContactIDAsst =  #ARGUMENTS.AsstCoachID#
			 , ContactIDAsst2 =  #ARGUMENTS.Asst2CoachID#
			 , ContactIDAsst3 =  #ARGUMENTS.Asst3CoachID#
			 , nonSundayPlay = '#ARGUMENTS.NonSundayPlay#'
	     Where TEAM_ID 	 	 =  #ARGUMENTS.TeamId#
	</CFQUERY>
</cffunction>

<!--- =================================================================== --->
<cffunction name="updateTeamCoaches" access="public">
	<!--- --------
		12/02/08 - AArnone - updates the coaches of a team
	----- --->
	<cfargument name="updContactID"	type="numeric" required="Yes">
	<cfargument name="HeadCoachID"	type="numeric" required="Yes">
	<cfargument name="AsstCoachID"	type="numeric" required="Yes">
	<cfargument name="AsstCoachID2"	type="numeric" required="No">
	<cfargument name="AsstCoachID3"	type="numeric" required="No">
	<cfargument name="TeamID"       type="string" required="Yes">

	<CFQUERY name="updateTeamReg" datasource="#SESSION.DSN#">
		Update TBL_TEAM
		   set ContactIDHead = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.HeadCoachID#">
			 , ContactIDAsst = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.AsstCoachID#">
			 , ContactIDAsst2 = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.AsstCoachID2#">
			 , ContactIDAsst3 = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.AsstCoachID3#">
			 , updateDate 	 = getdate()
			 , upDatedBy	 = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.updContactID#">
	     Where TEAM_ID 	 	 = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.TeamId#">
	</CFQUERY>

	<!--- update team name --->
	<cfinvoke method="updateTeamName">
		<cfinvokeargument name="TeamID"  value="#ARGUMENTS.TeamId#">
	</cfinvoke>
</cffunction>

<!--- =================================================================== --->
<cffunction name="updateTeamName" access="public">
	<!--- --------
		09/10/08 - AArnone - updates a Team's name
	----- --->
	<cfargument name="TeamID"       type="string" required="Yes">
	
	<cfstoredProc procedure="p_update_teamname" datasource="#variables.dsn#">
		<cfprocparam type="In" dbvarname="@teamid" cfsqltype="CF_SQL_NUMERIC" value="#arguments.TeamID#">
	</cfstoredproc>
</cffunction>

<!--- =================================================================== --->
<cffunction name="approveTeam" access="public">
	<!--- --------
		09/10/08 - AArnone - approves a registered team
	----- --->
	<cfargument name="updContactID"	type="numeric" required="Yes">
	<cfargument name="TeamID"       type="string" required="Yes">

	<CFQUERY name="approveTeam" datasource="#SESSION.DSN#">
		Update TBL_TEAM
		   set Approved_YN	= 'Y'
	 		 , updateDate = getdate()
			 , upDatedBy  = #ARGUMENTS.updContactID#
		 Where TEAM_ID 	  = #ARGUMENTS.TeamId#					
	</CFQUERY>
</cffunction>


<!--- =================================================================== --->
<cffunction name="TeamPlayWeeks" access="public" returntype="query">
	<!--- 09/10/08 - AArnone - approves a registered team
	----- --->
	<cfargument name="TeamID" type="numeric" required="Yes">

 	<CFQUERY name="teamPlayWeeks" datasource="#VARIABLES.DSN#">
		Select CP.team_id,
			   CP.Coach_playweek_id, CP.playWeekend_id,
			   CP.SatAvailable_YN, CP.SunAvailable_YN,
			   CP.satTime,		   CP.SunTime,
			   CP.SatBeforeAfter,  CP.SunBeforeAfter,
			   pw.day1_date,	   pw.day2_date,
			   PW.Week_number 
		  from tbl_coach_playweek CP 
		  				INNER JOIN tbl_playWeekEnd PW ON PW.playWeekend_id = CP.playWeekend_id
		 Where team_id = #ARGUMENTS.TeamID#
	</CFQUERY>
	
	<cfreturn teamPlayWeeks>
</cffunction>



<!--- =================================================================== --->
<cffunction name="insertTeamPlayweek" access="public" >
	<!--- 09/11/08 - AArnone - insert into tbl_coach_playweek
	----- --->
	<cfargument name="teamID"     type="numeric" required="Yes">
	<cfargument name="playWEid"   type="numeric" required="Yes">
	<cfargument name="SAT_time"   type="string"  required="Yes">
	<cfargument name="SAT_Avail"  type="string"  required="Yes">
	<cfargument name="SAT_BefAft" type="string"  required="Yes">
	<cfargument name="SUN_time"   type="string"  required="Yes">
	<cfargument name="SUN_Avail"  type="string"  required="Yes">
	<cfargument name="SUN_BefAft" type="string"  required="Yes">
	
	<CFQUERY name="insetPW" datasource="#VARIABLES.DSN#">
		INSERT into tbl_coach_playweek
			   (team_id,
			   SatAvailable_YN,  SatTime, SatBeforeAfter,
			   SunAvailable_YN,  SunTime, SunBeforeAfter,
			   playWeekend_id )
		VALUES (#teamID#
			   ,'#ARGUMENTS.SAT_Avail#'	
			   ,'#ARGUMENTS.SAT_time#'	
			   ,'#ARGUMENTS.SAT_BefAft#'	
			   ,'#ARGUMENTS.SUN_Avail#'	
			   ,'#ARGUMENTS.SUN_time#'	
			   ,'#ARGUMENTS.SUN_BefAft#'	
			   , #ARGUMENTS.playWEid#	
			   )
	</CFQUERY>
	
</cffunction>

<!--- =================================================================== --->
<cffunction name="updateTeamPlayweek" access="public" >
	<!--- 09/11/08 - AArnone - update tbl_coach_playweek
	----- --->
	<cfargument name="teamID"     type="numeric" required="Yes">
	<cfargument name="playWEid"   type="numeric" required="Yes">
	<cfargument name="SAT_time"   type="string"  required="Yes">
	<cfargument name="SAT_Avail"  type="string"  required="Yes">
	<cfargument name="SAT_BefAft" type="string"  required="Yes">
	<cfargument name="SUN_time"   type="string"  required="Yes">
	<cfargument name="SUN_Avail"  type="string"  required="Yes">
	<cfargument name="SUN_BefAft" type="string"  required="Yes">

	<CFQUERY name="updatePW" datasource="#VARIABLES.DSN#">
		Update tbl_coach_playweek
		   set SatAvailable_YN	= '#ARGUMENTS.SAT_Avail#'
			 ,	SATTime			= '#ARGUMENTS.SAT_time#'
			 ,	SATBeforeAfter	= '#ARGUMENTS.SAT_BefAft#'
			 ,	SunAvailable_YN	= '#ARGUMENTS.SUN_Avail#'
			 ,	SUNTime			= '#ARGUMENTS.SUN_time#'	
			 ,	SUNBeforeAfter	= '#ARGUMENTS.SUN_BefAft#'
		 Where team_id			= #teamID#
		   and playWeekend_id	= #ARGUMENTS.playWEid#	
	</CFQUERY>
	
</cffunction>

							
<!--- =================================================================== --->
<cffunction name="getTeamID" access="public" returntype="query">
	<!--- --------
		02/03/09 - AArnone - 
		02/05/09 - AArnone - added sort by
	----- --->
	<cfargument name="gender" 	type="string" required="no" default="" >
	<cfargument name="age"    	type="string" required="no" default="" >
	<cfargument name="playLevel" type="string" required="No" default="">
	<cfargument name="seasonID" type="numeric" required="Yes">
	<cfargument name="sortBy"   type="string" required="No" default="">

	<cfswitch expression="#ucase(ARGUMENTS.sortBy)#">
		<cfcase value="DIVISION"> 
			<cfset orderByClause = " ORDER BY DIVISION, TEAMNAMEderived "> 
		</cfcase>
		<cfcase value="TEAMNAME">
			<cfset orderByClause = " ORDER BY TEAMNAMEderived "> 
		</cfcase>
		<cfcase value="TEAMID">
			<cfset orderByClause = " ORDER BY T.TEAM_ID "> 
		</cfcase>
		<cfdefaultcase>
			<cfset orderByClause = " ORDER BY TEAMNAMEderived "> 
		</cfdefaultcase>
	</cfswitch>

	<CFQUERY name="qGetTeamIDs" datasource="#VARIABLES.DSN#">
		SELECT T.team_id, 
			   IsNull(T.Gender,'') + right(T.TeamAge,2) + IsNull(T.PlayLevel,'') + IsNull(T.PlayGroup,'') AS DIVISION,
			   dbo.getTeamName(T.team_id) AS TEAMNAMEderived
		  FROM tbl_team T	LEFT JOIN  tbl_contact HC     ON HC.contact_id = T.ContactIDHead 
							LEFT JOIN  tbl_contact AC     ON AC.contact_id = T.ContactIDAsst 
							INNER JOIN tbl_club    CL     ON CL.club_id    = T.club_id
							INNER JOIN XREF_CLUB_SEASON X ON X.club_id     = CL.club_id 
															AND X.SEASON_ID = #ARGUMENTS.SEASONID# 
															AND X.ACTIVE_YN = 'Y' 
		 WHERE T.season_id   = #ARGUMENTS.SEASONID#
		   AND T.Approved_YN = 'Y'
			<CFIF isDefined("ARGUMENTS.GENDER") AND LEN(TRIM(ARGUMENTS.GENDER))>
				AND	T.Gender = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.GENDER#">
			</cfif>
			<CFIF isDefined("ARGUMENTS.age") AND LEN(TRIM(ARGUMENTS.age))>
				AND T.TeamAge = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.AGE#">
			</cfif>
			<CFIF isDefined("ARGUMENTS.playLevel") AND LEN(TRIM(ARGUMENTS.playLevel))>
				AND T.playLevel = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.playLevel#">
			</cfif>
		#variables.orderByClause#
	</CFQUERY>
	<cfreturn qGetTeamIDs>
</cffunction>

<cffunction
	name="getContactTeams"
	access="public"
	returntype="query"
	description="Retrieves a list of teams viewable by a contact.  gets a coaches teams or a club reps teams">
	<cfargument name="contact_id" type="string" required="Yes">
	<cfargument name="season_id" type="string" required="No">
	<cfargument name="excludeNonLeague" type="boolean" default="No">
	
	<!--- get season --->
	<cfset season_id=session.currentseason.id>
	
	<!--- get roles --->
	<cfinvoke
		component="#SESSION.SITEVARS.cfcPath#contact"
		method="getContactRoles"
		contactid="#arguments.contact_Id#"
		seasonid="#season_id#"
		returnvariable="contactRoles">
	
	<cfinvoke
		component="#session.sitevars.cfcpath#utility"
		method="listIntersect"
		list1="#valuelist(contactRoles.role_id)#"
		list2=""
		returnvariable="contactClubRoles">
		
	<cfif listlen(contactClubRoles) GT 0>
		<!--- club contact --->
	<cfelseif listfind(valuelist(contactRoles.role_id),"29") NEQ 0>
		<!--- coach contact --->
		<cfquery datasource="#application.dsn#" name="getTeams">
			select distinct t.team_id, dbo.getteamname(t.team_id) as teamname from tbl_team t
			where (t.contactidhead=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.contact_id#"> 
			or t.contactidasst=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.contact_id#">
			or t.contactidasst2=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.contact_id#">
			or t.contactidasst3=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.contact_id#">)
			<cfif isdefined("arguments.season_id")>
			AND season_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.season_id#">
			</cfif>
			<cfif arguments.excludeNonLeague>
			AND t.playLevel <> 'R'
			</cfif>
		</cfquery>
	</cfif>
	
	<cfreturn getTeams>
	
</cffunction>


</cfcomponent>



