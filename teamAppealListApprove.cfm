<!--- 
	FileName:	teamAppealListApprove.cfm
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
01/28/09 - aa - commented out "swAppealOpen" for admins, leave appeals open
01/30/09 - aa - added ussf div, fixed select box for "group"
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm"> 
<cfoutput>
<div id="contentText">

<H1 class="pageheading">NCSA - Team Flight and Appeals</H1>
<br><!--- <h2>yyyyyy </h2> --->

<cfset msg = "">

<CFIF isDefined("FORM.clubSelected")>
	<CFSET clubID = FORM.clubSelected >
<CFELSE>
	<CFSET clubID = 0 >
</CFIF>

<CFIF isDefined("FORM.TeamAgeSelected")>
	<CFSET TeamAgeSelected = FORM.TeamAgeSelected >
<CFELSE>
	<CFSET TeamAgeSelected = "" >
</CFIF>

<CFIF isDefined("FORM.BGSelected")>
	<CFSET BGSelected = FORM.BGSelected >
<CFELSE>
	<CFSET BGSelected = "" >
</CFIF>

<!--- <CFIF isDefined("SESSION.GLOBALVARS.APPEALOPEN") AND SESSION.GLOBALVARS.APPEALOPEN EQ "OPEN">
	<CFSET swAppealOpen = true>
<CFELSE>
	<CFSET swAppealOpen = false>
</CFIF> --->


<CFIF isDefined("FORM.teamID")>
	<CFSET teamID = FORM.teamID>
<CFELSEIF isDefined("URL.tid")>
	<CFSET teamID = URL.tid>
<CFELSE>
	<CFSET teamID = 0>
</CFIF>

<CFIF isDefined("FORM.APPEAL")>
	<CFIF isDefined("FORM.teamID")>
		<CFSET teamID = FORM.teamID>
		<cfset msg = "Enter the appeal in the space provided below the team and then click ""Submit Appeal"" when done.">	
	<CFELSE>
		<cfset msg = "Please select a team.">	
	</CFIF>
</CFIF>

<cfif isDefined("FORM.CancelAppeal")>
	<CFSET teamID = 0>
</cfif>

<CFIF isDefined("FORM.SetAppeal")>
	<CFSET Group = "">
	<CFSET Level = "">
	<CFSET Age = "">
	<!--- loop thru form fields and get values --->
	<CFLOOP collection="#FORM#" item="iVar"> <!--- iVar = form field "FORM.formfield_teamID" --->
		<CFIF listLast(iVar,"_") EQ FORM.TEAMID> <!--- second value is team id --->
			<CFSWITCH expression="#UCASE(listFirst(iVar,"_"))#"> <!--- first value is form field --->
				<CFCASE value="PLAYGROUP">
					<CFSET Group = FORM[iVar]>
				</CFCASE>
				<CFCASE value="PLAYLEVEL">
					<CFSET Level = FORM[iVar]>
				</CFCASE>
				<CFCASE value="TEAMAGE">
					<CFSET Age = FORM[iVar]>
				</CFCASE>
			</CFSWITCH>
		</CFIF>
	</CFLOOP>
