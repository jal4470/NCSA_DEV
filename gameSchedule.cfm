<!--- 
	FileName:	gameSchedule.cfm
	Created on: 08/12/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: Display game schedule/scores based on parameter:
			gameSchedule.cfm?by=tm = by TEAM
			gameSchedule.cfm?by=cl = by CLUB 		(default case)
			gameSchedule.cfm?by=dv = by DIVISION
			gameSchedule.cfm?by=fl = by FIELD
			gameSchedule.cfm?by=dt = by DATE
			gameSchedule.cfm?by=nn = by nonNCSA ????
	
MODS: mm/dd/yyyy - filastname - comments
01/21/09 - aarnone - put in check to see if schedule should be published "swDisplaySched"
03/06/09 - aarnone - ticket:7309 - virtual team changes for state cup and non league games
03/19/09 - aarnone - as per ncsa, include NON LEAGUE games when viewing by FIELD
03/24/09 - aarnone - as per ncsa, included non league games in some more choices
09/08/17 - apinzone (27455) - changed export to excel text to read "xls" instead of "csv"

NOTE!!! Changes to this file may also need to be applied to gameSchedulePDF.cfm

 --->

<!--- Prevent cacheing of this page --->
<cfheader name="cache-control" value="no-cache, no-store, must-revalidate">
<cfheader name="pragma" value="no-cache">
<cfheader name="expires" value="#getHttpTimeString(now())#">
 
<cfset mid = 3> 
<cfinclude template="_header.cfm">

<div id="contentText">

<cfoutput>

<!--- Finding the logged in user --->
<CFIF isDefined("SESSION.USER.CONTACTID")>
	<CFSET contactSelected = SESSION.USER.CONTACTID >
<CFELSEIF isDefined("FORM.contactSelected") AND FORM.contactSelected GT 0 >
	<CFSET contactSelected = FORM.contactSelected >
<CFELSE>
	<CFSET contactSelected = 0 >
</CFIF>

<CFSET swBoardMEMBER = false>
<CFIF contactSelected GT 0>
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#contact" method="getContactInfo" returnvariable="qContactInfo">
		<cfinvokeargument name="contactID" value="#VARIABLES.contactSelected#">
	</cfinvoke>

	<!--- check if logged in as BOARD MEMBER --->
	<CFIF isDefined("SESSION.MENUROLEID") AND listFind("1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24",SESSION.MENUROLEID) GT 0>
		<cfif isDefined("SESSION.USER.CONTACTROLEID") AND len(trim(SESSION.USER.CONTACTROLEID))>
			<cfinvoke component="#SESSION.SITEVARS.cfcPath#contact" method="getBoardMemberInfo" returnvariable="qBoardMemberInfo">
				<cfinvokeargument name="dsn" value="#SESSION.DSN#">
				<cfinvokeargument name="RoleID" value="#SESSION.USER.CONTACTROLEID#">
				<cfinvokeargument name="ContactID" value="#VARIABLES.contactSelected#">
			</cfinvoke> 

			<CFIF qBoardMemberInfo.RECORDCOUNT>
				<CFSET swBoardMEMBER = true>
			</CFIF>	
		</cfif>
	</CFIF>
</CFIF>
<!--- Ending Logged in user search --->

<CFIF isDefined("URL.BY")>
	<CFSET schedBY = URL.BY>
<CFELSEIF isDefined("FORM.BY")>
	<CFSET schedBY = FORM.BY>
<CFELSE>
	<CFSET schedBY = "">
</CFIF>

<CFIF isDefined("FORM.TEAMID")>
	<CFSET teamIDselected = FORM.TEAMID>
<CFELSE>
	<CFSET teamIDselected = 0>
</CFIF>

<CFIF isDefined("FORM.CLUBID")>
	<CFSET clubIDselected = FORM.CLUBID>
<CFELSE>
	<CFSET clubIDselected = 0>
</CFIF>

<CFIF isDefined("FORM.DIV")>
	<CFSET divSelected = FORM.DIV>
<CFELSE>
	<CFSET divSelected = 0>
</CFIF>

<CFIF isDefined("FORM.DATE_FROM")>
	<CFSET dateSelectedFrom = FORM.DATE_FROM>
