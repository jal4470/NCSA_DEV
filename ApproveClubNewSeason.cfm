<!--- 
	FileName:	ApproveClubNewSeason.cfm
	Created on: 09/09/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<cfoutput>
<div id="contentText">

<CFIF isDefined("SESSION.REGSEASON")>
	<CFSET displaySeason = SESSION.REGSEASON.SF & " " & SESSION.REGSEASON.YEAR>
<CFELSE>
	<CFSET displaySeason = SESSION.CURRENTSEASON.SF & " " & SESSION.CURRENTSEASON.YEAR>
</CFIF>

<CFIF isDefined("URL.A")>
	<CFIF URL.A EQ "c">
		<CFSET appShow = "Clubs">
	<CFELSEIF URL.A EQ "t">
		<CFSET appShow = "Teams">
	<CFELSEIF URL.A EQ "f">
		<CFSET appShow = "Fields">
	<CFELSE>
		<CFSET appShow = "Clubs">
	</CFIF>
<CFELSE>
	<CFSET appShow = "Clubs">
</CFIF>

<H1 class="pageheading">NCSA - #VARIABLES.appShow# Registered for #displaySeason#</H1>
<br>
<!--- <h2>yyyyyy</h2> --->


<cfinvoke component="#SESSION.sitevars.cfcPath#registration" method="getRegisteredClubs" returnvariable="RegisteredClubs">
</cfinvoke> <!---  <cfdump var="#RegisteredClubs#"> --->

<FORM name="Clubs" action="App_Club_Maintain.asp" method="post">
<table cellspacing="0" cellpadding="5" align="center" border="0" width="90%">
	<tr class="tblHeading">
		<CFSWITCH expression="#VARIABLES.appShow#"><!--- HEADER ROW --->
			<CFCASE value = "Clubs">
				<td width="2%"></td>
				<td width="40%">Club</td>
				<td width="58%"> </td>
			</CFCASE>
			<CFCASE value = "Teams">
				<td width="2%"></td>
				<td width="40%">Club</td>
				<td width="23%"></td>
				<td width="15%">Total Teams</td>
				<td width="20%">Approved Teams</td>
			</CFCASE>
			<CFCASE value = "Fields">
				<td width="2%"></td>
				<td width="40%">Club</td>
				<td width="23%"></td>
				<td width="15%">Total Fields</td>
				<td width="20%">Approved Fields</td>
			</CFCASE>
		</CFSWITCH>
	</tr>
	<CFLOOP query="RegisteredClubs"> <!--- DETAIL ROWS --->
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
			<CFSWITCH expression="#VARIABLES.appShow#">
				<CFCASE value = "Clubs">
					<TD class="tdUnderLine">#club_id#</TD>
					<TD class="tdUnderLine">#Club_NAME#</TD>
					<TD class="tdUnderLine">
						<a href="approveReviewClub.cfm?cid=#club_id#">
							<CFIF APPROVED_YN EQ "Y">
								<span class="red">APPROVED</span>
							<CFELSE>
								Review Club
							</CFIF>
						</a>
					</TD>
				</CFCASE>
				<CFCASE value = "Teams">
					<cfinvoke component="#SESSION.sitevars.cfcPath#registration" method="getRegTeamCount" returnvariable="stRegTeamCount">
						<cfinvokeargument name="ClubId" value="#CLUB_ID#">
					</cfinvoke>  
					<TD class="tdUnderLine">#club_id#</TD>
					<TD class="tdUnderLine">#Club_NAME#</TD>
					<TD class="tdUnderLine" align="center">
						<a href="approveTeamNewSeason.cfm?cid=#club_id#">
							<cfif stRegTeamCount.total GT 0 AND stRegTeamCount.total EQ stRegTeamCount.approved>
								<span class="red">All Approved</span>
							<CFELSE>	
								Review TEAMS
							</cfif>
						</a>
					</TD>
					<TD class="tdUnderLine" align="center">#stRegTeamCount.total#</TD>
					<TD class="tdUnderLine" align="center">#stRegTeamCount.approved#</TD>
				</CFCASE>
				<CFCASE value = "Fields">
					<cfinvoke component="#SESSION.sitevars.cfcPath#field" method="getRegFieldCount" returnvariable="stRegFieldCount">
						<cfinvokeargument name="ClubId" value="#CLUB_ID#">
					</cfinvoke>  
					<TD class="tdUnderLine">#club_id#</TD>
					<TD class="tdUnderLine">#Club_NAME#</TD>
					<TD class="tdUnderLine" align="center">
						<a href="approveReviewField.cfm?cid=#club_id#">
							<cfif stRegFieldCount.total GT 0 AND stRegFieldCount.total EQ stRegFieldCount.approved>
								<span class="red">All Approved</span>
							<CFELSE>	
								Review Fields
							</cfif>
						</a>
					</TD>
					<TD class="tdUnderLine" align="center">#stRegFieldCount.total#</TD>
					<TD class="tdUnderLine" align="center">#stRegFieldCount.approved#</TD>
				</CFCASE>
			</CFSWITCH>
		</tr>
	</CFLOOP>	
</table>	
</FORM>
	
	

</cfoutput>
</div>
<cfinclude template="_footer.cfm">
