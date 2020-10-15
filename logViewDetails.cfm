<!--- 
	FileName:	homesite+\html\Default Template.htm
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">  
<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Log viewer</H1>

<cfif isDefined("URL.glid") AND isNumeric(URL.glid)>
	<cfset pTitle = "Game Log">
	<cfset logID = URL.glid >
<cfelseif isDefined("URL.gcrlid") AND isNumeric(URL.gcrlid)>
	<cfset pTitle = "Game Change Request Log">
	<cfset logID = URL.gcrlid>
<cfelseif isDefined("URL.rrhid") AND isNumeric(URL.rrhid)>
	<cfset pTitle = "Referee Report Header Log">
	<cfset logID  = URL.rrhid>
<cfelseif isDefined("URL.gdel") AND isNumeric(URL.gdel)>
	<cfset pTitle = "Game Delete Log">
	<cfset logID  = URL.gdel>
</cfif>

<cfif isDefined("URL.gid") AND isNumeric(URL.gid)>
	<cfset gameID = URL.gid>
<cfelse>
	<cfset gameID = 0>
</cfif>




<h2>#pTitle#</h2>
<table cellspacing="0" cellpadding="2" align="center" border="0" width="95%">
	<tr class="tblHeading">
		<TD align="left"> Log ID - #VARIABLES.logID#</TD>
		<TD align="right"> &nbsp; </TD>
		<TD align="right"> <a href="logGameLogList.cfm?gid=#gameID#">BACK</a> </TD>
	</tr>

