<!--- 
	FileName:	teamsSummaryMatrix.cfm
	Created on: 11/06/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
	01/07/09 - aarnone - fixed grand totals on top line
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 

<cfset BoysColStart	= 3>		<!---  Column in the Matrix --->
<cfset TotalDivisions = 13>		<!---  U07 - U19 = 13 --->
<cfset GirlsColStart = BoysColStart + TotalDivisions>	<!---  Effectively it'll be 15 --->
<cfset TotalColumns	 = (TotalDivisions * 2) + 2>		<!---  Col 1 for ClubName, Col 28 for Unwanted values --->
<cfset ctColor = 0>
<cfset TotalClubs = 0>

<cfquery name="clubCount" datasource="#SESSION.DSN#">
	Select count(*) as ctClubs from V_Clubs
</cfquery>
<cfset TotalClubs = clubCount.ctClubs>

<cfif TotalClubs EQ 0>
	<cflocation url="homePage.cfm">
</cfif>


<cfif isDefined("URL.Q") and Len(trim(URL.Q)) EQ 3>
	<cfset useQuery = URL.Q>
<cfelse>
	<cfset useQuery = "">
</cfif>

<CFSWITCH expression="#UCASE(VARIABLES.useQuery)#">
	<cfcase value="RSA"> <!--- query for REGIS. Season APPROVED --->
				<cfset TitleText = "Approved for Registration Season">
				<cfquery name="getTeams" datasource="#SESSION.DSN#">
					Select a.Club_NAME, a.CLUB_ID, 
					   A.teamage, A.Gender,A.SEASON_ID, Count(*) as ctTeamsQ
					 from V_CoachesINFO A
					 Where A.ClubID <> 1
					   and A.Approved = 'Y'
					   and CHARINDEX('R', A.DIVISION) = 0 
					 Group by a.Club_NAME, a.CLUB_ID, A.teamage, A.Gender, A.SEASON_ID
					 order by a.club_name
				</cfquery> <!--- rsa <cfdump var="#getTeams#"> --->
	</cfcase>
	<cfcase value="RSU"> <!--- query for REGIS. Season UNApproved --->
				<cfset TitleText = "To Be Approved for Registration Season">
				<cfquery name="getTeams" datasource="#SESSION.DSN#">
					Select A.Club_NAME, A.CLUB_ID, 
						   A.teamage, A.Gender,A.SEASON_ID, Count(*) as ctTeamsQ
					  from V_CoachesINFO A
					 Where A.ClubID <> 1     	
						and A.Approved <> 'Y'
						and CHARINDEX('R', A.DIVISION) = 0 
					  Group by a.Club_NAME, a.CLUB_ID, A.teamage, A.Gender, A.SEASON_ID
					 order by a.club_name
				</cfquery> <!--- rsu <cfdump var="#getTeams#"> --->
	</cfcase>
	<cfdefaultcase> <!--- query for Current Season --->
				<cfset TitleText = "">
				<cfquery name="getTeams" datasource="#SESSION.DSN#">
					Select B.Club_NAME, B.CLUB_ID, A.teamage, A.Gender, A.SEASON_ID, Count(*) as ctTeamsQ
					  from V_CoachesTeams A 
								INNER JOIN TBL_Club B 			   ON B.CLUB_ID = A.ClubID  	
								INNER JOIN xref_club_season AS XCS ON XCS.club_id = B.club_id 
					 Where (XCS.Approved_YN = 'Y') 
					   AND (XCS.season_id = (SELECT season_id
					                           FROM tbl_season
					                          WHERE (currentSeason_YN = 'Y'))
						  )
				      AND (A.TeamStatus is Null or A.TeamStatus = '')
					  and CHARINDEX('R', A.DIVISION) = 0
					 Group by B.Club_NAME, B.CLUB_ID, A.teamage, A.Gender, A.SEASON_ID
					 order by b.club_name
				</cfquery> <!--- Curr <cfdump var="#getTeams#"> --->
					<!--- Select B.Club_NAME, B.CLUB_ID, A.teamage, A.Gender, A.SEASON_ID, Count(*) as ctTeamsQ
					  from V_CoachesTeams A, V_Clubs B
					 Where   (A.TeamStatus is Null or A.TeamStatus = '')
					   and A.ClubID = B.ID	
					   and B.ID <> 1     	
					 Group by B.Club_NAME, B.CLUB_ID, A.teamage, A.Gender, A.SEASON_ID --->
	</cfdefaultcase>
