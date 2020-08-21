<!--- 
	FileName:	teamAppealApproveView.cfm
	Created on: 07/12/2016
	Created by: rgonzalez@capturepoint.com
	
	Purpose: List the information for a single team from teamAppealListApprove
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm"> 

<div id="contentText">

<cfset msg = "">

<CFIF isDefined("URL.tid")>
	<CFSET teamID = URL.tid >
<CFELSE>
	<CFSET teamID = 0 >
</CFIF>

<!--- Get teams for selected club ---> 
<cfset ctTeams = 0>
<CFIF teamID GT 0>
	<!--- Get single team information --->
	<!--- <cfinvoke component="#SESSION.SITEVARS.cfcPath#registration" method="getRegisteredTeams" returnvariable="qTeams">
		<!--- <cfinvokeargument name="clubID" value="#VARIABLES.clubID#"> --->
		<cfinvokeargument name="TeamID" value="#teamID#">
		<!--- <cfinvokeargument name="approvedYN" value="Y"> --->
	</cfinvoke> <!--- 1<cfdump var="#qTeams#"> --->
	--->

	<CFQUERY name="qTeams" datasource="#session.DSN#">
		SELECT  CL.ClubAbbr, CL.club_id, CL.Club_name,
			   IsNull(T.Gender,'') + right(T.TeamAge,2) + IsNull(T.PlayLevel,'') + IsNull(T.PlayGroup,'') AS DIVISION, 
			   T.team_id, T.ContactIDHead, T.ContactIDAsst, T.club_id, T.teamName, 
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
			   AC.phoneCell AS asstCellPhone,		AC.phoneFax AS asstFax, AC.email AS asstEmail,
			   T.roster as roster,
			   T.prevPlayLevel as prevPlayLevel,
			   T.reasonForPlayLevel as reasonForPlayLevel,
			   T.teamFormed as teamFormed,
			   T.teamAvailability as teamAvailability,
			   T.soccerID as soccerID
			
		FROM    tbl_team T  LEFT JOIN tbl_contact HC ON HC.contact_id = T.ContactIDHead 
							LEFT JOIN tbl_contact AC ON AC.contact_id = T.ContactIDAsst 
						   INNER JOIN tbl_club    CL ON CL.club_id    = T.club_id
		WHERE T.season_id = (select season_id from tbl_season where RegistrationOpen_YN = 'Y')
		AND T.team_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#teamID#">
	</CFQUERY>


	<CFSET ctTeams = qTeams.RECORDCOUNT>
</CFIF> 

<H1 class="pageheading">NCSA - Team <cfoutput>#qTeams.teamname#</cfoutput></H1>
<br>

<!--- <CFIF isDefined("FORM.GOCLUB") AND ctTeams EQ 0>
	<CFSET msg = msg & " If ""All Ages"" was selected, then a club must be selected.">
</CFIF>  --->