<!--- ======================================================================================================= --->
<cfif isDefined("URL.glid") AND isNumeric(URL.glid)>
	<cfquery name="gameLog" datasource="#SESSION.DSN#">
		select 	GAME_LOG_ID, GAME_ID, GAME_CODE, SEASON_ID, SEASON_NAME,
				GAME_DATE, GAME_TIME, ORIGINAL_GAMEDATE, ORIGINAL_GAMETIME,
				GAME_TYPE, FIELDABBR, FIELDSTATUS, FIELD_ID, FIELD_NAME,
				DIVISION, DIVISION_ID, 
				HOME_CLUB_ID,    HOME_CLUB_NAME,    HOME_TEAM_ID,    HOME_TEAM_NAME, 
				VISITOR_CLUB_ID, VISITOR_CLUB_NAME, VISITOR_TEAM_ID, VISITOR_TEAM_NAME,  
				SCOREOVERRIDE, SCORE_HOME, SCORE_VISITOR, DELAYEDENTRY_HOME, DELAYEDENTRY_VISITOR, 
				FORFEIT_HOME,  FORFEIT_VISITOR, 
				REFNOSHOW, REFPAID_YN, REFREPORTSBM_YN, 
				REF_CONTACT_ID,	     REF_FIRSTNAME,		 REF_LASTNAME,		REF_ACCEPT_DATE, 
				ASSTREF1_CONTACT_ID, ASSTREF1_FIRSTNAME, ASSTREF1_LASTNAME, ASSTREF1_ACCEPT_DATE, 
				ASSTREF2_CONTACT_ID, ASSTREF2_FIRSTNAME, ASSTREF2_LASTNAME, ASSTREF2_ACCEPT_DATE, 
				COMMENTS, GAMESCHAIRCOMMENTS,
				CREATEDATE, CREATEDBY, CREATEDFROMPAGE, LOGCREATEDATE, LOGCREATEDBY, UPDATEDATE, UPDATEDBY , GAME_DAY_DOCUMENT
		  from  TBL_GAME_LOG   
		 where  GAME_LOG_ID = #VARIABLES.logID#   
	</cfquery>

		<tr><TD class="tdUnderLine" align="right"><b>Game Log ID:</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp; #gameLog.GAME_LOG_ID#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>

		<tr><TD class="tdUnderLine" align="right"><b>Game ID:</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameLog.GAME_ID#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"></TD>
			<TD class="tdUnderLine" align="left"> &nbsp; <a href="ViewGameDayViaLog.cfm?game_log_id=#gameLog.GAME_LOG_ID#" target="_tab">Game Day Document</a></TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Game Code:</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameLog.GAME_CODE#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Season ID/Name:</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameLog.SEASON_ID#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameLog.SEASON_NAME# </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Game Date/Time:</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp; #dateFormat(gameLog.GAME_DATE,"m/dd/yyyy")# #timeFormat(gameLog.GAME_TIME,"h:mm tt")#<!---  #gameLog.GAME_DATE# ---></TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>original Game Date/Time:</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #dateFormat(gameLog.ORIGINAL_GAMEDATE,"m/dd/yyyy")# #timeFormat(gameLog.ORIGINAL_GAMETIME,"h:mm tt")#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Game Type:</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameLog.GAME_TYPE#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Field Abbrv:</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameLog.FIELDABBR#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Field Status:</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameLog.FIELDSTATUS#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Field ID:</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameLog.FIELD_ID#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Field Name:</b> </TD>
			<TD class="tdUnderLine" align="left">#gameLog.FIELD_NAME#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Division:</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameLog.DIVISION#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Division id:</b></TD>
			<TD class="tdUnderLine" align="left"> #gameLog.DIVISION_ID#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Home Club ID/Name:</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameLog.HOME_CLUB_ID#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameLog.HOME_CLUB_NAME#</TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Home Team ID/Name:</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameLog.HOME_TEAM_ID#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; #gameLog.HOME_TEAM_NAME#</TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Visitor Club ID/Name:</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameLog.VISITOR_CLUB_ID#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameLog.VISITOR_CLUB_NAME#</TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Visitor Team ID/Name:</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameLog.VISITOR_TEAM_ID#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameLog.VISITOR_TEAM_NAME#</TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Score Override:</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameLog.SCOREOVERRIDE#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Score Home:</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameLog.SCORE_HOME#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Score Visitor:</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameLog.SCORE_VISITOR#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Delayed Entry Home:</b></TD>
			<TD class="tdUnderLine" align="left"> #gameLog.DELAYEDENTRY_HOME#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Delayed Entry Visitor:</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameLog.DELAYEDENTRY_VISITOR#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Forfeit Home:</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameLog.FORFEIT_HOME#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Forfeit Visitor:</b></TD>
			<TD class="tdUnderLine" align="left"> #gameLog.FORFEIT_VISITOR#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Ref No Show:</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameLog.REFNOSHOW#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Ref Paid:</b></TD>
			<TD class="tdUnderLine" align="left"> #gameLog.REFPAID_YN#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Ref report submitted:</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameLog.REFREPORTSBM_YN#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Ref ID:</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameLog.REF_CONTACT_ID#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameLog.REF_FirstName# #gameLog.REF_LastNAme#</TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Ref Accept Date:</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #dateformat(gameLog.REF_ACCEPT_DATE,"m/d/yyyy")#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>AR1 ID:</b></TD>
			<TD class="tdUnderLine" align="left"> #gameLog.ASSTREF1_CONTACT_ID#</TD>
			<TD class="tdUnderLine" align="left"> #gameLog.ASSTREF1_FirstName# #gameLog.ASSTREF1_LastNAme# </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>AR1 Accept Date:</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #dateformat(gameLog.ASSTREF1_ACCEPT_DATE,"m/d/yyyy")#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>AR2 ID:</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameLog.ASSTREF2_CONTACT_ID#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameLog.ASSTREF2_FirstName# #gameLog.ASSTREF2_LastNAme# </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>AR2 Accept Date:</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #dateformat(gameLog.ASSTREF2_ACCEPT_DATE,"m/d/yyyy")#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Comments:</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameLog.COMMENTS#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Game ChairComments:</b></TD>
			<TD class="tdUnderLine" align="left"> #gameLog.GAMESCHAIRCOMMENTS#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Create Date:</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp; #dateformat(gameLog.CREATEDATE,"m/dd/yyyy")#&nbsp;&nbsp;&nbsp;#timeformat(gameLog.CREATEDATE,"h:mm:ss tt")#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Created By:</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameLog.CREATEDBY#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Created From:</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameLog.CREATEDFROMPAGE#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Updated Date:</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #dateformat(gameLog.UPDATEDATE,"m/dd/yyyy")#&nbsp;&nbsp;&nbsp;#timeformat(gameLog.UPDATEDATE,"h:mm:ss tt")#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Updated By:</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameLog.UPDATEDBY#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Log Create Date:</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #dateformat(gameLog.LOGCREATEDATE,"m/dd/yyyy")#&nbsp;&nbsp;&nbsp;#timeformat(gameLog.LOGCREATEDATE,"h:mm:ss tt")#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"> Create By:</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameLog.LOGCREATEDBY#
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>	
</cfif>


