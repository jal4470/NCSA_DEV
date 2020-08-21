<!--- 
	FileName:	teamAppealList.cfm
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
1/13/2009 - aa - supress appeal button if appeal is not open
				changed to only list approved teams.
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm"> 
<cfoutput>
<div id="contentText">

<H1 class="pageheading">NCSA - Team Flight and Appeals</H1>
<br><!--- <h2>yyyyyy </h2> --->
<div align="center">
	<span class="red">
		No Appeal will be accepted 72 hours before the flight review meeting
		<br>
		Notify your club representative to file appeal online
	</span>
</div>

<CFSET teamID = 0>
<cfset msg = "">

<CFIF isDefined("URL.tid")>
	<CFSET teamID = URL.tid>
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
	 
	<CFIF isDefined("FORM.teamID")>
		<CFSET teamID = FORM.teamID>
	</CFIF>
	<CFIF len(trim(FORM.teamAppealTxt))>
		<cfset AppealText = trim(replace(FORM.teamAppealTxt, "'", "''"))>
		<CFQUERY name="updateAppeal" datasource="#SESSION.DSN#">
			Update TBL_TEAM			
			   set Appeals	= <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.AppealText#">
				 , AppealsStatus = 'P'
			 Where TEAM_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.teamID#">
		</CFQUERY>
		<cfset teamID = 0>
		<cfset msg = "The appeal has been submitted.">	
	<CFELSE>
		<cfset msg = "Please enter your appeal in the box provided or select another team.">	
	</CFIF>
</CFIF>

<CFSET menuRoleID = SESSION.MENUROLEID>

<CFIF listFind(SESSION.CONSTANT.CUROLES,menuRoleID) >
	<CFSET clubID = SESSION.USER.CLUBID>
</CFIF>

<CFIF isDefined("SESSION.GLOBALVARS.APPEALOPEN") AND SESSION.GLOBALVARS.APPEALOPEN EQ "OPEN">
	<CFSET swAppealOpen = true>
<CFELSE>
	<CFSET swAppealOpen = false>
</CFIF>

<cfinvoke component="#SESSION.SITEVARS.cfcPath#registration" method="getRegisteredTeams" returnvariable="qTeams">
	<cfinvokeargument name="clubID" value="#VARIABLES.clubID#">
	<cfinvokeargument name="approvedYN" value="Y">
</cfinvoke> <!--- <cfdump var="#qTeams#"> --->
 
 
<FORM name="Coaches" action="teamAppealList.cfm" method="post">
<input type="hidden" name="ClubId"		value="#ClubId#">
<table cellspacing="0" cellpadding="3" align="left" border="0" width="98%">

	<cfif len(trim(msg))>
		<tr><td colspan="11"><span class="red"><b>#msg#</b></span></td></tr>
	</cfif>
<!--- 	<tr class="tblHeading">
		<td colspan="11"><B>Boy's Teams</B></td>
	</tr>
 --->	<tr class="tblHeading">
		<!--- <td width="02%"></td>
		<td width="08%"><B>Team Age</B></td>
		<td width="05%"><B>Level</B></td>
		<td width="07%"><B>Group</B></td>
		<td width="07%"><B>Req. Div</B></td>
		<td width="05%"><B>&nbsp;</B></td>	<!-- Pr. Div -->
		<td width="05%"><B>&nbsp;</B></td>	<!-- USSF Div -->
		<td width="32%"><B>Club/Coach</B></td>
		<td width="13%"><B>Phone</B></td>
		<td width="08%"><B>Appeal</B></td>
		<td width="10%"><B>Status</B></td> --->


		<td width="02%"></td>
		<td width="06%" align="center"><b>Gender</b></td>
		<td width="09%" align="center"><B>Age</B></td>
		<td width="08%" align="center"><B>Level</B></td>
		<td width="08%" align="center"><B>Group</B></td>
		<td width="05%" align="center"><B>Req. Div</B></td>
		<td width="01%"><B>&nbsp;</B></td>	<!-- Pr. Div -->
		<td width="01%"><B>&nbsp;</B></td>	<!-- USSF Div -->
		<td width="32%"><B>Team Name</B> </td>	<!--- <br> (club-div-coach) --->
		<td width="12%" align="center"><B>Phone</B></td>
		<td width="08%" align="center"><B>Appeal</B></td>
		<td width="08%" align="center"><B>Status</B></td>


	</tr>
	<CFSET holdGender = "">
	
	<CFLOOP query="qTeams">
		<CFIF GENDER neq holdGender>
			<CFIF GENDER neq holdGender>
					<tr class="tblHeading">
						<td width="02%"></td>
						<td colspan="11"><b><CFIF GENDER EQ "B"> Boys <CFELSE> Girls </CFIF></b></td>
					</tr>
					<CFSET holdGender = GENDER>
			</CFIF>
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
				<CFIF swAppealOpen>
					<INPUT type=radio  value="#TEAM_Id#" <cfif TEAM_ID EQ variables.teamID>checked</cfif> name="teamID">
				<CFELSE>
					<INPUT type=hidden value="#TEAM_Id#" name="teamId">
				</CFIF>  
			</TD>
			<TD #underline# align="center" align="center">&nbsp; #boldStart# #GENDER# #boldEnd#</td>
			<TD #underline# align="center">
					&nbsp; #boldStart# #TEAMAGE# #boldEnd#
			 </td>
			<TD #underline# align="center">
					&nbsp; #boldStart# #PlayLevel# #boldEnd#
			</td>
			<TD #underline# align="center">
					&nbsp; #boldStart# #PlayGroup# #boldEnd#
			</td>
			<TD #underline# align="center">&nbsp; #boldStart# #requestDiv# #boldEnd#</td>
			<td #underline# align="center">&nbsp; <!--- #Division# ---> </td>
			<td #underline# align="center">&nbsp; <!--- #USSFDiv# ---> </td>
			<td #underline# align="left">&nbsp; #boldStart# #TEAMNAMEderived# #boldEnd#</td><!--- #Left(trim(Club_Name),10)#-#Trim(coachLastName)#, #Trim(coachFirstName)# --->
			<td #underline# align="center">&nbsp; #boldStart# #coachHomePhone# #boldEnd#</td>
			<td #underline# align=center>
				&nbsp;
				<cfif len(trim(Appeals))>
						<a href="teamAppealList.cfm?tid=#TEAM_ID#"> #boldStart# Y #boldEnd#</a>
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
					<td class="tdUnderLine" align="center" colspan="11">
						<CFIF appealsStatus EQ "R" OR appealsStatus EQ "A">
							<cfset readOnly = "readonly">
							<span class="red">The Appeal has been #applStatusText#.</span>
							<br>
						<CFELSE>
							<cfset readOnly = "">
							<span class="red">Enter Appeal here, when done click "Submit Appeal" below.</span>
							<br>
						</CFIF>  
						<TEXTAREA  name="teamAppealTxt" #readOnly# rows=5 cols=90>#appeals#</TEXTAREA>	
						<br>
						<cfif  readOnly EQ "">
							<CFIF swAppealOpen>
								<input type="Submit" name="SetAppeal" value="Submit Appeal">
							</CFIF>
						</cfif>					
						<input type="Submit" name="CancelAppeal" value="Cancel">
					</td>
				</tr>
		</CFIF>
	</CFLOOP>
    <tr><td colspan="11" align="center">
			<CFIF swAppealOpen>
				<INPUT type="Submit" name="Appeal" value="Select Team" >
			</CFIF>
		</td>
    </tr>
</table>
</FORM>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">
