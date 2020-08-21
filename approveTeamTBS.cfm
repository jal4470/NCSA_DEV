<!--- 
	FileName:	approveTeamTBS.cfm
	Created on: 09/10/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm"> 

<cfoutput>
<div id="contentText">

<!--- ======================================================================================
TempProcessIt = "N"
gRegSeason = Session("REGseasonSF") --->

<CFIF isDefined("URL.CID")>
	<CFSET ClubID = URL.CID>
<CFELSEIF isDefined("FORM.ClubID")>
	<CFSET ClubID = FORM.ClubID>
<CFELSE>
	<CFSET ClubID = 0>
</CFIF>
<CFIF isDefined("URL.TID")>
	<CFSET TeamID = URL.TID>
<CFELSEIF isDefined("FORM.TeamID")>
	<CFSET TeamID = FORM.TeamID>
<CFELSE>
	<CFSET TeamID = 0>
</CFIF>

<CFIF isDefined("URL.p")>
	<CFSET backpage = URL.p>
<CFELSEIF isDefined("FORM.backpage")>
	<CFSET backpage = FORM.backpage>
<CFELSE>
	<CFSET backpage = "approveTeamNewSeason">
</CFIF>

<!---  ----------  Setup Weekends  -------------- --->
<CFQUERY name="getWeekEnds" datasource="#SESSION.DSN#">
	Select day1_date as Sat, day2_date as Sun, playWeekend_id, WEEK_NUMBER
	  from TBL_PlayWeekend
	 where season_id  = #SESSION.REGSEASON.ID#
	 Order by Week_number
</CFQUERY>
<CFSET WeekendSATstart	= dateformat(getWeekEnds.SAT[1],  "mm/dd")>
<CFSET WeekendSATend	= dateformat(getWeekEnds.SAT[10], "mm/dd")>
<CFSET WeekendSUNstart	= dateformat(getWeekEnds.SUN[1],  "mm/dd")>
<CFSET WeekendSUNend	= dateformat(getWeekEnds.SUN[10], "mm/dd")>

<!--- Get the Team's PlayWeeks --->
<cfinvoke component="#SESSION.SITEVARS.cfcPath#team" method="TeamPlayWeeks" returnvariable="qPlayweek">
	<cfinvokeargument name="TeamID" value="#VARIABLES.TeamID#">
</cfinvoke>

<CFIF isDefined("FORM.BACK")>
	<CFLOCATION url="#VARIABLES.backpage#.cfm?cid=#VARIABLES.clubID#">
</CFIF>

