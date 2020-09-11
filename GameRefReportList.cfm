<!--- 
	FileName:	GameRefReportList.cfm
	Created on: 10/21/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
04/02/2009 - aarnone - dbo.formatdatetime() and added logic for GameDateLimit
04/06/2009 - AARNONE - T:7491 with (nolock) added to v_games (perf issue)
04/07/2009 - aarnone - pop up for filled out ref report
05/14/2009 - aarnone - added printer friendly
05/25/2017 - apinzone - moved table headers into scrollable area.


	NOTE! - changes to this page may also have to be included into GameRefReportListPDF.cfm
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Referee Game Report List</H1><!--- <br> <h2>yyyyyy </h2> --->


<CFIF isDefined("URL.pg") AND isNumeric(URL.pg)>
	<script> window.open('gameRefReportPrint.cfm?gid=#URL.pg#','popwin'); </script> 
</CFIF>

<CFIF SESSION.menuRoleID EQ 25> <!--- logged in as referee, using referee menu --->
	<cfset refereeContactID = SESSION.USER.CONTACTID>
</CFIF>
<cfif IsDefined("FORM.SortBy")>
	 <cfset sortBy = FORM.SortBy>
	 <cfswitch expression="#UCASE(FORM.SortBy)#">
	 	<cfcase value="GAME">		<cfset orderBy = " ORDER BY GAME_ID ">								</cfcase>
	 	<cfcase value="DIV">		<cfset orderBy = " ORDER BY DIVISION, GAME_DATE, dbo.formatDateTime(GAME_TIME,'HH:MM 24') ">		</cfcase>
	 	<cfcase value="VISITOR">	<cfset orderBy = " ORDER BY VISITOR_TEAMNAME, GAME_DATE, dbo.formatDateTime(GAME_TIME,'HH:MM 24') "></cfcase>
	 	<cfcase value="HOME">		<cfset orderBy = " ORDER BY HOME_TEAMNAME, GAME_DATE, dbo.formatDateTime(GAME_TIME,'HH:MM 24') ">	</cfcase>
	 	<cfcase value="PLAYFIELD">	<cfset orderBy = " ORDER BY FieldAbbr, GAME_DATE, dbo.formatDateTime(GAME_TIME,'HH:MM 24') ">		</cfcase>
	 	<cfdefaultcase>				<cfset orderBy = " ORDER BY GAME_DATE, dbo.formatDateTime(GAME_TIME,'HH:MM 24') ">					</cfdefaultcase>
	 </cfswitch>
<cfelse>
	<cfset sortBy = "DATE">
	<cfset orderBy = " ORDER BY GAME_DATE, dbo.formatDateTime(GAME_TIME,'HH:MM 24') ">
</cfif>

<CFSET GameDateLimit = "">
<CFIF isDefined("SESSION.GLOBALVARS.REFASSIGNVIEWDATEYN") AND SESSION.GLOBALVARS.REFASSIGNVIEWDATEYN EQ "Y">
	<CFIF SESSION.menuRoleID EQ 25 AND isDate(SESSION.GLOBALVARS.REFASSIGNVIEWDATE)>
		<CFSET GameDateLimit = SESSION.GLOBALVARS.REFASSIGNVIEWDATE >
	</CFIF>
</CFIF>

<CFQUERY name="qGetRefGames" datasource="#SESSION.DSN#">
	Select Game_ID, GAME_Date, GAME_Time, Division, Fieldname, FieldAbbr, FIELD_ID, GAME_TYPE,
	       Home_CLUB_ID, HOME_TEAMNAME, VISITOR_TEAMNAME, Forfeit_Home, Forfeit_Visitor, 
		   RefID, 	   REF_ACCEPT_YN, Ref_accept_Date, 
		   AsstRefID1, ARef1Acpt_YN,  ARef1AcptDate,
		   AsstRefID2, ARef2Acpt_YN,  ARef2AcptDate 
	  from V_Games A  with (nolock)
	 WHERE RefID = #VARIABLES.refereeContactID#
	   AND REF_ACCEPT_YN = 'Y'
	   AND ( GAME_TYPE IS NULL OR GAME_TYPE = 'L')
	<cfif isDate(GameDateLimit)>
		AND GAME_Date <= '#VARIABLES.gameDateLimit#'  	
	</cfif>
	 #preserveSingleQuotes(VARIABLES.orderBy)#
</CFQUERY> 
<!--- only need games where ref is head ref 
		AND  REF_ACCEPT_YN = 'Y'
		AND  ( GAME_TYPE IS NULL OR GAME_TYPE = 'L')
 --->


<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="arrGameType">
	<cfinvokeargument name="listType" value="GAMETYPE"> 
