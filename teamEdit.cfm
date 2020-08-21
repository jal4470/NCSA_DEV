<!--- 
	FileName:	teamEdit.cfm
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
	01/09/09 - aarnone - added current season to display
	6/24/2016, R. Gonzalez TICKET NCSA22671
	- Added remaining questions to list of form items
	- Added division collection process
	- Added AsstCoachID2,AsstCoachID3,Roster,PrevPlayLevel,ReasonForPlayLevel,
	TeamFormed,TeamAvailability,SoccerID variables to display on page
	6/30/2016, R. Gonzalez TICKET NCSA22671
	- Applied fix around SoccerID to default to 0 if empty
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">  
<cfoutput>
<div id="contentText">


<CFIF isDefined("URL.cid")>
	<CFSET clubID = URL.cid>
<CFELSEIF isDefined("FORM.ClubId")>
	<CFSET clubID = FORM.ClubId>
<CFELSEIF isDefined("SESSION.USER.CLUBID")>
	<CFSET clubID = SESSION.USER.CLUBID>
<CFELSE>
	<CFSET clubID = 0>
</CFIF>



<CFQUERY name="getClub" datasource="#SESSION.DSN#">
	SELECT CLUB_NAME 
	  from TBL_CLUB
	 Where CLUB_ID = #VARIABLES.clubID#
</CFQUERY>
<CFSET ClubName	= getClub.CLUB_NAME>


<CFIF isDefined("URL.tid")>
	<CFSET teamID = URL.tid>
<CFELSEIF isDefined("FORM.teamID")>
	<CFSET teamID = FORM.teamID>
<CFELSE>
	<CFSET teamID = 0>
</CFIF>

<CFIF isDefined("url.return_page") AND url.return_page NEQ "">
	<CFSET return_page = url.return_page>
<CFELSEIF isDefined("form.return_page") AND form.return_page NEQ "">
	<CFSET return_page = form.return_page>
<CFELSE>
	<CFSET return_page = "regTeamList.cfm">
</CFIF>


<CFIF isDefined("URL.reg")> <!--- the reg team page will pass this param so we can locate back to it after updating or going "back" --->
	<CFSET swGobackToRegPage = true>
<CFELSEIF isDefined("FORM.swGobackToRegPage")>
	<CFSET swGobackToRegPage = FORM.swGobackToRegPage>
<CFELSE>	
	<CFSET swGobackToRegPage = false>
</CFIF>

<!--- <CFSET displaySeason = SESSION.CURRENTSEASON.SF & " " & SESSION.CURRENTSEASON.YEAR>
<CFSET SF = SESSION.CURRENTSEASON.SF>
<CFSET seasonID = SESSION.CURRENTSEASON.ID> --->
<CFSET errMessage = "">


<!--- 
	check if CLUB -or- ADMIN
		if club, only change coaches
		if admin, change age,group, level, gender, coaches, etc.
	
 --->

<!--- <CFIF isDefined("FORM.DELETE")>
	<!--- delete from playweeks --->
	<CFQUERY name="deletePalyweeks" datasource="#SESSION.DSN#">
		Delete from TBL_COACH_PLAYWEEK
		 Where TEAM_ID = #FORM.TEAMID#
	</CFQUERY>
	<!--- delete from teams --->
	<CFQUERY name="deleteTeam" datasource="#SESSION.DSN#">
		Delete from TBL_TEAM
		 Where TEAM_ID = #FORM.TEAMID#
	</CFQUERY>
	<CFLOCATION url="TeamList.cfm">
</CFIF> --->
<cfif isDefined("FORM.Question1")>
	<cfset Q1_Roster = FORM.Question1 >
<cfelse>
	<CFSET Q1_Roster	= "">
</cfif>
<cfif isDefined("FORM.Question1aPlayLevel")>
	<cfset Q1a_PlayLevel = FORM.Question1aPlayLevel >
<cfelse>
	<CFSET Q1a_PlayLevel	= "">
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
<cfif isDefined("FORM.Question5") AND len(trim(FORM.Question5))>
	<cfset Q5_SoccerID = FORM.Question5 >
<cfelse>
	<CFSET Q5_SoccerID	= "">
</cfif>
<CFIF isDefined("FORM.UPDATE")>
	<CFINVOKE component="#SESSION.SITEVARS.cfcPath#TEAM" method="updateTeamCoaches">
		<cfinvokeArgument name="updContactID" value="#SESSION.USER.CONTACTID#">
		<cfinvokeArgument name="HeadCoachID" value="#FORM.HeadCoachID#">
		<cfinvokeArgument name="AsstCoachID"  value="#FORM.AsstCoachID#">
		<cfinvokeArgument name="AsstCoachID2"  value="#FORM.AsstCoachID2#">
		<cfinvokeArgument name="AsstCoachID3"  value="#FORM.AsstCoachID3#">
		<cfinvokeArgument name="TeamID"       value="#FORM.TEAMID#" >
	</CFINVOKE>
	<CFIF swGobackToRegPage>
		<CFLOCATION url="#return_page#?cid=#VARIABLES.clubID#">
	<cfelse>
		<CFLOCATION url="TeamList.cfm?cid=#VARIABLES.clubID#">
	</CFIF>
