<!--- 
	FileName:	rptAppTeamSummary.cfm
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

	<H1 class="pageheading">NCSA - Approved Team Summary Report </H1>	
	<!--- <h2>Teams available with special requests </h2> --->
<br>



<CFIF isDefined("FORM.workingSeason")>
	<cfset workingSeason = trim(FORM.workingSeason)>
<CFELSE>
	<cfset workingSeason = "">
</CFIF>


<CFQUERY name="qWorkingSeasons" datasource="#SESSION.DSN#">
	SELECT SEASON_ID, SEASON_YEAR, SEASON_SF, 
		   CURRENTSEASON_YN, REGISTRATIONOPEN_YN
	  FROM TBL_SEASON 
	ORDER BY SEASON_ID desc
</CFQUERY>
<!--- === END - Get values for Drop Down Lists === --->


<FORM name="teamID" action="rptAppTeamSummary.cfm" method="post">
<table cellspacing="0" cellpadding="3" align="center" border="0" width="100%">
	<TR><TD colspan="6" valign="bottom">
			<b>Season:</b>	
			<SELECT name="workingSeason" >
				<CFLOOP query="qWorkingSeasons">
					<CFSET curr = "">
					<CFSET reg = "">
					<CFIF CURRENTSEASON_YN EQ 'Y'>
						<CFSET curr = "(current)">
					</CFIF> 
					<CFIF REGISTRATIONOPEN_YN EQ 'Y'>
						<CFSET reg = "(registration)">
					</CFIF> 
					<option value="#season_id#" <cfif VARIABLES.workingSeason EQ season_id>selected</cfif> >#SEASON_YEAR# #SEASON_SF# #curr# #reg# </option>
				</CFLOOP>
			</SELECT>
			<INPUT type="Submit" name="getTeamSumm" value="Get Summary">
		</TD>
	</TR>
</table>
</FORM> <!--- End of Selection form --->

