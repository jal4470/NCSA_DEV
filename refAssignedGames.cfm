<!--- 
	FileName:	refAssignedGames.cfm
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
	01/15/2009 - AArnone - modified this page so it can also be accessed by an admin so they can accept/reject
					an assignment on behalf of the referee
						- added check for REFASSIGNVIEWDATE_YN
	02/19/2009 - aarnone - made scroll box (div) expandable up to 7 rows before it starts scrolling
	03/26/2009 - aarnone - added virtual team and game type
	04/02/2009 - aarnone - added dbo.formatDateTime()
	04/06/2009 - AARNONE - T:7491 with (nolock) added to v_games (perf issue)
	05/13/2009 - aarnone - added print friendly pdf
	05/24/2017 - apinzone - Moved table headers into scrollable area and centered submit on mobile. 
	10/3/2018 - M Greenberg - changed field link to be modal on screen
	9/25/2018 - M Greenberg - added all emails link, added modal for coach emails
	5/17/2020 - J Lechuga	- Modified instructions adjusted margin on print friendly button

	NOTE! - changes to this page may also have to be included into refAssignedGamesPDF.cfm

 --->
 <CFIF isDefined("URL.rcid") AND isNumeric(URL.rcid)>
	<cfset refereeContactID = URL.rcid>
<CFELSEIF isDefined("FORM.refContactID") AND isNumeric(FORM.refContactID)>
	<cfset refereeContactID = FORM.refContactID>
<CFELSEIF isdefined("SESSION.menuRoleID") and SESSION.menuRoleID EQ 25> <!--- logged in as referee, using referee menu --->
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


<CFIF isDefined("FORM.ACCEPT")>
	<cfset confirmingRefID = FORM.refContactID>
	<cfloop list="#form.Fieldnames#" index="ifm">
		<cfif listFirst(ifm,"_") EQ "CONFIRM">
			<cfset refereeType = listGetAt(ifm,2,"_")>
			<cfset gameID = listLast(ifm,"_")>
			<cfswitch expression="#UCASE(refereeType)#">
				<cfcase value="REF"> <CFSET gameOfficialTypeID = 1> </cfcase>
				<cfcase value="AR1"> <CFSET gameOfficialTypeID = 2> </cfcase>
				<cfcase value="AR2"> <CFSET gameOfficialTypeID = 3> </cfcase>
			</cfswitch> 		<!--- <br>[#GameId#][#confirmingRefID#][#gameOfficialTypeID#]ACCEPT --->
			<cfquery name="updateGameOfficial" datasource="#session.dsn#">
				Update XREF_GAME_OFFICIAL
				   set Ref_accept_Date = <cfqueryParam cfsqltype="CF_SQL_DATE" value="#dateFormat(NOW(),"mm/dd/yyyy")#">
					 , Ref_accept_YN   = 'Y'
				 Where Game_id	   	   = <cfqueryParam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameId#">
				   and contact_id      = <cfqueryParam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.confirmingRefID#">
				   and game_official_type_id = <cfqueryParam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.gameOfficialTypeID#">
			</cfquery>
		<cfelseif listFirst(ifm,"_") EQ "REJECT">
			<cfset refereeType = listGetAt(ifm,2,"_")>
			<cfset gameID = listLast(ifm,"_")>
			<cfswitch expression="#UCASE(refereeType)#">
				<cfcase value="REF"> <CFSET gameOfficialTypeID = 1> </cfcase>
				<cfcase value="AR1"> <CFSET gameOfficialTypeID = 2> </cfcase>
				<cfcase value="AR2"> <CFSET gameOfficialTypeID = 3> </cfcase>
			</cfswitch> 		<!--- <br>[#GameId#][#confirmingRefID#][#gameOfficialTypeID#]REJECT --->
			<cfquery name="updateGameOfficial" datasource="#session.dsn#">
				Update XREF_GAME_OFFICIAL
				   set Ref_accept_Date = NULL
					 , Ref_accept_YN   = 'N'
				 Where Game_id	   	   = <cfqueryParam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameId#">
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
	 	<!---<cfcase value="PLAYFIELD">
			<cfset orderBy = " ORDER BY FieldAbbr, GAME_DATE ">
		</cfcase>--->
	 	<cfdefaultcase>
			<cfset orderBy = " ORDER BY GAME_DATE ">
		</cfdefaultcase>
	 </cfswitch>
<cfelse>
	<cfset sortBy = "DATE">
	<cfset orderBy = " ORDER BY GAME_DATE ">
</cfif>

<CFQUERY name="qGetRefGames" datasource="#SESSION.DSN#">
	Select Game_ID,       GAME_Date,        GAME_Time,    Division, GAME_TYPE,
		   Fieldname,     FieldAbbr,        Field_ID, 
		   Home_CLUB_ID,  HOME_TEAMNAME,     VISITOR_TEAMNAME, Virtual_TeamName, 
		   Forfeit_Home,  Forfeit_Visitor, 
		   RefID,		Ref_accept_Date,	Ref_accept_YN,
		   AsstRefID1,  ARef1AcptDate,		ARef1Acpt_YN,
		   AsstRefID2,  ARef2AcptDate,		ARef2Acpt_YN, Visitor_CLUB_ID, Home_CLUB_ID,Home_Team_ID,VISITOR_TEAM_ID,
		   dbo.f_getTeamRoster(home_team_id) as home_team_roster_id, dbo.f_getTeamRoster(visitor_team_id) as visitor_team_roster_id,
		   dbo.f_get_MDF(home_team_id, game_id) as home_team_mdf, dbo.f_get_MDF(visitor_team_id, game_id) as visitor_team_mdf
	  from V_Games with (nolock)
	 WHERE 
	 	(  RefID = #VARIABLES.refereeContactID#
	    or AsstRefID1 = #VARIABLES.refereeContactID#
		or AsstRefID2 = #VARIABLES.refereeContactID#
		)
	 #preserveSingleQuotes(VARIABLES.orderBy)#, dbo.formatDateTime(GAME_TIME,'HH:MM 24')
</CFQUERY> 

<CFIF len(Trim(GameDateLimit))>
	<CFQUERY name="qGetRefGames" dbtype="query">
		Select *
		  from qGetRefGames 
		 WHERE GAME_Date <= '#VARIABLES.gameDateLimit#'  
		 <!---#preserveSingleQuotes(VARIABLES.orderBy)#, GAME_TIME--->
	</CFQUERY> 
</CFIF>

<!--- get game types --->
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="arrGameType">
	<cfinvokeargument name="listType" value="GAMETYPE"> 
</cfinvoke> 

<!---  <style>
#refGames td.game_field{
    position: relative !important;
    overflow-y:visible !important;
}
 </style> --->



<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<style>
/*#refGames td.game_field{
    position: relative !important;
    overflow-y:visible !important;
}*/
.modal {
  display:none;
  overflow: auto;
  max-height: 450px;
  min-height: 100px;
  }	
#clubPopup.active {
	display: block; 
	}
