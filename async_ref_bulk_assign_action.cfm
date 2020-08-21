<cfsetting enablecfoutputonly="Yes" showdebugoutput="No">

<cfinclude template="_checkLogin.cfm">


<cfset game_id=form.game_id>
<cfset contact_id=form.contact_id>
<cfset officialTypeID=form.officialTypeID>


<cfstoredproc procedure="p_LOG_RefereeReportDetail" datasource="#SESSION.DSN#">
	<cfprocparam dbvarname="@game_id" cfsqltype="CF_SQL_NUMERIC" value="#game_id#">
	<cfprocparam dbvarname="@username" cfsqltype="CF_SQL_VARCHAR" value="#SESSION.USER.CONTACTID#">
	<cfprocparam dbvarname="@pagename" cfsqltype="CF_SQL_VARCHAR" value="#CGI.Script_Name#">
</cfstoredproc>

<cfquery name="deleteRefDetail" datasource="#SESSION.DSN#">
	Delete from TBL_REFEREE_RPT_DETAIL Where Game_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#game_id#">
</cfquery>

<cfstoredproc procedure="p_LOG_RefereeReportHeader" datasource="#SESSION.DSN#">
	<cfprocparam dbvarname="@game_id" cfsqltype="CF_SQL_NUMERIC" value="#game_id#">
	<cfprocparam dbvarname="@username" cfsqltype="CF_SQL_VARCHAR" value="#SESSION.USER.CONTACTID#">
	<cfprocparam dbvarname="@pagename" cfsqltype="CF_SQL_VARCHAR" value="#CGI.Script_Name#">
</cfstoredproc>

<cfquery name="deleteRefHeader" datasource="#SESSION.DSN#">
	Delete from TBL_REFEREE_RPT_HEADER Where Game_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#game_id#">
</cfquery>

<cfif isdefined("form.remove")>
	<cfstoredproc procedure="p_delete_xref_game_official" datasource="#SESSION.DSN#">
		<cfprocparam dbvarname="@officialTypeID" cfsqltype="CF_SQL_NUMERIC" value="#officialTypeID#">
		<cfprocparam dbvarname="@OldContactID" 	 cfsqltype="CF_SQL_NUMERIC" value="#contact_id#">
		<cfprocparam dbvarname="@gameID"		 cfsqltype="CF_SQL_NUMERIC" value="#game_id#">
	</cfstoredproc>
<cfelse>
	<cfstoredproc procedure="p_insert_xref_game_official" datasource="#SESSION.DSN#">
		<cfprocparam dbvarname="@officialTypeID" cfsqltype="CF_SQL_NUMERIC" value="#officialTypeID#">
		<cfprocparam dbvarname="@ContactID" 	 cfsqltype="CF_SQL_NUMERIC" value="#contact_id#">
		<cfprocparam dbvarname="@gameID"		 cfsqltype="CF_SQL_NUMERIC" value="#game_id#">
	</cfstoredproc>
</cfif>


<cfoutput>
{
"success":true
}
</cfoutput>