<!---  Joe Lechuga - 8-13-2009 Changed Message.cfc to use SMTP Server vs list serv created function sendCFMessage and commented sendToGateway--->
<!--- B. Cooper - 9/10/2009
	1.changed name of arguments to sendCFMessage() to drop plurality and accurately reflect meaning. updated in call found in createMessage
	2.changed access to private.
	3.added fromAlias
--->
<!--- P. Waters - 12/14/2009
	1. added grade_id_str and exclude_waitlisted_flag inputs to createMessage function
 --->
	
<cfcomponent>

	<cffunction
		name="createMessage"
		access="public"
		returntype="numeric"
		description="Creates a message and adds recipients if topic_choice_id_str or program_id_str is provided">
		<cfargument type="numeric" name="organization_id" required="No" default="0">
		<cfargument type="string" name="from_email_address" required="Yes">
		<cfargument type="string" name="from_email_alias" required="Yes">
		<cfargument type="string" name="subject" required="Yes">
		<cfargument type="string" name="text_copy" required="Yes">
		<cfargument type="string" name="message_desc" required="No" default="">
		<cfargument type="string" name="replyto_email_address" required="No" default="">
		<cfargument type="string" name="replyto_email_alias" required="No" default="">
		<cfargument type="string" name="cc_emails" required="No" default="">
		<cfargument type="string" name="bcc_emails" required="No" default="">
		<cfargument type="numeric" name="track_opens_flag" required="No" default="0">
		<cfargument type="string" name="topic_choice_id_str" required="No" default="">
		<cfargument type="string" name="program_id_str" required="No" default="">
		<cfargument type="string" name="grade_id_str" required="No" default="">
		<cfargument type="string" name="created_via_message_manager_flag" required="No" default="0">
		<cfargument type="string" name="exclude_waitlisted_flag" required="No" default="0">
		<cfargument type="array" name="to_emails" required="No">
			<!--- expects an array of structs of form [{to1.individual_id,to1.email},{to2.individual_id,to2.email},...] --->
		<cfargument type="boolean" name="send_to_gateway" required="No" default="false">
			<!--- ADDED: J. Oriente, 2009-08-13. Enable option to send as HTML --->
		<cfargument type="string" name="type" required="No" default="HTML">
		
		<cfif arguments.message_desc EQ "">
			<cfset arguments.message_desc=arguments.subject>
		</cfif>
		<!--- create message --->
		<CFSTOREDPROC datasource="#application.dsn#" procedure="p_create_message" returncode="YES" >
			<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#arguments.organization_id#" DBVARNAME="@organization_id" null="#yesnoformat(arguments.organization_id EQ -1)#">
			<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#arguments.message_desc#" DBVARNAME="@message_desc">
			<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#arguments.from_email_address#" DBVARNAME="@from_email_address">
			<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#arguments.from_email_alias#" DBVARNAME="@from_email_alias">
			<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#arguments.replyto_email_address#" DBVARNAME="@replyto_email_address" NULL="#YesNoFormat(arguments.replyto_email_address EQ "")#">
			<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#arguments.replyto_email_alias#" DBVARNAME="@replyto_email_alias" NULL="#YesNoFormat(arguments.replyto_email_alias EQ "")#">
			<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#arguments.subject#" DBVARNAME="@subject">
			<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#arguments.cc_emails#" DBVARNAME="@cc_emails" NULL="#YesNoFormat(arguments.cc_emails EQ "")#">
			<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#arguments.bcc_emails#" DBVARNAME="@bcc_emails" NULL="#YesNoFormat(arguments.bcc_emails EQ "")#">
			<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#arguments.text_copy#" DBVARNAME="@html_copy">
			<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#arguments.text_copy#" DBVARNAME="@text_copy">
			<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_BIT" VALUE="#arguments.track_opens_flag#" DBVARNAME="@track_opens_flag">
			<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#arguments.topic_choice_id_str#" DBVARNAME="@topic_choice_id_str" NULL="#YesNoFormat(arguments.topic_choice_id_str EQ "")#">
			<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#arguments.program_id_str#" DBVARNAME="@program_id_str" NULL="#YesNoFormat(arguments.program_id_str EQ "")#">
			<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#arguments.grade_id_str#" DBVARNAME="@grade_id_str" NULL="#YesNoFormat(arguments.grade_id_str EQ "")#">
			<cfprocparam type="in" cfsqltype="CF_SQL_BIT" value="#arguments.created_via_message_manager_flag#" dbvarname="@created_via_message_manager_flag">
			<cfprocparam type="in" cfsqltype="CF_SQL_BIT" value="#arguments.exclude_waitlisted_flag#" dbvarname="@exclude_waitlisted_flag">
			<CFPROCPARAM TYPE="OUT" CFSQLTYPE="CF_SQL_INTEGER" VARIABLE="message_id" DBVARNAME="@message_id">
		</CFSTOREDPROC>
		<cfset emails = "">
		<cfset cc_emails = arguments.cc_emails>

		<!--- if to_emails specified, add to recipient list --->
		<cfif isdefined("arguments.to_emails")>
			<cfloop from="1" to="#arraylen(arguments.to_emails)#" index="i">
				<!--- add email/individual_id to list --->
				<cfif StructKeyExists(arguments.to_emails[i],"individual_id")> 
					<cfset individual_id = arguments.to_emails[i].individual_id>
				<cfelse>
					<cfset individual_id = 0>
				</cfif>
				<cfinvoke
					method="addMessageRecipient"
					message_id="#message_id#"
					individual_id="#variables.individual_id#"
					email="#arguments.to_emails[i].email#"
					returnvariable="message_recipient_id">	

				<cfif arguments.send_to_gateway>
					<!--- 1/18/2010 J.Lechuga added query and loop to set CC recipients based on ALT Emails for a given individual --->
					
					<cfif individual_id>
						<cfquery name="getAltRecipients" datasource="#application.dsn#">
							select distinct email from tbl_individual_alt_email
							where individual_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#individual_id#">
						</cfquery>
						<cfif getAltRecipients.recordcount>
							<cfloop query="getAltRecipients">
								<cfif not len(trim(cc_emails))>
									<cfset cc_emails = email>
								<cfelse>
									<cfset cc_emails = cc_emails & ',' &  email>
								</cfif>
							</cfloop>
						</cfif>
					</cfif>
					<cfinvoke
						method="sendCFMessage"
						recipient="#arguments.to_emails[i].email#"
						fromAddress="#arguments.from_email_address#"
						fromAlias="#arguments.from_email_alias#"
						ccRecipient="#cc_emails#"
						bccRecipient="#arguments.bcc_emails#"
						Subject="#arguments.subject#"
						Body="#arguments.text_copy#"
						Type="#arguments.type#" <!--- ADDED: J. Oriente, 2009-08-13. Enable option to send as HTML --->
						returnvariable="message_sent">
			</cfif>
			
			</cfloop>

		</cfif>
		
	
		
		<cfreturn message_id>
		
	</cffunction>
	
	<cffunction
		name="addMessageRecipient"
		access="public"
		returntype="numeric"
		description="Adds a recipient to a message">
		<cfargument type="numeric" name="message_id" required="Yes">
		<cfargument type="numeric" name="individual_id" required="Yes">
		<cfargument type="string" name="email" required="Yes">
		
		<CFSTOREDPROC datasource="#application.dsn#" procedure="p_create_message_recipient" returncode="YES">
			<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#arguments.message_id#" DBVARNAME="@message_id">
			<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#arguments.individual_id#"  DBVARNAME="@individual_id">
			<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#arguments.email#" DBVARNAME="@email">
			<CFPROCPARAM TYPE="OUT" CFSQLTYPE="CF_SQL_INTEGER" VARIABLE="message_recipient_id" DBVARNAME="@message_recipient_id">
		</CFSTOREDPROC>
			
		<cfreturn message_recipient_id>
		
	</cffunction>
	
