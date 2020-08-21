<!--- 
	FileName:	rptRegSeasonAppTeams.cfm
	Created on: 02/06/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: 
	
MODS: mm/dd/yyyy - filastname - comments
01/15/2009 - aarnone - changed message on top.
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<!--- <cfinclude template="_checkLogin.cfm"> use? --->

<cfif isDefined("FORM.TeamAge")>
	<cfset teamAge = FORM.TeamAge>
<cfelse>
	<cfset teamAge = "">
</cfif>	

<cfif isDefined("FORM.Gender")>
	<cfset Gender = FORM.Gender>
<cfelse>
	<cfset Gender = "">
</cfif>

<cfif isDefined("FORM.ApprovedYN")>
	<cfset ApprovedYN = FORM.ApprovedYN>
	<cfif ApprovedYN EQ "Y">
		<cfset pageTitle  = " - Approved Teams List">
	<cfelse>
		<cfset pageTitle  = " - To Be Approved Teams List">
	</cfif>
<cfelse>
	<cfset ApprovedYN = "">
	<cfset pageTitle  = "">
</cfif>

<cfoutput>
<div id="contentText">

<!--- WE are not using SESSION values because it is a public page  --->
<cfset seasonID = 0>	
<cfset seasonSF = "">
<cfset seasonYR = "">

<cfset seasonID=session.regseason.id>
<cfset seasonSF=session.regseason.sf>
<cfset seasonYR=session.regseason.year>
<!--- <cfquery name="qRegSeason" datasource="#SESSION.DSN#">
	SELECT season_id, season_year, season_SF
     FROM tbl_season 
	 WHERE RegistrationOpen_YN = 'Y'
</cfquery>
<CFIF qRegSeason.RECORDCOUNT> 
	<!--- Use the REG season --->
	<cfset seasonID = qRegSeason.season_id>
	<cfset seasonSF = qRegSeason.season_SF>
	<cfset seasonYR = qRegSeason.season_year>
<CFELSE>
	<!--- Use the CURRENT season --->	
	<cfquery name="qCurrSeason" datasource="#SESSION.DSN#">
		SELECT season_id, season_year, season_SF
   		  FROM tbl_season 
		 WHERE CurrentSeason_YN = 'Y'
	</cfquery>
	<CFIF qCurrSeason.RECORDCOUNT> 
		<!--- Use the REG season --->
		<cfset seasonID = qCurrSeason.season_id>	
		<cfset seasonSF = qCurrSeason.season_SF>
		<cfset seasonYR = qCurrSeason.season_year>
	</CFIF>
</CFIF> --->

<H1 class="pageheading">NCSA - Registration Season Report #pageTitle#</H1>
<h2>For #VARIABLES.seasonSF# #VARIABLES.seasonYR# Teams </h2>

<cfquery name="qTeamAge" datasource="#SESSION.DSN#">
	SELECT DISTINCT TEAMAGE 
	  FROM TBL_TEAM 
	 WHERE SEASON_ID = #VARIABLES.seasonID#
	 ORDER BY TEAMAGE
</cfquery> <!--- WHERE SEASON_ID = (SELECT season_id FROM tbl_season WHERE RegistrationOpen_YN = 'Y') --->

<FORM action="rptRegSeasonAppTeams.cfm" method="post">
	<b>Team Age</b>
	<SELECT name="TeamAge" > 
		<OPTION value="" selected>All Ages</OPTION>
		<cfloop query="qTeamAge">
			<OPTION value="#TeamAge#" <cfif VARIABLES.teamAge EQ TEAMAGE>selected</cfif> >#TeamAge#</OPTION>
		</cfloop>
	</SELECT>
	
	<b>Select Gender </b>
	<SELECT name="Gender">
		<OPTION value=""  <cfif VARIABLES.gender EQ "">selected</cfif> > Both </OPTION>
		<OPTION value="B" <cfif VARIABLES.gender EQ "B">selected</cfif> > Boys </OPTION>
		<OPTION value="G" <cfif VARIABLES.gender EQ "G">selected</cfif> > Girls</OPTION>
	</SELECT>

	<b>ApprovedYN </b>
	<SELECT name="ApprovedYN">
		<OPTION value="Y" <cfif VARIABLES.ApprovedYN EQ "Y">selected</cfif> > Yes </OPTION>
		<OPTION value="N" <cfif VARIABLES.ApprovedYN EQ "N">selected</cfif> > No  </OPTION>
	</SELECT>


	<input type="Submit" name="GETTEAMS" value="Get Teams">