<!--- ======================================================================================================= --->

<cfif isDefined("URL.gcrlid") AND isNumeric(URL.gcrlid)>
	<cfquery name="gameCRLog" datasource="#SESSION.DSN#">
		select  GAME_CHANGE_REQUEST_LOG_ID, GAME_CHANGE_REQUEST_ID, GAMEID, 
				NEWDATE, NEWTIME, NEWFIELD, NEWFIELDABBR, NEWFIELDNAME,
				REQUESTDATE, REQUESTTIME, REQUESTEDBYTEAM, REQUESTEDBYTEAMNAME, 
				ACCEPTEDBYVISITOR, ACCEPTEDDATE, ACCEPTEDTIME, 
				ADMINFEES, 
				APPROVED, APPROVEDDATE, APPROVEDTIME, 
				COMMENTS, REFCOMMENTS,  GAMESCHAIRCOMMENTS,  
				FINE_ID, 
				CREATEDATE, CREATEDBY, 
				UPDATEDATE, UPDATEDBY,
				LOG_CREATEDBY, LOG_DATE_TIME 
		  from  TBL_Game_Change_Request_LOG   
		 where  GAME_CHANGE_REQUEST_LOG_ID = #logID#   
	</cfquery>

		<tr><TD class="tdUnderLine" align="right"><b>Game Change Request Log ID</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameCRLog.GAME_CHANGE_REQUEST_LOG_ID#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Game Cchange Request ID</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameCRLog.GAME_CHANGE_REQUEST_ID#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>GameID</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameCRLog.GAMEID#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>New DATE/TIME</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp; #dateFormat(gameCRLog.NEWDATE,"mm/dd/yyyy")# #timeFormat(gameCRLog.NEWTIME,"hh:mm tt")#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>New FIELD ID <br>  Abbr <br> Name </b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameCRLog.NEWFIELD# <br> #gameCRLog.NEWFIELDABBR# <br> #gameCRLog.NEWFIELDNAME#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>REQUEST DATE/TIME</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #dateFormat(gameCRLog.REQUESTDATE,"mm/dd/yyyy")# #timeFormat(gameCRLog.REQUESTTIME,"hh:mm tt")#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>REQUESTED BY TEAM</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameCRLog.REQUESTEDBYTEAM#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameCRLog.REQUESTEDBYTEAMNAME#</TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>ACCEPTED BY VISITOR</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameCRLog.ACCEPTEDBYVISITOR#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>ACCEPTED DATE/TIME</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #dateFormat(gameCRLog.ACCEPTEDDATE,"mm/dd/yyyy")# #timeFormat(gameCRLog.ACCEPTEDTIME,"hh:mm tt")#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD></TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>ADMIN FEES</b></TD>
			<TD class="tdUnderLine" align="left"> #gameCRLog.ADMINFEES#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>APPROVED</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameCRLog.APPROVED#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>APPROVED DATE/TIME</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #dateFormat(gameCRLog.APPROVEDDATE,"mm/dd/yyyy")# #timeFormat(gameCRLog.APPROVEDTIME,"hh:mm tt")#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>COMMENTS</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameCRLog.COMMENTS#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>REF COMMENTS</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameCRLog.REFCOMMENTS#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>GAMES CHAIR COMMENTS</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameCRLog.GAMESCHAIRCOMMENTS#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>FINE ID</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameCRLog.FINE_ID#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>CREATE DATE</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #dateformat(gameCRLog.CREATEDATE, "m/d/yyyy")# #timeformat(gameCRLog.createdate,"h:mm tt")#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>CREATED BY</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameCRLog.CREATEDBY#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>UPDATE DATE</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #dateformat(gameCRLog.UPDATEDATE,"m/d/yyyy")# #timeformat(gameCRLog.updatedate,"h:mm tt")#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>UPDATED BY</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameCRLog.UPDATEDBY#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>LOG CREATED BY</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #gameCRLog.LOG_CREATEDBY#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>LOG DATE TIME</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #dateformat(gameCRLog.LOG_DATE_TIME,"m/d/yyyy")# #timeformat(gameCRLog.log_date_time, "h:mm tt")#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
</cfif>



