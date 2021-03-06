<!--- 
	FileName:	refAssign.cfm
	Created on: 10/15/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm"> 
<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Referee Assignment</H1>
<br> <!--- <h2>yyyyyy </h2> --->


<cfif isDefined("URL.gid") AND isNumeric(URL.GID)>
	<cfset GameID = URL.gid>
<cfelseIf isDefined("FORM.GAMEID")>
	<cfset GameID = FORM.GAMEID>
<cfelse>
	<cfset GameID = 0>
</cfif>
<!--- <cfif isDefined("URL.DIV") AND len(trim(URL.DIV)) LT 7>
	<cfset DivID = URL.DIV>
<cfelseIf isDefined("FORM.DivID")>
	<cfset DivID = FORM.DivID>
<cfelse>
	<cfset DivID = "">
</cfif> --->
<cfif isDefined("URL.FROM") AND isDate(URL.FROM)>
	<cfset WeekEndFrom = URL.FROM>
<cfelseIf isDefined("FORM.WeekEndFrom")>
	<cfset WeekEndFrom = FORM.WeekEndFrom>
<cfelse>
	<cfset WeekEndFrom = "">
</cfif>
<cfif isDefined("URL.TO") AND isDate(URL.TO)>
	<cfset WeekEndTO = URL.TO>
<cfelseIf isDefined("FORM.WeekEndTO")>
	<cfset WeekEndTO = FORM.WeekEndTO>
<cfelse>
	<cfset WeekEndTO = "">
</cfif>
<!--- <cfif isDefined("URL.ST") AND len(trim(URL.ST)) LT 3>
	<cfset state = URL.ST>
<cfelseIf isDefined("FORM.state")>
	<cfset state = FORM.state>
<cfelse>
	<cfset state = "">
</cfif> --->

<cfif isDefined("URL.PageURL")>
	<cfset PageURL = URL.PageURL>
<cfelseif isDefined("FORM.PageURL")>
	<cfset PageURL = FORM.PageURL>
<cfelse>
	<cfset PageURL = "">
</cfif>