#success {
  display:none;
  background: #faf2cc;
  line-height: 1.5;
  margin: 20px 20px;
  padding: 10px 10px; 
  border-radius: 4px;
  font-weight: 400;}
 #assignment_text {
  display:block;
  background: #faf2cc;
  line-height: 1.5;
  margin: 20px 20px;
  padding: 10px 10px 15px 15px; 
  border-radius: 4px;
  font-weight: 400;}
#success.active {
	display: block; }
 #CEmail{
 	text-align: center;
 }
 .EmailList{
	padding: 5%;
 }
 .coach{
 	display:inline-block;
 	padding-bottom: 8px;
 	text-align: center;
	font-size: 12px;
 }
.clubPopup h2 {
    text-align: center;
}
.schedule_cta_wrapper {
    position: initial: ;
    margin-top: -40px !important;
}
#print{
	margin-left: 28%;
}
.form_btn{
	text-align: center;
	margin-top: 10px;
}
#sort{
	margin-bottom:10px;
}
</style>
<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Accept/Reject Game assignments</H1>
<!--- <br> <h2>yyyyyy </h2> --->
<div id="assignment_text">
<CFIF len(Trim(GameDateLimit))>
	<span class="red"><b> NOTE! Game assigments are currently viewable up to #VARIABLES.gameDateLimit#, assignments after this date have not been published.</b></span>
</CFIF><!--- logged in as referee, using referee menu --->
<!--- <CFIF SESSION.menuRoleID EQ 25> 
	<cfset refereeContactID = SESSION.USER.CONTACTID>
</CFIF> --->


