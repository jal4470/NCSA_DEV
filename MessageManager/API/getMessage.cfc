<!--- 
MODIFICATIONS
- removed topic_choice_id_str from GetDraftMessages, GetScheduledMessages, GetSentMessages and GetMessageDetail
J.Lechuga 3-14-2011 Added Functions to GetMessageDetail to retrieve recipient metrics.
--->

<cfcomponent>
	<cffunction name="GetDraftMessages" access="public" returntype="query">
	<cfargument name="contactid" type="numeric" required="Yes">
		<cfset var GetDraftMessages = "">
		  <cfquery name="GetDraftMessages" datasource="#application.dsn#">
		    select message_id,
		           message_desc,
		           from_email_address,
		           from_email_alias,
		           replyto_email_address,
		           replyto_email_alias,
		           subject,
		           cc_emails,
		           bcc_emails,
		           cast(html_copy as varchar(max)) html_copy,
			       cast(text_copy as varchar(max)) text_copy,
		           sent_date,
		           confirmed_date,
		           track_opens_flag,
		           datecreated,
		           dateupdated,
		           status_id,
				   transmission_status,
				   Distribution_List,
				   owner
		      from v_message
		     where sent_date IS NULL
		       and status_id = 1
			   and created_via_message_manager_flag=1
			   and contactid = #arguments.contactid#
			 Group by 
				   message_id,
		           message_desc,
		           from_email_address,
		           from_email_alias,
		           replyto_email_address,
		           replyto_email_alias,
		           subject,
		           cc_emails,
		           bcc_emails,
		           cast(html_copy as varchar(max)),
			       cast(text_copy as varchar(max)),
		           sent_date,
		           confirmed_date,
		           track_opens_flag,
		           datecreated,
		           dateupdated,
		           status_id,
				   transmission_status,
				   Distribution_List,
				   owner
		  order by DATECREATED DESC
		  </cfquery>
		<cfreturn GetDraftMessages>
	</cffunction>
	
	<cffunction name="GetScheduledMessages" access="public" returntype="query">
		<cfargument name="contactid" type="numeric" required="Yes">
		<cfset var GetScheduledMessages = "">
		  <cfquery name="GetScheduledMessages" datasource="#application.dsn#">
		    select message_id,
		           message_desc,
		           from_email_address,
		           from_email_alias,
		           replyto_email_address,
		           replyto_email_alias,
		           subject,
		           cc_emails,
		           bcc_emails,
		           cast(html_copy as varchar(max)) html_copy,
			       cast(text_copy as varchar(max)) text_copy,
		           scheduled_date,
		           sent_date,
		           confirmed_date,
		           track_opens_flag,
		           datecreated,
		           dateupdated,
		           status_id,
				   dbo.getMessageTransmissionStatus(MESSAGE_ID) AS TRANSMISSION_STATUS,
				   Distribution_List,
				   owner
		      from v_message
		     where sent_date IS NULL
		       and scheduled_date IS NOT NULL
		       and status_id = 1
			   and created_via_message_manager_flag=1
			   and contactid = #arguments.contactid#
			 group by message_id,
		           message_desc,
		           from_email_address,
		           from_email_alias,
		           replyto_email_address,
		           replyto_email_alias,
		           subject,
		           cc_emails,
		           bcc_emails,
		           cast(html_copy as varchar(max)),
			       cast(text_copy as varchar(max)),
		           scheduled_date,
		           sent_date,
		           confirmed_date,
		           track_opens_flag,
		           datecreated,
		           dateupdated,
		           status_id,
				   Distribution_List,
				   owner
		  order by DATECREATED DESC
		  </cfquery>
		<cfreturn GetScheduledMessages>
	</cffunction>
	
	<cffunction name="GetSentMessages" access="public" returntype="query">
		<cfargument name="clubid" type="numeric" required="Yes">
		<cfset var GetSentMessages = "">
		  <cfquery name="GetSentMessages" datasource="#application.dsn#">
		    select message_id,
		           message_desc,
		           from_email_address,
		           from_email_alias,
		           replyto_email_address,
		           replyto_email_alias,
		           subject,
		           cc_emails,
		           bcc_emails,
		           cast(html_copy as varchar(max)) html_copy,
				   cast(text_copy as varchar(max)) text_copy,
		           sent_date,
		           confirmed_date,
		           track_opens_flag,
		           datecreated,
		           dateupdated,
		           status_id,
				   dbo.getMessageTransmissionStatus(MESSAGE_ID) AS TRANSMISSION_STATUS,
				   transmission_status_id,
				   Distribution_List,
				   owner
		      from v_message
		     where sent_date IS NOT NULL
		       and status_id = 1
			   and created_via_message_manager_flag=1
			   and clubid = #arguments.clubid#
			 group by message_id,
		           message_desc,
		           from_email_address,
		           from_email_alias,
		           replyto_email_address,
		           replyto_email_alias,
		           subject,
		           cc_emails,
		           bcc_emails,
				   cast(html_copy as varchar(max)),
				   cast(text_copy as varchar(max)),
		           sent_date,
		           confirmed_date,
		           track_opens_flag,
		           datecreated,
		           dateupdated,
		           status_id,
				   transmission_status_id,
				   Distribution_List,
				   owner
		  order by sent_date desc
		  </cfquery>
		<cfreturn GetSentMessages>
	</cffunction>
	
	<cffunction name="GetMessageDetail" access="public" returntype="query">
		<cfargument name="message_id" type="string" required="true">
		<cfset var GetMessageDetail = "">
		  <cfquery name="GetMessageDetail" datasource="#application.dsn#">
		    select message_id,
		           message_desc,
		           from_email_address,
		           from_email_alias,
		           replyto_email_address,
		           replyto_email_alias,
		           subject,
		           cc_emails,
		           bcc_emails,
		           cast(html_copy as varchar(max)) html_copy,
				   cast(text_copy as varchar(max)) text_copy,
		           sent_date,
		           confirmed_date,
		           track_opens_flag,
		           datecreated,
		           dateupdated,
		           status_id,
				   transmission_status,
                   dbo.getMessageRecipientCnt(MESSAGE_ID) AS RECIPIENT_CNT,
                   dbo.getMessageBouncedCnt(MESSAGE_ID) AS BOUNCED_CNT,
				   dbo.getMessageDeliveredCnt(MESSAGE_ID) AS DELIVERED_CNT,
				   dbo.getMessageOpenedCnt(MESSAGE_ID) AS OPENED_CNT,
				   dbo.getMessageTransmissionStatus(MESSAGE_ID) AS MSG_TRANSMISSION_STATUS_DESC,
				   DATECREATED,
				   DATEUPDATED,
				   STATUS_ID as MSG_TRANSMISSION_STATUS_ID,
				   Distribution_List,
				   owner
		      from v_message
		     where message_id = #message_id#
			 group by message_id,
		           message_desc,
		           from_email_address,
		           from_email_alias,
		           replyto_email_address,
		           replyto_email_alias,
		           subject,
		           cc_emails,
		           bcc_emails,
		           cast(html_copy as varchar(max)),
				   cast(text_copy as varchar(max)),
		           sent_date,
		           confirmed_date,
		           track_opens_flag,
		           datecreated,
		           dateupdated,
		           status_id,
				   transmission_status,
				   DATECREATED,
				   DATEUPDATED,
				   STATUS_ID,
				   Distribution_List,
				   owner
		  </cfquery>
		<cfreturn GetMessageDetail>
	</cffunction>
	
	<cffunction name="GetPerFields" access="public" returntype="query">
		<cfargument name="message_id" type="string" required="true">
		<cfset var GetPerFields = "">
		  <cfquery name="GetPerFields" datasource="#application.dsn#">
		    select MESSAGE_PER_FIELDS_ID,
       			   DISPLAY_NAME,
       			   REFERENCE_TABLE,
       			   FIELD_NAME,
       			   CODE,
       			   DATECREATED,
       			   DATEUPDATED,
       			   STATUS_ID
		      from V_MESSAGE_PER_FIELDS
		     where status_id = 1
		  order by display_name
		  </cfquery>
		<cfreturn GetPerFields>
	</cffunction>
</cfcomponent>
