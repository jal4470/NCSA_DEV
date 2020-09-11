<!--- 
	FileName:	AddTeamRoster.cfm
	Created on: 2/121/2011
	Created by: bcooper@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
7-29-2014 - J. Danz - (TICKET NCSA15481) - updated the "get teams for user login" ifstatment to include id 20 and changed the condition to GTE instead of just GT so that Assistant Admins can get access as well.
05/25/2017 - A. Pinzone - Ticket NCSA22821
	-- Moved jQuery & JS to footer
	-- Moved jQuery CSS to the header
	-- Removed reference to older jquery (1.4.2)
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>


<CFIF isDefined("FORM.team_id")>
	<CFSET team_id = FORM.team_id>
<cfelseif isdefined("url.team_id")>
	<cfset team_id=url.team_id>
<CFELSE>
	<CFSET team_id = "">
</CFIF>

<cfif isdefined("url.game_id")>
	<cfset game_id=url.game_id>
</cfif>
<cfset error = "">

	<!--- get teams for user logged in --->
	<cfif listFind("1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21",Session.menuroleID) GTE 1> <!--- if admin/board user --->
		<cfinvoke
			component="#session.sitevars.cfcpath#team"
			method="getClubTeams"
			clubid="0"
			orderBy="CLUB"
			season_id="#session.currentseason.id#"
			excludeNonLeague="yes"
			returnvariable="contactTeams">
	<cfelseif listfind("26,27,28",session.menuroleid) NEQ 0><!--- if user is club rep/alt rep/pres --->
		<cfinvoke
			component="#session.sitevars.cfcpath#team"
			method="getClubTeams"
			clubid="#session.user.clubid#"
			season_id="#session.currentseason.id#"
			excludeNonLeague="yes"
			returnvariable="contactTeams">
	<cfelse>
		<cfinvoke
			component="#session.sitevars.cfcpath#team"
			method="getContactTeams"
			contact_id="#session.user.contactid#"
			season_id="#session.currentseason.id#"
			excludeNonLeague="yes"
			returnvariable="contactTeams">
	</cfif>
	
	<cfif contactTeams.recordcount EQ 1>
		<cfset team_id=contactTeams.team_id>
	</cfif>


<div id="contentText">
<H1 class="pageheading">NCSA - Add/Replace Active Team Roster</H1>
<br> <!--- <h2>yyyyyy </h2> --->


<cfif isDefined("error_occured") and error_occured EQ 1>
<h2 style="margin: 20px 0; color: black;" >#error#.</h2>
<div><input type="button" onclick="history.go(-1);" value="&laquo; Go Back" /></div>

<cfelse>
<!--- <cfif not isdefined("game_id")> --->
	<FORM action="#cgi.script_name#" method="post">
		
	<table cellspacing="0" cellpadding="2" align="center" border="0" width="99%">
	<tr>
		<td>
			
			<select name="team_id">
				<cfloop query="contactTeams">
					<option value="#team_id#" <cfif isdefined("team_id") and contactTeams.team_id eq variables.team_id>selected</cfif>>#teamname#</option>
				</cfloop>
			</select>
		
			<INPUT type="submit" value="Select Team">
		</td> 
	</tr> 
	</table>
	</form>
	<CFIF isDefined("team_id") and len(trim(team_id))>
			<cfquery datasource="#application.dsn#" name="getTeamInfo">
				select t.team_id, dbo.getteamname(t.team_id) as teamname ,dbo.f_getTeamRoster(t.team_id) as roster_id
				from tbl_team t
				where t.team_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#team_id#">
			</cfquery>

		<div class="notice">
			To upload a roster click upload, if applicable. To View the roster click view, to replace the roster, click replace.
		</div>
		<div>
			<!--- <span>Working with: #getTeamInfo.teamname#</span> <a href="addTeamRoster.cfm?pmid=54&smid=256">Select a New Team</a> --->
		<table class="table1" cellpadding="3" cellspacing="0" border="0">
			<thead>
			<tr>
				<th>Team Number</th>
				<th>Team Name</th>
				<th style="text-align:center;">Team Roster</th>
			</TR>
			</thead>
			<tbody>
			
			<cfloop query="getTeamInfo">
				<tr>
					<td>#team_id#</td>
					<td>#teamname#</td>
					<td style="text-align:center;">
						<cfif roster_id NEQ "">
							<a target="_blank" href="rosterView.cfm?roster_id=#getTeamInfo.roster_id#">View</a>|<a href="uploadRoster.cfm?team_id=#getTeamInfo.team_id#" >Replace</a>
						<cfelse>
							<a  href="uploadRoster.cfm?team_id=#team_id#">Upload</a>
						</cfif>
					</td>

			</cfloop>
			</tbody>
		</TABLE>
	</CFIF>


</cfif>
</cfoutput>
</div>
<cfinclude template="_footer.cfm">

