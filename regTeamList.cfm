<!--- 
	FileName:	regTeamList.cfm
	Created on: 09/17/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
12/09/08 - aa - removed "swShowOldTeams" from around TBS button
12/17/08 - aa - got rid of gap in IE because second table was center instead of left
01/09/09 - aa - "grayed" out (disable) button logic added
01/27/09 - aa - Removed TBS button, it is now a seperate template regTeamTBS.cfm
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<div id="contentText">
<cfoutput>


<CFIF isDefined("URL.cid") AND isNumeric(URL.CID)>
	<CFSET ClubID = URL.cid>
<CFELSEIF isDefined("FORM.clubID")>
	<CFSET ClubID = FORM.clubID>
<CFELSE>
	<CFSET ClubID = Session.USER.ClubID>
</CFIF>


<CFSET message = "">
<CFSET swShowOldTeams = true>

<!--- <CFIF isDefined("URL.TBS")>
	<CFSET swShowOldTeams = false>
<CFELSE>
	<CFSET swShowOldTeams = true>
</CFIF> --->


<CFIF isDefined("SESSION.REGSEASON")>
	<CFSET displaySeason = SESSION.REGSEASON.SF & " " & SESSION.REGSEASON.YEAR>
	<CFSET SF = SESSION.REGSEASON.SF>
	<CFSET seasonID = SESSION.REGSEASON.ID>
<CFELSE>
	<CFSET displaySeason = SESSION.CURRENTSEASON.SF & " " & SESSION.CURRENTSEASON.YEAR>
	<CFSET SF = SESSION.CURRENTSEASON.SF>
	<CFSET seasonID = SESSION.CURRENTSEASON.ID>
</CFIF>


<CFIF isDefined("FORM.Add")>
	<CFLOCATION url="teamCreate.cfm?cid=#ClubID#"> <!--- "blank" form --->
	 <!--- <BR> DO ADD TEAM<BR>     --- teamCreate.cfm Reg/Reg_Coaches_Maintain.asp --->
</CFIF>

<CFIF isDefined("FORM.Edit")>
	<CFIF isDefined("FORM.TEAMID") AND isNumeric(FORM.TEAMID) >
		<CFLOCATION url="teamEdit.cfm?cid=#ClubID#&tid=#FORM.TEAMID#&reg=1"> <!--- "Edit" form --->
	<CFELSE>
		<CFSET message = message & "<b>Please select a team before clicking Edit.</b>">
	</CFIF>
</CFIF>

<CFIF isDefined("FORM.Register")>
	<CFIF isDefined("FORM.TEAMID") AND isNumeric(FORM.TEAMID) >
		<CFLOCATION url="teamCreate.cfm?cid=#ClubID#&tid=#FORM.TEAMID#"> <!--- "pre-populated" form --->
	<CFELSE>
		<CFSET message = message & "<b>Please select a team before clicking Register.</b>">
	</CFIF>
</CFIF>

<!--- <CFIF isDefined("FORM.TBS")>
	<CFIF isDefined("FORM.TEAMID") AND isNumeric(FORM.TEAMID) >
		<CFQUERY name="checkTeam" datasource="#SESSION.DSN#">
			SELECT TEAM_ID
			  FROM TBL_TEAM
			  WHERE TEAM_ID	   = #FORM.TEAMID#
			    AND season_id  = #VARIABLES.seasonID#
		</CFQUERY> <!--- 	<cfdump var="#checkTeam#"> --->
		
		<CFIF checkTeam.RECORDCOUNT>
			<CFSET message = message & "<b>FOUND TEAM goto TBS.</b>">
			<CFLOCATION url="approveTeamTBS.cfm?cid=#ClubID#&tid=#FORM.TEAMID#&p=regteamlist"> 
		<CFELSE>
			<CFSET message = message & "<b>DID NOT FIND TEAM - NO TBS.</b>">
		</CFIF>
	<CFELSE>
		<CFSET message = message & "<b>Please select a team before clicking TBS.</b>">
	</CFIF>
</CFIF> --->

<CFIF isDefined("FORM.DELETE")>
		<CFQUERY name="checkTeam" datasource="#SESSION.DSN#">
			SELECT TEAM_ID
			  FROM TBL_TEAM
			  WHERE TEAM_ID	   = #FORM.TEAMID#
			    AND season_id  = #VARIABLES.seasonID#
		</CFQUERY> <!--- 	<cfdump var="#checkTeam#"> --->
		
		<CFIF checkTeam.RECORDCOUNT>
			<CFLOCATION url="teamCreate.cfm?cid=#ClubID#&tid=#FORM.TEAMID#&p=regteamlist&a=del"> 
		<CFELSE>
			<CFSET message = "<b>Please select a currently registered team to delete.</b>">
		</CFIF>
</CFIF>

<CFIF isDefined("FORM.Next")>
	<CFLOCATION url="teamSummary.cfm?cid=#ClubID#&p=regteamlist&a=del">
