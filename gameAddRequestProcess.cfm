<!--- 
	FileName:	gameAddRequestProcess.cfm
	Created on: 01/20/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
03/06/09 - aarnone - ticket:7309 - virtual team changes for state cup and non league games
04/14/09 - aarnone - 7403 finished page need to test
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm"> 
<script language="JavaScript" src="DatePicker.js"></script> 
<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Process Added Game Request</H1>
<!--- <h2>yyyyyy </h2> --->
<br>

<cfset msg = "">
<cfset GameID = 0>


<CFIF isDefined("URL.grid") AND isNumeric(URL.grid)>
	<CFSET gameReqID = URL.grid>
<CFELSEIF isDefined("FORM.gameReqID") AND isNumeric(FORM.gameReqID)>
	<CFSET gameReqID = FORM.gameReqID>
<CFELSE>
	<CFSET gameReqID = 0>
</CFIF>

<CFIF isDefined("FORM.BACK")>
	<cflocation url="gameAddReqList.cfm">
</CFIF>

<!--- Get info for seleted Game Request ID --->
<CFQUERY name="qGetGameRequested" datasource="#SESSION.DSN#">
	select gnr.game_request_ID, gnr.season_ID,   gnr.gameDate, 
		   gnr.gameTime,        gnr.game_ID,	 gnr.GameType,   gnr.GameDivision,
		   gnr.FieldID,        gnr.HomeTeam_ID,  gnr.VisitorTeam_ID,
		   gnr.requestDate,    gnr.requestTime,  gnr.createdBy,
		   gnr.Approved_YN,    gnr.ApprovedDate, gnr.ApprovedTime,
		   gnr.new_game_comments,
		   gnr.virtual_VisitorTeamName,
		   dbo.GetTeamName(VT.team_id) as VTname,
		   dbo.GetTeamName(HT.team_id) as HTname,
		   (SELECT CLUB_ID  FROM TBL_TEAM WHERE TEAM_ID = VT.team_id) AS Visitor_CLUB_ID,
		   (SELECT CLUB_ID  FROM TBL_TEAM WHERE TEAM_ID = HT.team_id) AS Home_CLUB_ID,
		   (SELECT DISTINCT IsNull(Gender, '') + RIGHT(TeamAge, 2) + IsNull(PlayLevel, '') + IsNull(PlayGroup, '') FROM TBL_TEAM WHERE TEAM_ID = HT.team_id) AS Division, 
		   F.FIELDNAME, F.FIELDABBR, C.FirstName, c.LastName
	  FROM TBL_GAME_NEW_REQUEST gnr 
				LEFT OUTER JOIN tbl_field F  ON F.field_id = gnr.fieldid 
					 INNER JOIN TBL_Team  HT ON HT.TEAM_ID = gnr.HomeTeam_ID
					 INNER JOIN TBL_Team  VT ON VT.TEAM_ID = gnr.VisitorTeam_ID
					 INNER JOIN TBL_CONTACT C ON C.CONTACT_ID = gnr.createdBy
	 WHERE gnr.game_request_ID = <cfqueryParam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.gameReqID#">   
</CFQUERY>	<!--- <cfdump var="#qGetGameRequested#"> --->

