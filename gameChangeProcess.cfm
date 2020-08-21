<!--- 
	FileName:	gameChangeProcess.cfm
	Created on: 10/08/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
01/30/09 - aarnone - fixed field js issue in FF.
		changed to return to list of games after approving
03/06/09 - aarnone - ticket:7309 - virtual team changes for state cup and non league games
03/16/09 - aarnone - added java functions: setNewFieldIDClubList() and setNewFieldIDAllList() to set new field id
					 depending on which drop down list was used.
03/20/09 - aarnone - ticket:7404 - added flip teams
03/26/09 - aarnone - changed inner to left join so blank field will show.
04/16/09 - aarnone - T:7514 - made the deletion of the referees dependent on the user to select Y/N
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<script language="JavaScript" src="DatePicker.js"></script> 
<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Accept Game Changes</H1>
<br><!--- <h2>yyyyyy </h2> --->

<cfset msg = "">

<CFIF isDefined("Form.FineTeam")>
	<cfset selFineTeam = Form.FineTeam>
<cfelse>
	<cfset selFineTeam = "">
</CFIF>
<CFIF isDefined("Form.FineTypeID")>
	<cfset FineTypeID = Form.FineTypeID>
<cfelse>
	<cfset selFineTypeID = "">
</CFIF>
<CFIF isDefined("Form.RequestedByTeam")>
	<cfset selTeamToBeFined = Form.RequestedByTeam>
<cfelse>
	<cfset selTeamToBeFined = "">
</CFIF>

<CFIF isDefined("Form.DeleteRefs_YN")>
	<cfset DeleteRefs_YN = Form.DeleteRefs_YN>
<cfelse>
	<cfset DeleteRefs_YN = "Y">
</CFIF>

<!--- T:7663 - limit comments to 500 chars --->
<CFIF isDefined("Form.Comments") AND LEN(TRIM(Form.Comments)) GT 0>
	<cfset Comments = left(Form.Comments,500)>
<cfelse>
	<cfset Comments = "">
</CFIF>
<CFIF isDefined("Form.RefComments") AND LEN(TRIM(Form.RefComments)) GT 0>
	<cfset RefComments = left(Form.RefComments,500)>
<cfelse>
	<cfset RefComments = "">
</CFIF>




<CFIF isDefined("FORM.Back")>
	<cflocation url="gameChangeList.cfm">
</CFIF> 