</CFIF>

<CFSET swDisable = true>


<CFIF teamID GT 0>
	<CFINVOKE component="#SESSION.SITEVARS.cfcPath#team" method="getTeamInfo" returnvariable="qTeamInfo">
		<cfinvokeargument name="teamID" value="#VARIABLES.TeamID#">
	</CFINVOKE> <!--- <cfdump var="#qTeamInfo#"> --->

	<CFSET ClubName		= qTeamInfo.Club_name>
	<CFSET TeamId		= qTeamInfo.team_id>
	<CFSET TeamName		= qTeamInfo.TEAMNAMEderived>
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
	<cfset teamSeasonID		 = qTeamInfo.season_id>
	<cfset Q1_Roster		 = qTeamInfo.roster>
	<cfset Q1a_PlayLevel		 = qTeamInfo.prevPlayLevel>
	<cfset Q2_ReasonForPlayLevel		 = qTeamInfo.reasonForPlayLevel>
	<cfset Q3_TeamFormed		 = qTeamInfo.teamFormed>
	<cfset Q4_TeamAvailability		 = qTeamInfo.teamAvailability>
	<cfset Q5_SoccerID		 = qTeamInfo.soccerID>
	
	<!--- <CFQUERY name="checkTeam" datasource="#SESSION.DSN#">
		SELECT TEAM_ID
		  FROM TBL_TEAM
		  WHERE club_id	   = #VARIABLES.clubID#
		    AND season_id  = #VARIABLES.seasonID#
		    AND upper(teamAge)    = '#ucase(VARIABLES.TeamAge)#'
		    AND upper(playLevel)  = '#ucase(VARIABLES.PlayLevel)#'
		    AND upper(gender)     = '#ucase(VARIABLES.Gender)#'
		    AND upper(USSFDiv)    = '#ucase(VARIABLES.USSFDiv)#'
		    AND ContactIDHead = #VARIABLES.HeadCoachID#
		    AND ContactIDAsst = #VARIABLES.AsstCoachID#
	</CFQUERY> <!--- 	<cfdump var="#checkTeam#"> --->
	
	<CFIF checkTeam.RECORDCOUNT>
		<CFSET errMessage = errMessage & "<B>This team has already been registered.</B>">
		<CFSET swDisable = true>
	</CFIF> --->
	
	<CFIF Gender EQ "B">
		<CFSET GenderBoys  = "checked">
		<CFSET GenderGirls = "">
	<CFELSEIF Gender EQ "G">
		<CFSET GenderBoys  = "">
		<CFSET GenderGirls = "checked">
	<CFELSE>
		<CFSET GenderBoys	= "">
		<CFSET GenderGirls	= "">
	</CFIF>
	
	<cfinvoke component="#SESSION.SITEVARS.cfcpath#SEASON" method="getSeasonInfoByID" returnvariable="qSeasonInfo" >
		<cfinvokeargument name="seasonID" value="#VARIABLES.teamSeasonID#" > 
	</cfinvoke>
	<CFSET seasonText = qSeasonInfo.season_SF & " " & qSeasonInfo.season_YEAR>
	
</CFIF>


<cfinvoke component="#SESSION.SITEVARS.cfcpath#contact" method="getClubContactRoleX" returnvariable="qCoaches">
	<cfinvokeargument name="clubID" value="#VARIABLES.clubID#"> 
	<cfinvokeargument name="roleID" value="#SESSION.CONSTANT.RoleIDcoach#"> 
</cfinvoke>