<!--- 	<cffunction
		name="sendToGateway"
		access="public"
		returntype="boolean"
		description="Sends a message_id to the event gateway to queue a message for transmission">
		<cfargument type="numeric" name="message_id" required="Yes">
		
		<!--- update sent date --->
		<CFSTOREDPROC datasource="#application.dsn#" procedure="p_set_message_sent_date" returncode="YES">
			<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#arguments.message_id#" DBVARNAME="@message_id">
		</CFSTOREDPROC>
		
		<!--- send to gateway --->
		<CFSCRIPT>
			emailBlastData = structNew();
			emailBlastData.message_id = "#arguments.message_id#";
			emailBlastData.timeout = 10000;
			status = SendGatewayMessage("NewsEmailer", emailBlastData);
		</CFSCRIPT>
		
		<cfreturn true>
		
	</cffunction> --->
	<cffunction 
		name="sendCFMessage" 
		access="private" 
		returntype="boolean" 
		description="Sends message using CFMAIL and Server Iron SMTP Server">
		<cfargument name="recipient" required="Yes" type="string">
		<cfargument name="fromAddress" required="Yes" type="string">
		<cfargument name="fromAlias" required="No" type="string" default="">
		<cfargument name="ccRecipient" required="No" type="string" default="">
		<cfargument name="bccRecipient" required="No" type="string" default="">
		<cfargument name="Subject" required="Yes" type="string">
		<cfargument name="Body" required="Yes" type="string">
		
		<cfset returnVal = 0>
		
		<cfif arguments.fromAlias EQ "">
			<cfset arguments.fromAlias=arguments.fromAddress>
		</cfif>
		
		
		<cftry>
			<cfmail to="#arguments.recipient#"  bcc="#arguments.bccRecipient#" cc="#arguments.ccRecipient#" subject="#arguments.subject#" from="#arguments.fromAlias# <#arguments.fromAddress#>" type="#arguments.type#"> <!--- ADDED type="#arguments.type#": J. Oriente, 2009-08-13. Enable option to send as HTML --->
				#arguments.body#
			</cfmail>
			
			<cfset returnVal=1>
			
			<cfcatch>
			</cfcatch>
		</cftry>
		
		<cfreturn returnVal>
		
	</cffunction>
	
</cfcomponent>