<CFIF isDefined("FORM.ACCEPT")>
	<!--- ------------------ --->
	<!--- ACCEPT Game Change --->
	<!--- ------------------ --->
	<CFSET status = "Y">
	<!--- START - SubmitChanges --->
	<CFIF isDefined("FORM.NewGameDate") AND isDate(FORM.NewGameDate)>
		<cfset newDate = FORM.NewGameDate>
	<cfelse>
		<cfset msg = "Date is missing or is not valid.">
	</CFIF>
	<CFIF isDefined("FORM.GameNewHour") AND isNumeric(FORM.GameNewHour)>
		<cfset newHour = FORM.GameNewHour>
	</CFIF>
	<CFIF isDefined("FORM.GameNewMinute") AND isNumeric(FORM.GameNewMinute)>
		<cfset newMinute = FORM.GameNewMinute>
	</CFIF> 
	<CFIF isDefined("FORM.GameNewMeridian")>
		<cfset newMeridian =  FORM.GameNewMeridian>
	</CFIF>
	<cfset NewTime = NewHour & ":" & NewMinute & " " & NewMeridian>
	
	
	<CFIF isDefined("FORM.GameFieldClub") AND isNumeric(FORM.GameFieldClub)>
		<cfset newFieldID = FORM.GameFieldClub> 
	<cfelse>
		<cfset msg = msg & "<br>field is required.">
	</CFIF> 
	
	<CFIF isDefined("FORM.NewGameFieldID") AND isNumeric(FORM.NewGameFieldID)>
		<cfset newFieldID =  FORM.NewGameFieldID>
	<CFELSE>
		<cfset newFieldID = FORM.OrgGameFieldID>
	</CFIF>

	<CFIF len(trim(VARIABLES.newFieldID)) EQ 0>
		<cfset msg = msg & "<br>field is required.">
	</CFIF> 

	
	<CFIF LEN(TRIM(Comments)) EQ 0>
		<cfset msg = msg & "<br>Reason for change is required.">
	</CFIF>

	<CFIF isDefined("Form.FineTeam") AND LEN(TRIM(Form.FineTeam)) GT 0>
		<cfset FineTeam = Form.FineTeam>
		<CFIF FineTeam EQ "Y">
			<CFIF isDefined("Form.FineTypeID") AND Form.FineTypeID GT 0>
				<cfset FineTypeID = Form.FineTypeID>
			<cfelse>
				<cfset msg = msg & "<br>Admin Fine/Fee is required.">
			</CFIF>
			<CFIF isDefined("Form.RequestedByTeam") AND LEN(TRIM(Form.RequestedByTeam)) GT 0>
				<cfset TeamToBeFined = Form.RequestedByTeam>
			<cfelse>
				<cfset msg = msg & "<br>Requested by Team is required.">
			</CFIF>
		</CFIF>	
	<cfelse>
		<cfset msg = msg & "<br>Fine Team is required.">
	</CFIF>
	
	<CFIF isDefined("Form.ChangeRequestId")>
		<cfset ChangeRequestId = FORM.ChangeRequestId>
	</CFIF>
	<CFIF isDefined("Form.GameId")>
		<cfset GameId = FORM.GameId>
	</CFIF>
	<CFIF isDefined("Form.HomeTeamID")>
		<cfset HomeTeamID = FORM.HomeTeamID>
	</CFIF>
	<CFIF isDefined("Form.VisitorTeamID")>
		<cfset VisitorTeamID = FORM.VisitorTeamID>
	</CFIF>
	<CFIF isDefined("Form.ORIGHomeTeamID")>
		<cfset ORIGHomeTeamID = FORM.ORIGHomeTeamID>
	</CFIF>
	<CFIF isDefined("Form.ORIGVisitorTeamID")>
		<cfset ORIGVisitorTeamID = FORM.ORIGVisitorTeamID>
	</CFIF>

	<CFIF NOT Len(Trim(msg))>
		<!--- This include contains the ACCEPT logic --->
		<cfinclude template="gameChangeProcessAccINC.cfm">
	
		<!--- <cfset msg = msg & "<br>Change Request has been updated."> --->
		<CFIF len(trim(msg)) EQ 0>
			<cflocation url="gameChangeList.cfm">
		</CFIF>
	</CFIF> <!--- END - IF NOT Len(Trim(msg)) --->

</CFIF> <!--- END - IF isDefined("FORM.ACCEPT") --->


<CFIF isDefined("FORM.REJECT")>
	<!--- ------------------ --->
	<!--- REJECT Game Change --->
	<!--- ------------------ --->
	<CFSET status = "R">
	<!--- log the request --->
	<cfstoredproc procedure="p_LOG_Game_Change_Request" datasource="#SESSION.DSN#">
		<cfprocparam cfsqltype="CF_SQL_NUMERIC" dbvarname="@game_change_request_id" value="#ChangeRequestID#">
		<cfprocparam cfsqltype="CF_SQL_NUMERIC" dbvarname="@contactID" value="#SESSION.USER.CONTACTID#">
	</cfstoredproc>
	<!--- update the game change request --->
	<cfquery name="updateGCR" datasource="#SESSION.DSN#">
		Update TBL_Game_Change_REQUEST
		   set ApprovedTime	= <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#dateFormat(now(),"mm/dd/yyyy")# #timeformat(now(),"hh:mm:ss tt")#"> 
			,  ApprovedDate	= <cfqueryparam cfsqltype="CF_SQL_DATE"    value="#dateFormat(now(),"mm/dd/yyyy")#"> 
			,  Approved		= <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.Status#">
			,  Comments		= <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.Comments#">
			,  RefComments	= <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.RefComments#">
			,  updateDate	= <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#dateFormat(now(),"mm/dd/yyyy")# #timeformat(now(),"hh:mm:ss tt")#"> 
			,  updatedBY	= <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#SESSION.USER.CONTACTID#">
			Where GAME_Change_Request_Id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#FORM.ChangeRequestID#">
	</cfquery>
	<cflocation url="gameChangeList.cfm">
