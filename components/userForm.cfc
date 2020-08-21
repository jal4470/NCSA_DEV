<cfcomponent>

	<cffunction
		name="getForms"
		access="public"
		returntype="query">
		
		<cfquery datasource="#application.dsn#" name="getForms">
			select user_form_id, name
			from tbl_user_form
			order by name
		</cfquery>
		
		<cfreturn getForms>
	
	</cffunction>

	<cffunction
		name="getResponse"
		access="public"
		returntype="query">
		<cfargument name="response_id" type="string" required="Yes">
		
		<cfquery datasource="#application.dsn#" name="getForms">
			select c.name as choice_name, c.choice_type_id, r.response_id, r.contact_id, r.user_form_id, r.datecreated, rc.question_group_form_section_id, rc.question_id, rc.choice_id, rc.value
			from tbl_response r
			left join tbl_response_choice rc
			on r.response_id=rc.response_id
			left join tbl_choice c
			on rc.choice_id=c.choice_id
			where r.response_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.response_id#">
			order by rc.response_id, rc.question_group_form_section_id, rc.question_id, rc.choice_id, rc.value
		</cfquery>
		
		<cfreturn getForms>
	
	</cffunction>
	
	<cffunction
		name="createForm"
		access="public"
		returntype="numeric">
		<cfargument name="name" type="string" required="Yes">
		
		<cfstoredproc datasource="#application.dsn#" procedure="p_create_user_form">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@name" type="In" value="#arguments.name#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@user_form_id" type="Out" variable="user_form_id">
		</cfstoredproc>
		
		<cfreturn user_form_id>
		
	</cffunction>
	
	<cffunction
		name="createSection"
		access="public"
		returntype="numeric">
		<cfargument name="user_form_id" type="string" required="Yes">
		<cfargument name="name" type="string" required="Yes">
		
		<cfstoredproc datasource="#application.dsn#" procedure="p_create_form_section">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@user_form_id" type="In" value="#arguments.user_form_id#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@name" type="In" value="#arguments.name#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@form_section_id" type="Out" variable="form_section_id">
		</cfstoredproc>
		
		<cfreturn form_section_id>
		
	</cffunction>
	
	<cffunction
		name="createQuestionGroup"
		access="public"
		returntype="numeric">
		<cfargument name="question_group_type_id" type="string" required="Yes">
		
		<cfstoredproc datasource="#application.dsn#" procedure="p_create_question_group">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@question_group_type_id" type="In" value="#arguments.question_group_type_id#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@question_group_id" type="Out" variable="question_group_id">
		</cfstoredproc>
		
		<cfreturn question_group_id>
		
	</cffunction>
	
	<cffunction
		name="createQuestion"
		access="public"
		returntype="numeric">
		<cfargument name="question_group_id" type="string" required="Yes">
		<cfargument name="name" type="string" required="Yes">
		
		<cfstoredproc datasource="#application.dsn#" procedure="p_create_question">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@question_group_id" type="In" value="#arguments.question_group_id#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@name" type="In" value="#trim(arguments.name)#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@question_id" type="Out" variable="question_id">
		</cfstoredproc>
		
		<cfreturn question_id>
		
	</cffunction>
	
	<cffunction
		name="createChoice"
		access="public"
		returntype="numeric">
		<cfargument name="question_group_id" type="string" required="Yes">
		<cfargument name="name" type="string" required="Yes">
		<cfargument name="choice_type_id" type="string" required="Yes">
		
		<cfstoredproc datasource="#application.dsn#" procedure="p_create_choice">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@question_group_id" type="In" value="#arguments.question_group_id#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@name" type="In" value="#trim(arguments.name)#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@choice_type_id" type="In" value="#arguments.choice_type_id#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@choice_id" type="Out" variable="choice_id">
		</cfstoredproc>
		
		<cfreturn choice_id>
		
	</cffunction>
	
	<cffunction
		name="addGroupToSection"
		access="public"
		returntype="numeric">
		<cfargument name="question_group_id" type="string" required="Yes">
		<cfargument name="form_section_id" type="string" required="Yes">
		
		<cfstoredproc datasource="#application.dsn#" procedure="p_add_group_to_section">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@question_group_id" type="In" value="#arguments.question_group_id#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@form_section_id" type="In" value="#arguments.form_section_id#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@question_group_form_section_id" type="Out" variable="question_group_form_section_id">
		</cfstoredproc>
		
		<cfreturn question_group_form_section_id>
		
	</cffunction>
	
	<cffunction
		name="removeQuestionGroupFormSection"
		access="public"
		returntype="any">
		<cfargument name="question_group_form_section_id" type="string" required="Yes">
		
		<cfquery datasource="#application.dsn#" name="getQuestionGroups">
			delete from xref_question_group_form_section
			where question_group_form_section_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.question_group_form_section_id#">
		</cfquery>
	
	</cffunction>
	
	<cffunction
		name="getFormSections"
		access="public"
		returntype="query">
		<cfargument name="user_form_id" type="string" required="Yes">
		
		<cfquery datasource="#application.dsn#" name="getSections">
			select form_section_id, name, seq
			from tbl_form_section
			where user_form_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.user_form_id#">
		</cfquery>
		
		<cfreturn getSections>
		
	</cffunction>
	
	<cffunction
		name="getQuestionGroupTypes"
		access="public"
		returntype="query">
		
		<cfquery datasource="#application.dsn#" name="getTypes">
			select question_group_type_id, name
			from tlkp_question_group_type
		</cfquery>
		
		<cfreturn getTypes>
	
	</cffunction>
	
	<cffunction
		name="getChoiceTypes"
		access="public"
		returntype="query">
		
		<cfquery datasource="#application.dsn#" name="getTypes">
			select choice_type_id, name
			from tlkp_choice_type
		</cfquery>
		
		<cfreturn getTypes>
	
	</cffunction>
	
	<cffunction
		name="getSectionQuestionGroups"
		access="public"
		returntype="query">
		<cfargument name="form_section_id" type="string" required="Yes">
		
		<cfquery datasource="#application.dsn#" name="getQuestionGroups">
			select qgfs.question_group_form_section_id, qgfs.seq as seq, qg.question_group_id, qgt.question_group_type_id, qgt.name as question_group_type_name, q.name as question_name, q.seq as question_seq, q.question_id
			from tbl_question_group qg
			inner join tlkp_question_group_type qgt
			on qg.question_group_type_id=qgt.question_group_type_id
			inner join xref_question_group_form_section qgfs
			on qg.question_group_id=qgfs.question_group_id
			inner join tbl_question q
			on qg.question_group_id=q.question_group_id
			where qgfs.form_section_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.form_section_id#">
			order by qgfs.seq, q.seq
		</cfquery>
		
		<cfreturn getQuestionGroups>
	
	</cffunction>
	
	<cffunction
		name="getQuestionGroupFormSection"
		access="public"
		returntype="query">
		<cfargument name="question_group_form_section_id" type="string" required="Yes">
		
		<cfquery datasource="#application.dsn#" name="getQuestionGroups">
			select qgfs.question_group_form_section_id, qg.question_group_id, qgt.question_group_type_id, qgt.name as question_group_type_name, q.name as question_name, q.question_id
			from tbl_question_group qg
			inner join tlkp_question_group_type qgt
			on qg.question_group_type_id=qgt.question_group_type_id
			inner join xref_question_group_form_section qgfs
			on qg.question_group_id=qgfs.question_group_id
			inner join tbl_question q
			on qg.question_group_id=q.question_group_id
			where qgfs.question_group_form_section_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.question_group_form_section_id#">
			order by qgfs.seq, q.seq
		</cfquery>
		
		<cfreturn getQuestionGroups>
	
	</cffunction>
	
	<cffunction
		name="getQuestionGroups"
		access="public"
		returntype="query">
		
		<cfquery datasource="#application.dsn#" name="getQuestionGroups">
			select distinct qg.question_group_id, q.seq, qgt.question_group_type_id, qgt.name as question_group_type_name, q.name as question_name, q.question_id
			from tbl_question_group qg
			inner join tlkp_question_group_type qgt
			on qg.question_group_type_id=qgt.question_group_type_id
			inner join tbl_question q
			on qg.question_group_id=q.question_group_id
			order by qg.question_group_id, q.seq
		</cfquery>
		
		<cfreturn getQuestionGroups>
	
	</cffunction>
	
	<cffunction
		name="getQuestionGroupChoices"
		access="public"
		returntype="query">
		<cfargument name="question_group_id" type="string" required="Yes">
		
		<cfquery datasource="#application.dsn#" name="getQuestionGroups">
			select c.choice_id, c.name, c.choice_type_id, c.seq, ct.name as choice_type_name
			from tbl_choice c
			inner join tlkp_choice_type ct
			on c.choice_type_id=ct.choice_type_id
			where c.question_group_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.question_group_id#">
			order by c.seq
		</cfquery>
		
		<cfreturn getQuestionGroups>
	
	</cffunction>
	
	<cffunction
		name="createResponse"
		access="public"
		returntype="numeric">
		<cfargument name="contact_id" type="string" required="Yes">
		<cfargument name="user_form_id" type="string" required="yes">
		
		<cfstoredproc datasource="#application.dsn#" procedure="p_create_response">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@contact_id" type="In" value="#arguments.contact_id#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@user_form_id" type="In" value="#arguments.user_form_id#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@response_id" type="out" variable="response_id">
		</cfstoredproc>
		
		<cfreturn response_id>
		
	</cffunction>
	
	<cffunction
		name="removeResponse"
		access="public"
		returntype="numeric">
		<cfargument name="response_id" type="numeric" required="Yes">
		
		<cfstoredproc datasource="#application.dsn#" procedure="p_remove_response">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@response_id" type="in" value="#arguments.response_id#">
		</cfstoredproc>
		
		<cfreturn 1>
		
	</cffunction>
	
	<cffunction
		name="createResponseChoice"
		access="public"
		returntype="numeric">
		<cfargument name="response_id" type="string" required="Yes">
		<cfargument name="question_group_form_section_id" type="string" required="yes">
		<cfargument name="question_id" type="string" required="yes">
		<cfargument name="choice_id" type="string" required="yes">
		<cfargument name="value" type="string" required="no">
		
		<cfif not isdefined("arguments.value")>
			<cfset usevalue="">
			<cfset nullvalue="yes">
		<cfelse>
			<cfset usevalue=arguments.value>
			<cfset nullvalue="no">
		</cfif>
		
		<cfstoredproc datasource="#application.dsn#" procedure="p_create_response_choice">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@response_id" type="In" value="#arguments.response_id#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@question_group_form_section_id" type="In" value="#arguments.question_group_form_section_id#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@question_id" type="In" value="#arguments.question_id#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@choice_id" type="In" value="#arguments.choice_id#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@value" type="In" value="#usevalue#" null="#nullvalue#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@response_choice_id" type="out" variable="response_choice_id">
		</cfstoredproc>
		
		<cfreturn response_choice_id>
		
	</cffunction>
	
	<cffunction
		name="updateResponseChoice"
		access="public"
		returntype="numeric">
		<cfargument name="response_id" type="string" required="Yes">
		<cfargument name="question_group_form_section_id" type="string" required="yes">
		<cfargument name="question_id" type="string" required="yes">
		<cfargument name="choice_id" type="string" required="yes">
		<cfargument name="value" type="string" required="no">
		<cfargument name="type" type="numeric" required="no">
		
		<cfif not isdefined("arguments.value")>
			<cfset usevalue="">
			<cfset nullvalue="yes">
		<cfelse>
			<cfset usevalue=arguments.value>
			<cfset nullvalue="no">
		</cfif>
		
		<!--- 
			Type 1 = Choice & Text
			Type 2 = Choice 
		--->
		
		<cftry>
		
			<cfstoredproc datasource="#application.dsn#" procedure="p_update_response_choice">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@response_id" type="In" value="#arguments.response_id#">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@question_group_form_section_id" type="In" value="#arguments.question_group_form_section_id#">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@question_id" type="In" value="#arguments.question_id#">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@choice_id" type="In" value="#arguments.choice_id#">
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@value" type="In" value="#usevalue#" null="#nullvalue#">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@in_type" type="In" value="#arguments.type#">				
			</cfstoredproc>
			
			<cfcatch>
		
				<cfstoredproc datasource="#application.dsn#" procedure="p_create_response_choice">
					<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@response_id" type="In" value="#arguments.response_id#">
					<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@question_group_form_section_id" type="In" value="#arguments.question_group_form_section_id#">
					<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@question_id" type="In" value="#arguments.question_id#">
					<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@choice_id" type="In" value="#arguments.choice_id#">
					<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@value" type="In" value="#usevalue#" null="#nullvalue#">
					<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@response_choice_id" type="out" variable="response_choice_id">
				</cfstoredproc>
			
			</cfcatch>
		</cftry>
		
		<cfreturn 1>
		
	</cffunction>
	
	<cffunction
		name="removeResponseChoice"
		access="public"
		returntype="numeric">
		<cfargument name="response_id" type="string" required="Yes">
		<cfargument name="question_group_form_section_id" type="string" required="yes">
		<cfargument name="question_id" type="string" required="yes">
		<cfargument name="choice_id" type="string" required="yes">
		<cfargument name="type" type="numeric" required="no">
		
		<cfif not isdefined("arguments.value")>
			<cfset usevalue="">
			<cfset nullvalue="yes">
		<cfelse>
			<cfset usevalue=arguments.value>
			<cfset nullvalue="no">
		</cfif>
		
		<!--- 
			Type 1 = Choice & Text
			Type 2 = Choice 
		--->
		
		<cfstoredproc datasource="#application.dsn#" procedure="p_remove_response_choice">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@response_id" type="In" value="#arguments.response_id#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@question_group_form_section_id" type="In" value="#arguments.question_group_form_section_id#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@question_id" type="In" value="#arguments.question_id#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@choice_id" type="In" value="#arguments.choice_id#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@in_type" type="In" value="#arguments.type#">				
		</cfstoredproc>
					
		<cfreturn 1>
		
	</cffunction>

</cfcomponent>