<!--- set variables --->
<CFSET GameReqID = qGetGameRequested.game_request_ID>
<CFSET seasonID	 = qGetGameRequested.season_ID>
<CFSET GameDate	 = dateFormat(qGetGameRequested.gameDate, "mm/dd/yyyy") >
<CFSET GameTime	 = timeFormat(qGetGameRequested.gameTime, "hh:mm tt") >
<CFSET GameID	 = qGetGameRequested.game_ID>
<CFSET GameType	 = qGetGameRequested.gameType>
<CFSET Division	 = qGetGameRequested.Division><!--- GameDivision --->
<CFSET FieldID	 = qGetGameRequested.FieldID>
<CFSET origFieldID	 = qGetGameRequested.FieldID>
<CFSET FieldName = qGetGameRequested.FIELDNAME>
<CFSET FIELDABBR = qGetGameRequested.FIELDABBR>
<CFSET HclubID	 = qGetGameRequested.Home_CLUB_ID>
<CFSET HteamID	 = qGetGameRequested.HomeTeam_ID>
<CFSET HteamName = qGetGameRequested.HTname>
<CFSET VclubID	 = qGetGameRequested.Visitor_CLUB_ID>
<CFSET VteamID	 = qGetGameRequested.VisitorTeam_ID>
<CFSET VteamName = qGetGameRequested.VTname>
<CFSET VirtTeamName = qGetGameRequested.virtual_VisitorTeamName>
<CFSET requestor = qGetGameRequested.FirstName & " " & qGetGameRequested.LastName>
<CFSET reqDate	 = dateFormat(qGetGameRequested.requestDate,"mm/dd/yyyy")>
<CFSET reqTime	 = timeFormat(qGetGameRequested.requestTime,"hh:mm tt")>
<CFSET approveYN   = qGetGameRequested.Approved_YN>
<CFSET approveDate = qGetGameRequested.ApprovedDate>
<CFSET approveTime = qGetGameRequested.ApprovedTime>
<CFSET GameComments = qGetGameRequested.new_game_comments>

<cfif isDefined("FORM.RejectComments") AND len(trim(FORM.RejectComments))>
	<cfset RejectComments = FORM.RejectComments>
<CFELSE>
	<cfset RejectComments = "">
</cfif>

<cfif isDefined("FORM.gameChairComments") AND len(trim(FORM.gameChairComments))>
	<cfset gameChairComments = FORM.gameChairComments>
<CFELSE>
	<cfset gameChairComments = "">
</cfif>
<cfif isDefined("FORM.RefComments") AND len(trim(FORM.RefComments))>
	<cfset RefComments = FORM.RefComments>
<CFELSE>
	<cfset RefComments = "">
</cfif>


<CFIF isDefined("FORM.NewGameFieldID") AND isNumeric(FORM.NewGameFieldID)>
	<cfset FieldID =  FORM.NewGameFieldID>
<CFELSEIF isDefined("FORM.ORIGFieldID") AND isNumeric(FORM.ORIGFieldID)>
	<cfset FieldID = FORM.ORIGFieldID>
<CFELSE>
	<cfset FieldID = FieldID>
</CFIF>

<!--- -------------------------------------------------- --->
<CFIF isDefined("Form.FineTeam")>
	<cfset FineTeam = Form.FineTeam>
<cfelse>
	<cfset FineTeam = "">
</CFIF>
<CFIF isDefined("Form.FineTypeID")>
	<cfset FineTypeID = Form.FineTypeID>
<cfelse>
	<cfset FineTypeID = "">
</CFIF>
<!--- -------------------------------------------------- --->