</cfinvoke> 

<FORM name="GameList" action="gameRefReportList.cfm"  method="post" >
<input type="Hidden" name="refContactID" value="#VARIABLES.refereeContactID#">
<table cellspacing="0" cellpadding="3" align="center" border="0"  width="100%" >
<tr><td colspan="5" align="left">
		<span class="red">
				- Click on the Game number OR "missing" to submit a report
			<br>- "Yes" under RPT in the last column signifies Referee Report for the game has been submitted
			<br>- "missing" under RPT in the last column signifies Referee Report has not been submitted
			<br>- Referee report must still be printed and mailed to league office (see instructions on referee login page) 
			<br>- Passes of red carded players and coaches must be mailed within 24 hours to league office
		</span>
	</td>
	<td colspan="3" align="right" valign="bottom">
		<br>Sort:
		<select name="sortBy">
			<option value="DATE" 	<cfif sortBy EQ "DATE">selected</cfif> >	Game Date</option>
			<option value="GAME" 	<cfif sortBy EQ "GAME">selected</cfif> >	Game Number</option>
			<option value="DIV" 	<cfif sortBy EQ "DIV">selected</cfif> > 	Division</option>
			<option value="VISITOR" <cfif sortBy EQ "VISITOR">selected</cfif> > Visting Team</option>
			<option value="HOME" 	<cfif sortBy EQ "HOME">selected</cfif> >    Home Team</option>
			<option value="PLAYFIELD" <cfif sortBy EQ "PLAYFIELD">selected</cfif> > Play Field</option>
		</select>
		<input type="submit" name="resort" value="Resort">
		<input type="Submit" name="printme" value="Printer Friendly" >
	</td>
</tr>
<!--- <tr class="tblHeading">
	<TD width="18%" valign="bottom">Date/Time	</TD>
    <TD width="06%" valign="bottom">Game		</TD>
    <TD width="05%" valign="bottom">Div		</TD>
	<TD width="18%" valign="bottom">PlayField 	</TD>
	<TD width="25%" valign="bottom">Home Team <br> Visitor Team	</TD>
	<TD width="20%" valign="bottom">Refs	</TD>
	<TD width="10%" valign="bottom">Rpt	</TD>
</TR> --->
</table>


