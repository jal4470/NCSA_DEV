<cfsetting enablecfoutputonly="Yes" showdebugoutput="No">

<cfset posNum=1>
<cfloop list="#form.sortlist#" delimiters="&" index="i">
	<cfset itemID=listgetat(i,2,"=")>
	
	<cfquery datasource="#application.dsn#" name="updateSort">
		update tbl_choice
		set seq=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#posNum#">
		where choice_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#itemID#">
	</cfquery>
	
	<cfset posNum=posNum + 1>
</cfloop>