<FORM name="Games" action="refAssignedGames.cfm"  method="post">
<input type="Hidden" name="refContactID" value="#VARIABLES.refereeContactID#">
	<p class="red">
			<!--- - To Accept game assignment, mark the check box and then press SUBMIT button at the bottom of the page
		<br>- To Decline game assignment, mark the check box and then press SUBMIT button at the bottom of the page
		<br>- You must act on assignments within 24 hours of posting
		<br>- You cannot change an acceptance or rejection after saving 
		<br>- you must email the assignors (see instructions on referee login page) immediately if you make an error 
		<br>  or have a change in plans  --->
		- To Accept game assignment, mark the check box and then press SUBMIT button at the bottom of the page 
		<br>- To Decline game assignment, mark the check box and then press SUBMIT button at the bottom of the page 
		<br>- You must act on assignments within 24 hours of posting 
		<br>- After you hit submit, check the page after it reloads to verify that the check box is now shaded with the selection you made.  You cannot change an acceptance or rejection after saving - you must email the assignors (see instructions on referee login page) immediately if you make an error or have a change in plans
		<br>- Click the Field Name for directions and link to Map
		<br>- Click Retrieve All Coaches' Emails Icon to pop up list of emails; click Copy Here to copy coaches' emails and then paste into your email account to send required email to coaches from referee in advance of game.

	</p>
</div>
	<div id="sort">
	<label class="select_label" for="sortBy">Sort</label>
	<div class="select_box">
		<select name="sortBy" id="sortBy">
			<option value="DATE" 	<cfif sortBy EQ "DATE">selected</cfif> >	Game Date</option>
			<option value="GAME" 	<cfif sortBy EQ "GAME">selected</cfif> >	Game Number</option>
			<option value="DIV" 	<cfif sortBy EQ "DIV">selected</cfif> > 	Division</option>
			<option value="VISITOR" <cfif sortBy EQ "VISITOR">selected</cfif> > Visting Team</option>
			<option value="HOME" 	<cfif sortBy EQ "HOME">selected</cfif> >    Home Team</option>
			<!---<option value="PLAYFIELD" <cfif sortBy EQ "PLAYFIELD">selected</cfif> > Play Field</option>--->
		</select>
	</div>
	<button type="submit" name="getGames" class="gray_btn select_btn">Resort</button>
	
	<!--- <input type="submit" name="resort" value="Resort"> --->
		<button class="schedule_cta print yellow_btn" id="print" type="Submit" name="printme">Printer Friendly</button>
		<!--- <input type="Submit" name="printme" value="" >  ---> 

	<div id="success">Emails Successfully Copied</div>
</div>


<cfif qGetRefGames.RECORDCOUNT>
	<cfif qGetRefGames.RECORDCOUNT LTE 7>
		<!--- up to 7 rows, expand, over 7 default size and scroll --->
		<cfset divHeight = qGetRefGames.RECORDCOUNT * 70>
	<cfelse>
		<cfset divHeight = "500">
	</cfif>
