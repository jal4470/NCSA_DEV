<!---
	FileName:	teamCreate.cfm
	Created on: 09/18/2008
	Created by: aarnone@capturepoint.com

	Purpose: [purpose of the file]

MODS: mm/dd/yyyy - filastname - comments
02/04/09 
	- aa - #7168 fixed issue with field's defaulted values. If user submitted w/o changing values then all teams will
				show up on flighting page having u07 as the ussfdiv. Changed to default to "Select" on startup.
02/05/09 
	- aa - #7168 changed the Gender radio buttons to a dropdown list.
7/14/2010 B. Cooper
	- 7405 - added auto-approve flag
7/8/2011, J. Oriente
	- commented "<cfif swDisable>disabled</cfif>" from Coach and Asst. Coach form fields
	- replaced qOtherContacts query with new version to align options with "edit teams" form
6/28/2013, J. Rab
	- Added fix for teams created before clube availablility
6/17/2016, R. Gonzalez
	- Added assistant coach 2 and 3
	- update dropdown labels to reflect the year
6/20/2016, R. Gonzalez TICKET NCSA22671 
	- Added 1st question to list of form items
6/24/2016, R. Gonzalez TICKET NCSA22671
	- Added remaining questions to list of form items
	- Added error handling on new form items
	- Added division collection process
	- Added support for AsstCoachID2,AsstCoachID3,Roster,PrevPlayLevel,ReasonForPlayLevel,
	TeamFormed,TeamAvailability,SoccerID to creation process
6/30/2016, R. Gonzalez TICKET NCSA22671
	- Applied fix around SoccerID to default to 0 if empty
8/30/2017, R. Gonzalez TICKET NCSA27026
	- Applied year calculation to be the same as the calculation in agebracket.cfm
7/27/2018, R. Gonzalez TICKET 27024
	- Removed Head Coach Second Team question
	- Added text block in place of the removed question
 --->

<cfset mid = 0> <!--- optional =menu id --->
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>
<div id="contentText">

<CFIF isDefined("URL.cid")>
	<CFSET clubID = URL.cid>
<CFELSEIF isDefined("FORM.CLUBID")>
	<CFSET clubID = FORM.CLUBID>
<CFELSEIF isDefined("SESSION.USER.CLUBID")>
	<CFSET clubID = SESSION.USER.CLUBID>
<CFELSE>
	<CFSET clubID = 0>
</CFIF>


<CFIF isDefined("SESSION.REGSEASON")>
	<CFSET displaySeason = SESSION.REGSEASON.SF & " " & SESSION.REGSEASON.YEAR>
	<CFSET SF = SESSION.REGSEASON.SF>
	<CFSET seasonID = SESSION.REGSEASON.ID>
<CFELSE>
	<CFSET displaySeason = SESSION.CURRENTSEASON.SF & " " & SESSION.CURRENTSEASON.YEAR>
	<CFSET SF = SESSION.CURRENTSEASON.SF>
	<CFSET seasonID = SESSION.CURRENTSEASON.ID>
</CFIF>

<cfset page_error = "">

<CFSET errMessage = "">
<CFSET swDisable = false>
<CFSET swDelete  = false>

<CFIF isDefined("URL.a") AND URL.A EQ "del">
	<CFSET swDisable = TRUE>
	<CFSET swDelete  = TRUE>
	<CFSET errMessage = "<b>Are you sure you want to delete this team? </b>">
</CFIF>


<CFIF isDefined("FORM.DELETE")>
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#team" method="deleteTeam">
		<cfinvokeargument name="teamID"   value="#FORM.TEAMID#">
	</cfinvoke>
	<CFLOCATION url="regTeamList.cfm">
</CFIF>

<cfif isDefined("FORM.TeamAge")>
	<cfset TeamAge = FORM.TeamAge >
<cfelse>
	<CFSET TeamAge	= "">
</cfif>
<cfif isDefined("FORM.PlayLevel")>
	<cfset PlayLevel = FORM.PlayLevel >
<cfelse>
	<CFSET PlayLevel = "">
</cfif>
<cfif isDefined("FORM.Division")>
	<cfset Division = FORM.Division >
<cfelse>
	<CFSET Division	= "">
</cfif>
<cfif isDefined("FORM.USSFDiv")>
	<cfset USSFDiv = FORM.USSFDiv >
<cfelse>
	<CFSET USSFDiv	= "">
</cfif>
<cfif isDefined("FORM.Gender")>
	<cfset Gender = FORM.Gender >
<cfelse>
	<CFSET Gender	= "">
</cfif>
<cfif isDefined("FORM.HeadCoachId")>
	<cfset  HeadCoachId= FORM.HeadCoachId >
<cfelse>
	<CFSET HeadCoachId = "">
</cfif>
<cfif isDefined("FORM.AsstCoachId")>
	<cfset AsstCoachId = FORM.AsstCoachId >
<cfelse>
	<CFSET AsstCoachId = "">
</cfif>
<cfif isDefined("FORM.AsstCoachId2")>
	<cfset AsstCoachId2 = FORM.AsstCoachId2 >