<table cellspacing="2" cellpadding="3" align="left" border="0" width="98%">
	<tr>
		<td style="border-bottom: 1px solid #ddd; color: #006699" width="100px"><strong>Gender</strong></td>
		<td style="border-bottom: 1px solid #ddd;"><cfoutput>#qTeams.gender#</cfoutput></td>
	</tr>
	<tr>
		<td style="border-bottom: 1px solid #ddd; color: #006699" width="100px"><strong>Age</strong></td>
		<td style="border-bottom: 1px solid #ddd;"><cfoutput>#qTeams.teamage#</cfoutput></td>
	</tr>
	<tr>
		<td style="border-bottom: 1px solid #ddd; color: #006699" width="100px"><strong>Level</strong></td>
		<td style="border-bottom: 1px solid #ddd;"><cfoutput>#qTeams.playlevel#</cfoutput></td>
	</tr>
	<tr>
		<td style="border-bottom: 1px solid #ddd; color: #006699" width="100px"><strong>Group</strong></td>
		<td style="border-bottom: 1px solid #ddd;"><cfoutput>#qTeams.playgroup#</cfoutput></td>
	</tr>
	<tr>
		<td style="border-bottom: 1px solid #ddd; color: #006699" width="100px"><strong>Req. Div</strong></td>
		<td style="border-bottom: 1px solid #ddd;"><cfoutput>#qTeams.requestdiv#</cfoutput></td>
	</tr>
	<tr>
		<td style="border-bottom: 1px solid #ddd; color: #006699" width="100px"><strong>USSF Div</strong></td>
		<td style="border-bottom: 1px solid #ddd;"><cfoutput>#qTeams.ussfdiv#</cfoutput></td>
	</tr>
	<tr>	
		<td style="border-bottom: 1px solid #ddd; color: #006699" width="100px"><strong>Team Name</strong></td>
		<td style="border-bottom: 1px solid #ddd;"><cfoutput>#qTeams.teamname#</cfoutput></td>
	</tr>
	<tr>
		<td style="border-bottom: 1px solid #ddd; color: #006699" width="100px"><strong>Phone</strong></td>
		<td style="border-bottom: 1px solid #ddd;"><cfoutput>#qTeams.coachhomephone#</cfoutput></td>
	</tr>
	<tr>
		<td style="border-bottom: 1px solid #ddd; color: #006699" width="100px"><strong>Appeal</strong></td>
		<td style="border-bottom: 1px solid #ddd;"><cfoutput>#qTeams.appeals#</cfoutput></td>
	</tr>
	<tr>
		<td style="border-bottom: 1px solid #ddd; color: #006699" width="100px"><strong>Status</strong></td>
		<td style="border-bottom: 1px solid #ddd;"><cfoutput>#qTeams.appealsstatus#</cfoutput></td>
	</tr>
	<tr>
		<td style="border-bottom: 1px solid #ddd; color: #006699" width="100px"><strong>Same Roster Last Season</strong></td>
		<td style="border-bottom: 1px solid #ddd;"><cfoutput>#qTeams.roster#</cfoutput></td>
	</tr>
	<tr>
		<td style="border-bottom: 1px solid #ddd; color: #006699" width="100px"><strong>Previous Season Division</strong></td>
		<td style="border-bottom: 1px solid #ddd;"><cfoutput>#qTeams.prevPlayLevel#</cfoutput></td>
	</tr>
	<tr>
		<td style="border-bottom: 1px solid #ddd; color: #006699" width="100px"><strong>Team formation Type</strong></td>
		<td style="border-bottom: 1px solid #ddd;"><cfoutput>#qTeams.teamFormed#</cfoutput></td>
	</tr>
	<tr>
		<td style="border-bottom: 1px solid #ddd; color: #006699" width="100px"><strong>Team Available Opp Day</strong></td>
		<td style="border-bottom: 1px solid #ddd;"><cfoutput>#qTeams.teamAvailability#</cfoutput></td>
	</tr>
	<tr>
		<td style="border-bottom: 1px solid #ddd; color: #006699" width="100px"><strong>Got Soccer ID #</strong></td>
		<td style="border-bottom: 1px solid #ddd;"><cfoutput>#qTeams.soccerID#</cfoutput></td>
	</tr>
	<tr>
		<td style="border-bottom: 1px solid #ddd; color: #006699" width="100px"><strong>Comments/Reasons</strong></td>
		<td style="border-bottom: 1px solid #ddd;"><cfoutput>#qTeams.reasonForPlayLevel#</cfoutput></td>
	</tr>
</table>