</CFIF>

<!--- CHECK FOR REGISTERED CLUBS BEFROE ALLOWING TEAM ADMINSITRATION --->

<cfinvoke component="#SESSION.SITEVARS.cfcPath#registration" method="getRegisteredClubs" returnvariable="qGetRegisteredClubs">
	<cfinvokeargument name="clubID" value="#ClubID#">
</cfinvoke> <!--- <cfdump var="#qGetRegisteredClubs#"> --->

<H1 class="pageheading">NCSA - Teams Registration List</H1>
<h2>for the #displaySeason# Season</h2>

<!--- 
<CFSET SortOrder = "" ><!--- Request("SortOrder") --->
<CFIF LEN(Trim(SortOrder)) LT 1>
	<CFSET SortOrder = "TEAM">
</CFIF>
<CFSWITCH expression="#SortOrder#">
	<CFCASE value="TEAM">		<CFSET OrderBy = " Order by Gender, TeamAge, PlayLevel, PlayGroup">
	</CFCASE>
	<CFCASE value="DIV">		<CFSET OrderBy = " Order by Division">
	</CFCASE>
	<CFCASE value="COACH">		<CFSET OrderBy = " Order by Coach">
	</CFCASE>
	<CFDEFAULTCASE>		<CFSET OrderBy = " Order by Gender, TeamAge, PlayLevel, PlayGroup">
	</CFDEFAULTCASE>
</CFSWITCH> 
--->

<!--- <CFIF isDEFINED("URL.mcd")>
	<CFSWITCH expression="#URL.mcd#">
		<CFCASE value="010">	<CFSET message = message & " <br><br> The team being registered already exists. <br><br>">
		</CFCASE>			
	</CFSWITCH>
</CFIF> --->

<cfif qGetRegisteredClubs.RecordCount EQ 0>

	<div class="red" style="font-size: 12px; margin-top: 10px;">You must first submit club registration for new season before submitting team registration.</div>

