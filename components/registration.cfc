

<cfcomponent>
<CFSET DSN = SESSION.DSN>

<!--- ============================================
	functions:
		insertNewClubRequest - Inserts a new club request
		getNewClubRequests   -
		ClubRequestDetails   -

============================================= --->

<!--- 

7/14/2010 B. Cooper
8747-Added call to p_create_new_club_season to RegisterNewClub.  not sure why it was missing.  
It seems to be the main functionality of that method
6/24/2016 R. Gonzalez
Ticket NCSA22671 - Added AsstCoachID2,AsstCoachID3,Roster,PrevPlayLevel,ReasonForPlayLevel,
	TeamFormed,TeamAvailability,SoccerID support to method registerNewTeam
7/25/2017 J LECHUGA
	-Added Missing Second Team Logic

 --->

<!--- =================================================================== --->
<cffunction name="RegisterExistingClub" access="remote" returntype="string">
	<!--- --------
		09/03/08 - AArnone - New function: Inserts a new club request
	----- --->
	<cfargument name="clubID" 	      type="numeric" required="Yes">
	<cfargument name="ClubName"	      type="string" required="Yes">
	<cfargument name="ClubHomePage"   type="string"	required="Yes">
	<cfargument name="ClubEMail"      type="string" required="Yes">
	<cfargument name="HomeShirtColor" type="string" required="Yes">
	<cfargument name="HomeShortColor" type="string" required="Yes">
	<cfargument name="AwayShirtColor" type="string" required="Yes">
	<cfargument name="AwayShortColor" type="string" required="Yes">
	<cfargument name="registeredBy"   type="string" required="Yes">
	<!---<cfargument name="ApproveReg"     type="string" required="No"  default="N">  OPTIONAL --->
	<cfargument name="SeasonID"       type="numeric" required="No">				<!--- OPTIONAL --->
	<cfargument name="ClubPresID"     type="numeric" required="Yes">
	<cfargument name="ClubREPID"      type="numeric" required="Yes">
	<cfargument name="ClubALTID"      type="numeric" required="No">

	<CFQUERY name="qWasClubRegd" datasource="#VARIABLES.DSN#">
		SELECT 	club_id
		  FROM  xref_club_season
		 WHERE  CLUB_ID   = <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.clubID#">  
		   AND  season_id = <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.seasonID#">
	</CFQUERY> <!--- APPROVED_YN = 'Y' new clubs not approved for reg yet but exist in xref --->

	<CFIF qWasClubRegd.RECORDCOUNT>
		<!--- CLUB INFO WAS ALREADY SUBMITTED FOR REGISTRATION --->
		<CFSET regMsg = "The club information was already submitted." >	
	<CFELSE>
		<!--- INSERT CLUB REG --->
		<!--- update club info --->
		<CFQUERY name="qUpdateClubInfo" datasource="#VARIABLES.DSN#">
			 Update TBL_CLUB
				set CLUB_NAME	   	= <CFQUERYPARAM cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ClubName#">
				  , ClubHomePage	= <CFQUERYPARAM cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ClubHomePage#">
				  , ClubEMail		= <CFQUERYPARAM cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ClubEMail#">
				  , HomeShirtColor	= <CFQUERYPARAM cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.HomeShirtColor#">
				  , HomeShortColor	= <CFQUERYPARAM cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.HomeShortColor#">
				  , AwayShirtColor	= <CFQUERYPARAM cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.AwayShirtColor#">
				  , AwayShortColor	= <CFQUERYPARAM cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.AwayShortColor#">
				  , UpdateDate	    = getdate()	
				  , UpdatedBy		= <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.registeredBy#">
			  Where CLUB_ID = <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.ClubId#">
		</CFQUERY>

		<!--- DOENS'T EXIST - insert club season xref --->
		<CFSTOREDPROC procedure="p_create_new_club_season" datasource="#VARIABLES.DSN#">
			<cfprocparam type="In" dbvarname="@club_id"    cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.ClubID#">
			<cfprocparam type="In" dbvarname="@season_id"  cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.seasonID#">
			<cfprocparam type="In" dbvarname="@created_by" cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.registeredBy#">
		</CFSTOREDPROC> 
		
		<CFQUERY name="qRemoveRoles" datasource="#VARIABLES.DSN#">
			DELETE FROM XREF_CONTACT_ROLE 
			 WHERE CLUB_ID = #ARGUMENTS.ClubID#
			  AND SEASON_ID = #ARGUMENTS.SeasonID#
		</CFQUERY>
		<!--- INSERT Club personnel for season --->
		<CFIF isDefined("ARGUMENTS.ClubPresID") and ARGUMENTS.ClubPresID GT 0>
			<!--- INSERT  --->
			<cfinvoke component="contact" method="insertContactRole">
				<cfinvokeargument name="contactID"   value="#ARGUMENTS.ClubPresID#">
				<cfinvokeargument name="roleID" 	 value="26">
				<cfinvokeargument name="ClubId" 	 value="#ARGUMENTS.ClubID#">
				<cfinvokeargument name="seasonID"    value="#ARGUMENTS.SeasonID#">
				<cfinvokeargument name="activeYN"	 value="Y">
				<cfinvokeargument name="allowGameEdit" value="0">
			</cfinvoke>
		</CFIF>

		<CFIF isDefined("ARGUMENTS.ClubREPID") and ARGUMENTS.ClubREPID GT 0>
			<!--- INSERT  --->
			<cfinvoke component="contact" method="insertContactRole">
				<cfinvokeargument name="contactID"   value="#ARGUMENTS.ClubREPID#">
				<cfinvokeargument name="roleID" 	 value="27">
				<cfinvokeargument name="ClubId" 	 value="#ARGUMENTS.ClubID#">
				<cfinvokeargument name="seasonID"    value="#ARGUMENTS.SeasonID#">
				<cfinvokeargument name="activeYN"	 value="Y">
				<cfinvokeargument name="allowGameEdit" value="0">
			</cfinvoke>
		</CFIF>

		<CFIF isDefined("ARGUMENTS.ClubALTID") and ARGUMENTS.ClubALTID GT 0>
			<!--- INSERT  --->
			<cfinvoke component="contact" method="insertContactRole">
				<cfinvokeargument name="contactID"   value="#ARGUMENTS.ClubALTID#">
				<cfinvokeargument name="roleID" 	 value="28">
				<cfinvokeargument name="ClubId" 	 value="#ARGUMENTS.ClubID#">
				<cfinvokeargument name="seasonID"    value="#ARGUMENTS.SeasonID#">
				<cfinvokeargument name="activeYN"	 value="Y">
				<cfinvokeargument name="allowGameEdit" value="0">
			</cfinvoke>
		</CFIF>
		
		<cfset regMsg = "">
	</CFIF>
		  
	<cfreturn regMsg>