<cfset returnToPage = VARIABLES.PageURL & ".cfm?FROM=" & VARIABLES.WeekendFrom & "&TO=" & VARIABLES.WeekendTo & "&g=1">
<!--- [#returnToPage#] --->

<cfif isDefined("FORM.SAVE")>
	<!--- 
	<cfif len(trim(RefID)) EQ 0 OR RefID EQ 0>				<cfset RefID = "">		</cfif>
	<cfif len(trim(AsstRefID1)) EQ 0 OR AsstRefID1 EQ 0>	<cfset AsstRefID1 = "">	</cfif>
	<cfif len(trim(AsstRefID2)) EQ 0 OR AsstRefID2 EQ 0>	<cfset AsstRefID2 = "">	</cfif>
	--->
	<cfif isDefined("FORM.RefID") AND len(trim(FORM.RefID)) AND FORM.RefID GT 0>
		<cfset RefID = FORM.RefID>
	<cfelse>
		<cfset RefID = "">
	</cfif>
	<cfif isDefined("FORM.AsstRefID1") AND len(trim(FORM.AsstRefID1)) AND FORM.AsstRefID1 GT 0>
		<cfset AsstRefID1 = FORM.AsstRefID1>
	<cfelse>
		<cfset AsstRefID1 = "">
	</cfif>
	<cfif isDefined("FORM.AsstRefID2") AND len(trim(FORM.AsstRefID2)) AND FORM.AsstRefID2 GT 0>
		<cfset AsstRefID2 = FORM.AsstRefID2>
	<cfelse>
		<cfset AsstRefID2 = "">
	</cfif>
	
	<CFQUERY name="qCurrentOfficialValues" datasource="#SESSION.DSN#">
		Select  game
			 	,RefID		,xref_game_official_id
			 	,AsstRefID1	,AsstRef1_game_official_id
			 	,AsstRefID2	,AsstRef2_game_official_id
		  from  V_Games
		 Where  Game = #VARIABLES.GameID#
	</CFQUERY>
	<CFIF qCurrentOfficialValues.RECORDCOUNT>
		<cfset CRefID				 = qCurrentOfficialValues.RefID >
		<cfset CRefID_official		 = qCurrentOfficialValues.xref_game_official_id >
		<cfset CAsstRefID1			 = qCurrentOfficialValues.AsstRefID1 >
		<cfset CAsstRefID1_official  = qCurrentOfficialValues.AsstRef1_game_official_id >
		<cfset CAsstRefID2			 = qCurrentOfficialValues.AsstRefID2 >
		<cfset CAsstRefID2_official  = qCurrentOfficialValues.AsstRef2_game_official_id >
	</CFIF>

	<cfif len(trim(CRefID)) EQ 0>
		<cfset CRefID = "">
	</cfif>
	<cfif len(trim(CAsstRefID1)) EQ 0>
		<cfset CAsstRefId1 = "">
	</cfif>
	<cfif len(trim(CAsstRefID2)) EQ 0>
		<cfset CAsstRefId2 = "">
	</cfif>
	
	<cfif CRefID NEQ RefID OR AsstRefID1 NEQ CAsstRefID1 OR AsstRefID2 NEQ CAsstRefID2>
		<!---  Create the record in the log before changing the games information  --->
		<cfstoredproc procedure="p_LOG_Game" datasource="#SESSION.DSN#">
			<cfprocparam dbvarname="@game_id" cfsqltype="CF_SQL_NUMERIC"  value="#VARIABLES.GameID#">
			<cfprocparam dbvarname="@username" cfsqltype="CF_SQL_VARCHAR" value="#SESSION.USER.CONTACTID#">
			<cfprocparam dbvarname="@pagename" cfsqltype="CF_SQL_VARCHAR" value="#CGI.Script_Name#">
		</cfstoredproc>

		<cfstoredproc procedure="p_LOG_RefereeReportDetail" datasource="#SESSION.DSN#">
			<cfprocparam dbvarname="@game_id" cfsqltype="CF_SQL_NUMERIC"  value="#VARIABLES.GameID#">
			<cfprocparam dbvarname="@username" cfsqltype="CF_SQL_VARCHAR" value="#SESSION.USER.CONTACTID#">
			<cfprocparam dbvarname="@pagename" cfsqltype="CF_SQL_VARCHAR" value="#CGI.Script_Name#">
		</cfstoredproc>

		<cfquery name="deleteRefDetail" datasource="#SESSION.DSN#">
				Delete from TBL_REFEREE_RPT_DETAIL Where Game_ID = #GameID#
		</cfquery>

		<cfstoredproc procedure="p_LOG_RefereeReportHeader" datasource="#SESSION.DSN#">
			<cfprocparam dbvarname="@game_id" cfsqltype="CF_SQL_NUMERIC"  value="#VARIABLES.GameID#">
			<cfprocparam dbvarname="@username" cfsqltype="CF_SQL_VARCHAR" value="#SESSION.USER.CONTACTID#">
			<cfprocparam dbvarname="@pagename" cfsqltype="CF_SQL_VARCHAR" value="#CGI.Script_Name#">
		</cfstoredproc>

		<cfquery name="deleteRefHeader" datasource="#SESSION.DSN#">
			Delete from TBL_REFEREE_RPT_HEADER Where Game_ID = #GameID#
		</cfquery>

		<!---  It could be that only one of the three referees has changed, so the acccept date should be NULLified for changed ones only --->
		<cfif CRefID NEQ RefID>				<!---  1 = head referee official type id = 1 --->
			<cfif len(trim(CRefID)) EQ 0>	<!---  INSERT head ref into XREF_GAME_OFFICIAL --->
				<cfstoredproc procedure="p_insert_xref_game_official" datasource="#SESSION.DSN#">
					<cfprocparam dbvarname="@officialTypeID" cfsqltype="CF_SQL_NUMERIC" value="1">
					<cfprocparam dbvarname="@ContactID" 	 cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.REFID#">
					<cfprocparam dbvarname="@gameID"		 cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameID#">
				</cfstoredproc>
				[R]
			<cfelse> 							<!---  UPDATE replace head ref xref_game_official --->
				<cfif len(trim(RefId)) EQ 0> 	<!--- removing the ref so delete xref --->
					<cfstoredproc procedure="p_delete_xref_game_official" datasource="#SESSION.DSN#">
						<cfprocparam dbvarname="@officialTypeID" cfsqltype="CF_SQL_NUMERIC" value="1">
						<cfprocparam dbvarname="@OldContactID" 	 cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.CRefID#">
						<cfprocparam dbvarname="@gameID"		 cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameID#">
					</cfstoredproc>
				<cfelse>
					<cfstoredproc procedure="p_update_xref_game_official" datasource="#SESSION.DSN#">
						<cfprocparam dbvarname="@officialTypeID" cfsqltype="CF_SQL_NUMERIC" value="1">
						<cfprocparam dbvarname="@NewContactID" 	 cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.RefId#">
						<cfprocparam dbvarname="@OldContactID" 	 cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.CRefID#">
						<cfprocparam dbvarname="@gameID"		 cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameID#">
					</cfstoredproc>
				</cfif>
				[R2]
			</cfif>
		</cfif>
		<!--- ASSIST. REF 1 --->	
		<cfif CAsstRefID1 NEQ AsstRefID1>  	 	<!--- 2 = head referee official type id = 2  --->
			<cfif len(trim(CAsstRefID1)) EQ 0> 	<!---  INSERT asst ref 1 into XREF_GAME_OFFICIAL --->
				<cfstoredproc procedure="p_insert_xref_game_official" datasource="#SESSION.DSN#">
					<cfprocparam dbvarname="@officialTypeID" cfsqltype="CF_SQL_NUMERIC" value="2">
					<cfprocparam dbvarname="@ContactID" 	 cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.AsstRefID1#">
					<cfprocparam dbvarname="@gameID"		 cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameID#">
				</cfstoredproc>
				[AR1]
			<cfelse> 								<!---  UPDATE xref_game_official --->
				<cfif len(trim(AsstRefID1)) EQ 0> 	<!--- removing the ref so delete xref --->
					<cfstoredproc procedure="p_delete_xref_game_official" datasource="#SESSION.DSN#">
						<cfprocparam dbvarname="@officialTypeID" cfsqltype="CF_SQL_NUMERIC" value="2">
						<cfprocparam dbvarname="@OldContactID" 	 cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.CAsstRefID1#">
						<cfprocparam dbvarname="@gameID"		 cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameID#">
					</cfstoredproc>
				[AR1a]
				<cfelse>
					<cfstoredproc procedure="p_update_xref_game_official" datasource="#SESSION.DSN#">
						<cfprocparam dbvarname="@officialTypeID" cfsqltype="CF_SQL_NUMERIC" value="2">
						<cfprocparam dbvarname="@NewContactID" 	 cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.AsstRefID1#">
						<cfprocparam dbvarname="@OldContactID" 	 cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.CAsstRefID1#">
						<cfprocparam dbvarname="@gameID"		 cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameID#">
					</cfstoredproc>
				[AR1b]
				</cfif>
			</cfif>
		</cfif>
		<!--- ASSIST. REF 2 --->	
		<cfif CAsstRefID2 NEQ AsstRefID2>  		<!---  3 = asst ref 2 official type id = 3 --->
			<cfif len(trim(CAsstRefID2)) EQ 0>	<!---  INSERT asst ref 2 into XREF_GAME_OFFICIAL --->
				<cfstoredproc procedure="p_insert_xref_game_official" datasource="#SESSION.DSN#">
					<cfprocparam dbvarname="@officialTypeID" cfsqltype="CF_SQL_NUMERIC" value="3">
					<cfprocparam dbvarname="@ContactID" 	 cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.AsstRefID2#">
					<cfprocparam dbvarname="@gameID"		 cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameID#">
				</cfstoredproc>
				[AR2]
			<cfelse> 								<!---  UPDATE xref_game_official --->
				<cfif len(trim(AsstRefID2)) EQ 0>  	<!--- removing the ref so delete xref --->
					<cfstoredproc procedure="p_delete_xref_game_official" datasource="#SESSION.DSN#">
						<cfprocparam dbvarname="@officialTypeID" cfsqltype="CF_SQL_NUMERIC" value="3">
						<cfprocparam dbvarname="@OldContactID" 	 cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.CAsstRefID2#">
						<cfprocparam dbvarname="@gameID"		 cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameID#">
					</cfstoredproc>
					[AR2a]
				<cfelse>
					<cfstoredproc procedure="p_update_xref_game_official" datasource="#SESSION.DSN#">
						<cfprocparam dbvarname="@officialTypeID" cfsqltype="CF_SQL_NUMERIC" value="3">
						<cfprocparam dbvarname="@NewContactID" 	 cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.AsstRefID2#">
						<cfprocparam dbvarname="@OldContactID" 	 cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.CAsstRefID2#">
						<cfprocparam dbvarname="@gameID"		 cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameID#">
					</cfstoredproc>
					[AR2b]
				</cfif>
			</cfif>
		</cfif>

	</cfif>
	<CFLOCATION url="#VARIABLES.returnToPage#">
</cfif>
	
<CFIF isDefined("FORM.DELETE")>
	<cfstoredproc procedure="p_LOG_Game" datasource="#SESSION.DSN#">
		<cfprocparam dbvarname="@game_id" cfsqltype="CF_SQL_NUMERIC"  value="#VARIABLES.GameID#">
		<cfprocparam dbvarname="@username" cfsqltype="CF_SQL_VARCHAR" value="#SESSION.USER.CONTACTID#">
		<cfprocparam dbvarname="@pagename" cfsqltype="CF_SQL_VARCHAR" value="#CGI.Script_Name#">
	</cfstoredproc>

	<cfstoredproc procedure="p_LOG_RefereeReportHeader" datasource="#SESSION.DSN#">
		<cfprocparam dbvarname="@game_id" cfsqltype="CF_SQL_NUMERIC"  value="#VARIABLES.GameID#">
		<cfprocparam dbvarname="@username" cfsqltype="CF_SQL_VARCHAR" value="#SESSION.USER.CONTACTID#">
		<cfprocparam dbvarname="@pagename" cfsqltype="CF_SQL_VARCHAR" value="#CGI.Script_Name#">
	</cfstoredproc>

	<cfquery name="deleteRefHeader" datasource="#SESSION.DSN#">
		Delete from TBL_REFEREE_RPT_HEADER Where Game_ID = #GameID#
	</cfquery>

	<cfstoredproc procedure="p_LOG_RefereeReportDetail" datasource="#SESSION.DSN#">
		<cfprocparam dbvarname="@game_id" cfsqltype="CF_SQL_NUMERIC"  value="#VARIABLES.GameID#">
		<cfprocparam dbvarname="@username" cfsqltype="CF_SQL_VARCHAR" value="#SESSION.USER.CONTACTID#">
		<cfprocparam dbvarname="@pagename" cfsqltype="CF_SQL_VARCHAR" value="#CGI.Script_Name#">
	</cfstoredproc>

	<cfquery name="deleteRefDetail" datasource="#SESSION.DSN#">
			Delete from TBL_REFEREE_RPT_DETAIL Where Game_ID = #GameID#
	</cfquery>
		
	<cfquery name="deleteOfficials" datasource="#SESSION.DSN#">
		DELETE FROM XREF_GAME_OFFICIAL  WHERE GAME_ID = #GameID#
	</cfquery>

	<CFLOCATION url="#VARIABLES.returnToPage#">
</CFIF>

<CFIF isDefined("FORM.BACK")>
	<CFLOCATION url="#VARIABLES.returnToPage#">
</CFIF>




<!--- Weekend	= Request("Weekend")
PageURL	= Request("PageURL") --->

<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getReferees" returnvariable="qReferees">
	<cfinvokeargument name="certifiedOnly" value="Y"> 
</cfinvoke>


<cfset BoardUser	= "">
<cfset RefID2		= "">
<cfif listFind("2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,21",Session.menuroleID) GT 1>  <!--- ("ProfileType")) = "BU" ) and Trim(ucase(trim(Session("RoleCode"))) <> "GAMECONDCH") then --->
	<cfset BoardUser = "Y">
	<cfset RefName	 = Session.USER.CLUB_NAME>
	<!--- 
	<CFQUERY name="getRefIds" datasource="#SESSION.DSN#">
		Select Id from V_Refereee Where Referee + ' ' + RefereeLast = '#RefName#'
	</CFQUERY> 
	<cfif getRefIds.RECORDCOUNT>
		<cfset RefId2  = getRefIds.ID>
		<cfset RefName	= "<font face=verdana size=2><b>" & Session.USER.CLUB_NAME & "</b></font>">
	<cfelse>
		<cfset RefID2 = "">
		<cfset RefName = "<font color=red face=verdana size=2><b>Referee Not found</b></font>">
	</cfif>
	--->
	<CFQUERY name="getRefIds" dbtype="query">
		Select contact_id from qReferees Where FirstName + ' ' + LastName = '#RefName#'
	</CFQUERY>
	<cfif getRefIds.RECORDCOUNT>
		<cfset RefId2  = getRefIds.contact_id>
		<cfset RefName	= "<font face=verdana size=2><b>" & Session.USER.CLUB_NAME & "</b></font>">
	<cfelse>
		<cfset RefID2 = "">
		<cfset RefName = "<font color=red face=verdana size=2><b>Referee Not found</b></font>">
	</cfif>
