<cfinclude template="_checkLogin.cfm">

<cfif isdefined("url.game_log_id")>
	<cfset game_log_id = url.game_log_id>
<cfelseif isdefined("variables.game_log_id")>
	<cfset game_log_id = variables.game_log_id>
</cfif>

<cfquery name="getBin" datasource="#session.DSN#">
	Select game_day_document,  game_log_id,game_id
	from TBL_GAME_LOG
	where game_log_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#game_log_id#">
</cfquery>

<!--- guess content type --->
<cfif getBin.recordcount>
	<cfset mimeType="application/pdf">


	<cfheader name="Content-Disposition" value="inline; filename=game_#getBin.Game_log_id#_#getBin.game_id#_game_day_doc.pdf">

	<cfcontent variable="#toBinary(getBin.game_day_document)#" type="#mimeType#">
<cfelse>
	<cfinclude template="_header.cfm">
				<div>The game day document for this game was not Generated prior to the game change.</div>
	<cfinclude template="_footer.cfm">
</cfif>