<CFIF isdefined("FORM.REGISTER")>
	<!--- PROCESS FORM and UPDATE --->
	<!--- Note:	Fall   = SUN only 
		        AND Spring = SAT & SUN 
	--->
	<CFIF qPlayweek.RecordCount>
		<CFSET insertNewRec = 0> <!--- team playweeks EXIST, do update --->
	<CFELSE>
		<CFSET insertNewRec = 1> <!--- team playweeks DO NOT exist, do insert --->
	</CFIF>

	<CFLOOP query="getWeekends">
		<!--- SATURDAY --->
		<cfif isdefined("form.playhoursat")>
			<CFSET SAT_time   = listGetAt(FORM.PlayHourSat,week_number)>
			<CFSET SAT_Avail  = listGetAt(FORM.PLAYWEEKSSAT,week_number)>
			<CFSET SAT_BefAft = "">
			<cfloop collection="#FORM#" item="fld">
			 	<CFIF listFirst(fld,"_") EQ "SATBEFORE" AND listLast(fld,"_") EQ week_number>
					<CFSET SAT_BefAft = evaluate(#fld#)>
				</CFIF>
			</cfloop>
			
			<cfset sun_time = "">
			<cfset sun_avail="">
			<cfset sun_befaft="">
		<CFELSE>
			<!--- SUNDAY --->
			<CFSET SUN_time   = listGetAt(FORM.PLAYHOURSUN,week_number)>
			<CFSET SUN_Avail  = listGetAt(FORM.PLAYWEEKSSUN,week_number)>
			<CFSET SUN_BefAft = "">
			<cfloop collection="#FORM#" item="fld">
				<CFIF listFirst(fld,"_") EQ "SUNBEFORE" AND listLast(fld,"_") EQ week_number>
					<CFSET SUN_BefAft = evaluate(#fld#)>
				</CFIF>
			 </cfloop>
			 
			<CFSET SAT_time   = "">
			<CFSET SAT_Avail  = "">
			<CFSET SAT_BefAft = "">
		</cfif>

		 <CFIF insertNewRec>
		 	<!--- INSERT playweeks --->
			<CFINVOKE component="#SESSION.SITEVARS.cfcPath#team" method="insertTeamPlayweek">
				<cfinvokeargument name="teamID"     value="#VARIABLES.teamID#">
				<cfinvokeargument name="playWEid"   value="#playWeekend_id#">
				<cfinvokeargument name="SAT_time"   value="#VARIABLES.SAT_time#">
				<cfinvokeargument name="SAT_Avail"  value="#VARIABLES.SAT_Avail#">
				<cfinvokeargument name="SAT_BefAft" value="#VARIABLES.SAT_BefAft#">
				<cfinvokeargument name="SUN_time"   value="#VARIABLES.SUN_time#">
				<cfinvokeargument name="SUN_Avail"  value="#VARIABLES.SUN_Avail#">
				<cfinvokeargument name="SUN_BefAft" value="#VARIABLES.SUN_BefAft#">
			</CFINVOKE> 
		 <CFELSE>
		 	<!--- UPDATE playweeks --->
			<CFINVOKE component="#SESSION.SITEVARS.cfcPath#team" method="updateTeamPlayweek">
				<cfinvokeargument name="teamID"     value="#VARIABLES.teamID#">
				<cfinvokeargument name="playWEid"   value="#playWeekend_id#">
				<cfinvokeargument name="SAT_time"   value="#VARIABLES.SAT_time#">
				<cfinvokeargument name="SAT_Avail"  value="#VARIABLES.SAT_Avail#">
				<cfinvokeargument name="SAT_BefAft" value="#VARIABLES.SAT_BefAft#">
				<cfinvokeargument name="SUN_time"   value="#VARIABLES.SUN_time#">
				<cfinvokeargument name="SUN_Avail"  value="#VARIABLES.SUN_Avail#">
				<cfinvokeargument name="SUN_BefAft" value="#VARIABLES.SUN_BefAft#">
			</CFINVOKE> 
		 </CFIF>
	</CFLOOP>
	<CFLOCATION url="#backpage#.cfm?cid=#VARIABLES.clubID#">
</CFIF> <!--- END process FORM --->




<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="PlayHours">
	<cfinvokeargument name="listType" value="PLAYHOURS"> 
</cfinvoke> 

<cfinvoke component="#SESSION.SITEVARS.cfcPath#registration" method="getRegisteredTeams" returnvariable="qTeam">
	<cfinvokeargument name="clubID" value="#VARIABLES.clubID#">
	<cfinvokeargument name="TeamID" value="#VARIABLES.TeamID#">
</cfinvoke>
<cfset clubname		= qTeam.CLUB_NAME>
<cfset TeamAge		= qTeam.TeamAge>
<cfset PlayLevel	= qTeam.PlayLevel>
<cfset Division		= qTeam.Division>
<cfset Gender		= qTeam.Gender>
<cfset Coach		= qTeam.CoachFirstName>
<cfset CoachLastName = qTeam.CoachLastName>


<cfif isDefined("RegSubmit") AND RegSubmit EQ "Y"><!--- ???? where???? --->
	<cfset DisabledField	= "Disabled">
	<cfset InfoUpdated		= "Y">
<cfelse>    <cfset RegSubmit = "N"> <!--- ?????  --->
	<cfset DisabledField	= "">
	<cfset InfoUpdated		= "">	
</cfif>

<!--- setting up the default value ???????
<cfif NOT len(trim(NonSundayPlay))>
	<cfset NonSundayPlay = "N">
</cfif>--->

<CFIF isDefined("SESSION.REGSEASON")>
	<CFSET displaySeason = SESSION.REGSEASON.SF & " " & SESSION.REGSEASON.YEAR>
<CFELSE>
	<CFSET displaySeason = SESSION.CURRENTSEASON.SF & " " & SESSION.CURRENTSEASON.YEAR>
</CFIF>

<H1 class="pageheading">NCSA - Team PlayWeekend Availabilty for #displaySeason#</H1>
<br>
<h2>Club: #clubName# #repeatstring("&nbsp;",4)#  : #CoachLastName#, #Coach# - #Gender##trim(right(TeamAge, 2))##trim(PlayLevel)#  </h2>
<CFSET required = "<FONT color=red>*</FONT>">
<FORM name="CoachesMaintain" action="ApproveTeamTBS.cfm"  method="post">
	<input type="hidden" name="TeamID"		value="#TeamID#">
	<input type="hidden" name="ClubId"		value="#ClubId#">
	<input type="hidden" name="RegSubmit"	value="#RegSubmit#">
	<input type="hidden" name="InfoUpdated" value="#InfoUpdated#">
	<input type="hidden" name="backpage"	value="#backpage#">
	<input type="hidden" name="CurrentPage" value=0>
<span class="red">Fields marked with * are required</span>
<table cellspacing="0" cellpadding="5" align="left" border="0" width="75%">
	<!--- <tr class="tblHeading">
		<cfif SESSION.RegSeason.SF EQ "FALL"> <!---  For FALL Registration only ---> 
			<td colspan="2" > Weekend SAT </td>
			<td colspan="1" >&gt;&gt;</td>
			<td colspan="2" > Weekend SUN </td>
			<td colspan="1" >&nbsp;</td>
		<CFELSE>
			<td colspan="6" > Weekend SUN </td>
		</cfif> 
	</tr> --->
	<cfif SESSION.RegSeason.SF EQ "FALL" AND GENDER EQ "B">
		<tr class="tblHeading">
			<td colspan="6">	
				Boys SATURDAY weekend
			</td>
		</tr>
	<cfelse>	
		<tr class="tblHeading">
			<td colspan="6">
				<cfif SESSION.RegSeason.SF EQ "FALL">
					Girls SUNDAY weekend
				<cfelse>
					SUNDAY weekend
				</cfif>
			</td>
		</tr>
	</cfif>

	<tr><td colspan="6">
			Select the Teams Availability over Weeks between 
			<cfif SESSION.RegSeason.SF EQ "FALL" AND GENDER EQ "B">
				<b>#WeekendSatSTART#</b> and <b>#WeekendSatEND#</b>
			<cfelse>
				<b>#WeekendSUNstart#</b> and <b>#WeekendSUNend# </b>
			</cfif>
			<BR><SPAN class="red">Select No for TBS</SPAN>
		</td>
	</tr>

	<tr class="tblHeading">
		<td width="5%">&nbsp;</td>
		<TD width="10%" align="center">Week</td>
		<TD width="15%">
			<cfif SESSION.RegSeason.SF EQ "FALL" AND GENDER EQ "B">
				Saturday/TBS
			<cfelse>	
				Sunday/TBS
			</cfif>
			
		</td>
		<td width="35%" align="center">Before/After</td>
		<td width="30%">Time</td>
		<td width="5%">&nbsp;</td>
	</TR>

	<cfif SESSION.RegSeason.SF EQ "FALL" AND GENDER EQ "B">
		<!--- === Play Weeks SATurday === --->
		<CFLOOP query="getWeekEnds">
			<CFSET WeekNo = Week_number>
			<cfquery name="TeamWeek" dbtype="query">
				SELECT Week_number,
					   SatAvailable_YN,
					   satTime,			
				   SatBeforeAfter 	
					  from qPlayweek
				 Where Week_number = #VARIABLES.WeekNo#
			</cfquery>
			<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,VARIABLES.WeekNo)#">
				<td class="tdUnderLine">&nbsp;</td>
				<TD class="tdUnderLine" align="Center"><b>#required##dateFormat(SAT,"mm/dd/yyyy")#</b></TD>
				<TD class="tdUnderLine" align="center">
					<SELECT name="PlayWeeksSAT"> 
						<OPTION value="Y" <cfif TeamWeek.SatAvailable_YN EQ "Y">selected</cfif> >Yes</OPTION>
						<OPTION value="N" <cfif TeamWeek.SatAvailable_YN EQ "N">selected</cfif> > No </OPTION>
					</SELECT>
				</td>
				<td class="tdUnderLine">
					<!--- If the BeforeAfter is After and Time is 9:00Am then display is ANYTIME --->
					<cfif RegSubmit EQ "Y" and TempProcessIt EQ "Y">
						<cfif TeamWeek.SatBeforeAfter EQ "B">
							<input type=Hidden name="SATBefore_After_#VARIABLES.WeekNo#" value="B"> Before
						<cfelse>
							<cfif TeamWeek.SatTime EQ listGetAt(PlayHours,1)>
								<input type=Hidden name="SATBefore_After_#VARIABLES.WeekNo#" value="A"> AnyTime
							<cfelse>
								<input type=Hidden name="SATBefore_After_#VARIABLES.WeekNo#" value="A"> After
							</cfif>
						</cfif>
					<cfelse>
						<cfset SatBefore  = "">
						<cfset SatAfter	  = "">
						<cfset SatAnyTime = "">
						<cfswitch expression="#TeamWeek.SatBeforeAfter#">
							<cfcase value="B"> <cfset SatBefore = "checked">  </cfcase>
							<cfcase value="A"> <cfset SatAfter = "checked">   </cfcase>
							<cfdefaultcase>    <cfset SatAnyTime = "checked"> </cfdefaultcase>
						</cfswitch>
						<input type="Radio" maxlength="1" name="SATBefore_After_#VARIABLES.WeekNo#" value="N" #SATAnyTime#> <font size=1>AnyTime</font>
						<input type="Radio" maxlength="1" name="SATBefore_After_#VARIABLES.WeekNo#" value="B" #SATBefore#>  <font size=1>Before</font>
						<input type="Radio" maxlength="1" name="SATBefore_After_#VARIABLES.WeekNo#" value="A" #SATAfter#>   <font size=1>After</font>
					</cfif>
				</td>
				<td class="tdUnderLine">
					<cfif (RegSubmit EQ "Y") and (TempProcessIt EQ "Y") and (TeamWeek.SatTime EQ listGetAt(PlayHours,1) )>
						&nbsp;
					<cfelse>
						<SELECT name="PlayHourSAT">
							<CFLOOP list="#PlayHours#" index="iH">
								<cfif trim(timeFormat(TeamWeek.SatTime,"h:mm:ss tt")) EQ trim(iH)> 
									<cfset selected = "selected"> 
								<cfelse> 
									<cfset selected = ""> 
								</cfif>
								<OPTION value="#trim(iH)#" #selected# >#iH#</OPTION>
							</CFLOOP>
						</SELECT>
					</cfif>
				</td>
				<td class="tdUnderLine">&nbsp;</td>
			</tr>
		</CFLOOP>
	<CFELSE>
		<!--- === Play Weeks SUNDAY === --->
		<CFLOOP query="getWeekEnds">
			<CFSET WeekNo = Week_number>
			<cfquery name="TeamWeek" dbtype="query">
				SELECT Week_number,
					   SunAvailable_YN,
					   SunTime,
					   SunBeforeAfter
				  from qPlayweek
				 Where Week_number = #Week_number#
			</cfquery>
			<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,VARIABLES.WeekNo)#">
				<td class="tdUnderLine">&nbsp;</td>
				<TD class="tdUnderLine" align="Center"><b>#required##dateFormat(SUN,"mm/dd/yyyy")#</b>
					<input type="Hidden" name="WeekendID_#VARIABLES.WeekNo#" value="#playWeekend_id#"><!--- ??? --->
				</TD>
				<td class="tdUnderLine" align="center">
					<SELECT name="PlayWeeksSUN"> 
						<OPTION value="Y" <cfif TeamWeek.SunAvailable_YN EQ "Y">selected</cfif> > Yes </OPTION>
						<OPTION value="N" <cfif TeamWeek.SunAvailable_YN EQ "N">selected</cfif> > No </OPTION>
					</SELECT>
				</TD>
				<td class="tdUnderLine">
				<!---  If the BeforeAfter is After and Time is 9:00Am then display is ANYTIME	 --->
					<cfif RegSubmit EQ "Y" and TempProcessIt EQ "Y">
						<cfif TeamWeek.SunBeforeAfter EQ "B">
							<input type=Hidden name="SUNBefore_After_#VARIABLES.WeekNo#" value="B"> Before
						<cfelse>
							<cfif TeamWeek.SunTime EQ listGetAt(PlayHours,1)>
								<input type=Hidden name="SUNBefore_After_#VARIABLES.WeekNo#" value="A"> AnyTime
							<cfelse>
								<input type=Hidden name="SUNBefore_After_#VARIABLES.WeekNo#" value="A"> After
							</cfif>
						</cfif>
					<cfelse>
						<cfset SunBefore  = "">
						<cfset SunAfter	  = "">
						<cfset SunAnyTime = "">
						<CFSWITCH expression="#TeamWeek.SunBeforeAfter#">
							<cfcase value="B"> <cfset SunBefore = "checked">  </cfcase>
							<cfcase value="A"> <cfset SunAfter = "checked">	  </cfcase>
							<cfdefaultcase>    <cfset SunAnyTime = "checked"> </cfdefaultcase>
						</CFSWITCH> 
						<input type="Radio"  maxlength="1" name="SUNBefore_After_#VARIABLES.WeekNo#" value="N" #SunAnyTime# > <font size=1>AnyTime</font>
						<input type="Radio"  maxlength="1" name="SUNBefore_After_#VARIABLES.WeekNo#" value="B" #SunBefore# >  <font size=1>Before</font>
						<input type="Radio"  maxlength="1" name="SUNBefore_After_#VARIABLES.WeekNo#" value="A" #SunAfter# >   <font size=1>After</font>
					</cfif>
				</td>
				<td class="tdUnderLine">
					<cfif RegSubmit EQ "Y" and TempProcessIt EQ "Y" and TeamWeek.SunTime EQ listGetAt(PlayHours,1)>
						&nbsp;
					<cfelse>
						<SELECT name="PlayHourSUN">
							<cfloop list="#PlayHours#" index="iH">
								<cfif trim(timeFormat(TeamWeek.SunTime,"h:mm:ss tt")) EQ trim(iH)> 
									<cfset selected = "selected"> 
								<cfelse> 
									<cfset selected = ""> 
								</cfif>
								<OPTION value="#trim(iH)#" #selected# >#iH#</OPTION>
							</cfloop>
						</SELECT>
					</cfif>
				</td>
				<td class="tdUnderLine">&nbsp;</td>
			</tr>
		</CFLOOP>
	</cfif> <!--- END -if SESSION.RegSeason.SF EQ "FALL" --->

	<tr><td colspan="6">&nbsp;</td>
	</tr>
	<TR align="middle">
		<TD colspan="6" align="center">
			<INPUT type="submit" value="Save" name="Register">
			<INPUT type="submit" value="Back"     name="Back" >
		</TD>
	</TR>
</TABLE>

 
</FORM>


</cfoutput>
</div>
<cfinclude template="_footer.cfm">