</cfif>


<!--- <CFQUERY name="qReferees" datasource="#SESSION.DSN#">
	Select ID, Referee, RefereeLast from V_RefereeS where ACTIVE_YN = 'Y' Order by RefereeLast, Referee
</CFQUERY> --->


					
<CFQUERY name="qGameInfo" datasource="#SESSION.DSN#">
	SELECT  GAME_DATE, GAME_TIME, VISITOR_TEAMNAME, HOME_TEAMNAME,
			FIELDABBR, DIVISION, REFID,
			SCORE_VISITOR, SCORE_HOME, ASSTREFID1, ASSTREFID2,
			Ref_accept_Date, AREF1ACPTDATE, AREF2ACPTDATE
	  FROM  V_GAMES
	 WHERE  GAME_ID = #VARIABLES.gameID#
</CFQUERY>

<cfif qGameInfo.RECORDCOUNT>
	<cfset GameDate		= qGameInfo.GAME_DATE>
	<cfset GameTime		= qGameInfo.GAME_TIME>
	<cfset HomeTeam		= qGameInfo.HOME_TEAMNAME>
	<cfset VisitorTeam	= qGameInfo.VISITOR_TEAMNAME>
	<cfset FieldAbbr	= qGameInfo.FIELDABBR>
	<cfset Division		= qGameInfo.DIVISION>
	<cfset RefID		= qGameInfo.REFID>
	<cfset HomeScore	= qGameInfo.SCORE_HOME>
	<cfset VisitorScore	= qGameInfo.SCORE_VISITOR>
	<cfset AsstRefID1	= qGameInfo.ASSTREFID1>
	<cfset AsstRefID2	= qGameInfo.ASSTREFID2>
	<cfset RefAcptDate	= qGameInfo.Ref_accept_Date>
	<cfset ARef1AcptDate= qGameInfo.AREF1ACPTDATE>
	<cfset ARef2AcptDate= qGameInfo.AREF2ACPTDATE>
