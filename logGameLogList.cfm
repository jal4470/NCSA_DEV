<!--- 
	FileName:	logGameLogList.cfm
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 

<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<!---<cfinclude template="_checkLogin.cfm"> use? --->
<cfoutput>



<cfif isDefined("FORM.gameId")>
	<cfset gameId = FORM.gameId>	
<cfelseif isDefined("URL.gId") AND isNumeric(URL.GID)>
	<cfset gameId = URL.gId>	
<cfelse>	
	<cfset gameId = "">	
</cfif>


<div id="contentText">
<H1 class="pageheading">NCSA - game logs</H1>



<FORM name="unpaidref" action="logGameLogList.cfm" method="post">
<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
	<tr class="tblHeading">
		<TD colspan="1"> &nbsp;	</TD>
	</tr>
	<tr><TD colspan="1"> 
			<b>Enter Game Number:	</b>
			<input type="Text" name="gameID" value="#gameID#">
			<input type="Submit" name="GetGame" value="Get Game Info">
		</TD>
	</tr>
	<tr><TD colspan="1">
			<hr size="1">
		</TD>
	</tr>
</table>
</form>
<cfif gameId GT 0>
	<h2>For game: #gameID# </h2>
	<cfquery name="gameLog" datasource="#SESSION.DSN#">
		select GAME_LOG_ID, LOGCREATEDATE, LOGCREATEDBY
		  from TBL_GAME_LOG   
		 where game_id = #gameId#   
		 order by logCreateDate DESC
	</cfquery>
	
	<cfquery name="gameCRLog" datasource="#SESSION.DSN#">
		select GAME_CHANGE_REQUEST_LOG_ID, LOG_DATE_TIME, LOG_CREATEDBY
		  from TBL_Game_Change_Request_LOG   
		 where gameid = #gameId#   
		 order by log_date_time DESC
	</cfquery>
	
	<cfquery name="RefRptHdrLog" datasource="#SESSION.DSN#">
		select REFRPT_HDR_LOG_ID, LOGCREATEDATE, LOGCREATEDBY
		  from tbl_refRptHdr_Log   
		 where gameid = #gameId#   
		 order by logCreateDate DESC
	</cfquery>	

	<cfquery name="gameDeleteLog" datasource="#SESSION.DSN#">
		select dt_event_date , event_userid
		  from cpc_gameDeleteLog
		 where game_id = #gameId#   
	</cfquery> 

	<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
		<TR class="tblHeading"><td colspan="4" > Game Logs:  #gameLog.RECORDCOUNT# records</td></TR>
		<TR class="tblHeading">
			<td>&nbsp; &nbsp; </td>
			<td>LOG ID</td>
			<td>LOG CREATE DATE </td>
			<td>LOG CREATED BY </td>
		</TR>
	</table>
	<div style="overflow:auto; height:100px; border:1px ##cccccc solid;">
		<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
		<cfif gameLog.RECORDCOUNT>
			<cfloop query="gameLog">
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
					<td class="tdUnderLine">&nbsp; &nbsp; </td>
					<td class="tdUnderLine"> <a href="logViewDetails.cfm?gid=#gameId#&glid=#GAME_LOG_ID#">#GAME_LOG_ID# </a> </td>
					<td class="tdUnderLine"> <a href="logViewDetails.cfm?gid=#gameId#&glid=#GAME_LOG_ID#">#dateFormat(LOGCREATEDATE, "mm/dd/yy")# #timeFormat(LOGCREATEDATE, "hh:mm tt")#</a> </td>
					<td class="tdUnderLine"> #LOGCREATEDBY# </td>
				</TR>
			</cfloop>
		<cfelse>
			<tr><td colspan="4">&nbsp; &nbsp; There are no Game Log records for game: #gameId#</td>
			</TR>
		</cfif>
		<tr><td colspan="4">&nbsp; &nbsp; </td>
		</TR>
		</table>
	</div>	
 <br>

	<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
		<TR class="tblHeading"><td colspan="4" > Game Delete Log:  #gameDeleteLog.RECORDCOUNT# records</td></TR>
		<TR class="tblHeading">
			<td>&nbsp; &nbsp; </td>
			<td>&nbsp; </td>
			<td>LOG CREATE DATE </td>
			<td>LOG CREATED BY </td>
		</TR>
	</table>
	<div style="overflow:auto; height:100px; border:1px ##cccccc solid;">
		<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
		<cfif gameDeleteLog.RECORDCOUNT>
			<cfloop query="gameDeleteLog">
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
					<td class="tdUnderLine">&nbsp; &nbsp; </td>
					<td class="tdUnderLine"> <a href="logViewDetails.cfm?gid=#gameId#&gdel=#gameId#">#GAMEID# </a> </td>
					<td class="tdUnderLine"> <a href="logViewDetails.cfm?gid=#gameId#&gdel=#gameId#">#dateFormat(dt_event_date, "mm/dd/yy")# #timeFormat(dt_event_date, "hh:mm tt")#</a> </td>
					<td class="tdUnderLine"> #event_userid# </td>
				</TR>
			</cfloop>
		<cfelse>
			<tr><td colspan="4">&nbsp; &nbsp; There are no Game Delete Log records for game: #gameId#</td>
			</TR>
		</cfif>
		<tr><td colspan="4">&nbsp; &nbsp; </td>
		</TR>
		</table>
	</div>	
 <br>

	<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
		<TR class="tblHeading"><td colspan="4" >Game Change Request Logs: #gameCRLog.RECORDCOUNT# records</td></TR>
		<TR class="tblHeading">
			<td>&nbsp; &nbsp; </td>
			<td>LOG ID</td>
			<td>LOG CREATE DATE </td>
			<td>LOG CREATED BY </td>
		</TR>
	</table>
	<div style="overflow:auto; height:100px; border:1px ##cccccc solid;">
		<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
		<cfif gameCRLog.RECORDCOUNT>
			<cfloop query="gameCRLog">
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
					<td class="tdUnderLine">&nbsp; &nbsp; </td>
					<td class="tdUnderLine"> <a href="logViewDetails.cfm?gid=#gameId#&gcrlid=#GAME_CHANGE_REQUEST_LOG_ID#">#GAME_CHANGE_REQUEST_LOG_ID#</a> </td>
					<td class="tdUnderLine"> <a href="logViewDetails.cfm?gid=#gameId#&gcrlid=#GAME_CHANGE_REQUEST_LOG_ID#">#dateFormat(LOG_DATE_TIME, "mm/dd/yy")# #timeFormat(LOG_DATE_TIME, "hh:mm tt")#</a> </td>
					<td class="tdUnderLine"> #LOG_CREATEDBY# </td>
				</TR>
			</cfloop>
		<cfelse>
			<tr><td colspan="4">&nbsp; &nbsp; There are no Game Change Request Log records for game: #gameId#</td>
			</TR>
		</cfif>
		<tr><td colspan="4">&nbsp; &nbsp; </td>
		</TR>
		</table>
	</div>	
 <br>

	<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
		<TR class="tblHeading"><td colspan="4" >Referee Report Header Logs: #RefRptHdrLog.RECORDCOUNT# records</td></TR>
		<TR class="tblHeading">
			<td>&nbsp; &nbsp; </td>
			<td>LOG ID</td>
			<td>LOG CREATE DATE </td>
			<td>LOG CREATED BY </td>
		</TR>
	</table>
	<div style="overflow:auto; height:100px; border:1px ##cccccc solid;">
		<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
		<cfif RefRptHdrLog.RECORDCOUNT>
			<cfloop query="RefRptHdrLog">
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
					<td class="tdUnderLine">&nbsp; &nbsp; </td>
					<td class="tdUnderLine"> <a href="logViewDetails.cfm?gid=#gameId#&rrhid=#REFRPT_HDR_LOG_ID#">#REFRPT_HDR_LOG_ID#</a> </td>
					<td class="tdUnderLine"> <a href="logViewDetails.cfm?gid=#gameId#&rrhid=#REFRPT_HDR_LOG_ID#">#dateFormat(LOGCREATEDATE, "mm/dd/yy")# #timeFormat(LOGCREATEDATE, "hh:mm tt")#</a> </td>
					<td class="tdUnderLine"> #LOGCREATEDBY# </td>
				</TR>
			</cfloop>
		<cfelse>
			<tr><td colspan="4">&nbsp; &nbsp; There are no Referee Report Log records for game: #gameId#</td>
			</TR>
		</cfif>
		<tr><td colspan="4">&nbsp; &nbsp; </td>
		</TR>
		</table>
	</div>	

</cfif>



 



</cfoutput>
 </div> 
<cfinclude template="_footer.cfm">
