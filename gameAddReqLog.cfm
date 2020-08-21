<!--- 
	FileName:	gameAddReqLog.cfm
	Created on: 01/20/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
03/06/09 - aarnone - ticket:7309 - virtual team changes for state cup and non league games

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm"> 
<cfoutput>

<div id="contentText">
<H1 class="pageheading">NCSA - Added Game Request Log</H1>
<!--- <br> <h2>yyyyyy </h2> --->

<CFQUERY name="qGetGamesReqquested" datasource="#SESSION.DSN#">
	select gnr.game_request_ID, gnr.season_ID,    gnr.gameDate, 
		   gnr.gameTime,        gnr.game_ID,	 gnr.gameType,
		   gnr.FieldID,        gnr.HomeTeam_ID,  gnr.VisitorTeam_ID,
		   gnr.requestDate,    gnr.requestTime,  gnr.createdBy,
		   gnr.Approved_YN,    gnr.ApprovedDate, gnr.ApprovedTime,
		   gnr.Reject_comments,
		   gnr.virtual_VisitorTeamName,
		   dbo.GetTeamName(VT.team_id) as VTname,
		   dbo.GetTeamName(HT.team_id) as HTname,
		   (SELECT CLUB_ID  FROM TBL_TEAM WHERE TEAM_ID = VT.team_id) AS Visitor_CLUB_ID,
		   (SELECT CLUB_ID  FROM TBL_TEAM WHERE TEAM_ID = HT.team_id) AS Home_CLUB_ID,
		   F.FIELDNAME 
	  FROM TBL_GAME_NEW_REQUEST gnr 
				LEFT OUTER JOIN tbl_field F  ON F.field_id = gnr.fieldid 
					 INNER JOIN TBL_Team  HT ON HT.TEAM_ID = gnr.HomeTeam_ID
					 INNER JOIN TBL_Team  VT ON VT.TEAM_ID = gnr.VisitorTeam_ID
	 WHERE gnr.SEASON_ID = <cfqueryParam cfsqltype="CF_SQL_NUMERIC" value="#SESSION.CURRENTSEASON.ID#">   
	   AND (HT.CLUB_ID   = <cfqueryParam cfsqltype="CF_SQL_NUMERIC" value="#SESSION.USER.CLUBID#">   
			 OR 
			VT.CLUB_ID   = <cfqueryParam cfsqltype="CF_SQL_NUMERIC" value="#SESSION.USER.CLUBID#">   
			)
	ORDER BY gameDate, gameTime
</CFQUERY>



<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
	<tr><TD colspan="7">
			<span class="red"><b>NOTE!</b> For </span>
			<span class="green"><b>APPROVED</b></span>
			<span class="red"> game requests, check schedule for any date/time/field changes</span>
		</TD>
	</tr>
	<tr class="tblHeading">
		<TD>Game Id</TD>
		<TD>Game <br> Date</TD>
		<TD>Game <br> Time</TD>
		<TD>Field</TD>
		<TD>Home Team</TD>
		<TD>Visiting Team</TD>
		<TD>Approval <br> Status</TD>
	</tr>
	<CFLOOP query="qGetGamesReqquested">
		<CFIF len(trim(Reject_comments))>
			<cfset tdUnder = "">
		<CFELSE>
			<cfset tdUnder = "class='tdUnderLine'">
		</CFIF>
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> <!--- currentRow or counter --->
			<TD #tdUnder# ><cfif len(trim(game_id))>#game_ID#<cfelse>n/a</cfif></TD>
			<TD #tdUnder# >#dateFormat(gameDate,"mm/dd/yyyy")#</TD>
			<TD #tdUnder# >#timeFormat(gameTime,"hh:mm tt")#</TD>
			<TD #tdUnder# >#FIELDNAME#</TD>
			<TD #tdUnder# >#HTname#</TD>
			<TD #tdUnder# >
				<CFIF len(trim(VTname))>
					#VTname#
				<CFELSEIF len(trim(virtual_VisitorTeamName))>
					<span class="red">
						<cfswitch expression="#ucase(gameType)#">
							<cfcase value="N">NL </cfcase>
							<cfcase value="C">SC </cfcase>
							<cfdefaultcase>&nbsp;</cfdefaultcase>
						</cfswitch>
					</span>
					#virtual_VisitorTeamName#
				<CFELSE>
					&nbsp;
				</CFIF>
			</TD>
			<TD #tdUnder# >
				<cfswitch expression="#Approved_YN#">
					<cfcase value="Y"><span class="green">Approved</span></cfcase>
					<cfcase value="N"><span class="red">Rejected</span></cfcase>
					<cfdefaultcase>Pending</cfdefaultcase>
				</cfswitch>
			</TD>
		</tr>
		<CFIF len(trim(Reject_comments))>
			<tr><td class='tdUnderLine' colspan="3"> &nbsp; </td>
				<td class='tdUnderLine' colspan="4"> Rejection Comment: #Reject_comments# </td>
			</tr>
		</CFIF>
	</CFLOOP>
	<tr><TD colspan="7">
			<span class="red"><b>NOTE!</b> For </span>
			<span class="green"><b>APPROVED</b></span>
			<span class="red"> game requests, check schedule for any date/time/field changes</span>
		</TD>
	</tr>


</table>	


</cfoutput>
</div>
<cfinclude template="_footer.cfm">