<cfelse>
	<CFSET AsstCoachId2 = "">
</cfif>
<cfif isDefined("FORM.AsstCoachId3")>
	<cfset AsstCoachId3 = FORM.AsstCoachId3 >
<cfelse>
	<CFSET AsstCoachId3 = "">
</cfif>
<cfif isDefined("FORM.SecondTeam")>
	<cfset SecondTeam = FORM.SecondTeam >
<cfelse>
	<CFSET SecondTeam  = "">
</cfif>
<cfif isDefined("FORM.NonSundayPlay")>
	<cfset NonSundayPlay = FORM.NonSundayPlay >
<cfelse>
	<CFSET NonSundayPlay	= "N">
</cfif>
<!--- <cfif isDefined("FORM.GenderBoys")>
	<cfset GenderBoys = FORM.GenderBoys >
<cfelse>
	<CFSET GenderBoys  = "checked">
</cfif>
<cfif isDefined("FORM.GenderGirls")>
	<cfset GenderGirls = FORM.GenderGirls >
<cfelse>
	<CFSET GenderGirls = "">
</cfif> --->
<cfif isDefined("FORM.Question1")>
	<cfset Q1_Roster = FORM.Question1 >
<cfelse>
	<CFSET Q1_Roster	= "">
</cfif>
<cfif isDefined("FORM.Question1aPlayLevel") AND len(trim(FORM.Question1aPlayLevel))>
	<cfset Q1a_PlayLevel = FORM.Question1aPlayLevel >
<cfelse>
	<CFSET Q1a_PlayLevel	= "na">
</cfif>
<cfif isDefined("FORM.Question2")>
	<cfset Q2_ReasonForPlayLevel = FORM.Question2 >
<cfelse>
	<CFSET Q2_ReasonForPlayLevel	= "">
</cfif>
<cfif isDefined("FORM.Question3")>
	<cfset Q3_TeamFormed = FORM.Question3 >
<cfelse>
	<CFSET Q3_TeamFormed	= "">
</cfif>
<cfif isDefined("FORM.Question4")>
	<cfset Q4_TeamAvailability = FORM.Question4 >
<cfelse>
	<CFSET Q4_TeamAvailability	= "">
</cfif>
<!--- 6/30/2016 - R. Gonzalez --->
<cfif isDefined("FORM.Question5") AND isNumeric(FORM.Question5)>
	<cfset Q5_SoccerID = FORM.Question5 >
<cfelse>
	<CFSET Q5_SoccerID	= "">
</cfif>


<CFIF isDefined("FORM.REGISTER")>
	<cfset swRegister = true>

	<cfif len(trim(FORM.Gender))>
		<cfset Gender = FORM.Gender>
	<cfelse>
		<cfset swRegister = false>
		<CFSET errMessage = errMessage & "<br> Gender is required." >
	</cfif>

	<cfif len(trim(FORM.TeamAge))>
		<cfset teamage = FORM.TeamAge>
	<cfelse>
		<cfset swRegister = false>
		<CFSET errMessage = errMessage & "<br> Team Age is required." >
	</cfif>

	<cfif len(trim(FORM.PlayLevel))>
		<cfset PlayLevel = FORM.PlayLevel>
	<cfelse>
		<cfset swRegister = false>
		<CFSET errMessage = errMessage & "<br> Play Level is required." >
	</cfif>

	<cfif len(trim(FORM.USSFDiv))>
		<cfset USSFDiv = FORM.USSFDiv>
	<cfelse>
		<cfset swRegister = false>
		<CFSET errMessage = errMessage & "<br> USSFDiv is required." >
	</cfif>
	<cfif len(trim(FORM.Question1))>
		<cfset Q1_Roster = FORM.Question1 >
	<cfelse>
		<cfset swRegister = false>
		<CFSET errMessage = errMessage & "<br> Team Roster Question is required." >
	</cfif>
	<cfif Q1a_PlayLevel eq "na" AND Q1_Roster eq "yes">
		<cfset swRegister = false>
		<CFSET errMessage = errMessage & "<br> Flight Previously Played Question is required." >
	</cfif>
	<cfif len(trim(FORM.Question2))>
		<cfset Q2_ReasonForPlayLevel = FORM.Question2 >
	<cfelse>
		<cfset swRegister = false>
		<CFSET errMessage = errMessage & "<br> Comment is required." >
	</cfif>
	<cfif len(trim(FORM.Question3))>
		<cfset Q3_TeamFormed = FORM.Question3 >
	<cfelse>
		<cfset swRegister = false>
		<CFSET errMessage = errMessage & "<br> Team Formation Question is required." >
	</cfif>
	<cfif len(trim(FORM.Question4))>
		<cfset Q4_TeamAvailability = FORM.Question4 >
	<cfelse>
		<cfset swRegister = false>
		<CFSET errMessage = errMessage & "<br> Team Availablility Question is required." >
	</cfif>
	<cfif len(trim(FORM.Question5)) AND isNumeric(FORM.Question5)>
		<cfset Q5_SoccerID = FORM.Question5 >
	<cfelse>
		<cfset swRegister = false>
		<CFSET errMessage = errMessage & "<br> SoccerID must be a numeric value." >
	</cfif>

	<cfif isdefined("form.chkApproveOverride") AND form.chkApproveOverride EQ "1">
		<cfset teamApproved="Y">
	<cfelse>
		<cfset teamApproved="N">
	</cfif>