</CFSWITCH>
		
 
 
<!--- the Division starts from U07 till U18, 12 Divisions in All
	  Second Column of the ClubTeamMtrx will have the U07 for Boys For Girls it start from 14th column. 
	  Subtract 5 from U07 gives us 2, the required column,    	  For Girls, we subtract 5 from U07 and add 12 to get 14th colum
	  Row 1 will contain Colum Total. --->

<!--- init array --->
<cfset ctLoop =  TotalClubs + 1>
<cfloop from="1" to="#ctLoop#" index="iRow">
	<cfloop from="1" to="#TotalColumns#" index="iCol">
		<cfset ClubTeamMtrx[iRow][iCol] = 0>
	</cfloop>
</cfloop>	<!--- <cfdump var="#ClubTeamMtrx#"> --->

<!--- accum totals by club and age group --->
<cfset iRow = 1 >
<cfset iCol = 1 >
<cfset holdClubID = 0 >

<CFLOOP query="getTeams">
	<cfif holdClubID NEQ CLUB_ID>
		<cfset holdClubID = CLUB_ID>
		<cfset iCol = 1 >
		<cfset iRow = iRow + 1 >
		<cfset ClubTeamMtrx[iRow][iCol] = CLUB_NAME>
	</cfif>
	<cfset TeamAgeX = Right(TEAMAGE,2)>
	<cfif TeamAgeX GTE 7 and TeamAgeX LTE 19>
		<cfswitch expression="#GENDER#">
			<cfcase value="B">
				<cfset iCol = TeamAgeX - 4>
			</cfcase>	
			<cfcase value="G">
				<cfset iCol = TeamAgeX - 4 + TotalDivisions>
			</cfcase>
			<cfdefaultcase>
				<cfset iCol = TotalColumns>
			</cfdefaultcase>
		</cfswitch>
		<cfset ClubTeamMtrx[iRow][iCol] = ctTeamsQ>
		<cfset ClubTeamMtrx[1][iCol] = ClubTeamMtrx[1][iCol] + ctTeamsQ>
	</cfif>
</CFLOOP>	<!--- <cfdump var="#ClubTeamMtrx#"> --->

<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfsavecontent variable="cfhtmlhead_team_summary">
<script>window.jQuery || document.write(unescape('%3Cscript src="assets/jquery-1.10.1.min.js"%3E%3C/script%3E'))</script>
<script>
	$(function () {
		$("#printBtn").click(function () {
			<cfif useQuery EQ "">
			window.open('teamsSummaryMatrix_PDF.cfm');
			<cfelse>
			window.open('teamsSummaryMatrix_PDF.cfm?q=<cfoutput>#useQuery#</cfoutput>');
			</cfif>
		});
	});
</script>
</cfsavecontent>
<cfhtmlhead text="#cfhtmlhead_team_summary#">
<cfoutput>
<div id="contentText">
<H1 class="pageheading">
	NCSA - Club/Teams Summary 
	<cfif isDefined("getTeams") AND getTeams.RecordCount GT 0>
		<input id="printBtn" type="button" value="Print Report" />
	</cfif>
</H1>



