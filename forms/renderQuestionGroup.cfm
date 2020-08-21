
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
		<cfcase value="1"><!--- linear display --->
			<cfloop query="qgfs">
				<cfset question_id=qgfs.question_id>
				<div class="question">
					<span class="questionName">#question_name#</span>
					<span class="choices">
						<cfif choices.choice_type_id EQ "4" OR choices.choice_type_id EQ "5">
							<select name="choice_#attributes.question_group_form_section_id#_#question_id#" <cfif choices.choice_type_id EQ "5">multiple size="5"</cfif>>
							<option value="">-- Select --</option>
						</cfif>
						<cfloop query="choices">
							<cfswitch expression="#choice_type_id#">
								<cfcase value="1">
									<!--- text --->
									<input type="text" name="choice_#attributes.question_group_form_section_id#_#question_id#_#choice_id#">
								</cfcase>
								<cfcase value="2">
									<span class="choice">#name#: <input type="Checkbox" name="choice_#attributes.question_group_form_section_id#_#question_id#_#choice_id#" value="#name#"></span>
								</cfcase>
								<cfcase value="3">
									<span class="choice">#name#: <input type="Radio" name="choice_#attributes.question_group_form_section_id#_#question_id#" value="#choice_id#"></span>
								</cfcase>
								<cfcase value="4,5" delimiters=",">
									<option value="#choice_id#">#name#</option>
								</cfcase>
								<cfcase value="6">
									<textarea name="choice_#attributes.question_group_form_section_id#_#question_id#_#choice_id#"></textarea>
								</cfcase>
								<cfcase value="7">
									<input type="checkbox" name="choice_#attributes.question_group_form_section_id#_#question_id#_#choice_id#" class="triggerText"><input type="Text" name="choice_#attributes.question_group_form_section_id#_#question_id#_#choice_id#" disabled="disabled">
								</cfcase>
								<cfcase value="8">
									<input type="Radio" name="choice_#attributes.question_group_form_section_id#_#question_id#" class="triggerText"><input type="Text" name="choice_#attributes.question_group_form_section_id#_#question_id#_#choice_id#" disabled="disabled">
								</cfcase>
								<cfcase value="10">
									<cftry>
										<span class="choice label">#caller.label_vars["#name#"]#</span>
										<cfcatch></cfcatch>
									</cftry>
								</cfcase>
							</cfswitch>
							
						</cfloop>
						
						<cfif choices.choice_type_id EQ "4" OR choices.choice_type_id EQ "5">
							</select>
						</cfif>
					</span>
					<div class="clear"></div>
				</div>
			</cfloop>
		</cfcase>
		<cfcase value="2"><!--- tabular --->
		
			<table border="0" cellpadding="0" cellspacing="0">
				<thead>
					<tr>
						<th><!--- question ---></th>
						<cfloop query="choices">
							<th>#name#</th>
						</cfloop>
					</tr>
				</thead>
				<tbody>
					<cfloop query="qgfs">
						<cfset question_id=qgfs.question_id>
						<tr>
							<td class="name">#question_name#</td>
							<cfloop query="choices">
								<td>
									<cfswitch expression="#choice_type_id#">
										<cfcase value="1">
											<!--- text --->
											<input type="text" name="choice_#attributes.question_group_form_section_id#_#question_id#_#choice_id#">
										</cfcase>
										<cfcase value="2">
											<input type="Checkbox" name="choice_#attributes.question_group_form_section_id#_#question_id#_#choice_id#" value="#name#">
										</cfcase>
										<cfcase value="3">
											<input type="Radio" name="choice_#attributes.question_group_form_section_id#_#question_id#" value="#choice_id#">
										</cfcase>
										<cfcase value="4,5" delimiters=",">
											<option value="#choice_id#">#name#</option>
										</cfcase>
										<cfcase value="6">
											<textarea name="choice_#attributes.question_group_form_section_id#_#question_id#_#choice_id#"></textarea>
										</cfcase>
										<cfcase value="7">
											<input type="checkbox" name="choice_#attributes.question_group_form_section_id#_#question_id#_#choice_id#" class="triggerText"><input type="Text" name="choice_#attributes.question_group_form_section_id#_#question_id#_#choice_id#" disabled="disabled">
										</cfcase>
										<cfcase value="8">
											<input type="Radio" name="choice_#attributes.question_group_form_section_id#_#question_id#" class="triggerText"><input type="Text" name="choice_#attributes.question_group_form_section_id#_#question_id#_#choice_id#" disabled="disabled">
										</cfcase>
										<cfcase value="10">
											<cftry>
												<span class="choice label">#caller.label_vars["#name#"]#</span>
												<cfcatch></cfcatch>
											</cftry>
										</cfcase>
									</cfswitch>
								</td>
							</cfloop>
						</tr>
					</cfloop>
				</tbody>
			</table>
		</cfcase>
		<cfcase value="3"><!--- instruction --->
			<cfloop query="qgfs">
				<div class="question instruction">
					#question_name#
				</div>
			</cfloop>
		</cfcase>
		<cfcase value="4"><!--- hidden --->
			<cfloop query="qgfs">
				<cfset question_id=qgfs.question_id>
				<cfloop query="choices">
					<cfswitch expression="#choice_type_id#">
						<cfcase value="11">
							<!--- text --->
							<cftry>
								<cfset choiceText=caller.label_vars["#name#"]>
								
								<cfcatch>
									<cfset choiceText="">
								</cfcatch>
							</cftry>
							<input type="Hidden" name="choice_#attributes.question_group_form_section_id#_#question_id#_#choice_id#" value="#choiceText#">
						</cfcase>
					</cfswitch>
					
				</cfloop>
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