<!--- <cfdump var=#form#><cfabort> --->


<cfif swRegister>
	<CFINVOKE component="#SESSION.SITEVARS.cfcPath#registration" method="registerNewTeam" returnvariable="stRegTeam">
		<cfinvokeArgument name="clubID" 		value="#FORM.clubID#">
		<cfinvokeArgument name="HeadCoachID" 	value="#FORM.HeadCoachID#">
		<cfinvokeArgument name="AsstCoachID" 	value="#FORM.AsstCoachID#">
		<cfinvokeArgument name="AsstCoachID2" 	value="#FORM.AsstCoachID2#">
		<cfinvokeArgument name="AsstCoachID3" 	value="#FORM.AsstCoachID3#">
		<cfinvokeArgument name="TeamAge" 		value="#FORM.TeamAge#">
		<cfinvokeArgument name="PlayLevel" 		value="#FORM.PlayLevel#">
		<cfinvokeArgument name="Gender" 		value="#FORM.Gender#">
		<cfinvokeArgument name="USSFDiv" 		value="#FORM.USSFDiv#">
		<cfinvokeArgument name="SecondTeam" 	value="#SecondTeam#">
		<cfinvokeArgument name="NonSundayPlay" 	value="#FORM.NonSundayPlay#">
		<cfinvokeArgument name="seasonID" 		value="#VARIABLES.seasonID#">
		<cfinvokeArgument name="contactID" 		value="#SESSION.USER.CONTACTID#">
		<cfinvokeArgument name="PriorTeamID" 	value="#FORM.TeamID#">

		<cfinvokeArgument name="Roster" 		value="#Q1_Roster#">
		<cfinvokeArgument name="PrevPlayLevel" 	value="#Q1a_PlayLevel#">
		<cfinvokeArgument name="ReasonForPlayLevel"	value="#Q2_ReasonForPlayLevel#">
		<cfinvokeArgument name="TeamFormed" 	value="#Q3_TeamFormed#">
		<cfinvokeArgument name="TeamAvailability" 	value="#Q4_TeamAvailability#">
		<cfinvokeArgument name="SoccerID" 	value="#Q5_SoccerID#">

		<cfinvokeargument name="approved" value="#teamApproved#">
	</CFINVOKE>
	<CFIF stRegTeam.swErr>
		<CFSET errMessage = errMessage & stRegTeam.MSG>
	<CFELSE>
		<CFLOCATION url="regTeamList.cfm?cid=#FORM.clubID#">
	</CFIF>
</cfif>

</CFIF>

<H1 class="pageheading">NCSA - Add a Team</H1>
<br>
<h2>for #displaySeason# Season </h2>

<!--- Set Starting year to drop down --->
<!--- <cfquery name="getCurrentSeason" datasource="#application.dsn#">
	Select season_year, 
	case when season_SF = 'SPRING' then season_year - 1 else season_year end as Start_Year
	from tbl_season where currentSeason_yn = 'Y'
</cfquery>  --->
<!--- <cfquery name="getCurrentSeason" datasource="#application.dsn#">
	Select season_year, 
	season_year as Start_Year
	from tbl_season where currentSeason_yn = 'Y'
</cfquery> --->
<!--- <cfif getCurrentSeason.recordcount gt 0>
	<CFSET StartYear = getCurrentSeason.Start_Year>
</cfif> --->
<!--- <cfquery name="getRegistrationSeason" datasource="#application.dsn#">
	Select season_year, 
	case when season_SF = 'SPRING' then season_year else season_year end as Start_Year,
	case when season_SF = 'FALL' then season_year + 1 else season_year end as End_Year 
	from tbl_season where registrationOpen_YN = 'Y'
</cfquery>
<cfif getRegistrationSeason.recordcount gt 0>
	<CFSET StartYear = getRegistrationSeason.Start_Year>
	<CFSET EndYear = getRegistrationSeason.End_Year>
<cfelse>
	<cfquery name="getCurrentSeason" datasource="#application.dsn#">
		Select season_year, 
		case when season_SF = 'SPRING' then season_year - 1 else season_year end as Start_Year,
		case when season_SF = 'FALL' then season_year + 1 else season_year end as End_Year 
		from tbl_season where currentSeason_yn = 'Y'
	</cfquery>

	<cfif getCurrentSeason.recordcount gt 0>
		<CFSET StartYear = getCurrentSeason.Start_Year>
		<CFSET EndYear = getCurrentSeason.End_Year>
	</cfif>
</cfif> --->