<!--- <table cellspacing="0" cellpadding="3" align="left" border="0" width="98%">

	<cfinvoke component="#SESSION.SITEVARS.cfcPath#registration" method="getRegisteredClubs" returnvariable="qClubs">
		<cfinvokeargument name="orderby" value="clubname">
	</cfinvoke>
	<TR><TD align="right"> &nbsp; </TD>
		<TD colspan="11"> <b>Select a Club:</b>
			<Select name="Clubselected">
				<option value="0">All Clubs</option>
				<CFLOOP query="qClubs">
					<option value="#CLUB_ID#" <CFIF CLUB_ID EQ VARIABLES.ClubID>selected</CFIF> >#CLUB_NAME#</option>
					<CFIF CLUB_ID EQ VARIABLES.ClubID><cfset clubname = CLUB_NAME></CFIF>
				</CFLOOP>
			</SELECT>
			and/or 
			<b>Team Age:</b>
			<SELECT  name="TeamAgeSelected" >
				<OPTION value="">All Ages </OPTION>
				<CFLOOP list="#lTeamAges#" index="ita">
					<OPTION value="#ita#" <CFIF TeamAgeSelected EQ ita>selected</CFIF>  >#ita#</OPTION>
				</CFLOOP>
			</SELECT>

			<b>Gender:</b>
			<SELECT  name="BGSelected" >
				<OPTION value="ALL">Both </OPTION>
				<OPTION value="B" <CFIF BGSelected EQ "B">selected</CFIF> >Boys</OPTION>
				<OPTION value="G" <CFIF BGSelected EQ "G">selected</CFIF> >Girls</OPTION>
			</SELECT>

			<INPUT type="Submit" name="goClub" value="Get Teams">
		</TD>
	</TR>
	<cfif len(trim(msg))>
		<tr><td colspan="12"><span class="red"><b>#msg#</b></span></td></tr>
	</cfif>
	<tr class="tblHeading">
		<td width="02%"></td>
		<td width="06%" align="center"><b>Gender</b></td>
		<td width="09%" align="center"><B>Age</B></td>
		<td width="08%" align="center"><B>Level</B></td>
		<td width="08%" align="center"><B>Group</B></td>
		<td width="05%" align="center"><B>Req. Div</B></td>
		<td width="01%"> <B>&nbsp;</B> </td>	
		<td width="01%"> <B>USSF Div</B> </td>	
		<td width="32%"> <B>Team Name</B> <br> (club-div-coach)</td>
		<td width="12%" align="center"><B>Phone</B></td>
		<td width="08%" align="center"><B>Appeal</B></td>
		<td width="08%" align="center"><B>Status</B></td>
	</tr>
	<CFIF isDefined("qTeams") and qTeams.recordCount >

		<CFSET holdGender = "">
		<CFLOOP query="qTeams">
			<CFIF (BGSelected EQ "ALL") OR	(BGSelected EQ GENDER)>

					<CFIF GENDER neq holdGender>
							<tr class="tblHeading">
								<td width="02%"></td>
								<td colspan="11"><b><CFIF GENDER EQ "B"> Boys <CFELSE> Girls </CFIF></b></td>
							</tr>
							<CFSET holdGender = GENDER>
					</CFIF>
					<cfif TEAM_ID EQ variables.teamID>
							<cfset boldStart = "<b>" >
							<cfset boldEnd   = "</b>" >
					<cfelse>
						<cfset boldStart = "" >
						<cfset boldEnd   = "" >
					</cfif>
					<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> 
						<CFIF TEAM_ID EQ VARIABLES.teamID>
							<cfset underline = "">
						<CFELSE>
							<cfset underline = "class='tdUnderLine'">
						</CFIF>
							
		
						<TD #underline# align="center">
		
								<INPUT type=radio  value="#TEAM_Id#" <cfif TEAM_ID EQ variables.teamID>checked</cfif> name="teamID">

							<INPUT type=hidden value="#TEAM_Id#" name="ListTeamIds">
						</TD>
						<TD #underline# align="center" align="center">&nbsp; #boldStart# #GENDER# #boldEnd#</td>
						<TD #underline# align="center">
								<SELECT  name="TeamAge_#TEAM_Id#"  > <!--- <cfif swDisable>disabled</cfif> --->
									<CFLOOP list="#lTeamAges#" index="ita">
										<OPTION value="#ita#" <CFIF TeamAge EQ ita>selected</CFIF>  >#ita#</OPTION>
									</CFLOOP>
								</SELECT>
						 </td>
						<TD #underline# align="center">
							<SELECT  name="PlayLevel_#TEAM_Id#"  ><!--- <cfif swDisable>disabled</cfif> --->
								<CFLOOP list="#lPlayLevel#" index="ipl">
									<OPTION value="#ipl#" <CFIF PlayLevel EQ ipl>selected</CFIF> >#ipl#</OPTION>
								</CFLOOP>
							</SELECT>
						</td>
						<TD #underline# align="center">
							<SELECT name="PlayGroup_#TEAM_Id#" style="WIDTH: 40px ">
								<OPTION value=""></OPTION>
								<OPTION value="W" <CFIF PlayGroup EQ "W">selected</CFIF> >White</OPTION>
								<OPTION value="B" <CFIF PlayGroup EQ "B">selected</CFIF> >Blue </OPTION>
							</SELECT>
						</td>
						<TD #underline#>&nbsp; #boldStart# #requestDiv# #boldEnd#</td>
						<td #underline#>&nbsp; <!--- #Division# ---> </td>
						<td #underline#>&nbsp; #USSFDiv# </td>
						<td #underline#>&nbsp; #boldStart# #TEAMNAMEderived# #boldEnd#	

						</td>
						<td #underline#>&nbsp; #boldStart# #coachHomePhone# #boldEnd#	</td>
						<td #underline# align=center>
							&nbsp;
							<cfif len(trim(Appeals))>
								<b>Y</b>

							</cfif>
						</td>
						<td #underline# align=center>
							&nbsp;
							<cfswitch expression="#ucase(appealsStatus)#">
								<cfcase value="P"> <cfset applStatusText = "Pending">  <cfset swRed = true> </cfcase>
								<cfcase value="A"> <cfset applStatusText = "Accepted"> <cfset swRed = false> </cfcase>
								<cfcase value="R"> <cfset applStatusText = "Rejected"> <cfset swRed = false> </cfcase>
								<cfdefaultcase>    <cfset applStatusText = "">		   <cfset swRed = false> </cfdefaultcase>
							</cfswitch>
							#boldStart#
							<cfif swRed>
								<span class="red">#applStatusText#</span>
							<cfelse>
								#applStatusText#
							</cfif>
						</td>
					</TR>
					<CFIF TEAM_ID EQ VARIABLES.teamID>
						<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> 
							<td class="tdUnderLine" align="center" colspan="12">
								<span class="red">Enter Appeal here, when done click "Submit Appeal" on the right.</span>
								<br>
								<TEXTAREA  name="teamAppealTxt" rows=5 cols=90>#appeals#</TEXTAREA>	
								<SELECT name="AppealSts">
										<CFLOOP from="1" to="#arrayLen(lappealSts)#" index="ists">
											<OPTION value="#lappealSts[ists][1]#" <CFIF ucase(appealsStatus) EQ lappealSts[ists][1]>selected</CFIF> >#lappealSts[ists][2]#</OPTION>
										</CFLOOP> 
								</SELECT>
								<input type="Submit" name="SetAppeal" value="Submit Appeal">
								<input type="Submit" name="CancelAppeal" value="Cancel">
							</td>
						</tr>
					</CFIF>
			</CFIF>	
		</CFLOOP>
	        <tr><td colspan="12" align="center">

						<INPUT type="Submit" name="Appeal" value="Select Team for Appeal" >

					<INPUT type="Submit" name="setFlights" value="Update All Flights" >
				</td>
			</tr>
	<CFELSE>
			<tr><td colspan="12" align="center">
					<cfif len(trim(clubName))>
			  			<br> <span class="red"><b>There are no teams to display for club: #clubname# </b></span>
					</cfif>
					<cfif len(trim(teamAgeSelected))>
			  			<br> <span class="red"><b>There are no teams to display for this age group </b></span>
					</cfif>
				</td>
			</tr>
		</CFIF>



	</table>
</FORM>

 
</cfoutput> --->
</div>
<cfinclude template="_footer.cfm">