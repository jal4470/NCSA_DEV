<cfsetting enablecfoutputonly="Yes" showdebugoutput="No">

<!--- get coaches --->
<cfinvoke
	component="#application.sitevars.cfcpath#.contact"
	method="getClubContactRoleX"
	clubid="#session.user.clubid#"
	roleid="29"
	returnvariable="coaches">

<cfif isdefined("url.term") AND url.term NEQ "">
	<cfquery dbtype="query" name="coaches">
		select * from coaches where lower(firstname) + ' ' + lower(lastname) like '%#lcase(url.term)#%'
	</cfquery>
</cfif>	
	
<cfoutput>
	[
	<cfset arrCoaches=arraynew(1)>
	<cfloop query="coaches">
		<cfset arrayappend(arrCoaches,"""#firstname# #lastname#""")>
	</cfloop>
	#arraytolist(arrCoaches,",")#
	]
</cfoutput>