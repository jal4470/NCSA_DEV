<cfinclude template="../_checkLogin.cfm">

<cfif isdefined("form.btnSave")>
	<!--- save form data to response tables --->
	
	<!--- create a response --->
	<cfinvoke
		component="#application.sitevars.cfcpath#.userForm"
		method="createResponse"
		contact_Id="#session.user.contactid#"
		user_form_id="#form.user_form_id#"
		returnvariable="response_id">
		
		
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
					<cfinvoke
						component="#application.sitevars.cfcpath#.userForm"
						method="createResponseChoice"
						response_id="#response_id#"
						question_group_form_section_id="#question_group_form_section_id#"
						question_id="#question_id#"
						choice_id="#choice_id#"
						value="#choice_value#"
						returnvariable="response_choice_id">
				</cfif>
					
			<cfelseif listlen(i,"_") EQ 3>
				<cfset question_group_form_section_id=listgetat(i,2,"_")>
				<cfset question_id=listgetat(i,3,"_")>
				<cfset choice_id=form["#i#"]>
				<cfif choice_id NEQ ""><!--- if choice id is blank, this is a radiobox_text type.  the value comes from the text input --->
					<cfoutput>Adding qgfs:#question_group_form_section_id# q:#question_id# c:#choice_id#<br></cfoutput>
					<cfinvoke
						component="#application.sitevars.cfcpath#.userForm"
						method="createResponseChoice"
						response_id="#response_id#"
						question_group_form_section_id="#question_group_form_section_id#"
						question_id="#question_id#"
						choice_id="#choice_id#"
						returnvariable="response_choice_id">
				</cfif>
				
			<cfelse>
				<!--- shouldn't get here! --->
			</cfif>
		</cfif>
	</cfloop>
</cfif>
<cfif isdefined("form.btnSave")>
	<cfset form.return_page=form.return_page & "&formSave=1">
</cfif>
<cflocation url="#form.return_page#" addtoken="No">