<cfquery name="getSeason" datasource="#application.dsn#">
		Select season_year, 
		case when season_SF = 'SPRING' then season_year - 1 else season_year end as Start_Year,
		case when season_SF = 'FALL' then season_year + 1 else season_year end as End_Year 
		from tbl_season where season_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#seasonId#">
	</cfquery>

	<cfif getSeason.recordcount gt 0>
		<CFSET StartYear = getSeason.Start_Year>
		<CFSET EndYear = getSeason.End_Year>
	</cfif>


<!--- Setup Period array to calculate AGE --->
<CFSET Period = ArrayNew(1)>
<CFSET Period[1] = 6 >
<CFSET Period[2] = 7 >
<CFSET Period[3] = 8 >
<CFSET Period[4] = 9 >
<CFSET Period[5] = 10 >
<CFSET Period[6] = 11 >
<CFSET Period[7] = 12 >
<CFSET Period[8] = 13 >
<CFSET Period[9] = 14 >
<CFSET Period[10] = 15 >
<CFSET Period[11] = 16 >
<CFSET Period[12] = 17 >
<CFSET Period[13] = 18 >

<CFQUERY name="getClub" datasource="#SESSION.DSN#">
	SELECT CLUB_NAME
	  from TBL_CLUB
	 Where CLUB_ID = #VARIABLES.clubID#
</CFQUERY>
<CFSET ClubName	= getClub.CLUB_NAME>

<!--- <CFSET TeamId	= "">
<CFSET TeamAge	= "">
<CFSET PlayLevel = "">
<CFSET Division	= "">
<CFSET USSFDiv	= "">
<CFSET Gender	= "">
<CFSET HeadCoachId = "">
<CFSET AsstCoachId = "">
<CFSET SecondTeam  = "">
<CFSET NonSundayPlay	= "N">
<CFSET GenderBoys  = "checked">
<CFSET GenderGirls = "">
 --->


<CFIF isDefined("URL.tid")>
	<CFSET teamID = URL.tid>
<CFELSEIF isDefined("FORM.teamID")>
	<CFSET teamID = FORM.teamID>
<CFELSE>
	<CFSET teamID = 0>
</CFIF>

<!--- <cfdump var="#FORM#"><cfdump var="#URL#">
</cfoutput>  </div>  <cfinclude template="_footer.cfm">
<CFABORT><cfoutput> --->


<CFIF teamID GT 0>
	<CFINVOKE component="#SESSION.SITEVARS.cfcPath#team" method="getTeamInfo" returnvariable="qTeamInfo">
		<cfinvokeargument name="teamID" value="#VARIABLES.TeamID#">
	</CFINVOKE> <!--- <cfdump var="#qTeamInfo#"> --->

	<CFSET ClubName		= qTeamInfo.Club_name>
	<CFSET TeamId		= qTeamInfo.team_id>
	<CFSET TeamAge		= qTeamInfo.teamAge>
	<CFSET PlayLevel 	= qTeamInfo.playLevel>
	<CFSET Division		= qTeamInfo.DIVISION>
	<CFSET USSFDiv		= qTeamInfo.USSFDiv>
	<CFSET Gender		= qTeamInfo.gender>
	<CFSET HeadCoachId 	= qTeamInfo.ContactIDHead>
	<CFSET AsstCoachId 	= qTeamInfo.ContactIDAsst>
	<CFSET AsstCoachId2 	= qTeamInfo.ContactIDAsst2>
	<CFSET AsstCoachId3 	= qTeamInfo.ContactIDAsst3>
	<CFSET ORIG_HeadCoachId	 = qTeamInfo.ContactIDHead>
	<CFSET ORIG_AsstCoachId	 = qTeamInfo.ContactIDAsst>
	<CFSET NonSundayPlay	 = qTeamInfo.NonSundayPlay>

<!--- <cfoutput>SELECT TEAM_ID
		  FROM TBL_TEAM
		  WHERE club_id	   = #VARIABLES.clubID#
		    AND season_id  = #VARIABLES.seasonID#
		    AND upper(teamAge)    = '#ucase(VARIABLES.TeamAge)#'
		    AND upper(playLevel)  = '#ucase(VARIABLES.PlayLevel)#'
		    AND upper(gender)     = '#ucase(VARIABLES.Gender)#'
		    AND upper(USSFDiv)    = '#ucase(VARIABLES.USSFDiv)#'
		    AND ContactIDHead = '#VARIABLES.HeadCoachID#'
		    <cfif len(trim(VARIABLES.AsstCoachID))>
				AND ContactIDAsst = #VARIABLES.AsstCoachID#
			<cfelse>
				AND ( ContactIDAsst IS NULL
					OR ContactIDAsst = 0
					OR ContactIDAsst = ' '
					)
			</cfif></cfoutput><cfabort> --->
	<CFQUERY name="checkTeam" datasource="#SESSION.DSN#">
		SELECT TEAM_ID
		  FROM TBL_TEAM
		  WHERE club_id	   = #VARIABLES.clubID#
		    AND season_id  = #VARIABLES.seasonID#
		    AND upper(teamAge)    = '#ucase(VARIABLES.TeamAge)#'
		    AND upper(playLevel)  = '#ucase(VARIABLES.PlayLevel)#'
		    AND upper(gender)     = '#ucase(VARIABLES.Gender)#'
		    AND upper(USSFDiv)    = '#ucase(VARIABLES.USSFDiv)#'
		    AND ContactIDHead = '#VARIABLES.HeadCoachID#'
		    <cfif len(trim(VARIABLES.AsstCoachID))>
				AND ContactIDAsst = #VARIABLES.AsstCoachID#
			<cfelse>
				AND ( ContactIDAsst IS NULL
					OR ContactIDAsst = 0
					OR ContactIDAsst = ' '
					)
			</cfif>

	</CFQUERY> <!--- 	<cfdump var="#checkTeam#"> --->

	<CFIF checkTeam.RECORDCOUNT>
		<CFSET errMessage = errMessage & "<B>This team has already been registered.</B>">
		<CFSET swDisable = true>
	</CFIF>

	<!--- <CFIF Gender EQ "B">
		<CFSET GenderBoys  = "checked">
		<CFSET GenderGirls = "">
	<CFELSEIF Gender EQ "G">
		<CFSET GenderBoys  = "">
		<CFSET GenderGirls = "checked">
	<CFELSE>
		<CFSET GenderBoys	= "">
		<CFSET GenderGirls	= "">
	</CFIF> --->

	<!--- if coach found, get secondTeam
	<CFSET SecondTeam  	= ""> --->


