<!--- 
	FileName:	refAssignAdminRefList.cfm
	Created on: 01/15/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: this template will allow an admin to select a ref from a list and which will 
			 redirect them to the refAssignedGames.cfm page where they can accept/reject 
			 game assignments for the selected referee.
	
MODS: 01/15/2009 - filastname - comments
	11/19/2012 - jrab    - changed form to mimic other pages
	7/13/2016 - rgonzalez - added jquery logic to update hidden referee variable and pass correctly to print page
	05/22/2017 - apinzone - removed jquery 1.4.2, moved javascript to bottom of page and wrapped in cfsavecontent

 --->
 <CFIF isDefined("URL.rcid") AND isNumeric(URL.rcid)>
	<cfset refereeContactID = URL.rcid>
<CFELSEIF isDefined("FORM.refContactID") AND isNumeric(FORM.refContactID)>
	<cfset refereeContactID = FORM.refContactID>
<CFELSEIF SESSION.menuRoleID EQ 25> <!--- logged in as referee, using referee menu --->
	<cfset refereeContactID = SESSION.USER.CONTACTID>
<CFELSE>
	<cfset refereeContactID = 0>
</CFIF>

<CFSET GameDateLimit = "">
<CFIF isDefined("SESSION.GLOBALVARS.REFASSIGNVIEWDATEYN") AND SESSION.GLOBALVARS.REFASSIGNVIEWDATEYN EQ "Y">
	<CFIF SESSION.menuRoleID EQ 25 AND isDate(SESSION.GLOBALVARS.REFASSIGNVIEWDATE)>
		<CFSET GameDateLimit = SESSION.GLOBALVARS.REFASSIGNVIEWDATE >
	</CFIF>
</CFIF>

<cfif isDefined("URL.wef") AND isDate(URL.wef)>
	<cfset WeekendFrom = dateFormat(URL.wef,"mm/dd/yyyy") > 
<cfelseif isDefined("FORM.WeekendFrom")>
	<cfset WeekendFrom = dateFormat(FORM.WeekendFrom,"mm/dd/yyyy") > 
<cfelse>
	<cfset WeekendFrom = dateFormat(session.currentseason.startdate,"mm/dd/yyyy") > 
</CFIF>

<cfif isDefined("URL.wet") AND isDate(URL.wet)>
	<cfset WeekendTo   = dateFormat(URL.wet,"mm/dd/yyyy") >
<cfelseif isDefined("FORM.WeekendTo")>
	<cfset WeekendTo   = dateFormat(FORM.WeekendTo,"mm/dd/yyyy") >
<cfelse>
	<cfset WeekendTo   = dateFormat(session.currentseason.enddate,"mm/dd/yyyy") >
</CFIF>

<cfif isDefined("URL.fid") AND isNumeric(URL.fid)>
	<cfset GameFieldID = URL.fid>
<cfelseif isDefined("FORM.GameFieldID")>
	<cfset GameFieldID = FORM.GameFieldID>
<cfelse>
	<cfset GameFieldID = 0>
</cfif>

<cfif isDefined("URL.gdv")>
	<cfset gameDiv = URL.gdv>
<cfelseif isDefined("FORM.gameDiv")>
	<cfset gameDiv = FORM.gameDiv>
<cfelse>
	<cfset gameDiv = "">
</cfif>

<cfif isDefined("URL.gid") AND isNumeric(URL.gid)>
	<cfset gameID = URL.gid>
<cfelseif isDefined("FORM.gameID") AND isNumeric(FORM.gameID)>
	<cfset gameID = FORM.gameID>
<cfelse>
	<cfset gameID = "">
</cfif>

<cfset errMsg = "">