</FORM>

<br>
<CFIF isDefined("FORM.GETTEAMS")>
	<CFQUERY name="qGetTeams" datasource="#SESSION.DSN#">
		SELECT dbo.getTeamName(T.team_id) AS TEAMNAMEderived, T.requestDiv,  T.appealsStatus
			 , IsNull(T.Gender,'') + right(T.TeamAge,2) + IsNull(T.PlayLevel,'') + IsNull(T.PlayGroup,'') AS DIVISION
			 , HC.FirstName AS HC_FirstName,  HC.LastName AS HC_LastName,  HC.email AS HC_Email
		  FROM tbl_team T INNER JOIN XREF_CLUB_SEASON X ON X.club_id = T.club_id 
		                                                AND X.SEASON_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.seasonID#">
		                                                AND X.ACTIVE_YN = 'Y' 
							LEFT JOIN tbl_contact HC ON HC.contact_id = T.ContactIDHead 
		 WHERE T.SEASON_ID = #VARIABLES.seasonID#
		   AND T.approved_yn = '#VARIABLES.ApprovedYN#'
		<CFIF len(Trim(gender))>
		   AND gender = <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.gender#">
		</CFIF>   
		<CFIF len(trim(TeamAge))>
			AND TeamAge = <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.TeamAge#">
		</CFIF>
			AND T.CLUB_ID <> 1
		ORDER BY DIVISION, TEAMNAMEderived
	</CFQUERY>	<!--- WHERE SEASON_ID = (select season_id from tbl_season where RegistrationOpen_YN = 'Y') --->

	<span class="red">Number of teams: #qGetTeams.RECORDCOUNT# </span>	
	<table cellspacing="0" cellpadding="3" align="center" border="0" width="100%">
			<tr class="tblHeading">
				<td width="22" align=left valign="bottom" >Team Name</td>
				<td width="10%" align=left valign="bottom" >Flight Requested</td>
				<td width="10%" align=left valign="bottom" >Flight Assigned</td>
				<td width="20%" align=left valign="bottom" >Coach</td>
				<td width="20%" align=left valign="bottom" >Email</td>
				<td width="12%" align=left valign="bottom" >Appeal Status</td>
		</tr>
	</table>
	<CFIF qGetTeams.RECORDCOUNT>
		<div style="overflow:auto;height:350px;border:1px ##cccccc solid;">
		<table cellspacing="0" cellpadding="3" align="left" border="0" width="100%">
			<CFLOOP query="qGetTeams">
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> <!--- currentRow or counter --->
					<td width="30%" class="tdUnderLine" align="left"> #TEAMNAMEderived#		</td>
					<td width="10%" class="tdUnderLine" align="left"> #requestDiv#		</td>
					<td width="10%" class="tdUnderLine" align="left"> #DIVISION#	</td>
					<td width="20%" class="tdUnderLine" align="left"> #HC_FirstName# #HC_LastName#	</td>
					<td width="20%" class="tdUnderLine" align="left"> #HC_Email#	</td>
					<td width="10%" class="tdUnderLine" align="left">
						<cfswitch expression="#ucase(appealsStatus)#">
							<cfcase value="P"> Pending  </cfcase>
							<cfcase value="A"> Accepted </cfcase>
							<cfcase value="R"> Rejected </cfcase>
							<cfdefaultcase>    &nbsp;	</cfdefaultcase>
						</cfswitch>
					</td>
				</TR>
			</CFLOOP>
		</table>
		</div>	
	<cfelse>
		<span class="red"> <b>No Teams Found.</b> </span>
	</CFIF>
</CFIF>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">