<cfelse>
	<cfset GameDate		= "">
	<cfset GameTime		= "">
	<cfset HomeTeam		= "">
	<cfset VisitorTeam	= "">
	<cfset FieldAbbr	= "">
	<cfset Division		= "">
	<cfset RefID		= "">
	<cfset HomeScore	= "">
	<cfset VisitorScore	= "">
	<cfset AsstRefID1	= "">
	<cfset AsstRefID2	= "">
	<cfset RefAcptDate	= "">
	<cfset ARef1AcptDate= "">
	<cfset ARef2AcptDate= "">
</cfif>

<cfif len(trim(RefID)) GT 0>
	<CFQUERY name="qRefName" dbtype="query">
		Select LastName, FirstName	From qReferees Where contact_id = #VARIABLES.RefID#
	</cfquery>
	<cfif qRefName.recordCount>
		<cfset RefName = qRefName.LastName & ", " & qRefName.FirstName>
	<cfelse>
		<cfset RefName = "">
	</cfif>
</cfif>

<cfif len(trim(AsstRefID1)) GT 0>
	<CFQUERY name="qAR1name" dbtype="query">
		Select LastName, FirstName	From qReferees Where contact_id = #VARIABLES.AsstRefID1#
	</cfquery>
	<cfif qAR1name.recordCount>
		<cfset AsstRefName1 = qAR1name.LastName & ", " & qAR1name.FirstName>
	<cfelse>
		<cfset AsstRefName1 = "">
	</cfif>
