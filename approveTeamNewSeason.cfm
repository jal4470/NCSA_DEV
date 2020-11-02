<!--- 
	FileName:	approveTeamNewSeason.cfm
	Created on: 09/09/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
	  01/05/2009 - AArnone	- Added "no assistant coach" if no asst coach was found.
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<cfsavecontent variable="localCss">
	<style>
		.address{font-size:.8em;padding-bottom:2px;}
	</style>
</cfsavecontent>
<cfhtmlhead text="#localCss#">

<cfoutput>
<div id="contentText">


<CFSET errMsg = "">

<CFIF isDefined("FORM.GOBACK")>
	<cflocation url="ApproveClubNewSeason.cfm?a=t">
</CFIF>

<CFIF isDefined("FORM.REVIEW") OR isDefined("FORM.TBS") OR isDefined("FORM.DELETE")>
	<CFIF isDefined("FORM.TEAMID")>
		<CFIF isDefined("FORM.REVIEW")>
			<CFLOCATION url="approveReviewTeam.cfm?cid=#FORM.clubID#&tid=#FORM.TeamID#">
		</CFIF>
		<CFIF isDefined("FORM.TBS")>
			<CFLOCATION url="approveTeamTBS.cfm?cid=#FORM.clubID#&tid=#FORM.TeamID#">
		</CFIF>
		<CFIF isDefined("FORM.DELETE")>
			<!--- DELETE team from tbl_team --->
			<cfinvoke component="#SESSION.SITEVARS.cfcPath#team" method="deleteTeam">
				<cfinvokeargument name="teamID"   value="#TeamId#">
				<cfinvokeargument name="seasonID" value="#SESSION.REGSEASON.ID#">
			</cfinvoke>
		</CFIF>
	<CFELSE>		
		<CFSET errMsg = "Please select a team to proceed.">
	</CFIF>
</CFIF>








<CFIF isDefined("URL.cid") and isNumeric(URL.cid)>
	<CFSET clubID = URL.cid>
<CFELSEIF isDefined("FORM.clubID") and isNumeric(FORM.clubID)>
	<CFSET clubID = FORM.clubID>
<CFELSE>
	<CFSET clubID = "">
</CFIF>


<cfinvoke component="#SESSION.sitevars.cfcPath#registration" method="getRegisteredTeams" returnvariable="RegisteredTeams">
	<cfinvokeargument name="ClubId" value="#VARIABLES.clubId#">
</cfinvoke>  


<CFIF isDefined("SESSION.REGSEASON")>
	<CFSET displaySeason = SESSION.REGSEASON.SF & " " & SESSION.REGSEASON.YEAR>
<CFELSE>
	<CFSET displaySeason = SESSION.CURRENTSEASON.SF & " " & SESSION.CURRENTSEASON.YEAR>
</CFIF>



<H1 class="pageheading">NCSA - Team Registration Application for #displaySeason#</H1>
<br>
<h2>Sorted By TEAM for club: #RegisteredTeams.CLUB_NAME#</h2>

<CFIF LEN(TRIM(errMsg))>
	<span class="red">
		<b >#errMsg#</b>
	</span>
</CFIF>

