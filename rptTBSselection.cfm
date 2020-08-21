<!--- 
	FileName:	rptTBSselection.cfm
	Created on: 02/03/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: 
	
	
MODS: mm/dd/yyyy - filastname - comments
 02/12/09 - AA - add mods
 11/16/2016 - rgonzalez - removed comments from cfquery
 07/17/2017 - apinzone - removed logic to hide 9:00am requests
 09/06/2017 - rgonzalez - added extra copy under Teams available with special 															requests
												- changed 4th column name to Head Coach Add'l team
												- Added X to table if head coach coaches more than 1 team
 --->

<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>
<div id="contentText">

<CFIF isDefined("URL.spr")>
	<CFSET swShowAvailOnly = true> <!--- for teams available with Special Requests --->
<CFELSEIF isDefined("FORM.swShowAvailOnly")>
	<CFSET swShowAvailOnly = FORM.swShowAvailOnly>
<CFELSE>
	<CFSET swShowAvailOnly = false> <!--- for teams NOT available --->
</CFIF>


<CFIF swShowAvailOnly>
	<H1 class="pageheading">NCSA - Special Request Report </H1>	
	<h2>Teams available with special requests </h2>
	<h2>For teams listed with an "X" in Head Coach Additional Team column, please see Report ##3a for identification of other team(s). </h2>
<CFELSE>
	<H1 class="pageheading">NCSA - Requested TBS Report </H1>	
	<h2>Teams NOT available </h2>
</CFIF>
<br>


<CFIF isDefined("FORM.clubSelected")>
	<CFSET clubSelected = FORM.clubSelected >
<CFELSE>
	<CFSET clubSelected = 0 >
</CFIF>
<CFIF isDefined("FORM.TeamAgeSelected")>
	<cfset TeamAgeSelected = trim(FORM.TeamAgeSelected)>
<CFELSE>
	<cfset TeamAgeSelected = "">
</CFIF>
<CFIF isDefined("FORM.BGSelected")>
	<cfset BGSelected = trim(FORM.BGSelected)>
<CFELSE>
	<cfset BGSelected = "">
</CFIF>
<CFIF isDefined("FORM.PlayLevel")>
	<cfset PlayLevel = trim(FORM.PlayLevel)>
<CFELSE>
	<cfset PlayLevel = "">
</CFIF>
<cfif isDefined("FORM.weekEndID") AND isNumeric(FORM.weekEndID)>
	<cfset weekEndID	 = FORM.weekEndID>
	<cfset selectWEval	 = FORM.weekEndID> <!--- preserves value for dropdown --->
	<cfset QuerySeasonID = 0>
<cfelseif isDefined("FORM.weekEndID") AND FORM.weekEndID EQ "cur" >
	<cfset weekEndID	 = 0>
	<cfset selectWEval	 = FORM.weekEndID> <!--- preserves value for dropdown --->
	<cfset QuerySeasonID = SESSION.CURRENTSEASON.ID>
<cfelseif isDefined("FORM.weekEndID") AND FORM.weekEndID EQ "reg" >
	<cfset weekEndID	 = 0>
	<cfset selectWEval	 = FORM.weekEndID> <!--- preserves value for dropdown --->
	<cfset QuerySeasonID = SESSION.REGSEASON.ID>
<CFELSE>
	<cfset weekEndID	 = 0>
	<cfset selectWEval	 = "">
	<cfset QuerySeasonID = 0>
</cfif>

<CFIF isDefined("FORM.SORTORDER")>
	<cfset selectSort = FORM.SORTORDER>
<CFELSE>
	<cfset selectSort = "">
</CFIF>

<!--- === START - Get values for Drop Down Lists === --->
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="lTeamAges">
	<cfinvokeargument name="listType" value="TEAMAGES"> 
</cfinvoke> <!--- lTeamAges --->
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="lPlayLevel">
	<cfinvokeargument name="listType" value="PLAYLEVEL"> 
</cfinvoke> <!--- lPlayLevel --->

<!---<cfinvoke component="#SESSION.SITEVARS.cfcPath#registration" method="getRegisteredClubs" returnvariable="qClubs">
	<cfinvokeargument name="orderby" value="clubname">
</cfinvoke>  CLUBS --->
<CFQUERY name="qClubs" datasource="#SESSION.DSN#">
	SELECT club_id, Club_name 
      FROM  tbl_club 
	 ORDER BY CLUB_NAME
</CFQUERY>




<cfinvoke component="#SESSION.SITEVARS.cfcPath#SEASON" method="getPlayweeks" returnvariable="qPlayWEcurr">
	<cfinvokeargument name="seasonID" value="#SESSION.CURRENTSEASON.ID#">