</cffunction>


<!--- =================================================================== --->
<cffunction name="RegisterNewClub" access="remote" returntype="string">
	<!--- --------
		12/12/08 - AArnone - New function: Inserts a new club request
	----- --->
	<cfargument name="clubID" 	      type="numeric" required="Yes">
	<cfargument name="ClubName"	      type="string" required="Yes">
	<cfargument name="ClubHomePage"   type="string"	required="Yes">
	<cfargument name="ClubEMail"      type="string" required="Yes">
	<cfargument name="HomeShirtColor" type="string" required="Yes">
	<cfargument name="HomeShortColor" type="string" required="Yes">
	<cfargument name="AwayShirtColor" type="string" required="Yes">
	<cfargument name="AwayShortColor" type="string" required="Yes">
	<cfargument name="registeredBy"   type="string" required="Yes">
	<!---<cfargument name="ApproveReg"     type="string" required="No"  default="N">  OPTIONAL --->
	<cfargument name="SeasonID"       type="numeric" required="No">				<!--- OPTIONAL --->
	<cfargument name="ClubPresID"     type="numeric" required="Yes">
	<cfargument name="ClubREPID"      type="numeric" required="Yes">
	<cfargument name="ClubALTID"      type="numeric" required="No">

	<!--- INSERT CLUB REG --->
	<!--- update club info --->
	<CFQUERY name="qUpdateClubInfo" datasource="#VARIABLES.DSN#">
			 Update TBL_CLUB
				set CLUB_NAME	   	= <CFQUERYPARAM cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ClubName#">
				  , ClubHomePage	= <CFQUERYPARAM cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ClubHomePage#">
				  , ClubEMail		= <CFQUERYPARAM cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ClubEMail#">
				  , HomeShirtColor	= <CFQUERYPARAM cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.HomeShirtColor#">
				  , HomeShortColor	= <CFQUERYPARAM cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.HomeShortColor#">
				  , AwayShirtColor	= <CFQUERYPARAM cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.AwayShirtColor#">
				  , AwayShortColor	= <CFQUERYPARAM cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.AwayShortColor#">
				  , UpdateDate	    = getdate()	
				  , UpdatedBy		= <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.registeredBy#">
			  Where CLUB_ID = <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.ClubId#">
	</CFQUERY>

	<!--- DOENS'T EXIST - insert club season xref --->
	<CFSTOREDPROC procedure="p_create_new_club_season" datasource="#VARIABLES.DSN#">
		<cfprocparam type="In" dbvarname="@club_id"    cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.ClubID#">
		<cfprocparam type="In" dbvarname="@season_id"  cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.seasonID#">
		<cfprocparam type="In" dbvarname="@created_by" cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.registeredBy#">
	</CFSTOREDPROC> 

	<CFQUERY name="qRemoveRoles" datasource="#VARIABLES.DSN#">
			DELETE FROM XREF_CONTACT_ROLE 
			 WHERE CLUB_ID = #ARGUMENTS.ClubID#
			  AND SEASON_ID = #ARGUMENTS.SeasonID#
	</CFQUERY>
	<!--- INSERT Club personnel for season --->
	<CFIF isDefined("ARGUMENTS.ClubPresID") and ARGUMENTS.ClubPresID GT 0>
			<!--- INSERT  --->
			<cfinvoke component="contact" method="insertContactRole">
				<cfinvokeargument name="contactID"   value="#ARGUMENTS.ClubPresID#">
				<cfinvokeargument name="roleID" 	 value="26">
				<cfinvokeargument name="ClubId" 	 value="#ARGUMENTS.ClubID#">
				<cfinvokeargument name="seasonID"    value="#ARGUMENTS.SeasonID#">
				<cfinvokeargument name="activeYN"	 value="Y">
				<cfinvokeargument name="allowGameEdit" value="0">
			</cfinvoke>
	</CFIF>

	<CFIF isDefined("ARGUMENTS.ClubREPID") and ARGUMENTS.ClubREPID GT 0>
			<!--- INSERT  --->
			<cfinvoke component="contact" method="insertContactRole">
				<cfinvokeargument name="contactID"   value="#ARGUMENTS.ClubREPID#">
				<cfinvokeargument name="roleID" 	 value="27">
				<cfinvokeargument name="ClubId" 	 value="#ARGUMENTS.ClubID#">
				<cfinvokeargument name="seasonID"    value="#ARGUMENTS.SeasonID#">
				<cfinvokeargument name="activeYN"	 value="Y">
				<cfinvokeargument name="allowGameEdit" value="0">
			</cfinvoke>
	</CFIF>

	<CFIF isDefined("ARGUMENTS.ClubALTID") and ARGUMENTS.ClubALTID GT 0>
			<!--- INSERT  --->
			<cfinvoke component="contact" method="insertContactRole">
				<cfinvokeargument name="contactID"   value="#ARGUMENTS.ClubALTID#">
				<cfinvokeargument name="roleID" 	 value="28">
				<cfinvokeargument name="ClubId" 	 value="#ARGUMENTS.ClubID#">
				<cfinvokeargument name="seasonID"    value="#ARGUMENTS.SeasonID#">
				<cfinvokeargument name="activeYN"	 value="Y">
				<cfinvokeargument name="allowGameEdit" value="0">
			</cfinvoke>
	</CFIF>
		
	<cfset regMsg = "">
		  
	<cfreturn regMsg>