</cfif>

<cfif len(trim(AsstRefID2)) GT 0>
	<CFQUERY name="qAR2name" dbtype="query">
		Select LastName, FirstName	From qReferees Where contact_id = #VARIABLES.AsstRefID2#
	</cfquery>
	<cfif qAR2name.recordCount>
		<cfset AsstRefName2 = qAR2name.LastName & ", " & qAR2name.FirstName>
	<cfelse>
		<cfset AsstRefName2 = "">
	</cfif>
</cfif>

			
<FORM name="Referee" action="refAssign.cfm"  method="post">
<input type="hidden" name="GameId"		 value="#GameId#">
<input type="hidden" name="WeekendFrom"	 value="#WeekendFrom#">
<input type="hidden" name="WeekendTo"	 value="#WeekendTo#">
<input type="hidden" name="PageURL" 	 value="#PageURL#">
<input type="hidden" name="Mode">




<span class="red">Fields marked with * are required</span>
<CFSET required = "<FONT color=red>*</FONT>">

<table cellspacing="0" cellpadding="5" align="left" border="0" width="75%">
	<tr class="tblHeading">
		<TD colspan="2"> &nbsp; </TD>
	</tr>
	<TR><TD width="30%" align="right"><B>Game</b></TD>
		<TD>#GameId#</TD>
	</TR>
	<TR><TD align="right"><B>Division</b></TD>
			<TD>#(Division)#</TD>
	</TR>
	<TR><TD align="right"><B>Game Date</b></TD>
		<td>#dateFormat(GameDate,"mm/dd/yy")#</td>
	</TR>
	<TR><TD align="right"><B>Game Time</b></TD>
		<TD>#timeFormat(GameTime,"hh:mm tt")#</td>
	</TR>
	<TR><TD align="right"><B>Home Team</b></TD>
		<TD>#HomeTeam#</TD>
	</TR>
	<TR><TD align="right"><B>Visitor Team</b></TD>
		<TD>#VisitorTeam#</TD>
	</TR>
	<TR id="ClubFields" style="DISPLAY: inline">
		<TD align="right"><B>PlayField</b> </TD>
		<TD>#FieldAbbr#</td>
	</TR>
	</TR><TD align="right">#required# <B>Referee</b> 	</TD>
		<td><!--- if (isNull(HomeScore) and isNull(VisitorScore)) and (BoardUser <> "Y") or ( ucase(trim(Session("RoleCode"))) = "ASSTADMIN")  then --->
			<cfif (len(trim(HomeScore)) EQ 0 and len(trim(VisitorScore)) eq 0) AND (BoardUser NEQ "Y") OR (SESSION.MenuRoleID EQ 1)  >
				<SELECT name="RefID" > 
					<OPTION value="0" selected>Select Referee</OPTION>
					<cfloop query="qReferees">
						<OPTION value="#contact_id#" <cfif RefID eq contact_id>selected</cfif> > #LastName#, #FirstName#</OPTION>
					</cfloop>
				</SELECT>
			<cfelse>
				<input type="hidden" name="refId" value="#RefID#">
				#RefName#
			</cfif>	
 			<cfif len(trim(REFACPTDATE)) GT 0><!--- <cfif not (isNull(RefAcptDate) and Trim(RefAcptDate) = "") then --->
				&nbsp;<span class="red">CONF</span>
			</cfif>
		</td>
	</TR>
	<TR><TD width="30%" align="right">#required# <B>Asst Referee ##1</B> </TD>
		<td><!--- if (isNull(HomeScore) and isNull(VisitorScore)) and (BoardUser <> "Y") or ( ucase(trim(Session("RoleCode"))) = "ASSTADMIN" )  then --->
			<cfif (len(trim(HomeScore)) EQ 0 and len(trim(VisitorScore)) eq 0) AND (BoardUser NEQ "Y") OR (SESSION.MenuRoleID EQ 1)  >
				<SELECT name="AsstRefID1" > 
					<OPTION value="0" selected>Select Asst Ref 1</OPTION>
					<cfloop query="qReferees">
						<OPTION value="#contact_id#" <cfif AsstRefId1 eq contact_id>selected</cfif> >#LastName#, #FirstName#</OPTION>
					</cfloop>
				</SELECT>
			<cfelse>
				<input type="hidden" name="AsstRefId1" value="#AsstRefID1#">
				#AsstRefName1#
			</cfif>	
			<cfif len(trim(AREF1ACPTDATE)) GT 0><!--- if not (isNull(ARef1AcptDate) and Trim(ARef1AcptDate) = "") then --->
				&nbsp;<span class="red">CONF</span>
			</cfif>
		</td>
	</TR>
	<TR><TD class="tdUnderLine"  align="right">#required# <B>Asst Referee ##2</B> 	</TD>
		<td class="tdUnderLine" ><!--- if (isNull(HomeScore) and isNull(VisitorScore)) and (BoardUser <> "Y") or ( ucase(trim(Session("RoleCode"))) = "ASSTADMIN")  then --->
			<cfif (len(trim(HomeScore)) EQ 0 and len(trim(VisitorScore)) eq 0) AND (BoardUser NEQ "Y") OR (SESSION.MenuRoleID EQ 1)  >
				<SELECT name="AsstRefID2" > 
					<OPTION value="0" selected>Select Asst Ref 2</OPTION>
					<cfloop query="qReferees">
						<OPTION value="#contact_id#" <cfif AsstRefId2 eq contact_id>selected</cfif> >#LastName#, #FirstName#</OPTION>
					</cfloop>
				</SELECT>
			<cfelse>
				<input type="hidden" name="AsstRefId2" value="#AsstRefID2#">
				#AsstRefName2#
			</cfif>	
			<cfif len(trim(AREF2ACPTDATE)) GT 0><!--- if not (isNull(ARef2AcptDate) and Trim(ARef2AcptDate) = "") then --->
				&nbsp;<span class="red">CONF</span>
			</cfif>
		</td>
	</TR>
	<TR><TD> &nbsp; </TD>
		<TD align="left"><!--- if ( isNull(HomeScore) and isNull(VisitorScore) )  or ( ucase(trim(Session("RoleCode"))) = "ASSTADMIN") then  --->
			<cfif (len(trim(HomeScore)) EQ 0 and len(trim(VisitorScore)) eq 0) AND (BoardUser NEQ "Y") OR (SESSION.MenuRoleID EQ 1)  >
				<INPUT type="submit" name="Save" value="Save">
			</cfif>

			<cfif RefId GT 0 and (len(trim(HomeScore)) EQ 0 and len(trim(VisitorScore)) eq 0)>
				<INPUT type="submit" name="Delete" value="Delete" onClick="return DeleteIt()">
			</cfif>
			<INPUT type="submit" name="Back" value="Back">
		</TD>
	</TR>
</TABLE>
</FORM>

<script language="javascript">
var cForm = document.Referee.all;

function GoBack()
{	history.back(-1)
}
function SubmitIt()
{	document.Referee.Mode.value = "SAVE";
	if ( document.Referee.RefID.value == 0 )
	{	cForm("error").style.display = "inline";
		return false;
	}
	return true;
}
function DeleteIt()
{	document.Referee.Mode.value = "DELETE";
	delYN = confirm ("Are you sure to De-Assign Referee")
	if (delYN)
	{	return true;
	}
	return false;
}
</script>




</cfoutput>
</div>
<cfinclude template="_footer.cfm">
