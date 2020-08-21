<!--- 
	FileName:	loginhome.cfm
	Created on: 08/21/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: this page is the landing page after a user has logged in
	
MODS: mm/dd/yyyy - filastname - comments
12/03/08 - aa - removed display of iRc
04/24/09 - aarnone - T:7596 - but in logic for holdclubid and holdclubname for club reps that also have boardmember roles. 
7/19/2010 - B.Cooper
8818 - Modified to set club id based on role clicked.  pulled from most recent season for a given contact and role.
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">

<cfoutput>

<CFIF isDefined("SESSION.USER")>

	<CFIF NOT isDefined("URL.RID")>
		<CFIF structCount(SESSION.USER.stRole) GT 1>
			<!--- START - the following lines of code also appear below --->
			<div id="contentText">
			<H1 class="pageheading">NCSA - Home page (logged in)</H1>
			<H2> Welcome #SESSION.USER.fName# #SESSION.USER.lName# 
				<CFIF isDefined("SESSION.USER.CLUBNAME") and len(trim(SESSION.USER.CLUBNAME))>
					of #SESSION.USER.CLUBNAME#
				</CFIF>
			</H2>
			<br><br>
			<!--- END - the following lines of code also appear below --->
			<table width="800px" cellspacing="0" cellpadding="5" align="center" border="0">
				<tr class="tblHeading">	
					<td> Please select one of the menus below:</td>	
				</tr>
				<CFSET ctLOOP = 1>
				
				<cfset keyList = listSort(structKeyList(SESSION.USER.stRole),"numeric","asc")>
				<Cfloop list="#keyList#" index="iRC">
					<CFQUERY name="getRoleInfo" datasource="#SESSION.DSN#">
						SELECT ROLE_ID, RoleDisplayName
						  FROM TLKP_ROLE
						 WHERE roleCode = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#SESSION.USER.stRole[iRC]#">
					</CFQUERY>
					<CFIF getRoleInfo.RECORDCOUNT>
						<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,VARIABLES.ctLoop)#">
							<td valign="top" class="tdUnderLine">
								<a href="loginHome.cfm?rid=#getRoleInfo.Role_ID#">#getRoleInfo.RoleDisplayName#</a>  
							</td>
						</tr>
						<CFSET ctLOOP = ctLOOP + 1>
					</CFIF>
				</CFLOOP> 
			</table>
			</div>
		</CFIF>
	<cfelseif isDefined("SESSION.MENUROLEID") AND isDefined("SESSION.USER")><!--- session.menuroleid set in _header.cfm based on url.rid --->
	
		<!--- set session user club info based on this menuroleid --->
		<cfquery datasource="#application.dsn#" name="getRoleClubInfo">
			select a.contact_id, a.role_id, b.club_id, b.club_name 
			from xref_contact_role a
			inner join tbl_club b
			on a.club_id=b.club_id
			where contact_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user.contactid#">
			and role_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.menuroleid#">
			order by season_id desc
		</cfquery>
		
		<cfif getRoleClubInfo.recordcount>
			<CFSET SESSION.User.Clubid		  = getRoleClubInfo.club_id >
			<CFSET SESSION.User.ClubName	  = getRoleClubInfo.club_name >
		<cfelse>
			<!--- no record found for this contact and role.  this shouldn't happen --->
		</cfif>
	
	
		<CFSWITCH expression="#SESSION.MENUROLEID#">
			<cfcase value="25"> <!--- referee --->
				<!--- REFEREES --->	
				<cfinclude template="_refereePage.cfm">
					<!--- 
					<CFQUERY name="qGetRefGames" datasource="#SESSION.DSN#">
						Select Game_ID, GAME_Date, GAME_Time, Division, Fieldname, FieldAbbr, Field_ID, 
						       HOME_TEAMNAME, VISITOR_TEAMNAME, Forfeit_Home, Forfeit_Visitor, 
							   RefID, Ref_accept_Date, Home_CLUB_ID, AsstRefID1 , AsstRefID2, ARef1AcptDate, ARef2AcptDate 
						  from V_Games A 
						 WHERE ( RefID 	    = #SESSION.USER.ContactID# and (Ref_accept_Date	is Null or Ref_accept_Date = '') )
						    or ( AsstRefID1 = #SESSION.USER.ContactID# and (ARef1AcptDate   is Null or ARef1AcptDate   = '') )
							or ( AsstRefID2 = #SESSION.USER.ContactID# and (ARef2AcptDate   is Null or ARef2AcptDate   = '') )
					</CFQUERY> 
					<br>      New Game Assignments: [#qGetRefGames.RECORDCOUNT#] <cfif qGetRefGames.RECORDCOUNT>Please confirm assignments.</cfif>
					<br> <br> E-mail carl.dietze@worldnet.att.net and edseavers@earthlink.net immediately if you are not accepting NJ matches and rvsoccer1@aol.com for NY matches. 
					<br> <br> NOTE: Printed referee report with roster still needs to be mailed as before. 
					<br> --->
			</cfcase>
			<cfcase value="26,27,28"> 
				<!--- CLUB USERS --->
				<!--- <cfif session.user.clubid EQ 1>
					<!--- They are a club user AND a board member so restore their club info so that 
						  the club pages will show only data for thier club --->
				
					<CFLOCK scope="SESSION" type="EXCLUSIVE" timeout="5">
						<!--- 9/1/2009 bcooper: Is this backwards?  throws error --->
						<!--- <CFSET SESSION.User.Clubid 		= SESSION.USER.holdclubid    >
						<CFSET SESSION.User.ClubName 	= SESSION.USER.holdclubname > --->
						<CFSET SESSION.User.holdclubid 		= SESSION.USER.Clubid    >
						<CFSET SESSION.User.holdclubname 	= SESSION.USER.ClubName >
					</CFLOCK> 
				</cfif> --->
				<!--- go to CLUB homepage as a CLUB user --->		
				<cfinclude template="_clubPage.cfm">
			</cfcase>
			<cfcase value="29">
				<cfinclude template="_coachesPage.cfm">
			</cfcase>
			<cfdefaultcase> 
				<!--- ALL ELSE ... --->
				<!--- <cfif session.user.clubid NEQ 1>
					<!--- they are board members who are also club reps so their 
						  club info must be saved and replaced with club 1 info so that
						  the admin pages do not limit their view to only their club. --->
					
					<CFLOCK scope="SESSION" type="EXCLUSIVE" timeout="5">
						<CFSET SESSION.USER.holdclubid    = SESSION.User.Clubid >
						<CFSET SESSION.USER.holdclubname  = SESSION.User.ClubName >
						<CFSET SESSION.User.Clubid		  = 1 >
						<CFSET SESSION.User.ClubName	  = "Northern Counties Soccer Association" >
					</CFLOCK> 
				</cfif> --->
				<!--- go to BOARDMEMBER homepage as a BoardMember --->		
				<cfinclude template="_boardMemPage.cfm">
			</cfdefaultcase>
		</CFSWITCH>
	</cfif>
	


	
</CFIF>

</cfoutput>

<cfinclude template="_footer.cfm">