<CFELSE>
	<CFSET dateSelectedFrom = 0>
</CFIF>

<CFIF isDefined("FORM.DATE_TO")>
	<CFSET dateSelectedTo = FORM.DATE_To>
<CFELSE>
	<CFSET dateSelectedTo = 0>
</CFIF>

<CFIF isDefined("FORM.FIELDID")>
	<CFSET fieldSelected = FORM.FIELDID>
<CFELSE>
	<CFSET fieldSelected = 0>
</CFIF>
 
<CFSWITCH expression="#VARIABLES.schedBY#">
	<CFCASE value="tm"><!--- BY TEAM --->
		<CFSET h1text = "by Team">
		<CFSET h2text = "Select a team and click Enter to see the team's schedule.">

		<cfinvoke component="#SESSION.sitevars.cfcPath#team" method="getClubTeams" returnvariable="qClubTeams">
			<cfinvokeargument name="orderby"  value="teamname">
		</cfinvoke>  
	</CFCASE>

	<CFCASE value="dv"><!--- BY DIVISION --->
		<CFSET h1text = "by Division">
		<CFSET h2text = "Select a Division and click Enter to see the schedule.">

		<cfinvoke component="#SESSION.sitevars.cfcPath#Game" method="getGameDivisions" returnvariable="qGameDivs">
		</cfinvoke>  

		<!--- <cfinvoke component="#SESSION.sitevars.cfcPath#Game" method="getGameDates" returnvariable="qGameDT">
		</cfinvoke>   --->
	</CFCASE>

	<CFCASE value="fl"><!--- BY FIELD --->
		<CFSET h1text = "by Field">
		<CFSET h2text = "Select a Field and click Enter to see the schedule.">
		<cfinvoke component="#SESSION.sitevars.cfcPath#Game" method="getGameFields" returnvariable="qGameFields">
		</cfinvoke>  
	</CFCASE>

	<CFCASE value="dt"><!--- BY DATE --->
		<CFSET h1text = "by Date">
		<CFSET h2text = "Select a Weekend and click Enter to see the schedule.">
		<cfinvoke component="#SESSION.sitevars.cfcPath#Game" method="getGameDates" returnvariable="qGameDT">
		</cfinvoke>
	</CFCASE>

	<CFCASE value="nn"><!--- BY NON NCSA --->
		<CFSET h1text = "by NON NCSA games">
		<CFSET h2text = "Select a Weekend and click Enter to see the schedule.">
		<cfinvoke component="#SESSION.sitevars.cfcPath#Game" method="getGameDates" returnvariable="qGameDT">

	</CFCASE>

	<cfdefaultcase><!--- BY CLUB --->
		<CFSET h1text = "by Club">
		<CFSET h2text = "Select a club and click Enter to see the schedule.">

		<cfinvoke component="#SESSION.sitevars.cfcPath#club" method="getClubInfo" returnvariable="qClubs">
			<cfinvokeargument name="orderby"  value="clubname">
		</cfinvoke>  
	</cfdefaultcase>
</CFSWITCH>


<H1 class="pageheading">NCSA Games Schedule - #variables.h1text# </H1>

<!--- use query instead of session because it is a public page --->
<CFQUERY name="qGetSchedDisplay" datasource="#SESSION.DSN#">
	SELECT _VALUE
	  FROM TBL_GLOBAL_VARS
	 WHERE _NAME = 'AllowSchedDisplay'
</CFQUERY>
<CFSET swDisplaySched = qGetSchedDisplay._VALUE>

<CFIF swDisplaySched EQ "N" >
	<span class="red"><b>The schedule is currently not available.</b></span>
