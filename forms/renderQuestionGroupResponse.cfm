
<cfparam name="attributes.question_group_form_section_id" type="numeric">

<cfinvoke
	component="#application.sitevars.cfcpath#.userForm"
	method="getQuestionGroupFormSection"
	question_group_form_section_id="#attributes.question_group_form_section_id#"
	returnvariable="qgfs">
<cfinvoke
	component="#application.sitevars.cfcpath#.userForm"
	method="getQuestionGroupChoices"
	question_group_id="#qgfs.question_group_id#"
	returnvariable="choices">
	
	
<!--- render question group --->
<cfoutput>

	<cfswitch expression="#qgfs.question_group_type_id#">
		<cfcase value="1,2"><!--- linear display --->
			<cfloop query="qgfs">
				<cfset question_id=qgfs.question_id>
				<div class="question">
					<span class="questionName">#question_name#</span>
					<span class="choices">
						
						
						<cfloop query="choices">
							<cfset key="#attributes.question_group_form_section_id#-#question_id#-#choice_id#">
							<cfswitch expression="#choice_type_id#">
								<cfcase value="1,2,3,4,5,6,7,8">
									<cfif structkeyexists(attributes.stResponse,key)>
										<cfset arr=attributes.stResponse["#key#"]>
										<cfset lsArr=arraytolist(arr,",")>
										#lsArr#
									</cfif>
								</cfcase>
								<cfcase value="10">
									<cftry>
										<span class="choice label">#caller.label_vars["#name#"]#</span>
										<cfcatch></cfcatch>
									</cftry>
								</cfcase>
							</cfswitch>
							
						</cfloop>
					</span>
					<div class="clear"></div>
				</div>
			</cfloop>
		</cfcase>
		<cfcase value="3"><!--- instruction --->
			<cfloop query="qgfs">
				<div class="question instruction">
					#question_name#
				</div>
			</cfloop>
		</cfcase>
		<cfcase value="5"><!--- free form --->
			<!--- display text --->
			<cfloop query="qgfs">
				<div>
					#question_name#
				</div>
			</cfloop>
		</cfcase>
	</cfswitch>
</cfoutput>


<cffunction name="renderSelect" access="private">
	
</cffunction> 