<cfinclude template="../_checkLogin.cfm">

<cfif isdefined("form.btnSave")>
	<!--- save form data to response tables --->
	
	<!--- get a response id --->
	<cfif isDefined("url.response_id") and url.response_id NEQ "">
		<cfset response_id = url.response_id>
	<cfelseif isDefined("form.response_id") and form.response_id NEQ "">
		<cfset response_id = form.response_id>
	<cfelse>
		<cfset response_id = "">
	</cfif>
		
	<!--- loop over form submission and processs --->
	<cfloop collection="#form#" item="i">
		<cfif listgetat(i,1,"_") EQ "CHOICE">
			<cfif listlen(i,"_") EQ 4>
				<!--- question with choice and value --->
				<cfset question_group_form_section_id=listgetat(i,2,"_")>
				<cfset question_id=listgetat(i,3,"_")>
				<cfset choice_id=listgetat(i,4,"_")>
				<cfset choice_value=form["#i#"]>
				<cfif choice_value NEQ ""><!--- if choice value is blank, this is a checkbox_text type or blank response. if former, the value comes from the text input --->
					<cfoutput>Adding qgfs:#question_group_form_section_id# q:#question_id# c:#choice_id# v:#choice_value#<br></cfoutput>
					<cftry>
					<cfinvoke
						component="#application.sitevars.cfcpath#.userForm"
						method="updateResponseChoice"
						response_id="#response_id#"
						question_group_form_section_id="#question_group_form_section_id#"
						question_id="#question_id#"
						choice_id="#choice_id#"
						value="#choice_value#"
						type=1>
					<cfcatch><cfoutput>#i#</cfoutput> >> error 1: <cfoutput>#cfcatch#</cfoutput><br></cfcatch>
					</cftry>
				<cfelse>
				
					<!--- delete old response --->
					<cfinvoke
						component="#application.sitevars.cfcpath#.userForm"
						method="removeResponseChoice"
						response_id="#response_id#"
						question_group_form_section_id="#question_group_form_section_id#"
						question_id="#question_id#"
						choice_id="#choice_id#"
						type=1>
				</cfif>
					
			<cfelseif listlen(i,"_") EQ 3>
				<cfset question_group_form_section_id=listgetat(i,2,"_")>
				<cfset question_id=listgetat(i,3,"_")>
				<cfset choice_id=form["#i#"]>
				<cfif choice_id NEQ ""><!--- if choice id is blank, this is a radiobox_text type.  the value comes from the text input --->
					<cfoutput>Adding qgfs:#question_group_form_section_id# q:#question_id# c:#choice_id#<br></cfoutput>
					<cftry>
					<cfinvoke
						component="#application.sitevars.cfcpath#.userForm"
						method="updateResponseChoice"
						response_id="#response_id#"
						question_group_form_section_id="#question_group_form_section_id#"
						question_id="#question_id#"
						choice_id="#choice_id#"
						type=2>
					<cfcatch><cfoutput>#i#</cfoutput> >> error 2: <cfoutput>#cfcatch#</cfoutput><br></cfcatch>
					</cftry>
				</cfif>
				
			<cfelse>
				<!--- shouldn't get here! --->
			</cfif>
		</cfif>
	</cfloop>
</cfif>
<cfif isdefined("form.btnSave")>
	<cflocation url="#form.return_page#&formSave=1" addtoken="No">
</cfif>
<cfif isDefined("form.btnCancel")>
	<cflocation url="#form.return_page#&formSave=2" addtoken="No">
</cfif>
<!---<cflocation url="#form.return_page#" addtoken="No">--->