<cfelse>
	
	<CFSWITCH expression="#VARIABLES.schedBY#">
		<!--- FOR: game.cfc method="getGameSchedule"
				argument notLeague = ""  = all games 
				argument notLeague = "Y" = non League games only: F, C, N, P
				argument notLeague = "N" = League games only
		 ---> 
		<CFCASE value="tm"><!--- BY TEAM --->
			<CFIF isDefined("VARIABLES.teamIDselected") AND teamIDselected GT 0>
				<cfinvoke component="#SESSION.sitevars.cfcPath#game" method="getGameSchedule" returnvariable="qGames">
					<cfinvokeargument name="teamID"  value="#FORM.TEAMID#">
					<cfinvokeargument name="notLeague" value="">
					<cfinvokeargument name="seasonID" value="#session.currentseason.id#">
				</cfinvoke>  
			</CFIF>
		</CFCASE>
	
		<CFCASE value="dv"><!--- BY DIVISION --->
			<CFIF isDefined("VARIABLES.divSelected") AND divSelected GT 0 >
				<cfinvoke component="#SESSION.sitevars.cfcPath#game" method="getGameSchedule" returnvariable="qGames">
					<cfinvokeargument name="division" value="#FORM.DIV#">
					<cfinvokeargument name="notLeague" value="N">
					<cfinvokeargument name="seasonID" value="#session.currentseason.id#">
				</cfinvoke>  <!--- <cfinvokeargument name="date" 	  value="#FORM.DATE#"> --->
			</CFIF>	
		</CFCASE>
	
		<CFCASE value="fl"><!--- BY FIELD --->
			<CFIF isDefined("VARIABLES.fieldSelected") AND fieldSelected GT 0 >
				<cfinvoke component="#SESSION.sitevars.cfcPath#game" method="getGameSchedule" returnvariable="qGames">
					<cfinvokeargument name="fieldID" value="#FORM.FIELDID#">
					<cfinvokeargument name="notLeague" value="">
					<cfinvokeargument name="seasonID" value="#session.currentseason.id#">
				</cfinvoke>  
			</CFIF>	
		</CFCASE>
	
		<CFCASE value="dt"><!--- BY DATE --->
			<CFIF isDefined("VARIABLES.dateSelectedFrom") AND dateSelectedFrom GT 0 >
				<CFSET fromDate = dateSelectedFrom>
				<CFSET toDate   = 0>
				<CFIF dateSelectedTo GT 0>
					<CFIF dateSelectedTo GT dateSelectedFrom>
						<CFSET toDate   = dateSelectedTo>
					</CFIF>
				</CFIF>	
				<cfinvoke component="#SESSION.sitevars.cfcPath#game" method="getGameSchedule" returnvariable="qGames">
					<cfinvokeargument name="fromDate" value="#VARIABLES.fromDate#">
					<cfinvokeargument name="toDate"   value="#VARIABLES.toDate#">
					<cfinvokeargument name="notLeague" value="">
				</cfinvoke> 
			</CFIF>	
		</CFCASE>
	
		<CFCASE value="nn"><!--- BY NON NCSA --->
			<CFIF isDefined("VARIABLES.dateSelectedFrom") AND dateSelectedFrom GT 0 >
				<CFSET fromDate = dateSelectedFrom>
				<CFSET toDate   = 0>
				<CFIF dateSelectedTo GT 0>
					<CFIF dateSelectedTo GT dateSelectedFrom>
						<CFSET toDate   = dateSelectedTo>
					</CFIF>
				</CFIF>	
				<cfinvoke component="#SESSION.sitevars.cfcPath#game" method="getGameSchedule" returnvariable="qGames">
					<cfinvokeargument name="fromDate" value="#VARIABLES.fromDate#">
					<cfinvokeargument name="toDate"   value="#VARIABLES.toDate#">
					<cfinvokeargument name="notLeague" value="Y">
				</cfinvoke> 
				<cfquery name="qGames" dbtype="query">
					SELECT * FROM qGames
					ORDER BY GAME_TYPE
				</cfquery>
			</CFIF>	
		</CFCASE>
	
		<cfdefaultcase><!--- BY CLUB --->
			<CFIF isDefined("VARIABLES.clubIDselected") AND clubIDselected GT 0>
				<cfinvoke component="#SESSION.sitevars.cfcPath#game" method="getGameSchedule" returnvariable="qGames">
					<cfinvokeargument name="clubID"  value="#FORM.clubID#">
					<cfinvokeargument name="seasonID" value="#session.currentseason.id#">
					<cfinvokeargument name="notLeague" value="">
				</cfinvoke>  
			</CFIF>
		</cfdefaultcase>
	</CFSWITCH> 

	<form action="gameSchedule.cfm" method="post" class="clearfix" style="position:relative;">
		<input type="Hidden" name="BY" value="#VARIABLES.schedBY#">

