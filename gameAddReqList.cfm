<!--- 
	FileName:	gameAddReqList.cfm
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
<H1 class="pageheading">NCSA - Added Game Requests </H1>
<br> <!--- <h2>yyyyyy </h2> --->

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
		   F.FIELDNAME, C.FirstName, c.LastName
	  FROM TBL_GAME_NEW_REQUEST gnr 
				LEFT OUTER JOIN tbl_field F  ON F.field_id = gnr.fieldid 
					 INNER JOIN TBL_Team  HT ON HT.TEAM_ID = gnr.HomeTeam_ID
					 INNER JOIN TBL_Team  VT ON VT.TEAM_ID = gnr.VisitorTeam_ID
					 INNER JOIN TBL_CONTACT C ON C.CONTACT_ID = gnr.createdBy
	 WHERE gnr.SEASON_ID = <cfqueryParam cfsqltype="CF_SQL_NUMERIC" value="#SESSION.CURRENTSEASON.ID#">   
	ORDER BY gnr.requestDate,    gnr.requestTime
</CFQUERY>

<cfquery name="qGetPending" dbtype="query">
	SELECT * 
	  FROM qGetGamesReqquested
	 WHERE Approved_YN IS NULL
</cfquery>

<cfquery name="qGetApproved" dbtype="query">
	SELECT * 
	  FROM qGetGamesReqquested
	 WHERE Approved_YN = 'Y'
</cfquery>

<cfquery name="qGetRejected" dbtype="query">
	SELECT * 
	  FROM qGetGamesReqquested
	 WHERE Approved_YN = 'N'
</cfquery>


<cfset divHeight = 450>
<cfset ctShowBoxes = 0>
<cfif qGetPending.recordcount GT 0>  
	<cfset ctShowBoxes = ctShowBoxes + 1> 
</cfif>
<cfif qGetApproved.recordcount GT 0> 
	<cfset ctShowBoxes = ctShowBoxes + 1> 
</cfif>
<cfif qGetRejected.recordcount GT 0> 
	<cfset ctShowBoxes = ctShowBoxes + 1> 
</cfif>
<cfif ctShowBoxes GT 0>
	<CFSET divHeight = 450/ctShowBoxes>
</cfif>


<span class="red">Click on "Pending" to process request.</span>
<cfloop list="qGetPending,qGetApproved,qGetRejected" index="iQry">
	<cfswitch expression="#iQry#">
		<cfcase value="qGetPending"> 
			<cfset title = "Pending" >
			<cfset ctRow = qGetPending.recordcount>
		</cfcase>
		<cfcase value="qGetApproved"> 
			<cfset title = "Approved" > 
			<cfset ctRow = qGetApproved.recordcount>
		</cfcase>
		<cfcase value="qGetRejected"> 
			<cfset title = "Rejected" > 
			<cfset ctRow = qGetRejected.recordcount>
		</cfcase>
		<cfdefaultcase> 
			<cfset title = "" > 
			<cfset ctRow = 0>
		</cfdefaultcase>
	</cfswitch>
	
	<cfif ctRow GT 0>
		<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
			<tr class="tblHeading">
				<TD colspan="7">
					Total #ucase(title)# game requests: #ctRow#
				 	<cfif UCASE(title) EQ "APPROVED">
						(the game number will appear beneath the status)
					</cfif>
				</TD>
			</tr>
			<tr class="tblHeading">
				<TD valign="bottom" width="10%">Status</TD>
				<TD valign="bottom" width="10%">Requested<br> on </TD>
				<TD valign="bottom" width="10%">Requested<br> by </TD>
				<TD valign="bottom" width="10%">Game<br> Date/Time</TD>
				<TD valign="bottom" width="20%">Home Team</TD>
				<TD valign="bottom" width="20%">Visiting Team</TD>
				<TD valign="bottom" width="20%">Field</TD>
			</tr>
		</table>
		<CFIF ctRow GT 4>
			<div  style="vertical-align:top;overflow:auto;height:#divHeight#px;border:1px ##cccccc solid;">
		</CFIF>
		<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
			<CFLOOP query="#iQry#">
				<CFIF len(trim(Reject_comments))>
					<cfset tdUnder = "">
				<CFELSE>
					<cfset tdUnder = "class='tdUnderLine'">
				</CFIF>
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> <!--- currentRow or counter --->
					<TD #tdUnder# valign="top" width="10%">
						<cfswitch expression="#Approved_YN#">
							<cfcase value="Y"><span class="green">Approved</span></cfcase>
							<cfcase value="N"><span class="red">Rejected</span></cfcase>
							<cfdefaultcase><a href="gameAddRequestProcess.cfm?grid=#game_request_ID#">Pending</a></cfdefaultcase>
						</cfswitch>
						<cfif len(trim(GAME_ID))>
							<br> #GAME_ID#
						</cfif>
					</TD>
					<TD #tdUnder# valign="top" width="10%">#dateFormat(requestDate,"mm/dd/yyyy")# <br> #timeFormat(requestTime,"hh:mm tt")#</TD>
					<TD #tdUnder# valign="top" width="10%">#FirstName# #LastName#</TD>
					<TD #tdUnder# valign="top" width="10%">#dateFormat(gameDate,"mm/dd/yyyy")# <br>  #timeFormat(gameTime,"hh:mm tt")#</TD>
					<TD #tdUnder# valign="top" width="20%">#HTname#</TD>
					<TD #tdUnder# valign="top" width="20%"><!--- #VTname# --->
						<cfswitch expression="#ucase(trim(gameType))#">
							<cfcase value="N"><span class="red">NL</span></cfcase>
							<cfcase value="C"><span class="red">SC</span></cfcase>
							<cfcase value="F"><span class="red">Fr</span></cfcase>
							<cfdefaultcase>&nbsp; &nbsp;</cfdefaultcase>
						</cfswitch>
						<CFIF len(trim(VTname))>
							#VTname#
						<CFELSEIF len(trim(virtual_VisitorTeamName))>
							#virtual_VisitorTeamName#
						<CFELSE>
							&nbsp;
						</CFIF>
					</TD>
					<TD #tdUnder# valign="top" width="20%">#FIELDNAME#</TD>
				</tr>
				<CFIF len(trim(Reject_comments))>
					<tr><td class='tdUnderLine' colspan="4"> &nbsp; </td>
						<td class='tdUnderLine' colspan="3"> <b>Rejection Comments:</b> #Reject_comments# </td>
					</tr>
				</CFIF>
			</CFLOOP>
		</table>
		<CFIF ctRow GT 4>
			</div>
		</CFIF>
	<cfelse>
			<!--- <br> <br> No game requests found for status: <b>#title#</b> 
			<br> --->
			<div> No game requests found for status: <b>#title#</b> 
			</div>
	</CFIF> 

</cfloop>




</cfoutput>
</div>
<cfinclude template="_footer.cfm">