</CFIF>

<CFIF isDefined("URL.GCRID") AND isNumeric(URL.GCRID)>
	<cfset ChangeRequestID	= URL.GCRID>
<CFELSE>
	<cfset ChangeRequestID	= 0>
</CFIF>

<cfquery name="qChangeInfo" datasource="#SESSION.dsn#">
	SELECT gc.game_change_request_ID, gc.APPROVED,
		   gc.NewDate, gc.NewTime,
		   gc.Comments, gc.game_ID,
		   gc.RefComments,
		   gc.RequestedByTeam,
		   Fn.FineType_Id,
		   Fd.FIELDABBR, Fd.FIELD_ID
	  FROM tbl_Game_Change_Request gc
				 LEFT JOIN TBL_FINES Fn ON Fn.fine_id  = gc.fine_id
				 LEFT JOIN TBL_FIELD Fd ON Fd.FIELD_ID = gc.NewField
	 Where gc.game_change_request_ID = #VARIABLES.ChangeRequestID#
</cfquery>	<!--- qChangeInfo<cfdump var="#qChangeInfo#"> --->

<cfset NewGameDate		= DateFormat(qChangeInfo.NewDate,"mm/dd/yyyy") >
<cfset NewGameTime		= TimeFormat(qChangeInfo.NewTime,"hh:mm tt") >
<cfset NewGameFieldAbbr	= qChangeInfo.FIELDABBR >
<cfset NewGameFieldID	= qChangeInfo.FIELD_ID >
<cfset Comments			= qChangeInfo.Comments >
<cfset GameId			= qChangeInfo.game_ID >
<cfset RefComments		= qChangeInfo.RefComments >
<cfset FineId			= qChangeInfo.FINETYPE_ID >
<cfset RequestedByTeam  = qChangeInfo.RequestedByTeam >
<cfset requestStatus	= qChangeInfo.APPROVED >
<!--- <cfif len(Trim(RefComments)) EQ 0>
	<cfset RefComments = Comments>
</cfif> --->

<cfquery name="qGameInfo" datasource="#SESSION.dsn#">
	SELECT D.HOME_TeamName, D.HOME_TEAM_ID,
		   D.VISITOR_TeamName,  D.VISITOR_TEAM_ID,
		   D.GAME_DATE, D.GAME_TIME, D.FieldAbbr, D.FIELD_ID, D.DIVISION, 
		   D.Virtual_TeamName, D.game_Type,
		   D.REFID,  	  D.REF_ACCEPT_DATE,	D.Ref_accept_YN,
		   D.ASSTREFID1,  D.AREF1ACPTDATE,  	D.ARef1Acpt_YN,
		   D.ASSTREFID2,  D.AREF2ACPTDATE,		D.ARef2Acpt_YN 

	 FROM  V_Games D with (nolock)  
    Where D.GAME_ID = #VARIABLES.gameID#
</cfquery>	<!--- qGameInfo<cfdump var="#qGameInfo#"> --->

