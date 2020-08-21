<cfset question_group_id=url.question_group_id>

<cfif isdefined("form.btnAddChoice")>
	<cfinvoke
		component="#application.sitevars.cfcpath#.userForm"
		method="createChoice"
		question_group_id="#question_group_id#"
		name="#form.choiceName#"
		choice_type_id="#form.choice_type_id#"
		returnvariable="choice_id">
</cfif>


<cfoutput><a href="buildForm.cfm?user_form_id=#url.user_form_id#&form_section_id=#url.form_section_id#">Return to section</a></cfoutput>

<!--- get choices --->
<cfinvoke
	component="#application.sitevars.cfcpath#.userForm"
	method="getQuestionGroupChoices"
	question_group_id="#question_group_id#"
	returnvariable="choices">
<cfinvoke
	component="#application.sitevars.cfcpath#.userForm"
	method="getChoiceTypes"
	returnvariable="choiceTypes">
	
	
	

<script language="JavaScript" type="text/javascript" src="../assets/jQuery-ui-1.8.9/js/jquery-1.4.4.min.js"></script>
<script language="JavaScript" type="text/javascript" src="../assets/jQuery-ui-1.8.9/js/jquery-ui-1.8.9.custom.min.js"></script>
<script language="JavaScript" type="text/javascript">
	$(function(){
	
		$('ol').sortable({
			axis:'y',
			revert:150,
			update:function(){
			
				//ajax save
				$.ajax({
					type:'POST',
					dataType:'json',
					data:{
						sortlist:$('ol').sortable('serialize')
					},
					url:'async_save_choice_order.cfm'
				});
			}
		});
	
	});
</script>
<form method="post">
	Add Choice:<input type="Text" name="choiceName">
	<select name="choice_type_id">
		<cfoutput>
			<cfloop query="choiceTypes">
				<option value="#choice_type_id#">#name#</option>
			</cfloop>
		</cfoutput>
	</select>
	<input type="submit" name="btnAddChoice" value="Add Choice">
</form>

<ol style="width:300px;">
<cfloop query="choices">
<cfoutput>
	<li id="choice_#choice_id#">
		<div style="float:right;">
			#choice_type_name#
		</div>
		#name#
	</li>
</cfoutput>
</cfloop>
</ol>