<CFIF isDefined("FORM.ACCEPT")>
	<!---<cfset confirmingRefID = FORM.refContactID>--->
	<cfloop list="#form.Fieldnames#" index="ifm">
		<cfif listFirst(ifm,"_") EQ "CONFIRM">
			<cfset confirmingRefID = listGetAt(ifm,3,"_")>
			<cfset refereeType = listGetAt(ifm,2,"_")>
			<cfset cur_gameID = listLast(ifm,"_")>
			<cfswitch expression="#UCASE(refereeType)#">
				<cfcase value="REF"> <CFSET gameOfficialTypeID = 1> </cfcase>
				<cfcase value="AR1"> <CFSET gameOfficialTypeID = 2> </cfcase>
				<cfcase value="AR2"> <CFSET gameOfficialTypeID = 3> </cfcase>
			</cfswitch> 		<!--- <br>[#cur_gameID#][#confirmingRefID#][#gameOfficialTypeID#]ACCEPT --->
			<cfquery name="updateGameOfficial" datasource="#session.dsn#">
				Update XREF_GAME_OFFICIAL
				   set Ref_accept_Date = <cfqueryParam cfsqltype="CF_SQL_DATE" value="#dateFormat(NOW(),"mm/dd/yyyy")#">
					 , Ref_accept_YN   = 'Y'
				 Where Game_id	   	   = <cfqueryParam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.cur_gameID#">
				   and contact_id      = <cfqueryParam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.confirmingRefID#">
				   and game_official_type_id = <cfqueryParam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.gameOfficialTypeID#">
			</cfquery>
		<cfelseif listFirst(ifm,"_") EQ "REJECT">
			<cfset confirmingRefID = listGetAt(ifm,3,"_")>
			<cfset refereeType = listGetAt(ifm,2,"_")>
			<cfset cur_gameID = listLast(ifm,"_")>
			<cfswitch expression="#UCASE(refereeType)#">
				<cfcase value="REF"> <CFSET gameOfficialTypeID = 1> </cfcase>
				<cfcase value="AR1"> <CFSET gameOfficialTypeID = 2> </cfcase>
				<cfcase value="AR2"> <CFSET gameOfficialTypeID = 3> </cfcase>
			</cfswitch> 		<!--- <br>[#cur_gameID#][#confirmingRefID#][#gameOfficialTypeID#]REJECT --->
			<cfquery name="updateGameOfficial" datasource="#session.dsn#">
				Update XREF_GAME_OFFICIAL
				   set Ref_accept_Date = NULL
					 , Ref_accept_YN   = 'N'
				 Where Game_id	   	   = <cfqueryParam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.cur_gameID#">
				   and contact_id      = <cfqueryParam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.confirmingRefID#">
				   and game_official_type_id = <cfqueryParam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.gameOfficialTypeID#">
			</cfquery>
		</cfif>
	</cfloop>
</CFIF>

<cfif IsDefined("FORM.SortBy")>
	 <cfset sortBy = FORM.SortBy>
	 <cfswitch expression="#UCASE(FORM.SortBy)#">
	 	<cfcase value="GAME">
			<cfset orderBy = " ORDER BY GAME_ID ">
		</cfcase>
	 	<cfcase value="DIV">
			<cfset orderBy = " ORDER BY DIVISION, GAME_DATE ">
		</cfcase>
	 	<cfcase value="VISITOR">
			<cfset orderBy = " ORDER BY VISITOR_TEAMNAME, GAME_DATE ">
		</cfcase>
	 	<cfcase value="HOME">
			<cfset orderBy = " ORDER BY HOME_TEAMNAME, GAME_DATE ">
		</cfcase>
	 	<cfcase value="PLAYFIELD">
			<cfset orderBy = " ORDER BY FieldAbbr, GAME_DATE ">
		</cfcase>
	 	<cfdefaultcase>
			<cfset orderBy = " ORDER BY GAME_DATE ">
		</cfdefaultcase>
	 </cfswitch>
<cfelse>
	<cfset sortBy = "DATE">
	<cfset orderBy = " ORDER BY GAME_DATE ">
</cfif>
<cfif isDefined("form.Fieldnames") >
<CFQUERY name="qGetRefGames" datasource="#SESSION.DSN#">
	Select Game_ID,       GAME_Date,        GAME_Time,    Division, GAME_TYPE,
		   Fieldname,     FieldAbbr,        Field_ID, 
		   Home_CLUB_ID,  HOME_TEAMNAME,    VISITOR_TEAMNAME, Virtual_TeamName, 
		   Forfeit_Home,  Forfeit_Visitor, 
		   RefID,		Ref_accept_Date,	Ref_accept_YN,
		   AsstRefID1,  ARef1AcptDate,		ARef1Acpt_YN,
		   AsstRefID2,  ARef2AcptDate,		ARef2Acpt_YN
	  from V_Games with (nolock)
	 WHERE 1 = 1
	 AND 	(RefID <> ''
	   		 or AsstRefID1 <> ''
			 or AsstRefID2 <> '')
	 <cfif refereeContactID GT 0>
	 AND
	 (
	 	 RefID = #VARIABLES.refereeContactID#
	    or AsstRefID1 = #VARIABLES.refereeContactID#
		or AsstRefID2 = #VARIABLES.refereeContactID#
		)
		</cfif>
			<cfif gameid NEQ "">
				AND GAME_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.gameID#">
			<cfelse>
				AND (	  game_date >= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#WeekendFrom#">
					  AND game_date <= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#WeekendTo#">
					   )	
					  <cfif GameFieldID GT 0>
						  AND field_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameFieldID#">
					  </cfif>
					  <cfif len(trim(gameDiv))>
						  AND Division = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.gameDiv#">
					  </cfif>
			</cfif>
	 #preserveSingleQuotes(VARIABLES.orderBy)#, dbo.formatDateTime(GAME_TIME,'HH:MM 24')
</CFQUERY> 
<CFIF len(Trim(GameDateLimit))>
	<CFQUERY name="qGetRefGames" dbtype="query">
		Select *
		  from qGetRefGames 
		 WHERE GAME_Date <= '#VARIABLES.gameDateLimit#'  
		 #preserveSingleQuotes(VARIABLES.orderBy)#, GAME_TIME
	</CFQUERY> 
</CFIF>

<!--- get game types --->
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="arrGameType">
	<cfinvokeargument name="listType" value="GAMETYPE"> 
</cfinvoke> 
</cfif>

<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<cfsavecontent variable="jqueryUI_CSS">
	<link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css"> 	
</cfsavecontent>
<cfhtmlhead text="#jqueryUI_CSS#">

<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Accept Assignments for Referees</H1>

<table cellspacing="0" cellpadding="5" align="center" border="0"  width="820px" >
<tr>
<td class="tdUnderLine" colspan="8">
<FORM name="Games" action="refAssignAdminRefList.cfm"  method="post">
			
			<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%" >
			
			<TR><TD align="left">
					<B>From</B> &nbsp;
						<INPUT name="WeekendFrom" value="#VARIABLES.WeekendFrom#" size="9">
					
					#repeatString("&nbsp;",3)#
					<B>To</B> &nbsp;
						<INPUT name="WeekendTo" value="#VARIABLES.WeekendTo#" size="9">
					
					#repeatString("&nbsp;",3)#
					<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getReferees" returnvariable="qRefInfo">
</cfinvoke>

					<B>Referee </B> &nbsp;
							<SELECT name="refContactID" ID="refContactID">
								<OPTION value="0" >Select All</OPTION>
								<cfloop query="qRefInfo">
									<OPTION value="#CONTACT_ID#" <cfif refereeContactID EQ CONTACT_ID>selected</cfif>>#LASTNAME#, #FIRSTNAME#</OPTION>
								</cfloop>
							</SELECT>
				</td>
				<td align="center">
					<B>Game Number </B> &nbsp;
						<input type="Text" name="gameID" value="#VARIABLES.gameID#" size="5">
						<br>(overrides all filters)
			
				</td>
			</tr>
			<tr><td>
					<b>Fields</b>
						<cfquery name="qAllFields" datasource="#SESSION.DSN#">
							SELECT F.FIELD_ID, F.FIELDABBR, F.FIELDNAME AS FIELD
							  FROM TBL_FIELD F
							 Where FieldAbbr is not NULL 
							   and (Active_YN = 'Y')
							 Order by FieldAbbr
						</cfquery>
						<SELECT name="GameFieldID"> 
							<OPTION value="0" >Select All</OPTION>
							<CFLOOP query="qAllFields">
								<OPTION value="#FIELD_ID#" <cfif GameFieldID EQ FIELD_ID >selected</cfif> >#FIELDABBR#</OPTION>
							</CFLOOP>
						</SELECT>
					
					#repeatString("&nbsp;",3)#
					<b>Division</b>
						<cfquery name="qAllDivs" datasource="#SESSION.DSN#">
							select distinct division from v_games WHERE division <> '' order by division
						</cfquery>
						<SELECT name="gameDiv"> 
							<OPTION value="" >Select All</OPTION>
							<CFLOOP query="qAllDivs">
								<OPTION value="#division#" <cfif gameDiv EQ division >selected</cfif> >#division#</OPTION>
							</CFLOOP>
						</SELECT>
			
					#repeatString("&nbsp;",3)#
					<b>Sort</b>
						<select name="sortBy">
							<option value="DATE" 	<cfif sortBy EQ "DATE">selected</cfif> >	Game Date</option>
							<option value="GAME" 	<cfif sortBy EQ "GAME">selected</cfif> >	Game Number</option>
							<option value="DIV" 	<cfif sortBy EQ "DIV">selected</cfif> > 	Division</option>
							<option value="VISITOR" <cfif sortBy EQ "VISITOR">selected</cfif> > Visting Team</option>
							<option value="HOME" 	<cfif sortBy EQ "HOME">selected</cfif> >    Home Team</option>
							<option value="PLAYFIELD" <cfif sortBy EQ "PLAYFIELD">selected</cfif> > Play Field</option>
						</select>
							<input type="Submit" name="getAssignments" value="Get Game Assignments">
				</td>
				<td align="center">
					<input type="SUBMIT" name="GoSingle"  value="Get Single Game" >  
					<!--- <input type="Submit" name="printpdf" value="printer friendly" >  
						  <input type="Submit" name="printcsv" value="csv file" > --->
				</td>
			</tr>
			
			<cfif len(trim(errMsg))>
				<tr><td colspan="2" align="center">
						<span class="red"><b>#VARIABLES.errMsg#</b></span>
					</td>
				</tr>
			</cfif>
			
			</table>	
			</FORM>
</td>
</tr>
</table>


<FORM name="Games" action="refAssignAdminRefList.cfm"  method="post" >
<input type="Hidden" name="refContactID" value="#VARIABLES.refereeContactID#">
<table cellspacing="0" cellpadding="5" align="center" border="0"  width="820px" >
<tr><td colspan="5" align="left">
		<span class="red">
				- To Accept game assignment, mark the check box and then press SUBMIT button at the bottom of the page
			<br>- To Decline game assignment, mark the check box and then press SUBMIT button at the bottom of the page
			<br>- You must act on assignments within 24 hours of posting
			<br>- You cannot change an acceptance or rejection after saving 
			<br>- you must email the assignors (see instructions on referee login page) immediately if you make an error 
			<br>  or have a change in plans 
			<!--- <br>- Click on the Game number to Edit Game
			<br>- "Y" under RPT in the last column signifies Referee Report for the game has been submitted
			<br>CNFM=Ref Accepted, RPT=Referee Report Submitted
			<CFIF SESSION.menuRoleID EQ 25> <!--- logged in as referee, using referee menu --->
				<br>- To Accept game assignment, mark the check box and then press accept at the bottom of the page
				<br>- Red carded player's passes are to be mailed to the league office with your game rosters 
			</cfif> --->
		</span>
	</td>
	<td colspan="3" align="right" valign="bottom">		
		<input type="Submit" name="printme" id="printme" value="Printer Friendly" disabled >  
	</td>
</tr>
<tr class="tblHeading">
	<TD width="18%" valign="bottom">Date/Time	</TD>
    <TD width="06%" valign="bottom">Game		</TD>
    <TD width="07%" valign="bottom">Div		</TD>
	<TD width="18%" valign="bottom">PlayField 	</TD>
	<TD width="26%" valign="bottom">Home Team <br> Visitor Team	</TD>
	<TD width="15%" valign="bottom">Refs	</TD>
	<TD width="05%" valign="bottom" align="left">Accept	</TD>
	<TD width="05%" valign="bottom" align="left">Reject	</TD>
	<!--- <TD width="05%" valign="bottom">Rpt	</TD> --->
</TR>
</table>

<cfif isDefined("qGetRefGames.RECORDCOUNT")>
	<cfif qGetRefGames.RECORDCOUNT LTE 7>
		<!--- up to 7 rows, expand, over 7 default size and scroll --->
		<cfset divHeight = qGetRefGames.RECORDCOUNT * 70>
	<cfelse>
		<cfset divHeight = "500">
	</cfif>
	<div style="border:1px ##cccccc solid; height:400px; overflow-y:scroll;"> 
	<table cellspacing="0" cellpadding="3" border="0" width="800px" align="left" >
		<CFLOOP query="qGetRefGames">
			<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
				<TD width="17%"  class="tdUnderLine" valign="top" align="left">
					#dateFormat(GAME_DATE,"ddd")#&nbsp;&nbsp;#dateFormat(GAME_DATE,"mm/dd/yy")#&nbsp;&nbsp;#timeFormat(GAME_TIME,"hh:mm tt")# 
					<!--- <br>#repeatString("&nbsp;",23)# #timeFormat(GAME_TIME,"hh:mm tt")# --->
					<cfif len(Trim(GAME_TYPE))>
						<cfloop from="1" to="#arrayLen(arrGameType)#" step="1" index="iGt">
							<cfif GAME_TYPE EQ arrGameType[igt][1]>
								<br> <SPAN class="red">#arrGameType[igt][3]#</span>
								<cfbreak>
							</cfif>
						</cfloop>
					</cfif>
				</TD>
				<TD width="06%"  class="tdUnderLine" valign="top" align="left">#GAME_ID#</TD>
				<TD width="06%" class="tdUnderLine" valign="top" >#DIVISION#</TD>
				<TD width="18%" class="tdUnderLine" valign="top">
						<a href="fieldDirPop.cfm?fid=#FIELD_ID#" target="_blank">#FieldAbbr#</a>
				</TD>
				<TD width="25%" class="tdUnderLine" valign="top">
							#Home_TEAMNAME#		<!--- (#Forfeit_Home#) --->
						<br><!--- #VISITOR_TEAMNAME# --->	<!--- (#Forfeit_Visitor#)  --->
							<cfif len(trim(VISITOR_TEAMNAME))>
								#VISITOR_TEAMNAME#
							<cfelseif len(trim(Virtual_TeamName))>
								#Virtual_TeamName#
							<cfelse>
								&nbsp;
							</cfif>
				</TD>
				<TD width="25%" colspan="2" class="tdUnderLine" valign="top" align=left>
						<!--- Start INNER table --->
						<table align="left" width="100%" border="0" cellpadding="0" cellspacing="0">
							<!--- ref ref ref ref ref ref ref ref ref ref --->
							<tr><td width="77%">
									REF:
									<cfif len(trim(RefID))>
										<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getContactInfo" returnvariable="qContactInfo">
											<cfinvokeargument name="contactID" value="#RefID#">
										</cfinvoke>
										<cfif qContactInfo.recordCount>
											<cfif refID EQ refereeContactID> 
												<b>#qContactInfo.LastName#, #qContactInfo.firstName#</b>
											<cfelse>
												#qContactInfo.LastName#, #qContactInfo.firstName#
											</cfif>
										<cfelse>
											n/a
										</cfif>
									</cfif> <!--- [#REFID#][#Ref_accept_Date#][#Ref_accept_YN#] --->
								</td>
								<td><!--- Ref Accept --->
									<cfif Ref_accept_YN EQ "Y"> <!--- ref accepted, set checked and disable --->
										<cfset txtDisable = "disabled">	   	
										<cfset txtChecked = "checked">
									<cfelseif Ref_accept_YN EQ "N"> <!--- ref rejected, set checked and disable --->
										<cfset txtDisable = "disabled">
										<cfset txtChecked = "">
									<cfelse>						<!--- ref took no action uncheck and able --->
										<cfset txtDisable = "">
										<cfset txtChecked = "">
									</cfif>
									<cfif <!---refID EQ refereeContactID and --->len(trim(txtDisable)) EQ 0 && RefID NEQ ""> 
										<!--- this REF is the logged in user, let box be checkable --->	
										<cfset txtName	  = "name='CONFIRM_REF_" & RefID & "_" & GAME_ID & "'">
									<cfelse>
										<cfset txtName	  = "">		<!--- this REF is NOT the logged in user, disable the box --->
										<cfset txtDisable = "disabled">
									</cfif>
									<input type="checkbox" #txtDisable# #txtChecked# #txtName#> 
								</td>
								<td><!--- Ref Reject --->
									<cfif Ref_accept_YN EQ "Y"> <!--- ref accepted, set checked and disable --->
										<cfset txtDisable = "disabled">	   	
										<cfset txtChecked = "">
									<cfelseif Ref_accept_YN EQ "N"> <!--- ref rejected, set checked and disable --->
										<cfset txtDisable = "disabled">
										<cfset txtChecked = "checked">
									<cfelse>						<!--- ref took no action uncheck and able --->
										<cfset txtDisable = "">
										<cfset txtChecked = "">
									</cfif>
									<cfif <!---refID EQ refereeContactID and --->len(trim(txtDisable)) EQ 0 && RefID NEQ ""> 
										<!--- this REF is the logged in user, let box be checkable --->	
										<cfset txtName	  = "name='REJECT_REF_" & RefID & "_" & GAME_ID & "'">
									<cfelse>
										<cfset txtName	  = "">		<!--- this REF is NOT the logged in user, disable the box --->
										<cfset txtDisable = "disabled">
									</cfif>
									<input type="checkbox" #txtDisable# #txtChecked# #txtName#> 
								</td>
								<!--- <td><cfif refID EQ refereeContactID> <!--- Ref Conf --->
										<input type="checkbox" <cfif len(trim(Ref_accept_Date)) AND isDate(Ref_accept_Date) AND Ref_accept_YN EQ "N" > disabled checked</cfif> name="REJECT_REF_#GAME_ID#">
									<cfelse>
										<input type="checkbox" disabled <cfif len(trim(Ref_accept_Date)) AND isDate(Ref_accept_Date) AND Ref_accept_YN EQ "N" >checked</cfif> > 
									</cfif>
								</td> --->
							</tr>
							<!--- AR1 AR1 AR1 AR1 AR1 AR1 AR1 AR1 AR1 AR1 AR1 AR1 AR1 AR1 AR1 --->
							<tr><td>AR1:
									<cfif len(trim(AsstRefId1))>
										<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getContactInfo" returnvariable="qContactInfo1">
											<cfinvokeargument name="contactID" value="#AsstRefId1#">
										</cfinvoke>
										<cfif qContactInfo1.recordCount>
											<cfif AsstRefId1 EQ refereeContactID> 
												<b>#qContactInfo1.LastName#, #qContactInfo1.firstName#</b>
											<cfelse>
												#qContactInfo1.LastName#, #qContactInfo1.firstName#
											</cfif>
										<cfelse>
											n/a
										</cfif>
									</cfif><!---  [#AsstRefID1#][#ARef1AcptDate#][#ARef1Acpt_YN#] --->
								</td>
								<!--- <td><cfif AsstRefId1 EQ refereeContactID> <!--- AssRef 1 Conf --->
										<input type="checkbox" <cfif len(trim(ARef1AcptDate)) AND isDate(ARef1AcptDate) AND ARef1Acpt_YN EQ "Y"> disabled checked</cfif> name="CONFIRM_AR1_#GAME_ID#">
									<cfelse>  <input type="checkbox" disabled <cfif len(trim(ARef1AcptDate)) AND isDate(ARef1AcptDate) AND ARef1Acpt_YN EQ "Y">checked</cfif> >
									</cfif>
								</td>
								<td><cfif AsstRefId1 EQ refereeContactID> <!--- AssRef 1 Conf --->
										<input type="checkbox" <cfif len(trim(ARef1AcptDate)) AND isDate(ARef1AcptDate) AND ARef1Acpt_YN EQ "N"> disabled checked</cfif> name="REJECT_AR1_#GAME_ID#">
									<cfelse>  <input type="checkbox" disabled <cfif len(trim(ARef1AcptDate)) AND isDate(ARef1AcptDate) AND ARef1Acpt_YN EQ "N">checked</cfif> >
									</cfif>
								</td> --->
								<td><!--- AR_1 Accept --->
									<cfif ARef1Acpt_YN EQ "Y"> <!--- ref accepted, set checked and disable --->
										<cfset txtDisable = "disabled">	   	
										<cfset txtChecked = "checked">
									<cfelseif ARef1Acpt_YN EQ "N"> <!--- ref rejected, set checked and disable --->
										<cfset txtDisable = "disabled">
										<cfset txtChecked = "">
									<cfelse>						<!--- ref took no action uncheck and able --->
										<cfset txtDisable = "">
										<cfset txtChecked = "">
									</cfif>
									<cfif <!---AsstRefId1 EQ refereeContactID and --->len(trim(txtDisable)) EQ 0 && AsstRefId1 NEQ ""> 
										<!--- this REF is the logged in user, let box be checkable --->	
										<cfset txtName	  = "name='CONFIRM_AR1_" & AsstRefId1 & "_" & GAME_ID & "'">
									<cfelse>
										<cfset txtName	  = "">		<!--- this REF is NOT the logged in user, disable the box --->
										<cfset txtDisable = "disabled">
									</cfif>
									<input type="checkbox" #txtDisable# #txtChecked# #txtName#> 
								</td>
								<td><!--- AR_1 Reject --->
									<cfif ARef1Acpt_YN EQ "Y"> <!--- ref accepted, set checked and disable --->
										<cfset txtDisable = "disabled">	   	
										<cfset txtChecked = "">
									<cfelseif ARef1Acpt_YN EQ "N"> <!--- ref rejected, set checked and disable --->
										<cfset txtDisable = "disabled">
										<cfset txtChecked = "checked">
									<cfelse>						<!--- ref took no action uncheck and able --->
										<cfset txtDisable = "">
										<cfset txtChecked = "">
									</cfif>
									<cfif <!---AsstRefId1 EQ refereeContactID and --->len(trim(txtDisable)) EQ 0 && AsstRefId1 NEQ ""> 
										<!--- this REF is the logged in user, let box be checkable --->	
										<cfset txtName	  = "name='REJECT_AR1_" & AsstRefId1 & "_" & GAME_ID & "'">
									<cfelse>
										<cfset txtName	  = "">		<!--- this REF is NOT the logged in user, disable the box --->
										<cfset txtDisable = "disabled">
									</cfif>
									<input type="checkbox" #txtDisable# #txtChecked# #txtName#> 
								</td>
							</tr>
							<tr><td>AR2:
									<cfif len(trim(AsstRefId2))>
										<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getContactInfo" returnvariable="qContactInfo2">
											<cfinvokeargument name="contactID" value="#AsstRefId2#">
										</cfinvoke>
										<cfif qContactInfo2.recordCount>
											<cfif AsstRefId2 EQ refereeContactID> 
												<b>#qContactInfo2.LastName#, #qContactInfo2.firstName#</b>
											<cfelse>
												#qContactInfo2.LastName#, #qContactInfo2.firstName#
											</cfif>
										<cfelse>
											n/a
										</cfif>
									</cfif> <!--- [#AsstRefID2#][#ARef2AcptDate#][#ARef2Acpt_YN#] --->
								</td>
								<!--- <td><cfif AsstRefId2 EQ refereeContactID> <!--- AssRef 2 Conf --->
										<input type="checkbox" <cfif len(trim(ARef2AcptDate)) AND isDate(ARef2AcptDate) AND ARef2Acpt_YN EQ "Y">disabled checked</cfif> name="CONFIRM_AR2_#GAME_ID#">
									<cfelse>	<input type="checkbox" disabled <cfif len(trim(ARef2AcptDate)) AND isDate(ARef2AcptDate) AND ARef2Acpt_YN EQ "Y">checked</cfif> >
									</cfif>
								</td>
								<td><cfif AsstRefId2 EQ refereeContactID> <!--- AssRef 2 Conf --->
										<input type="checkbox" <cfif len(trim(ARef2AcptDate)) AND isDate(ARef2AcptDate) AND ARef2Acpt_YN EQ "N">disabled checked</cfif> name="REJECT_AR2_#GAME_ID#">
									<cfelse>	<input type="checkbox" disabled <cfif len(trim(ARef2AcptDate)) AND isDate(ARef2AcptDate) AND ARef2Acpt_YN EQ "N">checked</cfif> >
									</cfif>
								</td> --->
								<td><!--- AR_2 Accept --->
									<cfif ARef2Acpt_YN EQ "Y"> <!--- ref accepted, set checked and disable --->
										<cfset txtDisable = "disabled">	   	
										<cfset txtChecked = "checked">
									<cfelseif ARef2Acpt_YN EQ "N"> <!--- ref rejected, set checked and disable --->
										<cfset txtDisable = "disabled">
										<cfset txtChecked = "">
									<cfelse>						<!--- ref took no action uncheck and able --->
										<cfset txtDisable = "">
										<cfset txtChecked = "">
									</cfif>
									<cfif <!---AsstRefId2 EQ refereeContactID and --->len(trim(txtDisable)) EQ 0 && AsstRefId2 NEQ ""> 
										<!--- this REF is the logged in user, let box be checkable --->	
										<cfset txtName	  = "name='CONFIRM_AR2_" & AsstRefId2 & "_" & GAME_ID & "'">
									<cfelse>
										<cfset txtName	  = "">		<!--- this REF is NOT the logged in user, disable the box --->
										<cfset txtDisable = "disabled">
									</cfif>
									<input type="checkbox" #txtDisable# #txtChecked# #txtName#> 
								</td>
								<td><!--- AR_2 Reject --->
									<cfif ARef2Acpt_YN EQ "Y"> <!--- ref accepted, set checked and disable --->
										<cfset txtDisable = "disabled">	   	
										<cfset txtChecked = "">
									<cfelseif ARef2Acpt_YN EQ "N"> <!--- ref rejected, set checked and disable --->
										<cfset txtDisable = "disabled">
										<cfset txtChecked = "checked">
									<cfelse>						<!--- ref took no action uncheck and able --->
										<cfset txtDisable = "">
										<cfset txtChecked = "">
									</cfif>
									<cfif <!---AsstRefId2 EQ refereeContactID and --->len(trim(txtDisable)) EQ 0 && AsstRefId2 NEQ ""> 
										<!--- this REF is the logged in user, let box be checkable --->	
										<cfset txtName	  = "name='REJECT_AR2_" & AsstRefId2 & "_" & GAME_ID & "'">
									<cfelse>
										<cfset txtName	  = "">		<!--- this REF is NOT the logged in user, disable the box --->
										<cfset txtDisable = "disabled">
									</cfif>
									<input type="checkbox" #txtDisable# #txtChecked# #txtName#> 
								</td>
							</tr>
							</tr>
						</table><!--- End INNER table --->
				</TD>
				<!--- <td valign="top" class="tdUnderLine"> 
					<cfquery name="qRefRpt" datasource="#SESSION.DSN#">
						SELECT  Game_ID, StartTime
						  FROM  TBL_REFEREE_RPT_HEADER
						 WHERE  Game_ID = #GAME_ID#
					</cfquery>
					<cfif qRefRpt.RECORDCOUNT>
							<!--- <cfif ucase(trim(Session("RoleCode"))) = "ASSTADMIN"    or ucase(trim(Session("RoleCode"))) = "PRESIDENT" 
							   or ucase(trim(Session("RoleCode"))) = "GAMESCHAIR"   or ucase(trim(Session("RoleCode"))) = "GAMECONDCH" 
							   or ucase(trim(Session("RoleCode"))) = "REFDEVELCO" 
							   or ucase(Trim(Session("UserID"))) = "DOUGHERTYTOM"   or ucase(Trim(Session("UserID"))) = "KRAMERCHUCK" 
							   or selBy = "REF"> --->
							
							<cfif listFind("1,2,19,20,21",SESSION.MENUROLEID)> <!--- 1=ASSTADMIN, 2=PRESIDENT, 19=GAMESCHAIR, 20=GAMECONDCH, 21=REFDEVELCO --->
								<a href="xxxxx.cfm?GameId=#GAME_ID#&RefID=#GameRefID#"><b>Y</b></a>
							<cfelse>
								<b>Y</b>
							</cfif>
					<cfelse>
						&nbsp;
					</cfif>
				</td> --->
			</TR>
		 </CFLOOP>
	</TABLE>
	</div>

	<table cellspacing="0" cellpadding="5" align="left" border="0" width="825px" >
	<tr><td colspan="7" align="center">
			<input type="Submit" name="Accept" value="Submit"> 
		</td>
	</tr>
	</Table>
</CFIF>


<CFIF isDefined("FORM.PRINTME")><!--- mimeType="text/html" --->
	<!--- This will pop up a window that will display the page in a pdf --->
	<!--- <script> window.open('refAssignedGamesPDF.cfm?rcid=#VARIABLES.refereeContactID#','popwin'); </script> --->
	<script> window.open('refAssignedGamesPDF.cfm?rcid=#refereeContactID#','popwin'); </script> 
</CFIF>

</cfoutput>
</div>
</form>

<cfsavecontent variable="cf_footer_scripts">
<script language="JavaScript" type="text/javascript" src="assets/jquery-ui-1.12.1.min.js"></script>
<script language="JavaScript" type="text/javascript">
	$(function(){
		$('input[name=WeekendFrom],input[name=WeekendTo]').datepicker();
	});

	$('#refContactID').change(function() {
		if ($('#refContactID').val() == 0) {
			$('#printme').attr('disabled', 'disabled');
		} else {
			$('#printme').removeAttr('disabled');
		}

		$('input:hidden[name=refContactID]').val($('#refContactID').val());
	});
</script>
</cfsavecontent>

<cfinclude template="_footer.cfm">