<cfset GameDate		 	= DateFormat(qGameInfo.GAME_DATE,"mm/dd/yyyy") >
<cfset GameTime		 	= TimeFormat(qGameInfo.GAME_TIME,"hh:mm tt") >
<cfset OrgGameFieldAbbr	= qGameInfo.FieldAbbr >
<cfset OrgGameFieldID	= qGameInfo.FIELD_ID >
<cfset Division		 	= qGameInfo.Division >
<cfset HomeTeamId	 	= qGameInfo.HOME_TEAM_ID >
<cfset ORIGHomeTeamID   = qGameInfo.HOME_TEAM_ID >
<cfset HomeTeamName	 	= qGameInfo.HOME_TeamName >
<cfset VisitorTeamId 	= qGameInfo.VISITOR_TEAM_ID >
<cfset ORIGVisitorTeamID = qGameInfo.VISITOR_TEAM_ID >
<cfset VisitorTeamName  = qGameInfo.VISITOR_TeamName >
<cfset VirtualTeamName  = qGameInfo.Virtual_TeamName >
<cfset gameType			= qGameInfo.game_Type >
<cfset Ref_accept_YN 	= qGameInfo.Ref_accept_YN >
<cfset REFID			= qGameInfo.REFID >
<cfset ARef1Acpt_YN 	= qGameInfo.ARef1Acpt_YN >
<cfset AsstRefId1		= qGameInfo.ASSTREFID1 >
<cfset ARef2Acpt_YN 	= qGameInfo.ARef2Acpt_YN >
<cfset AsstRefId2		= qGameInfo.ASSTREFID2 >



<!---  If TBS Game is overdue by two weeks, then fine is Mandatory --->
<cfset OverDueDays = Datediff("d", GameDate, now())>
<cfif OverDueDays GT 14 and ( left(OrgGameFieldAbbr, 3) EQ "TBS" )>
	<cfset TBSFine	 = "Y">
	<cfset FineTeamYes = "checked">
<cfelse>
	<cfset TBSFine	   = "N">
	<cfset FineTeamYes = "">
