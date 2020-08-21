<!--- 
Created by: B.Cooper
Purpose:  Start page for helper module used to assist in creating forms within the generic form schema
 --->

<cfif isdefined("form.btnCreateForm")>
	<!--- create a form, then modify it --->
	<cfinvoke
		component="#application.sitevars.cfcpath#.userForm"
		method="createForm"
		name="#form.formName#"
		returnvariable="user_form_id">
</cfif>
<cfif isdefined("form.btnCreateSection")>
	<cfset user_form_id=form.user_form_id>
	<cfinvoke
		component="#application.sitevars.cfcpath#.userForm"
		method="createSection"
		user_form_id="#user_form_id#"
		name="#form.sectionName#"
		returnvariable="form_section_id">
</cfif>
<cfif isdefined("form.createQuestion")>
	<cfif not isdefined("form.question_group_id")>
		<!--- create new question group --->
		<cfinvoke
			component="#application.sitevars.cfcpath#.userForm"
			method="createQuestionGroup"
			question_group_type_id="#form.question_group_type_id#"
			returnvariable="question_group_id">
		<cfinvoke
			component="#application.sitevars.cfcpath#.userForm"
			method="addGroupToSection"
			question_group_id="#question_group_id#"
			form_section_id="#form.form_section_id#"
			returnvariable="question_group_form_section_id">
	<cfelse>
		<cfset question_group_id=form.question_group_id>
	</cfif>
	<!--- create question --->
	<cfinvoke
		component="#application.sitevars.cfcpath#.userForm"
		method="createQuestion"
		question_group_id="#question_group_id#"
		name="#form.questionName#"
		returnvariable="question_id">
</cfif>
<cfif isdefined("form.addQuestionGroup")>
	<cfinvoke
		component="#application.sitevars.cfcpath#.userForm"
		method="addGroupToSection"
		question_group_id="#form.question_group_id#"
		form_section_id="#form.form_section_id#"
		returnvariable="question_group_form_section_id">
</cfif>
<cfif isdefined("url.remove_question_group")>
	<cfinvoke
		component="#application.sitevars.cfcpath#.userForm"
		method="removeQuestionGroupFormSection"
		question_group_form_section_id="#url.remove_question_group#">
</cfif>

<cfif isdefined("url.user_form_id")>
	<cfset user_form_id=url.user_Form_id>
<cfelseif isdefined("form.user_Form_id")>
	<cfset user_form_id=form.user_form_id>
</cfif>
<cfif isdefined("url.form_section_id")>
	<cfset form_section_id=url.form_section_id>
<cfelseif isdefined("form.form_section_id")>
	<cfset form_section_id=form.form_section_id>
</cfif>


<!--- get all forms --->
<cfinvoke
	component="#application.sitevars.cfcpath#.userForm"
	method="getForms"
	returnvariable="forms">

<cfif isdefined("user_Form_id")>
	<!--- get sections --->
	<cfinvoke
		component="#application.sitevars.cfcpath#.userForm"
		method="getFormSections"
		user_form_id="#user_form_id#"
		returnvariable="formSections">
		
</cfif>

<cfif isdefined("form_section_id")>
	<cfinvoke
		component="#application.sitevars.cfcpath#.userForm"
		method="getQuestionGroupTypes"
		returnvariable="questionGroupTypes">
		
	<!--- get question groups --->
	<cfinvoke
		component="#application.sitevars.cfcpath#.userForm"
		method="getSectionQuestionGroups"
		form_section_id="#form_section_id#"
		returnvariable="questionGroups">
		
	<!--- get all question groups --->
	<cfinvoke
		component="#application.sitevars.cfcpath#.userForm"
		method="getQuestionGroups"
		returnvariable="allQuestionGroups">
</cfif>

