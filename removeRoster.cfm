<!--- 
	FileName:	removeRoster.cfm
	Created on: 8/22/2020
	Created by: J Lechuga
	
	Purpose: Remove Roster
	


 --->
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_checkLogin.cfm">

<!--- set to watermark --->
<cfset rosterType=1>
<!--- Set team and game to 0 --->
<cfif isdefined("url.roster_id")>
	<cfset roster_id = url.roster_id>
</cfif>

<cfif isdefined("url.team_id")>
	<!--- Used to return the user back to where they came from --->
	<cfset team_id = url.team_id>
</cfif>

<cfif isdefined("roster_id")>
	<cfstoredproc datasource="#session.dsn#" procedure="p_remove_roster">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@roster_id" type="in" value="#roster_id#">
	</cfstoredproc>
</cfif>

<cflocation url="addTeamRoster.cfm?team_id=#team_id#" addtoken="No">




 
