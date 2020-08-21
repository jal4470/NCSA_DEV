<!--- 
	FileName:	rptTBSselection.cfm
	Created on: 02/03/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: 
	
	
MODS: mm/dd/yyyy - filastname - comments

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
	 WHERE CURRENTSEASON_YN = 'Y' 
	    OR REGISTRATIONOPEN_YN = 'Y'
	ORDER BY SEASON_ID
</CFQUERY>
<!--- === END - Get values for Drop Down Lists === --->


<FORM name="teamID" action="rptTBSselectionA.cfm" method="post">
<input type="Hidden" name="swShowAvailOnly" value="#VARIABLES.swShowAvailOnly#">
<table cellspacing="0" cellpadding="3" align="center" border="0" width="98%">
	<TR><TD><cfif listFind(SESSION.CONSTANT.CUROLES, SESSION.MENUROLEID) GT 0>
				<!--- a CLUB is logged in, default to their club ID --->
				<input type="Hidden" name="Clubselected" value="#SESSION.USER.CLUBID#"> 
			<cfelse>
				<!--- admin/board let them choose a club --->
				&nbsp; 
				<b>Select a Club:</b>
				<Select name="Clubselected">
					<option value="0">All Clubs</option>
					<CFLOOP query="qClubs">
						<option value="#CLUB_ID#" <CFIF CLUB_ID EQ VARIABLES.clubSelected>selected</CFIF> >#CLUB_NAME#</option>
						<CFIF CLUB_ID EQ VARIABLES.clubSelected><cfset clubname = CLUB_NAME></CFIF>
					</CFLOOP>
				</SELECT> &nbsp;  
			</cfif>

			<!--- <BR> --->
			&nbsp; 
			<b>Gender:</b>
			<SELECT  name="BGSelected" >
				<OPTION value="">Both </OPTION>
				<OPTION value="B" <CFIF VARIABLES.BGSelected EQ "B">selected</CFIF> >Boys</OPTION>
				<OPTION value="G" <CFIF VARIABLES.BGSelected EQ "G">selected</CFIF> >Girls</OPTION>
			</SELECT> &nbsp; 
			<b>Team Age:</b>
			<SELECT  name="TeamAgeSelected" >
				<OPTION value="">All</OPTION>
				<CFLOOP list="#lTeamAges#" index="ita">
					<OPTION value="#ita#" <CFIF VARIABLES.TeamAgeSelected EQ ita>selected</CFIF>  >#ita#</OPTION>
				</CFLOOP>
			</SELECT> &nbsp; 
			<b>Level:</b>
			<SELECT  name="PlayLevel">
				<OPTION value="" selected>All</OPTION>
				<CFLOOP list="#lPlayLevel#" index="ipl">
					<OPTION value="#ipl#" <CFIF PlayLevel EQ ipl>selected</CFIF> >#ipl#</OPTION>
				</CFLOOP>
			</SELECT> &nbsp; 
			
			<br>
			<b>Play Weekend:</b>
			<select name="weekEndID" >
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
			</select>&nbsp;
			<b>Sort By</b>
			<select name="sortOrder">
				<option value="TEAM" <cfif selectSort EQ "TEAM">selected</cfif> >Team Name</option>
				<option value="FLIT" <cfif selectSort EQ "FLIT">selected</cfif> >Flight</option>
			</select>
			
			&nbsp;  &nbsp; 
			<INPUT type="Submit" name="getTBS" value="Get TBS">
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
			 , T.CLUB_ID, C.CLUBABBR 
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
	</cfquery> <!---  qGetTeams<cfdump var="#qGetTeams#"> --->
</CFIF>