</CFIF>




<cfinvoke component="#SESSION.SITEVARS.cfcpath#contact" method="getClubContactRoleX" returnvariable="qCoaches">
	<cfinvokeargument name="clubID" value="#VARIABLES.clubID#">
	<cfinvokeargument name="roleID" value="#SESSION.CONSTANT.RoleIDcoach#">
</cfinvoke> <!--- rs2 --->

<cfif qCoaches.RecordCount EQ 0>
	<cfset page_error = "In order to register a team, you must have at least one contact who has the role of 'coach.'">
</cfif>

<!--- REMOVED 7/8/2011 by J. Oriente: replaced by query listed below.
<cfif qCoaches.recordCount>
	<cfset lCoachesID = valueList(qCoaches.contact_id)>
<cfelse>
	<cfset lCoachesID = 0>
</cfif>
<!--- <cfset lCoachesID = valueList(qCoaches.contact_id)> --->

<CFQUERY name="qOtherContacts" datasource="#SESSION.DSN#">
	SELECT c.contact_id, c.FirstName, c.lastName
	  FROM TBL_CONTACT c
	 WHERE c.CLUB_ID = #VARIABLES.ClubId#
	   AND c.CONTACT_ID NOT IN (#lCoachesID#)
</CFQUERY> <!--- rs3 ---> --->

<!--- ADDED 7/8/2011 by J. Oriente: replaced prior version of query listed above. --->
<CFQUERY name="qOtherContacts" datasource="#SESSION.DSN#">
	SELECT c.contact_id, c.FirstName, c.lastName
	  FROM TBL_CONTACT c INNER JOIN XREF_CONTACT_ROLE X on x.CONTACT_ID = c.CONTACT_ID
	 WHERE c.CLUB_ID = #VARIABLES.ClubId#
	 <cfif qCoaches.RecordCount NEQ 0> <!--- Prevents error from being thrown if there are no coaches --->
	   AND c.CONTACT_ID NOT IN (#valueList(qCoaches.contact_id)#)
	 </cfif>
	   and c.active_yn='Y' and c.approve_yn='Y'
</CFQUERY> 

<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="lTeamAges">
	<cfinvokeargument name="listType" value="TEAMAGES">
</cfinvoke> <!--- lTeamAges --->
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="lPlayLevel">
	<cfinvokeargument name="listType" value="PLAYLEVEL">
</cfinvoke> <!--- lPlayLevel --->

<CFINVOKE component="#SESSION.SITEVARS.cfcPath#team" method="getPreviousSeasonDivisions" returnvariable="lDivision"> <!--- Divisions --->


<!--- Append Jquery to HEAD --->
<cfhtmlhead text='<script language="JavaScript" type="text/javascript" src="assets/jquery-1.4.2.min.js"></script>'>

<cfif page_error NEQ "">
	<div class="red" style="font-size: 12px; margin-top: 10px;">#page_error#</div>

<cfelse>

<FORM name="CoachesMaintain" action="teamCreate.cfm"  method="post">
	<input type="hidden" name="ClubId"			 value="#VARIABLES.ClubId#">
	<input type="hidden" name="TeamID"		value="#TeamId#">
<!--- 	<input type="hidden" name="CurrentPage" 	 value=0>
	<input type="hidden" name="Mode"		value="<%=Mode%>">
	<input type="hidden" name="ClubID"		value="#ClubId#"> --->
<!--- 	<input type="hidden" name="ClubInfoId"	value="<%=ClubInfoId%>">
	<input type="hidden" name="RegSubmit"	value="<%=RegSubmit%>">
	<input type="hidden" name="InfoUpdated" value="<%=InfoUpdated%>">
	<input type="hidden" name="CurrentPage" value=0>
 --->
<span class="red">Fields marked with * are required</span>
<CFSET required = "<FONT color=red>*</FONT>">
<table cellspacing="0" cellpadding="5" align="left" border="0" width="90%">

	<tr class="tblHeading">
		<TD colspan="2">Team Info for #VARIABLES.clubName# <cfif teamId neq 0>- Prior Team #teamId#</cfif>:</TD>
	</tr>
		<cfif len(Trim(errMessage))>
			<TR><TD colspan="3" align="Center" class="red">
					#errMessage#
				</td>
			</TR>
		</cfif>
	<TR><TD align="right">#required# <b>Gender</b>
		</TD>
		<TD>	<!--- <b>
				<input type="Radio" maxlength="1" name="Gender" value="B" #GenderBoys#  <cfif swDisable>disabled</cfif> > Boys
				<input type="Radio" maxlength="1" name="Gender" value="G" #GenderGirls# <cfif swDisable>disabled</cfif> > Girls
				</b> --->
			<SELECT  name="Gender" <cfif swDisable>disabled</cfif> >
				<OPTION value="" > Select </OPTION>
				<OPTION value="B" <CFIF gender EQ "B">selected</CFIF> > Boys  </OPTION>
				<OPTION value="G" <CFIF gender EQ "G">selected</CFIF> > Girls </OPTION>
			</SELECT>
		</TD>

	</TR>
	<TR>
		<TD align="right"> #required# <b>Team Age Group</B></TD>
		<TD><SELECT  name="TeamAge" <cfif swDisable>disabled</cfif> >
				<OPTION value="" >Select</OPTION>

				<!--- Initialize year var --->
				<cfset Year = StartYear>
				<cfset ageIndx = 1>
				<CFLOOP list="#lTeamAges#" index="ita">
					<cfset Age = Period[ageIndx]>
			<!--- 		<cfif find("FALL", displaySeason)>  --->
						<cfset Year = (StartYear) - Age>
		<!--- 			<cfelse>
						<cfset Year = StartYear - Age>
					</cfif> --->

					<OPTION value="#ita#" <CFIF TeamAge EQ ita>selected</CFIF>  >#ita# (#Year#)</OPTION>
					<!--- Decrement by 1 year --->
					<cfset Year = Year - 1>

					<!--- Increment age index --->
					<cfset ageIndx = ageIndx + 1>
				</CFLOOP>
			</SELECT>
		</TD>
	</tr>
	<tr><TD align="right">#required# <b>Play Level</b></TD>
		<TD><SELECT  name="PlayLevel" <cfif swDisable>disabled</cfif> >
				<OPTION value="" >Select</OPTION>
				<CFLOOP list="#lPlayLevel#" index="ipl">
					<OPTION value="#ipl#" <CFIF PlayLevel EQ ipl>selected</CFIF> >#ipl#</OPTION>
				</CFLOOP>
			</SELECT>
			<span class="red"><u>(Flight 'X' is reserved for CUP divisional Play only)</u></span>
		</TD>
	</TR>
	<TR><TD align="right"><b>Division</b></TD>
		<TD>#Division#</TD>
	</TR>
	<TR><TD align="right">#required# <b>USSF Rgstd Div</b> </TD>
		<TD><SELECT  name="USSFDiv" <cfif swDisable>disabled</cfif> >
				<OPTION value="" >Select</OPTION>
				<!--- <cfset Year = StartYear> --->
				<cfset ageIndx = 1>
				<CFLOOP list="#lTeamAges#" index="ita">
					<cfset Age = Period[ageIndx]>
					<!--- <cfif find("FALL", displaySeason)>  --->
						<cfset Year = (StartYear) - Age>
					<!--- <cfelse>
						<cfset Year = StartYear - Age>
					</cfif> --->
<!--- 
					<cfset Year = StartYear - Age> --->
					<OPTION value="#ita#" <CFIF USSFDiv EQ ita>selected</CFIF>  >#ita#  (#Year#)</OPTION>
					<cfset Year = Year - 1>

					<!--- Increment age index --->
					<cfset ageIndx = ageIndx + 1>
				</CFLOOP>
			</SELECT>
		</td>
	</TR>
	<TR><TD align="right">#required# <b>Coach</b> </TD>
		<TD><SELECT name="HeadCoachID"  > <!--- <cfif swDisable>disabled</cfif> ---> 
				<CFIF qOtherContacts.RECORDCOUNT>
					<CFLOOP query="qOtherContacts">
						<OPTION value="#contact_id#" <CFIF HeadCoachID EQ contact_id> selected </CFIF> > #LastNAme#, #FirstName#</OPTION>
					</CFLOOP>
				</CFIF>
			    <!--- put in Coaches --->
				<CFIF qCoaches.RECORDCOUNT>
					<CFLOOP query="qCoaches" >
						<OPTION value="#contact_id#" <cfif HeadCoachID EQ contact_id> selected </cfif> >#LastName#, #FirstName#</OPTION>
					</CFLOOP>
				</CFIF>
			</SELECT>
		</TD>
	</TR>
	<TR><TD align="right"> <b>Asst.Coach</b> </TD>
		<TD><SELECT name="AsstCoachID"  > <!--- <cfif swDisable>disabled</cfif> --->
				<option value="0"> Select contact  </OPTION>
				<CFIF qOtherContacts.RECORDCOUNT>
					<CFLOOP query="qOtherContacts">
						<OPTION value="#contact_id#" <CFIF AsstCoachID EQ contact_id> selected </CFIF> > #LastNAme#, #FirstName#</OPTION>
					</CFLOOP>
				</CFIF>
			    <!--- put in Coaches --->
				<CFIF qCoaches.RECORDCOUNT>
					<CFLOOP query="qCoaches">
						<OPTION value="#contact_id#" <cfif AsstCoachID EQ contact_id> selected </cfif> >#LastName#, #FirstName#</OPTION>
					</CFLOOP>
				</CFIF>
			</SELECT>
		</TD>
	</TR>
	<TR><TD align="right"> <b>Asst.Coach 2</b> </TD>
		<TD><SELECT name="AsstCoachID2"  > <!--- <cfif swDisable>disabled</cfif> --->
				<option value="0"> Select contact  </OPTION>
				<CFIF qOtherContacts.RECORDCOUNT>
					<CFLOOP query="qOtherContacts">
						<OPTION value="#contact_id#" <CFIF AsstCoachID2 EQ contact_id> selected </CFIF> > #LastNAme#, #FirstName#</OPTION>
					</CFLOOP>
				</CFIF>
			    <!--- put in Coaches --->
				<CFIF qCoaches.RECORDCOUNT>
					<CFLOOP query="qCoaches">
						<OPTION value="#contact_id#" <cfif AsstCoachID2 EQ contact_id> selected </cfif> >#LastName#, #FirstName#</OPTION>
					</CFLOOP>
				</CFIF>
			</SELECT>
		</TD>
	</TR>
	<TR><TD align="right"> <b>Asst.Coach 3</b> </TD>
		<TD><SELECT name="AsstCoachID3"  > <!--- <cfif swDisable>disabled</cfif> --->
				<option value="0"> Select contact  </OPTION>
				<CFIF qOtherContacts.RECORDCOUNT>
					<CFLOOP query="qOtherContacts">
						<OPTION value="#contact_id#" <CFIF AsstCoachID3 EQ contact_id> selected </CFIF> > #LastNAme#, #FirstName#</OPTION>
					</CFLOOP>
				</CFIF>
			    <!--- put in Coaches --->
				<CFIF qCoaches.RECORDCOUNT>
					<CFLOOP query="qCoaches">
						<OPTION value="#contact_id#" <cfif AsstCoachID3 EQ contact_id> selected </cfif> >#LastName#, #FirstName#</OPTION>
					</CFLOOP>
				</CFIF>
			</SELECT>
		</TD>
	</TR>
	<!--- <tr><td align="right"> <b>Head Coach Second Team</b>	</TD>
		<TD><SELECT name="SecondTeam" <cfif swDisable>disabled</cfif> >
				<OPTION value="" selected>Select</OPTION>
				<CFLOOP list="#lTeamAges#" index="ita">
					<CFLOOP list="#lPlayLevel#" index="ipl">
						<cfif ipl neq 'X'>
						<OPTION value="B#ita##ipl#" <CFIF SecondTeam EQ 'B#ita##ipl#'>selected</CFIF>  >B#ita##ipl#</OPTION>
						<OPTION value="G#ita##ipl#" <CFIF SecondTeam EQ 'G#ita##ipl#'>selected</CFIF>  >G#ita##ipl#</OPTION>
						</cfif>
					</CFLOOP>	
				</CFLOOP>
			</SELECT>
		</TD>
	</tr> --->
	<tr>
		<TD colspan="2">
			NCSA tracks contacts who are head coaches of more than 1 team through actual listings as the head coach of more than one team. Such head coaches of more than one team who wish to coordinate 2 teams' schedules must indicate through the "Special Scheduling Request" for one team to be played early (for example, before noon) and the other to be played late (for example, after 2:00 PM).  Coordination of more than 2 teams is not feasible.  Coordination of 2 teams also depends upon home team field availability and opponents' special scheduling requests.
		</TD>
	</tr>
	<tr><td align="right" style="width: 40%;">#required# <b>Did this team with substantially the same roster play in NCSA in the season that just ended or is about to end?</b>	</TD>
		<TD><SELECT name="Question1" id="Question1" <cfif swDisable>disabled</cfif> >
				<OPTION value="">Select</OPTION>
				<OPTION value="yes" <CFIF Q1_Roster EQ "yes">selected</CFIF> >Yes</OPTION>
				<OPTION value="no" <CFIF Q1_Roster EQ "no">selected</CFIF> >No</OPTION>
			</SELECT>
		</TD>
	</tr>
	<tr id="Question1a" style="display:none;"><td align="right" style="width: 40%;">#required# <b>If "YES", which flight did the team play in?</b>	</TD>
		<TD><SELECT  name="Question1aPlayLevel" <cfif swDisable>disabled</cfif> >
				<OPTION value="" >Select</OPTION>
				<CFLOOP list="#ValueList(lDivision.division,",")#" index="div">
					<cfif FindNoCase('X', div) eq 0 AND FindNoCase('R', div) eq 0>
						<OPTION value="#div#" <CFIF Q1a_PlayLevel EQ div>selected</CFIF> >#div#</OPTION>
					</cfif>
				</CFLOOP>
			</SELECT>
		</TD>
	</tr>
	<tr><td align="right" style="width: 40%;">#required# <b>In the Comments Box below, please provide (a) concise reasons for requested play level; (b) if there has been a coaching change, name of former coach so we can connect this team to its history; (c) any other information you wish Division Commissioner to take into account in flighting this team. If you have no comments, state "none."</b>	</TD>
		<TD><textarea name="Question2" rows="5" cols="24" maxlength="500"><CFIF len(trim(Q2_ReasonForPlayLevel))>#Q2_ReasonForPlayLevel#</CFIF></textarea>
		</TD>
	</tr>
	<tr><td align="right" style="width: 40%;">#required# <b>Please let us know how this team has been formed with reference to the change in player age to "birth year".</b>	</TD>
		<TD><SELECT name="Question3" <cfif swDisable>disabled</cfif> >
				<OPTION value="" selected>Select</OPTION>
				<OPTION value="using birth year" <CFIF Q3_TeamFormed EQ "using birth year">selected</CFIF> >Using birth year only to form team</OPTION>
				<OPTION value="using old 7/31-8/1 year" <CFIF Q3_TeamFormed EQ "using old 7/31-8/1 year">selected</CFIF> >Using old 7/31-8/1 year (playing up)</OPTION>
				<OPTION value="other" <CFIF Q3_TeamFormed EQ "other">selected</CFIF> >Other-Does not fit either of above</OPTION>
			</SELECT>
		</TD>
	</tr>
	<tr><td align="right" style="width: 40%;">#required# <b>Is this team available to play scheduled games on the other weekend day than its usual scheduled day of play (in Fall, boys on Saturday and girls on Sunday; in spring, all on Sunday).</b>	</TD>
		<TD><SELECT name="Question4" <cfif swDisable>disabled</cfif> >
				<OPTION value="">Select</OPTION>
				<OPTION value="yes" <CFIF Q4_TeamAvailability EQ "yes">selected</CFIF> >Yes</OPTION>
				<OPTION value="no" <CFIF Q4_TeamAvailability EQ "no">selected</CFIF> >No</OPTION>
			</SELECT>
		</TD>
	</tr>
	<!--- <tr><td align="right" style="width: 40%;"> <b>If NCSA offers to provide information to Got Soccer about results for your flight and if you wish to have Got Soccer points awarded, you must include your Got Soccer ID number here:</b>	</TD>
		<TD><input type="text" name="Question5" maxlength="20" <CFIF len(trim(Q5_SoccerID))>value="#Q5_SoccerID#"</CFIF> >
		</TD>
	</tr> --->
	<cfif isdefined("roleid") AND roleid EQ 1>
		<tr><td align="right"> <b>Also Automatically Approve(Check if Yes)</b>	</TD>
			<TD>
				<input type="Checkbox" name="chkApproveOverride" value="1" checked="checked">
			</TD>
		</tr>
	</cfif>
	<input type="Hidden" name="Question5" value="0">
	<input type="Hidden" name="NonSundayPlay" value="">
	<!--- <CFIF SF EQ "SPRING">
		<tr><TD align="right"> Willing to play other than sunday? </TD>
			<TD><SELECT name="NonSundayPlay" <cfif swDisable>disabled</cfif> >
					<OPTION value="Y" <CFIF NonSundayPlay EQ "Y">selected</CFIF> >Yes</OPTION>
					<OPTION value="N" <CFIF NonSundayPlay EQ "N">selected</CFIF> >No </OPTION>
				</SELECT>
			</td>
		</tr>
	<CFELSE>

	</CFIF> --->

	<TR><TD colspan="2" align="center">
			<hr size="1">
			<cfif swDisable>
				&nbsp; &nbsp; &nbsp;
			<cfelse>
				&nbsp; &nbsp;
				<INPUT type="submit" name="Register" value="Register">
			</cfif>
			<CFIF swDelete>
				&nbsp; &nbsp;
				<INPUT type="submit" name="DELETE" value="Delete">
			</CFIF>
			&nbsp; &nbsp;
			<INPUT type="button" name="Back"   value="Back" onclick="history.go(-1)">
			</TD>
		</TR>
	</TABLE>
</FORM>

</cfif>

</cfoutput>
</div>

<script type="text/javascript">
	$(document).ready(function(){
		if ($('#Question1').val() == 'yes'){
			$('#Question1a').show();
		} else {
			$('#Question1a').hide();
		}
	});

	$('#Question1').change(function(){
		$question1 = $(this);

		if ($question1.val() == 'yes'){
			$('#Question1a').show();
		} else {
			$('#Question1a').hide();
		}
	});
</script>
<cfinclude template="_footer.cfm">