<!--- TEAM SELECT --->
		<CFIF isDefined("qClubTeams") AND qClubTeams.recordCount >
			<label class="select_label" for="teamID">#variables.h2text#</label>
			<div class="select_box">
				<SELECT id="teamID" name="teamID">
					<option value="0">Select a team</option>
					<cfloop query="qClubTeams">
						<CFIF len(trim(TEAMNAMEderived))>
							<option value="#team_id#" <CFIF team_id EQ teamIDselected>selected</CFIF> >#TEAMNAMEderived#</option>
						</CFIF>
					</cfloop>
				</SELECT>
			</div>
		</CFIF>

<!--- CLUB SELECT --->
		<CFIF isDefined("qClubs") AND qClubs.recordCount >
			<label class="select_label" for="clubID">#variables.h2text#</label>
			<div class="select_box">
				<SELECT id="clubID" name="clubID">
					<option value="0">Select a Club</option>
					<cfloop query="qClubs">
						<CFIF club_id GT 2>
						<option value="#club_id#" <CFIF club_id EQ clubIDselected>selected</CFIF> >#club_name#</option>
						</CFIF>
					</cfloop>
				</SELECT>
			</div>
		</CFIF>

<!--- DIVISION SELECT --->
		<CFIF isDefined("qGameDivs") AND qGameDivs.recordCount>
			<label class="select_label" for="divSelect">#variables.h2text#</label>
			<div class="select_box">
			<SELECT id="divSelect" name="div">
				<option value="0">Select a Division</option>
				<cfloop query="qGameDivs">
					<option value="#DIVISION#" <CFIF DIVISION EQ divSelected>selected</CFIF> >#DIVISION#</option>
				</cfloop>
			</SELECT>
			</div>
		</CFIF>

<!--- DATE RANGE --->				
		<CFIF isDefined("qGameDT") AND qGameDT.recordCount>
			<h3 class="select_label">#variables.h2text#</h3>

			<div class="date_select_wrapper">
				<label class="select_label date" for="date_from">From:</label>
				<div class="select_box date">
					<SELECT id="date_from" name="DATE_FROM">
						<option value="0" <CFIF dateSelectedFrom EQ 0>selected</CFIF> >Select a Date</option>
						<cfloop query="qGameDT">
							<cfset ftGameDate = dateFormat(game_date,"mm/dd/yyyy")>
							<cfif datePart("yyyy",ftGameDate) GT 2000>
								<option value="#ftGameDate#" <CFIF ftGameDate EQ dateSelectedFrom>selected</CFIF> >#ftGameDate#</option>
							</cfif>
						</cfloop>
					</SELECT>
				</div>
			</div>

			<div class="date_select_wrapper">
				<label class="select_label date" for="date_to">To:</label>
				<div class="select_box date">
					<SELECT id="date_to" name="DATE_TO">
						<option value="0" <CFIF dateSelectedTo EQ 0>selected</CFIF> >Select a Date</option>
						<cfloop query="qGameDT">
							<cfset ftGameDate = dateFormat(game_date,"mm/dd/yyyy")>
							<cfif datePart("yyyy",ftGameDate) GT 2000>
								<option value="#ftGameDate#" <CFIF ftGameDate EQ dateSelectedTo>selected</CFIF> >#ftGameDate#</option>
							</cfif>
						</cfloop>
					</SELECT>
				</div>
			</div>
		</CFIF>

<!--- SELECT A FIELD --->				
		<CFIF isDefined("qGameFields") AND qGameFields.recordCount>
			<label class="select_label" for="fieldID">#variables.h2text#</label>
			<div class="select_box">
				<SELECT id="fieldID" name="FIELDID">
					<option value="0">Select a Field</option>
					<cfloop query="qGameFields">
						<option value="#FIELD_ID#" <CFIF FIELD_ID EQ fieldSelected>selected</CFIF> >#FIELDABBR#</option>
					</cfloop>
				</SELECT>
			</div>
		</CFIF>

<!--- SUBMIT SELECT BOX --->
		<button type="submit" name="getGames" class="gray_btn select_btn">Enter</button>
		<!--- <input type="Submit" name="getGames" value="Enter"> --->