<CFQUERY name="qOtherContacts" datasource="#SESSION.DSN#">
	SELECT c.contact_id, c.FirstName, c.lastName
	  FROM TBL_CONTACT c INNER JOIN XREF_CONTACT_ROLE X on x.CONTACT_ID = c.CONTACT_ID
	 WHERE c.CLUB_ID = #VARIABLES.ClubId#
	   AND c.CONTACT_ID NOT IN (#valueList(qCoaches.contact_id)#)
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


<H1 class="pageheading">NCSA - Team Edit  for the #VARIABLES.seasonText# season</H1>
<h2>Club: #VARIABLES.ClubName#</h2>
	
<FORM name="teamEdit" action="teamEdit.cfm"  method="post">
	<input type="hidden" name="ClubId"	value="#VARIABLES.ClubId#">
	<input type="hidden" name="TeamID"	value="#TeamId#">
	<input type="hidden" name="swGobackToRegPage" value="#VARIABLES.swGobackToRegPage#">
	<input type="hidden" name="return_page" value="#VARIABLES.return_page#">
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
		<TD colspan="2">Team Info for: #TeamName# </TD>
	</tr>
		<cfif len(Trim(errMessage))>
			<TR><TD colspan="3" align="Center" class="red">
					#errMessage#
				</td>
			</TR>
		</cfif>
	<TR><TD align="right">#required# <b>Gender</b> 		</TD>
		<TD><CFIF Gender EQ "B"> 
				Boys
			<CFELSE>
				Girls
			</CFIF>
		<!--- <input type="Radio" maxlength="1" name="Gender" value="B" #GenderBoys#  <cfif swDisable>disabled</cfif> > Boys
			<input type="Radio" maxlength="1" name="Gender" value="G" #GenderGirls# <cfif swDisable>disabled</cfif> > Girls --->
		</TD>
	</TR>
	<TR><TD align="right"> #required# <b>Team Age Group</B></TD>
		<TD>#TeamAge#
			<!--- <SELECT  name="TeamAge" <cfif swDisable>disabled</cfif> > 
				<CFLOOP list="#lTeamAges#" index="ita">
					<OPTION value="#ita#" <CFIF TeamAge EQ ita>selected</CFIF>  >#ita#</OPTION>
				</CFLOOP>
			</SELECT> --->
		</TD>
	</tr>
	<tr><TD align="right">#required# <b>Play Level</b></TD>
		<TD>#PlayLevel#
			<!--- <SELECT  name="PlayLevel" <cfif swDisable>disabled</cfif> >
				<CFLOOP list="#lPlayLevel#" index="ipl">
					<OPTION value="#ipl#" <CFIF PlayLevel EQ ipl>selected</CFIF> >#ipl#</OPTION>
				</CFLOOP>
			</SELECT>
			<span class="red"><u>(Flight 'X' is reserved for CUP divisional Play only)</u></span> --->
		</TD>
	</TR>
	<TR><TD align="right"><b>Division</b></TD>
		<TD>#Division#</TD>
	</TR>
	<TR><TD align="right">#required# <b>USSF Rgstd Div</b> </TD>
		<TD>#USSFDiv#
			<!--- <SELECT  name="USSFDiv" <cfif swDisable>disabled</cfif> >
				<CFLOOP list="#lTeamAges#" index="ita">
					<OPTION value="#ita#" <CFIF USSFDiv EQ ita>selected</CFIF>  >#ita#</OPTION>
				</CFLOOP>
			</SELECT> --->
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
		<TD><textarea name="Question2" rows="5" cols="24" maxlength="500" <cfif swDisable>disabled</cfif>><CFIF len(trim(Q2_ReasonForPlayLevel))>#Q2_ReasonForPlayLevel#</CFIF></textarea>
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
	
	<tr><td align="right" style="width: 40%;"> <b>If NCSA offers to provide information to Got Soccer about results for your flight and if you wish to have Got Soccer points awarded, you must include your Got Soccer ID number here:</b>	</TD>
		<TD><input type="text" name="Question5" maxlength="20" <cfif swDisable>disabled</cfif> <CFIF len(trim(Q5_SoccerID))>value="#Q5_SoccerID#"</CFIF> >
		</TD>
	</tr>
	<!--- <tr><td align="right">#required# <b>Head Coach Second Team</b>	</TD>
		<TD><SELECT name="SecondTeam" <cfif swDisable>disabled</cfif> > 
				<OPTION value="" selected>Select</OPTION>
				<CFLOOP list="#lTeamAges#" index="ita">
					<OPTION value="#ita#" <CFIF SecondTeam EQ ita>selected</CFIF>  >#ita#</OPTION>
				</CFLOOP>
			</SELECT>
		</TD>
	</tr>
	<CFIF SF EQ "SPRING">
		<tr><TD align="right"> Willing to play other than sunday? </TD>
			<TD><SELECT name="NonSundayPlay" <cfif swDisable>disabled</cfif> > 
					<OPTION value="Y" <CFIF NonSundayPlay EQ "Y">selected</CFIF> >Yes</OPTION>
					<OPTION value="N" <CFIF NonSundayPlay EQ "N">selected</CFIF> >No </OPTION>
				</SELECT>
			</td>
		</tr>
	<CFELSE>
		<input type="Hidden" name="NonSundayPlay" value="">
	</CFIF> --->

	<TR><TD colspan="2" align="center">
			<hr size="1">
				&nbsp; &nbsp; 
				<INPUT type="submit" name="UPDATE" value="Save Changes"> 
			 
				<!--- &nbsp; &nbsp; 
				<INPUT type="submit" name="DELETE" value="Delete">  --->
			
			&nbsp; &nbsp; 
			<INPUT type="button" name="Back"   value="Back" onclick="history.go(-1)">
			</TD>
		</TR>
	</TABLE>
</FORM>

	
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
</script>
<cfinclude template="_footer.cfm">