<html>
	<head>
		<script language="JavaScript" type="text/javascript" src="../assets/jQuery-ui-1.8.9/js/jquery-1.4.4.min.js"></script>
		<script language="JavaScript" type="text/javascript" src="../assets/jQuery-ui-1.8.9/js/jquery-ui-1.8.9.custom.min.js"></script>
		<script language="JavaScript" type="text/javascript">
			$(function(){
				$('#questionGroups').sortable({
					axis:'y',
					handle:'.questionActions',
					revert:150,
					update:function(){
						
						//ajax save
						$.ajax({
							type:'POST',
							dataType:'json',
							data:{
								sortlist:$('#questionGroups').sortable('serialize')
							},
							url:'async_save_questionGroup_order.cfm'
						});
					}
				});
				
				$('.questions').sortable({
					axis:'y',
					revert:150,
					update:function(a,b){
					
						//ajax save
						$.ajax({
							type:'POST',
							dataType:'json',
							data:{
								sortlist:b.item.closest('.questions').sortable('serialize')
							},
							url:'async_save_question_order.cfm'
						});
					}
				});
			});
		</script>
	</head>
	<body>
		<cfif not isdefined("user_form_id")>
		<!--- create/edit form --->
			<form method="post">
				Form name:<input type="text" name="formName">
				<input type="Submit" name="btnCreateForm" value="Create Form">
			</form>
			<form method="post">
				Select form:
				<select name="user_form_id">
					<cfloop query="forms">
						<cfoutput><option value="#user_form_id#">#name#</option></cfoutput>
					</cfloop>
				</select>
				<input type="submit" name="btnModifyForm" value="Modify Form">
			</form>
		<cfelseif not isdefined("form_section_id")>
			<a href="buildForm.cfm">Pick Form</a>
		<!--- create/edit section --->
			<form method="post">
				<cfoutput><input type="Hidden" name="user_form_id" value="#user_form_id#"></cfoutput>
				Create a section:<input type="Text" name="sectionName">
				<input type="Submit" name="btnCreateSection" value="Create Section">
			</form>
			<form method="post">
				<cfoutput><input type="Hidden" name="user_form_id" value="#user_form_id#"></cfoutput>
				Select a section to modify:
				<select name="form_section_id">
					<cfloop query="formSections">
						<cfoutput><option value="#form_section_id#">#name#</option></cfoutput>
					</cfloop>
				</select>
				<input type="submit" name="btnModifySection" value="Modify Section">
			</form>
		<cfelse>
			<cfoutput><a href="buildForm.cfm?user_form_id=#user_form_id#">Pick Section</a></cfoutput><br>
			<div style="float:left; width:45%; margin-right:4%;">
				<form method="post">
					<cfoutput><input type="Hidden" name="user_form_id" value="#user_form_id#"></cfoutput>
					<cfoutput><input type="Hidden" name="form_section_id" value="#form_section_id#"></cfoutput>
					Create Question:<input type="Text" name="questionName">
					<select name="question_group_type_id">
						<cfloop query="questionGroupTypes">
							<cfoutput><option value="#question_group_type_id#">#name#</option></cfoutput>
						</cfloop>
					</select>
					<div id="questionGroups">
						<cfoutput query="questionGroups" group="question_group_form_section_id">
							<div class="questionGroup" id="questiongroup_#question_group_form_section_id#">
								<div class="questionActions">
									<div style="float:right;">
										#question_group_type_name#
									</div>
									<input type="checkbox" name="question_group_id" value="#question_group_id#">Add to
									<a href="addChoices.cfm?user_form_id=#user_form_id#&form_section_id=#form_section_id#&question_group_id=#question_group_id#">Add Choices</a>
									<a href="buildForm.cfm?user_Form_id=#user_form_id#&form_section_id=#form_section_id#&remove_question_group=#question_group_form_section_id#">Remove</a>
								</div>
								<div class="questions">
									<cfoutput>
										<div class="question" id="question_#question_id#">
											#question_name#
										</div>
									</cfoutput>
								</div>
							</div>
						</cfoutput>
					</div>
					<input type="submit" name="createQuestion" value="Create Question">
				</form>
			</div>
			<div style="float:left; width:45%;">
				<form method="post">
					<cfoutput><input type="Hidden" name="user_form_id" value="#user_form_id#"></cfoutput>
					<cfoutput><input type="Hidden" name="form_section_id" value="#form_section_id#"></cfoutput>
					Add existing question group:
					<cfoutput query="allQuestionGroups" group="question_group_id">
						<div class="questionGroup">
							<input type="radio" name="question_group_id" value="#question_group_id#">
							<cfoutput>
								<div class="question">
									#question_name#
								</div>
							</cfoutput>
						</div>
					</cfoutput>
					<input type="submit" name="addQuestionGroup" value="Add Question Group">
				</form>
			</div>
			<style type="text/css">
				.questionGroup{
					border:1px solid black;
					margin-bottom:5px;
				}
				.questionGroup .questionActions{
					background-color:#dedede;
			</style>
		</cfif>
	</body>
</html>