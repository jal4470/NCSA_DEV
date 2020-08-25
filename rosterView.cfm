
<cfinclude template="_checkLogin.cfm">

<cfquery name="getBin" datasource="#session.DSN#">
	Select content,  team_id
	from tbl_roster
	where roster_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#url.roster_id#">
</cfquery>


<!--- guess content type --->

<cfset mimeType="application/pdf">


<!--- if mime type is still blank, set to default --->
<cfif not isdefined("mimeType") OR mimeType EQ "">
	<cfset mimeType="application/file">
</cfif>

<cfheader name="Content-Disposition" value="inline; filename=#getBin.team_id#.pdf">

<cfcontent variable="#toBinary(getBin.content)#" type="#mimeType#">
