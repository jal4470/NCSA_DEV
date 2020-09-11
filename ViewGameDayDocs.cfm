<cfinclude template="_checkLogin.cfm">

<cfif isdefined("url.game_id")>
	<cfset game_id = url.game_id>
<cfelseif isdefined("variables.game_id")>
	<cfset game_id = variables.game_id>
</cfif>

<cfquery name="getBin" datasource="#session.DSN#">
	Select content,  game_id
	from TBL_GAME_DAY_DOCUMENTS
	where game_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#game_id#">
</cfquery>

<!--- guess content type --->
<cfif getBin.recordcount>
	<cfset mimeType="application/pdf">


	<cfheader name="Content-Disposition" value="inline; filename=game_#getBin.Game_id#_game_day_doc.pdf">

	<cfcontent variable="#toBinary(getBin.content)#" type="#mimeType#">
<cfelse>
	<cfinclude template="_header.cfm">
				<div>We're sorry but the Game Day Documents file has not yet been created by the Referee.  The Referee cannot do so until less than 24 hours before game time.  Please check back later</div>
	<cfinclude template="_footer.cfm">
</cfif>