<!--- ======================================================================================================= --->
<cfif isDefined("URL.rrhid") AND isNumeric(URL.rrhid)>
	<cfquery name="RefRptHdrLog" datasource="#SESSION.DSN#">
		select  REFRPT_HDR_LOG_ID, REFEREE_RPT_HEADER_ID, GAMEID, GAMESTS, WEATHER,
				STARTTIME, ENDTIME, HOWLATE_HOME, HOWLATE_VISITOR, ISONTIME_HOME, ISONTIME_VISITOR, 
				HALFTIMESCORE_HOME, HALFTIMESCORE_VISITOR,
				FULLTIMESCORE_HOME, FULLTIMESCORE_VISITOR,
				LINEUP_HOME, LINEUP_VISITOR,
				PASSES_HOME, PASSES_VISITOR,
				FIELDCOND, FIELDMARKING, SPECTATORCOUNT,	
				CONTACT_ID_REFEREE,  Referee_FirstName,  Referee_LastName,  REFPAID_AMOUNT,   REFPAID_DATE,   REFPAID_YN,
				CONTACT_ID_ASSTREF1, AsstRef1_FirstName, AsstRef1_LastName, AREF1PAID_AMOUNT, AREF1PAID_DATE, AREF1PAID_YN, 
				CONTACT_ID_ASSTREF2, AsstRef2_FirstName, AsstRef2_LastName, AREF2PAID_AMOUNT, AREF2PAID_DATE, AREF2PAID_YN, 
				ASSISTANTREF1_WRITEIN, ASSISTANTREF2_WRITEIN, 
				COMMENTS, CONDUCTOFFICIALS, CONDUCTPLAYERS, CONDUCTSPECTATORS,
				CONTACT_ID_OFFICIAL4TH,  OFFICIAL4THLOG,
				PLAYERDROOM, REFEREEDROOM,
				CREATEDATE, CREATEDBY, CREATEDFROMPAGE, UPDATEDATE, UPDATEDBY,
				LOGCREATEDATE, LOGCREATEDBY 
		  from tbl_refRptHdr_Log   
		 where REFRPT_HDR_LOG_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#logId#">   
	</cfquery>	

		
		<tr><TD class="tdUnderLine" align="right"><b>Referee Report Header Log ID</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.REFRPT_HDR_LOG_ID#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Referee Report Header ID</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.REFEREE_RPT_HEADER_ID#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Game ID</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.GAMEID#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Game Status</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.GAMESTS#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Weather</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.WEATHER#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Start Time</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #timeFormat(RefRptHdrLog.STARTTIME, "hh:mm tt")#</TD>
			<TD class="tdUnderLine" align="right"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>End Time</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #timeFormat(RefRptHdrLog.ENDTIME, "hh:mm tt")#</TD>
			<TD class="tdUnderLine" align="right"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>How Late Home</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.HOWLATE_HOME#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>How Late Visitor</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.HOWLATE_VISITOR#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Is on time Home</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.ISONTIME_HOME#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Is on tome Visitor</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.ISONTIME_VISITOR#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Half time score Home</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.HALFTIMESCORE_HOME#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Half time score Visitor</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.HALFTIMESCORE_VISITOR#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Full time score Home</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.FULLTIMESCORE_HOME#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Full time score Visitor </b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.FULLTIMESCORE_VISITOR#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Line up Home</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.LINEUP_HOME#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Line up Visitor</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.LINEUP_VISITOR#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Passes Home</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.PASSES_HOME#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Passes Visitor</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.PASSES_VISITOR#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Field Condition</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.FIELDCOND#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Field Marking</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.FIELDMARKING#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Sectator Count</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.SPECTATORCOUNT#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Referee id</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.CONTACT_ID_REFEREE#</TD>
			<TD class="tdUnderLine" align="right"> &nbsp; #RefRptHdrLog.Referee_FirstName# #RefRptHdrLog.Referee_LastName#</TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Referee Paid Amount</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.REFPAID_AMOUNT#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Referee Paid Date</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #dateformat(RefRptHdrLog.REFPAID_DATE, "m/d/yyyy")#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Referee PAid YN</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.REFPAID_YN#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Asst. Referee 1 id</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.CONTACT_ID_ASSTREF1#</TD>
			<TD class="tdUnderLine" align="right"> &nbsp; #RefRptHdrLog.AsstRef1_FirstName# #RefRptHdrLog.AsstRef1_LastName#</TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Asst. Referee 1 paid amount</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.AREF1PAID_AMOUNT#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Asst. Referee 1 Paid Date</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #dateformat(RefRptHdrLog.AREF1PAID_DATE, "m/d/yyyy")#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Asst. Referee 1 Paid YN</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.AREF1PAID_YN#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Asst. Referee 2 id</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.CONTACT_ID_ASSTREF2#</TD>
			<TD class="tdUnderLine" align="right"> &nbsp; #RefRptHdrLog.AsstRef2_FirstName# #RefRptHdrLog.AsstRef2_LastName#</TD></TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Asst. Referee 2 paid amount</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.AREF2PAID_AMOUNT#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Asst. Referee 2 Paid Date</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #dateformat(RefRptHdrLog.AREF2PAID_DATE, "m/d/yyyy")#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Asst. Referee 2 Paid YN</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.AREF2PAID_YN#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Asst. Referee 1 Write IN</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.ASSISTANTREF1_WRITEIN#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Asst. Referee 2 Write IN</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.ASSISTANTREF2_WRITEIN#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Comments</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.COMMENTS#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Conduct Official</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.CONDUCTOFFICIALS#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Conduct Players</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.CONDUCTPLAYERS#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Conduct Spectators</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.CONDUCTSPECTATORS#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>4th Official ID</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.CONTACT_ID_OFFICIAL4TH#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>4th Official Log</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.OFFICIAL4THLOG#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Player D room</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.PLAYERDROOM#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Referee D room</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.REFEREEDROOM#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Create Date</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #dateformat(RefRptHdrLog.CREATEDATE, "m/d/yyyy")# #timeformat(RefRptHdrLog.CREATEDATE, "h:mm tt")#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Created By</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.CREATEDBY#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Created From Page</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.CREATEDFROMPAGE#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Update Date</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #dateformat(RefRptHdrLog.UPDATEDATE, "m/d/yyyy")# #timeformat(RefRptHdrLog.UPDATEDATE, "h:mm tt")#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Update BY</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.UPDATEDBY#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Log Create Date</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #dateformat(RefRptHdrLog.LOGCREATEDATE, "m/d/yyyy")# #timeformat(RefRptHdrLog.LOGCREATEDATE, "h:mm tt")#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>Log Created By</b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp;  #RefRptHdrLog.LOGCREATEDBY#</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
