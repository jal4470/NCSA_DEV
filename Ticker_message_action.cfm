<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfif isdefined("form.mode")>
	<cfif form.mode eq "add">
	<cfstoredproc datasource="#application.dsn#" procedure="p_insert_ticker_message">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" value="#form.description#" type="In">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" value="#form.msgDate#" type="In">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" value="#form.msgTime#" type="In">
	</cfstoredproc>
	<cfelseif form.mode eq "update">
	<cfstoredproc datasource="#application.dsn#" procedure="p_update_ticker_message">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" value="#form.description#" type="In">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" value="#form.msgDate#" type="In">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" value="#form.msgTime#" type="In">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#form.tickerMsg_id#" type="In">
	</cfstoredproc>
	
	</cfif>

</cfif>
<cfif isdefined("url.tmid") and isdefined("url.del") and url.del>
	<cfstoredproc  datasource="#application.dsn#" procedure="p_delete_ticker_message">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#url.tmid#" type="In">
	</cfstoredproc>
</cfif>

<cfif isdefined('session.ticker_message')>
	<cfset tmp = structDelete(session,'ticker_message')>
</cfif>

<cflocation url="tickerList.cfm">