<cfelse>

	<cfinvoke component="#SESSION.SITEVARS.cfcPath#team" method="getClubTeams" returnvariable="qClubTeams">
		<cfinvokeargument name="clubID" value="#ClubID#">
	</cfinvoke> <!--- <cfdump var="#qClubTeams#"> --->
			 
	
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#registration" method="getRegisteredTeams" returnvariable="qRegTeams">
		<cfinvokeargument name="clubID" value="#ClubID#">
	</cfinvoke> <!--- <cfdump var="#qRegTeams#"> --->
	 
	
	<FORM name="Teams" action="regTeamList.cfm" method="post">
	<!--- <input type="hidden" name="Mode"		value="#Mode#"> --->
	<input type="hidden" name="ClubInfoID"	value="#ClubID#">
	<input type="hidden" name="ClubID"		value="#ClubID#">
	<!--- <input type="hidden" name="SortOrder" value="#SortOrder#"> --->
	
	<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
		<cfif len(Trim(message))>
			<TR><TD colspan="8" align="Center" class="red">	#message# </td>	</TR>
		</cfif>
		<!--- ================================================================ --->
		<!--- === Teams already registered =================================== --->
		<!--- ================================================================ --->
		<tr class="tblHeading">
			<cfquery name="ctReg" dbtype="query"> 
				select count(*) as total from qRegTeams
			</cfquery> 
			<TD colspan="8">Registered Teams [#ctReg.total#]</TD>
		</tr>
		<tr class="tblHeading">
			<td width="02%">&nbsp;</td>
			<td width="08%"><strong>Team	</strong></td>
			<td width="10%"><strong>Div		</strong></td>
			<td width="20%"><strong>Coach	</strong></td>
			<td width="20%"><strong>EMail/Phone	</strong></td>
			<td width="20%"><strong>AsstCoach	</strong></td>
			<td width="20%"><strong>EMail/Phone	</strong></td>
		</tr>
	</table>
	
	<div style="overflow:auto;height:200px;border:1px ##cccccc solid;">
	<table cellspacing="0" cellpadding="2" align="left" border="0" width="98%">
		<CFLOOP query="qRegTeams">
			<cfif Len(trim(COMMENTS))>
				<CFSET useClass = "">
			<cfelse>
				<CFSET useClass = "class='tdUnderLine'">
			</cfif>
			<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">  
					<TD width="02%" #useClass#> <INPUT type=radio value="#TEAM_ID#" name="TEAMID">			</TD>
					<td width="08%" #useClass#>	#Gender#-#TeamAge#-#PlayLevel#
									<CFIF REGISTERED_YN EQ "Y">
										<br><span class="red">Registered</span>
									</CFIF>
					</td>
					<td width="10%" #useClass#> #Division#</td>
					<td width="20%" #useClass# valign="top"> #CoachLastName#, #COACHFIRSTNAME# </td>
					<td width="20%" #useClass# valign="top"> #COACHEMAIL#	  <br>#COACHHOMEPHONE#	</td>
					<td width="20%" #useClass# valign="top"> #AsstCoachLastName#, #ASSTCOACHFIRSTNAME#</td>
					<td width="20%" #useClass# valign="top"> #AsstEMail#	  <br>#AsstHomePhone#		</td>
			</TR>
			<cfif Len(trim(COMMENTS))>
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> 
					<td class="tdUnderLine" colspan="3">&nbsp;</td>
					<TD class="tdUnderLine" colspan="7">
						Comments: #Comments#
					</td>
				</tr>
			</cfif>
		</CFLOOP>
		</table>
		</div>	
	
	
		<CFIF swShowOldTeams>
		<!--- <tr> 
			<td class="tdUnderLine" colspan="8">
				<hr size="2">
			</td>
		</tr> --->
		<!--- ======================================================================= --->
		<!--- === Teams from the last season ======================================== --->
		<!--- ======================================================================= --->
		<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
		<tr class="tblHeading">
			<cfquery name="ctLast" dbtype="query">
				select count(*) as total from qClubTeams
			</cfquery> 
			<TD colspan="8">Last Season's Teams [#ctLast.total#]</TD>
		</tr>
		<tr class="tblHeading">
			<td width="02%">&nbsp;</td>
			<td width="08%"><strong>Team	</strong></td>
			<td width="10%"><strong>Div		</strong></td>
			<td width="20%"><strong>Coach	</strong></td>
			<td width="20%"><strong>EMail/Phone	</strong></td>
			<td width="20%"><strong>AsstCoach	</strong></td>
			<td width="20%"><strong>EMail/Phone	</strong></td>
		</tr>
		</table>
		
		<div style="overflow:auto;height:200px;border:1px ##cccccc solid;">
		<table cellspacing="0" cellpadding="2" align="center" border="0" width="98%">
		<CFLOOP query="qClubTeams">
			<cfif Len(trim(COMMENTS))>
				<CFSET useClass = "">
			<cfelse>
				<CFSET useClass = "class='tdUnderLine'">
			</cfif>
			<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">  
					<TD width="02%" #useClass#> <INPUT type=radio value="#TEAM_ID#" name="TEAMID"></TD>
					<td width="08%" #useClass#>	#Gender#-#TeamAge#-#PlayLevel#
									<CFIF REGISTERED_YN EQ "Y">
										<br><span class="red">Registerd</span>
									</CFIF>
					</td>
					<td width="10%" #useClass#> #Division#</td>
					<td width="20%" #useClass#> #CoachLastName#, #COACHFIRSTNAME# </td>
					<td width="20%" #useClass#> #COACHEMAIL#  <br>#COACHHOMEPHONE#	</td>
					<td width="20%" #useClass#> #AsstCoachLastName#, #ASSTCOACHFIRSTNAME#</td>
					<td width="20%" #useClass#> #AsstEMail#	  <br>#AsstHomePhone#		</td>
			</TR>
			<cfif Len(trim(COMMENTS))>
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> 
					<td class="tdUnderLine" colspan="3">&nbsp;</td>
					<TD class="tdUnderLine" colspan="7">
						Comments: #Comments#
					</td>
				</tr>
			</cfif>
		</CFLOOP>
		</table>
		</div>	
		</CFIF>
	
		<table cellspacing="0" cellpadding="2" align="center" border="0" width="98%">
		<tr><td colspan="8" align="center">
				<!--- <CFIF IsDefined("SESSION.GLOBALVARS.TBSOPEN") AND SESSION.GLOBALVARS.TBSOPEN EQ "OPEN">	
					<cfset TBS_disabled = "">
					<!--- <cfset ADD_disabled = "disabled">
					<cfset REG_disabled = "disabled"> --->
				<CFELSE>
					<cfset TBS_disabled = "disabled">
					<!--- <cfset ADD_disabled = "">
					<cfset REG_disabled = ""> --->
				</CFIF> --->
				<cfset ADD_disabled = "">
				<cfset REG_disabled = "">
				<INPUT type="submit" name="Edit"     value="Edit"      >
				<INPUT type="submit" name="Add"      value="Add"      #VARIABLES.ADD_disabled# >
				<INPUT type="submit" name="Register" value="Register" #VARIABLES.REG_disabled# >
				<!--- <INPUT type="submit" name="TBS" 	 value="TBS"	  #VARIABLES.TBS_disabled# > --->
				
				<!--- NOT for CLUBS  <INPUT  type="submit"  name="Delete" value="Delete"   > --->
				<INPUT  type="submit"  name="Next"   value="Next"     >
	
				<!--- <CFIF IsDefined("SESSION.GLOBALVARS.TBSOPEN") AND SESSION.GLOBALVARS.TBSOPEN EQ "OPEN">	
						<INPUT  type="submit"  name="TBS"    value="TBS"      >
				</CFIF> --->
	
	
			</td>
		</tr>
	</table>
	
	</FORM>


</cfif>
 
</cfoutput>
</div>
<cfinclude template="_footer.cfm">