</cfif>
<cfset FineTeamNo = "">
<!--- GameDate[#GameDate#] 	now()[#now()#] OverDueDays[#OverDueDays#] TBSFine[#TBSFine#] FineTeamYes[#FineTeamYes#] OrgGameFieldAbbr[#left(OrgGameFieldAbbr, 3)#] --->

<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="stTimeParams">
	<cfinvokeargument name="listType" value="DDHHMMTT"> 
</cfinvoke> 

<cfquery name="qFines" datasource="#SESSION.dsn#">
	Select FINETYPE_ID, DESCRIPTION, Amount
	  From TLKP_Fine_Type
</cfquery>

	  
<FORM name="Games" action="gameChangeProcess.cfm?gcrid=#VARIABLES.ChangeRequestID#"  method="post">
<input type="hidden" name="GameId"			value="#VARIABLES.GameId#">
<input type="hidden" name="ChangeRequestId" value="#VARIABLES.ChangeRequestId#">
<input type="hidden" name="Status" >
<input type="hidden" name="NewGameFieldID" id="NewGameFieldID"	value="#VARIABLES.NewGameFieldID#">
<input type="Hidden" name="OrgGameFieldID"	value="#VARIABLES.OrgGameFieldID#">
<input type="hidden" name="HomeTeamID"		value="#VARIABLES.HomeTeamID#">
<input type="hidden" name="VisitorTeamID"	value="#VARIABLES.VisitorTeamID#">
<input type="hidden" name="ORIGHomeTeamID"		value="#VARIABLES.ORIGHomeTeamID#">
<input type="hidden" name="ORIGVisitorTeamID"	value="#VARIABLES.ORIGVisitorTeamID#">

<span class="red">Fields marked with * are required</span>
<CFSET required = "<FONT color=red>*</FONT>">
<table cellspacing="0" cellpadding="5" align="LEFT" border="0" width="100%">
	<CFIF len(trim(msg))>
		<TR><TD colspan="3">
				<span class="red"><b>#msg#</b></span>
			</TD>
		</TR>
	</CFIF>
	<tr class="tblHeading">
		<TD colspan="3"> &nbsp; </TD>
	</TR>
	
	<TR><TD width="25%" align="right"><b>Game</b></TD>
		<TD width="50%">#VARIABLES.GameId#</TD>
		<TD width="25%" align="LEFT"><FONT color="maroon">Existing Values</font></TD>
	</TR>
	<TR><TD align="right"><B>Game Type<B></TD>
		<TD><cfswitch expression="#ucase(VARIABLES.GameType)#">
				<cfcase value="N">Non League </cfcase>
				<cfcase value="C">State Cup </cfcase>
				<cfcase value="F">Friendly  </cfcase>
				<cfdefaultcase> League </cfdefaultcase>
			</cfswitch>
		</TD>
		<TD> &nbsp; </TD>
	</TR>
	<TR><TD align="right"><b>Change Request ID</b></TD>
		<TD >#VARIABLES.ChangeRequestID#</TD>
		<TD> &nbsp; </TD>
	</TR>
	<TR><TD align="right"><b>Status</b></TD>
		<TD >#VARIABLES.requestStatus#</TD>
		<TD> &nbsp; </TD>
	</TR>
	
	<TR><TD align="right"><b>Division</b></TD>
		<TD>#VARIABLES.Division#</TD>
		<td>&nbsp;</td>
	</TR>
	<TR><TD align="right">#required#<b>Game Date</b></TD>
		<TD><input size="9" name="NewGameDate" value="#VARIABLES.NewGameDate#" readonly >
			<input size="3" name="DOW"  value="#DateFormat(VARIABLES.NewGameDate,"ddd")#" disabled>
			&nbsp;  <cfset dpMM = datePart("m",VARIABLES.NewGameDate)-1>
					<cfset dpYYYY = datePart("yyyy",VARIABLES.NewGameDate)>
			<a href="javascript:show_calendar('Games.NewGameDate','Games.DOW','#dpMM#','#dpYYYY#' );" 
					onmouseover="window.status='Date Picker';return true;" 
					onmouseout="window.status='';return true;"> 
				<img src="#SESSION.siteVars.imagePath#cal.gif" width="20" height="18" alt="" border="0">
			</a>
		</TD>
		<TD><FONT color="maroon">#GameDate# &nbsp; (#DateFormat(VARIABLES.GameDate,"ddd")# )</FONT></TD>
	</TR>

	<TR><TD align="right">#variables.required#<b>Game Time</b></TD>
		<TD align="left">
			<cfset HH = listfirst(VARIABLES.NewGameTime,":")>
			<cfset MM = listlast( listfirst(VARIABLES.NewGameTime," ") ,":")>
			<cfset TT = listlast(VARIABLES.NewGameTime," ")>
			<SELECT name="GameNewHour"> 
				<OPTION value="0" selected>HR</OPTION>
			    <CFLOOP list="#stTimeParams.hour#" index="iHr">
					<OPTION value="#iHr#" <CFIF HH EQ iHr>selected</CFIF> >#iHr#</OPTION>
				</CFLOOP>
			</SELECT>
			<SELECT name="GameNewMinute"> 
				<OPTION value="0" selected>MN</OPTION>
				<CFLOOP list="#stTimeParams.min#" index="iMn">
					<OPTION value="#iMn#" <CFIF MM EQ iMn>selected</CFIF> >#iMn#</OPTION>
				</CFLOOP>
			</SELECT>
			<SELECT name="GameNewMeridian">
				<CFLOOP list="#stTimeParams.tt#" index="iTT">
					<OPTION value="#iTT#" <CFIF TT EQ iTT>selected</CFIF> >#iTT#</OPTION>
				</CFLOOP>
			</SELECT>  
		</TD>
		<TD><FONT color="maroon">#VARIABLES.GameTime#</b></TD>
	</TR>
	<TR><TD align="right"><b>Home Team</b></TD>
		<TD><input type="Text" name="HomeTeam" value="#VARIABLES.HomeTeamName#" disabled>
		</TD>
		<td>&nbsp;</td>
	</tr>
	<TR><TD align="right"><b>Visitor Team</b></TD>
		<!--- <TD>#VARIABLES.VisitorTeamName#</TD> --->
		<TD><cfif len(trim(VARIABLES.VisitorTeamName))>
				<input type="Text" name="VisitorTeam" value="#VARIABLES.VisitorTeamName#" disabled>
				&nbsp; &nbsp; &nbsp; 
				<input type=button value="Flip Teams" onclick="FlipTeams()" id=button1 name=button1>
			<cfelseif len(trim(VARIABLES.VirtualTeamName))>
				<input type="Text" name="VisitorTeam" value="#VARIABLES.VirtualTeamName#" disabled>
			<cfelse>
				&nbsp; 
			</cfif>
		</TD>
		<TD>&nbsp; 
		</TD>
		<td>&nbsp;</td>
	</tr>

	<TR id="ClubFields" style="DISPLAY:">
		<TD align="right"> <b>PlayField</b> <br> <span class="red">(Club's list)</span> </TD>
		<TD align="left">
			<cfset FieldFound = 0>
			<CFQUERY name="HomeTeamFields" datasource="#SESSION.DSN#">
				SELECT F.FIELD_ID, F.FIELDABBR, F.FIELDNAME
				  FROM TBL_FIELD F	INNER JOIN XREF_CLUB_FIELD xcf ON xcf.field_id = F.field_id
									INNER JOIN V_GAMES	   vg  ON vg.Home_CLUB_ID = xcf.CLUB_ID
				 WHERE vg.GAME = #GameID#
				   and f.Active_YN = 'Y'
			</CFQUERY>
			<cfquery name="otherFieldValues" datasource="#SESSION.DSN#">
					SELECT F.FIELD_ID, F.FIELDABBR, F.FIELDNAME
					  FROM TBL_FIELD F  INNER JOIN XREF_CLUB_FIELD xcf ON xcf.field_id = F.field_id
					 WHERE XCF.CLUB_ID = 1 
					   and f.Active_YN = 'Y'
			</cfquery>
			<SELECT name="GameFieldClub" id="GameFieldClub" onchange="setNewFieldIDClubList()"> 
				<OPTION value="0" selected>&nbsp;</OPTION>
				<CFLOOP query="HomeTeamFields">
					<cfif NewGameFieldID EQ FIELD_ID>
					 	<cfset FieldFound = 1>
						<OPTION value="#FIELD_ID#" selected>#FIELDABBR#</OPTION>
					<cfelse>
						<OPTION value="#FIELD_ID#"		   >#FIELDABBR#</OPTION>
					</cfif>
				</CFLOOP>
				<cfif FieldFound EQ 0>
					<cfif Len(trim(NewGameFieldID)) >
						<OPTION value="#VARIABLES.NewGameFieldID#" selected>#VARIABLES.NewGameFieldAbbr#</OPTION>
					</cfif>
				</cfif>
				<CFLOOP query="otherFieldValues">
					<OPTION value="#FIELD_ID#" <cfif NewGameFieldID EQ FIELD_ID >selected</cfif> >#FIELDABBR#</OPTION>
				</CFLOOP>
			</SELECT>
			<input type=button name="DispAllFields" onclick="DisplayAllFields()" value="Display ALL Fields">
		</TD>
		<TD><FONT color="maroon">#OrgGameFieldAbbr#</FONT>
		</TD>
	</TR>
	<!--- % if( (uCase(Session("UserID")) = "GAMESCHAIRMAN" or Session("ProfileType") = "SU") ) then % --->
	<cfif (SESSION.MENUROLEID EQ 19 OR SESSION.MENUROLEID EQ 1) > <!---  19="GAMESCHAIR" 1="ASSTADMIN" --->
		<TR id="AllFields" style="DISPLAY:none">
			<TD align="right"><b>PlayField</b> <br> <span class="red">(All fields listed)</span> </TD>
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
							<OPTION value="#FIELD_ID#" <cfif NewGameFieldID EQ FIELD_ID >selected</cfif> >#FIELDABBR#</OPTION>
						</CFLOOP>
						<!--- If ( ucase(trim(Session("RoleCode"))) = "GAMESCHAIR" ) _
							  OR ( ucase(trim(Session("RoleCode"))) = "ASSTADMIN"  ) then --->
						<cfif (SESSION.MENUROLEID EQ 19 OR SESSION.MENUROLEID EQ 1) > <!---  19="GAMESCHAIR" 1="ASSTADMIN" --->
							<cfquery name="otherFieldValues" datasource="#SESSION.DSN#">
								SELECT F.FIELD_ID, F.FIELDABBR, F.FIELDNAME
								  FROM TBL_FIELD F  INNER JOIN XREF_CLUB_FIELD xcf ON xcf.field_id = F.field_id
								 WHERE XCF.CLUB_ID = 1 
								   and f.Active_YN = 'Y'
							</cfquery>
							<CFLOOP query="otherFieldValues">
								<OPTION value="#FIELD_ID#" <cfif NewGameFieldID EQ FIELD_ID>selected</cfif> >#FIELDABBR#</OPTION>
							</CFLOOP>
						</cfif>
				</SELECT>
				<input type=button name="DispClubFields" onclick="DisplayClubFields()" value="Display CLUB Fields">
			</TD>
			<TD><FONT color="maroon">#OrgGameFieldAbbr#</FONT>			</TD>
		</TR>
	</cfif>

	<TR><TD align="right" valign="top">#variables.required#<b>Reason for change/Games Chairman comments</b> <br>(500 chars max)</TD>
		<TD><TEXTAREA name="Comments"  rows=6 cols=40>#VARIABLES.Comments#</TEXTAREA>			</TD>
		<TD><FONT color="maroon">&nbsp;</b>		</TD>
	</TR>
	<TR><TD align="right" valign="top"><b>Referee Assignment Notes</b> <br>(500 chars max)</TD>
		<TD><TEXTAREA name="RefComments"  rows=3 cols=40>#VARIABLES.RefComments#</TEXTAREA>	</TD>
		<TD><FONT color="maroon">&nbsp;</b></TD>
	</TR>

	<cfif TBSFine EQ "Y">
		<tr><TD align="right">&nbsp;</TD>
			<TD><span class="red">TBS Game Schedule Over due by two Weeks. Fine is Mandatory.</span> 	</td>
			<td>&nbsp;</td>
		</tr>
	</cfif>

	<tr><TD align="right">#variables.required#<b>Fine Team?</b></TD>
		<TD><input type="Radio"  onclick="DisplayFineDetail('Y')" maxlength="1" name="FineTeam" value="Y" #FineTeamYes#> Yes
			<input type="Radio"  onclick="DisplayFineDetail('N')" maxlength="1" name="FineTeam" value="N" #FineTeamNo#>  No
		</td>
		<td>&nbsp;</td>
	</tr>

	<div id="FineDetail" align="center"  style="DISPLAY: none">
		<tr><TD align="right">#variables.required#<b>Select Team to Fine</b></TD>
			<TD><input type="Radio"  maxlength="1" name="RequestedByTeam" value="#HomeTeamId#"	> 
					#HomeTeamName#
				<input type="Radio"  maxlength="1" name="RequestedByTeam" value="#VisitorTeamID#"> 
					<cfif len(trim(VARIABLES.VisitorTeamName))>
						#VARIABLES.VisitorTeamName#
					<cfelseif len(trim(VARIABLES.VirtualTeamName))>
						#VARIABLES.VirtualTeamName#
					<cfelse>
						&nbsp; 
					</cfif>
			</td>
			<td>&nbsp;</td>
		</tr>
		<TR><TD align="right">	#variables.required#<b>Admin Fine/Fees</b> 	</TD>
			<TD colspan="2"><SELECT name="FineTypeID">
					<OPTION value="0" selected>Select Fine (if applicable)</OPTION>
						<cfloop query="qFines">
							<OPTION value="#FINETYPE_ID#" <cfIf FINETYPE_ID EQ FineID>selected</cfif> >#Trim(DESCRIPTION)#: #dollarFormat(Amount)#</OPTION>
						</cfloop>
				</Select>
			</td>
		</tr>
		<tr><td align="right"> 
				<b>For ACCEPT Change only,<br>Delete Referees?</b>
			</td>
			<TD colspan="2">
				<table>
					<tr><td>
							<SELECT name="DeleteRefs_YN">
								<OPTION value="Y" <cfIf DeleteRefs_YN EQ "Y">selected</cfif> >Yes</OPTION>
								<OPTION value="N" <cfIf DeleteRefs_YN EQ "N">selected</cfif> >No</OPTION>
							</Select>
						</td>
						<td>
							<!--- ------------------------- --->
							<br>#repeatString("&nbsp;",3)#
								<cfif Ref_accept_YN EQ "Y">
									<span class="green"><b>A</b></span>
								<cfelseif Ref_accept_YN EQ "N">
									<span class="red"><b>D</b></span>
								<cfelse>
									__<!--- [&nbsp;] --->
								</cfif>
								REF: 
								<cfif REFID GT 0>
									<!--- #RefereeLast#, #Referee#  --->
									<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getContactInfo" returnvariable="qContactInfoR">
										<cfinvokeargument name="contactID" value="#REFID#">
									</cfinvoke>
									<cfif qContactInfoR.recordCount>
										#qContactInfoR.LastName#, #qContactInfoR.firstName#
									<cfelse>
										n/a
									</cfif>
								</cfif>	
							<!--- ------------------------- --->
							<br>#repeatString("&nbsp;",3)#
								<cfif ARef1Acpt_YN EQ "Y">
									<span class="green"><b>A</b></span>
								<cfelseif ARef1Acpt_YN EQ "N">
									<span class="red"><b>D</b></span>
								<cfelse>
									__
								</cfif>
								AR1: 
								<cfif len(trim(AsstRefId1))>
									<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getContactInfo" returnvariable="qContactInfo1">
										<cfinvokeargument name="contactID" value="#AsstRefId1#">
									</cfinvoke>
									<cfif qContactInfo1.recordCount>
										#qContactInfo1.LastName#, #qContactInfo1.firstName#
									<cfelse>
										n/a
									</cfif>
								</cfif>
							<!--- ------------------------- --->
							<br>#repeatString("&nbsp;",3)#
								<cfif ARef2Acpt_YN EQ "Y">
									<span class="green"><b>A</b></span>
								<cfelseif ARef2Acpt_YN EQ "N">
									<span class="red"><b>D</b></span>
								<cfelse>
									__
								</cfif>
								AR2:  
								<cfif len(trim(AsstRefId2))>
									<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getContactInfo" returnvariable="qContactInfo2">
										<cfinvokeargument name="contactID" value="#AsstRefId2#">
									</cfinvoke>
									<cfif qContactInfo2.recordCount>
										#qContactInfo2.LastName#, #qContactInfo2.firstName#
									<cfelse>
										n/a
									</cfif>
								</cfif>
							<!--- ------------------------- --->
						</td>
					</tr>
				</table>
							
							
			</td>
		</tr>
	</div>
	
	<TR><TD colspan="3" align="center">
			<INPUT type="SUBMIT" name="Accept"	value="Accept">
			<INPUT type="SUBMIT" name="Reject"	value="Reject">
			<INPUT type="SUBMIT" name="Back"	value="Back">
		</TD>
	  </TR>
</TABLE>

</FORM>

<script language="javascript">
var cForm = document.Games.all;
function trim(s) 
{	return s.replace(/^\s+|\s+$/g, "") 
}
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

function FlipTeams()
{	var HT, VT;
	var HTID, VTID;
	HT = self.document.Games.HomeTeam.value;
	VT = self.document.Games.VisitorTeam.value;
	self.document.Games.HomeTeam.value		= VT;
	self.document.Games.VisitorTeam.value	= HT;
	HTID = self.document.Games.HomeTeamID.value;
	VTID = self.document.Games.VisitorTeamID.value;
	self.document.Games.HomeTeamID.value	= VTID;
	self.document.Games.VisitorTeamID.value	= HTID;
}



</script>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">