</cfinvoke> <!--- CURRENT season --->
<cfif IsDefined("SESSION.REGSEASON")>
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#SEASON" method="getPlayweeks" returnvariable="qPlayWEreg">
		<cfinvokeargument name="seasonID" value="#SESSION.REGSEASON.ID#">
	</cfinvoke> <!--- REG season --->
</cfif>

<CFQUERY name="qWorkingSeasons" datasource="#SESSION.DSN#">
	SELECT SEASON_ID, SEASON_YEAR, SEASON_SF, 
		   CURRENTSEASON_YN, REGISTRATIONOPEN_YN
	  FROM TBL_SEASON 
	 WHERE  season_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#SESSION.CurrentSeason.ID#">
	    OR REGISTRATIONOPEN_YN = 'Y'
	ORDER BY SEASON_ID
</CFQUERY>
<!--- === END - Get values for Drop Down Lists === --->


<FORM name="teamID" action="rptTBSselection.cfm" method="post">
<input type="Hidden" name="swShowAvailOnly" value="#VARIABLES.swShowAvailOnly#">
<table cellspacing="0" cellpadding="3" align="center" border="0" width="80%" >
	<!--- <cfif listFind(SESSION.CONSTANT.CUROLES, SESSION.MENUROLEID) GT 0>
		<!--- its a club, use their club id and supress team id --->
		<cfset swShowTeamID = false>
		<input type="Hidden" name="Clubselected" value="#SESSION.USER.CLUBID#"> 
	<cfelse> --->
		<TR><TD colspan="6" valign="bottom">
				<!--- admin/board let them choose a club --->
				<cfset swShowTeamID = true>
				<b>Select a Club:</b>
				<Select name="Clubselected">
					<option value="0">All Clubs</option>
					<CFLOOP query="qClubs">
						<option value="#CLUB_ID#" <CFIF CLUB_ID EQ VARIABLES.clubSelected>selected</CFIF> >#CLUB_NAME#</option>
						<CFIF CLUB_ID EQ VARIABLES.clubSelected><cfset clubname = CLUB_NAME></CFIF>
					</CFLOOP>
				</SELECT>
			</TD>
		</TR>
	<!--- </cfif> --->
	<TR><TD valign="bottom"><b>Gender:</b>		 </TD>
		<TD valign="bottom"><b>Team Age:</b>	 </TD>
		<TD valign="bottom"><b>Level:</b>		 </TD>
		<TD valign="bottom"><b>Play Weekend:</b> </TD>
		<TD valign="bottom"><b>Sort By:</b>		 </TD>
		<TD>&nbsp;				 </TD>
	</TR>
	<TR><TD><SELECT  name="BGSelected" >
				<OPTION value="">Both </OPTION>
				<OPTION value="B" <CFIF VARIABLES.BGSelected EQ "B">selected</CFIF> >Boys</OPTION>
				<OPTION value="G" <CFIF VARIABLES.BGSelected EQ "G">selected</CFIF> >Girls</OPTION>
			</SELECT>
		</TD>
		<TD><SELECT  name="TeamAgeSelected" >
				<OPTION value="">All</OPTION>
				<CFLOOP list="#lTeamAges#" index="ita">
					<OPTION value="#ita#" <CFIF VARIABLES.TeamAgeSelected EQ ita>selected</CFIF>  >#ita#</OPTION>
				</CFLOOP>
			</SELECT>
		</TD>
		<TD><SELECT  name="PlayLevel">
				<OPTION value="" selected>All</OPTION>
				<CFLOOP list="#lPlayLevel#" index="ipl">
					<OPTION value="#ipl#" <CFIF PlayLevel EQ ipl>selected</CFIF> >#ipl#</OPTION>
				</CFLOOP>
			</SELECT>
		</TD>
		<TD><select name="weekEndID" >
				<option value="cur" <cfif selectWEval EQ "cur">selected</cfif> >All #SESSION.CURRENTSEASON.SF# #SESSION.CURRENTSEASON.YEAR# Weekends</option> 
				<cfloop query="qPlayWEcurr">
					<option value="#playWeekEnd_ID#" <cfif selectWEval EQ playWeekEnd_ID>selected</cfif> > 
						#week_number#. #dateFormat(Day1_date,"ddd mm/dd/yy")# #dateFormat(Day2_date,"ddd mm/dd/yy")# 
					</option>
				</cfloop>
				<CFIF isDefined("qPlayWEreg")>
					<option value="reg" <cfif selectWEval EQ "reg">selected</cfif> >All #SESSION.REGSEASON.SF# #SESSION.REGSEASON.YEAR# Weekends</option> 
					<cfloop query="qPlayWEreg">
						<option value="#playWeekEnd_ID#" <cfif selectWEval EQ playWeekEnd_ID>selected</cfif> > 
							#week_number#. #dateFormat(Day1_date,"ddd mm/dd/yy")# #dateFormat(Day2_date,"ddd mm/dd/yy")# 
						</option>
					</cfloop>
				</CFIF> 
			</select>
		</TD>
		<TD><select name="sortOrder">
				<option value="TEAM" <cfif selectSort EQ "TEAM">selected</cfif> >Team Name</option>
				<option value="FLIT" <cfif selectSort EQ "FLIT">selected</cfif> >Flight</option>
			</select>
		</TD>
		<TD><INPUT type="Submit" name="getTBS" value="Go">
		</TD>
	</TR>