<!--- 	<div style="border:1px ##cccccc solid; height:400px;">  --->
	<table id="schedule_table" cellspacing="0" cellpadding="0">
		<thead>
		<tr>
			<th width="18%" valign="bottom">Date/Time	</th>
		    <th width="06%" valign="bottom">Game		</th>
		    <th width="07%" valign="bottom">Div		</th>
			<th width="18%" valign="bottom">PlayField 	</th>
			<th width="26%" valign="bottom">Home Team <br> Visitor Team	</th>
			<th width="15%" valign="bottom">Refs	</th>
			<th width="7%" valign="bottom" align="left">Accept	</th>
			<th width="05%" valign="bottom" align="left">Reject	</Th>
			<!--- <TD width="05%" valign="bottom">Rpt	</TD> --->
		</TR>
		</thead>
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
				<TD width="18%" class="tdUnderLine game_field" valign="top">
					<a href="##" class="more_link">#fieldAbbr#</a>
					<div class="more_info">
						<div class="container">
							<cfset fid = FIELD_ID>
							<cfinclude template="fieldDirPop.cfm">
						</div>
					</div>
						<!--- <a href="fieldDirPop.cfm?fid=#FIELD_ID#" target="_blank">#FieldAbbr#</a> --->
				</TD>
				<TD width="25%" class="tdUnderLine" valign="top">
							#Home_TEAMNAME#	
							<!--- #qGetRefGames.Home_CLUB_ID# --->	<!--- (#Forfeit_Home#) --->
						<br><!--- #VISITOR_TEAMNAME# --->	<!--- (#Forfeit_Visitor#)  --->
							<cfif len(trim(VISITOR_TEAMNAME))>
								#VISITOR_TEAMNAME#
								<!--- #qGetRefGames.Visitor_CLUB_ID# --->
							<cfelseif len(trim(Virtual_TeamName))>
								#Virtual_TeamName#
						<!--- 		#qGetRefGames.Visitor_CLUB_ID# --->
							<cfelse>
								&nbsp;
							</cfif>
							 <cfset official_game_date = dateformat(GAME_DATE,"mm/dd/yyyy") & ' ' & timeformat(GAME_TIME,"hh:mm:ss t")>
						 <!--- <cfdump var="#datediff('h',official_game_date,now())#"><cfdump var="#GAME_TIME#"> --->
						<cfif datediff('h',official_game_date,now()) lte 24 and datediff('h',official_game_date,now()) gte -24>
							<p style="margin: 20px 20px 20px 20px;"><a href="GameDayDocuments.cfm?home_team_roster_id=#home_team_roster_id#&visitor_team_roster_id=#visitor_team_roster_id#&home_team_mdf=#home_team_mdf#&visitor_team_mdf=#visitor_team_mdf#&game_id=#game_id#" target="_blank" class="yellow_btn"><i class="fa fa-file"></i> Retrieve Game Day Documents</a></p>
						</cfif>
						<p style="margin: 20px 20px 20px 20px;"><i class="fa fa-envelope" aria-hidden="true"></i><a href="##" class="coachLink" data-id="#game_id#"> Retrieve All Coaches' Emails</a></p>
						

						<CFQUERY name="getAllEmails" datasource="#SESSION.DSN#"> 
							select email from [dbo].[V_CoachesEmailsByTeam]
								where teamId =  <cfqueryparam cfsqltype="cf_sql_integer" VALUE="#Home_Team_ID#">
							UNION
							select email from [dbo].[V_CoachesEmailsByTeam]
							where teamId =  <cfqueryparam cfsqltype="cf_sql_integer" VALUE="#Visitor_Team_ID#">
							group by email
						</CFQUERY>
				<!--- 		<CFQUERY name="getHomeEmail" datasource="#SESSION.DSN#"> 
							select email, teamid from [dbo].[V_CoachesEmailsByTeam]
							where teamId =  <cfqueryparam cfsqltype="cf_sql_integer" VALUE="#Home_Team_ID#">
						</CFQUERY>

						<CFQUERY name="getAwayEmail" datasource="#SESSION.DSN#"> 
							select email, teamid from [dbo].[V_CoachesEmailsByTeam]
							where teamId =  <cfqueryparam cfsqltype="cf_sql_integer" VALUE="#Visitor_Team_ID#">
						</CFQUERY>
 --->

						<!--- create list of home coaches --->
						<!--- <cfset home_coach_list = "">
						<cfloop query="#getHomeEmail#">
							<cfset home_coach_list=listappend(home_coach_list, email, "; ")>	
						</cfloop> --->
						
						<!--- create list of away coaches --->
					<!--- 	 <cfset away_coach_list = "">
						<cfloop query="#getAwayEmail#">
							<cfset away_coach_list=listappend(away_coach_list, email, "; ")>	
						</cfloop> --->

						<!--- Add two lists together, remove duplicates --->
					<!--- 	 <cfset complete_coach_list = "">
						<cfloop query="#getAwayEmail#">
							<cfset complete_coach_list=listappend(complete_coach_list, email, "; ")>	
						</cfloop>
						<cfloop query="#getHomeEmail#">
							<cfset complete_coach_list=listappend(complete_coach_list, email, "; ")>	
						</cfloop>
						 <cfset complete_coach_list = listRemoveDuplicates(complete_coach_list, "; ", true)>  --->

						 <div class="modal email_#game_id#" id="clubPopup">
							<div class="container">

							<hgroup id="modal_title">
								<h2>Coaches' Emails</h2>
							</hgroup>
							<cfoutput>
								<button class="yellow_btn coachEmail" data-elem-id="#game_id#" type="button"><i class="fa fa-envelope" aria-hidden="true"></i> Click here to copy all the emails</button><br>
								
								<div id="CEmail_#game_id#" class="EmailList">
									<!--- <cfloop list="#complete_coach_list#" index="i" delimiters=";"> --->
									<cfloop query="getAllEmails">
										<div class="coach"><a href="mailto:#email#" target="_blank">#email#</a></div>
									</cfloop>
								</div>	
							</Cfoutput>
							</div>
						</div>
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
									<cfif refID EQ refereeContactID and len(trim(txtDisable)) EQ 0> 
										<!--- this REF is the logged in user, let box be checkable --->	
										<cfset txtName	  = "name='CONFIRM_REF_" & GAME_ID & "'">
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
									<cfif refID EQ refereeContactID and len(trim(txtDisable)) EQ 0> 
										<!--- this REF is the logged in user, let box be checkable --->	
										<cfset txtName	  = "name='REJECT_REF_" & GAME_ID & "'">
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
									<cfif AsstRefId1 EQ refereeContactID and len(trim(txtDisable)) EQ 0> 
										<!--- this REF is the logged in user, let box be checkable --->	
										<cfset txtName	  = "name='CONFIRM_AR1_" & GAME_ID & "'">
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
									<cfif AsstRefId1 EQ refereeContactID and len(trim(txtDisable)) EQ 0> 
										<!--- this REF is the logged in user, let box be checkable --->	
										<cfset txtName	  = "name='REJECT_AR1_" & GAME_ID & "'">
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
									<cfif AsstRefId2 EQ refereeContactID and len(trim(txtDisable)) EQ 0> 
										<!--- this REF is the logged in user, let box be checkable --->	
										<cfset txtName	  = "name='CONFIRM_AR2_" & GAME_ID & "'">
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
									<cfif AsstRefId2 EQ refereeContactID and len(trim(txtDisable)) EQ 0> 
										<!--- this REF is the logged in user, let box be checkable --->	
										<cfset txtName	  = "name='REJECT_AR2_" & GAME_ID & "'">
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
			</TR>

	</CFLOOP>