<!--- <br> teamID[#FORM.teamID#]
<br> Group[#Group#]
<br> Level[#Level#]
<br> Age[#Age#]
<br> status[#FORM.APPEALSTS#]
<br> text[#FORM.TEAMAPPEALTXT#] --->

	<CFIF len(trim(FORM.teamAppealTxt))>
		<cfset AppealText = trim(replace(FORM.teamAppealTxt, "'", "''"))>
		<CFQUERY name="updateAppeal" datasource="#SESSION.DSN#">
			Update TBL_TEAM			
			   set Appeals	= <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.AppealText#">
				 , AppealsStatus = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#FORM.APPEALSTS#">
			 Where TEAM_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.teamID#">
		</CFQUERY>
		<cfset teamID = 0>
		<cfset msg = "The appeal has been submitted.">	
	<CFELSE>
		<cfset msg = "Please enter your appeal in the box provided or select another team.">	
	</CFIF> 
</CFIF>




<CFIF isDefined("FORM.setFlights")>
	<!--- <cfdump var="#form#"> --->
	<CFLOOP list="#FORM.LISTTEAMIDS#" index="iTeam"> <!--- loop team ids on page --->
		<cfset updateTeam = iTeam>
		<CFLOOP collection="#FORM#" item="iVar"> <!--- iVar = form field "FORM.formfield_teamID" --->
			<CFIF listLast(iVar,"_") EQ updateTeam> <!--- second value is team id --->
				<CFSWITCH expression="#UCASE(listFirst(iVar,"_"))#"> <!--- first value is form field --->
					<CFCASE value="PLAYGROUP">
						<CFSET Group = FORM[iVar]>
					</CFCASE>
					<CFCASE value="PLAYLEVEL">
						<CFSET Level = FORM[iVar]>
					</CFCASE>
					<CFCASE value="TEAMAGE">
						<CFSET Age = FORM[iVar]>
					</CFCASE>
				</CFSWITCH>
			</CFIF>
		</CFLOOP>
		<!--- <br>tid[#updateTeam#] -- Age[#Age#] -- Level[#Level#] -- Group[#Group#] --->
		<CFQUERY name="updateFlight" datasource="#SESSION.DSN#">
			Update TBL_TEAM
			   SET TeamAge	  = <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#Age#">
			 	 , PlayLevel  = <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#Level#">
			 	 , PlayGroup  = <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#Group#" null="#yesNoFormat(NOT len(trim(Group)))#">
			 	 , updateDate = getDate()
			 	 , updatedBy  = #SESSION.USER.CONTACTID#
			 Where TEAM_ID    = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#updateTeam#">
		</CFQUERY>
	</CFLOOP>
</CFIF>

<!--- GET list of TEAMAGES PLAYLEVEL APPEALSTATUS ---> 
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="lTeamAges">
	<cfinvokeargument name="listType" value="TEAMAGES"> 
</cfinvoke> <!--- lTeamAges --->
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="lPlayLevel">
	<cfinvokeargument name="listType" value="PLAYLEVEL"> 
</cfinvoke> <!--- lPlayLevel --->
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="lappealSts">
	<cfinvokeargument name="listType" value="APPEALSTATUS"> 
</cfinvoke> <!--- lappealSts --->

<!--- Get teams for selected club ---> 
<cfset ctTeams = 0>
<CFIF clubID GT 0>
	<!--- all teams for club selected --->
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#registration" method="getRegisteredTeams" returnvariable="qTeams">
		<cfinvokeargument name="clubID" value="#VARIABLES.clubID#">
		<cfinvokeargument name="approvedYN" value="Y">
	</cfinvoke> <!--- 1<cfdump var="#qTeams#"> --->
	<CFSET ctTeams = qTeams.RECORDCOUNT>
	<CFIF len(trim(TeamAgeSelected))>
		<!--- only return teams for club/age selected --->
		<CFQUERY name="qTeams" dbtype="query">
			SELECT * 
			  FROM qTeams
			 WHERE TEAMAGE = '#VARIABLES.TeamAgeSelected#'
		</CFQUERY> <!--- 2<cfdump var="#qTeams#"> --->
		<CFSET ctTeams = qTeams.RECORDCOUNT>
	</CFIF>	
<CFELSEIF len(trim(TeamAgeSelected))>
	<!--- get ALL teams for selected age across ALL clubs --->
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#registration" method="getRegisteredTeams" returnvariable="qTeams">
		<cfinvokeargument name="teamAge" value="#VARIABLES.TeamAgeSelected#">
		<cfinvokeargument name="approvedYN" value="Y">
	</cfinvoke> <!--- 3<cfdump var="#qTeams#"> --->


	<CFSET ctTeams = qTeams.RECORDCOUNT>
</CFIF> 

<CFIF isDefined("FORM.GOCLUB") AND ctTeams EQ 0>
	<CFSET msg = msg & " If ""All Ages"" was selected, then a club must be selected.">
</CFIF> 



<cfset clubname = ""> 
<FORM name="Coaches" action="teamAppealListApprove.cfm" method="post">
<input type="hidden" name="ClubId"		value="#ClubId#">
<table cellspacing="0" cellpadding="3" align="left" border="0" width="98%">
	<!--- <cfinvoke component="#SESSION.SITEVARS.cfcPath#club" method="getClubInfo" returnvariable="qClubs">
		<cfinvokeargument name="orderby" value="clubname">
	</cfinvoke> --->
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
		<td width="01%"> <B>&nbsp;</B> </td>	<!-- Pr. Div -->
		<td width="01%"> <B>USSF Div</B> </td>	<!-- USSF Div -->
		<td width="32%"> <B>Team Name</B> <br> (club-div-coach)</td>
		<td width="12%" align="center"><B>Phone</B></td>
		<td width="08%" align="center"><B>Appeal</B></td>
		<td width="08%" align="center"><B>Status</B></td>
	</tr>
	<CFIF isDefined("qTeams") and qTeams.recordCount >
		<!--- we have teams to show --->
		<CFSET holdGender = "">
		<CFLOOP query="qTeams">
			<CFIF (BGSelected EQ "ALL") OR	(BGSelected EQ GENDER)>
				<!--- show both or only gender selected --->
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
							<!--- we are showing the appeals area, suppress underline --->
							<cfset underline = "">
						<CFELSE>
							<cfset underline = "class='tdUnderLine'">
						</CFIF>
							
		
						<TD #underline# align="center">
							<!--- <CFIF swAppealOpen> --->
								<INPUT type=radio  value="#TEAM_Id#" <cfif TEAM_ID EQ variables.teamID>checked</cfif> name="teamID">
							<!--- <CFELSE>
								<INPUT type=hidden value="#TEAM_Id#" name="teamId">
							</CFIF>   --->
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
						<td #underline#>&nbsp; <a href="teamAppealApproveView.cfm?tid=#TEAM_ID#">#boldStart# #TEAMNAMEderived# #boldEnd#</a>	
							<!--- #Left(trim(Club_Name),10)#-#Trim(coachLastName)#, #Trim(coachFirstName)# ---> <!--- <br>Tname: #TEAMNAME# --->
						</td>
						<td #underline#>&nbsp; #boldStart# #coachHomePhone# #boldEnd#	</td>
						<td #underline# align=center>
							&nbsp;
							<cfif len(trim(Appeals))>
								<b>Y</b>
								<!--- <a href="teamAppealListApprove.cfm?tid=#TEAM_ID#"> #boldStart# Y #boldEnd#</a> --->
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
					<!--- <INPUT type="button" value="Print" name="Print" onclick="GoPrint()"  style="WIDTH: 83px; HEIGHT: 28px" size="38"> --->
					<!--- <CFIF swAppealOpen> --->
						<INPUT type="Submit" name="Appeal" value="Select Team for Appeal" >
					<!--- </CFIF> --->
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

 
</cfoutput>
</div>
<cfinclude template="_footer.cfm">


<!--- 
<INPUT type="submit" value="Submit" name="Submit"  style="WIDTH: 83px; HEIGHT: 28px" size="38">
<INPUT type="button" value="Print" name="Print" onclick="GoPrint()"  style="WIDTH: 83px; HEIGHT: 28px" size="38">
<INPUT type="button" value="Appeal" name="Appeal" onclick="GoAppeal()"  style="WIDTH: 83px; HEIGHT: 28px" size="38">
<INPUT type="button" value="Back" name="Back" onclick="GoBack()"  style="WIDTH: 83px; HEIGHT: 28px" size="38">
<INPUT type="button" value="Help" name="Help" onclick="GoHelp()"  style="WIDTH: 83px; HEIGHT: 28px" size="38">
function RBClicked()
function GetCoaches()	self.document.Coaches.action = "App_Teams_Mtrx.asp";
function GetClubs()		self.document.Coaches.action = "App_Teams_Mtrx.asp";
function GetGender()	self.document.Coaches.action = "App_Teams_Mtrx.asp";
function GoPrint()		self.document.Coaches.action = "App_Teams_Mtrx_Print.asp";
function GoAppeal()		self.document.Coaches.action = "App_Teams_Mtrx_Appeal.asp";

 --->