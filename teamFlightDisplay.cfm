<!--- 
	FileName:	teamFlightDisplay.cfm
	Created on: 01/12/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: Lists out all the registered teams that are approved and appeals
	
MODS: mm/dd/yyyy - filastname - comments
01/15/2009 - aarnone - changed message on top.
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<!--- <cfinclude template="_checkLogin.cfm"> use? --->

<cfif isDefined("FORM.TeamAge")>
	<cfset teamAge = FORM.TeamAge>
<cfelse>
	<cfset teamAge = "">
</cfif>	

<cfif isDefined("FORM.ClubID")>
	<cfset ClubID = FORM.ClubID>
<cfelse>
	<cfset ClubID = "">
</cfif>	

<cfif isDefined("FORM.Gender")>
	<cfset Gender = FORM.Gender>
<cfelse>
	<cfset Gender = "">
</cfif>

<cfoutput>
<div id="contentText">

<!--- WE are not using SESSION values because it is a public page  --->
<cfset seasonID = 0>	
<cfset seasonSF = "">
<cfset seasonYR = "">

<cfquery name="qRegSeason" datasource="#SESSION.DSN#">
	SELECT season_id, season_year, season_SF
     FROM tbl_season 
	 WHERE RegistrationOpen_YN = 'Y'
</cfquery>
<CFIF qRegSeason.RECORDCOUNT> 
	<!--- Use the REG season --->
	<cfset seasonID = qRegSeason.season_id>
	<cfset seasonSF = qRegSeason.season_SF>
	<cfset seasonYR = qRegSeason.season_year>
<CFELSE>
	<!--- Use the CURRENT season --->	
	<cfquery name="qCurrSeason" datasource="#SESSION.DSN#">
		SELECT season_id, season_year, season_SF
   		  FROM tbl_season 
		 WHERE CurrentSeason_YN = 'Y'
	</cfquery>
	<CFIF qCurrSeason.RECORDCOUNT> 
		<!--- Use the REG season --->
		<cfset seasonID = qCurrSeason.season_id>	
		<cfset seasonSF = qCurrSeason.season_SF>
		<cfset seasonYR = qCurrSeason.season_year>
	</CFIF>
</CFIF>

<H1 class="pageheading">NCSA - Team Flighting </H1>
<h2>For #VARIABLES.seasonSF# #VARIABLES.seasonYR# Teams </h2>
<span class="red">
	<br>LEVEL displayed is same as requested division until flighting is done by division commissioner - check Calendar for date flights to be posted.
	<br>
	<br>APPEALS may be filed only by Club Representatives through online process - Club's ability to appeal closes 72 hours prior to Preseason Flight Meeting - check Calendar for dates.
	<br>
	<br>
</span>		

<cfquery name="qTeamAge" datasource="#SESSION.DSN#">
	SELECT DISTINCT TEAMAGE 
	  FROM TBL_TEAM 
	 WHERE SEASON_ID = #VARIABLES.seasonID#
	 ORDER BY TEAMAGE
</cfquery> <!--- WHERE SEASON_ID = (SELECT season_id FROM tbl_season WHERE RegistrationOpen_YN = 'Y') --->

<cfquery name="qClubList" datasource="#SESSION.DSN#">
	SELECT distinct cl.club_id, cl.Club_name, cl.ClubAbbr
	  FROM tbl_club cl  INNER JOIN xref_club_season XCS  ON XCS.club_id = cl.club_id 	     
	 WHERE XCS.APPROVED_YN = 'Y'
	   and xcs.season_id = #VARIABLES.seasonID#
	   and XCS.CLUB_ID <> 1	
	 ORDER BY cl.Club_name
</cfquery> <!--- and xcs.season_id = (select season_id from tbl_season where RegistrationOpen_YN = 'Y') --->

