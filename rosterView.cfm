
<cfinclude template="_checkLogin.cfm">

<cfif isdefined("url.roster_id")>
	<cfset roster_id = url.roster_id>
<cfelseif isdefined("variables.roster_id")>
	<cfset roster_id = variables.roster_id>
</cfif>

<cfquery name="getBin" datasource="#session.DSN#">
	Select content,  team_id
	from tbl_roster
	where roster_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#roster_id#">
</cfquery>


<!--- guess content type --->

<cfset mimeType="application/pdf">


<!--- if mime type is still blank, set to default --->
<cfif not isdefined("mimeType") OR mimeType EQ "">
	<cfset mimeType="application/file">
</cfif>

<cfif isdefined("Bin") and Bin>
		<cfset roster = "#toBinary(getBin.content)#">
<cfelse>
	<cfheader name="Content-Disposition" value="inline; filename=#getBin.team_id#.pdf">

	<cfcontent variable="#toBinary(getBin.content)#" type="#mimeType#">
</cfif>