<!--- EXCEL / PRINT --->
				<CFIF isDefined("qGames") AND qGames.RECORDCOUNT>
					<div class="schedule_cta_wrapper">
						<button class="schedule_cta export yellow_btn" name="csv_export" onClick="window.open('gameSchedule_csv.cfm?BY=#VARIABLES.schedBY#&TID=#VARIABLES.teamIDselected#&CID=#VARIABLES.clubIDselected#&DIV=#VARIABLES.divSelected#&FROM=#VARIABLES.dateSelectedFrom#&TO=#VARIABLES.dateSelectedTo#&FID=#VARIABLES.fieldSelected#');">Export to Excel (XLS)</button>
						<button class="schedule_cta print yellow_btn" type="Submit" name="printme">Printer Friendly</button>
					</div>
				</CFIF>
	
	</form>

</CFIF><!--- IF swDisplaySched EQ "N"  --->



<CFIF isDefined("qGames") AND qGames.RECORDCOUNT>

	<cfif len(trim(DATESELECTEDFROM)) and len(trim(DATESELECTEDTO)) and DATESELECTEDFROM NEQ 0 and DATESELECTEDTO NEQ 0>
		<cfset viewing_description = 'Games between #dateSelectedFrom# and #dateSelectedTo#'>
	<cfelseif len(trim(DIVSELECTED)) and DIVSELECTED NEQ 0>
		<cfset viewing_description = '#divSelected#'>
	<cfelseif len(trim(FIELDSELECTED)) and FIELDSELECTED NEQ 0>
		<cfquery name="getFieldName" dbtype="query">
			select FIELDABBR
			from qGameFields
			where FIELD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#fieldSelected#">
		</cfquery>
		<cfset viewing_description = '#getFieldName.FIELDABBR#'>
	<cfelseif len(trim(TEAMIDSELECTED)) and TEAMIDSELECTED NEQ 0>
		<cfquery name="getTeamName" dbtype="query">
			select TEAMNAMEderived
			from qClubTeams
			where team_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#teamIDselected#">
		</cfquery>
		<cfset viewing_description = '#getTeamName.TEAMNAMEderived#'>
	<cfelseif len(trim(CLUBIDSELECTED)) and CLUBIDSELECTED NEQ 0>
		<cfquery name="getClubName" dbtype="query">
			select club_name
			from qClubs
			where club_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#clubIDselected#">
		</cfquery>
		<cfset viewing_description = '#getClubName.club_name#'>
	<cfelse>
		<cfset viewing_description = ''>
	</cfif>

	<p class="calendar_instructions">
		<b style="color:red">NOTE:</b>  The calendar APP for each device differs in functionality for adding the attached event to your calendar.  For example, in Outlook, click on the attachment and save it to your Outlook calendar.  Follow the instructions for your calendar APP in order to add the event to your calendar. Android devices mainly support Google calendar, adding events to other calendars may not work properly. IOS devices will mainly work with the local calendar, an iCloud based calendar update may fail.
	</p>

	<h3 class="viewing_info">
		<span>Viewing:</span> <cfoutput>#viewing_description#</cfoutput>
	</h3>

	<table id="schedule_table" cellspacing="0" cellpadding="0">
		<CFIF schedBY NEQ "nn">
			<thead class="no_mobile">
				<tr>
					<th class="add_calendar"></th>
					<th class="date_time">Date/Time</th>
	   	 		<th class="game_type">Type</th>
	    		<th class="game_number">Game##</th>
	    		<th class="game_division">Div</th>
					<th class="game_field">Field</th>
					<th class="game_home_team">Home Team</th>
					<th class="game_visitor_team">Visitor Team</th>
					<th class="game_home_score">HS</th>
					<th class="game_visitor_score">VS</th>
					<th class="game_referee">REF</th>
				</tr>
			</thead>		
		</CFIF>

		<cfset gameTypeHOLD = "">
		<CFLOOP query="qGames">
			<CFIF schedBY EQ "nn">
				<CFIF GAME_TYPE NEQ gameTypeHOLD>
						<tr>
							<th colspan="10" align="center"> 
								<h2>
									<cfswitch expression="#game_type#">
										<cfcase value="F">Friendly</cfcase>
										<cfcase value="C">State Cup</cfcase>
										<cfcase value="P">Playoff</cfcase>
										<cfcase value="N">Non League</cfcase>
										<cfdefaultcase>&nbsp;</cfdefaultcase>
									</cfswitch>
									Games 
								</H2>
							</th>
					    </tr>
					<thead class="no_mobile">
						<tr>
							<th class="add_calendar"></th>
							<th class="date_time">Date/Time</th>
			   	 		<th class="game_type">Type</th>
			    		<th class="game_number">Game##</th>
			    		<th class="game_division">Div</th>
							<th class="game_field">Field</th>
							<th class="game_home_team">Home Team</th>
							<th class="game_visitor_team">Visitor Team</th>
							<th class="game_home_score">HS</th>
							<th class="game_visitor_score">VS</th>
							<th class="game_referee">REF</th>
						</tr>
					</thead>
				<cfset gameTypeHOLD = GAME_TYPE>
				</CFIF>
			</CFIF>
			<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
        
				<td nowrap class="add_calendar">
					<cfif GAME_DATE GTE now()>
							<button class="calendar_trigger" data-field-id="#FIELD_ID#" data-game-id="#game_id#" data-date="#DATEFORMAT(GAME_DATE,'mm/dd/yyyy')#" data-time="#TIMEFORMAT(GAME_TIME,'hh:mm tt')#" data-field="#fieldname#" data-home-team="#Home_TeamName#" <CFIF len(trim(Visitor_TeamName)) AND len(trim(Virtual_TeamName)) EQ 0> data-away-team="#Visitor_TeamName#" <CFELSE> data-away-team="#Virtual_TeamName#" </CFIF>>
								<i class="fa fa-calendar-plus-o" aria-hidden="true"></i>
								<span class="mobile_only">Add to Calendar</span>
							</button>
          </cfif>
				</td>
        
				<td nowrap class="date_time full"> 
				  <span class="game_day">#UCASE(DATEFORMAT(GAME_DATE,"ddd"))#</span> 
				  <span class="dash">-</span> 
				  <span class="game_date">#DATEFORMAT(GAME_DATE,"mm/dd/yy")#</span> 
				  <span class="dash">-</span> 
				  <span class="game_time">#TIMEFORMAT(GAME_TIME,"hh:mm tt")#</span> 
				</td>
				<td nowrap class="game_type"> 
					<span class="mobile_only">Type:</span>
					<cfswitch expression="#game_type#">
						<cfcase value="F">Friendly</cfcase>
						<cfcase value="C">State Cup</cfcase>
						<cfcase value="P">Playoff</cfcase>
						<cfcase value="N">Non League</cfcase>
						<cfdefaultcase>&nbsp;</cfdefaultcase>
					</cfswitch>
				</td>
				<td class="game_number">
					<span class="mobile_only">Game##:</span> 
					#game_id# <!--- game_code --->
				</td>
				<td class="game_division"> 
					<span class="mobile_only">Division:</span>
					#Division# 
				</td>
				<td class="game_field"> 
					<span class="mobile_only">Field:</span>
					<a href="##" class="more_link">#fieldAbbr#</a>
					<div class="more_info">
						<div class="container">
							<cfset fid = FIELD_ID>
							<cfinclude template="fieldDirPop.cfm">
						</div>
					</div>
					<!--- <a href="fieldDirPop.cfm?fid=#FIELD_ID#" target="_blank">#fieldAbbr#</a> --->
				</td>
				<td class="game_home_team"> 
				<!--- HOME TEAM NAME, bold if selecting CLUB or TEAM  --->
					<span class="mobile_only">Home Team:</span>
					<cfset swBold = false> 
					<CFIF Home_CLUB_ID EQ clubIDselected>
						<cfset swBold = true>
					<CFELSEIF Home_Team_ID EQ teamIDselected>
						<cfset swBold = true>
					</CFIF>
					<cfif swBold><b></cfif> #Home_TeamName# <cfif swBold></b></cfif>
					&nbsp;
				</td>
				<td class="game_visitor_team">
				<!--- VISITOR TEAM NAME, bold if selecting CLUB or TEAM, 
					 IF name is blank then it could be a write-in for STATECUP or NONLEAGUE GAMES  --->
					<span class="mobile_only">Visitor Team:</span>
					<CFIF len(trim(Visitor_TeamName)) AND len(trim(Virtual_TeamName)) EQ 0>
						<cfset swBold = false>
						<CFIF Visitor_CLUB_ID EQ clubIDselected>
							<cfset swBold = true>
						<CFELSEIF Visitor_Team_ID EQ teamIDselected>
							<cfset swBold = true>
						</CFIF>
						<cfif swBold><b></cfif> #Visitor_TeamName# <cfif swBold></b></cfif>
					<CFELSE><!--- state cup or non league game --->
						#Virtual_TeamName#
					</CFIF>
					&nbsp;
				</td>
				<td class="game_home_score">
					<span class="mobile_only">Home Score:</span> 
					#Score_Home# 
				</td>
				<td class="game_visitor_score">
					<span class="mobile_only">Visitor Score:</span> 
					#Score_visitor# 
				</td>
				<td class="game_referee"> 
					<span class="mobile_only">Referee:</span>
					<CFIF len(trim(RefID))>
						<cfif Ref_accept_YN EQ "Y">
							<span class="green">Accepted</span>
						</cfif>
					</CFIF> 
				</td>
	 		</tr>
		</CFLOOP>
	</table>

	<div id="calendar_popup" class="modal">
		<hgroup id="modal_title">
			<h2>Add to Calendar Confirmation</h2>
			<cfif contactSelected GT 0>
				<h3>Please confirm your email address below.</h3>
			<cfelse>
				<h3>Please enter your email address below.</h3>
			</cfif>
		</hgroup>
		<cfset game_address = #qDirections.ADDRESS# & ", " & #qDirections.CITY# & ", " & #qDirections.STATE# & " " & #qDirections.ZIPCODE#>
		<form id="form_game" class="iCalForm" action="iCal/index.cfm" method="post">
			<input type="hidden" name="sch_gm_date" value="">
			<input type="hidden" name="sch_gm_time" value="">
			<input type="hidden" name="sch_gm_field" value="">
			<input type="hidden" name="sch_gm_home_team" value="">
			<input type="hidden" name="sch_gm_away_team" value="">
			<input type="hidden" name="sch_gm_id" value="">
			<input type="hidden" name="sch_fld_id" value="">

			<div class="notification"></div>
			<div class="form_field">
			  <label for="user_email">Email</label>		
			  <cfif contactSelected GT 0>
			  	<cfif swBoardMEMBER EQ true AND len(trim(qBoardMemberInfo.CONTACTEMAIL))>
			  		<input type="text" id="user_email" name="user_email" value="#qBoardMemberInfo.CONTACTEMAIL#">
			  	<cfelseif len(trim(qContactInfo.EMAIL))>
			  		<input type="text" id="user_email" name="user_email" value="#qContactInfo.EMAIL#">
			  	<cfelse>
			  		<input type="text" id="user_email" name="user_email" value="">
			  	</cfif>
			  <cfelse>
			      <input type="text" id="user_email" name="user_email" value="">
			  </cfif>
			</div>
			<div class="form_btn">
			<button id="calendar_close"  class="gray_btn"   type="button">Cancel</button>
			<button id="calendar_submit" class="yellow_btn" type="submit">Send Email</button>
			</div>
		</form>
	</div>

<CFELSEIF isDefined("qGames") AND qGames.RECORDCOUNT EQ 0>
	
	<p class="red">No games found.</p>

</CFIF>

</cfoutput>
</DIV>
<cfinclude template="_footer.cfm">

<CFIF isDefined("FORM.PRINTME")><!--- mimeType="text/html" --->
	<cfoutput><!--- This will pop up a window that will display the page in a pdf --->
	<script> window.open('gameSchedulePDF.cfm?BY=#VARIABLES.schedBY#&TID=#VARIABLES.teamIDselected#&CID=#VARIABLES.clubIDselected#&DIV=#VARIABLES.divSelected#&FROM=#VARIABLES.dateSelectedFrom#&TO=#VARIABLES.dateSelectedTo#&FID=#VARIABLES.fieldSelected#','popwin'); </script> 
	</cfoutput>
</CFIF>