<!--- start APPROVE --->
<CFIF isDefined("FORM.APPROVE") AND FORM.gameReqID GT 0> 

 	<!--- <CFIF FORM.GAMEFIELDALL NEQ FORM.origFieldID>
		<CFSET newFieldID = FORM.GAMEFIELDALL>
	<CFELSEIF FORM.GAMEFIELDCLUB NEQ FORM.origFieldID>
		<CFSET newFieldID = FORM.GAMEFIELDCLUB>
	<CFELSE>
		<CFSET newFieldID = FORM.origFieldID>
	</CFIF> --->

	<CFIF isDefined("FORM.NewGameFieldID") AND isNumeric(FORM.NewGameFieldID)>
		<cfset newFieldID =  FORM.NewGameFieldID>
	<CFELSE>
		<cfset newFieldID = FORM.OrgGameFieldID>
	</CFIF>

	<CFSET GameDate	 = dateFormat(FORM.gameDate, "mm/dd/yyyy") >
	<CFIF isNumeric(FORM.GameHour)>
		<cfset GameTime = FORM.GameHour & ":">
	<CFELSE>
		<cfset GameTime = "01:" >
	</CFIF>
	<CFIF isNumeric(FORM.GameMinute) >
		<cfset GameTime = GameTime & FORM.GameMinute & " " & FORM.GameMeridian>
	<CFELSE>
		<cfset GameTime = GameTime & "00 AM">
	</CFIF>

	<CFIF isDefined("form.VIRTUALTEAMNAME")>
		<cfset VirtTeamName = form.VirtualTeamName>
	</CFIF>

	<cfset FinedTeamID = FORM.FinedTeamID >
	<cfset swApprove = true >
	<cfif FineTeam EQ "Y" >
		<!--- the home team is fined, make sure a fine was selected --->
		<cfif FineTypeID EQ 0 >
			<cfset swApprove = false >
			<cfset msg = msg & "<br>Admin Fine/Fee is required." >
		</cfif>
	</cfif>
	
	 	<!--- 
		<br>"HomeTeamID"	[#VARIABLES.HteamID#]		 <br>"VisitorTeamID" [#VARIABLES.VteamID#]
		<br>"seasonID"		[#SESSION.CURRENTSEASON.ID#] <br>"contactID"	 [#SESSION.USER.CONTACTID#]
		<br>"GameDate"		[#VARIABLES.GameDate#]		 <br>"GameTime"		 [#VARIABLES.GameTime#]
		<br>"FieldID"		[#VARIABLES.newFieldID#]	 <br>"GameType"		 [#VARIABLES.GameType#]
		<br>"Comments"		[#VARIABLES.refComments#]	 <br>"GamesChairComments" [#VARIABLES.gameChairComments#]
		<br>"FineTeam"		[#VARIABLES.FineTeam#]		 <br>"FinedTeamID"	 [#VARIABLES.FinedTeamID#]
		<br>"FineTypeID"	 [#VARIABLES.FineTypeID#]
		<cfdump var="#form#">
		<CFABORT> --->

	<cfif swApprove>

		<cfinvoke component="#SESSION.SITEVARS.cfcPath#GAME" method="insertGame" returnvariable="NEW_GAME_ID">
			<cfinvokeargument name="HomeTeamID"		value="#VARIABLES.HteamID#">
			<cfinvokeargument name="VisitorTeamID"  value="#VARIABLES.VteamID#">
			<cfinvokeargument name="seasonID"		value="#SESSION.CURRENTSEASON.ID#">
			<cfinvokeargument name="contactID"		value="#SESSION.USER.CONTACTID#">
			<cfinvokeargument name="GameDate"		value="#VARIABLES.GameDate#">
			<cfinvokeargument name="GameTime"		value="#VARIABLES.GameTime#">
			<cfinvokeargument name="FieldID"		value="#VARIABLES.newFieldID#">
			<cfinvokeargument name="GameType"		value="#VARIABLES.GameType#">
			<cfinvokeargument name="Comments"		value="#VARIABLES.refComments#">
			<cfinvokeargument name="GameCode"		value="">
			<cfinvokeargument name="GamesChairComments" value="#VARIABLES.gameChairComments#">
		</cfinvoke>
	
		<CFSET Gameid = NEW_GAME_ID>
			
		<CFIF GameID GT 0>
			<CFSET msg = msg & "<BR>Game has been added. Game ID is " & GameID >
	
			<CFQUERY name="qRejectGameReq" datasource="#SESSION.DSN#">
					UPDATE TBL_GAME_NEW_REQUEST
					   SET game_ID		= <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameID#">
					     , Approved_YN  = 'Y'
					     , ApprovedDate = getdate() 
						 , ApprovedTime = getdate() 
						 , updatedBy    = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#SESSION.USER.CONTACTID#">
						 , updateDate   = getdate() 
						 , virtual_VisitorTeamName = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.VirtTeamName#">
					 WHERE game_request_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.gameReqID#">
			</CFQUERY>

			<cfif GameType EQ "C" OR GameType EQ "N">
				<!--- for state cup and non-league games put in virtual team name --->
				<CFQUERY name="qUpdateVirtTeamName" datasource="#SESSION.DSN#">
					UPDATE XREF_GAME_TEAM
					   SET Virtual_TeamName = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.VirtTeamName#">
					 WHERE GAME_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameID#">
					   AND TEAM_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.VteamID#">
					   AND isHomeTeam = 0
				</CFQUERY>
			</cfif>

	
			<cfif FineTeam EQ "Y">
				<cfset Amount = 0>
				<cfquery name="getFineAmount" datasource="#SESSION.DSN#">
					Select Amount from TLKP_Fine_Type Where FINETYPE_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.FineTypeID#">
				</cfquery>
				<cfif getFineAmount.recordCount>
					<cfset Amount = getFineAmount.Amount>
				</cfif>
	
				<cfinvoke component="#SESSION.SITEVARS.cfcPath#TEAM" method="getTeamInfo" returnvariable="teamClubFined">
					<cfinvokeargument name="TeamID" value="#VARIABLES.FinedTeamID#">
				</cfinvoke>	
				<cfif teamClubFined.RECORDCOUNT>
					<cfset ClubFined		= teamClubFined.CLUB_ID >
					<cfset ClubFinedName	= teamClubFined.CLUB_NAME >
					<cfset TeamFined		= teamClubFined.TEAM_ID >
					<cfset TeamFinedName	= teamClubFined.TEAMNAME >
				<cfelse>
					<cfset ClubFined		= 0 >
					<cfset ClubFinedName	= "" >
					<cfset TeamFined		= 0 >
					<cfset TeamFinedName	= "" >
				</cfif>
		
				<cfinvoke component="#SESSION.SITEVARS.cfcPath#FINEFEES" method="insertFine">
					<cfinvokeargument name="SeasonID" 	value="#SESSION.CURRENTSEASON.ID#">
					<cfinvokeargument name="gameID" 	value="#VARIABLES.GameID#"> 
					<cfinvokeargument name="clubID"   	value="#VARIABLES.ClubFined#"> 
					<cfinvokeargument name="TeamID"  	value="#VARIABLES.TeamFined#"> 
					<cfinvokeargument name="fineTypeID"	value="#VARIABLES.FineTypeID#"> 
					<cfinvokeargument name="Amount"		value="#VARIABLES.Amount#"> 
					<cfinvokeargument name="Status"		value=""> 
					<cfinvokeargument name="Comments"	value=""> 
					<cfinvokeargument name="contactID"	value="#SESSION.USER.CONTACTID#"> 
					<cfinvokeargument name="AppealAllowedYN" value="Y"> 
				</cfinvoke>
			</cfif> <!--- end - if FineTeam EQ "Y" --->
	
			<cflocation url="gameAddReqList.cfm">
		<CFELSE>
			<CFSET msg = msg & "<BR>Game was not added." >
		</CFIF>
	</cfif>	<!--- end - IF swApprove --->

</CFIF>
<!--- end APPROVE --->


<!--- start REJECT --->
<CFIF isDefined("FORM.REJECT")>
 	<cfif len(trim(FORM.RejectComments)) EQ 0>
		<CFSET msg = msg & "<BR>Game was not Rejected. Rejection Comments are Required." >
	<cfelse>
		<CFQUERY name="qRejectGameReq" datasource="#SESSION.DSN#">
			UPDATE TBL_GAME_NEW_REQUEST
			   SET Approved_YN  = 'N'
			   	 , Reject_comments = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#FORM.RejectComments#">
			     , ApprovedDate = getdate() 
				 , ApprovedTime = getdate() 
				 , updatedBy    = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#SESSION.USER.CONTACTID#">
				 , updateDate   = getdate() 
			 WHERE game_request_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.gameReqID#">
		</CFQUERY>
		<cflocation url="gameAddReqList.cfm">
	</CFIF>
</CFIF>
<!--- end REJECT --->

<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="allGameTypes">
	<cfinvokeargument name="listType" value="GAMETYPE"> 
</cfinvoke> 
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="stTimeParams">
	<cfinvokeargument name="listType" value="DDHHMMTT"> 
</cfinvoke> 
<cfquery name="qFines" datasource="#SESSION.dsn#">
	Select FINETYPE_ID, DESCRIPTION, Amount From TLKP_Fine_Type
</cfquery>

<span class="red">Fields marked with * are required</span>
<CFSET required = "<FONT color=red>*</FONT>">

<FORM name="GameReq" action="gameAddRequestProcess.cfm"  method="post" id="GameReq">
	<input type="hidden" name="gameReqID"	value="#gameReqID#" >
	<input type="hidden" name="origFieldID" value="#variables.origFieldID#">
	<input type="hidden" name="NewGameFieldID" id="NewGameFieldID"	value="#VARIABLES.FieldID#">
	<table cellspacing="0" cellpadding="5" align="left" border="0" width="90%">
		<tr class="tblHeading"><TD colspan="3" >&nbsp;</TD>
		</tr>
		<cfif len(trim(msg))>
			<tr><TD colspan="3"><span class="red"><b>#msg#</b></span></TD>
			</tr>
		</cfif>
		<TR><TD align="right"><B>Requested by</B></TD>
			<TD colspan="2" >#VARIABLES.requestor#</TD>
		</TR>
		<TR><TD class="tdUnderLine"  align="right"><B>Requested on</B></TD>
			<TD class="tdUnderLine" colspan="2" >#VARIABLES.reqDate# #VARIABLES.reqTime# </TD>
		</TR>
		<TR><TD class="tdUnderLine" width="20%"  align="right"><B>Requested Game info:</B></TD>
			<TD class="tdUnderLine" width="30%" > &nbsp; </TD>
			<TD class="tdUnderLine" width="50%" > &nbsp; </TD>
		</TR>
		<TR><TD > &nbsp; </TD>
			<TD >Existing Values: </TD>
			<TD > &nbsp; </TD>
		</TR>
		<TR><TD align="right"><B>Game Type</B> </TD>
			<td align="left" colspan="2" >
				<cfloop from="1" to="#arrayLen(allGameTypes)#" index="iGT">
					<cfif GameType EQ allGameTypes[iGT][1]>
						 #allGameTypes[iGT][2]#
					</cfif>
				</cfloop>
			</td>
		</TR>
		<TR><TD align="right"><B>Game Date</B></TD>
			<TD>#VARIABLES.GameDate#</TD>
			<TD><input size="9" name="GameDate" value="#VARIABLES.GameDate#" readonly >
				<input size="3" name="DOW"  value="#DateFormat(VARIABLES.GameDate,"ddd")#" disabled>
				&nbsp;  <cfset dpMM = datePart("m",VARIABLES.GameDate)-1>
						<cfset dpYYYY = datePart("yyyy",VARIABLES.GameDate)>
				<a href="javascript:show_calendar('GameReq.GameDate','GameReq.DOW','#dpMM#','#dpYYYY#' );" 
						onmouseover="window.status='Date Picker';return true;" 
						onmouseout="window.status='';return true;"> 
					<img src="#SESSION.siteVars.imagePath#cal.gif" width="20" height="18" alt="" border="0">
				</a>
			</TD>
		</TR>
		<TR><TD align="right"><B>Game Time</B></TD>
			<TD>#VARIABLES.GameTime#</TD>
			<TD align="left">
				<cfset HH = listfirst(VARIABLES.GameTime,":")>
				<cfset MM = listlast( listfirst(VARIABLES.GameTime," ") ,":")>
				<cfset TT = listlast(VARIABLES.GameTime," ")>
				<SELECT name="GameHour"> 
					<!--- <OPTION value="0" selected>HR</OPTION> --->
				    <CFLOOP list="#stTimeParams.hour#" index="iHr">
						<OPTION value="#iHr#" <CFIF HH EQ iHr>selected</CFIF> >#iHr#</OPTION>
					</CFLOOP>
				</SELECT>
				<SELECT name="GameMinute"> 
					<!--- <OPTION value="0" selected>MN</OPTION> --->
					<CFLOOP list="#stTimeParams.min#" index="iMn">
						<OPTION value="#iMn#" <CFIF MM EQ iMn>selected</CFIF> >#iMn#</OPTION>
					</CFLOOP>
				</SELECT>
				<SELECT name="GameMeridian">
					<CFLOOP list="#stTimeParams.tt#" index="iTT">
						<OPTION value="#iTT#" <CFIF TT EQ iTT>selected</CFIF> >#iTT#</OPTION>
					</CFLOOP>
				</SELECT>  
			</TD>
		</TR>
		<TR><TD align="right" valign="middle"><B>Division</B></TD>
			<TD align="left" colspan="2">&nbsp;</TD>
		</TR>
		<TR><TD align="right"><B>Home</B></TD>
			<TD colspan="2">#VARIABLES.HteamName#</td>
			<!--- <TD><input type="Text" name="HomeTeam" value="#VARIABLES.HteamName#" disabled></td> --->
		</TR>
		<TR><TD align="right"><B>Visitor</B></TD>
			<TD colspan="2"><!--- #VteamName# --->
				<CFIF len(trim(VARIABLES.VteamName))>
					#VARIABLES.VteamName#
				<CFELSEIF len(trim(VARIABLES.VirtTeamName))>
					<input type="Text" name="VirtualTeamName" value="#VARIABLES.VirtTeamName#">
<!--- 					<input type="hidden" name="TeamId" value="#VisitorTeam_ID#"> --->
				<CFELSE>
					&nbsp;
				</CFIF>
 			</td>
			<!--- <TD><cfif len(trim(VARIABLES.VteamName))>
						<input type="Text" name="VisitorTeam" value="#VARIABLES.VteamName#" disabled>
					&nbsp; &nbsp; &nbsp; 
					<!--- <input type=button value="Flip Teams" onclick="FlipTeams()" id=button1 name=button1> --->
				<cfelseif len(trim(VARIABLES.VirtualTeamName))>
					<input type="Text" name="VisitorTeam" value="#VARIABLES.VirtualTeamName#" disabled>
				<cfelse>
					&nbsp; 
				</cfif>
			</TD> --->
		</TR>

		<!--- ----------------------------------------------------- --->
		<TR id="ClubFields" style="Display:">
			<TD align="right"><b>PlayField</b> <br> <span class="red">(Club's list)</span> </TD>
			<TD>#FieldName #</td>
			<TD align="left">
				<cfset FieldFound = 0>
				<cfinvoke component="#SESSION.SITEVARS.cfcpath#FIELD" method="getFields" returnvariable="HomeTeamFields">
					<cfinvokeargument name="clubID"  value="#HclubID#">
					<cfinvokeargument name="orderBy" value="ABBRV">
				</cfinvoke>
				<cfquery name="otherFieldValues" datasource="#SESSION.DSN#">
						SELECT F.FIELD_ID, F.FIELDABBR, F.FIELDNAME
						  FROM TBL_FIELD F  INNER JOIN XREF_CLUB_FIELD xcf ON xcf.field_id = F.field_id
						 WHERE XCF.CLUB_ID = 1 
						   and f.Active_YN = 'Y'
						 ORDER BY F.FIELDABBR
				</cfquery>
				<SELECT name="GameFieldClub" id="GameFieldClub" onchange="setNewFieldIDClubList()"> 
					<OPTION value="0" selected>Select a Field</OPTION>
					<CFLOOP query="HomeTeamFields">
						<cfif FieldID EQ FIELD_ID>
						 	<cfset FieldFound = 1>
							<OPTION value="#FIELD_ID#" selected>#FIELDABBR#</OPTION>
						<cfelse>
							<OPTION value="#FIELD_ID#"		   >#FIELDABBR#</OPTION>
						</cfif>
					</CFLOOP>
					<cfif FieldFound EQ 0>
						<cfif Len(trim(FieldID)) >
							<OPTION value="#VARIABLES.FieldID#" selected>#VARIABLES.FieldAbbr#</OPTION>
						</cfif>
					</cfif>
					<CFLOOP query="otherFieldValues">
						<OPTION value="#FIELD_ID#" <cfif FieldID EQ FIELD_ID >selected</cfif> >#FIELDABBR#</OPTION>
					</CFLOOP>
				</SELECT>
				<!--- <cfif (HomeTeamOK + VisitorTeamOK) EQ 2 AND --->
				<cfif (SESSION.MENUROLEID EQ 19 OR SESSION.MENUROLEID EQ 1) > <!---  19="GAMESCHAIR" 1="ASSTADMIN" --->
					<input type=button name="DispAllFields" onclick="DisplayAllFields(); setNewFieldIDClubList()" value="Display ALL Fields">
				</cfif>
			</TD>
		</TR>
		<cfif (SESSION.MENUROLEID EQ 19 OR SESSION.MENUROLEID EQ 1) > <!---  19="GAMESCHAIR" 1="ASSTADMIN" --->
			<TR id="AllFields" style="Display:none">
				<TD align="right"><b>PlayField</b> <br> <span class="red">(All fields listed)</span> </TD>
				<TD>#FieldName #</td>
				<TD align="left">
					<cfquery name="qAllFields" datasource="#SESSION.DSN#">
						SELECT F.FIELD_ID, F.FIELDABBR, F.FIELDNAME AS FIELD
						  FROM TBL_FIELD F
						 Where FieldAbbr is not NULL 
						   and (Active_YN = 'Y')
						 Order by FieldAbbr
					</cfquery>
					<SELECT name="GameFieldAll" id="GameFieldAll" onchange="setNewFieldIDAllList()"> > 
						<OPTION value="0" selected>&nbsp;</OPTION>
							<CFLOOP query="qAllFields">
								<OPTION value="#FIELD_ID#" <cfif FieldID EQ FIELD_ID >selected</cfif> >#FIELDABBR#</OPTION>
							</CFLOOP>
							<cfif (SESSION.MENUROLEID EQ 19 OR SESSION.MENUROLEID EQ 1) > <!---  19="GAMESCHAIR" 1="ASSTADMIN" --->
								<cfquery name="otherFieldValues" datasource="#SESSION.DSN#">
									SELECT F.FIELD_ID, F.FIELDABBR, F.FIELDNAME
									  FROM TBL_FIELD F  INNER JOIN XREF_CLUB_FIELD xcf ON xcf.field_id = F.field_id
									 WHERE XCF.CLUB_ID = 1 
									   and f.Active_YN = 'Y'
								</cfquery>
								<CFLOOP query="otherFieldValues">
									<OPTION value="#FIELD_ID#" <cfif FieldID EQ FIELD_ID>selected</cfif> >#FIELDABBR#</OPTION>
								</CFLOOP>
							</cfif>
					</SELECT>
					<input type=button name="DispClubFields" onclick="DisplayClubFields(); setNewFieldIDAllList()" value="Display CLUB Fields">
				</td>
			</TR>
		</cfif>
		<!--- ------------------------------------------------------- --->
		<TR><TD class="tdUnderLine" align="right" valign="top"><B>Additional Info</B></TD>
			<TD class="tdUnderLine" colspan="2" > #Trim(VARIABLES.gameComments)#     </TD>				
		</tr>
		<TR><TD align="right" valign="top"><B>Games Chairman Comments</B></TD>
			<TD colspan="2" >
				<TEXTAREA name="gameChairComments" rows="2" cols="65"> #Trim(VARIABLES.gameChairComments)# </TEXTAREA>
			</TD>
		</tr>
		<TR><TD class="tdUnderLine" align="right" valign="top"><B>Referee Assignment Notes</B></TD>
			<TD class="tdUnderLine" colspan="2" >
				<TEXTAREA name="refComments"  rows="2" cols="65"> #Trim(VARIABLES.refComments)# </TEXTAREA>
			</TD>
		</tr>
<!--- ---------------------------------------- --->
		<CFIF GameType EQ "F">
			<!--- supress fines for friendly games --->
			<input type="Hidden" name="FineTeam" value="N">	
			<input type="Hidden" name="FinedTeamID" value="#HTeamId#">
		<CFELSE>
			<CFIF FineTeam EQ "Y">
				<cfset FineTeamYes = "checked">
				<cfset FineTeamNo = "">
			<CFELSE>
				<cfset FineTeamYes = "">
				<cfset FineTeamNo = "checked">
			</CFIF>
			<tr><TD align="right"> <b>Fine Team?</b></TD>
				<TD colspan="2">
					<input type="Radio"  onclick="DisplayFineDetail('Y')" maxlength="1" name="FineTeam" value="Y" #FineTeamYes#> Yes
					<input type="Radio"  onclick="DisplayFineDetail('N')" maxlength="1" name="FineTeam" value="N" #FineTeamNo#>  No
				</td>
			</tr>
			<tr><TD align="right"> <b>Team to Fine</b></TD>
				<TD colspan="2">
					#HTeamName# <input type="Hidden" name="FinedTeamID" value="#HTeamId#">
				</td>
			</tr>
			<TR><TD class="tdUnderLine" align="right"> <b>Admin Fine/Fees</b> 	</TD>
				<TD class="tdUnderLine" colspan="2"><SELECT name="FineTypeID">
						<OPTION value="0" selected>Select Fine (if applicable)</OPTION>
							<cfloop query="qFines">
								<OPTION value="#FINETYPE_ID#" <cfIf FINETYPE_ID EQ FineTypeID>selected</cfif> >#Trim(DESCRIPTION)#: #dollarFormat(Amount)#</OPTION>
							</cfloop>
					</Select>
				</td>
			</tr>
		</CFIF>
<!--- ----------------------------------------- --->
		<tr><TD class="tdUnderLine" align="right"> <B>Rejection Comment:</B></TD>
			<TD class="tdUnderLine" colspan="2" >
				<TEXTAREA name="RejectComments" rows="2" cols="65"> #Trim(VARIABLES.RejectComments)# </TEXTAREA>
			</TD>
		</TR>


		<TR><TD>&nbsp;</TD>
			<TD align="left" colspan="2">
				<CFIF GameID LTE 0>
					<INPUT type="submit" name="APPROVE" value="Approve" >
					<INPUT type="submit" name="REJECT"  value="Reject" >
				</CFIF>
				<INPUT type="submit" name="BACK"  	value="Back" >
			</TD>
		</TR>
	</TABLE>
</FORM>

<script language="javascript">
function DisplayAllFields()
{	document.getElementById("ClubFields").style.display = "none";
	document.getElementById("AllFields").style.display = "";
	//	cForm("ClubFields").style.display = "none";
	// cForm("AllFields").style.display  = "";
}
function DisplayClubFields()
{	document.getElementById("ClubFields").style.display = "";
	document.getElementById("AllFields").style.display = "none";
	//	cForm("ClubFields").style.display = "inline";
	// cForm("AllFields").style.display  = "none";
}
function setNewFieldIDClubList()
{ 	var dropdownIndex = document.getElementById('GameFieldClub').selectedIndex;
	document.getElementById("NewGameFieldID").value = document.getElementById("GameFieldClub")[dropdownIndex].value;
}
function setNewFieldIDAllList()
{ 	var dropdownIndex = document.getElementById('GameFieldAll').selectedIndex;
	document.getElementById("NewGameFieldID").value = document.getElementById("GameFieldAll")[dropdownIndex].value;
}
</script>


</cfoutput>
</div>
<cfinclude template="_footer.cfm">