</TABLE>
<!--- <Cfdump var="#variables#"><Cfabort> --->
	<div class="form_btn">
		<button id="accept" name="Accept" class="yellow_btn" type="submit">Accept</button>
	</div>

	</div>
</CFIF>

	
<CFIF isDefined("FORM.PRINTME")><!--- mimeType="text/html" --->
	<!--- This will pop up a window that will display the page in a pdf --->
	<script> window.open('refAssignedGamesPDF.cfm?rcid=#VARIABLES.refereeContactID#','popwin'); </script> 
</CFIF>



</cfoutput>
</div>

<cfsavecontent variable="cf_footer_scripts">
<script>

$(function(){
  $(".coachLink").click(function(event){
  	event.preventDefault();
  	var ID = $(this).data('id');
  	var PopID = '.email_' + ID;
  	$(PopID).addClass('active');
  	$('#veil').addClass('active');

    $('#veil').click(function(){
      $(PopID).removeClass("active");
      $('#veil').removeClass('active');
      $('html, body').removeClass('locked');
    });

  });
});

 $(function(){   
   $(".coachEmail").on('click', function(event){ 
   	  	event.preventDefault();
   	 	var ID = $(this).data('elem-id');
  		var PopID = '.email_' + ID;
  		console.log(PopID);
   		copyToClipboard(document.getElementById("CEmail_"+ID));
   		$("#success").addClass("active");
   		$(PopID).removeClass("active");
  		$('#veil').removeClass('active');
  		$('html, body').removeClass('locked');
   });

   
	function copyToClipboard(elem) {
		// e.preventDefault();
        // create hidden text element, if it doesn't already exist
        var targetId = "_hiddenCopyText_";
        var isInput = elem.tagName === "INPUT" || elem.tagName === "TEXTAREA";
        var origSelectionStart, origSelectionEnd;
        if (isInput) {
            // can just use the original source element for the selection and copy
            target = elem;
            origSelectionStart = elem.selectionStart;
            origSelectionEnd = elem.selectionEnd;
        } else {
            // must use a temporary form element for the selection and copy
            target = document.getElementById(targetId);
            if (!target) {
                var target = document.createElement("textarea");
                target.style.position = "absolute";
                target.style.left = "-9999px";
                target.style.top = "0";
                target.id = targetId;

                document.body.appendChild(target);

            }
            var str = elem.textContent;
            //add ";" between each email
            new_str = str.split(/\s+,|\s+/).join(';');
            //remove first ";"
            new_str = new_str.substring(1);
            target.textContent = new_str;
        }
        // select the content
        var currentFocus = document.activeElement;
        target.focus();
        target.setSelectionRange(0, target.value.length);
        
        // copy the selection
        var succeed;
        try {
            succeed = document.execCommand("copy");
        } catch(e) {
            succeed = false;
        }
        // restore original focus
        if (currentFocus && typeof currentFocus.focus === "function") {
            currentFocus.focus();
        }
        
        if (isInput) {
            // restore prior selection
            elem.setSelectionRange(origSelectionStart, origSelectionEnd);
        } else {
            // clear temporary content
            target.textContent = "";
        }
         return succeed;
    }
   return false;    
 });
</script>
</cfsavecontent>
<cfinclude template="_footer.cfm">

