<cfinclude template="_checkLogin.cfm">

<cfif isDefined("url.btnDelete") AND url.btnDelete EQ "true" AND isDefined("url.team_id")>
	
	<!--- get a response id --->
	<cfif isDefined("url.response_id") and url.response_id NEQ "">
		<cfset response_id = url.response_id>
	<cfelseif isDefined("form.response_id") and form.response_id NEQ "">
		<cfset response_id = form.response_id>
	<cfelse>
		<cfset response_id = "">
	</cfif>
		
	<!--- loop over form submission and processs --->
	
	<cfif response_id NEQ "">
		<cfinvoke
			component="#application.sitevars.cfcpath#.userForm"
			method="removeResponse"
			response_id="#response_id#"
			type=1>
	</cfif>

	<cflocation url="refEvaluation.cfm?team_id=#url.team_id#&formSave=2" addtoken="No">
</cfif>
<!---<cflocation url="#form.return_page#" addtoken="No">--->