<FORM action="teamFlightDisplay.cfm" method="post">
	<b>Team Age</b>
	<SELECT name="TeamAge" > 
		<OPTION value="" selected>Select Age</OPTION>
		<cfloop query="qTeamAge">
			<OPTION value="#TeamAge#" <cfif VARIABLES.teamAge EQ TEAMAGE>selected</cfif> >#TeamAge#</OPTION>
		</cfloop>
	</SELECT>
	
	<b>Club Name</b> &nbsp; 
	<SELECT name="ClubID" > 
		<OPTION value="0" selected>Select Club</OPTION>
		<CFLOOP query="qClubList">
			<OPTION value="#club_id#" <cfif VARIABLES.clubID EQ club_id>selected</cfif> >#Club_name#</OPTION>
		</CFLOOP>
	</SELECT>
	
	<b>Select Gender </b>
	<SELECT name="Gender">
		<OPTION value=""  <cfif VARIABLES.gender EQ "">selected</cfif> > Both </OPTION>
		<OPTION value="B" <cfif VARIABLES.gender EQ "B">selected</cfif> > Boys </OPTION>
		<OPTION value="G" <cfif VARIABLES.gender EQ "G">selected</cfif> > Girls</OPTION>
	</SELECT>
	<input type="Submit" name="GETTEAMS" value="Get Teams">
</FORM>

<br>
<CFIF isDefined("FORM.GETTEAMS")>
	<CFQUERY name="qGetTeams" datasource="#SESSION.DSN#">
		SELECT team_id, teamAge, playLevel, division, USSFDiv, requestDiv, 
			   playgroup, appeals, appealsStatus, gender, teamname,
			   dbo.getTeamName(team_id) AS TEAMNAMEderived
		  FROM tbl_team
		 WHERE SEASON_ID = #VARIABLES.seasonID#
		   AND approved_yn = 'Y'
		<CFIF len(Trim(gender))>
		   AND gender = <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.gender#">
		</CFIF>   
		<CFIF clubID GT 0>
			AND CLUB_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.clubID#">
		<CFELSE>
			AND CLUB_ID <> 1
		</CFIF>
		<CFIF len(trim(TeamAge))>
			AND TeamAge = <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.TeamAge#">
		</CFIF>
		ORDER BY gender, teamAge, playLevel, playgroup
	</CFQUERY>	<!--- WHERE SEASON_ID = (select season_id from tbl_season where RegistrationOpen_YN = 'Y') --->

	<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
		<tr class="tblHeading">
				<td width="10%" align=center>Gender</td>
				<td width="10%" align=center>Team Age</td>
				<td width="10%" align=center>Level</td>
				<td width="10%" align=center>Group</td>
				<td width="10%" align=center>Req. Div</td>
				<!--- <td width="10%">&nbsp;</td>	<!-- Pr. Div --> --->
				<!--- <td width="10%">&nbsp;</td>	<!-- USSF Div --> --->
				<td width="30%" align=left>Team</td>
				<td width="20%" align=center>Appeal Status</td>
		</tr>
	</table>	
	<CFIF qGetTeams.RECORDCOUNT>
		<div style="overflow:auto;height:300px;border:1px ##cccccc solid;">
		<table cellspacing="0" cellpadding="5" align="left" border="0" width="100%">
			<CFLOOP query="qGetTeams">
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> <!--- currentRow or counter --->
					<td width="10%" class="tdUnderLine" align=center> #repeatString("&nbsp;",3)# #Trim(Gender)#		</td>
					<td width="10%" class="tdUnderLine" align=center> #repeatString("&nbsp;",3)# #Trim(teamAge)#		</td>
					<td width="10%" class="tdUnderLine" align=center> &nbsp; #Trim(PlayLevel)#	</td>
					<td width="10%" class="tdUnderLine" align=center> &nbsp; #Trim(PlayGroup)#	</td>
					<td width="10%" class="tdUnderLine" align=center> &nbsp; #requestDiv#		</td>
					<!--- <td width="10%" class="tdUnderLine" >				 #Division#			</td> --->
					<!--- <td width="10%" class="tdUnderLine" >				 #USSFDiv#			</td> --->
					<td width="30%" class="tdUnderLine" >			  &nbsp; #TEAMNAMEderived#		</td>
					<td width="20%" class="tdUnderLine" align=center>
						<cfswitch expression="#ucase(appealsStatus)#">
							<cfcase value="P"> Pending  </cfcase>
							<cfcase value="A"> Accepted </cfcase>
							<cfcase value="R"> Rejected </cfcase>
							<cfdefaultcase>    &nbsp;	</cfdefaultcase>
						</cfswitch>
					</td>
				</TR>
			</CFLOOP>
		</table>
		</div>	
	<cfelse>
		<span class="red"> <b>No Teams Found.</b> </span>
	</CFIF>
</CFIF>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">