<CFIF isDefined("FORM.getTeamSumm")>
	<!--- Get Teams based on selection criteria --->
	<cfquery name="qGetTeams" datasource="#SESSION.DSN#">
		SELECT T.team_id, T.teamAge, T.playLevel, T.playgroup, T.gender
			 , IsNull(T.Gender,'') + right(T.TeamAge,2) + IsNull(T.PlayLevel,'') + IsNull(T.PlayGroup,'') AS DIVISION
		  FROM tbl_team T INNER JOIN XREF_CLUB_SEASON X ON X.club_id = T.club_id 
		                                                AND X.SEASON_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.workingSeason#">
		                                                AND X.ACTIVE_YN = 'Y' 
		 WHERE T.SEASON_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.workingSeason#">
		   AND T.Approved_YN = 'Y' 
		ORDER BY DIVISION
	</cfquery> <!---  <cfdump var="#qGetTeams.recordCount#"> --->

	<!--- get distinct divisions --->
	<cfquery name="qDivisions" dbtype="query">
		SELECT DISTINCT DIVISION
		FROM qGetTeams
	</cfquery> <!--- <cfdump var="#qDivisions#"> --->
	<!--- initialize structure --->
	<CFSET stDivs = structNew()>
	<CFLOOP query="qDivisions">
		<CFSET stDivs[DIVISION] = 0>
	</CFLOOP>	<!--- <cfdump var="#stDivs#"> --->
	<!--- Accum totals --->
	<CFLOOP query="qGetTeams">
		<CFSET stDivs[DIVISION] = stDivs[DIVISION] + 1>
	</CFLOOP>	<!--- <cfdump var="#stDivs#"> --->
	
	<!--- <cfset ctBoys  = 0 >	<cfset ctGirls = 0>	<cfset ctTotal = 0>
	<cfloop collection="#stDivs#" item="iT">		<br> <b>#iT#</b>: #stDivs[iT]#		<cfif left(iT,1) EQ "B">			<cfset ctBoys = ctBoys + stDivs[iT]>		<cfelse>			<cfset ctGirls = ctGirls + stDivs[iT]>		</cfif>		<cfset ctTotal = ctTotal + stDivs[iT]>	</cfloop>
	<br>	<br>Total Boys Teams: #ctBoys#	<br>Total Girls Teams: #ctGirls#	<br>Total Total Teams: #ctTotal# --->

	<cfset ctloop  = 0 >
	<cfset ctBoys  = 0 >
	<cfset ctGirls = 0 >
	<cfset ctTotal = 0 >
	<cfset ctAge   = 0 >
	<cfset holdAge = mid(qDivisions.DIVISION,2,2)>
	<cfset holdBG  = left(qDivisions.DIVISION,1)>
	<table cellspacing="0" cellpadding="0" align="center" border="0" width="75%">
		<tr class="tblHeading">
			<TD width="10%">&nbsp;</TD>
			<TD width="10%">&nbsp;</TD>
			<TD width="80%">&nbsp;</TD>
		</TR>
		<cfloop query="qDivisions">
			<cfif left(DIVISION,1) EQ "B">
				<cfset ctBoys = ctBoys + stDivs[DIVISION]>
			<cfelse>
				<cfset ctGirls = ctGirls + stDivs[DIVISION]>
			</cfif>
			
			<cfif holdAge EQ mid(qDivisions.DIVISION,2,2)>
				<cfset ctAge = ctAge + stDivs[DIVISION]>
			<cfelse>
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctloop)#">
					<TD class="tdUnderLine" colspan="2">&nbsp;</TD>
					<TD class="tdUnderLine">Total <b>U#holdAge#</b> #repeatString("&nbsp;",5)# #ctAge#</TD>
				</TR>
				<cfset ctloop  = ctloop + 1 > 
				<cfset ctAge = stDivs[DIVISION]>
				<cfset holdAge = mid(qDivisions.DIVISION,2,2)>
			</cfif>
			<cfset ctTotal = ctTotal + stDivs[DIVISION]>
			
			<CFIF holdBG NEQ left(qDivisions.DIVISION,1)>
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctloop)#">
					<TD class="tdUnderLine" colspan="2">&nbsp;</TD>
					<TD class="tdUnderLine">#repeatString("&nbsp;",15)# <b> Total Boys Teams:  #ctBoys#</b></TD>
				</TR>
				<cfset holdBG  = left(qDivisions.DIVISION,1)>
				<cfset ctloop  = ctloop + 1 >
			</CFIF>
			
			<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctloop)#">
				<TD class="tdUnderLine">#DIVISION#:</TD>
				<TD class="tdUnderLine">#stDivs[DIVISION]#</TD>
				<TD class="tdUnderLine">&nbsp;</TD>
			</TR>
			
			<cfset ctloop  = ctloop + 1 >
		
		</cfloop>
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctloop)#">
					<TD class="tdUnderLine" colspan="2">&nbsp;</TD>
					<TD class="tdUnderLine">Total <b>U#holdAge#</b> #repeatString("&nbsp;",5)# #ctAge#</TD>
				</TR>
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctloop + 1)#">
			<TD class="tdUnderLine" colspan="2">&nbsp;</TD>
			<TD class="tdUnderLine">#repeatString("&nbsp;",15)# <b>Total Girls Teams:  #ctGirls#</b></TD>
		</TR> 
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctloop + 2)#">
			<TD class="tdUnderLine" colspan="2">&nbsp;</TD>
			<TD class="tdUnderLine">#repeatString("&nbsp;",25)# <b>Total ALL Teams:  #ctTotal#</b></TD>
		</TR> 
	</table>

</CFIF>

				
<!--- <CFIF isDefined("qGetTeamPLayWeeks") AND qGetTeamPLayWeeks.RECORDCOUNT GT 0>
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
		<CFLOOP query="qGetTeamPLayWeeks">
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,recCount)#">
					<td class="tdUnderLine" >#TEAM_ID#</td>
					<td class="tdUnderLine" >#DIVISION#</td>
					<td class="tdUnderLine" >#teamnamederived#</td>
					<td class="tdUnderLine" >#CLUBABBR#</td>
				</tr>
		</CFLOOP>
		<TR><td >&nbsp;</td>
			<td >&nbsp;</td>
			<td align=right>		  <B>Total teams</B></td>
			<td align=center>		  <B>#TotalTeams#</B></td>
			<td colspan=2 align=right><B>Total TBS</B></td>
			<td align=center>		  <B>#reccount#</B></td>
		</TR>
	</table>
</CFIF> --->





	
</cfoutput>
</div>
<cfinclude template="_footer.cfm">