</table>
</FORM> <!--- End of Selection form --->


<CFIF isDefined("FORM.getTBS")>
	<!--- <cfdump var="#FORM#">
	<br> clubSelected [#clubSelected#]
	<br> TeamAgeSelected [#TeamAgeSelected#]
	<br> BGSelected [#BGSelected#]
	<BR> PlayLevel [#PlayLevel#]
	<br> weekEndID [#weekEndID#] --->

	<!--- figure out which season to use based on Play Weekend value selected --->
	<cfif isNumeric(FORM.weekEndID)>
		<cfquery name="qGetSeasonFromPlayWeeks" datasource="#SESSION.DSN#">
			SELECT SEASON_ID 
			  FROM TBL_PLAYWEEKEND
			 WHERE PLAYWEEKEND_ID = #VARIABLES.weekEndID#	
		</cfquery>
		<cfset seasonID	 = qGetSeasonFromPlayWeeks.SEASON_ID>
	<cfelseif FORM.weekEndID EQ "cur" >
		<cfset seasonID	 = SESSION.CURRENTSEASON.ID>
	<cfelseif FORM.weekEndID EQ "reg" >
		<cfset seasonID	 = SESSION.REGSEASON.ID>
	<CFELSE>
		<cfset seasonID	 = 0>
	</cfif>
	<!--- Get Teams based on selection criteria --->
	<cfquery name="qGetTeams" datasource="#SESSION.DSN#">
		SELECT T.team_id, T.teamAge, T.playLevel, T.playgroup, T.gender
			 , dbo.getTeamName(T.team_id) AS TEAMNAMEderived
			 , IsNull(T.Gender,'') + right(T.TeamAge,2) + IsNull(T.PlayLevel,'') + IsNull(T.PlayGroup,'') AS DIVISION
			 , T.CLUB_ID, C.CLUBABBR, 
			 (SELECT dbo.f_get_head_coach_multi_team_count(T.CONTACTIDHEAD, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.seasonID#">)) AS SECONDTEAM
		  FROM tbl_team T INNER JOIN tbl_club C         ON C.CLUB_ID = T.CLUB_ID
		                  INNER JOIN XREF_CLUB_SEASON X ON X.club_id = C.club_id 
		                                                AND X.SEASON_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.seasonID#">
		                                                AND X.ACTIVE_YN = 'Y' 
		 WHERE T.SEASON_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.seasonID#">
		   AND T.Approved_YN = 'Y' 
			<cfif clubSelected GT 0>
   				AND T.club_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.clubSelected#">
   			</cfif>
			<cfif len(trim(VARIABLES.TeamAgeSelected)) GT 0>
				AND T.TEAMAGE = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.TeamAgeSelected#">
   			</cfif>
			<cfif len(trim(VARIABLES.BGSelected)) GT 0>
				AND T.GENDER = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.BGSelected#">
   			</cfif>
			<cfif len(trim(VARIABLES.PlayLevel)) GT 0>
				AND T.PLAYLEVEL = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.PlayLevel#">
   			</cfif>
		ORDER BY <cfif selectSort EQ "FLIT">
					DIVISION, TEAMNAMEderived
				<cfelse>	TEAMNAMEderived
				</cfif>		
	</cfquery> <!---  <cfdump var="#qGetTeams#"> --->
</CFIF>


<CFIF isDefined("qGetTeams") AND qGetTeams.RECORDCOUNT GT 0>
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#SEASON" method="getSeasonInfoByID" returnvariable="qSeasonInfo">
		<cfinvokeargument name="seasonID" value="#VARIABLES.seasonID#">
	</cfinvoke> <!--- CURRENT season --->
	<cfset season_sf = qSeasonInfo.season_SF>

	<table cellspacing="0" cellpadding="5" align="left" border="0" width="98%">
		<tr class="tblHeading">
			<td width="08%"><cfif swShowTeamID>Team ID<CFELSE>&nbsp;</cfif> </td>
			<td width="07%">Flight</td>
			<td width="25%">Team Name</td>
			<td width="15%">Head Coach Add'l team</td>
			<td width="15%">Day-Date</td>
			<td width="05%">Avlbl.</td>
			<td width="11%"><CFIF swShowAvailOnly>Bef/Aft<CFELSE>&nbsp;</CFIF></td>
			<td width="14%"><CFIF swShowAvailOnly>Time<CFELSE>&nbsp;</CFIF></td>
		</tr>
		<CFSET TotalTeams = 0>
		<cfset recCount = 0>
		
		<CFLOOP query="qGetTeams">
			<cfinvoke component="#SESSION.SITEVARS.cfcPath#TEAM" method="TeamPlayWeeks" returnvariable="qPlayWKs">
				<cfinvokeargument name="TeamID" value="#TEAM_ID#">
			</cfinvoke>

			<!--- START - show only YES or NO --->
			<cfset wherePWclause = "">
			<CFIF swShowAvailOnly EQ false>
				<cfif season_sf EQ "FALL">
					<cfIf Trim(qGetTeams.Gender) EQ "B" >
						<cfset wherePWclause = " SatAvailable_YN = 'N' ">
	 				<cfelseif Trim(qGetTeams.Gender) EQ "G" ><!--- if yesNoFormat(trim(SunAvailable_YN) EQ "Y") --->
						<cfset wherePWclause = " SunAvailable_YN = 'N' ">
					</cfif>
				<cfelse>   <!---  SPRING   --->
					<cfset wherePWclause = " SunAvailable_YN = 'N' ">
				</cfif>
			<CFELSEIF  swShowAvailOnly EQ true>
				<cfif season_sf EQ "FALL">
					<cfIf Trim(qGetTeams.Gender) EQ "B" >
						<cfset wherePWclause = " SatAvailable_YN = 'Y' AND SATBeforeAfter <> 'N' " >
					<cfelseif Trim(qGetTeams.Gender) EQ "G"><!--- if yesNoFormat(trim(SunAvailable_YN) EQ "Y") --->
						<cfset wherePWclause = " SunAvailable_YN = 'Y' AND SunBeforeAfter <> 'N' " >
					</cfif>
				<cfelse	>  <!---  SPRING   --->
					<cfset wherePWclause = " SunAvailable_YN = 'Y' AND SunBeforeAfter <> 'N' " >
				</cfif>
			</CFIF>
			
			<cfif len(trim(wherePWclause))>
				<cfquery name="qPlayWKs" dbtype="query">
					SELECT * FROM qPlayWKs 
					 WHERE <cfif isNumeric(FORM.weekEndID)>
						   	PLAYWEEKEND_ID = #FORM.weekEndID# AND 
						   </cfif>
					 #preserveSingleQuotes(wherePWclause)# 
				</cfquery>
			</CFIF>  
			<!--- END - show only YES or NO --->
	
			<CFIF qPlayWKs.RECORDCOUNT>
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,recCount)#">
					<td class="tdUnderLine" ><cfif swShowTeamID>#TEAM_ID#<CFELSE>&nbsp;</cfif> </td>
					<td class="tdUnderLine" >#DIVISION#</td>
					<td class="tdUnderLine" >#teamnamederived#</td>
					<td class="tdUnderLine" align="center">
						<cfif SECONDTEAM GT 1>
							X
						</cfif>
						<!--- REPLACE WITH ALSO HEAD COACH STATUS --->
					</td>
					<cfloop query="qPlayWKs">
						<cfset current_team_id = TEAM_ID>
						<CFSET swSkipIt = false>
						<cfif NOT swSkipIt>
							<cfset recCount = recCount + 1 >
								<td class="tdUnderLine" ><!--- #Week# --->
									<cfif season_sf EQ "FALL">
										<cfIf Trim(qGetTeams.Gender) EQ "B">
											#dateFormat(day1_date,"ddd - mm/dd/yy")#
										<cfelse>
											#dateFormat(day2_date,"ddd - mm/dd/yy")#
										</cfif>
									<cfelse> <!---  SPRING   --->
										#dateFormat(day2_date,"ddd - mm/dd/yy")#
									</cfif>
								</td>
								<td class="tdUnderLine" align="center">
									<cfif season_sf EQ "FALL">
										<cfIf Trim(qGetTeams.Gender) EQ "B">
											#yesNoFormat(trim(SatAvailable_YN) EQ "Y")#	<!--- <cfIf trim(SatAvailable_YN) EQ "Y" >YES<cfelse>NO</cfif> --->
										<cfelse> 
											#yesNoFormat(trim(SunAvailable_YN) EQ "Y")#	<!--- <cfIf trim(SunAvailable_YN) EQ "Y" >YES<cfelse>NO</cfif> --->
										</cfif>
									<cfelse> <!---  SPRING   --->
										#yesNoFormat(trim(SunAvailable_YN) EQ "Y")#		<!--- <cfIf trim(SunAvailable_YN) EQ "Y" >YES<cfelse>NO</cfif> --->
									</cfif>
								</td>
								<td  class="tdUnderLine" align="center">
								<CFIF swShowAvailOnly>
									<cfif season_sf EQ "FALL">
										<cfIf Trim(qGetTeams.Gender) EQ "B" >
											<cfIf trim(SatBeforeAfter) EQ "A" > After <cfelse> Before </cfif>
										<cfelse>
											<cfIf trim(SunBeforeAfter) EQ "A" > After <cfelse> Before </cfif>
										</cfif>
									<cfelse><!---  SPRING  --->
										<cfIf trim(SunBeforeAfter) EQ "A" >  After 	<cfelse>  Before </cfif>
									</cfif>
								<CFELSE>
									&nbsp;
								</CFIF>
								</td>
								<td class="tdUnderLine" >
								<CFIF swShowAvailOnly>
									<cfif season_sf EQ "FALL" >
										<cfIf Trim(qGetTeams.Gender) EQ "B" >
											#timeformat(SatTime, "hh:mm tt")#
										<cfelse> <!--- GIRLS --->
											#timeformat(SunTime, "hh:mm tt")#
										</cfif>
									<cfelse> <!--- SPRING --->
										#timeformat(SunTime, "hh:mm tt")#
									</cfif>
								<CFELSE>
									&nbsp;
								</CFIF>
								</td>
							</tr>
						

<!--- 
if count for loop is to be 10 times,
then check if all 10 occurances are the
same by doing a select distinct to see
 --->						

							<!--- this sets up the next row, where team/name/clubabbr are supressed --->
							<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,recCount)#">
								<td class="tdUnderLine" colspan="4">&nbsp;</td>
						
						</cfif>
					</cfloop>
					<td class="tdUnderLine" colspan="4" >&nbsp;</td> 
				</tr>
				<!--- </tr>  --->
				<CFSET TotalTeams = TotalTeams + 1 >
			<!--- END - IF qPlayWKs.RECORDCOUNT --->
			<CFELSEIF SECONDTEAM GT 1>
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,recCount)#">
					<td class="tdUnderLine" ><cfif swShowTeamID>#TEAM_ID#<CFELSE>&nbsp;</cfif> </td>
					<td class="tdUnderLine" >#DIVISION#</td>
					<td class="tdUnderLine" >#teamnamederived#</td>
					<td class="tdUnderLine" align="center">
						X
						<!--- REPLACE WITH ALSO HEAD COACH STATUS --->
					</td>
					<td class="tdUnderLine"></td>
					<td class="tdUnderLine"></td>
					<td class="tdUnderLine"></td>
					<td class="tdUnderLine"></td>
				</tr>
				<CFSET TotalTeams = TotalTeams + 1 >
			</CFIF>
		</CFLOOP>
		<TR><td >&nbsp;</td>
			<td >&nbsp;</td>
			<td align=right>		  <B>Total teams</B></td>
			<td align=center>		  <B>#TotalTeams#</B></td>
			<td colspan=2 align=right>
				<CFIF swShowAvailOnly>
					<B>Total Special Requests</B>
				<CFELSE>
					<B>Total TBS</B>
				</CFIF>
			</td>
			<td align=center>		  <B>#reccount#</B></td>
		</TR>
	</table>
<cfelseIF isDefined("qGetTeams") AND qGetTeams.RECORDCOUNT EQ 0>
	<table cellspacing="0" cellpadding="5" align="left" border="0" width="98%">
		<tr class="tblHeading">
			<td>&nbsp;</td>
		</tr>
		<TR><td> <span class="red"> <b>No teams found based on choices.</b></span> </td>
		</TR>
	</table>
	
</CFIF>





	
</cfoutput>
</div>
<cfinclude template="_footer.cfm">