<div style="overflow:auto; height:500px; border:1px ##cccccc solid;"> 
	<table cellspacing="0" cellpadding="3" border="0" width="800px" align="left" >
		<tr class="tblHeading">
			<TD width="18%" valign="bottom">Date/Time	</TD>
		    <TD width="06%" valign="bottom">Game		</TD>
		    <TD width="05%" valign="bottom">Div		</TD>
			<TD width="18%" valign="bottom">PlayField 	</TD>
			<TD width="25%" valign="bottom">Home Team <br> Visitor Team	</TD>
			<TD width="20%" valign="bottom">Refs	</TD>
			<TD width="10%" valign="bottom">Rpt	</TD>
		</TR>
	<cfif qGetRefGames.RECORDCOUNT >
		<CFLOOP query="qGetRefGames">
			<!--- ONLY show games where ref is Head Ref and they Accepted the Assignment, supress when they are an AR1 0r AR2 --->
			<cfif refID EQ refereeContactID AND REF_ACCEPT_YN EQ 'Y'>
				<cfquery name="qRefRpt" datasource="#SESSION.DSN#">
					SELECT  Game_ID, StartTime
					  FROM  TBL_REFEREE_RPT_HEADER
					 WHERE  Game_ID = #GAME_ID#
				</cfquery>
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
					<TD width="18%"  class="tdUnderLine" valign="top" align="left">
						#dateFormat(GAME_DATE,"ddd")#&nbsp;&nbsp;#dateFormat(GAME_DATE,"mm/dd/yy")#&nbsp;&nbsp;#timeFormat(GAME_TIME,"hh:mm tt")# 
						<cfif len(Trim(GAME_TYPE))>
							<cfloop from="1" to="#arrayLen(arrGameType)#" step="1" index="iGt">
								<cfif GAME_TYPE EQ arrGameType[igt][1]>
									<br>  <SPAN class="red">#arrGameType[igt][3]#</span>
									<cfbreak>
								</cfif>
							</cfloop>
						</cfif>
					</TD>
					<TD width="06%"  class="tdUnderLine" valign="top" align="left">
						<!--- <a href="gameReportSubmit.cfm?gid=#GAME_ID#">#GAME_ID#</a> --->
						<cfif qRefRpt.RECORDCOUNT>
							<cfif listFind("1,2,19,20,21",SESSION.MENUROLEID)> 1=ASSTADMIN, 2=PRESIDENT, 19=GAMESCHAIR, 20=GAMECONDCH, 21=REFDEVELCO
								<a href="xxxxx.cfm?GameId=#GAME_ID#&RefID=#GameRefID#">#GAME_ID#</a>
							<cfelse>
								#GAME_ID#
							</cfif>
						<cfelse>
							<a href="gameReportSubmit.cfm?gid=#GAME_ID#">
								<span class="red">#GAME_ID#</span>
							</a>
						</cfif>
					</TD>
					<TD width="05%" class="tdUnderLine" valign="top" >#DIVISION#</TD>
					<TD width="18%" class="tdUnderLine" valign="top">
						<a href="fieldDirPop.cfm?fid=#FIELD_ID#" target="_blank">#FieldAbbr#</a>
					</TD>
					<TD width="25%" class="tdUnderLine" valign="top">
								(#Forfeit_Home#)    #Home_TEAMNAME#	
							<br>(#Forfeit_Visitor#) #VISITOR_TEAMNAME#
					</TD>
					<td width="23%" class="tdUnderLine" valign="top">
							<cfif Ref_accept_YN EQ "Y">
								<span class="green"><b>A</b></span>
							<cfelseif Ref_accept_YN EQ "N">
								<span class="red"><b>D</b></span>
							<cfelse>
								&nbsp;
							</cfif>
							REF:
							<cfif len(trim(RefID))>
								<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getContactInfo" returnvariable="qContactInfo">
									<cfinvokeargument name="contactID" value="#RefID#">
								</cfinvoke>
								<cfif qContactInfo.recordCount>
									#qContactInfo.LastName#, #qContactInfo.firstName#
								<cfelse>
									n/a
								</cfif>
							</cfif>
						<br><!--- ----- --->
							<cfif ARef1Acpt_YN EQ "Y">
								<span class="green"><b>A</b></span>
							<cfelseif ARef1Acpt_YN EQ "N">
								<span class="red"><b>D</b></span>
							<cfelse>
								&nbsp;
							</cfif>
							AR1:
							<cfif len(trim(AsstRefId1)) AND ARef1Acpt_YN EQ 'Y'>
								<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getContactInfo" returnvariable="qContactInfo1">
									<cfinvokeargument name="contactID" value="#AsstRefId1#">
								</cfinvoke>
								<cfif qContactInfo1.recordCount>
									#qContactInfo1.LastName#, #qContactInfo1.firstName#
								</cfif>
							<cfelse>
								n/a
							</cfif>
						<br><!--- -------- --->
							<cfif ARef2Acpt_YN EQ "Y">
								<span class="green"><b>A</b></span>
							<cfelseif ARef2Acpt_YN EQ "N">
								<span class="red"><b>D</b></span>
							<cfelse>
								&nbsp;
							</cfif>
							AR2:
							<cfif len(trim(AsstRefId2)) AND ARef2Acpt_YN EQ 'Y'>
								<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getContactInfo" returnvariable="qContactInfo2">
									<cfinvokeargument name="contactID" value="#AsstRefId2#">
								</cfinvoke>
								<cfif qContactInfo2.recordCount>
									#qContactInfo2.LastName#, #qContactInfo2.firstName#
								</cfif>
							<cfelse>
								n/a
							</cfif> <!--- [#AsstRefID2#][#ARef2AcptDate#][#ARef2Acpt_YN#] --->
					
					</td>
					<td valign="top" class="tdUnderLine"> 
						<cfif qRefRpt.RECORDCOUNT>
							<cfif listFind("1,2,19,20,21",SESSION.MENUROLEID)> <!--- 1=ASSTADMIN, 2=PRESIDENT, 19=GAMESCHAIR, 20=GAMECONDCH, 21=REFDEVELCO --->
								<a href="gameRefReportPrint.cfm?GameId=#GAME_ID#&RefID=#GameRefID#" target="_blank"><b>Y</b></a>
							<cfelse>
								<a href="gameRefReportPrint.cfm?gid=#GAME_ID#" target="_blank"> <b>Yes</b> </a>
							</cfif>
						<cfelse>
							<a href="gameReportSubmit.cfm?gid=#GAME_ID#">
								<span class="red">missing</span>
							</a>
						</cfif>
					</td>
				</TR>
			</cfif> 
		 </CFLOOP>
	</CFIF>
	</TABLE>
</div>



</cfoutput>
</div>
<cfinclude template="_footer.cfm">
<CFIF isDefined("FORM.PRINTME")><!--- mimeType="text/html" --->
	<!--- This will pop up a window that will display the page in a pdf --->
	<script> window.open('GameRefReportListPDF.cfm?sby=#VARIABLES.sortBy#','popwin'); </script> 
</CFIF>