<CFIF getTeams.RECORDCOUNT>
	<!--- THE views V_CoachesTeams and V_Clubs always contain the current season, so use them  to get the current season --->
	<cfquery name="getSeasonName" datasource="#SESSION.DSN#">
		SELECT season_id, season_SF, season_year
		  from tbl_season
		 WHERE season_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#getTeams.SEASON_ID#">
	</cfquery> <!--- <cfdump var="#getSeasonName#"> --->
	<h2> #TitleText# #getSeasonName.season_SF# #getSeasonName.season_year#</h2>
	<FORM name="ClubTeamSummary" action=""  method="post">
	<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
		<tr class="tblHeading">
			<td width="19%" align="right">&nbsp;</td>
			<td width="05%" align="right">&nbsp;</td>
			<td width="05%" align="center">U07</td>
			<td width="05%" align="center">U08</td>
			<td width="05%" align="center">U09</td>
			<td width="05%" align="center">U10</td>
			<td width="05%" align="center">U11</td>
			<td width="05%" align="center">U12</td>
			<td width="05%" align="center">U13</td>
			<td width="05%" align="center">U14</td>
			<td width="05%" align="center">U15</td>
			<td width="05%" align="center">U16</td>
			<td width="04%" align="center">U17</td>
			<td width="05%" align="center">U18</td>
			<td width="04%" align="center">U19</td>
			<td width="06%" align="center">Total</td>
			<td width="07%" align="center">&nbsp;</td>
		</tr>
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctColor)#"> <cfset ctColor = ctColor + 1>
			<td class="tdUnderLine" align=right> Grand Totals </td>
			<td class="tdUnderLine">&nbsp;  </td>
			<cfset iRowTotal = 0>
			<cfset iRow		= 1>
			<cfloop from="3" to="15" index="iCol">
				<td class="tdUnderLine" align=Center>
					<cfif ClubTeamMtrx[iRow][iCol] EQ 0 AND ClubTeamMtrx[iRow][iCol + 13] EQ 0>
						&nbsp;
					<cfelse>
						<cfset total = ClubTeamMtrx[iRow][iCol] + ClubTeamMtrx[iRow][iCol + 13] >
						<b>#total#</b>
						<!---  Boys range from Column 2 - 14, Girls from 15 - 27  --->
						<cfset iRowTotal = iRowTotal + ClubTeamMtrx[iRow][iCol] + ClubTeamMtrx[iRow][iCol + 13] >
					</cfif>
				</td>
			</cfloop>
			<td class="tdUnderLine" align=Center> <b>#iRowTotal#</b> </td>
			<td class="tdUnderLine">&nbsp;</td>
		</tr>
		<!--  Boys grand total   -->
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctColor)#"> <cfset ctColor = ctColor + 1>
			<td class="tdUnderLine" align=right> Total Boys </td>
			<td class="tdUnderLine">&nbsp;  </td>
			<cfset iRowTotal = 0>
			<cfset iRow		= 1>
			<cfloop from="3" to="15" index="iCol">
				<td class="tdUnderLine" align=Center>
					<cfif ClubTeamMtrx[iRow][iCol] EQ 0>
						&nbsp;
					<cfelse>
						#ClubTeamMtrx[iRow][iCol]#
						<!---  Boys range from Column 2 - 14, Girls from 15 - 27  --->
						<cfset iRowTotal = iRowTotal + ClubTeamMtrx[iRow][iCol]>
					</cfif>
				</td>
			</cfloop>
			<td class="tdUnderLine" align=Center>	 #iRowTotal# </td>
			<td class="tdUnderLine">&nbsp;</td>
		</tr>
		<!--  Girls grand total   -->
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctColor)#"> <cfset ctColor = ctColor + 1>
			<td class="tdUnderLine" align=right> Total Girls </td>
			<td class="tdUnderLine">&nbsp;  </td>
			<cfset iRowTotal = 0>
			<cfset iRow		= 1>
			<cfloop from="3" to="15" index="iCol">
				<td class="tdUnderLine" align=Center>
					<cfif ClubTeamMtrx[iRow][iCol + 13] EQ 0>
						&nbsp;
					<cfelse>
						#ClubTeamMtrx[iRow][iCol + 13]#
						<!---  Boys range from Column 2 - 14, Girls from 15 - 27  --->
						<cfset iRowTotal = iRowTotal + ClubTeamMtrx[iRow][iCol + 13] >
					</cfif>
				</td>
			</cfloop>
			<td class="tdUnderLine" align=Center>	 #iRowTotal# 	</td>
			<td class="tdUnderLine">&nbsp;</td>
		</tr>
	</table>
		 
	<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
		<tr class="tblHeading">
			<td width="19%" align="right">&nbsp;</td>
			<td width="05%" align="right">&nbsp;</td>
			<td width="05%" align="center">U07</td>
			<td width="05%" align="center">U08</td>
			<td width="05%" align="center">U09</td>
			<td width="05%" align="center">U10</td>
			<td width="05%" align="center">U11</td>
			<td width="05%" align="center">U12</td>
			<td width="05%" align="center">U13</td>
			<td width="05%" align="center">U14</td>
			<td width="05%" align="center">U15</td>
			<td width="05%" align="center">U16</td>
			<td width="04%" align="center">U17</td>
			<td width="05%" align="center">U18</td>
			<td width="04%" align="center">U19</td>
			<td width="06%" align="center">Total</td>
			<td width="07%" align="center">Club Total</td>
		</tr>
	</table>
	<div style="overflow:auto; height:500px; border:1px ##cccccc solid;">
	<table cellspacing="0" cellpadding="2" align="left" border="0" width="98%">
		<cfloop from="2" to="#TotalClubs#" index="iRow">
			<cfset ctColor = ctColor + 1>
			<cfif len(trim(ClubTeamMtrx[iRow][1])) AND ClubTeamMtrx[iRow][1] NEQ 0 >
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctColor)#"> 
					<td class="tdUnderLine" width="20%"> #ClubTeamMtrx[iRow][1]# </td>
					<td class="tdUnderLine" width="05%">Boys</td>
					<cfset iClubTotal	= 0 >
					<cfset iRowTotal	= 0 >
					<cfloop from="3" to="15" index="iCol">
						<td class="tdUnderLine" width="05%" align=Center>
							<cfif ClubTeamMtrx[iRow][iCol] EQ 0>
								&nbsp;
							<cfelse>
								#ClubTeamMtrx[iRow][iCol]#
								<cfset iRowTotal = iRowTotal + ClubTeamMtrx[iRow][iCol]>
							</cfif>
						</td>
					</cfloop>
					<td class="tdUnderLine" width="05%" align=Center> #iRowTotal# </td>
					<cfset iClubTotal = iRowTotal>	<!---  Boys Total  --->
					<td class="tdUnderLine" width="05%">&nbsp;</td>
				</tr>
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctColor)#"> 
					<td class="tdUnderLine">&nbsp; </td>
					<td class="tdUnderLine"> Girls </td>
					<cfset iRowTotal = 0>
					<cfloop from="16" to="28" index="iCol">
						<td class="tdUnderLine" align=Center>
							<cfif ClubTeamMtrx[iRow][iCol] EQ 0 >
								&nbsp;
							<cfelse>
								#ClubTeamMtrx[iRow][iCol]#
								<cfset iRowTotal = iRowTotal + ClubTeamMtrx[iRow][iCol]>
							</cfif>
						</td>
					</cfloop>
					<td class="tdUnderLine" align=Center>  #iRowTotal#  </td>
					<cfset iClubTotal = iClubTotal + iRowTotal> <!---  Adding Girls Total to club total --->
					<td class="tdUnderLine" align=Center>  #iClubTotal#  </td>
				<TR>
			</cfif>
		</cfloop>
	</table>
	</div>
	<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
		<tr class="tblHeading">
			<td width="19%" align="right">&nbsp;</td>
			<td width="05%" align="right">&nbsp;</td>
			<td width="05%" align="center">U07</td>
			<td width="05%" align="center">U08</td>
			<td width="05%" align="center">U09</td>
			<td width="05%" align="center">U10</td>
			<td width="05%" align="center">U11</td>
			<td width="05%" align="center">U12</td>
			<td width="05%" align="center">U13</td>
			<td width="05%" align="center">U14</td>
			<td width="05%" align="center">U15</td>
			<td width="05%" align="center">U16</td>
			<td width="04%" align="center">U17</td>
			<td width="05%" align="center">U18</td>
			<td width="04%" align="center">U19</td>
			<td width="06%" align="center">Total</td>
			<td width="07%" align="center">Club Total</td>
		</tr>
	</table>
<CFELSE>
	No teams found
</CFIF>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">