<FORM name="Coaches" action="ApproveTeamNewSeason.cfm" method="post">
<!--- <input type="hidden" name="Mode"	value="#Mode%>"> --->
<input type="hidden" name="ClubID"	value="#ClubID#">
<!--- <input type="hidden" name="SortOrder" value="#SortOrder#"> --->
<table cellspacing="0" cellpadding="2" align="left" border="0" width="98%">
	<tr class="tblHeading">
		<td width="02%"> ID 	</td>
		<td width="08%"> Team	</td>
		<td width="05%"> Div	</td>
		<td width="15%"> Coach	</td>
		<td width="20%"> Street </td>
		<td width="20%"> Town, State/Zip </td>
		<td width="10%"> Phone </td>
		<td width="20%"> EMail </td>
	</tr>
	<CFLOOP query="RegisteredTeams">
		<CFIF len(trim(COMMENTS))>
			<CFSET swUnderLine = "">
		<CFELSE>
			<CFSET swUnderLine = "class=""address""">
		</CFIF>
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
			<TD #swUnderLine#>#TEAM_ID#</TD>
			<TD #swUnderLine#>#Gender#-#TeamAge#-#PlayLevel#</TD>
			<TD #swUnderLine#>#Division#</TD>
			<TD #swUnderLine#  title="Head Coach">#CoachLastName#, #CoachFirstName#</TD>
			<TD #swUnderLine#>#CoachAddress#</TD>
			<TD #swUnderLine#>#CoachTown#, #CoachState#-#CoachZip#</TD>
			<TD #swUnderLine#><!--- #CoachWorkPhone# --->
				<CFIF LEN(TRIM(coachCellPhone))>
					(c) #coachCellPhone#
				<CFELSEIF LEN(TRIM(coachHomePhone))>
					(h) #coachHomePhone#
				<CFELSEIF LEN(TRIM(coachWorkPhone))>
					(w) #coachWorkPhone#
				<cfelse>
					n/a
				</CFIF>
			</TD>
			<TD #swUnderLine#>#CoachEmail#</TD>
		</tr>

		<CFIF len(trim(COMMENTS))>
			<CFSET swUnderLine = "">
		<CFELSE>
			<CFSET swUnderLine = "class=""tdUnderLine address""">
		</CFIF>

		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
			<td #swUnderLine#><INPUT type=radio value="#TEAM_ID#" name="TeamId"></td>
			<td #swUnderLine#><cfif approved_yn EQ "Y"> <span class="red">Approved</span> <CFELSE> &nbsp; </CFIF>	</td>
			<td #swUnderLine#> &nbsp; </td>
			
			<CFIF len(trim(AsstCoachLastName))>
				<td #swUnderLine# title="Assistant Coach">#AsstCoachLastName#, #AsstCoachFirstName# &nbsp;</td>
				<td #swUnderLine#>#AsstAddress#		&nbsp;</td>
				<td #swUnderLine#>#AsstTown#, #AsstState#-#AsstZIP#		&nbsp;</td>
				<td #swUnderLine#> <!--- #AsstWorkPhone#	 --->
					<CFIF LEN(TRIM(asstCellPhone))>
						(c) #asstCellPhone#
					<CFELSEIF LEN(TRIM(asstHomePhone))>
						(h) #asstHomePhone#
					<CFELSEIF LEN(TRIM(asstWorkPhone))>
						(w) #asstWorkPhone#
					<cfelse>
						n/a
					</CFIF>
					&nbsp;
				</td>
				<td #swUnderLine#>#AsstEMail# 		&nbsp;</td>
			<CFELSE>
				<td #swUnderLine# colspan="5">No assistant coach. </td>
			</CFIF>
		</tr>
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
			<td #swUnderLine#> &nbsp; </td>
			<td #swUnderLine#> &nbsp; </td>
			<td #swUnderLine#> &nbsp; </td>
			
			<CFIF len(trim(Asst2CoachLastName))>
				<td #swUnderLine#  title="2nd Assistant Coach">#Asst2CoachLastName#, #Asst2CoachFirstName# &nbsp;</td>
				<td #swUnderLine#>#Asst2Address#		&nbsp;</td>
				<td #swUnderLine#>#Asst2Town#, #Asst2State#-#Asst2ZIP#		&nbsp;</td>
				<td #swUnderLine#> <!--- #Asst2WorkPhone#	 --->
					<CFIF LEN(TRIM(asst2CellPhone))>
						(c) #asst2CellPhone#
					<CFELSEIF LEN(TRIM(asst2HomePhone))>
						(h) #asst2HomePhone#
					<CFELSEIF LEN(TRIM(asst2WorkPhone))>
						(w) #asst2WorkPhone#
					<cfelse>
						n/a
					</CFIF>
					&nbsp;
				</td>
				<td #swUnderLine#>#Asst2EMail# 		&nbsp;</td>
			<CFELSE>
				<td #swUnderLine# colspan="5">No 2nd assistant coach. </td>
			</CFIF>
		</tr>
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
			<td #swUnderLine#> &nbsp; </td>
			<td #swUnderLine#> &nbsp; </td>
			<td #swUnderLine#> &nbsp; </td>
			
			<CFIF len(trim(Asst3CoachLastName))>
				<td #swUnderLine#   title="3rd Assistant Coach">#Asst3CoachLastName#, #Asst3CoachFirstName# &nbsp;</td>
				<td #swUnderLine#>#Asst3Address#		&nbsp;</td>
				<td #swUnderLine#>#Asst3Town#, #Asst3State#-#Asst3ZIP#		&nbsp;</td>
				<td #swUnderLine#> <!--- #Asst3WorkPhone#	 --->
					<CFIF LEN(TRIM(asst3CellPhone))>
						(c) #asst3CellPhone#
					<CFELSEIF LEN(TRIM(asst3HomePhone))>
						(h) #asst3HomePhone#
					<CFELSEIF LEN(TRIM(asst3WorkPhone))>
						(w) #asst3WorkPhone#
					<cfelse>
						n/a
					</CFIF>
					&nbsp;
				</td>
				<td #swUnderLine#>#Asst3EMail# 		&nbsp;</td>
			<CFELSE>
				<td #swUnderLine# colspan="5">No 3rd assistant coach. </td>
			</CFIF>
		</tr>
		<CFIF len(trim(COMMENTS))>
			<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
				<td class="tdUnderLine"> &nbsp; </td>
				<td class="tdUnderLine" colspan="7"> Comments: #Comments#	</td>
			</tr>
		</CFIF>
	</CFLOOP>

    <tr><td colspan="8" align="center">
			<br>  
			<!--- <cfif Trim(ReadOnly) EQ ""> --->
				<INPUT type="Submit" name="Review" value="Review">
				<INPUT type="Submit" name="Delete" value="Delete">
				<INPUT type="Submit" name="TBS"	   value="TBS/Schedule">
			<!--- </cfif> --->
				<INPUT type="Submit" name="goback" value="<< Back">
		</td>
	</tr>
</table>



</table>	
</FORM>
	
	
	
	
	

</cfoutput>
</div>
<cfinclude template="_footer.cfm">