</cfif>


<!--- ======================================================================================================= --->
<cfif isDefined("URL.gdel") AND isNumeric(URL.gdel)>
	<cfquery name="gameDeleteLog" datasource="#SESSION.DSN#">
		select game_id, dt_event_date, event_userid, event_ip_address, event_url, event_post_data, event_sql 
		  from cpc_gameDeleteLog
		 where game_id = #gameId#   
	</cfquery> 
			
		<tr><TD class="tdUnderLine" align="right"> <b>game_id </b></TD>
			<TD class="tdUnderLine" align="left" colspan="2"> &nbsp; #gameDeleteLog.game_id#</TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>dt_event_date </b></TD>
			<TD class="tdUnderLine" align="left" colspan="2"> &nbsp; #dateformat(gameDeleteLog.dt_event_date,"m/d/yyyy")#</TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>event_userid </b></TD>
			<TD class="tdUnderLine" align="left" colspan="2"> &nbsp; #gameDeleteLog.event_userid#</TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>event_ip_address </b></TD>
			<TD class="tdUnderLine" align="left" colspan="2"> &nbsp; #gameDeleteLog.event_ip_address#</TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>event_url </b></TD>
			<TD class="tdUnderLine" align="left" colspan="2"> &nbsp; #gameDeleteLog.event_url#</TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>event_sql </b></TD>
			<TD class="tdUnderLine" align="left" colspan="2"> &nbsp; #gameDeleteLog.event_sql#</TD>
		</tr>
		<tr><TD class="tdUnderLine" align="right"><b>event_post_data: </b></TD>
			<TD class="tdUnderLine" align="left"> &nbsp; listed below</TD>
			<TD class="tdUnderLine" align="left"> &nbsp; </TD>
		</tr>
	<CFLOOP list="#gameDeleteLog.event_post_data#" delimiters="||" index="iL">
		<tr><TD class="tdUnderLine" align="left"> &nbsp; </TD>
			<TD class="tdUnderLine" align="right"><b>#listFirst(il,"::")#</b></TD>
			<TD class="tdUnderLine" align="left">&nbsp; #listLast(il,"::")#</TD>
		</tr>
	</CFLOOP>
	
	
	
</cfif>


</table>
	
 
 
 
 
</cfoutput>
</div>
<cfinclude template="_footer.cfm">