<CFIF isDefined("qGetTeams") AND qGetTeams.RECORDCOUNT GT 0>
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#SEASON" method="getSeasonInfoByID" returnvariable="qSeasonInfo">
		<cfinvokeargument name="seasonID" value="#VARIABLES.seasonID#">
	</cfinvoke> <!--- CURRENT season --->
	<cfset season_sf = qSeasonInfo.season_SF>

	<table cellspacing="0" cellpadding="5" align="left" border="0" width="98%">
		<tr class="tblHeading">
			<td width="08%">Team ID</td>
			<td width="07%">Flight</td>
			<td width="20%">Team Name</td>
			<td width="20%">Club Abbr</td>
			<td width="15%">Day-Date</td>
			<td width="05%">Avlbl.</td>
			<td width="11%">Bef/Aft</td>
			<td width="14%">Time</td>
		</tr>
		<CFSET TotalTeams = 0>
		<cfset recCount = 0>
		<CFLOOP query="qGetTeams">
			<cfinvoke component="#SESSION.SITEVARS.cfcPath#TEAM" method="TeamPlayWeeks" returnvariable="qPlayWKs">
				<cfinvokeargument name="TeamID" value="#TEAM_ID#">
			</cfinvoke> <!--- 1111qPlayWKs <cfdump var="#qPlayWKs#"> --->

			<!--- START - show only YES or NO --->
			<cfset wherePWclause = "">
			<CFIF swShowAvailOnly EQ false>
				<cfif season_sf EQ "FALL">
					<cfIf Trim(Gender) EQ "B" >
						<cfset wherePWclause = " SatAvailable_YN = 'N' ">
	 				<cfelseif yesNoFormat(trim(SunAvailable_YN) EQ "Y")>
						<cfset wherePWclause = " SunAvailable_YN = 'N' ">
					</cfif>
				<cfelse>   <!---  SPRING   --->
					<cfset wherePWclause = " SunAvailable_YN = 'N' ">
				</cfif>
			<CFELSEIF  swShowAvailOnly EQ true>
				<cfif season_sf EQ "FALL">
					<cfIf Trim(Gender) EQ "B" >
						<cfset wherePWclause = " SatAvailable_YN = 'Y' AND SATBeforeAfter <> 'N' " >
					<cfelseif yesNoFormat(trim(SunAvailable_YN) EQ "Y")>
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
				</cfquery> <!--- 22222qPlayWKs <cfdump var="#qPlayWKs#"> --->
			</CFIF>  
			<!--- END - show only YES or NO --->
			
			<CFIF qPlayWKs.RECORDCOUNT>
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,recCount)#">
					<td class="tdUnderLine" >#TEAM_ID#</td>
					<td class="tdUnderLine" >#DIVISION#</td>
					<td class="tdUnderLine" >#teamnamederived#</td>
					<td class="tdUnderLine" >#CLUBABBR#</td>
					<cfloop query="qPlayWKs">
						<CFSET swSkipIt = false>
						<cfif season_sf EQ "FALL">
							<cfif trim(Gender) EQ "B" >
								<cfif SatAvailable_YN EQ "Y" and timeFormat(satTime,"h:mm tt") EQ "9:00 AM" >
									<CFSET swSkipIt = true>
								</cfif>
							<cfelse>
								<cfif SunAvailable_YN EQ "Y" and timeFormat(Suntime,"h:mm tt") EQ "9:00 AM" >
									<CFSET swSkipIt = true>
								</cfif>
							</cfif>
						<cfelse>
							<cfif Trim(SunAvailable_YN) EQ "Y" and timeFormat(Suntime,"h:mm tt") EQ "9:00 AM" >
								<CFSET swSkipIt = true>
							</cfif>
						</cfif>
						<cfif NOT swSkipIt>
							<cfset recCount = recCount + 1 >
								<td class="tdUnderLine" ><!--- #Week# --->
									<cfif season_sf EQ "FALL">
										<cfIf Trim(Gender) EQ "B">
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
										<cfIf Trim(Gender) EQ "B">
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
										<cfIf Trim(Gender) EQ "B" >
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
										<cfIf Trim(Gender) EQ "B" >
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
							<!--- this sets up the next row, where team/name/clubabbr are supressed --->
							</tr>
							<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,recCount)#">
								<td class="tdUnderLine" colspan="4">&nbsp;</td>
						</cfif>
					</cfloop>
					<td class="tdUnderLine" colspan="4" >&nbsp;</td> 
				</tr>
				<!--- </tr>  --->
				<CFSET TotalTeams = TotalTeams + 1 >
			</CFIF> <!--- END - IF qPlayWKs.RECORDCOUNT --->
		</CFLOOP>
		<TR><td >&nbsp;</td>
			<td >&nbsp;</td>
			<td align=right>		  <B>Total teams</B></td>
			<td align=center>		  <B>#TotalTeams#</B></td>
			<td colspan=2 align=right><B>Total TBS</B></td>
			<td align=center>		  <B>#reccount#</B></td>
		</TR>
	</table>
<cfelseIF isDefined("qGetTeams") AND qGetTeams.RECORDCOUNT EQ 0>
	<span class="red"> <b>No teams found based on choices.</b>	</span>
</CFIF>





	
</cfoutput>
</div>
<cfinclude template="_footer.cfm">
