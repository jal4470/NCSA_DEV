<!--- 
	FileName:	GameRefReportListPDF.cfm
	Created on: 05/14/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments



	NOTE! - changes to this page may also have to be included into GameRefReportList.cfm
 --->
 

<!--- <cfinclude template="cfudfs.cfm"> ---> 
<cfinclude template="_checkLogin.cfm">


<CFIF SESSION.menuRoleID EQ 25> <!--- logged in as referee, using referee menu --->
	<cfset refereeContactID = SESSION.USER.CONTACTID>
</CFIF>

<cfif IsDefined("url.sby")>
	 <cfset sortBy = url.sby>
	 <cfswitch expression="#UCASE(VARIABLES.sortBy)#">
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

<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="arrGameType">
	<cfinvokeargument name="listType" value="GAMETYPE"> 
</cfinvoke> 



<cfdocument format="pdf" 
			marginBottom=".5"
			marginLeft=".4"
			marginRight=".4"
			marginTop=".85" 
			orientation="landscape" >
	<link rel="STYLESHEET" type="text/css" href="2col_leftNav.css">	
	<cfdocumentitem type="header" > <!--- has heading but not spaced right --->
		<cfoutput><link rel="STYLESHEET" type="text/css" href="2col_leftNav.css">	
		<table cellspacing="0" cellpadding="3" align="center" border="0"  width="100%" >
			<tr><td colspan="5" align="left">
					<br>NCSA - Referee Game Report List
				</td>
				<td colspan="3" align="right">
					<br>Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#
				</td>
			</tr>
			<tr class="tblHeading">
				<TD width="18%" valign="bottom">Date/Time	</TD>
			    <TD width="06%" valign="bottom">Game		</TD>
			    <TD width="05%" valign="bottom">Div		</TD>
				<TD width="18%" valign="bottom">PlayField 	</TD>
				<TD width="25%" valign="bottom">Home Team <br> Visitor Team	</TD>
				<TD width="20%" valign="bottom">Refs	</TD>
				<TD width="10%" valign="bottom">Rpt	</TD>
			</TR>
			</table></cfoutput>
	</cfdocumentitem>
	<cfoutput>
	<cfif qGetRefGames.RECORDCOUNT >
		<table cellspacing="0" cellpadding="3" border="0" width="100%" align="left" >
		<CFLOOP query="qGetRefGames">
			<!--- ONLY show games where ref is Head Ref and they Accepted the Assignment, supress when they are an AR1 0r AR2 --->
			<cfif refID EQ refereeContactID AND REF_ACCEPT_YN EQ 'Y'>
				<cfquery name="qRefRpt" datasource="#SESSION.DSN#">
					SELECT  Game_ID, StartTime
					  FROM  TBL_REFEREE_RPT_HEADER
					 WHERE  Game_ID = #GAME_ID#
				</cfquery>
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
					<TD width="15%"  class="tdUnderLine" valign="top" align="left">
						#dateFormat(GAME_DATE,"ddd")#&nbsp;&nbsp;#dateFormat(GAME_DATE,"mm/dd/yy")#
						<br>#repeatString("&nbsp;",6)# #timeFormat(GAME_TIME,"hh:mm tt")# 
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
							#GAME_ID#
						<cfelse>
							<span class="red">#GAME_ID#</span>
						</cfif>
					</TD>
					<TD width="05%" class="tdUnderLine" valign="top" >#DIVISION#  </TD>
					<TD width="18%" class="tdUnderLine" valign="top"> #FieldAbbr# </TD>
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
							<b>Yes</b>
						<cfelse>
							<span class="red">missing</span>
						</cfif>
					</td>
				</TR>
			</cfif> 
		 </CFLOOP>
		</TABLE>
	</CFIF>

	</cfoutput>
</cfdocument>