</cffunction>



<!--- =============================================================================== --->	


<!--- =================================================================== --->
<cffunction name="insertNewClubRequest" access="remote" returntype="numeric">
	<!--- --------
		09/03/08 - AArnone - New function: Inserts a new club request
	----- --->
	<cfargument name="stNewClubInfo" type="struct" required="Yes" >

	<CFSET clubReqID = 0>

	<CFIF isDefined("ARGUMENTS.stNewClubInfo") AND structCount(stNewClubInfo)>
		<CFSET ClubName 	 = ARGUMENTS.stNewClubInfo.ClubName>
		<CFSET ClubAddress 	 = ARGUMENTS.stNewClubInfo.ClubAddress>
		<CFSET clubTown 	 = ARGUMENTS.stNewClubInfo.clubTown>
		<CFSET clubState 	 = ARGUMENTS.stNewClubInfo.clubState>
		<CFSET clubZip 		 = ARGUMENTS.stNewClubInfo.clubZip>
		<CFSET USSFCertReferees = ARGUMENTS.stNewClubInfo.USSFCertReferees>
		<CFSET HomeFieldFull    = ARGUMENTS.stNewClubInfo.HomeFieldFull>
		<CFSET HomeFieldSmall   = ARGUMENTS.stNewClubInfo.HomeFieldSmall>
		<CFSET comments 	 = ARGUMENTS.stNewClubInfo.comments>
		<CFSET PresFname 	 = ARGUMENTS.stNewClubInfo.PresFname>
		<CFSET PresLname 	 = ARGUMENTS.stNewClubInfo.PresLname>
		<CFSET PresAddress   = ARGUMENTS.stNewClubInfo.PresAddress>
		<CFSET PresTown 	 = ARGUMENTS.stNewClubInfo.PresTown>
		<CFSET PresState 	 = ARGUMENTS.stNewClubInfo.PresState>
		<CFSET PresZip 		 = ARGUMENTS.stNewClubInfo.PresZip>
		<CFSET PresHomePhone = ARGUMENTS.stNewClubInfo.PresHomePhone>
		<CFSET PresFax 		 = ARGUMENTS.stNewClubInfo.PresFax>
		<CFSET PresWorkPhone = ARGUMENTS.stNewClubInfo.PresWorkPhone>
		<CFSET PresCellPhone = ARGUMENTS.stNewClubInfo.PresCellPhone>
		<CFSET PresEmail 	 = ARGUMENTS.stNewClubInfo.PresEmail>
		<CFSET seasonID		 = ARGUMENTS.stNewClubInfo.seasonID>
		<CFSET stTeams 		 = ARGUMENTS.stNewClubInfo.stTeams>

		<cfstoredproc procedure="p_insert_club_regRequest" datasource="#VARIABLES.DSN#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_NUMERIC" dbvarname="@Season_ID" 	value="#VARIABLES.seasonID#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@Club_name" 	value="#VARIABLES.ClubName#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@Address" 	value="#VARIABLES.ClubAddress#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@City" 		value="#VARIABLES.clubTown#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@State" 		value="#VARIABLES.clubState#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@Zip" 		value="#VARIABLES.clubZip#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@PresFname" 	value="#VARIABLES.PresFname#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@PresLname" 	value="#VARIABLES.PresLname#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@PresAddress" value="#VARIABLES.PresAddress#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@PresTown" 	value="#VARIABLES.PresTown#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@PresState" 	value="#VARIABLES.PresState#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@PresZip" 	value="#VARIABLES.PresZip#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@PresWorkPhone" 	value="#VARIABLES.PresWorkPhone#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@PresFax" 		value="#VARIABLES.PresFax#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@PresHomePhone" 	value="#VARIABLES.PresHomePhone#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@PresCellPhone" 	value="#VARIABLES.PresCellPhone#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@PresEmail" 		value="#VARIABLES.PresEmail#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_NUMERIC" dbvarname="@homeFieldFull" 	value="#VARIABLES.HomeFieldFull#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_NUMERIC" dbvarname="@homeFieldSmall" 	value="#VARIABLES.HomeFieldSmall#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_NUMERIC" dbvarname="@USSFCertReferees" value="#VARIABLES.USSFCertReferees#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@comments" 		value="#VARIABLES.comments#"> 
			<cfprocparam type="Out" cfsqltype="CF_SQL_NUMERIC" dbvarname="@clubReqID" variable="NewClubReqID"> 
		</cfstoredproc>

		<!--- insert the requested team info --->
		<CFLOOP collection="#stTeams#" item="iBG"><!--- B/G --->
			<CFLOOP collection="#stTeams[iBG]#" item="iAge"> <!--- 07-18 --->
				<CFIF NOT structIsEmpty(stTeams[iBG][iAge])> 
					<!--- <br> [#iBG#] [#iAge#] [#stTeams[iBG][iAge].LEVEL#] [#stTeams[iBG][iAge].COUNT#] --->
					<cfif len(trim(iAge))>
						<CFSET AgeGroup	= "U" & ucase(iAge)>
					<cfelse>
						<cfset AgeGroup = "">
					</cfif>
					
					<cfif structKeyExists(stTeams[iBG][iAge],"LEVEL") and len(trim(stTeams[iBG][iAge].LEVEL))>
						<cfset level = stTeams[iBG][iAge].LEVEL>
					<cfelse>
						<cfset level = "">
					</cfif>
					
					<cfif structKeyExists(stTeams[iBG][iAge],"COUNT") and len(trim(stTeams[iBG][iAge].COUNT))>
						<cfset COUNT = stTeams[iBG][iAge].COUNT>
					<cfelse>
						<cfset COUNT = 0>
					</cfif>
					
					<CFQUERY name="qInsertTeamReq" datasource="#VARIABLES.DSN#">
						INSERT INTO TBL_CoachesRegRequest
							(ClubID, TeamAge, PlayLevel, Gender, TeamsCount )
						VALUES
							(#NewClubReqID#
							,'#AgeGroup#'
							,'#level#'
							,'#ucase(iBG)#'
							,#COUNT#
							)
					</CFQUERY>	 
				</CFIF>
			</CFLOOP>
		</CFLOOP>
	</CFIF>
	
	<cfreturn NewClubReqID>
</cffunction>


<!--- =================================================================== --->
<cffunction name="updateClubComments" access="remote" returntype="string">
	<!--- --------
		08/18/2014 - J. Danz - updates comments given club id and new comment.
	----- --->
	<cfargument name="ClubID" type="numeric" required="Yes" >
	<cfargument name="Comment" type="string" required="Yes" >

	<cfstoredproc procedure="p_update_club_comment" datasource="#VARIABLES.DSN#">
		<cfprocparam type="In"  cfsqltype="CF_SQL_NUMERIC" dbvarname="@clubID" 	value="#ARGUMENTS.ClubID#"> 
		<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@comments" 	value="#ARGUMENTS.Comment#"> 
	</cfstoredproc>

	<cfset msg = "Updated Comment: " & #ARGUMENTS.Comment# & #Arguments.ClubID#>
	<cfreturn msg>
</cffunction>


<!--- =================================================================== --->
<cffunction name="getNewClubRequests" access="remote" returntype="query">
	<!--- --------
		09/05/08 - AArnone - get all the new clubs
	----- --->
	<CFQUERY name="qGetClubRequests" datasource="#VARIABLES.DSN#">
		Select ID, Club, RequestDate, Address, Town, State, ZIP
		  from TBL_ClubRegRequest
		 where Status is Null or Status = ' '
		 ORDER BY RequestDate
	</CFQUERY>
	
	<cfreturn qGetClubRequests>
</cffunction>

<!--- =================================================================== --->
<cffunction name="getNewClubReqHistory" access="remote" returntype="query">
	<!--- --------
		01/14/09 - AArnone - get all the new club request history 
	----- --->
	<CFQUERY name="qGetClubReqHist" datasource="#VARIABLES.DSN#">
		Select ID, Club, RequestDate, Address, Town, State, ZIP, Status, updateDate, updatedBy
		  from TBL_ClubRegRequest
		  where Status is NOT Null 
		  	AND Status <> ' '
		 ORDER BY RequestDate
	</CFQUERY>
	
	<cfreturn qGetClubReqHist>
</cffunction>


<!--- =================================================================== --->
<cffunction name="ClubRequestDetails" access="remote" returntype="struct">
	<!--- --------
		09/05/08 - AArnone - get details for a club request
	----- --->
	<cfargument name="newClubID" type="numeric" required="Yes" >

	<CFQUERY name="qGetClubDetails" datasource="#VARIABLES.DSN#">
		Select club, Address, Town, State, Zip,
			   PresidentName, PresidentLastname,
			   PAddress, PTown, Pstate, PZip,
			   PHomePhone, PCellPhone, PFax, PPhone, PEmail,
			   USSFCertReferees, HomeFieldFull, HomeFieldSmall, 
			   comments,
			   RequestDate, RequestTime		
		  from TBL_ClubRegRequest
		 Where ID = #ARGUMENTS.newClubID#
	</CFQUERY>

	<CFQUERY name="qGetTeamDetails" datasource="#VARIABLES.DSN#">
		Select clubID, TeamAge, PLayLevel, Gender, teamsCount
		  from TBL_CoachesRegRequest
		 Where clubID = #ARGUMENTS.newClubID#
	</CFQUERY>

	
	<CFSET stDetails = structNew()>
	<CFSET stDetails.club = qGetClubDetails>
	<CFSET stDetails.team = qGetTeamDetails>
	
	<cfreturn stDetails >
</cffunction>


<!--- =================================================================== --->
<cffunction name="getRegisteredClubs" access="remote" returntype="query">
	<!--- --------
		09/09/08 - AArnone - returns all the clubs that have registered
		01/20/09 - AArnone - Added Club address, city, state, zip
	----- --->
	<cfargument name="clubID" type="numeric" required="No">
	
	<CFIF isDefined("ARGUMENTS.clubID")>
		<CFSET whereClub = " AND cl.CLUB_ID = " & ARGUMENTS.clubID & " ">
	<CFELSE>	
		<CFSET whereClub = "">
	</CFIF>
	
	<CFQUERY name="registeredClubs" datasource="#VARIABLES.DSN#">
	SELECT cl.club_id, cl.Club_name, cl.ClubAbbr, cl.clubEmail, cl.ClubHomePage, 
		   cl.Address, cl.city, cl.state, cl.zip, 
    	   cl.HomeShirtColor, cl.HomeShortColor, cl.AwayShirtColor, cl.AwayShortColor, 
		   cl.infoDate, cl.infoUpdate, cl.MemberNCSA, cl.CLUB_STATE,
		   cl.homeFieldFull, cl.homeFieldSmall, cl.USSFCertReferees,
		   XCS.Season_id, XCS.paymentDate, XCS.Bond_YN,
		   XCS.TotalU11OlderTeams, XCS.TotalU10YoungerTeams, XCS.Total11Thru14Teams, XCS.Total15thru19Teams,
		   XCS.Approved_YN, XCS.Active_YN, XCS.termsAccepted_YN, XCS.RegSubmit,
		   XCS.ClubInfoUpd_YN, XCS.BondInfoUpd_YN, XCS.CREATEDATE
     FROM  tbl_club cl INNER JOIN xref_club_season XCS   ON XCS.club_id = cl.club_id
	WHERE  xcs.season_id =  (SELECT season_id
                               FROM tbl_season
                              WHERE RegistrationOpen_YN = 'Y')
		#VARIABLES.whereClub#
	ORDER BY CLUB_NAME
	</CFQUERY>
	<cfreturn registeredClubs >
</cffunction>



<!--- =================================================================== --->
<cffunction name="getRegisteredTeams" access="remote" returntype="query">
	<!--- --------
		09/09/08 - AArnone - returns all the teams for a club that have registered
	----- --->
	<cfargument name="clubID" type="numeric" required="NO">
	<cfargument name="TeamID" type="numeric" required="No">		<!--- OPTIONAL --->
	<cfargument name="TeamAGE" type="string" required="No">		<!--- OPTIONAL --->
	<cfargument name="approvedYN" type="string" required="No">	<!--- OPTIONAL --->

	<CFIF isDefined("ARGUMENTS.sortOrder")>
		<CFSET sortorder = ARGUMENTS.sortOrder>
	<CFELSE>
		<CFSET sortorder = "">
	</CFIF>
	<CFSWITCH expression="#VARIABLES.SortOrder#">
		<cfcase value="COACH">	<CFSET OrderBy = " Order by AC.LastName"> 	</cfcase>
		<cfdefaultcase>			<CFSET OrderBy = " Order by T.Gender, T.TeamAge, T.PlayLevel, T.PlayGroup"> </cfdefaultcase>
	</CFSWITCH>

	<CFIF isDefined("ARGUMENTS.clubID") and ARGUMENTS.clubID GT 0>
		<CFSET whereClubID = " AND CL.club_id = " & ARGUMENTS.clubID & " ">
	<CFELSE>
		<CFSET whereClubID = "">
	</CFIF>

	<CFIF isDefined("ARGUMENTS.TeamID") and ARGUMENTS.TeamID GT 0>
		<CFSET whereTeamID = " AND T.team_id = " & ARGUMENTS.TeamID & " ">
	<CFELSE>
		<CFSET whereTeamID = "">
	</CFIF>
	
	<CFIF isDefined("ARGUMENTS.TeamAGE") and len(trim(ARGUMENTS.TeamAGE))>
		<CFSET whereTeamAGE = " AND T.teamAge = '" & ARGUMENTS.TeamAGE & "' ">
	<CFELSE>
		<CFSET whereTeamAGE = "">
	</CFIF>
	
	<CFIF isDefined("ARGUMENTS.approvedYN") and len(trim(ARGUMENTS.approvedYN))>
		<CFSET whereApproveYN = " AND T.approved_yn = '" & ucase(ARGUMENTS.approvedYN) & "' ">
	<CFELSE>
		<CFSET whereApproveYN = "">
	</CFIF>
	
	
	<CFQUERY name="registeredTeams" datasource="#VARIABLES.DSN#">
		SELECT  CL.ClubAbbr, CL.club_id, CL.Club_name,
			   IsNull(T.Gender,'') + right(T.TeamAge,2) + IsNull(T.PlayLevel,'') + IsNull(T.PlayGroup,'') AS DIVISION, 
			   T.team_id, T.ContactIDHead, T.ContactIDAsst,T.ContactIDAsst2,T.ContactIDAsst3, 
			   T.club_id, T.teamName, 
		       --CL.ClubAbbr + '-' + HC.LastName + '-' + T.division AS TEAMNAMEderived,
			   CL.ClubAbbr + '-' + IsNull(T.Gender,'') + right(T.TeamAge,2) + IsNull(T.PlayLevel,'') + IsNull(T.PlayGroup,'')+ '-' + HC.LastName AS TEAMNAMEderived, 
			   T.teamAge, T.playLevel, T.gender, T.requestDiv, T.comments, T.USSFDiv, T.season_id, T.suffix, 
			   T.teamstatus, T.nonSundayplay, T.playgroup, T.appeals, T.appealsStatus, T.standingFactor, 
			   T.approved_yn, T.registered_YN,
			   HC.FirstName AS coachFirstName,  HC.LastName AS coachLastName, 
			   HC.address   AS coachAddress,    HC.city AS coachTown,  HC.state AS coachState, HC.zipcode AS coachZip, 
			   HC.phoneWork AS coachWorkPhone, 	HC.phoneHome AS coachHomePhone, 
			   HC.phoneCell AS coachCellPhone,  HC.phoneFax AS coachFax, HC.email AS coachEmail,
		      (SELECT top 1 ci.secondTeam_id
				   FROM TBL_COACH_INFO ci 
						INNER JOIN XREF_CONTACT_ROLE xcr ON xcr.xref_contact_role_id = ci.xref_contact_role_id 
				  WHERE xcr.CONTACT_ID = T.contactIDHead
				      AND xcr.role_id = 29)  as secondTeam ,
			  (SELECT top 1 ci.coaching_program
				   FROM TBL_COACH_INFO ci 
						INNER JOIN XREF_CONTACT_ROLE xcr ON xcr.xref_contact_role_id = ci.xref_contact_role_id 
				  WHERE xcr.CONTACT_ID = T.contactIDHead
				      AND xcr.role_id = 29)  as coachingPgm ,
		
			   AC.FirstName AS asstCoachFirstName,  AC.LastName AS asstCoachLastName, 
			   AC.address 	AS asstAddress,   	    AC.city AS asstTown, AC.state AS asstState, AC.zipcode AS asstZip, 
			   AC.phoneWork	AS asstWorkPhone,		AC.phoneHome AS asstHomePhone, 
			   AC.phoneCell AS asstCellPhone,		AC.phoneFax AS asstFax, AC.email AS asstEmail ,
		
			   AC2.FirstName AS asst2CoachFirstName,  AC2.LastName AS asst2CoachLastName, 
			   AC2.address 	AS asst2Address,   	    AC2.city AS asst2Town, AC2.state AS asst2State, AC2.zipcode AS asst2Zip, 
			   AC2.phoneWork	AS asst2WorkPhone,		AC2.phoneHome AS asst2HomePhone, 
			   AC2.phoneCell AS asst2CellPhone,		AC2.phoneFax AS asst2Fax, AC2.email AS asst2Email ,
		
			   AC3.FirstName AS asst3CoachFirstName,  AC3.LastName AS asst3CoachLastName, 
			   AC3.address 	AS asst3Address,   	    AC3.city AS asst3Town, AC.state AS asst3State, AC3.zipcode AS asst3Zip, 
			   AC3.phoneWork	AS asst3WorkPhone,		AC3.phoneHome AS asst3HomePhone, 
			   AC3.phoneCell AS asst3CellPhone,		AC3.phoneFax AS asst3Fax, AC3.email AS asst3Email 
			
		FROM    tbl_team T INNER JOIN tbl_club    CL ON CL.club_id    = T.club_id 
				LEFT JOIN tbl_contact HC ON HC.contact_id = T.ContactIDHead 
				LEFT JOIN tbl_contact AC ON AC.contact_id = T.ContactIDAsst 
				LEFT JOIN tbl_contact AC2 ON AC2.contact_id = T.ContactIDAsst2
				LEFT JOIN tbl_contact AC3 ON AC3.contact_id = T.ContactIDAsst3	   
		WHERE T.season_id = (select season_id from tbl_season where RegistrationOpen_YN = 'Y')
		  #whereClubID#
		  #whereTeamID#
		  #PreserveSingleQuotes(whereTeamAGE)#
		  #PreserveSingleQuotes(whereApproveYN)#
		#OrderBy#
	</CFQUERY>
	<cfreturn registeredTeams >

</cffunction>





<!--- =================================================================== --->
<cffunction name="getRegTeamCount" access="remote" returntype="struct">
	<!--- --------
		09/17/08 - AArnone - returns counts of teams that are registered vs not registered
	----- --->
	<cfargument name="clubID" type="numeric" required="Yes">

	<CFSET stRegTeamCounts = structNew()>
	<CFSET stRegTeamCounts.total = 0 >
	<CFSET stRegTeamCounts.approved = 0>
	
	<CFQUERY name="regTeamCount" datasource="#VARIABLES.DSN#">
		SELECT T.team_id, T.approved_yn, T.registered_YN
		  FROM tbl_team T  INNER JOIN tbl_club CL  ON CL.club_id = T.club_id
		WHERE T.season_id = (select season_id from tbl_season where RegistrationOpen_YN = 'Y')
		  AND CL.club_id  = #ARGUMENTS.clubID#
	</CFQUERY>
	<CFSET stRegTeamCounts.total = regTeamCount.RECORDCOUNT >

	<CFIF regTeamCount.RECORDCOUNT>
		<CFQUERY name="qApproved" dbtype="query">
			SELECT team_id
			  FROM regTeamCount
			 WHERE approved_yn = 'Y'
		</CFQUERY>
		<CFSET stRegTeamCounts.approved = qApproved.RECORDCOUNT >
	</CFIF>

	<cfreturn stRegTeamCounts >

</cffunction>




<!--- =================================================================== --->
<cffunction name="registerNewTeam" access="remote" returntype="struct">
	<!--- --------
		09/18/08 - AArnone - creates a team
		12/10/08 - AA - added prior team id as optinal argument
		06/24/16 - R.Gonzalez - added support for AsstCoachID2,AsstCoachID3,Roster,PrevPlayLevel,ReasonForPlayLevel,
	TeamFormed,TeamAvailability,SoccerID arguments
	----- --->
	<cfargument name="clubID" 	   type="numeric" required="Yes">
	<cfargument name="HeadCoachID" type="numeric" required="Yes">
	<cfargument name="AsstCoachID" type="numeric" required="Yes">
	<cfargument name="AsstCoachID2" type="numeric" required="no">
	<cfargument name="AsstCoachID3" type="numeric" required="no">
	<cfargument name="TeamAge" 	   type="string" required="Yes">
	<cfargument name="PlayLevel"   type="string" required="Yes">
	<cfargument name="Gender" 	   type="string" required="Yes">
	<cfargument name="USSFDiv" 	   type="string" required="Yes">
	<cfargument name="SecondTeam"  type="string" required="Yes">
	<cfargument name="NonSundayPlay" type="string" required="Yes">
	<cfargument	name="seasonID"    type="numeric"  required="Yes">
	<cfargument	name="contactID"   type="numeric"  required="Yes">
	<cfargument	name="PriorTeamID" type="numeric"  required="No">

	<cfargument name="Roster" 	   type="string" required="Yes">
	<cfargument name="PrevPlayLevel"   type="string" required="Yes">
	<cfargument name="ReasonForPlayLevel"  type="string" required="Yes">
	<cfargument name="TeamFormed" type="string" required="Yes">
	<cfargument	name="TeamAvailability"   type="string"  required="Yes">
	<cfargument	name="SoccerID"   type="string"  required="no">

	<cfargument name="Approved"		type="string" required="No" default="N">

	<cfset stReturnTeam = structNew()>
	<cfset stReturnTeam.TEAMID = 0>
	<cfset stReturnTeam.MSG = "">
	<cfset stReturnTeam.swErr = 0>
	
	<CFQUERY name="checkTeam" datasource="#VARIABLES.DSN#">
		SELECT TEAM_ID
		  FROM TBL_TEAM
		  WHERE club_id	   = #ARGUMENTS.clubID#
		    AND season_id  = #ARGUMENTS.seasonID#
		    AND teamAge    = '#ARGUMENTS.TeamAge#'
		    AND playLevel  = '#ARGUMENTS.PlayLevel#'
		    AND gender     = '#ARGUMENTS.Gender#'
		    AND USSFDiv    = '#ARGUMENTS.USSFDiv#'
		    AND ContactIDHead = #ARGUMENTS.HeadCoachID#
		    AND ContactIDAsst = #ARGUMENTS.AsstCoachID#
	</CFQUERY> <!--- from V_CoachesInfo --->

	<CFIF checkTeam.RECORDCOUNT>
		<!--- team already exists --->
		<cfset stReturnTeam.TEAMID = checkTeam.TEAM_ID>
		<cfset stReturnTeam.MSG = "This team being registered, <B>" & ARGUMENTS.Gender & "-" & ARGUMENTS.TeamAge & "-" & ARGUMENTS.PlayLevel & "</B> already exists.">
		<cfset stReturnTeam.swErr = 1>
	<CFELSE>
		<!--- NEW TEAM !!! --->
		<!--- Does the coach exist for this season???? --->
		<CFQUERY name="getHeadXCRID" datasource="#VARIABLES.DSN#">
			SELECT xref_contact_role_id
			  FROM xref_contact_role
			 WHERE CONTACT_ID = #ARGUMENTS.HeadCoachID#
			   AND ROLE_ID    = 29
			   AND CLUB_ID	  = #ARGUMENTS.clubID#
			   AND SEASON_ID  = #ARGUMENTS.seasonID#
		</CFQUERY> 
		<CFIF getHeadXCRID.RECORDCOUNT EQ 0>
			<!--- no match, so create role for headcoach for this season... --->
			<cfinvoke component="contact" method="insertContactRole" >
				<cfinvokeargument name="contactID"   value="#ARGUMENTS.HeadCoachID#">
				<cfinvokeargument name="roleID" 	 value="29">
				<cfinvokeargument name="ClubId" 	 value="#ARGUMENTS.ClubId#">
				<cfinvokeargument name="seasonID"    value="#ARGUMENTS.seasonID#">
				<cfinvokeargument name="activeYN"	 value="Y">
				<cfinvokeargument name="allowGameEdit" value="0">
			</cfinvoke>
		</CFIF> 
		<!--- IF selected, does the ASST coach exist for this season???? --->
		<CFIF isDefined("ARGUMENTS.AsstCoachID") AND ARGUMENTS.AsstCoachID GT 0>
			<CFQUERY name="getAsstXCRID" datasource="#VARIABLES.DSN#">
				SELECT xref_contact_role_id
				  FROM xref_contact_role
				 WHERE CONTACT_ID = #ARGUMENTS.AsstCoachID#
				   AND ROLE_ID    = 29
				   AND CLUB_ID	  = #ARGUMENTS.clubID#
				   AND SEASON_ID  = #ARGUMENTS.seasonID#
			</CFQUERY> 
			<CFIF getAsstXCRID.RECORDCOUNT EQ 0>
				<!--- no match, so create role for asstcoach for this season... --->
				<cfinvoke component="contact" method="insertContactRole" >
					<cfinvokeargument name="contactID"   value="#ARGUMENTS.AsstCoachID#">
					<cfinvokeargument name="roleID" 	 value="29">
					<cfinvokeargument name="ClubId" 	 value="#ARGUMENTS.ClubId#">
					<cfinvokeargument name="seasonID"    value="#ARGUMENTS.seasonID#">
					<cfinvokeargument name="activeYN"	 value="Y">
					<cfinvokeargument name="allowGameEdit" value="0">
				</cfinvoke>
			</CFIF> 	
		</CFIF>

		<!--- IF selected, does the ASST coach 2 exist for this season???? --->
		<CFIF isDefined("ARGUMENTS.AsstCoachID2") AND ARGUMENTS.AsstCoachID2 GT 0>
			<CFQUERY name="getAsstXCRID" datasource="#VARIABLES.DSN#">
				SELECT xref_contact_role_id
				  FROM xref_contact_role
				 WHERE CONTACT_ID = #ARGUMENTS.AsstCoachID2#
				   AND ROLE_ID    = 29
				   AND CLUB_ID	  = #ARGUMENTS.clubID#
				   AND SEASON_ID  = #ARGUMENTS.seasonID#
			</CFQUERY> 
			<CFIF getAsstXCRID.RECORDCOUNT EQ 0>
				<!--- no match, so create role for asstcoach for this season... --->
				<cfinvoke component="contact" method="insertContactRole" >
					<cfinvokeargument name="contactID"   value="#ARGUMENTS.AsstCoachID2#">
					<cfinvokeargument name="roleID" 	 value="29">
					<cfinvokeargument name="ClubId" 	 value="#ARGUMENTS.ClubId#">
					<cfinvokeargument name="seasonID"    value="#ARGUMENTS.seasonID#">
					<cfinvokeargument name="activeYN"	 value="Y">
					<cfinvokeargument name="allowGameEdit" value="0">
				</cfinvoke>
			</CFIF> 	
		</CFIF>

		<!--- IF selected, does the ASST coach 3 exist for this season???? --->
		<CFIF isDefined("ARGUMENTS.AsstCoachID3") AND ARGUMENTS.AsstCoachID3 GT 0>
			<CFQUERY name="getAsstXCRID" datasource="#VARIABLES.DSN#">
				SELECT xref_contact_role_id
				  FROM xref_contact_role
				 WHERE CONTACT_ID = #ARGUMENTS.AsstCoachID3#
				   AND ROLE_ID    = 29
				   AND CLUB_ID	  = #ARGUMENTS.clubID#
				   AND SEASON_ID  = #ARGUMENTS.seasonID#
			</CFQUERY> 
			<CFIF getAsstXCRID.RECORDCOUNT EQ 0>
				<!--- no match, so create role for asstcoach for this season... --->
				<cfinvoke component="contact" method="insertContactRole" >
					<cfinvokeargument name="contactID"   value="#ARGUMENTS.AsstCoachID3#">
					<cfinvokeargument name="roleID" 	 value="29">
					<cfinvokeargument name="ClubId" 	 value="#ARGUMENTS.ClubId#">
					<cfinvokeargument name="seasonID"    value="#ARGUMENTS.seasonID#">
					<cfinvokeargument name="activeYN"	 value="Y">
					<cfinvokeargument name="allowGameEdit" value="0">
				</cfinvoke>
			</CFIF> 	
		</CFIF>
		
		<!--- lets insert the team --->
		<cfstoredproc procedure="p_create_new_team_season_insert" datasource="#VARIABLES.DSN#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_NUMERIC" dbvarname="@club_id"			value="#ARGUMENTS.clubID#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_NUMERIC" dbvarname="@season_id"		value="#ARGUMENTS.seasonID#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@TeamAge"			value="#ARGUMENTS.TeamAge#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@PlayLevel"		value="#ARGUMENTS.PlayLevel#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@Gender"			value="#ARGUMENTS.Gender#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@USSFDiv"			value="#ARGUMENTS.USSFDiv#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_NUMERIC" dbvarname="@Head_Coach_id"	value="#ARGUMENTS.HeadCoachID#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_NUMERIC" dbvarname="@Asst_Coach_id"	value="#ARGUMENTS.AsstCoachID#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_NUMERIC" dbvarname="@Asst_Coach_id2"	value="#ARGUMENTS.AsstCoachID2#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_NUMERIC" dbvarname="@Asst_Coach_id3"	value="#ARGUMENTS.AsstCoachID3#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@NonSundayPlay"	value="#ARGUMENTS.NonSundayPlay#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@CreatedBy"		value="#ARGUMENTS.contactID#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@roster"		value="#ARGUMENTS.Roster#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@prevPlayLevel"		value="#ARGUMENTS.PrevPlayLevel#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@reasonForPlayLevel"		value="#ARGUMENTS.ReasonForPlayLevel#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@teamFormed"		value="#ARGUMENTS.TeamFormed#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@teamAvailability"		value="#ARGUMENTS.TeamAvailability#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@soccerID"		value="#ARGUMENTS.SoccerID#">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@approved_yn" value="#arguments.approved#">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@second_team_id" value="#arguments.secondTeam#" null="#YesNoFormat(arguments.secondTeam eq '')#">
			<cfprocparam type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@prior_team_id" value="#ARGUMENTS.PriorTeamID#">
			<cfprocparam type="Out" cfsqltype="CF_SQL_NUMERIC" dbvarname="@new_team_id" variable="newTeamID">
		</cfstoredproc> 

		
		<CFQUERY name="updateDiv" datasource="#VARIABLES.DSN#">
			UPDATE TBL_TEAM
			   SET RequestDiv = Gender + substring(teamage, 2, 2) + Playlevel
					<CFIF isDefined("ARGUMENTS.PriorTeamID") AND ARGUMENTS.PriorTeamID GT 0>
						, prior_team_id = #ARGUMENTS.PriorTeamID#
					</CFIF>
			 Where TEAM_ID = #VARIABLES.newTeamID#
		</CFQUERY> 

		<!--- make into CFC --->
		<cfset TotalU10YoungerTeams = 0 >
		<cfset Total11Thru14Teams = 0 >
		<cfset Total15thru19Teams = 0 >
		<CFQUERY name="qTeamAge" datasource="#VARIABLES.DSN#">
			Select TeamAge from TBL_TEAM
			 Where Club_ID = #ARGUMENTS.clubID#
			   and Registered_YN = 'Y'
			   and Season_ID  = #ARGUMENTS.seasonID#
		</CFQUERY> 
		<CFLOOP query="qTeamAge">
			<cfset Age = Trim(Right(TeamAge, 2))>
			<CFIF Age LE 10>
				<CFSET TotalU10YoungerTeams = TotalU10YoungerTeams + 1	>
			<CFELSE>
				<CFIF Age LE 14>
					<CFSET Total11Thru14Teams = Total11Thru14Teams + 1	>
				<CFELSE>
					<CFSET Total15thru19Teams = Total15thru19Teams + 1	>
				</CFIF>
			</CFIF>
		</CFLOOP>

		<CFQUERY name="updateXCScounts" datasource="#VARIABLES.DSN#">
			Update XREF_CLUB_SEASON
			   SET TotalU10YoungerTeams = #TotalU10YoungerTeams#
				 , Total11Thru14Teams  = #Total11Thru14Teams#
				 , Total15thru19Teams  = #Total15thru19Teams#
				 , UpdateDate		   = getDate()
				 , UpdatedBy		   = #ARGUMENTS.contactID#
			 Where SEASON_ID		   = #ARGUMENTS.seasonID#
			   AND CLUB_ID			   = #ARGUMENTS.clubID#
		</CFQUERY> 
		<!--- end of a cfc? --->

		<cfset stReturnTeam.TEAMID = VARIABLES.newTeamID>
		<cfset stReturnTeam.MSG = "The team was created">
		<cfset stReturnTeam.swErr = 0>
	</CFIF>

	<cfreturn stReturnTeam >

</cffunction>




<!--- -----------------------------------
	  end component registration.cfc
------------------------------------ --->

</cfcomponent>