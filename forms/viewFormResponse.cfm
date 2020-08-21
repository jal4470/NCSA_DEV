<!--- module to render a form response --->

<cfparam name="attributes.response_id" type="numeric">
<cfparam name="attributes.label_vars" type="struct" default="#structnew()#">

<cfset label_vars=attributes.label_vars>

<!--- get response --->
<cfinvoke
	component="#application.sitevars.cfcpath#.userForm"
	method="getResponse"
	response_id="#attributes.response_id#"
	returnvariable="responseInfo">
<cfset user_form_id=responseInfo.user_form_id>

<cfset stResponse=structnew()>
<cfloop query="responseInfo">
	<cfset key="#question_group_form_section_id#-#question_id#-#choice_id#">
	<cfif structkeyexists(stResponse,"#key#")>
		<cfset arrayappend(stResponse["#key#"],value)>
	<cfelse>
		<cfset keyvalue=arraynew(1)>
		<cfset arrayappend(keyvalue,value)>
		<cfset stResponse["#key#"]=keyvalue>
	</cfif>
</cfloop>


<cfoutput>
	<!--- get sections in form --->
	<cfinvoke
		component="#application.sitevars.cfcpath#.userForm"
		method="getFormSections"
		user_form_id="#user_form_id#"
		returnvariable="formSections">
	
	<style type="text/css">
		.userForm{
			padding:10px;
			font-size:1.3em;
		}
		.userForm .formSection{
			padding-bottom:30px;
			border-bottom:3px dashed ##3399CC;
			margin-bottom:40px;
		}
		.userForm .formSection.noName{
			border-bottom:none;
		}
		.userForm .formSection h2{
			margin-bottom:5px;
			font-size:1.2em;
		}
		.formSection table{
			border:1px solid ##bbb;
			border-width:0 0px 0px 0px;
			margin-bottom:10px;
		}
		.formSection table th,.formSection table td{
			text-align:center;
			padding:2px 5px;
			vertical-align:top;
		}
		.formSection table th{
			border-bottom:2px solid ##ccc;
		}
		.formSection table td{
			border-bottom:1px solid ##ddd;
		}
		.formSection table td.name{
			text-align:left;
		}
		.userForm .question{
			margin-top:10px;
			padding-bottom:10px;
			border-bottom:1px solid ##bbb;
		}
		.userForm .question .questionName{
			width:50%;
			display:inline-block;
			vertical-align:top;
			float:left;
		}
		.userForm .question .choices{
			width:48%;
			display:inline-block;
			vertical-align:top;
			float:left;
			font-style: italic;
    		font-weight: bold;
		}
		.userForm .question .choices textarea{
			width:100%;
			height:115px;
		}
		/*.userForm .question .choices .choice{
			float:left;
			width:150px;
			vertical-align:top;
		}*/
		.userForm .instruction{
			font-style:italic;
		}
		.userForm .choice.label{
			font-weight:bold;
			font-style:italic;
		}
		.userForm .clear{
			clear:both;
		}
	</style>
	
	
	<div class="userForm">
			<!--- loop over sections --->
			<cfloop query="formSections">
			
				<div id="formSection#form_section_id#" class="formSection <cfif name EQ "">noName</cfif>">
				
					<h2>#name#</h2>
					
					<!--- get question groups --->
					<cfinvoke
						component="#application.sitevars.cfcpath#.userForm"
						method="getSectionQuestionGroups"
						form_section_id="#form_section_id#"
						returnvariable="questionGroups">
					<cfquery dbtype="query" name="questionGroups">
						select distinct question_group_form_section_id
						from questionGroups
						order by seq
					</cfquery>
						
					<!--- loop over question groups and display --->
					<cfloop query="questionGroups">
						<cf_renderQuestionGroupResponse question_group_form_section_id="#question_group_form_section_id#" stResponse=#stResponse#>
					</cfloop>
				</div>
			</cfloop>
			
		</form>
	</div>
</cfoutput>